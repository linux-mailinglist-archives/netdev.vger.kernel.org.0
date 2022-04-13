Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02734FEE89
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 07:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiDMFkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 01:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiDMFkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 01:40:01 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2902E3134B;
        Tue, 12 Apr 2022 22:37:40 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KdWXM2CQxzgYbq;
        Wed, 13 Apr 2022 13:35:47 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Apr
 2022 13:37:35 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
Subject: [PATCH bpf-next 4/5] bpf, arm64: bpf trampoline for arm64
Date:   Wed, 13 Apr 2022 01:49:58 -0400
Message-ID: <20220413054959.1053668-5-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413054959.1053668-1-xukuohai@huawei.com>
References: <20220413054959.1053668-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf trampoline support for arm64. Most of the logic is the same as
x86.

fentry before bpf trampoline hooked:
 mov x9, x30
 nop

fentry after bpf trampoline hooked:
 mov x9, x30
 bl  <bpf_trampoline>

Tested on qemu, result:
 #55 fentry_fexit:OK
 #56 fentry_test:OK
 #58 fexit_sleep:OK
 #59 fexit_stress:OK
 #60 fexit_test:OK
 #67 get_func_args_test:OK
 #68 get_func_ip_test:OK
 #101 modify_return:OK

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 arch/arm64/net/bpf_jit.h      |  14 +-
 arch/arm64/net/bpf_jit_comp.c | 338 +++++++++++++++++++++++++++++++++-
 2 files changed, 348 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index 194c95ccc1cf..e29761dc8004 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -86,9 +86,18 @@
 		AARCH64_INSN_VARIANT_64BIT, \
 		AARCH64_INSN_LDST_##ls##_PAIR_##type)
 /* Rn -= 16; Rn[0] = Rt; Rn[8] = Rt2; */
-#define A64_PUSH(Rt, Rt2, Rn) A64_LS_PAIR(Rt, Rt2, Rn, -16, STORE, PRE_INDEX)
+#define A64_PUSH(Rt, Rt2, Rn) \
+	A64_LS_PAIR(Rt, Rt2, Rn, -16, STORE, PRE_INDEX)
 /* Rt = Rn[0]; Rt2 = Rn[8]; Rn += 16; */
-#define A64_POP(Rt, Rt2, Rn)  A64_LS_PAIR(Rt, Rt2, Rn, 16, LOAD, POST_INDEX)
+#define A64_POP(Rt, Rt2, Rn) \
+	A64_LS_PAIR(Rt, Rt2, Rn, 16, LOAD, POST_INDEX)
+
+/* Rn[imm] = Xt1; Rn[imm + 8] = Xt2 */
+#define A64_STP(Xt1, Xt2, Xn, imm)  \
+	A64_LS_PAIR(Xt1, Xt2, Xn, imm, STORE, SIGNED_OFFSET)
+/* Xt1 = Rn[imm]; Xt2 = Rn[imm + 8] */
+#define A64_LDP(Xt1, Xt2, Xn, imm)  \
+	A64_LS_PAIR(Xt1, Xt2, Xn, imm, LOAD, SIGNED_OFFSET)
 
 /* Load/store exclusive */
 #define A64_SIZE(sf) \
@@ -270,6 +279,7 @@
 #define A64_BTI_C  A64_HINT(AARCH64_INSN_HINT_BTIC)
 #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
 #define A64_BTI_JC A64_HINT(AARCH64_INSN_HINT_BTIJC)
+#define A64_NOP    A64_HINT(AARCH64_INSN_HINT_NOP)
 
 /* DMB */
 #define A64_DMB_ISH aarch64_insn_gen_dmb(AARCH64_INSN_MB_ISH)
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 1a1c3ea75ee2..5f6bd755050f 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1333,10 +1333,16 @@ static int validate_code(struct jit_ctx *ctx)
 
 	for (i = 0; i < ctx->idx; i++) {
 		u32 a64_insn = le32_to_cpu(ctx->image[i]);
-
 		if (a64_insn == AARCH64_BREAK_FAULT)
 			return -1;
 	}
