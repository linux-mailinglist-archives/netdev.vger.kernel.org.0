Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9801C529A7F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbiEQHIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241024AbiEQHIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:08:14 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AE748311;
        Tue, 17 May 2022 00:07:53 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L2RxM09VFz1JCK3;
        Tue, 17 May 2022 15:06:31 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 17 May
 2022 15:07:49 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH bpf-next v4 5/6] bpf, arm64: bpf trampoline for arm64
Date:   Tue, 17 May 2022 03:18:37 -0400
Message-ID: <20220517071838.3366093-6-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220517071838.3366093-1-xukuohai@huawei.com>
References: <20220517071838.3366093-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf trampoline support for arm64. Most of the logic is the same as
x86.

Tested on raspberry pi 4b and qemu with KASLR disabled (avoid long jump),
result:
 #9  /1     bpf_cookie/kprobe:OK
 #9  /2     bpf_cookie/multi_kprobe_link_api:FAIL
 #9  /3     bpf_cookie/multi_kprobe_attach_api:FAIL
 #9  /4     bpf_cookie/uprobe:OK
 #9  /5     bpf_cookie/tracepoint:OK
 #9  /6     bpf_cookie/perf_event:OK
 #9  /7     bpf_cookie/trampoline:OK
 #9  /8     bpf_cookie/lsm:OK
 #9         bpf_cookie:FAIL
 #18 /1     bpf_tcp_ca/dctcp:OK
 #18 /2     bpf_tcp_ca/cubic:OK
 #18 /3     bpf_tcp_ca/invalid_license:OK
 #18 /4     bpf_tcp_ca/dctcp_fallback:OK
 #18 /5     bpf_tcp_ca/rel_setsockopt:OK
 #18        bpf_tcp_ca:OK
 #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
 #51 /2     dummy_st_ops/dummy_init_ret_value:OK
 #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
 #51 /4     dummy_st_ops/dummy_multiple_args:OK
 #51        dummy_st_ops:OK
 #55        fentry_fexit:OK
 #56        fentry_test:OK
 #57 /1     fexit_bpf2bpf/target_no_callees:OK
 #57 /2     fexit_bpf2bpf/target_yes_callees:OK
 #57 /3     fexit_bpf2bpf/func_replace:OK
 #57 /4     fexit_bpf2bpf/func_replace_verify:OK
 #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
 #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
 #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
 #57 /8     fexit_bpf2bpf/func_replace_multi:OK
 #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
 #57        fexit_bpf2bpf:OK
 #58        fexit_sleep:OK
 #59        fexit_stress:OK
 #60        fexit_test:OK
 #67        get_func_args_test:OK
 #68        get_func_ip_test:OK
 #104       modify_return:OK
 #237       xdp_bpf2bpf:OK

bpf_cookie/multi_kprobe_link_api and bpf_cookie/multi_kprobe_attach_api
failed due to lack of multi_kprobe on arm64.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 arch/arm64/net/bpf_jit_comp.c | 420 +++++++++++++++++++++++++++++++++-
 1 file changed, 413 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 5ce6ed5f42a1..59cb96dc4335 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -142,6 +142,12 @@ static inline void emit_a64_mov_i64(const int reg, const u64 val,
 	}
 }
 
+static inline void emit_bti(u32 insn, struct jit_ctx *ctx)
+{
+	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
+		emit(insn, ctx);
+}
+
 /*
  * Kernel addresses in the vmalloc space use at most 48 bits, and the
  * remaining bits are guaranteed to be 0x1. So we can compose the address
@@ -161,6 +167,14 @@ static inline void emit_addr_mov_i64(const int reg, const u64 val,
 	}
 }
 
+static inline void emit_call(u64 target, struct jit_ctx *ctx)
+{
+	u8 tmp = bpf2a64[TMP_REG_1];
+
+	emit_addr_mov_i64(tmp, target, ctx);
+	emit(A64_BLR(tmp), ctx);
+}
+
 static inline int bpf2a64_offset(int bpf_insn, int off,
 				 const struct jit_ctx *ctx)
 {
@@ -281,8 +295,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 	 *
 	 */
 
