Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC744662A0B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbjAIPcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbjAIPbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:31:50 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4141EC75;
        Mon,  9 Jan 2023 07:31:07 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id EB74118D8;
        Mon,  9 Jan 2023 16:30:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673278257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hiQtbjr1MuOIadudcSBQhGvcT/hBXRIhqkSXGDXJPIo=;
        b=x23FRf2u9HfAfVFtarmaIOkyQ4mbzjmqiVXL6KW6UrcYg5mixeDYZAJ+R4KLfpQk5m44c4
        +j3KIuImPXWUdFvV0eDTZt2/M9difs2f19yL1+SOSj00FQJUgZdSb80Mz6C5TgdaboLdzC
        8Mpj1ZHw2ALLfqq2NtWW+QjmWZlr66n75loFWcrfi8ceddmWqxTR/M/aM6DUlBEwZAdn/Z
        xEMLUp9P+KSknWY+pZCSS8PX0WTL4VM8/UETnELEx0VQccEybpIGBiaWCxhc2g5Y9+JmNV
        4AFosfhti3qPd6Os1gaVHlC6EJwAqkAaWHenofimLIXwsEPPDlBY/ruwIKfDKQ==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 09 Jan 2023 16:30:48 +0100
Subject: [PATCH net-next v3 08/11] net: mdio: xgmac_mdio: Separate C22 and C45
 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v3-8-ade1deb438da@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
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
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
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

While at it, remove the misleading comment. According to Vladimir
Oltean:
 - miimcom is a register accessed by fsl_pq_mdio.c, not by xgmac_mdio.c
 - "device dev" doesn't really refer to anything (maybe "dev_addr").
 - I don't understand what is meant by the comment "All PHY
   configuration has to be done through the TSEC1 MIIM regs". Or rather
   said, I think I understand, but it is irrelevant to the driver for 2
   reasons:
    * TSEC devices use the fsl_pq_mdio.c driver, not this one
    * It doesn't matter to this driver whose TSEC registers are used for
      MDIO access. The driver just works with the registers it's given,
      which is a concern for the device tree.
 - barring the above, the rest just describes the MDIO bus API, which is
   superfluous

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2:
 - [al] Move the masking of regnum into the variable declarations
 - [al] Remove a couple of blank lines
v3:
 - [mw] Remove comment
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 148 ++++++++++++++++++++--------
 1 file changed, 108 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index d7d39a58cd80..8b5a4cd8ff08 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -128,30 +128,49 @@ static int xgmac_wait_until_done(struct device *dev,
 	return 0;
 }
 
-/*
- * Write value to the PHY for this device to the register at regnum,waiting
- * until the write is done before it returns.  All PHY configuration has to be
- * done through the TSEC1 MIIM regs.
- */
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
 
@@ -164,13 +183,11 @@ static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 val
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
@@ -182,31 +199,82 @@ static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 val
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
@@ -218,13 +286,11 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
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
@@ -326,8 +392,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
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
