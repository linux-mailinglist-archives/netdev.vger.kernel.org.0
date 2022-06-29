Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D04455F831
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiF2G5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiF2G51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:57:27 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68D531398;
        Tue, 28 Jun 2022 23:57:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VHml7x-_1656485836;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHml7x-_1656485836)
          by smtp.aliyun-inc.com;
          Wed, 29 Jun 2022 14:57:17 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: [PATCH v11 09/40] virtio_ring: split: extract the logic of alloc state and extra
Date:   Wed, 29 Jun 2022 14:56:25 +0800
Message-Id: <20220629065656.54420-10-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 3fdaf102dd89
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

Separate the logic of creating desc_state, desc_extra, and subsequent
patches will call it independently.

Since only the structure vring is passed into __vring_new_virtqueue(),
when creating the function vring_alloc_state_extra_split(), we prefer to
use vring_virtqueue_split as a parameter, and it will be more convenient
to pass vring_virtqueue_split to some subsequent functions.

So a new vring_virtqueue_split variable is added in
__vring_new_virtqueue().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 58 +++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index a9ceb9c16c54..cedd340d6db7 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -204,6 +204,7 @@ struct vring_virtqueue {
 #endif
 };
 
+static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num);
 
 /*
  * Helpers.
@@ -939,6 +940,32 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
 	return NULL;
 }
 
+static int vring_alloc_state_extra_split(struct vring_virtqueue_split *vring)
+{
+	struct vring_desc_state_split *state;
+	struct vring_desc_extra *extra;
+	u32 num = vring->vring.num;
+
+	state = kmalloc_array(num, sizeof(struct vring_desc_state_split), GFP_KERNEL);
+	if (!state)
+		goto err_state;
+
+	extra = vring_alloc_desc_extra(num);
+	if (!extra)
+		goto err_extra;
+
+	memset(state, 0, num * sizeof(struct vring_desc_state_split));
+
+	vring->desc_state = state;
+	vring->desc_extra = extra;
+	return 0;
+
+err_extra:
+	kfree(state);
+err_state:
+	return -ENOMEM;
+}
+
 static void vring_free_split(struct vring_virtqueue_split *vring,
 			     struct virtio_device *vdev)
 {
@@ -2224,7 +2251,7 @@ EXPORT_SYMBOL_GPL(vring_interrupt);
 
 /* Only available for split ring */
 struct virtqueue *__vring_new_virtqueue(unsigned int index,
-					struct vring vring,
+					struct vring _vring,
 					struct virtio_device *vdev,
 					bool weak_barriers,
 					bool context,
@@ -2232,7 +2259,9 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 					void (*callback)(struct virtqueue *),
 					const char *name)
 {
+	struct vring_virtqueue_split vring = {};
 	struct vring_virtqueue *vq;
+	int err;
 
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return NULL;
@@ -2261,7 +2290,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->split.queue_dma_addr = 0;
 	vq->split.queue_size_in_bytes = 0;
 
-	vq->split.vring = vring;
+	vq->split.vring = _vring;
 	vq->split.avail_flags_shadow = 0;
 	vq->split.avail_idx_shadow = 0;
 
@@ -2273,30 +2302,23 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 					vq->split.avail_flags_shadow);
 	}
 
-	vq->split.desc_state = kmalloc_array(vring.num,
-			sizeof(struct vring_desc_state_split), GFP_KERNEL);
-	if (!vq->split.desc_state)
-		goto err_state;
+	vring.vring = _vring;
 
-	vq->split.desc_extra = vring_alloc_desc_extra(vring.num);
-	if (!vq->split.desc_extra)
-		goto err_extra;
+	err = vring_alloc_state_extra_split(&vring);
+	if (err) {
+		kfree(vq);
+		return NULL;
+	}
 
-	memset(vq->split.desc_state, 0, vring.num *
-			sizeof(struct vring_desc_state_split));
+	vq->split.desc_state = vring.desc_state;
+	vq->split.desc_extra = vring.desc_extra;
 
-	virtqueue_init(vq, vq->split.vring.num);
+	virtqueue_init(vq, vring.vring.num);
 
 	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 	spin_unlock(&vdev->vqs_list_lock);
 	return &vq->vq;
-
-err_extra:
-	kfree(vq->split.desc_state);
-err_state:
-	kfree(vq);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
 
-- 
2.31.0