+	return 0;
+}
+
+static int validate_ctx(struct jit_ctx *ctx)
+{
+	if (validate_code(ctx))
+		return -1;
 
 	if (WARN_ON_ONCE(ctx->exentry_idx != ctx->prog->aux->num_exentries))
 		return -1;
@@ -1461,7 +1467,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	build_epilogue(&ctx);
 
 	/* 3. Extra pass to validate JITed code. */
-	if (validate_code(&ctx)) {
+	if (validate_ctx(&ctx)) {
 		bpf_jit_binary_free(header);
 		prog = orig_prog;
 		goto out_off;
@@ -1532,6 +1538,334 @@ void bpf_jit_free_exec(void *addr)
 	return vfree(addr);
 }
 
+static void invoke_bpf_prog(struct jit_ctx *ctx, struct bpf_prog *p,
+			    int args_off, int retval_off, bool save_ret)
+{
+	u32 *branch;
+	u64 enter_prog;
+	u64 exit_prog;
+	u8 tmp = bpf2a64[TMP_REG_1];
+	u8 r0 = bpf2a64[BPF_REG_0];
+
+	if (p->aux->sleepable) {
+		enter_prog = (u64)__bpf_prog_enter_sleepable;
+		exit_prog = (u64)__bpf_prog_exit_sleepable;
+	} else {
+		enter_prog = (u64)__bpf_prog_enter;
+		exit_prog = (u64)__bpf_prog_exit;
+	}
+
+	/* bl __bpf_prog_enter */
+	emit_addr_mov_i64(A64_R(0), (const u64)p, ctx);
+	emit_addr_mov_i64(tmp, enter_prog, ctx);
+	emit(A64_BLR(tmp), ctx);
+
+	/*
+	 * if (__bpf_prog_enter(prog) == 0)
+	 *         goto skip_exec_of_prog;
+	 */
+	branch = ctx->image + ctx->idx;
+	emit(A64_NOP, ctx);
+
+	/* move return value to x19 */
+	emit(A64_MOV(1, A64_R(19), r0), ctx);
+
+	/* bl bpf_prog */
+	emit(A64_ADD_I(1, A64_R(0), A64_SP, args_off), ctx);
+	if (!p->jited)
+		emit_addr_mov_i64(A64_R(1), (const u64)p->insnsi, ctx);
+	emit_addr_mov_i64(tmp, (const u64)p->bpf_func, ctx);
+	emit(A64_BLR(tmp), ctx);
+
+	/* store return value */
+	if (save_ret)
+		emit(A64_STR64I(r0, A64_SP, retval_off), ctx);
+
+	if (ctx->image) {
+		int offset = &ctx->image[ctx->idx] - branch;
+		*branch = A64_CBZ(1, A64_R(0), offset);
+	}
+
+	/* bl __bpf_prog_exit */
+	emit_addr_mov_i64(A64_R(0), (const u64)p, ctx);
+	emit(A64_MOV(1, A64_R(1), A64_R(19)), ctx);
+	emit_addr_mov_i64(tmp, exit_prog, ctx);
+	emit(A64_BLR(tmp), ctx);
+}
+
+static void invoke_bpf_mod_ret(struct jit_ctx *ctx, struct bpf_tramp_progs *tp,
+			       int args_off, int retval_off, u32 **branches)
+{
+	int i;
+
+	/* The first fmod_ret program will receive a garbage return value.
+	 * Set this to 0 to avoid confusing the program.
+	 */
+	emit(A64_STR64I(A64_ZR, A64_SP, retval_off), ctx);
+	for (i = 0; i < tp->nr_progs; i++) {
+		invoke_bpf_prog(ctx, tp->progs[i], args_off, retval_off, true);
+		/*
+		 * if (*(u64 *)(sp + retval_off) !=  0)
+		 *	goto do_fexit;
+		 */
+		emit(A64_LDR64I(A64_R(10), A64_SP, retval_off), ctx);
+		/* Save the location of branch, and generate a nop.
+		 * This nop will be replaced with a cbnz later.
+		 */
+		branches[i] = ctx->image + ctx->idx;
+		emit(A64_NOP, ctx);
+	}
+}
+
+static void save_args(struct jit_ctx *ctx, int args_off, int nargs)
+{
+	int i;
+
+	for (i = 0; i < nargs; i++) {
+		emit(A64_STR64I(i, A64_SP, args_off), ctx);
+		args_off += 8;
+	}
+}
+
+static void restore_args(struct jit_ctx *ctx, int args_off, int nargs)
+{
+	int i;
+
+	for (i = 0; i < nargs; i++) {
+		emit(A64_LDR64I(i, A64_SP, args_off), ctx);
+		args_off += 8;
+	}
+}
+
+/*
+ * Based on the x86's implementation of arch_prepare_bpf_trampoline().
+ *
+ * We dpend on DYNAMIC_FTRACE_WITH_REGS to set return address and nop.
+ *
+ * fentry before bpf trampoline hooked:
+ *   mov x9, x30
+ *   nop
+ *
+ * fentry after bpf trampoline hooked:
+ *   mov x9, x30
+ *   bl  <bpf_trampoline>
+ *
+ */
+static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
+			      struct bpf_tramp_progs *tprogs, void *orig_call,
+			      int nargs, u32 flags)
+{
+	int i;
+	int stack_size;
+	int retaddr_off;
+	int regs_off;
+	int retval_off;
+	int args_off;
+	int nargs_off;
+	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
+	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
+	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
+	bool save_ret;
+	u32 **branches = NULL;
+
+	/*
+	 * trampoline stack layout:
+	 *                  [ parent ip       ]
+	 *                  [ FP              ]
+	 * SP + retaddr_off [ self ip         ]
+	 * FP               [ FP              ]
+	 *
+	 * sp + regs_off    [ x19             ] callee-saved regs, currently
+	 *                                      only x19 is used
+	 *
+	 * SP + retval_off  [ return value    ] BPF_TRAMP_F_CALL_ORIG or
+	 *                                      BPF_TRAMP_F_RET_FENTRY_RET flags
+	 *
+	 *                  [ argN            ]
+	 *                  [ ...             ]
+	 * sp + args_off    [ arg1            ]
+	 *
+	 * SP + nargs_off   [ args count      ]
+	 *
+	 * SP + 0           [ traced function ] BPF_TRAMP_F_IP_ARG flag
+	 */
+
+	stack_size = 0;
+	/* room for IP address argument */
+	if (flags & BPF_TRAMP_F_IP_ARG)
+		stack_size += 8;
+
+	nargs_off = stack_size;
+	/* room for args count */
+	stack_size += 8;
+
+	args_off = stack_size;
+	/* room for args */
+	stack_size += nargs * 8;
+
+	/* room for return value */
+	retval_off = stack_size;
+	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
+	if (save_ret)
+		stack_size += 8;
+
+	/* room for callee-saved registers, currently only x19 is used */
+	regs_off = stack_size;
+	stack_size += 8;
+
+	retaddr_off = stack_size + 8;
+
+	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
+		emit(A64_BTI_C, ctx);
+
+	/* frame for parent function */
+	emit(A64_PUSH(A64_FP, A64_R(9), A64_SP), ctx);
+	emit(A64_MOV(1, A64_FP, A64_SP), ctx);
+
+	/* frame for patched function */
+	emit(A64_PUSH(A64_FP, A64_LR, A64_SP), ctx);
+	emit(A64_MOV(1, A64_FP, A64_SP), ctx);
+
+	/* allocate stack space */
+	emit(A64_SUB_I(1, A64_SP, A64_SP, stack_size), ctx);
+
+	if (flags & BPF_TRAMP_F_IP_ARG) {
+		/* save ip address of the traced function */
+		emit_addr_mov_i64(A64_R(10), (const u64)orig_call, ctx);
+		emit(A64_STR64I(A64_R(10), A64_SP, 0), ctx);
+	}
+
+	/* save args count*/
+	emit(A64_MOVZ(1, A64_R(10), nargs, 0), ctx);
+	emit(A64_STR64I(A64_R(10), A64_SP, nargs_off), ctx);
+
+	/* save args */
+	save_args(ctx, args_off, nargs);
+
+	/* save callee saved registers */
+	emit(A64_STR64I(A64_R(19), A64_SP, regs_off), ctx);
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		emit_addr_mov_i64(A64_R(0), (const u64)im, ctx);
+		emit_addr_mov_i64(A64_R(10), (const u64)__bpf_tramp_enter, ctx);
+		emit(A64_BLR(A64_R(10)), ctx);
+	}
+
+	for (i = 0; i < fentry->nr_progs; i++)
+		invoke_bpf_prog(ctx, fentry->progs[i], args_off, retval_off,
+				flags & BPF_TRAMP_F_RET_FENTRY_RET);
+
+	if (fmod_ret->nr_progs) {
+		branches = kcalloc(fmod_ret->nr_progs, sizeof(u32 *),
+				   GFP_KERNEL);
+		if (!branches)
+			return -ENOMEM;
+
+		invoke_bpf_mod_ret(ctx, fmod_ret, args_off, retval_off,
+				   branches);
+	}
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		restore_args(ctx, args_off, nargs);
+		emit(A64_LDR64I(A64_R(10), A64_SP, retaddr_off), ctx);
+		emit(A64_BLR(A64_R(10)), ctx);
+		emit(A64_STR64I(A64_R(0), A64_SP, retval_off), ctx);
+		im->ip_after_call = ctx->image + ctx->idx;
+		emit(A64_NOP, ctx);
+	}
+
+	/* update the branches saved in invoke_bpf_mod_ret with cbnz */
+	for (i = 0; i < fmod_ret->nr_progs && ctx->image != NULL; i++) {
+		int offset = &ctx->image[ctx->idx] - branches[i];
+		*branches[i] = A64_CBNZ(1, A64_R(10), offset);
+	}
+
+	for (i = 0; i < fexit->nr_progs; i++)
+		invoke_bpf_prog(ctx, fexit->progs[i], args_off, retval_off,
+				false);
+
+	if (flags & BPF_TRAMP_F_RESTORE_REGS)
+		restore_args(ctx, args_off, nargs);
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		im->ip_epilogue = ctx->image + ctx->idx;
+		emit_addr_mov_i64(A64_R(0), (const u64)im, ctx);
+		emit_addr_mov_i64(A64_R(10), (const u64)__bpf_tramp_exit, ctx);
+		emit(A64_BLR(A64_R(10)), ctx);
+	}
+
+	/* restore x19 */
+	emit(A64_LDR64I(A64_R(19), A64_SP, regs_off), ctx);
+
+	if (save_ret)
+		emit(A64_LDR64I(A64_R(0), A64_SP, retval_off), ctx);
+
+	/* reset SP  */
+	emit(A64_MOV(1, A64_SP, A64_FP), ctx);
+
+	/* pop frames  */
+	emit(A64_POP(A64_FP, A64_LR, A64_SP), ctx);
+	emit(A64_POP(A64_FP, A64_R(9), A64_SP), ctx);
+
+	if (flags & BPF_TRAMP_F_SKIP_FRAME) {
+		/* skip patched function, return to parent */
+		emit(A64_MOV(1, A64_LR, A64_R(9)), ctx);
+		emit(A64_RET(A64_R(9)), ctx);
+	} else {
+		/* return to patched function */
+		emit(A64_MOV(1, A64_R(10), A64_LR), ctx);
+		emit(A64_MOV(1, A64_LR, A64_R(9)), ctx);
+		emit(A64_RET(A64_R(10)), ctx);
+	}
+
+	if (ctx->image)
+		bpf_flush_icache(ctx->image, ctx->image + ctx->idx);
+
+	kfree(branches);
+
+	return ctx->idx;
+}
+
+int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image,
+				void *image_end, const struct btf_func_model *m,
+				u32 flags, struct bpf_tramp_progs *tprogs,
+				void *orig_call)
+{
+	int ret;
+	int nargs = m->nr_args;
+	int max_insns = ((long)image_end - (long)image) / AARCH64_INSN_SIZE;
+	struct jit_ctx ctx = {
+		.image = NULL,
+		.idx = 0
+	};
+
+	/* we depends on ftrace to set return address and place nop */
+	if (!IS_ENABLED(CONFIG_DYNAMIC_FTRACE_WITH_REGS))
+		return -ENOTSUPP;
+
+	/* the first 8 arguments are passed by registers */
+	if (nargs > 8)
+		return -ENOTSUPP;
+
+	ret =  prepare_trampoline(&ctx, im, tprogs, orig_call, nargs, flags);
+	if (ret < 0)
+		return ret;
+
+	if (ret > max_insns)
+		return -EFBIG;
+
+	ctx.image = image;
+	ctx.idx = 0;
+
+	jit_fill_hole(image, (unsigned int)(image_end - image));
+	ret = prepare_trampoline(&ctx, im, tprogs, orig_call, nargs, flags);
+
+	if (ret > 0 && validate_code(&ctx) < 0)
+		ret = -EINVAL;
+
+	return ret;
+}
+
 static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
 			     void *addr, u32 *insn)
 {
-- 
2.30.2

