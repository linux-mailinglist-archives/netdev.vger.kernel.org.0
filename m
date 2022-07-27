Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252D35834CB
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 23:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbiG0VWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 17:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiG0VWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 17:22:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C105720A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 14:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A89B82257
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 21:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D299C433D6;
        Wed, 27 Jul 2022 21:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658956951;
        bh=CZtM9s2J3HKMWBBRhVvCKsVplRGQbv9iT4Im/IHZw/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HE4IWDayGqAq/dKD+FCAQlAztBsa68h62s1wGLs0Iy2XitrAnjCt6A1wn+zmrSMha
         UC/obMpr8p5vX3nga+R1dEcPdlz+b1lEgpTtRrkj8AMMAc8xkp+YZmNOdfXYqpCmVd
         a7RYdHIObpeVZaQzXdavoHbrW9pKJl83Y9wkbNN5BqoQprmk00BOBX0ute/JFe2SLF
         gYvR+M9Q3H1iQLxvh43Cr2pTcvtwUXsbsRN9r+KNiaBQwNQ+PDjX8qd6PrqsYVDDYc
         5/toA4xXgwofKEcn4gr6rvWErnuUWxhZvv8YhmB9Pg/jvteednoZLPxVo43gDcLf5v
         LBS1V7DmR0e7Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH net-next 1/3] net: ethernet: mtk_eth_soc: introduce mtk_xdp_frame_map utility routine
Date:   Wed, 27 Jul 2022 23:20:50 +0200
Message-Id: <b6108c028b471261ae28eaa39a3e22bce1622fd9.1658955249.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1658955249.git.lorenzo@kernel.org>
References: <cover.1658955249.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to add xdp multi-frag support to mtk_eth_soc
driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 68 +++++++++++++--------
 1 file changed, 42 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c370d6589596..8450604d22ff 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1523,6 +1523,41 @@ static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
 		skb_free_frag(data);
 }
 
+static int mtk_xdp_frame_map(struct mtk_eth *eth, struct net_device *dev,
+			     struct mtk_tx_dma_desc_info *txd_info,
+			     struct mtk_tx_dma *txd, struct mtk_tx_buf *tx_buf,
+			     void *data, u16 headroom, int index, bool dma_map)
+{
+	struct mtk_tx_ring *ring = &eth->tx_ring;
+	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_tx_dma *txd_pdma;
+
+	if (dma_map) {  /* ndo_xdp_xmit */
+		txd_info->addr = dma_map_single(eth->dma_dev, data,
+						txd_info->size, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(eth->dma_dev, txd_info->addr)))
+			return -ENOMEM;
+
+		tx_buf->flags |= MTK_TX_FLAGS_SINGLE0;
+	} else {
+		struct page *page = virt_to_head_page(data);
+
+		txd_info->addr = page_pool_get_dma_addr(page) +
+				 sizeof(struct xdp_frame) + headroom;
+		dma_sync_single_for_device(eth->dma_dev, txd_info->addr,
+					   txd_info->size, DMA_BIDIRECTIONAL);
+	}
+	mtk_tx_set_dma_desc(dev, txd, txd_info);
+
+	tx_buf->flags |= !mac->id ? MTK_TX_FLAGS_FPORT0 : MTK_TX_FLAGS_FPORT1;
+
+	txd_pdma = qdma_to_pdma(ring, txd);
+	setup_tx_buf(eth, tx_buf, txd_pdma, txd_info->addr, txd_info->size,
+		     index);
+
+	return 0;
+}
+
 static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 				struct net_device *dev, bool dma_map)
 {
@@ -1533,9 +1568,8 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 		.first	= true,
 		.last	= true,
 	};
-	struct mtk_mac *mac = netdev_priv(dev);
-	struct mtk_tx_dma *txd, *txd_pdma;
 	int err = 0, index = 0, n_desc = 1;
+	struct mtk_tx_dma *txd, *txd_pdma;
 	struct mtk_tx_buf *tx_buf;
 
 	if (unlikely(test_bit(MTK_RESETTING, &eth->state)))
@@ -1555,36 +1589,18 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 	tx_buf = mtk_desc_to_tx_buf(ring, txd, soc->txrx.txd_size);
 	memset(tx_buf, 0, sizeof(*tx_buf));
 
-	if (dma_map) {  /* ndo_xdp_xmit */
-		txd_info.addr = dma_map_single(eth->dma_dev, xdpf->data,
-					       txd_info.size, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(eth->dma_dev, txd_info.addr))) {
-			err = -ENOMEM;
-			goto out;
-		}
-		tx_buf->flags |= MTK_TX_FLAGS_SINGLE0;
-	} else {
-		struct page *page = virt_to_head_page(xdpf->data);
-
-		txd_info.addr = page_pool_get_dma_addr(page) +
-				sizeof(*xdpf) + xdpf->headroom;
-		dma_sync_single_for_device(eth->dma_dev, txd_info.addr,
-					   txd_info.size,
-					   DMA_BIDIRECTIONAL);
-	}
-	mtk_tx_set_dma_desc(dev, txd, &txd_info);
-
-	tx_buf->flags |= !mac->id ? MTK_TX_FLAGS_FPORT0 : MTK_TX_FLAGS_FPORT1;
-
-	txd_pdma = qdma_to_pdma(ring, txd);
-	setup_tx_buf(eth, tx_buf, txd_pdma, txd_info.addr, txd_info.size,
-		     index++);
+	err = mtk_xdp_frame_map(eth, dev, &txd_info, txd, tx_buf,
+				xdpf->data, xdpf->headroom, index,
+				dma_map);
+	if (err < 0)
+		goto out;
 
 	/* store xdpf for cleanup */
 	tx_buf->type = dma_map ? MTK_TYPE_XDP_NDO : MTK_TYPE_XDP_TX;
 	tx_buf->data = xdpf;
 
 	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
+		txd_pdma = qdma_to_pdma(ring, txd);
 		if (index & 1)
 			txd_pdma->txd2 |= TX_DMA_LS0;
 		else
-- 
2.37.1

