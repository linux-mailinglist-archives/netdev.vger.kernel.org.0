Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD021B47DC
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 16:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgDVOzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 10:55:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49611 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgDVOzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 10:55:17 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jRGmL-0006CM-DS; Wed, 22 Apr 2020 14:55:09 +0000
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
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Steve Barber <smbarber@google.com>,
        Dylan Reid <dgreid@google.com>,
        Filipe Brandenburger <filbranden@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Benjamin Elder <bentheelder@google.com>,
        Akihiro Suda <suda.kyoto@gmail.com>
Subject: [PATCH v2 2/7] loopfs: implement loopfs
Date:   Wed, 22 Apr 2020 16:54:32 +0200
Message-Id: <20200422145437.176057-3-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422145437.176057-1-christian.brauner@ubuntu.com>
References: <20200422145437.176057-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements loopfs, a loop device filesystem. It takes inspiration
from the binderfs filesystem I implemented about two years ago and with
which we had overall good experiences so far. Parts of it are also
based on [3] but it's mostly a new, imho cleaner approach.

Loopfs allows to create private loop devices instances to applications
for various use-cases. It covers the use-case that was expressed on-list
and in-person to get programmatic access to private loop devices for
image building in sandboxes. An illustration for this is provided in
[4].

Also loopfs is intended to provide loop devices to privileged and
unprivileged containers which has been a frequent request from various
major tools (Chromium, Kubernetes, LXD, Moby/Docker, systemd). I'm
providing a non-exhaustive list of issues and requests (cf. [5]) around
this feature mainly to illustrate that I'm not making the use-cases up.
Currently none of this can be done safely since handing a loop device
from the host into a container means that the container can see anything
that the host is doing with that loop device and what other containers
are doing with that device too. And (bind-)mounting devtmpfs inside of
containers is not secure at all so also not an option (though sometimes
done out of despair apparently).

The workloads people run in containers are supposed to be indiscernible
from workloads run on the host and the tools inside of the container are
supposed to not be required to be aware that they are running inside a
container apart from containerization tools themselves. This is
especially true when running older distros in containers that did exist
before containers were as ubiquitous as they are today. With loopfs user
can call mount -o loop and in a correctly setup container things work
the same way they would on the host. The filesystem representation
allows us to do this in a very simple way. At container setup, a
container manager can mount a private instance of loopfs somehwere, e.g.
at /dev/loopfs and then bind-mount or symlink /dev/loopfs/loop-control
to /dev/loop-control, pre allocate and symlink the number of standard
devices into their standard location and have a service file or rules in
place that symlink additionally allocated loop devices through losetup
into place as well.
With the new syscall interception logic this is also possible for
unprivileged containers. In these cases when a user calls mount -o loop
<image> <mountpoint> it will be possible to completely setup the loop
device in the container. The final mount syscall is handled through
syscall interception which we already implemented and released in
earlier kernels (see [1] and [2]) and is actively used in production
workloads. The mount is often rewritten to a fuse binary to provide safe
access for unprivileged containers.

Loopfs also allows the creation of hidden/detached dynamic loop devices
and associated mounts which also was a often issued request. With the
old mount api this can be achieved by creating a temporary loopfs and
stashing a file descriptor to the mount point and the loop-control
device and immediately unmounting the loopfs instance.  With the new
mount api a detached mount can be created directly (i.e. a mount not
visible anywhere in the filesystem). New loop devices can then be
allocated and configured. They can be mounted through
/proc/self/<fd>/<nr> with the old mount api or by using the fd directly
with the new mount api. Combined with a mount namespace this allows for
fully auto-cleaned up loop devices on program crash. This ties back to
various use-cases and is illustrated in [4].

The filesystem representation requires the standard boilerplate
filesystem code we know from other tiny filesystems. And all of
the loopfs code is hidden under a config option that defaults to false.
This specifically means, that none of the code even exists when users do
not have any use-case for loopfs.
In addition, the loopfs code does not alter how loop devices behave at
all, i.e. there are no changes to any existing workloads and I've taken
care to ifdef all loopfs specific things out.

Each loopfs mount is a separate instance. As such loop devices created
in one instance are independent of loop devices created in another
instance. This specifically entails that loop devices are only visible
in the loopfs instance they belong to.

The number of loop devices available in loopfs instances are
hierarchically limited through /proc/sys/user/max_loop_devices via the
ucount infrastructure (Thanks to David Rheinsberg for pointing out that
missing piece.). An administrator could e.g. set
echo 3 > /proc/sys/user/max_loop_devices at which point any loopfs
instance mounted by uid x can only create 3 loop devices no matter how
many loopfs instances they mount. This limit applies hierarchically to
all user namespaces.

