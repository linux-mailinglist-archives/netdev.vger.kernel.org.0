Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0863A1BAEFD
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgD0UMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48472 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbgD0UMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:49 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK4igA019172
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xeYLGxkD1hUz5mfzBgArcwzev+JPL6yY1fUDybsXNoo=;
 b=jOec8IbXN3u/tmHLvA89hKY/Q0GjYZnPkf75KlOtixzTGui79IkLl3avfm4olg3ZASCY
 zUpkGfBWbI9NBqEFcCkwYE9AIyM7sU3P4/Nlj2fyv2WL8DC5w/LSFJ/ply3LM59oUgxS
 BS7GCdDGbn/ghwldqzVfDJlGfqXRJRhAj7g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30nq53mw3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:47 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:46 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 1FBE83700871; Mon, 27 Apr 2020 13:12:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 08/19] bpf: create file bpf iterator
Date:   Mon, 27 Apr 2020 13:12:44 -0700
Message-ID: <20200427201244.2995241-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=745
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new obj type BPF_TYPE_ITER is added to bpffs.
To produce a file bpf iterator, the fd must be
corresponding to a link_fd assocciated with a
trace/iter program. When the pinned file is
opened, a seq_file will be generated.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   |  3 +++
 kernel/bpf/bpf_iter.c | 48 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/inode.c    | 28 +++++++++++++++++++++++++
 kernel/bpf/syscall.c  |  2 +-
 4 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0f0cafc65a04..601b3299b7e4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1021,6 +1021,8 @@ static inline void bpf_enable_instrumentation(void)
=20
 extern const struct file_operations bpf_map_fops;
 extern const struct file_operations bpf_prog_fops;
+extern const struct file_operations bpf_link_fops;
+extern const struct file_operations bpffs_iter_fops;
=20
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	extern const struct bpf_prog_ops _name ## _prog_ops; \
@@ -1136,6 +1138,7 @@ int bpf_iter_link_attach(const union bpf_attr *attr=
, struct bpf_prog *prog);
 int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_pr=
og,
 			  struct bpf_prog *new_prog);
 int bpf_iter_new_fd(struct bpf_link *link);
