Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5001433331B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 03:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhCJCZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 21:25:04 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:49806 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231174AbhCJCYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 21:24:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0URBRP6D_1615343085;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0URBRP6D_1615343085)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 10:24:46 +0800
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH v8 net-next] virtio-net: support XDP when not more queues
Date:   Wed, 10 Mar 2021 10:24:45 +0800
Message-Id: <1615343085-39786-1-git-send-email-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of queues implemented by many virtio backends is limited,
especially some machines have a large number of CPUs. In this case, it
is often impossible to allocate a separate queue for
XDP_TX/XDP_REDIRECT, then xdp cannot be loaded to work, even xdp does
not use the XDP_TX/XDP_REDIRECT.

This patch allows XDP_TX/XDP_REDIRECT to run by reuse the existing SQ
with __netif_tx_lock() hold when there are not enough queues.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
v8: 1. explain why use macros not inline functions. (suggested by Michael S. Tsirkin)
    2. empty line after variable definitions inside marcos. (suggested by Michael S. Tsirkin)

v7: 1. use macros to implement get/put
    2. remove 'flag'. (suggested by Jason Wang)

v6: 1. use __netif_tx_acquire()/__netif_tx_release(). (suggested by Jason Wang)
    2. add note for why not lock. (suggested by Jason Wang)
    3. Use variable 'flag' to record with or without locked.  It is not safe to
       use curr_queue_pairs in "virtnet_put_xdp_sq", because it may changed after
       "virtnet_get_xdp_sq".

v5: change subject from 'support XDP_TX when not more queues'

v4: make sparse happy
    suggested by Jakub Kicinski

v3: add warning when no more queues
    suggested by Jesper Dangaard Brouer

 drivers/net/virtio_net.c | 62 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82e520d..ae82e8e 100644
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

@@ -481,12 +484,41 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 	return 0;
 }

-static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
-{
-	unsigned int qp;
-
-	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
-	return &vi->sq[qp];
+/* when vi->curr_queue_pairs > nr_cpu_ids, the txq/sq is only used for xdp tx on
+ * the current cpu, so it does not need to be locked.
+ *
+ * Here we use marco instead of inline functions because we have to deal with
+ * three issues at the same time: 1. the choice of sq. 2. judge and execute the
+ * lock/unlock of txq 3. make sparse happy. It is difficult for two inline
+ * functions to perfectly solve these three problems at the same time.
+ */
+#define virtnet_xdp_get_sq(vi) ({                                       \
+	struct netdev_queue *txq;                                       \
+	typeof(vi) v = (vi);                                            \
+	unsigned int qp;                                                \
+									\
+	if (v->curr_queue_pairs > nr_cpu_ids) {                         \
+		qp = v->curr_queue_pairs - v->xdp_queue_pairs;          \
+		qp += smp_processor_id();                               \
+		txq = netdev_get_tx_queue(v->dev, qp);                  \
+		__netif_tx_acquire(txq);                                \
+	} else {                                                        \
+		qp = smp_processor_id() % v->curr_queue_pairs;          \
+		txq = netdev_get_tx_queue(v->dev, qp);                  \
+		__netif_tx_lock(txq, raw_smp_processor_id());           \
+	}                                                               \
+	v->sq + qp;                                                     \
+})
+
+#define virtnet_xdp_put_sq(vi, q) {                                     \
+	struct netdev_queue *txq;                                       \
+	typeof(vi) v = (vi);                                            \
+									\
+	txq = netdev_get_tx_queue(v->dev, (q) - v->sq);                 \
+	if (v->curr_queue_pairs > nr_cpu_ids)                           \
+		__netif_tx_release(txq);                                \
+	else                                                            \
+		__netif_tx_unlock(txq);                                 \
 }

 static int virtnet_xdp_xmit(struct net_device *dev,
@@ -512,7 +544,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	if (!xdp_prog)
 		return -ENXIO;

-	sq = virtnet_xdp_sq(vi);
+	sq = virtnet_xdp_get_sq(vi);

 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
 		ret = -EINVAL;
@@ -560,12 +592,13 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	sq->stats.kicks += kicks;
 	u64_stats_update_end(&sq->stats.syncp);

+	virtnet_xdp_put_sq(vi, sq);
 	return ret;
 }

 static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
 {
-	return vi->xdp_queue_pairs ? VIRTIO_XDP_HEADROOM : 0;
+	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
 }

 /* We copy the packet for XDP in the following cases:
@@ -1458,12 +1491,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 		xdp_do_flush();

 	if (xdp_xmit & VIRTIO_XDP_TX) {
-		sq = virtnet_xdp_sq(vi);
+		sq = virtnet_xdp_get_sq(vi);
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
 			sq->stats.kicks++;
 			u64_stats_update_end(&sq->stats.syncp);
 		}
+		virtnet_xdp_put_sq(vi, sq);
 	}

 	return received;
@@ -2418,10 +2452,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,

 	/* XDP requires extra queues for XDP_TX */
 	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
-		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
-		netdev_warn(dev, "request %i queues but max is %i\n",
+		netdev_warn(dev, "XDP request %i queues but max is %i. XDP_TX and XDP_REDIRECT will operate in a slower locked tx mode.\n",
 			    curr_qp + xdp_qp, vi->max_queue_pairs);
-		return -ENOMEM;
+		xdp_qp = 0;
 	}

 	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
@@ -2455,11 +2488,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	vi->xdp_queue_pairs = xdp_qp;

 	if (prog) {
+		vi->xdp_enabled = true;
 		for (i = 0; i < vi->max_queue_pairs; i++) {
 			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
 			if (i == 0 && !old_prog)
 				virtnet_clear_guest_offloads(vi);
 		}
+	} else {
+		vi->xdp_enabled = false;
 	}

 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -2527,7 +2563,7 @@ static int virtnet_set_features(struct net_device *dev,
 	int err;

 	if ((dev->features ^ features) & NETIF_F_LRO) {
-		if (vi->xdp_queue_pairs)
+		if (vi->xdp_enabled)
 			return -EBUSY;

 		if (features & NETIF_F_LRO)
--
1.8.3.1

