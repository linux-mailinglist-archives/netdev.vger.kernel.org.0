Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF6814ADFD
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 03:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgA1CPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 21:15:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36107 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbgA1CPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 21:15:00 -0500
Received: by mail-pf1-f196.google.com with SMTP id 185so2049050pfv.3
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 18:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to:in-reply-to:references;
        bh=jKrDfwDIxQNTXTrn+zwyb0TImugf3AGUmYGjhKrNRfc=;
        b=u2lemWY+5dfIGEONMq7ElLsRYfcjPfM+zVFSnbwB2QUxDirC5Ap3qf9dj8uY7gGPbZ
         yQVfbIClno3WHSVLbboD/umGxT1Ondur2zKycypuNc+lrqUPBsPQMWIpTjgeysbFRtlQ
         aSeIMQCFc40GVw3J0rKBtHGMzTlyettIs1Wemi/9I5zpqjaMvhYMIhRycrye8tndglh5
         O/b8yN9w4dCj+vHx7TY9dGzq5qZAcOvKsILaVWe9KhRk6UHTzxR1XzcWZrLl888sYPgc
         qcbNy9Ynlefqre+vOJfZ44swu4fU2PSPraRNDMXkxJpUjS4Bqg12fMB7xKL38m9bNTut
         WqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to:in-reply-to:references;
        bh=jKrDfwDIxQNTXTrn+zwyb0TImugf3AGUmYGjhKrNRfc=;
        b=J24YBDKsKB92SjvY9FO298enDtq2/o2i9Je6nyp1kBJUToDo2EfiA5en7xU06DZVx1
         SWOUM8aWNRElqtlFsFD++pv9PZlJ8o/xKdlW84oHRKoyogidSEdhqT/ugPn7tpYsrDJu
         LUEnoz7x5X2S4qdsPh90HgDQ8i1RQG3Yh1K09yWA02sGSbvsK2EVq99lPxdQEeEBFC+F
         zkWfKYpaGQAgvzQgOehMRWQuDgsNb6ONEfnMkTwUe9up3ov4RW9xAf7KEKKdRXkENL3I
         jtKK0EC9z7QngAF7HJLgAc2HrhmCePtbOwuAERmvwY1vPPjs2O32mMXXuGFZgvtDXIWl
         ZroA==
X-Gm-Message-State: APjAAAVyBVC/zjECN375XLl2G1ZIqB2ta1T+pKlC+sZedHMnzYqfL+LV
        VwSotF6M7Z/k33MyZO04yy68EA==
X-Google-Smtp-Source: APXvYqyi/cnBTa1Klz/nM2JzLVC6bUlEiBW6MlgldDlvQ56qM/OW7gQzYxWPZZDg1UQWEFYCSCX5rw==
X-Received: by 2002:a63:6d8d:: with SMTP id i135mr22565833pgc.90.1580177699348;
        Mon, 27 Jan 2020 18:14:59 -0800 (PST)
Received: from localhost ([216.9.110.7])
        by smtp.gmail.com with ESMTPSA id k1sm10222394pfg.66.2020.01.27.18.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 18:14:58 -0800 (PST)