In addition, loopfs has a "max" mount option which allows to set a limit
on the number of loop devices for a given loopfs instance. This is
mainly to cover use-cases where a single loopfs mount is shared as a
bind-mount between multiple parties that are prevented from creating
other loopfs mounts and is equivalent to the semantics of the binderfs
and devpts "max" mount option.

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
[4]: https://gist.github.com/brauner/dcaf15e6977cc1bfadfb3965f126c02f
[5]: https://github.com/kubernetes-sigs/kind/issues/1333
     https://github.com/kubernetes-sigs/kind/issues/1248
     https://lists.freedesktop.org/archives/systemd-devel/2017-August/039453.html
     https://chromium.googlesource.com/chromiumos/docs/+/master/containers_and_vms.md#loop-mount
     https://gitlab.com/gitlab-com/support-forum/issues/3732
     https://github.com/moby/moby/issues/27886
     https://twitter.com/_AkihiroSuda_/status/1249664478267854848
     https://serverfault.com/questions/701384/loop-device-in-a-linux-container
     https://discuss.linuxcontainers.org/t/providing-access-to-loop-and-other-devices-in-containers/1352
     https://discuss.concourse-ci.org/t/exposing-dev-loop-devices-in-privileged-mode/813
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Steve Barber <smbarber@google.com>
Cc: Filipe Brandenburger <filbranden@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Benjamin Elder <bentheelder@google.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: Tom Gundersen <teg@jklm.no>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Kellner <ckellner@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dylan Reid <dgreid@google.com>
Cc: David Rheinsberg <david.rheinsberg@gmail.com>
Cc: Akihiro Suda <suda.kyoto@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
- David Rheinsberg <david.rheinsberg@gmail.com> /
  Christian Brauner <christian.brauner@ubuntu.com>:
  - Correctly cleanup loop devices that are in-use after the loopfs
    instance has been shut down. This is important for some use-cases
    that David pointed out where they effectively create a loopfs
    instance, allocate devices and drop unnecessary references to it.
- Christian Brauner <christian.brauner@ubuntu.com>:
  - Replace lo_loopfs_i inode member in struct loop_device with a custom
    struct lo_info pointer which is only allocated for loopfs loop
    devices.
---
 MAINTAINERS                    |   5 +
 drivers/block/Kconfig          |   4 +
 drivers/block/Makefile         |   1 +
 drivers/block/loop.c           | 200 ++++++++++---
 drivers/block/loop.h           |  12 +-
 drivers/block/loopfs/Makefile  |   3 +
 drivers/block/loopfs/loopfs.c  | 494 +++++++++++++++++++++++++++++++++
 drivers/block/loopfs/loopfs.h  |  36 +++
 include/linux/user_namespace.h |   3 +
 include/uapi/linux/magic.h     |   1 +
 kernel/ucount.c                |   3 +
 11 files changed, 721 insertions(+), 41 deletions(-)
 create mode 100644 drivers/block/loopfs/Makefile
 create mode 100644 drivers/block/loopfs/loopfs.c
 create mode 100644 drivers/block/loopfs/loopfs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index b816a453b10e..560b37a65bce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9957,6 +9957,11 @@ W:	http://www.avagotech.com/support/
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
index 795facd8cf19..7052be26aa8b 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
+obj-$(CONFIG_BLK_DEV_LOOPFS)	+= loopfs/
 
 obj-$(CONFIG_BLK_DEV_RSXX) += rsxx/
 obj-$(CONFIG_ZRAM) += zram/
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index da693e6a834e..52f7583dd17d 100644
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
@@ -1115,6 +1119,24 @@ loop_init_xfer(struct loop_device *lo, struct loop_func_table *xfer,
 	return err;
 }
 
