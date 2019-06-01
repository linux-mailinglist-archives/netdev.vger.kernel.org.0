Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19EE318A7
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfFAAIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:08:54 -0400
Received: from mailgw01.mediatek.com ([216.200.240.184]:37342 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfFAAIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:08:30 -0400
X-UUID: c59d9d4c6e67435db183698f70d4dadf-20190531
X-UUID: c59d9d4c6e67435db183698f70d4dadf-20190531
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw01.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 2008444438; Fri, 31 May 2019 16:03:27 -0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 31 May 2019 17:03:26 -0700
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 1 Jun 2019 08:03:25 +0800
From:   <sean.wang@mediatek.com>
To:     <john@phrozen.org>, <davem@davemloft.net>
CC:     <nbd@openwrt.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next v1 5/6] net: ethernet: mediatek: Add MT7629 ethernet support
Date:   Sat, 1 Jun 2019 08:03:14 +0800
Message-ID: <1559347395-14058-6-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1559347395-14058-1-git-send-email-sean.wang@mediatek.com>
References: <1559347395-14058-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

Add ethernet support to MT7629 SoC

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 14 ++++++++++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 19 +++++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 382173fa4752..362eacd82b92 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -54,8 +54,10 @@ static const struct mtk_ethtool_stats {
 };
 
 static const char * const mtk_clks_source_name[] = {
-	"ethif", "esw", "gp0", "gp1", "gp2", "trgpll", "sgmii_tx250m",
-	"sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii_ck", "eth2pll"
+	"ethif", "sgmiitop", "esw", "gp0", "gp1", "gp2", "fe", "trgpll",
+	"sgmii_tx250m", "sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb",
+	"sgmii2_tx250m", "sgmii2_rx250m", "sgmii2_cdr_ref", "sgmii2_cdr_fb",
+	"sgmii_ck", "eth2pll",
 };
 
 void mtk_w32(struct mtk_eth *eth, u32 val, unsigned reg)
@@ -2629,11 +2631,19 @@ static const struct mtk_soc_data mt7623_data = {
 	.required_pctl = true,
 };
 
+static const struct mtk_soc_data mt7629_data = {
+	.ana_rgc3 = 0x128,
+	.caps = MT7629_CAPS | MTK_HWLRO,
+	.required_clks = MT7629_CLKS_BITMAP,
+	.required_pctl = false,
+};
+
 const struct of_device_id of_mtk_match[] = {
 	{ .compatible = "mediatek,mt2701-eth", .data = &mt2701_data},
 	{ .compatible = "mediatek,mt7621-eth", .data = &mt7621_data},
 	{ .compatible = "mediatek,mt7622-eth", .data = &mt7622_data},
 	{ .compatible = "mediatek,mt7623-eth", .data = &mt7623_data},
+	{ .compatible = "mediatek,mt7629-eth", .data = &mt7629_data},
 	{},
 };
 MODULE_DEVICE_TABLE(of, of_mtk_match);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 89d68dd60b3d..a0aa5008d5cc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -475,15 +475,21 @@ enum mtk_tx_flags {
  */
 enum mtk_clks_map {
 	MTK_CLK_ETHIF,
+	MTK_CLK_SGMIITOP,
 	MTK_CLK_ESW,
 	MTK_CLK_GP0,
 	MTK_CLK_GP1,
 	MTK_CLK_GP2,
+	MTK_CLK_FE,
 	MTK_CLK_TRGPLL,
 	MTK_CLK_SGMII_TX_250M,
 	MTK_CLK_SGMII_RX_250M,
 	MTK_CLK_SGMII_CDR_REF,
 	MTK_CLK_SGMII_CDR_FB,
+	MTK_CLK_SGMII2_TX_250M,
+	MTK_CLK_SGMII2_RX_250M,
+	MTK_CLK_SGMII2_CDR_REF,
+	MTK_CLK_SGMII2_CDR_FB,
 	MTK_CLK_SGMII_CK,
 	MTK_CLK_ETH2PLL,
 	MTK_CLK_MAX
@@ -502,6 +508,19 @@ enum mtk_clks_map {
 				 BIT(MTK_CLK_SGMII_CK) | \
 				 BIT(MTK_CLK_ETH2PLL))
 #define MT7621_CLKS_BITMAP	(0)
+#define MT7629_CLKS_BITMAP	(BIT(MTK_CLK_ETHIF) | BIT(MTK_CLK_ESW) |  \
+				 BIT(MTK_CLK_GP0) | BIT(MTK_CLK_GP1) | \
+				 BIT(MTK_CLK_GP2) | BIT(MTK_CLK_FE) | \
+				 BIT(MTK_CLK_SGMII_TX_250M) | \
+				 BIT(MTK_CLK_SGMII_RX_250M) | \
+				 BIT(MTK_CLK_SGMII_CDR_REF) | \
+				 BIT(MTK_CLK_SGMII_CDR_FB) | \
+				 BIT(MTK_CLK_SGMII2_TX_250M) | \
+				 BIT(MTK_CLK_SGMII2_RX_250M) | \
+				 BIT(MTK_CLK_SGMII2_CDR_REF) | \
+				 BIT(MTK_CLK_SGMII2_CDR_FB) | \
+				 BIT(MTK_CLK_SGMII_CK) | \
+				 BIT(MTK_CLK_ETH2PLL) | BIT(MTK_CLK_SGMIITOP))
 
 enum mtk_dev_state {
 	MTK_HW_INIT,
-- 
2.17.1

