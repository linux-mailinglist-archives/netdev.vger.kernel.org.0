Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4CF1A2506
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgDHPXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:23:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39082 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbgDHPWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:22:40 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMCXD-0001BO-JV; Wed, 08 Apr 2020 15:22:35 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/8] loopfs: implement loopfs
Date:   Wed,  8 Apr 2020 17:21:45 +0200
Message-Id: <20200408152151.5780-3-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408152151.5780-1-christian.brauner@ubuntu.com>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements loopfs, a loop device filesystem. It takes inspiration
from the binderfs filesystem I implemented about two years ago and with
which we had overally good experiences so far. Parts of it are also
based on [3] but it's mostly a new, imho cleaner approach.

One of the use-cases for loopfs is to allow to dynamically allocate loop
devices in sandboxed workloads without exposing /dev or
/dev/loop-control to the workload in question and without having to
implement a complex and also racy protocol to send around file
descriptors for loop devices. With loopfs each mount is a new instance,
i.e. loop devices created in one loopfs instance are independent of any
loop devices created in another loopfs instance. This allows
sufficiently privileged tools to have their own private stash of loop
device instances.

In addition, the loopfs filesystem can be mounted by user namespace root
and is thus suitable for use in containers. Combined with syscall
interception this makes it possible to securely delegate mounting of
images on loop devices, i.e. when a users calls mount -o loop <image>
<mountpoint> it will be possible to completely setup the loop device
(enabled in later patches) and the mount syscall to actually perform the
mount will be handled through syscall interception and be performed by a
sufficiently privileged process. Syscall interception is already
supported through a new seccomp feature we implemented in [1] and
extended in [2] and is actively used in production workloads. The
additional loopfs work will be used there and in various other workloads
too.

The number of loop devices available to a loopfs instance can be limited
by setting the "max" mount option to a positive integer. This e.g.
allows sufficiently privileged processes to dynamically enforce a limit
on the number of devices. This limit is dynamic in contrast to the
max_loop module option in that a sufficiently privileged process can
update it with a simple remount operation.

The loopfs filesystem is placed under a new config option and special
care has been taken to not introduce any new code when users do not
select this config option.

Note that in __loop_clr_fd() we now need not just check whether bdev is
valid but also whether bdev->bd_disk is valid. This wasn't necessary
before because in order to call LOOP_CLR_FD the loop device would need
to be open and thus bdev->bd_disk was guaranteed to be allocated. For
loopfs loop devices we allow callers to simply unlink them just as we do
for binderfs binder devices and we do also need to account for the case
where a loopfs superblock is shutdown while backing files might still be
associated with some loop devices. In such cases no bd_disk device will
be attached to bdev. This is not in itself noteworthy it's more about
documenting the "why" of the added bdev->bd_disk check for posterity.

[1]: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
[2]: fb3c5386b382 ("seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE")
[3]: https://lore.kernel.org/lkml/1401227936-15698-1-git-send-email-seth.forshee@canonical.com
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Tom Gundersen <teg@jklm.no>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Kellner <ckellner@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Rheinsberg <david.rheinsberg@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 MAINTAINERS                   |   5 +
 drivers/block/Kconfig         |   4 +
 drivers/block/Makefile        |   1 +
 drivers/block/loop.c          | 151 +++++++++---
 drivers/block/loop.h          |   8 +-
 drivers/block/loopfs/Makefile |   3 +
 drivers/block/loopfs/loopfs.c | 429 ++++++++++++++++++++++++++++++++++
 drivers/block/loopfs/loopfs.h |  35 +++
 include/uapi/linux/magic.h    |   1 +
 9 files changed, 600 insertions(+), 37 deletions(-)
 create mode 100644 drivers/block/loopfs/Makefile
 create mode 100644 drivers/block/loopfs/loopfs.c
 create mode 100644 drivers/block/loopfs/loopfs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5a5332b3591d..0a2886645f43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9852,6 +9852,11 @@ S:	Supported
 F:	drivers/message/fusion/
 F:	drivers/scsi/mpt3sas/
 
