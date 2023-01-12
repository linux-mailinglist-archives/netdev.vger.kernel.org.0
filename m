Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FB2667911
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjALPXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbjALPW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:22:56 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFB261470;
        Thu, 12 Jan 2023 07:15:29 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A55EB16E0;
        Thu, 12 Jan 2023 16:15:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673536528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80Acs2WYYpj+pnZcfpfbf8Ss/qQYwMe4n+th9ivgh1s=;
        b=hDUshVdYr6kbwBwi2X0/NSxkLTLHvnXh16ebqQ1vmqVRXwZ3CcRXKv4eaajXkBrbjWgkI8
        wXkzYC3kTJ7ChaPu3pQIgwOAp6VPWhMgJMGVf/Z044FHvUq8wHT7PTehN5IjgRAJmLyF5F
        6J3bt72Qn2h15RChH53HekFdcUPOlAXYu01RE24QvKX5eJw3XHL/1xshGn1nSOCXN0k1EM
        TPUd5KqUBhJM0v0gntCvS3tEsK62VbF0WwQGT5Vc8nANbO5rPL+RtF7PuAAd3HgWOkV2Gz
        A4/bDB7gtm1K+1dzBNzKybu7CiMStl5SpMnnnW7kkJty/ATr1pwPBHG8LtZ/eQ==
From:   Michael Walle <michael@walle.cc>
Date:   Thu, 12 Jan 2023 16:15:15 +0100
Subject: [PATCH net-next 09/10] net: stmmac: Separate C22 and C45 transactions
 for xgmac
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-net-next-c45-seperation-part-2-v1-9-5eeaae931526@walle.cc>
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

The stmmac MDIO bus driver in variant gmac4 can perform both C22 and
C45 transfers. Create separate functions for each and register the
C45 versions using the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 200 +++++++++++++++-------
 1 file changed, 138 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 4836a40df1af..d2cb22f49ce5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -234,8 +234,29 @@ static int stmmac_xgmac2_mdio_write_c45(struct mii_bus *bus, int phyaddr,
 					phydata);
 }
 
+static int stmmac_mdio_read(struct stmmac_priv *priv, int data, u32 value)
+{
+	unsigned int mii_address = priv->hw->mii.addr;
+	unsigned int mii_data = priv->hw->mii.data;
+	u32 v;
+
+	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+			       100, 10000))
+		return -EBUSY;
+
+	writel(data, priv->ioaddr + mii_data);
+	writel(value, priv->ioaddr + mii_address);
+
+	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+			       100, 10000))
+		return -EBUSY;
+
+	/* Read the data from the MII data register */
+	return readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
+}
+
 /**
- * stmmac_mdio_read
+ * stmmac_mdio_read_c22
  * @bus: points to the mii_bus structure
  * @phyaddr: MII addr
  * @phyreg: MII reg
@@ -244,15 +265,12 @@ static int stmmac_xgmac2_mdio_write_c45(struct mii_bus *bus, int phyaddr,
  * accessing the PHY registers.
  * Fortunately, it seems this has no drawback for the 7109 MAC.
  */
-static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
+static int stmmac_mdio_read_c22(struct mii_bus *bus, int phyaddr, int phyreg)
 {
 	struct net_device *ndev = bus->priv;
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	unsigned int mii_address = priv->hw->mii.addr;
-	unsigned int mii_data = priv->hw->mii.data;
 	u32 value = MII_BUSY;
 	int data = 0;
-	u32 v;
 
 	data = pm_runtime_resume_and_get(priv->device);
 	if (data < 0)
@@ -265,60 +283,94 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 		& priv->hw->mii.clk_csr_mask;
 	if (priv->plat->has_gmac4) {
 		value |= MII_GMAC4_READ;
-		if (phyreg & MII_ADDR_C45) {
-			value |= MII_GMAC4_C45E;
-			value &= ~priv->hw->mii.reg_mask;
-			value |= ((phyreg >> MII_DEVADDR_C45_SHIFT) <<
-			       priv->hw->mii.reg_shift) &
-			       priv->hw->mii.reg_mask;
-
-			data |= (phyreg & MII_REGADDR_C45_MASK) <<
-				MII_GMAC4_REG_ADDR_SHIFT;
-		}
 	}
 
-	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000)) {
-		data = -EBUSY;
-		goto err_disable_clks;
-	}
+	data = stmmac_mdio_read(priv, data, value);
 
-	writel(data, priv->ioaddr + mii_data);
-	writel(value, priv->ioaddr + mii_address);
+	pm_runtime_put(priv->device);
 
-	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000)) {
-		data = -EBUSY;
-		goto err_disable_clks;
+	return data;
+}
+
+/**
+ * stmmac_mdio_read_c45
+ * @bus: points to the mii_bus structure
+ * @phyaddr: MII addr
+ * @devad: device address to read
+ * @phyreg: MII reg
+ * Description: it reads data from the MII register from within the phy device.
+ * For the 7111 GMAC, we must set the bit 0 in the MII address register while
+ * accessing the PHY registers.
+ * Fortunately, it seems this has no drawback for the 7109 MAC.
+ */
+static int stmmac_mdio_read_c45(struct mii_bus *bus, int phyaddr, int devad,
+				int phyreg)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	u32 value = MII_BUSY;
+	int data = 0;
+
+	data = pm_runtime_get_sync(priv->device);
+	if (data < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return data;
 	}
 
