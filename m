Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE8221DFE0
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgGMShm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgGMSha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:37:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F151DC08C5DD
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 11:37:29 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q17so5876452pls.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 11:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=05GTUKxISSPCflYrWMkNERCLsbPNwySCKdDwTsPQbQE=;
        b=F3V2SH1CcmajH85a12KW2s+lHzG52mAuH3DfWM+jPhn66cjSYOPOF69WGaitlgmFzu
         1oiKFpW8ozKKYDCeh0N0cuZSzDAs7HoZhIMqYBKOsESYTKvsSlu0LoM0Gex5Nt0/M1zC
         jVOyRGb2kbPZO2fm76Y7niIx1sSmSsz72dblg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=05GTUKxISSPCflYrWMkNERCLsbPNwySCKdDwTsPQbQE=;
        b=eJ5lZQO0KPN/s4KU2KRi8Fmovd9C7FuLPDS0nL2DSA6rtb7ze/Mlyoujz/szG0gj4B
         DFclhHV07CwTFYdE9/7DNo1hT8R8j25n86D7Ymsnly9apxNMhDqom5dGMb/i8bhG7+qD
         3vW7ftFVjGEs6dXSG/E5i3jLvbxZ4LKRapPFAOHLrIlDA5R2TCZIIIly6fzJaRHyUsq6
         +gjQEgkrJB3kgEdorgesp/CpcnlvWJmGYgLUjzmIgp2aZST4pg5/0qGnjHJo7eALUc7s
         JbIFZAbBpPzwac/6R/DyyWvMFRd81xBTp3y8k55+PUUGfCWeZkeVRcoDLvksQ6xBpXBu
         9ZDQ==
X-Gm-Message-State: AOAM53159XCIkqLdDorVPT84gfGY7o6IMGd1Jkv7XCvDvjIQtZt3sUt4
        tltz1QKlAYvIXE4wZmTPFJgvig==
X-Google-Smtp-Source: ABdhPJy5Fk9yKtVyPWpdslEMtRlE/xL6mM7wDkpVQ/sAIE5SydcPAO/WMkc65tzLMGvr+kQVmkN99g==
X-Received: by 2002:a17:902:be17:: with SMTP id r23mr797612pls.284.1594665449223;
        Mon, 13 Jul 2020 11:37:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id ia13sm264985pjb.42.2020.07.13.11.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 11:37:28 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH bpf-next 3/3] bpf, riscv: Use compressed instructions in the rv64 JIT
Date:   Mon, 13 Jul 2020 11:37:11 -0700
Message-Id: <20200713183711.762244-4-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713183711.762244-1-luke.r.nels@gmail.com>
References: <20200713183711.762244-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch uses the RVC support and encodings from bpf_jit.h to optimize
the rv64 jit.

The optimizations work by replacing emit(rv_X(...)) with a call to a
helper function emit_X, which will emit a compressed version of the
instruction when possible, and when RVC is enabled.

The JIT continues to pass all tests in lib/test_bpf.c, and introduces
no new failures to test_verifier; both with and without RVC being enabled.

The following are examples of the JITed code for the verifier selftest
"direct packet read test#3 for CGROUP_SKB OK", without and with RVC
enabled, respectively. The former uses 178 bytes, and the latter uses 112,
for a ~37% reduction in code size for this example.

