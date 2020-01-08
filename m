Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DDF133C35
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgAHHZy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 02:25:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726715AbgAHHZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 02:25:53 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0087PndX015493
        for <netdev@vger.kernel.org>; Tue, 7 Jan 2020 23:25:50 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd3ep1w2w-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 23:25:50 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 7 Jan 2020 23:25:49 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C5241760DB5; Tue,  7 Jan 2020 23:25:44 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/6] bpf: Introduce function-by-function verification
Date:   Tue, 7 Jan 2020 23:25:35 -0800
Message-ID: <20200108072538.3359838-4-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200108072538.3359838-1-ast@kernel.org>
References: <20200108072538.3359838-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_01:2020-01-07,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1034 impostorscore=0 mlxscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New llvm and old llvm with libbpf help produce BTF that distinguish global and
static functions. Unlike arguments of static function the arguments of global
functions cannot be removed or optimized away by llvm. The compiler has to use
exactly the arguments specified in a function prototype. The argument type
information allows the verifier validate each global function independently.
For now only supported argument types are pointer to context and scalars. In
the future pointers to structures, sizes, pointer to packet data can be
supported as well. Consider the following example:

static int f1(int ...)
{
  ...
}

int f3(int b);

int f2(int a)
{
  f1(a) + f3(a);
}

int f3(int b)
{
  ...
}

int main(...)
{
  f1(...) + f2(...) + f3(...);
}

The verifier will start its safety checks from the first global function f2().
It will recursively descend into f1() because it's static. Then it will check
that arguments match for the f3() invocation inside f2(). It will not descend
into f3(). It will finish f2() that has to be successfully verified for all
possible values of 'a'. Then it will proceed with f3(). That function also has
to be safe for all possible values of 'b'. Then it will start subprog 0 (which
is main() function). It will recursively descend into f1() and will skip full
check of f2() and f3(), since they are global. The order of processing global
functions doesn't affect safety, since all global functions must be proven safe
based on their arguments only.

Such function by function verification can drastically improve speed of the
verification and reduce complexity.

Note that the stack limit of 512 still applies to the call chain regardless whether
functions were static or global. The nested level of 8 also still applies. The
same recursion prevention checks are in place as well.

The type information and static/global kind is preserved after the verification
hence in the above example global function f2() and f3() can be replaced later
by equivalent functions with the same types that are loaded and verified later
without affecting safety of this main() program. Such replacement (re-linking)
of global functions is a subject of future patches.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h          |   7 +-
 include/linux/bpf_verifier.h |   7 +-
 include/uapi/linux/btf.h     |   6 +
 kernel/bpf/btf.c             | 147 +++++++++++++++++-----
 kernel/bpf/verifier.c        | 228 +++++++++++++++++++++++++++--------
 5 files changed, 317 insertions(+), 78 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b14e51d56a82..ceb5b6c13abc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -558,6 +558,7 @@ static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
 #endif
 
 struct bpf_func_info_aux {
+	u32 linkage;
 	bool unreliable;
 };
 
@@ -1006,7 +1007,11 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   const char *func_name,
 			   struct btf_func_model *m);
 
-int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog);
+struct bpf_reg_state;
+int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
+			     struct bpf_reg_state *regs);
+int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
+			  struct bpf_reg_state *reg);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
 
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 26e40de9ef55..b668d3ba2f11 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -304,11 +304,13 @@ struct bpf_insn_aux_data {
 	u64 map_key_state; /* constant (32 bit) key tracking for maps */
 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
 	int sanitize_stack_off; /* stack slot to be cleared */
-	bool seen; /* this insn was processed by the verifier */
+	u32 seen; /* this insn was processed by the verifier at env->pass_cnt */
 	bool zext_dst; /* this insn zero extends dst reg */
 	u8 alu_state; /* used in combination with alu_limit */
-	bool prune_point;
+
+	/* below fields are initialized once */
 	unsigned int orig_idx; /* original instruction index */
+	bool prune_point;
 };
 
 #define MAX_USED_MAPS 64 /* max number of maps accessed by one eBPF program */
@@ -379,6 +381,7 @@ struct bpf_verifier_env {
 		int *insn_stack;
 		int cur_stack;
 	} cfg;
+	u32 pass_cnt; /* number of times do_check() was called */
 	u32 subprog_cnt;
 	/* number of instructions analyzed by the verifier */
 	u32 prev_insn_processed, insn_processed;
diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index 1a2898c482ee..5a667107ad2c 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -146,6 +146,12 @@ enum {
 	BTF_VAR_GLOBAL_EXTERN = 2,
 };
 
+enum btf_func_linkage {
+	BTF_FUNC_STATIC = 0,
+	BTF_FUNC_GLOBAL = 1,
+	BTF_FUNC_EXTERN = 2,
+};
+
 /* BTF_KIND_VAR is followed by a single "struct btf_var" to describe
  * additional information related to the variable such as its linkage.
  */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ed2075884724..e28ec89971ce 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2621,8 +2621,8 @@ static s32 btf_func_check_meta(struct btf_verifier_env *env,
 		return -EINVAL;
 	}
 
-	if (btf_type_vlen(t)) {
-		btf_verifier_log_type(env, t, "vlen != 0");
+	if (btf_type_vlen(t) > BTF_FUNC_EXTERN) {
+		btf_verifier_log_type(env, t, "invalid func linkage");
 		return -EINVAL;
 	}
 
@@ -3476,7 +3476,8 @@ static u8 bpf_ctx_convert_map[] = {
 
 static const struct btf_member *
 btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
-		      const struct btf_type *t, enum bpf_prog_type prog_type)
+		      const struct btf_type *t, enum bpf_prog_type prog_type,
+		      int arg)
 {
 	const struct btf_type *conv_struct;
 	const struct btf_type *ctx_struct;
@@ -3497,12 +3498,13 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
 		 * is not supported yet.
 		 * BPF_PROG_TYPE_RAW_TRACEPOINT is fine.
 		 */
-		bpf_log(log, "BPF program ctx type is not a struct\n");
+		if (log->level & BPF_LOG_LEVEL)
+			bpf_log(log, "arg#%d type is not a struct\n", arg);
 		return NULL;
 	}
 	tname = btf_name_by_offset(btf, t->name_off);
 	if (!tname) {
-		bpf_log(log, "BPF program ctx struct doesn't have a name\n");
+		bpf_log(log, "arg#%d struct doesn't have a name\n", arg);
 		return NULL;
 	}
 	/* prog_type is valid bpf program type. No need for bounds check. */
@@ -3535,11 +3537,12 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
 static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
 				     struct btf *btf,
 				     const struct btf_type *t,
-				     enum bpf_prog_type prog_type)
+				     enum bpf_prog_type prog_type,
+				     int arg)
 {
 	const struct btf_member *prog_ctx_type, *kern_ctx_type;
 
-	prog_ctx_type = btf_get_prog_ctx_type(log, btf, t, prog_type);
+	prog_ctx_type = btf_get_prog_ctx_type(log, btf, t, prog_type, arg);
 	if (!prog_ctx_type)
 		return -ENOENT;
 	kern_ctx_type = prog_ctx_type + 1;
@@ -3700,7 +3703,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	info->btf_id = t->type;
 
 	if (tgt_prog) {
-		ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type);
+		ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
 		if (ret > 0) {
 			info->btf_id = ret;
 			return true;
@@ -4043,11 +4046,10 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 	return 0;
 }
 
-int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog)
+/* Compare BTF of a function with given bpf_reg_state */
+int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
+			     struct bpf_reg_state *reg)
 {
-	struct bpf_verifier_state *st = env->cur_state;
-	struct bpf_func_state *func = st->frame[st->curframe];
-	struct bpf_reg_state *reg = func->regs;
 	struct bpf_verifier_log *log = &env->log;
 	struct bpf_prog *prog = env->prog;
 	struct btf *btf = prog->aux->btf;
@@ -4057,27 +4059,27 @@ int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog)
 	const char *tname;
 
 	if (!prog->aux->func_info)
-		return 0;
+		return -EINVAL;
 
 	btf_id = prog->aux->func_info[subprog].type_id;
 	if (!btf_id)
-		return 0;
+		return -EINVAL;
 
 	if (prog->aux->func_info_aux[subprog].unreliable)
-		return 0;
+		return -EINVAL;
 
 	t = btf_type_by_id(btf, btf_id);
 	if (!t || !btf_type_is_func(t)) {
-		bpf_log(log, "BTF of subprog %d doesn't point to KIND_FUNC\n",
+		bpf_log(log, "BTF of func#%d doesn't point to KIND_FUNC\n",
 			subprog);
-		return -EINVAL;
+		return -EFAULT;
 	}
 	tname = btf_name_by_offset(btf, t->name_off);
 
 	t = btf_type_by_id(btf, t->type);
 	if (!t || !btf_type_is_func_proto(t)) {
 		bpf_log(log, "Invalid type of func %s\n", tname);
-		return -EINVAL;
+		return -EFAULT;
 	}
 	args = (const struct btf_param *)(t + 1);
 	nargs = btf_type_vlen(t);
@@ -4103,25 +4105,116 @@ int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog)
 				bpf_log(log, "R%d is not a pointer\n", i + 1);
 				goto out;
 			}
