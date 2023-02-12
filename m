Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CE669393A
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBLSBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 13:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBLSBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 13:01:09 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA22BDE8
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 10:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7A/1Lc+IQLOLVgeDfpaPrqk/s/T1sK5pUbWznm6XwdE=; b=gK0Vk3b0Tt/rIg4ZXltd4c3x7l
        FZU9IoPJNWfWnR6k0heI/uB9PXxFVS+hWKRBiEBrV9dQaOzuX2/d+UamOddsMEa58GvEXwGOeAQWI
        Aex47yOUMmEUclvVfCC/gGY2X7/vtfxFbk5CWGBQaByJ+JmKV0EhO839mDstsMnXUUYL2ZG4rEfHT
        UCwEz/Ngp8VnhuUAjO+84udEN0+jvP3DNVTwDyeRQS1Nwby4ydZwU1/9SezVn3OdudK0beA21tMg0
        ucp5sf1kstlNnmM3QNBCjwuLdhRpyauFBfSozRb09YR29R3MzXa7hVMUqndYT6iG+o8cJK8O3OlWA
        MWOFC/fQ==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRGeo-003ZnX-MY; Sun, 12 Feb 2023 18:00:58 +0000
Message-Id: <ea17b44b48e4dad6c97e3f1e61266fcf9f0ad2d5.1676221818.git.geoff@infradead.org>
In-Reply-To: <cover.1676221818.git.geoff@infradead.org>
References: <cover.1676221818.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sun, 12 Feb 2023 07:45:34 -0800
Subject: [PATCH net v5 2/2] net/ps3_gelic_net: Use dma_mapping_error
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

The current Gelic Etherenet driver was checking the return value of its
dma_map_single call, and not using the dma_mapping_error() routine.

Fixes runtime problems like these:

  DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
  WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc

Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 41 ++++++++++----------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 2bb68e60d0d5..0e52bb99e344 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -309,22 +309,30 @@ static int gelic_card_init_chain(struct gelic_card *card,
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
+			for (i--, descr--; i >= 0; i--, descr--) {
+				dma_unmap_single(ctodev(card), descr->bus_addr,
+					GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
+			}
+			return -ENOMEM;
+		}
 
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
@@ -346,14 +354,6 @@ static int gelic_card_init_chain(struct gelic_card *card,
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
@@ -408,13 +408,12 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	descr->buf_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
 		DMA_FROM_DEVICE);
 
-	if (!descr->buf_addr) {
+	if (unlikely(dma_mapping_error(dev, descr->buf_addr))) {
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
@@ -774,6 +773,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 				  struct gelic_descr *descr,
 				  struct sk_buff *skb)
 {
+	struct device *dev = ctodev(card);
 	dma_addr_t buf;
 
 	if (card->vlan_required) {
@@ -788,11 +788,10 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
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

