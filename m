Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4D418969B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCRIF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:05:26 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:20950 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727558AbgCRIFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:05:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584518723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bl02nMCzyQiSqtFEAH3mL6drjnhPYktb1L2cAf7iEM4=;
        b=J6d4i2wSQzToLb/ZeP4dHEnNJxWNRhHbPAguZzBPjmDcldc2yGq/OgLqCaR2HXSG/Yu9P7
        XwpP7KINnxOl6tyZcWlpSgMNtCrjbGvKcOfy8bX2jbW4XBfnVhkCyFNNESI1soIZVfie2t
        meIdUJGXAOvq+6p885E6Ncy/X+mlQcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-fU9aEqCVNjyAWnAMXY1c0Q-1; Wed, 18 Mar 2020 04:05:22 -0400
X-MC-Unique: fU9aEqCVNjyAWnAMXY1c0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DD9B477;
        Wed, 18 Mar 2020 08:05:19 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-166.pek2.redhat.com [10.72.13.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5395519C58;
        Wed, 18 Mar 2020 08:05:08 +0000 (UTC)
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
Subject: [PATCH V6 7/8] vdpasim: vDPA device simulator
Date:   Wed, 18 Mar 2020 16:03:26 +0800
Message-Id: <20200318080327.21958-8-jasowang@redhat.com>
In-Reply-To: <20200318080327.21958-1-jasowang@redhat.com>
References: <20200318080327.21958-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements a software vDPA networking device. The datapath
is implemented through vringh and workqueue. The device has an on-chip
IOMMU which translates IOVA to PA. For kernel virtio drivers, vDPA
simulator driver provides dma_ops. For vhost driers, set_map() methods
of vdpa_config_ops is implemented to accept mappings from vhost.

Currently, vDPA device simulator will loopback TX traffic to RX. So
the main use case for the device is vDPA feature testing, prototyping
and development.

Note, there's no management API implemented, a vDPA device will be
registered once the module is probed. We need to handle this in the
future development.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/vdpa/Kconfig             |  18 +
 drivers/virtio/vdpa/Makefile            |   1 +
 drivers/virtio/vdpa/vdpa_sim/Makefile   |   2 +
 drivers/virtio/vdpa/vdpa_sim/vdpa_sim.c | 646 ++++++++++++++++++++++++
 4 files changed, 667 insertions(+)
 create mode 100644 drivers/virtio/vdpa/vdpa_sim/Makefile
 create mode 100644 drivers/virtio/vdpa/vdpa_sim/vdpa_sim.c

diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
index 351617723d12..9baa1d8da002 100644
--- a/drivers/virtio/vdpa/Kconfig
+++ b/drivers/virtio/vdpa/Kconfig
@@ -5,3 +5,21 @@ config VDPA
 	  Enable this module to support vDPA device that uses a
 	  datapath which complies with virtio specifications with
 	  vendor specific control path.
+
+menuconfig VDPA_MENU
+	bool "VDPA drivers"
+	default n
+
+if VDPA_MENU
+
+config VDPA_SIM
+	tristate "vDPA device simulator"
+	select VDPA
+	depends on RUNTIME_TESTING_MENU && VHOST_RING
+	default n
+	help
+	  vDPA networking device simulator which loop TX traffic back
+	  to RX. This device is used for testing, prototyping and
+	  development of vDPA.
+
+endif # VDPA_MENU
diff --git a/drivers/virtio/vdpa/Makefile b/drivers/virtio/vdpa/Makefile
index ee6a35e8a4fb..3814af8e097b 100644
--- a/drivers/virtio/vdpa/Makefile
+++ b/drivers/virtio/vdpa/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_VDPA) +=3D vdpa.o
+obj-$(CONFIG_VDPA_SIM) +=3D vdpa_sim/
diff --git a/drivers/virtio/vdpa/vdpa_sim/Makefile b/drivers/virtio/vdpa/=
vdpa_sim/Makefile
new file mode 100644
index 000000000000..b40278f65e04
--- /dev/null
+++ b/drivers/virtio/vdpa/vdpa_sim/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_VDPA_SIM) +=3D vdpa_sim.o
diff --git a/drivers/virtio/vdpa/vdpa_sim/vdpa_sim.c b/drivers/virtio/vdp=
a/vdpa_sim/vdpa_sim.c
new file mode 100644
index 000000000000..da2e9964c48f
--- /dev/null
+++ b/drivers/virtio/vdpa/vdpa_sim/vdpa_sim.c
@@ -0,0 +1,646 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VDPA networking device simulator.
+ *
+ * Copyright (c) 2020, Red Hat Inc. All rights reserved.
+ *     Author: Jason Wang <jasowang@redhat.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/uuid.h>
+#include <linux/iommu.h>
+#include <linux/dma-mapping.h>
+#include <linux/sysfs.h>
+#include <linux/file.h>
+#include <linux/etherdevice.h>
+#include <linux/vringh.h>
+#include <linux/vdpa.h>
+#include <linux/vhost_iotlb.h>
+#include <uapi/linux/virtio_config.h>
+#include <uapi/linux/virtio_net.h>
+
+#define DRV_VERSION  "0.1"
+#define DRV_AUTHOR   "Jason Wang <jasowang@redhat.com>"
+#define DRV_DESC     "vDPA Device Simulator"
+#define DRV_LICENSE  "GPL v2"
+
+struct vdpasim_virtqueue {
+	struct vringh vring;
+	struct vringh_kiov iov;
+	unsigned short head;
+	bool ready;
+	u64 desc_addr;
+	u64 device_addr;
+	u64 driver_addr;
+	u32 num;
+	void *private;
+	irqreturn_t (*cb)(void *data);
+};
+
+#define VDPASIM_QUEUE_ALIGN PAGE_SIZE
+#define VDPASIM_QUEUE_MAX 256
+#define VDPASIM_DEVICE_ID 0x1
+#define VDPASIM_VENDOR_ID 0
+#define VDPASIM_VQ_NUM 0x2
+#define VDPASIM_NAME "vdpasim-netdev"
+
+static u64 vdpasim_features =3D (1ULL << VIRTIO_F_ANY_LAYOUT) |
+			      (1ULL << VIRTIO_F_VERSION_1)  |
+			      (1ULL << VIRTIO_F_IOMMU_PLATFORM);
+
+/* State of each vdpasim device */
+struct vdpasim {
+	struct vdpasim_virtqueue vqs[2];
+	struct work_struct work;
+	/* spinlock to synchronize virtqueue state */
+	spinlock_t lock;
+	struct vdpa_device *vdpa;
+	struct device dev;
+	struct virtio_net_config config;
+	struct vhost_iotlb *iommu;
+	void *buffer;
+	u32 status;
+	u32 generation;
+	u64 features;
+};
+
+static struct vdpasim *vdpasim_dev;
+
+static struct vdpasim *dev_to_sim(struct device *dev)
+{
+	return container_of(dev, struct vdpasim, dev);
+}
+
+static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
+{
+	struct device *d =3D &vdpa->dev;
+
+	return dev_to_sim(d->parent);
+}
+
+static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int id=
x)
+{
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+	int ret;
+
+	ret =3D vringh_init_iotlb(&vq->vring, vdpasim_features,
+				VDPASIM_QUEUE_MAX, false,
+				(struct vring_desc *)(uintptr_t)vq->desc_addr,
+				(struct vring_avail *)
+				(uintptr_t)vq->driver_addr,
+				(struct vring_used *)
+				(uintptr_t)vq->device_addr);
+}
+
+static void vdpasim_vq_reset(struct vdpasim_virtqueue *vq)
+{
+	vq->ready =3D 0;
+	vq->desc_addr =3D 0;
+	vq->driver_addr =3D 0;
+	vq->device_addr =3D 0;
+	vq->cb =3D NULL;
+	vq->private =3D NULL;
+	vringh_init_iotlb(&vq->vring, vdpasim_features, VDPASIM_QUEUE_MAX,
+			  false, NULL, NULL, NULL);
+}
+
+static void vdpasim_reset(struct vdpasim *vdpasim)
+{
+	int i;
+
+	for (i =3D 0; i < VDPASIM_VQ_NUM; i++)
+		vdpasim_vq_reset(&vdpasim->vqs[i]);
+
+	vhost_iotlb_reset(vdpasim->iommu);
+
+	vdpasim->features =3D 0;
+	vdpasim->status =3D 0;
+	++vdpasim->generation;
+}
+
+static void vdpasim_work(struct work_struct *work)
+{
+	struct vdpasim *vdpasim =3D container_of(work, struct
+						 vdpasim, work);
+	struct vdpasim_virtqueue *txq =3D &vdpasim->vqs[1];
+	struct vdpasim_virtqueue *rxq =3D &vdpasim->vqs[0];
+	size_t read, write, total_write;
+	int err;
+	int pkts =3D 0;
+
+	spin_lock(&vdpasim->lock);
+
+	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
+		goto out;
+
+	if (!txq->ready || !rxq->ready)
+		goto out;
+
+	while (true) {
+		total_write =3D 0;
+		err =3D vringh_getdesc_iotlb(&txq->vring, &txq->iov, NULL,
+					   &txq->head, GFP_ATOMIC);
+		if (err <=3D 0)
+			break;
+
+		err =3D vringh_getdesc_iotlb(&rxq->vring, NULL, &rxq->iov,
+					   &rxq->head, GFP_ATOMIC);
+		if (err <=3D 0) {
+			vringh_complete_iotlb(&txq->vring, txq->head, 0);
+			break;
+		}
+
+		while (true) {
+			read =3D vringh_iov_pull_iotlb(&txq->vring, &txq->iov,
+						     vdpasim->buffer,
+						     PAGE_SIZE);
+			if (read <=3D 0)
+				break;
+
+			write =3D vringh_iov_push_iotlb(&rxq->vring, &rxq->iov,
+						      vdpasim->buffer, read);
+			if (write <=3D 0)
+				break;
+
+			total_write +=3D write;
+		}
+
+		/* Make sure data is wrote before advancing index */
+		smp_wmb();
+
+		vringh_complete_iotlb(&txq->vring, txq->head, 0);
+		vringh_complete_iotlb(&rxq->vring, rxq->head, total_write);
+
+		/* Make sure used is visible before rasing the interrupt. */
+		smp_wmb();
+
+		local_bh_disable();
+		if (txq->cb)
+			txq->cb(txq->private);
+		if (rxq->cb)
+			rxq->cb(rxq->private);
+		local_bh_enable();
+
+		if (++pkts > 4) {
+			schedule_work(&vdpasim->work);
+			goto out;
+		}
+	}
+
+out:
+	spin_unlock(&vdpasim->lock);
+}
+
+static int dir_to_perm(enum dma_data_direction dir)
+{
+	int perm =3D -EFAULT;
+
+	switch (dir) {
+	case DMA_FROM_DEVICE:
+		perm =3D VHOST_MAP_WO;
+		break;
+	case DMA_TO_DEVICE:
+		perm =3D VHOST_MAP_RO;
+		break;
+	case DMA_BIDIRECTIONAL:
+		perm =3D VHOST_MAP_RW;
+		break;
+	default:
+		break;
+	}
+
+	return perm;
+}
+
+static dma_addr_t vdpasim_map_page(struct device *dev, struct page *page=
,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction dir,
+				   unsigned long attrs)
+{
+	struct vdpasim *vdpasim =3D dev_to_sim(dev);
+	struct vhost_iotlb *iommu =3D vdpasim->iommu;
+	u64 pa =3D (page_to_pfn(page) << PAGE_SHIFT) + offset;
+	int ret, perm =3D dir_to_perm(dir);
+
+	if (perm < 0)
+		return DMA_MAPPING_ERROR;
+
+	/* For simplicity, use identical mapping to avoid e.g iova
+	 * allocator.
+	 */
+	ret =3D vhost_iotlb_add_range(iommu, pa, pa + size - 1,
+				    pa, dir_to_perm(dir));
+	if (ret)
+		return DMA_MAPPING_ERROR;
+
+	return (dma_addr_t)(pa);
+}
+
+static void vdpasim_unmap_page(struct device *dev, dma_addr_t dma_addr,
+			       size_t size, enum dma_data_direction dir,
+			       unsigned long attrs)
+{
+	struct vdpasim *vdpasim =3D dev_to_sim(dev);
+	struct vhost_iotlb *iommu =3D vdpasim->iommu;
+
+	vhost_iotlb_del_range(iommu, (u64)dma_addr,
+			      (u64)dma_addr + size - 1);
+}
+
+static void *vdpasim_alloc_coherent(struct device *dev, size_t size,
+				    dma_addr_t *dma_addr, gfp_t flag,
+				    unsigned long attrs)
+{
+	struct vdpasim *vdpasim =3D dev_to_sim(dev);
+	struct vhost_iotlb *iommu =3D vdpasim->iommu;
+	void *addr =3D kmalloc(size, flag);
+	int ret;
+
+	if (!addr)
+		*dma_addr =3D DMA_MAPPING_ERROR;
+	else {
+		u64 pa =3D virt_to_phys(addr);
+
+		ret =3D vhost_iotlb_add_range(iommu, (u64)pa,
+					    (u64)pa + size - 1,
+					    pa, VHOST_MAP_RW);
+		if (ret) {
+			*dma_addr =3D DMA_MAPPING_ERROR;
+			kfree(addr);
+			addr =3D NULL;
+		} else
+			*dma_addr =3D (dma_addr_t)pa;
+	}
+
+	return addr;
+}
+
+static void vdpasim_free_coherent(struct device *dev, size_t size,
+				void *vaddr, dma_addr_t dma_addr,
+				unsigned long attrs)
+{
+	struct vdpasim *vdpasim =3D dev_to_sim(dev);
+	struct vhost_iotlb *iommu =3D vdpasim->iommu;
+
+	vhost_iotlb_del_range(iommu, (u64)dma_addr,
+			      (u64)dma_addr + size - 1);
+	kfree(phys_to_virt((uintptr_t)dma_addr));
+}
+
+static const struct dma_map_ops vdpasim_dma_ops =3D {
+	.map_page =3D vdpasim_map_page,
+	.unmap_page =3D vdpasim_unmap_page,
+	.alloc =3D vdpasim_alloc_coherent,
+	.free =3D vdpasim_free_coherent,
+};
+
+static const struct vdpa_config_ops vdpasim_net_config_ops;
+
+static void vdpasim_device_release(struct device *dev)
+{
+	struct vdpasim *vdpasim =3D dev_to_sim(dev);
+
+	cancel_work_sync(&vdpasim->work);
+	kfree(vdpasim->buffer);
+	if (vdpasim->iommu)
+		vhost_iotlb_free(vdpasim->iommu);
+	kfree(vdpasim);
+}
+
+static struct vdpasim *vdpasim_create(void)
+{
+	struct virtio_net_config *config;
+	struct vdpasim *vdpasim;
+	struct device *dev;
+	int ret =3D -ENOMEM;
+
+	vdpasim =3D kzalloc(sizeof(*vdpasim), GFP_KERNEL);
+	if (!vdpasim)
+		goto err_alloc;
+
+	INIT_WORK(&vdpasim->work, vdpasim_work);
+	spin_lock_init(&vdpasim->lock);
+
+	dev =3D &vdpasim->dev;
+	dev->release =3D vdpasim_device_release;
+	dev->coherent_dma_mask =3D DMA_BIT_MASK(64);
+	set_dma_ops(dev, &vdpasim_dma_ops);
+	dev_set_name(dev, "%s", VDPASIM_NAME);
+
+	device_initialize(&vdpasim->dev);
+
+	vdpasim->iommu =3D vhost_iotlb_alloc(2048, 0);
+	if (!vdpasim->iommu)
+		goto err_iommu;
+
+	vdpasim->buffer =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!vdpasim->buffer)
+		goto err_iommu;
+
+	config =3D &vdpasim->config;
+	config->mtu =3D 1500;
+	config->status =3D VIRTIO_NET_S_LINK_UP;
+	eth_random_addr(config->mac);
+
+	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
+	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
+
+	ret =3D device_add(&vdpasim->dev);
+	if (ret)
+		goto err_iommu;
+
+	vdpasim->vdpa =3D vdpa_alloc_device(dev, dev, &vdpasim_net_config_ops);
+	if (IS_ERR(vdpasim->vdpa))
+		goto err_vdpa;
+
+	ret =3D vdpa_register_device(vdpasim->vdpa);
+	if (ret)
+		goto err_register;
+
+	return vdpasim;
+
+err_register:
+	put_device(&vdpasim->vdpa->dev);
+err_vdpa:
+	device_del(&vdpasim->dev);
+	goto err_alloc;
+err_iommu:
+	put_device(&vdpasim->dev);
+err_alloc:
+	return ERR_PTR(ret);
+}
+
+static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u16 idx,
+				  u64 desc_area, u64 driver_area,
+				  u64 device_area)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+
+	vq->desc_addr =3D desc_area;
+	vq->driver_addr =3D driver_area;
+	vq->device_addr =3D device_area;
+
+	return 0;
+}
+
+static void vdpasim_set_vq_num(struct vdpa_device *vdpa, u16 idx, u32 nu=
m)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+
+	vq->num =3D num;
+}
+
+static void vdpasim_kick_vq(struct vdpa_device *vdpa, u16 idx)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+
+	if (vq->ready)
+		schedule_work(&vdpasim->work);
+}
+
+static void vdpasim_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
+			      struct vdpa_callback *cb)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+
+	vq->cb =3D cb->callback;
+	vq->private =3D cb->private;
+}
+
+static void vdpasim_set_vq_ready(struct vdpa_device *vdpa, u16 idx, bool=
 ready)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+
