Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFFF586488
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 08:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbiHAGkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 02:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbiHAGkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 02:40:10 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F97814D36;
        Sun, 31 Jul 2022 23:39:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VL1cCPm_1659335966;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VL1cCPm_1659335966)
          by smtp.aliyun-inc.com;
          Mon, 01 Aug 2022 14:39:27 +0800
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
Subject: [PATCH v14 12/42] virtio_ring: split: extract the logic of vring init
Date:   Mon,  1 Aug 2022 14:38:32 +0800
Message-Id: <20220801063902.129329-13-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
References: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 0f12e405b061
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

Separate the logic of initializing vring, and subsequent patches will
call it separately.

This function completes the variable initialization of split vring. It
together with the logic of atatch constitutes the initialization of
vring.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 03fc656b1f40..e456cc16ea2a 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -938,6 +938,25 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
 	return NULL;
 }
 
+static void virtqueue_vring_init_split(struct vring_virtqueue_split *vring_split,
+				       struct vring_virtqueue *vq)
+{
+	struct virtio_device *vdev;
+
+	vdev = vq->vq.vdev;
+
+	vring_split->avail_flags_shadow = 0;
+	vring_split->avail_idx_shadow = 0;
+
+	/* No callback?  Tell other side not to bother us. */
+	if (!vq->vq.callback) {
+		vring_split->avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;
+		if (!vq->event)
+			vring_split->vring.avail->flags = cpu_to_virtio16(vdev,
+					vring_split->avail_flags_shadow);
+	}
+}
+
 static int vring_alloc_state_extra_split(struct vring_virtqueue_split *vring_split)
 {
 	struct vring_desc_state_split *state;
@@ -2302,16 +2321,6 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->split.queue_size_in_bytes = 0;
 
 	vq->split.vring = vring_split->vring;
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
 
 	err = vring_alloc_state_extra_split(vring_split);
 	if (err) {
@@ -2325,6 +2334,8 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->split.desc_state = vring_split->desc_state;
 	vq->split.desc_extra = vring_split->desc_extra;
 
+	virtqueue_vring_init_split(vring_split, vq);
+
 	virtqueue_init(vq, vring_split->vring.num);
 
 	spin_lock(&vdev->vqs_list_lock);
-- 
2.31.0

