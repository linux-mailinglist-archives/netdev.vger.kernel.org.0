Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DCC276738
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgIXD03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:26:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54201 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbgIXD02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+rilPBAsMXt6zsUPwIDn1uxXSz7Jh7iEk8zBLOz32K4=;
        b=gycui8XRgOUROtTkW27QIpW6em5VhRZJUPLOV8mSQbJBau39dAhPNCsRYPd2yobMn/B6dv
        wYTQoF9jOHefKLhJH9uSQBmTqIB8uM/f/oQDhRPySXcAhugHjJjnuSt5DLQJy3pvpVI30W
        Z54HwEFtNsmDsxT4ANc+TUJ/eRkatKg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-GZRxHkCyPdKAYUzKRTcoTw-1; Wed, 23 Sep 2020 23:26:23 -0400
X-MC-Unique: GZRxHkCyPdKAYUzKRTcoTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3830B420F0;
        Thu, 24 Sep 2020 03:26:22 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D6793782;
        Thu, 24 Sep 2020 03:26:07 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 24/24] vdpasim: control virtqueue support
Date:   Thu, 24 Sep 2020 11:21:25 +0800
Message-Id: <20200924032125.18619-25-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the control virtqueue support for vDPA
simulator. This is a requirement for supporting advanced features like
multiqueue.

A requirement for control virtqueue is to isolate its memory access
from the rx/tx virtqueues. This is because when using vDPA device
for VM, the control virqueue may not be assigned to VM
directly but shadowed by userspace VMM (Qemu).

The isolation is done via the virtqueue groups and ASID support in
vDPA through vhost-vdpa. The simulator is extended to have:

1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
2) two virtqueue groups: group 0 contains RX/TX, group 1 contains CVQ
3) two address spaces and the simulator simply implements the address
   spaces by mapping it 1:1 to IOTLB.

For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
to group 1. So we have:

1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
   RX and TX can be assigned to guest directly.
2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
   is the buffers that allocated and managed by userspace only so that
   guest can not access the CVQ of vhost-vdpa.

For the other use cases, since AS 0 is associated to all virtqueue
groups by default. All virtqueues share the same mapping by default.

To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
implemented in the simulator for the driver to set mac address.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 189 +++++++++++++++++++++++++++----
 1 file changed, 166 insertions(+), 23 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 66d901fb4c57..3459539c4460 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -56,14 +56,18 @@ struct vdpasim_virtqueue {
 #define VDPASIM_QUEUE_MAX 256
 #define VDPASIM_DEVICE_ID 0x1
 #define VDPASIM_VENDOR_ID 0
-#define VDPASIM_VQ_NUM 0x2
+#define VDPASIM_VQ_NUM 0x3
+#define VDPASIM_AS_NUM 0x2
+#define VDPASIM_GROUP_NUM 0x2
 #define VDPASIM_NAME "vdpasim-netdev"
 
 static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_F_VERSION_1)  |
 			      (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
 			      (1ULL << VIRTIO_NET_F_MTU) |
-			      (1ULL << VIRTIO_NET_F_MAC);
+			      (1ULL << VIRTIO_NET_F_MAC) |
+			      (1ULL << VIRTIO_NET_F_CTRL_VQ) |
+			      (1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR);
 
 /* State of each vdpasim device */
 struct vdpasim {
@@ -143,11 +147,17 @@ static void vdpasim_reset(struct vdpasim *vdpasim)
 {
 	int i;
 
-	for (i = 0; i < VDPASIM_VQ_NUM; i++)
+	spin_lock(&vdpasim->iommu_lock);
+
+	for (i = 0; i < VDPASIM_VQ_NUM; i++) {
 		vdpasim_vq_reset(&vdpasim->vqs[i]);
+		vringh_set_iotlb(&vdpasim->vqs[i].vring,
+				 &vdpasim->iommu[0]);
+	}
 
-	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_reset(vdpasim->iommu);
+	for (i = 0; i < VDPASIM_AS_NUM; i++) {
+		vhost_iotlb_reset(&vdpasim->iommu[i]);
+	}
 	spin_unlock(&vdpasim->iommu_lock);
 
 	vdpasim->features = 0;
@@ -187,6 +197,80 @@ static bool receive_filter(struct vdpasim *vdpasim, size_t len)
 	return false;
 }
 
+virtio_net_ctrl_ack vdpasim_handle_ctrl_mac(struct vdpasim *vdpasim,
+					    u8 cmd)
+{
+	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	size_t read;
+
+	switch (cmd) {
+	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov,
+					     (void *)vdpasim->config.mac,
+					     ETH_ALEN);
+		if (read == ETH_ALEN)
+			status = VIRTIO_NET_OK;
+		break;
+	default:
+		break;
+	}
+
+	return status;
+}
+
+static void vdpasim_handle_cvq(struct vdpasim *vdpasim)
+{
+	struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	struct virtio_net_ctrl_hdr ctrl;
+	size_t read, write;
+	int err;
+
+	if (!(vdpasim->features & (1ULL << VIRTIO_NET_F_CTRL_VQ)))
+		return;
+
+	if (!cvq->ready)
+		return;
+
+	while (true) {
+		err = vringh_getdesc_iotlb(&cvq->vring, &cvq->riov, &cvq->wiov,
+					   &cvq->head, GFP_ATOMIC);
+		if (err <= 0)
+			break;
+
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, &ctrl,
+					     sizeof(ctrl));
+		if (read != sizeof(ctrl))
+			break;
+
+		switch (ctrl.class) {
+		case VIRTIO_NET_CTRL_MAC:
+			status = vdpasim_handle_ctrl_mac(vdpasim, ctrl.cmd);
+			break;
+		default:
+			break;
+		}
+
+		/* Make sure data is wrote before advancing index */
+		smp_wmb();
+
+		write = vringh_iov_push_iotlb(&cvq->vring, &cvq->wiov,
+					      &status, sizeof (status));
+		vringh_complete_iotlb(&cvq->vring, cvq->head, write);
+		vringh_kiov_cleanup(&cvq->riov);
+		vringh_kiov_cleanup(&cvq->wiov);
+
+		/* Make sure used is visible before rasing the interrupt. */
+		smp_wmb();
+
+		local_bh_disable();
+		if (cvq->cb)
+			cvq->cb(cvq->private);
+		local_bh_enable();
+	}
+}
+
 static void vdpasim_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct
@@ -272,7 +356,7 @@ static dma_addr_t vdpasim_map_page(struct device *dev, struct page *page,
 				   unsigned long attrs)
 {
 	struct vdpasim *vdpasim = dev_to_sim(dev);
-	struct vhost_iotlb *iommu = vdpasim->iommu;
+	struct vhost_iotlb *iommu = &vdpasim->iommu[0];
 	u64 pa = (page_to_pfn(page) << PAGE_SHIFT) + offset;
 	int ret, perm = dir_to_perm(dir);
 
@@ -297,7 +381,7 @@ static void vdpasim_unmap_page(struct device *dev, dma_addr_t dma_addr,
 			       unsigned long attrs)
 {
 	struct vdpasim *vdpasim = dev_to_sim(dev);
-	struct vhost_iotlb *iommu = vdpasim->iommu;
+	struct vhost_iotlb *iommu = &vdpasim->iommu[0];
 
 	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_del_range(iommu, (u64)dma_addr,
@@ -310,7 +394,7 @@ static void *vdpasim_alloc_coherent(struct device *dev, size_t size,
 				    unsigned long attrs)
 {
 	struct vdpasim *vdpasim = dev_to_sim(dev);
-	struct vhost_iotlb *iommu = vdpasim->iommu;
+	struct vhost_iotlb *iommu = &vdpasim->iommu[0];
 	void *addr = kmalloc(size, flag);
 	int ret;
 
@@ -340,7 +424,7 @@ static void vdpasim_free_coherent(struct device *dev, size_t size,
 				  unsigned long attrs)
 {
 	struct vdpasim *vdpasim = dev_to_sim(dev);
-	struct vhost_iotlb *iommu = vdpasim->iommu;
+	struct vhost_iotlb *iommu = &vdpasim->iommu[0];
 
 	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_del_range(iommu, (u64)dma_addr,
@@ -366,14 +450,17 @@ static struct vdpasim *vdpasim_create(void)
 	struct vdpasim *vdpasim;
 	struct device *dev;
 	int ret = -ENOMEM;
+	int i;
 
 	if (batch_mapping)
 		ops = &vdpasim_net_batch_config_ops;
 	else
 		ops = &vdpasim_net_config_ops;
 
+	/* 3 virtqueues, 2 address spaces, 2 virtqueue groups */
 	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
-				    VDPASIM_VQ_NUM, 1, 1);
+				    VDPASIM_VQ_NUM, VDPASIM_AS_NUM,
+				    VDPASIM_GROUP_NUM);
 	if (!vdpasim)
 		goto err_alloc;
 
@@ -385,18 +472,23 @@ static struct vdpasim *vdpasim_create(void)
 	dev->coherent_dma_mask = DMA_BIT_MASK(64);
 	set_dma_ops(dev, &vdpasim_dma_ops);
 
-	vdpasim->iommu = vhost_iotlb_alloc(2048, 0);
+	vdpasim->iommu = kmalloc_array(VDPASIM_AS_NUM,
+				       sizeof(*vdpasim->iommu), GFP_KERNEL);
 	if (!vdpasim->iommu)
 		goto err_iommu;
 
+	for (i = 0; i < VDPASIM_AS_NUM; i++)
+		vhost_iotlb_init(&vdpasim->iommu[i], 0, 0);
+
 	vdpasim->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!vdpasim->buffer)
 		goto err_iommu;
 
 	eth_random_addr(vdpasim->config.mac);
 
-	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
-	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
+	/* Make sure that default ASID is zero */
+	for (i = 0; i < VDPASIM_VQ_NUM; i++)
+		vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0]);
 
 	vdpasim->vdpa.dma_dev = dev;
 	ret = vdpa_register_device(&vdpasim->vdpa);
@@ -438,7 +530,14 @@ static void vdpasim_kick_vq(struct vdpa_device *vdpa, u16 idx)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 
-	if (vq->ready)
+	if (idx == 2) {
+		/* Kernel virtio driver will do busy waiting for the
+		 * result, so we can't handle cvq in the workqueue.
+		 */
+		spin_lock(&vdpasim->lock);
+		vdpasim_handle_cvq(vdpasim);
+		spin_unlock(&vdpasim->lock);
+	} else if (vq->ready)
 		schedule_work(&vdpasim->work);
 }
 
