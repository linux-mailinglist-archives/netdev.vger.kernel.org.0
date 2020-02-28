Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01ABB174216
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgB1WkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:40:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726589AbgB1WkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:40:01 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SMdGGV007227
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:40:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Dzniy8IGYmhopt74kVBqDIzBBCYcVVPvWFnLrzlSuls=;
 b=PZqaOXMcGDI0t33NkwqOGLnUcf2/S74QTC7u2zKbkqoPDyLSykecEer7yugPiUq5i4wx
 CgvG6rmlryVJRrFDG29UIbEjIBnt/VFY1b2Rw9jWnobX/YbErSUjfnjdCC3hqN27thKI
 M45kitMTtdLNrBrvOzHqPJ6O937RsHOxBls= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfb23884n-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:40:00 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 28 Feb 2020 14:39:58 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 21AFF2EC2D20; Fri, 28 Feb 2020 14:39:53 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpf: introduce pinnable bpf_link abstraction
Date:   Fri, 28 Feb 2020 14:39:46 -0800
Message-ID: <20200228223948.360936-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200228223948.360936-1-andriin@fb.com>
References: <20200228223948.360936-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_08:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=25 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002280163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_link abstraction, representing an attachment of BPF program to
a BPF hook point (e.g., tracepoint, perf event, etc). bpf_link encapsulates
ownership of attached BPF program, reference counting of a link itself, when
reference from multiple anonymous inodes, as well as ensures that release
callback will be called from a process context, so that users can safely take
mutex locks and sleep.

Additionally, with a new abstraction it's now possible to generalize pinning
of a link object in BPF FS, allowing to explicitly prevent BPF program
detachment on process exit by pinning it in a BPF FS and let it open from
independent other process to keep working with it.

Convert two existing bpf_link-like objects (raw tracepoint and tracing BPF
program attachments) into utilizing bpf_link framework, making them pinnable
in BPF FS. More FD-based bpf_links will be added in follow up patches.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h  |  13 +++
 kernel/bpf/inode.c   |  42 ++++++++-
 kernel/bpf/syscall.c | 209 ++++++++++++++++++++++++++++++++++++-------
 3 files changed, 226 insertions(+), 38 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6015a4daf118..f13c78c6f29d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1056,6 +1056,19 @@ extern int sysctl_unprivileged_bpf_disabled;
 int bpf_map_new_fd(struct bpf_map *map, int flags);
 int bpf_prog_new_fd(struct bpf_prog *prog);
 
+struct bpf_link;
+
+struct bpf_link_ops {
+	void (*release)(struct bpf_link *link);
+};
+
+void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
+		   struct bpf_prog *prog);
+void bpf_link_inc(struct bpf_link *link);
+void bpf_link_put(struct bpf_link *link);
+int bpf_link_new_fd(struct bpf_link *link);
+struct bpf_link *bpf_link_get_from_fd(u32 ufd);
+
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
 
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 5e40e7fccc21..95087d9f4ed3 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -25,6 +25,7 @@ enum bpf_type {
 	BPF_TYPE_UNSPEC	= 0,
 	BPF_TYPE_PROG,
 	BPF_TYPE_MAP,
+	BPF_TYPE_LINK,
 };
 
 static void *bpf_any_get(void *raw, enum bpf_type type)
@@ -36,6 +37,9 @@ static void *bpf_any_get(void *raw, enum bpf_type type)
 	case BPF_TYPE_MAP:
 		bpf_map_inc_with_uref(raw);
 		break;
+	case BPF_TYPE_LINK:
+		bpf_link_inc(raw);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -53,6 +57,9 @@ static void bpf_any_put(void *raw, enum bpf_type type)
 	case BPF_TYPE_MAP:
 		bpf_map_put_with_uref(raw);
 		break;
