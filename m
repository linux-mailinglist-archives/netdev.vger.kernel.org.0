Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F042C65223B
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbiLTOPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiLTOPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:15:03 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7965D1013;
        Tue, 20 Dec 2022 06:15:01 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VXlhpyo_1671545698;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VXlhpyo_1671545698)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 22:14:59 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH v2 8/9] virtio_net: remove xdp related info from page_to_skb()
Date:   Tue, 20 Dec 2022 22:14:48 +0800
Message-Id: <20221220141449.115918-9-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221220141449.115918-1-hengqi@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the clear construction of xdp_buff, we remove the xdp processing
interleaved with page_to_skb(). Now, the logic of xdp and building
skb from xdp are separate and independent.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 41 +++++++++-------------------------------
 1 file changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4e12196fcfd4..398ffe2a5084 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -439,9 +439,7 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
 static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
 				   struct page *page, unsigned int offset,
-				   unsigned int len, unsigned int truesize,
-				   bool hdr_valid, unsigned int metasize,
-				   unsigned int headroom)
+				   unsigned int len, unsigned int truesize)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -459,21 +457,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
-	/* If headroom is not 0, there is an offset between the beginning of the
-	 * data and the allocated space, otherwise the data and the allocated
-	 * space are aligned.
-	 *
-	 * Buffers with headroom use PAGE_SIZE as alloc size, see
-	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
-	 */
-	truesize = headroom ? PAGE_SIZE : truesize;
-	tailroom = truesize - headroom;
-	buf = p - headroom;
-
+	buf = p;
 	len -= hdr_len;
 	offset += hdr_padded_len;
 	p += hdr_padded_len;
-	tailroom -= hdr_padded_len + len;
+	tailroom = truesize - hdr_padded_len - len;
 
 	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
@@ -503,7 +491,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	if (len <= skb_tailroom(skb))
 		copy = len;
 	else
-		copy = ETH_HLEN + metasize;
+		copy = ETH_HLEN;
 	skb_put_data(skb, p, copy);
 
 	len -= copy;
@@ -542,19 +530,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		give_pages(rq, page);
 
 ok:
-	/* hdr_valid means no XDP, so we can copy the vnet header */
-	if (hdr_valid) {
-		hdr = skb_vnet_hdr(skb);
-		memcpy(hdr, hdr_p, hdr_len);
-	}
+	hdr = skb_vnet_hdr(skb);
+	memcpy(hdr, hdr_p, hdr_len);
 	if (page_to_free)
 		put_page(page_to_free);
 
-	if (metasize) {
-		__skb_pull(skb, metasize);
-		skb_metadata_set(skb, metasize);
-	}
-
 	return skb;
 }
 
@@ -934,7 +914,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
 {
 	struct page *page = buf;
 	struct sk_buff *skb =
-		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -1222,9 +1202,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				rcu_read_unlock();
 				put_page(page);
 				head_skb = page_to_skb(vi, rq, xdp_page, offset,
-						       len, PAGE_SIZE, false,
-						       metasize,
-						       headroom);
+						       len, PAGE_SIZE);
 				return head_skb;
 			}
 			break;
@@ -1289,8 +1267,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	rcu_read_unlock();
 
 skip_xdp:
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
-			       metasize, headroom);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.19.1.6.gb485710b

