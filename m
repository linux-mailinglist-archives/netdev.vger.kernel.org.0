Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C113A26C8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhFJIYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:24:43 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:54609 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhFJIYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:24:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UbxRMxb_1623313335;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UbxRMxb_1623313335)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 16:22:15 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v5 13/15] virtio-net: support AF_XDP zc rx
Date:   Thu, 10 Jun 2021 16:22:07 +0800
Message-Id: <20210610082209.91487-14-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compared to the case of xsk tx, the case of xsk zc rx is more
complicated.

When we process the buf received by vq, we may encounter ordinary
buffers, or xsk buffers. What makes the situation more complicated is
that in the case of mergeable, when num_buffer > 1, we may still
encounter the case where xsk buffer is mixed with ordinary buffer.

Another thing that makes the situation more complicated is that when we
get an xsk buffer from vq, the xsk bound to this xsk buffer may have
been unbound.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtio_net.c | 238 ++++++++++++++-----
 drivers/net/virtio/virtio_net.h |  27 +++
 drivers/net/virtio/xsk.c        | 396 +++++++++++++++++++++++++++++++-
 drivers/net/virtio/xsk.h        |  75 ++++++
 4 files changed, 678 insertions(+), 58 deletions(-)

diff --git a/drivers/net/virtio/virtio_net.c b/drivers/net/virtio/virtio_net.c
index 40d7751f1c5f..9503133e71f0 100644
--- a/drivers/net/virtio/virtio_net.c
+++ b/drivers/net/virtio/virtio_net.c
@@ -125,11 +125,6 @@ static int rxq2vq(int rxq)
 	return rxq * 2;
 }
 
-static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
-{
-	return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
-}
-
 /*
  * private is used to chain pages for big packets, put the whole
  * most recent used list in the beginning for reuse
@@ -458,6 +453,68 @@ static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
 	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
 }
 
+/* return value:
+ *  1: XDP_PASS should handle to build skb
+ * -1: xdp err, should handle to free the buf and return NULL
+ *  0: buf has been consumed by xdp
+ */
+int virtnet_run_xdp(struct net_device *dev,
+		    struct bpf_prog *xdp_prog,
+		    struct xdp_buff *xdp,
+		    unsigned int *xdp_xmit,
+		    struct virtnet_rq_stats *stats)
+{
+	struct xdp_frame *xdpf;
+	int act, err;
+
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	stats->xdp_packets++;
+
+	switch (act) {
+	case XDP_PASS:
+		return 1;
+
+	case XDP_TX:
+		stats->xdp_tx++;
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		if (unlikely(!xdpf))
+			goto err_xdp;
+		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
+		if (unlikely(!err)) {
+			xdp_return_frame_rx_napi(xdpf);
+		} else if (unlikely(err < 0)) {
+			trace_xdp_exception(dev, xdp_prog, act);
+			goto err_xdp;
+		}
+		*xdp_xmit |= VIRTIO_XDP_TX;
+		return 0;
+
+	case XDP_REDIRECT:
+		stats->xdp_redirects++;
+		err = xdp_do_redirect(dev, xdp, xdp_prog);
+		if (err)
+			goto err_xdp;
+
+		*xdp_xmit |= VIRTIO_XDP_REDIR;
+		return 0;
+
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		fallthrough;
+
+	case XDP_ABORTED:
+		trace_xdp_exception(dev, xdp_prog, act);
+		fallthrough;
+
+	case XDP_DROP:
+		break;
+	}
+
+err_xdp:
+	stats->xdp_drops++;
+	return -1;
+}
+
 /* We copy the packet for XDP in the following cases:
  *
  * 1) Packet is scattered across multiple rx buffers.
@@ -491,27 +548,40 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 		int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		unsigned int buflen;
 		void *buf;
+		void *ctx;
 		int off;
 
-		buf = virtqueue_get_buf(rq->vq, &buflen);
+		buf = virtqueue_get_buf_ctx(rq->vq, &buflen, &ctx);
 		if (unlikely(!buf))
 			goto err_buf;
 
-		p = virt_to_head_page(buf);
-		off = buf - page_address(p);
-
 		/* guard against a misconfigured or uncooperative backend that
 		 * is sending packet larger than the MTU.
 		 */
 		if ((page_off + buflen + tailroom) > PAGE_SIZE) {
-			put_page(p);
+			virtnet_rx_put_buf(buf, ctx);
 			goto err_buf;
 		}
 