+	case BPF_TYPE_LINK:
+		bpf_link_put(raw);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -63,20 +70,32 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type)
 {
 	void *raw;
 
-	*type = BPF_TYPE_MAP;
 	raw = bpf_map_get_with_uref(ufd);
-	if (IS_ERR(raw)) {
+	if (!IS_ERR(raw)) {
+		*type = BPF_TYPE_MAP;
+		return raw;
+	}
+
+	raw = bpf_prog_get(ufd);
+	if (!IS_ERR(raw)) {
 		*type = BPF_TYPE_PROG;
-		raw = bpf_prog_get(ufd);
+		return raw;
 	}
 
-	return raw;
+	raw = bpf_link_get_from_fd(ufd);
+	if (!IS_ERR(raw)) {
+		*type = BPF_TYPE_LINK;
+		return raw;
+	}
+
+	return ERR_PTR(-EINVAL);
 }
 
 static const struct inode_operations bpf_dir_iops;
 
 static const struct inode_operations bpf_prog_iops = { };
 static const struct inode_operations bpf_map_iops  = { };
+static const struct inode_operations bpf_link_iops  = { };
 
 static struct inode *bpf_get_inode(struct super_block *sb,
 				   const struct inode *dir,
@@ -114,6 +133,8 @@ static int bpf_inode_type(const struct inode *inode, enum bpf_type *type)
 		*type = BPF_TYPE_PROG;
 	else if (inode->i_op == &bpf_map_iops)
 		*type = BPF_TYPE_MAP;
+	else if (inode->i_op == &bpf_link_iops)
+		*type = BPF_TYPE_LINK;
 	else
 		return -EACCES;
 
@@ -335,6 +356,12 @@ static int bpf_mkmap(struct dentry *dentry, umode_t mode, void *arg)
 			     &bpffs_map_fops : &bpffs_obj_fops);
 }
 
+static int bpf_mklink(struct dentry *dentry, umode_t mode, void *arg)
+{
+	return bpf_mkobj_ops(dentry, mode, arg, &bpf_link_iops,
+			     &bpffs_obj_fops);
+}
+
 static struct dentry *
 bpf_lookup(struct inode *dir, struct dentry *dentry, unsigned flags)
 {
@@ -411,6 +438,9 @@ static int bpf_obj_do_pin(const char __user *pathname, void *raw,
 	case BPF_TYPE_MAP:
 		ret = vfs_mkobj(dentry, mode, bpf_mkmap, raw);
 		break;
+	case BPF_TYPE_LINK:
+		ret = vfs_mkobj(dentry, mode, bpf_mklink, raw);
+		break;
 	default:
 		ret = -EPERM;
 	}
@@ -487,6 +517,8 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
 		ret = bpf_prog_new_fd(raw);
 	else if (type == BPF_TYPE_MAP)
 		ret = bpf_map_new_fd(raw, f_flags);
+	else if (type == BPF_TYPE_LINK)
+		ret = bpf_link_new_fd(raw);
 	else
 		return -ENOENT;
 
@@ -504,6 +536,8 @@ static struct bpf_prog *__get_prog_inode(struct inode *inode, enum bpf_prog_type
 
 	if (inode->i_op == &bpf_map_iops)
 		return ERR_PTR(-EINVAL);
+	if (inode->i_op == &bpf_link_iops)
+		return ERR_PTR(-EINVAL);
 	if (inode->i_op != &bpf_prog_iops)
 		return ERR_PTR(-EACCES);
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c536c65256ad..fca8de7e7872 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2173,23 +2173,153 @@ static int bpf_obj_get(const union bpf_attr *attr)
 				attr->file_flags);
 }
 
