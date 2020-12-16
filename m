Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69542DBE58
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 11:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLPKJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 05:09:07 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:48575 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgLPKJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 05:09:07 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4CwrQt0BWjz9v1Z2;
        Wed, 16 Dec 2020 11:07:34 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id ISDjDQKzJrKH; Wed, 16 Dec 2020 11:07:33 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4CwrQs6PkCz9tysx;
        Wed, 16 Dec 2020 11:07:33 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DBB698B7BA;
        Wed, 16 Dec 2020 11:07:34 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id TeRI7nqTyIFv; Wed, 16 Dec 2020 11:07:34 +0100 (CET)
Received: from localhost.localdomain (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 511588B7C7;
        Wed, 16 Dec 2020 11:07:34 +0100 (CET)
Received: by localhost.localdomain (Postfix, from userid 0)
        id 26CCA6681D; Wed, 16 Dec 2020 10:07:34 +0000 (UTC)
Message-Id: <899249505f46147dacd44779a9c04f8312c4740e.1608112797.git.christophe.leroy@csgroup.eu>
In-Reply-To: <cover.1608112796.git.christophe.leroy@csgroup.eu>
References: <cover.1608112796.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [RFC PATCH v1 4/7] powerpc/bpf: Move common functions into
 bpf_jit_comp.c
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 16 Dec 2020 10:07:34 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move into bpf_jit_comp.c the functions that will remain common to
PPC64 and PPC32 when we add support of EBPF for PPC32.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/net/Makefile         |   2 +-
 arch/powerpc/net/bpf_jit.h        |   6 +
 arch/powerpc/net/bpf_jit_comp.c   | 269 ++++++++++++++++++++++++++++++
 arch/powerpc/net/bpf_jit_comp64.c | 258 +---------------------------
 4 files changed, 281 insertions(+), 254 deletions(-)
 create mode 100644 arch/powerpc/net/bpf_jit_comp.c

diff --git a/arch/powerpc/net/Makefile b/arch/powerpc/net/Makefile
index 52c939cef5b2..969cde177880 100644
--- a/arch/powerpc/net/Makefile
+++ b/arch/powerpc/net/Makefile
@@ -2,4 +2,4 @@
 #
 # Arch-specific network modules
 #
-obj-$(CONFIG_BPF_JIT) += bpf_jit_comp64.o
+obj-$(CONFIG_BPF_JIT) += bpf_jit_comp.o bpf_jit_comp64.o
diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index b8fa6908fc5e..b34abfce15a6 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -143,6 +143,12 @@ static inline void bpf_set_seen_register(struct codegen_context *ctx, int i)
 	ctx->seen |= 1 << (31 - i);
 }
 
