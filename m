Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A5029752
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391239AbfEXLgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:36:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33822 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391207AbfEXLgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:36:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id f8so9686533wrt.1
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t5QoTAKj6gWs22LRKizXuguuwC9VDKWN26JI1/YClLc=;
        b=QaTNBgS146STwpF5bCiJpPyYd4Vk6Jo/N3wMPZD1NjtDW6jhKyiWMmRei+HOb9urrb
         4lnA+NafdkPaB+gLR+bqCNGQExueCX+C6Zs83jgM5z/uiPVjKVCMooQ3VmvJci0ivVEK
         73CGlvbSHUfM73kMbO+IFO3Ged3gB30FmTczlhA0OtVCoBNI8ymp2E+taw0CcuiEOjDH
         aC6HT3mvu7txxWyWN/mCAfo8yvtEnverwhfTJ7IW6V2qgYJwcq0h2+w0lpFz00nYxkHX
         wO7CvmdrDK0YEEMLvLIiT9GwzdVvBqfOt7hTQlVLPZQ5BM/to9PC3p1qt+T00R7dEHSe
         G+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t5QoTAKj6gWs22LRKizXuguuwC9VDKWN26JI1/YClLc=;
        b=ahGtOGeBLs94CwyRsjAqrSE3EUF7ufuiJpIZRzsAFhLuwhRSoyLpqsdzwahq69BCOG
         ixDnkhpetr1facxYHw1LJK4jihrmaQhmF5WMi72eJuS+tAddwTqe7bgCqqTVKPN/mAZX
         gAUkBwluMB2qARH5K5KA3xyLbvpGye7bFT1vFv78v/+ofAfkn451NxE0a8Nm7NzPza7j
         wonfejFP2rEkuV1fcboB9QV8kBUokjFnXnqxrh3ittW9YOFOiHLu5lrUOjMlYaUVT3mK
         TFfjbjDTHnAeIyuhx69/Nt5L7NIZx5/oSOoc2QjfD1RfZSkGPCABKKuAccbyCpCc9rOl
         VS/Q==
X-Gm-Message-State: APjAAAVC2NHfR18CJ5t0Csi6MyH1QBm/yT58luPAYvbosoo6FPaDpQAK
        906ONPVZfHJseez5rOvKdnJdYg==
X-Google-Smtp-Source: APXvYqzRgZz8zfqRpWtVthj6/7Rg88wS7V15hCdCPQrMoggt91D9A2hcacxVaYJsZi4jOe0FZBXfBg==
X-Received: by 2002:a5d:4682:: with SMTP id u2mr52934434wrq.202.1558697763034;
        Fri, 24 May 2019 04:36:03 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x22sm2462902wmi.4.2019.05.24.04.36.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 04:36:02 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v8 bpf-next 14/16] x32: bpf: eliminate zero extension code-gen
Date:   Fri, 24 May 2019 12:35:24 +0100
Message-Id: <1558697726-4058-15-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Wang YanQing <udknight@gmail.com>
Tested-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/x86/net/bpf_jit_comp32.c | 83 +++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 27 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index b29e82f..133433d 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -253,13 +253,14 @@ static inline void emit_ia32_mov_r(const u8 dst, const u8 src, bool dstk,
 /* dst = src */
 static inline void emit_ia32_mov_r64(const bool is64, const u8 dst[],
 				     const u8 src[], bool dstk,
-				     bool sstk, u8 **pprog)
+				     bool sstk, u8 **pprog,
+				     const struct bpf_prog_aux *aux)
 {
 	emit_ia32_mov_r(dst_lo, src_lo, dstk, sstk, pprog);
 	if (is64)
 		/* complete 8 byte move */
 		emit_ia32_mov_r(dst_hi, src_hi, dstk, sstk, pprog);
-	else
+	else if (!aux->verifier_zext)
 		/* zero out high 4 bytes */
 		emit_ia32_mov_i(dst_hi, 0, dstk, pprog);
 }
