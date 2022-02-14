Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627F34B43A5
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbiBNIPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:15:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241707AbiBNIO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:14:56 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76395FF2E;
        Mon, 14 Feb 2022 00:14:48 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4OcHDr_1644826462;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4OcHDr_1644826462)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:23 +0800
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
Subject: [PATCH v5 06/22] virtio_ring: queue_reset: packed: support enable reset queue
Date:   Mon, 14 Feb 2022 16:14:00 +0800
Message-Id: <20220214081416.117695-7-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 24fd8391539b
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to make vring packed support re-enable reset
vq.

Based on whether the incoming vq passed by vring_setup_virtqueue() is
NULL or not, distinguish whether it is a normal create virtqueue or
re-enable a reset queue.

When re-enable a reset queue, reuse the original callback, name, indirect.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4639e1643c78..20659f7ca582 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1683,7 +1683,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	bool context,
 	bool (*notify)(struct virtqueue *),
 	void (*callback)(struct virtqueue *),
-	const char *name)
+	const char *name,
+	struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq;
 	struct vring_packed_desc *ring;
@@ -1713,13 +1714,20 @@ static struct virtqueue *vring_create_virtqueue_packed(
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
+
+		vq->vq.callback = callback;
+		vq->vq.name = name;
+		vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
+			!context;
+	}
 
-	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
-	vq->vq.name = name;
 	vq->vq.num_free = num;
 	vq->vq.index = index;
 	vq->we_own_ring = true;
@@ -1736,8 +1744,6 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->last_add_time_valid = false;
 #endif
 
-	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
-		!context;
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
@@ -1778,7 +1784,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 		goto err_desc_extra;
 
 	/* No callback?  Tell other side not to bother us. */
-	if (!callback) {
+	if (!vq->vq.callback) {
 		vq->packed.event_flags_shadow = VRING_PACKED_EVENT_FLAG_DISABLE;
 		vq->packed.vring.driver->flags =
 			cpu_to_le16(vq->packed.event_flags_shadow);
@@ -1792,7 +1798,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
 err_desc_extra:
 	kfree(vq->packed.desc_state);
 err_desc_state:
-	kfree(vq);
+	if (!_vq)
+		kfree(vq);
 err_vq:
 	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
 err_device:
@@ -2317,7 +2324,7 @@ struct virtqueue *vring_setup_virtqueue(
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return vring_create_virtqueue_packed(index, num, vring_align,
 				vdev, weak_barriers, may_reduce_num,
-				context, notify, callback, name);
+				context, notify, callback, name, vq);
 
 	return vring_create_virtqueue_split(index, num, vring_align,
 			vdev, weak_barriers, may_reduce_num,
-- 
2.31.0

