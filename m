Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8AE33CAA4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhCPBO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:14:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41872 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234152AbhCPBOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:14:09 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1AeUZ015803
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7hqcZLdSnc1hkh8zfg2Tuuc1PLUyZ5by3pbiUnPWT3U=;
 b=AA9A4QEVBnqUp+lJE/r9YMZdUXxB9mP1WKYJl+/Ba0PZdAhXbdP15cZtK0OhV+DtBTYg
 JmA73SZJRNaG/r941vyTt7aAdG24wRmdI2Ftukfto1MXpkqhWW4LVLD6sO3cH3MVa67r
 mKz44Ft+7+8FkAzrkHT9kUMELlSF+APBqNk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379e118trv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:09 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:14:07 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5BC9F2942B57; Mon, 15 Mar 2021 18:14:01 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 04/15] bpf: Support bpf program calling kernel function
Date:   Mon, 15 Mar 2021 18:14:01 -0700
Message-ID: <20210316011401.4176793-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support to BPF verifier to allow bpf program calling
kernel function directly.

The use case included in this set is to allow bpf-tcp-cc to directly
call some tcp-cc helper functions (e.g. "tcp_cong_avoid_ai()").  Those
functions have already been used by some kernel tcp-cc implementations.

This set will also allow the bpf-tcp-cc program to directly call the
kernel tcp-cc implementation,  For example, a bpf_dctcp may only want to
implement its own dctcp_cwnd_event() and reuse other dctcp_*() directly
from the kernel tcp_dctcp.c instead of reimplementing (or
copy-and-pasting) them.

The tcp-cc kernel functions mentioned above will be white listed
for the struct_ops bpf-tcp-cc programs to use in a later patch.
The white listed functions are not bounded to a fixed ABI contract.
Those functions have already been used by the existing kernel tcp-cc.
If any of them has changed, both in-tree and out-of-tree kernel tcp-cc
implementations have to be changed.  The same goes for the struct_ops
bpf-tcp-cc programs which have to be adjusted accordingly.

This patch is to make the required changes in the bpf verifier.

First change is in btf.c, it adds a case in "do_btf_check_func_arg_match(=
)".
When the passed in "btf->kernel_btf =3D=3D true", it means matching the
verifier regs' states with a kernel function.  This will handle the
PTR_TO_BTF_ID reg.  It also maps PTR_TO_SOCK_COMMON, PTR_TO_SOCKET,
and PTR_TO_TCP_SOCK to its kernel's btf_id.

In the later libbpf patch, the insn calling a kernel function will
look like:

insn->code =3D=3D (BPF_JMP | BPF_CALL)
insn->src_reg =3D=3D BPF_PSEUDO_KFUNC_CALL /* <- new in this patch */
insn->imm =3D=3D func_btf_id /* btf_id of the running kernel */

[ For the future calling function-in-kernel-module support, an array
  of module btf_fds can be passed at the load time and insn->off
  can be used to index into this array. ]

At the early stage of verifier, the verifier will collect all kernel
function calls into "struct bpf_kern_func_descriptor".  Those
descriptors are stored in "prog->aux->kfunc_tab" and will
be available to the JIT.  Since this "add" operation is similar
to the current "add_subprog()" and looking for the same insn->code,
they are done together in the new "add_subprog_and_kern_func()".

In the "do_check()" stage, the new "check_kern_func_call()" is added
to verify the kernel function call instruction:
1. Ensure the kernel function can be used by a particular BPF_PROG_TYPE.
   A new bpf_verifier_ops "check_kern_func_call" is added to do that.
   The bpf-tcp-cc struct_ops program will implement this function in
   a later patch.
2. Call "btf_check_kern_func_args_match()" to ensure the regs can be
   used as the args of a kernel function.
3. Mark the regs' type, subreg_def, and zext_dst.

At the later do_misc_fixups() stage, the new fixup_kern_func_call()
will replace the insn->imm with the function address (relative
to __bpf_call_base).  If needed, the jit can find the btf_func_model
by calling the new bpf_jit_find_kern_func_model(prog, insn->imm).
With the imm set to the function address, "bpftool prog dump xlated"
will be able to display the kernel function calls the same way as
it displays other bpf helper calls.

gpl_compatible program is required to call kernel function.

This feature currently requires JIT.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 arch/x86/net/bpf_jit_comp.c       |   5 +
 include/linux/bpf.h               |  24 ++
 include/linux/btf.h               |   1 +
 include/linux/filter.h            |   1 +
 include/uapi/linux/bpf.h          |   4 +
 kernel/bpf/btf.c                  |  65 +++++-
 kernel/bpf/core.c                 |  18 +-
 kernel/bpf/disasm.c               |  32 +--
 kernel/bpf/disasm.h               |   3 +-
 kernel/bpf/syscall.c              |   1 +
 kernel/bpf/verifier.c             | 376 ++++++++++++++++++++++++++++--
 tools/bpf/bpftool/xlated_dumper.c |   3 +-
 tools/include/uapi/linux/bpf.h    |   4 +
 13 files changed, 488 insertions(+), 49 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 6926d0ca6c71..bcb957234410 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2327,3 +2327,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_pro=
g *prog)
 					   tmp : orig_prog);
 	return prog;
 }
