Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93E61922D0
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCYIee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 04:34:34 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:50964 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726262AbgCYIee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585125272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fAQlCgWZ2dPQCguW5Bed3XEBbALZ5NTQsYpY32QaamE=;
        b=cgFS5ubqrBBEU4eNZAPegiPsk2Xwf0PKKr5P5yREfuAwHf8ed72YhLz01EbeNAqsD9+bKQ
        bXdSPB+GdzVem91T1tRmKtlOp9CnTCAcIrahVcKgB2SH3dW+W4M68tsqEqJlPh94q0YsRw
        /kDrO6ECwb7skLPniiX5hHgfTJUtyck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-FGfQiAz6P0urXhFVexoWEw-1; Wed, 25 Mar 2020 04:34:15 -0400
X-MC-Unique: FGfQiAz6P0urXhFVexoWEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE9F0802560;
        Wed, 25 Mar 2020 08:34:12 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-14-13.pek2.redhat.com [10.72.14.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A42FA7FF;
        Wed, 25 Mar 2020 08:33:33 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, Tiwei Bie <tiwei.bie@intel.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V8 7/9] vhost: introduce vDPA-based backend
Date:   Wed, 25 Mar 2020 16:27:09 +0800
Message-Id: <20200325082711.1107-8-jasowang@redhat.com>
In-Reply-To: <20200325082711.1107-1-jasowang@redhat.com>
References: <20200325082711.1107-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tiwei Bie <tiwei.bie@intel.com>

This patch introduces a vDPA-based vhost backend. This backend is
built on top of the same interface defined in virtio-vDPA and provides
a generic vhost interface for userspace to accelerate the virtio
devices in guest.

This backend is implemented as a vDPA device driver on top of the same
ops used in virtio-vDPA. It will create char device entry named
vhost-vdpa-$index for userspace to use. Userspace can use vhost ioctls
on top of this char device to setup the backend.

Vhost ioctls are extended to make it type agnostic and behave like a
virtio device, this help to eliminate type specific API like what
vhost_net/scsi/vsock did:

- VHOST_VDPA_GET_DEVICE_ID: get the virtio device ID which is defined
  by virtio specification to differ from different type of devices
- VHOST_VDPA_GET_VRING_NUM: get the maximum size of virtqueue
  supported by the vDPA device
- VHSOT_VDPA_SET/GET_STATUS: set and get virtio status of vDPA device
- VHOST_VDPA_SET/GET_CONFIG: access virtio config space
- VHOST_VDPA_SET_VRING_ENABLE: enable a specific virtqueue

For memory mapping, IOTLB API is mandated for vhost-vDPA which means
userspace drivers are required to use
VHOST_IOTLB_UPDATE/VHOST_IOTLB_INVALIDATE to add or remove mapping for
a specific userspace memory region.

The vhost-vDPA API is designed to be type agnostic, but it allows net
device only in current stage. Due to the lacking of control virtqueue
support, some features were filter out by vhost-vdpa.

We will enable more features and devices in the near future.

Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/Kconfig            |  11 +
 drivers/vhost/Makefile           |   3 +
 drivers/vhost/vdpa.c             | 883 +++++++++++++++++++++++++++++++
 include/uapi/linux/vhost.h       |  24 +
 include/uapi/linux/vhost_types.h |   8 +
 5 files changed, 929 insertions(+)
 create mode 100644 drivers/vhost/vdpa.c

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index b03872886901..2a4efe39d79b 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -52,6 +52,17 @@ config VHOST_VSOCK
 	To compile this driver as a module, choose M here: the module will be c=
alled
 	vhost_vsock.
=20
+config VHOST_VDPA
+	tristate "Vhost driver for vDPA-based backend"
+	depends on EVENTFD
+	select VDPA
+	help
+	  This kernel module can be loaded in host kernel to accelerate
+	  guest virtio devices with the vDPA-based backends.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called vhost_vdpa.
+
 config VHOST_CROSS_ENDIAN_LEGACY
 	bool "Cross-endian support for vhost"
 	default n
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index fb831002bcf0..f3e1897cce85 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -10,6 +10,9 @@ vhost_vsock-y :=3D vsock.o
=20
 obj-$(CONFIG_VHOST_RING) +=3D vringh.o
