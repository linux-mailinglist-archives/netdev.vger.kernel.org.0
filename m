Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FCC5289AD
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbiEPQIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245672AbiEPQIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:08:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3693819C;
        Mon, 16 May 2022 09:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A46DB81261;
        Mon, 16 May 2022 16:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579EAC34115;
        Mon, 16 May 2022 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717302;
        bh=g+8ZHx5azfc9wFAICouyVaIiKamwB274z8h8s7EKO50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+bT1o961RfEthuRGTK+eC1Vxkq7IDhths0YeT9ujxeKaCKEBSFwtrYiS670ZQOmm
         Op77K6qCb4MWCahtuv8zCfQFoXZANS8318gHlVu4kf7IFpn9/OIBhUmSz1sugTF2bw
         vlHERXGn6eKmAnaqStvX0Q3ObytcJe49oAUguRVFQLjk1G9u7ducTfxV0bbQQY93PD
         UfIYOqbpVgaMR9Bg4t4rq3Df8M0a+WS90d1Es9L6rmijfe8AM1A43c1vHoMb/rPJNj
         dPwBmS+c/2G4mj8E683OFAVQKb6lX6vIsqi3iE5nzWS7CEWvdudIqCgnk+0cHZb4ae
         qGH937UWTMuPg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 13/15] net: ethernet: mtk_eth_soc: convert ring dma pointer to void
Date:   Mon, 16 May 2022 18:06:40 +0200
Message-Id: <c7f18ae8273e099390e8094542efb292e99f8fdc.1652716741.git.lorenzo@kernel.org>
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

Simplify the code converting {tx,rx} ring dma pointer to void

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 32 +++++++++------------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  4 +--
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 50ffdcb8d35a..4190172ba902 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -851,18 +851,15 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 	return 0;
 }
 
-static inline void *mtk_qdma_phys_to_virt(struct mtk_tx_ring *ring, u32 desc)
+static void *mtk_qdma_phys_to_virt(struct mtk_tx_ring *ring, u32 desc)
 {
-	void *ret = ring->dma;
-
-	return ret + (desc - ring->phys);
+	return ring->dma + (desc - ring->phys);
 }
 
 static struct mtk_tx_buf *mtk_desc_to_tx_buf(struct mtk_tx_ring *ring,
-					     struct mtk_tx_dma *txd,
-					     u32 txd_size)
+					     void *txd, u32 txd_size)
 {
-	int idx = ((void *)txd - (void *)ring->dma) / txd_size;
+	int idx = (txd - ring->dma) / txd_size;
 
 	return &ring->buf[idx];
 }
@@ -870,13 +867,12 @@ static struct mtk_tx_buf *mtk_desc_to_tx_buf(struct mtk_tx_ring *ring,
 static struct mtk_tx_dma *qdma_to_pdma(struct mtk_tx_ring *ring,
 				       struct mtk_tx_dma *dma)
 {
-	return ring->dma_pdma - ring->dma + dma;
+	return ring->dma_pdma - (struct mtk_tx_dma *)ring->dma + dma;
 }
 
-static int txd_to_idx(struct mtk_tx_ring *ring, struct mtk_tx_dma *dma,
-		      u32 txd_size)
+static int txd_to_idx(struct mtk_tx_ring *ring, void *dma, u32 txd_size)
 {
-	return ((void *)dma - (void *)ring->dma) / txd_size;
+	return (dma - ring->dma) / txd_size;
 }
 
 static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
@@ -1293,7 +1289,7 @@ static struct mtk_rx_ring *mtk_get_rx_ring(struct mtk_eth *eth)
 
 		ring = &eth->rx_ring[i];
 		idx = NEXT_DESP_IDX(ring->calc_idx, ring->dma_size);
-		rxd = (void *)ring->dma + idx * eth->soc->txrx.rxd_size;
+		rxd = ring->dma + idx * eth->soc->txrx.rxd_size;
 		if (rxd->rxd2 & RX_DMA_DONE) {
 			ring->calc_idx_update = true;
 			return ring;
@@ -1345,7 +1341,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto rx_done;
 
 		idx = NEXT_DESP_IDX(ring->calc_idx, ring->dma_size);
-		rxd = (void *)ring->dma + idx * eth->soc->txrx.rxd_size;
+		rxd = ring->dma + idx * eth->soc->txrx.rxd_size;
 		data = ring->data[idx];
 
 		if (!mtk_rx_get_desc(eth, &trxd, rxd))
@@ -1548,7 +1544,7 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 
 		mtk_tx_unmap(eth, tx_buf, true);
 
-		desc = (void *)ring->dma + cpu * eth->soc->txrx.txd_size;
+		desc = ring->dma + cpu * eth->soc->txrx.txd_size;
 		ring->last_free = desc;
 		atomic_inc(&ring->free_count);
 
@@ -1692,7 +1688,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		int next = (i + 1) % MTK_DMA_SIZE;
 		u32 next_ptr = ring->phys + next * soc->txrx.txd_size;
 
-		txd = (void *)ring->dma + i * soc->txrx.txd_size;
+		txd = ring->dma + i * soc->txrx.txd_size;
 		txd->txd2 = next_ptr;
 		txd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
 		txd->txd4 = 0;
@@ -1723,7 +1719,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 
 	ring->dma_size = MTK_DMA_SIZE;
 	atomic_set(&ring->free_count, MTK_DMA_SIZE - 2);
-	ring->next_free = &ring->dma[0];
+	ring->next_free = ring->dma;
 	ring->last_free = (void *)txd;
 	ring->last_free_ptr = (u32)(ring->phys +
 				    (MTK_DMA_SIZE - 1) * soc->txrx.txd_size);
@@ -1835,7 +1831,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		if (unlikely(dma_mapping_error(eth->dma_dev, dma_addr)))
 			return -ENOMEM;
 
-		rxd = (void *)ring->dma + i * eth->soc->txrx.rxd_size;
+		rxd = ring->dma + i * eth->soc->txrx.rxd_size;
 		rxd->rxd1 = (unsigned int)dma_addr;
 
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
@@ -1889,7 +1885,7 @@ static void mtk_rx_clean(struct mtk_eth *eth, struct mtk_rx_ring *ring)
 			if (!ring->data[i])
 				continue;
 
-			rxd = (void *)ring->dma + i * eth->soc->txrx.rxd_size;
+			rxd = ring->dma + i * eth->soc->txrx.rxd_size;
 			if (!rxd->rxd1)
 				continue;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 654ad3b00154..57501dd5adcc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -828,7 +828,7 @@ struct mtk_tx_buf {
  *			are present
  */
 struct mtk_tx_ring {
-	struct mtk_tx_dma *dma;
+	void *dma;
 	struct mtk_tx_buf *buf;
 	dma_addr_t phys;
 	struct mtk_tx_dma *next_free;
@@ -858,7 +858,7 @@ enum mtk_rx_flags {
  * @calc_idx:		The current head of ring
  */
 struct mtk_rx_ring {
-	struct mtk_rx_dma *dma;
+	void *dma;
 	u8 **data;
 	dma_addr_t phys;
 	u16 frag_size;
-- 
2.35.3

