Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEBE9826E2
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbfHEV3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730733AbfHEV3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:29:12 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B173214C6;
        Mon,  5 Aug 2019 21:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565040550;
        bh=kN6EBgzfOEqR42PSgmAa1A5oUs07dhaoUWkodGKw+54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/ufDuDIWXiKsDyfOj6qIzp9ZTZwz+4hLBHegPu3IHCtvQemfP+cLLfWEswL4qGDJ
         RWvP72XaXwMOLYcZkEpnjPB+00Ajm2cUd8q+sB5VvNZSFMPmSm/Mx2sClnPrcRyqw6
         f1GrpaipdPc6d4+/Ii8KmaLdPoGtyZ1w3CVsOYjc=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [WIP 1/4] bpf: Respect persistent map and prog access modes
Date:   Mon,  5 Aug 2019 14:29:02 -0700
Message-Id: <3a5ddc41c25e00e8590f6da414bcf0ed7626ffe1.1565040372.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1565040372.git.luto@kernel.org>
References: <cover.1565040372.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the interest of making bpf() more useful by unprivileged users,
this patch teaches bpf to respect access modes on map and prog
inodes.  The permissions are:

R on a map: read the map
W on a map: write the map

Referencing a map from a program should require RW.

R on a prog: Read or introspect the prog
W on a prog: Attach the prog to something

Test-running a prog is a form of introspection, so it requires RW.
Detaching a prog merely uses the fd for identification, so neither R
nor W is needed.

This is likely incomplete, and it has some comments that should be
removed.

This patch uses WRITE instead of EXEC as the permission needed to
run (by attaching or test-running) a program.  EXEC seems nicer, but
O_MAYEXEC isn't merged, which makes using X awkward.
---
 include/linux/bpf.h    | 15 +++++++------
 kernel/bpf/arraymap.c  |  8 ++++++-
 kernel/bpf/cgroup.c    |  6 ++++-
 kernel/bpf/inode.c     | 25 ++++++++++++++-------
 kernel/bpf/syscall.c   | 51 ++++++++++++++++++++++++++++++------------
 kernel/events/core.c   |  5 +++--
 net/core/dev.c         |  4 +++-
 net/core/filter.c      |  8 ++++---
 net/netfilter/xt_bpf.c |  5 +++--
 net/packet/af_packet.c |  2 +-
 10 files changed, 89 insertions(+), 40 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 18f4cc2c6acd..2d5e1a4dff6c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -630,9 +630,9 @@ extern const struct bpf_prog_ops bpf_offload_prog_ops;
 extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
 extern const struct bpf_verifier_ops xdp_analyzer_ops;
 
-struct bpf_prog *bpf_prog_get(u32 ufd);
+struct bpf_prog *bpf_prog_get(u32 ufd, int mask);
 struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
-				       bool attach_drv);
+				       bool attach_drv, int mask);
 struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog, int i);
 void bpf_prog_sub(struct bpf_prog *prog, int i);
 struct bpf_prog * __must_check bpf_prog_inc(struct bpf_prog *prog);
@@ -662,7 +662,7 @@ void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 extern int sysctl_unprivileged_bpf_disabled;
 
 int bpf_map_new_fd(struct bpf_map *map, int flags);
-int bpf_prog_new_fd(struct bpf_prog *prog);
+int bpf_prog_new_fd(struct bpf_prog *prog, int flags);
 
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
@@ -733,7 +733,7 @@ static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
 		attr->numa_node : NUMA_NO_NODE;
 }
 
-struct bpf_prog *bpf_prog_get_type_path(const char *name, enum bpf_prog_type type);
+struct bpf_prog *bpf_prog_get_type_path(const char *name, enum bpf_prog_type type, int mask);
 int array_map_alloc_check(union bpf_attr *attr);
 
 int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
@@ -850,7 +850,7 @@ static inline int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu,
 }
 
 static inline struct bpf_prog *bpf_prog_get_type_path(const char *name,
-				enum bpf_prog_type type)
+				enum bpf_prog_type type, int mask)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
@@ -878,9 +878,10 @@ static inline int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 #endif /* CONFIG_BPF_SYSCALL */
 
 static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
-						 enum bpf_prog_type type)
+						 enum bpf_prog_type type,
+						 int mask)
 {
-	return bpf_prog_get_type_dev(ufd, type, false);
+	return bpf_prog_get_type_dev(ufd, type, false, mask);
 }
 
 bool bpf_prog_get_ok(struct bpf_prog *, enum bpf_prog_type *, bool);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a9..7e17a5d42110 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -522,6 +522,10 @@ int bpf_fd_array_map_lookup_elem(struct bpf_map *map, void *key, u32 *value)
 }
 
 /* only called from syscall */
