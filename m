Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86959482BB7
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 16:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiABPs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 10:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbiABPs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 10:48:27 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE6EC061761;
        Sun,  2 Jan 2022 07:48:26 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n435s-00017v-Sg; Sun, 02 Jan 2022 16:48:25 +0100
Date:   Sun, 2 Jan 2022 15:48:18 +0000
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
Subject: [PATCH v10 1/3] net: ethernet: mtk_eth_soc: fix return value and
 refactor MDIO ops
Message-ID: <YdHJQhG3vmEJ4ia6@makrotopia.org>
References: <YdCNZh5PsBwbfMtp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdCNZh5PsBwbfMtp@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of returning -1 (-EPERM) when MDIO bus is stuck busy
while writing or 0xffff if it happens while reading, return the
appropriate -EBUSY. Also fix return type to int instead of u32.
Refactor functions to use bitfield helpers instead of having various
masking and shifting constants in the code.

Fixes: 656e705243fd0 ("net-next: mediatek: add support for MT7623 ethernet")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v10: unchanged
v9: improved formatting and Cc missing maintainer
v8: switch to bitfield helper macros
v7: remove unneeded variables
v6: further clean up functions and more cleanly separate patches
v5: fix wrong variable name in first patch covered by follow-up patch
v4: clean-up return values and types, split into two commits
v3: return -1 instead of 0xffff on error in _mtk_mdio_write
v2: use MII_DEVADDR_C45_SHIFT and MII_REGADDR_C45_MASK to extract
    device id and register address. Unify read and write functions to
    have identical types and parameter names where possible as we are
    anyway already replacing both function bodies.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 39 ++++++++++-----------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 16 ++++++---
 2 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bcb91b01e69f5..0806688567d8b 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -94,43 +94,42 @@ static int mtk_mdio_busy_wait(struct mtk_eth *eth)
 	return -1;
 }
 
-static u32 _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr,
-			   u32 phy_register, u32 write_data)
+static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
+			   u32 write_data)
 {
 	if (mtk_mdio_busy_wait(eth))
-		return -1;
-
-	write_data &= 0xffff;
+		return -EBUSY;
 
-	mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_WRITE |
-		(phy_register << PHY_IAC_REG_SHIFT) |
-		(phy_addr << PHY_IAC_ADDR_SHIFT) | write_data,
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		     PHY_IAC_START_C22 |
+		     PHY_IAC_CMD_WRITE |
+		     PHY_IAC_REG(phy_reg) |
+		     PHY_IAC_ADDR(phy_addr) |
+		     PHY_IAC_DATA(write_data),
 		MTK_PHY_IAC);
 
 	if (mtk_mdio_busy_wait(eth))
-		return -1;
+		return -EBUSY;
 
 	return 0;
 }
 
-static u32 _mtk_mdio_read(struct mtk_eth *eth, int phy_addr, int phy_reg)
+static int _mtk_mdio_read(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
 {
-	u32 d;
-
 	if (mtk_mdio_busy_wait(eth))
-		return 0xffff;
+		return -EBUSY;
 
-	mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_READ |
-		(phy_reg << PHY_IAC_REG_SHIFT) |
-		(phy_addr << PHY_IAC_ADDR_SHIFT),
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		     PHY_IAC_START_C22 |
+		     PHY_IAC_CMD_C22_READ |
+		     PHY_IAC_REG(phy_reg) |
+		     PHY_IAC_ADDR(phy_addr),
 		MTK_PHY_IAC);
 
 	if (mtk_mdio_busy_wait(eth))
-		return 0xffff;
-
-	d = mtk_r32(eth, MTK_PHY_IAC) & 0xffff;
+		return -EBUSY;
 
-	return d;
+	return mtk_r32(eth, MTK_PHY_IAC) & PHY_IAC_DATA_MASK;
 }
 
 static int mtk_mdio_write(struct mii_bus *bus, int phy_addr,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 5ef70dd8b49c6..f2d90639d7ed1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -341,11 +341,17 @@
 /* PHY Indirect Access Control registers */
 #define MTK_PHY_IAC		0x10004
 #define PHY_IAC_ACCESS		BIT(31)
-#define PHY_IAC_READ		BIT(19)
-#define PHY_IAC_WRITE		BIT(18)
-#define PHY_IAC_START		BIT(16)
-#define PHY_IAC_ADDR_SHIFT	20
-#define PHY_IAC_REG_SHIFT	25
+#define PHY_IAC_REG_MASK	GENMASK(29, 25)
+#define PHY_IAC_REG(x)		FIELD_PREP(PHY_IAC_REG_MASK, (x))
+#define PHY_IAC_ADDR_MASK	GENMASK(24, 20)
+#define PHY_IAC_ADDR(x)		FIELD_PREP(PHY_IAC_ADDR_MASK, (x))
+#define PHY_IAC_CMD_MASK	GENMASK(19, 18)
+#define PHY_IAC_CMD_WRITE	FIELD_PREP(PHY_IAC_CMD_MASK, 1)
+#define PHY_IAC_CMD_C22_READ	FIELD_PREP(PHY_IAC_CMD_MASK, 2)
+#define PHY_IAC_START_MASK	GENMASK(17, 16)
+#define PHY_IAC_START_C22	FIELD_PREP(PHY_IAC_START_MASK, 1)
+#define PHY_IAC_DATA_MASK	GENMASK(15, 0)
+#define PHY_IAC_DATA(x)		FIELD_PREP(PHY_IAC_DATA_MASK, (x))
 #define PHY_IAC_TIMEOUT		HZ
 
 #define MTK_MAC_MISC		0x1000c
-- 
2.34.1

