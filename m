Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C419E48030D
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 18:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhL0RwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 12:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhL0RwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 12:52:15 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04E1C06173E;
        Mon, 27 Dec 2021 09:52:15 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n1uAP-0000AE-5J; Mon, 27 Dec 2021 18:52:13 +0100
Date:   Mon, 27 Dec 2021 17:52:07 +0000
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
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 2/2] net: ethernet: mtk_eth_soc: implement Clause 45 MDIO
 access
Message-ID: <Ycn9R+Cgu/cxGWvc@makrotopia.org>
References: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
 <YcnlMtninjjjPhjI@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
 <YcnlMtninjjjPhjI@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement read and write access to IEEE 802.3 Clause 45 Ethernet
phy registers.
Tested on the Ubiquiti UniFi 6 LR access point featuring
MediaTek MT7622BV WiSoC with Aquantia AQR112C.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v4: clean-up return values and types, split into two commits
v3: return -1 instead of 0xffff on error in _mtk_mdio_write
v2: use MII_DEVADDR_C45_SHIFT and MII_REGADDR_C45_MASK to extract
    device id and register address. Unify read and write functions to
    have identical types and parameter names where possible as we are
    anyway already replacing both function bodies.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 60 +++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  3 ++
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 0bf8d0a3b1781..67e3ffdf73cce 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -102,10 +102,30 @@ static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
 
 	write_data &= 0xffff;
 
-	mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_WRITE |
-		(phy_register << PHY_IAC_REG_SHIFT) |
-		(phy_addr << PHY_IAC_ADDR_SHIFT) | write_data,
-		MTK_PHY_IAC);
+	if (phy_reg & MII_ADDR_C45) {
+		u8 dev_num = (phy_reg >> MII_DEVADDR_C45_SHIFT) & GENMASK(4, 0);
+		u16 reg = (u16)(phy_reg & MII_REGADDR_C45_MASK);
+
+		mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START_C45 | PHY_IAC_SET_ADDR |
+			(phy_addr << PHY_IAC_ADDR_SHIFT) |
+			(dev_num << PHY_IAC_REG_SHIFT) |
+			reg,
+			MTK_PHY_IAC);
+
+		if (mtk_mdio_busy_wait(eth))
+			return -EBUSY;
+
+		mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START_C45 | PHY_IAC_WRITE |
+			(phy_addr << PHY_IAC_ADDR_SHIFT) |
+			(dev_num << PHY_IAC_REG_SHIFT) |
+			write_data,
+			MTK_PHY_IAC);
+	} else {
+		mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_WRITE |
+			(phy_reg << PHY_IAC_REG_SHIFT) |
+			(phy_addr << PHY_IAC_ADDR_SHIFT) | write_data,
+			MTK_PHY_IAC);
+	}
 
 	if (mtk_mdio_busy_wait(eth))
 		return -EBUSY;
@@ -113,17 +133,36 @@ static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
 	return 0;
 }
 
-static int _mtk_mdio_read(struct mtk_eth *eth, int phy_addr, int phy_reg)
+static int _mtk_mdio_read(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
 {
-	u32 d;
+	int d;
 
 	if (mtk_mdio_busy_wait(eth))
 		return -EBUSY;
 
-	mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_READ |
-		(phy_reg << PHY_IAC_REG_SHIFT) |
-		(phy_addr << PHY_IAC_ADDR_SHIFT),
-		MTK_PHY_IAC);
+	if (phy_reg & MII_ADDR_C45) {
+		u8 dev_num = (phy_reg >> MII_DEVADDR_C45_SHIFT) & GENMASK(4, 0);
+		u16 reg = (u16)(phy_reg & MII_REGADDR_C45_MASK);
+
+		mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START_C45 | PHY_IAC_SET_ADDR |
+			(phy_addr << PHY_IAC_ADDR_SHIFT) |
+			(dev_num << PHY_IAC_REG_SHIFT) |
+			reg,
+			MTK_PHY_IAC);
+
+		if (mtk_mdio_busy_wait(eth))
+			return -EBUSY;
+
+		mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START_C45 | PHY_IAC_READ_C45 |
+			(phy_addr << PHY_IAC_ADDR_SHIFT) |
+			(dev_num << PHY_IAC_REG_SHIFT),
+			MTK_PHY_IAC);
+	} else {
+		mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_READ |
+			(phy_reg << PHY_IAC_REG_SHIFT) |
+			(phy_addr << PHY_IAC_ADDR_SHIFT),
+			MTK_PHY_IAC);
+	}
 
 	if (mtk_mdio_busy_wait(eth))
 		return -EBUSY;
@@ -497,6 +536,7 @@ static int mtk_mdio_init(struct mtk_eth *eth)
 	eth->mii_bus->name = "mdio";
 	eth->mii_bus->read = mtk_mdio_read;
 	eth->mii_bus->write = mtk_mdio_write;
+	eth->mii_bus->probe_capabilities = MDIOBUS_C22_C45;
 	eth->mii_bus->priv = eth;
 	eth->mii_bus->parent = eth->dev;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 5ef70dd8b49c6..b73d8adc9d24c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -341,9 +341,12 @@
 /* PHY Indirect Access Control registers */
 #define MTK_PHY_IAC		0x10004
 #define PHY_IAC_ACCESS		BIT(31)
+#define PHY_IAC_SET_ADDR	0
 #define PHY_IAC_READ		BIT(19)
+#define PHY_IAC_READ_C45	(BIT(18) | BIT(19))
 #define PHY_IAC_WRITE		BIT(18)
 #define PHY_IAC_START		BIT(16)
+#define PHY_IAC_START_C45	0
 #define PHY_IAC_ADDR_SHIFT	20
 #define PHY_IAC_REG_SHIFT	25
 #define PHY_IAC_TIMEOUT		HZ
-- 
2.34.1

