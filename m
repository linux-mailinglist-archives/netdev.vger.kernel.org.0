Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F0F4D17B7
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239341AbiCHMgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346892AbiCHMgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:36:46 -0500
Received: from out199-6.us.a.mail.aliyun.com (out199-6.us.a.mail.aliyun.com [47.90.199.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACC74552B;
        Tue,  8 Mar 2022 04:35:42 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V6ebqTT_1646742933;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6ebqTT_1646742933)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 20:35:34 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v7 07/26] virtio_ring: packed: extract the logic of init vq and attach vring
Date:   Tue,  8 Mar 2022 20:34:59 +0800
Message-Id: <20220308123518.33800-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: f06b131dbfed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the logic of packed assignment vq into three parts.

1. The assignment passed from the function parameter
2. The part that attaches vring to vq. -- vring_virtqueue_attach_packed()
3. The part that initializes vq to a fixed value --
vring_virtqueue_init_packed()

This feature is required for subsequent virtuqueue reset vring

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 138 +++++++++++++++++++++--------------
 1 file changed, 82 insertions(+), 56 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1af98b112996..b5a9bf4f45b3 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1773,36 +1773,53 @@ static int vring_create_vring_packed(struct vring_packed *vring,
 	return -ENOMEM;
 }
 
-static struct virtqueue *vring_create_virtqueue_packed(
-	unsigned int index,
-	unsigned int num,
-	unsigned int vring_align,
-	struct virtio_device *vdev,
-	bool weak_barriers,
-	bool may_reduce_num,
-	bool context,
-	bool (*notify)(struct virtqueue *),
-	void (*callback)(struct virtqueue *),
-	const char *name)
+static int vring_virtqueue_attach_packed(struct vring_virtqueue *vq,
+					 struct vring_packed *vring,
+					 struct virtio_device *vdev)
 {
-	struct vring_virtqueue *vq;
-	struct vring_packed vring;
-
-	if (vring_create_vring_packed(&vring, vdev, num))
-		goto err_vq;
+	u32 num;
 
-	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
-	if (!vq)
-		goto err_vq;
+	num = vring->num;
 
-	vq->vq.callback = callback;
-	vq->vq.vdev = vdev;
-	vq->vq.name = name;
 	vq->vq.num_free = num;
-	vq->vq.index = index;
+
+	vq->packed.ring_dma_addr = vring->ring_dma_addr;
+	vq->packed.driver_event_dma_addr = vring->driver_event_dma_addr;
+	vq->packed.device_event_dma_addr = vring->device_event_dma_addr;
+
+	vq->packed.ring_size_in_bytes = vring->ring_size_in_bytes;
+	vq->packed.event_size_in_bytes = vring->event_size_in_bytes;
+
+	vq->packed.vring.num = num;
+	vq->packed.vring.desc = vring->ring;
+	vq->packed.vring.driver = vring->driver;
+	vq->packed.vring.device = vring->device;
+
+	vq->packed.desc_state = kmalloc_array(num,
+			sizeof(struct vring_desc_state_packed),
+			GFP_KERNEL);
+	if (!vq->packed.desc_state)
+		goto err_desc_state;
+
+	memset(vq->packed.desc_state, 0,
+		num * sizeof(struct vring_desc_state_packed));
+
+	vq->packed.desc_extra = vring_alloc_desc_extra(vq, num);
+	if (!vq->packed.desc_extra)
+		goto err_desc_extra;
+
+	return 0;
+
+err_desc_extra:
+	kfree(vq->packed.desc_state);
+err_desc_state:
+	return -ENOMEM;
+}
+
+static void vring_virtqueue_init_packed(struct vring_virtqueue *vq,
+					struct virtio_device *vdev)
+{
 	vq->we_own_ring = true;
-	vq->notify = notify;
-	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
 	vq->last_used_idx = 0;
 	vq->event_triggered = false;
@@ -1814,62 +1831,71 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->last_add_time_valid = false;
 #endif
 
-	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
-		!context;
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
-	vq->packed.ring_dma_addr = vring.ring_dma_addr;
-	vq->packed.driver_event_dma_addr = vring.driver_event_dma_addr;
-	vq->packed.device_event_dma_addr = vring.device_event_dma_addr;
-
-	vq->packed.ring_size_in_bytes = vring.ring_size_in_bytes;
-	vq->packed.event_size_in_bytes = vring.event_size_in_bytes;
-
-	vq->packed.vring.num = num;
-	vq->packed.vring.desc = vring.ring;
-	vq->packed.vring.driver = vring.driver;
-	vq->packed.vring.device = vring.device;
-
 	vq->packed.next_avail_idx = 0;
 	vq->packed.avail_wrap_counter = 1;
 	vq->packed.used_wrap_counter = 1;
 	vq->packed.event_flags_shadow = 0;
 	vq->packed.avail_used_flags = 1 << VRING_PACKED_DESC_F_AVAIL;
 
-	vq->packed.desc_state = kmalloc_array(num,
-			sizeof(struct vring_desc_state_packed),
-			GFP_KERNEL);
-	if (!vq->packed.desc_state)
-		goto err_desc_state;
-
-	memset(vq->packed.desc_state, 0,
-		num * sizeof(struct vring_desc_state_packed));
-
 	/* Put everything in free lists. */
 	vq->free_head = 0;
 
-	vq->packed.desc_extra = vring_alloc_desc_extra(vq, num);
-	if (!vq->packed.desc_extra)
-		goto err_desc_extra;
-
 	/* No callback?  Tell other side not to bother us. */
-	if (!callback) {
+	if (!vq->vq.callback) {
 		vq->packed.event_flags_shadow = VRING_PACKED_EVENT_FLAG_DISABLE;
 		vq->packed.vring.driver->flags =
 			cpu_to_le16(vq->packed.event_flags_shadow);
 	}
+}
+
+static struct virtqueue *vring_create_virtqueue_packed(
+	unsigned int index,
+	unsigned int num,
+	unsigned int vring_align,
+	struct virtio_device *vdev,
+	bool weak_barriers,
+	bool may_reduce_num,
+	bool context,
+	bool (*notify)(struct virtqueue *),
+	void (*callback)(struct virtqueue *),
+	const char *name)
+{
+	struct vring_virtqueue *vq;
+	struct vring_packed vring;
+
+	if (vring_create_vring_packed(&vring, vdev, num))
+		goto err_vq;
+
+	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
+	if (!vq)
+		goto err_vq;
+
+	vq->vq.callback = callback;
+	vq->vq.vdev = vdev;
+	vq->vq.name = name;
+	vq->vq.index = index;
+	vq->notify = notify;
+	vq->weak_barriers = weak_barriers;
+	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
+		!context;
+
+	if (vring_virtqueue_attach_packed(vq, &vring, vdev))
+		goto err;
+
+	vring_virtqueue_init_packed(vq, vdev);
 
 	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 	spin_unlock(&vdev->vqs_list_lock);
+
 	return &vq->vq;
 
-err_desc_extra:
-	kfree(vq->packed.desc_state);
-err_desc_state:
+err:
 	kfree(vq);
 err_vq:
 	vring_free_vring_packed(&vring, vdev);
-- 
2.31.0