-static int bpf_tracing_prog_release(struct inode *inode, struct file *filp)
+struct bpf_link {
+	atomic64_t refcnt;
+	const struct bpf_link_ops *ops;
+	struct bpf_prog *prog;
+	struct work_struct work;
+};
+
+void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
+		   struct bpf_prog *prog)
 {
-	struct bpf_prog *prog = filp->private_data;
+	atomic64_set(&link->refcnt, 1);
+	link->ops = ops;
+	link->prog = prog;
+}
+
+void bpf_link_inc(struct bpf_link *link)
+{
+	atomic64_inc(&link->refcnt);
+}
+
+/* bpf_link_free is guaranteed to be called from process context */
+static void bpf_link_free(struct bpf_link *link)
+{
+	struct bpf_prog *prog;
 
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
+	/* remember prog locally, because release below will free link memory */
+	prog = link->prog;
+	/* extra clean up and kfree of container link struct */
+	link->ops->release(link);
+	/* no more accesing of link members after this point */
 	bpf_prog_put(prog);
+}
+
+static void bpf_link_put_deferred(struct work_struct *work)
+{
+	struct bpf_link *link = container_of(work, struct bpf_link, work);
+
+	bpf_link_free(link);
+}
+
+/* bpf_link_put can be called from atomic context, but ensures that resources
+ * are freed from process context
+ */
+void bpf_link_put(struct bpf_link *link)
+{
+	if (!atomic64_dec_and_test(&link->refcnt))
+		return;
+
+	if (in_atomic()) {
+		INIT_WORK(&link->work, bpf_link_put_deferred);
+		schedule_work(&link->work);
+	} else {
+		bpf_link_free(link);
+	}
+}
+
+static int bpf_link_release(struct inode *inode, struct file *filp)
+{
+	struct bpf_link *link = filp->private_data;
+
+	bpf_link_put(link);
 	return 0;
 }
 
-static const struct file_operations bpf_tracing_prog_fops = {
-	.release	= bpf_tracing_prog_release,
+#ifdef CONFIG_PROC_FS
+static const struct bpf_link_ops bpf_raw_tp_lops;
+static const struct bpf_link_ops bpf_tracing_link_lops;
+static const struct bpf_link_ops bpf_xdp_link_lops;
+
+static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
+{
+	const struct bpf_link *link = filp->private_data;
+	const struct bpf_prog *prog = link->prog;
+	char prog_tag[sizeof(prog->tag) * 2 + 1] = { };
+	const char *link_type;
+
+	if (link->ops == &bpf_raw_tp_lops)
+		link_type = "raw_tracepoint";
+	else if (link->ops == &bpf_tracing_link_lops)
+		link_type = "tracing";
+	else
+		link_type = "unknown";
+
+	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
+	seq_printf(m,
+		   "link_type:\t%s\n"
+		   "prog_tag:\t%s\n"
+		   "prog_id:\t%u\n",
+		   link_type,
+		   prog_tag,
+		   prog->aux->id);
+}
+#endif
+
+const struct file_operations bpf_link_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= bpf_link_show_fdinfo,
+#endif
+	.release	= bpf_link_release,
 	.read		= bpf_dummy_read,
 	.write		= bpf_dummy_write,
 };
 
+int bpf_link_new_fd(struct bpf_link *link)
+{
+	return anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
+}
+
+struct bpf_link *bpf_link_get_from_fd(u32 ufd)
+{
+	struct fd f = fdget(ufd);
+	struct bpf_link *link;
+
+	if (!f.file)
+		return ERR_PTR(-EBADF);
+	if (f.file->f_op != &bpf_link_fops) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
+	}
+
+	link = f.file->private_data;
+	bpf_link_inc(link);
+	fdput(f);
+
+	return link;
+}
+
+struct bpf_tracing_link {
+	struct bpf_link link;
+};
+
+static void bpf_tracing_link_release(struct bpf_link *link)
+{
+	struct bpf_tracing_link *tr_link =
+		container_of(link, struct bpf_tracing_link, link);
+
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog));
+	kfree(tr_link);
+}
+
+static const struct bpf_link_ops bpf_tracing_link_lops = {
+	.release = bpf_tracing_link_release,
+};
+
 static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 {
+	struct bpf_tracing_link *link;
 	int tr_fd, err;
 
 	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
@@ -2199,53 +2329,57 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 		goto out_put_prog;
 	}
 
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link) {
+		err = -ENOMEM;
+		goto out_put_prog;
+	}
+	bpf_link_init(&link->link, &bpf_tracing_link_lops, prog);
+
 	err = bpf_trampoline_link_prog(prog);
 	if (err)
-		goto out_put_prog;
+		goto out_free_link;
 
-	tr_fd = anon_inode_getfd("bpf-tracing-prog", &bpf_tracing_prog_fops,
-				 prog, O_CLOEXEC);
+	tr_fd = anon_inode_getfd("bpf-tracing-link", &bpf_link_fops,
+				 &link->link, O_CLOEXEC);
 	if (tr_fd < 0) {
 		WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
 		err = tr_fd;
-		goto out_put_prog;
+		goto out_free_link;
 	}
 	return tr_fd;
 
