Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734096A2D27
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 03:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBZCZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 21:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZCZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 21:25:52 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C872E30FE
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 18:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XfBt1At4T6UhkQNFRZQ17c84YHtTZj/zq1PGXWdHHT8=; b=jocL/Z+JT7cqDuOXoayqW0sQce
        3seTWHtoTJ8FyNY6VjpH/c52yZ6GIc/NuRgBMIwCQxYe/84M+i7/NN1h5b1eHzklllIsqFrjtRzR0
        jbFiO3nPemE4iJs8W9GwTSOjbX5Qx1CXcBAH3l7F4STJbqkofn1GbGiP3gwqEdeBD40X7jzyebXvi
        CM3OTGfI722BMXvsQhQ7rc9oJllLhevVqJgSGBSsb3NmidtX6ZqAGR4j8sVjSykzU18BRaGK+v+Dj
        EGNMi0Ih6jHmf0E1yy6napM15EQFg1aNuhma3xK5EFp9RN9vvmCYNyPLDMPzkCMkn8DDK8rp91BcB
        iG4pjb7g==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pW6jP-005Uio-4H; Sun, 26 Feb 2023 02:25:43 +0000
Message-Id: <3edb8c30e72c429aaa50d3ba43b46e7579b0da63.1677377639.git.geoff@infradead.org>
In-Reply-To: <cover.1677377639.git.geoff@infradead.org>
References: <cover.1677377639.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 25 Feb 2023 17:37:20 -0800
Subject: [PATCH net v6 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sun, 26 Feb 2023 02:25:43 +0000
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

Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 37 ++++++++++----------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 7e12e041acd3..2f7505609447 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -309,23 +309,31 @@ static int gelic_card_init_chain(struct gelic_card *card,
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
+		if (dma_mapping_error(dev, descr->bus_addr)) {
+			dev_err_once(dev, "%s:%d: dma_mapping_error\n",
+				__func__, __LINE__);
 
+			for (i--, descr--; i >= 0; i--, descr--) {
+				dma_unmap_single(ctodev(card), descr->bus_addr,
+					GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
+			}
+			return -ENOMEM;
+		}
+ 
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 	}
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
@@ -407,7 +407,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	descr->buf_addr = cpu_to_be32(dma_map_single(dev, napi_buff,
 		GELIC_NET_MAX_MTU, DMA_FROM_DEVICE));
 
-	if (!descr->buf_addr) {
+	if (dma_mapping_error(dev, descr->buf_addr)) {
 		skb_free_frag(napi_buff);
 		descr->skb = NULL;
 		descr->buf_addr = 0;
@@ -773,6 +773,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 				  struct gelic_descr *descr,
 				  struct sk_buff *skb)
 {
+	struct device *dev = ctodev(card);
 	dma_addr_t buf;
 
 	if (card->vlan_required) {
@@ -787,10 +788,10 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 		skb = skb_tmp;
 	}
 
-	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
+	buf = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
-		dev_err(ctodev(card),
+	if (dma_mapping_error(dev, buf)) {
+		dev_err_once(dev,
 			"dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
 		return -ENOMEM;
-- 
2.34.1

