Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EAFF2764
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfKGFr5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29492 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbfKGFr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:56 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75j9l1001044
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:47:54 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ue3fwa-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:47:54 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:47:13 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id D1CC4760BC0; Wed,  6 Nov 2019 21:47:12 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 14/17] bpf: Support attaching tracing BPF program to other BPF programs
Date:   Wed, 6 Nov 2019 21:46:41 -0800
Message-ID: <20191107054644.1285697-15-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1034 malwarescore=0 mlxlogscore=999 suspectscore=3 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow FENTRY/FEXIT BPF programs to attach to other BPF programs of any type
including their subprograms. This feature allows snooping on input and output
packets in XDP, TC programs including their return values. In order to do that
the verifier needs to track types not only of vmlinux, but types of other BPF
programs as well. The verifier also needs to translate uapi/linux/bpf.h types
used by networking programs into kernel internal BTF types used by FENTRY/FEXIT
BPF programs. In some cases LLVM optimizations can remove arguments from BPF
subprograms without adjusting BTF info that LLVM backend knows. When BTF info
disagrees with actual types that the verifiers sees the BPF trampoline has to
fallback to conservative and treat all arguments as u64. The FENTRY/FEXIT
program can still attach to such subprograms, but won't be able to recognize
pointer types like 'struct sk_buff *' into won't be able to pass them to
bpf_skb_output() for dumping to user space.

The BPF_PROG_LOAD command is extended with attach_prog_fd field. When it's set
to zero the attach_btf_id is one vmlinux BTF type ids. When attach_prog_fd
points to previously loaded BPF program the attach_btf_id is BTF type id of
main function or one of its subprograms.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c |   3 +-
 include/linux/bpf.h         |   2 +
 include/linux/btf.h         |   1 +
 include/uapi/linux/bpf.h    |   1 +
 kernel/bpf/btf.c            |  49 ++++++++++++++---
 kernel/bpf/core.c           |   2 +
 kernel/bpf/syscall.c        |  19 +++++--
 kernel/bpf/verifier.c       | 102 +++++++++++++++++++++++++++++-------
 kernel/trace/bpf_trace.c    |   2 -
 9 files changed, 147 insertions(+), 34 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 260f61276f18..286ea82a0fa2 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -505,7 +505,8 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 	u8 *prog;
 	int ret;
 
-	if (!is_kernel_text((long)ip))
+	if (!is_kernel_text((long)ip) &&
+	    !is_bpf_text_address((long)ip))
 		/* BPF trampoline in modules is not supported */
 		return -EINVAL;
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ef9c954021e4..f1bde52eeaaa 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -484,6 +484,7 @@ struct bpf_prog_aux {
 	u32 func_cnt; /* used by non-func prog as the number of func progs */
 	u32 func_idx; /* 0 for non-func prog, the index in func array for func prog */
 	u32 attach_btf_id; /* in-kernel BTF type id to attach to */
+	struct bpf_prog *linked_prog;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
@@ -1169,6 +1170,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_skb_output_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 9dee00859c5f..79d4abc2556a 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -88,6 +88,7 @@ static inline bool btf_type_is_func_proto(const struct btf_type *t)
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
 struct btf *btf_parse_vmlinux(void);
+struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
 						    u32 type_id)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 69c200e6e696..4842a134b202 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -425,6 +425,7 @@ union bpf_attr {
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
 		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
+		__u32		attach_prog_fd; /* 0 to attach to vmlinux */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 050ec34bdd73..20b33a67ebbd 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3417,12 +3417,45 @@ struct btf *btf_parse_vmlinux(void)
 }
 
 extern struct btf *btf_vmlinux;
+struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
+{
+	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
+
+	if (tgt_prog) {
+		return tgt_prog->aux->btf;
+	} else {
+		return btf_vmlinux;
+	}
+}
+
+static bool btf_translate_to_vmlinux(struct bpf_verifier_log *log,
+				     struct btf *btf,
+				     const struct btf_type *t,
+				     struct bpf_insn_access_aux *info)
+{
+	const char *tname = __btf_name_by_offset(btf, t->name_off);
+	u32 btf_id;
+
+	if (!tname) {
+		bpf_log(log, "Program's type doesn't have a name\n");
+		return false;
+	}
+	if (strcmp(tname, "__sk_buff") == 0) {
+		btf_id = btf_resolve_helper_id(log, &bpf_skb_output_proto, 0);
+		if (btf_id < 0)
+			return false;
+		info->btf_id = btf_id;
+		return true;
+	}
+	return false;
+}
 
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info)
 {
 	const struct btf_type *t = prog->aux->attach_func_proto;
+	struct btf *btf = bpf_prog_get_target_btf(prog);
 	const char *tname = prog->aux->attach_func_name;
 	struct bpf_verifier_log *log = info->log;
 	const struct btf_param *args;
@@ -3445,17 +3478,17 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	if (prog->expected_attach_type == BPF_TRACE_FEXIT &&
 	    arg == nr_args) {
 		/* function return type */
-		t = btf_type_by_id(btf_vmlinux, t->type);
+		t = btf_type_by_id(btf, t->type);
 	} else if (arg >= nr_args) {
 		bpf_log(log, "func '%s' doesn't have %d-th argument\n",
 			tname, arg + 1);
 		return false;
 	} else {
-		t = btf_type_by_id(btf_vmlinux, args[arg].type);
+		t = btf_type_by_id(btf, args[arg].type);
 	}
 	/* skip modifiers */
 	while (btf_type_is_modifier(t))
-		t = btf_type_by_id(btf_vmlinux, t->type);
+		t = btf_type_by_id(btf, t->type);
 	if (btf_type_is_int(t))
 		/* accessing a scalar */
 		return true;
@@ -3463,7 +3496,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		bpf_log(log,
 			"func '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
 			tname, arg,
-			__btf_name_by_offset(btf_vmlinux, t->name_off),
+			__btf_name_by_offset(btf, t->name_off),
 			btf_kind_str[BTF_INFO_KIND(t->info)]);
 		return false;
 	}
