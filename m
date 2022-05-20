Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E4252F236
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352462AbiETSMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352455AbiETSMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B69F18DAC9;
        Fri, 20 May 2022 11:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB8C2B82D90;
        Fri, 20 May 2022 18:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07A1C385A9;
        Fri, 20 May 2022 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070367;
        bh=+IZMGA7q81QWtnP8o5Y0D9cC9JaYvk8r7G2oLMll/EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcGn28r1VbhZYFeRVT6nbcD/5vCLR2yOhdLo1tEeYR3QLGosuBEOsawjoSuTa6rUm
         pKjenIwjoUho4Elkv7FuzWjKQqscx4jzTGVZgMMv2Jo+fZMnbW0kcwpb2aqYGVSAPV
         nmqqcyboGocxNLGq3mIlbm8ofzIwVp5JFHg0gRkPtjIWZuXmj7DggQ11NvZ4m80oKN
         rIua+B6XQATdEYVcyw0SntcLEx7lTa3CJrjz5nnHTxn2881+5Q+wYw0sa6wnD8XBfu
         uQAxUF9+Faaua52J22jC5ToHX5NHtevkMxAf6JFPwLuvOk71Fy5464c9KH8hgqlQTo
         k4Euu5Bcj5Igw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 09/16] net: ethernet: mtk_eth_soc: add rxd_size to mtk_soc_data
Date:   Fri, 20 May 2022 20:11:32 +0200
Message-Id: <970f29fe5af213e643e1a5e6aec4006f1d6d693c.1653069056.git.lorenzo@kernel.org>
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
index 1bf5edd9eb44..7c4e63cc7c2a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1740,7 +1740,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 	}
 
 	ring->dma = dma_alloc_coherent(eth->dma_dev,
-				       rx_dma_size * sizeof(*ring->dma),
+				       rx_dma_size * eth->soc->txrx.rxd_size,
 				       &ring->phys, GFP_KERNEL);
 	if (!ring->dma)
 		return -ENOMEM;
@@ -1798,9 +1798,8 @@ static void mtk_rx_clean(struct mtk_eth *eth, struct mtk_rx_ring *ring)
 
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
@@ -3388,6 +3387,7 @@ static const struct mtk_soc_data mt2701_data = {
 	.required_pctl = true,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3399,6 +3399,7 @@ static const struct mtk_soc_data mt7621_data = {
 	.offload_version = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3411,6 +3412,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.offload_version = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3422,6 +3424,7 @@ static const struct mtk_soc_data mt7623_data = {
 	.offload_version = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3433,6 +3436,7 @@ static const struct mtk_soc_data mt7629_data = {
 	.required_pctl = false,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
@@ -3443,6 +3447,7 @@ static const struct mtk_soc_data rt5350_data = {
 	.required_pctl = false,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
+		.rxd_size = sizeof(struct mtk_rx_dma),
 	},
 };
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 7a5ad14b8be6..dcbf4b5c70e0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -868,6 +868,7 @@ struct mtk_tx_dma_desc_info {
  * @required_pctl		A bool value to show whether the SoC requires
  *				the extra setup for those pins used by GMAC.
  * @txd_size			Tx DMA descriptor size.
+ * @rxd_size			Rx DMA descriptor size.
  */
 struct mtk_soc_data {
 	u32             ana_rgc3;
@@ -878,6 +879,7 @@ struct mtk_soc_data {
 	netdev_features_t hw_features;
 	struct {
 		u32	txd_size;
+		u32	rxd_size;
 	} txrx;
 };
 
-- 
2.35.3