=20
+obj-$(CONFIG_VHOST_VDPA) +=3D vhost_vdpa.o
+vhost_vdpa-y :=3D vdpa.o
+
 obj-$(CONFIG_VHOST)	+=3D vhost.o
=20
 obj-$(CONFIG_VHOST_IOTLB) +=3D vhost_iotlb.o
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
new file mode 100644
index 000000000000..421f02a8530a
--- /dev/null
+++ b/drivers/vhost/vdpa.c
@@ -0,0 +1,883 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018-2020 Intel Corporation.
+ * Copyright (C) 2020 Red Hat, Inc.
+ *
+ * Author: Tiwei Bie <tiwei.bie@intel.com>
+ *         Jason Wang <jasowang@redhat.com>
+ *
+ * Thanks Michael S. Tsirkin for the valuable comments and
+ * suggestions.  And thanks to Cunming Liang and Zhihong Wang for all
+ * their supports.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include <linux/uuid.h>
+#include <linux/vdpa.h>
+#include <linux/nospec.h>
+#include <linux/vhost.h>
+#include <linux/virtio_net.h>
+
+#include "vhost.h"
+
+enum {
+	VHOST_VDPA_FEATURES =3D
+		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
+		(1ULL << VIRTIO_F_ANY_LAYOUT) |
+		(1ULL << VIRTIO_F_VERSION_1) |
+		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
+		(1ULL << VIRTIO_F_RING_PACKED) |
+		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
+		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
+		(1ULL << VIRTIO_RING_F_EVENT_IDX),
+
+	VHOST_VDPA_NET_FEATURES =3D VHOST_VDPA_FEATURES |
+		(1ULL << VIRTIO_NET_F_CSUM) |
+		(1ULL << VIRTIO_NET_F_GUEST_CSUM) |
+		(1ULL << VIRTIO_NET_F_MTU) |
+		(1ULL << VIRTIO_NET_F_MAC) |
+		(1ULL << VIRTIO_NET_F_GUEST_TSO4) |
+		(1ULL << VIRTIO_NET_F_GUEST_TSO6) |
+		(1ULL << VIRTIO_NET_F_GUEST_ECN) |
+		(1ULL << VIRTIO_NET_F_GUEST_UFO) |
+		(1ULL << VIRTIO_NET_F_HOST_TSO4) |
+		(1ULL << VIRTIO_NET_F_HOST_TSO6) |
+		(1ULL << VIRTIO_NET_F_HOST_ECN) |
+		(1ULL << VIRTIO_NET_F_HOST_UFO) |
+		(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
+		(1ULL << VIRTIO_NET_F_STATUS) |
+		(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
+};
+
+/* Currently, only network backend w/o multiqueue is supported. */
+#define VHOST_VDPA_VQ_MAX	2
+
+#define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
+
+struct vhost_vdpa {
+	struct vhost_dev vdev;
+	struct iommu_domain *domain;
+	struct vhost_virtqueue *vqs;
+	struct completion completion;
+	struct vdpa_device *vdpa;
+	struct device dev;
+	struct cdev cdev;
+	atomic_t opened;
+	int nvqs;
+	int virtio_id;
+	int minor;
+};
+
+static DEFINE_IDA(vhost_vdpa_ida);
+
+static dev_t vhost_vdpa_major;
+
+static const u64 vhost_vdpa_features[] =3D {
+	[VIRTIO_ID_NET] =3D VHOST_VDPA_NET_FEATURES,
+};
+
+static void handle_vq_kick(struct vhost_work *work)
+{
+	struct vhost_virtqueue *vq =3D container_of(work, struct vhost_virtqueu=
e,
+						  poll.work);
+	struct vhost_vdpa *v =3D container_of(vq->dev, struct vhost_vdpa, vdev)=
;
+	const struct vdpa_config_ops *ops =3D v->vdpa->config;
+
+	ops->kick_vq(v->vdpa, vq - v->vqs);
+}
+
+static irqreturn_t vhost_vdpa_virtqueue_cb(void *private)
+{
+	struct vhost_virtqueue *vq =3D private;
+	struct eventfd_ctx *call_ctx =3D vq->call_ctx;
+
+	if (call_ctx)
+		eventfd_signal(call_ctx, 1);
+
+	return IRQ_HANDLED;
+}
+
+static void vhost_vdpa_reset(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	ops->set_status(vdpa, 0);
+}
+
+static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *ar=
gp)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	u32 device_id;
+
+	device_id =3D ops->get_device_id(vdpa);
+
+	if (copy_to_user(argp, &device_id, sizeof(device_id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long vhost_vdpa_get_status(struct vhost_vdpa *v, u8 __user *statu=
sp)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	u8 status;
+
+	status =3D ops->get_status(vdpa);
+
+	if (copy_to_user(statusp, &status, sizeof(status)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statu=
sp)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	u8 status;
+
+	if (copy_from_user(&status, statusp, sizeof(status)))
+		return -EFAULT;
+
+	/*
+	 * Userspace shouldn't remove status bits unless reset the
+	 * status to 0.
+	 */
+	if (status !=3D 0 && (ops->get_status(vdpa) & ~status) !=3D 0)
+		return -EINVAL;
+
+	ops->set_status(vdpa, status);
+
+	return 0;
+}
+
+static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
+				      struct vhost_vdpa_config *c)
+{
+	long size =3D 0;
+
+	switch (v->virtio_id) {
+	case VIRTIO_ID_NET:
+		size =3D sizeof(struct virtio_net_config);
+		break;
+	}
+
+	if (c->len =3D=3D 0)
+		return -EINVAL;
+
+	if (c->len > size - c->off)
+		return -E2BIG;
+
+	return 0;
+}
+
+static long vhost_vdpa_get_config(struct vhost_vdpa *v,
+				  struct vhost_vdpa_config __user *c)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct vhost_vdpa_config config;
+	unsigned long size =3D offsetof(struct vhost_vdpa_config, buf);
+	u8 *buf;
+
+	if (copy_from_user(&config, c, size))
+		return -EFAULT;
+	if (vhost_vdpa_config_validate(v, &config))
+		return -EINVAL;
+	buf =3D kvzalloc(config.len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ops->get_config(vdpa, config.off, buf, config.len);
+
+	if (copy_to_user(c->buf, buf, config.len)) {
+		kvfree(buf);
+		return -EFAULT;
+	}
+
+	kvfree(buf);
+	return 0;
+}
+
+static long vhost_vdpa_set_config(struct vhost_vdpa *v,
+				  struct vhost_vdpa_config __user *c)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct vhost_vdpa_config config;
+	unsigned long size =3D offsetof(struct vhost_vdpa_config, buf);
+	u8 *buf;
+
+	if (copy_from_user(&config, c, size))
+		return -EFAULT;
+	if (vhost_vdpa_config_validate(v, &config))
+		return -EINVAL;
+	buf =3D kvzalloc(config.len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, c->buf, config.len)) {
+		kvfree(buf);
+		return -EFAULT;
+	}
+
+	ops->set_config(vdpa, config.off, buf, config.len);
+
+	kvfree(buf);
+	return 0;
+}
+
+static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *fe=
aturep)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	u64 features;
+
+	features =3D ops->get_features(vdpa);
+	features &=3D vhost_vdpa_features[v->virtio_id];
+
+	if (copy_to_user(featurep, &features, sizeof(features)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *fe=
aturep)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	u64 features;
+
+	/*
+	 * It's not allowed to change the features after they have
+	 * been negotiated.
+	 */
+	if (ops->get_status(vdpa) & VIRTIO_CONFIG_S_FEATURES_OK)
+		return -EBUSY;
+
+	if (copy_from_user(&features, featurep, sizeof(features)))
+		return -EFAULT;
+
+	if (features & ~vhost_vdpa_features[v->virtio_id])
+		return -EINVAL;
+
+	if (ops->set_features(vdpa, features))
+		return -EINVAL;
+
+	return 0;
+}
+
+static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *a=
rgp)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	u16 num;
+
+	num =3D ops->get_vq_num_max(vdpa);
+
+	if (copy_to_user(argp, &num, sizeof(num)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cm=
d,
+				   void __user *argp)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct vdpa_callback cb;
+	struct vhost_virtqueue *vq;
+	struct vhost_vring_state s;
+	u8 status;
+	u32 idx;
+	long r;
+
+	r =3D get_user(idx, (u32 __user *)argp);
+	if (r < 0)
+		return r;
+
+	if (idx >=3D v->nvqs)
+		return -ENOBUFS;
+
+	idx =3D array_index_nospec(idx, v->nvqs);
+	vq =3D &v->vqs[idx];
+
+	status =3D ops->get_status(vdpa);
+
+	if (cmd =3D=3D VHOST_VDPA_SET_VRING_ENABLE) {
+		if (copy_from_user(&s, argp, sizeof(s)))
+			return -EFAULT;
+		ops->set_vq_ready(vdpa, idx, s.num);
+		return 0;
+	}
+
+	if (cmd =3D=3D VHOST_GET_VRING_BASE)
+		vq->last_avail_idx =3D ops->get_vq_state(v->vdpa, idx);
+
+	r =3D vhost_vring_ioctl(&v->vdev, cmd, argp);
+	if (r)
+		return r;
+
+	switch (cmd) {
+	case VHOST_SET_VRING_ADDR:
+		if (ops->set_vq_address(vdpa, idx,
+					(u64)(uintptr_t)vq->desc,
+					(u64)(uintptr_t)vq->avail,
+					(u64)(uintptr_t)vq->used))
+			r =3D -EINVAL;
+		break;
+
+	case VHOST_SET_VRING_BASE:
+		if (ops->set_vq_state(vdpa, idx, vq->last_avail_idx))
+			r =3D -EINVAL;
+		break;
+
+	case VHOST_SET_VRING_CALL:
+		if (vq->call_ctx) {
+			cb.callback =3D vhost_vdpa_virtqueue_cb;
+			cb.private =3D vq;
+		} else {
+			cb.callback =3D NULL;
+			cb.private =3D NULL;
+		}
+		ops->set_vq_cb(vdpa, idx, &cb);
+		break;
+
+	case VHOST_SET_VRING_NUM:
+		ops->set_vq_num(vdpa, idx, vq->num);
+		break;
+	}
+
+	return r;
+}
+
+static long vhost_vdpa_unlocked_ioctl(struct file *filep,
+				      unsigned int cmd, unsigned long arg)
+{
+	struct vhost_vdpa *v =3D filep->private_data;
+	struct vhost_dev *d =3D &v->vdev;
+	void __user *argp =3D (void __user *)arg;
+	long r;
+
+	mutex_lock(&d->mutex);
+
+	switch (cmd) {
+	case VHOST_VDPA_GET_DEVICE_ID:
+		r =3D vhost_vdpa_get_device_id(v, argp);
+		break;
+	case VHOST_VDPA_GET_STATUS:
+		r =3D vhost_vdpa_get_status(v, argp);
+		break;
+	case VHOST_VDPA_SET_STATUS:
+		r =3D vhost_vdpa_set_status(v, argp);
+		break;
+	case VHOST_VDPA_GET_CONFIG:
+		r =3D vhost_vdpa_get_config(v, argp);
+		break;
+	case VHOST_VDPA_SET_CONFIG:
+		r =3D vhost_vdpa_set_config(v, argp);
+		break;
+	case VHOST_GET_FEATURES:
+		r =3D vhost_vdpa_get_features(v, argp);
+		break;
+	case VHOST_SET_FEATURES:
+		r =3D vhost_vdpa_set_features(v, argp);
+		break;
+	case VHOST_VDPA_GET_VRING_NUM:
+		r =3D vhost_vdpa_get_vring_num(v, argp);
+		break;
+	case VHOST_SET_LOG_BASE:
+	case VHOST_SET_LOG_FD:
+		r =3D -ENOIOCTLCMD;
+		break;
+	default:
+		r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
+		if (r =3D=3D -ENOIOCTLCMD)
+			r =3D vhost_vdpa_vring_ioctl(v, cmd, argp);
+		break;
+	}
+
+	mutex_unlock(&d->mutex);
+	return r;
+}
+
+static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 =
last)
+{
+	struct vhost_dev *dev =3D &v->vdev;
+	struct vhost_iotlb *iotlb =3D dev->iotlb;
+	struct vhost_iotlb_map *map;
+	struct page *page;
+	unsigned long pfn, pinned;
+
+	while ((map =3D vhost_iotlb_itree_first(iotlb, start, last)) !=3D NULL)=
 {
+		pinned =3D map->size >> PAGE_SHIFT;
+		for (pfn =3D map->addr >> PAGE_SHIFT;
+		     pinned > 0; pfn++, pinned--) {
+			page =3D pfn_to_page(pfn);
+			if (map->perm & VHOST_ACCESS_WO)
+				set_page_dirty_lock(page);
+			unpin_user_page(page);
+		}
+		atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
+		vhost_iotlb_map_free(iotlb, map);
+	}
+}
+
+static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
+{
+	struct vhost_dev *dev =3D &v->vdev;
+
+	vhost_vdpa_iotlb_unmap(v, 0ULL, 0ULL - 1);
+	kfree(dev->iotlb);
+	dev->iotlb =3D NULL;
+}
+
+static int perm_to_iommu_flags(u32 perm)
+{
+	int flags =3D 0;
+
+	switch (perm) {
+	case VHOST_ACCESS_WO:
+		flags |=3D IOMMU_WRITE;
+		break;
+	case VHOST_ACCESS_RO:
+		flags |=3D IOMMU_READ;
+		break;
+	case VHOST_ACCESS_RW:
+		flags |=3D (IOMMU_WRITE | IOMMU_READ);
+		break;
+	default:
+		WARN(1, "invalidate vhost IOTLB permission\n");
+		break;
+	}
+
+	return flags | IOMMU_CACHE;
+}
+
+static int vhost_vdpa_map(struct vhost_vdpa *v,
+			  u64 iova, u64 size, u64 pa, u32 perm)
+{
+	struct vhost_dev *dev =3D &v->vdev;
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	int r =3D 0;
+
+	r =3D vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
+				  pa, perm);
+	if (r)
+		return r;
+
+	if (ops->dma_map)
+		r =3D ops->dma_map(vdpa, iova, size, pa, perm);
+	else if (ops->set_map)
+		r =3D ops->set_map(vdpa, dev->iotlb);
+	else
+		r =3D iommu_map(v->domain, iova, pa, size,
+			      perm_to_iommu_flags(perm));
+
+	return r;
+}
+
+static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
+{
+	struct vhost_dev *dev =3D &v->vdev;
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	vhost_vdpa_iotlb_unmap(v, iova, iova + size - 1);
+
+	if (ops->dma_map)
+		ops->dma_unmap(vdpa, iova, size);
+	else if (ops->set_map)
+		ops->set_map(vdpa, dev->iotlb);
+	else
+		iommu_unmap(v->domain, iova, size);
+}
+
+static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
+					   struct vhost_iotlb_msg *msg)
+{
+	struct vhost_dev *dev =3D &v->vdev;
+	struct vhost_iotlb *iotlb =3D dev->iotlb;
+	struct page **page_list;
+	unsigned long list_size =3D PAGE_SIZE / sizeof(struct page *);
+	unsigned int gup_flags =3D FOLL_LONGTERM;
+	unsigned long npages, cur_base, map_pfn, last_pfn =3D 0;
+	unsigned long locked, lock_limit, pinned, i;
+	u64 iova =3D msg->iova;
+	int ret =3D 0;
+
+	if (vhost_iotlb_itree_first(iotlb, msg->iova,
+				    msg->iova + msg->size - 1))
+		return -EEXIST;
+
+	page_list =3D (struct page **) __get_free_page(GFP_KERNEL);
+	if (!page_list)
+		return -ENOMEM;
+
+	if (msg->perm & VHOST_ACCESS_WO)
+		gup_flags |=3D FOLL_WRITE;
+
+	npages =3D PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
+	if (!npages)
+		return -EINVAL;
+
+	down_read(&dev->mm->mmap_sem);
+
+	locked =3D atomic64_add_return(npages, &dev->mm->pinned_vm);
+	lock_limit =3D rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	if (locked > lock_limit) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+
+	cur_base =3D msg->uaddr & PAGE_MASK;
+	iova &=3D PAGE_MASK;
+
+	while (npages) {
+		pinned =3D min_t(unsigned long, npages, list_size);
+		ret =3D pin_user_pages(cur_base, pinned,
+				     gup_flags, page_list, NULL);
+		if (ret !=3D pinned)
+			goto out;
+
+		if (!last_pfn)
+			map_pfn =3D page_to_pfn(page_list[0]);
+
+		for (i =3D 0; i < ret; i++) {
+			unsigned long this_pfn =3D page_to_pfn(page_list[i]);
+			u64 csize;
+
+			if (last_pfn && (this_pfn !=3D last_pfn + 1)) {
+				/* Pin a contiguous chunk of memory */
+				csize =3D (last_pfn - map_pfn + 1) << PAGE_SHIFT;
+				if (vhost_vdpa_map(v, iova, csize,
+						   map_pfn << PAGE_SHIFT,
+						   msg->perm))
+					goto out;
+				map_pfn =3D this_pfn;
+				iova +=3D csize;
+			}
+
+			last_pfn =3D this_pfn;
+		}
+
+		cur_base +=3D ret << PAGE_SHIFT;
+		npages -=3D ret;
+	}
+
+	/* Pin the rest chunk */
+	ret =3D vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
+			     map_pfn << PAGE_SHIFT, msg->perm);
+out:
+	if (ret) {
+		vhost_vdpa_unmap(v, msg->iova, msg->size);
+		atomic64_sub(npages, &dev->mm->pinned_vm);
+	}
+	up_read(&dev->mm->mmap_sem);
+	free_page((unsigned long)page_list);
+	return ret;
+}
+
+static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
+					struct vhost_iotlb_msg *msg)
+{
+	struct vhost_vdpa *v =3D container_of(dev, struct vhost_vdpa, vdev);
+	int r =3D 0;
+
+	r =3D vhost_dev_check_owner(dev);
+	if (r)
+		return r;
+
+	switch (msg->type) {
+	case VHOST_IOTLB_UPDATE:
+		r =3D vhost_vdpa_process_iotlb_update(v, msg);
+		break;
+	case VHOST_IOTLB_INVALIDATE:
+		vhost_vdpa_unmap(v, msg->iova, msg->size);
+		break;
+	default:
+		r =3D -EINVAL;
+		break;
+	}
+
+	return r;
+}
+
+static ssize_t vhost_vdpa_chr_write_iter(struct kiocb *iocb,
+					 struct iov_iter *from)
+{
+	struct file *file =3D iocb->ki_filp;
+	struct vhost_vdpa *v =3D file->private_data;
+	struct vhost_dev *dev =3D &v->vdev;
+
+	return vhost_chr_write_iter(dev, from);
+}
+
+static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct device *dma_dev =3D vdpa_get_dma_dev(vdpa);
+	struct bus_type *bus;
+	int ret;
+
+	/* Device want to do DMA by itself */
+	if (ops->set_map || ops->dma_map)
+		return 0;
+
+	bus =3D dma_dev->bus;
+	if (!bus)
+		return -EFAULT;
+
+	if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
+		return -ENOTSUPP;
+
+	v->domain =3D iommu_domain_alloc(bus);
+	if (!v->domain)
+		return -EIO;
+
+	ret =3D iommu_attach_device(v->domain, dma_dev);
+	if (ret)
+		goto err_attach;
+
+	return 0;
+
+err_attach:
+	iommu_domain_free(v->domain);
+	return ret;
+}
+
+static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa =3D v->vdpa;
+	struct device *dma_dev =3D vdpa_get_dma_dev(vdpa);
+
+	if (v->domain) {
+		iommu_detach_device(v->domain, dma_dev);
+		iommu_domain_free(v->domain);
+	}
+
+	v->domain =3D NULL;
+}
+
+static int vhost_vdpa_open(struct inode *inode, struct file *filep)
+{
+	struct vhost_vdpa *v;
+	struct vhost_dev *dev;
+	struct vhost_virtqueue **vqs;
+	int nvqs, i, r, opened;
+
+	v =3D container_of(inode->i_cdev, struct vhost_vdpa, cdev);
+	if (!v)
+		return -ENODEV;
+
+	opened =3D atomic_cmpxchg(&v->opened, 0, 1);
+	if (opened)
+		return -EBUSY;
+
+	nvqs =3D v->nvqs;
+	vhost_vdpa_reset(v);
+
+	vqs =3D kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
+	if (!vqs) {
+		r =3D -ENOMEM;
+		goto err;
+	}
+
+	dev =3D &v->vdev;
+	for (i =3D 0; i < nvqs; i++) {
+		vqs[i] =3D &v->vqs[i];
+		vqs[i]->handle_kick =3D handle_vq_kick;
+	}
+	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0,
+		       vhost_vdpa_process_iotlb_msg);
+
+	dev->iotlb =3D vhost_iotlb_alloc(0, 0);
+	if (!dev->iotlb) {
+		r =3D -ENOMEM;
+		goto err_init_iotlb;
+	}
+
+	r =3D vhost_vdpa_alloc_domain(v);
+	if (r)
+		goto err_init_iotlb;
+
+	filep->private_data =3D v;
+
+	return 0;
+
+err_init_iotlb:
+	vhost_dev_cleanup(&v->vdev);
+err:
+	atomic_dec(&v->opened);
+	return r;
+}
+
+static int vhost_vdpa_release(struct inode *inode, struct file *filep)
+{
+	struct vhost_vdpa *v =3D filep->private_data;
+	struct vhost_dev *d =3D &v->vdev;
+
+	mutex_lock(&d->mutex);
+	filep->private_data =3D NULL;
+	vhost_vdpa_reset(v);
+	vhost_dev_stop(&v->vdev);
+	vhost_vdpa_iotlb_free(v);
+	vhost_vdpa_free_domain(v);
+	vhost_dev_cleanup(&v->vdev);
+	kfree(v->vdev.vqs);
+	mutex_unlock(&d->mutex);
+
+	atomic_dec(&v->opened);
+	complete(&v->completion);
+
+	return 0;
+}
+
+static const struct file_operations vhost_vdpa_fops =3D {
+	.owner		=3D THIS_MODULE,
+	.open		=3D vhost_vdpa_open,
+	.release	=3D vhost_vdpa_release,
+	.write_iter	=3D vhost_vdpa_chr_write_iter,
+	.unlocked_ioctl	=3D vhost_vdpa_unlocked_ioctl,
+	.compat_ioctl	=3D compat_ptr_ioctl,
+};
+
+static void vhost_vdpa_release_dev(struct device *device)
+{
+	struct vhost_vdpa *v =3D
+	       container_of(device, struct vhost_vdpa, dev);
+
+	ida_simple_remove(&vhost_vdpa_ida, v->minor);
+	kfree(v->vqs);
+	kfree(v);
+}
+
+static int vhost_vdpa_probe(struct vdpa_device *vdpa)
+{
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct vhost_vdpa *v;
+	int minor, nvqs =3D VHOST_VDPA_VQ_MAX;
+	int r;
+
+	/* Currently, we only accept the network devices. */
+	if (ops->get_device_id(vdpa) !=3D VIRTIO_ID_NET)
+		return -ENOTSUPP;
+
+	v =3D kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	if (!v)
+		return -ENOMEM;
+
+	minor =3D ida_simple_get(&vhost_vdpa_ida, 0,
+			       VHOST_VDPA_DEV_MAX, GFP_KERNEL);
+	if (minor < 0) {
+		kfree(v);
+		return minor;
+	}
+
+	atomic_set(&v->opened, 0);
+	v->minor =3D minor;
+	v->vdpa =3D vdpa;
+	v->nvqs =3D nvqs;
+	v->virtio_id =3D ops->get_device_id(vdpa);
+
+	device_initialize(&v->dev);
+	v->dev.release =3D vhost_vdpa_release_dev;
+	v->dev.parent =3D &vdpa->dev;
+	v->dev.devt =3D MKDEV(MAJOR(vhost_vdpa_major), minor);
+	v->vqs =3D kmalloc_array(nvqs, sizeof(struct vhost_virtqueue),
+			       GFP_KERNEL);
+	if (!v->vqs) {
+		r =3D -ENOMEM;
+		goto err;
+	}
+
+	r =3D dev_set_name(&v->dev, "vhost-vdpa-%u", minor);
+	if (r)
+		goto err;
+
+	cdev_init(&v->cdev, &vhost_vdpa_fops);
+	v->cdev.owner =3D THIS_MODULE;
+
+	r =3D cdev_device_add(&v->cdev, &v->dev);
+	if (r)
+		goto err;
+
+	init_completion(&v->completion);
+	vdpa_set_drvdata(vdpa, v);
+
+	return 0;
+
+err:
+	put_device(&v->dev);
+	return r;
+}
+
+static void vhost_vdpa_remove(struct vdpa_device *vdpa)
+{
+	struct vhost_vdpa *v =3D vdpa_get_drvdata(vdpa);
+	int opened;
+
+	cdev_device_del(&v->cdev, &v->dev);
+
+	do {
+		opened =3D atomic_cmpxchg(&v->opened, 0, 1);
+		if (!opened)
+			break;
+		wait_for_completion(&v->completion);
+	} while (1);
+
+	put_device(&v->dev);
+}
+
+static struct vdpa_driver vhost_vdpa_driver =3D {
+	.driver =3D {
+		.name	=3D "vhost_vdpa",
+	},
+	.probe	=3D vhost_vdpa_probe,
+	.remove	=3D vhost_vdpa_remove,
+};
+
+static int __init vhost_vdpa_init(void)
+{
+	int r;
+
+	r =3D alloc_chrdev_region(&vhost_vdpa_major, 0, VHOST_VDPA_DEV_MAX,
+				"vhost-vdpa");
+	if (r)
+		goto err_alloc_chrdev;
+
+	r =3D vdpa_register_driver(&vhost_vdpa_driver);
+	if (r)
+		goto err_vdpa_register_driver;
+
+	return 0;
+
+err_vdpa_register_driver:
+	unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
+err_alloc_chrdev:
+	return r;
+}
+module_init(vhost_vdpa_init);
+
+static void __exit vhost_vdpa_exit(void)
+{
+	vdpa_unregister_driver(&vhost_vdpa_driver);
+	unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
+}
+module_exit(vhost_vdpa_exit);
+
+MODULE_VERSION("0.0.1");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("vDPA-based vhost backend for virtio");
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 40d028eed645..9fe72e4b1373 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -116,4 +116,28 @@
 #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
 #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
