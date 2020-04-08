Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086701A2C47
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgDHX0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:26:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14460 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726699AbgDHXZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:55 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 038NPjHl019373
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xAQDZIfES9Gj1GnCxGUljbWcEITqX2/G8lxVxqvIGH8=;
 b=ExFYxBkIHTRDQ0EgYxP39sZ67maaUwWXPMYab0hJN0pkL5o48+RI3nNI9Qczk/tIc9Pv
 TB9nYXvknKDxB+0R+NXvhwdE4R39rZ3Bu8hY+R5btDuiLNm1a3bAYORD8O4a44oQzll3
 sV2/HY1p3BRYzv8f9nY5BMDhgn+5wwgGyzo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3091m37bp8-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:55 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:35 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 06ABF3700D98; Wed,  8 Apr 2020 16:25:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 04/16] bpf: allow loading of a dumper program
Date:   Wed, 8 Apr 2020 16:25:24 -0700
Message-ID: <20200408232524.2675603-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 suspectscore=2 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080164
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
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/dump.c              | 40 ++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  8 ++++++-
 kernel/bpf/verifier.c          | 15 +++++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 6 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 53914bec7590..44268d36d901 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -673,6 +673,7 @@ struct bpf_prog_aux {
 	struct bpf_map **used_maps;
 	struct bpf_prog *prog;
 	struct user_struct *user;
+	const char *dump_target;
 	u64 load_time; /* ns since boottime */
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	char name[BPF_OBJ_NAME_LEN];
@@ -1112,6 +1113,7 @@ int bpf_obj_get_user(const char __user *pathname, i=
nt flags);
 int bpf_dump_reg_target(const char *target, const char *target_proto,
 			const struct seq_operations *seq_ops,
 			u32 seq_priv_size, u32 target_feature);
+int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2e29a671d67e..0f1cbed446c1 100644
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
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index 45528846557f..1091affe8b3f 100644
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
@@ -48,6 +51,43 @@ static const struct inode_operations bpf_dir_iops =3D =
{
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
+	if (target_file->f_inode->i_op !=3D &bpf_dir_iops) {
+		err =3D -EINVAL;
+		goto done;
+	}
+
+	tinfo =3D target_file->f_inode->i_private;
+	target_proto =3D tinfo->target_proto;
+	btf_id =3D btf_find_by_name_kind(btf_vmlinux, target_proto,
+				       BTF_KIND_FUNC);
+
+	if (btf_id > 0) {
+		prog->aux->dump_target =3D tinfo->target;
+		prog->aux->attach_btf_id =3D btf_id;
+	}
+
+	err =3D min(btf_id, 0);
+done:
+	fdput(tfd);
+	return err;
+}
+
 int bpf_dump_reg_target(const char *target,
 			const char *target_proto,
 			const struct seq_operations *seq_ops,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 64783da34202..41005dee8957 100644
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
+		err =3D bpf_dump_set_target_info(attr->attach_prog_fd, prog);
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
index 2e29a671d67e..0f1cbed446c1 100644
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
--=20
2.24.1

