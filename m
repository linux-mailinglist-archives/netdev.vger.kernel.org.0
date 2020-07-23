Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2E922A8B0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgGWGPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:15:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgGWGPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:15:46 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N6BEsK028834
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5l/bsxjiARvXr1s6S8Gqnk7wr12eFBeVcpOXLkXpVXg=;
 b=InfhamryVqV70OzWjSg3Q74Ov+3Dpjy7XUSsdbg8Ys24KXXIu+MJDnGx9fX4w78DjFXI
 DaCpDU92AJoynMPjMM61taXMtQaMgool2xZ04z1YF8OycvG/YG9bTXbE3jwEzcrfe1bh
 qj+3ObfL2SYZdFIZ1HkZv2qh1QWL/LsoNRY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32etbg2np9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:44 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 23:15:41 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 9F2DD3705266; Wed, 22 Jul 2020 23:15:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 04/13] bpf: implement bpf iterator for map elements
Date:   Wed, 22 Jul 2020 23:15:37 -0700
Message-ID: <20200723061537.2100144-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723061533.2099842-1-yhs@fb.com>
References: <20200723061533.2099842-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_02:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 suspectscore=25 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007230050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf iterator for map elements are implemented.
The bpf program will receive four parameters:
  bpf_iter_meta *meta: the meta data
  bpf_map *map:        the bpf_map whose elements are traversed
  void *key:           the key of one element
  void *value:         the value of the same element

Here, meta and map pointers are always valid, and
key has register type PTR_TO_RDONLY_BUF_OR_NULL and
value has register type PTR_TO_RDWR_BUF_OR_NULL.
The kernel will track the access range of key and value
during verification time. Later, these values will be compared
against the values in the actual map to ensure all accesses
are within range.

A new field iter_seq_info is added to bpf_map_ops which
is used to add map type specific information, i.e., seq_ops,
init/fini seq_file func and seq_file private data size.
Subsequent patches will have actual implementation
for bpf_map_ops->iter_seq_info.

In user space, BPF_ITER_LINK_MAP_FD needs to be
specified in prog attr->link_create.flags, which indicates
that attr->link_create.target_fd is a map_fd.
The reason for such an explicit flag is for possible
future cases where one bpf iterator may allow more than
one possible customization, e.g., pid and cgroup id for
task_file.

Current kernel internal implementation only allows
the target to register at most one required bpf_iter_link_info.
To support the above case, optional bpf_iter_link_info's
are needed, the target can be extended to register such link
infos, and user provided link_info needs to match one of
target supported ones.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            | 16 ++++++
 include/uapi/linux/bpf.h       |  7 +++
 kernel/bpf/bpf_iter.c          | 89 ++++++++++++++++++++++++++--------
 kernel/bpf/map_iter.c          | 30 +++++++++++-
 tools/include/uapi/linux/bpf.h |  7 +++
 5 files changed, 129 insertions(+), 20 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f9c4bb08f616..4175cf1f4665 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -107,6 +107,9 @@ struct bpf_map_ops {
 	/* BTF name and id of struct allocated by map_alloc */
 	const char * const map_btf_name;
 	int *map_btf_id;
+
+	/* bpf_iter info used to open a seq_file */
+	const struct bpf_iter_seq_info *iter_seq_info;
 };
=20
 struct bpf_map_memory {
@@ -1207,12 +1210,18 @@ int bpf_obj_get_user(const char __user *pathname,=
 int flags);
 	int __init bpf_iter_ ## target(args) { return 0; }
=20
 struct bpf_iter_aux_info {
+	struct bpf_map *map;
 };
=20
+typedef int (*bpf_iter_check_target_t)(struct bpf_prog *prog,
+				       struct bpf_iter_aux_info *aux);
+
 #define BPF_ITER_CTX_ARG_MAX 2
 struct bpf_iter_reg {
 	const char *target;
+	bpf_iter_check_target_t check_target;
 	u32 ctx_arg_info_size;
+	enum bpf_iter_link_info req_linfo;
 	struct bpf_ctx_arg_aux ctx_arg_info[BPF_ITER_CTX_ARG_MAX];
 	const struct bpf_iter_seq_info *seq_info;
 };
@@ -1223,6 +1232,13 @@ struct bpf_iter_meta {
 	u64 seq_num;
 };
=20
+struct bpf_iter__bpf_map_elem {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct bpf_map *, map);
+	__bpf_md_ptr(void *, key);
+	__bpf_md_ptr(void *, value);
+};
+
 int bpf_iter_reg_target(const struct bpf_iter_reg *reg_info);
 void bpf_iter_unreg_target(const struct bpf_iter_reg *reg_info);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 54d0c886e3ba..828c2f6438f2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -246,6 +246,13 @@ enum bpf_link_type {
 	MAX_BPF_LINK_TYPE,
 };
