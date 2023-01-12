Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C7F66790B
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbjALPXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjALPWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:22:55 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFDB5F91E;
        Thu, 12 Jan 2023 07:15:29 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 3F45B16D0;
        Thu, 12 Jan 2023 16:15:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673536527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GHiclTSJcQpEuXc7UZJCs+DUc7vMe7Q2Zx9qkP/i6VE=;
        b=v2xaDV+uTTGZtERRTebXFr9t/CTFUCCN4cIyZ36GhKO6lzWaiK6KNnXMqdsfJ6FC6hOlr1
        cMQIaSkUzmLe05Kkra3vSNOCD67P5B0c+FnQM71eVfwP7LAYft7Za0E8e4hsHFVeP+D33b
        gVw0+UOT+g2TEcxMRSCIFZVzNPSiMMjoN4Aoogtd/83d4apM4H9AwxC2+Ga5Mq0ZPYezqg
        hHSwR+rwZXD6/B8nHnzpdi2tGbZSnRhe5OoWjgWV0B3zyVaFydCpBEHcdhFwiIKoJvDrR0
        ZYu9qvGBlRIPTgTMH8KuVwtuD81vpI44p7MTkR7mVtmCNV1iMzWZYpVoIrIs0Q==
From:   Michael Walle <michael@walle.cc>
Date:   Thu, 12 Jan 2023 16:15:14 +0100
Subject: [PATCH net-next 08/10] net: stmmac: Separate C22 and C45 transactions
 for xgmac2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-net-next-c45-seperation-part-2-v1-8-5eeaae931526@walle.cc>
References: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
In-Reply-To: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Li Yang <leoyang.li@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linuxppc-dev@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The stmicro stmmac xgmac2 MDIO bus driver can perform both C22 and C45
transfers. Create separate functions for each and register the C45
versions using the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 131 +++++++++++++---------
 1 file changed, 81 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 5f177ea80725..4836a40df1af 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -45,8 +45,8 @@
 #define MII_XGMAC_PA_SHIFT		16
 #define MII_XGMAC_DA_SHIFT		21
 
-static int stmmac_xgmac2_c45_format(struct stmmac_priv *priv, int phyaddr,
-				    int phyreg, u32 *hw_addr)
+static void stmmac_xgmac2_c45_format(struct stmmac_priv *priv, int phyaddr,
+				     int devad, int phyreg, u32 *hw_addr)
 {
 	u32 tmp;
 
@@ -56,19 +56,14 @@ static int stmmac_xgmac2_c45_format(struct stmmac_priv *priv, int phyaddr,
 	writel(tmp, priv->ioaddr + XGMAC_MDIO_C22P);
 
 	*hw_addr = (phyaddr << MII_XGMAC_PA_SHIFT) | (phyreg & 0xffff);
-	*hw_addr |= (phyreg >> MII_DEVADDR_C45_SHIFT) << MII_XGMAC_DA_SHIFT;
-	return 0;
+	*hw_addr |= devad << MII_XGMAC_DA_SHIFT;
 }
 
-static int stmmac_xgmac2_c22_format(struct stmmac_priv *priv, int phyaddr,
-				    int phyreg, u32 *hw_addr)
+static void stmmac_xgmac2_c22_format(struct stmmac_priv *priv, int phyaddr,
+				     int phyreg, u32 *hw_addr)
 {
 	u32 tmp;
 
-	/* HW does not support C22 addr >= 4 */
-	if (phyaddr > MII_XGMAC_MAX_C22ADDR)
-		return -ENODEV;
-
 	/* Set port as Clause 22 */
 	tmp = readl(priv->ioaddr + XGMAC_MDIO_C22P);
 	tmp &= ~MII_XGMAC_C22P_MASK;
@@ -76,16 +71,14 @@ static int stmmac_xgmac2_c22_format(struct stmmac_priv *priv, int phyaddr,
 	writel(tmp, priv->ioaddr + XGMAC_MDIO_C22P);
 
 	*hw_addr = (phyaddr << MII_XGMAC_PA_SHIFT) | (phyreg & 0x1f);
-	return 0;
 }
 
-static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
+static int stmmac_xgmac2_mdio_read(struct stmmac_priv *priv, u32 addr,
+				   u32 value)
 {
-	struct net_device *ndev = bus->priv;
-	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
-	u32 tmp, addr, value = MII_XGMAC_BUSY;
+	u32 tmp;
 	int ret;
 
 	ret = pm_runtime_resume_and_get(priv->device);
@@ -99,20 +92,6 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 		goto err_disable_clks;
 	}
 
-	if (phyreg & MII_ADDR_C45) {
-		phyreg &= ~MII_ADDR_C45;
-
-		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
-		if (ret)
-			goto err_disable_clks;
-	} else {
-		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
-		if (ret)
-			goto err_disable_clks;
-
-		value |= MII_XGMAC_SADDR;
-	}
-
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
 	value |= MII_XGMAC_READ;
@@ -144,14 +123,44 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	return ret;
 }
 
-static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
-				    int phyreg, u16 phydata)
+static int stmmac_xgmac2_mdio_read_c22(struct mii_bus *bus, int phyaddr,
+				       int phyreg)
 {
 	struct net_device *ndev = bus->priv;
-	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct stmmac_priv *priv;
+	u32 addr;
+
+	priv = netdev_priv(ndev);
+
+	/* HW does not support C22 addr >= 4 */
+	if (phyaddr > MII_XGMAC_MAX_C22ADDR)
+		return -ENODEV;
+
+	stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
+
+	return stmmac_xgmac2_mdio_read(priv, addr, MII_XGMAC_BUSY);
+}
+
+static int stmmac_xgmac2_mdio_read_c45(struct mii_bus *bus, int phyaddr,
+				       int devad, int phyreg)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv;
+	u32 addr;
+
+	priv = netdev_priv(ndev);
+
+	stmmac_xgmac2_c45_format(priv, phyaddr, devad, phyreg, &addr);
+
+	return stmmac_xgmac2_mdio_read(priv, addr, MII_XGMAC_BUSY);
+}
+
+static int stmmac_xgmac2_mdio_write(struct stmmac_priv *priv, u32 addr,
+				    u32 value, u16 phydata)
+{
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
-	u32 addr, tmp, value = MII_XGMAC_BUSY;
+	u32 tmp;
 	int ret;
 
 	ret = pm_runtime_resume_and_get(priv->device);
@@ -165,20 +174,6 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 		goto err_disable_clks;
 	}
 
