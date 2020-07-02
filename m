Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA5A212D90
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGBUDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgGBUDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:03:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B53C08C5DD;
        Thu,  2 Jul 2020 13:03:38 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id l6so9793309pjq.1;
        Thu, 02 Jul 2020 13:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tk135JHzV7qH/T5n3/WTwMeX7W2AnYVAmGL6vTYVe2c=;
        b=YYjR8z3ZI2nD+I7Peh4OacxP3RHXXguyXG0s15YzJGd+O4m2TXGAVuJDeO9C6/YM5i
         xcSVV/e+9VddUGNf4g9FF8JCsVmTYBdYYOaaokgxQ1tSAFay/PatSyn5il0qzxSdVXf9
         A9GLcdRhTNLULBZc6Xu4tgr6TnOAEyouVX9UxKc0BTohLwfRM2GUsl9zPBy2/2FkMVkl
         OAphaa59SJLvSc7hQtuAILksjuPSfba9ItJoANrN6gUL1xVS4MhTuo9eH4P1TrGwe/vL
         837NEE77kITDqj/XxwdW4KGnFApdC95ut4IYtf+n86Ui2UhfMkqSvOfrBgqpGCix6cQ1
         +SeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tk135JHzV7qH/T5n3/WTwMeX7W2AnYVAmGL6vTYVe2c=;
        b=bCUg10yZN6fZCQ5pKX5OIFWOKwWBZ1M3XO+OlQDluQLN2sPKe+ZwmG89toMHH9WZ2e
         PbGYamztSgAV8VyNgq8I5H2FDdBFMbo12fpnurBbv7UvNhu9iLbbmjamN41WxDcPWpY6
         4JeOIpZt6UstbSynkaZZjERYMSKrbfLSCb00oG/L9AZt/hodQzLWnoW4kdeKkCkW/iC0
         ZgS/oTt4cmTTC5INWHwxl36oQYH+1nqIipZrED+6nndWjxVhjiq4NMwSg2qlES878TBU
         8llx39qP0ppbynO9vR4RKTyFukLeGMNSd5mnLN8FM9OFe/Yu3LoMsJvhrvEp/HlN26jb
         JRiw==
X-Gm-Message-State: AOAM530uc2kigtUgwohZ/hCkLmkdeFrjrsYuz1OEfOOIOemHIij/8xa/
        NNkV/iWSSYtyGJAhTnN89uM=
X-Google-Smtp-Source: ABdhPJwGrHI453Ukc2qSDITPBmFnTGgYg6uozwJmDGie2aD0ZICAMC2z84ZtWvvXEwN0/QXhRz5D1Q==
X-Received: by 2002:a17:902:b706:: with SMTP id d6mr28557059pls.304.1593720218285;
        Thu, 02 Jul 2020 13:03:38 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 83sm9663466pfu.60.2020.07.02.13.03.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2020 13:03:37 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, daniel@iogearbox.net, ebiederm@xmission.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 3/3] bpf: Add kernel module with user mode driver that populates bpffs.
Date:   Thu,  2 Jul 2020 13:03:29 -0700
Message-Id: <20200702200329.83224-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add kernel module with user mode driver that populates bpffs with
BPF iterators.

$ mount bpffs /sys/fs/bpf/ -t bpf
$ ls -la /sys/fs/bpf/
total 4
drwxrwxrwt  2 root root    0 Jul  2 00:27 .
drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
-rw-------  1 root root    0 Jul  2 00:27 maps
-rw-------  1 root root    0 Jul  2 00:27 progs

The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
maps, load two BPF programs, attach them to BPF iterators, and finally send two
bpf_link IDs back to the kernel.
The kernel will pin two bpf_links into newly mounted bpffs instance under
names "progs" and "maps". These two files become human readable.

$ cat /sys/fs/bpf/progs
  id name            pages attached
  11    dump_bpf_map     1 bpf_iter_bpf_map
  12   dump_bpf_prog     1 bpf_iter_bpf_prog
  27 test_pkt_access     1
  32       test_main     1 test_pkt_access test_pkt_access
  33   test_subprog1     1 test_pkt_access_subprog1 test_pkt_access
  34   test_subprog2     1 test_pkt_access_subprog2 test_pkt_access
  35   test_subprog3     1 test_pkt_access_subprog3 test_pkt_access
  36 new_get_skb_len     1 get_skb_len test_pkt_access
  37 new_get_skb_ifi     1 get_skb_ifindex test_pkt_access
  38 new_get_constan     1 get_constant test_pkt_access