+
+bool bpf_jit_supports_kfunc_call(void)
+{
+	return true;
+}
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a25730eaa148..75ab8dc02df5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -426,6 +426,7 @@ enum bpf_reg_type {
 	PTR_TO_PERCPU_BTF_ID,	 /* reg points to a percpu kernel variable */
 	PTR_TO_FUNC,		 /* reg points to a bpf program function */
 	PTR_TO_MAP_KEY,		 /* reg points to a map element key */
+	__BPF_REG_TYPE_MAX,
 };
=20
 /* The information passed from prog-specific *_is_valid_access
@@ -479,6 +480,7 @@ struct bpf_verifier_ops {
 				 const struct btf_type *t, int off, int size,
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
+	bool (*check_kern_func_call)(u32 kfunc_btf_id);
 };
=20
 struct bpf_prog_offload_ops {
@@ -779,6 +781,8 @@ struct btf_mod_pair {
 	struct module *module;
 };
=20
+struct bpf_kern_func_desc_tab;
+
 struct bpf_prog_aux {
 	atomic64_t refcnt;
 	u32 used_map_cnt;
@@ -816,6 +820,7 @@ struct bpf_prog_aux {
 	struct bpf_prog **func;
 	void *jit_data; /* JIT specific data. arch dependent */
 	struct bpf_jit_poke_descriptor *poke_tab;
+	struct bpf_kern_func_desc_tab *kfunc_tab;
 	u32 size_poke_tab;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
@@ -1514,6 +1519,9 @@ int btf_distill_func_proto(struct bpf_verifier_log =
*log,
 			   struct btf_func_model *m);
=20
 struct bpf_reg_state;
+int btf_check_kern_func_arg_match(struct bpf_verifier_env *env,
+				  const struct btf *btf, u32 func_id,
+				  struct bpf_reg_state *regs);
 int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
 			     struct bpf_reg_state *regs);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
@@ -1526,6 +1534,10 @@ struct bpf_link *bpf_link_by_id(u32 id);
=20
 const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_i=
d);
 void bpf_task_storage_free(struct task_struct *task);
+bool bpf_prog_has_kern_func_call(const struct bpf_prog *prog);
+const struct btf_func_model *
+bpf_jit_find_kern_func_model(const struct bpf_prog *prog,
+			      const struct bpf_insn *insn);
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -1706,6 +1718,18 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 static inline void bpf_task_storage_free(struct task_struct *task)
 {
 }
+
+static inline bool bpf_prog_has_kern_func_call(const struct bpf_prog *pr=
og)
+{
+	return false;
+}
+
+static inline const struct btf_func_model *
+bpf_jit_find_kern_func_model(const struct bpf_prog *prog,
+			     const struct bpf_insn *insn)
+{
+	return NULL;
+}
 #endif /* CONFIG_BPF_SYSCALL */