@@ -3478,10 +3511,10 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	info->reg_type = PTR_TO_BTF_ID;
 	info->btf_id = t->type;
 
-	t = btf_type_by_id(btf_vmlinux, t->type);
+	t = btf_type_by_id(btf, t->type);
 	/* skip modifiers */
 	while (btf_type_is_modifier(t))
-		t = btf_type_by_id(btf_vmlinux, t->type);
+		t = btf_type_by_id(btf, t->type);
 	if (!btf_type_is_struct(t)) {
 		bpf_log(log,
 			"func '%s' arg%d type %s is not a struct\n",
@@ -3490,7 +3523,9 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	}
 	bpf_log(log, "func '%s' arg%d has btf_id %d type %s '%s'\n",
 		tname, arg, info->btf_id, btf_kind_str[BTF_INFO_KIND(t->info)],
-		__btf_name_by_offset(btf_vmlinux, t->name_off));
+		__btf_name_by_offset(btf, t->name_off));
+	if (btf != btf_vmlinux)
+		return btf_translate_to_vmlinux(log, btf, t, info);
 	return true;
 }
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7352f5514e57..802409b32c50 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2027,6 +2027,8 @@ void bpf_prog_free(struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
 
+	if (aux->linked_prog)
+		bpf_prog_put(aux->linked_prog);
 	INIT_WORK(&aux->work, bpf_prog_free_deferred);
 	schedule_work(&aux->work);
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e2e37bea86bc..0f7c2f82febb 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1576,7 +1576,7 @@ static void bpf_prog_load_fixup_attach_type(union bpf_attr *attr)
 static int
 bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 			   enum bpf_attach_type expected_attach_type,
-			   u32 btf_id)
+			   u32 btf_id, u32 prog_fd)
 {
 	switch (prog_type) {
 	case BPF_PROG_TYPE_TRACING:
@@ -1584,7 +1584,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 			return -EINVAL;
 		break;
 	default:
-		if (btf_id)
+		if (btf_id || prog_fd)
 			return -EINVAL;
 		break;
 	}
@@ -1635,7 +1635,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 }
 
 /* last field in 'union bpf_attr' used by this command */
-#define	BPF_PROG_LOAD_LAST_FIELD attach_btf_id
+#define	BPF_PROG_LOAD_LAST_FIELD attach_prog_fd
 
 static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 {
@@ -1678,7 +1678,8 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 
 	bpf_prog_load_fixup_attach_type(attr);
 	if (bpf_prog_load_check_attach(type, attr->expected_attach_type,
-				       attr->attach_btf_id))
+				       attr->attach_btf_id,
+				       attr->attach_prog_fd))
 		return -EINVAL;
 
 	/* plain bpf_prog allocation */
@@ -1688,6 +1689,16 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 
 	prog->expected_attach_type = attr->expected_attach_type;
 	prog->aux->attach_btf_id = attr->attach_btf_id;
+	if (attr->attach_prog_fd) {
+		struct bpf_prog *tgt_prog;
+
+		tgt_prog = bpf_prog_get(attr->attach_prog_fd);
+		if (IS_ERR(tgt_prog)) {
+			err = PTR_ERR(tgt_prog);
+			goto free_prog_nouncharge;
+		}
+		prog->aux->linked_prog = tgt_prog;
+	}
 
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e5ccd9afb1e7..33c61fe9b263 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9389,13 +9389,17 @@ static void print_verification_stats(struct bpf_verifier_env *env)
 static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
+	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
 	u32 btf_id = prog->aux->attach_btf_id;
 	const char prefix[] = "btf_trace_";
 	struct bpf_trampoline *tr;
 	const struct btf_type *t;
+	int ret, subprog = -1, i;
+	bool conservative = true;
 	const char *tname;
+	struct btf *btf;
 	long addr;
-	int ret;
+	u64 key;
 
 	if (prog->type != BPF_PROG_TYPE_TRACING)
 		return 0;
@@ -9404,19 +9408,46 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		verbose(env, "Tracing programs must provide btf_id\n");
 		return -EINVAL;
 	}
