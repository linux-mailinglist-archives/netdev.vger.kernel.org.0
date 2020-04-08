Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143A71A2C33
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgDHXZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:25:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgDHXZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:32 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038NJN1c028674
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=reV9zRE9CsGSG6Liq8/GjBGN0gKMKdSlI/v0Wk7iIyE=;
 b=ILlysoymQgmitZppLBlSeQ+RI7dXbl/SZzeizUKMFkJmuQCYtRJAo7eTzp5rlq/z065V
 hD0Q+jHk2FVX6eX+uXPFw74ywUV7r0OCp22ZIxlVdp3uaEaGOXH399sxNG8OvOsSUgX0
 b6HLJ1rvVTgNqN6DizhjOJaMdKnGx/d3Vyo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3091kwfktg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:30 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:29 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 4212C3700D98; Wed,  8 Apr 2020 16:25:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
Date:   Wed, 8 Apr 2020 16:25:26 -0700
Message-ID: <20200408232526.2675664-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 malwarescore=0 phishscore=0 spamscore=0 suspectscore=2 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given a loaded dumper bpf program, which already
knows which target it should bind to, there
two ways to create a dumper:
  - a file based dumper under hierarchy of
    /sys/kernel/bpfdump/ which uses can
    "cat" to print out the output.
  - an anonymous dumper which user application
    can "read" the dumping output.

For file based dumper, BPF_OBJ_PIN syscall interface
is used. For anonymous dumper, BPF_PROG_ATTACH
syscall interface is used.

To facilitate target seq_ops->show() to get the
bpf program easily, dumper creation increased
the target-provided seq_file private data size
so bpf program pointer is also stored in seq_file
private data.

Further, a seq_num which represents how many
bpf_dump_get_prog() has been called is also
available to the target seq_ops->show().
Such information can be used to e.g., print
banner before printing out actual data.

Note the seq_num does not represent the num
of unique kernel objects the bpf program has
seen. But it should be a good approximate.

A target feature BPF_DUMP_SEQ_NET_PRIVATE
is implemented specifically useful for
net based dumpers. It sets net namespace
as the current process net namespace.
This avoids changing existing net seq_ops
in order to retrieve net namespace from
the seq_file pointer.

For open dumper files, anonymous or not, the
fdinfo will show the target and prog_id associated
with that file descriptor. For dumper file itself,
a kernel interface will be provided to retrieve the
prog_id in one of the later patches.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            |   5 +
 include/uapi/linux/bpf.h       |   6 +-
 kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c           |  11 +-
 tools/include/uapi/linux/bpf.h |   6 +-
 5 files changed, 362 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 44268d36d901..8171e01ff4be 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1110,10 +1110,15 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
+#define BPF_DUMP_SEQ_NET_PRIVATE	BIT(0)
+
 int bpf_dump_reg_target(const char *target, const char *target_proto,
 			const struct seq_operations *seq_ops,
 			u32 seq_priv_size, u32 target_feature);
 int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog);
+int bpf_dump_create(u32 prog_fd, const char __user *dumper_name);
+struct bpf_prog *bpf_dump_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
+				   u64 *seq_num);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0f1cbed446c1..b51d56fc77f9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -354,6 +354,7 @@ enum {
 /* Flags for accessing BPF object from syscall side. */
 	BPF_F_RDONLY		=3D (1U << 3),
 	BPF_F_WRONLY		=3D (1U << 4),
+	BPF_F_DUMP		=3D (1U << 5),
=20
 /* Flag for stack_map, store build_id+offset instead of pointer */
 	BPF_F_STACK_BUILD_ID	=3D (1U << 5),
@@ -481,7 +482,10 @@ union bpf_attr {
 	};
=20
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
-		__aligned_u64	pathname;
+		union {
+			__aligned_u64	pathname;
+			__aligned_u64	dumper_name;
+		};
 		__u32		bpf_fd;
 		__u32		file_flags;
 	};
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index 1091affe8b3f..ac6856abb711 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -30,22 +30,173 @@ struct bpfdump_targets {
 	struct mutex dumper_mutex;
 };
=20
+struct dumper_inode_info {
+	struct bpfdump_target_info *tinfo;
+	struct bpf_prog *prog;
+};
+
+struct dumper_info {
+	struct list_head list;
+	/* file to identify an anon dumper,
+	 * dentry to identify a file dumper.
+	 */
+	union {
+		struct file *file;
+		struct dentry *dentry;
+	};
+	struct bpfdump_target_info *tinfo;
+	struct bpf_prog *prog;
+};
+
+struct dumpers {
+	struct list_head dumpers;
+	struct mutex dumper_mutex;
+};
+
+struct extra_priv_data {
+	struct bpf_prog *prog;
+	u64 seq_num;
+};
+
 /* registered dump targets */
 static struct bpfdump_targets dump_targets;
