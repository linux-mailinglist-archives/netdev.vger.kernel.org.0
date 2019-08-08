Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DED85792
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 03:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389558AbfHHBWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 21:22:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36291 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388123AbfHHBWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 21:22:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so90526992qtc.3
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 18:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=G0AP1NYSO3JYlDV9MUD/9rykw+hGaZ9Kk+YfaQX8yrc=;
        b=SPBV/QH2dfK/LyZS0Bpjhk2a1WiKbGoLQHhoo03ArGjxx7q/R+26LQePfRUWH2p/9+
         VxZJTVCWUzwsCepHX7I5EbJSxsTAqV1gIxW+3lpM50E9xn70BVKmTy8qlp0I66l0PkWI
         kiP7UiBrsoT7es7RZfhUFjfD4WSrcqyeg/BGnbd2n/2jOI8OftvkpxvdCnTzYp9df+40
         vU9Kclw8YPluBteJYuhSmpSBfXH9C2Iv3gdlfakTZI65Rgs+I+wk9YLgVs9UYVGbsv86
         0RFuGuE5HPR9wczVnWMJn3ftPftI2DO0DUBGt0tcPoaWlhFmmzQhLAXvA1gRU0vS4mYd
         nTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=G0AP1NYSO3JYlDV9MUD/9rykw+hGaZ9Kk+YfaQX8yrc=;
        b=iVKCGbC1jXN57y5HdelGLrYQ+fvNFny3C1BwhQh12ObOdZwC8bTCa25LWqqhMOhqGP
         YsVwTJqHhOoVemwLYBbhJUBVqxD+UhSRx+ysLwHfr5tXc7JmwKVPUa7tQ8TsiPe+mM4h
         9hPS+TVVyIARJCLW+T9f8Ncytqx4X6ID8jFV/dHLNexJWi9iTGFmLt0ezFGAZSGf89kN
         4NZFgjP0FpxA7LqyXzAlYOqP6I5mStWwCSBa4VstsvvAHNSW4Wr2WVY8lmLlQzMwIg0+
         evB4RgAmp9stcnZ4soFDKNsHajZsCDpDrhU6FQ/7sKybaGgzjeajoP5h8L/AW2cgJmiR
         jdtg==
X-Gm-Message-State: APjAAAUBV4+ndRiioJYGFTWmUmJiOydLbteBmyYuih7AJ6p5jCcpbu8p
        0k7C/i1WR8WTwlA2qEBttzZgfb5tUa7ZQQ==
X-Google-Smtp-Source: APXvYqxOYUd+MzdSwKFuDfhlSKvu0Oz1jmnSsKxv96/UOJXrcaG2PP6zZuTWBMgKPkScu9gFhlC5eg==
X-Received: by 2002:ac8:22a3:: with SMTP id f32mr10998880qta.152.1565227367668;
        Wed, 07 Aug 2019 18:22:47 -0700 (PDT)
Received: from dev00 ([190.162.109.53])
        by smtp.gmail.com with ESMTPSA id m5sm37822405qkb.117.2019.08.07.18.22.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Aug 2019 18:22:46 -0700 (PDT)
Date:   Wed, 7 Aug 2019 21:22:42 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        quentin.monnet@netronome.com, cneirabustos@gmail.com
Subject: [PATCH v5 bpf-next] BPF: helpers: New helper to obtain namespace
 data from current task
Message-ID: <20190808012240.htbgpv2mhktvig5h@dev00>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code has been modified to avoid syscalls that could sleep.
Please let me know if any other modification is needed.

From be0384c0fa209a78c1567936e8db4e35b9a7c0f8 Mon Sep 17 00:00:00 2001
From: Carlos <cneirabustos@gmail.com>
Date: Wed, 7 Aug 2019 20:04:30 -0400
Subject: [PATCH] [PATCH v5 bpf-next] BPF: New helper to obtain namespace data 
 from current task

