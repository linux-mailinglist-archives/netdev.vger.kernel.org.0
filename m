Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030FA4D7CF5
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiCNIBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiCNIBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:01:04 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F0A2DD6;
        Mon, 14 Mar 2022 00:58:10 -0700 (PDT)
X-UUID: 177ec6f7625d470cb3cad54756e1e80b-20220314
X-UUID: 177ec6f7625d470cb3cad54756e1e80b-20220314
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1686703435; Mon, 14 Mar 2022 15:57:22 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 14 Mar 2022 15:57:21 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Mar 2022 15:57:20 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <angelogioacchino.delregno@collabora.com>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <dkirjanov@suse.de>
Subject: [PATCH net-next v13 4/7] arm64: dts: mt2712: update ethernet device node
Date:   Mon, 14 Mar 2022 15:57:10 +0800
Message-ID: <20220314075713.29140-5-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220314075713.29140-1-biao.huang@mediatek.com>
References: <20220314075713.29140-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since there are some changes in ethernet driver:
update ethernet device node in dts to accommodate to it.

1. stmmac_probe_config_dt() in stmmac_platform.c will initialize specified
   parameters according to compatible string "snps,dwmac-4.20a", then,
   dwmac-mediatek.c can skip the initialization if add compatible string
   "snps,dwmac-4.20a" in eth device node.
2. commit 882007ed7832 ("net-next: dt-binding: dwmac-mediatek: add more
   description for RMII") added rmii internal support, we should add
   corresponding clocks/clocks-names in eth device node.
3. add "snps,reset-delays-us = <0 10000 10000>;" to ensure reset delay
   can meet PHY requirement.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts |  1 +
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi   | 14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
index 7d369fdd3117..11aa135aa0f3 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
@@ -110,6 +110,7 @@ &eth {
 	phy-handle = <&ethernet_phy0>;
 	mediatek,tx-delay-ps = <1530>;
 	snps,reset-gpio = <&pio 87 GPIO_ACTIVE_LOW>;
+	snps,reset-delays-us = <0 10000 10000>;
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&eth_default>;
 	pinctrl-1 = <&eth_sleep>;
diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
index a9cca9c146fd..9e850e04fffb 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
@@ -726,7 +726,7 @@ queue2 {
 	};
 
 	eth: ethernet@1101c000 {
-		compatible = "mediatek,mt2712-gmac";
+		compatible = "mediatek,mt2712-gmac", "snps,dwmac-4.20a";
 		reg = <0 0x1101c000 0 0x1300>;
 		interrupts = <GIC_SPI 237 IRQ_TYPE_LEVEL_LOW>;
 		interrupt-names = "macirq";
@@ -734,15 +734,19 @@ eth: ethernet@1101c000 {
 		clock-names = "axi",
 			      "apb",
 			      "mac_main",
-			      "ptp_ref";
+			      "ptp_ref",
+			      "rmii_internal";
 		clocks = <&pericfg CLK_PERI_GMAC>,
 			 <&pericfg CLK_PERI_GMAC_PCLK>,
 			 <&topckgen CLK_TOP_ETHER_125M_SEL>,
-			 <&topckgen CLK_TOP_ETHER_50M_SEL>;
+			 <&topckgen CLK_TOP_ETHER_50M_SEL>,
+			 <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
 		assigned-clocks = <&topckgen CLK_TOP_ETHER_125M_SEL>,
-				  <&topckgen CLK_TOP_ETHER_50M_SEL>;
+				  <&topckgen CLK_TOP_ETHER_50M_SEL>,
+				  <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
 		assigned-clock-parents = <&topckgen CLK_TOP_ETHERPLL_125M>,
-					 <&topckgen CLK_TOP_APLL1_D3>;
+					 <&topckgen CLK_TOP_APLL1_D3>,
+					 <&topckgen CLK_TOP_ETHERPLL_50M>;
 		power-domains = <&scpsys MT2712_POWER_DOMAIN_AUDIO>;
 		mediatek,pericfg = <&pericfg>;
 		snps,axi-config = <&stmmac_axi_setup>;
-- 
2.25.1

