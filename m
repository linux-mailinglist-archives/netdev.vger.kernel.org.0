Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247D4235512
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 06:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgHBEVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 00:21:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65532 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725866AbgHBEVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 00:21:35 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0724KriP010452
        for <netdev@vger.kernel.org>; Sat, 1 Aug 2020 21:21:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ltx9oI+47fjPZJRo8gjzRx/LKfbKly/CYNjUU0Iv/UY=;
 b=D0wvABqmdEp+qrehNAI5yYJaCq/ZpWmKrovmKPglpOOXiMlJUsmZ90ykdKmb7sNKHRgP
 biSuIY+cS3/rcRyJ6V8drb3SxzOZbxuNI5bDGfkD61BH5dDmGwTg2uOSBZPg/0QMjs5D
 Z8y3RCMLJeHiHmFq6rAmVuTCqiDOmrmrSSA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32n81y23xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 21:21:33 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 1 Aug 2020 21:21:31 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 68578370529D; Sat,  1 Aug 2020 21:21:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/2] bpf: change uapi for bpf iterator map elements
Date:   Sat, 1 Aug 2020 21:21:26 -0700
Message-ID: <20200802042126.2119843-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200802042126.2119783-1-yhs@fb.com>
References: <20200802042126.2119783-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-02_01:2020-07-31,2020-08-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=8
 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008020033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a5cbe05a6673 ("bpf: Implement bpf iterator for
map elements") added bpf iterator support for
map elements. The map element bpf iterator requires
info to identify a particular map. In the above
commit, the attr->link_create.target_fd is used
to carry map_fd and an enum bpf_iter_link_info
is added to uapi to specify the target_fd actually
representing a map_fd:
    enum bpf_iter_link_info {
	BPF_ITER_LINK_UNSPEC =3D 0,
	BPF_ITER_LINK_MAP_FD =3D 1,

	MAX_BPF_ITER_LINK_INFO,
    };

This is an extensible approach as we can grow
enumerator for pid, cgroup_id, etc. and we can
unionize target_fd for pid, cgroup_id, etc.
But in the future, there are chances that
more complex customization may happen, e.g.,
for tasks, it could be filtered based on
both cgroup_id and user_id.

This patch changed the uapi to have fields
	__aligned_u64	iter_info;
	__u32		iter_info_len;
for additional iter_info for link_create.
The iter_info is defined as
	union bpf_iter_link_info {
		struct {
			__u32   map_fd;
		} map;
	};

So future extension for additional customization
will be easier. The bpf_iter_link_info will be
passed to target callback to validate and generic
bpf_iter framework does not need to deal it any
more.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            | 10 ++++---
 include/uapi/linux/bpf.h       | 15 +++++-----
 kernel/bpf/bpf_iter.c          | 52 +++++++++++++++-------------------
 kernel/bpf/map_iter.c          | 37 ++++++++++++++++++------
 kernel/bpf/syscall.c           |  2 +-
 net/core/bpf_sk_storage.c      | 37 ++++++++++++++++++------
 tools/include/uapi/linux/bpf.h | 15 +++++-----
 7 files changed, 104 insertions(+), 64 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cef4ef0d2b4e..55f694b63164 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1214,15 +1214,17 @@ struct bpf_iter_aux_info {
 	struct bpf_map *map;
 };
=20
-typedef int (*bpf_iter_check_target_t)(struct bpf_prog *prog,
-				       struct bpf_iter_aux_info *aux);
+typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
+					union bpf_iter_link_info *linfo,
+					struct bpf_iter_aux_info *aux);
+typedef void (*bpf_iter_detach_target_t)(struct bpf_iter_aux_info *aux);
=20
 #define BPF_ITER_CTX_ARG_MAX 2
 struct bpf_iter_reg {
 	const char *target;
-	bpf_iter_check_target_t check_target;
+	bpf_iter_attach_target_t attach_target;
+	bpf_iter_detach_target_t detach_target;
 	u32 ctx_arg_info_size;
-	enum bpf_iter_link_info req_linfo;
 	struct bpf_ctx_arg_aux ctx_arg_info[BPF_ITER_CTX_ARG_MAX];
 	const struct bpf_iter_seq_info *seq_info;
 };
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b134e679e9db..0480f893facd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -81,6 +81,12 @@ struct bpf_cgroup_storage_key {
 	__u32	attach_type;		/* program attach type */
 };
