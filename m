Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77009F9E7
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfH1Fkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:40:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:51848 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbfH1Fkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 01:40:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 22:40:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="185513640"
Received: from dpdk-virtio-tbie-2.sh.intel.com ([10.67.104.71])
  by orsmga006.jf.intel.com with ESMTP; 27 Aug 2019 22:40:36 -0700
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com, tiwei.bie@intel.com
Subject: [RFC v3] vhost: introduce mdev based hardware vhost backend
Date:   Wed, 28 Aug 2019 13:37:12 +0800
Message-Id: <20190828053712.26106-1-tiwei.bie@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Details about this can be found here:

https://lwn.net/Articles/750770/

What's new in this version
==========================

There are three choices based on the discussion [1] in RFC v2:

> #1. We expose a VFIO device, so we can reuse the VFIO container/group
>     based DMA API and potentially reuse a lot of VFIO code in QEMU.
>
>     But in this case, we have two choices for the VFIO device interface
>     (i.e. the interface on top of VFIO device fd):
>
>     A) we may invent a new vhost protocol (as demonstrated by the code
>        in this RFC) on VFIO device fd to make it work in VFIO's way,
>        i.e. regions and irqs.
>
>     B) Or as you proposed, instead of inventing a new vhost protocol,
>        we can reuse most existing vhost ioctls on the VFIO device fd
>        directly. There should be no conflicts between the VFIO ioctls
>        (type is 0x3B) and VHOST ioctls (type is 0xAF) currently.
>
> #2. Instead of exposing a VFIO device, we may expose a VHOST device.
>     And we will introduce a new mdev driver vhost-mdev to do this.
>     It would be natural to reuse the existing kernel vhost interface
>     (ioctls) on it as much as possible. But we will need to invent
>     some APIs for DMA programming (reusing VHOST_SET_MEM_TABLE is a
>     choice, but it's too heavy and doesn't support vIOMMU by itself).

