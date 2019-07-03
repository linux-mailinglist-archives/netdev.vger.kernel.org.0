Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967E25E0B9
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfGCJQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:16:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:5199 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfGCJQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 05:16:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 02:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,446,1557212400"; 
   d="scan'208";a="154693094"
Received: from npg-dpdk-virtio-tbie-2.sh.intel.com ([10.67.104.151])
  by orsmga007.jf.intel.com with ESMTP; 03 Jul 2019 02:16:30 -0700
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, tiwei.bie@intel.com
Subject: [RFC v2] vhost: introduce mdev based hardware vhost backend
Date:   Wed,  3 Jul 2019 17:13:39 +0800
Message-Id: <20190703091339.1847-1-tiwei.bie@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Details about this can be found here:

https://lwn.net/Articles/750770/

What's new in this version
==========================

A new VFIO device type is introduced - vfio-vhost. This addressed
some comments from here: https://patchwork.ozlabs.org/cover/984763/

Below is the updated device interface:

Currently, there are two regions of this device: 1) CONFIG_REGION
(VFIO_VHOST_CONFIG_REGION_INDEX), which can be used to setup the
device; 2) NOTIFY_REGION (VFIO_VHOST_NOTIFY_REGION_INDEX), which
can be used to notify the device.

1. CONFIG_REGION

The region described by CONFIG_REGION is the main control interface.
Messages will be written to or read from this region.

The message type is determined by the `request` field in message
header. The message size is encoded in the message header too.
The message format looks like this:

struct vhost_vfio_op {
	__u64 request;
	__u32 flags;
	/* Flag values: */
 #define VHOST_VFIO_NEED_REPLY 0x1 /* Whether need reply */
	__u32 size;
	union {
		__u64 u64;
		struct vhost_vring_state state;
		struct vhost_vring_addr addr;
	} payload;
};

The existing vhost-kernel ioctl cmds are reused as the message
requests in above structure.

Each message will be written to or read from this region at offset 0:

int vhost_vfio_write(struct vhost_dev *dev, struct vhost_vfio_op *op)
{
	int count = VHOST_VFIO_OP_HDR_SIZE + op->size;
	struct vhost_vfio *vfio = dev->opaque;
	int ret;

	ret = pwrite64(vfio->device_fd, op, count, vfio->config_offset);
	if (ret != count)
		return -1;

	return 0;
}

int vhost_vfio_read(struct vhost_dev *dev, struct vhost_vfio_op *op)
{
	int count = VHOST_VFIO_OP_HDR_SIZE + op->size;
	struct vhost_vfio *vfio = dev->opaque;
	uint64_t request = op->request;
	int ret;

	ret = pread64(vfio->device_fd, op, count, vfio->config_offset);
	if (ret != count || request != op->request)
		return -1;

	return 0;
}

It's quite straightforward to set things to the device. Just need to
write the message to device directly:

int vhost_vfio_set_features(struct vhost_dev *dev, uint64_t features)
{
	struct vhost_vfio_op op;

	op.request = VHOST_SET_FEATURES;
	op.flags = 0;
	op.size = sizeof(features);
	op.payload.u64 = features;

	return vhost_vfio_write(dev, &op);
}

To get things from the device, two steps are needed.
Take VHOST_GET_FEATURE as an example:

int vhost_vfio_get_features(struct vhost_dev *dev, uint64_t *features)
{
	struct vhost_vfio_op op;
	int ret;

	op.request = VHOST_GET_FEATURES;
	op.flags = VHOST_VFIO_NEED_REPLY;
	op.size = 0;

	/* Just need to write the header */
	ret = vhost_vfio_write(dev, &op);
	if (ret != 0)
		goto out;

	/* `op` wasn't changed during write */
	op.flags = 0;
	op.size = sizeof(*features);

	ret = vhost_vfio_read(dev, &op);
	if (ret != 0)
		goto out;

	*features = op.payload.u64;
out:
	return ret;
}

2. NOTIFIY_REGION (mmap-able)

The region described by NOTIFY_REGION will be used to notify
the device.

Each queue will have a page for notification, and it can be mapped
to VM (if hardware also supports), and the virtio driver in the VM
will be able to notify the device directly.

