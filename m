Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B979F60323
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 11:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfGEJdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 05:33:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:53937 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbfGEJdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 05:33:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jul 2019 02:33:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,454,1557212400"; 
   d="scan'208";a="167014252"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga003.jf.intel.com with ESMTP; 05 Jul 2019 02:33:28 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v2 net-next] net: stmmac: enable clause 45 mdio support
Date:   Sat,  6 Jul 2019 01:33:27 +0800
Message-Id: <1562348007-12263-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kweh Hock Leong <hock.leong.kweh@intel.com>

DWMAC4 is capable to support clause 45 mdio communication.
This patch enable the feature on stmmac_mdio_write() and
stmmac_mdio_read() by following phy_write_mmd() and
phy_read_mmd() mdiobus read write implementation format.

Reviewed-by: Li, Yifan <yifan2.li@intel.com>
Signed-off-by: Kweh Hock Leong <hock.leong.kweh@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 18cadf0b0d66..4304c1abc5d1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -24,11 +24,14 @@
 
 #define MII_BUSY 0x00000001
 #define MII_WRITE 0x00000002
+#define MII_DATA_MASK GENMASK(15, 0)
 
 /* GMAC4 defines */
 #define MII_GMAC4_GOC_SHIFT		2
+#define MII_GMAC4_REG_ADDR_SHIFT	16
 #define MII_GMAC4_WRITE			(1 << MII_GMAC4_GOC_SHIFT)
 #define MII_GMAC4_READ			(3 << MII_GMAC4_GOC_SHIFT)
+#define MII_GMAC4_C45E			BIT(1)
 
 /* XGMAC defines */
 #define MII_XGMAC_SADDR			BIT(18)
@@ -155,22 +158,34 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
-	u32 v;
-	int data;
 	u32 value = MII_BUSY;
+	int data = 0;
+	u32 v;
 
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	if (priv->plat->has_gmac4)
+	if (priv->plat->has_gmac4) {
 		value |= MII_GMAC4_READ;
+		if (phyreg & MII_ADDR_C45) {
+			value |= MII_GMAC4_C45E;
+			value &= ~priv->hw->mii.reg_mask;
+			value |= ((phyreg >> MII_DEVADDR_C45_SHIFT) <<
+			       priv->hw->mii.reg_shift) &
+			       priv->hw->mii.reg_mask;
+
+			data |= (phyreg & MII_REGADDR_C45_MASK) <<
+				MII_GMAC4_REG_ADDR_SHIFT;
+		}
+	}
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
 			       100, 10000))
 		return -EBUSY;
 
+	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
@@ -178,7 +193,7 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 		return -EBUSY;
 
 	/* Read the data from the MII data register */
-	data = (int)readl(priv->ioaddr + mii_data);
+	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
 
 	return data;
 }
@@ -198,8 +213,9 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
-	u32 v;
 	u32 value = MII_BUSY;
+	int data = phydata;
+	u32 v;
 
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
@@ -207,10 +223,21 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	if (priv->plat->has_gmac4)
+	if (priv->plat->has_gmac4) {
 		value |= MII_GMAC4_WRITE;
-	else
+		if (phyreg & MII_ADDR_C45) {
+			value |= MII_GMAC4_C45E;
+			value &= ~priv->hw->mii.reg_mask;
+			value |= ((phyreg >> MII_DEVADDR_C45_SHIFT) <<
+			       priv->hw->mii.reg_shift) &
+			       priv->hw->mii.reg_mask;
+
+			data |= (phyreg & MII_REGADDR_C45_MASK) <<
+				MII_GMAC4_REG_ADDR_SHIFT;
+		}
+	} else {
 		value |= MII_WRITE;
+	}
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
@@ -218,7 +245,7 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 		return -EBUSY;
 
 	/* Set the MII address register to write */
-	writel(phydata, priv->ioaddr + mii_data);
+	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	/* Wait until any existing MII operation is complete */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index d0af7d37fdf9..1739c6dc470e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -195,6 +195,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 /* Or MII_ADDR_C45 into regnum for read/write on mii_bus to enable the 21 bit
    IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips. */
 #define MII_ADDR_C45 (1<<30)
+#define MII_DEVADDR_C45_SHIFT	16
+#define MII_REGADDR_C45_MASK	GENMASK(15, 0)
 
 struct device;
 struct phylink;
--
Changelog v2
*Merge c45_setup() into stmmac_mdio_read() and stmmac_mdio_write()
to increase readability
1.9.1

