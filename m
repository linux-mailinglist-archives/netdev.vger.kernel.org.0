Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98111BED32
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgD3Avx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726309AbgD3Avw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:51:52 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85464C035495
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:51:52 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w65so2009857pfc.12
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id;
        bh=2VzTJMG6uHW6Q2DV451ZYKmYi8OhZd8DBxFpPNX7pIs=;
        b=dWCH6n/XQPm3+gB7yUXpLsA59ZzW6xb8HTHCoz+hnD5AWL/NrTe2YwF/Rx+k4yZJav
         4rmmLQE1zVAvF7NhwMXcaxhnVPjF7So0Mrc52lz2O6edht1hrmT634+Wz2YOQSkE2QDj
         ih94XlipYqiwDaPL74SgN3ebI+mIKL3nAhY6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2VzTJMG6uHW6Q2DV451ZYKmYi8OhZd8DBxFpPNX7pIs=;
        b=bfr/cHHbzg20eyUryi312+XoOEtUSLrhoAYsrGExjrdx/EJm8V5jx9L2ipPocx5xUL
         l9mJpALeC5R0A5LaHxqAEfTpADbFixe2dmK++SpR1nFaSH5Ttr9/vj1NfBxFe92/U1jL
         qmvtWO7I8ngt4CA3DT8X83tsIyZaVygg7SbidEPwgAx25Mg1IWc0186C4M2qU7bjoL5T
         ttjRvCCaOOzzQ6oht+XFSss5/volHTSwmVolgaMebMxOfaP5bmhXTv1wivz28ZDIn/Te
         utLSvIC9ujHCEAr5xY5mFtQDShrgRffdk3XFuMoaScSPGrj4l3aL7CioePxF6HAtsa8i
         55hQ==
X-Gm-Message-State: AGi0PubgOf64bfEcNcrDKNXftUYCCkGNm5HYzYl1l67deSBBuS2SQuHl
        w1aQfxeWqvx/b3TKmIygHjp19A==
X-Google-Smtp-Source: APiQypJwtanBe4WcqMHj8ktlO0+j3fBIRNqQTX5RTUV32kcelcAl8mCCTgG4qkVceJ9oypk3VSLUyA==
X-Received: by 2002:aa7:948f:: with SMTP id z15mr935807pfk.6.1588207911661;
        Wed, 29 Apr 2020 17:51:51 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id o9sm347905pjp.4.2020.04.29.17.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 17:51:51 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] bpf, riscv: Fix stack layout of JITed code on RV32
Date:   Wed, 29 Apr 2020 17:51:27 -0700
Message-Id: <20200430005127.2205-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes issues with stackframe unwinding and alignment in the
current stack layout for BPF programs on RV32.

In the current layout, RV32 fp points to the JIT scratch registers, rather
than to the callee-saved registers. This breaks stackframe unwinding,
which expects fp to point just above the saved ra and fp registers.

This patch fixes the issue by moving the callee-saved registers to be
stored on the top of the stack, pointed to by fp. This satisfies the
assumptions of stackframe unwinding.

This patch also fixes an issue with the old layout that the stack was
not aligned to 16 bytes.

Stacktrace from JITed code using the old stack layout:

  [   12.196249 ] [<c0402200>] walk_stackframe+0x0/0x96

Stacktrace using the new stack layout:

  [   13.062888 ] [<c0402200>] walk_stackframe+0x0/0x96
  [   13.063028 ] [<c04023c6>] show_stack+0x28/0x32
  [   13.063253 ] [<a403e778>] bpf_prog_82b916b2dfa00464+0x80/0x908
  [   13.063417 ] [<c09270b2>] bpf_test_run+0x124/0x39a
  [   13.063553 ] [<c09276c0>] bpf_prog_test_run_skb+0x234/0x448
  [   13.063704 ] [<c048510e>] __do_sys_bpf+0x766/0x13b4
  [   13.063840 ] [<c0485d82>] sys_bpf+0xc/0x14
  [   13.063961 ] [<c04010f0>] ret_from_syscall+0x0/0x2

