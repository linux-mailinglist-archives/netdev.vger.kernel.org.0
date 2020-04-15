Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FAD1AB1D1
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633512AbgDOTcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:32:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406803AbgDOT2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:05 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJPWti012507
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=rNrzRWDJi2tjBUPOrb7Ouh0Uil0tjXJha4J1ocpPNxo=;
 b=KsstTTAta6ogEH7fvPw+JfcztzS+QcxzfnjhT1Prg5x14YUa+8OTtCgPZfFAQIpQynIk
 EdQ00JV8kvB/8aw0cLfteP85uqdLI4MS9IMpMm/8DPCFrNsRoAIbFV6qx8RtH6pEOMkE
 G1oKb5aUTFj+Zbuj/dBiKXjB03TOijtWoow= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn82qtc1-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:03 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:47 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 422153700AF5; Wed, 15 Apr 2020 12:27:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 03/17] bpf: provide a way for targets to register themselves
Date:   Wed, 15 Apr 2020 12:27:43 -0700
Message-ID: <20200415192743.4082872-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 phishscore=0 bulkscore=0 suspectscore=2 spamscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here, the target refers to a particular data structure
inside the kernel we want to dump. For example, it
can be all task_structs in the current pid namespace,
or it could be all open files for all task_structs
in the current pid namespace.

Each target is identified with the following information:
   target_rel_path    <=3D=3D=3D relative path to /sys/kernel/bpfdump
   target_proto       <=3D=3D=3D kernel func proto used by kernel verifie=
r
   prog_ctx_type_name <=3D=3D=3D prog ctx type used by bpf programs
   seq_ops            <=3D=3D=3D seq_ops for seq_file operations
   seq_priv_size      <=3D=3D=3D seq_file private data size
   target_feature     <=3D=3D=3D target specific feature which needs
                           handling outside seq_ops.

The target relative path is a relative directory to /sys/kernel/bpfdump/.
For example, it could be:
   task                  <=3D=3D=3D all tasks
   task/file             <=3D=3D=3D all open files under all tasks
   ipv6_route            <=3D=3D=3D all ipv6_routes
   tcp6/sk_local_storage <=3D=3D=3D all tcp6 socket local storages
   foo/bar/tar           <=3D=3D=3D all tar's in bar in foo

The "target_feature" is mostly used for reusing existing seq_ops.
For example, for /proc/net/<> stats, the "net" namespace is often
stored in file private data. The target_feature enables bpf based
dumper to set "net" properly for itself before calling shared
seq_ops.

bpf_dump_reg_target() is implemented so targets
can register themselves. Currently, module is not
supported, so there is no bpf_dump_unreg_target().
The main reason is that BTF is not available for modules
yet.

Since target might call bpf_dump_reg_target() before
bpfdump mount point is created, __bpfdump_init()
may be called in bpf_dump_reg_target() as well.

The file-based dumpers will be regular files under
the specific target directory. For example,
   task/my1      <=3D=3D=3D dumper "my1" iterates through all tasks
   task/file/my2 <=3D=3D=3D dumper "my2" iterates through all open files
                      under all tasks

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h |  12 +++
 kernel/bpf/dump.c   | 198 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 208 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd2b2322412d..84c7eb40d7bc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -31,6 +31,7 @@ struct seq_file;
 struct btf;
 struct btf_type;
 struct exception_table_entry;
+struct seq_operations;
=20
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1109,6 +1110,17 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
+struct bpf_dump_reg {
+	const char *target;
+	const char *target_proto;
+	const char *prog_ctx_type_name;
+	const struct seq_operations *seq_ops;
+	u32 seq_priv_size;
+	u32 target_feature;
+};
+
+int bpf_dump_reg_target(struct bpf_dump_reg *reg_info);
+
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index e0c33486e0e7..e8b46f9e0ee0 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -12,6 +12,172 @@
 #include <linux/filter.h>
 #include <linux/bpf.h>