@@ -313,7 +314,8 @@ static inline void emit_ia32_mul_r(const u8 dst, const u8 src, bool dstk,
 }
 
 static inline void emit_ia32_to_le_r64(const u8 dst[], s32 val,
-					 bool dstk, u8 **pprog)
+					 bool dstk, u8 **pprog,
+					 const struct bpf_prog_aux *aux)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
@@ -334,12 +336,14 @@ static inline void emit_ia32_to_le_r64(const u8 dst[], s32 val,
 		 */
 		EMIT2(0x0F, 0xB7);
 		EMIT1(add_2reg(0xC0, dreg_lo, dreg_lo));
-		/* xor dreg_hi,dreg_hi */
-		EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
+		if (!aux->verifier_zext)
+			/* xor dreg_hi,dreg_hi */
+			EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
 		break;
 	case 32:
-		/* xor dreg_hi,dreg_hi */
-		EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
+		if (!aux->verifier_zext)
+			/* xor dreg_hi,dreg_hi */
+			EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
 		break;
 	case 64:
 		/* nop */
@@ -358,7 +362,8 @@ static inline void emit_ia32_to_le_r64(const u8 dst[], s32 val,
 }
 
 static inline void emit_ia32_to_be_r64(const u8 dst[], s32 val,
-				       bool dstk, u8 **pprog)
+				       bool dstk, u8 **pprog,
+				       const struct bpf_prog_aux *aux)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
@@ -380,16 +385,18 @@ static inline void emit_ia32_to_be_r64(const u8 dst[], s32 val,
 		EMIT2(0x0F, 0xB7);
 		EMIT1(add_2reg(0xC0, dreg_lo, dreg_lo));
 
-		/* xor dreg_hi,dreg_hi */
-		EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
+		if (!aux->verifier_zext)
+			/* xor dreg_hi,dreg_hi */
+			EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
 		break;
 	case 32:
 		/* Emit 'bswap eax' to swap lower 4 bytes */
 		EMIT1(0x0F);
 		EMIT1(add_1reg(0xC8, dreg_lo));
 
-		/* xor dreg_hi,dreg_hi */
-		EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
+		if (!aux->verifier_zext)
+			/* xor dreg_hi,dreg_hi */
+			EMIT2(0x33, add_2reg(0xC0, dreg_hi, dreg_hi));
 		break;
 	case 64:
 		/* Emit 'bswap eax' to swap lower 4 bytes */
@@ -569,7 +576,7 @@ static inline void emit_ia32_alu_r(const bool is64, const bool hi, const u8 op,
 static inline void emit_ia32_alu_r64(const bool is64, const u8 op,
 				     const u8 dst[], const u8 src[],
 				     bool dstk,  bool sstk,
-				     u8 **pprog)
+				     u8 **pprog, const struct bpf_prog_aux *aux)
 {
 	u8 *prog = *pprog;
 
@@ -577,7 +584,7 @@ static inline void emit_ia32_alu_r64(const bool is64, const u8 op,
 	if (is64)
 		emit_ia32_alu_r(is64, true, op, dst_hi, src_hi, dstk, sstk,
 				&prog);
-	else
+	else if (!aux->verifier_zext)
 		emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 	*pprog = prog;
 }
@@ -668,7 +675,8 @@ static inline void emit_ia32_alu_i(const bool is64, const bool hi, const u8 op,
 /* ALU operation (64 bit) */
 static inline void emit_ia32_alu_i64(const bool is64, const u8 op,
 				     const u8 dst[], const u32 val,
-				     bool dstk, u8 **pprog)
+				     bool dstk, u8 **pprog,
+				     const struct bpf_prog_aux *aux)
 {
 	u8 *prog = *pprog;
 	u32 hi = 0;
@@ -679,7 +687,7 @@ static inline void emit_ia32_alu_i64(const bool is64, const u8 op,
 	emit_ia32_alu_i(is64, false, op, dst_lo, val, dstk, &prog);
 	if (is64)
 		emit_ia32_alu_i(is64, true, op, dst_hi, hi, dstk, &prog);
-	else
+	else if (!aux->verifier_zext)
 		emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 
 	*pprog = prog;
@@ -1713,8 +1721,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ALU64 | BPF_MOV | BPF_X:
 			switch (BPF_SRC(code)) {
 			case BPF_X:
-				emit_ia32_mov_r64(is64, dst, src, dstk,
-						  sstk, &prog);
+				if (imm32 == 1) {
+					/* Special mov32 for zext. */
+					emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+					break;
+				}
+				emit_ia32_mov_r64(is64, dst, src, dstk, sstk,
+						  &prog, bpf_prog->aux);
 				break;
 			case BPF_K:
 				/* Sign-extend immediate value to dst reg */
@@ -1754,11 +1767,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			switch (BPF_SRC(code)) {
 			case BPF_X:
 				emit_ia32_alu_r64(is64, BPF_OP(code), dst,
-						  src, dstk, sstk, &prog);
+						  src, dstk, sstk, &prog,
+						  bpf_prog->aux);
 				break;
 			case BPF_K:
 				emit_ia32_alu_i64(is64, BPF_OP(code), dst,
-						  imm32, dstk, &prog);
+						  imm32, dstk, &prog,
+						  bpf_prog->aux);
 				break;
 			}
 			break;
@@ -1777,7 +1792,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						false, &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		case BPF_ALU | BPF_LSH | BPF_X:
 		case BPF_ALU | BPF_RSH | BPF_X:
@@ -1797,7 +1813,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						  &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = dst / src(imm) */
 		/* dst = dst % src(imm) */
@@ -1819,7 +1836,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 						    &prog);
 				break;
 			}
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		case BPF_ALU64 | BPF_DIV | BPF_K:
 		case BPF_ALU64 | BPF_DIV | BPF_X:
@@ -1836,7 +1854,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			EMIT2_off32(0xC7, add_1reg(0xC0, IA32_ECX), imm32);
 			emit_ia32_shift_r(BPF_OP(code), dst_lo, IA32_ECX, dstk,
 					  false, &prog);
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = dst << imm */
 		case BPF_ALU64 | BPF_LSH | BPF_K:
@@ -1872,7 +1891,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 		case BPF_ALU | BPF_NEG:
 			emit_ia32_alu_i(is64, false, BPF_OP(code),
 					dst_lo, 0, dstk, &prog);
-			emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
+			if (!bpf_prog->aux->verifier_zext)
+				emit_ia32_mov_i(dst_hi, 0, dstk, &prog);
 			break;
 		/* dst = ~dst (64 bit) */
 		case BPF_ALU64 | BPF_NEG:
@@ -1892,11 +1912,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			break;
 		/* dst = htole(dst) */
 		case BPF_ALU | BPF_END | BPF_FROM_LE:
-			emit_ia32_to_le_r64(dst, imm32, dstk, &prog);
+			emit_ia32_to_le_r64(dst, imm32, dstk, &prog,
+					    bpf_prog->aux);
 			break;
 		/* dst = htobe(dst) */
 		case BPF_ALU | BPF_END | BPF_FROM_BE:
-			emit_ia32_to_be_r64(dst, imm32, dstk, &prog);
+			emit_ia32_to_be_r64(dst, imm32, dstk, &prog,
+					    bpf_prog->aux);
 			break;
 		/* dst = imm64 */
 		case BPF_LD | BPF_IMM | BPF_DW: {
@@ -2051,6 +2073,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			case BPF_B:
 			case BPF_H:
 			case BPF_W:
+				if (!bpf_prog->aux->verifier_zext)
+					break;
 				if (dstk) {
 					EMIT3(0xC7, add_1reg(0x40, IA32_EBP),
 					      STACK_VAR(dst_hi));
@@ -2475,6 +2499,11 @@ emit_cond_jmp:		jmp_cond = get_cond_jmp_opcode(BPF_OP(code), false);
 	return proglen;
 }
 
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header = NULL;
-- 
2.7.4