-			/* If program is passing PTR_TO_CTX into subprogram
-			 * check that BTF type matches.
+			/* If function expects ctx type in BTF check that callee
+			 * is passing PTR_TO_CTX.
 			 */
-			if (reg[i + 1].type == PTR_TO_CTX &&
-			    !btf_get_prog_ctx_type(log, btf, t, prog->type))
+			if (btf_get_prog_ctx_type(log, btf, t, prog->type, i) &&
+			    reg[i + 1].type != PTR_TO_CTX) {
+				bpf_log(log,
+					"arg#%d expected pointer to ctx, but got %s\n",
+					i, btf_kind_str[BTF_INFO_KIND(t->info)]);
 				goto out;
+			}
 			/* All other pointers are ok */
 			continue;
 		}
-		bpf_log(log, "Unrecognized argument type %s\n",
-			btf_kind_str[BTF_INFO_KIND(t->info)]);
+		bpf_log(log, "Unrecognized arg#%d type %s\n",
+			i, btf_kind_str[BTF_INFO_KIND(t->info)]);
 		goto out;
 	}
 	return 0;
 out:
-	/* LLVM optimizations can remove arguments from static functions. */
-	bpf_log(log,
-		"Type info disagrees with actual arguments due to compiler optimizations\n");
+	/* LLVM optimizations can remove arguments from static functions
+	 * or mismatched type can be passed into a global function.
+	 * In such cases mark the function as unreliable from BTF point of view.
+	 */
 	prog->aux->func_info_aux[subprog].unreliable = true;
+	return -EINVAL;
+}
+
+/* Convert BTF of a function into bpf_reg_state if possible */
+int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
+			  struct bpf_reg_state *reg)
+{
+	struct bpf_verifier_log *log = &env->log;
+	struct bpf_prog *prog = env->prog;
+	struct btf *btf = prog->aux->btf;
+	const struct btf_param *args;
+	const struct btf_type *t;
+	u32 i, nargs, btf_id;
+	const char *tname;
+
+	if (!prog->aux->func_info ||
+	    prog->aux->func_info_aux[subprog].linkage != BTF_FUNC_GLOBAL) {
+		bpf_log(log, "Verifier bug\n");
+		return -EFAULT;
+	}
+
+	btf_id = prog->aux->func_info[subprog].type_id;
+	if (!btf_id) {
+		bpf_log(log, "Global functions need valid BTF\n");
+		return -EINVAL;
+	}
+
+	t = btf_type_by_id(btf, btf_id);
+	if (!t || !btf_type_is_func(t)) {
+		bpf_log(log, "BTF of func#%d doesn't point to KIND_FUNC\n",
+			subprog);
+		return -EINVAL;
+	}
+	tname = btf_name_by_offset(btf, t->name_off);
+
+	if (log->level & BPF_LOG_LEVEL)
+		bpf_log(log, "Validating %s() func#%d...\n",
+			tname, subprog);
+
+	if (prog->aux->func_info_aux[subprog].unreliable) {
+		bpf_log(log, "Verifier bug in function %s()\n", tname);
+		return -EFAULT;
+	}
+
+	t = btf_type_by_id(btf, t->type);
+	if (!t || !btf_type_is_func_proto(t)) {
+		bpf_log(log, "Invalid type of function %s()\n", tname);
+		return -EINVAL;
+	}
+	args = (const struct btf_param *)(t + 1);
+	nargs = btf_type_vlen(t);
+	if (nargs > 5) {
+		bpf_log(log, "Global function %s() with %d > 5 args. Buggy llvm.\n",
+			tname, nargs);
+		return -EINVAL;
+	}
+	/* check that function returns int */
+	t = btf_type_by_id(btf, t->type);
+	while (btf_type_is_modifier(t))
+		t = btf_type_by_id(btf, t->type);
+	if (!btf_type_is_int(t) && !btf_type_is_enum(t)) {
+		bpf_log(log,
+			"Global function %s() doesn't return scalar. Only those are supported.\n",
+			tname);
+		return -EINVAL;
+	}
+	/* Convert BTF function arguments into verifier types.
+	 * Only PTR_TO_CTX and SCALAR are supported atm.
+	 */
+	for (i = 0; i < nargs; i++) {
+		t = btf_type_by_id(btf, args[i].type);
+		while (btf_type_is_modifier(t))
+			t = btf_type_by_id(btf, t->type);
+		if (btf_type_is_int(t) || btf_type_is_enum(t)) {
+			reg[i + 1].type = SCALAR_VALUE;
+			continue;
+		}
+		if (btf_type_is_ptr(t) &&
+		    btf_get_prog_ctx_type(log, btf, t, prog->type, i)) {
+			reg[i + 1].type = PTR_TO_CTX;
+			continue;
+		}
+		bpf_log(log, "Arg#%d type %s in %s() is not supported yet.\n",
+			i, btf_kind_str[BTF_INFO_KIND(t->info)], tname);
+		return -EINVAL;
+	}
 	return 0;
 }
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6f63ae7a370c..3abb5bcc5cd9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1122,10 +1122,6 @@ static void init_reg_state(struct bpf_verifier_env *env,
 	regs[BPF_REG_FP].type = PTR_TO_STACK;
 	mark_reg_known_zero(env, regs, BPF_REG_FP);
 	regs[BPF_REG_FP].frameno = state->frameno;
-
-	/* 1st arg to a function */
-	regs[BPF_REG_1].type = PTR_TO_CTX;
-	mark_reg_known_zero(env, regs, BPF_REG_1);
 }
 
 #define BPF_MAIN_FUNC (-1)