This helper obtains the active namespace from current and returns pid, tgid,
device and namespace id as seen from that namespace, allowing to instrument
a process inside a container.
Device is read from /proc/self/ns/pid, as in the future it's possible that
different pid_ns files may belong to different devices, according
to the discussion between Eric Biederman and Yonghong in 2017 linux plumbers
conference.
Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
scripts but this helper returns the pid as seen by the root namespace which is
fine when a bcc script is not executed inside a container.
When the process of interest is inside a container, pid filtering will not work
if bpf_get_current_pid_tgid() is used. This helper addresses this limitation
returning the pid as it's seen by the current namespace where the script is
executing.

This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
used to do pid filtering even inside a container.

For example a bcc script using bpf_get_current_pid_tgid() (tools/funccount.py):

        u32 pid = bpf_get_current_pid_tgid() >> 32;
        if (pid != <pid_arg_passed_in>)
                return 0;
Could be modified to use bpf_get_current_pidns_info() as follows:

        struct bpf_pidns pidns;
        bpf_get_current_pidns_info(&pidns, sizeof(struct bpf_pidns));
        u32 pid = pidns.tgid;
        u32 nsid = pidns.nsid;
        if ((pid != <pid_arg_passed_in>) && (nsid != <nsid_arg_passed_in>))
                return 0;

To find out the name PID namespace id of a process, you could use this command:

$ ps -h -o pidns -p <pid_of_interest>

Or this other command:

$ ls -Li /proc/<pid_of_interest>/ns/pid

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 fs/namei.c                                         |   2 +-
 include/linux/bpf.h                                |   1 +
 include/linux/namei.h                              |   4 +
 include/uapi/linux/bpf.h                           |  29 ++++-
 kernel/bpf/core.c                                  |   1 +
 kernel/bpf/helpers.c                               |  78 ++++++++++++
 kernel/trace/bpf_trace.c                           |   2 +
 samples/bpf/Makefile                               |   3 +
 samples/bpf/trace_ns_info_user.c                   |  35 ++++++
 samples/bpf/trace_ns_info_user_kern.c              |  44 +++++++
 tools/include/uapi/linux/bpf.h                     |  29 ++++-
 tools/testing/selftests/bpf/Makefile               |   2 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |   3 +
 .../testing/selftests/bpf/progs/test_pidns_kern.c  |  51 ++++++++
 tools/testing/selftests/bpf/test_pidns.c           | 138 +++++++++++++++++++++
 15 files changed, 418 insertions(+), 4 deletions(-)
 create mode 100644 samples/bpf/trace_ns_info_user.c
 create mode 100644 samples/bpf/trace_ns_info_user_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_pidns.c

diff --git a/fs/namei.c b/fs/namei.c
index 209c51a5226c..d1eca36972d2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -19,7 +19,6 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/pagemap.h>
 #include <linux/fsnotify.h>
@@ -2355,6 +2354,7 @@ int filename_lookup(int dfd, struct filename *name, unsigned flags,
 	putname(name);
 	return retval;
 }
