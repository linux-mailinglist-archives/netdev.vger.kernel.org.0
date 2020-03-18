Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65474189C8A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCRNGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:06:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58284 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbgCRNGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584536799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V52u6Yf2cF4NEbL8VRjF6jw3kIUkv312Y635wb5SVaI=;
        b=SLdjSYBQ9m4QpGiegN+8S7ejER5urCxwHU+xu94V2ru68h7/ao86Gcs70ARFk3Hgp6C+Gp
        PGR/T1V5IRI/jQHKOWq3vsBmCeOekFzTbFr6dqS6hZ9iDigMNNGng0pt8JYvpBfCLIwHi+
        V3+OQ5zSNZK/klcpmkn4o2I4yKyI4fw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-OYfAjf83MJSL4_tcBHPtkw-1; Wed, 18 Mar 2020 09:06:34 -0400
X-MC-Unique: OYfAjf83MJSL4_tcBHPtkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2B17802B96;
        Wed, 18 Mar 2020 13:06:22 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63D5E1001DC0;
        Wed, 18 Mar 2020 13:06:21 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com
Subject: [RFC PATCH bpf-next 2/3] bpf: add tracing for XDP programs using the BPF_PROG_TEST_RUN API
Date:   Wed, 18 Mar 2020 13:06:19 +0000
Message-Id: <158453677929.3043.16929314754168577676.stgit@xdp-tutorial>
In-Reply-To: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for tracing eBPF XDP programs that get executed using the
__BPF_PROG_RUN syscall. This is done by switching from JIT (if enabled)
to executing the program using the interpreter and record each
executed instruction.

For now, the execution history is printed to the kernel ring buffer
using pr_info(), the final version should have this stored in a user
supplied buffer.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 include/linux/filter.h |   36 ++-
 kernel/bpf/core.c      |  679 ++++++++++++++++++++++++++++++++++++++++++=
++++++
 kernel/bpf/verifier.c  |   10 -
 3 files changed, 707 insertions(+), 18 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index f95f9ad45ad6..3d8fdbde2d02 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -523,6 +523,9 @@ struct bpf_binary_header {
 	u8 image[] __aligned(BPF_IMAGE_ALIGNMENT);
 };
=20
+typedef unsigned int (*bpf_func_t)(const void *ctx,
+				   const struct bpf_insn *insn);
+
 struct bpf_prog {
 	u16			pages;		/* Number of allocated pages */
 	u16			jited:1,	/* Is our filter JIT'ed? */
@@ -542,8 +545,7 @@ struct bpf_prog {
 	u8			tag[BPF_TAG_SIZE];
 	struct bpf_prog_aux	*aux;		/* Auxiliary fields */
 	struct sock_fprog_kern	*orig_prog;	/* Original BPF program */
-	unsigned int		(*bpf_func)(const void *ctx,
-					    const struct bpf_insn *insn);
+	bpf_func_t		bpf_func;
 	/* Instructions for interpreter */
 	union {
 		struct sock_filter	insns[0];
@@ -559,6 +561,29 @@ struct sk_filter {
=20
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
=20
+#define __BPF_PROG_RUN_INTERPRETER_TRACE(prog, ctx, dfunc)	({	\
+	u32 ret;							\
+	bpf_func_t bpf_func =3D bpf_get_trace_interpreter(prog);		\
+	if (!bpf_func) {						\
+		/* This should not happen, but if it does warn once */	\
+		WARN_ON_ONCE(1);					\
+		return 0;						\
+	}								\
+	cant_migrate();							\
+	if (static_branch_unlikely(&bpf_stats_enabled_key)) {		\
+		struct bpf_prog_stats *stats;				\
+		u64 start =3D sched_clock();				\
+		ret =3D dfunc(ctx, (prog)->insnsi, bpf_func);		\
+		stats =3D this_cpu_ptr(prog->aux->stats);			\
+		u64_stats_update_begin(&stats->syncp);			\
+		stats->cnt++;						\
+		stats->nsecs +=3D sched_clock() - start;			\
+		u64_stats_update_end(&stats->syncp);			\
+	} else {							\
+		ret =3D dfunc(ctx, (prog)->insnsi, bpf_func);		\
+	}								\
+	ret; })
+
 #define __BPF_PROG_RUN(prog, ctx, dfunc)	({			\
 	u32 ret;							\
 	cant_migrate();							\
@@ -722,6 +747,8 @@ static inline u32 bpf_prog_run_clear_cb(const struct =
bpf_prog *prog,
 	return res;
 }
=20
+bpf_func_t bpf_get_trace_interpreter(const struct bpf_prog *fp);
+
 DECLARE_BPF_DISPATCHER(bpf_dispatcher_xdp)
=20
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
@@ -746,8 +773,9 @@ static __always_inline u32 bpf_prog_run_xdp_trace(con=
st struct bpf_prog *prog,
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
-	return __BPF_PROG_RUN(prog, xdp,
-			      BPF_DISPATCHER_FUNC(bpf_dispatcher_xdp));
+	return __BPF_PROG_RUN_INTERPRETER_TRACE(prog, xdp,
+						BPF_DISPATCHER_FUNC(
+							bpf_dispatcher_xdp));
 }
=20
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *pr=
og);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 973a20d49749..5bfc7b5c5af5 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -34,6 +34,8 @@
 #include <linux/log2.h>
 #include <asm/unaligned.h>
=20
+#include "disasm.h"
+
 /* Registers */
 #define BPF_R0	regs[BPF_REG_0]
 #define BPF_R1	regs[BPF_REG_1]
@@ -1341,13 +1343,17 @@ bool bpf_opcode_in_insntable(u8 code)
 	return public_insntable[code];
 }
