Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF527DA9F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 13:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbfHALxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 07:53:02 -0400
Received: from inva020.nxp.com ([92.121.34.13]:53362 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730816AbfHALw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 07:52:57 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 087B21A0B63;
        Thu,  1 Aug 2019 13:52:55 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EFC601A02A9;
        Thu,  1 Aug 2019 13:52:54 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8AB26205E3;
        Thu,  1 Aug 2019 13:52:54 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     andrew@lunn.ch, Rob Herring <robh+dt@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, alexandru.marginean@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 1/5] enetc: Clean up local mdio bus allocation
Date:   Thu,  1 Aug 2019 14:52:49 +0300
Message-Id: <1564660373-4607-2-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564660373-4607-1-git-send-email-claudiu.manoil@nxp.com>
References: <1564660373-4607-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What's needed is basically a pointer to the mdio registers.
This is one way to store it inside bus->priv allocated space,
without upsetting sparse.
Reworked accessors to avoid __iomem casting.
Used devm_* variant to further clean up the init error /
remove paths.

Fixes following sparse warning:
 warning: incorrect type in assignment (different address spaces)
    expected void *priv
    got struct enetc_mdio_regs [noderef] <asn:2>*[assigned] regs

Fixes: ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v1 - added this patch
v2 - reworked accessors as per Andrew Lunn's request
v3 - cleaned up commit message
v4 - none
v5 - none

 .../net/ethernet/freescale/enetc/enetc_mdio.c | 94 +++++++++----------
 1 file changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 77b9cd10ba2b..05094601ece8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -8,16 +8,22 @@
 
 #include "enetc_pf.h"
 
