Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CD234E27C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhC3Hnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:43:42 -0400
Received: from foss.arm.com ([217.140.110.172]:51152 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231596AbhC3Hmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 03:42:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CADEED1;
        Tue, 30 Mar 2021 00:42:46 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.208.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 322403F719;
        Tue, 30 Mar 2021 00:42:40 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     zlim.lnx@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jianlin.Lv@arm.com,
        iecedge@gmail.com
Subject: [PATCH bpf-next] bpf: arm64: Redefine MOV consistent with arch insn
Date:   Tue, 30 Mar 2021 15:42:35 +0800
Message-Id: <20210330074235.525747-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A64_MOV is currently mapped to Add Instruction. Architecturally MOV
(register) is an alias of ORR (shifted register) and MOV (to or from SP)
is an alias of ADD (immediate).
This patch redefines A64_MOV and uses existing functionality
aarch64_insn_gen_move_reg() in insn.c to encode MOV (register) instruction.
For moving between register and stack pointer, rename macro to A64_MOV_SP.

Test:
	modprobe test_bpf test_name="SPILL_FILL"
	bpf_jit_disasm -o

without patch:
   0:   stp     x29, x30, [sp, #-16]!
        fd 7b bf a9
   4:   mov     x29, sp
        fd 03 00 91
	...
  14:   mov     x25, sp
        f9 03 00 91
	...
  24:   add     x19, x0, #0x0
        13 00 00 91
	...
  8c:   add     x0, x7, #0x0
        e0 00 00 91

with patch:
   0:   stp     x29, x30, [sp, #-16]!
        fd 7b bf a9
   4:   mov     x29, sp
        fd 03 00 91
	...
  14:   mov     x25, sp
        f9 03 00 91
	...
  24:   mov     x19, x0
        f3 03 00 aa
	...
  8c:   mov     x0, x7
        e0 03 07 aa

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 arch/arm64/net/bpf_jit.h      | 7 +++++--
 arch/arm64/net/bpf_jit_comp.c | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index cc0cf0f5c7c3..a2c3cddb1d2f 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -108,8 +108,8 @@
 #define A64_CMN_I(sf, Rn, imm12) A64_ADDS_I(sf, A64_ZR, Rn, imm12)
 /* Rn - imm12; set condition flags */
 #define A64_CMP_I(sf, Rn, imm12) A64_SUBS_I(sf, A64_ZR, Rn, imm12)
-/* Rd = Rn */
-#define A64_MOV(sf, Rd, Rn) A64_ADD_I(sf, Rd, Rn, 0)
+/* Rd = Rn; MOV (to/from SP) */
+#define A64_MOV_SP(sf, Rd, Rn) A64_ADD_I(sf, Rd, Rn, 0)
 
 /* Bitfield move */
 #define A64_BITFIELD(sf, Rd, Rn, immr, imms, type) \
@@ -134,6 +134,9 @@
 #define A64_UXTH(sf, Rd, Rn) A64_UBFM(sf, Rd, Rn, 0, 15)
 #define A64_UXTW(sf, Rd, Rn) A64_UBFM(sf, Rd, Rn, 0, 31)
 
+/* Rd = Rm; MOV (register) */
+#define A64_MOV(sf, Rd, Rm) aarch64_insn_gen_move_reg(Rd, Rm, A64_VARIANT(sf))
+
 /* Move wide (immediate) */
 #define A64_MOVEW(sf, Rd, imm16, shift, type) \
 	aarch64_insn_gen_movewide(Rd, imm16, shift, \
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index f7b194878a99..2a118c0fcb30 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -229,7 +229,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 
 	/* Save FP and LR registers to stay align with ARM64 AAPCS */
 	emit(A64_PUSH(A64_FP, A64_LR, A64_SP), ctx);
-	emit(A64_MOV(1, A64_FP, A64_SP), ctx);
+	emit(A64_MOV_SP(1, A64_FP, A64_SP), ctx);
 
 	/* Save callee-saved registers */
 	emit(A64_PUSH(r6, r7, A64_SP), ctx);
@@ -237,7 +237,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 	emit(A64_PUSH(fp, tcc, A64_SP), ctx);
 
 	/* Set up BPF prog stack base register */
-	emit(A64_MOV(1, fp, A64_SP), ctx);
+	emit(A64_MOV_SP(1, fp, A64_SP), ctx);
 
 	if (!ebpf_from_cbpf) {
 		/* Initialize tail_call_cnt */
-- 
2.25.1