+void *bpf_iter_get_from_fd(u32 ufd);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 1f4e778d1814..f5e933236996 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -123,7 +123,8 @@ struct bpf_prog *bpf_iter_get_prog(struct seq_file *s=
eq, u32 priv_data_size,
 {
 	struct extra_priv_data *extra_data;
=20
-	if (seq->file->f_op !=3D &anon_bpf_iter_fops)
+	if (seq->file->f_op !=3D &anon_bpf_iter_fops &&
+	    seq->file->f_op !=3D &bpffs_iter_fops)
 		return NULL;
=20
 	extra_data =3D get_extra_priv_dptr(seq->private, priv_data_size);
@@ -310,3 +311,48 @@ int bpf_iter_new_fd(struct bpf_link *link)
 	put_unused_fd(fd);
 	return err;
 }
+
+static int bpffs_iter_open(struct inode *inode, struct file *file)
+{
+	struct bpf_iter_link *link =3D inode->i_private;
+
+	return prepare_seq_file(file, link);
+}
+
+static int bpffs_iter_release(struct inode *inode, struct file *file)
+{
+	return anon_iter_release(inode, file);
+}
+
+const struct file_operations bpffs_iter_fops =3D {
+	.open		=3D bpffs_iter_open,
+	.read		=3D seq_read,
+	.release	=3D bpffs_iter_release,
+};
+
+void *bpf_iter_get_from_fd(u32 ufd)
+{
+	struct bpf_link *link;
+	struct bpf_prog *prog;
+	struct fd f;
+
+	f =3D fdget(ufd);
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+	if (f.file->f_op !=3D &bpf_link_fops) {
+		link =3D ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	link =3D f.file->private_data;
+	prog =3D link->prog;
+	if (prog->expected_attach_type !=3D BPF_TRACE_ITER) {
+		link =3D ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	bpf_link_inc(link);
+out:
+	fdput(f);
+	return link;
+}
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 95087d9f4ed3..de4493983a37 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -26,6 +26,7 @@ enum bpf_type {
 	BPF_TYPE_PROG,
 	BPF_TYPE_MAP,
 	BPF_TYPE_LINK,
+	BPF_TYPE_ITER,
 };
=20
 static void *bpf_any_get(void *raw, enum bpf_type type)
@@ -38,6 +39,7 @@ static void *bpf_any_get(void *raw, enum bpf_type type)
 		bpf_map_inc_with_uref(raw);
 		break;
 	case BPF_TYPE_LINK:
+	case BPF_TYPE_ITER:
 		bpf_link_inc(raw);
 		break;
 	default:
@@ -58,6 +60,7 @@ static void bpf_any_put(void *raw, enum bpf_type type)
 		bpf_map_put_with_uref(raw);
 		break;
 	case BPF_TYPE_LINK:
+	case BPF_TYPE_ITER:
 		bpf_link_put(raw);
 		break;
 	default:
@@ -82,6 +85,15 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *=
type)
 		return raw;
 	}
=20
+	/* check bpf_iter before bpf_link as
+	 * ufd is also a link.
+	 */
+	raw =3D bpf_iter_get_from_fd(ufd);
+	if (!IS_ERR(raw)) {
+		*type =3D BPF_TYPE_ITER;
+		return raw;
+	}
+
 	raw =3D bpf_link_get_from_fd(ufd);
 	if (!IS_ERR(raw)) {
 		*type =3D BPF_TYPE_LINK;
@@ -96,6 +108,7 @@ static const struct inode_operations bpf_dir_iops;
 static const struct inode_operations bpf_prog_iops =3D { };
 static const struct inode_operations bpf_map_iops  =3D { };
 static const struct inode_operations bpf_link_iops  =3D { };
+static const struct inode_operations bpf_iter_iops  =3D { };
=20
 static struct inode *bpf_get_inode(struct super_block *sb,
 				   const struct inode *dir,
@@ -135,6 +148,8 @@ static int bpf_inode_type(const struct inode *inode, =
enum bpf_type *type)
 		*type =3D BPF_TYPE_MAP;
 	else if (inode->i_op =3D=3D &bpf_link_iops)
 		*type =3D BPF_TYPE_LINK;
+	else if (inode->i_op =3D=3D &bpf_iter_iops)
+		*type =3D BPF_TYPE_ITER;
 	else
 		return -EACCES;
=20
@@ -362,6 +377,12 @@ static int bpf_mklink(struct dentry *dentry, umode_t=
 mode, void *arg)
 			     &bpffs_obj_fops);
 }
=20
+static int bpf_mkiter(struct dentry *dentry, umode_t mode, void *arg)
+{
+	return bpf_mkobj_ops(dentry, mode, arg, &bpf_iter_iops,
+			     &bpffs_iter_fops);
+}
+
 static struct dentry *
 bpf_lookup(struct inode *dir, struct dentry *dentry, unsigned flags)
 {
@@ -441,6 +462,9 @@ static int bpf_obj_do_pin(const char __user *pathname=
, void *raw,
 	case BPF_TYPE_LINK:
 		ret =3D vfs_mkobj(dentry, mode, bpf_mklink, raw);
 		break;
+	case BPF_TYPE_ITER:
+		ret =3D vfs_mkobj(dentry, mode, bpf_mkiter, raw);
+		break;
 	default:
 		ret =3D -EPERM;
 	}
@@ -519,6 +543,8 @@ int bpf_obj_get_user(const char __user *pathname, int=
 flags)
 		ret =3D bpf_map_new_fd(raw, f_flags);
 	else if (type =3D=3D BPF_TYPE_LINK)
 		ret =3D bpf_link_new_fd(raw);
+	else if (type =3D=3D BPF_TYPE_ITER)
+		ret =3D bpf_iter_new_fd(raw);
 	else
 		return -ENOENT;
=20
@@ -538,6 +564,8 @@ static struct bpf_prog *__get_prog_inode(struct inode=
 *inode, enum bpf_prog_type
 		return ERR_PTR(-EINVAL);
 	if (inode->i_op =3D=3D &bpf_link_iops)
 		return ERR_PTR(-EINVAL);
+	if (inode->i_op =3D=3D &bpf_iter_iops)
+		return ERR_PTR(-EINVAL);
 	if (inode->i_op !=3D &bpf_prog_iops)
 		return ERR_PTR(-EACCES);
=20
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 458f7000887a..e9ca5fbe8723 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2285,7 +2285,7 @@ static void bpf_link_show_fdinfo(struct seq_file *m=
, struct file *filp)
 }
 #endif
=20
-static const struct file_operations bpf_link_fops =3D {
+const struct file_operations bpf_link_fops =3D {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	=3D bpf_link_show_fdinfo,
 #endif
--=20
2.24.1

