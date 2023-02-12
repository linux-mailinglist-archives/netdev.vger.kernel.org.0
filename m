Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEE469393B
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 19:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjBLSBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 13:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBLSBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 13:01:09 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C19BDFB
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 10:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zXhiRRBdp63GOOnfMqBslO3D11eIBBqi9wVMTza+4zA=; b=nb0b3bICzGRkJkF4DPgp3tJbNX
        usRuxRaf7Hpfn+jfwZNoNKkFdbmk/dcLM5BNgNoQqgtFPlV8Mr/WsQfsMto+oVUquSSVRJZgjbOrf
        oug0A5eWaXMmvmSjmnGPGFSwe3o2nB9IOmkNHI8LVhGK3On8sX8ZbR+IGIgcTu14Ryirifkd2wh2U
        efVus5oZR6Cw6P7lHPhc/jHks/boLe4O29YDxA+13z8d2DtJnNvWCN+LcR2v1+r1Dfz8M/CjKAF8t
        ofCKFl1v+HIGXhwCyU8QAWAgs9xj32zRpNDcVLL9pTxieRYMXkNdcPYjmAsytrKwMS3+EzYqCqikS
        q/65rPRQ==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRGeo-003ZnV-HW; Sun, 12 Feb 2023 18:00:58 +0000
Message-Id: <de8eacb3bb238f40ce69882e425bd83c6180d671.1676221818.git.geoff@infradead.org>
In-Reply-To: <cover.1676221818.git.geoff@infradead.org>
References: <cover.1676221818.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sun, 12 Feb 2023 07:45:34 -0800
Subject: [PATCH net v5 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 12 Feb 2023 18:00:58 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Gelic Ethernet device needs to have the RX sk_buffs aligned to
GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a
multiple of GELIC_NET_RXBUF_ALIGN.

The current Gelic Ethernet driver was not allocating sk_buffs large
enough to allow for this alignment.

Fixes various randomly occurring runtime network errors.

Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 55 ++++++++++++--------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index cf8de8a7a8a1..2bb68e60d0d5 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -365,51 +365,62 @@ static int gelic_card_init_chain(struct gelic_card *card,
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
+		const unsigned int buffer_bytes;
+		const unsigned int total_bytes;
+		unsigned int offset;
+	} aligned_buf = {
+		.buffer_bytes = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN),
+		.total_bytes = (GELIC_NET_RXBUF_ALIGN - 1) +
+			ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN),
+	};
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
 		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
-	/* we need to round up the buffer size to a multiple of 128 */
-	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
 
-	/* and we need to have it 128 byte aligned, therefore we allocate a
-	 * bit more */
-	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
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
+	descr->buf_size = aligned_buf.buffer_bytes;
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
+	descr->buf_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
+		DMA_FROM_DEVICE);
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


