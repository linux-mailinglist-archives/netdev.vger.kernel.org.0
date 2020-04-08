Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177221A2C32
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgDHXZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:25:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10768 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbgDHXZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:28 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038NJ54u018135
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PVLCaa6awlfHtGbAr8EQofjyVtYS2l//UgjBImGUgyM=;
 b=RE9+CCLhZXPSwkG9hkTRCAamOkc6slirbTmDOBUcAWvXbJpPby/OWK68oudTqj1sDC2g
 pMMc36I+punlNNC9fx0X5S84BhQPU6QGfH0Z3fui1IrxNG18Y+MESvRCBZlCKBMChzBy
 0Ucur47ZdhNaGOe+QoOVY5lXQhKYZftCKPM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3091jtyprr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:28 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:27 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id C28063700D98; Wed,  8 Apr 2020 16:25:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 03/16] bpf: provide a way for targets to register themselves
Date:   Wed, 8 Apr 2020 16:25:23 -0700
Message-ID: <20200408232523.2675550-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 suspectscore=2 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080163
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
   target_rel_path   <=3D=3D=3D relative path to /sys/kernel/bpfdump
   target_proto      <=3D=3D=3D kernel func proto which represents
                          bpf program signature for this target
   seq_ops           <=3D=3D=3D seq_ops for seq_file operations
   seq_priv_size     <=3D=3D=3D seq_file private data size
   target_feature    <=3D=3D=3D target specific feature which needs
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
 include/linux/bpf.h |   4 +
 kernel/bpf/dump.c   | 190 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 193 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd2b2322412d..53914bec7590 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1109,6 +1109,10 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
+int bpf_dump_reg_target(const char *target, const char *target_proto,
+			const struct seq_operations *seq_ops,
+			u32 seq_priv_size, u32 target_feature);
+
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index e0c33486e0e7..45528846557f 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -12,6 +12,173 @@
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
+static int dumper_unlink(struct inode *dir, struct dentry *dentry)
+{
+	kfree(d_inode(dentry)->i_private);
+	return simple_unlink(dir, dentry);
+}
+
+static const struct inode_operations bpf_dir_iops =3D {
+	.lookup		=3D simple_lookup,
+	.unlink		=3D dumper_unlink,
+};
+
+int bpf_dump_reg_target(const char *target,
+			const char *target_proto,
+			const struct seq_operations *seq_ops,
+			u32 seq_priv_size, u32 target_feature)
+{
+	struct bpfdump_target_info *tinfo, *ptinfo;
+	struct dentry *dentry, *parent;
+	const char *lastslash;
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
+	tinfo->target =3D target;
+	tinfo->target_proto =3D target_proto;
+	tinfo->seq_ops =3D seq_ops;
+	tinfo->seq_priv_size =3D seq_priv_size;
+	tinfo->target_feature =3D target_feature;
+	INIT_LIST_HEAD(&tinfo->list);
+
+	lastslash =3D strrchr(target, '/');
+	if (!lastslash) {
+		parent =3D bpfdump_dentry;
+	} else {
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
+	dentry =3D bpfdump_add_dir(target, parent, &bpf_dir_iops, tinfo);
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
+	dget(dentry);
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
@@ -58,8 +225,10 @@ static struct file_system_type fs_type =3D {
 	.kill_sb		=3D kill_litter_super,
 };
=20
-static int __init bpfdump_init(void)
+static int __bpfdump_init(void)
 {
+	struct vfsmount *mount;
+	int mount_count;
 	int ret;
=20
 	ret =3D sysfs_create_mount_point(kernel_kobj, "bpfdump");
@@ -70,10 +239,29 @@ static int __init bpfdump_init(void)
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
 	return 0;
=20
 remove_mount:
 	sysfs_remove_mount_point(kernel_kobj, "bpfdump");
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

