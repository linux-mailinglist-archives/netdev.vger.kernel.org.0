Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30910249417
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHSE2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgHSE2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:28:07 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC94C061342;
        Tue, 18 Aug 2020 21:28:07 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ds1so198207pjb.1;
        Tue, 18 Aug 2020 21:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KI8OZy1Y/mjSCO7OgRxbouN2H002E6+7JQ8LD6ZqKkw=;
        b=Yx3u86uULOar86dNQHR+O995odYY90AHExKho+xtvYlRjzjuxlPAIAM6ktc47BPMMg
         PY76XHmN3YyfvdfCPCcOAxiA9t7Il+UvSIiqEj6mBetJHs4K1vir+2qrCdEMoBXLDJhD
         OR6HCnHzWZ3i5rs4xjTAbbWdxwR2aCqTOG43Vvj4+c9aJgIk8okPc61X5f7RH4iAEYK4
         1CeMQcxHeELNCckDR6ADIBVsnHM4bQPXU2wHx4Od9lUrERdIzkQhbJz/gf4yksH9Uu3G
         2dNDHVrtKu+w2If4Fr4bU8YSJErv/GzU3x03SLRed3i53aiVIhubBTVHN4L6eoQCaJyy
         ic6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KI8OZy1Y/mjSCO7OgRxbouN2H002E6+7JQ8LD6ZqKkw=;
        b=kIajbZ+rbzQ4p5XYb7cNoH5la/tqkRK6uJEXGUXuTpGm4bRk6iOkZjps9qIrO1xBEu
         PUGrbg4uIrg2gFfnM2z6jH1mX+6Y2Rr3D1cxXDq31l2eiWmJBwWRmL+qPmA3nsy0xOdC
         +EecR3XweQ1k/QlbcWTh/agcyNuIQanv8zCABzIUyy866AqDgwR369sMl4m+IpLtHJjx
         N8y7j46s1cPgKXIaNUHqmEcf0BrshlMOoi8XyfJdkSKYh7XWaEjMwNEdcFv+zgOp+VPd
         MlBqFbUZBHDN4HPwyH7FVh3smJk26buf5S46g8Uckd2sKibhSi4hlVyD0ogfkpaMe6HX
         nf+Q==
X-Gm-Message-State: AOAM532L1ujzli6py2MaxI3yUcly/TSXLYwNMfxmaX1aGZHVWfI4lE27
        jjMp1tFm9rhAp2517BZXr9NPqawIv+k=
X-Google-Smtp-Source: ABdhPJyVwcHAhuVQBEAjmxMsupFZVxjBO1T+eUHNjoX8+IQ/L5m1s+dD2Mw05a4neRsR1LYA0ji63Q==
X-Received: by 2002:a17:902:b60d:: with SMTP id b13mr17267237pls.48.1597811286862;
        Tue, 18 Aug 2020 21:28:06 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id f6sm24132023pga.9.2020.08.18.21.28.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2020 21:28:06 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v6 bpf-next 3/4] bpf: Add kernel module with user mode driver that populates bpffs.
Date:   Tue, 18 Aug 2020 21:27:58 -0700
Message-Id: <20200819042759.51280-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
References: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add kernel module with user mode driver that populates bpffs with
BPF iterators.

$ mount bpffs /my/bpffs/ -t bpf
$ ls -la /my/bpffs/
total 4
drwxrwxrwt  2 root root    0 Jul  2 00:27 .
drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
-rw-------  1 root root    0 Jul  2 00:27 maps.debug
-rw-------  1 root root    0 Jul  2 00:27 progs.debug

The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
maps, load two BPF programs, attach them to BPF iterators, and finally send two
bpf_link IDs back to the kernel.
The kernel will pin two bpf_links into newly mounted bpffs instance under
names "progs.debug" and "maps.debug". These two files become human readable.

$ cat /my/bpffs/progs.debug
  id name            attached
  11 dump_bpf_map    bpf_iter_bpf_map
  12 dump_bpf_prog   bpf_iter_bpf_prog
  27 test_pkt_access
  32 test_main       test_pkt_access test_pkt_access
  33 test_subprog1   test_pkt_access_subprog1 test_pkt_access
  34 test_subprog2   test_pkt_access_subprog2 test_pkt_access
  35 test_subprog3   test_pkt_access_subprog3 test_pkt_access
  36 new_get_skb_len get_skb_len test_pkt_access
  37 new_get_skb_ifindex get_skb_ifindex test_pkt_access
  38 new_get_constant get_constant test_pkt_access