-	if (phyreg & MII_ADDR_C45) {
-		phyreg &= ~MII_ADDR_C45;
-
-		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
-		if (ret)
-			goto err_disable_clks;
-	} else {
-		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
-		if (ret)
-			goto err_disable_clks;
-
-		value |= MII_XGMAC_SADDR;
-	}
-
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
 	value |= phydata;
@@ -205,6 +200,40 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 	return ret;
 }
 
+static int stmmac_xgmac2_mdio_write_c22(struct mii_bus *bus, int phyaddr,
+					int phyreg, u16 phydata)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv;
+	u32 addr;
+
+	priv = netdev_priv(ndev);
+
+	/* HW does not support C22 addr >= 4 */
+	if (phyaddr > MII_XGMAC_MAX_C22ADDR)
+		return -ENODEV;
+
+	stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
+
+	return stmmac_xgmac2_mdio_write(priv, addr,
+					MII_XGMAC_BUSY | MII_XGMAC_SADDR, phydata);
+}
+
+static int stmmac_xgmac2_mdio_write_c45(struct mii_bus *bus, int phyaddr,
+					int devad, int phyreg, u16 phydata)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv;
+	u32 addr;
+
+	priv = netdev_priv(ndev);
+
+	stmmac_xgmac2_c45_format(priv, phyaddr, devad, phyreg, &addr);
+
+	return stmmac_xgmac2_mdio_write(priv, addr, MII_XGMAC_BUSY,
+					phydata);
+}
+
 /**
  * stmmac_mdio_read
  * @bus: points to the mii_bus structure
@@ -457,8 +486,10 @@ int stmmac_mdio_register(struct net_device *ndev)
 		new_bus->probe_capabilities = MDIOBUS_C22_C45;
 
 	if (priv->plat->has_xgmac) {
-		new_bus->read = &stmmac_xgmac2_mdio_read;
-		new_bus->write = &stmmac_xgmac2_mdio_write;
+		new_bus->read = &stmmac_xgmac2_mdio_read_c22;
+		new_bus->write = &stmmac_xgmac2_mdio_write_c22;
+		new_bus->read_c45 = &stmmac_xgmac2_mdio_read_c45;
+		new_bus->write_c45 = &stmmac_xgmac2_mdio_write_c45;
 
 		/* Right now only C22 phys are supported */
 		max_addr = MII_XGMAC_MAX_C22ADDR + 1;
@@ -490,7 +521,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 	/* Looks like we need a dummy read for XGMAC only and C45 PHYs */
 	if (priv->plat->has_xgmac)
-		stmmac_xgmac2_mdio_read(new_bus, 0, MII_ADDR_C45);
+		stmmac_xgmac2_mdio_read_c45(new_bus, 0, 0, 0);
 
 	/* If fixed-link is set, skip PHY scanning */
 	if (!fwnode)

-- 
2.30.2