+void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 func);
+int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
+		       u32 *addrs, bool extra_pass);
+void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
+void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
+
 #endif
 
 #endif
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
new file mode 100644
index 000000000000..efac89964873
--- /dev/null
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * eBPF JIT compiler
+ *
+ * Copyright 2016 Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
+ *		  IBM Corporation
+ *
+ * Based on the powerpc classic BPF JIT compiler by Matt Evans
+ */
+#include <linux/moduleloader.h>
+#include <asm/cacheflush.h>
+#include <asm/asm-compat.h>
+#include <linux/netdevice.h>
+#include <linux/filter.h>
+#include <linux/if_vlan.h>
+#include <asm/kprobes.h>
+#include <linux/bpf.h>
+
+#include "bpf_jit.h"
+
+static void bpf_jit_fill_ill_insns(void *area, unsigned int size)
+{
+	memset32(area, BREAKPOINT_INSTRUCTION, size / 4);
+}
+
+/* Fix the branch target addresses for subprog calls */
+static int bpf_jit_fixup_subprog_calls(struct bpf_prog *fp, u32 *image,
+				       struct codegen_context *ctx, u32 *addrs)
+{
+	const struct bpf_insn *insn = fp->insnsi;
+	bool func_addr_fixed;
+	u64 func_addr;
+	u32 tmp_idx;
+	int i, ret;
+
+	for (i = 0; i < fp->len; i++) {
+		/*
+		 * During the extra pass, only the branch target addresses for
+		 * the subprog calls need to be fixed. All other instructions
+		 * can left untouched.
+		 *
+		 * The JITed image length does not change because we already
+		 * ensure that the JITed instruction sequence for these calls
+		 * are of fixed length by padding them with NOPs.
+		 */
+		if (insn[i].code == (BPF_JMP | BPF_CALL) &&
+		    insn[i].src_reg == BPF_PSEUDO_CALL) {
+			ret = bpf_jit_get_func_addr(fp, &insn[i], true,
+						    &func_addr,
+						    &func_addr_fixed);
+			if (ret < 0)
+				return ret;
+
+			/*
+			 * Save ctx->idx as this would currently point to the
+			 * end of the JITed image and set it to the offset of
+			 * the instruction sequence corresponding to the
+			 * subprog call temporarily.
+			 */
+			tmp_idx = ctx->idx;
+			ctx->idx = addrs[i] / 4;
+			bpf_jit_emit_func_call_rel(image, ctx, func_addr);
+
+			/*
+			 * Restore ctx->idx here. This is safe as the length
+			 * of the JITed sequence remains unchanged.
+			 */
+			ctx->idx = tmp_idx;
+		}
+	}
+
+	return 0;
+}
+
+struct powerpc64_jit_data {
+	struct bpf_binary_header *header;
+	u32 *addrs;
+	u8 *image;
+	u32 proglen;
+	struct codegen_context ctx;
+};
+
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
+
+struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
+{
+	u32 proglen;
+	u32 alloclen;
+	u8 *image = NULL;
+	u32 *code_base;
+	u32 *addrs;
+	struct powerpc64_jit_data *jit_data;
+	struct codegen_context cgctx;
+	int pass;
+	int flen;
+	struct bpf_binary_header *bpf_hdr;
+	struct bpf_prog *org_fp = fp;
+	struct bpf_prog *tmp_fp;
+	bool bpf_blinded = false;
+	bool extra_pass = false;
+
+	if (!fp->jit_requested)
+		return org_fp;
+
+	tmp_fp = bpf_jit_blind_constants(org_fp);
+	if (IS_ERR(tmp_fp))
+		return org_fp;
+
+	if (tmp_fp != org_fp) {
+		bpf_blinded = true;
+		fp = tmp_fp;
+	}
+
+	jit_data = fp->aux->jit_data;
+	if (!jit_data) {
+		jit_data = kzalloc(sizeof(*jit_data), GFP_KERNEL);
+		if (!jit_data) {
+			fp = org_fp;
+			goto out;
+		}
+		fp->aux->jit_data = jit_data;
+	}
+
+	flen = fp->len;
+	addrs = jit_data->addrs;
+	if (addrs) {
+		cgctx = jit_data->ctx;
+		image = jit_data->image;
+		bpf_hdr = jit_data->header;
+		proglen = jit_data->proglen;
+		alloclen = proglen + FUNCTION_DESCR_SIZE;
+		extra_pass = true;
+		goto skip_init_ctx;
+	}
+
+	addrs = kcalloc(flen + 1, sizeof(*addrs), GFP_KERNEL);
+	if (addrs == NULL) {
+		fp = org_fp;
+		goto out_addrs;
+	}
+
+	memset(&cgctx, 0, sizeof(struct codegen_context));
+
+	/* Make sure that the stack is quadword aligned. */
+	cgctx.stack_size = round_up(fp->aux->stack_depth, 16);
+
+	/* Scouting faux-generate pass 0 */
+	if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
+		/* We hit something illegal or unsupported. */
+		fp = org_fp;
+		goto out_addrs;
+	}
+
+	/*
+	 * If we have seen a tail call, we need a second pass.
+	 * This is because bpf_jit_emit_common_epilogue() is called
+	 * from bpf_jit_emit_tail_call() with a not yet stable ctx->seen.
+	 */
+	if (cgctx.seen & SEEN_TAILCALL) {
+		cgctx.idx = 0;
+		if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
+			fp = org_fp;
+			goto out_addrs;
+		}
+	}
+
+	/*
+	 * Pretend to build prologue, given the features we've seen.  This will
+	 * update ctgtx.idx as it pretends to output instructions, then we can
+	 * calculate total size from idx.
+	 */
+	bpf_jit_build_prologue(0, &cgctx);
+	bpf_jit_build_epilogue(0, &cgctx);
+
+	proglen = cgctx.idx * 4;
+	alloclen = proglen + FUNCTION_DESCR_SIZE;
+
+	bpf_hdr = bpf_jit_binary_alloc(alloclen, &image, 4, bpf_jit_fill_ill_insns);
+	if (!bpf_hdr) {
+		fp = org_fp;
+		goto out_addrs;
+	}
+
+skip_init_ctx:
+	code_base = (u32 *)(image + FUNCTION_DESCR_SIZE);
+
+	if (extra_pass) {
+		/*
+		 * Do not touch the prologue and epilogue as they will remain
+		 * unchanged. Only fix the branch target address for subprog
+		 * calls in the body.
+		 *
+		 * This does not change the offsets and lengths of the subprog
+		 * call instruction sequences and hence, the size of the JITed
+		 * image as well.
+		 */
+		bpf_jit_fixup_subprog_calls(fp, code_base, &cgctx, addrs);
+
+		/* There is no need to perform the usual passes. */
+		goto skip_codegen_passes;
+	}
+
+	/* Code generation passes 1-2 */
+	for (pass = 1; pass < 3; pass++) {
+		/* Now build the prologue, body code & epilogue for real. */
+		cgctx.idx = 0;
+		bpf_jit_build_prologue(code_base, &cgctx);
+		bpf_jit_build_body(fp, code_base, &cgctx, addrs, extra_pass);
+		bpf_jit_build_epilogue(code_base, &cgctx);
+
+		if (bpf_jit_enable > 1)
+			pr_info("Pass %d: shrink = %d, seen = 0x%x\n", pass,
+				proglen - (cgctx.idx * 4), cgctx.seen);
+	}
+
+skip_codegen_passes:
+	if (bpf_jit_enable > 1)
+		/*
+		 * Note that we output the base address of the code_base
+		 * rather than image, since opcodes are in code_base.
+		 */
+		bpf_jit_dump(flen, proglen, pass, code_base);
+
+#ifdef PPC64_ELF_ABI_v1
+	/* Function descriptor nastiness: Address + TOC */
+	((u64 *)image)[0] = (u64)code_base;
+	((u64 *)image)[1] = local_paca->kernel_toc;
+#endif
+
+	fp->bpf_func = (void *)image;
+	fp->jited = 1;
+	fp->jited_len = alloclen;
+
+	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
+	if (!fp->is_func || extra_pass) {
+		bpf_prog_fill_jited_linfo(fp, addrs);
+out_addrs:
+		kfree(addrs);
+		kfree(jit_data);
+		fp->aux->jit_data = NULL;
+	} else {
+		jit_data->addrs = addrs;
+		jit_data->ctx = cgctx;
+		jit_data->proglen = proglen;
+		jit_data->image = image;
+		jit_data->header = bpf_hdr;
+	}
+
+out:
+	if (bpf_blinded)
+		bpf_jit_prog_release_other(fp, fp == org_fp ? tmp_fp : org_fp);
+
+	return fp;
+}
+
+/* Overriding bpf_jit_free() as we don't set images read-only. */
+void bpf_jit_free(struct bpf_prog *fp)
+{
+	unsigned long addr = (unsigned long)fp->bpf_func & PAGE_MASK;
+	struct bpf_binary_header *bpf_hdr = (void *)addr;
+
+	if (fp->jited)
+		bpf_jit_binary_free(bpf_hdr);
+
+	bpf_prog_unlock_free(fp);
+}
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 89599e75028c..fe0b5937f9fe 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -69,7 +69,7 @@ static int bpf_jit_stack_offsetof(struct codegen_context *ctx, int reg)
 	BUG();
 }
 
