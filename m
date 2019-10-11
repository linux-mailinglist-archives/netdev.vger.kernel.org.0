Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9C3D3AC5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfJKITL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:19:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfJKITL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 04:19:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1642F3090FD1;
        Fri, 11 Oct 2019 08:19:10 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-241.pek2.redhat.com [10.72.12.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 071B710018F8;
        Fri, 11 Oct 2019 08:18:36 +0000 (UTC)
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
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V3 4/7] mdev: introduce device specific ops
Date:   Fri, 11 Oct 2019 16:15:54 +0800
Message-Id: <20191011081557.28302-5-jasowang@redhat.com>
In-Reply-To: <20191011081557.28302-1-jasowang@redhat.com>
References: <20191011081557.28302-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 11 Oct 2019 08:19:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, except for the create and remove, the rest of
mdev_parent_ops is designed for vfio-mdev driver only and may not help
for kernel mdev driver. With the help of class id, this patch
introduces device specific callbacks inside mdev_device
structure. This allows different set of callback to be used by
vfio-mdev and virtio-mdev.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 .../driver-api/vfio-mediated-device.rst       | 22 +++++---
 MAINTAINERS                                   |  1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 ++++---
 drivers/s390/cio/vfio_ccw_ops.c               | 18 ++++---
 drivers/s390/crypto/vfio_ap_ops.c             | 14 +++--
 drivers/vfio/mdev/mdev_core.c                 |  9 +++-
 drivers/vfio/mdev/mdev_private.h              |  1 +
 drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
 include/linux/mdev.h                          | 42 +++------------
 include/linux/vfio_mdev.h                     | 52 +++++++++++++++++++
 samples/vfio-mdev/mbochs.c                    | 20 ++++---
 samples/vfio-mdev/mdpy.c                      | 21 +++++---
 samples/vfio-mdev/mtty.c                      | 18 ++++---
 13 files changed, 177 insertions(+), 96 deletions(-)
 create mode 100644 include/linux/vfio_mdev.h

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 2035e48da7b2..553574ebba73 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -152,11 +152,20 @@ callbacks per mdev parent device, per mdev type, or any other categorization.
 Vendor drivers are expected to be fully asynchronous in this respect or
 provide their own internal resource protection.)
 
-The callbacks in the mdev_parent_ops structure are as follows:
+In order to support multiple types of device/driver, device needs to
+provide both class_id and device_ops through:
 
-* open: open callback of mediated device
-* close: close callback of mediated device
-* ioctl: ioctl callback of mediated device
+    void mdev_set_class(struct mdev_device *mdev, u16 id, const void *ops);
+
+The class_id is used to be paired with ids in id_table in mdev_driver
+structure for probing the correct driver. The device_ops is device
+specific callbacks which can be get through mdev_get_dev_ops()
+function by mdev bus driver. For vfio-mdev device, its device specific
+ops are as follows:
+
+* open: open callback of vfio mediated device
+* close: close callback of vfio mediated device
+* ioctl: ioctl callback of vfio mediated device
 * read : read emulation callback
 * write: write emulation callback
 * mmap: mmap emulation callback
@@ -167,9 +176,10 @@ register itself with the mdev core driver::
 	extern int  mdev_register_device(struct device *dev,
 	                                 const struct mdev_parent_ops *ops);
 
-It is also required to specify the class_id through::
+It is also required to specify the class_id and device specific ops through::
 
-	extern int mdev_set_class(struct device *dev, u16 id);
+	extern int mdev_set_class(struct device *dev, u16 id,
+	                          const void *ops);
 
 However, the mdev_parent_ops structure is not required in the function call
 that a driver should use to unregister itself with the mdev core driver::
diff --git a/MAINTAINERS b/MAINTAINERS
index 8824f61cd2c0..3d196a023b5e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17127,6 +17127,7 @@ S:	Maintained
 F:	Documentation/driver-api/vfio-mediated-device.rst
 F:	drivers/vfio/mdev/
 F:	include/linux/mdev.h
+F:	include/linux/vfio_mdev.h
 F:	samples/vfio-mdev/
 
 VFIO PLATFORM DRIVER
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 17e9d4634c84..7e2b720074fd 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -42,6 +42,7 @@
 #include <linux/kvm_host.h>
 #include <linux/vfio.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 #include <linux/debugfs.h>
 
 #include <linux/nospec.h>
@@ -643,6 +644,8 @@ static void kvmgt_put_vfio_device(void *vgpu)
 	vfio_device_put(((struct intel_vgpu *)vgpu)->vdev.vfio_device);
 }
 
