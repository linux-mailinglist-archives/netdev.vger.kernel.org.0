Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF72C19E1D7
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDDAKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:10:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37144 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726414AbgDDAKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:10:17 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03408dgM014700
        for <netdev@vger.kernel.org>; Fri, 3 Apr 2020 17:10:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3WJ73bBl2RtZ2RQUNf/dQemwra3suWFFh+Ammm7Gi9Q=;
 b=DW4472wNkhfG2x+X4Y5c24hWJUJLB7kWV/rpQnSj2S7lT1Q7OrQ8bFiXYNhanP0iGPQG
 5jWsZgYCpcNED94NDrawqP4BnE8bGh/CjXwmQwG6LxAHM6voqrabyET7Cn3oKEgcEBQ2
 Kgfdb3Rabi8aZPTDs38fIh5Et0CKCYkvbeY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 305343by47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:10:15 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 3 Apr 2020 17:10:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F037B2EC2885; Fri,  3 Apr 2020 17:10:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 5/8] bpf: add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link
Date:   Fri, 3 Apr 2020 17:09:44 -0700
Message-ID: <20200404000948.3980903-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200404000948.3980903-1-andriin@fb.com>
References: <20200404000948.3980903-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_19:2020-04-03,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=43 clxscore=1015 phishscore=0 impostorscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=921
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to fetch bpf_link details through BPF_OBJ_GET_INFO_BY_FD comm=
and.
Also enhance show_fdinfo to potentially include bpf_link type-specific
information (similarly to obj_info).

Also introduce enum bpf_link_type stored in bpf_link itself and expose it=
 in
UAPI. bpf_link_tracing also now will store and return bpf_attach_type.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf-cgroup.h     |   2 -
 include/linux/bpf.h            |  10 +-
 include/linux/bpf_types.h      |   6 ++
 include/uapi/linux/bpf.h       |  28 ++++++
 kernel/bpf/btf.c               |   2 +
 kernel/bpf/cgroup.c            |  45 ++++++++-
 kernel/bpf/syscall.c           | 164 +++++++++++++++++++++++++++++----
 kernel/bpf/verifier.c          |   2 +
 tools/include/uapi/linux/bpf.h |  31 +++++++
 9 files changed, 266 insertions(+), 24 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index d2d969669564..ab95824a1d99 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -57,8 +57,6 @@ struct bpf_cgroup_link {
 	enum bpf_attach_type type;
 };