Subject: [PATCH 3/4] arm64: bpf: Split the read and write halves of dst
Date:   Mon, 27 Jan 2020 18:11:44 -0800
Message-Id: <20200128021145.36774-4-palmerdabbelt@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     daniel@iogearbox.net, ast@kernel.org, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        shuah@kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-team@android.com
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Bjorn Topel <bjorn.topel@gmail.com>
In-Reply-To: <20200128021145.36774-1-palmerdabbelt@google.com>
References: <20200128021145.36774-1-palmerdabbelt@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is intended to change no functionality, it just allows me to do
register renaming later.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/arm64/net/bpf_jit_comp.c | 107 +++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 8eee68705056..fba5b1b00cd7 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -348,7 +348,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		      bool extra_pass)
 {
 	const u8 code = insn->code;
-	const u8 dst = bpf2a64(ctx, insn->dst_reg);
+	const u8 dstw = bpf2a64(ctx, insn->dst_reg);
+	const u8 dstr = bpf2a64(ctx, insn->dst_reg);
 	const u8 src = bpf2a64(ctx, insn->src_reg);
 	const u8 tmp = bpf2a64(ctx, TMP_REG_1);
 	const u8 tmp2 = bpf2a64(ctx, TMP_REG_2);
@@ -377,32 +378,32 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	/* dst = src */
 	case BPF_ALU | BPF_MOV | BPF_X:
 	case BPF_ALU64 | BPF_MOV | BPF_X:
-		emit(A64_MOV(is64, dst, src), ctx);
+		emit(A64_MOV(is64, dstw, src), ctx);
 		break;
 	/* dst = dst OP src */
 	case BPF_ALU | BPF_ADD | BPF_X:
 	case BPF_ALU64 | BPF_ADD | BPF_X:
-		emit(A64_ADD(is64, dst, dst, src), ctx);
+		emit(A64_ADD(is64, dstw, dstr, src), ctx);
 		break;
 	case BPF_ALU | BPF_SUB | BPF_X:
 	case BPF_ALU64 | BPF_SUB | BPF_X:
-		emit(A64_SUB(is64, dst, dst, src), ctx);
+		emit(A64_SUB(is64, dstw, dstr, src), ctx);
 		break;
 	case BPF_ALU | BPF_AND | BPF_X:
 	case BPF_ALU64 | BPF_AND | BPF_X:
-		emit(A64_AND(is64, dst, dst, src), ctx);
+		emit(A64_AND(is64, dstw, dstr, src), ctx);
 		break;
 	case BPF_ALU | BPF_OR | BPF_X:
 	case BPF_ALU64 | BPF_OR | BPF_X:
-		emit(A64_ORR(is64, dst, dst, src), ctx);
+		emit(A64_ORR(is64, dstw, dstr, src), ctx);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_X:
 	case BPF_ALU64 | BPF_XOR | BPF_X:
-		emit(A64_EOR(is64, dst, dst, src), ctx);
+		emit(A64_EOR(is64, dstw, dstr, src), ctx);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_X:
 	case BPF_ALU64 | BPF_MUL | BPF_X:
-		emit(A64_MUL(is64, dst, dst, src), ctx);
+		emit(A64_MUL(is64, dstw, dstr, src), ctx);
 		break;
 	case BPF_ALU | BPF_DIV | BPF_X:
 	case BPF_ALU64 | BPF_DIV | BPF_X:
@@ -410,30 +411,30 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU64 | BPF_MOD | BPF_X:
 		switch (BPF_OP(code)) {
 		case BPF_DIV:
-			emit(A64_UDIV(is64, dst, dst, src), ctx);
+			emit(A64_UDIV(is64, dstw, dstr, src), ctx);
 			break;
 		case BPF_MOD:
-			emit(A64_UDIV(is64, tmp, dst, src), ctx);
-			emit(A64_MSUB(is64, dst, dst, tmp, src), ctx);
+			emit(A64_UDIV(is64, tmp, dstr, src), ctx);
+			emit(A64_MSUB(is64, dstw, dstr, tmp, src), ctx);
 			break;
 		}
 		break;
 	case BPF_ALU | BPF_LSH | BPF_X:
 	case BPF_ALU64 | BPF_LSH | BPF_X:
-		emit(A64_LSLV(is64, dst, dst, src), ctx);
+		emit(A64_LSLV(is64, dstw, dstr, src), ctx);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_X:
 	case BPF_ALU64 | BPF_RSH | BPF_X:
-		emit(A64_LSRV(is64, dst, dst, src), ctx);
+		emit(A64_LSRV(is64, dstw, dstr, src), ctx);
 		break;
 	case BPF_ALU | BPF_ARSH | BPF_X:
 	case BPF_ALU64 | BPF_ARSH | BPF_X:
-		emit(A64_ASRV(is64, dst, dst, src), ctx);
+		emit(A64_ASRV(is64, dstw, dstr, src), ctx);
 		break;
 	/* dst = -dst */
 	case BPF_ALU | BPF_NEG:
 	case BPF_ALU64 | BPF_NEG:
-		emit(A64_NEG(is64, dst, dst), ctx);
+		emit(A64_NEG(is64, dstw, dstr), ctx);
 		break;
 	/* dst = BSWAP##imm(dst) */
 	case BPF_ALU | BPF_END | BPF_FROM_LE:
@@ -447,16 +448,16 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 #endif
 		switch (imm) {
 		case 16:
-			emit(A64_REV16(is64, dst, dst), ctx);
+			emit(A64_REV16(is64, dstw, dstr), ctx);
 			/* zero-extend 16 bits into 64 bits */
-			emit(A64_UXTH(is64, dst, dst), ctx);
+			emit(A64_UXTH(is64, dstw, dstr), ctx);
 			break;
 		case 32:
-			emit(A64_REV32(is64, dst, dst), ctx);
+			emit(A64_REV32(is64, dstw, dstr), ctx);
 			/* upper 32 bits already cleared */
 			break;
 		case 64:
-			emit(A64_REV64(dst, dst), ctx);
+			emit(A64_REV64(dstw, dstr), ctx);
 			break;
 		}
 		break;
@@ -464,11 +465,11 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		switch (imm) {
 		case 16:
 			/* zero-extend 16 bits into 64 bits */
-			emit(A64_UXTH(is64, dst, dst), ctx);
+			emit(A64_UXTH(is64, dstw, dstr), ctx);
 			break;
 		case 32:
 			/* zero-extend 32 bits into 64 bits */
-			emit(A64_UXTW(is64, dst, dst), ctx);
+			emit(A64_UXTW(is64, dstw, dstr), ctx);
 			break;
 		case 64:
 			/* nop */
@@ -478,61 +479,61 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	/* dst = imm */
 	case BPF_ALU | BPF_MOV | BPF_K:
 	case BPF_ALU64 | BPF_MOV | BPF_K:
-		emit_a64_mov_i(is64, dst, imm, ctx);
+		emit_a64_mov_i(is64, dstw, imm, ctx);
 		break;
 	/* dst = dst OP imm */
 	case BPF_ALU | BPF_ADD | BPF_K:
 	case BPF_ALU64 | BPF_ADD | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_ADD(is64, dst, dst, tmp), ctx);
+		emit(A64_ADD(is64, dstw, dstr, tmp), ctx);
 		break;
 	case BPF_ALU | BPF_SUB | BPF_K:
 	case BPF_ALU64 | BPF_SUB | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_SUB(is64, dst, dst, tmp), ctx);
