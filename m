Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7812B097
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfL0C1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:27:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43869 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726277AbfL0C1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577413635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PYcQSCQh7oAU0yIEgdl2BnrZ2rnCHYayz/BUt+Y987A=;
        b=YFOgVPTsUmDpVNY1EQPN00DuzwQt+zE0iXrBCdL+zHwWPmDWlKUrqipFEf0G52tLJAf5+5
        qyYGem/eoKlZDQ2Chmca0++q+dHEGF1lDi5DuV5Eu2taAEv7GG0ExlfEvK/eV5CCLgqNM4
        B5IgunnB2BWcZXwM19tYgE5xf8WnSzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-Ik3MybfsPFiRvE2iK0crRw-1; Thu, 26 Dec 2019 21:27:07 -0500
X-MC-Unique: Ik3MybfsPFiRvE2iK0crRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB37C800D53;
        Fri, 27 Dec 2019 02:27:05 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49AC06A83B;
        Fri, 27 Dec 2019 02:27:03 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     vdronov@redhat.com, Al Viro <aviro@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ptp: fix the race between the release of ptp_clock and cdev
Date:   Fri, 27 Dec 2019 03:26:27 +0100
Message-Id: <20191227022627.24476-1-vdronov@redhat.com>
In-Reply-To: <20191208195340.GX4203@ZenIV.linux.org.uk>
References: <20191208195340.GX4203@ZenIV.linux.org.uk>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a case when a ptp chardev (like /dev/ptp0) is open but an underlying
device is removed, closing this file leads to a race. This reproduces
easily in a kvm virtual machine:

ts# cat openptp0.c
int main() { ... fp =3D fopen("/dev/ptp0", "r"); ... sleep(10); }
ts# uname -r
5.5.0-rc3-46cf053e
ts# cat /proc/cmdline
... slub_debug=3DFZP
ts# modprobe ptp_kvm
ts# ./openptp0 &
[1] 670
opened /dev/ptp0, sleeping 10s...
ts# rmmod ptp_kvm
ts# ls /dev/ptp*
ls: cannot access '/dev/ptp*': No such file or directory
ts# ...woken up
[   48.010809] general protection fault: 0000 [#1] SMP
[   48.012502] CPU: 6 PID: 658 Comm: openptp0 Not tainted 5.5.0-rc3-46cf0=
53e #25
[   48.014624] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
[   48.016270] RIP: 0010:module_put.part.0+0x7/0x80
[   48.017939] RSP: 0018:ffffb3850073be00 EFLAGS: 00010202
[   48.018339] RAX: 000000006b6b6b6b RBX: 6b6b6b6b6b6b6b6b RCX: ffff89a47=
6c00ad0
[   48.018936] RDX: fffff65a08d3ea08 RSI: 0000000000000247 RDI: 6b6b6b6b6=
b6b6b6b
[   48.019470] ...                                              ^^^ a slu=
b poison
[   48.023854] Call Trace:
[   48.024050]  __fput+0x21f/0x240
[   48.024288]  task_work_run+0x79/0x90
[   48.024555]  do_exit+0x2af/0xab0
[   48.024799]  ? vfs_write+0x16a/0x190
[   48.025082]  do_group_exit+0x35/0x90
[   48.025387]  __x64_sys_exit_group+0xf/0x10
[   48.025737]  do_syscall_64+0x3d/0x130
[   48.026056]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   48.026479] RIP: 0033:0x7f53b12082f6
[   48.026792] ...
[   48.030945] Modules linked in: ptp i6300esb watchdog [last unloaded: p=
tp_kvm]
[   48.045001] Fixing recursive fault but reboot is needed!

This happens in:

static void __fput(struct file *file)
{   ...
    if (file->f_op->release)
        file->f_op->release(inode, file); <<< cdev is kfree'd here
    if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev !=3D NULL &&
             !(mode & FMODE_PATH))) {
        cdev_put(inode->i_cdev); <<< cdev fields are accessed here

Namely:

__fput()
  posix_clock_release()
    kref_put(&clk->kref, delete_clock) <<< the last reference
      delete_clock()
        delete_ptp_clock()
          kfree(ptp) <<< cdev is embedded in ptp
  cdev_put
    module_put(p->owner) <<< *p is kfree'd, bang!

Here cdev is embedded in posix_clock which is embedded in ptp_clock.
The race happens because ptp_clock's lifetime is controlled by two
refcounts: kref and cdev.kobj in posix_clock. This is wrong.

Make ptp_clock's sysfs device a parent of cdev with cdev_device_add()
created especially for such cases. This way the parent device with its
ptp_clock is not released until all references to the cdev are released.
This adds a requirement that an initialized but not exposed struct
device should be provided to posix_clock_register() by a caller instead
of a simple dev_t.

This approach was adopted from the commit 72139dfa2464 ("watchdog: Fix
the race between the release of watchdog_core_data and cdev"). See
details of the implementation in the commit 233ed09d7fda ("chardev: add
helper function to register char devs with a struct device").

Link: https://lore.kernel.org/linux-fsdevel/20191125125342.6189-1-vdronov=
@redhat.com/T/#u
Analyzed-by: Stephen Johnston <sjohnsto@redhat.com>
Analyzed-by: Vern Lovejoy <vlovejoy@redhat.com>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 drivers/ptp/ptp_clock.c     | 31 ++++++++++++++-----------------
 drivers/ptp/ptp_private.h   |  2 +-
 include/linux/posix-clock.h | 19 +++++++++++--------
 kernel/time/posix-clock.c   | 31 +++++++++++++------------------
 4 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index e60eab7f8a61..61fafe0374ce 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -166,9 +166,9 @@ static struct posix_clock_operations ptp_clock_ops =3D=
 {
 	.read		=3D ptp_read,
 };
=20
-static void delete_ptp_clock(struct posix_clock *pc)
+static void ptp_clock_release(struct device *dev)
 {
-	struct ptp_clock *ptp =3D container_of(pc, struct ptp_clock, clock);
+	struct ptp_clock *ptp =3D container_of(dev, struct ptp_clock, dev);
=20
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
@@ -213,7 +213,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock=
_info *info,
 	}
=20
 	ptp->clock.ops =3D ptp_clock_ops;
-	ptp->clock.release =3D delete_ptp_clock;
 	ptp->info =3D info;
 	ptp->devid =3D MKDEV(major, index);
 	ptp->index =3D index;
@@ -236,15 +235,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_cloc=
k_info *info,
 	if (err)
 		goto no_pin_groups;
=20
-	/* Create a new device in our class. */
-	ptp->dev =3D device_create_with_groups(ptp_class, parent, ptp->devid,
-					     ptp, ptp->pin_attr_groups,
-					     "ptp%d", ptp->index);
-	if (IS_ERR(ptp->dev)) {
-		err =3D PTR_ERR(ptp->dev);
-		goto no_device;
-	}
-
 	/* Register a new PPS source. */
 	if (info->pps) {
 		struct pps_source_info pps;
@@ -260,8 +250,18 @@ struct ptp_clock *ptp_clock_register(struct ptp_cloc=
k_info *info,
 		}
 	}
=20
-	/* Create a posix clock. */
-	err =3D posix_clock_register(&ptp->clock, ptp->devid);
+	/* Initialize a new device of our class in our clock structure. */
+	device_initialize(&ptp->dev);
+	ptp->dev.devt =3D ptp->devid;
+	ptp->dev.class =3D ptp_class;
+	ptp->dev.parent =3D parent;
+	ptp->dev.groups =3D ptp->pin_attr_groups;
+	ptp->dev.release =3D ptp_clock_release;
+	dev_set_drvdata(&ptp->dev, ptp);
+	dev_set_name(&ptp->dev, "ptp%d", ptp->index);
+
+	/* Create a posix clock and link it to the device. */
+	err =3D posix_clock_register(&ptp->clock, &ptp->dev);
 	if (err) {
 		pr_err("failed to create posix clock\n");
 		goto no_clock;
@@ -273,8 +273,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock=
_info *info,
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
 no_pps:
-	device_destroy(ptp_class, ptp->devid);
-no_device:
 	ptp_cleanup_pin_groups(ptp);
 no_pin_groups:
 	if (ptp->kworker)
@@ -304,7 +302,6 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
=20
-	device_destroy(ptp_class, ptp->devid);
 	ptp_cleanup_pin_groups(ptp);
=20
 	posix_clock_unregister(&ptp->clock);
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 9171d42468fd..6b97155148f1 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -28,7 +28,7 @@ struct timestamp_event_queue {
=20
 struct ptp_clock {
 	struct posix_clock clock;
-	struct device *dev;
+	struct device dev;
 	struct ptp_clock_info *info;
 	dev_t devid;
 	int index; /* index into clocks.map */
diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index fe6cfdcfbc26..5cfe13293243 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -69,29 +69,32 @@ struct posix_clock_operations {
  *
  * @ops:     Functional interface to the clock
  * @cdev:    Character device instance for this clock
- * @kref:    Reference count.
+ * @dev:     Pointer to the clock's device.
  * @rwsem:   Protects the 'zombie' field from concurrent access.
  * @zombie:  If 'zombie' is true, then the hardware has disappeared.
- * @release: A function to free the structure when the reference count r=
eaches
- *           zero. May be NULL if structure is statically allocated.
  *
  * Drivers should embed their struct posix_clock within a private
  * structure, obtaining a reference to it during callbacks using
  * container_of().
+ *
+ * Drivers should supply an initialized but not exposed struct device
+ * to posix_clock_register(). It is used to manage lifetime of the
+ * driver's private structure. It's 'release' field should be set to
+ * a release function for this private structure.
  */
 struct posix_clock {
 	struct posix_clock_operations ops;
 	struct cdev cdev;
-	struct kref kref;
+	struct device *dev;
 	struct rw_semaphore rwsem;
 	bool zombie;
-	void (*release)(struct posix_clock *clk);
 };
=20
 /**
  * posix_clock_register() - register a new clock
- * @clk:   Pointer to the clock. Caller must provide 'ops' and 'release'
- * @devid: Allocated device id
+ * @clk:   Pointer to the clock. Caller must provide 'ops' field
+ * @dev:   Pointer to the initialized device. Caller must provide
+ *         'release' filed
  *
  * A clock driver calls this function to register itself with the
  * clock device subsystem. If 'clk' points to dynamically allocated
@@ -100,7 +103,7 @@ struct posix_clock {
  *
  * Returns zero on success, non-zero otherwise.
  */
-int posix_clock_register(struct posix_clock *clk, dev_t devid);
+int posix_clock_register(struct posix_clock *clk, struct device *dev);
=20
 /**
  * posix_clock_unregister() - unregister a clock
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index ec960bb939fd..200fb2d3be99 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -14,8 +14,6 @@
=20
 #include "posix-timers.h"
=20
-static void delete_clock(struct kref *kref);
-
 /*
  * Returns NULL if the posix_clock instance attached to 'fp' is old and =
stale.
  */
@@ -125,7 +123,7 @@ static int posix_clock_open(struct inode *inode, stru=
ct file *fp)
 		err =3D 0;
=20
 	if (!err) {
-		kref_get(&clk->kref);
+		get_device(clk->dev);
 		fp->private_data =3D clk;
 	}
 out:
@@ -141,7 +139,7 @@ static int posix_clock_release(struct inode *inode, s=
truct file *fp)
 	if (clk->ops.release)
 		err =3D clk->ops.release(clk);
=20
-	kref_put(&clk->kref, delete_clock);
+	put_device(clk->dev);
=20
 	fp->private_data =3D NULL;
=20
@@ -161,38 +159,35 @@ static const struct file_operations posix_clock_fil=
e_operations =3D {
 #endif
 };
=20
-int posix_clock_register(struct posix_clock *clk, dev_t devid)
+int posix_clock_register(struct posix_clock *clk, struct device *dev)
 {
 	int err;
=20
-	kref_init(&clk->kref);
 	init_rwsem(&clk->rwsem);
=20
 	cdev_init(&clk->cdev, &posix_clock_file_operations);
+	err =3D cdev_device_add(&clk->cdev, dev);
+	if (err) {
+		pr_err("%s unable to add device %d:%d\n",
+			dev_name(dev), MAJOR(dev->devt), MINOR(dev->devt));
+		return err;
+	}
 	clk->cdev.owner =3D clk->ops.owner;
-	err =3D cdev_add(&clk->cdev, devid, 1);
+	clk->dev =3D dev;
=20
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(posix_clock_register);
=20
-static void delete_clock(struct kref *kref)
-{
-	struct posix_clock *clk =3D container_of(kref, struct posix_clock, kref=
);
-
-	if (clk->release)
-		clk->release(clk);
-}
-
 void posix_clock_unregister(struct posix_clock *clk)
 {
-	cdev_del(&clk->cdev);
+	cdev_device_del(&clk->cdev, clk->dev);
=20
 	down_write(&clk->rwsem);
 	clk->zombie =3D true;
 	up_write(&clk->rwsem);
=20
-	kref_put(&clk->kref, delete_clock);
+	put_device(clk->dev);
 }
 EXPORT_SYMBOL_GPL(posix_clock_unregister);
=20
--=20
2.20.1