-	/* Read the data from the MII data register */
-	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
+	value |= (phyaddr << priv->hw->mii.addr_shift)
+		& priv->hw->mii.addr_mask;
+	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
+	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
+		& priv->hw->mii.clk_csr_mask;
+	value |= MII_GMAC4_READ;
+	value |= MII_GMAC4_C45E;
+	value &= ~priv->hw->mii.reg_mask;
+	value |= (devad << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
+
+	data |= phyreg << MII_GMAC4_REG_ADDR_SHIFT;
+
+	data = stmmac_mdio_read(priv, data, value);
 
-err_disable_clks:
 	pm_runtime_put(priv->device);
 
 	return data;
 }
 
+static int stmmac_mdio_write(struct stmmac_priv *priv, int data, u32 value)
+{
+	unsigned int mii_address = priv->hw->mii.addr;
+	unsigned int mii_data = priv->hw->mii.data;
+	u32 v;
+
+	/* Wait until any existing MII operation is complete */
+	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+			       100, 10000))
+		return -EBUSY;
+
+	/* Set the MII address register to write */
+	writel(data, priv->ioaddr + mii_data);
+	writel(value, priv->ioaddr + mii_address);
+
+	/* Wait until any existing MII operation is complete */
+	return readl_poll_timeout(priv->ioaddr + mii_address, v,
+				  !(v & MII_BUSY), 100, 10000);
+}
+
 /**
- * stmmac_mdio_write
+ * stmmac_mdio_write_c22
  * @bus: points to the mii_bus structure
  * @phyaddr: MII addr
  * @phyreg: MII reg
  * @phydata: phy data
  * Description: it writes the data into the MII register from within the device.
  */
-static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
-			     u16 phydata)
+static int stmmac_mdio_write_c22(struct mii_bus *bus, int phyaddr, int phyreg,
+				 u16 phydata)
 {
 	struct net_device *ndev = bus->priv;
 	struct stmmac_priv *priv = netdev_priv(ndev);
-	unsigned int mii_address = priv->hw->mii.addr;
-	unsigned int mii_data = priv->hw->mii.data;
 	int ret, data = phydata;
 	u32 value = MII_BUSY;
-	u32 v;
 
 	ret = pm_runtime_resume_and_get(priv->device);
 	if (ret < 0)
@@ -330,38 +382,57 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	if (priv->plat->has_gmac4) {
+	if (priv->plat->has_gmac4)
 		value |= MII_GMAC4_WRITE;
-		if (phyreg & MII_ADDR_C45) {
-			value |= MII_GMAC4_C45E;
-			value &= ~priv->hw->mii.reg_mask;
-			value |= ((phyreg >> MII_DEVADDR_C45_SHIFT) <<
-			       priv->hw->mii.reg_shift) &
-			       priv->hw->mii.reg_mask;
-
-			data |= (phyreg & MII_REGADDR_C45_MASK) <<
-				MII_GMAC4_REG_ADDR_SHIFT;
-		}
-	} else {
+	else
 		value |= MII_WRITE;
-	}
 
-	/* Wait until any existing MII operation is complete */
-	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000)) {
-		ret = -EBUSY;
-		goto err_disable_clks;
+	ret = stmmac_mdio_write(priv, data, value);
+
+	pm_runtime_put(priv->device);
+
+	return ret;
+}
+
+/**
+ * stmmac_mdio_write_c45
+ * @bus: points to the mii_bus structure
+ * @phyaddr: MII addr
+ * @phyreg: MII reg
+ * @devad: device address to read
+ * @phydata: phy data
+ * Description: it writes the data into the MII register from within the device.
+ */
+static int stmmac_mdio_write_c45(struct mii_bus *bus, int phyaddr,
+				 int devad, int phyreg, u16 phydata)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int ret, data = phydata;
+	u32 value = MII_BUSY;
+
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
 	}
 
-	/* Set the MII address register to write */
-	writel(data, priv->ioaddr + mii_data);
-	writel(value, priv->ioaddr + mii_address);
+	value |= (phyaddr << priv->hw->mii.addr_shift)
+		& priv->hw->mii.addr_mask;
+	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
 
-	/* Wait until any existing MII operation is complete */
-	ret = readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-				 100, 10000);
+	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
+		& priv->hw->mii.clk_csr_mask;
+
+	value |= MII_GMAC4_WRITE;
+	value |= MII_GMAC4_C45E;
+	value &= ~priv->hw->mii.reg_mask;
+	value |= (devad << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
+
+	data |= phyreg << MII_GMAC4_REG_ADDR_SHIFT;
+
+	ret = stmmac_mdio_write(priv, data, value);
 
-err_disable_clks:
 	pm_runtime_put(priv->device);
 
 	return ret;
@@ -499,8 +570,13 @@ int stmmac_mdio_register(struct net_device *ndev)
 			dev_err(dev, "Unsupported phy_addr (max=%d)\n",
 					MII_XGMAC_MAX_C22ADDR);
 	} else {
-		new_bus->read = &stmmac_mdio_read;
-		new_bus->write = &stmmac_mdio_write;
+		new_bus->read = &stmmac_mdio_read_c22;
+		new_bus->write = &stmmac_mdio_write_c22;
+		if (priv->plat->has_gmac4) {
+			new_bus->read_c45 = &stmmac_mdio_read_c45;
+			new_bus->write_c45 = &stmmac_mdio_write_c45;
+		}
+
 		max_addr = PHY_MAX_ADDR;
 	}
 

-- 
2.30.2
