Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C465D34F98F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhCaHMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:12:23 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:40098 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233983AbhCaHLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:11:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UTwL0EX_1617174703;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UTwL0EX_1617174703)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 15:11:43 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v3 8/8] virtio-net: free old xmit handle xsk
Date:   Wed, 31 Mar 2021 15:11:39 +0800
Message-Id: <20210331071139.15473-9-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the last two bit of ptr returned by virtqueue_get_buf, 01
represents the packet sent by xdp, 10 is the packet sent by xsk, and 00
is skb by default.

If the xmit work of xsk has not been completed, but the ring is full,
napi must first exit and wait for the ring to be available, so
need_wakeup is set. If __free_old_xmit is called first by start_xmit, we
can quickly wake up napi to execute xsk xmit work.

When recycling, we need to count the number of bytes sent, so put xsk
desc->len into the ptr pointer. Because ptr does not point to meaningful
objects in xsk.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 171 ++++++++++++++++++++++++++-------------
 1 file changed, 113 insertions(+), 58 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fac7d0020013..8318b89b2971 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -50,6 +50,9 @@ module_param(xsk_kick_thr, int, 0644);
 #define VIRTIO_XDP_REDIR	BIT(1)
 
 #define VIRTIO_XDP_FLAG	BIT(0)
+#define VIRTIO_XSK_FLAG	BIT(1)
+
+#define VIRTIO_XSK_PTR_SHIFT       4
 
 static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
 
@@ -147,6 +150,9 @@ struct send_queue {
 
 		/* save the desc for next xmit, when xmit fail. */
 		struct xdp_desc last_desc;
+
+		/* xsk wait for tx inter or softirq */
+		bool need_wakeup;
 	} xsk;
 };
 
@@ -266,6 +272,12 @@ struct padded_vnet_hdr {
 
 static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
 			   int budget, bool in_napi);
+static void virtnet_xsk_complete(struct send_queue *sq, u32 num);
+
+static bool is_skb_ptr(void *ptr)
+{
+	return !((unsigned long)ptr & (VIRTIO_XDP_FLAG | VIRTIO_XSK_FLAG));
+}
 
 static bool is_xdp_frame(void *ptr)
 {
@@ -277,11 +289,58 @@ static void *xdp_to_ptr(struct xdp_frame *ptr)
 	return (void *)((unsigned long)ptr | VIRTIO_XDP_FLAG);
 }
 
+static void *xsk_to_ptr(struct xdp_desc *desc)
+{
+	/* save the desc len to ptr */
+	u64 p = desc->len << VIRTIO_XSK_PTR_SHIFT;
+
+	return (void *)(p | VIRTIO_XSK_FLAG);
+}
+
+static void ptr_to_xsk(void *ptr, struct xdp_desc *desc)
+{
+	desc->len = ((u64)ptr) >> VIRTIO_XSK_PTR_SHIFT;
+}
+
 static struct xdp_frame *ptr_to_xdp(void *ptr)
 {
 	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
 }
 
+static void __free_old_xmit(struct send_queue *sq, bool in_napi,
+			    struct virtnet_sq_stats *stats)
+{
+	unsigned int xsknum = 0;
+	unsigned int len;
+	void *ptr;
+
+	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
+		if (is_skb_ptr(ptr)) {
+			struct sk_buff *skb = ptr;
+
+			pr_debug("Sent skb %p\n", skb);
+
+			stats->bytes += skb->len;
+			napi_consume_skb(skb, in_napi);
+		} else if (is_xdp_frame(ptr)) {
+			struct xdp_frame *frame = ptr_to_xdp(ptr);
+
+			stats->bytes += frame->len;
+			xdp_return_frame(frame);
+		} else {
+			struct xdp_desc desc;
+
+			ptr_to_xsk(ptr, &desc);
+			stats->bytes += desc.len;
+			++xsknum;
+		}
+		stats->packets++;
+	}
+
+	if (xsknum)
+		virtnet_xsk_complete(sq, xsknum);
+}
+
 /* Converting between virtqueue no. and kernel tx/rx queue no.
  * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
  */
@@ -543,15 +602,12 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 			    int n, struct xdp_frame **frames, u32 flags)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
+	struct virtnet_sq_stats stats = {};
 	struct receive_queue *rq = vi->rq;
 	struct bpf_prog *xdp_prog;
 	struct send_queue *sq;
-	unsigned int len;
-	int packets = 0;
-	int bytes = 0;
 	int nxmit = 0;
 	int kicks = 0;
-	void *ptr;
 	int ret;
 	int i;
 
@@ -570,20 +626,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	}
 
 	/* Free up any pending old buffers before queueing new ones. */
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		if (likely(is_xdp_frame(ptr))) {
-			struct xdp_frame *frame = ptr_to_xdp(ptr);
-
-			bytes += frame->len;
-			xdp_return_frame(frame);
-		} else {
-			struct sk_buff *skb = ptr;
-
-			bytes += skb->len;
-			napi_consume_skb(skb, false);
-		}
-		packets++;
-	}
+	__free_old_xmit(sq, false, &stats);
 
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
@@ -600,8 +643,8 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	}
 out:
 	u64_stats_update_begin(&sq->stats.syncp);
-	sq->stats.bytes += bytes;
-	sq->stats.packets += packets;
+	sq->stats.bytes += stats.bytes;
+	sq->stats.packets += stats.packets;
 	sq->stats.xdp_tx += n;
 	sq->stats.xdp_tx_drops += n - nxmit;
 	sq->stats.kicks += kicks;
