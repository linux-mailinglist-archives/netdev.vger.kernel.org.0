Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7534B437B
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241677AbiBNIOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:14:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241639AbiBNIOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:14:42 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65535F8F5;
        Mon, 14 Feb 2022 00:14:34 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4OcHFK_1644826470;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4OcHFK_1644826470)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Feb 2022 16:14:31 +0800
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
Subject: [PATCH v5 13/22] virtio_pci: queue_reset: reserve vq->priv for re-enable queue
Date:   Mon, 14 Feb 2022 16:14:07 +0800
Message-Id: <20220214081416.117695-14-xuanzhuo@linux.alibaba.com>
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

Reserve vq->priv during reset. Prevent vp_modern_map_vq_notify() from
being called repeatedly.

Only set vq->priv = NULL in normal setup virtqueue, and keep
vq->priv in the process of re-enable queue.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_pci_modern.c | 8 +++++---
 drivers/virtio/virtio_ring.c       | 2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 5af82948f0ae..bed3e9b84272 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -224,10 +224,12 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				virtqueue_get_avail_addr(vq),
 				virtqueue_get_used_addr(vq));
 
-	vq->priv = (void __force *)vp_modern_map_vq_notify(mdev, index, NULL);
 	if (!vq->priv) {
-		err = -ENOMEM;
-		goto err_map_notify;
+		vq->priv = (void __force *)vp_modern_map_vq_notify(mdev, index, NULL);
+		if (!vq->priv) {
+			err = -ENOMEM;
+			goto err_map_notify;
+		}
 	}
 
 	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index b37753bdbbc4..6a892c8ea16e 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1723,6 +1723,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 
 		vq->vq.callback = callback;
 		vq->vq.name = name;
+		vq->vq.priv = NULL;
 		vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 			!context;
 	}
@@ -2211,6 +2212,7 @@ static int __vring_init_virtqueue(struct virtqueue *_vq,
 	if (!reset) {
 		vq->vq.callback = callback;
 		vq->vq.name = name;
+		vq->vq.priv = NULL;
 		vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 			!context;
 	}
-- 
2.31.0

