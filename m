Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD965D4E2
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbjADODm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjADODi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:03:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CDB200
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 06:03:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67B38B81683
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 14:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58D7C433EF;
        Wed,  4 Jan 2023 14:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672841015;
        bh=Qtcw4YiYQC6vFVBPGLZh6FrLkSqwMP0taIG1GVnfjtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqFm2A1JDNen83fNmzhUmvdeKYWL1B6fMGnuZoNzf7ISfgEKV6iM/qk61qoSQto1O
         HlDh1DQ8tuxd7vTz7HLZA6lVlcPRkI/gI7ltLcugB3i2/7YrJlJB7mZIiJzwavuD1w
         nQUgeM2Dnyi0nFokcQV4EtsGPuJgEoBr9LXGyoSoDbFlMcQg6qWdg12sIEJ5hw98Zg
         aWOjAvaCkGsIVsLE5d1TJMAu1WuoDrQeX8JAXJUdljoSAeFrjGRbukyPUUW4mCn4wC
         QL6oj8HOiDKdfz3XFhr6++MT2HviL2du1/UZCR/aTfdVjthgpeT7Wt3ISbfJg5o+49
         YJSYhSUgfkHiQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: [PATCH v2 net-next 1/5] net: ethernet: mtk_eth_soc: introduce mtk_hw_reset utility routine
Date:   Wed,  4 Jan 2023 15:03:10 +0100
Message-Id: <1cf6068894972dc11de15c0e86e65429407faf2e.1672840859.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1672840858.git.lorenzo@kernel.org>
References: <cover.1672840858.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to add Wireless Ethernet Dispatcher reset
support.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 36 +++++++++++++--------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e3de9a53b2d9..ce429deea389 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3471,6 +3471,27 @@ static void mtk_set_mcr_max_rx(struct mtk_mac *mac, u32 val)
 		mtk_w32(mac->hw, mcr_new, MTK_MAC_MCR(mac->id));
 }
 
+static void mtk_hw_reset(struct mtk_eth *eth)
+{
+	u32 val;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
+		val = RSTCTRL_PPE0_V2;
+	} else {
+		val = RSTCTRL_PPE0;
+	}
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
+		val |= RSTCTRL_PPE1;
+
+	ethsys_reset(eth, RSTCTRL_ETH | RSTCTRL_FE | val);
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
+			     0x3ffffff);
+}
+
 static int mtk_hw_init(struct mtk_eth *eth)
 {
 	u32 dma_mask = ETHSYS_DMA_AG_MAP_PDMA | ETHSYS_DMA_AG_MAP_QDMA |
@@ -3510,22 +3531,9 @@ static int mtk_hw_init(struct mtk_eth *eth)
 		return 0;
 	}
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
-		val = RSTCTRL_PPE0_V2;
-	} else {
-		val = RSTCTRL_PPE0;
-	}
-
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
-		val |= RSTCTRL_PPE1;
-
-	ethsys_reset(eth, RSTCTRL_ETH | RSTCTRL_FE | val);
+	mtk_hw_reset(eth);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
-			     0x3ffffff);
-
 		/* Set FE to PDMAv2 if necessary */
 		val = mtk_r32(eth, MTK_FE_GLO_MISC);
 		mtk_w32(eth,  val | BIT(4), MTK_FE_GLO_MISC);
-- 
2.39.0

