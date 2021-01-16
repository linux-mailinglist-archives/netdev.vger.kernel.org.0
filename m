Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDED2F8AE0
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 04:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbhAPDAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 22:00:21 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33937 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728493AbhAPDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 22:00:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0ULrQCa5_1610765970;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ULrQCa5_1610765970)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 16 Jan 2021 10:59:30 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next v2 5/7] virtio-net, xsk: realize the function of xsk packet sending
Date:   Sat, 16 Jan 2021 10:59:26 +0800
Message-Id: <9e1f5a4b633887ce1f66e39bc762b8497a379a43.1610765285.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
 <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
References: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtnet_xsk_run will be called in the tx interrupt handling function
virtnet_poll_tx.

The sending process gets desc from the xsk tx queue, and assembles it to
send the data.

Compared with other drivers, a special place is that the page of the
data in xsk is used here instead of the dma address. Because the virtio
interface does not use the dma address.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 200 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 197 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a62d456..42aa9ad 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -119,6 +119,8 @@ struct virtnet_xsk_hdr {
 	u32 len;
 };
 
+#define VIRTNET_STATE_XSK_WAKEUP 1
+
 #define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
 #define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
 
@@ -163,9 +165,12 @@ struct send_queue {
 		struct xsk_buff_pool   __rcu *pool;
 		struct virtnet_xsk_hdr __rcu *hdr;
 
+		unsigned long          state;
 		u64                    hdr_con;
 		u64                    hdr_pro;
 		u64                    hdr_n;
+		struct xdp_desc        last_desc;
+		bool                   wait_slot;
 	} xsk;
 };
 
@@ -284,6 +289,8 @@ static void __free_old_xmit_ptr(struct send_queue *sq, bool in_napi,
 				bool xsk_wakeup,
 				unsigned int *_packets, unsigned int *_bytes);
 static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi);
+static int virtnet_xsk_run(struct send_queue *sq,
+			   struct xsk_buff_pool *pool, int budget);
 
 static bool is_xdp_frame(void *ptr)
 {
@@ -1590,6 +1597,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	unsigned int index = vq2txq(sq->vq);
 	struct netdev_queue *txq;
+	struct xsk_buff_pool *pool;
+	int work = 0;
 
 	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
 		/* We don't need to enable cb for XDP */
@@ -1599,15 +1608,26 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
-	free_old_xmit_skbs(sq, true);
+
+	rcu_read_lock();
+	pool = rcu_dereference(sq->xsk.pool);
+	if (pool) {
+		work = virtnet_xsk_run(sq, pool, budget);
+		rcu_read_unlock();
+	} else {
+		rcu_read_unlock();
+		free_old_xmit_skbs(sq, true);
+	}
+
 	__netif_tx_unlock(txq);
 
-	virtqueue_napi_complete(napi, sq->vq, 0);
+	if (work < budget)
+		virtqueue_napi_complete(napi, sq->vq, 0);
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 		netif_tx_wake_queue(txq);
 
-	return 0;
+	return work;
 }
 
 static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
@@ -2647,6 +2667,180 @@ static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
+			    struct xdp_desc *desc)
+{
+	struct virtnet_info *vi = sq->vq->vdev->priv;
+	void *data, *ptr;
+	struct page *page;
+	struct virtnet_xsk_hdr *xskhdr;
+	u32 idx, offset, n, i, copy, copied;
+	u64 addr;
+	int err, m;
+
+	addr = desc->addr;
+
+	data = xsk_buff_raw_get_data(pool, addr);
+	offset = offset_in_page(data);
+
+	/* one for hdr, one for the first page */
+	n = 2;
+	m = desc->len - (PAGE_SIZE - offset);
+	if (m > 0) {
+		n += m >> PAGE_SHIFT;
+		if (m & PAGE_MASK)
+			++n;
+
+		n = min_t(u32, n, ARRAY_SIZE(sq->sg));
+	}
+
+	idx = sq->xsk.hdr_con % sq->xsk.hdr_n;
+	xskhdr = &sq->xsk.hdr[idx];
+
+	/* xskhdr->hdr has been memset to zero, so not need to clear again */
+
+	sg_init_table(sq->sg, n);
+	sg_set_buf(sq->sg, &xskhdr->hdr, vi->hdr_len);
+
+	copied = 0;
+	for (i = 1; i < n; ++i) {
+		copy = min_t(int, desc->len - copied, PAGE_SIZE - offset);
+
+		page = xsk_buff_raw_get_page(pool, addr + copied);
+
+		sg_set_page(sq->sg + i, page, copy, offset);
+		copied += copy;
+		if (offset)
+			offset = 0;
+	}
+
+	xskhdr->len = desc->len;
+	ptr = xdp_to_ptr(&xskhdr->type);
+
+	err = virtqueue_add_outbuf(sq->vq, sq->sg, n, ptr, GFP_ATOMIC);
+	if (unlikely(err))
+		sq->xsk.last_desc = *desc;
+	else
+		sq->xsk.hdr_con++;
+
+	return err;
+}
+
+static bool virtnet_xsk_dev_is_full(struct send_queue *sq)
+{
+	if (sq->vq->num_free < 2 + MAX_SKB_FRAGS)
+		return true;
+
+	if (sq->xsk.hdr_con == sq->xsk.hdr_pro)
+		return true;
+
+	return false;
+}
+
+static int virtnet_xsk_xmit_zc(struct send_queue *sq,
+			       struct xsk_buff_pool *pool, unsigned int budget)
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
+		sq->xsk.last_desc.addr = 0;
+	}
+
+	while (budget-- > 0) {
+		if (virtnet_xsk_dev_is_full(sq)) {
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
+		xsk_tx_release(pool);
+
+		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
+			u64_stats_update_begin(&sq->stats.syncp);
+			sq->stats.kicks++;
+			u64_stats_update_end(&sq->stats.syncp);
+		}
+	}
+
+	return ret;
+}
+
+static int virtnet_xsk_run(struct send_queue *sq,
+			   struct xsk_buff_pool *pool, int budget)
+{
+	int err, ret = 0;
+	unsigned int _packets = 0;
+	unsigned int _bytes = 0;
+
+	sq->xsk.wait_slot = false;
+
+	__free_old_xmit_ptr(sq, true, false, &_packets, &_bytes);
+
+	err = virtnet_xsk_xmit_zc(sq, pool, xsk_budget);
+	if (!err) {
+		struct xdp_desc desc;
+
+		clear_bit(VIRTNET_STATE_XSK_WAKEUP, &sq->xsk.state);
+		xsk_set_tx_need_wakeup(pool);
+
+		/* Race breaker. If new is coming after last xmit
+		 * but before flag change
+		 */
+
+		if (!xsk_tx_peek_desc(pool, &desc))
+			goto end;
+
+		set_bit(VIRTNET_STATE_XSK_WAKEUP, &sq->xsk.state);
+		xsk_clear_tx_need_wakeup(pool);
+
+		sq->xsk.last_desc = desc;
+		ret = budget;
+		goto end;
+	}
+
+	xsk_clear_tx_need_wakeup(pool);
+
+	if (err == -EAGAIN) {
+		ret = budget;
+		goto end;
+	}
+
+	__free_old_xmit_ptr(sq, true, false, &_packets, &_bytes);
+
+	if (!virtnet_xsk_dev_is_full(sq)) {
+		ret = budget;
+		goto end;
+	}
+
+	sq->xsk.wait_slot = true;
+
+	virtnet_sq_stop_check(sq, true);
+end:
+	return ret;
+}
+
 static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
 				      size_t len)
 {
-- 
1.8.3.1