+		emit(A64_SUB(is64, dstw, dstr, tmp), ctx);
 		break;
 	case BPF_ALU | BPF_AND | BPF_K:
 	case BPF_ALU64 | BPF_AND | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_AND(is64, dst, dst, tmp), ctx);
+		emit(A64_AND(is64, dstw, dstr, tmp), ctx);
 		break;
 	case BPF_ALU | BPF_OR | BPF_K:
 	case BPF_ALU64 | BPF_OR | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_ORR(is64, dst, dst, tmp), ctx);
+		emit(A64_ORR(is64, dstw, dstr, tmp), ctx);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_K:
 	case BPF_ALU64 | BPF_XOR | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_EOR(is64, dst, dst, tmp), ctx);
+		emit(A64_EOR(is64, dstw, dstr, tmp), ctx);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_K:
 	case BPF_ALU64 | BPF_MUL | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_MUL(is64, dst, dst, tmp), ctx);
+		emit(A64_MUL(is64, dstw, dstr, tmp), ctx);
 		break;
 	case BPF_ALU | BPF_DIV | BPF_K:
 	case BPF_ALU64 | BPF_DIV | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_UDIV(is64, dst, dst, tmp), ctx);
+		emit(A64_UDIV(is64, dstw, dstr, tmp), ctx);
 		break;
 	case BPF_ALU | BPF_MOD | BPF_K:
 	case BPF_ALU64 | BPF_MOD | BPF_K:
 		emit_a64_mov_i(is64, tmp2, imm, ctx);
-		emit(A64_UDIV(is64, tmp, dst, tmp2), ctx);
-		emit(A64_MSUB(is64, dst, dst, tmp, tmp2), ctx);
+		emit(A64_UDIV(is64, tmp, dstr, tmp2), ctx);
+		emit(A64_MSUB(is64, dstw, dstr, tmp, tmp2), ctx);
 		break;
 	case BPF_ALU | BPF_LSH | BPF_K:
 	case BPF_ALU64 | BPF_LSH | BPF_K:
-		emit(A64_LSL(is64, dst, dst, imm), ctx);
+		emit(A64_LSL(is64, dstw, dstr, imm), ctx);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_K:
 	case BPF_ALU64 | BPF_RSH | BPF_K:
-		emit(A64_LSR(is64, dst, dst, imm), ctx);
+		emit(A64_LSR(is64, dstw, dstr, imm), ctx);
 		break;
 	case BPF_ALU | BPF_ARSH | BPF_K:
 	case BPF_ALU64 | BPF_ARSH | BPF_K:
-		emit(A64_ASR(is64, dst, dst, imm), ctx);
+		emit(A64_ASR(is64, dstw, dstr, imm), ctx);
 		break;
 
 	/* JUMP off */
@@ -562,7 +563,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP32 | BPF_JSLT | BPF_X:
 	case BPF_JMP32 | BPF_JSGE | BPF_X:
 	case BPF_JMP32 | BPF_JSLE | BPF_X:
-		emit(A64_CMP(is64, dst, src), ctx);
+		emit(A64_CMP(is64, dstr, src), ctx);
 emit_cond_jmp:
 		jmp_offset = bpf2a64_offset(i + off, i, ctx);
 		check_imm19(jmp_offset);
@@ -605,7 +606,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		break;
 	case BPF_JMP | BPF_JSET | BPF_X:
 	case BPF_JMP32 | BPF_JSET | BPF_X:
