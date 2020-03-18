Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB824189692
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgCRIFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:05:02 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:50039 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727354AbgCRIFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584518701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0A80/fZ+pkCQYcnkCKyC43WtTpczDhthy4abNtOjSew=;
        b=ZLPfbBb8LRH7dcNhCcIN/4FM4jmHjZOA2cDs9gnE3KMdCFTwYTwojzmkupwkd7CAdpldB5
        uS7XVrOfevKn9IdRSU1eU2T+nIL/130ZPegsWp3aRLE68+zgX2fPqieCgCFbDoN2b+KF5u
        3BJH9oWQuaxxm91FPQ8MzQ3udHWCkcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-mVApxx3-NJO_2ZLM9yICIA-1; Wed, 18 Mar 2020 04:04:56 -0400
X-MC-Unique: mVApxx3-NJO_2ZLM9yICIA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E607BDB68;
        Wed, 18 Mar 2020 08:04:53 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-166.pek2.redhat.com [10.72.13.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFAD619C58;
        Wed, 18 Mar 2020 08:04:43 +0000 (UTC)
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
        vmireyno@marvell.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V6 5/8] virtio: introduce a vDPA based transport
Date:   Wed, 18 Mar 2020 16:03:24 +0800
Message-Id: <20200318080327.21958-6-jasowang@redhat.com>
In-Reply-To: <20200318080327.21958-1-jasowang@redhat.com>
References: <20200318080327.21958-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a vDPA transport for virtio. This is used to
use kernel virtio driver to drive the vDPA device that is capable
of populating virtqueue directly.

A new virtio-vdpa driver will be registered to the vDPA bus, when a
new virtio-vdpa device is probed, it will register the device with
vdpa based config ops. This means it is a software transport between
vDPA driver and vDPA device. The transport was implemented through
bus_ops of vDPA parent.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/Kconfig       |  13 ++
 drivers/virtio/Makefile      |   1 +
 drivers/virtio/virtio_vdpa.c | 396 +++++++++++++++++++++++++++++++++++
 3 files changed, 410 insertions(+)
 create mode 100644 drivers/virtio/virtio_vdpa.c

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 9c4fdb64d9ac..99e424570644 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -43,6 +43,19 @@ config VIRTIO_PCI_LEGACY
=20
 	  If unsure, say Y.
=20
+config VIRTIO_VDPA
+	tristate "vDPA driver for virtio devices"
+	select VDPA
+	select VIRTIO
+	help
+	  This driver provides support for virtio based paravirtual
+	  device driver over vDPA bus. For this to be useful, you need
+	  an appropriate vDPA device implementation that operates on a
+	  physical device to allow the datapath of virtio to be
+	  offloaded to hardware.
+
+	  If unsure, say M.
+
 config VIRTIO_PMEM
 	tristate "Support for virtio pmem driver"
 	depends on VIRTIO
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index fdf5eacd0d0a..3407ac03fe60 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -6,4 +6,5 @@ virtio_pci-y :=3D virtio_pci_modern.o virtio_pci_common.o
 virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) +=3D virtio_pci_legacy.o
 obj-$(CONFIG_VIRTIO_BALLOON) +=3D virtio_balloon.o
 obj-$(CONFIG_VIRTIO_INPUT) +=3D virtio_input.o
