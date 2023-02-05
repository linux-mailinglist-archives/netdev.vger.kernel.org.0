Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3027C68B21B
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 23:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjBEWK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 17:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBEWKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 17:10:23 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B95E1ABEC
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 14:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5rTwwskUPZzJV/mQr5VFwBvGgaEYVVx+4axYWt0kjr8=; b=R2hscksm4lvhIluqehAYmp8v85
        KsbDcJkKHRbz/kDUrxdh7lOdvUXJ1gE6pVqf5unE5u09MTpEHVe6f5AsRu40Jnpg8duzBvYYn81Lg
        UthoCzFRWdiQSjN7K1AetDKRZNOrzHUG/32JjnSN42EXeZyuW36M1Y0qMqiZPwg6i5Zdkk5trEHAw
        FSsDHSfW2f9IhdfOVaYNQ+7Iki+T8IFcoHV1Xlqy2GsZH7/OrlimAIw5CYKswDpGT4Fb5RMDvnaMP
        SF9IxsP4ecIgW3HLIcG8rthgWXBJ0SdhEIqnEI7m7kC2uE7rWlhSq3So5Oh92qPq27BkHNhpghgZk
        m8MOvqZQ==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pOnDE-002Oky-TL; Sun, 05 Feb 2023 22:10:17 +0000
Message-Id: <4150b1589ed367e18855c16762ff160e9d73a42f.1675632296.git.geoff@infradead.org>
In-Reply-To: <cover.1675632296.git.geoff@infradead.org>
References: <cover.1675632296.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sun, 5 Feb 2023 11:10:22 -0800
Subject: [PATCH net v4 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 05 Feb 2023 22:10:16 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Gelic Ethernet device needs to have the RX sk_buffs aligned to
GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a multiple of
GELIC_NET_RXBUF_ALIGN.

The current Gelic Ethernet driver was not allocating sk_buffs large enough to
allow for this alignment.

Fixes various randomly occurring runtime network errors.

Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 56 ++++++++++++--------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index cf8de8a7a8a1..7a8b5e1e77a6 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -365,51 +365,63 @@ static int gelic_card_init_chain(struct gelic_card *card,
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
+ *
+ * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
+ * must be a multiple of GELIC_NET_RXBUF_ALIGN.
  */
 static int gelic_descr_prepare_rx(struct gelic_card *card,
 				  struct gelic_descr *descr)
 {
-	int offset;
-	unsigned int bufsize;
+	struct device *dev = ctodev(card);
+	struct {
+		unsigned int total_bytes;
+		unsigned int offset;
+	} aligned_buf;
+	dma_addr_t cpu_addr;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
 		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
-	/* we need to round up the buffer size to a multiple of 128 */
-	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
 
-	/* and we need to have it 128 byte aligned, therefore we allocate a
-	 * bit more */
-	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
+	aligned_buf.total_bytes = (GELIC_NET_RXBUF_ALIGN - 1) +
+		GELIC_NET_MAX_MTU + (GELIC_NET_RXBUF_ALIGN - 1);
+
+	descr->skb = dev_alloc_skb(aligned_buf.total_bytes);
+
 	if (!descr->skb) {
-		descr->buf_addr = 0; /* tell DMAC don't touch memory */
+		descr->buf_addr = 0;
 		return -ENOMEM;
 	}
-	descr->buf_size = cpu_to_be32(bufsize);
+
+	aligned_buf.offset =
+		PTR_ALIGN(descr->skb->data, GELIC_NET_RXBUF_ALIGN) -
+			descr->skb->data;
+
+	descr->buf_size = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
 	descr->dmac_cmd_status = 0;
 	descr->result_size = 0;
 	descr->valid_size = 0;
 	descr->data_error = 0;
 
-	offset = ((unsigned long)descr->skb->data) &
-		(GELIC_NET_RXBUF_ALIGN - 1);
-	if (offset)
-		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
-	/* io-mmu-map the skb */
-	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
-						     descr->skb->data,
-						     GELIC_NET_MAX_MTU,
-						     DMA_FROM_DEVICE));
+	skb_reserve(descr->skb, aligned_buf.offset);
+
+	cpu_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
+		DMA_FROM_DEVICE);
+
+	descr->buf_addr = cpu_to_be32(cpu_addr);
+
 	if (!descr->buf_addr) {
 		dev_kfree_skb_any(descr->skb);
+		descr->buf_addr = 0;
+		descr->buf_size = 0;
 		descr->skb = NULL;
-		dev_info(ctodev(card),
+		dev_info(dev,
 			 "%s:Could not iommu-map rx buffer\n", __func__);
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
 		return -ENOMEM;
-	} else {
-		gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
-		return 0;
 	}
+
+	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
+	return 0;
 }
 
 /**
-- 
2.34.1