-		memcpy(page_address(page) + page_off,
-		       page_address(p) + off, buflen);
+		if (is_xsk_ctx(ctx)) {
+			struct virtnet_xsk_ctx_rx *xsk_ctx;
+
+			xsk_ctx = (struct virtnet_xsk_ctx_rx *)buf;
+
+			virtnet_xsk_ctx_rx_copy(xsk_ctx,
+						page_address(page) + page_off,
+						buflen, true);
+
+			virtnet_xsk_ctx_rx_put(xsk_ctx);
+		} else {
+			p = virt_to_head_page(buf);
+			off = buf - page_address(p);
+
+			memcpy(page_address(page) + page_off,
+			       page_address(p) + off, buflen);
+			put_page(p);
+		}
 		page_off += buflen;
-		put_page(p);
 	}
 
 	/* Headroom does not contribute to packet length */
@@ -522,17 +592,16 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	return NULL;
 }
 
-static void merge_drop_follow_bufs(struct net_device *dev,
-				   struct receive_queue *rq,
-				   u16 num_buf,
-				   struct virtnet_rq_stats *stats)
+void merge_drop_follow_bufs(struct net_device *dev,
+			    struct receive_queue *rq,
+			    u16 num_buf,
+			    struct virtnet_rq_stats *stats)
 {
-	struct page *page;
 	unsigned int len;
-	void *buf;
+	void *buf, *ctx;
 
 	while (num_buf-- > 1) {
-		buf = virtqueue_get_buf(rq->vq, &len);
+		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers missing\n",
 				 dev->name, num_buf);
@@ -540,23 +609,80 @@ static void merge_drop_follow_bufs(struct net_device *dev,
 			break;
 		}
 		stats->bytes += len;
-		page = virt_to_head_page(buf);
-		put_page(page);
+		virtnet_rx_put_buf(buf, ctx);
+	}
+}
+
+static char *merge_get_follow_buf(struct net_device *dev,
+				  struct receive_queue *rq,
+				  int *plen, int *ptruesize,
+				  int index, int total)
+{
+	struct virtnet_xsk_ctx_rx *xsk_ctx;
+	unsigned int truesize;
+	char *buf;
+	void *ctx;
+	int len;
+
+	buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
+	if (unlikely(!buf)) {
+		pr_debug("%s: rx error: %d buffers out of %d missing\n",
+			 dev->name, index, total);
+		dev->stats.rx_length_errors++;
+		return NULL;
+	}
+
+	if (is_xsk_ctx(ctx)) {
+		xsk_ctx = (struct virtnet_xsk_ctx_rx *)buf;
+
+		if (unlikely(len > xsk_ctx->ctx.head->truesize)) {
+			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+				 dev->name, len, (unsigned long)ctx);
+			dev->stats.rx_length_errors++;
+			virtnet_xsk_ctx_rx_put(xsk_ctx);
+			return ERR_PTR(-EDQUOT);
+		}
+
+		truesize = len;
+
+		buf = virtnet_alloc_frag(rq, truesize, GFP_ATOMIC);
+		if (unlikely(!buf)) {
+			virtnet_xsk_ctx_rx_put(xsk_ctx);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		virtnet_xsk_ctx_rx_copy(xsk_ctx, buf, len, true);
+		virtnet_xsk_ctx_rx_put(xsk_ctx);
+	} else {
+		truesize = mergeable_ctx_to_truesize(ctx);
+		if (unlikely(len > truesize)) {
+			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+				 dev->name, len, (unsigned long)ctx);
+			dev->stats.rx_length_errors++;
+
+			put_page(virt_to_head_page(buf));
+			return ERR_PTR(-EDQUOT);
+		}
 	}
+
+	*plen = len;
+	*ptruesize = truesize;
+
+	return buf;
 }
 
