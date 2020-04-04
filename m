Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCE819E1CD
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgDDAKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:10:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58963 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbgDDAKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:10:10 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03409a6D015264
        for <netdev@vger.kernel.org>; Fri, 3 Apr 2020 17:10:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=X+5G5Mp6fY6EaFwnuc1B/XkP09ODoP08g6McOldy1hk=;
 b=ZDfpn7b2UsbD6YQyz3vqsOD7Jg+off7z0Gjh/XewKKeYqzZurO1AI8+YoU18qthHYjCD
 NFwkwULNjno2NXgyrS87Qq2o9eTZEYWnqZMD65tnm8SXoZ28N1Jv6Sv31FhdopTqlK1g
 +2KxPt71zUxSsCeK0vaFn5RvuY5IcOVfKxI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30697e9tfw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:10:08 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 3 Apr 2020 17:10:07 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5AE192EC2885; Fri,  3 Apr 2020 17:10:03 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 2/8] bpf: allow bpf_link pinning as read-only and enforce LINK_UPDATE
Date:   Fri, 3 Apr 2020 17:09:41 -0700
Message-ID: <20200404000948.3980903-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200404000948.3980903-1-andriin@fb.com>
References: <20200404000948.3980903-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_19:2020-04-03,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 suspectscore=8 bulkscore=0 mlxlogscore=658 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to pin bpf_link as read-only to control whether LINK_UPD=
ATE
operation is allowed or not. bpf_links provided through read-only files a=
re
not allowed to perform LINK_UPDATE operations, which this patch starts
enforcing. bpf_map and bpf_prog are still always treated as read-write on=
es,
just like before.

This is a critical property for bpf_links and is going to be relied upon =
for
BPF_LINK_GET_FD_BY_ID operation implemented later in the series. GET_FD_B=
Y_ID
will only return read-only links to prevent processes that do not "own"
bpf_link from updating underlying bpf_prog.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h  |  6 +++---
 kernel/bpf/inode.c   | 30 ++++++++++++++++++++++--------
 kernel/bpf/syscall.c | 26 +++++++++++++++++++-------
 3 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ea65c3165e4c..3474f8e34a63 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1103,11 +1103,11 @@ void bpf_link_cleanup(struct bpf_link *link, stru=
ct file *link_file,
 		      int link_fd);
 void bpf_link_inc(struct bpf_link *link);
 void bpf_link_put(struct bpf_link *link);
-int bpf_link_new_fd(struct bpf_link *link);
+int bpf_link_new_fd(struct bpf_link *link, int flags);
 struct file *bpf_link_new_file(struct bpf_link *link, int *reserved_fd);
-struct bpf_link *bpf_link_get_from_fd(u32 ufd);
+struct bpf_link *bpf_link_get_from_fd(u32 ufd, fmode_t *link_mode);
=20
-int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
+int bpf_obj_pin_user(u32 ufd, const char __user *pathname, int file_flag=
s);
 int bpf_obj_get_user(const char __user *pathname, int flags);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 95087d9f4ed3..3fd71c1e3c33 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -66,23 +66,25 @@ static void bpf_any_put(void *raw, enum bpf_type type=
)
 	}
 }