+LOOPFS FILE SYSTEM
+M:	Christian Brauner <christian.brauner@ubuntu.com>
+S:	Supported
+F:	drivers/block/loopfs/
+
 LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
 M:	Matthew Wilcox <willy@infradead.org>
 L:	linux-scsi@vger.kernel.org
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 025b1b77b11a..d7ff37d795ad 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -214,6 +214,10 @@ config BLK_DEV_LOOP
 
 	  Most users will answer N here.
 
+config BLK_DEV_LOOPFS
+	bool "Loopback device virtual filesystem support"
+	depends on BLK_DEV_LOOP=y
+
 config BLK_DEV_LOOP_MIN_COUNT
 	int "Number of loop devices to pre-create at init time"
 	depends on BLK_DEV_LOOP
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index a53cc1e3a2d3..24fdd7c56eeb 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
+obj-$(CONFIG_BLK_DEV_LOOPFS)	+= loopfs/
 
 obj-$(CONFIG_BLK_DEV_RSXX) += rsxx/
 obj-$(CONFIG_ZRAM) += zram/
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 739b372a5112..a7eda14be639 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -81,6 +81,10 @@
 
 #include "loop.h"
 
+#ifdef CONFIG_BLK_DEV_LOOPFS
+#include "loopfs/loopfs.h"
+#endif
+
 #include <linux/uaccess.h>
 
 static DEFINE_IDR(loop_index_idr);