Without RVC:

   0: 02000813    addi  a6,zero,32
   4: fd010113    addi  sp,sp,-48
   8: 02813423    sd    s0,40(sp)
   c: 02913023    sd    s1,32(sp)
  10: 01213c23    sd    s2,24(sp)
  14: 01313823    sd    s3,16(sp)
  18: 01413423    sd    s4,8(sp)
  1c: 03010413    addi  s0,sp,48
  20: 03056683    lwu   a3,48(a0)
  24: 02069693    slli  a3,a3,0x20
  28: 0206d693    srli  a3,a3,0x20
  2c: 03456703    lwu   a4,52(a0)
  30: 02071713    slli  a4,a4,0x20
  34: 02075713    srli  a4,a4,0x20
  38: 03856483    lwu   s1,56(a0)
  3c: 02049493    slli  s1,s1,0x20
  40: 0204d493    srli  s1,s1,0x20
  44: 03c56903    lwu   s2,60(a0)
  48: 02091913    slli  s2,s2,0x20
  4c: 02095913    srli  s2,s2,0x20
  50: 04056983    lwu   s3,64(a0)
  54: 02099993    slli  s3,s3,0x20
  58: 0209d993    srli  s3,s3,0x20
  5c: 09056a03    lwu   s4,144(a0)
  60: 020a1a13    slli  s4,s4,0x20
  64: 020a5a13    srli  s4,s4,0x20
  68: 00900313    addi  t1,zero,9
  6c: 006a7463    bgeu  s4,t1,0x74
  70: 00000a13    addi  s4,zero,0
  74: 02d52823    sw    a3,48(a0)
  78: 02e52a23    sw    a4,52(a0)
  7c: 02952c23    sw    s1,56(a0)
  80: 03252e23    sw    s2,60(a0)
  84: 05352023    sw    s3,64(a0)
  88: 00000793    addi  a5,zero,0
  8c: 02813403    ld    s0,40(sp)
  90: 02013483    ld    s1,32(sp)
  94: 01813903    ld    s2,24(sp)
  98: 01013983    ld    s3,16(sp)
  9c: 00813a03    ld    s4,8(sp)
  a0: 03010113    addi  sp,sp,48
  a4: 00078513    addi  a0,a5,0
  a8: 00008067    jalr  zero,0(ra)

With RVC:

   0:   02000813    addi    a6,zero,32
   4:   7179        c.addi16sp  sp,-48
   6:   f422        c.sdsp  s0,40(sp)
   8:   f026        c.sdsp  s1,32(sp)
   a:   ec4a        c.sdsp  s2,24(sp)
   c:   e84e        c.sdsp  s3,16(sp)
   e:   e452        c.sdsp  s4,8(sp)
  10:   1800        c.addi4spn  s0,sp,48
  12:   03056683    lwu     a3,48(a0)
  16:   1682        c.slli  a3,0x20
  18:   9281        c.srli  a3,0x20
  1a:   03456703    lwu     a4,52(a0)
  1e:   1702        c.slli  a4,0x20
  20:   9301        c.srli  a4,0x20
  22:   03856483    lwu     s1,56(a0)
  26:   1482        c.slli  s1,0x20
  28:   9081        c.srli  s1,0x20
  2a:   03c56903    lwu     s2,60(a0)
  2e:   1902        c.slli  s2,0x20
  30:   02095913    srli    s2,s2,0x20
  34:   04056983    lwu     s3,64(a0)
  38:   1982        c.slli  s3,0x20
  3a:   0209d993    srli    s3,s3,0x20
  3e:   09056a03    lwu     s4,144(a0)
  42:   1a02        c.slli  s4,0x20
  44:   020a5a13    srli    s4,s4,0x20
  48:   4325        c.li    t1,9
  4a:   006a7363    bgeu    s4,t1,0x50
  4e:   4a01        c.li    s4,0
  50:   d914        c.sw    a3,48(a0)
  52:   d958        c.sw    a4,52(a0)
  54:   dd04        c.sw    s1,56(a0)
  56:   03252e23    sw      s2,60(a0)
  5a:   05352023    sw      s3,64(a0)
  5e:   4781        c.li    a5,0
  60:   7422        c.ldsp  s0,40(sp)
  62:   7482        c.ldsp  s1,32(sp)
  64:   6962        c.ldsp  s2,24(sp)
  66:   69c2        c.ldsp  s3,16(sp)
  68:   6a22        c.ldsp  s4,8(sp)
  6a:   6145        c.addi16sp  sp,48
  6c:   853e        c.mv    a0,a5
  6e:   8082        c.jr    ra

Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit_comp64.c | 275 +++++++++++++++++---------------
 1 file changed, 142 insertions(+), 133 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 26feed92f1bc..823fe800f406 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -137,14 +137,14 @@ static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 
 	if (is_32b_int(val)) {
 		if (upper)
-			emit(rv_lui(rd, upper), ctx);
+			emit_lui(rd, upper, ctx);
 
 		if (!upper) {
-			emit(rv_addi(rd, RV_REG_ZERO, lower), ctx);
+			emit_li(rd, lower, ctx);
 			return;
 		}
 
-		emit(rv_addiw(rd, rd, lower), ctx);
+		emit_addiw(rd, rd, lower, ctx);
 		return;
 	}
 
@@ -154,9 +154,9 @@ static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 
 	emit_imm(rd, upper, ctx);
 
-	emit(rv_slli(rd, rd, shift), ctx);
+	emit_slli(rd, rd, shift, ctx);
 	if (lower)
