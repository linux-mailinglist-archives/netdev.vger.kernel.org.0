Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B17B48417D
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbiADMH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiADMH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:07:57 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22695C061761;
        Tue,  4 Jan 2022 04:07:57 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n4ibY-0000Lk-EY; Tue, 04 Jan 2022 13:07:52 +0100
Date:   Tue, 4 Jan 2022 12:07:46 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v12 3/3] net: ethernet: mtk_eth_soc: implement Clause 45 MDIO
 access
Message-ID: <YdQ4kvyhR0kZ2GDL@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement read and write access to IEEE 802.3 Clause 45 Ethernet
phy registers while making use of new mdiobus_c45_regad and
mdiobus_c45_devad helpers.

Tested on the Ubiquiti UniFi 6 LR access point featuring
MediaTek MT7622BV WiSoC with Aquantia AQR112C.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v12: unchanged
v11: pass return value of mtk_mdio_wait_busy
v10: unchanged
v9: improved formatting and Cc missing maintainer
v8: switch to bitfield helper macros, incl. newly introduced ones
v7: remove unneeded variables and order OR-ed call parameters
v6: further clean up functions and more cleanly separate patches
v5: fix wrong variable name in first patch covered by follow-up patch
v4: clean-up return values and types, split into two commits
v3: return -1 instead of 0xffff on error in _mtk_mdio_write
v2: use MII_DEVADDR_C45_SHIFT and MII_REGADDR_C45_MASK to extract
    device id and register address. Unify read and write functions to
    have identical types and parameter names where possible as we are
    anyway already replacing both function bodies.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 70 +++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 +
 2 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3809ea6e31ce2..d1f9ea3ec9c0d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -103,13 +103,35 @@ static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
 	if (ret < 0)
 		return ret;
 
-	mtk_w32(eth, PHY_IAC_ACCESS |
-		     PHY_IAC_START_C22 |
-		     PHY_IAC_CMD_WRITE |
-		     PHY_IAC_REG(phy_reg) |
-		     PHY_IAC_ADDR(phy_addr) |
-		     PHY_IAC_DATA(write_data),
-		MTK_PHY_IAC);
+	if (phy_reg & MII_ADDR_C45) {
+		mtk_w32(eth, PHY_IAC_ACCESS |
+			     PHY_IAC_START_C45 |
+			     PHY_IAC_CMD_C45_ADDR |
+			     PHY_IAC_REG(mdiobus_c45_devad(phy_reg)) |
+			     PHY_IAC_ADDR(phy_addr) |
+			     PHY_IAC_DATA(mdiobus_c45_regad(phy_reg)),
+			MTK_PHY_IAC);
+
+		ret = mtk_mdio_busy_wait(eth);
+		if (ret < 0)
+			return ret;
+
+		mtk_w32(eth, PHY_IAC_ACCESS |
+			     PHY_IAC_START_C45 |
+			     PHY_IAC_CMD_WRITE |
+			     PHY_IAC_REG(mdiobus_c45_devad(phy_reg)) |
+			     PHY_IAC_ADDR(phy_addr) |
+			     PHY_IAC_DATA(write_data),
+			MTK_PHY_IAC);
+	} else {
+		mtk_w32(eth, PHY_IAC_ACCESS |
+			     PHY_IAC_START_C22 |
+			     PHY_IAC_CMD_WRITE |
+			     PHY_IAC_REG(phy_reg) |
+			     PHY_IAC_ADDR(phy_addr) |
+			     PHY_IAC_DATA(write_data),
+			MTK_PHY_IAC);
+	}
 
 	ret = mtk_mdio_busy_wait(eth);
 	if (ret < 0)
@@ -126,12 +148,33 @@ static int _mtk_mdio_read(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
 	if (ret < 0)
 		return ret;
 
-	mtk_w32(eth, PHY_IAC_ACCESS |
-		     PHY_IAC_START_C22 |
-		     PHY_IAC_CMD_C22_READ |
-		     PHY_IAC_REG(phy_reg) |
-		     PHY_IAC_ADDR(phy_addr),
-		MTK_PHY_IAC);
+	if (phy_reg & MII_ADDR_C45) {
+		mtk_w32(eth, PHY_IAC_ACCESS |
+			     PHY_IAC_START_C45 |
+			     PHY_IAC_CMD_C45_ADDR |
+			     PHY_IAC_REG(mdiobus_c45_devad(phy_reg)) |
+			     PHY_IAC_ADDR(phy_addr) |
+			     PHY_IAC_DATA(mdiobus_c45_regad(phy_reg)),
+			MTK_PHY_IAC);
+
+		ret = mtk_mdio_busy_wait(eth);
+		if (ret < 0)
+			return ret;
+
+		mtk_w32(eth, PHY_IAC_ACCESS |
+			     PHY_IAC_START_C45 |
+			     PHY_IAC_CMD_C45_READ |
+			     PHY_IAC_REG(mdiobus_c45_devad(phy_reg)) |
+			     PHY_IAC_ADDR(phy_addr),
+			MTK_PHY_IAC);
+	} else {
+		mtk_w32(eth, PHY_IAC_ACCESS |
+			     PHY_IAC_START_C22 |
+			     PHY_IAC_CMD_C22_READ |
+			     PHY_IAC_REG(phy_reg) |
+			     PHY_IAC_ADDR(phy_addr),
+			MTK_PHY_IAC);
+	}
 
 	ret = mtk_mdio_busy_wait(eth);
 	if (ret < 0)
@@ -504,6 +547,7 @@ static int mtk_mdio_init(struct mtk_eth *eth)
 	eth->mii_bus->name = "mdio";
 	eth->mii_bus->read = mtk_mdio_read;
 	eth->mii_bus->write = mtk_mdio_write;
+	eth->mii_bus->probe_capabilities = MDIOBUS_C22_C45;
 	eth->mii_bus->priv = eth;
 	eth->mii_bus->parent = eth->dev;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index f2d90639d7ed1..c9d42be314b5a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -346,9 +346,12 @@
 #define PHY_IAC_ADDR_MASK	GENMASK(24, 20)
 #define PHY_IAC_ADDR(x)		FIELD_PREP(PHY_IAC_ADDR_MASK, (x))
 #define PHY_IAC_CMD_MASK	GENMASK(19, 18)
+#define PHY_IAC_CMD_C45_ADDR	FIELD_PREP(PHY_IAC_CMD_MASK, 0)
 #define PHY_IAC_CMD_WRITE	FIELD_PREP(PHY_IAC_CMD_MASK, 1)
 #define PHY_IAC_CMD_C22_READ	FIELD_PREP(PHY_IAC_CMD_MASK, 2)
+#define PHY_IAC_CMD_C45_READ	FIELD_PREP(PHY_IAC_CMD_MASK, 3)
 #define PHY_IAC_START_MASK	GENMASK(17, 16)
+#define PHY_IAC_START_C45	FIELD_PREP(PHY_IAC_START_MASK, 0)
 #define PHY_IAC_START_C22	FIELD_PREP(PHY_IAC_START_MASK, 1)
 #define PHY_IAC_DATA_MASK	GENMASK(15, 0)
 #define PHY_IAC_DATA(x)		FIELD_PREP(PHY_IAC_DATA_MASK, (x))
-- 
2.34.1