+static void loop_remove(struct loop_device *lo)
+{
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	loopfs_remove(lo);
+#endif
+	del_gendisk(lo->lo_disk);
+	blk_cleanup_queue(lo->lo_queue);
+	blk_mq_free_tag_set(&lo->tag_set);
+	put_disk(lo->lo_disk);
+	kfree(lo);
+}
+
+static inline void __loop_remove(struct loop_device *lo)
+{
+	idr_remove(&loop_index_idr, lo->lo_number);
+	loop_remove(lo);
+}
+
 static int __loop_clr_fd(struct loop_device *lo, bool release)
 {
 	struct file *filp = NULL;
@@ -1164,7 +1186,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	}
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
-	if (bdev) {
+	if (bdev && bdev->bd_disk) {
 		bd_set_size(bdev, 0);
 		/* let user-space know about this change */
 		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
@@ -1174,7 +1196,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	module_put(THIS_MODULE);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
-	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN && bdev;
+	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN && bdev && bdev->bd_disk;
 	lo_number = lo->lo_number;
 	loop_unprepare_queue(lo);
 out_unlock:
@@ -1213,7 +1235,12 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
-	lo->lo_state = Lo_unbound;
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	if (loopfs_wants_remove(lo))
+		__loop_remove(lo);
+	else
+#endif
+		lo->lo_state = Lo_unbound;
 	mutex_unlock(&loop_ctl_mutex);
 
 	/*
@@ -1259,6 +1286,74 @@ static int loop_clr_fd(struct loop_device *lo)
 	return __loop_clr_fd(lo, false);
 }
 
+#ifdef CONFIG_BLK_DEV_LOOPFS
+int loopfs_rundown_locked(struct loop_device *lo)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(!loopfs_device(lo)))
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
+/**
+ * loopfs_evict_locked() - remove loop device or mark inactive
+ * @lo:	loopfs loop device
+ *
+ * This function will remove a loop device. If it has no users
+ * and is bound the backing file will be cleaned up. If the loop
+ * device has users it will be marked for auto cleanup.
+ * This function is only called when a loopfs instance is shutdown
+ * when all references to it from this loopfs instance have been
+ * dropped. If there are still any references to it cleanup will
+ * happen in lo_release().
+ */
+void loopfs_evict_locked(struct loop_device *lo)
+{
+	struct lo_loopfs *lo_info;
+	struct inode *lo_inode;
+
+	WARN_ON_ONCE(!loopfs_device(lo));
+
+	mutex_lock(&loop_ctl_mutex);
+	lo_info = lo->lo_info;
+	lo_inode = lo_info->lo_inode;
+	lo_info->lo_inode = NULL;
+	lo_info->lo_flags |= LOOPFS_FLAGS_INACTIVE;
+
+	if (atomic_read(&lo->lo_refcnt) > 0) {
+		lo->lo_flags |= LO_FLAGS_AUTOCLEAR;
+	} else {
+		lo->lo_state = Lo_rundown;
+		lo->lo_disk->private_data = NULL;
+		lo_inode->i_private = NULL;
+
+		mutex_unlock(&loop_ctl_mutex);
+		__loop_clr_fd(lo, false);
+		return;
+	}
+	mutex_unlock(&loop_ctl_mutex);
+}
+#endif /* CONFIG_BLK_DEV_LOOPFS */
+
 static int
 loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 {
@@ -1842,7 +1937,7 @@ static void lo_release(struct gendisk *disk, fmode_t mode)
 
 	if (lo->lo_flags & LO_FLAGS_AUTOCLEAR) {
 		if (lo->lo_state != Lo_bound)
-			goto out_unlock;
+			goto out_remove;
 		lo->lo_state = Lo_rundown;
 		mutex_unlock(&loop_ctl_mutex);
 		/*
@@ -1860,6 +1955,12 @@ static void lo_release(struct gendisk *disk, fmode_t mode)
 		blk_mq_unfreeze_queue(lo->lo_queue);
 	}
 
+out_remove:
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	if (lo->lo_state != Lo_bound && loopfs_wants_remove(lo))
+		__loop_remove(lo);
+#endif
+
 out_unlock:
 	mutex_unlock(&loop_ctl_mutex);
 }
@@ -1878,6 +1979,11 @@ static const struct block_device_operations lo_fops = {
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
@@ -2006,7 +2112,7 @@ static const struct blk_mq_ops loop_mq_ops = {
 	.complete	= lo_complete_rq,
 };
 
-static int loop_add(struct loop_device **l, int i)
+static int loop_add(struct loop_device **l, int i, struct inode *inode)
 {
 	struct loop_device *lo;
 	struct gendisk *disk;
@@ -2096,7 +2202,17 @@ static int loop_add(struct loop_device **l, int i)
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
+
 	add_disk(disk);
+
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	err = loopfs_add(lo, inode, disk_devt(disk));
+	if (err) {
+		__loop_remove(lo);
+		goto out;
+	}
+#endif
+
 	*l = lo;
 	return lo->lo_number;
 
@@ -2112,36 +2228,41 @@ static int loop_add(struct loop_device **l, int i)
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
+	if (!loopfs_access(cb_data->inode, lo))
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
@@ -2152,6 +2273,11 @@ static int loop_lookup(struct loop_device **l, int i)
 	/* lookup and return a specific i */
 	lo = idr_find(&loop_index_idr, i);
 	if (lo) {
+#ifdef CONFIG_BLK_DEV_LOOPFS
+		if (!loopfs_access(inode, lo))
+			return -EACCES;
+#endif
+
 		*l = lo;
 		ret = lo->lo_number;
 	}
@@ -2166,9 +2292,9 @@ static struct kobject *loop_probe(dev_t dev, int *part, void *data)
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
@@ -2192,15 +2318,15 @@ static long loop_control_ioctl(struct file *file, unsigned int cmd,
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
@@ -2212,14 +2338,13 @@ static long loop_control_ioctl(struct file *file, unsigned int cmd,
 			break;
 		}
 		lo->lo_disk->private_data = NULL;
-		idr_remove(&loop_index_idr, lo->lo_number);
-		loop_remove(lo);
+		__loop_remove(lo);
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
 
@@ -2246,7 +2371,6 @@ MODULE_ALIAS("devname:loop-control");
 static int __init loop_init(void)
 {
 	int i, nr;
-	unsigned long range;
 	struct loop_device *lo;
 	int err;
 
@@ -2285,10 +2409,10 @@ static int __init loop_init(void)
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
@@ -2301,13 +2425,13 @@ static int __init loop_init(void)
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
@@ -2329,14 +2453,10 @@ static int loop_exit_cb(int id, void *ptr, void *data)
 
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
index af75a5ee4094..6fed746b6124 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -17,6 +17,10 @@
 #include <linux/kthread.h>
 #include <uapi/linux/loop.h>
 
+#ifdef CONFIG_BLK_DEV_LOOPFS
+#include "loopfs/loopfs.h"
+#endif
+
 /* Possible states of device */
 enum {
 	Lo_unbound,
@@ -62,6 +66,9 @@ struct loop_device {
 	struct request_queue	*lo_queue;
 	struct blk_mq_tag_set	tag_set;
 	struct gendisk		*lo_disk;
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	struct lo_loopfs	*lo_info;
+#endif
 };
 
 struct loop_cmd {
@@ -89,6 +96,9 @@ struct loop_func_table {
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
index 000000000000..b3461c72b6e7
--- /dev/null
+++ b/drivers/block/loopfs/loopfs.c
@@ -0,0 +1,494 @@
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
+struct super_block *loopfs_i_sb(const struct inode *inode)
+{
+	if (inode && inode->i_sb->s_magic == LOOPFS_SUPER_MAGIC)
+		return inode->i_sb;
+
+	return NULL;
+}
+
+bool loopfs_device(const struct loop_device *lo)
+{
+	return lo->lo_info != NULL;
+}
+
+struct user_namespace *loopfs_ns(const struct loop_device *lo)
+{
+	if (loopfs_device(lo)) {
+		struct super_block *sb;
+
+		sb = loopfs_i_sb(lo->lo_info->lo_inode);
+		if (sb)
+			return sb->s_user_ns;
+	}
+
+	return &init_user_ns;
+}
+
+bool loopfs_access(const struct inode *first, struct loop_device *lo)
+{
+	return loopfs_device(lo) &&
+	       loopfs_i_sb(first) == loopfs_i_sb(lo->lo_info->lo_inode);
+}
+
+bool loopfs_wants_remove(const struct loop_device *lo)
+{
+	return lo->lo_info && (lo->lo_info->lo_flags & LOOPFS_FLAGS_INACTIVE);
+}
+
+/**
+ * loopfs_add - allocate inode from super block of a loopfs mount
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
+int loopfs_add(struct loop_device *lo, struct inode *ref_inode, dev_t device_nr)
+{
+	int ret;
+	char name[DISK_NAME_LEN];
+	struct super_block *sb;
+	struct loopfs_info *info;
+	struct dentry *root, *dentry;
+	struct inode *inode;
+	struct lo_loopfs *lo_info;
+
+	sb = loopfs_i_sb(ref_inode);
+	if (!sb)
+		return 0;
+
+	if (MAJOR(device_nr) != LOOP_MAJOR)
+		return -EINVAL;
+
+	lo_info = kzalloc(sizeof(struct lo_loopfs), GFP_KERNEL);
+	if (!lo_info) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	info = LOOPFS_SB(sb);
+	if ((info->device_count + 1) > info->mount_opts.max) {
+		ret = -ENOSPC;
+		goto err;
+	}
+
+	lo_info->lo_ucount = inc_ucount(sb->s_user_ns,
+					info->root_uid, UCOUNT_LOOP_DEVICES);
+	if (!lo_info->lo_ucount) {
+		ret = -ENOSPC;
+		goto err;
+	}
+
+	if (snprintf(name, sizeof(name), "loop%d", lo->lo_number) >= sizeof(name)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	inode = new_inode(sb);
+	if (!inode) {
+		ret = -ENOMEM;
+		goto err;
+	}
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
+		ret = PTR_ERR(dentry);
+		goto err;
+	}
+
+	if (d_really_is_positive(dentry)) {
+		/* already exists */
+		dput(dentry);
+		inode_unlock(d_inode(root));
+		iput(inode);
+		ret = -EEXIST;
+		goto err;
+	}
+
+	d_instantiate(dentry, inode);
+	fsnotify_create(d_inode(root), dentry);
+	inode_unlock(d_inode(root));
+
+	lo_info->lo_inode = inode;
+	lo->lo_info = lo_info;
+	inode->i_private = lo;
+	info->device_count++;
+
+	return 0;
+
+err:
+	if (lo_info->lo_ucount)
+		dec_ucount(lo_info->lo_ucount, UCOUNT_LOOP_DEVICES);
+	kfree(lo_info);
+	return ret;
+}
+
+void loopfs_remove(struct loop_device *lo)
+{
+	struct lo_loopfs *lo_info = lo->lo_info;
+	struct inode *inode;
+	struct super_block *sb;
+	struct dentry *root, *dentry;
+
+	if (!lo_info)
+		return;
+
+	inode = lo_info->lo_inode;
+	if (!inode || !S_ISBLK(inode->i_mode) || imajor(inode) != LOOP_MAJOR)
+		goto out;
+
+	sb = loopfs_i_sb(inode);
+	lo_info->lo_inode = NULL;
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
+
+out:
+	if (lo_info->lo_ucount)
+		dec_ucount(lo_info->lo_ucount, UCOUNT_LOOP_DEVICES);
+	kfree(lo->lo_info);
+	lo->lo_info = NULL;
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
+	if (lo && S_ISBLK(inode->i_mode) && imajor(inode) == LOOP_MAJOR) {
+		loopfs_evict_locked(lo);
+		LOOPFS_SB(inode->i_sb)->device_count--;
+		inode->i_private = NULL;
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
+	init_user_ns.ucount_max[UCOUNT_LOOP_DEVICES] = 255;
+	return register_filesystem(&loop_fs_type);
+}
+
+module_init(init_loopfs);
+MODULE_AUTHOR("Christian Brauner <christian.brauner@ubuntu.com>");
+MODULE_DESCRIPTION("Loop device filesystem");
diff --git a/drivers/block/loopfs/loopfs.h b/drivers/block/loopfs/loopfs.h
new file mode 100644
index 000000000000..2ee114aa3fa9
--- /dev/null
+++ b/drivers/block/loopfs/loopfs.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_LOOPFS_FS_H
+#define _LINUX_LOOPFS_FS_H
+
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+#include <linux/user_namespace.h>
+
+struct loop_device;
+
+#ifdef CONFIG_BLK_DEV_LOOPFS
+
+#define LOOPFS_FLAGS_INACTIVE (1 << 0)
+
+struct lo_loopfs {
+	struct ucounts *lo_ucount;
+	struct inode *lo_inode;
+	int lo_flags;
+};
+
+extern struct super_block *loopfs_i_sb(const struct inode *inode);
+extern bool loopfs_device(const struct loop_device *lo);
+extern struct user_namespace *loopfs_ns(const struct loop_device *lo);
+extern bool loopfs_access(const struct inode *first, struct loop_device *lo);
+extern int loopfs_add(struct loop_device *lo, struct inode *ref_inode,
+		      dev_t device_nr);
+extern void loopfs_remove(struct loop_device *lo);
+extern bool loopfs_wants_remove(const struct loop_device *lo);
+extern void loopfs_evict_locked(struct loop_device *lo);
+extern int loopfs_rundown_locked(struct loop_device *lo);
+
+#endif
+
+#endif /* _LINUX_LOOPFS_FS_H */
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 6ef1c7109fc4..04a4891765c0 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -49,6 +49,9 @@ enum ucount_type {
 #ifdef CONFIG_INOTIFY_USER
 	UCOUNT_INOTIFY_INSTANCES,
 	UCOUNT_INOTIFY_WATCHES,
+#endif
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	UCOUNT_LOOP_DEVICES,
 #endif
 	UCOUNT_COUNTS,
 };
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
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 11b1596e2542..fb0f6394a8bb 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -73,6 +73,9 @@ static struct ctl_table user_table[] = {
 #ifdef CONFIG_INOTIFY_USER
 	UCOUNT_ENTRY("max_inotify_instances"),
 	UCOUNT_ENTRY("max_inotify_watches"),
+#endif
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	UCOUNT_ENTRY("max_loop_devices"),
 #endif
 	{ }
 };
-- 
2.26.1