=20
+union bpf_iter_link_info {
+	struct {
+		__u32	map_fd;
+	} map;
+};
+
 /* BPF syscall commands, see bpf(2) man-page for details. */
 enum bpf_cmd {
 	BPF_MAP_CREATE,
@@ -249,13 +255,6 @@ enum bpf_link_type {
 	MAX_BPF_LINK_TYPE,
 };
=20
-enum bpf_iter_link_info {
-	BPF_ITER_LINK_UNSPEC =3D 0,
-	BPF_ITER_LINK_MAP_FD =3D 1,
-
-	MAX_BPF_ITER_LINK_INFO,
-};
-
 /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
@@ -623,6 +622,8 @@ union bpf_attr {
 		};
 		__u32		attach_type;	/* attach type */
 		__u32		flags;		/* extra flags */
+		__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
+		__u32		iter_info_len;	/* iter_info length */
 	} link_create;
=20
 	struct { /* struct used by BPF_LINK_UPDATE command */
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 363b9cafc2d8..20d62020807f 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -338,8 +338,8 @@ static void bpf_iter_link_release(struct bpf_link *li=
nk)
 	struct bpf_iter_link *iter_link =3D
 		container_of(link, struct bpf_iter_link, link);
=20
-	if (iter_link->aux.map)
-		bpf_map_put_with_uref(iter_link->aux.map);
+	if (iter_link->tinfo->reg_info->detach_target)
+		iter_link->tinfo->reg_info->detach_target(&iter_link->aux);
 }
=20
 static void bpf_iter_link_dealloc(struct bpf_link *link)
