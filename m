Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27561AB1C7
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411814AbgDOTcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:32:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2411810AbgDOT2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:21 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03FJSCol007606
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=cwP0jvAVYoqV9o4QyK1XYo38TC6ATpfsPl2kIWjs7xo=;
 b=aIKx5gSMomH8pzD8SNhKm8FzaBwel/zEJ8MGmBFrBsvV0dwFMZsLDKXHG3oCH7njaY9T
 bux5KrlkSKKan9C4WgNyUowepytxgQusTt3HP3u5P3tAfNr9IS4ekBK6wY35a/SbJ/sV
 ZFWZWzeBxy5JaCOcK5zCZJeSxh8ykGrxs/0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30dn7fymmk-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:17 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:46 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B6AAB3700AF5; Wed, 15 Apr 2020 12:27:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 05/17] bpf: create file or anonymous dumpers
Date:   Wed, 15 Apr 2020 12:27:45 -0700
Message-ID: <20200415192745.4083071-1-yhs@fb.com>
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

Given a loaded dumper bpf program, which already
knows which target it should bind to, there
two ways to create a dumper:
  - a file based dumper under hierarchy of
    /sys/kernel/bpfdump/ which uses can
    "cat" to print out the output.
  - an anonymous dumper which user application
    can "read" the dumping output.

For file based dumper, BPF_OBJ_PIN syscall interface
is used. For anonymous dumper, BPF_RAW_TRACEPOINT_OPEN
syscall interface is used.

To facilitate target seq_ops->show() to get the
bpf program easily, dumper creation increased
the target-provided seq_file private data size
so bpf program pointer is also stored in seq_file
private data.

A session_id, which is unique for each
bpfdump open file, is available to the
bpf program. This can differentiate different
sessions if the same program is used
by multiple open files.

A seq_num, which represents how many
bpf_dump_get_prog() has been called, is
also available to the bpf program.
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
prog_ctx_type and prog_id in one of the later patches.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h  |   7 +
 kernel/bpf/dump.c    | 407 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c |  20 ++-
 3 files changed, 429 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 068552c2d2cf..3cc16991c287 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1111,6 +1111,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