+out_free_link:
+	kfree(link);
 out_put_prog:
 	bpf_prog_put(prog);
 	return err;
 }
 
-struct bpf_raw_tracepoint {
+struct bpf_raw_tp_link {
+	struct bpf_link link;
 	struct bpf_raw_event_map *btp;
-	struct bpf_prog *prog;
 };
 
-static int bpf_raw_tracepoint_release(struct inode *inode, struct file *filp)
+static void bpf_raw_tp_link_release(struct bpf_link *link)
 {
-	struct bpf_raw_tracepoint *raw_tp = filp->private_data;
+	struct bpf_raw_tp_link *raw_tp =
+		container_of(link, struct bpf_raw_tp_link, link);
 
-	if (raw_tp->prog) {
-		bpf_probe_unregister(raw_tp->btp, raw_tp->prog);
-		bpf_prog_put(raw_tp->prog);
-	}
+	bpf_probe_unregister(raw_tp->btp, raw_tp->link.prog);
 	bpf_put_raw_tracepoint(raw_tp->btp);
 	kfree(raw_tp);
-	return 0;
 }
 
-static const struct file_operations bpf_raw_tp_fops = {
-	.release	= bpf_raw_tracepoint_release,
-	.read		= bpf_dummy_read,
-	.write		= bpf_dummy_write,
+static const struct bpf_link_ops bpf_raw_tp_lops = {
+	.release = bpf_raw_tp_link_release,
 };
 
 #define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
 
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 {
-	struct bpf_raw_tracepoint *raw_tp;
+	struct bpf_raw_tp_link *raw_tp;
 	struct bpf_raw_event_map *btp;
 	struct bpf_prog *prog;
 	const char *tp_name;
@@ -2302,15 +2436,15 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 		err = -ENOMEM;
 		goto out_put_btp;
 	}
+	bpf_link_init(&raw_tp->link, &bpf_raw_tp_lops, prog);
 	raw_tp->btp = btp;
-	raw_tp->prog = prog;
 
 	err = bpf_probe_register(raw_tp->btp, prog);
 	if (err)
 		goto out_free_tp;
 
-	tp_fd = anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
-				 O_CLOEXEC);
+	tp_fd = anon_inode_getfd("bpf-raw-tp-link", &bpf_link_fops,
+				 &raw_tp->link, O_CLOEXEC);
 	if (tp_fd < 0) {
 		bpf_probe_unregister(raw_tp->btp, prog);
 		err = tp_fd;
@@ -3266,15 +3400,21 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (err)
 		goto out;
 
-	if (file->f_op == &bpf_raw_tp_fops) {
-		struct bpf_raw_tracepoint *raw_tp = file->private_data;
-		struct bpf_raw_event_map *btp = raw_tp->btp;
+	if (file->f_op == &bpf_link_fops) {
+		struct bpf_link *link = file->private_data;
 
-		err = bpf_task_fd_query_copy(attr, uattr,
-					     raw_tp->prog->aux->id,
-					     BPF_FD_TYPE_RAW_TRACEPOINT,
-					     btp->tp->name, 0, 0);
-		goto put_file;
+		if (link->ops == &bpf_raw_tp_lops) {
+			struct bpf_raw_tp_link *raw_tp =
+				container_of(link, struct bpf_raw_tp_link, link);
+			struct bpf_raw_event_map *btp = raw_tp->btp;
+
+			err = bpf_task_fd_query_copy(attr, uattr,
+						     raw_tp->link.prog->aux->id,
+						     BPF_FD_TYPE_RAW_TRACEPOINT,
+						     btp->tp->name, 0, 0);
+			goto put_file;
+		}
+		goto out_not_supp;
 	}
 
 	event = perf_get_event(file);
@@ -3294,6 +3434,7 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 		goto put_file;
 	}
 
+out_not_supp:
 	err = -ENOTSUPP;
 put_file:
 	fput(file);
-- 
2.17.1