+/*
+ * XXX: it's totally unclear to me what this ends up doing with the fd
+ * in general.
+ */
 int bpf_fd_array_map_update_elem(struct bpf_map *map, struct file *map_file,
 				 void *key, void *value, u64 map_flags)
 {
@@ -569,7 +573,9 @@ static void *prog_fd_array_get_ptr(struct bpf_map *map,
 				   struct file *map_file, int fd)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
-	struct bpf_prog *prog = bpf_prog_get(fd);
+
+	/* XXX: what, exactly, does this end up doing to the prog in question? */
+	struct bpf_prog *prog = bpf_prog_get(fd, FMODE_READ | FMODE_WRITE);
 
 	if (IS_ERR(prog))
 		return prog;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 0a00eaca6fae..1450c3bdab82 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -562,7 +562,11 @@ int cgroup_bpf_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
 	if (IS_ERR(cgrp))
 		return PTR_ERR(cgrp);
 
-	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
+	/*
+	 * No particular access required -- this only uses the fd to identify
+	 * a program, not to do anything with the program.
+	 */
+	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype, 0);
 	if (IS_ERR(prog))
 		prog = NULL;
 
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index cc0d0cf114e3..cb07736b33ae 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -58,7 +58,7 @@ static void bpf_any_put(void *raw, enum bpf_type type)
 	}
 }
 