The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
all BPF programs currently loaded in the system. This information is unstable
and will change from kernel to kernel as ".debug" suffix conveys.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 init/Kconfig                                  |   2 +
 kernel/Makefile                               |   2 +-
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/inode.c                            | 116 +++++++++++++++++-
 kernel/bpf/preload/Kconfig                    |  23 ++++
 kernel/bpf/preload/Makefile                   |  23 ++++
 kernel/bpf/preload/bpf_preload.h              |  16 +++
 kernel/bpf/preload/bpf_preload_kern.c         |  91 ++++++++++++++
 kernel/bpf/preload/bpf_preload_umd_blob.S     |   7 ++
 .../preload/iterators/bpf_preload_common.h    |  13 ++
 kernel/bpf/preload/iterators/iterators.c      |  94 ++++++++++++++
 net/bpfilter/Kconfig                          |   1 +
 tools/lib/bpf/Makefile                        |   7 +-
 13 files changed, 390 insertions(+), 6 deletions(-)
 create mode 100644 kernel/bpf/preload/Kconfig
 create mode 100644 kernel/bpf/preload/Makefile
 create mode 100644 kernel/bpf/preload/bpf_preload.h
 create mode 100644 kernel/bpf/preload/bpf_preload_kern.c
 create mode 100644 kernel/bpf/preload/bpf_preload_umd_blob.S
 create mode 100644 kernel/bpf/preload/iterators/bpf_preload_common.h
 create mode 100644 kernel/bpf/preload/iterators/iterators.c

diff --git a/init/Kconfig b/init/Kconfig
index d6a0b31b13dc..fc10f7ede5f6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1710,6 +1710,8 @@ config BPF_JIT_DEFAULT_ON
 	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
 	depends on HAVE_EBPF_JIT && BPF_JIT
 
+source "kernel/bpf/preload/Kconfig"
+
 config USERFAULTFD
 	bool "Enable userfaultfd() system call"
 	depends on MMU
diff --git a/kernel/Makefile b/kernel/Makefile
index 9a20016d4900..22b0760660fc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -12,7 +12,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o smpboot.o ucount.o regset.o
 
-obj-$(CONFIG_BPFILTER) += usermode_driver.o
+obj-$(CONFIG_USERMODE_DRIVER) += usermode_driver.o
 obj-$(CONFIG_MODULES) += kmod.o
 obj-$(CONFIG_MULTIUSER) += groups.o
 
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
index fb878ba3f22f..b48a56f53495 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -20,6 +20,7 @@
 #include <linux/filter.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include "preload/bpf_preload.h"
 
 enum bpf_type {
 	BPF_TYPE_UNSPEC	= 0,
@@ -369,9 +370,10 @@ static struct dentry *
 bpf_lookup(struct inode *dir, struct dentry *dentry, unsigned flags)
 {
 	/* Dots in names (e.g. "/sys/fs/bpf/foo.bar") are reserved for future
-	 * extensions.
+	 * extensions. That allows popoulate_bpffs() create special files.
 	 */
-	if (strchr(dentry->d_name.name, '.'))
+	if ((dir->i_mode & S_IALLUGO) &&
+	    strchr(dentry->d_name.name, '.'))
 		return ERR_PTR(-EPERM);
 
 	return simple_lookup(dir, dentry, flags);
@@ -409,6 +411,27 @@ static const struct inode_operations bpf_dir_iops = {
 	.unlink		= simple_unlink,
 };
 
+/* pin iterator link into bpffs */
+static int bpf_iter_link_pin_kernel(struct dentry *parent,
+				    const char *name, struct bpf_link *link)
+{
+	umode_t mode = S_IFREG | S_IRUSR;
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
@@ -638,6 +661,91 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	return 0;
 }
 
+struct bpf_preload_ops *bpf_preload_ops;
+EXPORT_SYMBOL_GPL(bpf_preload_ops);
+
+static bool bpf_preload_mod_get(void)
+{
+	/* If bpf_preload.ko wasn't loaded earlier then load it now.
+	 * When bpf_preload is built into vmlinux the module's __init
+	 * function will populate it.
+	 */
+	if (!bpf_preload_ops) {
+		request_module("bpf_preload");
+		if (!bpf_preload_ops)
+			return false;
+	}
+	/* And grab the reference, so the module doesn't disappear while the
+	 * kernel is interacting with the kernel module and its UMD.
+	 */
+	if (!try_module_get(bpf_preload_ops->owner)) {
+		pr_err("bpf_preload module get failed.\n");
+		return false;
+	}
+	return true;
+}
+
+static void bpf_preload_mod_put(void)
+{
+	if (bpf_preload_ops)
+		/* now user can "rmmod bpf_preload" if necessary */
+		module_put(bpf_preload_ops->owner);
+}
+
+static DEFINE_MUTEX(bpf_preload_lock);
+
+static int populate_bpffs(struct dentry *parent)
+{
+	struct bpf_preload_info objs[BPF_PRELOAD_LINKS] = {};
+	struct bpf_link *links[BPF_PRELOAD_LINKS] = {};
+	int err = 0, i;
+
+	/* grab the mutex to make sure the kernel interactions with bpf_preload
+	 * UMD are serialized
+	 */
+	mutex_lock(&bpf_preload_lock);
+
+	/* if bpf_preload.ko wasn't built into vmlinux then load it */
+	if (!bpf_preload_mod_get())
+		goto out;
+
+	if (!bpf_preload_ops->info.tgid) {
+		/* preload() will start UMD that will load BPF iterator programs */
+		err = bpf_preload_ops->preload(objs);
+		if (err)
+			goto out_put;
+		for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
+			links[i] = bpf_link_by_id(objs[i].link_id);
+			if (IS_ERR(links[i])) {
+				err = PTR_ERR(links[i]);
+				goto out_put;
+			}
+		}
+		for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
+			err = bpf_iter_link_pin_kernel(parent,
+						       objs[i].link_name, links[i]);
+			if (err)
+				goto out_put;
+			/* do not unlink successfully pinned links even
+			 * if later link fails to pin
+			 */
+			links[i] = NULL;
+		}
+		/* finish() will tell UMD process to exit */
+		err = bpf_preload_ops->finish();
+		if (err)
+			goto out_put;
+	}
+out_put:
+	bpf_preload_mod_put();
+out:
+	mutex_unlock(&bpf_preload_lock);
+	for (i = 0; i < BPF_PRELOAD_LINKS && err; i++)
+		if (!IS_ERR_OR_NULL(links[i]))
+			bpf_link_put(links[i]);
+	return err;
+}
+
 static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	static const struct tree_descr bpf_rfiles[] = { { "" } };
