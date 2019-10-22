Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3BB6E0143
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbfJVJ4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:56:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:34734 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbfJVJ4Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:56:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 02:56:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="398965385"
Received: from dpdk-virtio-tbie-2.sh.intel.com ([10.67.104.74])
  by fmsmga006.fm.intel.com with ESMTP; 22 Oct 2019 02:56:21 -0700
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com, tiwei.bie@intel.com
Subject: [PATCH v2] vhost: introduce mdev based hardware backend
Date:   Tue, 22 Oct 2019 17:52:29 +0800
Message-Id: <20191022095230.2514-1-tiwei.bie@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a mdev based hardware vhost backend.
This backend is built on top of the same abstraction used
in virtio-mdev and provides a generic vhost interface for
userspace to accelerate the virtio devices in guest.

This backend is implemented as a mdev device driver on top
of the same mdev device ops used in virtio-mdev but using
a different mdev class id, and it will register the device
as a VFIO device for userspace to use. Userspace can setup
the IOMMU with the existing VFIO container/group APIs and
then get the device fd with the device name. After getting
the device fd of this device, userspace can use vhost ioctls
to setup the backend.

Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
---
This patch depends on below series:
https://lkml.org/lkml/2019/10/17/286

v1 -> v2:
- Replace _SET_STATE with _SET_STATUS (MST);
- Check status bits at each step (MST);
- Report the max ring size and max number of queues (MST);
- Add missing MODULE_DEVICE_TABLE (Jason);
- Only support the network backend w/o multiqueue for now;
- Some minor fixes and improvements;
- Rebase on top of virtio-mdev series v4;

RFC v4 -> v1:
- Implement vhost-mdev as a mdev device driver directly and
  connect it to VFIO container/group. (Jason);
- Pass ring addresses as GPAs/IOVAs in vhost-mdev to avoid
  meaningless HVA->GPA translations (Jason);

RFC v3 -> RFC v4:
- Build vhost-mdev on top of the same abstraction used by
  virtio-mdev (Jason);
- Introduce vhost fd and pass VFIO fd via SET_BACKEND ioctl (MST);

RFC v2 -> RFC v3:
- Reuse vhost's ioctls instead of inventing a VFIO regions/irqs
  based vhost protocol on top of vfio-mdev (Jason);

RFC v1 -> RFC v2:
- Introduce a new VFIO device type to build a vhost protocol
  on top of vfio-mdev;

 drivers/vfio/mdev/mdev_core.c |  12 +
 drivers/vhost/Kconfig         |   9 +
 drivers/vhost/Makefile        |   3 +
 drivers/vhost/mdev.c          | 415 ++++++++++++++++++++++++++++++++++
 include/linux/mdev.h          |   3 +
 include/uapi/linux/vhost.h    |  13 ++
 6 files changed, 455 insertions(+)
 create mode 100644 drivers/vhost/mdev.c

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 5834f6b7c7a5..2963f65e6648 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -69,6 +69,18 @@ void mdev_set_virtio_ops(struct mdev_device *mdev,
 }
 EXPORT_SYMBOL(mdev_set_virtio_ops);
 