@@ -390,15 +390,29 @@ bool bpf_link_is_iter(struct bpf_link *link)
=20
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og)
 {
+	union bpf_iter_link_info __user *ulinfo;
 	struct bpf_link_primer link_primer;
 	struct bpf_iter_target_info *tinfo;
-	struct bpf_iter_aux_info aux =3D {};
+	union bpf_iter_link_info linfo;
 	struct bpf_iter_link *link;
-	u32 prog_btf_id, target_fd;
+	u32 prog_btf_id, linfo_len;
 	bool existed =3D false;
-	struct bpf_map *map;
 	int err;
=20
+	memset(&linfo, 0, sizeof(union bpf_iter_link_info));
+
+	ulinfo =3D u64_to_user_ptr(attr->link_create.iter_info);
+	linfo_len =3D attr->link_create.iter_info_len;
+	if (ulinfo && linfo_len) {
+		err =3D bpf_check_uarg_tail_zero(ulinfo, sizeof(linfo),
+					       linfo_len);
+		if (err)
+			return err;
+		linfo_len =3D min_t(u32, linfo_len, sizeof(linfo));
+		if (copy_from_user(&linfo, ulinfo, linfo_len))
+			return -EFAULT;
+	}
+
 	prog_btf_id =3D prog->aux->attach_btf_id;
 	mutex_lock(&targets_mutex);
 	list_for_each_entry(tinfo, &targets, list) {
@@ -411,13 +425,6 @@ int bpf_iter_link_attach(const union bpf_attr *attr,=
 struct bpf_prog *prog)
 	if (!existed)
 		return -ENOENT;
=20
-	/* Make sure user supplied flags are target expected. */
-	target_fd =3D attr->link_create.target_fd;
-	if (attr->link_create.flags !=3D tinfo->reg_info->req_linfo)
-		return -EINVAL;
-	if (!attr->link_create.flags && target_fd)
-		return -EINVAL;
-
 	link =3D kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
 	if (!link)
 		return -ENOMEM;
@@ -431,28 +438,15 @@ int bpf_iter_link_attach(const union bpf_attr *attr=
, struct bpf_prog *prog)
 		return err;
 	}
=20
-	if (tinfo->reg_info->req_linfo =3D=3D BPF_ITER_LINK_MAP_FD) {
-		map =3D bpf_map_get_with_uref(target_fd);
-		if (IS_ERR(map)) {
-			err =3D PTR_ERR(map);
-			goto cleanup_link;
-		}
-
-		aux.map =3D map;
-		err =3D tinfo->reg_info->check_target(prog, &aux);
+	if (tinfo->reg_info->attach_target) {
+		err =3D tinfo->reg_info->attach_target(prog, &linfo, &link->aux);
 		if (err) {
-			bpf_map_put_with_uref(map);
-			goto cleanup_link;
+			bpf_link_cleanup(&link_primer);
+			return err;
 		}
-
-		link->aux.map =3D map;
 	}
=20
 	return bpf_link_settle(&link_primer);
-
-cleanup_link:
-	bpf_link_cleanup(&link_primer);
-	return err;
 }
=20
 static void init_seq_meta(struct bpf_iter_priv_data *priv_data,
diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index fbe1f557cb88..131603fe1cbf 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -98,12 +98,21 @@ static struct bpf_iter_reg bpf_map_reg_info =3D {
 	.seq_info		=3D &bpf_map_seq_info,
 };
=20
-static int bpf_iter_check_map(struct bpf_prog *prog,
-			      struct bpf_iter_aux_info *aux)
+static int bpf_iter_attach_map(struct bpf_prog *prog,
+			       union bpf_iter_link_info *linfo,
+			       struct bpf_iter_aux_info *aux)
 {
 	u32 key_acc_size, value_acc_size, key_size, value_size;
-	struct bpf_map *map =3D aux->map;
+	struct bpf_map *map;
 	bool is_percpu =3D false;
+	int err =3D -EINVAL;
+
+	if (!linfo->map.map_fd)
+		return -EINVAL;
+
+	map =3D bpf_map_get_with_uref(linfo->map.map_fd);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
=20
 	if (map->map_type =3D=3D BPF_MAP_TYPE_PERCPU_HASH ||
 	    map->map_type =3D=3D BPF_MAP_TYPE_LRU_PERCPU_HASH ||
@@ -112,7 +121,7 @@ static int bpf_iter_check_map(struct bpf_prog *prog,
 	else if (map->map_type !=3D BPF_MAP_TYPE_HASH &&
 		 map->map_type !=3D BPF_MAP_TYPE_LRU_HASH &&
 		 map->map_type !=3D BPF_MAP_TYPE_ARRAY)
-		return -EINVAL;
+		goto put_map;
=20
 	key_acc_size =3D prog->aux->max_rdonly_access;
 	value_acc_size =3D prog->aux->max_rdwr_access;
@@ -122,10 +131,22 @@ static int bpf_iter_check_map(struct bpf_prog *prog=
,
 	else
 		value_size =3D round_up(map->value_size, 8) * num_possible_cpus();
=20
-	if (key_acc_size > key_size || value_acc_size > value_size)
-		return -EACCES;
+	if (key_acc_size > key_size || value_acc_size > value_size) {
+		err =3D -EACCES;
+		goto put_map;
+	}
=20
+	aux->map =3D map;
 	return 0;
+
+put_map:
+	bpf_map_put_with_uref(map);
+	return err;
+}
+
+static void bpf_iter_detach_map(struct bpf_iter_aux_info *aux)
+{
+	bpf_map_put_with_uref(aux->map);
 }
=20
 DEFINE_BPF_ITER_FUNC(bpf_map_elem, struct bpf_iter_meta *meta,
@@ -133,8 +154,8 @@ DEFINE_BPF_ITER_FUNC(bpf_map_elem, struct bpf_iter_me=
ta *meta,
=20
 static const struct bpf_iter_reg bpf_map_elem_reg_info =3D {
 	.target			=3D "bpf_map_elem",
-	.check_target		=3D bpf_iter_check_map,
-	.req_linfo		=3D BPF_ITER_LINK_MAP_FD,
+	.attach_target		=3D bpf_iter_attach_map,
+	.detach_target		=3D bpf_iter_detach_map,
 	.ctx_arg_info_size	=3D 2,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__bpf_map_elem, key),
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2f343ce15747..86299a292214 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3883,7 +3883,7 @@ static int tracing_bpf_link_attach(const union bpf_=
attr *attr, struct bpf_prog *
 	return -EINVAL;
 }
=20
-#define BPF_LINK_CREATE_LAST_FIELD link_create.flags
+#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
 static int link_create(union bpf_attr *attr)
 {
 	enum bpf_prog_type ptype;
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index d3377c90a291..6c0bdb5a0b26 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -1384,18 +1384,39 @@ static int bpf_iter_init_sk_storage_map(void *pri=
v_data,
 	return 0;
 }
=20
-static int bpf_iter_check_map(struct bpf_prog *prog,
-			      struct bpf_iter_aux_info *aux)
+static int bpf_iter_attach_map(struct bpf_prog *prog,
+			       union bpf_iter_link_info *linfo,
+			       struct bpf_iter_aux_info *aux)
 {
-	struct bpf_map *map =3D aux->map;
+	struct bpf_map *map;
+	int err =3D -EINVAL;
=20
-	if (map->map_type !=3D BPF_MAP_TYPE_SK_STORAGE)
+	if (!linfo->map.map_fd)
 		return -EINVAL;
=20
-	if (prog->aux->max_rdonly_access > map->value_size)
-		return -EACCES;
+	map =3D bpf_map_get_with_uref(linfo->map.map_fd);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	if (map->map_type !=3D BPF_MAP_TYPE_SK_STORAGE)
+		goto put_map;
+
+	if (prog->aux->max_rdonly_access > map->value_size) {
+		err =3D -EACCES;
+		goto put_map;
+	}
=20
+	aux->map =3D map;
 	return 0;
+
+put_map:
+	bpf_map_put_with_uref(map);
+	return err;
+}
+
+static void bpf_iter_detach_map(struct bpf_iter_aux_info *aux)
+{
+	bpf_map_put_with_uref(aux->map);
 }
=20
 static const struct seq_operations bpf_sk_storage_map_seq_ops =3D {
@@ -1414,8 +1435,8 @@ static const struct bpf_iter_seq_info iter_seq_info=
 =3D {
=20
 static struct bpf_iter_reg bpf_sk_storage_map_reg_info =3D {
 	.target			=3D "bpf_sk_storage_map",
-	.check_target		=3D bpf_iter_check_map,
-	.req_linfo		=3D BPF_ITER_LINK_MAP_FD,
+	.attach_target		=3D bpf_iter_attach_map,
+	.detach_target		=3D bpf_iter_detach_map,
 	.ctx_arg_info_size	=3D 2,
 	.ctx_arg_info		=3D {
 		{ offsetof(struct bpf_iter__bpf_sk_storage_map, sk),
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index b134e679e9db..0480f893facd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -81,6 +81,12 @@ struct bpf_cgroup_storage_key {
 	__u32	attach_type;		/* program attach type */
 };
=20
+union bpf_iter_link_info {
+	struct {
+		__u32	map_fd;
+	} map;
+};
+
 /* BPF syscall commands, see bpf(2) man-page for details. */
 enum bpf_cmd {
 	BPF_MAP_CREATE,
@@ -249,13 +255,6 @@ enum bpf_link_type {
 	MAX_BPF_LINK_TYPE,
 };
=20
-enum bpf_iter_link_info {
-	BPF_ITER_LINK_UNSPEC =3D 0,
-	BPF_ITER_LINK_MAP_FD =3D 1,
-
-	MAX_BPF_ITER_LINK_INFO,
-};
-
 /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
@@ -623,6 +622,8 @@ union bpf_attr {
 		};
 		__u32		attach_type;	/* attach type */
 		__u32		flags;		/* extra flags */
+		__aligned_u64	iter_info;	/* extra bpf_iter_link_info */
+		__u32		iter_info_len;	/* iter_info length */
 	} link_create;
=20
 	struct { /* struct used by BPF_LINK_UPDATE command */
--=20
2.24.1

