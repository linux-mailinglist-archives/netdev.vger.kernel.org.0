Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8561152F22F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352439AbiETSMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352445AbiETSMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:12:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC77518C07D;
        Fri, 20 May 2022 11:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F376617A3;
        Fri, 20 May 2022 18:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B98C34116;
        Fri, 20 May 2022 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070357;
        bh=TS0a0jAfKnRA6PI/nGBv67O8H4VESfPde3pAGx7v5zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHHDlfau4T2x+jgnBX4Gd8w6TWLWSi/AtYcF4ERKSG0ge92eIyGbTbk5UozajXfCR
         IRNIY7Wd8jqSmtCbXGTUsf6K+YOMfv4YLHkrrUmUTmYXL0cIbW6ygtv+Su5c2HpFAB
         q0vfl20aUf181iAJdhoJwfL5Tl9efvGMi50MWckohE1Rtaj83djOFv0mDIkSwTBhc2
         M5eTBanK7qVA81+KNR+8kqaMu3PlIo7OAdfanOJ/8lP/ElgGQfnlReYl6I1adCIEmE
         qeQ5oXJTT2zDsBojdVPqUrAvndTRwKERFn0smql5jjKt5hvcPebWaYKLoEEbYr/Xx9
         pBLUfoO0k3C+Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 06/16] net: ethernet: mtk_eth_soc: rely on txd_size in mtk_tx_alloc/mtk_tx_clean
Date:   Fri, 20 May 2022 20:11:29 +0200
Message-Id: <bb7bb641bd844c1892421eee68893b3a22e8f674.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to add mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 23 ++++++++++++---------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e00c83982aa9..331814f4801f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1592,8 +1592,10 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
 
 static int mtk_tx_alloc(struct mtk_eth *eth)
 {
+	const struct mtk_soc_data *soc = eth->soc;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
-	int i, sz = sizeof(*ring->dma);
+	int i, sz = soc->txrx.txd_size;
+	struct mtk_tx_dma *txd;
 
 	ring->buf = kcalloc(MTK_DMA_SIZE, sizeof(*ring->buf),
 			       GFP_KERNEL);
@@ -1609,8 +1611,10 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		int next = (i + 1) % MTK_DMA_SIZE;
 		u32 next_ptr = ring->phys + next * sz;
 
-		ring->dma[i].txd2 = next_ptr;
-		ring->dma[i].txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
+		txd = (void *)ring->dma + i * sz;
+		txd->txd2 = next_ptr;
+		txd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
+		txd->txd4 = 0;
 	}
 
 	/* On MT7688 (PDMA only) this driver uses the ring->dma structs
@@ -1632,7 +1636,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	ring->dma_size = MTK_DMA_SIZE;
 	atomic_set(&ring->free_count, MTK_DMA_SIZE - 2);
 	ring->next_free = &ring->dma[0];
-	ring->last_free = &ring->dma[MTK_DMA_SIZE - 1];
+	ring->last_free = (void *)txd;
 	ring->last_free_ptr = (u32)(ring->phys + ((MTK_DMA_SIZE - 1) * sz));
 	ring->thresh = MAX_SKB_FRAGS;
 
@@ -1665,6 +1669,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 
 static void mtk_tx_clean(struct mtk_eth *eth)
 {
+	const struct mtk_soc_data *soc = eth->soc;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	int i;
 
@@ -1677,17 +1682,15 @@ static void mtk_tx_clean(struct mtk_eth *eth)
 
 	if (ring->dma) {
 		dma_free_coherent(eth->dma_dev,
-				  MTK_DMA_SIZE * sizeof(*ring->dma),
-				  ring->dma,
-				  ring->phys);
+				  MTK_DMA_SIZE * soc->txrx.txd_size,
+				  ring->dma, ring->phys);
 		ring->dma = NULL;
 	}
 
 	if (ring->dma_pdma) {
 		dma_free_coherent(eth->dma_dev,
-				  MTK_DMA_SIZE * sizeof(*ring->dma_pdma),
-				  ring->dma_pdma,
-				  ring->phys_pdma);
+				  MTK_DMA_SIZE * soc->txrx.txd_size,
+				  ring->dma_pdma, ring->phys_pdma);
 		ring->dma_pdma = NULL;
 	}
 }
-- 
2.35.3