=20
+/* VHOST_VDPA specific defines */
+
+/* Get the device id. The device ids follow the same definition of
+ * the device id defined in virtio-spec.
+ */
+#define VHOST_VDPA_GET_DEVICE_ID	_IOR(VHOST_VIRTIO, 0x70, __u32)
+/* Get and set the status. The status bits follow the same definition
+ * of the device status defined in virtio-spec.
+ */
+#define VHOST_VDPA_GET_STATUS		_IOR(VHOST_VIRTIO, 0x71, __u8)
+#define VHOST_VDPA_SET_STATUS		_IOW(VHOST_VIRTIO, 0x72, __u8)
+/* Get and set the device config. The device config follows the same
+ * definition of the device config defined in virtio-spec.
+ */
+#define VHOST_VDPA_GET_CONFIG		_IOR(VHOST_VIRTIO, 0x73, \
+					     struct vhost_vdpa_config)
+#define VHOST_VDPA_SET_CONFIG		_IOW(VHOST_VIRTIO, 0x74, \
+					     struct vhost_vdpa_config)
+/* Enable/disable the ring. */
+#define VHOST_VDPA_SET_VRING_ENABLE	_IOW(VHOST_VIRTIO, 0x75, \
+					     struct vhost_vring_state)
+/* Get the max ring size. */
+#define VHOST_VDPA_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
+
 #endif
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
index c907290ff065..669457ce5c48 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -119,6 +119,14 @@ struct vhost_scsi_target {
 	unsigned short reserved;
 };
=20
+/* VHOST_VDPA specific definitions */
+
+struct vhost_vdpa_config {
+	__u32 off;
+	__u32 len;
+	__u8 buf[0];
+};
+
 /* Feature bits */
 /* Log all write descriptors. Can be changed while device is active. */
 #define VHOST_F_LOG_ALL 26
--=20
2.20.1

