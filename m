Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6C6AE560
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436508AbfIJIUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:20:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbfIJIUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 04:20:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64A4C7F745;
        Tue, 10 Sep 2019 08:20:33 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90AD76061E;
        Tue, 10 Sep 2019 08:20:25 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, cohuck@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com, idos@mellanox.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com
Subject: [RFC PATCH 3/4] virtio: introudce a mdev based transport
Date:   Tue, 10 Sep 2019 16:19:34 +0800
Message-Id: <20190910081935.30516-4-jasowang@redhat.com>
In-Reply-To: <20190910081935.30516-1-jasowang@redhat.com>
References: <20190910081935.30516-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Tue, 10 Sep 2019 08:20:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This path introduces a new mdev transport for virtio. This is used to
use kernel virtio driver to drive the mediated device that is capable
of populating virtqueue directly.

A new virtio-mdev driver will be registered to the mdev bus, when a
new virtio-mdev device is probed, it will register the device with
mdev based config ops. This means, unlike the exist hardware
transport, this is a software transport between mdev driver and mdev
device. The transport was implemented through:

- configuration access was implemented through parent_ops->read()/write()
- vq/config callback was implemented through parent_ops->ioctl()

This transport is derived from virtio MMIO protocol and was wrote for
kernel driver. But for the transport itself, but the design goal is to
be generic enough to support userspace driver (this part will be added
in the future).

Note:
- current mdev assume all the parameter of parent_ops was from
  userspace. This prevents us from implementing the kernel mdev
  driver. For a quick POC, this patch just abuse those parameter and
  assume the mdev device implementation will treat them as kernel
  pointer. This should be addressed in the formal series by extending
  mdev_parent_ops.
- for a quick POC, I just drive the transport from MMIO, I'm pretty
  there's lot of optimization space for this.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vfio/mdev/Kconfig        |   7 +
 drivers/vfio/mdev/Makefile       |   1 +
 drivers/vfio/mdev/virtio_mdev.c  | 500 +++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_mdev.h | 131 ++++++++
 4 files changed, 639 insertions(+)
 create mode 100644 drivers/vfio/mdev/virtio_mdev.c
 create mode 100644 include/uapi/linux/virtio_mdev.h

diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 5da27f2100f9..c488c31fc137 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -16,3 +16,10 @@ config VFIO_MDEV_DEVICE
 	default n
 	help
 	  VFIO based driver for Mediated devices.
+
+config VIRTIO_MDEV_DEVICE
+	tristate "VIRTIO driver for Mediated devices"
+	depends on VFIO_MDEV && VIRTIO
+	default n
+	help
+	  VIRTIO based driver for Mediated devices.
diff --git a/drivers/vfio/mdev/Makefile b/drivers/vfio/mdev/Makefile
index 101516fdf375..99d31e29c23e 100644
--- a/drivers/vfio/mdev/Makefile
+++ b/drivers/vfio/mdev/Makefile
@@ -4,3 +4,4 @@ mdev-y := mdev_core.o mdev_sysfs.o mdev_driver.o
 
 obj-$(CONFIG_VFIO_MDEV) += mdev.o
 obj-$(CONFIG_VFIO_MDEV_DEVICE) += vfio_mdev.o
