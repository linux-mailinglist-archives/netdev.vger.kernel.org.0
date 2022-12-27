Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7179F6570E1
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiL0XI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiL0XHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:07:46 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B0BB49C;
        Tue, 27 Dec 2022 15:07:30 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 0DB9016E6;
        Wed, 28 Dec 2022 00:07:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672182449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sMbUUXMbhp+M/zQYqTYPRcq5z/ESj3+QbHed23y5ENo=;
        b=YZrfu27TR2nT3nrR3XlDqTwRUVeyzcBHo246w6Ii1DHDEGKubzkXkxfQWIATAkgqCVBmiy
        3M/SAQu+LzScxavvYFYHu9n122fLs5ecpE3vEI/pEEmnWk97W9coqauai7ZWpu2rnldEYT
        Em0b7H46SeO7KW/i8Ens3VdozEWDaj6rGUQwTf9GUJLziPjnEhcwiJ31qQP9+ZMN65UI5q
        X499JQS2oXuJdxt4Agha1C78JFA+my64aSFuWt7/I9bDkIX9gBWT8KmGLblubVefBZU6Yf
        tSsi30ar1lAt/HS2JRSUyGSldltR5hAHq/An73H/Nu1FRwdxxGN22noc00ZBDA==
From:   Michael Walle <michael@walle.cc>
Date:   Wed, 28 Dec 2022 00:07:24 +0100
Subject: [PATCH RFC net-next v2 08/12] net: ethernet: freescale: xgmac:
 Separate C22 and C45 transactions for xgmac
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v2-8-ddb37710e5a7@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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

The xgmac MDIO bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
v2:
 - [al] Move the masking of regnum into the variable declarations
 - [al] Remove a couple of blank lines
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 150 +++++++++++++++++++++-------
 1 file changed, 113 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index d7d39a58cd80..1861cf14f4d7 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -128,30 +128,57 @@ static int xgmac_wait_until_done(struct device *dev,
 	return 0;
 }
 
-/*
- * Write value to the PHY for this device to the register at regnum,waiting
+/* Write value to the PHY for this device to the register at regnum,waiting
  * until the write is done before it returns.  All PHY configuration has to be
  * done through the TSEC1 MIIM regs.
  */
