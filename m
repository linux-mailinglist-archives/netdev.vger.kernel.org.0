Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B404C49C499
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbiAZHgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:36:16 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:50685 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237915AbiAZHfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:47 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2uPGNw_1643182542;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2uPGNw_1643182542)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:42 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v3 08/17] virtio_ring: queue_reset: packed: support enable reset queue
Date:   Wed, 26 Jan 2022 15:35:24 +0800
Message-Id: <20220126073533.44994-9-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to make vring packed support re-enable reset
vq.

The core idea is that when calling vring_create_virtqueue_packed, use the
existing vq instead of re-allocating vq. vq is passed in through
function parameters.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index a93a677008ba..4beb7c7127c1 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1680,7 +1680,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	bool context,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
-	const char *name)
+	const char *name,
+	struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq;
 	struct vring_packed_desc *ring;
@@ -1710,15 +1711,20 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	if (!device)
 		goto err_device;
 
-	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
-	if (!vq)
-		goto err_vq;
+	if (_vq) {
+		vq = to_vvq(_vq);
+	} else {
+		vq = kmalloc(sizeof(*vq), GFP_KERNEL);
+		if (!vq)
+			goto err_vq;
+	}
 
 	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
 	vq->vq.name = name;
 	vq->vq.num_free = num;
 	vq->vq.index = index;
+	vq->vq.reset = false;
 	vq->we_own_ring = true;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
@@ -1789,7 +1795,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
 err_desc_extra:
 	kfree(vq->packed.desc_state);
 err_desc_state:
-	kfree(vq);
+	if (!_vq)
+		kfree(vq);
 err_vq:
 	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
 err_device:
@@ -2311,7 +2318,7 @@ struct virtqueue *vring_setup_virtqueue(
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return vring_create_virtqueue_packed(index, num, vring_align,
 				vdev, weak_barriers, may_reduce_num,
-				context, notify, callback, name);
+				context, notify, callback, name, vq);
 
 	return vring_create_virtqueue_split(index, num, vring_align,
 			vdev, weak_barriers, may_reduce_num,
-- 
2.31.0

