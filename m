Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD9D2EA708
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbhAEJMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:12:30 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:44538 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726677AbhAEJMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:12:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0UKoFTZ0_1609837906;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UKoFTZ0_1609837906)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 05 Jan 2021 17:11:46 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     dust.li@linux.alibaba.com, tonylu@linux.alibaba.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS), linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP))
Subject: [PATCH netdev 2/5] virtio-net: support XDP_TX when not more queues
Date:   Tue,  5 Jan 2021 17:11:40 +0800
Message-Id: <aa8d42a567f9e97a5071cad4ba88abc3ac5ac760.1609837120.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of queues implemented by many virtio backends is limited,
especially some machines have a large number of CPUs. In this case, it
is often impossible to allocate a separate queue for XDP_TX.

This patch allows XDP_TX to run by lock when not enough queue.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f65eea6..f2349b8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -194,6 +194,7 @@ struct virtnet_info {
 
 	/* # of XDP queue pairs currently used by the driver */
 	u16 xdp_queue_pairs;
+	bool xdp_enable;
 
 	/* I like... big packets and I cannot lie! */
 	bool big_packets;
@@ -481,14 +482,34 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
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
@@ -512,7 +533,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	if (!xdp_prog)
 		return -ENXIO;
 
-	sq = virtnet_xdp_sq(vi);
+	sq = virtnet_get_xdp_sq(vi);
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
 		ret = -EINVAL;
@@ -560,12 +581,13 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	sq->stats.kicks += kicks;
 	u64_stats_update_end(&sq->stats.syncp);
 
+	virtnet_put_xdp_sq(vi);
 	return ret;
 }
 
 static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
 {
-	return vi->xdp_queue_pairs ? VIRTIO_XDP_HEADROOM : 0;
+	return vi->xdp_enable ? VIRTIO_XDP_HEADROOM : 0;
 }
 
 /* We copy the packet for XDP in the following cases:
@@ -1457,12 +1479,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
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
@@ -2415,10 +2438,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 	/* XDP requires extra queues for XDP_TX */
 	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
-		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
-		netdev_warn(dev, "request %i queues but max is %i\n",
-			    curr_qp + xdp_qp, vi->max_queue_pairs);
-		return -ENOMEM;
+		xdp_qp = 0;
 	}
 
 	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
@@ -2451,12 +2471,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	netif_set_real_num_rx_queues(dev, curr_qp + xdp_qp);
 	vi->xdp_queue_pairs = xdp_qp;
 
+	vi->xdp_enable = false;
 	if (prog) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
 			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
 			if (i == 0 && !old_prog)
 				virtnet_clear_guest_offloads(vi);
 		}
+		vi->xdp_enable = true;
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -2524,7 +2546,7 @@ static int virtnet_set_features(struct net_device *dev,
 	int err;
 
 	if ((dev->features ^ features) & NETIF_F_LRO) {
-		if (vi->xdp_queue_pairs)
+		if (vi->xdp_enable)
 			return -EBUSY;
 
 		if (features & NETIF_F_LRO)
-- 
1.8.3.1

