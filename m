Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E038551D7CF
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391973AbiEFMfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391979AbiEFMfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:35:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B122D6622A;
        Fri,  6 May 2022 05:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A33961F82;
        Fri,  6 May 2022 12:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A43C385AF;
        Fri,  6 May 2022 12:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840281;
        bh=s8UIxCzeJV2RXIAMgUMaiMydyVB39RBqvOPbNM21Rdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jROICUJJCeH0JCEiXV8uOMwTdZIwA014JB5i3KYJSRj0XzKhIj9I6y5CgfVBdec4A
         AqMJeRJh1yrJSI942P6bpyCr6C/cOxzWchF9ks5oAG/qrKmdLGAuwttuwqImEOyL8O
         GyCXC9j+5jHoraGmXwACE7C3aMLgAuAx1rIX9ikzvIfPktQZU0Y8M10+ksDs1PK420
         +hpL+TS5uVYH5+pA4a6dd/HyDwpaz4wA9fKTY2Wcj/sdQ8h2p2EA6UJ2XuVeY50WGP
         h3Lguu6uhaoUCRxuO9M50bA9AqhGc+cHKZ7zVKhPnjLoR6l+DBYZWUTOmfAtcZ6wZW
         2OCXLXg9g3enQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 04/14] net: ethernet: mtk_eth_soc: add txd_size to mtk_soc_data