+EXPORT_SYMBOL(filename_lookup);
 
 /* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
 static int path_parentat(struct nameidata *nd, unsigned flags,
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f9a506147c8a..e4adf5e05afd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1050,6 +1050,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_get_current_pidns_info_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 9138b4471dbf..2c24e8c71d46 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -6,6 +6,7 @@
 #include <linux/path.h>
 #include <linux/fcntl.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 
 enum { MAX_NESTED_LINKS = 8 };
 
@@ -97,6 +98,9 @@ extern void unlock_rename(struct dentry *, struct dentry *);
 
 extern void nd_jump_link(struct path *path);
 
+extern int filename_lookup(int dfd, struct filename *name, unsigned int flags,
+		    struct path *path, struct path *root);
+
 static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
 {
 	((char *) name)[min(len, maxlen)] = '\0';
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4393bd4b2419..6f601f7106e2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2741,6 +2741,26 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_get_current_pidns_info(struct bpf_pidns_info *pidns, u32 size_of_pidns)
+ *	Description
+ *		Copies into *pidns* pid, namespace id and tgid as seen by the
+ *		current namespace and also device from /proc/self/ns/pid.
+ *		*size_of_pidns* must be the size of *pidns*
+ *
+ *		This helper is used when pid filtering is needed inside a
+ *		container as bpf_get_current_tgid() helper returns always the
+ *		pid id as seen by the root namespace.
+ *	Return
+ *		0 on success
+ *
+ *		**-EINVAL**  if unable to get ns, pid or tgid of current task.
+ *		Or if size_of_pidns is not valid.
+ *
+ *		**-ENOMEM**  if allocation fails.
+ *
+ *		If unable to get the inode from /proc/self/ns/pid an error code
+ *		will be returned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2853,7 +2873,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(get_current_pidns_info),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3604,4 +3625,10 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 dev;
+	__u32 nsid;
+	__u32 tgid;
+	__u32 pid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8191a7db2777..3159f2a0188c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2038,6 +2038,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_get_current_pidns_info __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..571f24077db2 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,12 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/pid_namespace.h>
+#include <linux/major.h>
+#include <linux/stat.h>
+#include <linux/namei.h>
+#include <linux/version.h>
+
 
 #include "../../lib/kstrtox.h"
 
@@ -312,6 +318,78 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 	preempt_enable();
 }
 
+BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *, pidns_info, u32,
+	 size)
+{
+	const char *name = "/proc/self/ns/pid";
+	struct pid_namespace *pidns = NULL;
+	struct filename *tmp = NULL;
+	int len = strlen(name) + 1;
+	struct inode *inode;
+	struct path kp;
+	pid_t tgid = 0;
+	pid_t pid = 0;
+	int ret;
+
+	if (unlikely(size != sizeof(struct bpf_pidns_info)))
+		return -EINVAL;
+
+	pidns = task_active_pid_ns(current);
+
+	if (unlikely(!pidns))
+		goto clear;
+
+	pidns_info->nsid =  pidns->ns.inum;
+	pid = task_pid_nr_ns(current, pidns);
+
+	if (unlikely(!pid))
+		goto clear;
+
+	tgid = task_tgid_nr_ns(current, pidns);
+
+	if (unlikely(!tgid))
+		goto clear;
+
+	pidns_info->tgid = (u32) tgid;
+	pidns_info->pid = (u32) pid;
+
+	tmp = kmem_cache_alloc(names_cachep, GFP_ATOMIC);
+	if (unlikely(!tmp)) {
+		memset((void *)pidns_info, 0, (size_t) size);
+		return -ENOMEM;
+	}
+
+	memcpy((char *)tmp->name, name, len);
+	tmp->uptr = NULL;
+	tmp->aname = NULL;
+	tmp->refcnt = 1;
+
+	ret = filename_lookup(AT_FDCWD, tmp, 0, &kp, NULL);
+
+	if (ret) {
+		memset((void *)pidns_info, 0, (size_t) size);
+		return ret;
+	}
+
+	inode = d_backing_inode(kp.dentry);
+	pidns_info->dev = inode->i_sb->s_dev;
+
+	return 0;
+
+clear:
+	memset((void *)pidns_info, 0, (size_t) size);
+
+	return -EINVAL;
+}
+
+const struct bpf_func_proto bpf_get_current_pidns_info_proto = {
+	.func	= bpf_get_current_pidns_info,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+};
+
 #ifdef CONFIG_CGROUPS
 BPF_CALL_0(bpf_get_current_cgroup_id)
 {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d14576..5e1dc22765a5 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -709,6 +709,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_get_current_pidns_info:
+		return &bpf_get_current_pidns_info_proto;
 	default:
 		return NULL;
 	}
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1d9be26b4edd..238453ff27d2 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ hostprogs-y += task_fd_query
 hostprogs-y += xdp_sample_pkts
 hostprogs-y += ibumad
 hostprogs-y += hbm
+hostprogs-y += trace_ns_info
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -109,6 +110,7 @@ task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+trace_ns_info-objs := bpf_load.o trace_ns_info_user.o
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
@@ -170,6 +172,7 @@ always += xdp_sample_pkts_kern.o
 always += ibumad_kern.o
 always += hbm_out_kern.o
 always += hbm_edt_kern.o
+always += trace_ns_info_user_kern.o
 
 KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
diff --git a/samples/bpf/trace_ns_info_user.c b/samples/bpf/trace_ns_info_user.c
new file mode 100644
index 000000000000..e06d08db6f30
--- /dev/null
+++ b/samples/bpf/trace_ns_info_user.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <linux/bpf.h>
+#include <unistd.h>
+#include "bpf/libbpf.h"
+#include "bpf_load.h"
+
+/* This code was taken verbatim from tracex1_user.c, it's used
+ * to exercize bpf_get_current_pidns_info() helper call.
+ */
+int main(int ac, char **argv)
+{
+	FILE *f;
+	char filename[256];
+
+	snprintf(filename, sizeof(filename), "%s_user_kern.o", argv[0]);
+	printf("loading %s\n", filename);
+
+	if (load_bpf_file(filename)) {
+		printf("%s", bpf_log_buf);
+		return 1;
+	}
+
+	f = popen("taskset 1 ping  localhost", "r");
+	(void) f;
+	read_trace_pipe();
+	return 0;
+}
diff --git a/samples/bpf/trace_ns_info_user_kern.c b/samples/bpf/trace_ns_info_user_kern.c
new file mode 100644
index 000000000000..96675e02b707
--- /dev/null
+++ b/samples/bpf/trace_ns_info_user_kern.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/version.h>
+#include <uapi/linux/bpf.h>
+#include "bpf_helpers.h"
+
+typedef __u64 u64;
+typedef __u32 u32;
+
+
+/* kprobe is NOT a stable ABI
+ * kernel functions can be removed, renamed or completely change semantics.
+ * Number of arguments and their positions can change, etc.
+ * In such case this bpf+kprobe example will no longer be meaningful
+ */
+
+/* This will call bpf_get_current_pidns_info() to display pid and ns values
+ * as seen by the current namespace, on the far left you will see the pid as
+ * seen as by the root namespace.
+ */
+
+SEC("kprobe/__netif_receive_skb_core")
+int bpf_prog1(struct pt_regs *ctx)
+{
+	char fmt[] = "nsid:%u, dev: %u,  pid:%u\n";
+	struct bpf_pidns_info nsinfo;
+	int ok = 0;
+
+	ok = bpf_get_current_pidns_info(&nsinfo, sizeof(nsinfo));
+	if (ok == 0)
+		bpf_trace_printk(fmt, sizeof(fmt), (u32)nsinfo.nsid,
+				 (u32) nsinfo.dev, (u32)nsinfo.pid);
+
+	return 0;
+}
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = LINUX_VERSION_CODE;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4393bd4b2419..6f601f7106e2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2741,6 +2741,26 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_get_current_pidns_info(struct bpf_pidns_info *pidns, u32 size_of_pidns)
+ *	Description
+ *		Copies into *pidns* pid, namespace id and tgid as seen by the
+ *		current namespace and also device from /proc/self/ns/pid.
+ *		*size_of_pidns* must be the size of *pidns*
+ *
+ *		This helper is used when pid filtering is needed inside a
+ *		container as bpf_get_current_tgid() helper returns always the
+ *		pid id as seen by the root namespace.
+ *	Return
+ *		0 on success
+ *
+ *		**-EINVAL**  if unable to get ns, pid or tgid of current task.
+ *		Or if size_of_pidns is not valid.
+ *
+ *		**-ENOMEM**  if allocation fails.
+ *
+ *		If unable to get the inode from /proc/self/ns/pid an error code
+ *		will be returned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2853,7 +2873,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(get_current_pidns_info),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3604,4 +3625,10 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 dev;
+	__u32 nsid;
+	__u32 tgid;
+	__u32 pid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3bd0f4a0336a..1f97b571b581 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
-	test_sockopt_multi test_tcp_rtt
+	test_sockopt_multi test_tcp_rtt test_pidns
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 120aa86c58d3..c96795a9d983 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -231,6 +231,9 @@ static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
 static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
 					  int ip_len, void *tcp, int tcp_len) =
 	(void *) BPF_FUNC_tcp_gen_syncookie;