The region described by NOTIFY_REGION is also write-able. If
the accelerator's notification register(s) cannot be mapped to
the VM, write() can also be used to notify the device. Something
like this:

void notify_relay(void *opaque)
{
	......
	offset = host_page_size * queue_idx;

	ret = pwrite64(vfio->device_fd, &queue_idx, sizeof(queue_idx),
			vfio->notify_offset + offset);
	......
}

3. VFIO interrupt ioctl API

VFIO interrupt ioctl API is used to setup device interrupts.
IRQ-bypass can also be supported.

Currently, the data path interrupt can be configured via the
VFIO_VHOST_VQ_IRQ_INDEX with virtqueue's callfd.

Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
---
 drivers/vhost/Makefile     |   2 +
 drivers/vhost/vdpa.c       | 770 +++++++++++++++++++++++++++++++++++++
 include/linux/vdpa_mdev.h  |  72 ++++
 include/uapi/linux/vfio.h  |  19 +
 include/uapi/linux/vhost.h |  25 ++
 5 files changed, 888 insertions(+)
 create mode 100644 drivers/vhost/vdpa.c
 create mode 100644 include/linux/vdpa_mdev.h

diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index 6c6df24f770c..cabb71095940 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -10,4 +10,6 @@ vhost_vsock-y := vsock.o
 
 obj-$(CONFIG_VHOST_RING) += vringh.o
 
