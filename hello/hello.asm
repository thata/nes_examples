;;; iNESヘッダ情報
  .inesprg 1   ; 1x 16KB PRG
  .ineschr 1   ; 1x  8KB CHR
  .inesmir 1   ; background mirroring
  .inesmap 0   ; mapper 0 = NROM, no bank swapping

;;; 割り込みベクタを初期化
  .bank 1
  .org $FFFA

  .dw 0
  .dw RESET
  .dw 0

;;; プログラム本体
  .bank 0
  .org $8000
RESET:
	sei
; VBlankが発生するのをループしながら待つ
  lda $2002
  bpl RESET

; スクリーンをオフに
	lda	#$00
	sta	$2000
	sta	$2001

; 背景用のパレットを初期化
	lda	#$3f
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#$10
copypal:
	lda	palettes, x
	sta	$2007
	inx
	dey
	bne	copypal

; 画面の左上へメッセージを表示
	lda	#$20
	sta	$2006
	lda	#$00
	sta	$2006
	ldx	#$00
	ldy	#$0d ; 13文字表示
copymap:
	lda	message, x
	sta	$2007
	inx
	dey
	bne	copymap

; スクロールを行わないように設定
	lda	#$00
	sta	$2005
	sta	$2005

; スクリーンをオンに
	lda	#$08
	sta	$2000
	lda	#$1e
	sta	$2001

FOREVER:
  JMP FOREVER ; 無限ループ

; 背景用パレット
palettes:
	.byte	$0f, $0a, $1a, $2a
	.byte	$0f, $04, $14, $24
	.byte	$0f, $01, $11, $21
	.byte	$0f, $00, $10, $20

; 表示するメッセージ
message:
	.byte	"Hello Famicon"


;;; フォントデータを読み込み
;;; NES研究室のサンプルプログラムから持ってきたもの
;;; http://hp.vector.co.jp/authors/VA042397/nes/sample.html
  .bank 2
  .org $0000
  .incbin "character.chr"