-	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
-		emit(A64_BTI_C, ctx);
+	emit_bti(A64_BTI_C, ctx);
 
 	emit(A64_MOV(1, A64_R(9), A64_LR), ctx);
 	emit(A64_NOP, ctx);
@@ -316,8 +329,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 		}
 
 		/* BTI landing pad for the tail call, done with a BR */
-		if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
-			emit(A64_BTI_J, ctx);
+		emit_bti(A64_BTI_J, ctx);
 	}
 
 	emit(A64_SUB_I(1, fpb, fp, ctx->fpb_offset), ctx);
@@ -995,8 +1007,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 					    &func_addr, &func_addr_fixed);
 		if (ret < 0)
 			return ret;
-		emit_addr_mov_i64(tmp, func_addr, ctx);
-		emit(A64_BLR(tmp), ctx);
+		emit_call(func_addr, ctx);
 		emit(A64_MOV(1, r0, A64_R(0)), ctx);
 		break;
 	}
@@ -1340,6 +1351,13 @@ static int validate_code(struct jit_ctx *ctx)
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
@@ -1464,7 +1482,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	build_epilogue(&ctx);
 
 	/* 3. Extra pass to validate JITed code. */
-	if (validate_code(&ctx)) {
+	if (validate_ctx(&ctx)) {
 		bpf_jit_binary_free(header);
 		prog = orig_prog;
 		goto out_off;
@@ -1535,6 +1553,394 @@ void bpf_jit_free_exec(void *addr)
 	return vfree(addr);
 }
 
+static void invoke_bpf_prog(struct jit_ctx *ctx, struct bpf_tramp_link *l,
+			    int args_off, int retval_off, int run_ctx_off,
+			    bool save_ret)
+{
+	u32 *branch;
+	u64 enter_prog;
+	u64 exit_prog;
+	u8 tmp = bpf2a64[TMP_REG_1];
+	u8 r0 = bpf2a64[BPF_REG_0];
+	struct bpf_prog *p = l->link.prog;
+	int cookie_off = offsetof(struct bpf_tramp_run_ctx, bpf_cookie);
+
+	if (p->aux->sleepable) {
+		enter_prog = (u64)__bpf_prog_enter_sleepable;
+		exit_prog = (u64)__bpf_prog_exit_sleepable;
+	} else {
+		enter_prog = (u64)__bpf_prog_enter;
+		exit_prog = (u64)__bpf_prog_exit;
+	}
+
+	if (l->cookie == 0) {
+		/* if cookie is zero, one instruction is enough to store it */
+		emit(A64_STR64I(A64_ZR, A64_SP, run_ctx_off + cookie_off), ctx);
+	} else {
+		emit_a64_mov_i64(tmp, l->cookie, ctx);
+		emit(A64_STR64I(tmp, A64_SP, run_ctx_off + cookie_off), ctx);
+	}
+
+	/* save p to callee saved register x19 to avoid loading p with mov_i64
+	 * each time.
+	 */
+	emit_addr_mov_i64(A64_R(19), (const u64)p, ctx);
+
+	/* arg1: prog */
+	emit(A64_MOV(1, A64_R(0), A64_R(19)), ctx);
+	/* arg2: &run_ctx */
+	emit(A64_ADD_I(1, A64_R(1), A64_SP, run_ctx_off), ctx);
+
+	emit_call(enter_prog, ctx);
+
+	/* if (__bpf_prog_enter(prog) == 0)
+	 *         goto skip_exec_of_prog;
+	 */
+	branch = ctx->image + ctx->idx;
+	emit(A64_NOP, ctx);
+
+	/* save return value to callee saved register x20 */
+	emit(A64_MOV(1, A64_R(20), r0), ctx);
+
+	emit(A64_ADD_I(1, A64_R(0), A64_SP, args_off), ctx);
+	if (!p->jited)
+		emit_addr_mov_i64(A64_R(1), (const u64)p->insnsi, ctx);
+
+	emit_call((const u64)p->bpf_func, ctx);
+
+	/* store return value */
+	if (save_ret)
+		emit(A64_STR64I(r0, A64_SP, retval_off), ctx);
+
+	if (ctx->image) {
+		int offset = &ctx->image[ctx->idx] - branch;
+		*branch = A64_CBZ(1, A64_R(0), offset);
+	}
+	emit_bti(A64_BTI_J, ctx);
+
+	/* arg1: prog */
+	emit(A64_MOV(1, A64_R(0), A64_R(19)), ctx);
+	/* arg2: start time */
+	emit(A64_MOV(1, A64_R(1), A64_R(20)), ctx);
+	/* arg3: &run_ctx */
+	emit(A64_ADD_I(1, A64_R(2), A64_SP, run_ctx_off), ctx);
+
+	emit_call(exit_prog, ctx);
+}
+
+static void invoke_bpf_mod_ret(struct jit_ctx *ctx, struct bpf_tramp_links *tl,
+			       int args_off, int retval_off, int run_ctx_off,
+			       u32 **branches)
+{
+	int i;
+
+	/* The first fmod_ret program will receive a garbage return value.
+	 * Set this to 0 to avoid confusing the program.
+	 */
+	emit(A64_STR64I(A64_ZR, A64_SP, retval_off), ctx);
+	for (i = 0; i < tl->nr_links; i++) {
+		invoke_bpf_prog(ctx, tl->links[i], args_off, retval_off,
+				run_ctx_off, true);
+		/* if (*(u64 *)(sp + retval_off) !=  0)
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
+/* Based on the x86's implementation of arch_prepare_bpf_trampoline().
+ *
+ * bpf prog and function entry before bpf trampoline hooked:
+ *   mov x9, x30
+ *   nop
+ *
+ * bpf prog and function entry after bpf trampoline hooked:
+ *   mov x9, x30
+ *   bl  <bpf_trampoline>
+ *
+ */
+static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
+			      struct bpf_tramp_links *tlinks, void *orig_call,
+			      int nargs, u32 flags)
+{
+	int i;
+	int stack_size;
+	int retaddr_off;
+	int regs_off;
+	int retval_off;
+	int args_off;
+	int nargs_off;
+	int ip_off;
+	int run_ctx_off;
+	struct bpf_tramp_links *fentry = &tlinks[BPF_TRAMP_FENTRY];
+	struct bpf_tramp_links *fexit = &tlinks[BPF_TRAMP_FEXIT];
+	struct bpf_tramp_links *fmod_ret = &tlinks[BPF_TRAMP_MODIFY_RETURN];
+	bool save_ret;
+	u32 **branches = NULL;
+
+	/* trampoline stack layout:
+	 *                  [ parent ip         ]
+	 *                  [ FP                ]
+	 * SP + retaddr_off [ self ip           ]
+	 *                  [ FP                ]
+	 *
+	 *                  [ padding           ] align SP to multiples of 16
+	 *
+	 *                  [ x20               ] callee saved reg x20
+	 * sp + regs_off    [ x19               ] callee saved reg x19
+	 *
+	 * SP + retval_off  [ return value      ] BPF_TRAMP_F_CALL_ORIG or
+	 *                                        BPF_TRAMP_F_RET_FENTRY_RET
+	 *
+	 *                  [ argN              ]
+	 *                  [ ...               ]
+	 * sp + args_off    [ arg1              ]
+	 *
+	 * SP + nargs_off   [ args count        ]
+	 *
+	 * SP + ip_off      [ traced function   ] BPF_TRAMP_F_IP_ARG flag
+	 *
+	 * SP + run_ctx_off [ bpf_tramp_run_ctx ]
+	 */
+
+	stack_size = 0;
+	run_ctx_off = stack_size;
+	/* room for bpf_tramp_run_ctx */
+	stack_size += round_up(sizeof(struct bpf_tramp_run_ctx), 8);
+
+	ip_off = stack_size;
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
+	/* room for callee saved registers, currently x19 and x20 are used */
+	regs_off = stack_size;
+	stack_size += 16;
+
+	/* round up to multiples of 16 to avoid SPAlignmentFault */
+	stack_size = round_up(stack_size, 16);
+
+	/* return address locates above FP */
+	retaddr_off = stack_size + 8;
+
+	emit_bti(A64_BTI_C, ctx);
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
+		emit(A64_STR64I(A64_R(10), A64_SP, ip_off), ctx);
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
+	emit(A64_STR64I(A64_R(20), A64_SP, regs_off + 8), ctx);
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		emit_addr_mov_i64(A64_R(0), (const u64)im, ctx);
+		emit_call((const u64)__bpf_tramp_enter, ctx);
+	}
+
+	for (i = 0; i < fentry->nr_links; i++)
+		invoke_bpf_prog(ctx, fentry->links[i], args_off,
+				retval_off, run_ctx_off,
+				flags & BPF_TRAMP_F_RET_FENTRY_RET);
+
+	if (fmod_ret->nr_links) {
+		branches = kcalloc(fmod_ret->nr_links, sizeof(u32 *),
+				   GFP_KERNEL);
+		if (!branches)
+			return -ENOMEM;
+
+		invoke_bpf_mod_ret(ctx, fmod_ret, args_off, retval_off,
+				   run_ctx_off, branches);
+	}
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		restore_args(ctx, args_off, nargs);
+		/* call original func */
+		emit(A64_LDR64I(A64_R(10), A64_SP, retaddr_off), ctx);
+		emit(A64_BLR(A64_R(10)), ctx);
+		/* store return value */
+		emit(A64_STR64I(A64_R(0), A64_SP, retval_off), ctx);
+		/* reserve a nop for bpf_tramp_image_put */
+		im->ip_after_call = ctx->image + ctx->idx;
+		emit(A64_NOP, ctx);
+	}
+
+	/* update the branches saved in invoke_bpf_mod_ret with cbnz */
+	for (i = 0; i < fmod_ret->nr_links && ctx->image != NULL; i++) {
+		int offset = &ctx->image[ctx->idx] - branches[i];
+		*branches[i] = A64_CBNZ(1, A64_R(10), offset);
+	}
+
+	if (fmod_ret->nr_links)
+		emit_bti(A64_BTI_J, ctx);
+
+	for (i = 0; i < fexit->nr_links; i++)
+		invoke_bpf_prog(ctx, fexit->links[i], args_off, retval_off,
+				run_ctx_off, false);
+
+	if (flags & BPF_TRAMP_F_RESTORE_REGS)
+		restore_args(ctx, args_off, nargs);
+
+	if (flags & BPF_TRAMP_F_CALL_ORIG) {
+		im->ip_epilogue = ctx->image + ctx->idx;
+		emit_bti(A64_BTI_J, ctx);
+		emit_addr_mov_i64(A64_R(0), (const u64)im, ctx);
+		emit_call((const u64)__bpf_tramp_exit, ctx);
+	}
+
+	/* restore callee saved register x19 and x20 */
+	emit(A64_LDR64I(A64_R(19), A64_SP, regs_off), ctx);
+	emit(A64_LDR64I(A64_R(20), A64_SP, regs_off + 8), ctx);
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
+static inline bool is_long_jump(void *ip, void *target)
+{
+	long offset;
+
+	/* when ip == NULL, the trampoline address is used by bpf_struct_ops
+	 * as a normal kernel function pointer, which can be always jumped to,
+	 * so don't treat it as a long jump.
+	 */
+	if (ip == NULL)
+		return false;
+
+	offset = (long)target - (long)ip;
+	return offset < -SZ_128M || offset >= SZ_128M;
+}
+
+int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image,
+				void *image_end, const struct btf_func_model *m,
+				u32 flags, struct bpf_tramp_links *tlinks,
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
+	/* Return error since the long jump is not implemented. Otherwise,
+	 * ftrace_bug will be triggered when the fentry is patched by ftrace,
+	 * making ftrace no longer work properly.
+	 */
+	if (is_long_jump(orig_call, image))
+		return -ENOTSUPP;
+
+	/* the first 8 arguments are passed by registers */
+	if (nargs > 8)
+		return -ENOTSUPP;
+
+	ret = prepare_trampoline(&ctx, im, tlinks, orig_call, nargs, flags);
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
+	ret = prepare_trampoline(&ctx, im, tlinks, orig_call, nargs, flags);
+
+	if (ret > 0 && validate_code(&ctx) < 0)
+		ret = -EINVAL;
+
+	if (ret > 0)
+		ret *= AARCH64_INSN_SIZE;
+
+	return ret;
+}
+
 static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
 			     void *addr, u32 *insn)
 {
-- 
2.30.2

