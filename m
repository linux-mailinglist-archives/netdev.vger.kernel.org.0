Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15673B8CA1
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 10:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437806AbfITIXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 04:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404929AbfITIXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 04:23:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5555444BD7;
        Fri, 20 Sep 2019 08:23:19 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-88.pek2.redhat.com [10.72.12.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE83010027AA;
        Fri, 20 Sep 2019 08:22:33 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        pmorel@linux.ibm.com, freude@linux.ibm.com, lingshan.zhu@intel.com,
        idos@mellanox.com, eperezma@redhat.com, lulu@redhat.com,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH V2 2/6] mdev: introduce device specific ops
Date:   Fri, 20 Sep 2019 16:20:46 +0800
Message-Id: <20190920082050.19352-3-jasowang@redhat.com>
In-Reply-To: <20190920082050.19352-1-jasowang@redhat.com>
References: <20190920082050.19352-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 20 Sep 2019 08:23:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, except for the crate and remove. The rest fields of
mdev_parent_ops is just designed for vfio-mdev driver and may not help
for kernel mdev driver. So follow the device id support by previous
patch, this patch introduces device specific ops which points to
device specific ops (e.g vfio ops). This allows the future drivers
like virtio-mdev to implement its own device specific ops.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 .../driver-api/vfio-mediated-device.rst       |  4 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 15 +++---
 drivers/s390/cio/vfio_ccw_ops.c               | 15 ++++--
 drivers/s390/crypto/vfio_ap_ops.c             | 11 ++--
 drivers/vfio/mdev/vfio_mdev.c                 | 31 +++++++-----
 include/linux/mdev.h                          | 39 ++-------------
 include/linux/vfio_mdev.h                     | 50 +++++++++++++++++++
 samples/vfio-mdev/mbochs.c                    | 17 ++++---
 samples/vfio-mdev/mdpy.c                      | 17 ++++---
 samples/vfio-mdev/mtty.c                      | 15 ++++--
 10 files changed, 136 insertions(+), 78 deletions(-)
 create mode 100644 include/linux/vfio_mdev.h

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 0d6e85155b9b..f48454bb60b9 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -152,7 +152,9 @@ callbacks per mdev parent device, per mdev type, or any other categorization.
 Vendor drivers are expected to be fully asynchronous in this respect or
 provide their own internal resource protection.)
 
-The callbacks in the mdev_parent_ops structure are as follows:
+The device specific callbacks are referred through device_ops pointer
+in mdev_parent_ops. For vfio-mdev device, its callbacks in device_ops
+are as follows:
 
 * open: open callback of mediated device
 * close: close callback of mediated device
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 19d51a35f019..8ea86b1e69f1 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -42,6 +42,7 @@
 #include <linux/kvm_host.h>
 #include <linux/vfio.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 #include <linux/debugfs.h>
 
 #include <linux/nospec.h>
@@ -1600,20 +1601,22 @@ static const struct attribute_group *intel_vgpu_groups[] = {
 	NULL,
 };
 
-static struct mdev_parent_ops intel_vgpu_ops = {
-	.mdev_attr_groups       = intel_vgpu_groups,
-	.create			= intel_vgpu_create,
-	.remove			= intel_vgpu_remove,
-
+static struct vfio_mdev_parent_ops intel_vfio_vgpu_ops = {
 	.open			= intel_vgpu_open,
 	.release		= intel_vgpu_release,
-
 	.read			= intel_vgpu_read,
 	.write			= intel_vgpu_write,
 	.mmap			= intel_vgpu_mmap,
 	.ioctl			= intel_vgpu_ioctl,
 };
 
+static struct mdev_parent_ops intel_vgpu_ops = {
+	.mdev_attr_groups       = intel_vgpu_groups,
+	.create			= intel_vgpu_create,
+	.remove			= intel_vgpu_remove,
+	.device_ops	        = &intel_vfio_vgpu_ops,
+};
+
 static int kvmgt_host_init(struct device *dev, void *gvt, const void *ops)
 {
 	struct attribute **kvm_type_attrs;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index f87d9409e290..e01247cc61b8 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -12,6 +12,7 @@
 
 #include <linux/vfio.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 #include <linux/nospec.h>
 #include <linux/slab.h>
 
@@ -564,11 +565,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 	}
 }
 