+obj-$(CONFIG_VIRTIO_VDPA) +=3D virtio_vdpa.o
 obj-$(CONFIG_VDPA) +=3D vdpa/
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
new file mode 100644
index 000000000000..c30eb55030be
--- /dev/null
+++ b/drivers/virtio/virtio_vdpa.c
@@ -0,0 +1,396 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VIRTIO based driver for vDPA device
+ *
+ * Copyright (c) 2020, Red Hat. All rights reserved.
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
+#include <linux/virtio.h>
+#include <linux/vdpa.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
+
+#define MOD_VERSION  "0.1"
+#define MOD_AUTHOR   "Jason Wang <jasowang@redhat.com>"
+#define MOD_DESC     "vDPA bus driver for virtio devices"
+#define MOD_LICENSE  "GPL v2"
+
+struct virtio_vdpa_device {
+	struct virtio_device vdev;
+	struct vdpa_device *vdpa;
+	u64 features;
+
+	/* The lock to protect virtqueue list */
+	spinlock_t lock;
+	/* List of virtio_vdpa_vq_info */
+	struct list_head virtqueues;
+};
+
+struct virtio_vdpa_vq_info {
+	/* the actual virtqueue */
+	struct virtqueue *vq;
+
+	/* the list node for the virtqueues list */
+	struct list_head node;
+};
+
+static inline struct virtio_vdpa_device *
+to_virtio_vdpa_device(struct virtio_device *dev)
+{
+	return container_of(dev, struct virtio_vdpa_device, vdev);
+}
+
+static struct vdpa_device *vd_get_vdpa(struct virtio_device *vdev)
+{
+	return to_virtio_vdpa_device(vdev)->vdpa;
+}
+
+static void virtio_vdpa_get(struct virtio_device *vdev, unsigned offset,
+			    void *buf, unsigned len)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	ops->get_config(vdpa, offset, buf, len);
+}
+
+static void virtio_vdpa_set(struct virtio_device *vdev, unsigned offset,
+			    const void *buf, unsigned len)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	ops->set_config(vdpa, offset, buf, len);
+}
+
+static u32 virtio_vdpa_generation(struct virtio_device *vdev)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	if (ops->get_generation)
+		return ops->get_generation(vdpa);
+
+	return 0;
+}
+
+static u8 virtio_vdpa_get_status(struct virtio_device *vdev)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	return ops->get_status(vdpa);
+}
+
+static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status=
)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	return ops->set_status(vdpa, status);
+}
+
+static void virtio_vdpa_reset(struct virtio_device *vdev)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	return ops->set_status(vdpa, 0);
+}
+
+static bool virtio_vdpa_notify(struct virtqueue *vq)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vq->vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	ops->kick_vq(vdpa, vq->index);
+
+	return true;
+}
+
+static irqreturn_t virtio_vdpa_config_cb(void *private)
+{
+	struct virtio_vdpa_device *vd_dev =3D private;
+
+	virtio_config_changed(&vd_dev->vdev);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t virtio_vdpa_virtqueue_cb(void *private)
+{
+	struct virtio_vdpa_vq_info *info =3D private;
+
+	return vring_interrupt(0, info->vq);
+}
+
+static struct virtqueue *
+virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
+		     void (*callback)(struct virtqueue *vq),
+		     const char *name, bool ctx)
+{
+	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev);
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct virtio_vdpa_vq_info *info;
+	struct vdpa_callback cb;
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
+	if (ops->get_vq_ready(vdpa, index))
+		return ERR_PTR(-ENOENT);
+
+	/* Allocate and fill out our active queue description */
+	info =3D kmalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	num =3D ops->get_vq_num_max(vdpa);
+	if (num =3D=3D 0) {
+		err =3D -ENOENT;
+		goto error_new_virtqueue;
+	}
+
+	/* Create the vring */
+	align =3D ops->get_vq_align(vdpa);
+	vq =3D vring_create_virtqueue(index, num, align, vdev,
+				    true, true, ctx,
+				    virtio_vdpa_notify, callback, name);
+	if (!vq) {
+		err =3D -ENOMEM;
+		goto error_new_virtqueue;
+	}
+
+	/* Setup virtqueue callback */
+	cb.callback =3D virtio_vdpa_virtqueue_cb;
+	cb.private =3D info;
+	ops->set_vq_cb(vdpa, index, &cb);
+	ops->set_vq_num(vdpa, index, virtqueue_get_vring_size(vq));
+
+	desc_addr =3D virtqueue_get_desc_addr(vq);
+	driver_addr =3D virtqueue_get_avail_addr(vq);
+	device_addr =3D virtqueue_get_used_addr(vq);
+
+	if (ops->set_vq_address(vdpa, index,
+				desc_addr, driver_addr,
+				device_addr)) {
+		err =3D -EINVAL;
+		goto err_vq;
+	}
+
+	ops->set_vq_ready(vdpa, index, 1);
+
+	vq->priv =3D info;
+	info->vq =3D vq;
+
+	spin_lock_irqsave(&vd_dev->lock, flags);
+	list_add(&info->node, &vd_dev->virtqueues);
+	spin_unlock_irqrestore(&vd_dev->lock, flags);
+
+	return vq;
+
+err_vq:
+	vring_del_virtqueue(vq);
+error_new_virtqueue:
+	ops->set_vq_ready(vdpa, index, 0);
+	/* VDPA driver should make sure vq is stopeed here */
+	WARN_ON(ops->get_vq_ready(vdpa, index));
+	kfree(info);
+	return ERR_PTR(err);
+}
+
+static void virtio_vdpa_del_vq(struct virtqueue *vq)
+{
+	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vq->vdev);
+	struct vdpa_device *vdpa =3D vd_dev->vdpa;
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct virtio_vdpa_vq_info *info =3D vq->priv;
+	unsigned int index =3D vq->index;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vd_dev->lock, flags);
+	list_del(&info->node);
+	spin_unlock_irqrestore(&vd_dev->lock, flags);
+
+	/* Select and deactivate the queue */
+	ops->set_vq_ready(vdpa, index, 0);
+	WARN_ON(ops->get_vq_ready(vdpa, index));
+
+	vring_del_virtqueue(vq);
+
+	kfree(info);
+}
+
+static void virtio_vdpa_del_vqs(struct virtio_device *vdev)
+{
+	struct virtqueue *vq, *n;
+
+	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
+		virtio_vdpa_del_vq(vq);
+}
+
+static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned nvq=
s,
+				struct virtqueue *vqs[],
+				vq_callback_t *callbacks[],
+				const char * const names[],
+				const bool *ctx,
+				struct irq_affinity *desc)
+{
+	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev);
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct vdpa_callback cb;
+	int i, err, queue_idx =3D 0;
+
+	for (i =3D 0; i < nvqs; ++i) {
+		if (!names[i]) {
+			vqs[i] =3D NULL;
+			continue;
+		}
+
+		vqs[i] =3D virtio_vdpa_setup_vq(vdev, queue_idx++,
+					      callbacks[i], names[i], ctx ?
+					      ctx[i] : false);
+		if (IS_ERR(vqs[i])) {
+			err =3D PTR_ERR(vqs[i]);
+			goto err_setup_vq;
+		}
+	}
+
+	cb.callback =3D virtio_vdpa_config_cb;
+	cb.private =3D vd_dev;
+	ops->set_config_cb(vdpa, &cb);
+
+	return 0;
+
+err_setup_vq:
+	virtio_vdpa_del_vqs(vdev);
+	return err;
+}
+
+static u64 virtio_vdpa_get_features(struct virtio_device *vdev)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	return ops->get_features(vdpa);
+}
+
+static int virtio_vdpa_finalize_features(struct virtio_device *vdev)
+{
+	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	return ops->set_features(vdpa, vdev->features);
+}
+
+static const char *virtio_vdpa_bus_name(struct virtio_device *vdev)
+{
+	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev);
+	struct vdpa_device *vdpa =3D vd_dev->vdpa;
+
+	return dev_name(&vdpa->dev);
+}
+
+static const struct virtio_config_ops virtio_vdpa_config_ops =3D {
+	.get		=3D virtio_vdpa_get,
+	.set		=3D virtio_vdpa_set,
+	.generation	=3D virtio_vdpa_generation,
+	.get_status	=3D virtio_vdpa_get_status,
+	.set_status	=3D virtio_vdpa_set_status,
+	.reset		=3D virtio_vdpa_reset,
+	.find_vqs	=3D virtio_vdpa_find_vqs,
+	.del_vqs	=3D virtio_vdpa_del_vqs,
+	.get_features	=3D virtio_vdpa_get_features,
+	.finalize_features =3D virtio_vdpa_finalize_features,
+	.bus_name	=3D virtio_vdpa_bus_name,
+};
+
+static void virtio_vdpa_release_dev(struct device *_d)
+{
+	struct virtio_device *vdev =3D
+	       container_of(_d, struct virtio_device, dev);
+	struct virtio_vdpa_device *vd_dev =3D
+	       container_of(vdev, struct virtio_vdpa_device, vdev);
+
+	kfree(vd_dev);
+}
+
+static int virtio_vdpa_probe(struct vdpa_device *vdpa)
+{
+	const struct vdpa_config_ops *ops =3D vdpa->config;
+	struct virtio_vdpa_device *vd_dev, *reg_dev =3D NULL;
+	int ret =3D -EINVAL;
+
+	vd_dev =3D kzalloc(sizeof(*vd_dev), GFP_KERNEL);
+	if (!vd_dev)
+		return -ENOMEM;
+
+	vd_dev->vdev.dev.parent =3D vdpa_get_dma_dev(vdpa);
+	vd_dev->vdev.dev.release =3D virtio_vdpa_release_dev;
+	vd_dev->vdev.config =3D &virtio_vdpa_config_ops;
+	vd_dev->vdpa =3D vdpa;
+	INIT_LIST_HEAD(&vd_dev->virtqueues);
+	spin_lock_init(&vd_dev->lock);
+
+	vd_dev->vdev.id.device =3D ops->get_device_id(vdpa);
+	if (vd_dev->vdev.id.device =3D=3D 0)
+		goto err;
+
+	vd_dev->vdev.id.vendor =3D ops->get_vendor_id(vdpa);
+	ret =3D register_virtio_device(&vd_dev->vdev);
+	reg_dev =3D vd_dev;
+	if (ret)
+		goto err;
+
+	vdpa_set_drvdata(vdpa, vd_dev);
+
+	return 0;
+
+err:
+	if (reg_dev)
+		put_device(&vd_dev->vdev.dev);
+	else
+		kfree(vd_dev);
+	return ret;
+}
+
+static void virtio_vdpa_remove(struct vdpa_device *vdpa)
+{
+	struct virtio_vdpa_device *vd_dev =3D vdpa_get_drvdata(vdpa);
+
+	unregister_virtio_device(&vd_dev->vdev);
+}
+
+static struct vdpa_driver virtio_vdpa_driver =3D {
+	.driver =3D {
+		.name	=3D "virtio_vdpa",
+	},
+	.probe	=3D virtio_vdpa_probe,
+	.remove =3D virtio_vdpa_remove,
+};
+
+module_vdpa_driver(virtio_vdpa_driver);
+
+MODULE_VERSION(MOD_VERSION);
+MODULE_LICENSE(MOD_LICENSE);
+MODULE_AUTHOR(MOD_AUTHOR);
+MODULE_DESCRIPTION(MOD_DESC);
--=20
2.20.1