-static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type)
+static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type, int mask)
 {
 	void *raw;
 
@@ -66,7 +66,7 @@ static void *bpf_fd_probe_obj(u32 ufd, enum bpf_type *type)
 	raw = bpf_map_get_with_uref(ufd);
 	if (IS_ERR(raw)) {
 		*type = BPF_TYPE_PROG;
-		raw = bpf_prog_get(ufd);
+		raw = bpf_prog_get(ufd, mask);
 	}
 
 	return raw;
@@ -430,7 +430,12 @@ int bpf_obj_pin_user(u32 ufd, const char __user *pathname)
 	if (IS_ERR(pname))
 		return PTR_ERR(pname);
 
-	raw = bpf_fd_probe_obj(ufd, &type);
+	/*
+	 * Pinning an object effectively grants the caller all access, because
+	 * the caller ends up owning the inode.  So require all access.
+	 * XXX: If we use FMODE_EXEC, we should require FMODE_EXEC too.
+	 */
+	raw = bpf_fd_probe_obj(ufd, &type, FMODE_READ | FMODE_WRITE);
 	if (IS_ERR(raw)) {
 		ret = PTR_ERR(raw);
 		goto out;
@@ -456,6 +461,10 @@ static void *bpf_obj_do_get(const struct filename *pathname,
 	if (ret)
 		return ERR_PTR(ret);
 
+	/*
+	 * XXX: O_MAYEXEC doesn't exist, which is problematic here if we
+	 * want to use FMODE_EXEC.
+	 */
 	inode = d_backing_inode(path.dentry);
 	ret = inode_permission(inode, ACC_MODE(flags));
 	if (ret)
@@ -499,7 +508,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
 	}
 
 	if (type == BPF_TYPE_PROG)
-		ret = bpf_prog_new_fd(raw);
+		ret = bpf_prog_new_fd(raw, f_flags);
 	else if (type == BPF_TYPE_MAP)
 		ret = bpf_map_new_fd(raw, f_flags);
 	else
@@ -512,10 +521,10 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
 	return ret;
 }
 
-static struct bpf_prog *__get_prog_inode(struct inode *inode, enum bpf_prog_type type)
+static struct bpf_prog *__get_prog_inode(struct inode *inode, enum bpf_prog_type type, int mask)
 {
 	struct bpf_prog *prog;
-	int ret = inode_permission(inode, MAY_READ);
+	int ret = inode_permission(inode, mask);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -536,14 +545,14 @@ static struct bpf_prog *__get_prog_inode(struct inode *inode, enum bpf_prog_type
 	return bpf_prog_inc(prog);
 }
 
-struct bpf_prog *bpf_prog_get_type_path(const char *name, enum bpf_prog_type type)
+struct bpf_prog *bpf_prog_get_type_path(const char *name, enum bpf_prog_type type, int mask)
 {
 	struct bpf_prog *prog;
 	struct path path;
 	int ret = kern_path(name, LOOKUP_FOLLOW, &path);
 	if (ret)
 		return ERR_PTR(ret);
-	prog = __get_prog_inode(d_backing_inode(path.dentry), type);
+	prog = __get_prog_inode(d_backing_inode(path.dentry), type, mask);
 	if (!IS_ERR(prog))
 		touch_atime(&path);
 	path_put(&path);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5d141f16f6fa..23f8f89d2a86 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -447,6 +447,7 @@ int bpf_map_new_fd(struct bpf_map *map, int flags)
 
 int bpf_get_file_flag(int flags)
 {
+	/* XXX: What about exec? */
 	if ((flags & BPF_F_RDONLY) && (flags & BPF_F_WRONLY))
 		return -EINVAL;
 	if (flags & BPF_F_RDONLY)
@@ -556,6 +557,10 @@ static int map_create(union bpf_attr *attr)
 	if (err)
 		return -EINVAL;
 
+	/*
+	 * XXX: I'm a bit confused.  Why would you ever create a map and
+	 * grant *yourself* less than full permission?
+	 */
 	f_flags = bpf_get_file_flag(attr->map_flags);
 	if (f_flags < 0)
 		return f_flags;
@@ -1411,7 +1416,7 @@ const struct file_operations bpf_prog_fops = {
 	.write		= bpf_dummy_write,
 };
 
-int bpf_prog_new_fd(struct bpf_prog *prog)
+int bpf_prog_new_fd(struct bpf_prog *prog, int flags)
 {
 	int ret;
 
@@ -1420,10 +1425,10 @@ int bpf_prog_new_fd(struct bpf_prog *prog)
 		return ret;
 
 	return anon_inode_getfd("bpf-prog", &bpf_prog_fops, prog,
-				O_RDWR | O_CLOEXEC);
+				flags | O_CLOEXEC);
 }
 
-static struct bpf_prog *____bpf_prog_get(struct fd f)
+static struct bpf_prog *____bpf_prog_get(struct fd f, int mask)
 {
 	if (!f.file)
 		return ERR_PTR(-EBADF);
@@ -1431,6 +1436,10 @@ static struct bpf_prog *____bpf_prog_get(struct fd f)
 		fdput(f);
 		return ERR_PTR(-EINVAL);
 	}
+	if ((f.file->f_mode & mask) != mask) {
+		fdput(f);
+		return ERR_PTR(-EACCES);
+	}
 
 	return f.file->private_data;
 }
@@ -1497,12 +1506,12 @@ bool bpf_prog_get_ok(struct bpf_prog *prog,
 }
 
 static struct bpf_prog *__bpf_prog_get(u32 ufd, enum bpf_prog_type *attach_type,
-				       bool attach_drv)
+				       bool attach_drv, int mask)
 {
 	struct fd f = fdget(ufd);
 	struct bpf_prog *prog;
 
-	prog = ____bpf_prog_get(f);
+	prog = ____bpf_prog_get(f, mask);
 	if (IS_ERR(prog))
 		return prog;
 	if (!bpf_prog_get_ok(prog, attach_type, attach_drv)) {
@@ -1516,15 +1525,15 @@ static struct bpf_prog *__bpf_prog_get(u32 ufd, enum bpf_prog_type *attach_type,
 	return prog;
 }
 
-struct bpf_prog *bpf_prog_get(u32 ufd)
+struct bpf_prog *bpf_prog_get(u32 ufd, int mask)
 {
-	return __bpf_prog_get(ufd, NULL, false);
+	return __bpf_prog_get(ufd, NULL, false, mask);
 }
 
 struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
-				       bool attach_drv)
+				       bool attach_drv, int mask)
 {
-	return __bpf_prog_get(ufd, &type, attach_drv);
+	return __bpf_prog_get(ufd, &type, attach_drv, mask);
 }
 EXPORT_SYMBOL_GPL(bpf_prog_get_type_dev);
 
@@ -1707,7 +1716,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (err)
 		goto free_used_maps;
 
-	err = bpf_prog_new_fd(prog);
+	err = bpf_prog_new_fd(prog, O_RDWR /* | O_MAYEXEC */);
 	if (err < 0) {
 		/* failed to allocate fd.
 		 * bpf_prog_put() is needed because the above
@@ -1808,7 +1817,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	}
 	raw_tp->btp = btp;
 
-	prog = bpf_prog_get(attr->raw_tracepoint.prog_fd);
+	prog = bpf_prog_get(attr->raw_tracepoint.prog_fd, MAY_EXEC);
 	if (IS_ERR(prog)) {
 		err = PTR_ERR(prog);
 		goto out_free_tp;
@@ -1929,7 +1938,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 		return -EINVAL;
 	}
 
-	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
+	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype, MAY_EXEC);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
@@ -2083,7 +2092,11 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
 	    (!attr->test.ctx_size_out && attr->test.ctx_out))
 		return -EINVAL;
 
-	prog = bpf_prog_get(attr->test.prog_fd);
+	/*
+	 * A test run is is a form of query, so require RW.  Using W as a proxy for
+	 * X, since X is awkward due to a lack of O_MAYEXEC.
+	 */
+	prog = bpf_prog_get(attr->test.prog_fd, MAY_READ | MAY_WRITE);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
@@ -2147,7 +2160,11 @@ static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	fd = bpf_prog_new_fd(prog);
+	/*
+	 * We have all permissions.  This is okay, since we also require
+	 * CAP_SYS_ADMIN to do this at all.
+	 */
+	fd = bpf_prog_new_fd(prog, O_RDWR /* | O_MAYEXEC */);
 	if (fd < 0)
 		bpf_prog_put(prog);
 
@@ -2638,6 +2655,11 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 	if (!f.file)
 		return -EBADFD;
 
+	if (!(f.file->f_mode & FMODE_READ)) {
+		err = -EACCES;
+		goto out;
+	}
+
 	if (f.file->f_op == &bpf_prog_fops)
 		err = bpf_prog_get_info_by_fd(f.file->private_data, attr,
 					      uattr);
@@ -2649,6 +2671,7 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 	else
 		err = -EINVAL;
 
+out:
 	fdput(f);
 	return err;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 026a14541a38..f2e3973b28f2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8876,7 +8876,8 @@ static int perf_event_set_bpf_handler(struct perf_event *event, u32 prog_fd)
 	if (event->prog)
 		return -EEXIST;
 
-	prog = bpf_prog_get_type(prog_fd, BPF_PROG_TYPE_PERF_EVENT);
+	/* Should maybe be FMODE_EXEC? */
+	prog = bpf_prog_get_type(prog_fd, BPF_PROG_TYPE_PERF_EVENT, FMODE_WRITE);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
@@ -8942,7 +8943,7 @@ static int perf_event_set_bpf_prog(struct perf_event *event, u32 prog_fd)
 		/* bpf programs can only be attached to u/kprobe or tracepoint */
 		return -EINVAL;
 
-	prog = bpf_prog_get(prog_fd);
+	prog = bpf_prog_get(prog_fd, FMODE_WRITE);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b2610e3..3fcaeae693bb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8093,8 +8093,10 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return -EBUSY;
 		}
 
+		/* XXX: FMODE_EXEC? */
 		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
-					     bpf_op == ops->ndo_bpf);
+					     bpf_op == ops->ndo_bpf,
+					     FMODE_WRITE);
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 4e2a79b2fd77..9282462678fd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1544,7 +1544,8 @@ static struct bpf_prog *__get_bpf(u32 ufd, struct sock *sk)
 	if (sock_flag(sk, SOCK_FILTER_LOCKED))
 		return ERR_PTR(-EPERM);
 
