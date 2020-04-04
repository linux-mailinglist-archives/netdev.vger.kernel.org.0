Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2445D19E1CE
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgDDAKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:10:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38266 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726377AbgDDAKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:10:12 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03405CYM014130
        for <netdev@vger.kernel.org>; Fri, 3 Apr 2020 17:10:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=2R5FvPJH8sl4JfElHQsiqoi+Rz4vzfpMnKi7aRLUj7M=;
 b=bSxaQv3WuUCsuUGibe0ITXOJDPhG+SM0XJXob7guFjx5y7FXz4mhK+Dco8IWrIShdT4T
 +kI3bmU+4BgaCeqOcsQuBWSKTcZP6gGSA5j4VsVUiISw6wSiRc7g+0Z/vmWZcBY1r5s/
 2VPy1whXiCffffLF2h56atXMwY5FY9Wf26I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 305upkd6ke-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:10:11 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 3 Apr 2020 17:10:09 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 85FA32EC2885; Fri,  3 Apr 2020 17:10:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 3/8] bpf: allocate ID for bpf_link
Date:   Fri, 3 Apr 2020 17:09:42 -0700
Message-ID: <20200404000948.3980903-4-andriin@fb.com>
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
 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 suspectscore=25 mlxlogscore=999
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generate ID for each bpf_link using IDR, similarly to bpf_map and bpf_pro=
g.
bpf_link creation, initialization, attachment, and exposing to user-space
through FD and ID is a complicated multi-step process, abstract it away
through bpf_link_primer and bpf_link_prime(), bpf_link_settle(), and
bpf_link_cleanup() internal API. They guarantee that until bpf_link is
properly attached, user-space won't be able to access partially-initializ=
ed
bpf_link either from FD or ID. All this allows to simplify bpf_link attac=
hment
and error handling code.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h      |  17 +++--
 include/uapi/linux/bpf.h |   1 +
 kernel/bpf/cgroup.c      |  14 ++--
 kernel/bpf/syscall.c     | 140 +++++++++++++++++++++++++++------------
 4 files changed, 116 insertions(+), 56 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3474f8e34a63..67ce74890911 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1085,11 +1085,19 @@ int bpf_prog_new_fd(struct bpf_prog *prog);
=20
 struct bpf_link {
 	atomic64_t refcnt;
+	u32 id;
 	const struct bpf_link_ops *ops;
 	struct bpf_prog *prog;
 	struct work_struct work;
 };
=20
+struct bpf_link_primer {
+	struct bpf_link *link;
+	struct file *file;
+	int fd;
+	u32 id;
+};
+
 struct bpf_link_ops {
 	void (*release)(struct bpf_link *link);
 	void (*dealloc)(struct bpf_link *link);
@@ -1097,10 +1105,11 @@ struct bpf_link_ops {
 			   struct bpf_prog *old_prog);
 };
