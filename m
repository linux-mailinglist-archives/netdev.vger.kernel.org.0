Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC63033C23A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhCOQhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:37:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234355AbhCOQhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:37:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bgdRda8gjRmGBNfAjmwV9NMHKH6Ye2bg31lslzLl2y4=;
        b=I/UkOqAbqbY1uNdnt/1g0mBj7CTMDzqjYldMMv62hibmIGjIyotx4+3XqVH2KYNi6F82MH
        6hjJRR8nTrObCaJSNkIec13mUrhv9jRfWx0/DrNtvuhnmLkVoN4qf6hzLYWTHMmAqTF9sW
        2qb8c3Mw4zoT61fTR8dqjTzGWBqBLKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-t039BIq9MEC9AW-OM_C7cw-1; Mon, 15 Mar 2021 12:36:59 -0400
X-MC-Unique: t039BIq9MEC9AW-OM_C7cw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD6D3A40C0;
        Mon, 15 Mar 2021 16:36:57 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85B745D705;
        Mon, 15 Mar 2021 16:36:49 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 12/14] vdpa_sim_blk: implement ramdisk behaviour
Date:   Mon, 15 Mar 2021 17:34:48 +0100
Message-Id: <20210315163450.254396-13-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous implementation wrote only the status of each request.
This patch implements a more accurate block device simulator,
providing a ramdisk-like behavior and adding input validation.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
- used %zd %zx to print size_t and ssize_t variables in dev_err()
- removed unnecessary new line [Jason]
- moved VIRTIO_BLK_T_GET_ID in another patch [Jason]
- used push/pull instead of write/read terminology
- added vdpasim_blk_check_range() to avoid overflows [Stefan]
- use vdpasim*_to_cpu instead of le*_to_cpu
- used vringh_kiov_length() helper [Jason]
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 164 ++++++++++++++++++++++++---
 1 file changed, 146 insertions(+), 18 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 64926a70af5e..a31964e3e5a4 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -3,6 +3,7 @@
  * VDPA simulator for block device.
  *
  * Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
+ * Copyright (c) 2021, Red Hat Inc. All rights reserved.
  *
  */
 
@@ -14,6 +15,7 @@
 #include <linux/blkdev.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
+#include <linux/blkdev.h>
 #include <uapi/linux/virtio_blk.h>
 
 #include "vdpa_sim.h"
@@ -37,10 +39,151 @@
 
 static struct vdpasim *vdpasim_blk_dev;
 