-		emit(A64_TST(is64, dst, src), ctx);
+		emit(A64_TST(is64, dstr, src), ctx);
 		goto emit_cond_jmp;
 	/* IF (dst COND imm) JUMP off */
 	case BPF_JMP | BPF_JEQ | BPF_K:
@@ -629,12 +630,12 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP32 | BPF_JSGE | BPF_K:
 	case BPF_JMP32 | BPF_JSLE | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_CMP(is64, dst, tmp), ctx);
+		emit(A64_CMP(is64, dstr, tmp), ctx);
 		goto emit_cond_jmp;
 	case BPF_JMP | BPF_JSET | BPF_K:
 	case BPF_JMP32 | BPF_JSET | BPF_K:
 		emit_a64_mov_i(is64, tmp, imm, ctx);
-		emit(A64_TST(is64, dst, tmp), ctx);
+		emit(A64_TST(is64, dstr, tmp), ctx);
 		goto emit_cond_jmp;
 	/* function call */
 	case BPF_JMP | BPF_CALL:
@@ -676,7 +677,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		u64 imm64;
 
 		imm64 = (u64)insn1.imm << 32 | (u32)imm;
-		emit_a64_mov_i64(dst, imm64, ctx);
+		emit_a64_mov_i64(dstw, imm64, ctx);
 
 		return 1;
 	}
@@ -689,16 +690,16 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		emit_a64_mov_i(1, tmp, off, ctx);
 		switch (BPF_SIZE(code)) {
 		case BPF_W:
-			emit(A64_LDR32(dst, src, tmp), ctx);
+			emit(A64_LDR32(dstw, src, tmp), ctx);
 			break;
 		case BPF_H:
-			emit(A64_LDRH(dst, src, tmp), ctx);
+			emit(A64_LDRH(dstw, src, tmp), ctx);
 			break;
 		case BPF_B:
-			emit(A64_LDRB(dst, src, tmp), ctx);
+			emit(A64_LDRB(dstw, src, tmp), ctx);
 			break;
 		case BPF_DW:
-			emit(A64_LDR64(dst, src, tmp), ctx);
+			emit(A64_LDR64(dstw, src, tmp), ctx);
 			break;
 		}
 		break;
@@ -713,16 +714,16 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		emit_a64_mov_i(1, tmp, imm, ctx);
 		switch (BPF_SIZE(code)) {
 		case BPF_W:
-			emit(A64_STR32(tmp, dst, tmp2), ctx);
+			emit(A64_STR32(tmp, dstr, tmp2), ctx);
 			break;
 		case BPF_H:
-			emit(A64_STRH(tmp, dst, tmp2), ctx);
+			emit(A64_STRH(tmp, dstr, tmp2), ctx);
 			break;
 		case BPF_B:
-			emit(A64_STRB(tmp, dst, tmp2), ctx);
+			emit(A64_STRB(tmp, dstr, tmp2), ctx);
 			break;
 		case BPF_DW:
-			emit(A64_STR64(tmp, dst, tmp2), ctx);
+			emit(A64_STR64(tmp, dstr, tmp2), ctx);
 			break;
 		}
 		break;
@@ -735,16 +736,16 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		emit_a64_mov_i(1, tmp, off, ctx);
 		switch (BPF_SIZE(code)) {
 		case BPF_W:
-			emit(A64_STR32(src, dst, tmp), ctx);
+			emit(A64_STR32(src, dstr, tmp), ctx);
 			break;
 		case BPF_H:
-			emit(A64_STRH(src, dst, tmp), ctx);
+			emit(A64_STRH(src, dstr, tmp), ctx);
 			break;
 		case BPF_B:
-			emit(A64_STRB(src, dst, tmp), ctx);
+			emit(A64_STRB(src, dstr, tmp), ctx);
 			break;
 		case BPF_DW:
-			emit(A64_STR64(src, dst, tmp), ctx);
+			emit(A64_STR64(src, dstr, tmp), ctx);
 			break;
 		}
 		break;
@@ -754,10 +755,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	/* STX XADD: lock *(u64 *)(dst + off) += src */
 	case BPF_STX | BPF_XADD | BPF_DW:
 		if (!off) {
-			reg = dst;
+			reg = dstr;
 		} else {
 			emit_a64_mov_i(1, tmp, off, ctx);
-			emit(A64_ADD(1, tmp, tmp, dst), ctx);
+			emit(A64_ADD(1, tmp, tmp, dstr), ctx);
 			reg = tmp;
 		}
 		if (cpus_have_cap(ARM64_HAS_LSE_ATOMICS)) {
-- 
2.25.0.341.g760bfbb309-goog