@@ -1426,37 +1469,19 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 
 static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 {
-	unsigned int len;
-	unsigned int packets = 0;
-	unsigned int bytes = 0;
-	void *ptr;
-
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		if (likely(!is_xdp_frame(ptr))) {
-			struct sk_buff *skb = ptr;
+	struct virtnet_sq_stats stats = {};
 
-			pr_debug("Sent skb %p\n", skb);
-
-			bytes += skb->len;
-			napi_consume_skb(skb, in_napi);
-		} else {
-			struct xdp_frame *frame = ptr_to_xdp(ptr);
-
-			bytes += frame->len;
-			xdp_return_frame(frame);
-		}
-		packets++;
-	}
+	__free_old_xmit(sq, in_napi, &stats);
 
 	/* Avoid overhead when no packets have been processed
 	 * happens when called speculatively from start_xmit.
 	 */
-	if (!packets)
+	if (!stats.packets)
 		return;
 
 	u64_stats_update_begin(&sq->stats.syncp);
-	sq->stats.bytes += bytes;
-	sq->stats.packets += packets;
+	sq->stats.bytes += stats.bytes;
+	sq->stats.packets += stats.packets;
 	u64_stats_update_end(&sq->stats.syncp);
 }
 
@@ -2575,6 +2600,28 @@ static void virtnet_xsk_check_space(struct send_queue *sq)
 		netif_stop_subqueue(dev, qnum);
 }
 
+static void virtnet_xsk_complete(struct send_queue *sq, u32 num)
+{
+	struct xsk_buff_pool *pool;
+
+	rcu_read_lock();
+
+	pool = rcu_dereference(sq->xsk.pool);
+	if (!pool) {
+		rcu_read_unlock();
+		return;
+	}
+
+	xsk_tx_completed(pool, num);
+
+	rcu_read_unlock();
+
+	if (sq->xsk.need_wakeup) {
+		sq->xsk.need_wakeup = false;
+		virtqueue_napi_schedule(&sq->napi, sq->vq);
+	}
+}
+
 static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
 			    struct xdp_desc *desc)
 {
@@ -2613,7 +2660,8 @@ static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
 			offset = 0;
 	}
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, n, NULL, GFP_ATOMIC);
+	err = virtqueue_add_outbuf(sq->vq, sq->sg, n, xsk_to_ptr(desc),
+				   GFP_ATOMIC);
 	if (unlikely(err))
 		sq->xsk.last_desc = *desc;
 
@@ -2623,13 +2671,13 @@ static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
 static int virtnet_xsk_xmit_batch(struct send_queue *sq,
 				  struct xsk_buff_pool *pool,
 				  unsigned int budget,
-				  bool in_napi, int *done)
+				  bool in_napi, int *done,
+				  struct virtnet_sq_stats *stats)
 {
 	struct xdp_desc desc;
 	int err, packet = 0;
 	int ret = -EAGAIN;
 	int need_kick = 0;
-	int kicks = 0;
 
 	if (sq->xsk.last_desc.addr) {
 		err = virtnet_xsk_xmit(sq, pool, &sq->xsk.last_desc);
@@ -2665,7 +2713,7 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
 		if (need_kick > xsk_kick_thr) {
 			if (virtqueue_kick_prepare(sq->vq) &&
 			    virtqueue_notify(sq->vq))
-				++kicks;
+				++stats->kicks;
 
 			need_kick = 0;
 		}
@@ -2675,15 +2723,11 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
 		if (need_kick) {
 			if (virtqueue_kick_prepare(sq->vq) &&
 			    virtqueue_notify(sq->vq))
-				++kicks;
-		}
-		if (kicks) {
-			u64_stats_update_begin(&sq->stats.syncp);
-			sq->stats.kicks += kicks;
-			u64_stats_update_end(&sq->stats.syncp);
+				++stats->kicks;
 		}
 
 		*done = packet;
+		stats->xdp_tx += packet;
 
 		xsk_tx_release(pool);
 	}
@@ -2694,26 +2738,37 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
 static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
 			   int budget, bool in_napi)
 {
+	struct virtnet_sq_stats stats = {};
 	int done = 0;
 	int err;
 
-	free_old_xmit_skbs(sq, in_napi);
+	sq->xsk.need_wakeup = false;
+	__free_old_xmit(sq, in_napi, &stats);
 
-	err = virtnet_xsk_xmit_batch(sq, pool, budget, in_napi, &done);
+	err = virtnet_xsk_xmit_batch(sq, pool, budget, in_napi, &done, &stats);
 	/* -EAGAIN: done == budget
 	 * -EBUSY: done < budget
 	 *  0    : done < budget
 	 */
 	if (err == -EBUSY) {
-		free_old_xmit_skbs(sq, in_napi);
+		__free_old_xmit(sq, in_napi, &stats);
 
 		/* If the space is enough, let napi run again. */
 		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 			done = budget;
+		else
+			sq->xsk.need_wakeup = true;
 	}
 
 	virtnet_xsk_check_space(sq);
 
+	u64_stats_update_begin(&sq->stats.syncp);
+	sq->stats.packets += stats.packets;
+	sq->stats.bytes += stats.bytes;
+	sq->stats.kicks += stats.kicks;
+	sq->stats.xdp_tx += stats.xdp_tx;
+	u64_stats_update_end(&sq->stats.syncp);
+
 	return done;
 }
 
@@ -2991,9 +3046,9 @@ static void free_unused_bufs(struct virtnet_info *vi)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		struct virtqueue *vq = vi->sq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
-			if (!is_xdp_frame(buf))
+			if (is_skb_ptr(buf))
 				dev_kfree_skb(buf);
-			else
+			else if (is_xdp_frame(buf))
 				xdp_return_frame(ptr_to_xdp(buf));
 		}
 	}
-- 
2.31.0

