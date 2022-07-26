Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1498580CF8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbiGZHXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238161AbiGZHXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:23:16 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A602B278;
        Tue, 26 Jul 2022 00:23:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VKUB8sV_1658820182;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VKUB8sV_1658820182)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 15:23:03 +0800
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
Subject: [PATCH v13 19/42] virtio_ring: packed: extract the logic of alloc state and extra
Date:   Tue, 26 Jul 2022 15:22:02 +0800
Message-Id: <20220726072225.19884-20-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 19d2a6aae0b1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the logic for alloc desc_state and desc_extra, which will
be called separately by subsequent patches.

Use struct vring_packed to pass desc_state, desc_extra.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 48 +++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 10cc2b7e3588..32590d763c3b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1908,6 +1908,33 @@ static int vring_alloc_queue_packed(struct vring_virtqueue_packed *vring_packed,
 	return -ENOMEM;
 }
 
+static int vring_alloc_state_extra_packed(struct vring_virtqueue_packed *vring_packed)
+{
+	struct vring_desc_state_packed *state;
+	struct vring_desc_extra *extra;
+	u32 num = vring_packed->vring.num;
+
+	state = kmalloc_array(num, sizeof(struct vring_desc_state_packed), GFP_KERNEL);
+	if (!state)
+		goto err_desc_state;
+
+	memset(state, 0, num * sizeof(struct vring_desc_state_packed));
+
+	extra = vring_alloc_desc_extra(num);
+	if (!extra)
+		goto err_desc_extra;
+
+	vring_packed->desc_state = state;
+	vring_packed->desc_extra = extra;
+
+	return 0;
+
+err_desc_extra:
+	kfree(state);
+err_desc_state:
+	return -ENOMEM;
+}
+
 static struct virtqueue *vring_create_virtqueue_packed(
 	unsigned int index,
 	unsigned int num,
@@ -1922,6 +1949,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 {
 	struct vring_virtqueue_packed vring_packed = {};
 	struct vring_virtqueue *vq;
+	int err;
 
 	if (vring_alloc_queue_packed(&vring_packed, vdev, num))
 		goto err_ring;
@@ -1961,18 +1989,12 @@ static struct virtqueue *vring_create_virtqueue_packed(
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
+	err = vring_alloc_state_extra_packed(&vring_packed);
+	if (err)
+		goto err_state_extra;
 
-	vq->packed.desc_extra = vring_alloc_desc_extra(num);
-	if (!vq->packed.desc_extra)
-		goto err_desc_extra;
+	vq->packed.desc_state = vring_packed.desc_state;
+	vq->packed.desc_extra = vring_packed.desc_extra;
 
 	/* No callback?  Tell other side not to bother us. */
 	if (!callback) {
@@ -1988,9 +2010,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	spin_unlock(&vdev->vqs_list_lock);
 	return &vq->vq;
 
-err_desc_extra:
-	kfree(vq->packed.desc_state);
-err_desc_state:
+err_state_extra:
 	kfree(vq);
 err_vq:
 	vring_free_packed(&vring_packed, vdev);
-- 
2.31.0