+/* Specify the vhost device ops for the mdev device, this
+ * must be called during create() callback for vhost mdev device.
+ */
+void mdev_set_vhost_ops(struct mdev_device *mdev,
+			const struct virtio_mdev_device_ops *vhost_ops)
+{
+	WARN_ON(mdev->class_id);
+	mdev->class_id = MDEV_CLASS_ID_VHOST;
+	mdev->device_ops = vhost_ops;
+}
+EXPORT_SYMBOL(mdev_set_vhost_ops);
+
 const void *mdev_get_dev_ops(struct mdev_device *mdev)
 {
 	return mdev->device_ops;
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 3d03ccbd1adc..7b5c2f655af7 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -34,6 +34,15 @@ config VHOST_VSOCK
 	To compile this driver as a module, choose M here: the module will be called
 	vhost_vsock.
 
+config VHOST_MDEV
+	tristate "Vhost driver for Mediated devices"
+	depends on EVENTFD && VFIO && VFIO_MDEV
+	select VHOST
+	default n
+	---help---
+	Say M here to enable the vhost_mdev module for use with
+	the mediated device based hardware vhost accelerators.
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
index 000000000000..5f9cae61018c
--- /dev/null
+++ b/drivers/vhost/mdev.c
@@ -0,0 +1,415 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018-2019 Intel Corporation.
+ */
+
+#include <linux/compat.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/mdev.h>
+#include <linux/module.h>
+#include <linux/vfio.h>
+#include <linux/vhost.h>
+#include <linux/virtio_mdev.h>
+#include <linux/virtio_ids.h>
+
+#include "vhost.h"
+
+/* Currently, only network backend w/o multiqueue is supported. */
+#define VHOST_MDEV_VQ_MAX	2
+
+struct vhost_mdev {
+	/* The lock is to protect this structure. */
+	struct mutex mutex;
+	struct vhost_dev dev;
+	struct vhost_virtqueue *vqs;
+	int nvqs;
+	u64 status;
+	u64 features;
+	u64 acked_features;
+	bool opened;
+	struct mdev_device *mdev;
+};
+
+static void handle_vq_kick(struct vhost_work *work)
+{
+	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
+						  poll.work);
+	struct vhost_mdev *m = container_of(vq->dev, struct vhost_mdev, dev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(m->mdev);
+
+	ops->kick_vq(m->mdev, vq - m->vqs);
+}
+
+static irqreturn_t vhost_mdev_virtqueue_cb(void *private)
+{
+	struct vhost_virtqueue *vq = private;
+	struct eventfd_ctx *call_ctx = vq->call_ctx;
+
+	if (call_ctx)
+		eventfd_signal(call_ctx, 1);
+	return IRQ_HANDLED;
+}
+
+static void vhost_mdev_reset(struct vhost_mdev *m)
+{
+	struct mdev_device *mdev = m->mdev;
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+
+	m->status = 0;
+	return ops->set_status(mdev, m->status);
+}
+
+static long vhost_mdev_get_status(struct vhost_mdev *m, u8 __user *statusp)
+{
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(m->mdev);
+	struct mdev_device *mdev = m->mdev;
+	u8 status;
+
+	status = ops->get_status(mdev);
+	m->status = status;
+
+	if (copy_to_user(statusp, &status, sizeof(status)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long vhost_mdev_set_status(struct vhost_mdev *m, u8 __user *statusp)
+{
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(m->mdev);
+	struct mdev_device *mdev = m->mdev;
+	u8 status;
+
+	if (copy_from_user(&status, statusp, sizeof(status)))
+		return -EFAULT;
+
+	/*
+	 * Userspace shouldn't remove status bits unless reset the
+	 * status to 0.
+	 */
+	if (status != 0 && (m->status & ~status) != 0)
+		return -EINVAL;
+
+	ops->set_status(mdev, status);
+	m->status = ops->get_status(mdev);
+
+	return 0;
+}
+
+static long vhost_mdev_get_features(struct vhost_mdev *m, u64 __user *featurep)
+{
+	if (copy_to_user(featurep, &m->features, sizeof(m->features)))
+		return -EFAULT;
+	return 0;
+}
+
+static long vhost_mdev_set_features(struct vhost_mdev *m, u64 __user *featurep)
+{
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(m->mdev);
+	struct mdev_device *mdev = m->mdev;
+	u64 features;
+
+	/*
+	 * It's not allowed to change the features after they have
+	 * been negotiated.
+	 */
+	if (m->status & VIRTIO_CONFIG_S_FEATURES_OK)
+		return -EPERM;
+
+	if (copy_from_user(&features, featurep, sizeof(features)))
+		return -EFAULT;
+
+	if (features & ~m->features)
+		return -EINVAL;
+
+	m->acked_features = features;
+	if (ops->set_features(mdev, m->acked_features))
+		return -ENODEV;
+
+	return 0;
+}
+
+static long vhost_mdev_get_vring_num(struct vhost_mdev *m, u16 __user *argp)
+{
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(m->mdev);
+	struct mdev_device *mdev = m->mdev;
+	u16 num;
+
+	num = ops->get_vq_num_max(mdev);
+
+	if (copy_to_user(argp, &num, sizeof(num)))
+		return -EFAULT;
+	return 0;
+}
+
+static long vhost_mdev_get_queue_num(struct vhost_mdev *m, u32 __user *argp)
+{
+	u32 nvqs = m->nvqs;
+
+	if (copy_to_user(argp, &nvqs, sizeof(nvqs)))
+		return -EFAULT;
+	return 0;
+}
+
+static long vhost_mdev_vring_ioctl(struct vhost_mdev *m, unsigned int cmd,
+				   void __user *argp)
+{
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(m->mdev);
+	struct mdev_device *mdev = m->mdev;
+	struct virtio_mdev_callback cb;
+	struct vhost_virtqueue *vq;
+	struct vhost_vring_state s;
+	u32 idx;
+	long r;
+
+	r = get_user(idx, (u32 __user *)argp);
+	if (r < 0)
+		return r;
+	if (idx >= m->nvqs)
+		return -ENOBUFS;
+
+	/*
+	 * It's not allowed to detect and program vqs before
+	 * features negotiation or after enabling driver.
+	 */
+	if (!(m->status & VIRTIO_CONFIG_S_FEATURES_OK) ||
+	    (m->status & VIRTIO_CONFIG_S_DRIVER_OK))
+		return -EPERM;
+
+	vq = &m->vqs[idx];
+
+	if (cmd == VHOST_MDEV_SET_VRING_ENABLE) {
+		if (copy_from_user(&s, argp, sizeof(s)))
+			return -EFAULT;
+		ops->set_vq_ready(mdev, idx, s.num);
+		return 0;
+	}
+
+	/*
+	 * It's not allowed to detect and program vqs with
+	 * vqs enabled.
+	 */
+	if (ops->get_vq_ready(mdev, idx))
+		return -EPERM;
+
+	if (cmd == VHOST_GET_VRING_BASE)
+		vq->last_avail_idx = ops->get_vq_state(m->mdev, idx);
+
+	r = vhost_vring_ioctl(&m->dev, cmd, argp);
+	if (r)
+		return r;
+
+	switch (cmd) {
+	case VHOST_SET_VRING_ADDR:
+		/*
+		 * In vhost-mdev, the ring addresses set by userspace should
+		 * be the DMA addresses within the VFIO container/group.
+		 */
+		if (ops->set_vq_address(mdev, idx, (u64)vq->desc,
+					(u64)vq->avail, (u64)vq->used))
+			r = -ENODEV;
+		break;
+
+	case VHOST_SET_VRING_BASE:
+		if (ops->set_vq_state(mdev, idx, vq->last_avail_idx))
+			r = -ENODEV;
+		break;
+
+	case VHOST_SET_VRING_CALL:
+		if (vq->call_ctx) {
+			cb.callback = vhost_mdev_virtqueue_cb;
+			cb.private = vq;
+		} else {
+			cb.callback = NULL;
+			cb.private = NULL;
+		}
+		ops->set_vq_cb(mdev, idx, &cb);
+		break;
+
+	case VHOST_SET_VRING_NUM:
+		ops->set_vq_num(mdev, idx, vq->num);
+		break;
+	}
+
+	return r;
+}
+
+static int vhost_mdev_open(void *device_data)
+{
+	struct vhost_mdev *m = device_data;
+	struct vhost_dev *dev;
+	struct vhost_virtqueue **vqs;
+	int nvqs, i, r;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	mutex_lock(&m->mutex);
+
+	if (m->opened) {
+		r = -EBUSY;
+		goto err;
+	}
+
+	nvqs = m->nvqs;
+	vhost_mdev_reset(m);
+
+	memset(&m->dev, 0, sizeof(m->dev));
+	memset(m->vqs, 0, nvqs * sizeof(struct vhost_virtqueue));
+
+	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
+	if (!vqs) {
+		r = -ENOMEM;
+		goto err;
+	}
+
+	dev = &m->dev;
+	for (i = 0; i < nvqs; i++) {
+		vqs[i] = &m->vqs[i];
+		vqs[i]->handle_kick = handle_vq_kick;
+	}
+	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0);
+	m->opened = true;
+	mutex_unlock(&m->mutex);
+
+	return 0;
+
+err:
+	mutex_unlock(&m->mutex);
+	module_put(THIS_MODULE);
+	return r;
+}
+
+static void vhost_mdev_release(void *device_data)
+{
+	struct vhost_mdev *m = device_data;
+
+	mutex_lock(&m->mutex);
+	vhost_mdev_reset(m);
+	vhost_dev_stop(&m->dev);
+	vhost_dev_cleanup(&m->dev);
+
+	kfree(m->dev.vqs);
+	m->opened = false;
+	mutex_unlock(&m->mutex);
+	module_put(THIS_MODULE);
+}
+
+static long vhost_mdev_unlocked_ioctl(void *device_data,
+				      unsigned int cmd, unsigned long arg)
+{
+	struct vhost_mdev *m = device_data;
+	void __user *argp = (void __user *)arg;
+	long r;
+
+	mutex_lock(&m->mutex);
+
+	switch (cmd) {
+	case VHOST_MDEV_GET_STATUS:
+		r = vhost_mdev_get_status(m, argp);
+		break;
+	case VHOST_MDEV_SET_STATUS:
+		r = vhost_mdev_set_status(m, argp);
+		break;
+	case VHOST_GET_FEATURES:
+		r = vhost_mdev_get_features(m, argp);
+		break;
+	case VHOST_SET_FEATURES:
+		r = vhost_mdev_set_features(m, argp);
+		break;
+	case VHOST_MDEV_GET_VRING_NUM:
+		r = vhost_mdev_get_vring_num(m, argp);
+		break;
+	case VHOST_MDEV_GET_QUEUE_NUM:
+		r = vhost_mdev_get_queue_num(m, argp);
+		break;
+	default:
+		r = vhost_dev_ioctl(&m->dev, cmd, argp);
+		if (r == -ENOIOCTLCMD)
+			r = vhost_mdev_vring_ioctl(m, cmd, argp);
+	}
+
+	mutex_unlock(&m->mutex);
+	return r;
+}
+
+static const struct vfio_device_ops vfio_vhost_mdev_dev_ops = {
+	.name		= "vfio-vhost-mdev",
+	.open		= vhost_mdev_open,
+	.release	= vhost_mdev_release,
+	.ioctl		= vhost_mdev_unlocked_ioctl,
+};
+
+static int vhost_mdev_probe(struct device *dev)
+{
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	const struct virtio_mdev_device_ops *ops = mdev_get_dev_ops(mdev);
+	struct vhost_mdev *m;
+	int nvqs, r;
+
+	/* Currently, only network backend is supported. */
+	if (ops->get_device_id(mdev) != VIRTIO_ID_NET)
+		return -ENOTSUPP;
+
+	if (ops->get_mdev_features(mdev) != VIRTIO_MDEV_F_VERSION_1)
+		return -ENOTSUPP;
+
+	m = devm_kzalloc(dev, sizeof(*m), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	if (!m)
+		return -ENOMEM;
+
+	nvqs = VHOST_MDEV_VQ_MAX;
+	m->nvqs = nvqs;
+
+	m->vqs = devm_kmalloc_array(dev, nvqs, sizeof(struct vhost_virtqueue),
+				    GFP_KERNEL);
+	if (!m->vqs)
+		return -ENOMEM;
+
+	r = vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, m);
+	if (r)
+		return r;
+
+	mutex_init(&m->mutex);
+	m->features = ops->get_features(mdev);
+	m->mdev = mdev;
+	return 0;
+}
+
+static void vhost_mdev_remove(struct device *dev)
+{
+	struct vhost_mdev *m;
+
+	m = vfio_del_group_dev(dev);
+	mutex_destroy(&m->mutex);
+}
+
+static const struct mdev_class_id vhost_mdev_match[] = {
+	{ MDEV_CLASS_ID_VHOST },
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(mdev, vhost_mdev_match);
+
+static struct mdev_driver vhost_mdev_driver = {
+	.name	= "vhost_mdev",
+	.probe	= vhost_mdev_probe,
+	.remove	= vhost_mdev_remove,
+	.id_table = vhost_mdev_match,
+};
+
+static int __init vhost_mdev_init(void)
+{
+	return mdev_register_driver(&vhost_mdev_driver, THIS_MODULE);
+}
+module_init(vhost_mdev_init);
+
+static void __exit vhost_mdev_exit(void)
+{
+	mdev_unregister_driver(&vhost_mdev_driver);
+}
+module_exit(vhost_mdev_exit);
+
+MODULE_VERSION("0.0.1");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Mediated device based accelerator for virtio");
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 13e045e09d3b..6060cdbe6d3e 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -114,6 +114,8 @@ void mdev_set_vfio_ops(struct mdev_device *mdev,
 		       const struct vfio_mdev_device_ops *vfio_ops);
 void mdev_set_virtio_ops(struct mdev_device *mdev,
                          const struct virtio_mdev_device_ops *virtio_ops);
+void mdev_set_vhost_ops(struct mdev_device *mdev,
+			const struct virtio_mdev_device_ops *vhost_ops);
 const void *mdev_get_dev_ops(struct mdev_device *mdev);
 
 extern struct bus_type mdev_bus_type;
@@ -131,6 +133,7 @@ struct mdev_device *mdev_from_dev(struct device *dev);
 enum {
 	MDEV_CLASS_ID_VFIO = 1,
 	MDEV_CLASS_ID_VIRTIO = 2,
+	MDEV_CLASS_ID_VHOST = 3,
 	/* New entries must be added here */
 };
 
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 40d028eed645..dad3c62bd91b 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -116,4 +116,17 @@
 #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
 #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
 
+/* VHOST_MDEV specific defines */
+
+/* Get and set the status of the backend. The status bits follow the
+ * same definition of the device status defined in virtio-spec. */
+#define VHOST_MDEV_GET_STATUS		_IOW(VHOST_VIRTIO, 0x70, __u8)
+#define VHOST_MDEV_SET_STATUS		_IOW(VHOST_VIRTIO, 0x71, __u8)
+/* Enable/disable the ring. */
+#define VHOST_MDEV_SET_VRING_ENABLE	_IOW(VHOST_VIRTIO, 0x72, struct vhost_vring_state)
+/* Get the max ring size. */
+#define VHOST_MDEV_GET_VRING_NUM	_IOW(VHOST_VIRTIO, 0x73, __u16)
+/* Get the max number of queues. */
+#define VHOST_MDEV_GET_QUEUE_NUM	_IOW(VHOST_VIRTIO, 0x74, __u32)
+
 #endif
-- 
2.23.0

