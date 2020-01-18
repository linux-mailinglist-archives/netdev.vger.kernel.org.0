Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB314150D
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 01:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgARAHN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jan 2020 19:07:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15094 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730232AbgARAHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 19:07:12 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00HNt6D1016162
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 16:07:09 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xk0s1ndrb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 16:07:09 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 17 Jan 2020 16:07:07 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id D20DE760922; Fri, 17 Jan 2020 16:06:59 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpf: Introduce dynamic program extensions
Date:   Fri, 17 Jan 2020 16:06:55 -0800
Message-ID: <20200118000657.2135859-2-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200118000657.2135859-1-ast@kernel.org>
References: <20200118000657.2135859-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001170179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce dynamic program extensions. The users can load additional BPF
functions and replace global functions in previously loaded BPF programs while
these programs are executing.

Global functions are verified individually by the verifier based on their types only.
Hence the global function in the new program which types match older function can
safely replace that corresponding function.

This new function/program is called 'an extension' of old program. At load time
the verifier uses (attach_prog_fd, attach_btf_id) pair to identify the function
to be replaced. The BPF program type is derived from the target program into
extension program. Technically bpf_verifier_ops is copied from target program.
The BPF_PROG_TYPE_EXT program type is a placeholder. It has empty verifier_ops.
The extension program can call the same bpf helper functions as target program.
Single BPF_PROG_TYPE_EXT type is used to extend XDP, SKB and all other program
types. The verifier allows only one level of replacement. Meaning that the
extension program cannot recursively extend an extension. That also means that
the maximum stack size is increasing from 512 to 1024 bytes and maximum
function nesting level from 8 to 16. The programs don't always consume that
much. The stack usage is determined by the number of on-stack variables used by
the program. The verifier could have enforced 512 limit for combined original
plus extension program, but it makes for difficult user experience. The main
use case for extensions is to provide generic mechanism to plug external
programs into policy program or function call chaining.

BPF trampoline is used to track both fentry/fexit and program extensions
because both are using the same nop slot at the beginning of every BPF
function. Attaching fentry/fexit to a function that was replaced is not
allowed. The opposite is true as well. Replacing a function that currently
being analyzed with fentry/fexit is not allowed. The executable page allocated
by BPF trampoline is not used by program extensions. This inefficiency will be
optimized in future patches.

Function by function verification of global function supports scalars and
pointer to context only. Hence program extensions are supported for such class
of global functions only. In the future the verifier will be extended with
support to pointers to structures, arrays with sizes, etc.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h       |  10 ++-
 include/linux/bpf_types.h |   2 +
 include/linux/btf.h       |   5 ++
 include/uapi/linux/bpf.h  |   1 +
 kernel/bpf/btf.c          | 152 +++++++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c      |  15 +++-
 kernel/bpf/trampoline.c   |  38 +++++++++-
 kernel/bpf/verifier.c     |  84 ++++++++++++++++-----
 8 files changed, 281 insertions(+), 26 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e3b8f4ad183..05d16615054c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -465,7 +465,8 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
 enum bpf_tramp_prog_type {
 	BPF_TRAMP_FENTRY,
 	BPF_TRAMP_FEXIT,
-	BPF_TRAMP_MAX
+	BPF_TRAMP_MAX,
+	BPF_TRAMP_REPLACE, /* more than MAX */
 };
 
 struct bpf_trampoline {
@@ -480,6 +481,11 @@ struct bpf_trampoline {
 		void *addr;
 		bool ftrace_managed;
 	} func;
+	/* if !NULL this is BPF_PROG_TYPE_EXT program that extends another BPF
+	 * program by replacing one of its functions. func.addr is the address
+	 * of the function it replaced.
+	 */
+	struct bpf_prog *extension_prog;
 	/* list of BPF programs using this trampoline */
 	struct hlist_head progs_hlist[BPF_TRAMP_MAX];
 	/* Number of attached programs. A counter per kind. */
@@ -1107,6 +1113,8 @@ int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
 			     struct bpf_reg_state *regs);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
+int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
+			 struct btf *btf, const struct btf_type *t);
 
 struct bpf_prog *bpf_prog_by_id(u32 id);
 
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 9f326e6ef885..c81d4ece79a4 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -68,6 +68,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport,
 #if defined(CONFIG_BPF_JIT)
 BPF_PROG_TYPE(BPF_PROG_TYPE_STRUCT_OPS, bpf_struct_ops,
 	      void *, void *)