-static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
+static int xgmac_mdio_write_c22(struct mii_bus *bus, int phy_id, int regnum,
+				u16 value)
 {
 	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
-	uint16_t dev_addr;
+	bool endian = priv->is_little_endian;
+	u16 dev_addr = regnum & 0x1f;
 	u32 mdio_ctl, mdio_stat;
 	int ret;
+
+	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
+	mdio_stat &= ~MDIO_STAT_ENC;
+	xgmac_write32(mdio_stat, &regs->mdio_stat, endian);
+
+	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
+	if (ret)
+		return ret;
+
+	/* Set the port and dev addr */
+	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
+	xgmac_write32(mdio_ctl, &regs->mdio_ctl, endian);
+
+	/* Write the value to the register */
+	xgmac_write32(MDIO_DATA(value), &regs->mdio_data, endian);
+
+	ret = xgmac_wait_until_done(&bus->dev, regs, endian);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/* Write value to the PHY for this device to the register at regnum,waiting
+ * until the write is done before it returns.  All PHY configuration has to be
+ * done through the TSEC1 MIIM regs.
+ */
+static int xgmac_mdio_write_c45(struct mii_bus *bus, int phy_id, int dev_addr,
+				int regnum, u16 value)
+{
+	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
 	bool endian = priv->is_little_endian;
+	u32 mdio_ctl, mdio_stat;
+	int ret;
 
 	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
-	if (regnum & MII_ADDR_C45) {
-		/* Clause 45 (ie 10G) */
-		dev_addr = (regnum >> 16) & 0x1f;
-		mdio_stat |= MDIO_STAT_ENC;
-	} else {
-		/* Clause 22 (ie 1G) */
-		dev_addr = regnum & 0x1f;
-		mdio_stat &= ~MDIO_STAT_ENC;
-	}
+	mdio_stat |= MDIO_STAT_ENC;
 
 	xgmac_write32(mdio_stat, &regs->mdio_stat, endian);
 
@@ -164,13 +191,11 @@ static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 val
 	xgmac_write32(mdio_ctl, &regs->mdio_ctl, endian);
 
 	/* Set the register address */
-	if (regnum & MII_ADDR_C45) {
-		xgmac_write32(regnum & 0xffff, &regs->mdio_addr, endian);
+	xgmac_write32(regnum & 0xffff, &regs->mdio_addr, endian);
 
-		ret = xgmac_wait_until_free(&bus->dev, regs, endian);
-		if (ret)
-			return ret;
-	}
+	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
+	if (ret)
+		return ret;
 
 	/* Write the value to the register */
 	xgmac_write32(MDIO_DATA(value), &regs->mdio_data, endian);
@@ -182,31 +207,82 @@ static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 val
 	return 0;
 }
 
-/*
- * Reads from register regnum in the PHY for device dev, returning the value.
+/* Reads from register regnum in the PHY for device dev, returning the value.
  * Clears miimcom first.  All PHY configuration has to be done through the
  * TSEC1 MIIM regs.
  */
-static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
+static int xgmac_mdio_read_c22(struct mii_bus *bus, int phy_id, int regnum)
 {
 	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
+	bool endian = priv->is_little_endian;
+	u16 dev_addr = regnum & 0x1f;
 	unsigned long flags;
-	uint16_t dev_addr;
 	uint32_t mdio_stat;
 	uint32_t mdio_ctl;
 	int ret;
-	bool endian = priv->is_little_endian;
 
 	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
-	if (regnum & MII_ADDR_C45) {
-		dev_addr = (regnum >> 16) & 0x1f;
-		mdio_stat |= MDIO_STAT_ENC;
+	mdio_stat &= ~MDIO_STAT_ENC;
+	xgmac_write32(mdio_stat, &regs->mdio_stat, endian);
+
+	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
+	if (ret)
+		return ret;
+
+	/* Set the Port and Device Addrs */
+	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
+	xgmac_write32(mdio_ctl, &regs->mdio_ctl, endian);
+
+	if (priv->has_a009885)
+		/* Once the operation completes, i.e. MDIO_STAT_BSY clears, we
+		 * must read back the data register within 16 MDC cycles.
+		 */
+		local_irq_save(flags);
+
+	/* Initiate the read */
+	xgmac_write32(mdio_ctl | MDIO_CTL_READ, &regs->mdio_ctl, endian);
+
+	ret = xgmac_wait_until_done(&bus->dev, regs, endian);
+	if (ret)
+		goto irq_restore;
+
+	/* Return all Fs if nothing was there */
+	if ((xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) &&
+	    !priv->has_a011043) {
+		dev_dbg(&bus->dev,
+			"Error while reading PHY%d reg at %d.%d\n",
+			phy_id, dev_addr, regnum);
+		ret = 0xffff;
 	} else {
-		dev_addr = regnum & 0x1f;
-		mdio_stat &= ~MDIO_STAT_ENC;
+		ret = xgmac_read32(&regs->mdio_data, endian) & 0xffff;
+		dev_dbg(&bus->dev, "read %04x\n", ret);
 	}
 
+irq_restore:
+	if (priv->has_a009885)
+		local_irq_restore(flags);
+
+	return ret;
+}
+
+/* Reads from register regnum in the PHY for device dev, returning the value.
+ * Clears miimcom first.  All PHY configuration has to be done through the
+ * TSEC1 MIIM regs.
+ */
+static int xgmac_mdio_read_c45(struct mii_bus *bus, int phy_id, int dev_addr,
+			       int regnum)
+{
+	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
+	bool endian = priv->is_little_endian;
+	u32 mdio_stat, mdio_ctl;
+	unsigned long flags;
+	int ret;
+
+	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
+	mdio_stat |= MDIO_STAT_ENC;
+
 	xgmac_write32(mdio_stat, &regs->mdio_stat, endian);
 
 	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
@@ -218,13 +294,11 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	xgmac_write32(mdio_ctl, &regs->mdio_ctl, endian);
 
 	/* Set the register address */
-	if (regnum & MII_ADDR_C45) {
-		xgmac_write32(regnum & 0xffff, &regs->mdio_addr, endian);
+	xgmac_write32(regnum & 0xffff, &regs->mdio_addr, endian);
 
-		ret = xgmac_wait_until_free(&bus->dev, regs, endian);
-		if (ret)
-			return ret;
-	}
+	ret = xgmac_wait_until_free(&bus->dev, regs, endian);
+	if (ret)
+		return ret;
 
 	if (priv->has_a009885)
 		/* Once the operation completes, i.e. MDIO_STAT_BSY clears, we
@@ -326,8 +400,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	bus->name = "Freescale XGMAC MDIO Bus";
-	bus->read = xgmac_mdio_read;
-	bus->write = xgmac_mdio_write;
+	bus->read = xgmac_mdio_read_c22;
+	bus->write = xgmac_mdio_write_c22;
+	bus->read_c45 = xgmac_mdio_read_c45;
+	bus->write_c45 = xgmac_mdio_write_c45;
 	bus->parent = &pdev->dev;
 	bus->probe_capabilities = MDIOBUS_C22_C45;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);

-- 
2.30.2