-		emit(rv_addi(rd, rd, lower), ctx);
+		emit_addi(rd, rd, lower, ctx);
 }
 
 static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
@@ -164,43 +164,43 @@ static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 	int stack_adjust = ctx->stack_size, store_offset = stack_adjust - 8;
 
 	if (seen_reg(RV_REG_RA, ctx)) {
-		emit(rv_ld(RV_REG_RA, store_offset, RV_REG_SP), ctx);
+		emit_ld(RV_REG_RA, store_offset, RV_REG_SP, ctx);
 		store_offset -= 8;
 	}
-	emit(rv_ld(RV_REG_FP, store_offset, RV_REG_SP), ctx);
+	emit_ld(RV_REG_FP, store_offset, RV_REG_SP, ctx);
 	store_offset -= 8;
 	if (seen_reg(RV_REG_S1, ctx)) {
-		emit(rv_ld(RV_REG_S1, store_offset, RV_REG_SP), ctx);
+		emit_ld(RV_REG_S1, store_offset, RV_REG_SP, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S2, ctx)) {
-		emit(rv_ld(RV_REG_S2, store_offset, RV_REG_SP), ctx);
+		emit_ld(RV_REG_S2, store_offset, RV_REG_SP, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S3, ctx)) {
-		emit(rv_ld(RV_REG_S3, store_offset, RV_REG_SP), ctx);
+		emit_ld(RV_REG_S3, store_offset, RV_REG_SP, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S4, ctx)) {
-		emit(rv_ld(RV_REG_S4, store_offset, RV_REG_SP), ctx);
+		emit_ld(RV_REG_S4, store_offset, RV_REG_SP, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S5, ctx)) {
-		emit(rv_ld(RV_REG_S5, store_offset, RV_REG_SP), ctx);
+		emit_ld(RV_REG_S5, store_offset, RV_REG_SP, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S6, ctx)) {
-		emit(rv_ld(RV_REG_S6, store_offset, RV_REG_SP), ctx);
+		emit_ld(RV_REG_S6, store_offset, RV_REG_SP, ctx);
 		store_offset -= 8;
 	}
 
-	emit(rv_addi(RV_REG_SP, RV_REG_SP, stack_adjust), ctx);
+	emit_addi(RV_REG_SP, RV_REG_SP, stack_adjust, ctx);
 	/* Set return value. */
 	if (!is_tail_call)