+BPF_PROG_TYPE(BPF_PROG_TYPE_EXT, bpf_extension,
+	      void *, void *)
 #endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 881e9b76ef49..5c1ea99b480f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -107,6 +107,11 @@ static inline u16 btf_type_vlen(const struct btf_type *t)
 	return BTF_INFO_VLEN(t->info);
 }
 
+static inline u16 btf_func_linkage(const struct btf_type *t)
+{
+	return BTF_INFO_VLEN(t->info);
+}
+
 static inline bool btf_type_kflag(const struct btf_type *t)
 {
 	return BTF_INFO_KFLAG(t->info);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 033d90a2282d..e81628eb059c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -180,6 +180,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 	BPF_PROG_TYPE_TRACING,
 	BPF_PROG_TYPE_STRUCT_OPS,
+	BPF_PROG_TYPE_EXT,
 };
 
 enum bpf_attach_type {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 832b5d7fd892..32963b6d5a9c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -276,6 +276,11 @@ static const char * const btf_kind_str[NR_BTF_KINDS] = {
 	[BTF_KIND_DATASEC]	= "DATASEC",
 };
 
+static const char *btf_type_str(const struct btf_type *t)
+{
+	return btf_kind_str[BTF_INFO_KIND(t->info)];
+}
+
 struct btf_kind_operations {
 	s32 (*check_meta)(struct btf_verifier_env *env,
 			  const struct btf_type *t,
@@ -4115,6 +4120,148 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 	return 0;
 }
 
+/* Compare BTFs of two functions assuming only scalars and pointers to context.
+ * t1 points to BTF_KIND_FUNC in btf1
+ * t2 points to BTF_KIND_FUNC in btf2
+ * Returns:
+ * EINVAL - function prototype mismatch
+ * EFAULT - verifier bug
+ * 0 - 99% match. The last 1% is validated by the verifier.
+ */
+int btf_check_func_type_match(struct bpf_verifier_log *log,
+			      struct btf *btf1, const struct btf_type *t1,
+			      struct btf *btf2, const struct btf_type *t2)
+{
+	const struct btf_param *args1, *args2;
+	const char *fn1, *fn2, *s1, *s2;
+	u32 nargs1, nargs2, i;
+
+	fn1 = btf_name_by_offset(btf1, t1->name_off);
+	fn2 = btf_name_by_offset(btf2, t2->name_off);
+
+	if (btf_func_linkage(t1) != BTF_FUNC_GLOBAL) {
+		bpf_log(log, "%s() is not a global function\n", fn1);
+		return -EINVAL;
+	}
+	if (btf_func_linkage(t2) != BTF_FUNC_GLOBAL) {
+		bpf_log(log, "%s() is not a global function\n", fn2);
+		return -EINVAL;
+	}
+
+	t1 = btf_type_by_id(btf1, t1->type);
+	if (!t1 || !btf_type_is_func_proto(t1))
+		return -EFAULT;
+	t2 = btf_type_by_id(btf2, t2->type);
+	if (!t2 || !btf_type_is_func_proto(t2))
+		return -EFAULT;
+
+	args1 = (const struct btf_param *)(t1 + 1);
+	nargs1 = btf_type_vlen(t1);
+	args2 = (const struct btf_param *)(t2 + 1);
+	nargs2 = btf_type_vlen(t2);
+
+	if (nargs1 != nargs2) {
+		bpf_log(log, "%s() has %d args while %s() has %d args\n",
+			fn1, nargs1, fn2, nargs2);
+		return -EINVAL;
+	}
+
+	t1 = btf_type_skip_modifiers(btf1, t1->type, NULL);
+	t2 = btf_type_skip_modifiers(btf2, t2->type, NULL);
+	if (t1->info != t2->info) {
+		bpf_log(log,
+			"Return type %s of %s() doesn't match type %s of %s()\n",
+			btf_type_str(t1), fn1,
+			btf_type_str(t2), fn2);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < nargs1; i++) {
+		t1 = btf_type_skip_modifiers(btf1, args1[i].type, NULL);
+		t2 = btf_type_skip_modifiers(btf2, args2[i].type, NULL);
+
+		if (t1->info != t2->info) {
+			bpf_log(log, "arg%d in %s() is %s while %s() has %s\n",
+				i, fn1, btf_type_str(t1),
+				fn2, btf_type_str(t2));
+			return -EINVAL;
+		}
+		if (btf_type_has_size(t1) && t1->size != t2->size) {
+			bpf_log(log,
+				"arg%d in %s() has size %d while %s() has %d\n",
+				i, fn1, t1->size,
+				fn2, t2->size);
+			return -EINVAL;
+		}
+
+		/* global functions are validated with scalars and pointers
+		 * to context only. And only global functions can be replaced.
+		 * Hence type check only those types.
+		 */
+		if (btf_type_is_int(t1) || btf_type_is_enum(t1))
+			continue;
+		if (!btf_type_is_ptr(t1)) {
+			bpf_log(log,
+				"arg%d in %s() has unrecognized type\n",
+				i, fn1);
+			return -EINVAL;
+		}
+		t1 = btf_type_skip_modifiers(btf1, t1->type, NULL);
+		t2 = btf_type_skip_modifiers(btf2, t2->type, NULL);
+		if (!btf_type_is_struct(t1)) {
+			bpf_log(log,
+				"arg%d in %s() is not a pointer to context\n",
+				i, fn1);
+			return -EINVAL;
+		}
+		if (!btf_type_is_struct(t2)) {
+			bpf_log(log,
+				"arg%d in %s() is not a pointer to context\n",
+				i, fn2);
+			return -EINVAL;
+		}
+		/* This is an optional check to make program writing easier.
+		 * Compare names of structs and report an error to the user.
+		 * btf_prepare_func_args() already checked that t2 struct
+		 * is a context type. btf_prepare_func_args() will check
+		 * later that t1 struct is a context type as well.
+		 */
+		s1 = btf_name_by_offset(btf1, t1->name_off);
+		s2 = btf_name_by_offset(btf2, t2->name_off);
+		if (strcmp(s1, s2)) {
+			bpf_log(log,
+				"arg%d %s(struct %s *) doesn't match %s(struct %s *)\n",
+				i, fn1, s1, fn2, s2);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/* Compare BTFs of given program with BTF of target program */
+int btf_check_type_match(struct bpf_verifier_env *env, struct bpf_prog *prog,
+			 struct btf *btf2, const struct btf_type *t2)
+{
+	struct btf *btf1 = prog->aux->btf;
+	const struct btf_type *t1;
+	u32 btf_id = 0;
+
+	if (!prog->aux->func_info) {
+		bpf_log(&env->log, "Program extension requires BTF\n");
+		return -EINVAL;
+	}
+
+	btf_id = prog->aux->func_info[0].type_id;
+	if (!btf_id)
+		return -EFAULT;
+
+	t1 = btf_type_by_id(btf1, btf_id);
+	if (!t1 || !btf_type_is_func(t1))
+		return -EFAULT;
+
+	return btf_check_func_type_match(&env->log, btf1, t1, btf2, t2);
+}
+
 /* Compare BTF of a function with given bpf_reg_state.
  * Returns:
  * EFAULT - there is a verifier bug. Abort verification.
@@ -4224,6 +4371,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 {
 	struct bpf_verifier_log *log = &env->log;
 	struct bpf_prog *prog = env->prog;
+	enum bpf_prog_type prog_type = prog->type;
 	struct btf *btf = prog->aux->btf;
 	const struct btf_param *args;
 	const struct btf_type *t;
@@ -4261,6 +4409,8 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 		bpf_log(log, "Verifier bug in function %s()\n", tname);
 		return -EFAULT;
 	}
+	if (prog_type == BPF_PROG_TYPE_EXT)
+		prog_type = prog->aux->linked_prog->type;
 
 	t = btf_type_by_id(btf, t->type);
 	if (!t || !btf_type_is_func_proto(t)) {
@@ -4296,7 +4446,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			continue;
 		}
 		if (btf_type_is_ptr(t) &&
-		    btf_get_prog_ctx_type(log, btf, t, prog->type, i)) {
+		    btf_get_prog_ctx_type(log, btf, t, prog_type, i)) {
 			reg[i + 1].type = PTR_TO_CTX;
 			continue;
 		}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c26a71460f02..4aaea62b33b9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1924,13 +1924,15 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		switch (prog_type) {
 		case BPF_PROG_TYPE_TRACING:
 		case BPF_PROG_TYPE_STRUCT_OPS:
+		case BPF_PROG_TYPE_EXT:
 			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
-	if (prog_fd && prog_type != BPF_PROG_TYPE_TRACING)
+	if (prog_fd && prog_type != BPF_PROG_TYPE_TRACING &&
+	    prog_type != BPF_PROG_TYPE_EXT)
 		return -EINVAL;
 
 	switch (prog_type) {
@@ -1973,6 +1975,10 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+	case BPF_PROG_TYPE_EXT:
+		if (expected_attach_type)
+			return -EINVAL;
+		/* fallthrough */
 	default:
 		return 0;
 	}
@@ -2175,7 +2181,8 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 	int tr_fd, err;
 
 	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
-	    prog->expected_attach_type != BPF_TRACE_FEXIT) {
+	    prog->expected_attach_type != BPF_TRACE_FEXIT &&
+	    prog->type != BPF_PROG_TYPE_EXT) {
 		err = -EINVAL;
 		goto out_put_prog;
 	}
@@ -2242,12 +2249,14 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 
 	if (prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT &&
 	    prog->type != BPF_PROG_TYPE_TRACING &&
+	    prog->type != BPF_PROG_TYPE_EXT &&
 	    prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
 		err = -EINVAL;
 		goto out_put_prog;
 	}
 
-	if (prog->type == BPF_PROG_TYPE_TRACING) {
+	if (prog->type == BPF_PROG_TYPE_TRACING ||
+	    prog->type == BPF_PROG_TYPE_EXT) {
 		if (attr->raw_tracepoint.name) {
 			/* The attach point for this category of programs
 			 * should be specified via btf_id during program load.
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 79a04417050d..194f25a1a448 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -5,6 +5,12 @@
 #include <linux/filter.h>
 #include <linux/ftrace.h>
 
+/* dummy _ops. The verifier will operate on target program's ops. */
+const struct bpf_verifier_ops bpf_extension_verifier_ops = {
+};
+const struct bpf_prog_ops bpf_extension_prog_ops = {
+};
+
 /* btf_vmlinux has ~22k attachable functions. 1k htab is enough. */
 #define TRAMPOLINE_HASH_BITS 10
 #define TRAMPOLINE_TABLE_SIZE (1 << TRAMPOLINE_HASH_BITS)
@@ -186,8 +192,10 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
 	switch (t) {
 	case BPF_TRACE_FENTRY:
 		return BPF_TRAMP_FENTRY;
-	default:
+	case BPF_TRACE_FEXIT:
 		return BPF_TRAMP_FEXIT;
+	default:
+		return BPF_TRAMP_REPLACE;
 	}
 }
 
@@ -200,6 +208,26 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
 	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog->expected_attach_type);
 	mutex_lock(&tr->mutex);
+	if (kind == BPF_TRAMP_REPLACE) {
+		/* If this program already has an extension program
+		 * or it has fentry/fexit attached then return EBUSY.
+		 */
+		if (tr->extension_prog ||
+		    tr->progs_cnt[BPF_TRAMP_FENTRY] +
+		    tr->progs_cnt[BPF_TRAMP_FEXIT]) {
+			err = -EBUSY;
+			goto out;
+		}
+		tr->extension_prog = prog;
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
+					 prog->bpf_func);
+		goto out;
+	}
+	if (tr->extension_prog) {
+		/* cannot attach fentry/fexit if extension prog is attached */
+		err = -EBUSY;
+		goto out;
+	}
 	if (tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT]
 	    >= BPF_MAX_TRAMP_PROGS) {
 		err = -E2BIG;
@@ -232,9 +260,17 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
 	tr = prog->aux->trampoline;
 	kind = bpf_attach_type_to_tramp(prog->expected_attach_type);
 	mutex_lock(&tr->mutex);
+	if (kind == BPF_TRAMP_REPLACE) {
+		WARN_ON_ONCE(!tr->extension_prog);
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP,
+					 tr->extension_prog->bpf_func, NULL);
+		tr->extension_prog = NULL;
+		goto out;
+	}
 	hlist_del(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
 	err = bpf_trampoline_update(prog->aux->trampoline);
+out:
 	mutex_unlock(&tr->mutex);
 	return err;
 }
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ca17dccc17ba..19cf18d52aeb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9564,7 +9564,7 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 			subprog);
 
 	regs = state->frame[state->curframe]->regs;
-	if (subprog) {
+	if (subprog || env->prog->type == BPF_PROG_TYPE_EXT) {
 		ret = btf_prepare_func_args(env, subprog, regs);
 		if (ret)
 			goto out;
@@ -9737,6 +9737,7 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
+	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
 	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
 	u32 btf_id = prog->aux->attach_btf_id;
 	const char prefix[] = "btf_trace_";
@@ -9752,7 +9753,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
 		return check_struct_ops_btf_id(env);
 
-	if (prog->type != BPF_PROG_TYPE_TRACING)
+	if (prog->type != BPF_PROG_TYPE_TRACING && !prog_extension)
 		return 0;
 
 	if (!btf_id) {
@@ -9788,8 +9789,58 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			return -EINVAL;
 		}
 		conservative = aux->func_info_aux[subprog].unreliable;
+		if (prog_extension) {
+			if (conservative) {
+				verbose(env,
+					"Cannot replace static functions\n");
+				return -EINVAL;
+			}
+			if (!prog->jit_requested) {
+				verbose(env,
+					"Extension programs should be JITed\n");
+				return -EINVAL;
+			}
+			env->ops = bpf_verifier_ops[tgt_prog->type];
+		}
+		if (!tgt_prog->jited) {
+			verbose(env, "Can attach to only JITed progs\n");
+			return -EINVAL;
+		}
+		if (tgt_prog->type == prog->type) {
+			/* Cannot fentry/fexit another fentry/fexit program.
+			 * Cannot attach program extension to another extension.
+			 * It's ok to attach fentry/fexit to extension program.
+			 */
+			verbose(env, "Cannot recursively attach\n");
+			return -EINVAL;
+		}
+		if (tgt_prog->type == BPF_PROG_TYPE_TRACING &&
+		    tgt_prog->expected_attach_type != BPF_TRACE_RAW_TP &&
+		    prog_extension) {
+			/* Program extensions can extend all program types
+			 * except fentry/fexit. The reason is the following.
+			 * The fentry/fexit programs are used for performance
+			 * analysis, stats and can be attached to any program
+			 * type except themselves. When extension program is
+			 * replacing XDP function it is necessary to allow
+			 * performance analysis of all functions. Both original
+			 * XDP program and its program extension. Hence
+			 * attaching fentry/fexit to BPF_PROG_TYPE_EXT is
+			 * allowed. If extending of fentry/fexit was allowed it
+			 * would be possible to create long call chain
+			 * fentry->extension->fentry->extension beyond
+			 * reasonable stack size. Hence extending fentry is not
+			 * allowed.
+			 */
+			verbose(env, "Cannot extend fentry/fexit\n");
+			return -EINVAL;
+		}
 		key = ((u64)aux->id) << 32 | btf_id;
 	} else {
+		if (prog_extension) {
+			verbose(env, "Cannot replace kernel functions\n");
+			return -EINVAL;
+		}
 		key = btf_id;
 	}
 
@@ -9827,6 +9878,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		prog->aux->attach_func_proto = t;
 		prog->aux->attach_btf_trace = true;
 		return 0;
+	default:
+		if (!prog_extension)
+			return -EINVAL;
+		/* fallthrough */
 	case BPF_TRACE_FENTRY:
 	case BPF_TRACE_FEXIT:
 		if (!btf_type_is_func(t)) {
@@ -9834,6 +9889,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				btf_id);
 			return -EINVAL;
 		}
+		if (prog_extension &&
+		    btf_check_type_match(env, prog, btf, t))
+			return -EINVAL;
 		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
@@ -9857,18 +9915,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		if (ret < 0)
 			goto out;
 		if (tgt_prog) {
-			if (!tgt_prog->jited) {
-				/* for now */
-				verbose(env, "Can trace only JITed BPF progs\n");
-				ret = -EINVAL;
-				goto out;
-			}
-			if (tgt_prog->type == BPF_PROG_TYPE_TRACING) {
-				/* prevent cycles */
-				verbose(env, "Cannot recursively attach\n");
-				ret = -EINVAL;
-				goto out;
-			}
 			if (subprog == 0)
 				addr = (long) tgt_prog->bpf_func;
 			else
@@ -9890,8 +9936,6 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		if (ret)
 			bpf_trampoline_put(tr);
 		return ret;
-	default:
-		return -EINVAL;
 	}
 }
 
@@ -9961,10 +10005,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		goto skip_full_check;
 	}
 
-	ret = check_attach_btf_id(env);
-	if (ret)
-		goto skip_full_check;
-
 	env->strict_alignment = !!(attr->prog_flags & BPF_F_STRICT_ALIGNMENT);
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		env->strict_alignment = true;
@@ -10001,6 +10041,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret < 0)
 		goto skip_full_check;
 
+	ret = check_attach_btf_id(env);
+	if (ret)
+		goto skip_full_check;
+
 	ret = check_cfg(env);
 	if (ret < 0)
 		goto skip_full_check;
-- 
2.23.0

