Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6FB361D0D
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbhDPJQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 05:16:42 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:53427 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234914AbhDPJQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 05:16:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UVjhql9_1618564575;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVjhql9_1618564575)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 16 Apr 2021 17:16:15 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when there's sufficient tailroom
Date:   Fri, 16 Apr 2021 17:16:15 +0800
Message-Id: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In page_to_skb(), if we have enough tailroom to save skb_shared_info, we
can use build_skb to create skb directly. No need to alloc for
additional space. And it can save a 'frags slot', which is very friendly
to GRO.

Here, if the payload of the received package is too small (less than
GOOD_COPY_LEN), we still choose to copy it directly to the space got by
napi_alloc_skb. So we can reuse these pages.

Testing Machine:
    The four queues of the network card are bound to the cpu1.

Test command:
    for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done

The size of the udp package is 1000, so in the case of this patch, there
will always be enough tailroom to use build_skb. The sent udp packet
will be discarded because there is no port to receive it. The irqsoftd
of the machine is 100%, we observe the received quantity displayed by
sar -n DEV 1:

no build_skb:  956864.00 rxpck/s
build_skb:    1158465.00 rxpck/s

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---

v3: fix the truesize when headroom > 0

v2: conflict resolution

 drivers/net/virtio_net.c | 69 ++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 101659cd4b87..8cd76037c724 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -379,21 +379,17 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
 				   struct page *page, unsigned int offset,
 				   unsigned int len, unsigned int truesize,
-				   bool hdr_valid, unsigned int metasize)
+				   bool hdr_valid, unsigned int metasize,
+				   unsigned int headroom)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	unsigned int copy, hdr_len, hdr_padded_len;
-	char *p;
+	int tailroom, shinfo_size;
+	char *p, *hdr_p;

 	p = page_address(page) + offset;
-
-	/* copy small packet so we can reuse these pages for small data */
-	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
-	if (unlikely(!skb))
-		return NULL;
-
-	hdr = skb_vnet_hdr(skb);
+	hdr_p = p;

 	hdr_len = vi->hdr_len;
 	if (vi->mergeable_rx_bufs)
@@ -401,14 +397,38 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);

-	/* hdr_valid means no XDP, so we can copy the vnet header */
-	if (hdr_valid)
-		memcpy(hdr, p, hdr_len);
+	/* If headroom is not 0, there is an offset between the beginning of the
+	 * data and the allocated space, otherwise the data and the allocated
+	 * space are aligned.
+	 */
+	if (headroom) {
+		/* The actual allocated space size is PAGE_SIZE. */
+		truesize = PAGE_SIZE;
+		tailroom = truesize - len - offset;
+	} else {
+		tailroom = truesize - len;
+	}

 	len -= hdr_len;
 	offset += hdr_padded_len;
 	p += hdr_padded_len;

+	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
+	if (len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
+		skb = build_skb(p, truesize);
+		if (unlikely(!skb))
+			return NULL;
+
+		skb_put(skb, len);
+		goto ok;
+	}
+
+	/* copy small packet so we can reuse these pages for small data */
+	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
+	if (unlikely(!skb))
+		return NULL;
+
 	/* Copy all frame if it fits skb->head, otherwise
 	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
 	 */
@@ -418,11 +438,6 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		copy = ETH_HLEN + metasize;
 	skb_put_data(skb, p, copy);

-	if (metasize) {
-		__skb_pull(skb, metasize);
-		skb_metadata_set(skb, metasize);
-	}
-
 	len -= copy;
 	offset += copy;

@@ -431,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
 		else
 			put_page(page);
-		return skb;
+		goto ok;
 	}

 	/*
@@ -458,6 +473,18 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	if (page)
 		give_pages(rq, page);

+ok:
+	/* hdr_valid means no XDP, so we can copy the vnet header */
+	if (hdr_valid) {
+		hdr = skb_vnet_hdr(skb);
+		memcpy(hdr, hdr_p, hdr_len);
+	}
+
+	if (metasize) {
+		__skb_pull(skb, metasize);
+		skb_metadata_set(skb, metasize);
+	}
+
 	return skb;
 }

@@ -808,7 +835,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
 {
 	struct page *page = buf;
 	struct sk_buff *skb =
-		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);

 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -922,7 +949,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				put_page(page);
 				head_skb = page_to_skb(vi, rq, xdp_page, offset,
 						       len, PAGE_SIZE, false,
-						       metasize);
+						       metasize, headroom);
 				return head_skb;
 			}
 			break;
@@ -980,7 +1007,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	}

 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
-			       metasize);
+			       metasize, headroom);
 	curr_skb = head_skb;

 	if (unlikely(!curr_skb))
--
2.31.0