=20
-extern const struct bpf_link_ops bpf_cgroup_link_lops;
-
 struct bpf_prog_list {
 	struct list_head node;
 	struct bpf_prog *prog;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 67ce74890911..8cf182d256d4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1026,9 +1026,11 @@ extern const struct file_operations bpf_prog_fops;
 	extern const struct bpf_verifier_ops _name ## _verifier_ops;
 #define BPF_MAP_TYPE(_id, _ops) \
 	extern const struct bpf_map_ops _ops;
+#define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
 #undef BPF_MAP_TYPE
+#undef BPF_LINK_TYPE
=20
 extern const struct bpf_prog_ops bpf_offload_prog_ops;
 extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
@@ -1086,6 +1088,7 @@ int bpf_prog_new_fd(struct bpf_prog *prog);
 struct bpf_link {
 	atomic64_t refcnt;
 	u32 id;
+	enum bpf_link_type type;
 	const struct bpf_link_ops *ops;
 	struct bpf_prog *prog;
 	struct work_struct work;
@@ -1103,9 +1106,14 @@ struct bpf_link_ops {
 	void (*dealloc)(struct bpf_link *link);
 	int (*update_prog)(struct bpf_link *link, struct bpf_prog *new_prog,
 			   struct bpf_prog *old_prog);
+	void (*show_fdinfo)(const struct bpf_link *link, struct seq_file *seq);
+	int (*fill_link_info)(const struct bpf_link *link,
+			      struct bpf_link_info *info,
+			      const struct bpf_link_info *uinfo,
+			      u32 info_len);
 };
=20
-void bpf_link_init(struct bpf_link *link,
+void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
 		   const struct bpf_link_ops *ops, struct bpf_prog *prog);
 int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer=
);
 int bpf_link_settle(struct bpf_link_primer *primer);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index ba0c2d56f8a3..8345cdf553b8 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -118,3 +118,9 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
 #if defined(CONFIG_BPF_JIT)
 BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
 #endif
+
+BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
+BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
+#ifdef CONFIG_CGROUP_BPF
+BPF_LINK_TYPE(BPF_LINK_TYPE_CGROUP, cgroup)
+#endif
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 407c086bc9e4..d2f269082a33 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -222,6 +222,15 @@ enum bpf_attach_type {
=20
 #define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
=20
+enum bpf_link_type {
+	BPF_LINK_TYPE_UNSPEC =3D 0,
+	BPF_LINK_TYPE_RAW_TRACEPOINT =3D 1,
+	BPF_LINK_TYPE_TRACING =3D 2,
+	BPF_LINK_TYPE_CGROUP =3D 3,
+
+	MAX_BPF_LINK_TYPE,
+};
+
 /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
@@ -3601,6 +3610,25 @@ struct bpf_btf_info {
 	__u32 id;
 } __attribute__((aligned(8)));
=20
+struct bpf_link_info {
+	__u32 type;
+	__u32 id;
+	__u32 prog_id;
+	union {
+		struct {
+			__aligned_u64 tp_name; /* in/out: tp_name buffer ptr */
+			__u32 tp_name_len;     /* in/out: tp_name buffer len */
+		} raw_tracepoint;
+		struct {
+			__u32 attach_type;
+		} tracing;
+		struct {
+			__u64 cgroup_id;
+			__u32 attach_type;
+		} cgroup;
+	};
+} __attribute__((aligned(8)));
+
 /* User bpf_sock_addr struct to access socket fields and sockaddr struct=
 passed
  * by user and intended to be used by socket (e.g. to bind to, depends o=
n
  * attach attach type).
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index d65c6912bdaf..a2cfba89a8e1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3482,6 +3482,7 @@ extern char __weak __stop_BTF[];
 extern struct btf *btf_vmlinux;
=20
 #define BPF_MAP_TYPE(_id, _ops)
+#define BPF_LINK_TYPE(_id, _name)
 static union {
 	struct bpf_ctx_convert {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
@@ -3508,6 +3509,7 @@ static u8 bpf_ctx_convert_map[] =3D {
 	0, /* avoid empty array */
 };
 #undef BPF_MAP_TYPE
+#undef BPF_LINK_TYPE
=20
 static const struct btf_member *
 btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ae84c5c90631..25ca4c937595 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -833,10 +833,50 @@ static void bpf_cgroup_link_dealloc(struct bpf_link=
 *link)
 	kfree(cg_link);
 }
=20
-const struct bpf_link_ops bpf_cgroup_link_lops =3D {
+static void bpf_cgroup_link_show_fdinfo(const struct bpf_link *link,
+					struct seq_file *seq)
+{
+	struct bpf_cgroup_link *cg_link =3D
+		container_of(link, struct bpf_cgroup_link, link);
+	u64 cg_id =3D 0;
+
+	mutex_lock(&cgroup_mutex);
+	if (cg_link->cgroup)
+		cg_id =3D cgroup_id(cg_link->cgroup);
+	mutex_unlock(&cgroup_mutex);
+
+	seq_printf(seq,
+		   "cgroup_id:\t%llu\n"
+		   "attach_type:\t%d\n",
+		   cg_id,
+		   cg_link->type);
+}
+
+static int bpf_cgroup_link_fill_link_info(const struct bpf_link *link,
+					  struct bpf_link_info *info,
+					  const struct bpf_link_info *uinfo,
+					  u32 info_len)
+{
+	struct bpf_cgroup_link *cg_link =3D
+		container_of(link, struct bpf_cgroup_link, link);
+	u64 cg_id =3D 0;
+
+	mutex_lock(&cgroup_mutex);
+	if (cg_link->cgroup)
+		cg_id =3D cgroup_id(cg_link->cgroup);
+	mutex_unlock(&cgroup_mutex);
+
+	info->cgroup.cgroup_id =3D cg_id;
+	info->cgroup.attach_type =3D cg_link->type;
+	return 0;
+}
+
+static const struct bpf_link_ops bpf_cgroup_link_lops =3D {
 	.release =3D bpf_cgroup_link_release,
 	.dealloc =3D bpf_cgroup_link_dealloc,
 	.update_prog =3D cgroup_bpf_replace,
+	.show_fdinfo =3D bpf_cgroup_link_show_fdinfo,
+	.fill_link_info =3D bpf_cgroup_link_fill_link_info,
 };
=20
 int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *=
prog)
@@ -858,7 +898,8 @@ int cgroup_bpf_link_attach(const union bpf_attr *attr=
, struct bpf_prog *prog)
 		err =3D -ENOMEM;
 		goto out_put_cgroup;
 	}
