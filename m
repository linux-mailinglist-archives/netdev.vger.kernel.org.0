Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C21E9EFB
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfJ3P3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:29:02 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:39098 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727039AbfJ3P3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:29:01 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 39569C0DE6;
        Wed, 30 Oct 2019 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572449340; bh=IBTxSbYOJI2JqoFiSiKIKTl72eA3gBkCoN+l7ptVNIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=B5mKN+7R3KLvrfqfPcW0EF3dBnqKZqg7X9MCt3cPDw5eCYWCrYEZo2/L7sciMerX8
         vxpY1YkAwWykYPBJw+tR/bBYBJKFrBkvmACNTIZQgoUwri5GLT9x57R/TLY11Ic9wu
         rcu+2tfOcGGTdzyBU69C8Y7y69v+iemQIpgoTEVzq5kngUjIESpDZ7oyRs4XmaHS8C
         +Bb8ViqCz6RdrrTxuuLxmQYq27kXHDBrRJPuDWkuwozXuSJJeRLDr5oh092lIm5cTb
         VqpzF2D2IEJhldNqaf7Pl+TtDVHAwQMWUbL+NTBEJTE+xCCnQAGnFa5iqAJSLTnDhA
         77IYmglHi+05A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id CBD3BA0060;
        Wed, 30 Oct 2019 15:28:58 +0000 (UTC)
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
Subject: [PATCH net-next 2/3] net: stmmac: xgmac: Add C45 PHY support in the MDIO callbacks
Date:   Wed, 30 Oct 2019 16:28:49 +0100
Message-Id: <444208cef341686bcf35f8361f409467f539c73b.1572449009.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572449009.git.Jose.Abreu@synopsys.com>
References: <cover.1572449009.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572449009.git.Jose.Abreu@synopsys.com>
References: <cover.1572449009.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support for C45 PHYs in the MDIO callbacks for XGMAC. This was
tested using Synopsys DesignWare XPCS.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 47 +++++++++++++++++++++--
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 40c42637ad75..143bffd28acf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -41,6 +41,29 @@
 #define MII_XGMAC_BUSY			BIT(22)
 #define MII_XGMAC_MAX_C22ADDR		3
 #define MII_XGMAC_C22P_MASK		GENMASK(MII_XGMAC_MAX_C22ADDR, 0)
+#define MII_XGMAC_PA_SHIFT		16
+#define MII_XGMAC_DA_SHIFT		21
+
+static int stmmac_xgmac2_c45_format(struct stmmac_priv *priv, int phyaddr,
+				    int phyreg, u32 *hw_addr)
+{
+	unsigned int mii_data = priv->hw->mii.data;
+	u32 tmp;
+
+	/* Wait until any existing MII operation is complete */
+	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
+		return -EBUSY;
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
@@ -76,16 +99,22 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	int ret;
 
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
@@ -116,16 +145,22 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 	int ret;
 
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
@@ -363,6 +398,10 @@ int stmmac_mdio_register(struct net_device *ndev)
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

