Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B67DC01
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 08:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfD2Gfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 02:35:46 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:41973 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726137AbfD2Gfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 02:35:40 -0400
X-UUID: 88c07c6299c34c1884c22a856f736142-20190429
X-UUID: 88c07c6299c34c1884c22a856f736142-20190429
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1974388627; Mon, 29 Apr 2019 14:35:32 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 29 Apr 2019 14:35:30 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 29 Apr 2019 14:35:30 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>
Subject: [PATCH 2/2] net-next: stmmac: add mdio clause 45 access from mac device for dwmac4
Date:   Mon, 29 Apr 2019 14:35:24 +0800
Message-ID: <1556519724-1576-3-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1556519724-1576-1-git-send-email-biao.huang@mediatek.com>
References: <1556519724-1576-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add clause 45 mdio read and write from mac device for dwmac4.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |   11 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |    3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |  167 +++++++++++++++++++--
 3 files changed, 165 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 709dcec..06573b3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -410,12 +410,15 @@ struct mac_link {
 struct mii_regs {
 	unsigned int addr;	/* MII Address */
 	unsigned int data;	/* MII Data */
-	unsigned int addr_shift;	/* MII address shift */
-	unsigned int reg_shift;		/* MII reg shift */
-	unsigned int addr_mask;		/* MII address mask */
-	unsigned int reg_mask;		/* MII reg mask */
+	unsigned int addr_shift;	/* PHY address shift */
+	unsigned int cl45_reg_shift;	/* CL45 reg address shift */
+	unsigned int reg_shift;		/* CL22 reg/CL45 dev shift */
+	unsigned int addr_mask;		/* PHY address mask */
+	unsigned int cl45_reg_mask;	/* CL45 reg mask */
+	unsigned int reg_mask;		/* CL22 reg/CL45 dev mask */
 	unsigned int clk_csr_shift;
 	unsigned int clk_csr_mask;
+	unsigned int cl45_en;	/* CL45 Enable*/
 };
 
 struct mac_device_info {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 2a41c64..1ca03f9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -835,6 +835,9 @@ int dwmac4_setup(struct stmmac_priv *priv)
 	mac->mii.reg_mask = GENMASK(20, 16);
 	mac->mii.clk_csr_shift = 8;
 	mac->mii.clk_csr_mask = GENMASK(11, 8);
+	mac->mii.cl45_reg_shift = 16;
+	mac->mii.cl45_reg_mask = GENMASK(31, 16);
+	mac->mii.cl45_en = BIT(1);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index bdd3515..a70c967 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -150,16 +150,16 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 }
 
 /**
- * stmmac_mdio_read
+ * stmmac_c22_read
  * @bus: points to the mii_bus structure
- * @phyaddr: MII addr
- * @phyreg: MII reg
- * Description: it reads data from the MII register from within the phy device.
+ * @phyaddr: clause 22 phy address
+ * @phyreg: clause 22 phy register
+ * Description: it reads data from the MII register follow clause 22.
  * For the 7111 GMAC, we must set the bit 0 in the MII address register while
  * accessing the PHY registers.
  * Fortunately, it seems this has no drawback for the 7109 MAC.
  */
-static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
+static int stmmac_c22_read(struct mii_bus *bus, int phyaddr, int phyreg)
 {
 	struct net_device *ndev = bus->priv;
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -194,15 +194,15 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 }
 
 /**
- * stmmac_mdio_write
+ * stmmac_c22_write
  * @bus: points to the mii_bus structure
- * @phyaddr: MII addr
- * @phyreg: MII reg
- * @phydata: phy data
- * Description: it writes the data into the MII register from within the device.
+ * @phyaddr: clause-22 phy address
+ * @phyreg: clause-22 phy register
+ * @phydata: clause-22 phy data
+ * Description: it writes the data into the MII register follow clause 22.
  */
-static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
-			     u16 phydata)
+static int stmmac_c22_write(struct mii_bus *bus, int phyaddr, int phyreg,
+			    u16 phydata)
 {
 	struct net_device *ndev = bus->priv;
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -237,6 +237,149 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 }
 
 /**
+ * stmmac_c45_read
+ * @bus: points to the mii_bus structure
+ * @phyaddr: clause-45 phy address
+ * @devad: clause-45 device address
+ * @prtad: clause-45 register address
+ * @phydata: phy data
+ * Description: it reads the data from the  MII register follow clause 45.
+ */
+static int stmmac_c45_read(struct mii_bus *bus, int phyaddr,
+			   int devad, int prtad)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	unsigned int mii_address = priv->hw->mii.addr;
+	unsigned int mii_data = priv->hw->mii.data;
+	u32 v, value;
+	int data;
+
+	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+			       100, 10000))
+		return -EIO;
+
+	value = 0;
+	value |= (prtad << priv->hw->mii.cl45_reg_shift)
+			& priv->hw->mii.cl45_reg_mask;
+	writel(value, priv->ioaddr + mii_data);
+
+	/* delay 2ms to avoid error value of get_phy_c45_devs_in_pkg */
+	mdelay(2);
+
+	value = MII_BUSY;
+	value |= (phyaddr << priv->hw->mii.addr_shift)
+		& priv->hw->mii.addr_mask;
+	value |= (devad << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
+	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
+		& priv->hw->mii.clk_csr_mask;
+	if (priv->plat->has_gmac4) {
+		value |= MII_GMAC4_READ;
+		value |= priv->hw->mii.cl45_en;
+	}
+	writel(value, priv->ioaddr + mii_address);
+
+	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+			       100, 10000))
+		return -EIO;
+
+	/* Read the data from the MII data register */
+	data = (int)(readl(priv->ioaddr + mii_data) & 0xffff);
+
+	return data;
+}
+
+/**
+ * stmmac_c45_write
+ * @bus: points to the mii_bus structure
+ * @phyaddr: clause-45 phy address
+ * @devad: clause-45 device address
+ * @prtad: clause-45 register address
+ * @phydata: phy data
+ * Description: it writes the data into the MII register follow clause 45.
+ */
+static int stmmac_c45_write(struct mii_bus *bus, int phyaddr, int devad,
+			    int prtad, u16 phydata)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	unsigned int mii_address = priv->hw->mii.addr;
+	unsigned int mii_data = priv->hw->mii.data;
+	u32 v, value;
+
+	/* Wait until any existing MII operation is complete */
+	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+			       100, 10000))
+		return -EIO;
+
+	value = phydata;
+	value |= (prtad << priv->hw->mii.cl45_reg_shift) &
+		 priv->hw->mii.cl45_reg_mask;
+	writel(value, priv->ioaddr + mii_data);
+
+	mdelay(2);
+
+	value = MII_BUSY;
+	value |= (phyaddr << priv->hw->mii.addr_shift) &
+		 priv->hw->mii.addr_mask;
+	value |= (devad << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
+	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift) &
+		 priv->hw->mii.clk_csr_mask;
+
+	if (priv->plat->has_gmac4) {
+		value |= MII_GMAC4_WRITE;
+		value |= priv->hw->mii.cl45_en;
+	}
+	writel(value, priv->ioaddr + mii_address);
+
+	/* Wait until any existing MII operation is complete */
+	return readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+				  100, 10000);
+}
+
+/**
+ * stmmac_mdio_read
+ * @bus: points to the mii_bus structure
+ * @phyaddr: MII addr
+ * @phyreg: MII reg
+ * Description: it reads data from the MII register from within the phy device.
+ */
+static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
+{
+	if (phyreg & MII_ADDR_C45) {
+		int devad, prtad;
+
+		devad = (phyreg >> 16) & 0x1f;
+		prtad = phyreg & 0xffff;
+		return stmmac_c45_read(bus, phyaddr, devad, prtad);
+	} else {
+		return stmmac_c22_read(bus, phyaddr, phyreg);
+	}
+}
+
+/**
+ * stmmac_mdio_write
+ * @bus: points to the mii_bus structure
+ * @phyaddr: MII addr
+ * @phyreg: MII reg
+ * @phydata: phy data
+ * Description: it writes the data into the MII register from within the device.
+ */
+static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
+			     u16 phydata)
+{
+	if (phyreg & MII_ADDR_C45) {
+		int devad, prtad;
+
+		devad = (phyreg >> 16) & 0x1f;
+		prtad = phyreg & 0xffff;
+		return stmmac_c45_write(bus, phyaddr, devad, prtad, phydata);
+	} else {
+		return stmmac_c22_write(bus, phyaddr, phyreg, phydata);
+	}
+}
+
+/**
  * stmmac_mdio_reset
  * @bus: points to the mii_bus structure
  * Description: reset the MII bus
-- 
1.7.9.5