+static const struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops;
+
 static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct intel_vgpu *vgpu = NULL;
@@ -678,7 +681,7 @@ static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
 		     dev_name(mdev_dev(mdev)));
 	ret = 0;
 
-	mdev_set_class(mdev, MDEV_ID_VFIO);
+	mdev_set_class(mdev, MDEV_ID_VFIO, &intel_vfio_vgpu_dev_ops);
 out:
 	return ret;
 }
@@ -1599,20 +1602,21 @@ static const struct attribute_group *intel_vgpu_groups[] = {
 	NULL,
 };
 
-static struct mdev_parent_ops intel_vgpu_ops = {
-	.mdev_attr_groups       = intel_vgpu_groups,
-	.create			= intel_vgpu_create,
-	.remove			= intel_vgpu_remove,
-
+static const struct vfio_mdev_device_ops intel_vfio_vgpu_dev_ops = {
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
+};
+
 static int kvmgt_host_init(struct device *dev, void *gvt, const void *ops)
 {
 	struct attribute **kvm_type_attrs;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index b5d223882c6c..322991f0feb0 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -12,6 +12,7 @@
 
 #include <linux/vfio.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 #include <linux/nospec.h>
 #include <linux/slab.h>
 
@@ -110,6 +111,8 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_mdev_device_ops vfio_mdev_ops;
+
 static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private =
@@ -129,7 +132,7 @@ static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
-	mdev_set_class(mdev, MDEV_ID_VFIO);
+	mdev_set_class(mdev, MDEV_ID_VFIO, &vfio_mdev_ops);
 	return 0;
 }
 
@@ -575,11 +578,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 	}
 }
 
-static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
-	.owner			= THIS_MODULE,
-	.supported_type_groups  = mdev_type_groups,
-	.create			= vfio_ccw_mdev_create,
-	.remove			= vfio_ccw_mdev_remove,
+static const struct vfio_mdev_device_ops vfio_mdev_ops = {
 	.open			= vfio_ccw_mdev_open,
 	.release		= vfio_ccw_mdev_release,
 	.read			= vfio_ccw_mdev_read,
@@ -587,6 +586,13 @@ static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
 	.ioctl			= vfio_ccw_mdev_ioctl,
 };
 
+static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
+	.owner			= THIS_MODULE,
+	.supported_type_groups  = mdev_type_groups,
+	.create			= vfio_ccw_mdev_create,
+	.remove			= vfio_ccw_mdev_remove,
+};
+
 int vfio_ccw_mdev_reg(struct subchannel *sch)
 {
 	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 47df1c593c35..e9bd5f3b1cc2 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -16,6 +16,7 @@
 #include <linux/bitops.h>
 #include <linux/kvm_host.h>
 #include <linux/module.h>
+#include <linux/vfio_mdev.h>
 #include <asm/kvm.h>
 #include <asm/zcrypt.h>
 
@@ -321,6 +322,8 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static const struct vfio_mdev_device_ops vfio_mdev_ops;
+
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
@@ -343,7 +346,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 	mutex_unlock(&matrix_dev->lock);
 
-	mdev_set_class(mdev, MDEV_ID_VFIO);
+	mdev_set_class(mdev, MDEV_ID_VFIO, &vfio_mdev_ops);
 	return 0;
 }
 
@@ -1281,15 +1284,18 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 	return ret;
 }
 
+static const struct vfio_mdev_device_ops vfio_mdev_ops = {
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
 };
 
 int vfio_ap_mdev_register(void)
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 724e9b9841d8..c79d0e16522b 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -45,12 +45,19 @@ void mdev_set_drvdata(struct mdev_device *mdev, void *data)
 }
 EXPORT_SYMBOL(mdev_set_drvdata);
 
-void mdev_set_class(struct mdev_device *mdev, u16 id)
+void mdev_set_class(struct mdev_device *mdev, u16 id, const void *ops)
 {
 	mdev->class_id = id;
+	mdev->device_ops = ops;
 }
 EXPORT_SYMBOL(mdev_set_class);
 
