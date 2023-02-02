Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5C3687B65
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjBBLCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjBBLBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:43 -0500
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C073B885E4;
        Thu,  2 Feb 2023 03:01:35 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VakpyHW_1675335691;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VakpyHW_1675335691)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:01:32 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 29/33] virtio_net: xsk: tx: support tx
Date:   Thu,  2 Feb 2023 19:00:54 +0800
Message-Id: <20230202110058.130695-30-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d7589ab6ea10
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver's tx napi is very important for XSK. It is responsible for
obtaining data from the XSK queue and sending it out.

At the beginning, we need to trigger tx napi.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/main.c |  12 +++-
 drivers/net/virtio/xsk.c  | 146 ++++++++++++++++++++++++++++++++++++++
 drivers/net/virtio/xsk.h  |   2 +
 3 files changed, 159 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
index 43249c78484a..02d2f7d21bdf 100644
--- a/drivers/net/virtio/main.c
+++ b/drivers/net/virtio/main.c
@@ -1607,6 +1607,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	struct send_queue *sq = container_of(napi, struct send_queue, napi);
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	unsigned int index = vq2txq(sq->vq);
+	struct xsk_buff_pool *pool;
 	struct netdev_queue *txq;
 	int busy = 0;
 	int opaque;
@@ -1621,7 +1622,16 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
 	virtqueue_disable_cb(sq->vq);
-	free_old_xmit(sq, true);
+
+	rcu_read_lock();
+	pool = rcu_dereference(sq->xsk.pool);
+	if (pool) {
+		busy |= virtnet_xsk_xmit(sq, pool, budget);
+		rcu_read_unlock();
+	} else {
+		rcu_read_unlock();
+		free_old_xmit(sq, true);
+	}
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 		netif_tx_wake_queue(txq);
diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
index b96af38a2608..04db80244dbd 100644
--- a/drivers/net/virtio/xsk.c
+++ b/drivers/net/virtio/xsk.c
@@ -7,6 +7,152 @@
 
 static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
 
+static void sg_fill_dma(struct scatterlist *sg, dma_addr_t addr, u32 len)
+{
+	sg->dma_address = addr;
+	sg->length = len;
+}
+
+static void virtnet_xsk_check_queue(struct send_queue *sq)
+{
+	struct virtnet_info *vi = sq->vq->vdev->priv;
+	struct net_device *dev = vi->dev;
+	int qnum = sq - vi->sq;
+
+	/* If it is a raw buffer queue, it does not check whether the status
+	 * of the queue is stopped when sending. So there is no need to check
+	 * the situation of the raw buffer queue.
+	 */
+	if (is_xdp_raw_buffer_queue(vi, qnum))
+		return;
+
+	/* If this sq is not the exclusive queue of the current cpu,
+	 * then it may be called by start_xmit, so check it running out
+	 * of space.
+	 *
+	 * Stop the queue to avoid getting packets that we are
+	 * then unable to transmit. Then wait the tx interrupt.
+	 */
+	if (sq->vq->num_free < 2 + MAX_SKB_FRAGS)
+		netif_stop_subqueue(dev, qnum);
+}
+
+static int virtnet_xsk_xmit_one(struct send_queue *sq,
+				struct xsk_buff_pool *pool,
+				struct xdp_desc *desc)
+{
+	struct virtnet_info *vi;
+	dma_addr_t addr;
+
+	vi = sq->vq->vdev->priv;
+
+	addr = xsk_buff_raw_get_dma(pool, desc->addr);
+	xsk_buff_raw_dma_sync_for_device(pool, addr, desc->len);
+
+	sg_init_table(sq->sg, 2);
+
+	sg_fill_dma(sq->sg, sq->xsk.hdr_dma_address, vi->hdr_len);
+	sg_fill_dma(sq->sg + 1, addr, desc->len);
+
+	return virtqueue_add_outbuf_premapped(sq->vq, sq->sg, 2,
+					      xsk_to_ptr(desc->len),
+					      GFP_ATOMIC);
+}
+
+enum {
+	XSK_XMIT_DONE,
+	XSK_XMIT_DEV_BUSY,
+	XSK_XMIT_NO_BUDGET
+};
+
+static int virtnet_xsk_xmit_batch(struct send_queue *sq,
+				  struct xsk_buff_pool *pool,
+				  unsigned int budget,
+				  struct virtnet_sq_stats *stats)
+{
+	int ret = XSK_XMIT_NO_BUDGET;
+	struct xdp_desc desc;
+	int err, packet = 0;
+
+	while (budget-- > 0) {
+		if (sq->vq->num_free < 2) {
+			__free_old_xmit(sq, true, stats);
+			if (sq->vq->num_free < 2) {
+				ret = XSK_XMIT_DEV_BUSY;
+				break;
+			}
+		}
+
+		if (!xsk_tx_peek_desc(pool, &desc)) {
+			ret = XSK_XMIT_DONE;
+			break;
+		}
+
+		err = virtnet_xsk_xmit_one(sq, pool, &desc);
+		if (unlikely(err)) {
+			ret = XSK_XMIT_DEV_BUSY;
+			break;
+		}
+
+		++packet;
+
+		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
+			++stats->kicks;
+	}
+
+	if (packet) {
+		stats->xdp_tx += packet;
+
+		xsk_tx_release(pool);
+	}
+
+	return ret;
+}
+
+bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
+		      int budget)
+{
+	struct virtnet_sq_stats stats = {};
+	bool busy;
+	int ret;
+
+	__free_old_xmit(sq, true, &stats);
+
+	if (xsk_uses_need_wakeup(pool))
+		xsk_set_tx_need_wakeup(pool);
+
+	ret = virtnet_xsk_xmit_batch(sq, pool, budget, &stats);
+	switch (ret) {
+	case XSK_XMIT_DONE:
+		/* xsk tx qeueu has been consumed done. should complete napi. */
+		busy = false;
+		break;
+
+	case XSK_XMIT_NO_BUDGET:
+		/* reach the budget limit. should let napi run again. */
+		busy = true;
+		break;
+
+	case XSK_XMIT_DEV_BUSY:
+		/* sq vring is full, should complete napi. wait for tx napi been
+		 * triggered by interrupt.
+		 */
+		busy = false;
+		break;
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
+	return busy;
+}
+
 static int virtnet_rq_bind_xsk_pool(struct virtnet_info *vi, struct receive_queue *rq,
 				    struct xsk_buff_pool *pool, struct net_device *dev)
 {
diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
index ad684c812091..15f1540a5803 100644
--- a/drivers/net/virtio/xsk.h
+++ b/drivers/net/virtio/xsk.h
@@ -20,4 +20,6 @@ static inline u32 ptr_to_xsk(void *ptr)
 }
 
 int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp);
+bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
+		      int budget);
 #endif
-- 
2.32.0.3.g01195cf9f