=20
 static struct dentry *bpfdump_dentry;
=20
+static struct dumpers anon_dumpers, file_dumpers;
+
+static const struct file_operations bpf_dumper_ops;
+static const struct inode_operations bpf_dir_iops;
+
+static struct dentry *bpfdump_add_file(const char *name, struct dentry *=
parent,
+				       const struct file_operations *f_ops,
+				       void *data);
 static struct dentry *bpfdump_add_dir(const char *name, struct dentry *p=
arent,
 				      const struct inode_operations *i_ops,
 				      void *data);
 static int __bpfdump_init(void);
=20
+static u32 get_total_priv_dsize(u32 old_size)
+{
+	return roundup(old_size, 8) + sizeof(struct extra_priv_data);
+}
+
+static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
+{
+	return old_ptr + roundup(old_size, 8);
+}
+
+#ifdef CONFIG_PROC_FS
+static void dumper_show_fdinfo(struct seq_file *m, struct file *filp)
+{
+	struct dumper_inode_info *i_info =3D filp->f_inode->i_private;
+
+	seq_printf(m, "target:\t%s\n"
+		      "prog_id:\t%u\n",
+		   i_info->tinfo->target,
+		   i_info->prog->aux->id);
+}
+
+static void anon_dumper_show_fdinfo(struct seq_file *m, struct file *fil=
p)
+{
+	struct dumper_info *dinfo;
+
+	mutex_lock(&anon_dumpers.dumper_mutex);
+	list_for_each_entry(dinfo, &anon_dumpers.dumpers, list) {
+		if (dinfo->file =3D=3D filp) {
+			seq_printf(m, "target:\t%s\n"
+				      "prog_id:\t%u\n",
+				   dinfo->tinfo->target,
+				   dinfo->prog->aux->id);
+			break;
+		}
+	}
+	mutex_unlock(&anon_dumpers.dumper_mutex);
+}
+
+#endif
+
+static void process_target_feature(u32 feature, void *priv_data)
+{
+	/* use the current net namespace */
+	if (feature & BPF_DUMP_SEQ_NET_PRIVATE)
+		set_seq_net_private((struct seq_net_private *)priv_data,
+				    current->nsproxy->net_ns);
+}
+
+static int dumper_open(struct inode *inode, struct file *file)
+{
+	struct dumper_inode_info *i_info =3D inode->i_private;
+	struct extra_priv_data *extra_data;
+	u32 old_priv_size, total_priv_size;
+	void *priv_data;
+
+	old_priv_size =3D i_info->tinfo->seq_priv_size;
+	total_priv_size =3D get_total_priv_dsize(old_priv_size);
+	priv_data =3D __seq_open_private(file, i_info->tinfo->seq_ops,
+				       total_priv_size);
+	if (!priv_data)
+		return -ENOMEM;
+
+	process_target_feature(i_info->tinfo->target_feature, priv_data);
+
+	extra_data =3D get_extra_priv_dptr(priv_data, old_priv_size);
+	extra_data->prog =3D i_info->prog;
+	extra_data->seq_num =3D 0;
+
+	return 0;
+}
+
+static int anon_dumper_release(struct inode *inode, struct file *file)
+{
+	struct dumper_info *dinfo;
+
+	/* release the bpf program */
+	mutex_lock(&anon_dumpers.dumper_mutex);
+	list_for_each_entry(dinfo, &anon_dumpers.dumpers, list) {
+		if (dinfo->file =3D=3D file) {
+			bpf_prog_put(dinfo->prog);
+			list_del(&dinfo->list);
+			break;
+		}
+	}
+	mutex_unlock(&anon_dumpers.dumper_mutex);
+
+	return seq_release_private(inode, file);
+}
+
+static int dumper_release(struct inode *inode, struct file *file)
+{
+	return seq_release_private(inode, file);
+}
+
 static int dumper_unlink(struct inode *dir, struct dentry *dentry)
 {
-	kfree(d_inode(dentry)->i_private);
+	struct dumper_inode_info *i_info =3D d_inode(dentry)->i_private;
+
+	bpf_prog_put(i_info->prog);
+	kfree(i_info);
+
 	return simple_unlink(dir, dentry);
 }
=20
+static const struct file_operations bpf_dumper_ops =3D {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	=3D dumper_show_fdinfo,
+#endif
+	.open		=3D dumper_open,
+	.read		=3D seq_read,
+	.release	=3D dumper_release,
+};
+
+static const struct file_operations anon_bpf_dumper_ops =3D {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	=3D anon_dumper_show_fdinfo,
+#endif
+	.read		=3D seq_read,
+	.release	=3D anon_dumper_release,
+};
+
 static const struct inode_operations bpf_dir_iops =3D {
 	.lookup		=3D simple_lookup,
 	.unlink		=3D dumper_unlink,
@@ -88,6 +239,179 @@ int bpf_dump_set_target_info(u32 target_fd, struct b=
pf_prog *prog)
 	return err;
 }