=20
-static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type)
+static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type, fmode_t *fil=
e_mode)
 {
 	void *raw;
=20
 	raw =3D bpf_map_get_with_uref(ufd);
 	if (!IS_ERR(raw)) {
 		*type =3D BPF_TYPE_MAP;
+		*file_mode =3D O_RDWR;
 		return raw;
 	}
=20
 	raw =3D bpf_prog_get(ufd);
 	if (!IS_ERR(raw)) {
 		*type =3D BPF_TYPE_PROG;
+		*file_mode =3D O_RDWR;
 		return raw;
 	}
=20
-	raw =3D bpf_link_get_from_fd(ufd);
+	raw =3D bpf_link_get_from_fd(ufd, file_mode);
 	if (!IS_ERR(raw)) {
 		*type =3D BPF_TYPE_LINK;
 		return raw;
@@ -407,7 +409,7 @@ static const struct inode_operations bpf_dir_iops =3D=
 {
 };
=20
 static int bpf_obj_do_pin(const char __user *pathname, void *raw,
-			  enum bpf_type type)
+			  enum bpf_type type, fmode_t file_mode)
 {
 	struct dentry *dentry;
 	struct inode *dir;
@@ -419,7 +421,7 @@ static int bpf_obj_do_pin(const char __user *pathname=
, void *raw,
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
=20
-	mode =3D S_IFREG | ((S_IRUSR | S_IWUSR) & ~current_umask());
+	mode =3D S_IFREG | (ACC_MODE(file_mode) & ~current_umask());
=20
 	ret =3D security_path_mknod(&path, dentry, mode, 0);
 	if (ret)
@@ -449,17 +451,29 @@ static int bpf_obj_do_pin(const char __user *pathna=
me, void *raw,
 	return ret;
 }
=20
-int bpf_obj_pin_user(u32 ufd, const char __user *pathname)
+int bpf_obj_pin_user(u32 ufd, const char __user *pathname, int file_flag=
s)
 {
 	enum bpf_type type;
+	fmode_t file_mode;
 	void *raw;
 	int ret;
=20
-	raw =3D bpf_fd_probe_obj(ufd, &type);
+	raw =3D bpf_fd_probe_obj(ufd, &type, &file_mode);
 	if (IS_ERR(raw))
 		return PTR_ERR(raw);
=20
-	ret =3D bpf_obj_do_pin(pathname, raw, type);
+	if ((type =3D=3D BPF_TYPE_MAP || type =3D=3D BPF_TYPE_PROG) && file_fla=
gs)
+		return -EINVAL;
+
+	/* requested pinned file mode has to be a valid subset */
+	if (!file_flags) {
+		file_flags =3D file_mode;
+	} else if ((file_mode & file_flags) !=3D file_flags) {
+		bpf_any_put(raw, type);
+		return -EPERM;
+	}
+
+	ret =3D bpf_obj_do_pin(pathname, raw, type, file_flags);
 	if (ret !=3D 0)
 		bpf_any_put(raw, type);
=20
@@ -518,7 +532,7 @@ int bpf_obj_get_user(const char __user *pathname, int=
 flags)
 	else if (type =3D=3D BPF_TYPE_MAP)
 		ret =3D bpf_map_new_fd(raw, f_flags);
 	else if (type =3D=3D BPF_TYPE_LINK)
-		ret =3D bpf_link_new_fd(raw);
+		ret =3D bpf_link_new_fd(raw, f_flags);
 	else
 		return -ENOENT;
=20
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 40993d8c936e..47f323901ed9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2167,10 +2167,11 @@ static int bpf_prog_load(union bpf_attr *attr, un=
ion bpf_attr __user *uattr)
=20
 static int bpf_obj_pin(const union bpf_attr *attr)
 {
-	if (CHECK_ATTR(BPF_OBJ) || attr->file_flags !=3D 0)
+	if (CHECK_ATTR(BPF_OBJ))
 		return -EINVAL;
=20
-	return bpf_obj_pin_user(attr->bpf_fd, u64_to_user_ptr(attr->pathname));
+	return bpf_obj_pin_user(attr->bpf_fd, u64_to_user_ptr(attr->pathname),
+				attr->file_flags);
 }
=20
 static int bpf_obj_get(const union bpf_attr *attr)
@@ -2294,9 +2295,10 @@ const struct file_operations bpf_link_fops =3D {
 	.write		=3D bpf_dummy_write,
 };
=20
-int bpf_link_new_fd(struct bpf_link *link)
+int bpf_link_new_fd(struct bpf_link *link, int flags)
 {
-	return anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
+	return anon_inode_getfd("bpf-link", &bpf_link_fops, link,
+				flags | O_CLOEXEC);
 }
=20
 /* Similar to bpf_link_new_fd, create anon_inode for given bpf_link, but
@@ -2316,7 +2318,8 @@ struct file *bpf_link_new_file(struct bpf_link *lin=
k, int *reserved_fd)
 	if (fd < 0)
 		return ERR_PTR(fd);
=20
-	file =3D anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC=
);
+	file =3D anon_inode_getfile("bpf_link", &bpf_link_fops, link,
+				  O_RDWR | O_CLOEXEC);
 	if (IS_ERR(file)) {
 		put_unused_fd(fd);
 		return file;
@@ -2326,7 +2329,7 @@ struct file *bpf_link_new_file(struct bpf_link *lin=
k, int *reserved_fd)
 	return file;
 }
=20
-struct bpf_link *bpf_link_get_from_fd(u32 ufd)
+struct bpf_link *bpf_link_get_from_fd(u32 ufd, fmode_t *link_mode)
 {
 	struct fd f =3D fdget(ufd);
 	struct bpf_link *link;
@@ -2340,6 +2343,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd)
=20
 	link =3D f.file->private_data;
 	bpf_link_inc(link);
+	if (link_mode)
+		*link_mode =3D f.file->f_mode;
 	fdput(f);
=20
 	return link;
@@ -3612,6 +3617,7 @@ static int link_update(union bpf_attr *attr)
 {
 	struct bpf_prog *old_prog =3D NULL, *new_prog;
 	struct bpf_link *link;
+	fmode_t link_mode;
 	u32 flags;
 	int ret;
=20
@@ -3625,10 +3631,16 @@ static int link_update(union bpf_attr *attr)
 	if (flags & ~BPF_F_REPLACE)
 		return -EINVAL;
=20
-	link =3D bpf_link_get_from_fd(attr->link_update.link_fd);
+	link =3D bpf_link_get_from_fd(attr->link_update.link_fd, &link_mode);
 	if (IS_ERR(link))
 		return PTR_ERR(link);
=20
+	/* read-only link references are not allowed to perform LINK_UPDATE */
+	if (!(link_mode & O_WRONLY)) {
+		bpf_link_put(link);
+		return -EACCES;
+	}
+
 	new_prog =3D bpf_prog_get(attr->link_update.new_prog_fd);
 	if (IS_ERR(new_prog))
 		return PTR_ERR(new_prog);
--=20
2.24.1