@@ -504,7 +603,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
 
 static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
 {
-	return 0;
+	/* RX and TX belongs to group 0, CVQ belongs to group 1 */
+	if (idx == 2)
+		return 1;
+	else
+		return 0;
 }
 
 static u64 vdpasim_get_features(struct vdpa_device *vdpa)
@@ -600,20 +703,53 @@ static u32 vdpasim_get_generation(struct vdpa_device *vdpa)
 	return vdpasim->generation;
 }
 
+int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
+			   unsigned int asid)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	struct vhost_iotlb *iommu;
+	int i;
+
+	if (group > VDPASIM_GROUP_NUM)
+		return -EINVAL;
+
+	if (asid > VDPASIM_AS_NUM)
+		return -EINVAL;
+
+	iommu = &vdpasim->iommu[asid];
+
+	spin_lock(&vdpasim->lock);
+
+	for (i = 0; i < VDPASIM_VQ_NUM; i++)
+		if (vdpasim_get_vq_group(vdpa, i) == group)
+			vringh_set_iotlb(&vdpasim->vqs[i].vring, iommu);
+
+	spin_unlock(&vdpasim->lock);
+
+	return 0;
+}
+
+
 static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 			   struct vhost_iotlb *iotlb)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	struct vhost_iotlb_map *map;
+	struct vhost_iotlb *iommu;
 	u64 start = 0ULL, last = 0ULL - 1;
 	int ret;
 
+	if (asid >= VDPASIM_AS_NUM)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_reset(vdpasim->iommu);
+
+	iommu = &vdpasim->iommu[asid];
+	vhost_iotlb_reset(iommu);
 
 	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
 	     map = vhost_iotlb_itree_next(map, start, last)) {
-		ret = vhost_iotlb_add_range(vdpasim->iommu, map->start,
+		ret = vhost_iotlb_add_range(iommu, map->start,
 					    map->last, map->addr, map->perm);
 		if (ret)
 			goto err;
@@ -622,7 +758,7 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 	return 0;
 
 err:
-	vhost_iotlb_reset(vdpasim->iommu);
+	vhost_iotlb_reset(iommu);
 	spin_unlock(&vdpasim->iommu_lock);
 	return ret;
 }
@@ -634,9 +770,12 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int ret;
 
+	if (asid >= VDPASIM_AS_NUM)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	ret = vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size - 1, pa,
-				    perm);
+	ret = vhost_iotlb_add_range(&vdpasim->iommu[asid], iova,
+				    iova + size - 1, pa, perm);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return ret;
@@ -647,8 +786,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
+	if (asid >= VDPASIM_AS_NUM)
+		return -EINVAL;
+
 	spin_lock(&vdpasim->iommu_lock);
-	vhost_iotlb_del_range(vdpasim->iommu, iova, iova + size - 1);
+	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
 
 	return 0;
@@ -660,8 +802,7 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 
 	cancel_work_sync(&vdpasim->work);
 	kfree(vdpasim->buffer);
-	if (vdpasim->iommu)
-		vhost_iotlb_free(vdpasim->iommu);
+	vhost_iotlb_free(vdpasim->iommu);
 }
 
 static const struct vdpa_config_ops vdpasim_net_config_ops = {
@@ -686,6 +827,7 @@ static const struct vdpa_config_ops vdpasim_net_config_ops = {
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
+	.set_group_asid         = vdpasim_set_group_asid,
 	.dma_map                = vdpasim_dma_map,
 	.dma_unmap              = vdpasim_dma_unmap,
 	.free                   = vdpasim_free,
@@ -713,6 +855,7 @@ static const struct vdpa_config_ops vdpasim_net_batch_config_ops = {
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
+	.set_group_asid         = vdpasim_set_group_asid,
 	.set_map                = vdpasim_set_map,
 	.free                   = vdpasim_free,
 };
-- 
2.20.1