=20
+struct bpfdump_target_info {
+	struct list_head list;
+	const char *target;
+	const char *target_proto;
+	struct dentry *dir_dentry;
+	const struct seq_operations *seq_ops;
+	u32 seq_priv_size;
+	u32 target_feature;
+};
+
+struct bpfdump_targets {
+	struct list_head dumpers;
+	struct mutex dumper_mutex;
+};
+
+/* registered dump targets */
+static struct bpfdump_targets dump_targets;
+
+static struct dentry *bpfdump_dentry;
+
+static struct dentry *bpfdump_add_dir(const char *name, struct dentry *p=
arent,
+				      const struct inode_operations *i_ops,
+				      void *data);
+static int __bpfdump_init(void);
+
+/* 0: not inited, > 0: successful, < 0: previous init failed */
+static int bpfdump_inited =3D 0;
+
+static int dumper_unlink(struct inode *dir, struct dentry *dentry)
+{
+	kfree(d_inode(dentry)->i_private);
+	return simple_unlink(dir, dentry);
+}
+
+static const struct inode_operations bpfdump_dir_iops =3D {
+	.lookup		=3D simple_lookup,
+	.unlink		=3D dumper_unlink,
+};
+
+int bpf_dump_reg_target(struct bpf_dump_reg *reg_info)
+{
+	struct bpfdump_target_info *tinfo, *ptinfo;
+	struct dentry *dentry, *parent;
+	const char *target, *lastslash;
+	bool existed =3D false;
+	int err, parent_len;
+
+	if (!bpfdump_dentry) {
+		err =3D __bpfdump_init();
+		if (err)
+			return err;
+	}
+
+	tinfo =3D kmalloc(sizeof(*tinfo), GFP_KERNEL);
+	if (!tinfo)
+		return -ENOMEM;
+
+	target =3D reg_info->target;
+	tinfo->target =3D target;
+	tinfo->target_proto =3D reg_info->target_proto;
+	tinfo->seq_ops =3D reg_info->seq_ops;
+	tinfo->seq_priv_size =3D reg_info->seq_priv_size;
+	tinfo->target_feature =3D reg_info->target_feature;
+	INIT_LIST_HEAD(&tinfo->list);
+
+	lastslash =3D strrchr(target, '/');
+	parent =3D bpfdump_dentry;
+	if (lastslash) {
+		parent_len =3D (unsigned long)lastslash - (unsigned long)target;
+
+		mutex_lock(&dump_targets.dumper_mutex);
+		list_for_each_entry(ptinfo, &dump_targets.dumpers, list) {
+			if (strlen(ptinfo->target) =3D=3D parent_len &&
+			    strncmp(ptinfo->target, target, parent_len) =3D=3D 0) {
+				existed =3D true;
+				break;
+			}
+		}
+		mutex_unlock(&dump_targets.dumper_mutex);
+		if (existed =3D=3D false) {
+			err =3D -ENOENT;
+			goto free_tinfo;
+		}
+
+		parent =3D ptinfo->dir_dentry;
+		target =3D lastslash + 1;
+	}
+	dentry =3D bpfdump_add_dir(target, parent, &bpfdump_dir_iops, tinfo);
+	if (IS_ERR(dentry)) {
+		err =3D PTR_ERR(dentry);
+		goto free_tinfo;
+	}
+
+	tinfo->dir_dentry =3D dentry;
+
+	mutex_lock(&dump_targets.dumper_mutex);
+	list_add(&tinfo->list, &dump_targets.dumpers);
+	mutex_unlock(&dump_targets.dumper_mutex);
+	return 0;
+
+free_tinfo:
+	kfree(tinfo);
+	return err;
+}
+
+static struct dentry *
+bpfdump_create_dentry(const char *name, umode_t mode, struct dentry *par=
ent,
+		      void *data, const struct inode_operations *i_ops,
+		      const struct file_operations *f_ops)
+{
+	struct inode *dir, *inode;
+	struct dentry *dentry;
+	int err;
+
+	dir =3D d_inode(parent);
+
+	inode_lock(dir);
+	dentry =3D lookup_one_len(name, parent, strlen(name));
+	if (IS_ERR(dentry))
+		goto unlock;
+
+	if (d_really_is_positive(dentry)) {
+		err =3D -EEXIST;
+		goto dentry_put;
+	}
+
+	inode =3D new_inode(dir->i_sb);
+	if (!inode) {
+		err =3D -ENOMEM;
+		goto dentry_put;
+	}
+
+	inode->i_ino =3D get_next_ino();
+	inode->i_mode =3D mode;
+	inode->i_atime =3D inode->i_mtime =3D inode->i_ctime =3D current_time(i=
node);
+	inode->i_private =3D data;
+
+	if (S_ISDIR(mode)) {
+		inode->i_op =3D i_ops;
+		inode->i_fop =3D f_ops;
+		inc_nlink(inode);
+		inc_nlink(dir);
+	} else {
+		inode->i_fop =3D f_ops;
+	}
+
+	d_instantiate(dentry, inode);
+	inode_unlock(dir);
+	return dentry;
+
+dentry_put:
+	dput(dentry);
+	dentry =3D ERR_PTR(err);
+unlock:
+	inode_unlock(dir);
+	return dentry;
+}
+
+static struct dentry *
+bpfdump_add_dir(const char *name, struct dentry *parent,
+		const struct inode_operations *i_ops, void *data)
+{
+	return bpfdump_create_dentry(name, S_IFDIR | 0755, parent,
+				     data, i_ops, &simple_dir_operations);
+}
+
 static void bpfdump_free_inode(struct inode *inode)
 {
 	kfree(inode->i_private);
@@ -58,22 +224,50 @@ static struct file_system_type fs_type =3D {
 	.kill_sb		=3D kill_litter_super,
 };
=20
-static int __init bpfdump_init(void)
+static int __bpfdump_init(void)
 {
+	struct vfsmount *mount =3D NULL;
+	int mount_count =3D 0;
 	int ret;
=20
+	if (bpfdump_inited)
+		return bpfdump_inited < 0 ? bpfdump_inited : 0;
+
 	ret =3D sysfs_create_mount_point(kernel_kobj, "bpfdump");
 	if (ret)
-		return ret;
+		goto done;
=20
 	ret =3D register_filesystem(&fs_type);
 	if (ret)
 		goto remove_mount;
=20
+	/* get a reference to mount so we can populate targets
+	 * at init time.
+	 */
+	ret =3D simple_pin_fs(&fs_type, &mount, &mount_count);
+	if (ret)
+		goto remove_mount;
+
+	bpfdump_dentry =3D mount->mnt_root;
+
+	INIT_LIST_HEAD(&dump_targets.dumpers);
+	mutex_init(&dump_targets.dumper_mutex);
+
+	bpfdump_inited =3D 1;
 	return 0;
=20
 remove_mount:
 	sysfs_remove_mount_point(kernel_kobj, "bpfdump");
+done:
+	bpfdump_inited =3D ret;
 	return ret;
 }
+
+static int __init bpfdump_init(void)
+{
+	if (bpfdump_dentry)
+		return 0;
+
+	return __bpfdump_init();
+}
 core_initcall(bpfdump_init);
--=20
2.24.1