-static struct sk_buff *merge_receive_follow_bufs(struct net_device *dev,
-						 struct virtnet_info *vi,
-						 struct receive_queue *rq,
-						 struct sk_buff *head_skb,
-						 u16 num_buf,
-						 struct virtnet_rq_stats *stats)
+struct sk_buff *merge_receive_follow_bufs(struct net_device *dev,
+					  struct virtnet_info *vi,
+					  struct receive_queue *rq,
+					  struct sk_buff *head_skb,
+					  u16 num_buf,
+					  struct virtnet_rq_stats *stats)
 {
 	struct sk_buff *curr_skb;
 	unsigned int truesize;
 	unsigned int len, num;
 	struct page *page;
-	void *buf, *ctx;
+	void *buf;
 	int offset;
 
 	curr_skb = head_skb;
@@ -565,25 +691,17 @@ static struct sk_buff *merge_receive_follow_bufs(struct net_device *dev,
 	while (--num_buf) {
 		int num_skb_frags;
 
-		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
-		if (unlikely(!buf)) {
-			pr_debug("%s: rx error: %d buffers out of %d missing\n",
-				 dev->name, num_buf, num);
-			dev->stats.rx_length_errors++;
+		buf = merge_get_follow_buf(dev, rq, &len, &truesize,
+					   num_buf, num);
+		if (unlikely(!buf))
 			goto err_buf;
-		}
+
+		if (IS_ERR(buf))
+			goto err_drop;
 
 		stats->bytes += len;
 		page = virt_to_head_page(buf);
 
-		truesize = mergeable_ctx_to_truesize(ctx);
-		if (unlikely(len > truesize)) {
-			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
-				 dev->name, len, (unsigned long)ctx);
-			dev->stats.rx_length_errors++;
-			goto err_skb;
-		}
-
 		num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
 		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
 			struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
@@ -618,6 +736,7 @@ static struct sk_buff *merge_receive_follow_bufs(struct net_device *dev,
 
 err_skb:
 	put_page(page);
+err_drop:
 	merge_drop_follow_bufs(dev, rq, num_buf, stats);
 err_buf:
 	stats->drops++;
@@ -982,16 +1101,18 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		pr_debug("%s: short packet %i\n", dev->name, len);
 		dev->stats.rx_length_errors++;
 		if (vi->mergeable_rx_bufs) {
-			put_page(virt_to_head_page(buf));
+			virtnet_rx_put_buf(buf, ctx);
 		} else if (vi->big_packets) {
 			give_pages(rq, buf);
 		} else {
-			put_page(virt_to_head_page(buf));
+			virtnet_rx_put_buf(buf, ctx);
 		}
 		return;
 	}
 
-	if (vi->mergeable_rx_bufs)
+	if (is_xsk_ctx(ctx))
+		skb = receive_xsk(dev, vi, rq, buf, len, xdp_xmit, stats);
+	else if (vi->mergeable_rx_bufs)
 		skb = receive_mergeable(dev, vi, rq, buf, ctx, len, xdp_xmit,
 					stats);
 	else if (vi->big_packets)
@@ -1175,6 +1296,14 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
 	int err;
 	bool oom;
 
+	/* Because virtio-net does not yet support flow direct, all rx
+	 * channels must also process other non-xsk packets. If there is
+	 * no buf available from xsk temporarily, we try to allocate
+	 * memory to the channel.
+	 */
+	if (fill_recv_xsk(vi, rq, gfp))
+		goto kick;
+
 	do {
 		if (vi->mergeable_rx_bufs)
 			err = add_recvbuf_mergeable(vi, rq, gfp);
@@ -1187,6 +1316,8 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
 		if (err)
 			break;
 	} while (rq->vq->num_free);
+
+kick:
 	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
 		unsigned long flags;
 
@@ -2575,7 +2706,7 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 
 static void free_unused_bufs(struct virtnet_info *vi)
 {
-	void *buf;
+	void *buf, *ctx;
 	int i;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -2593,14 +2724,13 @@ static void free_unused_bufs(struct virtnet_info *vi)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		struct virtqueue *vq = vi->rq[i].vq;
 
-		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
-			if (vi->mergeable_rx_bufs) {
-				put_page(virt_to_head_page(buf));
-			} else if (vi->big_packets) {
+		while ((buf = virtqueue_detach_unused_buf_ctx(vq, &ctx)) != NULL) {
+			if (vi->mergeable_rx_bufs)
+				virtnet_rx_put_buf(buf, ctx);
+			else if (vi->big_packets)
 				give_pages(&vi->rq[i], buf);
-			} else {
-				put_page(virt_to_head_page(buf));
-			}
+			else
+				virtnet_rx_put_buf(buf, ctx);
 		}
 	}
 }
diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
index e3da829887dc..70af880f469d 100644
--- a/drivers/net/virtio/virtio_net.h
+++ b/drivers/net/virtio/virtio_net.h
@@ -177,8 +177,23 @@ struct receive_queue {
 	char name[40];
 
 	struct xdp_rxq_info xdp_rxq;
+
+	struct {
+		struct xsk_buff_pool __rcu *pool;
+
+		/* xdp rxq used by xsk */
+		struct xdp_rxq_info xdp_rxq;
+
+		/* ctx used to record the page added to vq */
+		struct virtnet_xsk_ctx_head *ctx_head;
+	} xsk;
 };
 
+static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
+{
+	return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
+}
+
 static inline bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
 {
 	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
@@ -258,4 +273,16 @@ static inline void __free_old_xmit(struct send_queue *sq, bool in_napi,
 	if (xsknum)
 		virtnet_xsk_complete(sq, xsknum);
 }
+
+int virtnet_run_xdp(struct net_device *dev, struct bpf_prog *xdp_prog,
+		    struct xdp_buff *xdp, unsigned int *xdp_xmit,
+		    struct virtnet_rq_stats *stats);
+struct sk_buff *merge_receive_follow_bufs(struct net_device *dev,
+					  struct virtnet_info *vi,
+					  struct receive_queue *rq,
+					  struct sk_buff *head_skb,
+					  u16 num_buf,
+					  struct virtnet_rq_stats *stats);
+void merge_drop_follow_bufs(struct net_device *dev, struct receive_queue *rq,
+			    u16 num_buf, struct virtnet_rq_stats *stats);
 #endif
diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
index f98b68576709..36cda2dcf8e7 100644
--- a/drivers/net/virtio/xsk.c
+++ b/drivers/net/virtio/xsk.c
@@ -20,6 +20,75 @@ static struct virtnet_xsk_ctx *virtnet_xsk_ctx_get(struct virtnet_xsk_ctx_head *
 }
 
 #define virtnet_xsk_ctx_tx_get(head) ((struct virtnet_xsk_ctx_tx *)virtnet_xsk_ctx_get(head))
+#define virtnet_xsk_ctx_rx_get(head) ((struct virtnet_xsk_ctx_rx *)virtnet_xsk_ctx_get(head))
+
+static unsigned int virtnet_receive_buf_num(struct virtnet_info *vi, char *buf)
+{
+	struct virtio_net_hdr_mrg_rxbuf *hdr;
+
+	if (vi->mergeable_rx_bufs) {
+		hdr = (struct virtio_net_hdr_mrg_rxbuf *)buf;
+		return virtio16_to_cpu(vi->vdev, hdr->num_buffers);
+	}
+
+	return 1;
+}
+
+/* when xsk rx ctx ref two page, copy to dst from two page */
+static void virtnet_xsk_rx_ctx_merge(struct virtnet_xsk_ctx_rx *ctx,
+				     char *dst, unsigned int len)
+{
+	unsigned int size;
+	int offset;
+	char *src;
+
+	/* data start from first page */
+	if (ctx->offset >= 0) {
+		offset = ctx->offset;
+
+		size = min_t(int, PAGE_SIZE - offset, len);
+		src = page_address(ctx->ctx.page) + offset;
+		memcpy(dst, src, size);
+
+		if (len > size) {
+			src = page_address(ctx->ctx.page_unaligned);
+			memcpy(dst + size, src, len - size);
+		}
+
+	} else {
+		offset = -ctx->offset;
+
+		src = page_address(ctx->ctx.page_unaligned) + offset;
+
+		memcpy(dst, src, len);
+	}
+}
+
+/* copy ctx to dst, need to make sure that len is safe */
+void virtnet_xsk_ctx_rx_copy(struct virtnet_xsk_ctx_rx *ctx,
+			     char *dst, unsigned int len,
+			     bool hdr)
+{
+	char *src;
+	int size;
+
+	if (hdr) {
+		size = min_t(int, ctx->ctx.head->hdr_len, len);
+		memcpy(dst, &ctx->hdr, size);
+		len -= size;
+		if (!len)
+			return;
+		dst += size;
+	}
+
+	if (!ctx->ctx.page_unaligned) {
+		src = page_address(ctx->ctx.page) + ctx->offset;
+		memcpy(dst, src, len);
+
+	} else {
+		virtnet_xsk_rx_ctx_merge(ctx, dst, len);
+	}
+}
 
 static void virtnet_xsk_check_queue(struct send_queue *sq)
 {
@@ -45,6 +114,267 @@ static void virtnet_xsk_check_queue(struct send_queue *sq)
 		netif_stop_subqueue(dev, qnum);
 }
 
+static struct sk_buff *virtnet_xsk_construct_skb_xdp(struct receive_queue *rq,
+						     struct xdp_buff *xdp)
+{
+	unsigned int metasize = xdp->data - xdp->data_meta;
+	struct sk_buff *skb;
+	unsigned int size;
+
+	size = xdp->data_end - xdp->data_hard_start;
+	skb = napi_alloc_skb(&rq->napi, size);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start);
+
+	size = xdp->data_end - xdp->data_meta;
+	memcpy(__skb_put(skb, size), xdp->data_meta, size);
+
+	if (metasize) {
+		__skb_pull(skb, metasize);
+		skb_metadata_set(skb, metasize);
+	}
+
+	return skb;
+}
+
+static struct sk_buff *virtnet_xsk_construct_skb_ctx(struct net_device *dev,
+						     struct virtnet_info *vi,
+						     struct receive_queue *rq,
+						     struct virtnet_xsk_ctx_rx *ctx,
+						     unsigned int len,
+						     struct virtnet_rq_stats *stats)
+{
+	struct virtio_net_hdr_mrg_rxbuf *hdr;
+	struct sk_buff *skb;
+	int num_buf;
+	char *dst;
+
+	len -= vi->hdr_len;
+
+	skb = napi_alloc_skb(&rq->napi, len);
+	if (unlikely(!skb))
+		return NULL;
+
+	dst = __skb_put(skb, len);
+
+	virtnet_xsk_ctx_rx_copy(ctx, dst, len, false);
+
+	num_buf = virtnet_receive_buf_num(vi, (char *)&ctx->hdr);
+	if (num_buf > 1) {
+		skb = merge_receive_follow_bufs(dev, vi, rq, skb, num_buf,
+						stats);
+		if (!skb)
+			return NULL;
+	}
+
+	hdr = skb_vnet_hdr(skb);
+	memcpy(hdr, &ctx->hdr, vi->hdr_len);
+
+	return skb;
+}
+
+/* len not include virtio-net hdr */
+static struct xdp_buff *virtnet_xsk_check_xdp(struct virtnet_info *vi,
+					      struct receive_queue *rq,
+					      struct virtnet_xsk_ctx_rx *ctx,
+					      struct xdp_buff *_xdp,
+					      unsigned int len)
+{
+	struct xdp_buff *xdp;
+	struct page *page;
+	int frame_sz;
+	char *data;
+
+	if (ctx->ctx.head->active) {
+		xdp = ctx->xdp;
+		xdp->data_end = xdp->data + len;
+
+		return xdp;
+	}
+
+	/* ctx->xdp is invalid, because of that is released */
+
+	if (!ctx->ctx.page_unaligned) {
+		data = page_address(ctx->ctx.page) + ctx->offset;
+		page = ctx->ctx.page;
+	} else {
+		page = alloc_page(GFP_ATOMIC);
+		if (!page)
+			return NULL;
+
+		data = page_address(page) + ctx->headroom;
+
+		virtnet_xsk_rx_ctx_merge(ctx, data, len);
+
+		put_page(ctx->ctx.page);
+		put_page(ctx->ctx.page_unaligned);
+
+		/* page will been put when ctx is put */
+		ctx->ctx.page = page;
+		ctx->ctx.page_unaligned = NULL;
+	}
+
+	/* If xdp consume the data with XDP_REDIRECT/XDP_TX, the page
+	 * ref will been dec. So call get_page here.
+	 *
+	 * If xdp has been consumed, the page ref will dec auto and
+	 * virtnet_xsk_ctx_rx_put will dec the ref again.
+	 *
+	 * If xdp has not been consumed, then manually put_page once before
+	 * virtnet_xsk_ctx_rx_put.
+	 */
+	get_page(page);
+
+	xdp = _xdp;
+
+	frame_sz = ctx->ctx.head->frame_size + ctx->headroom;
+
+	/* use xdp rxq without MEM_TYPE_XSK_BUFF_POOL */
+	xdp_init_buff(xdp, frame_sz, &rq->xdp_rxq);
+	xdp_prepare_buff(xdp, data - ctx->headroom, ctx->headroom, len, true);
+
+	return xdp;
+}
+
+int add_recvbuf_xsk(struct virtnet_info *vi, struct receive_queue *rq,
+		    struct xsk_buff_pool *pool, gfp_t gfp)
+{
+	struct page *page, *page_start, *page_end;
+	unsigned long data, data_end, data_start;
+	struct virtnet_xsk_ctx_rx *ctx;
+	struct xdp_buff *xsk_xdp;
+	int err, size, n;
+	u32 offset;
+
+	xsk_xdp = xsk_buff_alloc(pool);
+	if (!xsk_xdp)
+		return -ENOMEM;
+
+	ctx = virtnet_xsk_ctx_rx_get(rq->xsk.ctx_head);
+
+	ctx->xdp = xsk_xdp;
+	ctx->headroom = xsk_xdp->data - xsk_xdp->data_hard_start;
+
+	offset = offset_in_page(xsk_xdp->data);
+
+	data_start = (unsigned long)xsk_xdp->data_hard_start;
+	data       = (unsigned long)xsk_xdp->data;
+	data_end   = data + ctx->ctx.head->frame_size - 1;
+
+	page_start = vmalloc_to_page((void *)data_start);
+
+	ctx->ctx.page = page_start;
+	get_page(page_start);
+
+	if ((data_end & PAGE_MASK) == (data_start & PAGE_MASK)) {
+		page_end = page_start;
+		page = page_start;
+		ctx->offset = offset;
+
+		ctx->ctx.page_unaligned = NULL;
+		n = 2;
+	} else {
+		page_end = vmalloc_to_page((void *)data_end);
+
+		ctx->ctx.page_unaligned = page_end;
+		get_page(page_end);
+
+		if ((data_start & PAGE_MASK) == (data & PAGE_MASK)) {
+			page = page_start;
+			ctx->offset = offset;
+			n = 3;
+		} else {
+			page = page_end;
+			ctx->offset = -offset;
+			n = 2;
+		}
+	}
+
+	size = min_t(int, PAGE_SIZE - offset, ctx->ctx.head->frame_size);
+
+	sg_init_table(rq->sg, n);
+	sg_set_buf(rq->sg, &ctx->hdr, vi->hdr_len);
+	sg_set_page(rq->sg + 1, page, size, offset);
+
+	if (n == 3) {
+		size = ctx->ctx.head->frame_size - size;
+		sg_set_page(rq->sg + 2, page_end, size, 0);
+	}
+
+	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, n, ctx,
+				      VIRTNET_XSK_BUFF_CTX, gfp);
+	if (err < 0)
+		virtnet_xsk_ctx_rx_put(ctx);
+
+	return err;
+}
+
+struct sk_buff *receive_xsk(struct net_device *dev, struct virtnet_info *vi,
+			    struct receive_queue *rq, void *buf,
+			    unsigned int len, unsigned int *xdp_xmit,
+			    struct virtnet_rq_stats *stats)
+{
+	struct virtnet_xsk_ctx_rx *ctx;
+	struct xsk_buff_pool *pool;
+	struct sk_buff *skb = NULL;
+	struct xdp_buff *xdp, _xdp;
+	struct bpf_prog *xdp_prog;
+	u16 num_buf = 1;
+	int ret;
+
+	ctx = (struct virtnet_xsk_ctx_rx *)buf;
+
+	rcu_read_lock();
+
+	pool     = rcu_dereference(rq->xsk.pool);
+	xdp_prog = rcu_dereference(rq->xdp_prog);
+	if (!pool || !xdp_prog)
+		goto skb;
+
+	/* this may happen when xsk chunk size too small. */
+	num_buf = virtnet_receive_buf_num(vi, (char *)&ctx->hdr);
+	if (num_buf > 1)
+		goto drop;
+
+	xdp = virtnet_xsk_check_xdp(vi, rq, ctx, &_xdp, len - vi->hdr_len);
+	if (!xdp)
+		goto drop;
+
+	ret = virtnet_run_xdp(dev, xdp_prog, xdp, xdp_xmit, stats);
+	if (unlikely(ret)) {
+		/* pair for get_page inside virtnet_xsk_check_xdp */
+		if (!ctx->ctx.head->active)
+			put_page(ctx->ctx.page);
+
+		if (unlikely(ret < 0))
+			goto drop;
+
+		/* XDP_PASS */
+		skb = virtnet_xsk_construct_skb_xdp(rq, xdp);
+	} else {
+		/* ctx->xdp has been consumed */
+		ctx->xdp = NULL;
+	}
+
+end:
+	virtnet_xsk_ctx_rx_put(ctx);
+	rcu_read_unlock();
+	return skb;
+
+skb:
+	skb = virtnet_xsk_construct_skb_ctx(dev, vi, rq, ctx, len, stats);
+	goto end;
+
+drop:
+	stats->drops++;
+
+	if (num_buf > 1)
+		merge_drop_follow_bufs(dev, rq, num_buf, stats);
+	goto end;
+}
+
 void virtnet_xsk_complete(struct send_queue *sq, u32 num)
 {
 	struct xsk_buff_pool *pool;
@@ -238,15 +568,20 @@ int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag)
 	return 0;
 }
 