+static int (*bpf_get_current_pidns_info)(struct bpf_pidns_info *buf,
+					 unsigned int buf_size) =
+	(void *) BPF_FUNC_get_current_pidns_info;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/progs/test_pidns_kern.c b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
new file mode 100644
index 000000000000..e1d2facfa762
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <linux/bpf.h>
+#include <errno.h>
+#include "bpf_helpers.h"
+
+struct bpf_map_def SEC("maps") nsidmap = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 1,
+};
+
+struct bpf_map_def SEC("maps") pidmap = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 1,
+};
+
+SEC("tracepoint/syscalls/sys_enter_nanosleep")
+int trace(void *ctx)
+{
+	struct bpf_pidns_info nsinfo;
+	__u32 key = 0, *expected_pid, *val;
+	char fmt[] = "ERROR nspid:%d\n";
+
+	if (bpf_get_current_pidns_info(&nsinfo, sizeof(nsinfo)))
+		return -EINVAL;
+
+	expected_pid = bpf_map_lookup_elem(&pidmap, &key);
+
+
+	if (!expected_pid || *expected_pid != nsinfo.pid)
+		return 0;
+
+	val = bpf_map_lookup_elem(&nsidmap, &key);
+	if (val)
+		*val = nsinfo.nsid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/test_pidns.c b/tools/testing/selftests/bpf/test_pidns.c
new file mode 100644
index 000000000000..a7254055f294
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_pidns.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <linux/perf_event.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "cgroup_helpers.h"
+#include "bpf_rlimit.h"
+
+#define CHECK(condition, tag, format...) ({		\
+	int __ret = !!(condition);			\
+	if (__ret) {					\
+		printf("%s:FAIL:%s ", __func__, tag);	\
+		printf(format);				\
+	} else {					\
+		printf("%s:PASS:%s\n", __func__, tag);	\
+	}						\
+	__ret;						\
+})
+
+static int bpf_find_map(const char *test, struct bpf_object *obj,
+			const char *name)
+{
+	struct bpf_map *map;
+
+	map = bpf_object__find_map_by_name(obj, name);
+	if (!map)
+		return -1;
+	return bpf_map__fd(map);
+}
+
+
+int main(int argc, char **argv)
+{
+	const char *probe_name = "syscalls/sys_enter_nanosleep";
+	const char *file = "test_pidns_kern.o";
+	int err, bytes, efd, prog_fd, pmu_fd;
+	int pidmap_fd, nsidmap_fd;
+	struct perf_event_attr attr = {};
+	struct bpf_object *obj;
+	__u32 knsid = 0;
+	__u32 key = 0, pid;
+	int exit_code = 1;
+	struct stat st;
+	char buf[256];
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err, "bpf_prog_load", "err %d errno %d\n", err, errno))
+		goto cleanup_cgroup_env;
+
+	nsidmap_fd = bpf_find_map(__func__, obj, "nsidmap");
+	if (CHECK(nsidmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  nsidmap_fd, errno))
+		goto close_prog;
+
+	pidmap_fd = bpf_find_map(__func__, obj, "pidmap");
+	if (CHECK(pidmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  pidmap_fd, errno))
+		goto close_prog;
+
+	pid = getpid();
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+
+	snprintf(buf, sizeof(buf),
+		 "/sys/kernel/debug/tracing/events/%s/id", probe_name);
+	efd = open(buf, O_RDONLY, 0);
+	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
+		goto close_prog;
+	bytes = read(efd, buf, sizeof(buf));
+	close(efd);
+	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "read",
+		  "bytes %d errno %d\n", bytes, errno))
+		goto close_prog;
+
+	attr.config = strtol(buf, NULL, 0);
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+
+	pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
+	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n", pmu_fd,
+		  errno))
+		goto close_prog;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
+	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
+	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	/* trigger some syscalls */
+	sleep(1);
+
+	err = bpf_map_lookup_elem(nsidmap_fd, &key, &knsid);
+	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
+		goto close_pmu;
+
+	if (stat("/proc/self/ns/pid", &st))
+		goto close_pmu;
+
+	if (CHECK(knsid != (__u32) st.st_ino, "compare_namespace_id",
+		  "kern knsid %u user unsid %u\n", knsid, (__u32) st.st_ino))
+		goto close_pmu;
+
+	exit_code = 0;
+	printf("%s:PASS\n", argv[0]);
+
+close_pmu:
+	close(pmu_fd);
+close_prog:
+	bpf_object__close(obj);
+cleanup_cgroup_env:
+	return exit_code;
+}
-- 
2.11.0