=20
-void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops=
,
-		   struct bpf_prog *prog);
-void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
-		      int link_fd);
+void bpf_link_init(struct bpf_link *link,
+		   const struct bpf_link_ops *ops, struct bpf_prog *prog);
+int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer=
);
+int bpf_link_settle(struct bpf_link_primer *primer);
+void bpf_link_cleanup(struct bpf_link_primer *primer);
 void bpf_link_inc(struct bpf_link *link);
 void bpf_link_put(struct bpf_link *link);
 int bpf_link_new_fd(struct bpf_link *link, int flags);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2e29a671d67e..eccfd1dea951 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -523,6 +523,7 @@ union bpf_attr {
 			__u32		prog_id;
 			__u32		map_id;
 			__u32		btf_id;
+			__u32		link_id;
 		};
 		__u32		next_id;
 		__u32		open_flags;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 54eacc44d1e4..ae84c5c90631 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -841,10 +841,10 @@ const struct bpf_link_ops bpf_cgroup_link_lops =3D =
{
=20
 int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *=
prog)
 {
+	struct bpf_link_primer link_primer;
 	struct bpf_cgroup_link *link;
-	struct file *link_file;
 	struct cgroup *cgrp;
-	int err, link_fd;
+	int err;
=20
 	if (attr->link_create.flags)
 		return -EINVAL;
@@ -862,22 +862,20 @@ int cgroup_bpf_link_attach(const union bpf_attr *at=
tr, struct bpf_prog *prog)
 	link->cgroup =3D cgrp;
 	link->type =3D attr->link_create.attach_type;
=20
-	link_file =3D bpf_link_new_file(&link->link, &link_fd);
-	if (IS_ERR(link_file)) {
+	err  =3D bpf_link_prime(&link->link, &link_primer);
+	if (err) {
 		kfree(link);
-		err =3D PTR_ERR(link_file);
 		goto out_put_cgroup;
 	}
=20
 	err =3D cgroup_bpf_attach(cgrp, NULL, NULL, link, link->type,
 				BPF_F_ALLOW_MULTI);
 	if (err) {
-		bpf_link_cleanup(&link->link, link_file, link_fd);
+		bpf_link_cleanup(&link_primer);
 		goto out_put_cgroup;
 	}
=20
-	fd_install(link_fd, link_file);
-	return link_fd;
+	return bpf_link_settle(&link_primer);
=20
 out_put_cgroup:
 	cgroup_put(cgrp);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 47f323901ed9..8b3a7d5814ae 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -42,6 +42,8 @@ static DEFINE_IDR(prog_idr);
 static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
 static DEFINE_SPINLOCK(map_idr_lock);
+static DEFINE_IDR(link_idr);
+static DEFINE_SPINLOCK(link_idr_lock);
=20
 int sysctl_unprivileged_bpf_disabled __read_mostly;
=20
@@ -2184,25 +2186,39 @@ static int bpf_obj_get(const union bpf_attr *attr=
)
 				attr->file_flags);
 }
=20
-void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops=
,
-		   struct bpf_prog *prog)
+void bpf_link_init(struct bpf_link *link,
+		   const struct bpf_link_ops *ops, struct bpf_prog *prog)
 {
 	atomic64_set(&link->refcnt, 1);
+	link->id =3D 0;
 	link->ops =3D ops;
 	link->prog =3D prog;
 }
=20
+static void bpf_link_free_id(struct bpf_link *link)
+{
+	unsigned long flags;
+
+	if (!link->id)
+		return;
+
+	spin_lock_irqsave(&link_idr_lock, flags);
+	idr_remove(&link_idr, link->id);
+	link->id =3D 0;
+	spin_unlock_irqrestore(&link_idr_lock, flags);
+}
+
 /* Clean up bpf_link and corresponding anon_inode file and FD. After
  * anon_inode is created, bpf_link can't be just kfree()'d due to deferr=
ed
  * anon_inode's release() call. This helper manages marking bpf_link as
  * defunct, releases anon_inode file and puts reserved FD.
  */
-void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
-		      int link_fd)
+void bpf_link_cleanup(struct bpf_link_primer *primer)
 {
-	link->prog =3D NULL;
-	fput(link_file);
-	put_unused_fd(link_fd);
+	primer->link->prog =3D NULL;
+	bpf_link_free_id(primer->link);
+	fput(primer->file);
+	put_unused_fd(primer->fd);
 }
=20
 void bpf_link_inc(struct bpf_link *link)
