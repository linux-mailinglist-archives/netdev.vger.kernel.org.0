Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70201CF9CC
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbgELPwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:52:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56446 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730898AbgELPwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:52:43 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04CFiG7V027035
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zzyIsukOVXBhTPl+0Q1jaO1t3O/pjAGk2LPMkHXdtgk=;
 b=JgNz47Mp3MM9Bdx5/sRUhQKPiocLxCAuOMhhIuG5vHtN8gC5/YvZ29H5Z2vGH8UXHuWK
 TcsrtuwnhtdV3lJ0GizGrzHUhVsj3FIDycjQgUPpW8s77pQoTwEP5/fG1t21KV8SmUGV
 9Uk7nB3dNi2OgL+j9YVEJLdZQJ1vc901N44= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30ws21gr7y-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:41 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:52:40 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B3D9E3700839; Tue, 12 May 2020 08:52:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 7/8] bpf: enable bpf_iter targets registering ctx argument types
Date:   Tue, 12 May 2020 08:52:39 -0700
Message-ID: <20200512155239.1080730-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200512155232.1080167-1-yhs@fb.com>
References: <20200512155232.1080167-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_04:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120118
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b121b341e598 ("bpf: Add PTR_TO_BTF_ID_OR_NULL
support") adds a field btf_id_or_null_non0_off to
bpf_prog->aux structure to indicate that the
first ctx argument is PTR_TO_BTF_ID reg_type and
all others are PTR_TO_BTF_ID_OR_NULL.
This approach does not really scale if we have
other different reg types in the future, e.g.,
a pointer to a buffer.

This patch enables bpf_iter targets registering ctx argument
reg types which may be different from the default one.
For example, for pointers to structures, the default reg_type
is PTR_TO_BTF_ID for tracing program. The target can register
a particular pointer type as PTR_TO_BTF_ID_OR_NULL which can
be used by the verifier to enforce accesses.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h      | 12 +++++++++++-
 include/net/ip6_fib.h    |  7 +++++++
 kernel/bpf/bpf_iter.c    |  5 +++++
 kernel/bpf/btf.c         | 15 ++++++++++-----
 kernel/bpf/map_iter.c    |  5 +++++
 kernel/bpf/task_iter.c   | 12 ++++++++++++
 kernel/bpf/verifier.c    |  1 -
 net/ipv6/ip6_fib.c       |  5 -----
 net/ipv6/route.c         |  5 +++++
 net/netlink/af_netlink.c |  5 +++++
 10 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ad1bd13cd34c..da36cdb410bb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -643,6 +643,12 @@ struct bpf_jit_poke_descriptor {
 	u16 reason;
 };
=20
+/* reg_type info for ctx arguments */
+struct bpf_ctx_arg_aux {
+	u32 offset;
+	enum bpf_reg_type reg_type;
+};
+
 struct bpf_prog_aux {
 	atomic64_t refcnt;
 	u32 used_map_cnt;
@@ -654,12 +660,13 @@ struct bpf_prog_aux {
 	u32 func_cnt; /* used by non-func prog as the number of func progs */
 	u32 func_idx; /* 0 for non-func prog, the index in func array for func =
prog */
 	u32 attach_btf_id; /* in-kernel BTF type id to attach to */
+	u32 ctx_arg_info_size;
+	struct bpf_ctx_arg_aux *ctx_arg_info;
 	struct bpf_prog *linked_prog;
 	bool verifier_zext; /* Zero extensions has been inserted by verifier. *=
/
 	bool offload_requested;
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool func_proto_unreliable;
-	bool btf_id_or_null_non0_off;
 	enum bpf_tramp_prog_type trampoline_prog_type;
 	struct bpf_trampoline *trampoline;
 	struct hlist_node tramp_hlist;
@@ -1139,12 +1146,15 @@ int bpf_obj_get_user(const char __user *pathname,=
 int flags);
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
=20
+#define BPF_ITER_CTX_ARG_MAX 2
 struct bpf_iter_reg {
 	const char *target;
 	const struct seq_operations *seq_ops;
 	bpf_iter_init_seq_priv_t init_seq_private;
 	bpf_iter_fini_seq_priv_t fini_seq_private;
 	u32 seq_priv_size;
+	u32 ctx_arg_info_size;
+	struct bpf_ctx_arg_aux ctx_arg_info[BPF_ITER_CTX_ARG_MAX];
 };
=20
 struct bpf_iter_meta {
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 80262d2980f5..870b646c5797 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -540,6 +540,13 @@ static inline bool fib6_metric_locked(struct fib6_in=
fo *f6i, int metric)
 	return !!(f6i->fib6_metrics->metrics[RTAX_LOCK - 1] & (1 << metric));
 }
=20
+#if IS_BUILTIN(CONFIG_IPV6) && defined(CONFIG_BPF_SYSCALL)
+struct bpf_iter__ipv6_route {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct fib6_info *, rt);
+};
+#endif
+
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 static inline bool fib6_has_custom_rules(const struct net *net)
 {
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 041f97dcec39..a6db83f41c50 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -305,6 +305,11 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 	}
 	mutex_unlock(&targets_mutex);
=20
+	if (supported) {
+		prog->aux->ctx_arg_info_size =3D tinfo->reg_info->ctx_arg_info_size;
+		prog->aux->ctx_arg_info =3D tinfo->reg_info->ctx_arg_info;
+	}
+
 	return supported;
 }
=20
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dcd233139294..ec587628a02f 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3694,7 +3694,7 @@ bool btf_ctx_access(int off, int size, enum bpf_acc=
ess_type type,
 	struct bpf_verifier_log *log =3D info->log;
 	const struct btf_param *args;
 	u32 nr_args, arg;
-	int ret;
+	int i, ret;
=20
 	if (off % 8) {
 		bpf_log(log, "func '%s' offset %d is not multiple of 8\n",
@@ -3790,10 +3790,15 @@ bool btf_ctx_access(int off, int size, enum bpf_a=
ccess_type type,
 		return true;
=20
 	/* this is a pointer to another type */
-	if (off !=3D 0 && prog->aux->btf_id_or_null_non0_off)
-		info->reg_type =3D PTR_TO_BTF_ID_OR_NULL;
-	else
-		info->reg_type =3D PTR_TO_BTF_ID;
+	info->reg_type =3D PTR_TO_BTF_ID;
+	for (i =3D 0; i < prog->aux->ctx_arg_info_size; i++) {
+		struct bpf_ctx_arg_aux *ctx_arg_info =3D &prog->aux->ctx_arg_info[i];
+
+		if (ctx_arg_info->offset =3D=3D off) {
+			info->reg_type =3D ctx_arg_info->reg_type;
+			break;
+		}
+	}
=20
 	if (tgt_prog) {
 		ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index 545c7dbb13c9..66e1691e7ee7 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -87,6 +87,11 @@ static struct bpf_iter_reg bpf_map_reg_info =3D {
 	.init_seq_private	=3D NULL,
 	.fini_seq_private	=3D NULL,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_map_info),
+	.ctx_arg_info_size	=3D 1,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__bpf_map, map),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
 };
=20
 static int __init bpf_map_iter_init(void)
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index ed0b1d6ce688..3621e1979c39 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -312,6 +312,11 @@ static struct bpf_iter_reg task_reg_info =3D {
 	.init_seq_private	=3D init_seq_pidns,
 	.fini_seq_private	=3D fini_seq_pidns,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_info),
+	.ctx_arg_info_size	=3D 1,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__task, task),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
 };