-static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
-	.owner			= THIS_MODULE,
-	.supported_type_groups  = mdev_type_groups,
-	.create			= vfio_ccw_mdev_create,
-	.remove			= vfio_ccw_mdev_remove,
+static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
 	.open			= vfio_ccw_mdev_open,
 	.release		= vfio_ccw_mdev_release,
 	.read			= vfio_ccw_mdev_read,
@@ -576,6 +573,14 @@ static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
 	.ioctl			= vfio_ccw_mdev_ioctl,
 };
 
+static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
+	.owner			= THIS_MODULE,
+	.supported_type_groups  = mdev_type_groups,
+	.create			= vfio_ccw_mdev_create,
+	.remove			= vfio_ccw_mdev_remove,
+	.device_ops		= &vfio_mdev_ops,
+};
+
 int vfio_ccw_mdev_reg(struct subchannel *sch)
 {
 	return mdev_register_vfio_device(&sch->dev, &vfio_ccw_mdev_ops);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index eacbde3c7a97..685ec5946c7b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -16,6 +16,7 @@
 #include <linux/bitops.h>
 #include <linux/kvm_host.h>
 #include <linux/module.h>
+#include <linux/vfio_mdev.h>
 #include <asm/kvm.h>
 #include <asm/zcrypt.h>
 
@@ -1280,15 +1281,19 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 	return ret;
 }
 
+static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
+	.open			= vfio_ap_mdev_open,
+	.release		= vfio_ap_mdev_release,
+	.ioctl			= vfio_ap_mdev_ioctl,
+};
+
 static const struct mdev_parent_ops vfio_ap_matrix_ops = {
 	.owner			= THIS_MODULE,
 	.supported_type_groups	= vfio_ap_mdev_type_groups,
 	.mdev_attr_groups	= vfio_ap_mdev_attr_groups,
 	.create			= vfio_ap_mdev_create,
 	.remove			= vfio_ap_mdev_remove,
-	.open			= vfio_ap_mdev_open,
-	.release		= vfio_ap_mdev_release,
-	.ioctl			= vfio_ap_mdev_ioctl,
+	.device_ops		= &vfio_mdev_ops,
 };
 
 int vfio_ap_mdev_register(void)
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index fd2a4d9a3f26..d23c9f58c84f 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/vfio.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 
 #include "mdev_private.h"
 
