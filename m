Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649094D1788
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346853AbiCHMgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245548AbiCHMgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:36:35 -0500
Received: from out199-9.us.a.mail.aliyun.com (out199-9.us.a.mail.aliyun.com [47.90.199.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27098457A8;
        Tue,  8 Mar 2022 04:35:36 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V6eC9Qq_1646742929;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6eC9Qq_1646742929)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 20:35:30 +0800
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
Subject: [PATCH v7 05/26] virtio_ring: split: extract the logic of init vq and attach vring
Date:   Tue,  8 Mar 2022 20:34:57 +0800
Message-Id: <20220308123518.33800-6-xuanzhuo@linux.alibaba.com>
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

Split the logic of split assignment vq into three parts.

1. The assignment passed from the function parameter
2. The part that attaches vring to vq. -- __vring_virtqueue_attach_split()
3. The part that initializes vq to a fixed value --
   __vring_virtqueue_init_split()

This feature is required for subsequent virtuqueue reset vring

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 111 +++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 44 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index d32793615451..dc6313b79305 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2196,34 +2196,40 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 }
 EXPORT_SYMBOL_GPL(vring_interrupt);
 
-/* Only available for split ring */
-struct virtqueue *__vring_new_virtqueue(unsigned int index,
-					struct vring vring,
-					struct virtio_device *vdev,
-					bool weak_barriers,
-					bool context,
-					bool (*notify)(struct virtqueue *),
-					void (*callback)(struct virtqueue *),
-					const char *name)
+static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
+					  struct virtio_device *vdev,
+					  struct vring vring)
 {
-	struct vring_virtqueue *vq;
+	vq->vq.num_free = vring.num;
 
-	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
-		return NULL;
+	vq->split.vring = vring;
+	vq->split.queue_dma_addr = 0;
+	vq->split.queue_size_in_bytes = 0;
 
-	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
-	if (!vq)
-		return NULL;
+	vq->split.desc_state = kmalloc_array(vring.num,
+					     sizeof(struct vring_desc_state_split), GFP_KERNEL);
+	if (!vq->split.desc_state)
+		goto err_state;
 
+	vq->split.desc_extra = vring_alloc_desc_extra(vq, vring.num);
+	if (!vq->split.desc_extra)
+		goto err_extra;
+
+	memset(vq->split.desc_state, 0, vring.num *
+	       sizeof(struct vring_desc_state_split));
+	return 0;
+
+err_extra:
+	kfree(vq->split.desc_state);
+err_state:
+	return -ENOMEM;
+}
+
+static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
+					 struct virtio_device *vdev)
+{
 	vq->packed_ring = false;
-	vq->vq.callback = callback;
-	vq->vq.vdev = vdev;
-	vq->vq.name = name;
-	vq->vq.num_free = vring.num;
-	vq->vq.index = index;
 	vq->we_own_ring = false;
-	vq->notify = notify;
-	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
 	vq->last_used_idx = 0;
 	vq->event_triggered = false;
@@ -2234,50 +2240,67 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->last_add_time_valid = false;
 #endif
 
-	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
-		!context;
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
-	vq->split.queue_dma_addr = 0;
-	vq->split.queue_size_in_bytes = 0;
-
-	vq->split.vring = vring;
 	vq->split.avail_flags_shadow = 0;
 	vq->split.avail_idx_shadow = 0;
 
 	/* No callback?  Tell other side not to bother us. */
-	if (!callback) {
+	if (!vq->vq.callback) {
 		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
 		if (!vq->event)
 			vq->split.vring.avail->flags = cpu_to_virtio16(vdev,
 					vq->split.avail_flags_shadow);
 	}
 
-	vq->split.desc_state = kmalloc_array(vring.num,
-			sizeof(struct vring_desc_state_split), GFP_KERNEL);
-	if (!vq->split.desc_state)
-		goto err_state;
-
-	vq->split.desc_extra = vring_alloc_desc_extra(vq, vring.num);
-	if (!vq->split.desc_extra)
-		goto err_extra;
-
 	/* Put everything in free lists. */
 	vq->free_head = 0;
-	memset(vq->split.desc_state, 0, vring.num *
-			sizeof(struct vring_desc_state_split));
+}
+
+/* Only available for split ring */
+struct virtqueue *__vring_new_virtqueue(unsigned int index,
+					struct vring vring,
+					struct virtio_device *vdev,
+					bool weak_barriers,
+					bool context,
+					bool (*notify)(struct virtqueue *),
+					void (*callback)(struct virtqueue *),
+					const char *name)
+{
+	struct vring_virtqueue *vq;
+	int err;
+
+	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
+		return NULL;
+
+	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
+	if (!vq)
+		return NULL;
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
+	err = __vring_virtqueue_attach_split(vq, vdev, vring);
+	if (err)
+		goto err;
+
+	__vring_virtqueue_init_split(vq, vdev);
 
 	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 	spin_unlock(&vdev->vqs_list_lock);
-	return &vq->vq;
 
-err_extra:
-	kfree(vq->split.desc_state);
-err_state:
+	return &vq->vq;
+err:
 	kfree(vq);
 	return NULL;
 }
-- 
2.31.0