The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
all BPF programs currently loaded in the system. This information is unstable
and will change from kernel to kernel.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 init/Kconfig                                  |  2 +
 kernel/bpf/Makefile                           |  1 +
 kernel/bpf/inode.c                            | 75 ++++++++++++++++
 kernel/bpf/preload/Kconfig                    | 15 ++++
 kernel/bpf/preload/Makefile                   | 21 +++++
 kernel/bpf/preload/bpf_preload.h              | 15 ++++
 kernel/bpf/preload/bpf_preload_kern.c         | 87 +++++++++++++++++++
 kernel/bpf/preload/bpf_preload_umd_blob.S     |  7 ++
 .../preload/iterators/bpf_preload_common.h    |  8 ++
 kernel/bpf/preload/iterators/iterators.c      | 81 +++++++++++++++++
 10 files changed, 312 insertions(+)
 create mode 100644 kernel/bpf/preload/Kconfig
 create mode 100644 kernel/bpf/preload/Makefile
 create mode 100644 kernel/bpf/preload/bpf_preload.h
 create mode 100644 kernel/bpf/preload/bpf_preload_kern.c
 create mode 100644 kernel/bpf/preload/bpf_preload_umd_blob.S
 create mode 100644 kernel/bpf/preload/iterators/bpf_preload_common.h
 create mode 100644 kernel/bpf/preload/iterators/iterators.c

diff --git a/init/Kconfig b/init/Kconfig
index a46aa8f3174d..278975a5daf2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2313,3 +2313,5 @@ config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 # <asm/syscall_wrapper.h>.
 config ARCH_HAS_SYSCALL_WRAPPER
 	def_bool n
+
+source "kernel/bpf/preload/Kconfig"
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index e6eb9c0402da..19e137aae40e 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -29,3 +29,4 @@ ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
 obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
+obj-$(CONFIG_BPF_PRELOAD) += preload/
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index fb878ba3f22f..8d33edd5c69c 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -20,6 +20,7 @@
 #include <linux/filter.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include "preload/bpf_preload.h"
 
 enum bpf_type {
 	BPF_TYPE_UNSPEC	= 0,
@@ -409,6 +410,26 @@ static const struct inode_operations bpf_dir_iops = {
 	.unlink		= simple_unlink,
 };
 
+static int bpf_link_pin_kernel(struct dentry *parent,
+			       const char *name, struct bpf_link *link)
+{
+	umode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
+	struct dentry *dentry;
+	int ret;
+
+	inode_lock(parent->d_inode);
+	dentry = lookup_one_len(name, parent, strlen(name));
+	if (IS_ERR(dentry)) {
+		inode_unlock(parent->d_inode);
+		return PTR_ERR(dentry);
+	}
+	ret = bpf_mkobj_ops(dentry, mode, link, &bpf_link_iops,
+			    &bpf_iter_fops);
+	dput(dentry);
+	inode_unlock(parent->d_inode);
+	return ret;
+}
+
 static int bpf_obj_do_pin(const char __user *pathname, void *raw,
 			  enum bpf_type type)
 {
@@ -638,6 +659,57 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	return 0;
 }
 
+struct bpf_preload_ops bpf_preload_ops = { .info.driver_name = "bpf_preload" };
+EXPORT_SYMBOL_GPL(bpf_preload_ops);
+
+static int populate_bpffs(struct dentry *parent)
+{
+	struct bpf_link *links[BPF_PRELOAD_LINKS] = {};
+	u32 link_id[BPF_PRELOAD_LINKS] = {};
+	int err = 0, i;
+
+	mutex_lock(&bpf_preload_ops.lock);
+	if (!bpf_preload_ops.do_preload) {
+		mutex_unlock(&bpf_preload_ops.lock);
+		request_module("bpf_preload");
+		mutex_lock(&bpf_preload_ops.lock);
+
+		if (!bpf_preload_ops.do_preload) {
+			pr_err("bpf_preload module is missing.\n"
+			       "bpffs will not have iterators.\n");
+			goto out;
+		}
+	}
+
+	if (!bpf_preload_ops.info.tgid) {
+		err = bpf_preload_ops.do_preload(link_id);
+		if (err)
+			goto out;
+		for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
+			links[i] = bpf_link_by_id(link_id[i]);
+			if (IS_ERR(links[i])) {
+				err = PTR_ERR(links[i]);
+				goto out;
+			}
+		}
+		err = bpf_link_pin_kernel(parent, "maps", links[0]);
+		if (err)
+			goto out;
+		err = bpf_link_pin_kernel(parent, "progs", links[1]);
+		if (err)
+			goto out;
+		err = bpf_preload_ops.do_finish();
+		if (err)
+			goto out;
+	}
+out:
+	mutex_unlock(&bpf_preload_ops.lock);
+	for (i = 0; i < BPF_PRELOAD_LINKS && err; i++)
+		if (!IS_ERR_OR_NULL(links[i]))
+			bpf_link_put(links[i]);
+	return err;
+}
+
 static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	static const struct tree_descr bpf_rfiles[] = { { "" } };