=20
+enum bpf_iter_link_info {
+	BPF_ITER_LINK_UNSPEC =3D 0,
+	BPF_ITER_LINK_MAP_FD =3D 1,
+
+	MAX_BPF_ITER_LINK_INFO,
+};
+
 /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 8fa94cb1b5a0..1fa7e6eda411 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -14,11 +14,13 @@ struct bpf_iter_target_info {
=20
 struct bpf_iter_link {
 	struct bpf_link link;
+	struct bpf_iter_aux_info aux;
 	struct bpf_iter_target_info *tinfo;
 };
=20
 struct bpf_iter_priv_data {
 	struct bpf_iter_target_info *tinfo;
+	const struct bpf_iter_seq_info *seq_info;
 	struct bpf_prog *prog;
 	u64 session_id;
 	u64 seq_num;
@@ -35,7 +37,8 @@ static DEFINE_MUTEX(link_mutex);
 /* incremented on every opened seq_file */
 static atomic64_t session_id;
=20
-static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k);
+static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k,
+			    const struct bpf_iter_seq_info *seq_info);
=20
 static void bpf_iter_inc_seq_num(struct seq_file *seq)
 {
@@ -199,11 +202,25 @@ static ssize_t bpf_seq_read(struct file *file, char=
 __user *buf, size_t size,
 	return copied;
 }
=20
+static const struct bpf_iter_seq_info *
+__get_seq_info(struct bpf_iter_link *link)
+{
+	const struct bpf_iter_seq_info *seq_info;
+
+	if (link->aux.map) {
+		seq_info =3D link->aux.map->ops->iter_seq_info;
+		if (seq_info)
+			return seq_info;
+	}
+
+	return link->tinfo->reg_info->seq_info;
+}
+
 static int iter_open(struct inode *inode, struct file *file)
 {
 	struct bpf_iter_link *link =3D inode->i_private;
=20
-	return prepare_seq_file(file, link);
+	return prepare_seq_file(file, link, __get_seq_info(link));
 }
=20
 static int iter_release(struct inode *inode, struct file *file)
@@ -218,8 +235,8 @@ static int iter_release(struct inode *inode, struct f=
ile *file)
 	iter_priv =3D container_of(seq->private, struct bpf_iter_priv_data,
 				 target_private);
=20
-	if (iter_priv->tinfo->reg_info->seq_info->fini_seq_private)
-		iter_priv->tinfo->reg_info->seq_info->fini_seq_private(seq->private);
+	if (iter_priv->seq_info->fini_seq_private)
+		iter_priv->seq_info->fini_seq_private(seq->private);
=20
 	bpf_prog_put(iter_priv->prog);
 	seq->private =3D iter_priv;
@@ -318,6 +335,11 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
=20
 static void bpf_iter_link_release(struct bpf_link *link)
 {
+	struct bpf_iter_link *iter_link =3D
+		container_of(link, struct bpf_iter_link, link);
+
+	if (iter_link->aux.map)
+		bpf_map_put_with_uref(iter_link->aux.map);
 }
=20
 static void bpf_iter_link_dealloc(struct bpf_link *link)
@@ -370,14 +392,13 @@ int bpf_iter_link_attach(const union bpf_attr *attr=
, struct bpf_prog *prog)
 {
 	struct bpf_link_primer link_primer;
 	struct bpf_iter_target_info *tinfo;
+	struct bpf_iter_aux_info aux =3D {};
 	struct bpf_iter_link *link;
+	u32 prog_btf_id, target_fd;
 	bool existed =3D false;
-	u32 prog_btf_id;
+	struct bpf_map *map;
 	int err;
=20
-	if (attr->link_create.target_fd || attr->link_create.flags)
-		return -EINVAL;
-
 	prog_btf_id =3D prog->aux->attach_btf_id;
 	mutex_lock(&targets_mutex);
 	list_for_each_entry(tinfo, &targets, list) {
@@ -390,6 +411,13 @@ int bpf_iter_link_attach(const union bpf_attr *attr,=
 struct bpf_prog *prog)
 	if (!existed)
 		return -ENOENT;
=20
+	/* Make sure user supplied flags are target expected. */
+	target_fd =3D attr->link_create.target_fd;
+	if (attr->link_create.flags !=3D tinfo->reg_info->req_linfo)
+		return -EINVAL;
+	if (!attr->link_create.flags && target_fd)
+		return -EINVAL;
+
 	link =3D kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
 	if (!link)
 		return -ENOMEM;
@@ -398,26 +426,48 @@ int bpf_iter_link_attach(const union bpf_attr *attr=
, struct bpf_prog *prog)
 	link->tinfo =3D tinfo;
=20
 	err  =3D bpf_link_prime(&link->link, &link_primer);
-	if (err) {
-		kfree(link);
-		return err;
+	if (err)
+		goto free_link;
+
+	if (tinfo->reg_info->req_linfo =3D=3D BPF_ITER_LINK_MAP_FD) {
+		map =3D bpf_map_get_with_uref(target_fd);
+		if (IS_ERR(map)) {
+			err =3D PTR_ERR(map);
+			goto free_link;
+		}
+
+		aux.map =3D map;
+		err =3D tinfo->reg_info->check_target(prog, &aux);
+		if (err) {
+			bpf_map_put_with_uref(map);
+			goto free_link;
+		}
+
+		link->aux.map =3D map;
 	}
=20
 	return bpf_link_settle(&link_primer);
+
+free_link:
+	kfree(link);
+	return err;
 }
=20
 static void init_seq_meta(struct bpf_iter_priv_data *priv_data,
 			  struct bpf_iter_target_info *tinfo,
+			  const struct bpf_iter_seq_info *seq_info,
 			  struct bpf_prog *prog)
 {
 	priv_data->tinfo =3D tinfo;
+	priv_data->seq_info =3D seq_info;
 	priv_data->prog =3D prog;
 	priv_data->session_id =3D atomic64_inc_return(&session_id);
 	priv_data->seq_num =3D 0;
 	priv_data->done_stop =3D false;
 }
=20
-static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k)
+static int prepare_seq_file(struct file *file, struct bpf_iter_link *lin=
k,
+			    const struct bpf_iter_seq_info *seq_info)
 {
 	struct bpf_iter_priv_data *priv_data;
 	struct bpf_iter_target_info *tinfo;
@@ -433,21 +483,21 @@ static int prepare_seq_file(struct file *file, stru=
ct bpf_iter_link *link)
=20
 	tinfo =3D link->tinfo;
 	total_priv_dsize =3D offsetof(struct bpf_iter_priv_data, target_private=
) +
-			   tinfo->reg_info->seq_info->seq_priv_size;
-	priv_data =3D __seq_open_private(file, tinfo->reg_info->seq_info->seq_o=
ps,
+			   seq_info->seq_priv_size;
+	priv_data =3D __seq_open_private(file, seq_info->seq_ops,
 				       total_priv_dsize);
 	if (!priv_data) {
 		err =3D -ENOMEM;
 		goto release_prog;
 	}
=20
-	if (tinfo->reg_info->seq_info->init_seq_private) {
-		err =3D tinfo->reg_info->seq_info->init_seq_private(priv_data->target_=
private, NULL);
+	if (seq_info->init_seq_private) {
+		err =3D seq_info->init_seq_private(priv_data->target_private, &link->a=
ux);
 		if (err)
 			goto release_seq_file;
 	}
=20
-	init_seq_meta(priv_data, tinfo, prog);
+	init_seq_meta(priv_data, tinfo, seq_info, prog);
 	seq =3D file->private_data;
 	seq->private =3D priv_data->target_private;
=20
@@ -463,6 +513,7 @@ static int prepare_seq_file(struct file *file, struct=
 bpf_iter_link *link)
=20
 int bpf_iter_new_fd(struct bpf_link *link)
 {
+	struct bpf_iter_link *iter_link;
 	struct file *file;
 	unsigned int flags;
 	int err, fd;
@@ -481,8 +532,8 @@ int bpf_iter_new_fd(struct bpf_link *link)
 		goto free_fd;
 	}
=20
-	err =3D prepare_seq_file(file,
-			       container_of(link, struct bpf_iter_link, link));
+	iter_link =3D container_of(link, struct bpf_iter_link, link);
+	err =3D prepare_seq_file(file, iter_link, __get_seq_info(iter_link));
 	if (err)
 		goto free_file;
=20
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index 1a69241fb1e2..8a1f9b3355d0 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -98,10 +98,38 @@ static struct bpf_iter_reg bpf_map_reg_info =3D {
 	.seq_info		=3D &bpf_map_seq_info,
 };
=20
+static int bpf_iter_check_map(struct bpf_prog *prog,
+			      struct bpf_iter_aux_info *aux)
+{
+	return -EINVAL;
+}
+
+DEFINE_BPF_ITER_FUNC(bpf_map_elem, struct bpf_iter_meta *meta,
+		     struct bpf_map *map, void *key, void *value)
+
+static const struct bpf_iter_reg bpf_map_elem_reg_info =3D {
+	.target			=3D "bpf_map_elem",
+	.check_target		=3D bpf_iter_check_map,
+	.req_linfo		=3D BPF_ITER_LINK_MAP_FD,
+	.ctx_arg_info_size	=3D 2,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__bpf_map_elem, key),
+		  PTR_TO_RDONLY_BUF_OR_NULL },
+		{ offsetof(struct bpf_iter__bpf_map_elem, value),
+		  PTR_TO_RDWR_BUF_OR_NULL },
+	},
+};
+
 static int __init bpf_map_iter_init(void)
 {
+	int ret;
+
 	bpf_map_reg_info.ctx_arg_info[0].btf_id =3D *btf_bpf_map_id;
-	return bpf_iter_reg_target(&bpf_map_reg_info);
+	ret =3D bpf_iter_reg_target(&bpf_map_reg_info);
+	if (ret)
+		return ret;
+
+	return bpf_iter_reg_target(&bpf_map_elem_reg_info);
 }
=20
 late_initcall(bpf_map_iter_init);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 54d0c886e3ba..828c2f6438f2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -246,6 +246,13 @@ enum bpf_link_type {
 	MAX_BPF_LINK_TYPE,
 };
=20
+enum bpf_iter_link_info {
+	BPF_ITER_LINK_UNSPEC =3D 0,
+	BPF_ITER_LINK_MAP_FD =3D 1,
+
+	MAX_BPF_ITER_LINK_INFO,
+};
+
 /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
--=20
2.24.1

