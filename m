Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD2751EE9F
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiEHPfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234823AbiEHPfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B359E030
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/36G5gK5OgwkRL1iXLzFSUvcG9KSgktxLhvm3uirI2U=; b=j9IqPftZJcjUJ2UUTpHCG+paVg
        GlakrQFUsaCJwOfNS8QUNQLSZdDhdJf3vDUj0q0SevgndxqH/9eAxLn6FE8mMneHIZYrxdn2kkA92
        SdrXmF6ZGNdye2uXFqiZ6sk8euriWr1OzBdrkFOwkLROmBN05Sf4ELzQZ+T1vynwQvuM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9q-9U; Sun, 08 May 2022 17:31:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: [PATCH net-next 07/10] net: ethernet: freescale: xgmac: Separate C22 and C45 transactions for xgmac
Date:   Sun,  8 May 2022 17:30:46 +0200
Message-Id: <20220508153049.427227-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220508153049.427227-1-andrew@lunn.ch>
References: <20220508153049.427227-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xgmac MDIO bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 154 +++++++++++++++-----
 1 file changed, 117 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index ec90da1de030..ddfe6bf1f231 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -128,30 +128,59 @@ static int xgmac_wait_until_done(struct device *dev,
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
 	u32 mdio_ctl, mdio_stat;
+	u16 dev_addr;
 	int ret;
+
+	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
+	dev_addr = regnum & 0x1f;
+	mdio_stat &= ~MDIO_STAT_ENC;
+
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
 
@@ -164,13 +193,11 @@ static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 val
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
@@ -182,31 +209,84 @@ static int xgmac_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 val
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
 	unsigned long flags;
-	uint16_t dev_addr;
 	uint32_t mdio_stat;
 	uint32_t mdio_ctl;
+	u16 dev_addr;
 	int ret;
-	bool endian = priv->is_little_endian;
 
 	mdio_stat = xgmac_read32(&regs->mdio_stat, endian);
-	if (regnum & MII_ADDR_C45) {
-		dev_addr = (regnum >> 16) & 0x1f;
-		mdio_stat |= MDIO_STAT_ENC;
+	dev_addr = regnum & 0x1f;
+	mdio_stat &= ~MDIO_STAT_ENC;
+
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
@@ -218,13 +298,11 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
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
@@ -326,8 +404,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
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
2.36.0