@@ -656,6 +728,7 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 	inode->i_mode &= ~S_IALLUGO;
 	inode->i_mode |= S_ISVTX | opts->mode;
 
+	populate_bpffs(sb->s_root);
 	return 0;
 }
 
@@ -705,6 +778,8 @@ static int __init bpf_init(void)
 {
 	int ret;
 
+	mutex_init(&bpf_preload_ops.lock);
+
 	ret = sysfs_create_mount_point(fs_kobj, "bpf");
 	if (ret)
 		return ret;
diff --git a/kernel/bpf/preload/Kconfig b/kernel/bpf/preload/Kconfig
new file mode 100644
index 000000000000..b737ce4c2bab
--- /dev/null
+++ b/kernel/bpf/preload/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menuconfig BPF_PRELOAD
+	bool "Load kernel specific BPF programs at kernel boot time (BPF_PRELOAD)"
+	depends on BPF
+	help
+	  tbd
+
+if BPF_PRELOAD
+config BPF_PRELOAD_UMD
+	tristate "bpf_preload kernel module with user mode driver"
+	depends on CC_CAN_LINK_STATIC
+	default m
+	help
+	  This builds bpf_preload kernel module with embedded user mode driver
+endif
diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
new file mode 100644
index 000000000000..191d82209842
--- /dev/null
+++ b/kernel/bpf/preload/Makefile
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0
+
+LIBBPF := $(srctree)/../../tools/lib/bpf
+userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi -I $(LIBBPF) \
+	-I $(srctree)/tools/lib/ \
+	-I $(srctree)/kernel/bpf/preload/iterators/ -Wno-int-conversion \
+	-DCOMPAT_NEED_REALLOCARRAY
+
+userprogs := bpf_preload_umd
+
+LIBBPF_O := $(LIBBPF)/bpf.o $(LIBBPF)/libbpf.o $(LIBBPF)/btf.o $(LIBBPF)/libbpf_errno.o \
+	$(LIBBPF)/str_error.o $(LIBBPF)/hashmap.o $(LIBBPF)/libbpf_probes.o
+
+bpf_preload_umd-objs := iterators/iterators.o $(LIBBPF_O)
+
+userldflags += -lelf -lz
+
+$(obj)/bpf_preload_umd_blob.o: $(obj)/bpf_preload_umd
+
+obj-$(CONFIG_BPF_PRELOAD_UMD) += bpf_preload.o
+bpf_preload-objs += bpf_preload_kern.o bpf_preload_umd_blob.o
diff --git a/kernel/bpf/preload/bpf_preload.h b/kernel/bpf/preload/bpf_preload.h
new file mode 100644
index 000000000000..0d852574c02a
--- /dev/null
+++ b/kernel/bpf/preload/bpf_preload.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_PRELOAD_H
+#define _BPF_PRELOAD_H
+
+#include <linux/usermode_driver.h>
+
+struct bpf_preload_ops {
+        struct umd_info info;
+        struct mutex lock;
+	int (*do_preload)(u32 *);
+	int (*do_finish)(void);
+};
+extern struct bpf_preload_ops bpf_preload_ops;
+#define BPF_PRELOAD_LINKS 2
+#endif
diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
new file mode 100644
index 000000000000..bfcd1fb3891c
--- /dev/null
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pid.h>
+#include <linux/fs.h>
+#include <linux/sched/signal.h>
+#include "bpf_preload.h"
+#include "iterators/bpf_preload_common.h"
+
+extern char bpf_preload_umd_start;
+extern char bpf_preload_umd_end;
+
+static int do_preload(u32 *link_id)
+{
+	int magic = BPF_PRELOAD_START;
+	struct pid *tgid;
+	int id, i, err;
+	loff_t pos;
+	ssize_t n;
+
+	err = fork_usermode_driver(&bpf_preload_ops.info);
+	if (err)
+		return err;
+	tgid = bpf_preload_ops.info.tgid;
+
+	/* send the start magic to let UMD proceed with loading BPF progs */
+	n = __kernel_write(bpf_preload_ops.info.pipe_to_umh,
+			   &magic, sizeof(magic), &pos);
+	if (n != sizeof(magic))
+		return -EPIPE;
+
+	/* receive bpf_link IDs from UMD */
+	pos = 0;
+	for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
+		n = kernel_read(bpf_preload_ops.info.pipe_from_umh,
+				&id, sizeof(id), &pos);
+		if (n != sizeof(id))
+			return -EPIPE;
+		link_id[i] = id;
+	}
+	return 0;
+}
+
+static int do_finish(void)
+{
+	int magic = BPF_PRELOAD_END;
+	struct pid *tgid;
+	loff_t pos;
+	ssize_t n;
+
+	/* send the last magic to UMD. It will do a normal exit. */
+	n = __kernel_write(bpf_preload_ops.info.pipe_to_umh,
+			   &magic, sizeof(magic), &pos);
+	if (n != sizeof(magic))
+		return -EPIPE;
+	tgid = bpf_preload_ops.info.tgid;
+	wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
+	bpf_preload_ops.info.tgid = NULL;
+	return 0;
+}
+
+static int __init load_umd(void)
+{
+	int err;
+
+	err = umd_load_blob(&bpf_preload_ops.info, &bpf_preload_umd_start,
+			    &bpf_preload_umd_end - &bpf_preload_umd_start);
+	if (err)
+		return err;
+	bpf_preload_ops.do_preload = do_preload;
+	bpf_preload_ops.do_finish = do_finish;
+	return err;
+}
+
+static void __exit fini_umd(void)
+{
+	bpf_preload_ops.do_preload = NULL;
+	bpf_preload_ops.do_finish = NULL;
+	/* kill UMD in case it's still there due to earlier error */
+	kill_pid(bpf_preload_ops.info.tgid, SIGKILL, 1);
+	bpf_preload_ops.info.tgid = NULL;
+	umd_unload_blob(&bpf_preload_ops.info);
+}
+late_initcall(load_umd);
+module_exit(fini_umd);
+MODULE_LICENSE("GPL");
diff --git a/kernel/bpf/preload/bpf_preload_umd_blob.S b/kernel/bpf/preload/bpf_preload_umd_blob.S
new file mode 100644
index 000000000000..d0fe58c0734a
--- /dev/null
+++ b/kernel/bpf/preload/bpf_preload_umd_blob.S
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+	.section .init.rodata, "a"
+	.global bpf_preload_umd_start
+bpf_preload_umd_start:
+	.incbin "bpf_preload_umd"
+	.global bpf_preload_umd_end
+bpf_preload_umd_end:
diff --git a/kernel/bpf/preload/iterators/bpf_preload_common.h b/kernel/bpf/preload/iterators/bpf_preload_common.h
new file mode 100644
index 000000000000..f2e77711cd95
--- /dev/null
+++ b/kernel/bpf/preload/iterators/bpf_preload_common.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_PRELOAD_COMMON_H
+#define _BPF_PRELOAD_COMMON_H
+
+#define BPF_PRELOAD_START 0x5555
+#define BPF_PRELOAD_END 0xAAAA
+
+#endif
diff --git a/kernel/bpf/preload/iterators/iterators.c b/kernel/bpf/preload/iterators/iterators.c
new file mode 100644
index 000000000000..74f23580b25f
--- /dev/null
+++ b/kernel/bpf/preload/iterators/iterators.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <argp.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+#include <sys/mount.h>
+#include "iterators.skel.h"
+#include "bpf_preload_common.h"
+
+int to_kernel = -1;
+int from_kernel = 0;
+
+static int send_id_to_kernel(struct bpf_link *link)
+{
+	struct bpf_link_info info = {};
+	__u32 info_len = sizeof(info);
+	int err;
+
+	err = bpf_obj_get_info_by_fd(bpf_link__fd(link), &info, &info_len);
+	if (err)
+		return err;
+	if (write(to_kernel, &info.id, sizeof(info.id)) != sizeof(info.id))
+		return -EPIPE;
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct iterators_bpf *skel;
+	int err, magic;
+	int debug_fd;
+
+	debug_fd = open("/dev/console", O_WRONLY | O_NOCTTY | O_CLOEXEC);
+	if (debug_fd < 0)
+		return -1;
+	to_kernel = dup(1);
+	close(1);
+	dup(debug_fd);
+	/* now stdin and stderr point to /dev/console */
+
+	read(from_kernel, &magic, sizeof(magic));
+	if (magic != BPF_PRELOAD_START) {
+		printf("bad start magic %d\n", magic);
+		return -1;
+	}
+
+	/* libbpf opens BPF object and loads it into the kernel */
+	skel = iterators_bpf__open_and_load();
+	if (!skel)
+		return -1;
+
+	err = iterators_bpf__attach(skel);
+	if (err)
+		goto cleanup;
+
+	/* send two bpf_link IDs to the kernel */
+	err = send_id_to_kernel(skel->links.dump_bpf_map);
+	if (err)
+		goto cleanup;
+	err = send_id_to_kernel(skel->links.dump_bpf_prog);
+	if (err)
+		goto cleanup;
+
+	/* The kernel will proceed with pinnging the links in bpffs.
+	 * UMD will wait on read from pipe.
+	 */
+	read(from_kernel, &magic, sizeof(magic));
+	if (magic != BPF_PRELOAD_END) {
+		printf("bad final magic %d\n", magic);
+		err = -EINVAL;
+	}
+cleanup:
+	iterators_bpf__destroy(skel);
+
+	return err != 0;
+}
-- 
2.23.0