=20
+static int create_anon_dumper(struct bpfdump_target_info *tinfo,
+			      struct bpf_prog *prog)
+{
+	struct extra_priv_data *extra_data;
+	u32 old_priv_size, total_priv_size;
+	struct dumper_info *dinfo;
+	struct file *file;
+	int err, anon_fd;
+	void *priv_data;
+	struct fd fd;
+
+	anon_fd =3D anon_inode_getfd("bpf-dumper", &anon_bpf_dumper_ops,
+				   NULL, O_CLOEXEC);
+	if (anon_fd < 0)
+		return anon_fd;
+
+	/* setup seq_file for anon dumper */
+	fd =3D fdget(anon_fd);
+	file =3D fd.file;
+
+	dinfo =3D kmalloc(sizeof(*dinfo), GFP_KERNEL);
+	if (!dinfo) {
+		err =3D -ENOMEM;
+		goto free_fd;
+	}
+
+	old_priv_size =3D tinfo->seq_priv_size;
+	total_priv_size =3D get_total_priv_dsize(old_priv_size);
+
+	priv_data =3D __seq_open_private(file, tinfo->seq_ops,
+				       total_priv_size);
+	if (!priv_data) {
+		err =3D -ENOMEM;
+		goto free_dinfo;
+	}
+
+	dinfo->file =3D file;
+	dinfo->tinfo =3D tinfo;
+	dinfo->prog =3D prog;
+
+	mutex_lock(&anon_dumpers.dumper_mutex);
+	list_add(&dinfo->list, &anon_dumpers.dumpers);
+	mutex_unlock(&anon_dumpers.dumper_mutex);
+
+	process_target_feature(tinfo->target_feature, priv_data);
+
+	extra_data =3D get_extra_priv_dptr(priv_data, old_priv_size);
+	extra_data->prog =3D prog;
+	extra_data->seq_num =3D 0;
+
+	fdput(fd);
+	return anon_fd;
+
+free_dinfo:
+	kfree(dinfo);
+free_fd:
+	fdput(fd);
+	return err;
+}
+
+static int create_dumper(struct bpfdump_target_info *tinfo,
+			 const char __user *dumper_name,
+			 struct bpf_prog *prog)
+{
+	struct dumper_inode_info *i_info;
+	struct dumper_info *dinfo;
+	struct dentry *dentry;
+	const char *dname;
+	int err =3D 0;
+
+	i_info =3D kmalloc(sizeof(*i_info), GFP_KERNEL);
+	if (!i_info)
+		return -ENOMEM;
+
+	i_info->tinfo =3D tinfo;
+	i_info->prog =3D prog;
+
+	dinfo =3D kmalloc(sizeof(*dinfo), GFP_KERNEL);
+	if (!dinfo) {
+		err =3D -ENOMEM;
+		goto free_i_info;
+	}
+
+	dname =3D strndup_user(dumper_name, PATH_MAX);
+	if (!dname) {
+		err =3D -ENOMEM;
+		goto free_dinfo;
+	}
+
+	dentry =3D bpfdump_add_file(dname, tinfo->dir_dentry,
+				  &bpf_dumper_ops, i_info);
+	kfree(dname);
+	if (IS_ERR(dentry)) {
+		err =3D PTR_ERR(dentry);
+		goto free_dinfo;
+	}
+
+	dinfo->dentry =3D dentry;
+	dinfo->tinfo =3D tinfo;
+	dinfo->prog =3D prog;
+
+	mutex_lock(&file_dumpers.dumper_mutex);
+	list_add(&dinfo->list, &file_dumpers.dumpers);
+	mutex_unlock(&file_dumpers.dumper_mutex);
+
+	return 0;
+
+free_dinfo:
+	kfree(dinfo);
+free_i_info:
+	kfree(i_info);
+	return err;
+}
+
+int bpf_dump_create(u32 prog_fd, const char __user *dumper_name)
+{
+	struct bpfdump_target_info *tinfo;
+	const char *target;
+	struct bpf_prog *prog;
+	bool existed =3D false;
+	int err =3D 0;
+
+	prog =3D bpf_prog_get(prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	target =3D prog->aux->dump_target;
+	if (!target) {
+		err =3D -EINVAL;
+		goto free_prog;
+	}
+
+	mutex_lock(&dump_targets.dumper_mutex);
+	list_for_each_entry(tinfo, &dump_targets.dumpers, list) {
+		if (strcmp(tinfo->target, target) =3D=3D 0) {
+			existed =3D true;
+			break;
+		}
+	}
+	mutex_unlock(&dump_targets.dumper_mutex);
+
+	if (!existed) {
+		err =3D -EINVAL;
+		goto free_prog;
+	}
+
+	err =3D dumper_name ? create_dumper(tinfo, dumper_name, prog)
+			  : create_anon_dumper(tinfo, prog);
+	if (err < 0)
+		goto free_prog;
+
+	return err;
+
+free_prog:
+	bpf_prog_put(prog);
+	return err;
+}
+
+struct bpf_prog *bpf_dump_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
+	u64 *seq_num)
+{
+	struct extra_priv_data *extra_data;
+
+	if (seq->file->f_op !=3D &bpf_dumper_ops &&
+	    seq->file->f_op !=3D &anon_bpf_dumper_ops)
+		return NULL;
+
+	extra_data =3D get_extra_priv_dptr(seq->private, priv_data_size);
+	*seq_num =3D extra_data->seq_num++;
+
+	return extra_data->prog;
+}
+
 int bpf_dump_reg_target(const char *target,
 			const char *target_proto,
 			const struct seq_operations *seq_ops,
@@ -211,6 +535,14 @@ bpfdump_create_dentry(const char *name, umode_t mode=
, struct dentry *parent,
 	return dentry;
 }
=20
+static struct dentry *
+bpfdump_add_file(const char *name, struct dentry *parent,
+		 const struct file_operations *f_ops, void *data)
+{
+	return bpfdump_create_dentry(name, S_IFREG | 0444, parent,
+				     data, NULL, f_ops);
+}
+
 static struct dentry *
 bpfdump_add_dir(const char *name, struct dentry *parent,
 		const struct inode_operations *i_ops, void *data)
@@ -290,6 +622,10 @@ static int __bpfdump_init(void)
=20
 	INIT_LIST_HEAD(&dump_targets.dumpers);
 	mutex_init(&dump_targets.dumper_mutex);
+	INIT_LIST_HEAD(&anon_dumpers.dumpers);
+	mutex_init(&anon_dumpers.dumper_mutex);
+	INIT_LIST_HEAD(&file_dumpers.dumpers);
+	mutex_init(&file_dumpers.dumper_mutex);
 	return 0;
=20
 remove_mount:
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 41005dee8957..b5e4f18cc633 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2173,9 +2173,13 @@ static int bpf_prog_load(union bpf_attr *attr, uni=
on bpf_attr __user *uattr)
=20
 static int bpf_obj_pin(const union bpf_attr *attr)
 {
-	if (CHECK_ATTR(BPF_OBJ) || attr->file_flags !=3D 0)
+	if (CHECK_ATTR(BPF_OBJ) || attr->file_flags & ~BPF_F_DUMP)
 		return -EINVAL;
=20
+	if (attr->file_flags =3D=3D BPF_F_DUMP)
+		return bpf_dump_create(attr->bpf_fd,
+				       u64_to_user_ptr(attr->dumper_name));
+
 	return bpf_obj_pin_user(attr->bpf_fd, u64_to_user_ptr(attr->pathname));
 }
=20
@@ -2605,6 +2609,8 @@ attach_type_to_prog_type(enum bpf_attach_type attac=
h_type)
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
+	case BPF_TRACE_DUMP:
+		return BPF_PROG_TYPE_TRACING;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -2663,6 +2669,9 @@ static int bpf_prog_attach(const union bpf_attr *at=
tr)
 	case BPF_PROG_TYPE_SOCK_OPS:
 		ret =3D cgroup_bpf_prog_attach(attr, ptype, prog);
 		break;
+	case BPF_PROG_TYPE_TRACING:
+		ret =3D bpf_dump_create(attr->attach_bpf_fd, (void __user *)NULL);
+		break;
 	default:
 		ret =3D -EINVAL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 0f1cbed446c1..b51d56fc77f9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -354,6 +354,7 @@ enum {
 /* Flags for accessing BPF object from syscall side. */
 	BPF_F_RDONLY		=3D (1U << 3),
 	BPF_F_WRONLY		=3D (1U << 4),
+	BPF_F_DUMP		=3D (1U << 5),
=20
 /* Flag for stack_map, store build_id+offset instead of pointer */
 	BPF_F_STACK_BUILD_ID	=3D (1U << 5),
@@ -481,7 +482,10 @@ union bpf_attr {
 	};
=20
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
-		__aligned_u64	pathname;
+		union {
+			__aligned_u64	pathname;
+			__aligned_u64	dumper_name;
+		};
 		__u32		bpf_fd;
 		__u32		file_flags;
 	};
--=20
2.24.1