+#define BPF_DUMP_SEQ_NET_PRIVATE	BIT(0)
+
 struct bpf_dump_reg {
 	const char *target;
 	const char *target_proto;
@@ -1122,6 +1124,11 @@ struct bpf_dump_reg {
=20
 int bpf_dump_reg_target(struct bpf_dump_reg *reg_info);
 int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog);
+int bpf_fd_dump_create(u32 prog_fd, const char __user *dumper_name,
+		       bool *is_dump_prog);
+int bpf_prog_dump_create(struct bpf_prog *prog);
+struct bpf_prog *bpf_dump_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
+				   u64 *session_id, u64 *seq_num, bool is_last);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index 8c7a89800312..f39b82430977 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -30,11 +30,51 @@ struct bpfdump_targets {
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
+	u64 session_id;
+	u64 seq_num;
+	bool has_last;
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
+static const struct inode_operations bpfdump_dir_iops;
+
+static atomic64_t session_id;
+
+static struct dentry *bpfdump_add_file(const char *name, struct dentry *=
parent,
+				       const struct file_operations *f_ops,
+				       void *data);
 static struct dentry *bpfdump_add_dir(const char *name, struct dentry *p=
arent,
 				      const struct inode_operations *i_ops,
 				      void *data);
@@ -43,12 +83,129 @@ static int __bpfdump_init(void);
 /* 0: not inited, > 0: successful, < 0: previous init failed */
 static int bpfdump_inited =3D 0;
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
+	extra_data->session_id =3D atomic64_add_return(1, &session_id);
+	extra_data->seq_num =3D 0;
+	extra_data->has_last =3D false;
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
 static const struct inode_operations bpfdump_dir_iops =3D {
 	.lookup		=3D simple_lookup,
 	.unlink		=3D dumper_unlink,
@@ -93,6 +250,242 @@ int bpf_dump_set_target_info(u32 target_fd, struct b=
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
+	extra_data->session_id =3D atomic64_add_return(1, &session_id);
+	extra_data->prog =3D prog;
+	extra_data->seq_num =3D 0;
+	extra_data->has_last =3D false;
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
+static int check_pathname(struct bpfdump_target_info *tinfo,
+			  const char __user *pathname)
+{
+	struct dentry *dentry;
+	struct inode *dir;
+	struct path path;
+	int err =3D 0;
+
+	dentry =3D user_path_create(AT_FDCWD, pathname, &path, 0);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	dir =3D dentry->d_parent->d_inode;
+	if (dir->i_op !=3D &bpfdump_dir_iops || dir->i_private !=3D tinfo)
+		err =3D -EINVAL;
+
+	done_path_create(&path, dentry);
+	return err;
+
+}
+
+static int create_dumper(struct bpfdump_target_info *tinfo,
+			 const char __user *pathname,
+			 struct bpf_prog *prog)
+{
+	struct dumper_inode_info *i_info;
+	struct dumper_info *dinfo;
+	const char *pname, *dname;
+	struct dentry *dentry;
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
+	err =3D check_pathname(tinfo, pathname);
+	if (err)
+		goto free_dinfo;
+
+	pname =3D strndup_user(pathname, PATH_MAX);
+	if (!pname) {
+		err =3D -ENOMEM;
+		goto free_dinfo;
+	}
+
+	dname =3D strrchr(pname, '/');
+	if (dname)
+		dname +=3D 1;
+	else
+		dname =3D pname;
+
+	dentry =3D bpfdump_add_file(dname, tinfo->dir_dentry,
+				  &bpf_dumper_ops, i_info);
+	kfree(pname);
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
+static struct bpfdump_target_info *find_target_info(const char *target)
+{
+	struct bpfdump_target_info *info;
+
+	mutex_lock(&dump_targets.dumper_mutex);
+	list_for_each_entry(info, &dump_targets.dumpers, list) {
+		if (strcmp(info->target, target) =3D=3D 0) {
+			mutex_unlock(&dump_targets.dumper_mutex);
+			return info;
+		}
+	}
+	mutex_unlock(&dump_targets.dumper_mutex);
+
+	return NULL;
+}
+
+static int bpf_dump_create(struct bpf_prog *prog, const char *target,
+			   const char __user *pathname)
+{
+	struct bpfdump_target_info *tinfo;
+
+	tinfo =3D find_target_info(target);
+	if (!tinfo)
+		return -EINVAL;
+
+	if (pathname)
+		return create_dumper(tinfo, pathname, prog);
+	else
+		return create_anon_dumper(tinfo, prog);
+}
+
+int bpf_fd_dump_create(u32 prog_fd, const char __user *pathname, bool *i=
s_dump_prog)
+{
+	struct bpf_prog *prog;
+	const char *target;
+	int err =3D 0;
+
+	if (is_dump_prog)
+		*is_dump_prog =3D false;
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
+	if (is_dump_prog)
+		*is_dump_prog =3D true;
+
+	err =3D bpf_dump_create(prog, target, pathname);
+	if (err < 0)
+		goto free_prog;
+	goto done;
+
+free_prog:
+	bpf_prog_put(prog);
+done:
+	return err;
+}
+
+int bpf_prog_dump_create(struct bpf_prog *prog)
+{
+	return bpf_dump_create(prog, prog->aux->dump_target, (void __user *)NUL=
L);
+}
+
+struct bpf_prog *bpf_dump_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
+	u64 *session_id, u64 *seq_num, bool is_last)
+{
+	struct extra_priv_data *extra_data;
+
+	if (seq->file->f_op !=3D &bpf_dumper_ops &&
+	    seq->file->f_op !=3D &anon_bpf_dumper_ops)
+		return NULL;
+
+	extra_data =3D get_extra_priv_dptr(seq->private, priv_data_size);
+	if (extra_data->has_last)
+		return NULL;
+
+	*session_id =3D extra_data->session_id;
+	*seq_num =3D extra_data->seq_num++;
+	extra_data->has_last =3D is_last;
+
+	return extra_data->prog;
+}
+
 int bpf_dump_reg_target(struct bpf_dump_reg *reg_info)
 {
 	struct bpfdump_target_info *tinfo, *ptinfo;
@@ -212,6 +605,14 @@ bpfdump_create_dentry(const char *name, umode_t mode=
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
@@ -294,6 +695,10 @@ static int __bpfdump_init(void)
=20
 	INIT_LIST_HEAD(&dump_targets.dumpers);
 	mutex_init(&dump_targets.dumper_mutex);
+	INIT_LIST_HEAD(&anon_dumpers.dumpers);
+	mutex_init(&anon_dumpers.dumper_mutex);
+	INIT_LIST_HEAD(&file_dumpers.dumpers);
+	mutex_init(&file_dumpers.dumper_mutex);
=20
 	bpfdump_inited =3D 1;
 	return 0;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1ce2f74f8efc..4a3c9fceebb8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2173,9 +2173,18 @@ static int bpf_prog_load(union bpf_attr *attr, uni=
on bpf_attr __user *uattr)
=20
 static int bpf_obj_pin(const union bpf_attr *attr)
 {
+	bool is_dump_prog =3D false;
+	int err;
+
 	if (CHECK_ATTR(BPF_OBJ) || attr->file_flags !=3D 0)
 		return -EINVAL;
=20
+	err =3D bpf_fd_dump_create(attr->bpf_fd,
+				 u64_to_user_ptr(attr->pathname),
+				 &is_dump_prog);
+	if (!err || is_dump_prog)
+		return err;
+
 	return bpf_obj_pin_user(attr->bpf_fd, u64_to_user_ptr(attr->pathname));
 }
=20
@@ -2490,10 +2499,13 @@ static int bpf_raw_tracepoint_open(const union bp=
f_attr *attr)
 			err =3D -EINVAL;
 			goto out_put_prog;
 		}
-		if (prog->type =3D=3D BPF_PROG_TYPE_TRACING &&
-		    prog->expected_attach_type =3D=3D BPF_TRACE_RAW_TP) {
-			tp_name =3D prog->aux->attach_func_name;
-			break;
+		if (prog->type =3D=3D BPF_PROG_TYPE_TRACING) {
+			if (prog->expected_attach_type =3D=3D BPF_TRACE_RAW_TP) {
+				tp_name =3D prog->aux->attach_func_name;
+				break;
+			} else if (prog->expected_attach_type =3D=3D BPF_TRACE_DUMP) {
+				return bpf_prog_dump_create(prog);
+			}
 		}
 		return bpf_tracing_prog_attach(prog);
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
--=20
2.24.1