The new code is also simpler to understand and includes an ASCII diagram
of the stack layout.

Tested on riscv32 QEMU virt machine.

Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit_comp32.c | 98 ++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 33 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index 11083d4d5f2d..b198eaa74456 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -13,8 +13,35 @@
 #include <linux/filter.h>
 #include "bpf_jit.h"
 
+/*
+ * Stack layout during BPF program execution:
+ *
+ *                     high
+ *     RV32 fp =>  +----------+
+ *                 | saved ra |
+ *                 | saved fp | RV32 callee-saved registers
+ *                 |   ...    |
+ *                 +----------+ <= (fp - 4 * NR_SAVED_REGISTERS)
+ *                 |  hi(R6)  |
+ *                 |  lo(R6)  |
+ *                 |  hi(R7)  | JIT scratch space for BPF registers
+ *                 |  lo(R7)  |
+ *                 |   ...    |
+ *  BPF_REG_FP =>  +----------+ <= (fp - 4 * NR_SAVED_REGISTERS
+ *                 |          |        - 4 * BPF_JIT_SCRATCH_REGS)
+ *                 |          |
+ *                 |   ...    | BPF program stack
+ *                 |          |
+ *     RV32 sp =>  +----------+
+ *                 |          |
+ *                 |   ...    | Function call stack
+ *                 |          |
+ *                 +----------+
+ *                     low
+ */
+
 enum {
-	/* Stack layout - these are offsets from (top of stack - 4). */
+	/* Stack layout - these are offsets from top of JIT scratch space. */
 	BPF_R6_HI,
 	BPF_R6_LO,
 	BPF_R7_HI,
@@ -29,7 +56,11 @@ enum {
 	BPF_JIT_SCRATCH_REGS,
 };
 
-#define STACK_OFFSET(k) (-4 - ((k) * 4))
+/* Number of callee-saved registers stored to stack: ra, fp, s1--s7. */
+#define NR_SAVED_REGISTERS	9
+
+/* Offset from fp for BPF registers stored on stack. */
+#define STACK_OFFSET(k)	(-4 - (4 * NR_SAVED_REGISTERS) - (4 * (k)))
 
 #define TMP_REG_1	(MAX_BPF_JIT_REG + 0)
 #define TMP_REG_2	(MAX_BPF_JIT_REG + 1)
@@ -111,11 +142,9 @@ static void emit_imm64(const s8 *rd, s32 imm_hi, s32 imm_lo,
 
 static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 {
-	int stack_adjust = ctx->stack_size, store_offset = stack_adjust - 4;
+	int stack_adjust = ctx->stack_size;
 	const s8 *r0 = bpf2rv32[BPF_REG_0];
 
-	store_offset -= 4 * BPF_JIT_SCRATCH_REGS;
-
 	/* Set return value if not tail call. */
 	if (!is_tail_call) {
 		emit(rv_addi(RV_REG_A0, lo(r0), 0), ctx);
@@ -123,15 +152,15 @@ static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 	}
 
 	/* Restore callee-saved registers. */
-	emit(rv_lw(RV_REG_RA, store_offset - 0, RV_REG_SP), ctx);
-	emit(rv_lw(RV_REG_FP, store_offset - 4, RV_REG_SP), ctx);
-	emit(rv_lw(RV_REG_S1, store_offset - 8, RV_REG_SP), ctx);
-	emit(rv_lw(RV_REG_S2, store_offset - 12, RV_REG_SP), ctx);
-	emit(rv_lw(RV_REG_S3, store_offset - 16, RV_REG_SP), ctx);
-	emit(rv_lw(RV_REG_S4, store_offset - 20, RV_REG_SP), ctx);
-	emit(rv_lw(RV_REG_S5, store_offset - 24, RV_REG_SP), ctx);
-	emit(rv_lw(RV_REG_S6, store_offset - 28, RV_REG_SP), ctx);
-	emit(rv_lw(RV_REG_S7, store_offset - 32, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_RA, stack_adjust - 4, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_FP, stack_adjust - 8, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S1, stack_adjust - 12, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S2, stack_adjust - 16, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S3, stack_adjust - 20, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S4, stack_adjust - 24, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S5, stack_adjust - 28, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S6, stack_adjust - 32, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S7, stack_adjust - 36, RV_REG_SP), ctx);
 
 	emit(rv_addi(RV_REG_SP, RV_REG_SP, stack_adjust), ctx);
 
@@ -1260,17 +1289,20 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 
 void bpf_jit_build_prologue(struct rv_jit_context *ctx)
 {
-	/* Make space to save 9 registers: ra, fp, s1--s7. */
-	int stack_adjust = 9 * sizeof(u32), store_offset, bpf_stack_adjust;
 	const s8 *fp = bpf2rv32[BPF_REG_FP];
 	const s8 *r1 = bpf2rv32[BPF_REG_1];
-
-	bpf_stack_adjust = round_up(ctx->prog->aux->stack_depth, 16);
+	int stack_adjust = 0;
+	int bpf_stack_adjust =
+		round_up(ctx->prog->aux->stack_depth, STACK_ALIGN);
+
+	/* Make space for callee-saved registers. */
+	stack_adjust += NR_SAVED_REGISTERS * sizeof(u32);
+	/* Make space for BPF registers on stack. */
+	stack_adjust += BPF_JIT_SCRATCH_REGS * sizeof(u32);
+	/* Make space for BPF stack. */
 	stack_adjust += bpf_stack_adjust;
-
-	store_offset = stack_adjust - 4;
-
-	stack_adjust += 4 * BPF_JIT_SCRATCH_REGS;
+	/* Round up for stack alignment. */
+	stack_adjust = round_up(stack_adjust, STACK_ALIGN);
 
 	/*
 	 * The first instruction sets the tail-call-counter (TCC) register.
@@ -1281,24 +1313,24 @@ void bpf_jit_build_prologue(struct rv_jit_context *ctx)
 	emit(rv_addi(RV_REG_SP, RV_REG_SP, -stack_adjust), ctx);
 
 	/* Save callee-save registers. */
-	emit(rv_sw(RV_REG_SP, store_offset - 0, RV_REG_RA), ctx);
-	emit(rv_sw(RV_REG_SP, store_offset - 4, RV_REG_FP), ctx);
-	emit(rv_sw(RV_REG_SP, store_offset - 8, RV_REG_S1), ctx);
-	emit(rv_sw(RV_REG_SP, store_offset - 12, RV_REG_S2), ctx);
-	emit(rv_sw(RV_REG_SP, store_offset - 16, RV_REG_S3), ctx);
-	emit(rv_sw(RV_REG_SP, store_offset - 20, RV_REG_S4), ctx);
-	emit(rv_sw(RV_REG_SP, store_offset - 24, RV_REG_S5), ctx);
-	emit(rv_sw(RV_REG_SP, store_offset - 28, RV_REG_S6), ctx);
-	emit(rv_sw(RV_REG_SP, store_offset - 32, RV_REG_S7), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 4, RV_REG_RA), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 8, RV_REG_FP), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 12, RV_REG_S1), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 16, RV_REG_S2), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 20, RV_REG_S3), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 24, RV_REG_S4), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 28, RV_REG_S5), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 32, RV_REG_S6), ctx);
+	emit(rv_sw(RV_REG_SP, stack_adjust - 36, RV_REG_S7), ctx);
 
 	/* Set fp: used as the base address for stacked BPF registers. */
 	emit(rv_addi(RV_REG_FP, RV_REG_SP, stack_adjust), ctx);
 
-	/* Set up BPF stack pointer. */
+	/* Set up BPF frame pointer. */
 	emit(rv_addi(lo(fp), RV_REG_SP, bpf_stack_adjust), ctx);
 	emit(rv_addi(hi(fp), RV_REG_ZERO, 0), ctx);
 
-	/* Set up context pointer. */
+	/* Set up BPF context pointer. */
 	emit(rv_addi(lo(r1), RV_REG_A0, 0), ctx);
 	emit(rv_addi(hi(r1), RV_REG_ZERO, 0), ctx);
 
-- 
2.17.1