=20
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 93bf2e5225f5..8f6ea0d4d8a1 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -109,6 +109,7 @@ const struct btf_type *btf_type_resolve_func_ptr(cons=
t struct btf *btf,
 const struct btf_type *
 btf_resolve_size(const struct btf *btf, const struct btf_type *type,
 		 u32 *type_size);
+const char *btf_type_str(const struct btf_type *t);
=20
 #define for_each_member(i, struct_type, member)			\
 	for (i =3D 0, member =3D btf_type_member(struct_type);	\
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 0d9c710eb050..eecfd82db648 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -918,6 +918,7 @@ u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u=
64 r5);
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
 bool bpf_jit_needs_zext(void);
+bool bpf_jit_supports_kfunc_call(void);
 bool bpf_helper_changes_pkt_data(void *func);
=20
 static inline bool bpf_dump_raw_ok(const struct cred *cred)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2d3036e292a9..ab9f2233607c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1117,6 +1117,10 @@ enum bpf_link_type {
  * offset to another bpf function
  */
 #define BPF_PSEUDO_CALL		1
+/* when bpf_call->src_reg =3D=3D BPF_PSEUDO_KFUNC_CALL,
+ * bpf_call->imm =3D=3D btf_id of a BTF_KIND_FUNC in the running kernel
+ */
+#define BPF_PSEUDO_KFUNC_CALL	2
=20
 /* flags for BPF_MAP_UPDATE_ELEM command */
 enum {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 529b94b601c6..ba77fdbe8cda 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -283,7 +283,7 @@ static const char * const btf_kind_str[NR_BTF_KINDS] =
=3D {
 	[BTF_KIND_FLOAT]	=3D "FLOAT",
 };
=20
-static const char *btf_type_str(const struct btf_type *t)
+const char *btf_type_str(const struct btf_type *t)
 {
 	return btf_kind_str[BTF_INFO_KIND(t->info)];
 }
@@ -5366,6 +5366,14 @@ int btf_check_type_match(struct bpf_verifier_log *=
log, const struct bpf_prog *pr
 	return btf_check_func_type_match(log, btf1, t1, btf2, t2);
 }
=20
+static u32 *reg2btf_ids[__BPF_REG_TYPE_MAX] =3D {
+#ifdef CONFIG_NET
+	[PTR_TO_SOCKET] =3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK],
+	[PTR_TO_SOCK_COMMON] =3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
+	[PTR_TO_TCP_SOCK] =3D &btf_sock_ids[BTF_SOCK_TYPE_TCP],
+#endif
+};
+
 static int do_btf_check_func_arg_match(struct bpf_verifier_env *env,
 				       const struct btf *btf, u32 func_id,
 				       struct bpf_reg_state *regs,
@@ -5375,12 +5383,12 @@ static int do_btf_check_func_arg_match(struct bpf=
_verifier_env *env,
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
-	u32 i, nargs;
+	u32 i, nargs, ref_id;
=20
 	t =3D btf_type_by_id(btf, func_id);
 	if (!t || !btf_type_is_func(t)) {
 		/* These checks were already done by the verifier while loading
-		 * struct bpf_func_info
+		 * struct bpf_func_info or in add_kern_func_call().
 		 */
 		bpf_log(log, "BTF of func_id %u doesn't point to KIND_FUNC\n",
 			func_id);
@@ -5422,9 +5430,49 @@ static int do_btf_check_func_arg_match(struct bpf_=
verifier_env *env,
 			return -EINVAL;
 		}
=20
-		ref_t =3D btf_type_skip_modifiers(btf, t->type, NULL);
+		ref_t =3D btf_type_skip_modifiers(btf, t->type, &ref_id);
 		ref_tname =3D btf_name_by_offset(btf, ref_t->name_off);
-		if (btf_get_prog_ctx_type(log, btf, t, env->prog->type, i)) {
+		if (btf_is_kernel(btf)) {
+			const struct btf_type *reg_ref_t;
+			const struct btf *reg_btf;
+			const char *reg_ref_tname;
+			u32 reg_ref_id;
+
+			if (!btf_type_is_struct(ref_t)) {
+				bpf_log(log, "kernel function %s args#%d pointer type %s %s is not s=
upported\n",
+					func_name, i, btf_type_str(ref_t),
+					ref_tname);
+				return -EINVAL;
+			}
+
+			if (reg->type =3D=3D PTR_TO_BTF_ID) {
+				reg_btf =3D reg->btf;
+				reg_ref_id =3D reg->btf_id;
+			} else if (reg2btf_ids[reg->type]) {
+				reg_btf =3D btf_vmlinux;
+				reg_ref_id =3D *reg2btf_ids[reg->type];
+			} else {
+				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s b=
ut R%d is not a pointer to btf_id\n",
+					func_name, i,
+					btf_type_str(ref_t), ref_tname, regno);
+				return -EINVAL;
+			}
+
+			reg_ref_t =3D btf_type_skip_modifiers(reg_btf, reg_ref_id,
+							    &reg_ref_id);
+			reg_ref_tname =3D btf_name_by_offset(reg_btf,
+							   reg_ref_t->name_off);
+			if (!btf_struct_ids_match(log, reg_btf, reg_ref_id,
+						  reg->off, btf, ref_id)) {
+				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s b=
ut R%d has a pointer to %s %s\n",
+					func_name, i,
+					btf_type_str(ref_t), ref_tname,
+					regno, btf_type_str(reg_ref_t),
+					reg_ref_tname);
+				return -EINVAL;
+			}
+		} else if (btf_get_prog_ctx_type(log, btf, t,
+						 env->prog->type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
 			 */
@@ -5497,6 +5545,13 @@ int btf_check_func_arg_match(struct bpf_verifier_e=
nv *env, int subprog,
 	return err;
 }
=20
+int btf_check_kern_func_arg_match(struct bpf_verifier_env *env,
+				  const struct btf *btf, u32 func_id,
+				  struct bpf_reg_state *regs)
+{
+	return do_btf_check_func_arg_match(env, btf, func_id, regs, false);
+}
+
 /* Convert BTF of a function into bpf_reg_state if possible
  * Returns:
  * EFAULT - there is a verifier bug. Abort verification.
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 4a6dd327446b..bd20683cb810 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -159,6 +159,9 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog)
 		kvfree(prog->aux->jited_linfo);
 		prog->aux->jited_linfo =3D NULL;
 	}
+
+	kfree(prog->aux->kfunc_tab);
+	prog->aux->kfunc_tab =3D NULL;
 }
=20
 /* The jit engine is responsible to provide an array
@@ -1840,9 +1843,15 @@ struct bpf_prog *bpf_prog_select_runtime(struct bp=
f_prog *fp, int *err)
 	/* In case of BPF to BPF calls, verifier did all the prep
 	 * work with regards to JITing, etc.
 	 */
+	bool jit_needed =3D false;
+
 	if (fp->bpf_func)
 		goto finalize;
=20
+	if (IS_ENABLED(CONFIG_BPF_JIT_ALWAYS_ON) ||
+	    bpf_prog_has_kern_func_call(fp))
+		jit_needed =3D true;
+
 	bpf_prog_select_func(fp);
=20
 	/* eBPF JITs can rewrite the program in case constant
@@ -1858,12 +1867,10 @@ struct bpf_prog *bpf_prog_select_runtime(struct b=
pf_prog *fp, int *err)
=20
 		fp =3D bpf_int_jit_compile(fp);
 		bpf_prog_jit_attempt_done(fp);
-#ifdef CONFIG_BPF_JIT_ALWAYS_ON
-		if (!fp->jited) {
+		if (!fp->jited && jit_needed) {
 			*err =3D -ENOTSUPP;
 			return fp;
 		}
-#endif
 	} else {
 		*err =3D bpf_prog_offload_compile(fp);
 		if (*err)
@@ -2343,6 +2350,11 @@ bool __weak bpf_jit_needs_zext(void)
 	return false;
 }
=20
+bool __weak bpf_jit_supports_kfunc_call(void)
+{
+	return false;
+}
+
 /* To execute LD_ABS/LD_IND instructions __bpf_prog_run() may call
  * skb_copy_bits(), so provide a weak definition of it for NET-less conf=
ig.
  */
diff --git a/kernel/bpf/disasm.c b/kernel/bpf/disasm.c
index 3acc7e0b6916..9b476b9ead03 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -19,16 +19,25 @@ static const char *__func_get_name(const struct bpf_i=
nsn_cbs *cbs,
 {
 	BUILD_BUG_ON(ARRAY_SIZE(func_id_str) !=3D __BPF_FUNC_MAX_ID);
=20
-	if (insn->src_reg !=3D BPF_PSEUDO_CALL &&
+	if (!insn->src_reg &&
 	    insn->imm >=3D 0 && insn->imm < __BPF_FUNC_MAX_ID &&
 	    func_id_str[insn->imm])
 		return func_id_str[insn->imm];
=20
-	if (cbs && cbs->cb_call)
-		return cbs->cb_call(cbs->private_data, insn);
+	if (cbs && cbs->cb_call) {
+		const char *res;
+
+		res =3D cbs->cb_call(cbs->private_data, insn, buff, len);
+		if (res)
+			return res;
+	}
=20
 	if (insn->src_reg =3D=3D BPF_PSEUDO_CALL)
-		snprintf(buff, len, "%+d", insn->imm);
+		snprintf(buff, len, "pc%+d", insn->imm);
+	else if (insn->src_reg =3D=3D BPF_PSEUDO_KFUNC_CALL)
+		snprintf(buff, len, "kfunc#%d", insn->imm);
+	else
+		snprintf(buff, len, "unknown#%d", insn->imm);
=20
 	return buff;
 }
@@ -255,18 +264,9 @@ void print_bpf_insn(const struct bpf_insn_cbs *cbs,
 		if (opcode =3D=3D BPF_CALL) {
 			char tmp[64];
=20
-			if (insn->src_reg =3D=3D BPF_PSEUDO_CALL) {
-				verbose(cbs->private_data, "(%02x) call pc%s\n",
-					insn->code,
-					__func_get_name(cbs, insn,
-							tmp, sizeof(tmp)));
-			} else {
-				strcpy(tmp, "unknown");
-				verbose(cbs->private_data, "(%02x) call %s#%d\n", insn->code,
-					__func_get_name(cbs, insn,
-							tmp, sizeof(tmp)),
-					insn->imm);
-			}
+			verbose(cbs->private_data,
+				"(%02x) call %s\n", insn->code,
+				__func_get_name(cbs, insn, tmp, sizeof(tmp)));
 		} else if (insn->code =3D=3D (BPF_JMP | BPF_JA)) {
 			verbose(cbs->private_data, "(%02x) goto pc%+d\n",
 				insn->code, insn->off);
diff --git a/kernel/bpf/disasm.h b/kernel/bpf/disasm.h
index e546b18d27da..60f9d87f9316 100644
--- a/kernel/bpf/disasm.h
+++ b/kernel/bpf/disasm.h
@@ -22,7 +22,8 @@ const char *func_id_name(int id);
 typedef __printf(2, 3) void (*bpf_insn_print_t)(void *private_data,
 						const char *, ...);
 typedef const char *(*bpf_insn_revmap_call_t)(void *private_data,
-					      const struct bpf_insn *insn);
+					      const struct bpf_insn *insn,
+					      char *buf, size_t len);
 typedef const char *(*bpf_insn_print_imm_t)(void *private_data,
 					    const struct bpf_insn *insn,
 					    __u64 full_imm);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 78a653e25df0..43ce565f017d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1691,6 +1691,7 @@ static void __bpf_prog_put_noref(struct bpf_prog *p=
rog, bool deferred)
 	btf_put(prog->aux->btf);
 	kvfree(prog->aux->jited_linfo);
 	kvfree(prog->aux->linfo);
+	kfree(prog->aux->kfunc_tab);
 	if (prog->aux->attach_btf)
 		btf_put(prog->aux->attach_btf);
=20
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0647454a0c8e..70e5d54a4115 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -234,6 +234,12 @@ static bool bpf_pseudo_call(const struct bpf_insn *i=
nsn)
 	       insn->src_reg =3D=3D BPF_PSEUDO_CALL;
 }
=20
+static bool bpf_pseudo_kfunc_call(const struct bpf_insn *insn)
+{
+	return insn->code =3D=3D (BPF_JMP | BPF_CALL) &&
+	       insn->src_reg =3D=3D BPF_PSEUDO_KFUNC_CALL;
+}
+
 static bool bpf_pseudo_func(const struct bpf_insn *insn)
 {
 	return insn->code =3D=3D (BPF_LD | BPF_IMM | BPF_DW) &&
@@ -1554,47 +1560,203 @@ static int add_subprog(struct bpf_verifier_env *=
env, int off)
 		verbose(env, "too many subprograms\n");
 		return -E2BIG;
 	}
+	/* determine subprog starts. The end is one before the next starts */
 	env->subprog_info[env->subprog_cnt++].start =3D off;
 	sort(env->subprog_info, env->subprog_cnt,
 	     sizeof(env->subprog_info[0]), cmp_subprogs, NULL);
 	return env->subprog_cnt - 1;
 }
=20
-static int check_subprogs(struct bpf_verifier_env *env)
+struct bpf_kern_func_descriptor {
+	struct btf_func_model func_model;
+	u32 func_id;
+	s32 imm;
+};
+
+#define MAX_KERN_FUNC_DESCS 256
+struct bpf_kern_func_desc_tab {
+	struct bpf_kern_func_descriptor descs[MAX_KERN_FUNC_DESCS];
+	u32 nr_descs;
+};
+
+static int kern_func_desc_cmp_by_id(const void *a, const void *b)
+{
+	const struct bpf_kern_func_descriptor *d0 =3D a;
+	const struct bpf_kern_func_descriptor *d1 =3D b;
+
+	/* func_id is not greater than BTF_MAX_TYPE */
+	return d0->func_id - d1->func_id;
+}
+
+static const struct bpf_kern_func_descriptor *
+find_kern_func_desc(const struct bpf_prog *prog, u32 func_id)
+{
+	struct bpf_kern_func_descriptor desc =3D {
+		.func_id =3D func_id,
+	};
+	struct bpf_kern_func_desc_tab *tab;
+
+	tab =3D prog->aux->kfunc_tab;
+	return bsearch(&desc, tab->descs, tab->nr_descs,
+		       sizeof(tab->descs[0]), kern_func_desc_cmp_by_id);
+}
+
+static int add_kern_func_call(struct bpf_verifier_env *env, u32 func_id)
+{
+	const struct btf_type *func, *func_proto;
+	struct bpf_kern_func_descriptor *desc;
+	struct bpf_kern_func_desc_tab *tab;
+	struct bpf_prog_aux *prog_aux;
+	const char *func_name;
+	unsigned long addr;
+
+	prog_aux =3D env->prog->aux;
+	tab =3D prog_aux->kfunc_tab;
+	if (!tab) {
+		if (!btf_vmlinux) {
+			verbose(env, "calling kernel function is not supported without CONFIG=
_DEBUG_INFO_BTF\n");
+			return -ENOTSUPP;
+		}
+
+		if (!env->prog->jit_requested) {
+			verbose(env, "JIT is required for calling kernel function\n");
+			return -ENOTSUPP;
+		}
+
+		if (!bpf_jit_supports_kfunc_call()) {
+			verbose(env, "JIT does not support calling kernel function\n");
+			return -ENOTSUPP;
+		}
+
+		if (!env->prog->gpl_compatible) {
+			verbose(env, "cannot call kernel function from non-GPL compatible pro=
gram\n");
+			return -EINVAL;
+		}
+
+		tab =3D kzalloc(sizeof(*tab), GFP_KERNEL);
+		if (!tab)
+			return -ENOMEM;
+		prog_aux->kfunc_tab =3D tab;
+	}
+
+	if (find_kern_func_desc(env->prog, func_id))
+		return 0;
+
+	if (tab->nr_descs =3D=3D MAX_KERN_FUNC_DESCS) {
+		verbose(env, "too many different kernel function calls\n");
+		return -E2BIG;
+	}
+
+	func =3D btf_type_by_id(btf_vmlinux, func_id);
+	if (!func || !btf_type_is_func(func)) {
+		verbose(env, "kernel btf_id %u is not a function\n",
+			func_id);
+		return -EINVAL;
+	}
+	func_proto =3D btf_type_by_id(btf_vmlinux, func->type);
+	if (!func_proto || !btf_type_is_func_proto(func_proto)) {
+		verbose(env, "kernel function btf_id %u does not have a valid func_pro=
to\n",
+			func_id);
+		return -EINVAL;
+	}
+
+	func_name =3D btf_name_by_offset(btf_vmlinux, func->name_off);
+	addr =3D kallsyms_lookup_name(func_name);
+	if (!addr) {
+		verbose(env, "cannot find address for kernel function %s\n",
+			func_name);
+		return -EINVAL;
+	}
+
+	desc =3D &tab->descs[tab->nr_descs++];
+	desc->func_id =3D func_id;
+	desc->imm =3D BPF_CAST_CALL(addr) - __bpf_call_base;
+	sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
+	     kern_func_desc_cmp_by_id, NULL);
+
+	return btf_distill_func_proto(&env->log, btf_vmlinux,
+				      func_proto, func_name,
+				      &desc->func_model);
+}
+
+static int kern_func_desc_cmp_by_imm(const void *a, const void *b)
+{
+	const struct bpf_kern_func_descriptor *d0 =3D a;
+	const struct bpf_kern_func_descriptor *d1 =3D b;
+
+	return d0->imm - d1->imm;
+}
+
+static void sort_kern_func_descs_by_imm(struct bpf_prog *prog)
+{
+	struct bpf_kern_func_desc_tab *tab;
+
+	tab =3D prog->aux->kfunc_tab;
+	if (!tab)
+		return;
+
+	sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
+	     kern_func_desc_cmp_by_imm, NULL);
+}
+
+bool bpf_prog_has_kern_func_call(const struct bpf_prog *prog)
+{
+	return !!prog->aux->kfunc_tab;
+}
+
+const struct btf_func_model *
+bpf_jit_find_kern_func_model(const struct bpf_prog *prog,
+			     const struct bpf_insn *insn)
+{
+	const struct bpf_kern_func_descriptor desc =3D {
+		.imm =3D insn->imm,
+	};
+	const struct bpf_kern_func_descriptor *res;
+	struct bpf_kern_func_desc_tab *tab;
+
+	tab =3D prog->aux->kfunc_tab;
+	res =3D bsearch(&desc, tab->descs, tab->nr_descs,
+		      sizeof(tab->descs[0]), kern_func_desc_cmp_by_imm);
+
+	return res ? &res->func_model : NULL;
+}
+
+static int add_subprog_and_kern_func(struct bpf_verifier_env *env)
 {
-	int i, ret, subprog_start, subprog_end, off, cur_subprog =3D 0;
 	struct bpf_subprog_info *subprog =3D env->subprog_info;
 	struct bpf_insn *insn =3D env->prog->insnsi;
-	int insn_cnt =3D env->prog->len;
+	int i, ret, insn_cnt =3D env->prog->len;
=20
 	/* Add entry function. */
 	ret =3D add_subprog(env, 0);
-	if (ret < 0)
+	if (ret)
 		return ret;
=20
-	/* determine subprog starts. The end is one before the next starts */
-	for (i =3D 0; i < insn_cnt; i++) {
-		if (bpf_pseudo_func(insn + i)) {
-			if (!env->bpf_capable) {
-				verbose(env,
-					"function pointers are allowed for CAP_BPF and CAP_SYS_ADMIN\n");
-				return -EPERM;
-			}
-			ret =3D add_subprog(env, i + insn[i].imm + 1);
-			if (ret < 0)
-				return ret;
-			/* remember subprog */
-			insn[i + 1].imm =3D ret;
-			continue;
-		}
-		if (!bpf_pseudo_call(insn + i))
+	for (i =3D 0; i < insn_cnt; i++, insn++) {
+		if (!bpf_pseudo_func(insn) && !bpf_pseudo_call(insn) &&
+		    !bpf_pseudo_kfunc_call(insn))
 			continue;
+
 		if (!env->bpf_capable) {
 			verbose(env,
-				"function calls to other bpf functions are allowed for CAP_BPF and C=
AP_SYS_ADMIN\n");
+				"%s %s function pointer is only allowed for CAP_BPF and CAP_SYS_ADMI=
N\n",
+				bpf_pseudo_func(insn) ? "loading" : "calling",
+				bpf_pseudo_kfunc_call(insn) ? "kernel" : "other bpf");
+
 			return -EPERM;
 		}
-		ret =3D add_subprog(env, i + insn[i].imm + 1);
+
+		if (bpf_pseudo_func(insn)) {
+			ret =3D add_subprog(env, i + insn->imm + 1);
+			if (ret >=3D 0)
+				/* remember subprog */
+				insn[1].imm =3D ret;
+		} else if (bpf_pseudo_call(insn)) {
+			ret =3D add_subprog(env, i + insn->imm + 1);
+		} else {
+			ret =3D add_kern_func_call(env, insn->imm);
+		}
+
 		if (ret < 0)
 			return ret;
 	}
@@ -1608,6 +1770,16 @@ static int check_subprogs(struct bpf_verifier_env =
*env)
 		for (i =3D 0; i < env->subprog_cnt; i++)
 			verbose(env, "func#%d @%d\n", i, subprog[i].start);
=20
+	return 0;
+}
+
+static int check_subprogs(struct bpf_verifier_env *env)
+{
+	int i, subprog_start, subprog_end, off, cur_subprog =3D 0;
+	struct bpf_subprog_info *subprog =3D env->subprog_info;
+	struct bpf_insn *insn =3D env->prog->insnsi;
+	int insn_cnt =3D env->prog->len;
+
 	/* now check that all jumps are within the same subprog */
 	subprog_start =3D subprog[cur_subprog].start;
 	subprog_end =3D subprog[cur_subprog + 1].start;
@@ -1916,6 +2088,27 @@ static int get_prev_insn_idx(struct bpf_verifier_s=
tate *st, int i,
 	return i;
 }
=20
+static const char *disasm_kern_func_name(void *data,
+					 const struct bpf_insn *insn,
+					 char *buf, size_t len)
+{
+	const struct btf_type *func;
+	const char *func_name;
+
+	if (insn->src_reg !=3D BPF_PSEUDO_KFUNC_CALL)
+		return NULL;
+
+	func =3D btf_type_by_id(btf_vmlinux, insn->imm);
+	if (!func)
+		func_name =3D "unknown-kern-func";
+	else
+		func_name =3D btf_name_by_offset(btf_vmlinux, func->name_off);
+
+	snprintf(buf, len, func_name);
+
+	return buf;
+}
+
 /* For given verifier state backtrack_insn() is called from the last ins=
n to
  * the first insn. Its purpose is to compute a bitmask of registers and
  * stack slots that needs precision in the parent verifier state.
@@ -1924,6 +2117,7 @@ static int backtrack_insn(struct bpf_verifier_env *=
env, int idx,
 			  u32 *reg_mask, u64 *stack_mask)
 {
 	const struct bpf_insn_cbs cbs =3D {
+		.cb_call	=3D disasm_kern_func_name,
 		.cb_print	=3D verbose,
 		.private_data	=3D env,
 	};
@@ -5960,6 +6154,99 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, struct bpf_insn *insn
 	return 0;
 }
=20
+/* mark_btf_func_reg_size() is used when the reg size is determined by
+ * the BTF func_proto's return value size and argument.
+ */
+static void mark_btf_func_reg_size(struct bpf_verifier_env *env, u32 reg=
no,
+				   size_t reg_size)
+{
+	struct bpf_reg_state *reg =3D &cur_regs(env)[regno];
+
+	if (regno =3D=3D BPF_REG_0) {
+		/* Function return value */
+		reg->live |=3D REG_LIVE_WRITTEN;
+		reg->subreg_def =3D reg_size =3D=3D sizeof(u64) ?
+			DEF_NOT_SUBREG : env->insn_idx + 1;
+	} else {
+		/* Function argument */
+		if (reg_size =3D=3D sizeof(u64)) {
+			mark_insn_zext(env, reg);
+			mark_reg_read(env, reg, reg->parent, REG_LIVE_READ64);
+		} else {
+			mark_reg_read(env, reg, reg->parent, REG_LIVE_READ32);
+		}
+	}
+}
+
+static int check_kern_func_call(struct bpf_verifier_env *env,
+				struct bpf_insn *insn)
+{
+	const struct btf_type *t, *func, *func_proto, *ptr_type;
+	struct bpf_reg_state *regs =3D cur_regs(env);
+	const char *func_name, *ptr_type_name;
+	u32 i, nargs, ret_id, func_id;
+	const struct btf_param *args;
+	int err;
+
+	func_id =3D insn->imm;
+	func =3D btf_type_by_id(btf_vmlinux, func_id);
+	func_name =3D btf_name_by_offset(btf_vmlinux, func->name_off);
+	func_proto =3D btf_type_by_id(btf_vmlinux, func->type);
+
+	if (!env->ops->check_kern_func_call ||
+	    !env->ops->check_kern_func_call(func_id)) {
+		verbose(env, "calling kernel function %s is not allowed\n",
+			func_name);
+		return -EACCES;
+	}
+
+	/* Check return type */
+	t =3D btf_type_skip_modifiers(btf_vmlinux, func_proto->type, &ret_id);
+	if (btf_type_is_void(t)) {
+		mark_reg_not_init(env, regs, BPF_REG_0);
+	} else if (btf_type_is_scalar(t)) {
+		mark_reg_unknown(env, regs, BPF_REG_0);
+		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
+	} else if (btf_type_is_ptr(t)) {
+		ptr_type =3D btf_type_skip_modifiers(btf_vmlinux, t->type, NULL);
+		if (!btf_type_is_struct(ptr_type)) {
+			ptr_type_name =3D btf_name_by_offset(btf_vmlinux,
+							   ptr_type->name_off);
+			verbose(env, "kernel function %s returns pointer type %s %s is not su=
pported\n",
+				func_name, btf_type_str(t),
+				ptr_type_name);
+			return -EINVAL;
+		}
+		regs[BPF_REG_0].btf =3D btf_vmlinux;
+		regs[BPF_REG_0].type =3D PTR_TO_BTF_ID;
+		regs[BPF_REG_0].btf_id =3D ret_id;
+		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
+	} /* else { add_kern_func_call() has already rejected this case } */
+
+	/* Check the arguments */
+	err =3D btf_check_kern_func_arg_match(env, btf_vmlinux, func_id, regs);
+	if (err)
+		return err;
+
+	nargs =3D btf_type_vlen(func_proto);
+	args =3D (const struct btf_param *)(func_proto + 1);
+	for (i =3D 0; i < nargs; i++) {
+		u32 regno =3D i + 1;
+
+		t =3D btf_type_skip_modifiers(btf_vmlinux, args[i].type, NULL);
+		if (btf_type_is_ptr(t))
+			mark_btf_func_reg_size(env, regno, sizeof(void *));
+		else
+			/* scalar. ensured by btf_check_kern_func_arg_match() */
+			mark_btf_func_reg_size(env, regno, t->size);
+	}
+
+	for (i =3D 1; i < CALLER_SAVED_REGS; i++)
+		mark_reg_not_init(env, regs, caller_saved[i]);
+
+	return 0;
+}
+
 static bool signed_add_overflows(s64 a, s64 b)
 {
 	/* Do the add in u64, where overflow is well-defined */
@@ -10163,6 +10450,7 @@ static int do_check(struct bpf_verifier_env *env)
=20
 		if (env->log.level & BPF_LOG_LEVEL) {
 			const struct bpf_insn_cbs cbs =3D {
+				.cb_call	=3D disasm_kern_func_name,
 				.cb_print	=3D verbose,
 				.private_data	=3D env,
 			};
@@ -10310,7 +10598,8 @@ static int do_check(struct bpf_verifier_env *env)
 				if (BPF_SRC(insn->code) !=3D BPF_K ||
 				    insn->off !=3D 0 ||
 				    (insn->src_reg !=3D BPF_REG_0 &&
-				     insn->src_reg !=3D BPF_PSEUDO_CALL) ||
+				     insn->src_reg !=3D BPF_PSEUDO_CALL &&
+				     insn->src_reg !=3D BPF_PSEUDO_KFUNC_CALL) ||
 				    insn->dst_reg !=3D BPF_REG_0 ||
 				    class =3D=3D BPF_JMP32) {
 					verbose(env, "BPF_CALL uses reserved fields\n");
@@ -10325,6 +10614,8 @@ static int do_check(struct bpf_verifier_env *env)
 				}
 				if (insn->src_reg =3D=3D BPF_PSEUDO_CALL)
 					err =3D check_func_call(env, insn, &env->insn_idx);
+				else if (insn->src_reg =3D=3D BPF_PSEUDO_KFUNC_CALL)
+					err =3D check_kern_func_call(env, insn);
 				else
 					err =3D check_helper_call(env, insn, &env->insn_idx);
 				if (err)
@@ -11635,6 +11926,7 @@ static int jit_subprogs(struct bpf_verifier_env *=
env)
 		func[i]->aux->name[0] =3D 'F';
 		func[i]->aux->stack_depth =3D env->subprog_info[i].stack_depth;
 		func[i]->jit_requested =3D 1;
+		func[i]->aux->kfunc_tab =3D prog->aux->kfunc_tab;
 		func[i]->aux->linfo =3D prog->aux->linfo;
 		func[i]->aux->nr_linfo =3D prog->aux->nr_linfo;
 		func[i]->aux->jited_linfo =3D prog->aux->jited_linfo;
@@ -11774,6 +12066,7 @@ static int fixup_call_args(struct bpf_verifier_en=
v *env)
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
 	struct bpf_prog *prog =3D env->prog;
 	struct bpf_insn *insn =3D prog->insnsi;
+	bool has_kfunc_call =3D bpf_prog_has_kern_func_call(prog);
 	int i, depth;
 #endif
 	int err =3D 0;
@@ -11787,6 +12080,10 @@ static int fixup_call_args(struct bpf_verifier_e=
nv *env)
 			return err;
 	}
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
+	if (has_kfunc_call) {
+		verbose(env, "calling kernel functions are not allowed in non-JITed pr=
ograms\n");
+		return -EINVAL;
+	}
 	if (env->subprog_cnt > 1 && env->prog->aux->tail_call_reachable) {
 		/* When JIT fails the progs with bpf2bpf calls and tail_calls
 		 * have to be rejected, since interpreter doesn't support them yet.
@@ -11815,6 +12112,27 @@ static int fixup_call_args(struct bpf_verifier_e=
nv *env)
 	return err;
 }
=20
+static int fixup_kern_func_call(struct bpf_verifier_env *env,
+				struct bpf_insn *insn)
+{
+	const struct bpf_kern_func_descriptor *desc;
+	const struct bpf_prog *prog =3D env->prog;
+
+	/* insn->imm has the btf func_id. Replace it with
+	 * an address (relative to __bpf_base_call).
+	 */
+	desc =3D find_kern_func_desc(prog, insn->imm);
+	if (!desc) {
+		verbose(env, "verifier internal error: kernel function descriptor not =
found for func_id %u\n",
+			insn->imm);
+		return -EFAULT;
+	}
+
+	insn->imm =3D desc->imm;
+
+	return 0;
+}
+
 /* Do various post-verification rewrites in a single program pass.
  * These rewrites simplify JIT and interpreter implementations.
  */
@@ -11951,6 +12269,12 @@ static int do_misc_fixups(struct bpf_verifier_en=
v *env)
 			continue;
 		if (insn->src_reg =3D=3D BPF_PSEUDO_CALL)
 			continue;
+		if (insn->src_reg =3D=3D BPF_PSEUDO_KFUNC_CALL) {
+			ret =3D fixup_kern_func_call(env, insn);
+			if (ret)
+				return ret;
+			continue;
+		}
=20
 		if (insn->imm =3D=3D BPF_FUNC_get_route_realm)
 			prog->dst_needed =3D 1;
@@ -12180,6 +12504,8 @@ static int do_misc_fixups(struct bpf_verifier_env=
 *env)
 		}
 	}
=20
+	sort_kern_func_descs_by_imm(env->prog);
+
 	return 0;
 }
=20
@@ -12885,6 +13211,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_=
attr *attr,
 	if (!env->explored_states)
 		goto skip_full_check;
=20
+	ret =3D add_subprog_and_kern_func(env);
+	if (ret < 0)
+		goto skip_full_check;
+
 	ret =3D check_subprogs(env);
 	if (ret < 0)
 		goto skip_full_check;
diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated=
_dumper.c
index 6fc3e6f7f40c..9ea9b8c76525 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -167,7 +167,8 @@ static const char *print_call_helper(struct dump_data=
 *dd,
 }
=20
 static const char *print_call(void *private_data,
-			      const struct bpf_insn *insn)
+			      const struct bpf_insn *insn,
+			      char *buf, size_t len)
 {
 	struct dump_data *dd =3D private_data;
 	unsigned long address =3D dd->address_call_base + insn->imm;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 2d3036e292a9..ab9f2233607c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1117,6 +1117,10 @@ enum bpf_link_type {
  * offset to another bpf function
  */
 #define BPF_PSEUDO_CALL		1
+/* when bpf_call->src_reg =3D=3D BPF_PSEUDO_KFUNC_CALL,
+ * bpf_call->imm =3D=3D btf_id of a BTF_KIND_FUNC in the running kernel
+ */
+#define BPF_PSEUDO_KFUNC_CALL	2
=20
 /* flags for BPF_MAP_UPDATE_ELEM command */
 enum {
--=20
2.30.2