-	bpf_link_init(&link->link, &bpf_cgroup_link_lops, prog);
+	bpf_link_init(&link->link, BPF_LINK_TYPE_CGROUP, &bpf_cgroup_link_lops,
+		      prog);
 	link->cgroup =3D cgrp;
 	link->type =3D attr->link_create.attach_type;
=20
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 527ec16702be..ed94b322c757 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -51,9 +51,11 @@ static const struct bpf_map_ops * const bpf_map_types[=
] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
 #define BPF_MAP_TYPE(_id, _ops) \
 	[_id] =3D &_ops,
+#define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
 #undef BPF_MAP_TYPE
+#undef BPF_LINK_TYPE
 };
=20
 /*
@@ -1550,9 +1552,11 @@ static const struct bpf_prog_ops * const bpf_prog_=
types[] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	[_id] =3D & _name ## _prog_ops,
 #define BPF_MAP_TYPE(_id, _ops)
+#define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
 #undef BPF_MAP_TYPE
+#undef BPF_LINK_TYPE
 };
=20
 static int find_prog_type(enum bpf_prog_type type, struct bpf_prog *prog=
)
@@ -2186,10 +2190,11 @@ static int bpf_obj_get(const union bpf_attr *attr=
)
 				attr->file_flags);
 }
=20
-void bpf_link_init(struct bpf_link *link,
+void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
 		   const struct bpf_link_ops *ops, struct bpf_prog *prog)
 {
 	atomic64_set(&link->refcnt, 1);
+	link->type =3D type;
 	link->id =3D 0;
 	link->ops =3D ops;
 	link->prog =3D prog;
@@ -2270,27 +2275,23 @@ static int bpf_link_release(struct inode *inode, =
struct file *filp)
 	return 0;
 }
=20
-#ifdef CONFIG_PROC_FS
-static const struct bpf_link_ops bpf_raw_tp_lops;
-static const struct bpf_link_ops bpf_tracing_link_lops;
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
+#define BPF_MAP_TYPE(_id, _ops)
+#define BPF_LINK_TYPE(_id, _name) [_id] =3D #_name,
+static const char *bpf_link_type_strs[] =3D {
+	[BPF_LINK_TYPE_UNSPEC] =3D "<invalid>",
+#include <linux/bpf_types.h>
+};
+#undef BPF_PROG_TYPE
+#undef BPF_MAP_TYPE
+#undef BPF_LINK_TYPE
=20
+#ifdef CONFIG_PROC_FS
 static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_link *link =3D filp->private_data;
 	const struct bpf_prog *prog =3D link->prog;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] =3D { };
-	const char *link_type;
-
-	if (link->ops =3D=3D &bpf_raw_tp_lops)
-		link_type =3D "raw_tracepoint";
-	else if (link->ops =3D=3D &bpf_tracing_link_lops)
-		link_type =3D "tracing";
-#ifdef CONFIG_CGROUP_BPF
-	else if (link->ops =3D=3D &bpf_cgroup_link_lops)
-		link_type =3D "cgroup";
-#endif
-	else
-		link_type =3D "unknown";
=20
 	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
 	seq_printf(m,
@@ -2298,10 +2299,12 @@ static void bpf_link_show_fdinfo(struct seq_file =
*m, struct file *filp)
 		   "link_id:\t%u\n"
 		   "prog_tag:\t%s\n"
 		   "prog_id:\t%u\n",
-		   link_type,
+		   bpf_link_type_strs[link->type],
 		   link->id,
 		   prog_tag,
 		   prog->aux->id);
+	if (link->ops->show_fdinfo)
+		link->ops->show_fdinfo(link, m);
 }
 #endif
=20
@@ -2409,6 +2412,7 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd, fmod=
e_t *link_mode)
=20
 struct bpf_tracing_link {
 	struct bpf_link link;
+	enum bpf_attach_type attach_type;
 };
=20
 static void bpf_tracing_link_release(struct bpf_link *link)
@@ -2424,9 +2428,35 @@ static void bpf_tracing_link_dealloc(struct bpf_li=
nk *link)
 	kfree(tr_link);
 }
=20
+static void bpf_tracing_link_show_fdinfo(const struct bpf_link *link,
+					 struct seq_file *seq)
+{
+	struct bpf_tracing_link *tr_link =3D
+		container_of(link, struct bpf_tracing_link, link);
+
+	seq_printf(seq,
+		   "attach_type:\t%d\n",
+		   tr_link->attach_type);
+}
+
+static int bpf_tracing_link_fill_link_info(const struct bpf_link *link,
+					   struct bpf_link_info *info,
+					   const struct bpf_link_info *uinfo,
+					   u32 info_len)
+{
+	struct bpf_tracing_link *tr_link =3D
+		container_of(link, struct bpf_tracing_link, link);
+
+	info->tracing.attach_type =3D tr_link->attach_type;
+
+	return 0;
+}
+
 static const struct bpf_link_ops bpf_tracing_link_lops =3D {
 	.release =3D bpf_tracing_link_release,
 	.dealloc =3D bpf_tracing_link_dealloc,
+	.show_fdinfo =3D bpf_tracing_link_show_fdinfo,
+	.fill_link_info =3D bpf_tracing_link_fill_link_info,
 };
=20
 static int bpf_tracing_prog_attach(struct bpf_prog *prog)
@@ -2466,7 +2496,9 @@ static int bpf_tracing_prog_attach(struct bpf_prog =
*prog)
 		err =3D -ENOMEM;
 		goto out_put_prog;
 	}
-	bpf_link_init(&link->link, &bpf_tracing_link_lops, prog);
+	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING,
+		      &bpf_tracing_link_lops, prog);
+	link->attach_type =3D prog->expected_attach_type;
=20
 	err =3D bpf_link_prime(&link->link, &link_primer);
 	if (err) {
@@ -2508,9 +2540,66 @@ static void bpf_raw_tp_link_dealloc(struct bpf_lin=
k *link)
 	kfree(raw_tp);
 }
=20
+static void bpf_raw_tp_link_show_fdinfo(const struct bpf_link *link,
+					struct seq_file *seq)
+{
+	struct bpf_raw_tp_link *raw_tp_link =3D
+		container_of(link, struct bpf_raw_tp_link, link);
+
+	seq_printf(seq,
+		   "tp_name:\t%s\n",
+		   raw_tp_link->btp->tp->name);
+}
+
+static int bpf_raw_tp_link_fill_link_info(const struct bpf_link *link,
+					  struct bpf_link_info *info,
+					  const struct bpf_link_info *uinfo,
+					  u32 info_len)
+{
+	struct bpf_raw_tp_link *raw_tp_link =3D
+		container_of(link, struct bpf_raw_tp_link, link);
+	u64 ubuf_ptr;
+	char __user *ubuf =3D u64_to_user_ptr(uinfo->raw_tracepoint.tp_name);
+	const char *tp_name =3D raw_tp_link->btp->tp->name;
+	size_t tp_len;
+	u32 ulen;
+
+	if (get_user(ulen, &uinfo->raw_tracepoint.tp_name_len))
+		return -EFAULT;
+	if (get_user(ubuf_ptr, &uinfo->raw_tracepoint.tp_name))
+		return -EFAULT;
+	ubuf =3D u64_to_user_ptr(ubuf_ptr);
+
+	if (ulen && !ubuf)
+		return -EINVAL;
+	if (!ubuf)
+		return 0;
+
+	tp_len =3D strlen(raw_tp_link->btp->tp->name);
+	info->raw_tracepoint.tp_name_len =3D tp_len + 1;
+	info->raw_tracepoint.tp_name =3D (u64)(unsigned long)ubuf;
+
+	if (ulen >=3D tp_len + 1) {
+		if (copy_to_user(ubuf, tp_name, tp_len + 1))
+			return -EFAULT;
+	} else {
+		char zero =3D '\0';
+
+		if (copy_to_user(ubuf, tp_name, ulen - 1))
+			return -EFAULT;
+		if (put_user(zero, ubuf + ulen - 1))
+			return -EFAULT;
+		return -ENOSPC;
+	}
+
+	return 0;
+}
+
 static const struct bpf_link_ops bpf_raw_tp_link_lops =3D {
 	.release =3D bpf_raw_tp_link_release,
 	.dealloc =3D bpf_raw_tp_link_dealloc,
+	.show_fdinfo =3D bpf_raw_tp_link_show_fdinfo,
+	.fill_link_info =3D bpf_raw_tp_link_fill_link_info,
 };
=20
 #define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
@@ -2576,7 +2665,8 @@ static int bpf_raw_tracepoint_open(const union bpf_=
attr *attr)
 		err =3D -ENOMEM;
 		goto out_put_btp;
 	}
-	bpf_link_init(&link->link, &bpf_raw_tp_link_lops, prog);
+	bpf_link_init(&link->link, BPF_LINK_TYPE_RAW_TRACEPOINT,
+		      &bpf_raw_tp_link_lops, prog);
 	link->btp =3D btp;
=20
 	err =3D bpf_link_prime(&link->link, &link_primer);
@@ -3372,6 +3462,39 @@ static int bpf_btf_get_info_by_fd(struct btf *btf,
 	return btf_get_info_by_fd(btf, attr, uattr);
 }
=20
+static int bpf_link_get_info_by_fd(struct bpf_link *link,
+				  const union bpf_attr *attr,
+				  union bpf_attr __user *uattr)
+{
+	struct bpf_link_info __user *uinfo =3D u64_to_user_ptr(attr->info.info)=
;
+	struct bpf_link_info info;
+	u32 info_len =3D attr->info.info_len;
+	int err;
+
+	err =3D bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
+	if (err)
+		return err;
+	info_len =3D min_t(u32, sizeof(info), info_len);
+
+	memset(&info, 0, sizeof(info));
+	info.type =3D link->type;
+	info.id =3D link->id;
+	info.prog_id =3D link->prog->aux->id;
+
+	if (link->ops->fill_link_info) {
+		err =3D link->ops->fill_link_info(link, &info, uinfo, info_len);
+		if (err)
+			return err;
+	}
+
+	if (copy_to_user(uinfo, &info, info_len) ||
+	    put_user(info_len, &uattr->info.info_len))
+		return -EFAULT;
+
+	return 0;
+}
+
+
 #define BPF_OBJ_GET_INFO_BY_FD_LAST_FIELD info.info
=20
 static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
@@ -3396,6 +3519,9 @@ static int bpf_obj_get_info_by_fd(const union bpf_a=
ttr *attr,
 					     uattr);
 	else if (f.file->f_op =3D=3D &btf_fops)
 		err =3D bpf_btf_get_info_by_fd(f.file->private_data, attr, uattr);
+	else if (f.file->f_op =3D=3D &bpf_link_fops)
+		err =3D bpf_link_get_info_by_fd(f.file->private_data,
+					      attr, uattr);
 	else
 		err =3D -EINVAL;
=20
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 04c6630cc18f..48dd5fc7c269 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -28,9 +28,11 @@ static const struct bpf_verifier_ops * const bpf_verif=
ier_ops[] =3D {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	[_id] =3D & _name ## _verifier_ops,
 #define BPF_MAP_TYPE(_id, _ops)
+#define BPF_LINK_TYPE(_id, _name)
 #include <linux/bpf_types.h>
 #undef BPF_PROG_TYPE
 #undef BPF_MAP_TYPE
+#undef BPF_LINK_TYPE
 };
=20
 /* bpf_check() is a static code analyzer that walks eBPF program
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 2e29a671d67e..d2f269082a33 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -113,6 +113,8 @@ enum bpf_cmd {
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
 	BPF_LINK_UPDATE,
+	BPF_LINK_GET_FD_BY_ID,
+	BPF_LINK_GET_NEXT_ID,
 };
=20
 enum bpf_map_type {
@@ -220,6 +222,15 @@ enum bpf_attach_type {
=20
 #define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
=20
+enum bpf_link_type {
+	BPF_LINK_TYPE_UNSPEC =3D 0,
+	BPF_LINK_TYPE_RAW_TRACEPOINT =3D 1,
+	BPF_LINK_TYPE_TRACING =3D 2,
+	BPF_LINK_TYPE_CGROUP =3D 3,
+
+	MAX_BPF_LINK_TYPE,
+};
+
 /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
@@ -523,6 +534,7 @@ union bpf_attr {
 			__u32		prog_id;
 			__u32		map_id;
 			__u32		btf_id;
+			__u32		link_id;
 		};
 		__u32		next_id;
 		__u32		open_flags;
@@ -3598,6 +3610,25 @@ struct bpf_btf_info {
 	__u32 id;
 } __attribute__((aligned(8)));
=20
+struct bpf_link_info {
+	__u32 type;
+	__u32 id;
+	__u32 prog_id;
+	union {
+		struct {
+			__aligned_u64 tp_name; /* in/out: tp_name buffer ptr */
+			__u32 tp_name_len;     /* in/out: tp_name buffer len */
+		} raw_tracepoint;
+		struct {
+			__u32 attach_type;
+		} tracing;
+		struct {
+			__u64 cgroup_id;
+			__u32 attach_type;
+		} cgroup;
+	};
+} __attribute__((aligned(8)));
+
 /* User bpf_sock_addr struct to access socket fields and sockaddr struct=
 passed
  * by user and intended to be used by socket (e.g. to bind to, depends o=
n
  * attach attach type).
--=20
2.24.1

