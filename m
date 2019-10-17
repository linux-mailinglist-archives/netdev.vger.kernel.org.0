Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29903DAA80
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 12:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409124AbfJQKvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 06:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409109AbfJQKvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 06:51:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DEBC3082DDD;
        Thu, 17 Oct 2019 10:51:48 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-185.pek2.redhat.com [10.72.12.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B33845D70D;
        Thu, 17 Oct 2019 10:51:23 +0000 (UTC)
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
        stefanha@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V4 5/6] virtio: introduce a mdev based transport
Date:   Thu, 17 Oct 2019 18:48:35 +0800
Message-Id: <20191017104836.32464-6-jasowang@redhat.com>
In-Reply-To: <20191017104836.32464-1-jasowang@redhat.com>
References: <20191017104836.32464-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 17 Oct 2019 10:51:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new mdev transport for virtio. This is used to
use kernel virtio driver to drive the mediated device that is capable
of populating virtqueue directly.

A new virtio-mdev driver will be registered to the mdev bus, when a
new virtio-mdev device is probed, it will register the device with
mdev based config ops. This means it is a software transport between
mdev driver and mdev device. The transport was implemented through
device specific ops which is a part of mdev_parent_ops now.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/Kconfig       |   7 +
 drivers/virtio/Makefile      |   1 +
 drivers/virtio/virtio_mdev.c | 409 +++++++++++++++++++++++++++++++++++
 3 files changed, 417 insertions(+)
 create mode 100644 drivers/virtio/virtio_mdev.c

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 078615cf2afc..8d18722ab572 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -43,6 +43,13 @@ config VIRTIO_PCI_LEGACY
 
 	  If unsure, say Y.
 
+config VIRTIO_MDEV_DEVICE
+	tristate "VIRTIO driver for Mediated devices"
+	depends on VFIO_MDEV && VIRTIO
+	default n
+	help
+	  VIRTIO based driver for Mediated devices.
+
 config VIRTIO_PMEM
 	tristate "Support for virtio pmem driver"
 	depends on VIRTIO
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 3a2b5c5dcf46..ebc7fa15ae82 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -6,3 +6,4 @@ virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
 virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
 obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
