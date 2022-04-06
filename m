Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30354F5AAA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 12:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359608AbiDFKTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376905AbiDFKSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:18:34 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989BA264558;
        Tue,  5 Apr 2022 20:44:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0V9JnaOQ_1649216646;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9JnaOQ_1649216646)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 06 Apr 2022 11:44:07 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
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
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v9 09/32] virtio_ring: split: extract the logic of vq init
Date:   Wed,  6 Apr 2022 11:43:23 +0800
Message-Id: <20220406034346.74409-10-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 881cb3483d12
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the logic of initializing vq, and subsequent patches will call
it separately.

The feature of this part is that it does not depend on the information
passed by the upper layer and can be called repeatedly.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 68 ++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 083f2992ba0d..874f878087a3 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -916,6 +916,43 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
 	return NULL;
 }
 
+static void vring_virtqueue_init_split(struct vring_virtqueue *vq,
+				       struct virtio_device *vdev,
+				       bool own_ring)
+{
+	vq->packed_ring = false;
+	vq->vq.num_free = vq->split.vring.num;
+	vq->we_own_ring = own_ring;
+	vq->broken = false;
+	vq->last_used_idx = 0;
+	vq->event_triggered = false;
+	vq->num_added = 0;
+	vq->use_dma_api = vring_use_dma_api(vdev);
+#ifdef DEBUG
+	vq->in_use = false;
+	vq->last_add_time_valid = false;
+#endif
+
+	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
+
+	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
+		vq->weak_barriers = false;
+
+	vq->split.avail_flags_shadow = 0;
+	vq->split.avail_idx_shadow = 0;
+
+	/* No callback?  Tell other side not to bother us. */
+	if (!vq->vq.callback) {
+		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
+		if (!vq->event)
+			vq->split.vring.avail->flags = cpu_to_virtio16(vdev,
+					vq->split.avail_flags_shadow);
+	}
+
+	/* Put everything in free lists. */
+	vq->free_head = 0;
+}
+
 static void vring_virtqueue_attach_split(struct vring_virtqueue *vq,
 					 struct vring vring,
 					 struct vring_desc_state_split *desc_state,
@@ -2249,42 +2286,15 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	if (!vq)
 		return NULL;
 
-	vq->packed_ring = false;
 	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
 	vq->vq.name = name;
-	vq->vq.num_free = vring.num;
 	vq->vq.index = index;
-	vq->we_own_ring = false;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
-	vq->broken = false;
-	vq->last_used_idx = 0;
-	vq->event_triggered = false;
-	vq->num_added = 0;
-	vq->use_dma_api = vring_use_dma_api(vdev);
-#ifdef DEBUG
-	vq->in_use = false;
-	vq->last_add_time_valid = false;
-#endif
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
-	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
-
-	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
-		vq->weak_barriers = false;
-
-	vq->split.avail_flags_shadow = 0;
-	vq->split.avail_idx_shadow = 0;
-
-	/* No callback?  Tell other side not to bother us. */
-	if (!callback) {
-		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
-		if (!vq->event)
-			vq->split.vring.avail->flags = cpu_to_virtio16(vdev,
-					vq->split.avail_flags_shadow);
-	}
 
 	err = vring_alloc_state_extra_split(vring.num, &state, &extra);
 	if (err) {
@@ -2293,9 +2303,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	}
 
 	vring_virtqueue_attach_split(vq, vring, state, extra);
-
-	/* Put everything in free lists. */
-	vq->free_head = 0;
+	vring_virtqueue_init_split(vq, vdev, false);
 
 	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
-- 
2.31.0

