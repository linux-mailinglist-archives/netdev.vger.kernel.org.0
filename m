Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A2D344BC4
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCVQiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:38:21 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:40420 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhCVQhz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:37:55 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F40Xr5Fx9z9txkW;
        Mon, 22 Mar 2021 17:37:48 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id zWvLbAnzNoRO; Mon, 22 Mar 2021 17:37:48 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F40Xr4CyTz9txkT;
        Mon, 22 Mar 2021 17:37:48 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 47B1F8B7A3;
        Mon, 22 Mar 2021 17:37:54 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id V1A9prPKdHQN; Mon, 22 Mar 2021 17:37:54 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E5C4A8B79C;
        Mon, 22 Mar 2021 17:37:53 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id C8C3D675F4; Mon, 22 Mar 2021 16:37:53 +0000 (UTC)
Message-Id: <b94562d7d2bb21aec89de0c40bb3cd91054b65a2.1616430991.git.christophe.leroy@csgroup.eu>
In-Reply-To: <cover.1616430991.git.christophe.leroy@csgroup.eu>
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v2 8/8] powerpc/bpf: Reallocate BPF registers to volatile
 registers when possible on PPC32
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Mon, 22 Mar 2021 16:37:53 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the BPF routine doesn't call any function, the non volatile
registers can be reallocated to volatile registers in order to
avoid having to save them/restore on the stack.

Before this patch, the test #359 ADD default X is:

   0:	7c 64 1b 78 	mr      r4,r3
   4:	38 60 00 00 	li      r3,0
   8:	94 21 ff b0 	stwu    r1,-80(r1)
   c:	60 00 00 00 	nop
  10:	92 e1 00 2c 	stw     r23,44(r1)
  14:	93 01 00 30 	stw     r24,48(r1)
  18:	93 21 00 34 	stw     r25,52(r1)
  1c:	93 41 00 38 	stw     r26,56(r1)
  20:	39 80 00 00 	li      r12,0
  24:	39 60 00 00 	li      r11,0
  28:	3b 40 00 00 	li      r26,0
  2c:	3b 20 00 00 	li      r25,0
  30:	7c 98 23 78 	mr      r24,r4
  34:	7c 77 1b 78 	mr      r23,r3
  38:	39 80 00 42 	li      r12,66
  3c:	39 60 00 00 	li      r11,0
  40:	7d 8c d2 14 	add     r12,r12,r26
  44:	39 60 00 00 	li      r11,0
  48:	7d 83 63 78 	mr      r3,r12
  4c:	82 e1 00 2c 	lwz     r23,44(r1)
  50:	83 01 00 30 	lwz     r24,48(r1)
  54:	83 21 00 34 	lwz     r25,52(r1)
  58:	83 41 00 38 	lwz     r26,56(r1)
  5c:	38 21 00 50 	addi    r1,r1,80
  60:	4e 80 00 20 	blr

After this patch, the same test has become:

   0:	7c 64 1b 78 	mr      r4,r3
   4:	38 60 00 00 	li      r3,0
   8:	94 21 ff b0 	stwu    r1,-80(r1)
   c:	60 00 00 00 	nop
  10:	39 80 00 00 	li      r12,0
  14:	39 60 00 00 	li      r11,0
  18:	39 00 00 00 	li      r8,0
  1c:	38 e0 00 00 	li      r7,0
  20:	7c 86 23 78 	mr      r6,r4
  24:	7c 65 1b 78 	mr      r5,r3
  28:	39 80 00 42 	li      r12,66
  2c:	39 60 00 00 	li      r11,0
  30:	7d 8c 42 14 	add     r12,r12,r8
  34:	39 60 00 00 	li      r11,0
  38:	7d 83 63 78 	mr      r3,r12
  3c:	38 21 00 50 	addi    r1,r1,80
  40:	4e 80 00 20 	blr

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/net/bpf_jit.h        | 16 ++++++++++++++++
 arch/powerpc/net/bpf_jit64.h      |  2 +-
 arch/powerpc/net/bpf_jit_comp.c   |  2 ++
 arch/powerpc/net/bpf_jit_comp32.c | 30 ++++++++++++++++++++++++++++--
 arch/powerpc/net/bpf_jit_comp64.c |  4 ++++
 5 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index a45b8266355d..776abef4d2a0 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -116,6 +116,15 @@ static inline bool is_nearbranch(int offset)
 #define SEEN_STACK	0x40000000 /* uses BPF stack */
 #define SEEN_TAILCALL	0x80000000 /* uses tail calls */
 
