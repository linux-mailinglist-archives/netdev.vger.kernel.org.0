Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C79482BBB
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 16:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiABPt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 10:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiABPtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 10:49:24 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC75C061761;
        Sun,  2 Jan 2022 07:49:24 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n436o-00018x-8a; Sun, 02 Jan 2022 16:49:22 +0100
Date:   Sun, 2 Jan 2022 15:49:16 +0000
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
        Andrew Lunn <andrew@lunn.ch>, Michael Lee <igvtee@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v10 3/3] net: ethernet: mtk_eth_soc: implement Clause 45 MDIO
 access
Message-ID: <YdHJfPVBHUlIs3Yp@makrotopia.org>
References: <YdCNZh5PsBwbfMtp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdCNZh5PsBwbfMtp@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement read and write access to IEEE 802.3 Clause 45 Ethernet
phy registers while making use of new mdiobus_c45_regad and
mdiobus_c45_devad helpers.
Improve readability by using bitfield helper macros which makes the
register definitions in the header file resemble the exact values
stated in the Reference Manual.

Tested on the Ubiquiti UniFi 6 LR access point featuring
MediaTek MT7622BV WiSoC with Aquantia AQR112C.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
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

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 68 +++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 +
 2 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 0806688567d8b..786f3d63ec78c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -100,13 +100,34 @@ static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
 	if (mtk_mdio_busy_wait(eth))
 		return -EBUSY;
 
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
+		if (mtk_mdio_busy_wait(eth))
+			return -EBUSY;
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
 
 	if (mtk_mdio_busy_wait(eth))
 		return -EBUSY;
@@ -119,12 +140,32 @@ static int _mtk_mdio_read(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
 	if (mtk_mdio_busy_wait(eth))
 		return -EBUSY;
 
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
+		if (mtk_mdio_busy_wait(eth))
+			return -EBUSY;
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
 
 	if (mtk_mdio_busy_wait(eth))
 		return -EBUSY;
@@ -496,6 +537,7 @@ static int mtk_mdio_init(struct mtk_eth *eth)
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