@@ -25,15 +26,16 @@ static int vfio_mdev_open(void *device_data)
 {
 	struct mdev_device *mdev = device_data;
 	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
 	int ret;
 
-	if (unlikely(!parent->ops->open))
+	if (unlikely(!ops->open))
 		return -EINVAL;
 
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
-	ret = parent->ops->open(mdev);
+	ret = ops->open(mdev);
 	if (ret)
 		module_put(THIS_MODULE);
 
@@ -44,9 +46,10 @@ static void vfio_mdev_release(void *device_data)
 {
 	struct mdev_device *mdev = device_data;
 	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
 
-	if (likely(parent->ops->release))
-		parent->ops->release(mdev);
+	if (likely(ops->release))
+		ops->release(mdev);
 
 	module_put(THIS_MODULE);
 }
@@ -56,11 +59,12 @@ static long vfio_mdev_unlocked_ioctl(void *device_data,
 {
 	struct mdev_device *mdev = device_data;
 	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
 
-	if (unlikely(!parent->ops->ioctl))
+	if (unlikely(!ops->ioctl))
 		return -EINVAL;
 
-	return parent->ops->ioctl(mdev, cmd, arg);
+	return ops->ioctl(mdev, cmd, arg);
 }
 
 static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
@@ -68,11 +72,12 @@ static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
 {
 	struct mdev_device *mdev = device_data;
 	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
 
-	if (unlikely(!parent->ops->read))
+	if (unlikely(!ops->read))
 		return -EINVAL;
 
-	return parent->ops->read(mdev, buf, count, ppos);
+	return ops->read(mdev, buf, count, ppos);
 }
 
 static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
@@ -80,22 +85,24 @@ static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
 {
 	struct mdev_device *mdev = device_data;
 	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
 
-	if (unlikely(!parent->ops->write))
+	if (unlikely(!ops->write))
 		return -EINVAL;
 
-	return parent->ops->write(mdev, buf, count, ppos);
+	return ops->write(mdev, buf, count, ppos);
 }
 
 static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct mdev_device *mdev = device_data;
 	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
 
-	if (unlikely(!parent->ops->mmap))
+	if (unlikely(!ops->mmap))
 		return -EINVAL;
 
-	return parent->ops->mmap(mdev, vma);
+	return ops->mmap(mdev, vma);
 }
 
 static const struct vfio_device_ops vfio_mdev_dev_ops = {
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index bb0a743e5a03..99fdfd74433d 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -48,30 +48,8 @@ struct device *mdev_get_iommu_device(struct device *dev);
  *			@mdev: mdev_device device structure which is being
  *			       destroyed
  *			Returns integer: success (0) or error (< 0)
- * @open:		Open mediated device.
- *			@mdev: mediated device.
- *			Returns integer: success (0) or error (< 0)
- * @release:		release mediated device
- *			@mdev: mediated device.
- * @read:		Read emulation callback
- *			@mdev: mediated device structure
- *			@buf: read buffer
- *			@count: number of bytes to read
- *			@ppos: address.
- *			Retuns number on bytes read on success or error.
- * @write:		Write emulation callback
- *			@mdev: mediated device structure
- *			@buf: write buffer
- *			@count: number of bytes to be written
- *			@ppos: address.
- *			Retuns number on bytes written on success or error.
- * @ioctl:		IOCTL callback
- *			@mdev: mediated device structure
- *			@cmd: ioctl command
- *			@arg: arguments to ioctl
- * @mmap:		mmap callback
- *			@mdev: mediated device structure
- *			@vma: vma structure
+ * @device_ops:         Device specific emulation callback.
+ *
  * Parent device that support mediated device should be registered with mdev
  * module with mdev_parent_ops structure.
  **/
@@ -83,15 +61,7 @@ struct mdev_parent_ops {
 
 	int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
 	int     (*remove)(struct mdev_device *mdev);
-	int     (*open)(struct mdev_device *mdev);
-	void    (*release)(struct mdev_device *mdev);
-	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
-			size_t count, loff_t *ppos);
-	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
-			 size_t count, loff_t *ppos);
-	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
-			 unsigned long arg);
-	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
+	const void *device_ops;
 };
 
 /* interface for exporting mdev supported type attributes */
@@ -137,7 +107,8 @@ const guid_t *mdev_uuid(struct mdev_device *mdev);
 
 extern struct bus_type mdev_bus_type;
 
-int mdev_register_vfio_device(struct device *dev, const struct mdev_parent_ops *ops);
+int mdev_register_vfio_device(struct device *dev,
+                              const struct mdev_parent_ops *ops);
 void mdev_unregister_device(struct device *dev);
 
 int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
diff --git a/include/linux/vfio_mdev.h b/include/linux/vfio_mdev.h
new file mode 100644
index 000000000000..7f884b946cba
--- /dev/null
+++ b/include/linux/vfio_mdev.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * VFIO Mediated device definition
+ */
+
+#ifndef VFIO_MDEV_H
+#define VFIO_MDEV_H
+
+/**
+ * struct vfio_mdev_parent_ops - Structure to be registered for each
+ * parent device to register the device to vfio-mdev module.
+ *
+ * @open:		Open mediated device.
+ *			@mdev: mediated device.
+ *			Returns integer: success (0) or error (< 0)
+ * @release:		release mediated device
+ *			@mdev: mediated device.
+ * @read:		Read emulation callback
+ *			@mdev: mediated device structure
+ *			@buf: read buffer
+ *			@count: number of bytes to read
+ *			@ppos: address.
+ *			Retuns number on bytes read on success or error.
+ * @write:		Write emulation callback
+ *			@mdev: mediated device structure
+ *			@buf: write buffer
+ *			@count: number of bytes to be written
+ *			@ppos: address.
+ *			Retuns number on bytes written on success or error.
+ * @ioctl:		IOCTL callback
+ *			@mdev: mediated device structure
+ *			@cmd: ioctl command
+ *			@arg: arguments to ioctl
+ * @mmap:		mmap callback
+ *			@mdev: mediated device structure
+ *			@vma: vma structure
+ */
+struct vfio_mdev_parent_ops {
+	int     (*open)(struct mdev_device *mdev);
+	void    (*release)(struct mdev_device *mdev);
+	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
+			size_t count, loff_t *ppos);
+	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
+			 size_t count, loff_t *ppos);
+	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
+			 unsigned long arg);
+	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
+};
+
+#endif
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 71a4469be85d..107cc30d0f45 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -30,6 +30,7 @@
 #include <linux/iommu.h>
 #include <linux/sysfs.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 #include <linux/pci.h>
 #include <linux/dma-buf.h>
 #include <linux/highmem.h>