+	spin_lock(&vdpasim->lock);
+	vq->ready =3D ready;
+	if (vq->ready)
+		vdpasim_queue_ready(vdpasim, idx);
+	spin_unlock(&vdpasim->lock);
+}
+
+static bool vdpasim_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+
+	return vq->ready;
+}
+
+static int vdpasim_set_vq_state(struct vdpa_device *vdpa, u16 idx, u64 s=
tate)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+	struct vringh *vrh =3D &vq->vring;
+
+	spin_lock(&vdpasim->lock);
+	vrh->last_avail_idx =3D state;
+	spin_unlock(&vdpasim->lock);
+
+	return 0;
+}
+
+static u64 vdpasim_get_vq_state(struct vdpa_device *vdpa, u16 idx)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[idx];
+	struct vringh *vrh =3D &vq->vring;
+
+	return vrh->last_avail_idx;
+}
+
+static u16 vdpasim_get_vq_align(struct vdpa_device *vdpa)
+{
+	return VDPASIM_QUEUE_ALIGN;
+}
+
+static u64 vdpasim_get_features(struct vdpa_device *vdpa)
+{
+	return vdpasim_features;
+}
+
+static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+
+	/* DMA mapping must be done by driver */
+	if (!(features & (1ULL << VIRTIO_F_IOMMU_PLATFORM)))
+		return -EINVAL;
+
+	vdpasim->features =3D features & vdpasim_features;
+
+	return 0;
+}
+
+static void vdpasim_set_config_cb(struct vdpa_device *vdpa,
+				  struct vdpa_callback *cb)
+{
+	/* We don't support config interrupt */
+}
+
+static u16 vdpasim_get_vq_num_max(struct vdpa_device *vdpa)
+{
+	return VDPASIM_QUEUE_MAX;
+}
+
+static u32 vdpasim_get_device_id(struct vdpa_device *vdpa)
+{
+	return VDPASIM_DEVICE_ID;
+}
+
+static u32 vdpasim_get_vendor_id(struct vdpa_device *vdpa)
+{
+	return VDPASIM_VENDOR_ID;
+}
+
+static u8 vdpasim_get_status(struct vdpa_device *vdpa)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	u8 status;
+
+	spin_lock(&vdpasim->lock);
+	status =3D vdpasim->status;
+	spin_unlock(&vdpasim->lock);
+
+	return vdpasim->status;
+}
+
+static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+
+	spin_lock(&vdpasim->lock);
+	vdpasim->status =3D status;
+	if (status =3D=3D 0)
+		vdpasim_reset(vdpasim);
+	spin_unlock(&vdpasim->lock);
+}
+
+static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int of=
fset,
+			     void *buf, unsigned int len)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+
+	if (offset + len < sizeof(struct virtio_net_config))
+		memcpy(buf, &vdpasim->config + offset, len);
+}
+
+static void vdpasim_set_config(struct vdpa_device *vdpa, unsigned int of=
fset,
+			     const void *buf, unsigned int len)
+{
+	/* No writable config supportted by vdpasim */
+}
+
+static u32 vdpasim_get_generation(struct vdpa_device *vdpa)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+
+	return vdpasim->generation;
+}
+
+static int vdpasim_set_map(struct vdpa_device *vdpa,
+			   struct vhost_iotlb *iotlb)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+	struct vhost_iotlb_map *map;
+	u64 start =3D 0ULL, last =3D 0ULL - 1;
+	int ret;
+
+	vhost_iotlb_reset(vdpasim->iommu);
+
+	for (map =3D vhost_iotlb_itree_first(iotlb, start, last); map;
+	     map =3D vhost_iotlb_itree_next(map, start, last)) {
+		ret =3D vhost_iotlb_add_range(vdpasim->iommu, map->start,
+					    map->last, map->addr, map->perm);
+		if (ret)
+			goto err;
+	}
+	return 0;
+
+err:
+	vhost_iotlb_reset(vdpasim->iommu);
+	return ret;
+}
+
+static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
+			   u64 pa, u32 perm)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+
+	return vhost_iotlb_add_range(vdpasim->iommu, iova,
+				     iova + size - 1, pa, perm);
+}
+
+static int vdpasim_dma_unmap(struct vdpa_device *vdpa, u64 iova, u64 siz=
e)
+{
+	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
+
+	vhost_iotlb_del_range(vdpasim->iommu, iova, iova + size - 1);
+
+	return 0;
+}
+
+static const struct vdpa_config_ops vdpasim_net_config_ops =3D {
+	.set_vq_address         =3D vdpasim_set_vq_address,
+	.set_vq_num             =3D vdpasim_set_vq_num,
+	.kick_vq                =3D vdpasim_kick_vq,
+	.set_vq_cb              =3D vdpasim_set_vq_cb,
+	.set_vq_ready           =3D vdpasim_set_vq_ready,
+	.get_vq_ready           =3D vdpasim_get_vq_ready,
+	.set_vq_state           =3D vdpasim_set_vq_state,
+	.get_vq_state           =3D vdpasim_get_vq_state,
+	.get_vq_align           =3D vdpasim_get_vq_align,
+	.get_features           =3D vdpasim_get_features,
+	.set_features           =3D vdpasim_set_features,
+	.set_config_cb          =3D vdpasim_set_config_cb,
+	.get_vq_num_max         =3D vdpasim_get_vq_num_max,
+	.get_device_id          =3D vdpasim_get_device_id,
+	.get_vendor_id          =3D vdpasim_get_vendor_id,
+	.get_status             =3D vdpasim_get_status,
+	.set_status             =3D vdpasim_set_status,
+	.get_config             =3D vdpasim_get_config,
+	.set_config             =3D vdpasim_set_config,
+	.get_generation         =3D vdpasim_get_generation,
+	.set_map                =3D vdpasim_set_map,
+	.dma_map                =3D vdpasim_dma_map,
+	.dma_unmap              =3D vdpasim_dma_unmap,
+};
+
+static int __init vdpasim_dev_init(void)
+{
+	vdpasim_dev =3D vdpasim_create();
+
+	if (!IS_ERR(vdpasim_dev))
+		return 0;
+
+	return PTR_ERR(vdpasim_dev);
+}
+
+static void __exit vdpasim_dev_exit(void)
+{
+	struct vdpa_device *vdpa =3D vdpasim_dev->vdpa;
+
+	vdpa_unregister_device(vdpa);
+	device_unregister(&vdpasim_dev->dev);
+}
+
+module_init(vdpasim_dev_init)
+module_exit(vdpasim_dev_exit)
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE(DRV_LICENSE);
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESC);
--=20
2.20.1

