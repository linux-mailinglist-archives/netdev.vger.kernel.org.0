Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37A4388D34
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242263AbhESLtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:49:20 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:40388 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235384AbhESLtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 07:49:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UZPQget_1621424877;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UZPQget_1621424877)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 19 May 2021 19:47:57 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] virtio: Introduce a new kick interface virtqueue_kick_try()
Date:   Wed, 19 May 2021 19:47:57 +0800
Message-Id: <20210519114757.6143-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike virtqueue_kick(), virtqueue_kick_try() returns true only when the
kick is successful. In virtio-net, we want to count the number of kicks.
So we need an interface that can perceive whether the kick is actually
executed.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c     |  8 ++++----
 drivers/virtio/virtio_ring.c | 20 ++++++++++++++++++++
 include/linux/virtio.h       |  2 ++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9b6a4a875c55..167697030cb6 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -617,7 +617,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	ret = nxmit;
 
 	if (flags & XDP_XMIT_FLUSH) {
-		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
+		if (virtqueue_kick_try(sq->vq))
 			kicks = 1;
 	}
 out:
@@ -1325,7 +1325,7 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
 		if (err)
 			break;
 	} while (rq->vq->num_free);
-	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
+	if (virtqueue_kick_try(rq->vq)) {
 		unsigned long flags;
 
 		flags = u64_stats_update_begin_irqsave(&rq->stats.syncp);
@@ -1533,7 +1533,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 
 	if (xdp_xmit & VIRTIO_XDP_TX) {
 		sq = virtnet_xdp_get_sq(vi);
-		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
+		if (virtqueue_kick_try(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
 			sq->stats.kicks++;
 			u64_stats_update_end(&sq->stats.syncp);
@@ -1710,7 +1710,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (kick || netif_xmit_stopped(txq)) {
-		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
+		if (virtqueue_kick_try(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
 			sq->stats.kicks++;
 			u64_stats_update_end(&sq->stats.syncp);
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 71e16b53e9c1..1462be756875 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1874,6 +1874,26 @@ bool virtqueue_kick(struct virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_kick);
 
+/**
+ * virtqueue_kick_try - try update after add_buf
+ * @vq: the struct virtqueue
+ *
+ * After one or more virtqueue_add_* calls, invoke this to kick
+ * the other side.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ *
+ * Returns true if kick success, otherwise false.
+ */
+bool virtqueue_kick_try(struct virtqueue *vq)
+{
+	if (virtqueue_kick_prepare(vq) && virtqueue_notify(vq))
+		return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(virtqueue_kick_try);
+
 /**
  * virtqueue_get_buf - get the next used buffer
  * @_vq: the struct virtqueue we're talking about.
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b1894e0323fa..45cd6a0af24d 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -59,6 +59,8 @@ int virtqueue_add_sgs(struct virtqueue *vq,
 
 bool virtqueue_kick(struct virtqueue *vq);
 
+bool virtqueue_kick_try(struct virtqueue *vq);
+
 bool virtqueue_kick_prepare(struct virtqueue *vq);
 
 bool virtqueue_notify(struct virtqueue *vq);
-- 
2.31.0

