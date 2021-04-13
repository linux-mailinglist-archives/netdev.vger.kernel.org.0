Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D0235D5C5
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbhDMDP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:15:59 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:55420 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344318AbhDMDPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:15:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UVPZqh0_1618283727;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVPZqh0_1618283727)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 11:15:27 +0800
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v4 09/10] virtio-net: xsk zero copy xmit implement wakeup and xmit
Date:   Tue, 13 Apr 2021 11:15:22 +0800
Message-Id: <20210413031523.73507-10-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements the core part of xsk zerocopy xmit.

When the user calls sendto to consume the data in the xsk tx queue,
virtnet_xsk_wakeup() will be called.

In wakeup, it will try to send a part of the data directly. There are
two purposes for this realization:

1. Send part of the data quickly to reduce the transmission delay of the
   first packet.
2. Trigger tx interrupt, start napi to consume xsk tx data.

All sent xsk packets share the virtio-net header of xsk_hdr. If xsk
needs to support csum and other functions later, consider assigning xsk
hdr separately for each sent packet.

There are now three situations in free_old_xmit(): skb, xdp frame, xsk
desc.  Based on the last two bit of ptr returned by virtqueue_get_buf():
    00 is skb by default.
    01 represents the packet sent by xdp
    10 is the packet sent by xsk

If the xmit work of xsk has not been completed, but the ring is full,
napi must first exit and wait for the ring to be available, so
need_wakeup() is set. If free_old_xmit() is called first by start_xmit(),
we can quickly wake up napi to execute xsk xmit task.

When recycling, we need to count the number of bytes sent, so put xsk
desc->len into the ptr pointer. Because ptr does not point to meaningful
objects in xsk.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 296 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 292 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8242a9e9f17d..c441d6bf1510 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -46,6 +46,11 @@ module_param(napi_tx, bool, 0644);
 #define VIRTIO_XDP_REDIR	BIT(1)
 
 #define VIRTIO_XDP_FLAG	BIT(0)
+#define VIRTIO_XSK_FLAG	BIT(1)
+
+#define VIRTIO_XSK_PTR_SHIFT       4
+
+static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
 
 /* RX packet size EWMA. The average packet size is used to determine the packet
  * buffer size when refilling RX rings. As the entire RX ring may be refilled
@@ -138,6 +143,12 @@ struct send_queue {
 	struct {
 		/* xsk pool */
 		struct xsk_buff_pool __rcu *pool;
+
+		/* save the desc for next xmit, when xmit fail. */
+		struct xdp_desc last_desc;
+
+		/* xsk wait for tx inter or softirq */
+		bool need_wakeup;
 	} xsk;
 };
 
@@ -255,6 +266,15 @@ struct padded_vnet_hdr {
 	char padding[4];
 };
 
+static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
+			   int budget, bool in_napi);
+static void virtnet_xsk_complete(struct send_queue *sq, u32 num);
+
+static bool is_skb_ptr(void *ptr)
+{
+	return !((unsigned long)ptr & (VIRTIO_XDP_FLAG | VIRTIO_XSK_FLAG));
+}
+
 static bool is_xdp_frame(void *ptr)
 {
 	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
@@ -265,6 +285,19 @@ static void *xdp_to_ptr(struct xdp_frame *ptr)
 	return (void *)((unsigned long)ptr | VIRTIO_XDP_FLAG);
 }
 