-	return bpf_prog_get_type(ufd, BPF_PROG_TYPE_SOCKET_FILTER);
+	/* FMODE_EXEC? */
+	return bpf_prog_get_type(ufd, BPF_PROG_TYPE_SOCKET_FILTER, FMODE_WRITE);
 }
 
 int sk_attach_bpf(u32 ufd, struct sock *sk)
@@ -1572,9 +1573,10 @@ int sk_reuseport_attach_bpf(u32 ufd, struct sock *sk)
 	if (sock_flag(sk, SOCK_FILTER_LOCKED))
 		return -EPERM;
 
-	prog = bpf_prog_get_type(ufd, BPF_PROG_TYPE_SOCKET_FILTER);
+	prog = bpf_prog_get_type(ufd, BPF_PROG_TYPE_SOCKET_FILTER, FMODE_WRITE);
 	if (IS_ERR(prog) && PTR_ERR(prog) == -EINVAL)
-		prog = bpf_prog_get_type(ufd, BPF_PROG_TYPE_SK_REUSEPORT);
+		prog = bpf_prog_get_type(ufd, BPF_PROG_TYPE_SK_REUSEPORT,
+					 FMODE_WRITE);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
diff --git a/net/netfilter/xt_bpf.c b/net/netfilter/xt_bpf.c
index 13cf3f9b5938..34e5c08ee1f3 100644
--- a/net/netfilter/xt_bpf.c
+++ b/net/netfilter/xt_bpf.c
@@ -44,7 +44,7 @@ static int __bpf_mt_check_fd(int fd, struct bpf_prog **ret)
 {
 	struct bpf_prog *prog;
 
-	prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
+	prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER, MAY_EXEC);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
@@ -57,7 +57,8 @@ static int __bpf_mt_check_path(const char *path, struct bpf_prog **ret)
 	if (strnlen(path, XT_BPF_PATH_MAX) == XT_BPF_PATH_MAX)
 		return -EINVAL;
 
-	*ret = bpf_prog_get_type_path(path, BPF_PROG_TYPE_SOCKET_FILTER);
+	*ret = bpf_prog_get_type_path(path, BPF_PROG_TYPE_SOCKET_FILTER,
+				      MAY_EXEC);
 	return PTR_ERR_OR_ZERO(*ret);
 }
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8d54f3047768..5b8c5e5d94bf 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1563,7 +1563,7 @@ static int fanout_set_data_ebpf(struct packet_sock *po, char __user *data,
 	if (copy_from_user(&fd, data, len))
 		return -EFAULT;
 
-	new = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
+	new = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER, FMODE_WRITE);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
-- 
2.21.0