@@ -654,8 +762,8 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 	inode = sb->s_root->d_inode;
 	inode->i_op = &bpf_dir_iops;
 	inode->i_mode &= ~S_IALLUGO;
+	populate_bpffs(sb->s_root);
 	inode->i_mode |= S_ISVTX | opts->mode;
-
 	return 0;
 }
 
@@ -705,6 +813,8 @@ static int __init bpf_init(void)
 {
 	int ret;
 
+	mutex_init(&bpf_preload_lock);
+
 	ret = sysfs_create_mount_point(fs_kobj, "bpf");
 	if (ret)
 		return ret;
diff --git a/kernel/bpf/preload/Kconfig b/kernel/bpf/preload/Kconfig
new file mode 100644
index 000000000000..7144e2d01ee4
--- /dev/null
+++ b/kernel/bpf/preload/Kconfig
@@ -0,0 +1,23 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config USERMODE_DRIVER
+	bool
+	default n
+
+menuconfig BPF_PRELOAD
+	bool "Preload BPF file system with kernel specific program and map iterators"
+	depends on BPF
+	select USERMODE_DRIVER
+	help
+	  This builds kernel module with several embedded BPF programs that are
+	  pinned into BPF FS mount point as human readable files that are
+	  useful in debugging and introspection of BPF programs and maps.
+
+if BPF_PRELOAD
+config BPF_PRELOAD_UMD
+	tristate "bpf_preload kernel module with user mode driver"
+	depends on CC_CAN_LINK
+	depends on m || CC_CAN_LINK_STATIC
+	default m
+	help
+	  This builds bpf_preload kernel module with embedded user mode driver.
+endif
diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
new file mode 100644
index 000000000000..12c7b62b9b6e
--- /dev/null
+++ b/kernel/bpf/preload/Makefile
@@ -0,0 +1,23 @@
+# SPDX-License-Identifier: GPL-2.0
+
+LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
+LIBBPF_A = $(obj)/libbpf.a
+LIBBPF_OUT = $(abspath $(obj))
+
+$(LIBBPF_A):
+	$(Q)$(MAKE) -C $(LIBBPF_SRCS) OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
+
+userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
+	-I $(srctree)/tools/lib/ -Wno-unused-result
+
+userprogs := bpf_preload_umd
+
+bpf_preload_umd-objs := iterators/iterators.o
+bpf_preload_umd-userldlibs := $(LIBBPF_A) -lelf -lz
+
+$(obj)/bpf_preload_umd: $(LIBBPF_A)
+
+$(obj)/bpf_preload_umd_blob.o: $(obj)/bpf_preload_umd
+
+obj-$(CONFIG_BPF_PRELOAD_UMD) += bpf_preload.o
+bpf_preload-objs += bpf_preload_kern.o bpf_preload_umd_blob.o
diff --git a/kernel/bpf/preload/bpf_preload.h b/kernel/bpf/preload/bpf_preload.h
new file mode 100644
index 000000000000..2f9932276f2e
--- /dev/null
+++ b/kernel/bpf/preload/bpf_preload.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_PRELOAD_H
+#define _BPF_PRELOAD_H
+
+#include <linux/usermode_driver.h>
+#include "iterators/bpf_preload_common.h"
+
+struct bpf_preload_ops {
+        struct umd_info info;
+	int (*preload)(struct bpf_preload_info *);
+	int (*finish)(void);
+	struct module *owner;
+};
+extern struct bpf_preload_ops *bpf_preload_ops;
+#define BPF_PRELOAD_LINKS 2
+#endif
diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
new file mode 100644
index 000000000000..79c5772465f1
--- /dev/null
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pid.h>
+#include <linux/fs.h>
+#include <linux/sched/signal.h>
+#include "bpf_preload.h"
+
+extern char bpf_preload_umd_start;
+extern char bpf_preload_umd_end;
+
+static int preload(struct bpf_preload_info *obj);
+static int finish(void);
+
+static struct bpf_preload_ops umd_ops = {
+	.info.driver_name = "bpf_preload",
+	.preload = preload,
+	.finish = finish,
+	.owner = THIS_MODULE,
+};
+
+static int preload(struct bpf_preload_info *obj)
+{
+	int magic = BPF_PRELOAD_START;
+	loff_t pos = 0;
+	int i, err;
+	ssize_t n;
+
+	err = fork_usermode_driver(&umd_ops.info);
+	if (err)
+		return err;
+
+	/* send the start magic to let UMD proceed with loading BPF progs */
+	n = kernel_write(umd_ops.info.pipe_to_umh,
+			 &magic, sizeof(magic), &pos);
+	if (n != sizeof(magic))
+		return -EPIPE;
+
+	/* receive bpf_link IDs and names from UMD */
+	pos = 0;
+	for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
+		n = kernel_read(umd_ops.info.pipe_from_umh,
+				&obj[i], sizeof(*obj), &pos);
+		if (n != sizeof(*obj))
+			return -EPIPE;
+	}
+	return 0;
+}
+
+static int finish(void)
+{
+	int magic = BPF_PRELOAD_END;
+	struct pid *tgid;
+	loff_t pos = 0;
+	ssize_t n;
+
+	/* send the last magic to UMD. It will do a normal exit. */
+	n = kernel_write(umd_ops.info.pipe_to_umh,
+			 &magic, sizeof(magic), &pos);
+	if (n != sizeof(magic))
+		return -EPIPE;
+	tgid = umd_ops.info.tgid;
+	wait_event(tgid->wait_pidfd, thread_group_exited(tgid));
+	umd_ops.info.tgid = NULL;
+	return 0;
+}
+
+static int __init load_umd(void)
+{
+	int err;
+
+	err = umd_load_blob(&umd_ops.info, &bpf_preload_umd_start,
+			    &bpf_preload_umd_end - &bpf_preload_umd_start);
+	if (err)
+		return err;
+	bpf_preload_ops = &umd_ops;
+	return err;
+}
+
+static void __exit fini_umd(void)
+{
+	bpf_preload_ops = NULL;
+	/* kill UMD in case it's still there due to earlier error */
+	kill_pid(umd_ops.info.tgid, SIGKILL, 1);
+	umd_ops.info.tgid = NULL;
+	umd_unload_blob(&umd_ops.info);
+}
+late_initcall(load_umd);
+module_exit(fini_umd);
+MODULE_LICENSE("GPL");
diff --git a/kernel/bpf/preload/bpf_preload_umd_blob.S b/kernel/bpf/preload/bpf_preload_umd_blob.S
new file mode 100644
index 000000000000..f1f40223b5c3
--- /dev/null
+++ b/kernel/bpf/preload/bpf_preload_umd_blob.S
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+	.section .init.rodata, "a"
+	.global bpf_preload_umd_start
+bpf_preload_umd_start:
+	.incbin "kernel/bpf/preload/bpf_preload_umd"
+	.global bpf_preload_umd_end
+bpf_preload_umd_end:
diff --git a/kernel/bpf/preload/iterators/bpf_preload_common.h b/kernel/bpf/preload/iterators/bpf_preload_common.h
new file mode 100644
index 000000000000..8464d1a48c05
--- /dev/null
+++ b/kernel/bpf/preload/iterators/bpf_preload_common.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_PRELOAD_COMMON_H
+#define _BPF_PRELOAD_COMMON_H
+
+#define BPF_PRELOAD_START 0x5555
+#define BPF_PRELOAD_END 0xAAAA
+
+struct bpf_preload_info {
+	char link_name[16];
+	int link_id;
+};
+
+#endif
diff --git a/kernel/bpf/preload/iterators/iterators.c b/kernel/bpf/preload/iterators/iterators.c
new file mode 100644
index 000000000000..b7ff87939172
--- /dev/null
+++ b/kernel/bpf/preload/iterators/iterators.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <argp.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/resource.h>
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+#include <sys/mount.h>
+#include "iterators.skel.h"
+#include "bpf_preload_common.h"
+
+int to_kernel = -1;
+int from_kernel = 0;
+
+static int send_link_to_kernel(struct bpf_link *link, const char *link_name)
+{
+	struct bpf_preload_info obj = {};
+	struct bpf_link_info info = {};
+	__u32 info_len = sizeof(info);
+	int err;
+
+	err = bpf_obj_get_info_by_fd(bpf_link__fd(link), &info, &info_len);
+	if (err)
+		return err;
+	obj.link_id = info.id;
+	if (strlen(link_name) >= sizeof(obj.link_name))
+		return -E2BIG;
+	strcpy(obj.link_name, link_name);
+	if (write(to_kernel, &obj, sizeof(obj)) != sizeof(obj))
+		return -EPIPE;
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct rlimit rlim = { RLIM_INFINITY, RLIM_INFINITY };
+	struct iterators_bpf *skel;
+	int err, magic;
+	int debug_fd;
+
+	debug_fd = open("/dev/console", O_WRONLY | O_NOCTTY | O_CLOEXEC);
+	if (debug_fd < 0)
+		return 1;
+	to_kernel = dup(1);
+	close(1);
+	dup(debug_fd);
+	/* now stdin and stderr point to /dev/console */
+
+	read(from_kernel, &magic, sizeof(magic));
+	if (magic != BPF_PRELOAD_START) {
+		printf("bad start magic %d\n", magic);
+		return 1;
+	}
+	setrlimit(RLIMIT_MEMLOCK, &rlim);
+	/* libbpf opens BPF object and loads it into the kernel */
+	skel = iterators_bpf__open_and_load();
+	if (!skel) {
+		/* iterators.skel.h is little endian.
+		 * libbpf doesn't support automatic little->big conversion
+		 * of BPF bytecode yet.
+		 * The program load will fail in such case.
+		 */
+		printf("Failed load could be due to wrong endianness\n");
+		return 1;
+	}
+	err = iterators_bpf__attach(skel);
+	if (err)
+		goto cleanup;
+
+	/* send two bpf_link IDs with names to the kernel */
+	err = send_link_to_kernel(skel->links.dump_bpf_map, "maps.debug");
+	if (err)
+		goto cleanup;
+	err = send_link_to_kernel(skel->links.dump_bpf_prog, "progs.debug");
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
diff --git a/net/bpfilter/Kconfig b/net/bpfilter/Kconfig
index 73d0b12789f1..8ad0233ce497 100644
--- a/net/bpfilter/Kconfig
+++ b/net/bpfilter/Kconfig
@@ -2,6 +2,7 @@
 menuconfig BPFILTER
 	bool "BPF based packet filtering framework (BPFILTER)"
 	depends on NET && BPF && INET
+	select USERMODE_DRIVER
 	help
 	  This builds experimental bpfilter framework that is aiming to
 	  provide netfilter compatible functionality via BPF
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c5dbfafdf889..66b2cfadf262 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -1,6 +1,9 @@
 # SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
 # Most of this file is copied from tools/lib/traceevent/Makefile
 
+RM ?= rm
+srctree = $(abs_srctree)
+
 LIBBPF_VERSION := $(shell \
 	grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
 	sort -rV | head -n1 | cut -d'_' -f2)
@@ -188,7 +191,7 @@ $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
 	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
 
 $(OUTPUT)libbpf.a: $(BPF_IN_STATIC)
-	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
+	$(QUIET_LINK)$(RM) -f $@; $(AR) rcs $@ $^
 
 $(OUTPUT)libbpf.pc:
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
@@ -291,7 +294,7 @@ PHONY += force elfdep zdep bpfdep cscope tags
 	cscope -b -q -I $(srctree)/include -f cscope.out
 
 tags:
-	rm -f TAGS tags
+	$(RM) -f TAGS tags
 	ls *.c *.h | xargs $(TAGS_PROG) -a
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
-- 
2.23.0