+obj-$(CONFIG_VHOST_VFIO) += vdpa.o
+
 obj-$(CONFIG_VHOST)	+= vhost.o
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
new file mode 100644
index 000000000000..5c9426e2a091
--- /dev/null
+++ b/drivers/vhost/vdpa.c
@@ -0,0 +1,770 @@
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
+#include <linux/vdpa_mdev.h>
+#include <asm/uaccess.h>
+
+#define VDPA_CONFIG_SIZE		0x1000000
+
+#define VDPA_VFIO_VHOST_OFFSET_SHIFT	40
+#define VDPA_VFIO_VHOST_OFFSET_MASK \
+		((1ULL << VDPA_VFIO_VHOST_OFFSET_SHIFT) - 1)
+#define VDPA_VFIO_VHOST_OFFSET_TO_INDEX(offset) \
+		((offset) >> VDPA_VFIO_VHOST_OFFSET_SHIFT)
+#define VDPA_VFIO_VHOST_INDEX_TO_OFFSET(index) \
+		((u64)(index) << VDPA_VFIO_VHOST_OFFSET_SHIFT)
+#define VDPA_VFIO_VHOST_REGION_OFFSET(offset) \
+		((offset) & VDPA_VFIO_VHOST_OFFSET_MASK)
+
+struct vdpa_dev *vdpa_alloc(struct mdev_device *mdev, void *private,
+			    int max_vrings)
+{
+	struct vdpa_dev *vdpa;
+	size_t size;
+
+	size = sizeof(struct vdpa_dev) + max_vrings *
+			sizeof(struct vdpa_vring_info);
+
+	vdpa = kzalloc(size, GFP_KERNEL);
+	if (vdpa == NULL)
+		return NULL;
+
+	mutex_init(&vdpa->ops_lock);
+
+	vdpa->mdev = mdev;
+	vdpa->private = private;
+	vdpa->max_vrings = max_vrings;
+
+	return vdpa;
+}
+EXPORT_SYMBOL(vdpa_alloc);
+
+void vdpa_free(struct vdpa_dev *vdpa)
+{
+	struct mdev_device *mdev;
+
+	mdev = vdpa->mdev;
+
+	vdpa->ops->stop(vdpa);
+	mdev_set_drvdata(mdev, NULL);
+	mutex_destroy(&vdpa->ops_lock);
+	kfree(vdpa);
+}
+EXPORT_SYMBOL(vdpa_free);
+
+static ssize_t vdpa_handle_config_read(struct mdev_device *mdev,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	struct vdpa_dev *vdpa;
+	struct vhost_vfio_op *op = NULL;
+	loff_t pos = *ppos;
+	loff_t offset;
+	int ret;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	offset = VDPA_VFIO_VHOST_REGION_OFFSET(pos);
+	if (offset != 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!vdpa->pending_reply) {
+		ret = 0;
+		goto out;
+	}
+
+	vdpa->pending_reply = false;
+
+	op = kzalloc(VHOST_VFIO_OP_HDR_SIZE + VHOST_VFIO_OP_PAYLOAD_MAX_SIZE,
+		     GFP_KERNEL);
+	if (op == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	op->request = vdpa->pending.request;
+
+	switch (op->request) {
+	case VHOST_GET_VRING_BASE:
+		op->payload.state = vdpa->pending.payload.state;
+		op->size = sizeof(op->payload.state);
+		break;
+	case VHOST_GET_FEATURES:
+		op->payload.u64 = vdpa->pending.payload.u64;
+		op->size = sizeof(op->payload.u64);
+		break;
+	default:
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	if (op->size + VHOST_VFIO_OP_HDR_SIZE != count) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	if (copy_to_user(buf, op, count)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
+	ret = count;
+
+out_free:
+	kfree(op);
+out:
+	return ret;
+}
+
+ssize_t vdpa_read(struct mdev_device *mdev, char __user *buf,
+		  size_t count, loff_t *ppos)
+{
+	int done = 0;
+	unsigned int index;
+	loff_t pos = *ppos;
+	struct vdpa_dev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	mutex_lock(&vdpa->ops_lock);
+
+	index = VDPA_VFIO_VHOST_OFFSET_TO_INDEX(pos);
+
+	switch (index) {
+	case VFIO_VHOST_CONFIG_REGION_INDEX:
+		done = vdpa_handle_config_read(mdev, buf, count, ppos);
+		break;
+	}
+
+	if (done > 0)
+		*ppos += done;
+
+	mutex_unlock(&vdpa->ops_lock);
+
+	return done;
+}
+EXPORT_SYMBOL(vdpa_read);
+
+static int vhost_set_vring_addr(struct mdev_device *mdev,
+		struct vhost_vring_addr *addr)
+{
+	struct vdpa_dev *vdpa;
+	int qid = addr->index;
+	struct vdpa_vring_info *vring;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	if (qid >= vdpa->max_vrings)
+		return -EINVAL;
+
+	if (qid >= vdpa->nr_vring)
+		vdpa->nr_vring = qid + 1;
+
+	vring = &vdpa->vring_info[qid];
+
+	vring->desc_user_addr = addr->desc_user_addr;
+	vring->used_user_addr = addr->used_user_addr;
+	vring->avail_user_addr = addr->avail_user_addr;
+	vring->log_guest_addr = addr->log_guest_addr;
+
+	return 0;
+}
+
+static int vhost_set_vring_num(struct mdev_device *mdev,
+		struct vhost_vring_state *num)
+{
+	struct vdpa_dev *vdpa;
+	int qid = num->index;
+	struct vdpa_vring_info *vring;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	if (qid >= vdpa->max_vrings)
+		return -EINVAL;
+
+	vring = &vdpa->vring_info[qid];
+
+	vring->size = num->num;
+
+	return 0;
+}
+
+static int vhost_set_vring_base(struct mdev_device *mdev,
+		struct vhost_vring_state *base)
+{
+	struct vdpa_dev *vdpa;
+	int qid = base->index;
+	struct vdpa_vring_info *vring;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	if (qid >= vdpa->max_vrings)
+		return -EINVAL;
+
+	vring = &vdpa->vring_info[qid];
+
+	vring->base = base->num;
+
+	return 0;
+}
+
+static int vhost_get_vring_base(struct mdev_device *mdev,
+		struct vhost_vring_state *base)
+{
+	struct vdpa_dev *vdpa;
+	int qid = base->index;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	vdpa->pending_reply = true;
+	vdpa->pending.request = VHOST_GET_VRING_BASE;
+	vdpa->pending.payload.state.index = qid;
+	vdpa->pending.payload.state.num = vdpa->vring_info[qid].base;
+
+	return 0;
+}
+
+static int vhost_set_log_base(struct mdev_device *mdev, u64 *log_base)
+{
+	struct vdpa_dev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	vdpa->log_base = *log_base;
+	return 0;
+}
+
+static int vhost_set_features(struct mdev_device *mdev, u64 *features)
+{
+	struct vdpa_dev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	vdpa->features = *features;
+	vdpa->ops->set_features(vdpa);
+
+	return 0;
+}
+
+static int vhost_get_features(struct mdev_device *mdev, u64 *features)
+{
+	struct vdpa_dev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	vdpa->pending_reply = true;
+	vdpa->pending.request = VHOST_GET_FEATURES;
+	vdpa->pending.payload.u64 =
+		vdpa->ops->supported_features(vdpa);
+
+	return 0;
+}
+
+static int vhost_set_owner(struct mdev_device *mdev)
+{
+	// TODO
+	return 0;
+}
+
+static int vhost_reset_owner(struct mdev_device *mdev)
+{
+	// TODO
+	return 0;
+}
+
+static int vhost_set_state(struct mdev_device *mdev, u64 *state)
+{
+	struct vdpa_dev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	if (*state >= VHOST_DEVICE_S_MAX)
+		return -EINVAL;
+
+	if (vdpa->state == *state)
+		return 0;
+
+	vdpa->state = *state;
+
+	switch (vdpa->state) {
+	case VHOST_DEVICE_S_RUNNING:
+		vdpa->ops->start(vdpa);
+		break;
+	case VHOST_DEVICE_S_STOPPED:
+		vdpa->ops->stop(vdpa);
+		break;
+	}
+
+	return 0;
+}
+
+static ssize_t vdpa_handle_config_write(struct mdev_device *mdev,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	struct vhost_vfio_op *op = NULL;
+	loff_t pos = *ppos;
+	loff_t offset;
+	int ret;
+
+	offset = VDPA_VFIO_VHOST_REGION_OFFSET(pos);
+	if (offset != 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (count < VHOST_VFIO_OP_HDR_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	op = kzalloc(VHOST_VFIO_OP_HDR_SIZE + VHOST_VFIO_OP_PAYLOAD_MAX_SIZE,
+		     GFP_KERNEL);
+	if (op == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (copy_from_user(op, buf, VHOST_VFIO_OP_HDR_SIZE)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	if (op->size > VHOST_VFIO_OP_PAYLOAD_MAX_SIZE ||
+	    op->size + VHOST_VFIO_OP_HDR_SIZE != count) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	if (copy_from_user(&op->payload, buf + VHOST_VFIO_OP_HDR_SIZE,
+			   op->size)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
+	switch (op->request) {
+	case VHOST_SET_LOG_BASE:
+		vhost_set_log_base(mdev, &op->payload.u64);
+		break;
+	case VHOST_SET_VRING_ADDR:
+		vhost_set_vring_addr(mdev, &op->payload.addr);
+		break;
+	case VHOST_SET_VRING_NUM:
+		vhost_set_vring_num(mdev, &op->payload.state);
+		break;
+	case VHOST_SET_VRING_BASE:
+		vhost_set_vring_base(mdev, &op->payload.state);
+		break;
+	case VHOST_GET_VRING_BASE:
+		vhost_get_vring_base(mdev, &op->payload.state);
+		break;
+	case VHOST_SET_FEATURES:
+		vhost_set_features(mdev, &op->payload.u64);
+		break;
+	case VHOST_GET_FEATURES:
+		vhost_get_features(mdev, &op->payload.u64);
+		break;
+	case VHOST_SET_OWNER:
+		vhost_set_owner(mdev);
+		break;
+	case VHOST_RESET_OWNER:
+		vhost_reset_owner(mdev);
+		break;
+	case VHOST_DEVICE_SET_STATE:
+		vhost_set_state(mdev, &op->payload.u64);
+		break;
+	default:
+		break;
+	}
+
+	ret = count;
+
+out_free:
+	kfree(op);
+out:
+	return ret;
+}
+
+static ssize_t vdpa_handle_notify_write(struct mdev_device *mdev,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	struct vdpa_dev *vdpa;
+	int qid;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	if (count < sizeof(qid))
+		return -EINVAL;
+
+	if (copy_from_user(&qid, buf, sizeof(qid)))
+		return -EINVAL;
+
+	vdpa->ops->notify(vdpa, qid);
+
+	return count;
+}
+
+ssize_t vdpa_write(struct mdev_device *mdev, const char __user *buf,
+		   size_t count, loff_t *ppos)
+{
+	int done = 0;
+	unsigned int index;
+	loff_t pos = *ppos;
+	struct vdpa_dev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	mutex_lock(&vdpa->ops_lock);
+
+	index = VDPA_VFIO_VHOST_OFFSET_TO_INDEX(pos);
+
+	switch (index) {
+	case VFIO_VHOST_CONFIG_REGION_INDEX:
+		done = vdpa_handle_config_write(mdev, buf, count, ppos);
+		break;
+	case VFIO_VHOST_NOTIFY_REGION_INDEX:
+		done = vdpa_handle_notify_write(mdev, buf, count, ppos);
+		break;
+	}
+
+	if (done > 0)
+		*ppos += done;
+
+	mutex_unlock(&vdpa->ops_lock);
+
+	return done;
+}
+EXPORT_SYMBOL(vdpa_write);
+
+static int vdpa_get_region_info(struct mdev_device *mdev,
+				struct vfio_region_info *region_info,
+				u16 *cap_type_id, void **cap_type)
+{
+	struct vdpa_dev *vdpa;
+	u32 index, flags;
+	u64 size = 0;
+
+	if (!mdev)
+		return -EINVAL;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -EINVAL;
+
+	index = region_info->index;
+	if (index >= VFIO_VHOST_NUM_REGIONS)
+		return -EINVAL;
+
+	mutex_lock(&vdpa->ops_lock);
+
+	flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE;
+
+	switch (index) {
+	case VFIO_VHOST_CONFIG_REGION_INDEX:
+		size = VDPA_CONFIG_SIZE;
+		break;
+	case VFIO_VHOST_NOTIFY_REGION_INDEX:
+		size = (u64)vdpa->max_vrings << PAGE_SHIFT;
+		flags |= VFIO_REGION_INFO_FLAG_MMAP;
+		break;
+	default:
+		size = 0;
+		break;
+	}
+
+	region_info->size = size;
+	region_info->offset = VDPA_VFIO_VHOST_INDEX_TO_OFFSET(index);
+	region_info->flags = flags;
+	mutex_unlock(&vdpa->ops_lock);
+	return 0;
+}
+
+static int vdpa_reset(struct mdev_device *mdev)
+{
+	struct vdpa_dev *vdpa;
+
+	if (!mdev)
+		return -EINVAL;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vdpa_get_device_info(struct mdev_device *mdev,
+				struct vfio_device_info *dev_info)
+{
+	struct vdpa_dev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	dev_info->flags = VFIO_DEVICE_FLAGS_VHOST | VFIO_DEVICE_RESET;
+	dev_info->num_regions = VFIO_VHOST_NUM_REGIONS;
+	dev_info->num_irqs = VFIO_VHOST_NUM_IRQS;
+
+	return 0;
+}
+
+static int vdpa_get_irq_info(struct mdev_device *mdev,
+			     struct vfio_irq_info *info)
+{
+	struct vdpa_dev *vdpa;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	if (info->index != VFIO_VHOST_VQ_IRQ_INDEX)
+		return -EINVAL;
+
+	info->flags = VFIO_IRQ_INFO_EVENTFD;
+	info->count = vdpa->max_vrings;
+
+	return 0;
+}
+
+static int vdpa_set_irqs(struct mdev_device *mdev, uint32_t flags,
+			 unsigned int index, unsigned int start,
+			 unsigned int count, void *data)
+{
+	struct vdpa_dev *vdpa;
+	int *fd = data, i;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -EINVAL;
+
+	if (index != VFIO_VHOST_VQ_IRQ_INDEX)
+		return -ENOTSUPP;
+
+	for (i = 0; i < count; i++)
+		vdpa->ops->set_eventfd(vdpa, start + i,
+			(flags & VFIO_IRQ_SET_DATA_EVENTFD) ? fd[i] : -1);
+
+	return 0;
+}
+
+long vdpa_ioctl(struct mdev_device *mdev, unsigned int cmd, unsigned long arg)
+{
+	int ret = 0;
+	unsigned long minsz;
+	struct vdpa_dev *vdpa;
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
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		ret = vdpa_get_device_info(mdev, &info);
+		if (ret)
+			return ret;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+
+		return 0;
+	}
+	case VFIO_DEVICE_GET_REGION_INFO:
+	{
+		struct vfio_region_info info;
+		u16 cap_type_id = 0;
+		void *cap_type = NULL;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		ret = vdpa_get_region_info(mdev, &info, &cap_type_id,
+					   &cap_type);
+		if (ret)
+			return ret;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+
+		return 0;
+	}
+	case VFIO_DEVICE_GET_IRQ_INFO:
+	{
+		struct vfio_irq_info info;
+
+		minsz = offsetofend(struct vfio_irq_info, count);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz || info.index >= vdpa->max_vrings)
+			return -EINVAL;
+
+		ret = vdpa_get_irq_info(mdev, &info);
+		if (ret)
+			return ret;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+
+		return 0;
+	}
+	case VFIO_DEVICE_SET_IRQS:
+	{
+		struct vfio_irq_set hdr;
+		size_t data_size = 0;
+		u8 *data = NULL;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		ret = vfio_set_irqs_validate_and_prepare(&hdr, vdpa->max_vrings,
+							 VFIO_VHOST_NUM_IRQS,
+							 &data_size);
+		if (ret)
+			return ret;
+
+		if (data_size) {
+			data = memdup_user((void __user *)(arg + minsz),
+					   data_size);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		}
+
+		ret = vdpa_set_irqs(mdev, hdr.flags, hdr.index, hdr.start,
+				hdr.count, data);
+
+		kfree(data);
+		return ret;
+	}
+	case VFIO_DEVICE_RESET:
+		return vdpa_reset(mdev);
+	}
+	return -ENOTTY;
+}
+EXPORT_SYMBOL(vdpa_ioctl);
+
+static const struct vm_operations_struct vdpa_mm_ops = {
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+	.access = generic_access_phys
+#endif
+};
+
+int vdpa_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+{
+	struct vdpa_dev *vdpa;
+	unsigned int index;
+	loff_t pos;
+	loff_t offset;
+	int qid, ret;
+
+	vdpa = mdev_get_drvdata(mdev);
+	if (!vdpa)
+		return -ENODEV;
+
+	pos = vma->vm_pgoff << PAGE_SHIFT;
+
+	index = VDPA_VFIO_VHOST_OFFSET_TO_INDEX(pos);
+	offset = VDPA_VFIO_VHOST_REGION_OFFSET(pos);
+
+	qid = offset >> PAGE_SHIFT;
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+	if (index != VFIO_VHOST_NOTIFY_REGION_INDEX)
+		return -EINVAL;
+	if (qid < 0 || qid >= vdpa->max_vrings)
+		return -EINVAL;
+
+	if (vma->vm_end - vma->vm_start > PAGE_SIZE)
+		return -EINVAL;
+
+	if (vdpa->ops->get_notify_addr == NULL)
+		return -ENOTSUPP;
+
+	mutex_lock(&vdpa->ops_lock);
+
+	vma->vm_ops = &vdpa_mm_ops;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	vma->vm_pgoff = vdpa->ops->get_notify_addr(vdpa, qid) >> PAGE_SHIFT;
+
+	ret = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			vma->vm_end - vma->vm_start, vma->vm_page_prot);
+
+	mutex_unlock(&vdpa->ops_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(vdpa_mmap);
+
+int vdpa_open(struct mdev_device *mdev)
+{
+	return 0;
+}
+EXPORT_SYMBOL(vdpa_open);
+
+void vdpa_close(struct mdev_device *mdev)
+{
+}
+EXPORT_SYMBOL(vdpa_close);
+
+MODULE_VERSION("0.0.0");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Hardware vhost accelerator abstraction");
diff --git a/include/linux/vdpa_mdev.h b/include/linux/vdpa_mdev.h
new file mode 100644
index 000000000000..4bbdf7e2e712
--- /dev/null
+++ b/include/linux/vdpa_mdev.h
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018-2019 Intel Corporation.
+ */
+
+#ifndef VDPA_MDEV_H
+#define VDPA_MDEV_H
+
+struct mdev_device;
+struct vdpa_dev;
+
+/*
+ * XXX: Any comments about the vDPA API design for drivers
+ *      would be appreciated!
+ */
+
+typedef int (*vdpa_start_device_t)(struct vdpa_dev *vdpa);
+typedef int (*vdpa_stop_device_t)(struct vdpa_dev *vdpa);
+typedef int (*vdpa_set_features_t)(struct vdpa_dev *vdpa);
+typedef int (*vdpa_set_eventfd_t)(struct vdpa_dev *vdpa, int queue_idx, int fd);
+typedef u64 (*vdpa_supported_features_t)(struct vdpa_dev *vdpa);
+typedef void (*vdpa_notify_device_t)(struct vdpa_dev *vdpa, int queue_idx);
+typedef u64 (*vdpa_get_notify_addr_t)(struct vdpa_dev *vdpa, int queue_idx);
+
+struct vdpa_device_ops {
+	vdpa_start_device_t		start;
+	vdpa_stop_device_t		stop;
+	vdpa_set_eventfd_t		set_eventfd;
+	vdpa_supported_features_t	supported_features;
+	vdpa_notify_device_t		notify;
+	vdpa_get_notify_addr_t		get_notify_addr;
+	vdpa_set_features_t		set_features;
+};
+
+struct vdpa_vring_info {
+	u64 desc_user_addr;
+	u64 used_user_addr;
+	u64 avail_user_addr;
+	u64 log_guest_addr;
+	u16 size;
+	u16 base;
+};
+
+struct vdpa_dev {
+	struct mdev_device *mdev;
+	struct mutex ops_lock;
+	int nr_vring;
+	u64 features;
+	u64 state;
+	bool pending_reply;
+	struct vhost_vfio_op pending;
+	const struct vdpa_device_ops *ops;
+	void *private;
+	int max_vrings;
+	uint64_t log_base;
+	uint64_t log_size;
+	struct vdpa_vring_info vring_info[0];
+};
+
+struct vdpa_dev *vdpa_alloc(struct mdev_device *mdev, void *private,
+			    int max_vrings);
+void vdpa_free(struct vdpa_dev *vdpa);
+ssize_t vdpa_read(struct mdev_device *mdev, char __user *buf,
+		  size_t count, loff_t *ppos);
+ssize_t vdpa_write(struct mdev_device *mdev, const char __user *buf,
+		   size_t count, loff_t *ppos);
+long vdpa_ioctl(struct mdev_device *mdev, unsigned int cmd, unsigned long arg);
+int vdpa_mmap(struct mdev_device *mdev, struct vm_area_struct *vma);
+int vdpa_open(struct mdev_device *mdev);
+void vdpa_close(struct mdev_device *mdev);
+
+#endif /* VDPA_MDEV_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8f10748dac79..6c5718ab7eeb 100644
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
@@ -573,6 +575,23 @@ enum {
 	VFIO_CCW_NUM_IRQS
 };
 
+/*
+ * The vfio-vhost bus driver makes use of the following fixed region and
+ * IRQ index mapping. Unimplemented regions return a size of zero.
+ * Unimplemented IRQ types return a count of zero.
+ */
+
+enum {
+	VFIO_VHOST_CONFIG_REGION_INDEX,
+	VFIO_VHOST_NOTIFY_REGION_INDEX,
+	VFIO_VHOST_NUM_REGIONS
+};
+
+enum {
+	VFIO_VHOST_VQ_IRQ_INDEX,
+	VFIO_VHOST_NUM_IRQS
+};
+
 /**
  * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IORW(VFIO_TYPE, VFIO_BASE + 12,
  *					      struct vfio_pci_hot_reset_info)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 40d028eed645..ad95b90c5c05 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -116,4 +116,29 @@
 #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
 #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
 
+/* VHOST_DEVICE specific defines */
+
+#define VHOST_DEVICE_SET_STATE _IOW(VHOST_VIRTIO, 0x70, __u64)
+
+#define VHOST_DEVICE_S_STOPPED 0
+#define VHOST_DEVICE_S_RUNNING 1
+#define VHOST_DEVICE_S_MAX     2
+
+struct vhost_vfio_op {
+	__u64 request;
+	__u32 flags;
+	/* Flag values: */
+#define VHOST_VFIO_NEED_REPLY 0x1 /* Whether need reply */
+	__u32 size;
+	union {
+		__u64 u64;
+		struct vhost_vring_state state;
+		struct vhost_vring_addr addr;
+	} payload;
+};
+
+#define VHOST_VFIO_OP_HDR_SIZE \
+		((unsigned long)&((struct vhost_vfio_op *)NULL)->payload)
+#define VHOST_VFIO_OP_PAYLOAD_MAX_SIZE 1024 /* FIXME TBD */
+
 #endif
-- 
2.17.1