Date:   Fri,  6 May 2022 14:30:21 +0200
Message-Id: <616c5a6091638bb06f19865e75c26f053c97d967.1651839494.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651839494.git.lorenzo@kernel.org>
References: <cover.1651839494.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to remove mtk_tx_dma size dependency, introduce txd_size in
mtk_soc_data data structure. Rely on txd_size in mtk_init_fq_dma() and
mtk_dma_free() routines.
This is a preliminary patch to add mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 47 +++++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  4 ++
 2 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 085c740779de..cde66463bf98 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -784,20 +784,20 @@ static inline bool mtk_rx_get_desc(struct mtk_rx_dma *rxd,
 /* the qdma core needs scratch memory to be setup */
 static int mtk_init_fq_dma(struct mtk_eth *eth)
 {
+	const struct mtk_soc_data *soc = eth->soc;
 	dma_addr_t phy_ring_tail;
 	int cnt = MTK_DMA_SIZE;
 	dma_addr_t dma_addr;
 	int i;
 
 	eth->scratch_ring = dma_alloc_coherent(eth->dma_dev,
-					       cnt * sizeof(struct mtk_tx_dma),
+					       cnt * soc->txrx.txd_size,
 					       &eth->phy_scratch_ring,
 					       GFP_ATOMIC);
 	if (unlikely(!eth->scratch_ring))
 		return -ENOMEM;
 
-	eth->scratch_head = kcalloc(cnt, MTK_QDMA_PAGE_SIZE,
-				    GFP_KERNEL);
+	eth->scratch_head = kcalloc(cnt, MTK_QDMA_PAGE_SIZE, GFP_KERNEL);
 	if (unlikely(!eth->scratch_head))
 		return -ENOMEM;
 
@@ -807,16 +807,19 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 	if (unlikely(dma_mapping_error(eth->dma_dev, dma_addr)))
 		return -ENOMEM;
 
-	phy_ring_tail = eth->phy_scratch_ring +
-			(sizeof(struct mtk_tx_dma) * (cnt - 1));
+	phy_ring_tail = eth->phy_scratch_ring + soc->txrx.txd_size * (cnt - 1);
 
 	for (i = 0; i < cnt; i++) {
-		eth->scratch_ring[i].txd1 =
-					(dma_addr + (i * MTK_QDMA_PAGE_SIZE));
+		struct mtk_tx_dma *txd;
+
+		txd = (void *)eth->scratch_ring + i * soc->txrx.txd_size;
+		txd->txd1 = dma_addr + i * MTK_QDMA_PAGE_SIZE;
 		if (i < cnt - 1)
-			eth->scratch_ring[i].txd2 = (eth->phy_scratch_ring +
-				((i + 1) * sizeof(struct mtk_tx_dma)));
-		eth->scratch_ring[i].txd3 = TX_DMA_SDL(MTK_QDMA_PAGE_SIZE);
+			txd->txd2 = eth->phy_scratch_ring +
+				    (i + 1) * soc->txrx.txd_size;
+
+		txd->txd3 = TX_DMA_PLEN0(MTK_QDMA_PAGE_SIZE);
+		txd->txd4 = 0;
 	}
 
 	mtk_w32(eth, eth->phy_scratch_ring, MTK_QDMA_FQ_HEAD);
@@ -2108,6 +2111,7 @@ static int mtk_dma_init(struct mtk_eth *eth)
 
 static void mtk_dma_free(struct mtk_eth *eth)
 {
+	const struct mtk_soc_data *soc = eth->soc;
 	int i;
 
 	for (i = 0; i < MTK_MAC_COUNT; i++)
@@ -2115,9 +2119,8 @@ static void mtk_dma_free(struct mtk_eth *eth)
 			netdev_reset_queue(eth->netdev[i]);
 	if (eth->scratch_ring) {
 		dma_free_coherent(eth->dma_dev,
-				  MTK_DMA_SIZE * sizeof(struct mtk_tx_dma),
-				  eth->scratch_ring,
-				  eth->phy_scratch_ring);
+				  MTK_DMA_SIZE * soc->txrx.txd_size,
+				  eth->scratch_ring, eth->phy_scratch_ring);
 		eth->scratch_ring = NULL;
 		eth->phy_scratch_ring = 0;
 	}
@@ -3353,6 +3356,9 @@ static const struct mtk_soc_data mt2701_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
+	.txrx = {
+		.txd_size = sizeof(struct mtk_tx_dma),
+	},
 };
 
 static const struct mtk_soc_data mt7621_data = {
@@ -3361,6 +3367,9 @@ static const struct mtk_soc_data mt7621_data = {
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
+	.txrx = {
+		.txd_size = sizeof(struct mtk_tx_dma),
+	},
 };
 
 static const struct mtk_soc_data mt7622_data = {
@@ -3370,6 +3379,9 @@ static const struct mtk_soc_data mt7622_data = {
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
+	.txrx = {
+		.txd_size = sizeof(struct mtk_tx_dma),
+	},
 };
 
 static const struct mtk_soc_data mt7623_data = {
@@ -3378,6 +3390,9 @@ static const struct mtk_soc_data mt7623_data = {
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 	.offload_version = 2,
+	.txrx = {
+		.txd_size = sizeof(struct mtk_tx_dma),
+	},
 };
 
 static const struct mtk_soc_data mt7629_data = {
@@ -3386,6 +3401,9 @@ static const struct mtk_soc_data mt7629_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
+	.txrx = {
+		.txd_size = sizeof(struct mtk_tx_dma),
+	},
 };
 
 static const struct mtk_soc_data rt5350_data = {
@@ -3393,6 +3411,9 @@ static const struct mtk_soc_data rt5350_data = {
 	.hw_features = MTK_HW_FEATURES_MT7628,
 	.required_clks = MT7628_CLKS_BITMAP,
 	.required_pctl = false,
+	.txrx = {
+		.txd_size = sizeof(struct mtk_tx_dma),
+	},
 };
 
 const struct of_device_id of_mtk_match[] = {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 5d940315c7ba..495f623b62ef 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -865,6 +865,7 @@ struct mtk_tx_dma_desc_info {
  *				the target SoC
  * @required_pctl		A bool value to show whether the SoC requires
  *				the extra setup for those pins used by GMAC.
+ * @txd_size			TX DMA descriptor size.
  */
 struct mtk_soc_data {
 	u32             ana_rgc3;
@@ -873,6 +874,9 @@ struct mtk_soc_data {
 	bool		required_pctl;
 	u8		offload_version;
 	netdev_features_t hw_features;
+	struct {
+		u32	txd_size;
+	} txrx;
 };
 
 /* currently no SoC has more than 2 macs */
-- 
2.35.1

