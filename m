Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E16356373
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 07:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244337AbhDGFuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 01:50:02 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:57647 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229558AbhDGFuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 01:50:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UUlTeLB_1617774589;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UUlTeLB_1617774589)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Apr 2021 13:49:49 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH net-next] virtio-net: page_to_skb() use build_skb when there's sufficient tailroom
Date:   Wed,  7 Apr 2021 13:49:49 +0800
Message-Id: <20210407054949.98211-1-xuanzhuo@linux.alibaba.com>
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
 drivers/net/virtio_net.c | 51 ++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb4ea9dbc16b..5071a8a8f57a 100644
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
@@ -401,24 +395,33 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
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
 	copy = len;
 	if (copy > skb_tailroom(skb))
 		copy = skb_tailroom(skb);
 	skb_put_data(skb, p, copy);
 
-	if (metasize) {
-		__skb_pull(skb, metasize);
-		skb_metadata_set(skb, metasize);
-	}
-
 	len -= copy;
 	offset += copy;
 
@@ -427,7 +430,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
 		else
 			put_page(page);
-		return skb;
+		goto ok;
 	}
 
 	/*
@@ -454,6 +457,18 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
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

