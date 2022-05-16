Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090F252899E
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbiEPQIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245658AbiEPQIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:08:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D9C37BE3;
        Mon, 16 May 2022 09:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0433DB8125F;
        Mon, 16 May 2022 16:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FF0C34115;
        Mon, 16 May 2022 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717275;
        bh=La4DfYogy1OZ7h+SajH4VcUJwX9hHdoQB3uCgc5dP00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3ZL7vmOBzmBvQok17XKRQckajdm7HayZ0KgyJslXuOC+vSVu0jBoRzaHaMooI6yv
         rEILzktFKPcwCnBINIFSy843I+aovwMcGAmlCjMIB3hdHiRccgznayaPo1albC2GOr
         R5G1sa6WfUlHEIuCvY3XFXqIpwHB4jDM9oVB0uWN8iqJA8rxV4cvgMR9AnkKaWUW86
         TSDKTru+AkcvAIy5ZkuNbrVoAzzDB+YaVjJn+WASqQR9VaUEgXOZfm+urA4Xtr8goV
         zeSApdVACOqJr35j3xsnICxVlK8KY9ypT5Qh5lyJSnuRWa6/QMXspzkMnCMD5p/Web
         AbyFgSY1rn+Zw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 05/15] net: ethernet: mtk_eth_soc: rely on txd_size in mtk_tx_alloc/mtk_tx_clean
Date:   Mon, 16 May 2022 18:06:32 +0200
Message-Id: <c5228daa3d277cd71a134a1062525bc19b34fa2f.1652716741.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 39 ++++++++++++---------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index cde66463bf98..a48e93792db1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1568,25 +1568,30 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
 
 static int mtk_tx_alloc(struct mtk_eth *eth)
 {
+	const struct mtk_soc_data *soc = eth->soc;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
-	int i, sz = sizeof(*ring->dma);
+	struct mtk_tx_dma *txd;
+	int i;
 
 	ring->buf = kcalloc(MTK_DMA_SIZE, sizeof(*ring->buf),
 			       GFP_KERNEL);
 	if (!ring->buf)
 		goto no_tx_mem;
 
-	ring->dma = dma_alloc_coherent(eth->dma_dev, MTK_DMA_SIZE * sz,
+	ring->dma = dma_alloc_coherent(eth->dma_dev,
+				       MTK_DMA_SIZE * soc->txrx.txd_size,
 				       &ring->phys, GFP_ATOMIC);
 	if (!ring->dma)
 		goto no_tx_mem;
 
 	for (i = 0; i < MTK_DMA_SIZE; i++) {
 		int next = (i + 1) % MTK_DMA_SIZE;
-		u32 next_ptr = ring->phys + next * sz;
+		u32 next_ptr = ring->phys + next * soc->txrx.txd_size;
 
-		ring->dma[i].txd2 = next_ptr;
-		ring->dma[i].txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
+		txd = (void *)ring->dma + i * soc->txrx.txd_size;
+		txd->txd2 = next_ptr;
+		txd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
+		txd->txd4 = 0;
 	}
 
 	/* On MT7688 (PDMA only) this driver uses the ring->dma structs
@@ -1594,9 +1599,9 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	 * descriptors in ring->dma_pdma.
 	 */
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
-		ring->dma_pdma = dma_alloc_coherent(eth->dma_dev, MTK_DMA_SIZE * sz,
-						    &ring->phys_pdma,
-						    GFP_ATOMIC);
+		ring->dma_pdma = dma_alloc_coherent(eth->dma_dev,
+				MTK_DMA_SIZE * soc->txrx.txd_size,
+				&ring->phys_pdma, GFP_ATOMIC);
 		if (!ring->dma_pdma)
 			goto no_tx_mem;
 
@@ -1609,8 +1614,9 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	ring->dma_size = MTK_DMA_SIZE;
 	atomic_set(&ring->free_count, MTK_DMA_SIZE - 2);
 	ring->next_free = &ring->dma[0];
-	ring->last_free = &ring->dma[MTK_DMA_SIZE - 1];
-	ring->last_free_ptr = (u32)(ring->phys + ((MTK_DMA_SIZE - 1) * sz));
+	ring->last_free = (void *)txd;
+	ring->last_free_ptr = (u32)(ring->phys +
+				    (MTK_DMA_SIZE - 1) * soc->txrx.txd_size);
 	ring->thresh = MAX_SKB_FRAGS;
 
 	/* make sure that all changes to the dma ring are flushed before we
@@ -1622,7 +1628,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		mtk_w32(eth, ring->phys, MTK_QTX_CTX_PTR);
 		mtk_w32(eth, ring->phys, MTK_QTX_DTX_PTR);
 		mtk_w32(eth,
-			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
+			ring->phys + (MTK_DMA_SIZE - 1) * soc->txrx.txd_size,
 			MTK_QTX_CRX_PTR);
 		mtk_w32(eth, ring->last_free_ptr, MTK_QTX_DRX_PTR);
 		mtk_w32(eth, (QDMA_RES_THRES << 8) | QDMA_RES_THRES,
@@ -1642,6 +1648,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 
 static void mtk_tx_clean(struct mtk_eth *eth)
 {
+	const struct mtk_soc_data *soc = eth->soc;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	int i;
 
@@ -1654,17 +1661,15 @@ static void mtk_tx_clean(struct mtk_eth *eth)
 
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