-		emit(rv_addi(RV_REG_A0, RV_REG_A5, 0), ctx);
-	emit(rv_jalr(RV_REG_ZERO, is_tail_call ? RV_REG_T3 : RV_REG_RA,
-		     is_tail_call ? 4 : 0), /* skip TCC init */
-	     ctx);
+		emit_mv(RV_REG_A0, RV_REG_A5, ctx);
+	emit_jalr(RV_REG_ZERO, is_tail_call ? RV_REG_T3 : RV_REG_RA,
+		  is_tail_call ? 4 : 0, /* skip TCC init */
+		  ctx);
 }
 
 static void emit_bcc(u8 cond, u8 rd, u8 rs, int rvoff,
@@ -280,8 +280,8 @@ static void emit_branch(u8 cond, u8 rd, u8 rs, int rvoff,
 
 static void emit_zext_32(u8 reg, struct rv_jit_context *ctx)
 {
-	emit(rv_slli(reg, reg, 32), ctx);
-	emit(rv_srli(reg, reg, 32), ctx);
+	emit_slli(reg, reg, 32, ctx);
+	emit_srli(reg, reg, 32, ctx);
 }
 
 static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
@@ -310,7 +310,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	/* if (TCC-- < 0)
 	 *     goto out;
 	 */
-	emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
+	emit_addi(RV_REG_T1, tcc, -1, ctx);
 	off = RVOFF(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
 
@@ -318,12 +318,12 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	 * if (!prog)
 	 *     goto out;
 	 */
-	emit(rv_slli(RV_REG_T2, RV_REG_A2, 3), ctx);
-	emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_A1), ctx);
+	emit_slli(RV_REG_T2, RV_REG_A2, 3, ctx);
+	emit_add(RV_REG_T2, RV_REG_T2, RV_REG_A1, ctx);
 	off = offsetof(struct bpf_array, ptrs);
 	if (is_12b_check(off, insn))
 		return -1;
-	emit(rv_ld(RV_REG_T2, off, RV_REG_T2), ctx);
+	emit_ld(RV_REG_T2, off, RV_REG_T2, ctx);
 	off = RVOFF(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_branch(BPF_JEQ, RV_REG_T2, RV_REG_ZERO, off, ctx);
 
@@ -331,8 +331,8 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	off = offsetof(struct bpf_prog, bpf_func);
 	if (is_12b_check(off, insn))
 		return -1;
-	emit(rv_ld(RV_REG_T3, off, RV_REG_T2), ctx);
-	emit(rv_addi(RV_REG_TCC, RV_REG_T1, 0), ctx);
+	emit_ld(RV_REG_T3, off, RV_REG_T2, ctx);
+	emit_mv(RV_REG_TCC, RV_REG_T1, ctx);
 	__build_epilogue(true, ctx);
 	return 0;
 }
@@ -360,9 +360,9 @@ static void init_regs(u8 *rd, u8 *rs, const struct bpf_insn *insn,
 
 static void emit_zext_32_rd_rs(u8 *rd, u8 *rs, struct rv_jit_context *ctx)
 {
-	emit(rv_addi(RV_REG_T2, *rd, 0), ctx);
+	emit_mv(RV_REG_T2, *rd, ctx);
 	emit_zext_32(RV_REG_T2, ctx);
-	emit(rv_addi(RV_REG_T1, *rs, 0), ctx);
+	emit_mv(RV_REG_T1, *rs, ctx);
 	emit_zext_32(RV_REG_T1, ctx);
 	*rd = RV_REG_T2;
 	*rs = RV_REG_T1;
@@ -370,15 +370,15 @@ static void emit_zext_32_rd_rs(u8 *rd, u8 *rs, struct rv_jit_context *ctx)
 
 static void emit_sext_32_rd_rs(u8 *rd, u8 *rs, struct rv_jit_context *ctx)
 {
-	emit(rv_addiw(RV_REG_T2, *rd, 0), ctx);
-	emit(rv_addiw(RV_REG_T1, *rs, 0), ctx);
+	emit_addiw(RV_REG_T2, *rd, 0, ctx);
+	emit_addiw(RV_REG_T1, *rs, 0, ctx);
 	*rd = RV_REG_T2;
 	*rs = RV_REG_T1;
 }
 
 static void emit_zext_32_rd_t1(u8 *rd, struct rv_jit_context *ctx)
 {
-	emit(rv_addi(RV_REG_T2, *rd, 0), ctx);
+	emit_mv(RV_REG_T2, *rd, ctx);
 	emit_zext_32(RV_REG_T2, ctx);
 	emit_zext_32(RV_REG_T1, ctx);
 	*rd = RV_REG_T2;
@@ -386,7 +386,7 @@ static void emit_zext_32_rd_t1(u8 *rd, struct rv_jit_context *ctx)
 
 static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
 {
-	emit(rv_addiw(RV_REG_T2, *rd, 0), ctx);
+	emit_addiw(RV_REG_T2, *rd, 0, ctx);
 	*rd = RV_REG_T2;
 }
 
@@ -432,7 +432,7 @@ static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
 	if (ret)
 		return ret;
 	rd = bpf_to_rv_reg(BPF_REG_0, ctx);
-	emit(rv_addi(rd, RV_REG_A0, 0), ctx);
+	emit_mv(rd, RV_REG_A0, ctx);
 	return 0;
 }
 
@@ -458,7 +458,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_zext_32(rd, ctx);
 			break;
 		}
-		emit(is64 ? rv_addi(rd, rs, 0) : rv_addiw(rd, rs, 0), ctx);
+		emit_mv(rd, rs, ctx);
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
@@ -466,31 +466,35 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* dst = dst OP src */
 	case BPF_ALU | BPF_ADD | BPF_X:
 	case BPF_ALU64 | BPF_ADD | BPF_X:
-		emit(is64 ? rv_add(rd, rd, rs) : rv_addw(rd, rd, rs), ctx);
+		emit_add(rd, rd, rs, ctx);
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_SUB | BPF_X:
 	case BPF_ALU64 | BPF_SUB | BPF_X:
-		emit(is64 ? rv_sub(rd, rd, rs) : rv_subw(rd, rd, rs), ctx);
+		if (is64)
+			emit_sub(rd, rd, rs, ctx);
+		else
+			emit_subw(rd, rd, rs, ctx);
+
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_AND | BPF_X:
 	case BPF_ALU64 | BPF_AND | BPF_X:
-		emit(rv_and(rd, rd, rs), ctx);
+		emit_and(rd, rd, rs, ctx);
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_OR | BPF_X:
 	case BPF_ALU64 | BPF_OR | BPF_X:
-		emit(rv_or(rd, rd, rs), ctx);
+		emit_or(rd, rd, rs, ctx);
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_X:
 	case BPF_ALU64 | BPF_XOR | BPF_X:
-		emit(rv_xor(rd, rd, rs), ctx);
+		emit_xor(rd, rd, rs, ctx);
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
@@ -534,8 +538,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* dst = -dst */
 	case BPF_ALU | BPF_NEG:
 	case BPF_ALU64 | BPF_NEG:
-		emit(is64 ? rv_sub(rd, RV_REG_ZERO, rd) :
-		     rv_subw(rd, RV_REG_ZERO, rd), ctx);
+		emit_sub(rd, RV_REG_ZERO, rd, ctx);
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
@@ -544,8 +547,8 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_END | BPF_FROM_LE:
 		switch (imm) {
 		case 16:
-			emit(rv_slli(rd, rd, 48), ctx);
-			emit(rv_srli(rd, rd, 48), ctx);
+			emit_slli(rd, rd, 48, ctx);
+			emit_srli(rd, rd, 48, ctx);
 			break;
 		case 32:
 			if (!aux->verifier_zext)
@@ -558,51 +561,51 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		break;
 
 	case BPF_ALU | BPF_END | BPF_FROM_BE:
-		emit(rv_addi(RV_REG_T2, RV_REG_ZERO, 0), ctx);
+		emit_li(RV_REG_T2, 0, ctx);
 
-		emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
-		emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
-		emit(rv_srli(rd, rd, 8), ctx);
+		emit_andi(RV_REG_T1, rd, 0xff, ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
+		emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
+		emit_srli(rd, rd, 8, ctx);
 		if (imm == 16)
 			goto out_be;
 
-		emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
-		emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
-		emit(rv_srli(rd, rd, 8), ctx);
+		emit_andi(RV_REG_T1, rd, 0xff, ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
+		emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
+		emit_srli(rd, rd, 8, ctx);
 
-		emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
-		emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
-		emit(rv_srli(rd, rd, 8), ctx);
+		emit_andi(RV_REG_T1, rd, 0xff, ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
+		emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
+		emit_srli(rd, rd, 8, ctx);
 		if (imm == 32)
 			goto out_be;
 
-		emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
-		emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
-		emit(rv_srli(rd, rd, 8), ctx);
-
-		emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
-		emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
-		emit(rv_srli(rd, rd, 8), ctx);
-
-		emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
-		emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
-		emit(rv_srli(rd, rd, 8), ctx);
-
-		emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
-		emit(rv_slli(RV_REG_T2, RV_REG_T2, 8), ctx);
-		emit(rv_srli(rd, rd, 8), ctx);
+		emit_andi(RV_REG_T1, rd, 0xff, ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
+		emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
+		emit_srli(rd, rd, 8, ctx);
+
+		emit_andi(RV_REG_T1, rd, 0xff, ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
+		emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
+		emit_srli(rd, rd, 8, ctx);
+
+		emit_andi(RV_REG_T1, rd, 0xff, ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
+		emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
+		emit_srli(rd, rd, 8, ctx);
+
+		emit_andi(RV_REG_T1, rd, 0xff, ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
+		emit_slli(RV_REG_T2, RV_REG_T2, 8, ctx);
+		emit_srli(rd, rd, 8, ctx);
 out_be:
-		emit(rv_andi(RV_REG_T1, rd, 0xff), ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, RV_REG_T1), ctx);
+		emit_andi(RV_REG_T1, rd, 0xff, ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, RV_REG_T1, ctx);
 
-		emit(rv_addi(rd, RV_REG_T2, 0), ctx);
+		emit_mv(rd, RV_REG_T2, ctx);
 		break;
 
 	/* dst = imm */
@@ -617,12 +620,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_ADD | BPF_K:
 	case BPF_ALU64 | BPF_ADD | BPF_K:
 		if (is_12b_int(imm)) {
-			emit(is64 ? rv_addi(rd, rd, imm) :
-			     rv_addiw(rd, rd, imm), ctx);
+			emit_addi(rd, rd, imm, ctx);
 		} else {
 			emit_imm(RV_REG_T1, imm, ctx);
-			emit(is64 ? rv_add(rd, rd, RV_REG_T1) :
-			     rv_addw(rd, rd, RV_REG_T1), ctx);
+			emit_add(rd, rd, RV_REG_T1, ctx);
 		}
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
@@ -630,12 +631,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_SUB | BPF_K:
 	case BPF_ALU64 | BPF_SUB | BPF_K:
 		if (is_12b_int(-imm)) {
-			emit(is64 ? rv_addi(rd, rd, -imm) :
-			     rv_addiw(rd, rd, -imm), ctx);
+			emit_addi(rd, rd, -imm, ctx);
 		} else {
 			emit_imm(RV_REG_T1, imm, ctx);
-			emit(is64 ? rv_sub(rd, rd, RV_REG_T1) :
-			     rv_subw(rd, rd, RV_REG_T1), ctx);
+			emit_sub(rd, rd, RV_REG_T1, ctx);
 		}
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
@@ -643,10 +642,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_AND | BPF_K:
 	case BPF_ALU64 | BPF_AND | BPF_K:
 		if (is_12b_int(imm)) {
-			emit(rv_andi(rd, rd, imm), ctx);
+			emit_andi(rd, rd, imm, ctx);
 		} else {
 			emit_imm(RV_REG_T1, imm, ctx);
-			emit(rv_and(rd, rd, RV_REG_T1), ctx);
+			emit_and(rd, rd, RV_REG_T1, ctx);
 		}
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
@@ -657,7 +656,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit(rv_ori(rd, rd, imm), ctx);
 		} else {
 			emit_imm(RV_REG_T1, imm, ctx);
-			emit(rv_or(rd, rd, RV_REG_T1), ctx);
+			emit_or(rd, rd, RV_REG_T1, ctx);
 		}
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
@@ -668,7 +667,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit(rv_xori(rd, rd, imm), ctx);
 		} else {
 			emit_imm(RV_REG_T1, imm, ctx);
-			emit(rv_xor(rd, rd, RV_REG_T1), ctx);
+			emit_xor(rd, rd, RV_REG_T1, ctx);
 		}
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
@@ -699,19 +698,28 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		break;
 	case BPF_ALU | BPF_LSH | BPF_K:
 	case BPF_ALU64 | BPF_LSH | BPF_K:
-		emit(is64 ? rv_slli(rd, rd, imm) : rv_slliw(rd, rd, imm), ctx);
+		emit_slli(rd, rd, imm, ctx);
+
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_K:
 	case BPF_ALU64 | BPF_RSH | BPF_K:
-		emit(is64 ? rv_srli(rd, rd, imm) : rv_srliw(rd, rd, imm), ctx);
+		if (is64)
+			emit_srli(rd, rd, imm, ctx);
+		else
+			emit(rv_srliw(rd, rd, imm), ctx);
+
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_ARSH | BPF_K:
 	case BPF_ALU64 | BPF_ARSH | BPF_K:
-		emit(is64 ? rv_srai(rd, rd, imm) : rv_sraiw(rd, rd, imm), ctx);
+		if (is64)
+			emit_srai(rd, rd, imm, ctx);
+		else
+			emit(rv_sraiw(rd, rd, imm), ctx);
+
 		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
@@ -763,7 +771,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		if (BPF_OP(code) == BPF_JSET) {
 			/* Adjust for and */
 			rvoff -= 4;
-			emit(rv_and(RV_REG_T1, rd, rs), ctx);
+			emit_and(RV_REG_T1, rd, rs, ctx);
 			emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff,
 				    ctx);
 		} else {
@@ -819,17 +827,17 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		rvoff = rv_offset(i, off, ctx);
 		s = ctx->ninsns;
 		if (is_12b_int(imm)) {
-			emit(rv_andi(RV_REG_T1, rd, imm), ctx);
+			emit_andi(RV_REG_T1, rd, imm, ctx);
 		} else {
 			emit_imm(RV_REG_T1, imm, ctx);
-			emit(rv_and(RV_REG_T1, rd, RV_REG_T1), ctx);
+			emit_and(RV_REG_T1, rd, RV_REG_T1, ctx);
 		}
 		/* For jset32, we should clear the upper 32 bits of t1, but
 		 * sign-extension is sufficient here and saves one instruction,
 		 * as t1 is used only in comparison against zero.
 		 */
 		if (!is64 && imm < 0)
-			emit(rv_addiw(RV_REG_T1, RV_REG_T1, 0), ctx);
+			emit_addiw(RV_REG_T1, RV_REG_T1, 0, ctx);
 		e = ctx->ninsns;
 		rvoff -= RVOFF(e - s);
 		emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff, ctx);
@@ -887,7 +895,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		}
 
 		emit_imm(RV_REG_T1, off, ctx);
-		emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
+		emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
 		emit(rv_lbu(rd, 0, RV_REG_T1), ctx);
 		if (insn_is_zext(&insn[1]))
 			return 1;
@@ -899,7 +907,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		}
 
 		emit_imm(RV_REG_T1, off, ctx);
-		emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
+		emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
 		emit(rv_lhu(rd, 0, RV_REG_T1), ctx);
 		if (insn_is_zext(&insn[1]))
 			return 1;
@@ -911,20 +919,20 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		}
 
 		emit_imm(RV_REG_T1, off, ctx);
-		emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
+		emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
 		emit(rv_lwu(rd, 0, RV_REG_T1), ctx);
 		if (insn_is_zext(&insn[1]))
 			return 1;
 		break;
 	case BPF_LDX | BPF_MEM | BPF_DW:
 		if (is_12b_int(off)) {
-			emit(rv_ld(rd, off, rs), ctx);
+			emit_ld(rd, off, rs, ctx);
 			break;
 		}
 
 		emit_imm(RV_REG_T1, off, ctx);
-		emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
-		emit(rv_ld(rd, 0, RV_REG_T1), ctx);
+		emit_add(RV_REG_T1, RV_REG_T1, rs, ctx);
+		emit_ld(rd, 0, RV_REG_T1, ctx);
 		break;
 
 	/* ST: *(size *)(dst + off) = imm */
@@ -936,7 +944,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		}
 
 		emit_imm(RV_REG_T2, off, ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, rd), ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, rd, ctx);
 		emit(rv_sb(RV_REG_T2, 0, RV_REG_T1), ctx);
 		break;
 
@@ -948,30 +956,30 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		}
 
 		emit_imm(RV_REG_T2, off, ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, rd), ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, rd, ctx);
 		emit(rv_sh(RV_REG_T2, 0, RV_REG_T1), ctx);
 		break;
 	case BPF_ST | BPF_MEM | BPF_W:
 		emit_imm(RV_REG_T1, imm, ctx);
 		if (is_12b_int(off)) {
-			emit(rv_sw(rd, off, RV_REG_T1), ctx);
+			emit_sw(rd, off, RV_REG_T1, ctx);
 			break;
 		}
 
 		emit_imm(RV_REG_T2, off, ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, rd), ctx);