-static struct virtnet_xsk_ctx_head *virtnet_xsk_ctx_alloc(struct xsk_buff_pool *pool,
-							  struct virtqueue *vq)
+static struct virtnet_xsk_ctx_head *virtnet_xsk_ctx_alloc(struct virtnet_info *vi,
+							  struct xsk_buff_pool *pool,
+							  struct virtqueue *vq,
+							  bool rx)
 {
 	struct virtnet_xsk_ctx_head *head;
 	u32 size, n, ring_size, ctx_sz;
 	struct virtnet_xsk_ctx *ctx;
 	void *p;
 
-	ctx_sz = sizeof(struct virtnet_xsk_ctx_tx);
+	if (rx)
+		ctx_sz = sizeof(struct virtnet_xsk_ctx_rx);
+	else
+		ctx_sz = sizeof(struct virtnet_xsk_ctx_tx);
 
 	ring_size = virtqueue_get_vring_size(vq);
 	size = sizeof(*head) + ctx_sz * ring_size;
@@ -259,6 +594,8 @@ static struct virtnet_xsk_ctx_head *virtnet_xsk_ctx_alloc(struct xsk_buff_pool *
 
 	head->active = true;
 	head->frame_size = xsk_pool_get_rx_frame_size(pool);
+	head->hdr_len = vi->hdr_len;
+	head->truesize = head->frame_size + vi->hdr_len;
 
 	p = head + 1;
 	for (n = 0; n < ring_size; ++n) {
@@ -278,12 +615,15 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 				   u16 qid)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
+	struct receive_queue *rq;
 	struct send_queue *sq;
+	int err;
 
 	if (qid >= vi->curr_queue_pairs)
 		return -EINVAL;
 
 	sq = &vi->sq[qid];
+	rq = &vi->rq[qid];
 
 	/* xsk zerocopy depend on the tx napi.
 	 *
@@ -295,31 +635,68 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 
 	memset(&sq->xsk, 0, sizeof(sq->xsk));
 
-	sq->xsk.ctx_head = virtnet_xsk_ctx_alloc(pool, sq->vq);
+	sq->xsk.ctx_head = virtnet_xsk_ctx_alloc(vi, pool, sq->vq, false);
 	if (!sq->xsk.ctx_head)
 		return -ENOMEM;
 
+	/* In big_packets mode, xdp cannot work, so there is no need to
+	 * initialize xsk of rq.
+	 */
+	if (!vi->big_packets || vi->mergeable_rx_bufs) {
+		err = xdp_rxq_info_reg(&rq->xsk.xdp_rxq, dev, qid,
+				       rq->napi.napi_id);
+		if (err < 0)
+			goto err;
+
+		err = xdp_rxq_info_reg_mem_model(&rq->xsk.xdp_rxq,
+						 MEM_TYPE_XSK_BUFF_POOL, NULL);
+		if (err < 0) {
+			xdp_rxq_info_unreg(&rq->xsk.xdp_rxq);
+			goto err;
+		}
+
+		rq->xsk.ctx_head = virtnet_xsk_ctx_alloc(vi, pool, rq->vq, true);
+		if (!rq->xsk.ctx_head) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		xsk_pool_set_rxq_info(pool, &rq->xsk.xdp_rxq);
+
+		/* Here is already protected by rtnl_lock, so rcu_assign_pointer
+		 * is safe.
+		 */
+		rcu_assign_pointer(rq->xsk.pool, pool);
+	}
+
 	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
 	 * safe.
 	 */
 	rcu_assign_pointer(sq->xsk.pool, pool);
 
 	return 0;
+
+err:
+	kfree(sq->xsk.ctx_head);
+	return err;
 }
 
 static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
+	struct receive_queue *rq;
 	struct send_queue *sq;
 
 	if (qid >= vi->curr_queue_pairs)
 		return -EINVAL;
 
 	sq = &vi->sq[qid];
+	rq = &vi->rq[qid];
 
 	/* Here is already protected by rtnl_lock, so rcu_assign_pointer is
 	 * safe.
 	 */
+	rcu_assign_pointer(rq->xsk.pool, NULL);
 	rcu_assign_pointer(sq->xsk.pool, NULL);
 
 	/* Sync with the XSK wakeup and with NAPI. */
@@ -332,6 +709,17 @@ static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
 
 	sq->xsk.ctx_head = NULL;
 
+	if (!vi->big_packets || vi->mergeable_rx_bufs) {
+		if (READ_ONCE(rq->xsk.ctx_head->ref))
+			WRITE_ONCE(rq->xsk.ctx_head->active, false);
+		else
+			kfree(rq->xsk.ctx_head);
+
+		rq->xsk.ctx_head = NULL;
+
+		xdp_rxq_info_unreg(&rq->xsk.xdp_rxq);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
index 54948e0b07fc..fe22cf78d505 100644
--- a/drivers/net/virtio/xsk.h
+++ b/drivers/net/virtio/xsk.h
@@ -5,6 +5,8 @@
 
 #define VIRTIO_XSK_FLAG	BIT(1)
 
+#define VIRTNET_XSK_BUFF_CTX  ((void *)(unsigned long)~0L)
+
 /* When xsk disable, under normal circumstances, the network card must reclaim
  * all the memory that has been sent and the memory added to the rq queue by
  * destroying the queue.
@@ -36,6 +38,8 @@ struct virtnet_xsk_ctx_head {
 	u64 ref;
 
 	unsigned int frame_size;
+	unsigned int truesize;
+	unsigned int hdr_len;
 
 	/* the xsk status */
 	bool active;
@@ -59,6 +63,28 @@ struct virtnet_xsk_ctx_tx {
 	u32 len;
 };
 
+struct virtnet_xsk_ctx_rx {
+	/* this *MUST* be the first */
+	struct virtnet_xsk_ctx ctx;
+
+	/* xdp get from xsk */
+	struct xdp_buff *xdp;
+
+	/* offset of the xdp.data inside it's page */
+	int offset;
+
+	/* xsk xdp headroom */
+	unsigned int headroom;
+
+	/* Users don't want us to occupy xsk frame to save virtio hdr */
+	struct virtio_net_hdr_mrg_rxbuf hdr;
+};
+
+static inline bool is_xsk_ctx(void *ctx)
+{
+	return ctx == VIRTNET_XSK_BUFF_CTX;
+}
+
 static inline void *xsk_to_ptr(struct virtnet_xsk_ctx_tx *ctx)
 {
 	return (void *)((unsigned long)ctx | VIRTIO_XSK_FLAG);
@@ -92,8 +118,57 @@ static inline void virtnet_xsk_ctx_put(struct virtnet_xsk_ctx *ctx)
 #define virtnet_xsk_ctx_tx_put(ctx) \
 	virtnet_xsk_ctx_put((struct virtnet_xsk_ctx *)ctx)
 
+static inline void virtnet_xsk_ctx_rx_put(struct virtnet_xsk_ctx_rx *ctx)
+{
+	if (ctx->xdp && ctx->ctx.head->active)
+		xsk_buff_free(ctx->xdp);
+
+	virtnet_xsk_ctx_put((struct virtnet_xsk_ctx *)ctx);
+}
+
+static inline void virtnet_rx_put_buf(char *buf, void *ctx)
+{
+	if (is_xsk_ctx(ctx))
+		virtnet_xsk_ctx_rx_put((struct virtnet_xsk_ctx_rx *)buf);
+	else
+		put_page(virt_to_head_page(buf));
+}
+
+void virtnet_xsk_ctx_rx_copy(struct virtnet_xsk_ctx_rx *ctx,
+			     char *dst, unsigned int len, bool hdr);
+int add_recvbuf_xsk(struct virtnet_info *vi, struct receive_queue *rq,
+		    struct xsk_buff_pool *pool, gfp_t gfp);
+struct sk_buff *receive_xsk(struct net_device *dev, struct virtnet_info *vi,
+			    struct receive_queue *rq, void *buf,
+			    unsigned int len, unsigned int *xdp_xmit,
+			    struct virtnet_rq_stats *stats);
 int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag);
 int virtnet_poll_xsk(struct send_queue *sq, int budget);
 void virtnet_xsk_complete(struct send_queue *sq, u32 num);
 int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp);
+
+static inline bool fill_recv_xsk(struct virtnet_info *vi,
+				 struct receive_queue *rq,
+				 gfp_t gfp)
+{
+	struct xsk_buff_pool *pool;
+	int err;
+
+	rcu_read_lock();
+	pool = rcu_dereference(rq->xsk.pool);
+	if (pool) {
+		while (rq->vq->num_free >= 3) {
+			err = add_recvbuf_xsk(vi, rq, pool, gfp);
+			if (err)
+				break;
+		}
+	} else {
+		rcu_read_unlock();
+		return false;
+	}
+	rcu_read_unlock();
+
+	return err != -ENOMEM;
+}
+
 #endif
-- 
2.31.0