+static bool vdpasim_blk_check_range(u64 start_sector, size_t range_size)
+{
+	u64 range_sectors = range_size >> SECTOR_SHIFT;
+
+	if (range_size > VDPASIM_BLK_SIZE_MAX * VDPASIM_BLK_SEG_MAX)
+		return false;
+
+	if (start_sector > VDPASIM_BLK_CAPACITY)
+		return false;
+
+	if (range_sectors > VDPASIM_BLK_CAPACITY - start_sector)
+		return false;
+
+	return true;
+}
+
+/* Returns 'true' if the request is handled (with or without an I/O error)
+ * and the status is correctly written in the last byte of the 'in iov',
+ * 'false' otherwise.
+ */
+static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
+				   struct vdpasim_virtqueue *vq)
+{
+	size_t pushed = 0, to_pull, to_push;
+	struct virtio_blk_outhdr hdr;
+	ssize_t bytes;
+	loff_t offset;
+	u64 sector;
+	u8 status;
+	u32 type;
+	int ret;
+
+	ret = vringh_getdesc_iotlb(&vq->vring, &vq->out_iov, &vq->in_iov,
+				   &vq->head, GFP_ATOMIC);
+	if (ret != 1)
+		return false;
+
+	if (vq->out_iov.used < 1 || vq->in_iov.used < 1) {
+		dev_err(&vdpasim->vdpa.dev, "missing headers - out_iov: %u in_iov %u\n",
+			vq->out_iov.used, vq->in_iov.used);
+		return false;
+	}
+
+	if (vq->in_iov.iov[vq->in_iov.used - 1].iov_len < 1) {
+		dev_err(&vdpasim->vdpa.dev, "request in header too short\n");
+		return false;
+	}
+
+	/* The last byte is the status and we checked if the last iov has
+	 * enough room for it.
+	 */
+	to_push = vringh_kiov_length(&vq->in_iov) - 1;
+
+	to_pull = vringh_kiov_length(&vq->out_iov);
+
+	bytes = vringh_iov_pull_iotlb(&vq->vring, &vq->out_iov, &hdr,
+				      sizeof(hdr));
+	if (bytes != sizeof(hdr)) {
+		dev_err(&vdpasim->vdpa.dev, "request out header too short\n");
+		return false;
+	}
+
+	to_pull -= bytes;
+
+	type = vdpasim32_to_cpu(vdpasim, hdr.type);
+	sector = vdpasim64_to_cpu(vdpasim, hdr.sector);
+	offset = sector << SECTOR_SHIFT;
+	status = VIRTIO_BLK_S_OK;
+
+	switch (type) {
+	case VIRTIO_BLK_T_IN:
+		if (!vdpasim_blk_check_range(sector, to_push)) {
+			dev_err(&vdpasim->vdpa.dev,
+				"reading over the capacity - offset: 0x%llx len: 0x%zx\n",
+				offset, to_push);
+			status = VIRTIO_BLK_S_IOERR;
+			break;
+		}
+
+		bytes = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
+					      vdpasim->buffer + offset,
+					      to_push);
+		if (bytes < 0) {
+			dev_err(&vdpasim->vdpa.dev,
+				"vringh_iov_push_iotlb() error: %zd offset: 0x%llx len: 0x%zx\n",
+				bytes, offset, to_push);
+			status = VIRTIO_BLK_S_IOERR;
+			break;
+		}
+
+		pushed += bytes;
+		break;
+
+	case VIRTIO_BLK_T_OUT:
+		if (!vdpasim_blk_check_range(sector, to_pull)) {
+			dev_err(&vdpasim->vdpa.dev,
+				"writing over the capacity - offset: 0x%llx len: 0x%zx\n",
+				offset, to_pull);
+			status = VIRTIO_BLK_S_IOERR;
+			break;
+		}
+
+		bytes = vringh_iov_pull_iotlb(&vq->vring, &vq->out_iov,
+					      vdpasim->buffer + offset,
+					      to_pull);
+		if (bytes < 0) {
+			dev_err(&vdpasim->vdpa.dev,
+				"vringh_iov_pull_iotlb() error: %zd offset: 0x%llx len: 0x%zx\n",
+				bytes, offset, to_pull);
+			status = VIRTIO_BLK_S_IOERR;
+			break;
+		}
+		break;
+
+	default:
+		dev_warn(&vdpasim->vdpa.dev,
+			 "Unsupported request type %d\n", type);
+		status = VIRTIO_BLK_S_IOERR;
+		break;
+	}
+
+	/* If some operations fail, we need to skip the remaining bytes
+	 * to put the status in the last byte
+	 */
+	if (to_push - pushed > 0)
+		vringh_kiov_advance(&vq->in_iov, to_push - pushed);
+
+	/* Last byte is the status */
+	bytes = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov, &status, 1);
+	if (bytes != 1)
+		return false;
+
+	pushed += bytes;
+
+	/* Make sure data is wrote before advancing index */
+	smp_wmb();
+
+	vringh_complete_iotlb(&vq->vring, vq->head, pushed);
+
+	return true;
+}
+
 static void vdpasim_blk_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
-	u8 status = VIRTIO_BLK_S_OK;
 	int i;
 
 	spin_lock(&vdpasim->lock);
@@ -54,22 +197,7 @@ static void vdpasim_blk_work(struct work_struct *work)
 		if (!vq->ready)
 			continue;
 
-		while (vringh_getdesc_iotlb(&vq->vring, &vq->out_iov,
-					    &vq->in_iov, &vq->head,
-					    GFP_ATOMIC) > 0) {
-			int write;
-
-			vq->in_iov.i = vq->in_iov.used - 1;
-			write = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
-						      &status, 1);
-			if (write <= 0)
-				break;
-
-			/* Make sure data is wrote before advancing index */
-			smp_wmb();
-
-			vringh_complete_iotlb(&vq->vring, vq->head, write);
-
+		while (vdpasim_blk_handle_req(vdpasim, vq)) {
 			/* Make sure used is visible before rasing the interrupt. */
 			smp_wmb();
 
@@ -109,7 +237,7 @@ static int __init vdpasim_blk_init(void)
 	dev_attr.config_size = sizeof(struct virtio_blk_config);
 	dev_attr.get_config = vdpasim_blk_get_config;
 	dev_attr.work_fn = vdpasim_blk_work;
-	dev_attr.buffer_size = PAGE_SIZE;
+	dev_attr.buffer_size = VDPASIM_BLK_CAPACITY << SECTOR_SHIFT;
 
 	vdpasim_blk_dev = vdpasim_create(&dev_attr);
 	if (IS_ERR(vdpasim_blk_dev)) {
-- 
2.30.2