-		emit(rv_sw(RV_REG_T2, 0, RV_REG_T1), ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, rd, ctx);
+		emit_sw(RV_REG_T2, 0, RV_REG_T1, ctx);
 		break;
 	case BPF_ST | BPF_MEM | BPF_DW:
 		emit_imm(RV_REG_T1, imm, ctx);
 		if (is_12b_int(off)) {
-			emit(rv_sd(rd, off, RV_REG_T1), ctx);
+			emit_sd(rd, off, RV_REG_T1, ctx);
 			break;
 		}
 
 		emit_imm(RV_REG_T2, off, ctx);
-		emit(rv_add(RV_REG_T2, RV_REG_T2, rd), ctx);
-		emit(rv_sd(RV_REG_T2, 0, RV_REG_T1), ctx);
+		emit_add(RV_REG_T2, RV_REG_T2, rd, ctx);
+		emit_sd(RV_REG_T2, 0, RV_REG_T1, ctx);
 		break;
 
 	/* STX: *(size *)(dst + off) = src */
@@ -982,7 +990,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		}
 
 		emit_imm(RV_REG_T1, off, ctx);
-		emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
+		emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
 		emit(rv_sb(RV_REG_T1, 0, rs), ctx);
 		break;
 	case BPF_STX | BPF_MEM | BPF_H:
@@ -992,28 +1000,28 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		}
 
 		emit_imm(RV_REG_T1, off, ctx);
-		emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
+		emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
 		emit(rv_sh(RV_REG_T1, 0, rs), ctx);
 		break;
 	case BPF_STX | BPF_MEM | BPF_W:
 		if (is_12b_int(off)) {
-			emit(rv_sw(rd, off, rs), ctx);
+			emit_sw(rd, off, rs, ctx);
 			break;
 		}
 
 		emit_imm(RV_REG_T1, off, ctx);
-		emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
-		emit(rv_sw(RV_REG_T1, 0, rs), ctx);
+		emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
+		emit_sw(RV_REG_T1, 0, rs, ctx);
 		break;
 	case BPF_STX | BPF_MEM | BPF_DW:
 		if (is_12b_int(off)) {
-			emit(rv_sd(rd, off, rs), ctx);
+			emit_sd(rd, off, rs, ctx);
 			break;
 		}
 
 		emit_imm(RV_REG_T1, off, ctx);
-		emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
-		emit(rv_sd(RV_REG_T1, 0, rs), ctx);
+		emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
+		emit_sd(RV_REG_T1, 0, rs, ctx);
 		break;
 	/* STX XADD: lock *(u32 *)(dst + off) += src */
 	case BPF_STX | BPF_XADD | BPF_W:
@@ -1021,10 +1029,10 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_STX | BPF_XADD | BPF_DW:
 		if (off) {
 			if (is_12b_int(off)) {
-				emit(rv_addi(RV_REG_T1, rd, off), ctx);
+				emit_addi(RV_REG_T1, rd, off, ctx);
 			} else {
 				emit_imm(RV_REG_T1, off, ctx);
-				emit(rv_add(RV_REG_T1, RV_REG_T1, rd), ctx);
+				emit_add(RV_REG_T1, RV_REG_T1, rd, ctx);
 			}
 
 			rd = RV_REG_T1;
@@ -1073,52 +1081,53 @@ void bpf_jit_build_prologue(struct rv_jit_context *ctx)
 
 	/* First instruction is always setting the tail-call-counter
 	 * (TCC) register. This instruction is skipped for tail calls.
+	 * Force using a 4-byte (non-compressed) instruction.
 	 */
 	emit(rv_addi(RV_REG_TCC, RV_REG_ZERO, MAX_TAIL_CALL_CNT), ctx);
 
-	emit(rv_addi(RV_REG_SP, RV_REG_SP, -stack_adjust), ctx);
+	emit_addi(RV_REG_SP, RV_REG_SP, -stack_adjust, ctx);
 
 	if (seen_reg(RV_REG_RA, ctx)) {
-		emit(rv_sd(RV_REG_SP, store_offset, RV_REG_RA), ctx);
+		emit_sd(RV_REG_SP, store_offset, RV_REG_RA, ctx);
 		store_offset -= 8;
 	}
-	emit(rv_sd(RV_REG_SP, store_offset, RV_REG_FP), ctx);
+	emit_sd(RV_REG_SP, store_offset, RV_REG_FP, ctx);
 	store_offset -= 8;
 	if (seen_reg(RV_REG_S1, ctx)) {
-		emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S1), ctx);
+		emit_sd(RV_REG_SP, store_offset, RV_REG_S1, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S2, ctx)) {
-		emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S2), ctx);
+		emit_sd(RV_REG_SP, store_offset, RV_REG_S2, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S3, ctx)) {
-		emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S3), ctx);
+		emit_sd(RV_REG_SP, store_offset, RV_REG_S3, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S4, ctx)) {
-		emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S4), ctx);
+		emit_sd(RV_REG_SP, store_offset, RV_REG_S4, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S5, ctx)) {
-		emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S5), ctx);
+		emit_sd(RV_REG_SP, store_offset, RV_REG_S5, ctx);
 		store_offset -= 8;
 	}
 	if (seen_reg(RV_REG_S6, ctx)) {
-		emit(rv_sd(RV_REG_SP, store_offset, RV_REG_S6), ctx);
+		emit_sd(RV_REG_SP, store_offset, RV_REG_S6, ctx);
 		store_offset -= 8;
 	}
 
-	emit(rv_addi(RV_REG_FP, RV_REG_SP, stack_adjust), ctx);
+	emit_addi(RV_REG_FP, RV_REG_SP, stack_adjust, ctx);
 
 	if (bpf_stack_adjust)
-		emit(rv_addi(RV_REG_S5, RV_REG_SP, bpf_stack_adjust), ctx);
+		emit_addi(RV_REG_S5, RV_REG_SP, bpf_stack_adjust, ctx);
 
 	/* Program contains calls and tail calls, so RV_REG_TCC need
 	 * to be saved across calls.
 	 */
 	if (seen_tail_call(ctx) && seen_call(ctx))
-		emit(rv_addi(RV_REG_TCC_SAVED, RV_REG_TCC, 0), ctx);
+		emit_mv(RV_REG_TCC_SAVED, RV_REG_TCC, ctx);
 
 	ctx->stack_size = stack_adjust;
 }
-- 
2.25.1