@@ -2213,6 +2229,7 @@ void bpf_link_inc(struct bpf_link *link)
 /* bpf_link_free is guaranteed to be called from process context */
 static void bpf_link_free(struct bpf_link *link)
 {
+	bpf_link_free_id(link);
 	if (link->prog) {
 		/* detach BPF program, clean up used resources */
 		link->ops->release(link);
@@ -2278,9 +2295,11 @@ static void bpf_link_show_fdinfo(struct seq_file *=
m, struct file *filp)
 	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
 	seq_printf(m,
 		   "link_type:\t%s\n"
+		   "link_id:\t%u\n"
 		   "prog_tag:\t%s\n"
 		   "prog_id:\t%u\n",
 		   link_type,
+		   link->id,
 		   prog_tag,
 		   prog->aux->id);
 }
@@ -2295,38 +2314,76 @@ const struct file_operations bpf_link_fops =3D {
 	.write		=3D bpf_dummy_write,
 };
=20
-int bpf_link_new_fd(struct bpf_link *link, int flags)
+static int bpf_link_alloc_id(struct bpf_link *link)
 {
-	return anon_inode_getfd("bpf-link", &bpf_link_fops, link,
-				flags | O_CLOEXEC);
-}
+	int id;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock_bh(&link_idr_lock);
+	id =3D idr_alloc_cyclic(&link_idr, link, 1, INT_MAX, GFP_ATOMIC);
+	spin_unlock_bh(&link_idr_lock);
+	idr_preload_end();
=20
-/* Similar to bpf_link_new_fd, create anon_inode for given bpf_link, but
- * instead of immediately installing fd in fdtable, just reserve it and
- * return. Caller then need to either install it with fd_install(fd, fil=
e) or
- * release with put_unused_fd(fd).
- * This is useful for cases when bpf_link attachment/detachment are
- * complicated and expensive operations and should be delayed until all =
the fd
- * reservation and anon_inode creation succeeds.
+	return id;
+}
+
+/* Prepare bpf_link to be exposed to user-space by allocating anon_inode=
 file,
+ * reserving unused FD and allocating ID from link_idr. This is to be pa=
ired
+ * with bpf_link_settle() to install FD and ID and expose bpf_link to
+ * user-space, if bpf_link is successfully attached. If not, bpf_link an=
d
+ * pre-allocated resources are to be freed with bpf_cleanup() call. All =
the
+ * transient state is passed around in struct bpf_link_primer.
+ * This is preferred way to create and initialize bpf_link, especially w=
hen
+ * there are complicated and expensive operations inbetween creating bpf=
_link
+ * itself and attaching it to BPF hook. By using bpf_link_prime() and
+ * bpf_link_settle() kernel code using bpf_link doesn't have to perform
+ * expensive (and potentially failing) roll back operations in a rare ca=
se
+ * that file, FD, or ID can't be allocated.
  */
-struct file *bpf_link_new_file(struct bpf_link *link, int *reserved_fd)
+int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer=
)
 {
 	struct file *file;
-	int fd;
+	int fd, id;
=20
 	fd =3D get_unused_fd_flags(O_CLOEXEC);
 	if (fd < 0)
-		return ERR_PTR(fd);
+		return fd;
=20
 	file =3D anon_inode_getfile("bpf_link", &bpf_link_fops, link,
 				  O_RDWR | O_CLOEXEC);
 	if (IS_ERR(file)) {
 		put_unused_fd(fd);
-		return file;
+		return PTR_ERR(file);
+	}
+
+	id =3D bpf_link_alloc_id(link);
+	if (id < 0) {
+		put_unused_fd(fd);
+		fput(file);
+		return id;
 	}
=20
-	*reserved_fd =3D fd;
-	return file;
+	primer->link =3D link;
+	primer->file =3D file;
+	primer->fd =3D fd;
+	primer->id =3D id;
+	return 0;
+}
+
+int bpf_link_settle(struct bpf_link_primer *primer)
+{
+	/* make bpf_link fetchable by ID */
+	WRITE_ONCE(primer->link->id, primer->id);
+	/* make bpf_link fetchable by FD */
+	fd_install(primer->fd, primer->file);
+	/* pass through installed FD */
+	return primer->fd;
+}
+
+int bpf_link_new_fd(struct bpf_link *link, int flags)
+{
+	return anon_inode_getfd("bpf-link", &bpf_link_fops, link,
+				flags | O_CLOEXEC);
 }
=20
 struct bpf_link *bpf_link_get_from_fd(u32 ufd, fmode_t *link_mode)