+obj-$(CONFIG_VIRTIO_MDEV_DEVICE) += virtio_mdev.o
diff --git a/drivers/vfio/mdev/virtio_mdev.c b/drivers/vfio/mdev/virtio_mdev.c
new file mode 100644
index 000000000000..5ff09089297e
--- /dev/null
+++ b/drivers/vfio/mdev/virtio_mdev.c
@@ -0,0 +1,500 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VIRTIO based driver for Mediated device
+ *
+ * Copyright (c) 2019, Red Hat. All rights reserved.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ *
+ * Based on Virtio MMIO driver.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/uuid.h>
+#include <linux/mdev.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
+#include <uapi/linux/virtio_mdev.h>
+#include "mdev_private.h"
+
+#define DRIVER_VERSION  "0.1"
+#define DRIVER_AUTHOR   "Red Hat Corporation"
+#define DRIVER_DESC     "VIRTIO based driver for Mediated device"
+
+#define to_virtio_mdev_device(dev) \
+	container_of(dev, struct virtio_mdev_device, vdev)
+
+struct virtio_mdev_device {
+	struct virtio_device vdev;
+	struct mdev_device *mdev;
+	unsigned long version;
+
+	struct virtqueue **vqs;
+	spinlock_t lock;
+};
+
+struct virtio_mdev_vq_info {
+	/* the actual virtqueue */
+	struct virtqueue *vq;
+
+	/* the list node for the virtqueues list */
+	struct list_head node;
+};
+
+static u32 virtio_mdev_readl(struct mdev_device *mdev,
+			     loff_t off)
+{
+	struct mdev_parent *parent = mdev->parent;
+	ssize_t len;
+	u32 val;
+
+	if (unlikely(!parent->ops->read))
+		return 0xFFFFFFFF;
+
+	len = parent->ops->read(mdev, (char *)&val, 4, &off);
+	if (len != 4)
+		return 0xFFFFFFFF;
+
+	return val;
+}
+
+static void virtio_mdev_writel(struct mdev_device *mdev,
+			       loff_t off, u32 val)
+{
+	struct mdev_parent *parent = mdev->parent;
+
+	if (unlikely(!parent->ops->write))
+		return;
+
+	parent->ops->write(mdev, (char *)&val, 4, &off);
+
+	return;
+}
+
+static void virtio_mdev_get(struct virtio_device *vdev, unsigned offset,
+			    void *buf, unsigned len)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+	struct mdev_device *mdev = vm_dev->mdev;
+	struct mdev_parent *parent = mdev->parent;
+
+	loff_t off = offset + VIRTIO_MDEV_CONFIG;
+
+	switch (len) {
+	case 1:
+		*(u8 *)buf = parent->ops->read(mdev, buf, 1, &off);
+		break;
+	case 2:
+		*(u16 *)buf = parent->ops->read(mdev, buf, 2, &off);
+		break;
+	case 4:
+		*(u32 *)buf = parent->ops->read(mdev, buf, 4, &off);
+		break;
+	case 8:
+		*(u32 *)buf = parent->ops->read(mdev, buf, 4, &off);
+		*((u32 *)buf + 1) = parent->ops->read(mdev, buf, 4, &off);
+		break;
+	default:
+		BUG();
+	}
+
+	return;
+}
+
+static void virtio_mdev_set(struct virtio_device *vdev, unsigned offset,
+			    const void *buf, unsigned len)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+	struct mdev_device *mdev = vm_dev->mdev;
+	struct mdev_parent *parent = mdev->parent;
+	loff_t off = offset + VIRTIO_MDEV_CONFIG;
+
+	switch (len) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+		break;
+	default:
+		BUG();
+	}
+
+	parent->ops->write(mdev, buf, len, &off);
+
+	return;
+}
+
+static u32 virtio_mdev_generation(struct virtio_device *vdev)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+
+	if (vm_dev->version == 1)
+		return 0;
+	else
+		return virtio_mdev_readl(vm_dev->mdev,
+					 VIRTIO_MDEV_CONFIG_GENERATION);
+}
+
+static u8 virtio_mdev_get_status(struct virtio_device *vdev)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+
+	return virtio_mdev_readl(vm_dev->mdev, VIRTIO_MDEV_STATUS) & 0xff;
+}
+
+static void virtio_mdev_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_STATUS, status);
+}
+
+static void virtio_mdev_reset(struct virtio_device *vdev)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_STATUS, 0);
+}
+
+static bool virtio_mdev_notify(struct virtqueue *vq)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vq->vdev);
+
+	/* We write the queue's selector into the notification register to
+	 * signal the other end */
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_NOTIFY,
+			   vq->index);
+	return true;
+}
+
+static irqreturn_t virtio_mdev_config_cb(void *private)
+{
+	struct virtio_mdev_device *vm_dev = private;
+
+	virtio_config_changed(&vm_dev->vdev);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t virtio_mdev_virtqueue_cb(void *private)
+{
+	struct virtio_mdev_vq_info *info = private;
+
+	return vring_interrupt(0, info->vq);
+}
+
+static struct virtqueue *
+virtio_mdev_setup_vq(struct virtio_device *vdev, unsigned index,
+		     void (*callback)(struct virtqueue *vq),
+		     const char *name, bool ctx)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+	struct mdev_device *mdev= vm_dev->mdev;
+	struct mdev_parent *parent = mdev->parent;
+	struct virtio_mdev_vq_info *info;
+	struct virtio_mdev_callback cb;
+	struct virtqueue *vq;
+	unsigned long flags;
+	u32 align, num;
+	u64 addr;
+	int err;
+
+	if (!name)
+		return NULL;
+
+	/* Select the queue we're interested in */
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_SEL, index);
+
+	/* Queue shouldn't already be set up. */
+	if (virtio_mdev_readl(vm_dev->mdev, VIRTIO_MDEV_QUEUE_READY)) {
+		err = -ENOENT;
+		goto error_available;
+	}
+
+	/* Allocate and fill out our active queue description */
+	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		err = -ENOMEM;
+		goto error_kmalloc;
+	}
+
+	num = virtio_mdev_readl(vm_dev->mdev, VIRTIO_MDEV_QUEUE_NUM_MAX);
+	if (num == 0) {
+		err = -ENOENT;
+		goto error_new_virtqueue;
+	}
+
+	/* Create the vring */
+	align = virtio_mdev_readl(vm_dev->mdev, VIRTIO_MDEV_QUEUE_ALIGN);
+	vq = vring_create_virtqueue(index, num, align, vdev,
+				    true, true, ctx,
+				    virtio_mdev_notify, callback, name);
+	if (!vq) {
+		err = -ENOMEM;
+		goto error_new_virtqueue;
+	}
+
+	/* Setup virtqueue callback */
+	cb.callback = virtio_mdev_virtqueue_cb;
+	cb.private = info;
+	err = parent->ops->ioctl(mdev, VIRTIO_MDEV_SET_VQ_CALLBACK,
+				 (unsigned long)&cb);
+	if (err) {
+		err = -EINVAL;
+		goto error_callback;
+	}
+
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_NUM,
+			   virtqueue_get_vring_size(vq));
+	addr = virtqueue_get_desc_addr(vq);
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_DESC_LOW, (u32)addr);
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_DESC_HIGH,
+			   (u32)(addr >> 32));
+
+	addr = virtqueue_get_avail_addr(vq);
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_AVAIL_LOW, (u32)addr);
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_AVAIL_HIGH,
+			   (u32)(addr >> 32));
+
+	addr = virtqueue_get_used_addr(vq);
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_USED_LOW, (u32)addr);
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_USED_HIGH, (u32)(addr >> 32));
+
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_READY, 1);
+
+	vq->priv = info;
+	info->vq = vq;
+
+	return vq;
+
+error_callback:
+	vring_del_virtqueue(vq);
+error_new_virtqueue:
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_READY, 0);
+	WARN_ON(virtio_mdev_readl(vm_dev->mdev, VIRTIO_MDEV_QUEUE_READY));
+	kfree(info);
+error_kmalloc:
+error_available:
+	return ERR_PTR(err);
+
+}
+
+static void virtio_mdev_del_vq(struct virtqueue *vq)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vq->vdev);
+	struct virtio_mdev_vq_info *info = vq->priv;
+	unsigned long flags;
+	unsigned int index = vq->index;
+
+	/* Select and deactivate the queue */
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_QUEUE_SEL, index);
+	virtio_mdev_writel(vm_dev->mdev,VIRTIO_MDEV_QUEUE_READY, 0);
+	WARN_ON(virtio_mdev_readl(vm_dev->mdev, VIRTIO_MDEV_QUEUE_READY));
+
+	vring_del_virtqueue(vq);
+
+	kfree(info);
+}
+
+static void virtio_mdev_del_vqs(struct virtio_device *vdev)
+{
+	struct virtqueue *vq, *n;
+
+	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
+		virtio_mdev_del_vq(vq);
+
+	return;
+}
+
+static int virtio_mdev_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+				struct virtqueue *vqs[],
+				vq_callback_t *callbacks[],
+				const char * const names[],
+				const bool *ctx,
+				struct irq_affinity *desc)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+	struct mdev_device *mdev = vm_dev->mdev;
+	struct mdev_parent *parent = mdev->parent;
+	struct virtio_mdev_callback cb;
+	int i, err, queue_idx = 0;
+	vm_dev->vqs = kmalloc_array(queue_idx, sizeof(*vm_dev->vqs),
+				    GFP_KERNEL);
+	if (!vm_dev->vqs)
+		return -ENOMEM;
+
+	for (i = 0; i < nvqs; ++i) {
+		if (!names[i]) {
+			vqs[i] = NULL;
+			continue;
+		}
+
+		vqs[i] = virtio_mdev_setup_vq(vdev, queue_idx++,
+					      callbacks[i], names[i], ctx ?
+					      ctx[i] : false);
+		if (IS_ERR(vqs[i])) {
+			err = PTR_ERR(vqs[i]);
+			goto err_setup_vq;
+		}
+	}
+
+	cb.callback = virtio_mdev_config_cb;
+	cb.private = vm_dev;
+	err = parent->ops->ioctl(mdev, VIRTIO_MDEV_SET_CONFIG_CALLBACK,
+				 (unsigned long)&cb);
+	if (err)
+		goto err_setup_vq;
+
+	return 0;
+
+err_setup_vq:
+	kfree(vm_dev->vqs);
+	virtio_mdev_del_vqs(vdev);
+	return err;
+}
+
+static u64 virtio_mdev_get_features(struct virtio_device *vdev)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+	u64 features;
+
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_DEVICE_FEATURES_SEL, 1);
+	features = virtio_mdev_readl(vm_dev->mdev, VIRTIO_MDEV_DEVICE_FEATURES);
+	features <<= 32;
+
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_DEVICE_FEATURES_SEL, 0);
+	features |= virtio_mdev_readl(vm_dev->mdev, VIRTIO_MDEV_DEVICE_FEATURES);
+
+	return features;
+}
+
+static int virtio_mdev_finalize_features(struct virtio_device *vdev)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_DRIVER_FEATURES_SEL, 1);
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_DRIVER_FEATURES,
+			   (u32)(vdev->features >> 32));
+
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_DRIVER_FEATURES_SEL, 0);
+	virtio_mdev_writel(vm_dev->mdev, VIRTIO_MDEV_DRIVER_FEATURES,
+			   (u32)vdev->features);
+
+	return 0;
+}
+
+static const char *virtio_mdev_bus_name(struct virtio_device *vdev)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+	struct mdev_device *mdev = vm_dev->mdev;
+
+	return dev_name(&mdev->dev);
+}
+
+static const struct virtio_config_ops virtio_mdev_config_ops = {
+	.get		= virtio_mdev_get,
+	.set		= virtio_mdev_set,
+	.generation	= virtio_mdev_generation,
+	.get_status	= virtio_mdev_get_status,
+	.set_status	= virtio_mdev_set_status,
+	.reset		= virtio_mdev_reset,
+	.find_vqs	= virtio_mdev_find_vqs,
+	.del_vqs	= virtio_mdev_del_vqs,
+	.get_features	= virtio_mdev_get_features,
+	.finalize_features = virtio_mdev_finalize_features,
+	.bus_name	= virtio_mdev_bus_name,
+};
+
+static void virtio_mdev_release_dev(struct device *_d)
+{
+	struct virtio_device *vdev =
+	       container_of(_d, struct virtio_device, dev);
+	struct virtio_mdev_device *vm_dev =
+	       container_of(vdev, struct virtio_mdev_device, vdev);
+
+	devm_kfree(_d, vm_dev);
+}
+
+static int virtio_mdev_probe(struct device *dev)
+{
+	struct mdev_device *mdev = to_mdev_device(dev);
+	struct virtio_mdev_device *vm_dev;
+	unsigned long magic;
+	int rc;
+
+	magic = virtio_mdev_readl(mdev, VIRTIO_MDEV_MAGIC_VALUE);
+	if (magic != ('v' | 'i' << 8 | 'r' << 16 | 't' << 24)) {
+		dev_warn(dev, "Wrong magic value 0x%08lx!\n", magic);
+		return -ENODEV;
+	}
+
+	vm_dev = devm_kzalloc(dev, sizeof(*vm_dev), GFP_KERNEL);
+	if (!vm_dev)
+		return -ENOMEM;
+
+	vm_dev->vdev.dev.parent = dev;
+	vm_dev->vdev.dev.release = virtio_mdev_release_dev;
+	vm_dev->vdev.config = &virtio_mdev_config_ops;
+	vm_dev->mdev = mdev;
+	vm_dev->vqs = NULL;
+	spin_lock_init(&vm_dev->lock);
+
+	vm_dev->version = virtio_mdev_readl(mdev, VIRTIO_MDEV_VERSION);
+	if (vm_dev->version != 1) {
+		dev_err(dev, "Version %ld not supported!\n",
+			vm_dev->version);
+		return -ENXIO;
+	}
+
+	vm_dev->vdev.id.device = virtio_mdev_readl(mdev, VIRTIO_MDEV_DEVICE_ID);
+	if (vm_dev->vdev.id.device == 0)
+		return -ENODEV;
+
+	vm_dev->vdev.id.vendor = virtio_mdev_readl(mdev, VIRTIO_MDEV_VENDOR_ID);
+	rc = register_virtio_device(&vm_dev->vdev);
+	if (rc)
+		put_device(dev);
+
+	dev_set_drvdata(dev, vm_dev);
+
+	return rc;
+
+}
+
+static void virtio_mdev_remove(struct device *dev)
+{
+	struct virtio_mdev_device *vm_dev = dev_get_drvdata(dev);
+
+	unregister_virtio_device(&vm_dev->vdev);
+}
+
+static struct mdev_driver virtio_mdev_driver = {
+	.name	= "virtio_mdev",
+	.probe	= virtio_mdev_probe,
+	.remove	= virtio_mdev_remove,
+};
+
+static int __init virtio_mdev_init(void)
+{
+	return mdev_register_driver(&virtio_mdev_driver, THIS_MODULE);
+}
+
+static void __exit virtio_mdev_exit(void)
+{
+	mdev_unregister_driver(&virtio_mdev_driver);
+}
+
+module_init(virtio_mdev_init)
+module_exit(virtio_mdev_exit)
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/uapi/linux/virtio_mdev.h b/include/uapi/linux/virtio_mdev.h
new file mode 100644
index 000000000000..8040de6b960a
--- /dev/null
+++ b/include/uapi/linux/virtio_mdev.h
@@ -0,0 +1,131 @@
+/*
+ * Virtio mediated device driver
+ *
+ * Copyright 2019, Red Hat Corp.
+ *
+ * Based on Virtio MMIO driver by ARM Ltd, copyright ARM Ltd. 2011
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+#ifndef _LINUX_VIRTIO_MDEV_H
+#define _LINUX_VIRTIO_MDEV_H
+
+#include <linux/interrupt.h>
+#include <linux/vringh.h>
+#include <uapi/linux/virtio_net.h>
+
+/*
+ * Ioctls
+ */
+
+struct virtio_mdev_callback {
+	irqreturn_t (*callback)(void *);
+	void *private;
+};
+
+#define VIRTIO_MDEV 0xAF
+#define VIRTIO_MDEV_SET_VQ_CALLBACK _IOW(VIRTIO_MDEV, 0x00, \
+					 struct virtio_mdev_callback)
+#define VIRTIO_MDEV_SET_CONFIG_CALLBACK _IOW(VIRTIO_MDEV, 0x01, \
+					struct virtio_mdev_callback)
+
+#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
+
+/*
+ * Control registers
+ */
+
+/* Magic value ("virt" string) - Read Only */
+#define VIRTIO_MDEV_MAGIC_VALUE		0x000
+
+/* Virtio device version - Read Only */
+#define VIRTIO_MDEV_VERSION		0x004
+
+/* Virtio device ID - Read Only */
+#define VIRTIO_MDEV_DEVICE_ID		0x008
+
+/* Virtio vendor ID - Read Only */
+#define VIRTIO_MDEV_VENDOR_ID		0x00c
+
+/* Bitmask of the features supported by the device (host)
+ * (32 bits per set) - Read Only */
+#define VIRTIO_MDEV_DEVICE_FEATURES	0x010
+
+/* Device (host) features set selector - Write Only */
+#define VIRTIO_MDEV_DEVICE_FEATURES_SEL	0x014
+
+/* Bitmask of features activated by the driver (guest)
+ * (32 bits per set) - Write Only */
+#define VIRTIO_MDEV_DRIVER_FEATURES	0x020
+
+/* Activated features set selector - Write Only */
+#define VIRTIO_MDEV_DRIVER_FEATURES_SEL	0x024
+
+/* Queue selector - Write Only */
+#define VIRTIO_MDEV_QUEUE_SEL		0x030
+
+/* Maximum size of the currently selected queue - Read Only */
+#define VIRTIO_MDEV_QUEUE_NUM_MAX	0x034
+
+/* Queue size for the currently selected queue - Write Only */
+#define VIRTIO_MDEV_QUEUE_NUM		0x038
+
+/* Ready bit for the currently selected queue - Read Write */
+#define VIRTIO_MDEV_QUEUE_READY		0x044
+
+/* Alignment of virtqueue - Read Only */
+#define VIRTIO_MDEV_QUEUE_ALIGN		0x048
+
+/* Queue notifier - Write Only */
+#define VIRTIO_MDEV_QUEUE_NOTIFY	0x050
+
+/* Device status register - Read Write */
+#define VIRTIO_MDEV_STATUS		0x060
+
+/* Selected queue's Descriptor Table address, 64 bits in two halves */
+#define VIRTIO_MDEV_QUEUE_DESC_LOW	0x080
+#define VIRTIO_MDEV_QUEUE_DESC_HIGH	0x084
+
+/* Selected queue's Available Ring address, 64 bits in two halves */
+#define VIRTIO_MDEV_QUEUE_AVAIL_LOW	0x090
+#define VIRTIO_MDEV_QUEUE_AVAIL_HIGH	0x094
+
+/* Selected queue's Used Ring address, 64 bits in two halves */
+#define VIRTIO_MDEV_QUEUE_USED_LOW	0x0a0
+#define VIRTIO_MDEV_QUEUE_USED_HIGH	0x0a4
+
+/* Configuration atomicity value */
+#define VIRTIO_MDEV_CONFIG_GENERATION	0x0fc
+
+/* The config space is defined by each driver as
+ * the per-driver configuration space - Read Write */
+#define VIRTIO_MDEV_CONFIG		0x100
+
+#endif
+
+
+/* Ready bit for the currently selected queue - Read Write */
-- 
2.19.1

