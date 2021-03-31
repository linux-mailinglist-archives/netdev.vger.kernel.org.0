Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC22C34F986
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhCaHLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:11:49 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:59394 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233895AbhCaHLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:11:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UTwOni8_1617174701;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UTwOni8_1617174701)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 15:11:41 +0800
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
Subject: [PATCH net-next v3 4/8] virtio-net: xsk zero copy xmit implement wakeup and xmit
Date:   Wed, 31 Mar 2021 15:11:35 +0800
Message-Id: <20210331071139.15473-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the user calls sendto to consume the data in the xsk tx queue,
virtnet_xsk_wakeup will be called.

In wakeup, it will try to send a part of the data directly, the quantity
is operated by the module parameter xsk_budget. There are two purposes
for this realization:

1. Send part of the data quickly to reduce the transmission delay of the
   first packet
2. Trigger tx interrupt, start napi to consume xsk tx data

All sent xsk packets share the virtio-net header of xsk_hdr. If xsk
needs to support csum and other functions later, consider assigning xsk
hdr separately for each sent packet.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 183 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 183 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4e25408a2b37..c8a317a93ef7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -28,9 +28,11 @@ static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
 
 static bool csum = true, gso = true, napi_tx = true;
+static int xsk_budget = 32;
 module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
+module_param(xsk_budget, int, 0644);
 
 /* FIXME: MTU in config. */
 #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
@@ -47,6 +49,8 @@ module_param(napi_tx, bool, 0644);
 
 #define VIRTIO_XDP_FLAG	BIT(0)
 
+static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
+
 /* RX packet size EWMA. The average packet size is used to determine the packet
  * buffer size when refilling RX rings. As the entire RX ring may be refilled
  * at once, the weight is chosen so that the EWMA will be insensitive to short-
@@ -138,6 +142,9 @@ struct send_queue {
 	struct {
 		/* xsk pool */
 		struct xsk_buff_pool __rcu *pool;
+
+		/* save the desc for next xmit, when xmit fail. */
+		struct xdp_desc last_desc;
 	} xsk;
 };
 
@@ -2532,6 +2539,179 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return err;
 }
 
+static void virtnet_xsk_check_space(struct send_queue *sq)
+{
+	struct virtnet_info *vi = sq->vq->vdev->priv;
+	struct net_device *dev = vi->dev;
+	int qnum = sq - vi->sq;
+
+	/* If this sq is not the exclusive queue of the current cpu,
+	 * then it may be called by start_xmit, so check it running out
+	 * of space.
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
+static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
+			    struct xdp_desc *desc)
+{
+	struct virtnet_info *vi;
+	struct page *page;
+	void *data;
+	u32 offset;
+	u64 addr;
+	int err;
+
+	vi = sq->vq->vdev->priv;
+	addr = desc->addr;
+	data = xsk_buff_raw_get_data(pool, addr);
+	offset = offset_in_page(data);
+
+	sg_init_table(sq->sg, 2);
+	sg_set_buf(sq->sg, &xsk_hdr, vi->hdr_len);
+	page = xsk_buff_xdp_get_page(pool, addr);
+	sg_set_page(sq->sg + 1, page, desc->len, offset);
+
+	err = virtqueue_add_outbuf(sq->vq, sq->sg, 2, NULL, GFP_ATOMIC);
+	if (unlikely(err))
+		sq->xsk.last_desc = *desc;
+
+	return err;
+}
+
+static int virtnet_xsk_xmit_batch(struct send_queue *sq,
+				  struct xsk_buff_pool *pool,
+				  unsigned int budget,
+				  bool in_napi, int *done)
+{
+	struct xdp_desc desc;
+	int err, packet = 0;
+	int ret = -EAGAIN;
+
+	if (sq->xsk.last_desc.addr) {
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
+		if (virtqueue_kick_prepare(sq->vq) &&
+		    virtqueue_notify(sq->vq)) {
+			u64_stats_update_begin(&sq->stats.syncp);
+			sq->stats.kicks += 1;
+			u64_stats_update_end(&sq->stats.syncp);
+		}
+
+		*done = packet;
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
+	int done = 0;
+	int err;
+
+	free_old_xmit_skbs(sq, in_napi);
+
+	err = virtnet_xsk_xmit_batch(sq, pool, budget, in_napi, &done);
+	/* -EAGAIN: done == budget
+	 * -EBUSY: done < budget
+	 *  0    : done < budget
+	 */
+	if (err == -EBUSY) {
+		free_old_xmit_skbs(sq, in_napi);
+
+		/* If the space is enough, let napi run again. */
+		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
+			done = budget;
+	}
+
+	virtnet_xsk_check_space(sq);
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
+	virtnet_xsk_run(sq, pool, xsk_budget, false);
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
@@ -2553,6 +2733,8 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 	if (rcu_dereference(sq->xsk.pool))
 		goto end;
 
+	memset(&sq->xsk, 0, sizeof(sq->xsk));
+
 	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
 	 * safe.
 	 */
@@ -2656,6 +2838,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_vlan_rx_kill_vid = virtnet_vlan_rx_kill_vid,
 	.ndo_bpf		= virtnet_xdp,
 	.ndo_xdp_xmit		= virtnet_xdp_xmit,
+	.ndo_xsk_wakeup         = virtnet_xsk_wakeup,
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
-- 
2.31.0