+static void *xsk_to_ptr(struct xdp_desc *desc)
+{
+	/* save the desc len to ptr */
+	u64 p = desc->len << VIRTIO_XSK_PTR_SHIFT;
+
+	return (void *)((unsigned long)p | VIRTIO_XSK_FLAG);
+}
+
+static void ptr_to_xsk(void *ptr, struct xdp_desc *desc)
+{
+	desc->len = ((unsigned long)ptr) >> VIRTIO_XSK_PTR_SHIFT;
+}
+
 static struct xdp_frame *ptr_to_xdp(void *ptr)
 {
 	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
@@ -273,25 +306,35 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
 static void __free_old_xmit(struct send_queue *sq, bool in_napi,
 			    struct virtnet_sq_stats *stats)
 {
+	unsigned int xsknum = 0;
 	unsigned int len;
 	void *ptr;
 
 	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		if (likely(!is_xdp_frame(ptr))) {
+		if (is_skb_ptr(ptr)) {
 			struct sk_buff *skb = ptr;
 
 			pr_debug("Sent skb %p\n", skb);
 
 			stats->bytes += skb->len;
 			napi_consume_skb(skb, in_napi);
-		} else {
+		} else if (is_xdp_frame(ptr)) {
 			struct xdp_frame *frame = ptr_to_xdp(ptr);
 
 			stats->bytes += frame->len;
 			xdp_return_frame(frame);
+		} else {
+			struct xdp_desc desc;
+
+			ptr_to_xsk(ptr, &desc);
+			stats->bytes += desc.len;
+			++xsknum;
 		}
 		stats->packets++;
 	}
+
+	if (xsknum)
+		virtnet_xsk_complete(sq, xsknum);
 }
 
 /* Converting between virtqueue no. and kernel tx/rx queue no.
@@ -1529,6 +1572,19 @@ static int virtnet_open(struct net_device *dev)
 	return 0;
 }
 
+static int virtnet_poll_xsk(struct send_queue *sq, int budget)
+{
+	struct xsk_buff_pool *pool;
+	int work_done = 0;
+
+	rcu_read_lock();
+	pool = rcu_dereference(sq->xsk.pool);
+	if (pool)
+		work_done = virtnet_xsk_run(sq, pool, budget, true);
+	rcu_read_unlock();
+	return work_done;
+}
+
 static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 {
 	struct send_queue *sq = container_of(napi, struct send_queue, napi);
@@ -1545,6 +1601,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
+	work_done += virtnet_poll_xsk(sq, budget);
 	free_old_xmit(sq, true);
 	__netif_tx_unlock(txq);
 
@@ -2535,6 +2592,234 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return err;
 }
 
+static void virtnet_xsk_check_queue(struct send_queue *sq)
+{
+	struct virtnet_info *vi = sq->vq->vdev->priv;
+	struct net_device *dev = vi->dev;
+	int qnum = sq - vi->sq;
+
+	/* If this sq is not the exclusive queue of the current cpu,
+	 * then it may be called by start_xmit, so check it running out
+	 * of space.
+	 *
+	 * And if it is a raw buffer queue, it does not check whether the status
+	 * of the queue is stopped when sending. So there is no need to check
+	 * the situation of the raw buffer queue.
+	 */
+	if (is_xdp_raw_buffer_queue(vi, qnum))
+		return;
+
+	/* Stop the queue to avoid getting packets that we are
+	 * then unable to transmit. Then wait the tx interrupt.
+	 */
+	if (sq->vq->num_free < 2 + MAX_SKB_FRAGS)
+		netif_stop_subqueue(dev, qnum);
+}
+
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
+	xsk_tx_completed(pool, num);
+	rcu_read_unlock();
+
+	if (sq->xsk.need_wakeup) {
+		sq->xsk.need_wakeup = false;
+		virtqueue_napi_schedule(&sq->napi, sq->vq);
+	}
+}
+
+static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
+			    struct xdp_desc *desc)
+{
+	struct virtnet_info *vi;
+	u32 offset, n, len;
+	struct page *page;
+	void *data;
+	u64 addr;
+	int err;
+
+	vi = sq->vq->vdev->priv;
+	addr = desc->addr;
+
+	data = xsk_buff_raw_get_data(pool, addr);
+	offset = offset_in_page(data);
+
+	/* xsk unaligned mode, desc may use two pages */
+	if (desc->len > PAGE_SIZE - offset)
+		n = 3;
+	else
+		n = 2;
+
+	sg_init_table(sq->sg, n);
+	sg_set_buf(sq->sg, &xsk_hdr, vi->hdr_len);
+
+	/* handle for xsk first page */
+	len = min_t(int, desc->len, PAGE_SIZE - offset);
+	page = xsk_buff_xdp_get_page(pool, addr);
+	sg_set_page(sq->sg + 1, page, len, offset);
+
+	/* xsk unaligned mode, handle for the second page */
+	if (len < desc->len) {
+		page = xsk_buff_xdp_get_page(pool, addr + len);
+		len = min_t(int, desc->len - len, PAGE_SIZE);
+		sg_set_page(sq->sg + 2, page, len, 0);
+	}
+
+	err = virtqueue_add_outbuf(sq->vq, sq->sg, n, xsk_to_ptr(desc),
+				   GFP_ATOMIC);
+	if (unlikely(err))
+		sq->xsk.last_desc = *desc;
+
+	return err;
+}
+
+static int virtnet_xsk_xmit_batch(struct send_queue *sq,
+				  struct xsk_buff_pool *pool,
+				  unsigned int budget,
+				  bool in_napi, int *done,
+				  struct virtnet_sq_stats *stats)
+{
+	struct xdp_desc desc;
+	int err, packet = 0;
+	int ret = -EAGAIN;
+
+	if (sq->xsk.last_desc.addr) {
+		if (sq->vq->num_free < 2 + MAX_SKB_FRAGS)
+			return -EBUSY;
+
+		err = virtnet_xsk_xmit(sq, pool, &sq->xsk.last_desc);
+		if (unlikely(err))
+			return -EBUSY;
+
+		++packet;
+		--budget;
+		sq->xsk.last_desc.addr = 0;
+	}
+
+	while (budget-- > 0) {
+		if (sq->vq->num_free < 2 + MAX_SKB_FRAGS) {
+			ret = -EBUSY;
+			break;
+		}
+
+		if (!xsk_tx_peek_desc(pool, &desc)) {
+			/* done */
+			ret = 0;
+			break;
+		}
+
+		err = virtnet_xsk_xmit(sq, pool, &desc);
+		if (unlikely(err)) {
+			ret = -EBUSY;
+			break;
+		}
+
+		++packet;
+	}
+
+	if (packet) {
+		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
+			++stats->kicks;
+
+		*done = packet;
+		stats->xdp_tx += packet;
+
+		xsk_tx_release(pool);
+	}
+
+	return ret;
+}
+
+static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool *pool,
+			   int budget, bool in_napi)
+{
+	struct virtnet_sq_stats stats = {};
+	int done = 0;
+	int err;
+
+	sq->xsk.need_wakeup = false;
+	__free_old_xmit(sq, in_napi, &stats);
+
+	/* return err:
+	 * -EAGAIN: done == budget
+	 * -EBUSY:  done < budget
+	 *  0    :  done < budget
+	 */
+	err = virtnet_xsk_xmit_batch(sq, pool, budget, in_napi, &done, &stats);
+	if (err == -EBUSY) {
+		__free_old_xmit(sq, in_napi, &stats);
+
+		/* If the space is enough, let napi run again. */
+		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
+			done = budget;
+		else
+			sq->xsk.need_wakeup = true;
+	}
+
+	virtnet_xsk_check_queue(sq);
+
+	u64_stats_update_begin(&sq->stats.syncp);
+	sq->stats.packets += stats.packets;
+	sq->stats.bytes += stats.bytes;
+	sq->stats.kicks += stats.kicks;
+	sq->stats.xdp_tx += stats.xdp_tx;
+	u64_stats_update_end(&sq->stats.syncp);
+
+	return done;
+}
+
+static int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct xsk_buff_pool *pool;
+	struct netdev_queue *txq;
+	struct send_queue *sq;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	if (qid >= vi->curr_queue_pairs)
+		return -EINVAL;
+
+	sq = &vi->sq[qid];
+
+	rcu_read_lock();
+
+	pool = rcu_dereference(sq->xsk.pool);
+	if (!pool)
+		goto end;
+
+	if (napi_if_scheduled_mark_missed(&sq->napi))
+		goto end;
+
+	txq = netdev_get_tx_queue(dev, qid);
+
+	__netif_tx_lock_bh(txq);
+
+	/* Send part of the packet directly to reduce the delay in sending the
+	 * packet, and this can actively trigger the tx interrupts.
+	 *
+	 * If no packet is sent out, the ring of the device is full. In this
+	 * case, we will still get a tx interrupt response. Then we will deal
+	 * with the subsequent packet sending work.
+	 */
+	virtnet_xsk_run(sq, pool, napi_weight, false);
+
+	__netif_tx_unlock_bh(txq);
+
+end:
+	rcu_read_unlock();
+	return 0;
+}
+
 static int virtnet_xsk_pool_enable(struct net_device *dev,
 				   struct xsk_buff_pool *pool,
 				   u16 qid)
@@ -2559,6 +2844,8 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 		return -EPERM;
 
 	rcu_read_lock();
+	memset(&sq->xsk, 0, sizeof(sq->xsk));
+
 	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
 	 * safe.
 	 */
@@ -2658,6 +2945,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_vlan_rx_kill_vid = virtnet_vlan_rx_kill_vid,
 	.ndo_bpf		= virtnet_xdp,
 	.ndo_xdp_xmit		= virtnet_xdp_xmit,
+	.ndo_xsk_wakeup         = virtnet_xsk_wakeup,
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
@@ -2761,9 +3049,9 @@ static void free_unused_bufs(struct virtnet_info *vi)
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

