Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD30F76BE
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfKKOn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:43:26 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:55146 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbfKKOnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:43:00 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 70FD2C08B9;
        Mon, 11 Nov 2019 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573483379; bh=PrBumZoUjPLZvImVQfgkZgeXA8mceoK9SRTpxM8SziE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=JwYItn5/1rdXTkTz1az/ugnrsf8vdRlf2/7hpku12lv1VoziQ37/VFqYz4rOgHwxI
         4C8KR08RGmnhKQ8LZoyY9liFPIN4vVSTSusFbKSmOe/j+YwVrfggk3bTUBUtpKZKkt
         yIsGzT/mhzTi9uAu8pcshWS7vbkWyCxsD4993TtSKAr2Vm3V1alwP8kHN1KAHyg/2O
         ec6Z3Kg27vChJEzU19mStaMqnz8Gd1VMB6MvnSKtHYL63TzhO9PldEF5lvrxAHt3gI
         KPHLUHzE5p7rVMhqGY7jwUSnvbBYr8iImjwx8JxB6P452t41ewumsnHZDISiLMXXif
         GD1i0FOsXcFfg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id F2C00A024C;
        Mon, 11 Nov 2019 14:42:56 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: stmmac: xgmac: Add C45 PHY support in the MDIO callbacks
Date:   Mon, 11 Nov 2019 15:42:36 +0100
Message-Id: <37a284c640a3e071811fa50838cfe3a319f50fb0.1573482991.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support for C45 PHYs in the MDIO callbacks for XGMAC. This was
tested using Synopsys DesignWare XPCS.

v2:
- Pull out the readl_poll_timeout() calls into common code (Andrew)

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 58 +++++++++++++++++++----
 1 file changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 40c42637ad75..cfe5d8b73142 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -41,20 +41,32 @@
 #define MII_XGMAC_BUSY			BIT(22)
 #define MII_XGMAC_MAX_C22ADDR		3
 #define MII_XGMAC_C22P_MASK		GENMASK(MII_XGMAC_MAX_C22ADDR, 0)
+#define MII_XGMAC_PA_SHIFT		16
+#define MII_XGMAC_DA_SHIFT		21
+
+static int stmmac_xgmac2_c45_format(struct stmmac_priv *priv, int phyaddr,
+				    int phyreg, u32 *hw_addr)
+{
+	u32 tmp;
+
+	/* Set port as Clause 45 */
+	tmp = readl(priv->ioaddr + XGMAC_MDIO_C22P);
+	tmp &= ~BIT(phyaddr);
+	writel(tmp, priv->ioaddr + XGMAC_MDIO_C22P);
+
+	*hw_addr = (phyaddr << MII_XGMAC_PA_SHIFT) | (phyreg & 0xffff);
+	*hw_addr |= (phyreg >> MII_DEVADDR_C45_SHIFT) << MII_XGMAC_DA_SHIFT;
+	return 0;
+}
 
 static int stmmac_xgmac2_c22_format(struct stmmac_priv *priv, int phyaddr,
 				    int phyreg, u32 *hw_addr)
 {
-	unsigned int mii_data = priv->hw->mii.data;
 	u32 tmp;
 
 	/* HW does not support C22 addr >= 4 */
 	if (phyaddr > MII_XGMAC_MAX_C22ADDR)
 		return -ENODEV;
-	/* Wait until any existing MII operation is complete */
-	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
 
 	/* Set port as Clause 22 */
 	tmp = readl(priv->ioaddr + XGMAC_MDIO_C22P);
@@ -62,7 +74,7 @@ static int stmmac_xgmac2_c22_format(struct stmmac_priv *priv, int phyaddr,
 	tmp |= BIT(phyaddr);
 	writel(tmp, priv->ioaddr + XGMAC_MDIO_C22P);
 
-	*hw_addr = (phyaddr << 16) | (phyreg & 0x1f);
+	*hw_addr = (phyaddr << MII_XGMAC_PA_SHIFT) | (phyreg & 0x1f);
 	return 0;
 }
 
@@ -75,17 +87,28 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	u32 tmp, addr, value = MII_XGMAC_BUSY;
 	int ret;
 
+	/* Wait until any existing MII operation is complete */
+	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
+		return -EBUSY;
+
 	if (phyreg & MII_ADDR_C45) {
-		return -EOPNOTSUPP;
+		phyreg &= ~MII_ADDR_C45;
+
+		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
+		if (ret)
+			return ret;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
 			return ret;
+
+		value |= MII_XGMAC_SADDR;
 	}
 
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	value |= MII_XGMAC_SADDR | MII_XGMAC_READ;
+	value |= MII_XGMAC_READ;
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
@@ -115,17 +138,28 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 	u32 addr, tmp, value = MII_XGMAC_BUSY;
 	int ret;
 
+	/* Wait until any existing MII operation is complete */
+	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
+		return -EBUSY;
+
 	if (phyreg & MII_ADDR_C45) {
-		return -EOPNOTSUPP;
+		phyreg &= ~MII_ADDR_C45;
+
+		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
+		if (ret)
+			return ret;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
 			return ret;
+
+		value |= MII_XGMAC_SADDR;
 	}
 
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	value |= phydata | MII_XGMAC_SADDR;
+	value |= phydata;
 	value |= MII_XGMAC_WRITE;
 
 	/* Wait until any existing MII operation is complete */
@@ -363,6 +397,10 @@ int stmmac_mdio_register(struct net_device *ndev)
 		goto bus_register_fail;
 	}
 
+	/* Looks like we need a dummy read for XGMAC only and C45 PHYs */
+	if (priv->plat->has_xgmac)
+		stmmac_xgmac2_mdio_read(new_bus, 0, MII_ADDR_C45);
+
 	if (priv->plat->phy_node || mdio_node)
 		goto bus_register_done;
 
-- 
2.7.4