@@ -1418,12 +1419,7 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
-static const struct mdev_parent_ops mdev_fops = {
-	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
-	.supported_type_groups	= mdev_type_groups,
-	.create			= mbochs_create,
-	.remove			= mbochs_remove,
+static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
 	.open			= mbochs_open,
 	.release		= mbochs_close,
 	.read			= mbochs_read,
@@ -1432,6 +1428,15 @@ static const struct mdev_parent_ops mdev_fops = {
 	.mmap			= mbochs_mmap,
 };
 
+static const struct mdev_parent_ops mdev_fops = {
+	.owner			= THIS_MODULE,
+	.mdev_attr_groups	= mdev_dev_groups,
+	.supported_type_groups	= mdev_type_groups,
+	.create			= mbochs_create,
+	.remove			= mbochs_remove,
+	.device_ops		= &vfio_mdev_ops,
+};
+
 static const struct file_operations vd_fops = {
 	.owner		= THIS_MODULE,
 };
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index d3029dd27d91..2cd2018a53f9 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -26,6 +26,7 @@
 #include <linux/iommu.h>
 #include <linux/sysfs.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 #include <linux/pci.h>
 #include <drm/drm_fourcc.h>
 #include "mdpy-defs.h"
@@ -725,12 +726,7 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
-static const struct mdev_parent_ops mdev_fops = {
-	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
-	.supported_type_groups	= mdev_type_groups,
-	.create			= mdpy_create,
-	.remove			= mdpy_remove,
+static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
 	.open			= mdpy_open,
 	.release		= mdpy_close,
 	.read			= mdpy_read,
@@ -739,6 +735,15 @@ static const struct mdev_parent_ops mdev_fops = {
 	.mmap			= mdpy_mmap,
 };
 
+static const struct mdev_parent_ops mdev_fops = {
+	.owner			= THIS_MODULE,
+	.mdev_attr_groups	= mdev_dev_groups,
+	.supported_type_groups	= mdev_type_groups,
+	.create			= mdpy_create,
+	.remove			= mdpy_remove,
+	.device_ops		= &vfio_mdev_ops,
+};
+
 static const struct file_operations vd_fops = {
 	.owner		= THIS_MODULE,
 };
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 744c88a6b22c..e427425b5daf 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -27,6 +27,7 @@
 #include <linux/ctype.h>
 #include <linux/file.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 #include <linux/pci.h>
 #include <linux/serial.h>
 #include <uapi/linux/serial_reg.h>
@@ -1410,6 +1411,14 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
+	.open                   = mtty_open,
+	.release                = mtty_close,
+	.read                   = mtty_read,
+	.write                  = mtty_write,
+	.ioctl		        = mtty_ioctl,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner                  = THIS_MODULE,
 	.dev_attr_groups        = mtty_dev_groups,
@@ -1417,11 +1426,7 @@ static const struct mdev_parent_ops mdev_fops = {
 	.supported_type_groups  = mdev_type_groups,
 	.create                 = mtty_create,
 	.remove			= mtty_remove,
-	.open                   = mtty_open,
-	.release                = mtty_close,
-	.read                   = mtty_read,
-	.write                  = mtty_write,
-	.ioctl		        = mtty_ioctl,
+	.device_ops             = &vfio_mdev_ops,
 };
 
 static void mtty_device_release(struct device *dev)
-- 
2.19.1