+#define SEEN_VREG_MASK	0x1ff80000 /* Volatile registers r3-r12 */
+#define SEEN_NVREG_MASK	0x0003ffff /* Non volatile registers r14-r31 */
+
+#ifdef CONFIG_PPC64
+extern const int b2p[MAX_BPF_JIT_REG + 2];
+#else
+extern const int b2p[MAX_BPF_JIT_REG + 1];
+#endif
+
 struct codegen_context {
 	/*
 	 * This is used to track register usage as well
@@ -129,6 +138,7 @@ struct codegen_context {
 	unsigned int seen;
 	unsigned int idx;
 	unsigned int stack_size;
+	int b2p[ARRAY_SIZE(b2p)];
 };
 
 static inline void bpf_flush_icache(void *start, void *end)
@@ -147,11 +157,17 @@ static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
 	ctx->seen |= 1 << (31 - i);
 }
 
+static inline void bpf_clear_seen_register(struct codegen_context *ctx, int i)
+{
+	ctx->seen &= ~(1 << (31 - i));
+}
+
 void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 func);
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
 		       u32 *addrs, bool extra_pass);
 void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
+void bpf_jit_realloc_regs(struct codegen_context *ctx);
 
 #endif
 
diff --git a/arch/powerpc/net/bpf_jit64.h b/arch/powerpc/net/bpf_jit64.h
index b05f2e67bba1..7b713edfa7e2 100644
--- a/arch/powerpc/net/bpf_jit64.h
+++ b/arch/powerpc/net/bpf_jit64.h
@@ -39,7 +39,7 @@
 #define TMP_REG_2	(MAX_BPF_JIT_REG + 1)
 
 /* BPF to ppc register mappings */
-static const int b2p[] = {
+const int b2p[MAX_BPF_JIT_REG + 2] = {
 	/* function return value */
 	[BPF_REG_0] = 8,
 	/* function arguments */
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index efac89964873..798ac4350a82 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -143,6 +143,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	}
 
 	memset(&cgctx, 0, sizeof(struct codegen_context));
+	memcpy(cgctx.b2p, b2p, sizeof(cgctx.b2p));
 
 	/* Make sure that the stack is quadword aligned. */
 	cgctx.stack_size = round_up(fp->aux->stack_depth, 16);
@@ -167,6 +168,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		}
 	}
 
+	bpf_jit_realloc_regs(&cgctx);
 	/*
 	 * Pretend to build prologue, given the features we've seen.  This will
 	 * update ctgtx.idx as it pretends to output instructions, then we can
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 29ce802d7534..003843273b43 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -37,7 +37,7 @@
 #define TMP_REG	(MAX_BPF_JIT_REG + 0)
 
 /* BPF to ppc register mappings */
-static const int b2p[] = {
+const int b2p[MAX_BPF_JIT_REG + 1] = {
 	/* function return value */
 	[BPF_REG_0] = 12,
 	/* function arguments */
@@ -60,7 +60,7 @@ static const int b2p[] = {
 
 static int bpf_to_ppc(struct codegen_context *ctx, int reg)
 {
-	return b2p[reg];
+	return ctx->b2p[reg];
 }
 
 /* PPC NVR range -- update this if we ever use NVRs below r17 */
@@ -77,6 +77,32 @@ static int bpf_jit_stack_offsetof(struct codegen_context *ctx, int reg)
 	return BPF_PPC_STACKFRAME(ctx) - 4;
 }
 
+void bpf_jit_realloc_regs(struct codegen_context *ctx)
+{
+	if (ctx->seen & SEEN_FUNC)
+		return;
+
+	while (ctx->seen & SEEN_NVREG_MASK &&
+	      (ctx->seen & SEEN_VREG_MASK) != SEEN_VREG_MASK) {
+		int old = 32 - fls(ctx->seen & (SEEN_NVREG_MASK & 0xaaaaaaab));
+		int new = 32 - fls(~ctx->seen & (SEEN_VREG_MASK & 0xaaaaaaaa));
+		int i;
+
+		for (i = BPF_REG_0; i <= TMP_REG; i++) {
+			if (ctx->b2p[i] != old)
+				continue;
+			ctx->b2p[i] = new;
+			bpf_set_seen_register(ctx, new);
+			bpf_clear_seen_register(ctx, old);
+			if (i != TMP_REG) {
+				bpf_set_seen_register(ctx, new - 1);
+				bpf_clear_seen_register(ctx, old - 1);
+			}
+			break;
+		}
+	}
+}
+
 void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 {
 	int i;
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 8a1f9fb00e78..57a8c1153851 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -64,6 +64,10 @@ static int bpf_jit_stack_offsetof(struct codegen_context *ctx, int reg)
 	BUG();
 }
 
+void bpf_jit_realloc_regs(struct codegen_context *ctx)
+{
+}
+
 void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 {
 	int i;
-- 
2.25.0

