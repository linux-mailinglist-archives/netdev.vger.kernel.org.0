Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C18276F8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbfEWHcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:32:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:36471 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfEWHcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 03:32:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 00:32:17 -0700
X-ExtLoop1: 1
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by fmsmga005.fm.intel.com with ESMTP; 23 May 2019 00:32:13 -0700
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
Subject: [PATCH net-next v2 1/5] net: stmmac: enable clause 45 mdio support
Date:   Thu, 23 May 2019 23:32:43 +0800
Message-Id: <1558625567-21653-2-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558625567-21653-1-git-send-email-weifeng.voon@intel.com>
References: <1558625567-21653-1-git-send-email-weifeng.voon@intel.com>
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
Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 40 ++++++++++++++++++-----
 include/linux/phy.h                               |  2 ++
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index bdd351597b55..761caaeb3da1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -34,11 +34,27 @@
 
 #define MII_BUSY 0x00000001
 #define MII_WRITE 0x00000002
+#define MII_DATA_MASK GENMASK(15, 0)
 
 /* GMAC4 defines */
 #define MII_GMAC4_GOC_SHIFT		2
+#define MII_GMAC4_REG_ADDR_SHIFT	16
 #define MII_GMAC4_WRITE			(1 << MII_GMAC4_GOC_SHIFT)
 #define MII_GMAC4_READ			(3 << MII_GMAC4_GOC_SHIFT)
+#define MII_GMAC4_C45E			BIT(1)
+
+static void stmmac_mdio_c45_setup(struct stmmac_priv *priv, int phyreg,
+				  u32 *val, u32 *data)
+{
+	unsigned int reg_mask = priv->hw->mii.reg_mask;
+	unsigned int reg_shift = priv->hw->mii.reg_shift;
+
+	*val |= MII_GMAC4_C45E;
+	*val &= ~reg_mask;
+	*val |= ((phyreg >> MII_DEVADDR_C45_SHIFT) << reg_shift) & reg_mask;
+
+	*data |= (phyreg & MII_REGADDR_C45_MASK) << MII_GMAC4_REG_ADDR_SHIFT;
+}
 
 /* XGMAC defines */
 #define MII_XGMAC_SADDR			BIT(18)
@@ -165,22 +181,26 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
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
+		if (phyreg & MII_ADDR_C45)
+			stmmac_mdio_c45_setup(priv, phyreg, &value, &data);
+	}
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
 			       100, 10000))
 		return -EBUSY;
 
+	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
@@ -188,7 +208,7 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 		return -EBUSY;
 
 	/* Read the data from the MII data register */
-	data = (int)readl(priv->ioaddr + mii_data);
+	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
 
 	return data;
 }
@@ -208,8 +228,9 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
-	u32 v;
 	u32 value = MII_BUSY;
+	int data = phydata;
+	u32 v;
 
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
@@ -217,10 +238,13 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	if (priv->plat->has_gmac4)
+	if (priv->plat->has_gmac4) {
 		value |= MII_GMAC4_WRITE;
-	else
+		if (phyreg & MII_ADDR_C45)
+			stmmac_mdio_c45_setup(priv, phyreg, &value, &data);
+	} else {
 		value |= MII_WRITE;
+	}
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
@@ -228,7 +252,7 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 		return -EBUSY;
 
 	/* Set the MII address register to write */
-	writel(phydata, priv->ioaddr + mii_data);
+	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	/* Wait until any existing MII operation is complete */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 073fb151b5a9..d3daac8ec686 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -198,6 +198,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 /* Or MII_ADDR_C45 into regnum for read/write on mii_bus to enable the 21 bit
    IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips. */
 #define MII_ADDR_C45 (1<<30)
+#define MII_DEVADDR_C45_SHIFT	16
+#define MII_REGADDR_C45_MASK	GENMASK(15, 0)
 
 struct device;
 struct phylink;
-- 
1.9.1