+const void *mdev_get_dev_ops(struct mdev_device *mdev)
+{
+	return mdev->device_ops;
+}
+EXPORT_SYMBOL(mdev_get_dev_ops);
+
 struct device *mdev_dev(struct mdev_device *mdev)
 {
 	return &mdev->dev;
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index c65f436c1869..b666805f0b1f 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -34,6 +34,7 @@ struct mdev_device {
 	struct device *iommu_device;
 	bool active;
 	u16 class_id;
+	const void *device_ops;
 };
 
 #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 891cf83a2d9a..95efa054442f 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/vfio.h>
 #include <linux/mdev.h>
+#include <linux/vfio_mdev.h>
 
 #include "mdev_private.h"
 
@@ -24,16 +25,16 @@
 static int vfio_mdev_open(void *device_data)
 {
 	struct mdev_device *mdev = device_data;
-	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
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
 
@@ -43,10 +44,10 @@ static int vfio_mdev_open(void *device_data)
 static void vfio_mdev_release(void *device_data)
 {
 	struct mdev_device *mdev = device_data;
-	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
 
-	if (likely(parent->ops->release))
-		parent->ops->release(mdev);
+	if (likely(ops->release))
+		ops->release(mdev);
 
 	module_put(THIS_MODULE);
 }
@@ -55,47 +56,47 @@ static long vfio_mdev_unlocked_ioctl(void *device_data,
 				     unsigned int cmd, unsigned long arg)
 {
 	struct mdev_device *mdev = device_data;
-	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
 
-	if (unlikely(!parent->ops->ioctl))
+	if (unlikely(!ops->ioctl))
 		return -EINVAL;
 
-	return parent->ops->ioctl(mdev, cmd, arg);
+	return ops->ioctl(mdev, cmd, arg);
 }
 
 static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	struct mdev_device *mdev = device_data;
-	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
 
-	if (unlikely(!parent->ops->read))
+	if (unlikely(!ops->read))
 		return -EINVAL;
 
-	return parent->ops->read(mdev, buf, count, ppos);
+	return ops->read(mdev, buf, count, ppos);
 }
 
 static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
 			       size_t count, loff_t *ppos)
 {
 	struct mdev_device *mdev = device_data;
-	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
 
-	if (unlikely(!parent->ops->write))
+	if (unlikely(!ops->write))
 		return -EINVAL;
 
-	return parent->ops->write(mdev, buf, count, ppos);
+	return ops->write(mdev, buf, count, ppos);
 }
 
 static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct mdev_device *mdev = device_data;
-	struct mdev_parent *parent = mdev->parent;
+	const struct vfio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
 
-	if (unlikely(!parent->ops->mmap))
+	if (unlikely(!ops->mmap))
 		return -EINVAL;
 