=20
-#ifndef CONFIG_BPF_JIT_ALWAYS_ON
 u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe=
_ptr)
 {
 	memset(dst, 0, size);
 	return -EFAULT;
 }
=20
+/* TODO: Removed "ifndef CONFIG_BPF_JIT_ALWAYS_ON" for now from __bpf_pr=
og_run
+ *       as we need it for fixup_call_args(), i.e. bpf 2 bpf call with t=
he
+ *       interpreter.
+ */
+
 /**
  *	__bpf_prog_run - run eBPF program on a given context
  *	@regs: is the array of MAX_BPF_EXT_REG eBPF pseudo-registers
@@ -1634,6 +1640,625 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, =
const struct bpf_insn *insn, u6
 		return 0;
 }
=20
+struct bpf_trace_ctx {
+	u32                    insn_executed;
+	u32                    stack_size;
+	u64                   *stack;
+	u64                   *regs;
+	u64                    regs_stored[MAX_BPF_EXT_REG];
+	void                  *addr_stored;
+	u64                    addr_value_stored;
+	char                   scratch[80];
+	char                   scratch_addr[KSYM_NAME_LEN];
+	const struct bpf_insn *prog_insn;
+	const struct bpf_insn *prev_insn;
+};
+
+static __always_inline void __bpf_trace_dump_stack(struct bpf_trace_ctx =
*ctx)
+{
+	int i;
+
+	pr_info("BPFTrace: STACK(%u bytes):", ctx->stack_size);
+
+	for (i =3D 0; i <  (ctx->stack_size / sizeof(u64) / 4); i++) {
+		pr_info("BPFTrace:   %px: 0x%016llx %016llx %016llx %016llx",
+			&ctx->stack[i * 4],
+			ctx->stack[i * 4 + 0], ctx->stack[i * 4 + 1],
+			ctx->stack[i * 4 + 2], ctx->stack[i * 4 + 3]);
+	}
+
+	if ((ctx->stack_size / sizeof(u64) % 4) > 0) {
+		int j;
+		char line[96];
+		int bytes_used =3D 0;
+
+		bytes_used +=3D snprintf(line, sizeof(line),
+				       "BPFTrace:   %px: 0x",
+				       &ctx->stack[i * 4]);
+
+		for (j =3D 0; j < (ctx->stack_size / sizeof(u64) % 4); j++) {
+			bytes_used +=3D snprintf(line + bytes_used,
+					       sizeof(line) - bytes_used,
+					       "%016llx ",
+					       ctx->stack[i * 4 + j]);
+		}
+		pr_info("%s", line);
+	}
+}
+
+static __always_inline void __bpf_trace_dump_regs(struct bpf_trace_ctx *=
ctx)
+{
+	pr_info("BPFTrace: REGISTERS:");
+	pr_info("BPFTrace:   r00-03: 0x%016llx %016llx %016llx %016llx",
+		ctx->regs[BPF_REG_0], ctx->regs[BPF_REG_1],
+		ctx->regs[BPF_REG_2], ctx->regs[BPF_REG_3]);
+	pr_info("BPFTrace:   r04-07: 0x%016llx %016llx %016llx %016llx",
+		ctx->regs[BPF_REG_4], ctx->regs[BPF_REG_5],
+		ctx->regs[BPF_REG_6], ctx->regs[BPF_REG_7]);
+	pr_info("BPFTrace:   r08-11: 0x%016llx %016llx %016llx %016llx",
+		ctx->regs[BPF_REG_8], ctx->regs[BPF_REG_9],
+		ctx->regs[BPF_REG_10], ctx->regs[BPF_REG_AX]);
+}
+
+static __always_inline void __bpf_trace_init(struct bpf_trace_ctx *ctx,
+					     const struct bpf_insn *insn,
+					     u64 *regs,
+					     u64 *stack, u32 stack_size)
+{
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->prog_insn =3D insn;
+	ctx->regs =3D regs;
+	ctx->stack =3D stack;
+	ctx->stack_size =3D stack_size;
+
+	__bpf_trace_dump_stack(ctx);
+	pr_info("BPFTrace:");
+	__bpf_trace_dump_regs(ctx);
+	pr_info("BPFTrace:");
+}
+
+static const char *__bpf_cb_call(void *private_data,
+				 const struct bpf_insn *insn)
+{
+	/* For now only return helper names, we can fix this in the
+	 * actual tool decoding the trace buffer, i.e. bpftool
+	 */
+	struct bpf_trace_ctx *ctx =3D private_data;
+
+	if (insn->src_reg =3D=3D BPF_PSEUDO_CALL) {
+		strncpy(ctx->scratch_addr, "unknown",
+			sizeof(ctx->scratch_addr));
+
+	} else  {
+		u64 address;
+
+		if (__bpf_call_base + insn->imm)
+			address =3D (u64) __bpf_call_base + insn->imm;
+		else
+			address =3D (u64) __bpf_call_base_args + insn->imm;
+
+
+		if (!kallsyms_lookup(address, NULL, NULL, NULL,
+				     ctx->scratch_addr)) {
+
+			snprintf(ctx->scratch_addr, sizeof(ctx->scratch_addr),
+				 "%#016llx", address);
+		}
+	}
+	return ctx->scratch_addr;
+}
+
+
+static void __bpf_cb_print(void *private_data, const char *fmt, ...)
+{
+	struct bpf_trace_ctx *ctx =3D private_data;
+	va_list args;
+
+	va_start(args, fmt);
+	vsnprintf(ctx->scratch, sizeof(ctx->scratch), fmt, args);
+	va_end(args);
+}
+
+static __always_inline void __bpf_trace_next(struct bpf_trace_ctx *ctx,
+					      const struct bpf_insn *insn)
+{
+	int reg;
+
+	/* For tracing handle results of previous function */
+	if (ctx->prev_insn !=3D NULL) {
+		u64 pc;
+		const struct bpf_insn *prev_insn =3D ctx->prev_insn;
+		const struct bpf_insn_cbs cbs =3D {
+			.cb_call        =3D __bpf_cb_call,
+			.cb_print	=3D __bpf_cb_print,
+			.private_data	=3D ctx,
+		};
+		ctx->scratch[0] =3D 0;
+		/*
+		 * TODO: Here we need to handle the BPF_CALL_ARGS and
+		 *       BPF_TAIL_CALL for the disassemble part, see also the
+		 *       bpf_insn_prepare_dump() call.
+		 */
+		print_bpf_insn(&cbs, prev_insn, true);
+		ctx->scratch[strlen(ctx->scratch) - 1] =3D 0;
+
+		/* TODO: We need a better way to calculate the pc, as the pc
+		 *       could be out of scope, i.e. external call. We could
+		 *       use  bpf_prog_insn_size() if we have the bpf_prog
+		 *       structure.
+		 */
+		pc =3D (u64) (prev_insn - ctx->prog_insn);
+
+		pr_info("BPFTrace: %u[%#llx]: %s",
+			ctx->insn_executed, pc,
+			ctx->scratch);
+
+		switch (BPF_CLASS(prev_insn->code)) {
+		case BPF_ALU:
+		case BPF_ALU64:
+		case BPF_LD:
+		case BPF_LDX:
+			pr_info("BPFTrace:   r%u: %#018llx -> %#018llx",
+				ctx->prev_insn->dst_reg,
+				ctx->regs_stored[prev_insn->dst_reg],
+				ctx->regs[prev_insn->dst_reg]);
+			break;
+
+		case BPF_ST:
+		case BPF_STX:
+			switch (BPF_SIZE(insn->code)) {
+			case BPF_B:
+				pr_info("BPFTrace:   MEM[%px]: %#04llx -> %#04x",
+					ctx->addr_stored,
+					ctx->addr_value_stored,
+					*(u8 *) ctx->addr_stored);
+				break;
+			case BPF_H:
+				pr_info("BPFTrace:   MEM[%px]: %#06llx -> %#06x",
+					ctx->addr_stored,
+					ctx->addr_value_stored,
+					*(u16 *) ctx->addr_stored);
+				break;
+			case BPF_W:
+				pr_info("BPFTrace:   MEM[%px]: %#010llx -> %#010x",
+					ctx->addr_stored,
+					ctx->addr_value_stored,
+					*(u32 *) ctx->addr_stored);
+				break;
+			case BPF_DW:
+				pr_info("BPFTrace:   MEM[%px]: %#018llx -> %#018llx",
+					ctx->addr_stored,
+					ctx->addr_value_stored,
+					*(u64 *) ctx->addr_stored);
+				break;
+			}
+			if (BPF_OP(prev_insn->code) =3D=3D BPF_XADD)
+				pr_info("BPFTrace:   !! Above values are not retrieved atomically !!=
");
+
+			break;
+
+		case BPF_JMP:
+		case BPF_JMP32:
+			switch (BPF_OP(prev_insn->code)) {
+
+			default:
+				if (BPF_SRC(prev_insn->code) =3D=3D BPF_X)
+					pr_warn("BPFTrace:   r%u: %#018llx <=3D=3D> r%u: %#018llx",
+						prev_insn->dst_reg,
+						ctx->regs[prev_insn->dst_reg],
+						prev_insn->src_reg,
+						ctx->regs[prev_insn->src_reg]);
+				else
+					pr_warn("BPFTrace:   r%u: %#018llx <=3D=3D> %#08x",
+						prev_insn->dst_reg,
+						ctx->regs[prev_insn->dst_reg],
+						prev_insn->imm);
+				fallthrough;
+
+			case BPF_JA:
+				if ((prev_insn + 1) =3D=3D insn) {
+					pr_warn("BPFTrace:   branch was NOT taken");
+				} else {
+					/* TODO: See note above on pc. */
+					pr_warn("BPFTrace:   pc: %#018llx -> %#018llx",
+						(u64) (prev_insn - ctx->prog_insn),
+						(u64) (insn - ctx->prog_insn));
+					pr_warn("BPFTrace:   branch was taken");
+				}
+				break;
+
+			case BPF_EXIT:
+				break;
+
+			case BPF_CALL:
+			case BPF_CALL_ARGS:
+			case BPF_TAIL_CALL:
+				for (reg =3D BPF_REG_0; reg <=3D BPF_REG_5;
+				     reg++) {
+					if (ctx->regs_stored[reg] !=3D ctx->regs[reg])
+						pr_info("BPFTrace:   r%u: %#018llx -> %#018llx",
+							reg,
+							ctx->regs_stored[reg],
+							ctx->regs[reg]);
+				}
+				break;
+			}
+			break;
+
+		default:
+			pr_warn("BPFTrace: No decode for results %d",
+				BPF_CLASS(prev_insn->code));
+			break;
+		}
+	}
+
+	if (insn =3D=3D NULL)
+		return;
+
+	/* For tracing store information needed before it gets changed */
+	switch (BPF_CLASS(insn->code)) {
+	case BPF_ALU:
+	case BPF_ALU64:
+	case BPF_LD:
+	case BPF_LDX:
+		ctx->regs_stored[insn->dst_reg] =3D ctx->regs[insn->dst_reg];
+		break;
+
+	case BPF_ST:
+	case BPF_STX:
+		ctx->addr_stored =3D (void *) ctx->regs[insn->dst_reg] + insn->off;
+		switch (BPF_SIZE(insn->code)) {
+		case BPF_B:
+			ctx->addr_value_stored =3D *(u8 *) ctx->addr_stored;
+			break;
+		case BPF_H:
+			ctx->addr_value_stored =3D *(u16 *) ctx->addr_stored;
+			break;
+		case BPF_W:
+			ctx->addr_value_stored =3D *(u32 *) ctx->addr_stored;
+			break;
+		case BPF_DW:
+			ctx->addr_value_stored =3D *(u64 *) ctx->addr_stored;
+			break;
+		default:
+			ctx->addr_value_stored =3D 0;
+			break;
+		}
+		break;
+
+	case BPF_JMP32:
+		/* Nothing we need to store for this case */
+		break;
+
+	case BPF_JMP:
+		/* Only for special jump we need to store stuff */
+		if (BPF_OP(insn->code) =3D=3D BPF_CALL ||
+		    BPF_OP(insn->code) =3D=3D BPF_CALL_ARGS) {
+
+			for (reg =3D BPF_REG_0; reg <=3D BPF_REG_5; reg++)
+				ctx->regs_stored[reg] =3D ctx->regs[reg];
+
+		} else if (BPF_OP(insn->code) =3D=3D BPF_TAIL_CALL) {
+
+			pr_warn("BPFTrace: TODO: No decode for results %d",
+				BPF_OP(insn->code));
+		}
+		break;
+
+	default:
+		pr_warn("BPFTrace: No capture for ORIGINAL value for %d",
+			BPF_CLASS(insn->code));
+		break;
+	}
+	ctx->insn_executed++;
+	ctx->prev_insn =3D insn;
+}
+
+static __always_inline void __bpf_trace_complete(struct bpf_trace_ctx *c=
tx,
+						 u64 ret)
+{
+	__bpf_trace_next(ctx, NULL);
+	pr_info("BPFTrace:");
+	__bpf_trace_dump_stack(ctx);
+	pr_info("BPFTrace:");
+	__bpf_trace_dump_regs(ctx);
+	pr_info("BPFTrace:");
+	pr_info("BPFTrace: RESULT:");
+	pr_info("BPFTrace:   return =3D %#018llx", ret);
+}
+
+/**
+ *	__bpf_prog_run_trace - run eBPF program on a given context
+ *	@regs: is the array of MAX_BPF_EXT_REG eBPF pseudo-registers
+ *	@insn: is the array of eBPF instructions
+ *	@stack: is the eBPF storage stack
+ *
+ * Decode and execute eBPF instructions with tracing enabled.
+ *
+ * TODO: This is just a copy of the none trace __bpf_prog_run(), we need=
 to
+ *       integrate the two with out adding duplicate code...
+ */
+static u64 __no_fgcse ___bpf_prog_run_trace(struct bpf_trace_ctx *trace_=
ctx,
+					    u64 *regs,
+					    const struct bpf_insn *insn,
+					    u64 *stack)
+{
+#define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] =3D &&x##_##y
+#define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] =3D &&x##_=
##y##_##z
+	static const void * const jumptable[256] __annotate_jump_table =3D {
+		[0 ... 255] =3D &&default_label,
+		/* Now overwrite non-defaults ... */
+		BPF_INSN_MAP(BPF_INSN_2_LBL, BPF_INSN_3_LBL),
+		/* Non-UAPI available opcodes. */
+		[BPF_JMP | BPF_CALL_ARGS] =3D &&JMP_CALL_ARGS,
+		[BPF_JMP | BPF_TAIL_CALL] =3D &&JMP_TAIL_CALL,
+		[BPF_LDX | BPF_PROBE_MEM | BPF_B] =3D &&LDX_PROBE_MEM_B,
+		[BPF_LDX | BPF_PROBE_MEM | BPF_H] =3D &&LDX_PROBE_MEM_H,
+		[BPF_LDX | BPF_PROBE_MEM | BPF_W] =3D &&LDX_PROBE_MEM_W,
+		[BPF_LDX | BPF_PROBE_MEM | BPF_DW] =3D &&LDX_PROBE_MEM_DW,
+	};
+#undef BPF_INSN_3_LBL
+#undef BPF_INSN_2_LBL
+	u32 tail_call_cnt =3D 0;
+
+#define CONT	 ({ insn++; goto select_insn; })
+#define CONT_JMP ({ insn++; goto select_insn; })
+select_insn:
+	__bpf_trace_next(trace_ctx, insn);
+	goto *jumptable[insn->code];
+
+	/* ALU */
+#define ALU(OPCODE, OP)			\
+	ALU64_##OPCODE##_X:		\
+		DST =3D DST OP SRC;	\
+		CONT;			\
+	ALU_##OPCODE##_X:		\
+		DST =3D (u32) DST OP (u32) SRC;	\
+		CONT;			\
+	ALU64_##OPCODE##_K:		\
+		DST =3D DST OP IMM;		\
+		CONT;			\
+	ALU_##OPCODE##_K:		\
+		DST =3D (u32) DST OP (u32) IMM;	\
+		CONT;
+
+	ALU(ADD,  +)
+	ALU(SUB,  -)
+	ALU(AND,  &)
+	ALU(OR,   |)
+	ALU(LSH, <<)
+	ALU(RSH, >>)
+	ALU(XOR,  ^)
+	ALU(MUL,  *)
+#undef ALU
+	ALU_NEG:
+		DST =3D (u32) -DST;
+		CONT;
+	ALU64_NEG:
+		DST =3D -DST;
+		CONT;
+	ALU_MOV_X:
+		DST =3D (u32) SRC;
+		CONT;
+	ALU_MOV_K:
+		DST =3D (u32) IMM;
+		CONT;
+	ALU64_MOV_X:
+		DST =3D SRC;
+		CONT;
+	ALU64_MOV_K:
+		DST =3D IMM;
+		CONT;
+	LD_IMM_DW:
+		DST =3D (u64) (u32) insn[0].imm | ((u64) (u32) insn[1].imm) << 32;
+		insn++;
+		CONT;
+	ALU_ARSH_X:
+		DST =3D (u64) (u32) (((s32) DST) >> SRC);
+		CONT;
+	ALU_ARSH_K:
+		DST =3D (u64) (u32) (((s32) DST) >> IMM);
+		CONT;
+	ALU64_ARSH_X:
+		(*(s64 *) &DST) >>=3D SRC;
+		CONT;
+	ALU64_ARSH_K:
+		(*(s64 *) &DST) >>=3D IMM;
+		CONT;
+	ALU64_MOD_X:
+		div64_u64_rem(DST, SRC, &AX);
+		DST =3D AX;
+		CONT;
+	ALU_MOD_X:
+		AX =3D (u32) DST;
+		DST =3D do_div(AX, (u32) SRC);
+		CONT;
+	ALU64_MOD_K:
+		div64_u64_rem(DST, IMM, &AX);
+		DST =3D AX;
+		CONT;
+	ALU_MOD_K:
+		AX =3D (u32) DST;
+		DST =3D do_div(AX, (u32) IMM);
+		CONT;
+	ALU64_DIV_X:
+		DST =3D div64_u64(DST, SRC);
+		CONT;
+	ALU_DIV_X:
+		AX =3D (u32) DST;
+		do_div(AX, (u32) SRC);
+		DST =3D (u32) AX;
+		CONT;
+	ALU64_DIV_K:
+		DST =3D div64_u64(DST, IMM);
+		CONT;
+	ALU_DIV_K:
+		AX =3D (u32) DST;
+		do_div(AX, (u32) IMM);
+		DST =3D (u32) AX;
+		CONT;
+	ALU_END_TO_BE:
+		switch (IMM) {
+		case 16:
+			DST =3D (__force u16) cpu_to_be16(DST);
+			break;
+		case 32:
+			DST =3D (__force u32) cpu_to_be32(DST);
+			break;
+		case 64:
+			DST =3D (__force u64) cpu_to_be64(DST);
+			break;
+		}
+		CONT;
+	ALU_END_TO_LE:
+		switch (IMM) {
+		case 16:
+			DST =3D (__force u16) cpu_to_le16(DST);
+			break;
+		case 32:
+			DST =3D (__force u32) cpu_to_le32(DST);
+			break;
+		case 64:
+			DST =3D (__force u64) cpu_to_le64(DST);
+			break;
+		}
+		CONT;
+
+	/* CALL */
+	JMP_CALL:
+		/* Function call scratches BPF_R1-BPF_R5 registers,
+		 * preserves BPF_R6-BPF_R9, and stores return value
+		 * into BPF_R0.
+		 */
+		BPF_R0 =3D (__bpf_call_base + insn->imm)(BPF_R1, BPF_R2, BPF_R3,
+						       BPF_R4, BPF_R5);
+		CONT;
+
+	JMP_CALL_ARGS:
+		BPF_R0 =3D (__bpf_call_base_args + insn->imm)(BPF_R1, BPF_R2,
+							    BPF_R3, BPF_R4,
+							    BPF_R5,
+							    insn + insn->off + 1);
+		CONT;
+
+	JMP_TAIL_CALL: {
+		struct bpf_map *map =3D (struct bpf_map *) (unsigned long) BPF_R2;
+		struct bpf_array *array =3D container_of(map, struct bpf_array, map);
+		struct bpf_prog *prog;
+		u32 index =3D BPF_R3;
+
+		if (unlikely(index >=3D array->map.max_entries))
+			goto out;
+		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+			goto out;
+
+		tail_call_cnt++;
+
+		prog =3D READ_ONCE(array->ptrs[index]);
+		if (!prog)
+			goto out;
+
+		/* ARG1 at this point is guaranteed to point to CTX from
+		 * the verifier side due to the fact that the tail call is
+		 * handeled like a helper, that is, bpf_tail_call_proto,
+		 * where arg1_type is ARG_PTR_TO_CTX.
+		 */
+		insn =3D prog->insnsi;
+		goto select_insn;
+out:
+		CONT;
+	}
+	JMP_JA:
+		insn +=3D insn->off;
+		CONT;
+	JMP_EXIT:
+		return BPF_R0;
+	/* JMP */
+#define COND_JMP(SIGN, OPCODE, CMP_OP)				\
+	JMP_##OPCODE##_X:					\
+		if ((SIGN##64) DST CMP_OP (SIGN##64) SRC) {	\
+			insn +=3D insn->off;			\
+			CONT_JMP;				\
+		}						\
+		CONT;						\
+	JMP32_##OPCODE##_X:					\
+		if ((SIGN##32) DST CMP_OP (SIGN##32) SRC) {	\
+			insn +=3D insn->off;			\
+			CONT_JMP;				\
+		}						\
+		CONT;						\
+	JMP_##OPCODE##_K:					\
+		if ((SIGN##64) DST CMP_OP (SIGN##64) IMM) {	\
+			insn +=3D insn->off;			\
+			CONT_JMP;				\
+		}						\
+		CONT;						\
+	JMP32_##OPCODE##_K:					\
+		if ((SIGN##32) DST CMP_OP (SIGN##32) IMM) {	\
+			insn +=3D insn->off;			\
+			CONT_JMP;				\
+		}						\
+		CONT;
+	COND_JMP(u, JEQ, =3D=3D)
+	COND_JMP(u, JNE, !=3D)
+	COND_JMP(u, JGT, >)
+	COND_JMP(u, JLT, <)
+	COND_JMP(u, JGE, >=3D)
+	COND_JMP(u, JLE, <=3D)
+	COND_JMP(u, JSET, &)
+	COND_JMP(s, JSGT, >)
+	COND_JMP(s, JSLT, <)
+	COND_JMP(s, JSGE, >=3D)
+	COND_JMP(s, JSLE, <=3D)
+#undef COND_JMP
+	/* STX and ST and LDX*/
+#define LDST(SIZEOP, SIZE)						\
+	STX_MEM_##SIZEOP:						\
+		*(SIZE *)(unsigned long) (DST + insn->off) =3D SRC;	\
+		CONT;							\
+	ST_MEM_##SIZEOP:						\
+		*(SIZE *)(unsigned long) (DST + insn->off) =3D IMM;	\
+		CONT;							\
+	LDX_MEM_##SIZEOP:						\
+		DST =3D *(SIZE *)(unsigned long) (SRC + insn->off);	\
+		CONT;
+
+	LDST(B,   u8)
+	LDST(H,  u16)
+	LDST(W,  u32)
+	LDST(DW, u64)
+#undef LDST
+#define LDX_PROBE(SIZEOP, SIZE)							\
+	LDX_PROBE_MEM_##SIZEOP:							\
+		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->of=
f));	\
+		CONT;
+	LDX_PROBE(B,  1)
+	LDX_PROBE(H,  2)
+	LDX_PROBE(W,  4)
+	LDX_PROBE(DW, 8)
+#undef LDX_PROBE
+
+	STX_XADD_W: /* lock xadd *(u32 *)(dst_reg + off16) +=3D src_reg */
+		atomic_add((u32) SRC, (atomic_t *)(unsigned long)
+			   (DST + insn->off));
+		CONT;
+	STX_XADD_DW: /* lock xadd *(u64 *)(dst_reg + off16) +=3D src_reg */
+		atomic64_add((u64) SRC, (atomic64_t *)(unsigned long)
+			     (DST + insn->off));
+		CONT;
+
+	default_label:
+		/* If we ever reach this, we have a bug somewhere. Die hard here
+		 * instead of just returning 0; we could be somewhere in a subprog,
+		 * so execution could continue otherwise which we do /not/ want.
+		 *
+		 * Note, verifier whitelists all opcodes in bpf_opcode_in_insntable().
+		 */
+		pr_warn("BPF interpreter: unknown opcode %02x\n", insn->code);
+		BUG_ON(1);
+		return 0;
+}
+
 #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
 #define DEFINE_BPF_PROG_RUN(stack_size) \
 static unsigned int PROG_NAME(stack_size)(const void *ctx, const struct =
bpf_insn *insn) \
@@ -1646,6 +2271,27 @@ static unsigned int PROG_NAME(stack_size)(const vo=
id *ctx, const struct bpf_insn
 	return ___bpf_prog_run(regs, insn, stack); \
 }
=20
+#define PROG_NAME_TRACE(stack_size) __bpf_prog_run_trace##stack_size
+#define DEFINE_BPF_PROG_RUN_TRACE(stack_size) \
+static unsigned int PROG_NAME_TRACE(stack_size)(const void *ctx, const s=
truct bpf_insn *insn) \
+{ \
+	unsigned int ret; \
+	u64 stack[stack_size / sizeof(u64)]; \
+	u64 regs[MAX_BPF_EXT_REG]; \
+	struct bpf_trace_ctx trace_ctx; \
+\
+	memset(stack, 0, sizeof(stack)); \
+	memset(regs, 0, sizeof(regs)); \
+\
+	FP =3D (u64) (unsigned long) &stack[ARRAY_SIZE(stack)]; \
+	ARG1 =3D (u64) (unsigned long) ctx; \
+\
+	__bpf_trace_init(&trace_ctx, insn, regs, stack, stack_size); \
+	ret =3D ___bpf_prog_run_trace(&trace_ctx, regs, insn, stack); \
+	__bpf_trace_complete(&trace_ctx, ret); \
+	return ret; \
+}
+
 #define PROG_NAME_ARGS(stack_size) __bpf_prog_run_args##stack_size
 #define DEFINE_BPF_PROG_RUN_ARGS(stack_size) \
 static u64 PROG_NAME_ARGS(stack_size)(u64 r1, u64 r2, u64 r3, u64 r4, u6=
4 r5, \
@@ -1670,16 +2316,20 @@ static u64 PROG_NAME_ARGS(stack_size)(u64 r1, u64=
 r2, u64 r3, u64 r4, u64 r5, \
 #define EVAL5(FN, X, Y...) FN(X) EVAL4(FN, Y)
 #define EVAL6(FN, X, Y...) FN(X) EVAL5(FN, Y)
=20
-EVAL6(DEFINE_BPF_PROG_RUN, 32, 64, 96, 128, 160, 192);
-EVAL6(DEFINE_BPF_PROG_RUN, 224, 256, 288, 320, 352, 384);
-EVAL4(DEFINE_BPF_PROG_RUN, 416, 448, 480, 512);
+EVAL6(DEFINE_BPF_PROG_RUN_TRACE, 32, 64, 96, 128, 160, 192);
+EVAL6(DEFINE_BPF_PROG_RUN_TRACE, 224, 256, 288, 320, 352, 384);
+EVAL4(DEFINE_BPF_PROG_RUN_TRACE, 416, 448, 480, 512);
=20
 EVAL6(DEFINE_BPF_PROG_RUN_ARGS, 32, 64, 96, 128, 160, 192);
 EVAL6(DEFINE_BPF_PROG_RUN_ARGS, 224, 256, 288, 320, 352, 384);
 EVAL4(DEFINE_BPF_PROG_RUN_ARGS, 416, 448, 480, 512);
=20
-#define PROG_NAME_LIST(stack_size) PROG_NAME(stack_size),
+#ifndef CONFIG_BPF_JIT_ALWAYS_ON
+EVAL6(DEFINE_BPF_PROG_RUN, 32, 64, 96, 128, 160, 192);
+EVAL6(DEFINE_BPF_PROG_RUN, 224, 256, 288, 320, 352, 384);
+EVAL4(DEFINE_BPF_PROG_RUN, 416, 448, 480, 512);
=20
+#define PROG_NAME_LIST(stack_size) PROG_NAME(stack_size),
 static unsigned int (*interpreters[])(const void *ctx,
 				      const struct bpf_insn *insn) =3D {
 EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
@@ -1687,6 +2337,17 @@ EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384=
)
 EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
 };
 #undef PROG_NAME_LIST
+#endif
+
+#define PROG_NAME_LIST(stack_size) PROG_NAME_TRACE(stack_size),
+static unsigned int (*interpreters_trace[])(const void *ctx,
+					    const struct bpf_insn *insn) =3D {
+EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
+EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384)
+EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
+};
+#undef PROG_NAME_LIST
+
 #define PROG_NAME_LIST(stack_size) PROG_NAME_ARGS(stack_size),
 static u64 (*interpreters_args[])(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5=
,
 				  const struct bpf_insn *insn) =3D {
@@ -1696,6 +2357,12 @@ EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
 };
 #undef PROG_NAME_LIST
=20
+bpf_func_t bpf_get_trace_interpreter(const struct bpf_prog *fp)
+{
+	u32 stack_depth =3D max_t(u32, fp->aux->stack_depth, 1);
+	return interpreters_trace[(round_up(stack_depth, 32) / 32) - 1];
+}
+
 void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
 {
 	stack_depth =3D max_t(u32, stack_depth, 1);
@@ -1705,7 +2372,7 @@ void bpf_patch_call_args(struct bpf_insn *insn, u32=
 stack_depth)
 	insn->code =3D BPF_JMP | BPF_CALL_ARGS;
 }
=20
-#else
+#ifdef CONFIG_BPF_JIT_ALWAYS_ON
 static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 					 const struct bpf_insn *insn)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 55d376c53f7d..d521c5ad8111 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2720,7 +2720,6 @@ static int check_max_stack_depth(struct bpf_verifie=
r_env *env)
 	goto continue_func;
 }
=20
-#ifndef CONFIG_BPF_JIT_ALWAYS_ON
 static int get_callee_stack_depth(struct bpf_verifier_env *env,
 				  const struct bpf_insn *insn, int idx)
 {
@@ -2734,7 +2733,6 @@ static int get_callee_stack_depth(struct bpf_verifi=
er_env *env,
 	}
 	return env->subprog_info[subprog].stack_depth;
 }
-#endif
=20
 int check_ctx_reg(struct bpf_verifier_env *env,
 		  const struct bpf_reg_state *reg, int regno)
@@ -9158,11 +9156,9 @@ static int jit_subprogs(struct bpf_verifier_env *e=
nv)
=20
 static int fixup_call_args(struct bpf_verifier_env *env)
 {
-#ifndef CONFIG_BPF_JIT_ALWAYS_ON
 	struct bpf_prog *prog =3D env->prog;
 	struct bpf_insn *insn =3D prog->insnsi;
 	int i, depth;
-#endif
 	int err =3D 0;
=20
 	if (env->prog->jit_requested &&
@@ -9173,7 +9169,7 @@ static int fixup_call_args(struct bpf_verifier_env =
*env)
 		if (err =3D=3D -EFAULT)
 			return err;
 	}
-#ifndef CONFIG_BPF_JIT_ALWAYS_ON
+
 	for (i =3D 0; i < prog->len; i++, insn++) {
 		if (insn->code !=3D (BPF_JMP | BPF_CALL) ||
 		    insn->src_reg !=3D BPF_PSEUDO_CALL)
@@ -9183,9 +9179,7 @@ static int fixup_call_args(struct bpf_verifier_env =
*env)
 			return depth;
 		bpf_patch_call_args(insn, depth);
 	}
-	err =3D 0;
-#endif
-	return err;
+	return 0;
 }
=20
 /* fixup insn->imm field of bpf_call instructions

