Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF9168B21A
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 23:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjBEWKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 17:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjBEWKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 17:10:23 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F33D1ADC5
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 14:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=neI+YkCTPXrkVPL5x8/t9ynrGai34LT/MwmL/gO/Xq8=; b=yd0dN+QL7tdqSw31IzCvFakhs1
        X5djXrEbkKw8cby7I4l7qEH3xyXCOOAQ/mBIrmqggfVdFucAcSYmoQrCYUSs4WSwhft1Xkccs1Czq
        jzvKHaTkfs8wIVgV9a09+8ojl/PyX9BO/ceXLD/u5Cc6YsNnl+wsibQIaD6pL9MjQD3+8JTRij+Y/
        bmnHdZDzhBh4zMPh0uBPXF7vFxh8x0clwSgRXuMmPjFIKDlLdbTO/lY4d91kt9mPAEoZrUfU+IDfE
        8ZeLoieb65Yxja1YQGs8jY6yM5LWK0Nv3xHSra6AHJC7kL1CQ+OvfHTU8Hj5odfPOk8WEAlw1Uid+
        zscFrMFw==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pOnDF-002Ol0-55; Sun, 05 Feb 2023 22:10:17 +0000
Message-Id: <8d40259f863ed1a077687f3c3d5b8b3707478170.1675632296.git.geoff@infradead.org>
In-Reply-To: <cover.1675632296.git.geoff@infradead.org>
References: <cover.1675632296.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sun, 5 Feb 2023 11:10:22 -0800
Subject: [PATCH net v4 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 05 Feb 2023 22:10:17 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current Gelic Etherenet driver was checking the return value of its
dma_map_single call, and not using the dma_mapping_error() routine.

Fixes runtime problems like these:

  DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
  WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc

Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 52 ++++++++++----------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 7a8b5e1e77a6..5622b512e2e4 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -309,22 +309,34 @@ static int gelic_card_init_chain(struct gelic_card *card,
 				 struct gelic_descr_chain *chain,
 				 struct gelic_descr *start_descr, int no)
 {
-	int i;
+	struct device *dev = ctodev(card);
 	struct gelic_descr *descr;
+	int i;
 
-	descr = start_descr;
-	memset(descr, 0, sizeof(*descr) * no);
+	memset(start_descr, 0, no * sizeof(*start_descr));
 
 	/* set up the hardware pointers in each descriptor */
-	for (i = 0; i < no; i++, descr++) {
+	for (i = 0, descr = start_descr; i < no; i++, descr++) {
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
 		descr->bus_addr =
 			dma_map_single(ctodev(card), descr,
 				       GELIC_DESCR_SIZE,
 				       DMA_BIDIRECTIONAL);
 
-		if (!descr->bus_addr)
-			goto iommu_error;
+		if (unlikely(dma_mapping_error(dev, descr->bus_addr))) {
+			dev_err(dev, "%s:%d: dma_mapping_error\n", __func__,
+				__LINE__);
+
+			for (i--, descr--; i > 0; i--, descr--) {
+				if (descr->bus_addr) {
+					dma_unmap_single(ctodev(card),
+						descr->bus_addr,
+						GELIC_DESCR_SIZE,
+						DMA_BIDIRECTIONAL);
+				}
+			}
+			return -ENOMEM;
+		}
 
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
@@ -334,8 +346,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
 	start_descr->prev = (descr - 1);
 
 	/* chain bus addr of hw descriptor */
-	descr = start_descr;
-	for (i = 0; i < no; i++, descr++) {
+	for (i = 0, descr = start_descr; i < no; i++, descr++) {
 		descr->next_descr_addr = cpu_to_be32(descr->next->bus_addr);
 	}
 
@@ -346,14 +357,6 @@ static int gelic_card_init_chain(struct gelic_card *card,
 	(descr - 1)->next_descr_addr = 0;
 
 	return 0;
-
-iommu_error:
-	for (i--, descr--; 0 <= i; i--, descr--)
-		if (descr->bus_addr)
-			dma_unmap_single(ctodev(card), descr->bus_addr,
-					 GELIC_DESCR_SIZE,
-					 DMA_BIDIRECTIONAL);
-	return -ENOMEM;
 }
 
 /**
@@ -407,19 +410,18 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	cpu_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
 		DMA_FROM_DEVICE);
 
-	descr->buf_addr = cpu_to_be32(cpu_addr);
-
-	if (!descr->buf_addr) {
+	if (unlikely(dma_mapping_error(dev, cpu_addr))) {
+		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
 		dev_kfree_skb_any(descr->skb);
 		descr->buf_addr = 0;
 		descr->buf_size = 0;
 		descr->skb = NULL;
-		dev_info(dev,
-			 "%s:Could not iommu-map rx buffer\n", __func__);
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
 		return -ENOMEM;
 	}
 
+	descr->buf_addr = cpu_to_be32(cpu_addr);
+
 	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
 	return 0;
 }
@@ -775,6 +777,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 				  struct gelic_descr *descr,
 				  struct sk_buff *skb)
 {
+	struct device *dev = ctodev(card);
 	dma_addr_t buf;
 
 	if (card->vlan_required) {
@@ -789,11 +792,10 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 		skb = skb_tmp;
 	}
 
-	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
+	buf = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
-		dev_err(ctodev(card),
-			"dma map 2 failed (%p, %i). Dropping packet\n",
+	if (unlikely(dma_mapping_error(dev, buf))) {
+		dev_err(dev, "dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
 		return -ENOMEM;
 	}
-- 
2.34.1

