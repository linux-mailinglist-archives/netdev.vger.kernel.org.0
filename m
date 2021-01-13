Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC362F45FF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbhAMIK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 03:10:29 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:41489 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727089AbhAMIK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 03:10:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0ULbRoz7_1610525337;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ULbRoz7_1610525337)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Jan 2021 16:08:58 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        dust.li@linux.alibaba.com
Subject: [PATCH netdev] virtio-net: support XDP_TX when not more queues
Date:   Wed, 13 Jan 2021 16:08:57 +0800
Message-Id: <81abae33fc8dbec37ef0061ff6f6fd696b484a3e.1610523188.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of queues implemented by many virtio backends is limited,
especially some machines have a large number of CPUs. In this case, it
is often impossible to allocate a separate queue for XDP_TX.

This patch allows XDP_TX to run by reuse the existing SQ with
__netif_tx_lock() hold when there are not enough queues.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 47 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba8e637..7a3b2a7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -195,6 +195,9 @@ struct virtnet_info {
 	/* # of XDP queue pairs currently used by the driver */
 	u16 xdp_queue_pairs;
 
+	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
+	bool xdp_enabled;
+
 	/* I like... big packets and I cannot lie! */
 	bool big_packets;
 
@@ -481,14 +484,34 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 	return 0;
 }
 
-static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
+static struct send_queue *virtnet_get_xdp_sq(struct virtnet_info *vi)
 {
 	unsigned int qp;
+	struct netdev_queue *txq;
+
+	if (vi->curr_queue_pairs > nr_cpu_ids) {
+		qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
+	} else {
+		qp = smp_processor_id() % vi->curr_queue_pairs;
+		txq = netdev_get_tx_queue(vi->dev, qp);
+		__netif_tx_lock(txq, raw_smp_processor_id());
+	}
 
-	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
 	return &vi->sq[qp];
 }
 
+static void virtnet_put_xdp_sq(struct virtnet_info *vi)
+{
+	unsigned int qp;
+	struct netdev_queue *txq;
+
+	if (vi->curr_queue_pairs <= nr_cpu_ids) {
+		qp = smp_processor_id() % vi->curr_queue_pairs;
+		txq = netdev_get_tx_queue(vi->dev, qp);
+		__netif_tx_unlock(txq);
+	}
+}
+
 static int virtnet_xdp_xmit(struct net_device *dev,
 			    int n, struct xdp_frame **frames, u32 flags)
 {
@@ -512,7 +535,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	if (!xdp_prog)
 		return -ENXIO;
 
-	sq = virtnet_xdp_sq(vi);
+	sq = virtnet_get_xdp_sq(vi);
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
 		ret = -EINVAL;
@@ -560,12 +583,13 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	sq->stats.kicks += kicks;
 	u64_stats_update_end(&sq->stats.syncp);
 
+	virtnet_put_xdp_sq(vi);
 	return ret;
 }
 
 static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
 {
-	return vi->xdp_queue_pairs ? VIRTIO_XDP_HEADROOM : 0;
+	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
 }
 
 /* We copy the packet for XDP in the following cases:
@@ -1457,12 +1481,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 		xdp_do_flush();
 
 	if (xdp_xmit & VIRTIO_XDP_TX) {
-		sq = virtnet_xdp_sq(vi);
+		sq = virtnet_get_xdp_sq(vi);
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
 			sq->stats.kicks++;
 			u64_stats_update_end(&sq->stats.syncp);
 		}
+		virtnet_put_xdp_sq(vi);
 	}
 
 	return received;
@@ -2416,12 +2441,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		xdp_qp = nr_cpu_ids;
 
 	/* XDP requires extra queues for XDP_TX */
-	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
-		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
-		netdev_warn(dev, "request %i queues but max is %i\n",
-			    curr_qp + xdp_qp, vi->max_queue_pairs);
-		return -ENOMEM;
-	}
+	if (curr_qp + xdp_qp > vi->max_queue_pairs)
+		xdp_qp = 0;
 
 	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
 	if (!prog && !old_prog)
@@ -2453,12 +2474,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	netif_set_real_num_rx_queues(dev, curr_qp + xdp_qp);
 	vi->xdp_queue_pairs = xdp_qp;
 
+	vi->xdp_enabled = false;
 	if (prog) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
 			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
 			if (i == 0 && !old_prog)
 				virtnet_clear_guest_offloads(vi);
 		}
+		vi->xdp_enabled = true;
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -2526,7 +2549,7 @@ static int virtnet_set_features(struct net_device *dev,
 	int err;
 
 	if ((dev->features ^ features) & NETIF_F_LRO) {
-		if (vi->xdp_queue_pairs)
+		if (vi->xdp_enabled)
 			return -EBUSY;
 
 		if (features & NETIF_F_LRO)
-- 
1.8.3.1

