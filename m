Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B905435EA87
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 03:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349040AbhDNBwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 21:52:55 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:49491 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231976AbhDNBwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 21:52:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UVVCO8y_1618365141;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVVCO8y_1618365141)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 14 Apr 2021 09:52:21 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next v2] virtio-net: page_to_skb() use build_skb when there's sufficient tailroom
Date:   Wed, 14 Apr 2021 09:52:21 +0800
Message-Id: <20210414015221.87554-1-xuanzhuo@linux.alibaba.com>
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

v2: conflict resolution

 drivers/net/virtio_net.c | 51 ++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 101659cd4b87..d7142b508bd0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -383,17 +383,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
-	unsigned int copy, hdr_len, hdr_padded_len;
-	char *p;
+	unsigned int copy, hdr_len, hdr_padded_len, tailroom, shinfo_size;
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
@@ -401,14 +395,28 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);

-	/* hdr_valid means no XDP, so we can copy the vnet header */
-	if (hdr_valid)
-		memcpy(hdr, p, hdr_len);
+	tailroom = truesize - len;

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
@@ -418,11 +426,6 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		copy = ETH_HLEN + metasize;
 	skb_put_data(skb, p, copy);

-	if (metasize) {
-		__skb_pull(skb, metasize);
-		skb_metadata_set(skb, metasize);
-	}
-
 	len -= copy;
 	offset += copy;

@@ -431,7 +434,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
 		else
 			put_page(page);
-		return skb;
+		goto ok;
 	}

 	/*
@@ -458,6 +461,18 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
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

--
2.31.0