@@ -1142,7 +1146,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	}
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
-	if (bdev) {
+	if (bdev && bdev->bd_disk) {
 		bd_set_size(bdev, 0);
 		/* let user-space know about this change */
 		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
@@ -1152,7 +1156,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	module_put(THIS_MODULE);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
-	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN && bdev;
+	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN && bdev && bdev->bd_disk;
 	lo_number = lo->lo_number;
 	loop_unprepare_queue(lo);
 out_unlock:
@@ -1237,6 +1241,61 @@ static int loop_clr_fd(struct loop_device *lo)
 	return __loop_clr_fd(lo, false);
 }
 
+static void loop_remove(struct loop_device *lo)
+{
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	loopfs_loop_device_remove(lo);
+#endif
+	del_gendisk(lo->lo_disk);
+	blk_cleanup_queue(lo->lo_queue);
+	blk_mq_free_tag_set(&lo->tag_set);
+	put_disk(lo->lo_disk);
+	kfree(lo);
+}
+
+#ifdef CONFIG_BLK_DEV_LOOPFS
+int loopfs_rundown_locked(struct loop_device *lo)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(!loopfs_i_sb(lo->lo_loopfs_i)))
+		return -EINVAL;
+
+	ret = mutex_lock_killable(&loop_ctl_mutex);
+	if (ret)
+		return ret;
+
+	if (lo->lo_state != Lo_unbound || atomic_read(&lo->lo_refcnt) > 0) {
+		ret = -EBUSY;
+	} else {
+		/*
+		 * Since the device is unbound it has no associated backing
+		 * file and we can safely set Lo_rundown to prevent it from
+		 * being found. Actual cleanup happens during inode eviction.
+		 */
+		lo->lo_state = Lo_rundown;
+		ret = 0;
+	}
+
+	mutex_unlock(&loop_ctl_mutex);
+	return ret;
+}
+
+void loopfs_remove_locked(struct loop_device *lo)
+{
+	if (WARN_ON_ONCE(!loopfs_i_sb(lo->lo_loopfs_i)))
+		return;
+
+	loop_clr_fd(lo);
+
+	mutex_lock(&loop_ctl_mutex);
+	idr_remove(&loop_index_idr, lo->lo_number);
+	lo->lo_loopfs_i = NULL;
+	loop_remove(lo);
+	mutex_unlock(&loop_ctl_mutex);
+}
+#endif /* CONFIG_BLK_DEV_LOOPFS */
+
 static int
 loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 {
@@ -1856,6 +1915,11 @@ static const struct block_device_operations lo_fops = {
  * And now the modules code and kernel interface.
  */
 static int max_loop;
+#ifdef CONFIG_BLK_DEV_LOOPFS
+unsigned long max_devices;
+#else
+static unsigned long max_devices;
+#endif
 module_param(max_loop, int, 0444);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 module_param(max_part, int, 0444);
@@ -1981,7 +2045,7 @@ static const struct blk_mq_ops loop_mq_ops = {
 	.complete	= lo_complete_rq,
 };
 
-static int loop_add(struct loop_device **l, int i)
+static int loop_add(struct loop_device **l, int i, struct inode *inode)
 {
 	struct loop_device *lo;
 	struct gendisk *disk;
@@ -2071,7 +2135,17 @@ static int loop_add(struct loop_device **l, int i)
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
+
 	add_disk(disk);
+
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	err = loopfs_loop_device_create(lo, inode, disk_devt(disk));
+	if (err) {
+		loop_remove(lo);
+		goto out;
+	}
+#endif
+
 	*l = lo;
 	return lo->lo_number;
 
@@ -2087,36 +2161,41 @@ static int loop_add(struct loop_device **l, int i)
 	return err;
 }
 
-static void loop_remove(struct loop_device *lo)
-{
-	del_gendisk(lo->lo_disk);
-	blk_cleanup_queue(lo->lo_queue);
-	blk_mq_free_tag_set(&lo->tag_set);
-	put_disk(lo->lo_disk);
-	kfree(lo);
-}
+struct find_free_cb_data {
+	struct loop_device **l;
+	struct inode *inode;
+};
 
 static int find_free_cb(int id, void *ptr, void *data)
 {
 	struct loop_device *lo = ptr;
-	struct loop_device **l = data;
+	struct find_free_cb_data *cb_data = data;
 
-	if (lo->lo_state == Lo_unbound) {
-		*l = lo;
-		return 1;
-	}
-	return 0;
+	if (lo->lo_state != Lo_unbound)
+		return 0;
+
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	if (!loopfs_same_instance(cb_data->inode, lo->lo_loopfs_i))
+		return 0;
+#endif
+
+	*cb_data->l = lo;
+	return 1;
 }
 
-static int loop_lookup(struct loop_device **l, int i)
+static int loop_lookup(struct loop_device **l, int i, struct inode *inode)
 {
 	struct loop_device *lo;
 	int ret = -ENODEV;
 
 	if (i < 0) {
 		int err;
+		struct find_free_cb_data cb_data = {
+			.l = &lo,
+			.inode = inode,
+		};
 
-		err = idr_for_each(&loop_index_idr, &find_free_cb, &lo);
+		err = idr_for_each(&loop_index_idr, &find_free_cb, &cb_data);
 		if (err == 1) {
 			*l = lo;
 			ret = lo->lo_number;
@@ -2127,6 +2206,11 @@ static int loop_lookup(struct loop_device **l, int i)
 	/* lookup and return a specific i */
 	lo = idr_find(&loop_index_idr, i);
 	if (lo) {
+#ifdef CONFIG_BLK_DEV_LOOPFS
+		if (!loopfs_same_instance(inode, lo->lo_loopfs_i))
+			return -EACCES;
+#endif
+
 		*l = lo;
 		ret = lo->lo_number;
 	}
@@ -2141,9 +2225,9 @@ static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 	int err;
 
 	mutex_lock(&loop_ctl_mutex);
-	err = loop_lookup(&lo, MINOR(dev) >> part_shift);
+	err = loop_lookup(&lo, MINOR(dev) >> part_shift, NULL);
 	if (err < 0)
-		err = loop_add(&lo, MINOR(dev) >> part_shift);
+		err = loop_add(&lo, MINOR(dev) >> part_shift, NULL);
 	if (err < 0)
 		kobj = NULL;
 	else
@@ -2167,15 +2251,15 @@ static long loop_control_ioctl(struct file *file, unsigned int cmd,
 	ret = -ENOSYS;
 	switch (cmd) {
 	case LOOP_CTL_ADD:
-		ret = loop_lookup(&lo, parm);
+		ret = loop_lookup(&lo, parm, file_inode(file));
 		if (ret >= 0) {
 			ret = -EEXIST;
 			break;
 		}
-		ret = loop_add(&lo, parm);
+		ret = loop_add(&lo, parm, file_inode(file));
 		break;
 	case LOOP_CTL_REMOVE:
-		ret = loop_lookup(&lo, parm);
+		ret = loop_lookup(&lo, parm, file_inode(file));
 		if (ret < 0)
 			break;
 		if (lo->lo_state != Lo_unbound) {
@@ -2191,10 +2275,10 @@ static long loop_control_ioctl(struct file *file, unsigned int cmd,
 		loop_remove(lo);
 		break;
 	case LOOP_CTL_GET_FREE:
-		ret = loop_lookup(&lo, -1);
+		ret = loop_lookup(&lo, -1, file_inode(file));
 		if (ret >= 0)
 			break;
-		ret = loop_add(&lo, -1);
+		ret = loop_add(&lo, -1, file_inode(file));
 	}
 	mutex_unlock(&loop_ctl_mutex);
 
@@ -2221,7 +2305,6 @@ MODULE_ALIAS("devname:loop-control");
 static int __init loop_init(void)
 {
 	int i, nr;
-	unsigned long range;
 	struct loop_device *lo;
 	int err;
 
@@ -2260,10 +2343,10 @@ static int __init loop_init(void)
 	 */
 	if (max_loop) {
 		nr = max_loop;
-		range = max_loop << part_shift;
+		max_devices = max_loop << part_shift;
 	} else {
 		nr = CONFIG_BLK_DEV_LOOP_MIN_COUNT;
-		range = 1UL << MINORBITS;
+		max_devices = 1UL << MINORBITS;
 	}
 
 	err = misc_register(&loop_misc);
@@ -2276,13 +2359,13 @@ static int __init loop_init(void)
 		goto misc_out;
 	}
 
-	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
+	blk_register_region(MKDEV(LOOP_MAJOR, 0), max_devices,
 				  THIS_MODULE, loop_probe, NULL, NULL);
 
 	/* pre-create number of devices given by config or max_loop */
 	mutex_lock(&loop_ctl_mutex);
 	for (i = 0; i < nr; i++)
-		loop_add(&lo, i);
+		loop_add(&lo, i, NULL);
 	mutex_unlock(&loop_ctl_mutex);
 
 	printk(KERN_INFO "loop: module loaded\n");
@@ -2304,14 +2387,10 @@ static int loop_exit_cb(int id, void *ptr, void *data)
 
 static void __exit loop_exit(void)
 {
-	unsigned long range;
-
-	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
-
 	idr_for_each(&loop_index_idr, &loop_exit_cb, NULL);
 	idr_destroy(&loop_index_idr);
 
-	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
+	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), max_devices);
 	unregister_blkdev(LOOP_MAJOR, "loop");
 
 	misc_deregister(&loop_misc);
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index af75a5ee4094..f740c7910023 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -62,6 +62,9 @@ struct loop_device {
 	struct request_queue	*lo_queue;
 	struct blk_mq_tag_set	tag_set;
 	struct gendisk		*lo_disk;
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	struct inode		*lo_loopfs_i;
+#endif
 };
 
 struct loop_cmd {
@@ -89,6 +92,9 @@ struct loop_func_table {
 }; 
 
 int loop_register_transfer(struct loop_func_table *funcs);
-int loop_unregister_transfer(int number); 
+int loop_unregister_transfer(int number);
+#ifdef CONFIG_BLK_DEV_LOOPFS
+extern unsigned long max_devices;
+#endif
 
 #endif
diff --git a/drivers/block/loopfs/Makefile b/drivers/block/loopfs/Makefile
new file mode 100644
index 000000000000..87ec703b662e
--- /dev/null
+++ b/drivers/block/loopfs/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+loopfs-y			:= loopfs.o
+obj-$(CONFIG_BLK_DEV_LOOPFS)	+= loopfs.o
diff --git a/drivers/block/loopfs/loopfs.c b/drivers/block/loopfs/loopfs.c
new file mode 100644
index 000000000000..ac46aa337008
--- /dev/null
+++ b/drivers/block/loopfs/loopfs.c
@@ -0,0 +1,429 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/fs.h>
+#include <linux/fs_parser.h>
+#include <linux/fsnotify.h>
+#include <linux/genhd.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/magic.h>
+#include <linux/major.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+
+#include "../loop.h"
+#include "loopfs.h"
+
+#define FIRST_INODE 1
+#define SECOND_INODE 2
+#define INODE_OFFSET 3
+
+enum loopfs_param {
+	Opt_max,
+};
+
+const struct fs_parameter_spec loopfs_fs_parameters[] = {
+	fsparam_u32("max",	Opt_max),
+	{}
+};
+
+struct loopfs_mount_opts {
+	int max;
+};
+
+struct loopfs_info {
+	kuid_t root_uid;
+	kgid_t root_gid;
+	unsigned long device_count;
+	struct dentry *control_dentry;
+	struct loopfs_mount_opts mount_opts;
+};
+
+static inline struct loopfs_info *LOOPFS_SB(const struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+/**
+ * loopfs_loop_device_create - allocate inode from super block of a loopfs mount
+ * @lo:		loop device for which we are creating a new device entry
+ * @ref_inode:	inode from wich the super block will be taken
+ * @device_nr:  device number of the associated disk device
+ *
+ * This function creates a new device node for @lo.
+ * Minor numbers are limited and tracked globally. The
+ * function will stash a struct loop_device for the specific loop
+ * device in i_private of the inode.
+ * It will go on to allocate a new inode from the super block of the
+ * filesystem mount, stash a struct loop_device in its i_private field
+ * and attach a dentry to that inode.
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+int loopfs_loop_device_create(struct loop_device *lo, struct inode *ref_inode,
+			      dev_t device_nr)
+{
+	char name[DISK_NAME_LEN];
+	struct super_block *sb;
+	struct loopfs_info *info;
+	struct dentry *root, *dentry;
+	struct inode *inode;
+
+	sb = loopfs_i_sb(ref_inode);
+	if (!sb)
+		return 0;
+
+	if (MAJOR(device_nr) != LOOP_MAJOR)
+		return -EINVAL;
+
+	info = LOOPFS_SB(sb);
+	if ((info->device_count + 1) > info->mount_opts.max)
+		return -ENOSPC;
+
+	if (snprintf(name, sizeof(name), "loop%d", lo->lo_number) >= sizeof(name))
+		return -EINVAL;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return -ENOMEM;
+
+	/*
+	 * The i_fop field will be set to the correct fops by the device layer
+	 * when the loop device in this loopfs instance is opened.
+	 */
+	inode->i_ino = MINOR(device_nr) + INODE_OFFSET;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
+	inode->i_uid = info->root_uid;
+	inode->i_gid = info->root_gid;
+	init_special_inode(inode, S_IFBLK | 0600, device_nr);
+
+	root = sb->s_root;
+	inode_lock(d_inode(root));
+	/* look it up */
+	dentry = lookup_one_len(name, root, strlen(name));
+	if (IS_ERR(dentry)) {
+		inode_unlock(d_inode(root));
+		iput(inode);
+		return PTR_ERR(dentry);
+	}
+
+	if (d_really_is_positive(dentry)) {
+		/* already exists */
+		dput(dentry);
+		inode_unlock(d_inode(root));
+		iput(inode);
+		return -EEXIST;
+	}
+
+	d_instantiate(dentry, inode);
+	fsnotify_create(d_inode(root), dentry);
+	inode_unlock(d_inode(root));
+
+	inode->i_private = lo;
+	lo->lo_loopfs_i = inode;
+	info->device_count++;
+
+	return 0;
+}
+
+void loopfs_loop_device_remove(struct loop_device *lo)
+{
+	struct inode *inode = lo->lo_loopfs_i;
+	struct super_block *sb;
+	struct dentry *root, *dentry;
+
+	if (!inode || !S_ISBLK(inode->i_mode) || imajor(inode) != LOOP_MAJOR)
+		return;
+
+	sb = loopfs_i_sb(inode);
+	if (!sb)
+		return;
+	lo->lo_loopfs_i = NULL;
+
+	/*
+	 * The root dentry is always the parent dentry since we don't allow
+	 * creation of directories.
+	 */
+	root = sb->s_root;
+
+	inode_lock(d_inode(root));
+	dentry = d_find_any_alias(inode);
+	if (dentry && simple_positive(dentry)) {
+		simple_unlink(d_inode(root), dentry);
+		d_delete(dentry);
+	}
+	dput(dentry);
+	inode_unlock(d_inode(root));
+	LOOPFS_SB(sb)->device_count--;
+}
+
+static void loopfs_fs_context_free(struct fs_context *fc)
+{
+	struct loopfs_mount_opts *ctx = fc->fs_private;
+
+	kfree(ctx);
+}
+
+/**
+ * loopfs_loop_ctl_create - create a new loop-control device
+ * @sb: super block of the loopfs mount
+ *
+ * This function creates a new loop-control device node in the loopfs mount
+ * referred to by @sb.
+ *
+ * Return: 0 on success, negative errno on failure
+ */
+static int loopfs_loop_ctl_create(struct super_block *sb)
+{
+	struct dentry *dentry;
+	struct inode *inode = NULL;
+	struct dentry *root = sb->s_root;
+	struct loopfs_info *info = sb->s_fs_info;
+
+	if (info->control_dentry)
+		return 0;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return -ENOMEM;
+
+	inode->i_ino = SECOND_INODE;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
+	init_special_inode(inode, S_IFCHR | 0600,
+			   MKDEV(MISC_MAJOR, LOOP_CTRL_MINOR));
+	/*
+	 * The i_fop field will be set to the correct fops by the device layer
+	 * when the loop-control device in this loopfs instance is opened.
+	 */
+	inode->i_uid = info->root_uid;
+	inode->i_gid = info->root_gid;
+
+	dentry = d_alloc_name(root, "loop-control");
+	if (!dentry) {
+		iput(inode);
+		return -ENOMEM;
+	}
+
+	info->control_dentry = dentry;
+	d_add(dentry, inode);
+
+	return 0;
+}
+
+static inline bool is_loopfs_control_device(const struct dentry *dentry)
+{
+	return LOOPFS_SB(dentry->d_sb)->control_dentry == dentry;
+}
+
+static int loopfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry,
+			 unsigned int flags)
+{
+	if (is_loopfs_control_device(old_dentry) ||
+	    is_loopfs_control_device(new_dentry))
+		return -EPERM;
+
+	return simple_rename(old_dir, old_dentry, new_dir, new_dentry, flags);
+}
+
+static int loopfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	int ret;
+	struct loop_device *lo;
+
+	if (is_loopfs_control_device(dentry))
+		return -EPERM;
+
+	lo = d_inode(dentry)->i_private;
+	ret = loopfs_rundown_locked(lo);
+	if (ret)
+		return ret;
+
+	return simple_unlink(dir, dentry);
+}
+
+static const struct inode_operations loopfs_dir_inode_operations = {
+	.lookup = simple_lookup,
+	.rename = loopfs_rename,
+	.unlink = loopfs_unlink,
+};
+
+static void loopfs_evict_inode(struct inode *inode)
+{
+	struct loop_device *lo = inode->i_private;
+
+	clear_inode(inode);
+
+	/* Only cleanup loop devices, not the loop control device. */
+	if (S_ISBLK(inode->i_mode) && imajor(inode) == LOOP_MAJOR) {
+		loopfs_remove_locked(lo);
+		LOOPFS_SB(inode->i_sb)->device_count--;
+	}
+}
+
+static int loopfs_show_options(struct seq_file *seq, struct dentry *root)
+{
+	struct loopfs_info *info = LOOPFS_SB(root->d_sb);
+
+	if (info->mount_opts.max <= max_devices)
+		seq_printf(seq, ",max=%d", info->mount_opts.max);
+
+	return 0;
+}
+
+static void loopfs_put_super(struct super_block *sb)
+{
+	struct loopfs_info *info = sb->s_fs_info;
+
+	sb->s_fs_info = NULL;
+	kfree(info);
+}
+
+static const struct super_operations loopfs_super_ops = {
+	.evict_inode    = loopfs_evict_inode,
+	.show_options	= loopfs_show_options,
+	.statfs         = simple_statfs,
+	.put_super	= loopfs_put_super,
+};
+
+static int loopfs_fill_super(struct super_block *sb, struct fs_context *fc)
+{
+	struct loopfs_info *info;
+	struct loopfs_mount_opts *ctx = fc->fs_private;
+	struct inode *inode = NULL;
+
+	sb->s_blocksize = PAGE_SIZE;
+	sb->s_blocksize_bits = PAGE_SHIFT;
+
+	/*
+	 * The loopfs filesystem can be mounted by userns root in a
+	 * non-initial userns. By default such mounts have the SB_I_NODEV flag
+	 * set in s_iflags to prevent security issues where userns root can
+	 * just create random device nodes via mknod() since it owns the
+	 * filesystem mount. But loopfs does not allow to create any files
+	 * including devices nodes. The only way to create binder devices nodes
+	 * is through the loop-control device which userns root is explicitly
+	 * allowed to do. So removing the SB_I_NODEV flag from s_iflags is both
+	 * necessary and safe.
+	 */
+	sb->s_iflags &= ~SB_I_NODEV;
+	sb->s_iflags |= SB_I_NOEXEC;
+	sb->s_magic = LOOPFS_SUPER_MAGIC;
+	sb->s_op = &loopfs_super_ops;
+	sb->s_time_gran = 1;
+
+	sb->s_fs_info = kzalloc(sizeof(struct loopfs_info), GFP_KERNEL);
+	if (!sb->s_fs_info)
+		return -ENOMEM;
+	info = sb->s_fs_info;
+
+	info->root_gid = make_kgid(sb->s_user_ns, 0);
+	if (!gid_valid(info->root_gid))
+		info->root_gid = GLOBAL_ROOT_GID;
+	info->root_uid = make_kuid(sb->s_user_ns, 0);
+	if (!uid_valid(info->root_uid))
+		info->root_uid = GLOBAL_ROOT_UID;
+	info->mount_opts.max = ctx->max;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return -ENOMEM;
+
+	inode->i_ino = FIRST_INODE;
+	inode->i_fop = &simple_dir_operations;
+	inode->i_mode = S_IFDIR | 0755;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
+	inode->i_op = &loopfs_dir_inode_operations;
+	set_nlink(inode, 2);
+
+	sb->s_root = d_make_root(inode);
+	if (!sb->s_root)
+		return -ENOMEM;
+
+	return loopfs_loop_ctl_create(sb);
+}
+
+static int loopfs_fs_context_get_tree(struct fs_context *fc)
+{
+	return get_tree_nodev(fc, loopfs_fill_super);
+}
+
+static int loopfs_fs_context_parse_param(struct fs_context *fc,
+					 struct fs_parameter *param)
+{
+	int opt;
+	struct loopfs_mount_opts *ctx = fc->fs_private;
+	struct fs_parse_result result;
+
+	opt = fs_parse(fc, loopfs_fs_parameters, param, &result);
+	if (opt < 0)
+		return opt;
+
+	switch (opt) {
+	case Opt_max:
+		if (result.uint_32 > max_devices)
+			return invalfc(fc, "Bad value for '%s'", param->key);
+
+		ctx->max = result.uint_32;
+		break;
+	default:
+		return invalfc(fc, "Unsupported parameter '%s'", param->key);
+	}
+
+	return 0;
+}
+
+static int loopfs_fs_context_reconfigure(struct fs_context *fc)
+{
+	struct loopfs_mount_opts *ctx = fc->fs_private;
+	struct loopfs_info *info = LOOPFS_SB(fc->root->d_sb);
+
+	info->mount_opts.max = ctx->max;
+	return 0;
+}
+
+static const struct fs_context_operations loopfs_fs_context_ops = {
+	.free		= loopfs_fs_context_free,
+	.get_tree	= loopfs_fs_context_get_tree,
+	.parse_param	= loopfs_fs_context_parse_param,
+	.reconfigure	= loopfs_fs_context_reconfigure,
+};
+
+static int loopfs_init_fs_context(struct fs_context *fc)
+{
+	struct loopfs_mount_opts *ctx = fc->fs_private;
+
+	ctx = kzalloc(sizeof(struct loopfs_mount_opts), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->max = max_devices;
+
+	fc->fs_private = ctx;
+
+	fc->ops = &loopfs_fs_context_ops;
+
+	return 0;
+}
+
+static struct file_system_type loop_fs_type = {
+	.name			= "loop",
+	.init_fs_context	= loopfs_init_fs_context,
+	.parameters		= loopfs_fs_parameters,
+	.kill_sb		= kill_litter_super,
+	.fs_flags		= FS_USERNS_MOUNT,
+};
+
+int __init init_loopfs(void)
+{
+	return register_filesystem(&loop_fs_type);
+}
+
+module_init(init_loopfs);
+MODULE_AUTHOR("Christian Brauner <christian.brauner@ubuntu.com>");
+MODULE_DESCRIPTION("Loop device filesystem");
diff --git a/drivers/block/loopfs/loopfs.h b/drivers/block/loopfs/loopfs.h
new file mode 100644
index 000000000000..b649f225eb8c
--- /dev/null
+++ b/drivers/block/loopfs/loopfs.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_LOOPFS_FS_H
+#define _LINUX_LOOPFS_FS_H
+
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+
+struct loop_device;
+
+#ifdef CONFIG_BLK_DEV_LOOPFS
+
+extern inline struct super_block *loopfs_i_sb(const struct inode *inode)
+{
+	if (inode && inode->i_sb->s_magic == LOOPFS_SUPER_MAGIC)
+		return inode->i_sb;
+
+	return NULL;
+}
+static inline bool loopfs_same_instance(const struct inode *first,
+					const struct inode *second)
+{
+	return loopfs_i_sb(first) == loopfs_i_sb(second);
+}
+extern int loopfs_loop_device_create(struct loop_device *lo,
+				     struct inode *ref_inode, dev_t device_nr);
+extern void loopfs_loop_device_remove(struct loop_device *lo);
+
+extern void loopfs_remove_locked(struct loop_device *lo);
+extern int loopfs_rundown_locked(struct loop_device *lo);
+
+#endif
+
+#endif /* _LINUX_LOOPFS_FS_H */
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index d78064007b17..0817d093a012 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -75,6 +75,7 @@
 #define BINFMTFS_MAGIC          0x42494e4d
 #define DEVPTS_SUPER_MAGIC	0x1cd1
 #define BINDERFS_SUPER_MAGIC	0x6c6f6f70
+#define LOOPFS_SUPER_MAGIC	0x6c6f6f71
 #define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
 #define PIPEFS_MAGIC            0x50495045
 #define PROC_SUPER_MAGIC	0x9fa0
-- 
2.26.0