@@ -2374,9 +2431,9 @@ static const struct bpf_link_ops bpf_tracing_link_l=
ops =3D {
=20
 static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 {
+	struct bpf_link_primer link_primer;
 	struct bpf_tracing_link *link;
-	struct file *link_file;
-	int link_fd, err;
+	int err;
=20
 	switch (prog->type) {
 	case BPF_PROG_TYPE_TRACING:
@@ -2411,22 +2468,19 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog)
 	}
 	bpf_link_init(&link->link, &bpf_tracing_link_lops, prog);
=20
-	link_file =3D bpf_link_new_file(&link->link, &link_fd);
-	if (IS_ERR(link_file)) {
+	err =3D bpf_link_prime(&link->link, &link_primer);
+	if (err) {
 		kfree(link);
-		err =3D PTR_ERR(link_file);
 		goto out_put_prog;
 	}
=20
 	err =3D bpf_trampoline_link_prog(prog);
 	if (err) {
-		bpf_link_cleanup(&link->link, link_file, link_fd);
+		bpf_link_cleanup(&link_primer);
 		goto out_put_prog;
 	}
=20
-	fd_install(link_fd, link_file);
-	return link_fd;
-
+	return bpf_link_settle(&link_primer);
 out_put_prog:
 	bpf_prog_put(prog);
 	return err;
@@ -2454,7 +2508,7 @@ static void bpf_raw_tp_link_dealloc(struct bpf_link=
 *link)
 	kfree(raw_tp);
 }
=20
-static const struct bpf_link_ops bpf_raw_tp_lops =3D {
+static const struct bpf_link_ops bpf_raw_tp_link_lops =3D {
 	.release =3D bpf_raw_tp_link_release,
 	.dealloc =3D bpf_raw_tp_link_dealloc,
 };
@@ -2463,13 +2517,13 @@ static const struct bpf_link_ops bpf_raw_tp_lops =
=3D {
=20
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 {
+	struct bpf_link_primer link_primer;
 	struct bpf_raw_tp_link *link;
 	struct bpf_raw_event_map *btp;
-	struct file *link_file;
 	struct bpf_prog *prog;
 	const char *tp_name;
 	char buf[128];
-	int link_fd, err;
+	int err;
=20
 	if (CHECK_ATTR(BPF_RAW_TRACEPOINT_OPEN))
 		return -EINVAL;
@@ -2522,24 +2576,22 @@ static int bpf_raw_tracepoint_open(const union bp=
f_attr *attr)
 		err =3D -ENOMEM;
 		goto out_put_btp;
 	}
-	bpf_link_init(&link->link, &bpf_raw_tp_lops, prog);
+	bpf_link_init(&link->link, &bpf_raw_tp_link_lops, prog);
 	link->btp =3D btp;
=20
-	link_file =3D bpf_link_new_file(&link->link, &link_fd);
-	if (IS_ERR(link_file)) {
+	err =3D bpf_link_prime(&link->link, &link_primer);
+	if (err) {
 		kfree(link);
-		err =3D PTR_ERR(link_file);
 		goto out_put_btp;
 	}
=20
 	err =3D bpf_probe_register(link->btp, prog);
 	if (err) {
-		bpf_link_cleanup(&link->link, link_file, link_fd);
+		bpf_link_cleanup(&link_primer);
 		goto out_put_btp;
 	}
=20
-	fd_install(link_fd, link_file);
-	return link_fd;
+	return bpf_link_settle(&link_primer);
=20
 out_put_btp:
 	bpf_put_raw_tracepoint(btp);
@@ -3471,7 +3523,7 @@ static int bpf_task_fd_query(const union bpf_attr *=
attr,
 	if (file->f_op =3D=3D &bpf_link_fops) {
 		struct bpf_link *link =3D file->private_data;
=20
-		if (link->ops =3D=3D &bpf_raw_tp_lops) {
+		if (link->ops =3D=3D &bpf_raw_tp_link_lops) {
 			struct bpf_raw_tp_link *raw_tp =3D
 				container_of(link, struct bpf_raw_tp_link, link);
 			struct bpf_raw_event_map *btp =3D raw_tp->btp;
--=20
2.24.1