@@ -3945,12 +3941,26 @@ static int release_reference(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static void clear_caller_saved_regs(struct bpf_verifier_env *env,
+				    struct bpf_reg_state *regs)
+{
+	int i;
+
+	/* after the call registers r0 - r5 were scratched */
+	for (i = 0; i < CALLER_SAVED_REGS; i++) {
+		mark_reg_not_init(env, regs, caller_saved[i]);
+		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
+	}
+}
+
 static int check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			   int *insn_idx)
 {
 	struct bpf_verifier_state *state = env->cur_state;
+	struct bpf_func_info_aux *func_info_aux;
 	struct bpf_func_state *caller, *callee;
 	int i, err, subprog, target_insn;
+	bool is_global = false;
 
 	if (state->curframe + 1 >= MAX_CALL_FRAMES) {
 		verbose(env, "the call stack of %d frames is too deep\n",
@@ -3973,6 +3983,32 @@ static int check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EFAULT;
 	}
 
+	func_info_aux = env->prog->aux->func_info_aux;
+	if (func_info_aux)
+		is_global = func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
+	err = btf_check_func_arg_match(env, subprog, caller->regs);
+	if (err == -EFAULT)
+		return err;
+	if (is_global) {
+		if (err) {
+			verbose(env, "Caller passes invalid args into func#%d\n",
+				subprog);
+			return err;
+		} else {
+			if (env->log.level & BPF_LOG_LEVEL)
+				verbose(env,
+					"Func#%d is global and valid. Skipping.\n",
+					subprog);
+			clear_caller_saved_regs(env, caller->regs);
+
+			/* All global functions return SCALAR_VALUE */
+			mark_reg_unknown(env, caller->regs, BPF_REG_0);
+
+			/* continue with next insn after call */
+			return 0;
+		}
+	}
+
 	callee = kzalloc(sizeof(*callee), GFP_KERNEL);
 	if (!callee)
 		return -ENOMEM;
@@ -3999,18 +4035,11 @@ static int check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	for (i = BPF_REG_1; i <= BPF_REG_5; i++)
 		callee->regs[i] = caller->regs[i];
 
-	/* after the call registers r0 - r5 were scratched */
-	for (i = 0; i < CALLER_SAVED_REGS; i++) {
-		mark_reg_not_init(env, caller->regs, caller_saved[i]);
-		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
-	}
+	clear_caller_saved_regs(env, caller->regs);
 
 	/* only increment it after check_reg_arg() finished */
 	state->curframe++;
 
-	if (btf_check_func_arg_match(env, subprog))
-		return -EINVAL;
-
 	/* and go analyze first insn of the callee */
 	*insn_idx = target_insn;
 
@@ -6738,12 +6767,13 @@ static int check_btf_func(struct bpf_verifier_env *env,
 
 		/* check type_id */
 		type = btf_type_by_id(btf, krecord[i].type_id);
-		if (!type || BTF_INFO_KIND(type->info) != BTF_KIND_FUNC) {
+		if (!type || !btf_type_is_func(type)) {
 			verbose(env, "invalid type id %d in func info",
 				krecord[i].type_id);
 			ret = -EINVAL;
 			goto err_free;
 		}
+		info_aux[i].linkage = BTF_INFO_VLEN(type->info);
 		prev_offset = krecord[i].insn_off;
 		urecord += urec_size;
 	}
@@ -7723,35 +7753,13 @@ static bool reg_type_mismatch(enum bpf_reg_type src, enum bpf_reg_type prev)
 
 static int do_check(struct bpf_verifier_env *env)
 {
-	struct bpf_verifier_state *state;
+	struct bpf_verifier_state *state = env->cur_state;
 	struct bpf_insn *insns = env->prog->insnsi;
 	struct bpf_reg_state *regs;
 	int insn_cnt = env->prog->len;
 	bool do_print_state = false;
 	int prev_insn_idx = -1;
 
-	env->prev_linfo = NULL;
-
-	state = kzalloc(sizeof(struct bpf_verifier_state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-	state->curframe = 0;
-	state->speculative = false;
-	state->branches = 1;
-	state->frame[0] = kzalloc(sizeof(struct bpf_func_state), GFP_KERNEL);
-	if (!state->frame[0]) {
-		kfree(state);
-		return -ENOMEM;
-	}
-	env->cur_state = state;
-	init_func_state(env, state->frame[0],
-			BPF_MAIN_FUNC /* callsite */,
-			0 /* frameno */,
-			0 /* subprogno, zero == main subprog */);
-
-	if (btf_check_func_arg_match(env, 0))
-		return -EINVAL;
-
 	for (;;) {
 		struct bpf_insn *insn;
 		u8 class;
@@ -7829,7 +7837,7 @@ static int do_check(struct bpf_verifier_env *env)
 		}
 
 		regs = cur_regs(env);
-		env->insn_aux_data[env->insn_idx].seen = true;
+		env->insn_aux_data[env->insn_idx].seen = env->pass_cnt;
 		prev_insn_idx = env->insn_idx;
 
 		if (class == BPF_ALU || class == BPF_ALU64) {
@@ -8064,7 +8072,7 @@ static int do_check(struct bpf_verifier_env *env)
 					return err;
 
 				env->insn_idx++;
-				env->insn_aux_data[env->insn_idx].seen = true;
+				env->insn_aux_data[env->insn_idx].seen = env->pass_cnt;
 			} else {
 				verbose(env, "invalid BPF_LD mode\n");
 				return -EINVAL;
@@ -8077,7 +8085,6 @@ static int do_check(struct bpf_verifier_env *env)
 		env->insn_idx++;
 	}
 
-	env->prog->aux->stack_depth = env->subprog_info[0].stack_depth;
 	return 0;
 }
 
@@ -8349,7 +8356,7 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
 	for (i = off; i < off + cnt - 1; i++) {
-		new_data[i].seen = true;
+		new_data[i].seen = env->pass_cnt;
 		new_data[i].zext_dst = insn_has_def32(env, insn + i);
 	}
 	env->insn_aux_data = new_data;
@@ -9459,6 +9466,7 @@ static void free_states(struct bpf_verifier_env *env)
 		kfree(sl);
 		sl = sln;
 	}
+	env->free_list = NULL;
 
 	if (!env->explored_states)
 		return;
@@ -9472,11 +9480,139 @@ static void free_states(struct bpf_verifier_env *env)
 			kfree(sl);
 			sl = sln;
 		}
+		env->explored_states[i] = NULL;
 	}
+}
 
-	kvfree(env->explored_states);
+static void sanitize_insn_aux_data(struct bpf_verifier_env *env)
+{
+	struct bpf_insn *insn = env->prog->insnsi;
+	struct bpf_insn_aux_data *aux;
+	int i, class;
+
+	for (i = 0; i < env->prog->len; i++) {
+		class = BPF_CLASS(insn[i].code);
+		if (class != BPF_LDX && class != BPF_STX)
+			continue;
+		aux = &env->insn_aux_data[i];
+		if (aux->seen != env->pass_cnt)
+			continue;
+		memset(aux, 0, offsetof(typeof(*aux), orig_idx));
+	}
 }
 
+static int do_check_common(struct bpf_verifier_env *env, int subprog)
+{
+	struct bpf_verifier_state *state;
+	struct bpf_reg_state *regs;
+	int ret, i;
+
+	env->prev_linfo = NULL;
+	env->pass_cnt++;
+
+	state = kzalloc(sizeof(struct bpf_verifier_state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+	state->curframe = 0;
+	state->speculative = false;
+	state->branches = 1;
+	state->frame[0] = kzalloc(sizeof(struct bpf_func_state), GFP_KERNEL);
+	if (!state->frame[0]) {
+		kfree(state);
+		return -ENOMEM;
+	}
+	env->cur_state = state;
+	init_func_state(env, state->frame[0],
+			BPF_MAIN_FUNC /* callsite */,
+			0 /* frameno */,
+			subprog);
+
+	regs = state->frame[state->curframe]->regs;
+	if (subprog) {
+		ret = btf_prepare_func_args(env, subprog, regs);
+		if (ret)
+			return ret;
+		for (i = BPF_REG_1; i <= BPF_REG_5; i++) {
+			if (regs[i].type == PTR_TO_CTX)
+				mark_reg_known_zero(env, regs, i);
+			else if (regs[i].type == SCALAR_VALUE)
+				mark_reg_unknown(env, regs, i);
+		}
+	} else {
+		/* 1st arg to a function */
+		regs[BPF_REG_1].type = PTR_TO_CTX;
+		mark_reg_known_zero(env, regs, BPF_REG_1);
+		if (btf_check_func_arg_match(env, subprog, regs) == -EFAULT)
+			return -EFAULT;
+	}
+
+	ret = do_check(env);
+	if (env->cur_state) {
+		free_verifier_state(env->cur_state, true);
+		env->cur_state = NULL;
+	}
+	while (!pop_stack(env, NULL, NULL));
+	free_states(env);
+	if (ret)
+		/* clean aux data in case subprog was rejected */
+		sanitize_insn_aux_data(env);
+	return ret;
+}
+
+/* Verify all global functions in a BPF program one by one based on their BTF.
+ * All global functions must pass verification. Otherwise the whole program is rejected.
+ * Consider:
+ * int bar(int);
+ * int foo(int f)
+ * {
+ *    return bar(f);
+ * }
+ * int bar(int b)
+ * {
+ *    ...
+ * }
+ * foo() will be verified first for R1=any_scalar_value. During verification it
+ * will be assumed that bar() already verified successfully and call to bar()
+ * from foo() will be checked for type match only. Later bar() will be verified
+ * independently to check that it's safe for R1=any_scalar_value.
+ */
+static int do_check_subprogs(struct bpf_verifier_env *env)
+{
+	struct bpf_prog_aux *aux = env->prog->aux;
+	int i, ret;
+
+	if (!aux->func_info)
+		return 0;
+
+	for (i = 1; i < env->subprog_cnt; i++) {
+		if (aux->func_info_aux[i].linkage != BTF_FUNC_GLOBAL)
+			continue;
+		env->insn_idx = env->subprog_info[i].start;
+		WARN_ON_ONCE(env->insn_idx == 0);
+		ret = do_check_common(env, i);
+		if (ret) {
+			return ret;
+		} else if (env->log.level & BPF_LOG_LEVEL) {
+			verbose(env,
+				"Func#%d is safe for any args that match its prototype\n",
+				i);
+		}
+	}
+	return 0;
+}
+
+static int do_check_main(struct bpf_verifier_env *env)
+{
+	int ret;
+
+	env->insn_idx = 0;
+	ret = do_check_common(env, 0);
+	if (!ret)
+		env->prog->aux->stack_depth = env->subprog_info[0].stack_depth;
+	return ret;
+}
+
+
 static void print_verification_stats(struct bpf_verifier_env *env)
 {
 	int i;
@@ -9769,18 +9905,14 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret < 0)
 		goto skip_full_check;
 
-	ret = do_check(env);
-	if (env->cur_state) {
-		free_verifier_state(env->cur_state, true);
-		env->cur_state = NULL;
-	}
+	ret = do_check_subprogs(env);
+	ret = ret ?: do_check_main(env);
 
 	if (ret == 0 && bpf_prog_is_dev_bound(env->prog->aux))
 		ret = bpf_prog_offload_finalize(env);
 
 skip_full_check:
-	while (!pop_stack(env, NULL, NULL));
-	free_states(env);
+	kvfree(env->explored_states);
 
 	if (ret == 0)
 		ret = check_max_stack_depth(env);
-- 
2.23.0

