Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8456947668
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfFPS36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 14:29:58 -0400
Received: from mx.0dd.nl ([5.2.79.48]:35814 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfFPS36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 14:29:58 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id CD2F4606F0;
        Sun, 16 Jun 2019 20:20:29 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="rqYc/K2g";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 9B9721C65C74;
        Sun, 16 Jun 2019 20:20:29 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 9B9721C65C74
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1560709229;
        bh=jkCk3uJcoUHxaeiWoxc5qfuBTzCnR4/h0/TtYViIvzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqYc/K2gVLyj7qPNYzn0UtMkJ0sUBwee+WJ7dXwu91v2dDuAHePWmv/P5UhFISINQ
         p/eC4+qZtrIqU2Wo+R0OO1eOY42Npp1S7NQ9y3T2S/GyVhGCsZhcJrWb29gxTeMJ7p
         nnQiQT+G1RyPg46+Pd01Q8FRzbzpUpTzuq+3wErdpixUaDLxkHosio0nwZbbQBGNw2
         a5ngAMHJR/ulaThowNn6s2x96kNQALzJaPTUsYEwP1D+J1pJf8oC15F02PKSuS9x+H
         BOyVKbK57eDZwbuc8KffgO4DMBpFBv7bYuF6QCvGcwIgbg6kK4Qc0tX2+j7M10vwiR
         6CqUJ9puW4ySA==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next 1/2] net: ethernet: mediatek: Add MT7621 TRGMII mode support
Date:   Sun, 16 Jun 2019 20:20:09 +0200
Message-Id: <20190616182010.18778-2-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190616182010.18778-1-opensource@vdorst.com>
References: <20190616182010.18778-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7621 SOC also supports TRGMII.
TRGMII speed is 1200MBit.

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 38 ++++++++++++++++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 11 ++++++
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 362eacd82b92..628adbf79710 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -140,6 +140,28 @@ static int mtk_mdio_read(struct mii_bus *bus, int phy_addr, int phy_reg)
 	return _mtk_mdio_read(eth, phy_addr, phy_reg);
 }
 
+static int mt7621_gmac0_rgmii_adjust(struct mtk_eth *eth,
+				     phy_interface_t interface)
+{
+	u32 val;
+
+	/* Check DDR memory type. Currently DDR2 is not supported. */
+	regmap_read(eth->ethsys, ETHSYS_SYSCFG, &val);
+	if (val & SYSCFG_DRAM_TYPE_DDR2) {
+		dev_err(eth->dev,
+			"TRGMII mode with DDR2 memory is not supported!\n");
+		return -EOPNOTSUPP;
+	}
+
+	val = (interface == PHY_INTERFACE_MODE_TRGMII) ?
+		ETHSYS_TRGMII_MT7621_DDR_PLL : 0;
+
+	regmap_update_bits(eth->ethsys, ETHSYS_CLKCFG0,
+			   ETHSYS_TRGMII_MT7621_MASK, val);
+
+	return 0;
+}
+
 static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth, int speed)
 {
 	u32 val;
@@ -189,9 +211,17 @@ static void mtk_phy_link_adjust(struct net_device *dev)
 		break;
 	}
 
-	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_GMAC1_TRGMII) &&
-	    !mac->id && !mac->trgmii)
-		mtk_gmac0_rgmii_adjust(mac->hw, dev->phydev->speed);
+	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_GMAC1_TRGMII) && !mac->id) {
+		if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII_MT7621_CLK)) {
+			if (mt7621_gmac0_rgmii_adjust(mac->hw,
+						      dev->phydev->interface))
+				return;
+		} else {
+			if (!mac->trgmii)
+				mtk_gmac0_rgmii_adjust(mac->hw,
+						       dev->phydev->speed);
+		}
+	}
 
 	if (dev->phydev->link)
 		mcr |= MAC_MCR_FORCE_LINK;
@@ -2613,7 +2643,7 @@ static const struct mtk_soc_data mt2701_data = {
 };
 
 static const struct mtk_soc_data mt7621_data = {
-	.caps = MTK_SHARED_INT,
+	.caps = MT7621_CAPS,
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
 };
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index a0aa5008d5cc..9abb4015477f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -369,6 +369,10 @@
 #define MT7622_ETH		7622
 #define MT7621_ETH		7621
 
+/* ethernet system control register */
+#define ETHSYS_SYSCFG		0x10
+#define SYSCFG_DRAM_TYPE_DDR2	BIT(4)
+
 /* ethernet subsystem config register */
 #define ETHSYS_SYSCFG0		0x14
 #define SYSCFG0_GE_MASK		0x3
@@ -383,6 +387,9 @@
 /* ethernet subsystem clock register */
 #define ETHSYS_CLKCFG0		0x2c
 #define ETHSYS_TRGMII_CLK_SEL362_5	BIT(11)
+#define ETHSYS_TRGMII_MT7621_MASK	(BIT(5) | BIT(6))
+#define ETHSYS_TRGMII_MT7621_APLL	BIT(6)
+#define ETHSYS_TRGMII_MT7621_DDR_PLL	BIT(5)
 
 /* ethernet reset control register */
 #define ETHSYS_RSTCTRL		0x34
@@ -622,6 +629,7 @@ enum mtk_eth_path {
 #define MTK_SHARED_SGMII		BIT(7)
 #define MTK_HWLRO			BIT(8)
 #define MTK_SHARED_INT			BIT(9)
+#define MTK_TRGMII_MT7621_CLK		BIT(10)
 
 /* Supported path present on SoCs */
 #define MTK_PATH_BIT(x)         BIT((x) + 10)
@@ -673,6 +681,9 @@ enum mtk_eth_path {
 
 #define MTK_HAS_CAPS(caps, _x)		(((caps) & (_x)) == (_x))
 
+#define MT7621_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII | \
+		      MTK_GMAC2_RGMII | MTK_SHARED_INT | MTK_TRGMII_MT7621_CLK)
+
 #define MT7622_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_SGMII | MTK_GMAC2_RGMII | \
 		      MTK_GMAC2_SGMII | MTK_GDM1_ESW | \
 		      MTK_MUX_GDM1_TO_GMAC1_ESW | \
-- 
2.20.1