=20
 static struct bpf_iter_reg task_file_reg_info =3D {
@@ -320,6 +325,13 @@ static struct bpf_iter_reg task_file_reg_info =3D {
 	.init_seq_private	=3D init_seq_pidns,
 	.fini_seq_private	=3D fini_seq_pidns,
 	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_file_info),
+	.ctx_arg_info_size	=3D 2,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__task_file, task),
+		  PTR_TO_BTF_ID_OR_NULL },
+		{ offsetof(struct bpf_iter__task_file, file),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
 };
=20
 static int __init task_iter_init(void)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2a1826c76bb6..a3f2af756fd6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10652,7 +10652,6 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
 		prog->aux->attach_func_proto =3D t;
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
-		prog->aux->btf_id_or_null_non0_off =3D true;
 		ret =3D btf_distill_func_proto(&env->log, btf, t,
 					     tname, &fmodel);
 		return ret;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index a1fcc0ca21af..250ff52c674e 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2638,11 +2638,6 @@ static void ipv6_route_native_seq_stop(struct seq_=
file *seq, void *v)
 }
=20
 #if IS_BUILTIN(CONFIG_IPV6) && defined(CONFIG_BPF_SYSCALL)
-struct bpf_iter__ipv6_route {
-	__bpf_md_ptr(struct bpf_iter_meta *, meta);
-	__bpf_md_ptr(struct fib6_info *, rt);
-};
-
 static int ipv6_route_prog_seq_show(struct bpf_prog *prog,
 				    struct bpf_iter_meta *meta,
 				    void *v)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bb8581f9b448..94b6aaa84db3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6403,6 +6403,11 @@ static struct bpf_iter_reg ipv6_route_reg_info =3D=
 {
 	.init_seq_private	=3D bpf_iter_init_seq_net,
 	.fini_seq_private	=3D bpf_iter_fini_seq_net,
 	.seq_priv_size		=3D sizeof(struct ipv6_route_iter),
+	.ctx_arg_info_size	=3D 1,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__ipv6_route, rt),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
 };
=20
 static int __init bpf_iter_register(void)
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1e2f5ab8c7d7..3fe1979c0088 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2809,6 +2809,11 @@ static struct bpf_iter_reg netlink_reg_info =3D {
 	.init_seq_private	=3D bpf_iter_init_seq_net,
 	.fini_seq_private	=3D bpf_iter_fini_seq_net,
 	.seq_priv_size		=3D sizeof(struct nl_seq_iter),
+	.ctx_arg_info_size	=3D 1,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__netlink, sk),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
 };
=20
 static int __init bpf_iter_register(void)
--=20
2.24.1

