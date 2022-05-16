Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3056E5289A4
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245635AbiEPQIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245647AbiEPQIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:08:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2789937BFA;
        Mon, 16 May 2022 09:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4946BB81261;
        Mon, 16 May 2022 16:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30546C385AA;
        Mon, 16 May 2022 16:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717279;
        bh=Fj9JFlaKbmnQVBZzLkZZrJLpdmId1DncPM5qdcLaj44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0uT+7yr1+QxZ57GgvwPGRcy5xV+IkFmBQpDevHy3yN/WIr12/u3x+yFmFpkJpw+U
         wX2a6YYLkx088VZpMEb8sECOqsQCA8pfVQDXLlHXCRcs1xufpwjq9ExOtRBJiE5Fcx
         hYl/flNzOBhgVuBaLdI87JOTigCvk9QSItrgrlUEdKli/4EhbUkegLcYVC7uaVwVmD
         gmdNGRkDpZJ6KgZHJS8oVN/E5JXOqXDSsKM6h1dVbT+AvewEgy0uuxToO1VMsT7WZg
         sg1kAXLeBh9KBOxGK33UbiZbFXNR6fPBngNTvruPFf5xPVKmkt0eCBOXQQJsJ/JaaD
         Dv6hZ/r6JPmzg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 06/15] net: ethernet: mtk_eth_soc: rely on txd_size in mtk_desc_to_tx_buf
Date:   Mon, 16 May 2022 18:06:33 +0200
Message-Id: <185cc16faadc2b4b1fa47d550ef59d2bfd4b0d23.1652716741.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 26 ++++++++++++---------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a48e93792db1..5f0082f92cc7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -837,10 +837,11 @@ static inline void *mtk_qdma_phys_to_virt(struct mtk_tx_ring *ring, u32 desc)
 	return ret + (desc - ring->phys);
 }
 
-static inline struct mtk_tx_buf *mtk_desc_to_tx_buf(struct mtk_tx_ring *ring,
-						    struct mtk_tx_dma *txd)
+static struct mtk_tx_buf *mtk_desc_to_tx_buf(struct mtk_tx_ring *ring,
+					     struct mtk_tx_dma *txd,
+					     u32 txd_size)
 {
-	int idx = txd - ring->dma;
+	int idx = ((void *)txd - (void *)ring->dma) / txd_size;
 
 	return &ring->buf[idx];
 }
@@ -962,6 +963,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	};
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
+	const struct mtk_soc_data *soc = eth->soc;
 	struct mtk_tx_dma *itxd, *txd;
 	struct mtk_tx_dma *itxd_pdma, *txd_pdma;
 	struct mtk_tx_buf *itx_buf, *tx_buf;
@@ -973,7 +975,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	if (itxd == ring->last_free)
 		return -ENOMEM;
 
-	itx_buf = mtk_desc_to_tx_buf(ring, itxd);
+	itx_buf = mtk_desc_to_tx_buf(ring, itxd, soc->txrx.txd_size);
 	memset(itx_buf, 0, sizeof(*itx_buf));
 
 	txd_info.addr = dma_map_single(eth->dma_dev, skb->data, txd_info.size,
@@ -1001,7 +1003,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		while (frag_size) {
 			bool new_desc = true;
 
-			if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA) ||
+			if (MTK_HAS_CAPS(soc->caps, MTK_QDMA) ||
 			    (i & 0x1)) {
 				txd = mtk_qdma_phys_to_virt(ring, txd->txd2);
 				txd_pdma = qdma_to_pdma(ring, txd);
@@ -1025,7 +1027,8 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 
 			mtk_tx_set_dma_desc(dev, txd, &txd_info);
 
-			tx_buf = mtk_desc_to_tx_buf(ring, txd);
+			tx_buf = mtk_desc_to_tx_buf(ring, txd,
+						    soc->txrx.txd_size);
 			if (new_desc)
 				memset(tx_buf, 0, sizeof(*tx_buf));
 			tx_buf->skb = (struct sk_buff *)MTK_DMA_DUMMY_DESC;
@@ -1044,7 +1047,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	/* store skb to cleanup */
 	itx_buf->skb = skb;
 
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
 		if (k & 0x1)
 			txd_pdma->txd2 |= TX_DMA_LS0;
 		else
@@ -1062,7 +1065,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	 */
 	wmb();
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+	if (MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
 		if (netif_xmit_stopped(netdev_get_tx_queue(dev, 0)) ||
 		    !netdev_xmit_more())
 			mtk_w32(eth, txd->txd2, MTK_QTX_CTX_PTR);
@@ -1076,13 +1079,13 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 
 err_dma:
 	do {
-		tx_buf = mtk_desc_to_tx_buf(ring, itxd);
+		tx_buf = mtk_desc_to_tx_buf(ring, itxd, soc->txrx.txd_size);
 
 		/* unmap dma */
 		mtk_tx_unmap(eth, tx_buf, false);
 
 		itxd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
-		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA))
 			itxd_pdma->txd2 = TX_DMA_DESP2_DEF;
 
 		itxd = mtk_qdma_phys_to_virt(ring, itxd->txd2);
@@ -1393,7 +1396,8 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 		if ((desc->txd3 & TX_DMA_OWNER_CPU) == 0)
 			break;
 
-		tx_buf = mtk_desc_to_tx_buf(ring, desc);
+		tx_buf = mtk_desc_to_tx_buf(ring, desc,
+					    eth->soc->txrx.txd_size);
 		if (tx_buf->flags & MTK_TX_FLAGS_FPORT1)
 			mac = 1;
 
-- 
2.35.3