-	return parent->ops->mmap(mdev, vma);
+	return ops->mmap(mdev, vma);
 }
 
 static const struct vfio_device_ops vfio_mdev_dev_ops = {
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index a7570cf13ba4..f491308674e5 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -10,6 +10,11 @@
 #ifndef MDEV_H
 #define MDEV_H
 
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/mdev.h>
+#include <uapi/linux/uuid.h>
+
 struct mdev_device;
 
 /*
@@ -48,30 +53,7 @@ struct device *mdev_get_iommu_device(struct device *dev);
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
+ *
  * Parent device that support mediated device should be registered with mdev
  * module with mdev_parent_ops structure.
  **/
@@ -83,15 +65,6 @@ struct mdev_parent_ops {
 
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
 };
 
 /* interface for exporting mdev supported type attributes */
@@ -133,7 +106,8 @@ struct mdev_driver {
 
 void *mdev_get_drvdata(struct mdev_device *mdev);
 void mdev_set_drvdata(struct mdev_device *mdev, void *data);
-void mdev_set_class(struct mdev_device *mdev, u16 id);
+void mdev_set_class(struct mdev_device *mdev, u16 id, const void *ops);
+const void *mdev_get_dev_ops(struct mdev_device *mdev);
 const guid_t *mdev_uuid(struct mdev_device *mdev);
 
 extern struct bus_type mdev_bus_type;
diff --git a/include/linux/vfio_mdev.h b/include/linux/vfio_mdev.h
new file mode 100644
index 000000000000..3907c5371c2b
--- /dev/null
+++ b/include/linux/vfio_mdev.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * VFIO Mediated device definition
+ */
+
+#ifndef VFIO_MDEV_H
+#define VFIO_MDEV_H
+
+#include <linux/mdev.h>
+
+/**
+ * struct vfio_mdev_device_ops - Structure to be registered for each
+ * mdev device to register the device to vfio-mdev module.
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
+struct vfio_mdev_device_ops {
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
index fd8491e58fe2..9db771ed5e4b 100644
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
@@ -516,6 +517,8 @@ static int mbochs_reset(struct mdev_device *mdev)
 	return 0;
 }
 
+static const struct vfio_mdev_device_ops vfio_mdev_ops;
+
 static int mbochs_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	const struct mbochs_type *type = mbochs_find_type(kobj);
@@ -561,7 +564,7 @@ static int mbochs_create(struct kobject *kobj, struct mdev_device *mdev)
 	mbochs_reset(mdev);
 
 	mbochs_used_mbytes += type->mbytes;
-	mdev_set_class(mdev, MDEV_ID_VFIO);
+	mdev_set_class(mdev, MDEV_ID_VFIO, &vfio_mdev_ops);
 	return 0;
 
 err_mem:
@@ -1419,12 +1422,7 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
-static const struct mdev_parent_ops mdev_fops = {
-	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
-	.supported_type_groups	= mdev_type_groups,
-	.create			= mbochs_create,
-	.remove			= mbochs_remove,
+static const struct vfio_mdev_device_ops vfio_mdev_ops = {
 	.open			= mbochs_open,
 	.release		= mbochs_close,
 	.read			= mbochs_read,
@@ -1433,6 +1431,14 @@ static const struct mdev_parent_ops mdev_fops = {
 	.mmap			= mbochs_mmap,
 };
 
+static const struct mdev_parent_ops mdev_fops = {
+	.owner			= THIS_MODULE,
+	.mdev_attr_groups	= mdev_dev_groups,
+	.supported_type_groups	= mdev_type_groups,
+	.create			= mbochs_create,
+	.remove			= mbochs_remove,
+};
+
 static const struct file_operations vd_fops = {
 	.owner		= THIS_MODULE,
 };
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 889472b06708..f0fdbc6ec706 100644
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
@@ -226,6 +227,8 @@ static int mdpy_reset(struct mdev_device *mdev)
 	return 0;
 }
 
+static const struct vfio_mdev_device_ops vfio_mdev_ops;
+
 static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	const struct mdpy_type *type = mdpy_find_type(kobj);
@@ -269,7 +272,8 @@ static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 	mdpy_reset(mdev);
 
 	mdpy_count++;
-	mdev_set_class(mdev, MDEV_ID_VFIO);
+
+	mdev_set_class(mdev, MDEV_ID_VFIO, &vfio_mdev_ops);
 	return 0;
 }
 
@@ -726,12 +730,7 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
-static const struct mdev_parent_ops mdev_fops = {
-	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
-	.supported_type_groups	= mdev_type_groups,
-	.create			= mdpy_create,
-	.remove			= mdpy_remove,
+static const struct vfio_mdev_device_ops vfio_mdev_ops = {
 	.open			= mdpy_open,
 	.release		= mdpy_close,
 	.read			= mdpy_read,
@@ -740,6 +739,14 @@ static const struct mdev_parent_ops mdev_fops = {
 	.mmap			= mdpy_mmap,
 };
 
+static const struct mdev_parent_ops mdev_fops = {
+	.owner			= THIS_MODULE,
+	.mdev_attr_groups	= mdev_dev_groups,
+	.supported_type_groups	= mdev_type_groups,
+	.create			= mdpy_create,
+	.remove			= mdpy_remove,
+};
+
 static const struct file_operations vd_fops = {
 	.owner		= THIS_MODULE,
 };
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 618810ca4331..18d0f83a228a 100644
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
@@ -708,6 +709,8 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
 	return ret;
 }
 
+static const struct vfio_mdev_device_ops vfio_dev_ops;
+
 static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state;
@@ -755,7 +758,7 @@ static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
 	list_add(&mdev_state->next, &mdev_devices_list);
 	mutex_unlock(&mdev_list_lock);
 
-	mdev_set_class(mdev, MDEV_ID_VFIO);
+	mdev_set_class(mdev, MDEV_ID_VFIO, &vfio_dev_ops);
 	return 0;
 }
 
@@ -1388,6 +1391,14 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_mdev_device_ops vfio_dev_ops = {
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
@@ -1395,11 +1406,6 @@ static const struct mdev_parent_ops mdev_fops = {
 	.supported_type_groups  = mdev_type_groups,
 	.create                 = mtty_create,
 	.remove			= mtty_remove,
-	.open                   = mtty_open,
-	.release                = mtty_close,
-	.read                   = mtty_read,
-	.write                  = mtty_write,
-	.ioctl		        = mtty_ioctl,
 };
 
 static void mtty_device_release(struct device *dev)
-- 
2.19.1