-	t = btf_type_by_id(btf_vmlinux, btf_id);
+	btf = bpf_prog_get_target_btf(prog);
+	t = btf_type_by_id(btf, btf_id);
 	if (!t) {
 		verbose(env, "attach_btf_id %u is invalid\n", btf_id);
 		return -EINVAL;
 	}
-	tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+	tname = btf_name_by_offset(btf, t->name_off);
 	if (!tname) {
 		verbose(env, "attach_btf_id %u doesn't have a name\n", btf_id);
 		return -EINVAL;
 	}
+	if (tgt_prog) {
+		struct bpf_prog_aux *aux = tgt_prog->aux;
+
+		for (i = 0; i < aux->func_info_cnt; i++)
+			if (aux->func_info[i].type_id == btf_id) {
+				subprog = i;
+				break;
+			}
+		if (subprog == -1) {
+			verbose(env, "Subprog %s doesn't exist\n", tname);
+			return -EINVAL;
+		}
+		if (subprog == 0)
+			conservative = aux->func_proto_unreliable;
+		else
+			conservative =
+				aux->func[subprog]->aux->func_proto_unreliable;
+		key = ((u64)aux->id) << 32 | btf_id;
+	} else {
+		key = btf_id;
+	}
 
 	switch (prog->expected_attach_type) {
 	case BPF_TRACE_RAW_TP:
+		if (tgt_prog) {
+			verbose(env,
+				"Only FENTRY/FEXIT progs are attachable to another BPF prog\n");
+			return -EINVAL;
+		}
 		if (!btf_type_is_typedef(t)) {
 			verbose(env, "attach_btf_id %u is not a typedef\n",
 				btf_id);
@@ -9428,11 +9459,11 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 			return -EINVAL;
 		}
 		tname += sizeof(prefix) - 1;
-		t = btf_type_by_id(btf_vmlinux, t->type);
+		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_ptr(t))
 			/* should never happen in valid vmlinux build */
 			return -EINVAL;
-		t = btf_type_by_id(btf_vmlinux, t->type);
+		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
 			/* should never happen in valid vmlinux build */
 			return -EINVAL;
@@ -9451,35 +9482,66 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				btf_id);
 			return -EINVAL;
 		}
-		t = btf_type_by_id(btf_vmlinux, t->type);
+		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
-		tr = bpf_trampoline_lookup(btf_id);
+		tr = bpf_trampoline_lookup(key);
 		if (!tr)
 			return -ENOMEM;
 		prog->aux->attach_func_name = tname;
+		/* t is either vmlinux type or another program's type */
 		prog->aux->attach_func_proto = t;
 		if (tr->func.addr) {
 			prog->aux->trampoline = tr;
 			return 0;
 		}
-		ret = btf_distill_func_proto(&env->log, btf_vmlinux, t,
-					     tname, &tr->func.model);
-		if (ret < 0) {
-			bpf_trampoline_put(tr);
-			return ret;
-		}
-		addr = kallsyms_lookup_name(tname);
-		if (!addr) {
-			verbose(env,
-				"The address of function %s cannot be found\n",
-				tname);
-			bpf_trampoline_put(tr);
-			return -ENOENT;
+		if (tgt_prog && conservative) {
+			struct btf_func_model *m = &tr->func.model;
+
+			/* default BPF prog or subprog with 5 args */
+			for (i = 0; i < 5; i++)
+				m->arg_size[i] = 8;
+			m->ret_size = 8;
+			m->nr_args = 5;
+		} else {
+			ret = btf_distill_func_proto(&env->log, btf, t,
+						     tname, &tr->func.model);
+			if (ret < 0)
+				goto out;
+		}
+		if (tgt_prog) {
+			if (!tgt_prog->jited) {
+				/* for now */
+				verbose(env, "Can trace only JITed BPF progs\n");
+				ret = -EINVAL;
+				goto out;
+			}
+			if (tgt_prog->type == BPF_PROG_TYPE_TRACING) {
+				/* prevent cycles */
+				verbose(env, "Cannot recursively attach\n");
+				ret = -EINVAL;
+				goto out;
+			}
+			if (subprog == 0)
+				addr = (long) tgt_prog->bpf_func;
+			else
+				addr = (long) tgt_prog->aux->func[subprog]->bpf_func;
+		} else {
+			addr = kallsyms_lookup_name(tname);
+			if (!addr) {
+				verbose(env,
+					"The address of function %s cannot be found\n",
+					tname);
+				ret = -ENOENT;
+				goto out;
+			}
 		}
 		tr->func.addr = (void *)addr;
 		prog->aux->trampoline = tr;
 		return 0;
+out:
+		bpf_trampoline_put(tr);
+		return ret;
 	default:
 		return -EINVAL;
 	}
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ffc91d4935ac..0d13f24a71b8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1082,8 +1082,6 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
-extern const struct bpf_func_proto bpf_skb_output_proto;
-
 BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
 	   struct bpf_map *, map, u64, flags)
 {
-- 
2.23.0