+obj-$(CONFIG_VIRTIO_MDEV_DEVICE) += virtio_mdev.o
diff --git a/drivers/virtio/virtio_mdev.c b/drivers/virtio/virtio_mdev.c
new file mode 100644
index 000000000000..24c0df5ffe77
--- /dev/null
+++ b/drivers/virtio/virtio_mdev.c
@@ -0,0 +1,409 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VIRTIO based driver for Mediated device
+ *
+ * Copyright (c) 2019, Red Hat. All rights reserved.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/uuid.h>
+#include <linux/mdev.h>
+#include <linux/virtio_mdev.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
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
+	/* The lock to protect virtqueue list */
+	spinlock_t lock;
+	/* List of virtio_mdev_vq_info */
+	struct list_head virtqueues;
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
+static struct mdev_device *vm_get_mdev(struct virtio_device *vdev)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+	struct mdev_device *mdev = vm_dev->mdev;
+
+	return mdev;
+}
+
+static void virtio_mdev_get(struct virtio_device *vdev, unsigned offset,
+			    void *buf, unsigned len)
+{
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	ops->get_config(mdev, offset, buf, len);
+}
+
+static void virtio_mdev_set(struct virtio_device *vdev, unsigned offset,
+			    const void *buf, unsigned len)
+{
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	ops->set_config(mdev, offset, buf, len);
+}
+
+static u32 virtio_mdev_generation(struct virtio_device *vdev)
+{
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	return ops->get_generation(mdev);
+}
+
+static u8 virtio_mdev_get_status(struct virtio_device *vdev)
+{
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	return ops->get_status(mdev);
+}
+
+static void virtio_mdev_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	return ops->set_status(mdev, status);
+}
+
+static void virtio_mdev_reset(struct virtio_device *vdev)
+{
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	return ops->set_status(mdev, 0);
+}
+
+static bool virtio_mdev_notify(struct virtqueue *vq)
+{
+	struct mdev_device *mdev = vm_get_mdev(vq->vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	ops->kick_vq(mdev, vq->index);
+
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
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+	struct virtio_mdev_vq_info *info;
+	struct virtio_mdev_callback cb;
+	struct virtqueue *vq;
+	u64 desc_addr, driver_addr, device_addr;
+	unsigned long flags;
+	u32 align, num;
+	int err;
+
+	if (!name)
+		return NULL;
+
+	/* Queue shouldn't already be set up. */
+	if (ops->get_vq_ready(mdev, index))
+		return ERR_PTR(-ENOENT);
+
+	/* Allocate and fill out our active queue description */
+	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	num = ops->get_vq_num_max(mdev);
+	if (num == 0) {
+		err = -ENOENT;
+		goto error_new_virtqueue;
+	}
+
+	/* Create the vring */
+	align = ops->get_vq_align(mdev);
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
+	ops->set_vq_cb(mdev, index, &cb);
+	ops->set_vq_num(mdev, index, virtqueue_get_vring_size(vq));
+
+	desc_addr = virtqueue_get_desc_addr(vq);
+	driver_addr = virtqueue_get_avail_addr(vq);
+	device_addr = virtqueue_get_used_addr(vq);
+
+	if (ops->set_vq_address(mdev, index,
+				desc_addr, driver_addr,
+				device_addr)) {
+		err = -EINVAL;
+		goto err_vq;
+	}
+
+	ops->set_vq_ready(mdev, index, 1);
+
+	vq->priv = info;
+	info->vq = vq;
+
+	spin_lock_irqsave(&vm_dev->lock, flags);
+	list_add(&info->node, &vm_dev->virtqueues);
+	spin_unlock_irqrestore(&vm_dev->lock, flags);
+
+	return vq;
+
+err_vq:
+	vring_del_virtqueue(vq);
+error_new_virtqueue:
+	ops->set_vq_ready(mdev, index, 0);
+	WARN_ON(ops->get_vq_ready(mdev, index));
+	kfree(info);
+	return ERR_PTR(err);
+
+}
+
+static void virtio_mdev_del_vq(struct virtqueue *vq)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vq->vdev);
+	struct mdev_device *mdev = vm_dev->mdev;
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+	struct virtio_mdev_vq_info *info = vq->priv;
+	unsigned int index = vq->index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vm_dev->lock, flags);
+	list_del(&info->node);
+	spin_unlock_irqrestore(&vm_dev->lock, flags);
+
+	/* Select and deactivate the queue */
+	ops->set_vq_ready(mdev, index, 0);
+	WARN_ON(ops->get_vq_ready(mdev, index));
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
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+	struct virtio_mdev_callback cb;
+	int i, err, queue_idx = 0;
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
+	ops->set_config_cb(mdev, &cb);
+
+	return 0;
+
+err_setup_vq:
+	virtio_mdev_del_vqs(vdev);
+	return err;
+}
+
+static u64 virtio_mdev_get_features(struct virtio_device *vdev)
+{
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	return ops->get_features(mdev);
+}
+
+static int virtio_mdev_finalize_features(struct virtio_device *vdev)
+{
+	struct mdev_device *mdev = vm_get_mdev(vdev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	return ops->set_features(mdev, vdev->features);
+}
+
+static const char *virtio_mdev_bus_name(struct virtio_device *vdev)
+{
+	struct virtio_mdev_device *vm_dev = to_virtio_mdev_device(vdev);
+	struct mdev_device *mdev = vm_dev->mdev;
+
+	return dev_name(mdev_dev(mdev));
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
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+	struct virtio_mdev_device *vm_dev;
+	int rc;
+
+	vm_dev = devm_kzalloc(dev, sizeof(*vm_dev), GFP_KERNEL);
+	if (!vm_dev)
+		return -ENOMEM;
+
+	vm_dev->vdev.dev.parent = dev;
+	vm_dev->vdev.dev.release = virtio_mdev_release_dev;
+	vm_dev->vdev.config = &virtio_mdev_config_ops;
+	vm_dev->mdev = mdev;
+	INIT_LIST_HEAD(&vm_dev->virtqueues);
+	spin_lock_init(&vm_dev->lock);
+
+	vm_dev->version = ops->get_mdev_features(mdev);
+	if (vm_dev->version != VIRTIO_MDEV_F_VERSION_1) {
+		dev_err(dev, "VIRTIO_MDEV_F_VERSION_1 is mandatory\n");
+		return -ENXIO;
+	}
+
+	vm_dev->vdev.id.device = ops->get_device_id(mdev);
+	if (vm_dev->vdev.id.device == 0)
+		return -ENODEV;
+
+	vm_dev->vdev.id.vendor = ops->get_vendor_id(mdev);
+	rc = register_virtio_device(&vm_dev->vdev);
+	if (rc)
+		put_device(dev);
+	else
+		dev_set_drvdata(dev, vm_dev);
+
+	return rc;
+}
+
+static void virtio_mdev_remove(struct device *dev)
+{
+	struct virtio_mdev_device *vm_dev = dev_get_drvdata(dev);
+
+	unregister_virtio_device(&vm_dev->vdev);
+}
+
+static const struct mdev_class_id id_table[] = {
+	{ MDEV_CLASS_ID_VIRTIO },
+	{ 0 },
+};
+
+MODULE_DEVICE_TABLE(mdev, id_table);
+
+static struct mdev_driver virtio_mdev_driver = {
+	.name	= "virtio_mdev",
+	.probe	= virtio_mdev_probe,
+	.remove = virtio_mdev_remove,
+	.id_table = id_table,
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
-- 
2.19.1