-struct enetc_mdio_regs {
-	u32	mdio_cfg;	/* MDIO configuration and status */
-	u32	mdio_ctl;	/* MDIO control */
-	u32	mdio_data;	/* MDIO data */
-	u32	mdio_addr;	/* MDIO address */
+#define	ENETC_MDIO_REG_OFFSET	0x1c00
+#define	ENETC_MDIO_CFG	0x0	/* MDIO configuration and status */
+#define	ENETC_MDIO_CTL	0x4	/* MDIO control */
+#define	ENETC_MDIO_DATA	0x8	/* MDIO data */
+#define	ENETC_MDIO_ADDR	0xc	/* MDIO address */
+
+#define enetc_mdio_rd(hw, off) \
+	enetc_port_rd(hw, ENETC_##off + ENETC_MDIO_REG_OFFSET)
+#define enetc_mdio_wr(hw, off, val) \
+	enetc_port_wr(hw, ENETC_##off + ENETC_MDIO_REG_OFFSET, val)
+#define enetc_mdio_rd_reg(off)	enetc_mdio_rd(hw, off)
+
+struct enetc_mdio_priv {
+	struct enetc_hw *hw;
 };
 
-#define bus_to_enetc_regs(bus)	(struct enetc_mdio_regs __iomem *)((bus)->priv)
-
-#define ENETC_MDIO_REG_OFFSET	0x1c00
 #define ENETC_MDC_DIV		258
 
 #define MDIO_CFG_CLKDIV(x)	((((x) >> 1) & 0xff) << 8)
@@ -33,18 +39,19 @@ struct enetc_mdio_regs {
 #define MDIO_DATA(x)		((x) & 0xffff)
 
 #define TIMEOUT	1000
-static int enetc_mdio_wait_complete(struct enetc_mdio_regs __iomem *regs)
+static int enetc_mdio_wait_complete(struct enetc_hw *hw)
 {
 	u32 val;
 
-	return readx_poll_timeout(enetc_rd_reg, &regs->mdio_cfg, val,
+	return readx_poll_timeout(enetc_mdio_rd_reg, MDIO_CFG, val,
 				  !(val & MDIO_CFG_BSY), 10, 10 * TIMEOUT);
 }
 
 static int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
 			    u16 value)
 {
-	struct enetc_mdio_regs __iomem *regs = bus_to_enetc_regs(bus);
+	struct enetc_mdio_priv *mdio_priv = bus->priv;
+	struct enetc_hw *hw = mdio_priv->hw;
 	u32 mdio_ctl, mdio_cfg;
 	u16 dev_addr;
 	int ret;
@@ -59,29 +66,29 @@ static int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
 		mdio_cfg &= ~MDIO_CFG_ENC45;
 	}
 
-	enetc_wr_reg(&regs->mdio_cfg, mdio_cfg);
+	enetc_mdio_wr(hw, MDIO_CFG, mdio_cfg);
 
-	ret = enetc_mdio_wait_complete(regs);
+	ret = enetc_mdio_wait_complete(hw);
 	if (ret)
 		return ret;
 
 	/* set port and dev addr */
 	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
-	enetc_wr_reg(&regs->mdio_ctl, mdio_ctl);
+	enetc_mdio_wr(hw, MDIO_CTL, mdio_ctl);
 
 	/* set the register address */
 	if (regnum & MII_ADDR_C45) {
-		enetc_wr_reg(&regs->mdio_addr, regnum & 0xffff);
+		enetc_mdio_wr(hw, MDIO_ADDR, regnum & 0xffff);
 
-		ret = enetc_mdio_wait_complete(regs);
+		ret = enetc_mdio_wait_complete(hw);
 		if (ret)
 			return ret;
 	}
 
 	/* write the value */
-	enetc_wr_reg(&regs->mdio_data, MDIO_DATA(value));
+	enetc_mdio_wr(hw, MDIO_DATA, MDIO_DATA(value));
 
-	ret = enetc_mdio_wait_complete(regs);
+	ret = enetc_mdio_wait_complete(hw);
 	if (ret)
 		return ret;
 
@@ -90,7 +97,8 @@ static int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
 
 static int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 {
-	struct enetc_mdio_regs __iomem *regs = bus_to_enetc_regs(bus);
+	struct enetc_mdio_priv *mdio_priv = bus->priv;
+	struct enetc_hw *hw = mdio_priv->hw;
 	u32 mdio_ctl, mdio_cfg;
 	u16 dev_addr, value;
 	int ret;
@@ -104,41 +112,41 @@ static int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 		mdio_cfg &= ~MDIO_CFG_ENC45;
 	}
 
-	enetc_wr_reg(&regs->mdio_cfg, mdio_cfg);
+	enetc_mdio_wr(hw, MDIO_CFG, mdio_cfg);
 
-	ret = enetc_mdio_wait_complete(regs);
+	ret = enetc_mdio_wait_complete(hw);
 	if (ret)
 		return ret;
 
 	/* set port and device addr */
 	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
-	enetc_wr_reg(&regs->mdio_ctl, mdio_ctl);
+	enetc_mdio_wr(hw, MDIO_CTL, mdio_ctl);
 
 	/* set the register address */
 	if (regnum & MII_ADDR_C45) {
-		enetc_wr_reg(&regs->mdio_addr, regnum & 0xffff);
+		enetc_mdio_wr(hw, MDIO_ADDR, regnum & 0xffff);
 
-		ret = enetc_mdio_wait_complete(regs);
+		ret = enetc_mdio_wait_complete(hw);
 		if (ret)
 			return ret;
 	}
 
 	/* initiate the read */
-	enetc_wr_reg(&regs->mdio_ctl, mdio_ctl | MDIO_CTL_READ);
+	enetc_mdio_wr(hw, MDIO_CTL, mdio_ctl | MDIO_CTL_READ);
 
-	ret = enetc_mdio_wait_complete(regs);
+	ret = enetc_mdio_wait_complete(hw);
 	if (ret)
 		return ret;
 
 	/* return all Fs if nothing was there */
-	if (enetc_rd_reg(&regs->mdio_cfg) & MDIO_CFG_RD_ER) {
+	if (enetc_mdio_rd(hw, MDIO_CFG) & MDIO_CFG_RD_ER) {
 		dev_dbg(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
 		return 0xffff;
 	}
 
-	value = enetc_rd_reg(&regs->mdio_data) & 0xffff;
+	value = enetc_mdio_rd(hw, MDIO_DATA) & 0xffff;
 
 	return value;
 }
@@ -146,12 +154,12 @@ static int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 int enetc_mdio_probe(struct enetc_pf *pf)
 {
 	struct device *dev = &pf->si->pdev->dev;
-	struct enetc_mdio_regs __iomem *regs;
+	struct enetc_mdio_priv *mdio_priv;
 	struct device_node *np;
 	struct mii_bus *bus;
-	int ret;
+	int err;
 
-	bus = mdiobus_alloc_size(sizeof(regs));
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
 	if (!bus)
 		return -ENOMEM;
 
@@ -159,41 +167,31 @@ int enetc_mdio_probe(struct enetc_pf *pf)
 	bus->read = enetc_mdio_read;
 	bus->write = enetc_mdio_write;
 	bus->parent = dev;
+	mdio_priv = bus->priv;
+	mdio_priv->hw = &pf->si->hw;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
-	/* store the enetc mdio base address for this bus */
-	regs = pf->si->hw.port + ENETC_MDIO_REG_OFFSET;
-	bus->priv = regs;
-
 	np = of_get_child_by_name(dev->of_node, "mdio");
 	if (!np) {
 		dev_err(dev, "MDIO node missing\n");
-		ret = -EINVAL;
-		goto err_registration;
+		return -EINVAL;
 	}
 
-	ret = of_mdiobus_register(bus, np);
-	if (ret) {
+	err = of_mdiobus_register(bus, np);
+	if (err) {
 		of_node_put(np);
 		dev_err(dev, "cannot register MDIO bus\n");
-		goto err_registration;
+		return err;
 	}
 
 	of_node_put(np);
 	pf->mdio = bus;
 
 	return 0;
-
-err_registration:
-	mdiobus_free(bus);
-
-	return ret;
 }
 
 void enetc_mdio_remove(struct enetc_pf *pf)
 {
-	if (pf->mdio) {
+	if (pf->mdio)
 		mdiobus_unregister(pf->mdio);
-		mdiobus_free(pf->mdio);
-	}
 }
-- 
2.17.1