This version is more like a quick PoC to try Jason's proposal on
reusing vhost ioctls. And the second way (#1/B) in above three
choices was chosen in this version to demonstrate the idea quickly.

Now the userspace API looks like this:

- VFIO's container/group based IOMMU API is used to do the
  DMA programming.

- Vhost's existing ioctls are used to setup the device.

And the device will report device_api as "vfio-vhost".

Note that, there are dirty hacks in this version. If we decide to
go this way, some refactoring in vhost.c/vhost.h may be needed.

PS. The direct mapping of the notify registers isn't implemented
    in this version.

[1] https://lkml.org/lkml/2019/7/9/101

Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
---
 drivers/vhost/Kconfig      |   9 +
 drivers/vhost/Makefile     |   3 +
 drivers/vhost/mdev.c       | 382 +++++++++++++++++++++++++++++++++++++
 include/linux/vhost_mdev.h |  58 ++++++
 include/uapi/linux/vfio.h  |   2 +
 include/uapi/linux/vhost.h |   8 +
 6 files changed, 462 insertions(+)
 create mode 100644 drivers/vhost/mdev.c
 create mode 100644 include/linux/vhost_mdev.h

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 3d03ccbd1adc..2ba54fcf43b7 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -34,6 +34,15 @@ config VHOST_VSOCK
 	To compile this driver as a module, choose M here: the module will be called
 	vhost_vsock.
 
+config VHOST_MDEV
+	tristate "Hardware vhost accelerator abstraction"
+	depends on EVENTFD && VFIO && VFIO_MDEV
+	select VHOST
+	default n
+	---help---
+	Say Y here to enable the vhost_mdev module
+	for use with hardware vhost accelerators
+
 config VHOST
 	tristate
 	---help---
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index 6c6df24f770c..ad9c0f8c6d8c 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -10,4 +10,7 @@ vhost_vsock-y := vsock.o
 
 obj-$(CONFIG_VHOST_RING) += vringh.o
 
+obj-$(CONFIG_VHOST_MDEV) += vhost_mdev.o
+vhost_mdev-y := mdev.o
+
 obj-$(CONFIG_VHOST)	+= vhost.o
diff --git a/drivers/vhost/mdev.c b/drivers/vhost/mdev.c
new file mode 100644
index 000000000000..6bef1d9ae2e6
--- /dev/null
+++ b/drivers/vhost/mdev.c
@@ -0,0 +1,382 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018-2019 Intel Corporation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/vfio.h>
+#include <linux/vhost.h>
+#include <linux/mdev.h>
+#include <linux/vhost_mdev.h>
+
+#include "vhost.h"
+
+struct vhost_mdev {
+	struct vhost_dev dev;
+	bool opened;
+	int nvqs;
+	u64 state;
+	u64 acked_features;
+	u64 features;
+	const struct vhost_mdev_device_ops *ops;
+	struct mdev_device *mdev;
+	void *private;
+	struct vhost_virtqueue vqs[];
+};
+
+static void handle_vq_kick(struct vhost_work *work)
+{
+	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
+						  poll.work);
+	struct vhost_mdev *vdpa = container_of(vq->dev, struct vhost_mdev, dev);
+
+	vdpa->ops->notify(vdpa, vq - vdpa->vqs);
+}
+
+static int vhost_set_state(struct vhost_mdev *vdpa, u64 __user *statep)
+{
+	u64 state;
+
+	if (copy_from_user(&state, statep, sizeof(state)))
+		return -EFAULT;
+
+	if (state >= VHOST_MDEV_S_MAX)
+		return -EINVAL;
+
+	if (vdpa->state == state)
+		return 0;
+
+	mutex_lock(&vdpa->dev.mutex);
+
+	vdpa->state = state;
+
+	switch (vdpa->state) {
+	case VHOST_MDEV_S_RUNNING:
+		vdpa->ops->start(vdpa);
+		break;
+	case VHOST_MDEV_S_STOPPED:
+		vdpa->ops->stop(vdpa);
+		break;
+	}
+
+	mutex_unlock(&vdpa->dev.mutex);
+
+	return 0;
+}
+
+static int vhost_set_features(struct vhost_mdev *vdpa, u64 __user *featurep)
+{
+	u64 features;
+
+	if (copy_from_user(&features, featurep, sizeof(features)))
+		return -EFAULT;
+
+	if (features & ~vdpa->features)
+		return -EINVAL;
+
+	vdpa->acked_features = features;
+	vdpa->ops->features_changed(vdpa);
+	return 0;
+}
+
+static int vhost_get_features(struct vhost_mdev *vdpa, u64 __user *featurep)
+{
+	if (copy_to_user(featurep, &vdpa->features, sizeof(vdpa->features)))
+		return -EFAULT;
+	return 0;
+}
+
+static int vhost_get_vring_base(struct vhost_mdev *vdpa, void __user *argp)
+{
+	struct vhost_virtqueue *vq;
+	u32 idx;
+	int r;
+
+	r = get_user(idx, (u32 __user *)argp);
+	if (r < 0)
+		return r;
+
+	vq = &vdpa->vqs[idx];
+	vq->last_avail_idx = vdpa->ops->get_vring_base(vdpa, idx);
+
+	return vhost_vring_ioctl(&vdpa->dev, VHOST_GET_VRING_BASE, argp);
+}
+
+/*
+ * Helpers for backend to register mdev.
+ */
+
+struct vhost_mdev *vhost_mdev_alloc(struct mdev_device *mdev, void *private,
+				    int nvqs)
+{
+	struct vhost_mdev *vdpa;
+	struct vhost_dev *dev;
+	struct vhost_virtqueue **vqs;
+	size_t size;
+	int i;
+
+	size = sizeof(struct vhost_mdev) + nvqs * sizeof(struct vhost_virtqueue);
+
+	vdpa = kzalloc(size, GFP_KERNEL);
+	if (!vdpa)
+		return NULL;
+
+	vdpa->nvqs = nvqs;
+
+	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
+	if (!vqs) {
+		kfree(vdpa);
+		return NULL;
+	}
+
+	dev = &vdpa->dev;
+	for (i = 0; i < nvqs; i++) {
+		vqs[i] = &vdpa->vqs[i];
+		vqs[i]->handle_kick = handle_vq_kick;
+	}
+	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0);
+
+	vdpa->private = private;
+	vdpa->mdev = mdev;
+
+	mdev_set_drvdata(mdev, vdpa);
+
+	return vdpa;
+}
+EXPORT_SYMBOL(vhost_mdev_alloc);
+
+void vhost_mdev_free(struct vhost_mdev *vdpa)
+{
+	struct mdev_device *mdev;
+
+	mdev = vdpa->mdev;
+	mdev_set_drvdata(mdev, NULL);
+
+	vhost_dev_stop(&vdpa->dev);
+	vhost_dev_cleanup(&vdpa->dev);
+	kfree(vdpa->dev.vqs);
+	kfree(vdpa);
+}
+EXPORT_SYMBOL(vhost_mdev_free);
+
+ssize_t vhost_mdev_read(struct mdev_device *mdev, char __user *buf,
+		  size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vhost_mdev_read);
+
+
+ssize_t vhost_mdev_write(struct mdev_device *mdev, const char __user *buf,
+		   size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vhost_mdev_write);
+
+int vhost_mdev_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+{
+	// TODO
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vhost_mdev_mmap);
+
+long vhost_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd,
+		      unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct vhost_mdev *vdpa;
+	unsigned long minsz;
+	int ret = 0;
+
+	if (!mdev)
+		return -EINVAL;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+	{
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		if (info.argsz < minsz) {
+			ret = -EINVAL;
+			break;
+		}
+
+		info.flags = VFIO_DEVICE_FLAGS_VHOST;
+		info.num_regions = 0;
+		info.num_irqs = 0;
+
+		if (copy_to_user((void __user *)arg, &info, minsz)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		break;
+	}
+	case VFIO_DEVICE_GET_REGION_INFO:
+	case VFIO_DEVICE_GET_IRQ_INFO:
+	case VFIO_DEVICE_SET_IRQS:
+	case VFIO_DEVICE_RESET:
+		ret = -EINVAL;
+		break;
+
+	case VHOST_MDEV_SET_STATE:
+		ret = vhost_set_state(vdpa, argp);
+		break;
+	case VHOST_GET_FEATURES:
+		ret = vhost_get_features(vdpa, argp);
+		break;
+	case VHOST_SET_FEATURES:
+		ret = vhost_set_features(vdpa, argp);
+		break;
+	case VHOST_GET_VRING_BASE:
+		ret = vhost_get_vring_base(vdpa, argp);
+		break;
+	default:
+		ret = vhost_dev_ioctl(&vdpa->dev, cmd, argp);
+		if (ret == -ENOIOCTLCMD)
+			ret = vhost_vring_ioctl(&vdpa->dev, cmd, argp);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(vhost_mdev_ioctl);
+
+int vhost_mdev_open(struct mdev_device *mdev)
+{
+	struct vhost_mdev *vdpa;
+	int ret = 0;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	mutex_lock(&vdpa->dev.mutex);
+
+	if (vdpa->opened)
+		ret = -EBUSY;
+	else
+		vdpa->opened = true;
+
+	mutex_unlock(&vdpa->dev.mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(vhost_mdev_open);
+
+void vhost_mdev_close(struct mdev_device *mdev)
+{
+	struct vhost_mdev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+
+	mutex_lock(&vdpa->dev.mutex);
+
+	vhost_dev_stop(&vdpa->dev);
+	vhost_dev_cleanup(&vdpa->dev);
+
+	vdpa->opened = false;
+	mutex_unlock(&vdpa->dev.mutex);
+}
+EXPORT_SYMBOL(vhost_mdev_close);
+
+/*
+ * Helpers for backend to set/get information.
+ */
+
+int vhost_mdev_set_device_ops(struct vhost_mdev *vdpa,
+			      const struct vhost_mdev_device_ops *ops)
+{
+	vdpa->ops = ops;
+	return 0;
+}
+EXPORT_SYMBOL(vhost_mdev_set_device_ops);
+
+int vhost_mdev_set_features(struct vhost_mdev *vdpa, u64 features)
+{
+	vdpa->features = features;
+	return 0;
+}
+EXPORT_SYMBOL(vhost_mdev_set_features);
+
+struct eventfd_ctx *
+vhost_mdev_get_call_ctx(struct vhost_mdev *vdpa, int queue_id)
+{
+	return vdpa->vqs[queue_id].call_ctx;
+}
+EXPORT_SYMBOL(vhost_mdev_get_call_ctx);
+
+int vhost_mdev_get_acked_features(struct vhost_mdev *vdpa, u64 *features)
+{
+	*features = vdpa->acked_features;
+	return 0;
+}
+EXPORT_SYMBOL(vhost_mdev_get_acked_features);
+
+int vhost_mdev_get_vring_num(struct vhost_mdev *vdpa, int queue_id, u16 *num)
+{
+	*num = vdpa->vqs[queue_id].num;
+	return 0;
+}
+EXPORT_SYMBOL(vhost_mdev_get_vring_num);
+
+int vhost_mdev_get_vring_base(struct vhost_mdev *vdpa, int queue_id, u16 *base)
+{
+	*base = vdpa->vqs[queue_id].last_avail_idx;
+	return 0;
+}
+EXPORT_SYMBOL(vhost_mdev_get_vring_base);
+
+int vhost_mdev_get_vring_addr(struct vhost_mdev *vdpa, int queue_id,
+			      struct vhost_vring_addr *addr)
+{
+	struct vhost_virtqueue *vq = &vdpa->vqs[queue_id];
+
+	/*
+	 * XXX: we need userspace to pass guest physical address or
+	 *      IOVA directly.
+	 */
+	addr->flags = vq->log_used ? (0x1 << VHOST_VRING_F_LOG) : 0;
+	addr->desc_user_addr = (__u64)vq->desc;
+	addr->avail_user_addr = (__u64)vq->avail;
+	addr->used_user_addr = (__u64)vq->used;
+	addr->log_guest_addr = (__u64)vq->log_addr;
+	return 0;
+}
+EXPORT_SYMBOL(vhost_mdev_get_vring_addr);
+
+int vhost_mdev_get_log_base(struct vhost_mdev *vdpa, int queue_id,
+			    void **log_base, u64 *log_size)
+{
+	// TODO
+	return 0;
+}
+EXPORT_SYMBOL(vhost_mdev_get_log_base);
+
+struct mdev_device *vhost_mdev_get_mdev(struct vhost_mdev *vdpa)
+{
+	return vdpa->mdev;
+}
+EXPORT_SYMBOL(vhost_mdev_get_mdev);
+
+void *vhost_mdev_get_private(struct vhost_mdev *vdpa)
+{
+	return vdpa->private;
+}
+EXPORT_SYMBOL(vhost_mdev_get_private);
+
+MODULE_VERSION("0.0.0");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Hardware vhost accelerator abstraction");
diff --git a/include/linux/vhost_mdev.h b/include/linux/vhost_mdev.h
new file mode 100644
index 000000000000..070787ce6b36
--- /dev/null
+++ b/include/linux/vhost_mdev.h
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018-2019 Intel Corporation.
+ */
+
+#ifndef _VHOST_MDEV_H
+#define _VHOST_MDEV_H
+
+struct mdev_device;
+struct vhost_mdev;
+
+typedef int (*vhost_mdev_start_device_t)(struct vhost_mdev *vdpa);
+typedef int (*vhost_mdev_stop_device_t)(struct vhost_mdev *vdpa);
+typedef int (*vhost_mdev_set_features_t)(struct vhost_mdev *vdpa);
+typedef void (*vhost_mdev_notify_device_t)(struct vhost_mdev *vdpa, int queue_id);
+typedef u64 (*vhost_mdev_get_notify_addr_t)(struct vhost_mdev *vdpa, int queue_id);
+typedef u16 (*vhost_mdev_get_vring_base_t)(struct vhost_mdev *vdpa, int queue_id);
+typedef void (*vhost_mdev_features_changed_t)(struct vhost_mdev *vdpa);
+
+struct vhost_mdev_device_ops {
+	vhost_mdev_start_device_t	start;
+	vhost_mdev_stop_device_t	stop;
+	vhost_mdev_notify_device_t	notify;
+	vhost_mdev_get_notify_addr_t	get_notify_addr;
+	vhost_mdev_get_vring_base_t	get_vring_base;
+	vhost_mdev_features_changed_t	features_changed;
+};
+
+struct vhost_mdev *vhost_mdev_alloc(struct mdev_device *mdev,
+		void *private, int nvqs);
+void vhost_mdev_free(struct vhost_mdev *vdpa);
+
+ssize_t vhost_mdev_read(struct mdev_device *mdev, char __user *buf,
+		size_t count, loff_t *ppos);
+ssize_t vhost_mdev_write(struct mdev_device *mdev, const char __user *buf,
+		size_t count, loff_t *ppos);
+long vhost_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd,
+		unsigned long arg);
+int vhost_mdev_mmap(struct mdev_device *mdev, struct vm_area_struct *vma);
+int vhost_mdev_open(struct mdev_device *mdev);
+void vhost_mdev_close(struct mdev_device *mdev);
+
+int vhost_mdev_set_device_ops(struct vhost_mdev *vdpa,
+		const struct vhost_mdev_device_ops *ops);
+int vhost_mdev_set_features(struct vhost_mdev *vdpa, u64 features);
+struct eventfd_ctx *vhost_mdev_get_call_ctx(struct vhost_mdev *vdpa,
+		int queue_id);
+int vhost_mdev_get_acked_features(struct vhost_mdev *vdpa, u64 *features);
+int vhost_mdev_get_vring_num(struct vhost_mdev *vdpa, int queue_id, u16 *num);
+int vhost_mdev_get_vring_base(struct vhost_mdev *vdpa, int queue_id, u16 *base);
+int vhost_mdev_get_vring_addr(struct vhost_mdev *vdpa, int queue_id,
+		struct vhost_vring_addr *addr);
+int vhost_mdev_get_log_base(struct vhost_mdev *vdpa, int queue_id,
+		void **log_base, u64 *log_size);
+struct mdev_device *vhost_mdev_get_mdev(struct vhost_mdev *vdpa);
+void *vhost_mdev_get_private(struct vhost_mdev *vdpa);
+
+#endif /* _VHOST_MDEV_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8f10748dac79..0300d6831cc5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -201,6 +201,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
 #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
+#define VFIO_DEVICE_FLAGS_VHOST	(1 << 6)	/* vfio-vhost device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
@@ -217,6 +218,7 @@ struct vfio_device_info {
 #define VFIO_DEVICE_API_AMBA_STRING		"vfio-amba"
 #define VFIO_DEVICE_API_CCW_STRING		"vfio-ccw"
 #define VFIO_DEVICE_API_AP_STRING		"vfio-ap"
+#define VFIO_DEVICE_API_VHOST_STRING		"vfio-vhost"
 
 /**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 40d028eed645..5afbc2f08fa3 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -116,4 +116,12 @@
 #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
 #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
 
+/* VHOST_MDEV specific defines */
+
+#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
+
+#define VHOST_MDEV_S_STOPPED	0
+#define VHOST_MDEV_S_RUNNING	1
+#define VHOST_MDEV_S_MAX	2
+
 #endif
-- 
2.17.1

