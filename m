Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C2B51D7D8
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391993AbiEFMfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392013AbiEFMfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:35:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783DE65D13;
        Fri,  6 May 2022 05:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CA13B8346C;
        Fri,  6 May 2022 12:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59497C385B1;
        Fri,  6 May 2022 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840294;
        bh=58IWSSsRvKshbFdru4enHZgga/CVY0/Whqe26ozDW4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0zVET2pV1dRN+lYKDl9l8QZiVslUf6lcNa/I51mQLApbgXVnRFdYTXrz+QPxuDlo
         Wi7GKdwu4EyLdoXJbP3Q6Cl9U/lNyRpszejO8COgyXFtMHCoFhEukS+iHnm341R4He
         mNk7/9HJ6gSIF2I5TVnFgAlf5NgsGJIm4spxT5Y9VczCjODUerfqyx7H3EuFQexv5n
         HT9ilcuAf7ZiXUF6c7fak45L4j7aa7vXJoUI2yz9Gxa6McOcwfbZgirDxx092aMih1
         YEnNr0yZgMeJA2WNOEW12KGzKRNkUxYCqoFOpELWQOoBHYsC5QZYEWv++Hpzhz6AS3
         BCcgc0XYNOc6w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 08/14] net: ethernet: mtk_eth_soc: add rxd_size to mtk_soc_data
Date:   Fri,  6 May 2022 14:30:25 +0200
Message-Id: <35e76230f551e4a14e5f962a06e174b5f3561ca8.1651839494.git.lorenzo@kernel.org>
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

Similar to tx counterpart, introduce rxd_size in mtk_soc_data data
structure.
This is a preliminary patch to add mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 13 +++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 ++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a67b22dbaac7..bb628b65a9e5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1719,7 +1719,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 	}
 
 	ring->dma = dma_alloc_coherent(eth->dma_dev,
-				       rx_dma_size * sizeof(*ring->dma),
+				       rx_dma_size * eth->soc->txrx.rxd_size,
 				       &ring->phys, GFP_ATOMIC);
 	if (!ring->dma)
 		return -ENOMEM;
@@ -1777,9 +1777,8 @@ static void mtk_rx_clean(struct mtk_eth *eth, struct mtk_rx_ring *ring)
 
 	if (ring->dma) {
 		dma_free_coherent(eth->dma_dev,
-				  ring->dma_size * sizeof(*ring->dma),
-				  ring->dma,
-				  ring->phys);
+				  ring->dma_size * eth->soc->txrx.rxd_size,
+				  ring->dma, ring->phys);
 		ring->dma = NULL;
 	}
 }
@@ -3370,6 +3369,7 @@ static const struct mtk_soc_data mt2701_data = {
 	.required_pctl = true,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3381,6 +3381,7 @@ static const struct mtk_soc_data mt7621_data = {
 	.offload_version = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3393,6 +3394,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.offload_version = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3404,6 +3406,7 @@ static const struct mtk_soc_data mt7623_data = {
 	.offload_version = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3415,6 +3418,7 @@ static const struct mtk_soc_data mt7629_data = {
 	.required_pctl = false,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3425,6 +3429,7 @@ static const struct mtk_soc_data rt5350_data = {
 	.required_pctl = false,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 495f623b62ef..150d692633fa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -866,6 +866,7 @@ struct mtk_tx_dma_desc_info {
  * @required_pctl		A bool value to show whether the SoC requires
  *				the extra setup for those pins used by GMAC.
  * @txd_size			TX DMA descriptor size.
+ * @rxd_size			RX DMA descriptor size.
  */
 struct mtk_soc_data {
 	u32             ana_rgc3;
@@ -876,6 +877,7 @@ struct mtk_soc_data {
 	netdev_features_t hw_features;
 	struct {
 		u32	txd_size;
+		u32	rxd_size;
 	} txrx;
 };
 
-- 
2.35.1

