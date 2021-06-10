Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCE13A26B7
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhFJIYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:24:20 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:46958 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230506AbhFJIYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:24:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UbxH89d_1623313332;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UbxH89d_1623313332)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 16:22:13 +0800
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
Subject: [PATCH net-next v5 08/15] virtio-net: split the receive_mergeable function
Date:   Thu, 10 Jun 2021 16:22:02 +0800
Message-Id: <20210610082209.91487-9-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

receive_mergeable() is too complicated, so this function is split here.
One is to make the function more readable. On the other hand, the two
independent functions will be called separately in subsequent patches.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 181 ++++++++++++++++++++++++---------------
 1 file changed, 111 insertions(+), 70 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3fd87bf2b2ad..989aba600e63 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -733,6 +733,109 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	return NULL;
 }
 
+static void merge_drop_follow_bufs(struct net_device *dev,
+				   struct receive_queue *rq,
+				   u16 num_buf,
+				   struct virtnet_rq_stats *stats)
+{
+	struct page *page;
+	unsigned int len;
+	void *buf;
+
+	while (num_buf-- > 1) {
+		buf = virtqueue_get_buf(rq->vq, &len);
+		if (unlikely(!buf)) {
+			pr_debug("%s: rx error: %d buffers missing\n",
+				 dev->name, num_buf);
+			dev->stats.rx_length_errors++;
+			break;
+		}
+		stats->bytes += len;
+		page = virt_to_head_page(buf);
+		put_page(page);
+	}
+}
+
+static struct sk_buff *merge_receive_follow_bufs(struct net_device *dev,
+						 struct virtnet_info *vi,
+						 struct receive_queue *rq,
+						 struct sk_buff *head_skb,
+						 u16 num_buf,
+						 struct virtnet_rq_stats *stats)
+{
+	struct sk_buff *curr_skb;
+	unsigned int truesize;
+	unsigned int len, num;
+	struct page *page;
+	void *buf, *ctx;
+	int offset;
+
+	curr_skb = head_skb;
+	num = num_buf;
+
+	while (--num_buf) {
+		int num_skb_frags;
+
+		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
+		if (unlikely(!buf)) {
+			pr_debug("%s: rx error: %d buffers out of %d missing\n",
+				 dev->name, num_buf, num);
+			dev->stats.rx_length_errors++;
+			goto err_buf;
+		}
+
+		stats->bytes += len;
+		page = virt_to_head_page(buf);
+
+		truesize = mergeable_ctx_to_truesize(ctx);
+		if (unlikely(len > truesize)) {
+			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+				 dev->name, len, (unsigned long)ctx);
+			dev->stats.rx_length_errors++;
+			goto err_skb;
+		}
+
+		num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
+		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
+			struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
+
+			if (unlikely(!nskb))
+				goto err_skb;
+			if (curr_skb == head_skb)
+				skb_shinfo(curr_skb)->frag_list = nskb;
+			else
+				curr_skb->next = nskb;
+			curr_skb = nskb;
+			head_skb->truesize += nskb->truesize;
+			num_skb_frags = 0;
+		}
+		if (curr_skb != head_skb) {
+			head_skb->data_len += len;
+			head_skb->len += len;
+			head_skb->truesize += truesize;
+		}
+		offset = buf - page_address(page);
+		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
+			put_page(page);
+			skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
+					     len, truesize);
+		} else {
+			skb_add_rx_frag(curr_skb, num_skb_frags, page,
+					offset, len, truesize);
+		}
+	}
+
+	return head_skb;
+
+err_skb:
+	put_page(page);
+	merge_drop_follow_bufs(dev, rq, num_buf, stats);
+err_buf:
+	stats->drops++;
+	dev_kfree_skb(head_skb);
+	return NULL;
+}
+
 static struct sk_buff *receive_small(struct net_device *dev,
 				     struct virtnet_info *vi,
 				     struct receive_queue *rq,
@@ -909,7 +1012,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
 	struct page *page = virt_to_head_page(buf);
 	int offset = buf - page_address(page);
-	struct sk_buff *head_skb, *curr_skb;
+	struct sk_buff *head_skb;
 	struct bpf_prog *xdp_prog;
 	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
@@ -1054,65 +1157,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
 			       metasize, !!headroom);
-	curr_skb = head_skb;
-
-	if (unlikely(!curr_skb))
+	if (unlikely(!head_skb))
 		goto err_skb;
-	while (--num_buf) {
-		int num_skb_frags;
 
-		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
-		if (unlikely(!buf)) {
-			pr_debug("%s: rx error: %d buffers out of %d missing\n",
-				 dev->name, num_buf,
-				 virtio16_to_cpu(vi->vdev,
-						 hdr->num_buffers));
-			dev->stats.rx_length_errors++;
-			goto err_buf;
-		}
-
-		stats->bytes += len;
-		page = virt_to_head_page(buf);
-
-		truesize = mergeable_ctx_to_truesize(ctx);
-		if (unlikely(len > truesize)) {
-			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
-				 dev->name, len, (unsigned long)ctx);
-			dev->stats.rx_length_errors++;
-			goto err_skb;
-		}
-
-		num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
-		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
-			struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
-
-			if (unlikely(!nskb))
-				goto err_skb;
-			if (curr_skb == head_skb)
-				skb_shinfo(curr_skb)->frag_list = nskb;
-			else
-				curr_skb->next = nskb;
-			curr_skb = nskb;
-			head_skb->truesize += nskb->truesize;
-			num_skb_frags = 0;
-		}
-		if (curr_skb != head_skb) {
-			head_skb->data_len += len;
-			head_skb->len += len;
-			head_skb->truesize += truesize;
-		}
-		offset = buf - page_address(page);
-		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
-			put_page(page);
-			skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
-					     len, truesize);
-		} else {
-			skb_add_rx_frag(curr_skb, num_skb_frags, page,
-					offset, len, truesize);
-		}
-	}
+	if (num_buf > 1)
+		head_skb = merge_receive_follow_bufs(dev, vi, rq, head_skb,
+						     num_buf, stats);
+	if (head_skb)
+		ewma_pkt_len_add(&rq->mrg_avg_pkt_len, head_skb->len);
 
-	ewma_pkt_len_add(&rq->mrg_avg_pkt_len, head_skb->len);
 	return head_skb;
 
 err_xdp:
@@ -1120,19 +1173,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	stats->xdp_drops++;
 err_skb:
 	put_page(page);
-	while (num_buf-- > 1) {
-		buf = virtqueue_get_buf(rq->vq, &len);
-		if (unlikely(!buf)) {
-			pr_debug("%s: rx error: %d buffers missing\n",
-				 dev->name, num_buf);
-			dev->stats.rx_length_errors++;
-			break;
-		}
-		stats->bytes += len;
-		page = virt_to_head_page(buf);
-		put_page(page);
-	}
-err_buf:
+	merge_drop_follow_bufs(dev, rq, num_buf, stats);
 	stats->drops++;
 	dev_kfree_skb(head_skb);
 xdp_xmit:
-- 
2.31.0