-static void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
+void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx)
 {
 	int i;
 
@@ -136,7 +136,7 @@ static void bpf_jit_emit_common_epilogue(u32 *image, struct codegen_context *ctx
 	}
 }
 
-static void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
+void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
 {
 	bpf_jit_emit_common_epilogue(image, ctx);
 
@@ -171,8 +171,7 @@ static void bpf_jit_emit_func_call_hlp(u32 *image, struct codegen_context *ctx,
 	EMIT(PPC_RAW_BLRL());
 }
 
-static void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx,
-				       u64 func)
+void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 func)
 {
 	unsigned int i, ctx_idx = ctx->idx;
 
@@ -273,9 +272,8 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 }
 
 /* Assemble the body code between the prologue & epilogue */
-static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
-			      struct codegen_context *ctx,
-			      u32 *addrs, bool extra_pass)
+int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
+		       u32 *addrs, bool extra_pass)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
@@ -995,249 +993,3 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 
 	return 0;
 }
-
-/* Fix the branch target addresses for subprog calls */
-static int bpf_jit_fixup_subprog_calls(struct bpf_prog *fp, u32 *image,
-				       struct codegen_context *ctx, u32 *addrs)
-{
-	const struct bpf_insn *insn = fp->insnsi;
-	bool func_addr_fixed;
-	u64 func_addr;
-	u32 tmp_idx;
-	int i, ret;
-
-	for (i = 0; i < fp->len; i++) {
-		/*
-		 * During the extra pass, only the branch target addresses for
-		 * the subprog calls need to be fixed. All other instructions
-		 * can left untouched.
-		 *
-		 * The JITed image length does not change because we already
-		 * ensure that the JITed instruction sequence for these calls
-		 * are of fixed length by padding them with NOPs.
-		 */
-		if (insn[i].code == (BPF_JMP | BPF_CALL) &&
-		    insn[i].src_reg == BPF_PSEUDO_CALL) {
-			ret = bpf_jit_get_func_addr(fp, &insn[i], true,
-						    &func_addr,
-						    &func_addr_fixed);
-			if (ret < 0)
-				return ret;
-
-			/*
-			 * Save ctx->idx as this would currently point to the
-			 * end of the JITed image and set it to the offset of
-			 * the instruction sequence corresponding to the
-			 * subprog call temporarily.
-			 */
-			tmp_idx = ctx->idx;
-			ctx->idx = addrs[i] / 4;
-			bpf_jit_emit_func_call_rel(image, ctx, func_addr);
-
-			/*
-			 * Restore ctx->idx here. This is safe as the length
-			 * of the JITed sequence remains unchanged.
-			 */
-			ctx->idx = tmp_idx;
-		}
-	}
-
-	return 0;
-}
-
-struct powerpc64_jit_data {
-	struct bpf_binary_header *header;
-	u32 *addrs;
-	u8 *image;
-	u32 proglen;
-	struct codegen_context ctx;
-};
-
-bool bpf_jit_needs_zext(void)
-{
-	return true;
-}
-
-struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
-{
-	u32 proglen;
-	u32 alloclen;
-	u8 *image = NULL;
-	u32 *code_base;
-	u32 *addrs;
-	struct powerpc64_jit_data *jit_data;
-	struct codegen_context cgctx;
-	int pass;
-	int flen;
-	struct bpf_binary_header *bpf_hdr;
-	struct bpf_prog *org_fp = fp;
-	struct bpf_prog *tmp_fp;
-	bool bpf_blinded = false;
-	bool extra_pass = false;
-
-	if (!fp->jit_requested)
-		return org_fp;
-
-	tmp_fp = bpf_jit_blind_constants(org_fp);
-	if (IS_ERR(tmp_fp))
-		return org_fp;
-
-	if (tmp_fp != org_fp) {
-		bpf_blinded = true;
-		fp = tmp_fp;
-	}
-
-	jit_data = fp->aux->jit_data;
-	if (!jit_data) {
-		jit_data = kzalloc(sizeof(*jit_data), GFP_KERNEL);
-		if (!jit_data) {
-			fp = org_fp;
-			goto out;
-		}
-		fp->aux->jit_data = jit_data;
-	}
-
-	flen = fp->len;
-	addrs = jit_data->addrs;
-	if (addrs) {
-		cgctx = jit_data->ctx;
-		image = jit_data->image;
-		bpf_hdr = jit_data->header;
-		proglen = jit_data->proglen;
-		alloclen = proglen + FUNCTION_DESCR_SIZE;
-		extra_pass = true;
-		goto skip_init_ctx;
-	}
-
-	addrs = kcalloc(flen + 1, sizeof(*addrs), GFP_KERNEL);
-	if (addrs == NULL) {
-		fp = org_fp;
-		goto out_addrs;
-	}
-
-	memset(&cgctx, 0, sizeof(struct codegen_context));
-
-	/* Make sure that the stack is quadword aligned. */
-	cgctx.stack_size = round_up(fp->aux->stack_depth, 16);
-
-	/* Scouting faux-generate pass 0 */
-	if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
-		/* We hit something illegal or unsupported. */
-		fp = org_fp;
-		goto out_addrs;
-	}
-
-	/*
-	 * If we have seen a tail call, we need a second pass.
-	 * This is because bpf_jit_emit_common_epilogue() is called
-	 * from bpf_jit_emit_tail_call() with a not yet stable ctx->seen.
-	 */
-	if (cgctx.seen & SEEN_TAILCALL) {
-		cgctx.idx = 0;
-		if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
-			fp = org_fp;
-			goto out_addrs;
-		}
-	}
-
-	/*
-	 * Pretend to build prologue, given the features we've seen.  This will
-	 * update ctgtx.idx as it pretends to output instructions, then we can
-	 * calculate total size from idx.
-	 */
-	bpf_jit_build_prologue(0, &cgctx);
-	bpf_jit_build_epilogue(0, &cgctx);
-
-	proglen = cgctx.idx * 4;
-	alloclen = proglen + FUNCTION_DESCR_SIZE;
-
-	bpf_hdr = bpf_jit_binary_alloc(alloclen, &image, 4,
-			bpf_jit_fill_ill_insns);
-	if (!bpf_hdr) {
-		fp = org_fp;
-		goto out_addrs;
-	}
-
-skip_init_ctx:
-	code_base = (u32 *)(image + FUNCTION_DESCR_SIZE);
-
-	if (extra_pass) {
-		/*
-		 * Do not touch the prologue and epilogue as they will remain
-		 * unchanged. Only fix the branch target address for subprog
-		 * calls in the body.
-		 *
-		 * This does not change the offsets and lengths of the subprog
-		 * call instruction sequences and hence, the size of the JITed
-		 * image as well.
-		 */
-		bpf_jit_fixup_subprog_calls(fp, code_base, &cgctx, addrs);
-
-		/* There is no need to perform the usual passes. */
-		goto skip_codegen_passes;
-	}
-
-	/* Code generation passes 1-2 */
-	for (pass = 1; pass < 3; pass++) {
-		/* Now build the prologue, body code & epilogue for real. */
-		cgctx.idx = 0;
-		bpf_jit_build_prologue(code_base, &cgctx);
-		bpf_jit_build_body(fp, code_base, &cgctx, addrs, extra_pass);
-		bpf_jit_build_epilogue(code_base, &cgctx);
-
-		if (bpf_jit_enable > 1)
-			pr_info("Pass %d: shrink = %d, seen = 0x%x\n", pass,
-				proglen - (cgctx.idx * 4), cgctx.seen);
-	}
-
-skip_codegen_passes:
-	if (bpf_jit_enable > 1)
-		/*
-		 * Note that we output the base address of the code_base
-		 * rather than image, since opcodes are in code_base.
-		 */
-		bpf_jit_dump(flen, proglen, pass, code_base);
-
-#ifdef PPC64_ELF_ABI_v1
-	/* Function descriptor nastiness: Address + TOC */
-	((u64 *)image)[0] = (u64)code_base;
-	((u64 *)image)[1] = local_paca->kernel_toc;
-#endif
-
-	fp->bpf_func = (void *)image;
-	fp->jited = 1;
-	fp->jited_len = alloclen;
-
-	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
-	if (!fp->is_func || extra_pass) {
-		bpf_prog_fill_jited_linfo(fp, addrs);
-out_addrs:
-		kfree(addrs);
-		kfree(jit_data);
-		fp->aux->jit_data = NULL;
-	} else {
-		jit_data->addrs = addrs;
-		jit_data->ctx = cgctx;
-		jit_data->proglen = proglen;
-		jit_data->image = image;
-		jit_data->header = bpf_hdr;
-	}
-
-out:
-	if (bpf_blinded)
-		bpf_jit_prog_release_other(fp, fp == org_fp ? tmp_fp : org_fp);
-
-	return fp;
-}
-
-/* Overriding bpf_jit_free() as we don't set images read-only. */
-void bpf_jit_free(struct bpf_prog *fp)
-{
-	unsigned long addr = (unsigned long)fp->bpf_func & PAGE_MASK;
-	struct bpf_binary_header *bpf_hdr = (void *)addr;
-
-	if (fp->jited)
-		bpf_jit_binary_free(bpf_hdr);
-
-	bpf_prog_unlock_free(fp);
-}
-- 
2.25.0

