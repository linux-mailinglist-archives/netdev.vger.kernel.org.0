Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113F81AB1CE
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633297AbgDOTc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:32:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46238 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407077AbgDOT2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03FJSCir007612
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=csV7CddIlvWoRtIWqh3RbrfW9v/5I//mbv5nrjj/WN8=;
 b=TAJOfQRo7RmfW/sMIKCpJpsArYcLOgrrrYVHeFwtdgdEAc6qwywMsQE1vlzoj7wD6xEM
 Kvm9aMFI1RpSXaHP75p6PtT4/oa35Viz92rHHfjQeYnV+RkPQApJkwvQde/Mm2zdHOLW
 Kw0k3o3CvLk5YStUhVwjTR+N8TyDUeafy4E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30dn7fymmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:12 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:46 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7B5F33700AF5; Wed, 15 Apr 2020 12:27:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 04/17] bpf: allow loading of a dumper program
Date:   Wed, 15 Apr 2020 12:27:44 -0700
Message-ID: <20200415192744.4082950-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=2 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A dumper bpf program is a tracing program with attach type
BPF_TRACE_DUMP. During bpf program load, the load attribute
   attach_prog_fd
carries the target directory fd. The program will be
verified against btf_id of the target_proto.

If the program is loaded successfully, the dump target, as
represented as a relative path to /sys/kernel/bpfdump,
will be remembered in prog->aux->dump_target, which will
be used later to create dumpers.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |  2 ++
 include/uapi/linux/bpf.h       |  6 ++++-
 kernel/bpf/dump.c              | 42 ++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  8 ++++++-
 kernel/bpf/verifier.c          | 15 ++++++++++++
 tools/include/uapi/linux/bpf.h |  6 ++++-
 6 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 84c7eb40d7bc..068552c2d2cf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -674,6 +674,7 @@ struct bpf_prog_aux {
 	struct bpf_map **used_maps;
 	struct bpf_prog *prog;
 	struct user_struct *user;
+	const char *dump_target;
 	u64 load_time; /* ns since boottime */
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	char name[BPF_OBJ_NAME_LEN];
@@ -1120,6 +1121,7 @@ struct bpf_dump_reg {
 };
=20
 int bpf_dump_reg_target(struct bpf_dump_reg *reg_info);
+int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2e29a671d67e..f92b919c723e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -215,6 +215,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_TRACE_DUMP,
 	__MAX_BPF_ATTACH_TYPE
 };
=20
@@ -476,7 +477,10 @@ union bpf_attr {
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
 		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
-		__u32		attach_prog_fd; /* 0 to attach to vmlinux */
+		union {
+			__u32		attach_prog_fd; /* 0 to attach to vmlinux */
+			__u32		attach_target_fd;
+		};
 	};
=20
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index e8b46f9e0ee0..8c7a89800312 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -11,6 +11,9 @@
 #include <linux/fs_parser.h>
 #include <linux/filter.h>
 #include <linux/bpf.h>
+#include <linux/btf.h>
+
+extern struct btf *btf_vmlinux;
=20
 struct bpfdump_target_info {
 	struct list_head list;
@@ -51,6 +54,45 @@ static const struct inode_operations bpfdump_dir_iops =
=3D {
 	.unlink		=3D dumper_unlink,
 };
=20
+int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog)
+{
+	struct bpfdump_target_info *tinfo;
+	const char *target_proto;
+	struct file *target_file;
+	struct fd tfd;
+	int err =3D 0, btf_id;
+
+	if (!btf_vmlinux)
+		return -EINVAL;
+
+	tfd =3D fdget(target_fd);
+	target_file =3D tfd.file;
+	if (!target_file)
+		return -EBADF;
+
+	if (target_file->f_inode->i_op !=3D &bpfdump_dir_iops) {
+		err =3D -EINVAL;
+		goto done;
+	}
+
+	tinfo =3D target_file->f_inode->i_private;
+	target_proto =3D tinfo->target_proto;
+	btf_id =3D btf_find_by_name_kind(btf_vmlinux, target_proto,
+				       BTF_KIND_FUNC);
+
+	if (btf_id < 0) {
+		err =3D btf_id;
+		goto done;
+	}
+
+	prog->aux->dump_target =3D tinfo->target;
+	prog->aux->attach_btf_id =3D btf_id;
+
+done:
+	fdput(tfd);
+	return err;
+}
+
 int bpf_dump_reg_target(struct bpf_dump_reg *reg_info)
 {
 	struct bpfdump_target_info *tinfo, *ptinfo;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 64783da34202..1ce2f74f8efc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2060,7 +2060,12 @@ static int bpf_prog_load(union bpf_attr *attr, uni=
on bpf_attr __user *uattr)
=20
 	prog->expected_attach_type =3D attr->expected_attach_type;
 	prog->aux->attach_btf_id =3D attr->attach_btf_id;
-	if (attr->attach_prog_fd) {
+	if (type =3D=3D BPF_PROG_TYPE_TRACING &&
+	    attr->expected_attach_type =3D=3D BPF_TRACE_DUMP) {
+		err =3D bpf_dump_set_target_info(attr->attach_target_fd, prog);
+		if (err)
+			goto free_prog_nouncharge;
+	} else if (attr->attach_prog_fd) {
 		struct bpf_prog *tgt_prog;
=20
 		tgt_prog =3D bpf_prog_get(attr->attach_prog_fd);
@@ -2145,6 +2150,7 @@ static int bpf_prog_load(union bpf_attr *attr, unio=
n bpf_attr __user *uattr)
 	err =3D bpf_prog_new_fd(prog);
 	if (err < 0)
 		bpf_prog_put(prog);
+
 	return err;
=20
 free_used_maps:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 04c6630cc18f..f531cee24fc5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10426,6 +10426,7 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
 	struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
 	u32 btf_id =3D prog->aux->attach_btf_id;
 	const char prefix[] =3D "btf_trace_";
+	struct btf_func_model fmodel;
 	int ret =3D 0, subprog =3D -1, i;
 	struct bpf_trampoline *tr;
 	const struct btf_type *t;
@@ -10566,6 +10567,20 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
 		prog->aux->attach_func_proto =3D t;
 		prog->aux->attach_btf_trace =3D true;
 		return 0;
+	case BPF_TRACE_DUMP:
+		if (!btf_type_is_func(t)) {
+			verbose(env, "attach_btf_id %u is not a function\n",
+				btf_id);
+			return -EINVAL;
+		}
+		t =3D btf_type_by_id(btf, t->type);
+		if (!btf_type_is_func_proto(t))
+			return -EINVAL;
+		prog->aux->attach_func_name =3D tname;
+		prog->aux->attach_func_proto =3D t;
+		ret =3D btf_distill_func_proto(&env->log, btf, t,
+					     tname, &fmodel);
+		return ret;
 	default:
 		if (!prog_extension)
 			return -EINVAL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 2e29a671d67e..f92b919c723e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -215,6 +215,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_TRACE_DUMP,
 	__MAX_BPF_ATTACH_TYPE
 };
=20
@@ -476,7 +477,10 @@ union bpf_attr {
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
 		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
-		__u32		attach_prog_fd; /* 0 to attach to vmlinux */
+		union {
+			__u32		attach_prog_fd; /* 0 to attach to vmlinux */
+			__u32		attach_target_fd;
+		};
 	};
=20
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
--=20
2.24.1

