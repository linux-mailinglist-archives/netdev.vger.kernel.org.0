Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7292B62303D
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiKIQfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiKIQex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:34:53 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A9A5F74;
        Wed,  9 Nov 2022 08:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=28vp25puRu98YusczJTWwgPKLBzAy9rVTW+MshpfQqE=; b=OV/LDjaYz9C3YbZibvplvZA4ud
        lnIfk4dfelBl2h56HFraR/SHSkOsGS+775IBY+adR2z56rU3i4D0ssoVwawKe5zl2q9bO8X12BDba
        T/6nhuT8R+JLm537b8OsXgAS5UWFVCeZq8woNDmC1w8igxA4kuTrrBJCUrqfMp+w2fG0=;
Received: from p200300daa72ee100054f3c61b16ef6e7.dip0.t-ipconnect.de ([2003:da:a72e:e100:54f:3c61:b16e:f6e7] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oso23-000l4N-TD; Wed, 09 Nov 2022 17:34:31 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 02/12] net: ethernet: mtk_eth_soc: increase tx ring side for QDMA devices
Date:   Wed,  9 Nov 2022 17:34:16 +0100
Message-Id: <20221109163426.76164-3-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109163426.76164-1-nbd@nbd.name>
References: <20221109163426.76164-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to use the hardware traffic shaper feature, a larger tx ring is
needed, especially for the scratch ring, which the hardware shaper uses to
reorder packets.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 38 ++++++++++++---------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  1 +
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 789268b15106..02a57729db28 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -938,7 +938,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 {
 	const struct mtk_soc_data *soc = eth->soc;
 	dma_addr_t phy_ring_tail;
-	int cnt = MTK_DMA_SIZE;
+	int cnt = MTK_QDMA_RING_SIZE;
 	dma_addr_t dma_addr;
 	int i;
 
@@ -2202,19 +2202,25 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	int i, sz = soc->txrx.txd_size;
 	struct mtk_tx_dma_v2 *txd;
+	int ring_size;
 
-	ring->buf = kcalloc(MTK_DMA_SIZE, sizeof(*ring->buf),
+	if (MTK_HAS_CAPS(soc->caps, MTK_QDMA))
+		ring_size = MTK_QDMA_RING_SIZE;
+	else
+		ring_size = MTK_DMA_SIZE;
+
+	ring->buf = kcalloc(ring_size, sizeof(*ring->buf),
 			       GFP_KERNEL);
 	if (!ring->buf)
 		goto no_tx_mem;
 
-	ring->dma = dma_alloc_coherent(eth->dma_dev, MTK_DMA_SIZE * sz,
+	ring->dma = dma_alloc_coherent(eth->dma_dev, ring_size * sz,
 				       &ring->phys, GFP_KERNEL);
 	if (!ring->dma)
 		goto no_tx_mem;
 
-	for (i = 0; i < MTK_DMA_SIZE; i++) {
-		int next = (i + 1) % MTK_DMA_SIZE;
+	for (i = 0; i < ring_size; i++) {
+		int next = (i + 1) % ring_size;
 		u32 next_ptr = ring->phys + next * sz;
 
 		txd = ring->dma + i * sz;
@@ -2234,22 +2240,22 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	 * descriptors in ring->dma_pdma.
 	 */
 	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
-		ring->dma_pdma = dma_alloc_coherent(eth->dma_dev, MTK_DMA_SIZE * sz,
+		ring->dma_pdma = dma_alloc_coherent(eth->dma_dev, ring_size * sz,
 						    &ring->phys_pdma, GFP_KERNEL);
 		if (!ring->dma_pdma)
 			goto no_tx_mem;
 
-		for (i = 0; i < MTK_DMA_SIZE; i++) {
+		for (i = 0; i < ring_size; i++) {
 			ring->dma_pdma[i].txd2 = TX_DMA_DESP2_DEF;
 			ring->dma_pdma[i].txd4 = 0;
 		}
 	}
 
-	ring->dma_size = MTK_DMA_SIZE;
-	atomic_set(&ring->free_count, MTK_DMA_SIZE - 2);
+	ring->dma_size = ring_size;
+	atomic_set(&ring->free_count, ring_size - 2);
 	ring->next_free = ring->dma;
 	ring->last_free = (void *)txd;
-	ring->last_free_ptr = (u32)(ring->phys + ((MTK_DMA_SIZE - 1) * sz));
+	ring->last_free_ptr = (u32)(ring->phys + ((ring_size - 1) * sz));
 	ring->thresh = MAX_SKB_FRAGS;
 
 	/* make sure that all changes to the dma ring are flushed before we
@@ -2261,14 +2267,14 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		mtk_w32(eth, ring->phys, soc->reg_map->qdma.ctx_ptr);
 		mtk_w32(eth, ring->phys, soc->reg_map->qdma.dtx_ptr);
 		mtk_w32(eth,
-			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
+			ring->phys + ((ring_size - 1) * sz),
 			soc->reg_map->qdma.crx_ptr);
 		mtk_w32(eth, ring->last_free_ptr, soc->reg_map->qdma.drx_ptr);
 		mtk_w32(eth, (QDMA_RES_THRES << 8) | QDMA_RES_THRES,
 			soc->reg_map->qdma.qtx_cfg);
 	} else {
 		mtk_w32(eth, ring->phys_pdma, MT7628_TX_BASE_PTR0);
-		mtk_w32(eth, MTK_DMA_SIZE, MT7628_TX_MAX_CNT0);
+		mtk_w32(eth, ring_size, MT7628_TX_MAX_CNT0);
 		mtk_w32(eth, 0, MT7628_TX_CTX_IDX0);
 		mtk_w32(eth, MT7628_PST_DTX_IDX0, soc->reg_map->pdma.rst_idx);
 	}
@@ -2286,7 +2292,7 @@ static void mtk_tx_clean(struct mtk_eth *eth)
 	int i;
 
 	if (ring->buf) {
-		for (i = 0; i < MTK_DMA_SIZE; i++)
+		for (i = 0; i < ring->dma_size; i++)
 			mtk_tx_unmap(eth, &ring->buf[i], NULL, false);
 		kfree(ring->buf);
 		ring->buf = NULL;
@@ -2294,14 +2300,14 @@ static void mtk_tx_clean(struct mtk_eth *eth)
 
 	if (ring->dma) {
 		dma_free_coherent(eth->dma_dev,
-				  MTK_DMA_SIZE * soc->txrx.txd_size,
+				  ring->dma_size * soc->txrx.txd_size,
 				  ring->dma, ring->phys);
 		ring->dma = NULL;
 	}
 
 	if (ring->dma_pdma) {
 		dma_free_coherent(eth->dma_dev,
-				  MTK_DMA_SIZE * soc->txrx.txd_size,
+				  ring->dma_size * soc->txrx.txd_size,
 				  ring->dma_pdma, ring->phys_pdma);
 		ring->dma_pdma = NULL;
 	}
@@ -2821,7 +2827,7 @@ static void mtk_dma_free(struct mtk_eth *eth)
 			netdev_reset_queue(eth->netdev[i]);
 	if (eth->scratch_ring) {
 		dma_free_coherent(eth->dma_dev,
-				  MTK_DMA_SIZE * soc->txrx.txd_size,
+				  MTK_QDMA_RING_SIZE * soc->txrx.txd_size,
 				  eth->scratch_ring, eth->phy_scratch_ring);
 		eth->scratch_ring = NULL;
 		eth->phy_scratch_ring = 0;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 3d7cdc1efbbc..637d3c60507e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -27,6 +27,7 @@
 #define MTK_MAX_RX_LENGTH_2K	2048
 #define MTK_TX_DMA_BUF_LEN	0x3fff
 #define MTK_TX_DMA_BUF_LEN_V2	0xffff
+#define MTK_QDMA_RING_SIZE	2048
 #define MTK_DMA_SIZE		512
 #define MTK_MAC_COUNT		2
 #define MTK_RX_ETH_HLEN		(VLAN_ETH_HLEN + ETH_FCS_LEN)
-- 
2.38.1

