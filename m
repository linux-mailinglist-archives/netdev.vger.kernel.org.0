Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DA7ABA7A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394094AbfIFOPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:15:48 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48512 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394077AbfIFOPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:15:47 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E7A181A0BF3;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DACE51A0BF0;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id AC3842061D;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 2/5] enetc: Make mdio accessors more generic
Date:   Fri,  6 Sep 2019 17:15:41 +0300
Message-Id: <1567779344-30965-3-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactoring needed to support multiple MDIO buses.
'mdio_base' - MDIO registers base address - is being parameterized.
The MDIO accessors are made more generic to be able to work with
different MDIO register bases.
Some includes get cleaned up in the process.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  1 +
 .../net/ethernet/freescale/enetc/enetc_mdio.c | 60 +++++++++++--------
 .../net/ethernet/freescale/enetc/enetc_mdio.h |  2 +-
 .../ethernet/freescale/enetc/enetc_pci_mdio.c |  2 +
 4 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 88276299f447..534de211b243 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -192,6 +192,7 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PFPMR		0x1900
 #define ENETC_PFPMR_PMACE	BIT(1)
 #define ENETC_PFPMR_MWLM	BIT(0)
+#define ENETC_EMDIO_BASE	0x1c00
 #define ENETC_PSIUMHFR0(n, err)	(((err) ? 0x1d08 : 0x1d00) + (n) * 0x10)
 #define ENETC_PSIUMHFR1(n)	(0x1d04 + (n) * 0x10)
 #define ENETC_PSIMMHFR0(n, err)	(((err) ? 0x1d00 : 0x1d08) + (n) * 0x10)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 149883c8f0b8..c9a27e7fe5a7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -6,19 +6,30 @@
 #include <linux/iopoll.h>
 #include <linux/of.h>
 
+#include "enetc_pf.h"
 #include "enetc_mdio.h"
 
-#define	ENETC_MDIO_REG_OFFSET	0x1c00
 #define	ENETC_MDIO_CFG	0x0	/* MDIO configuration and status */
 #define	ENETC_MDIO_CTL	0x4	/* MDIO control */
 #define	ENETC_MDIO_DATA	0x8	/* MDIO data */
 #define	ENETC_MDIO_ADDR	0xc	/* MDIO address */
 
-#define enetc_mdio_rd(hw, off) \
-	enetc_port_rd(hw, ENETC_##off + ENETC_MDIO_REG_OFFSET)
-#define enetc_mdio_wr(hw, off, val) \
-	enetc_port_wr(hw, ENETC_##off + ENETC_MDIO_REG_OFFSET, val)
-#define enetc_mdio_rd_reg(off)	enetc_mdio_rd(hw, off)
+static inline u32 _enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
+{
+	return enetc_port_rd(mdio_priv->hw, mdio_priv->mdio_base + off);
+}
+
+static inline void _enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
+				  u32 val)
+{
+	enetc_port_wr(mdio_priv->hw, mdio_priv->mdio_base + off, val);
+}
+
+#define enetc_mdio_rd(mdio_priv, off) \
+	_enetc_mdio_rd(mdio_priv, ENETC_##off)
+#define enetc_mdio_wr(mdio_priv, off, val) \
+	_enetc_mdio_wr(mdio_priv, ENETC_##off, val)
+#define enetc_mdio_rd_reg(off)	enetc_mdio_rd(mdio_priv, off)
 
 #define ENETC_MDC_DIV		258
 
@@ -35,7 +46,7 @@
 #define MDIO_DATA(x)		((x) & 0xffff)
 
 #define TIMEOUT	1000
-static int enetc_mdio_wait_complete(struct enetc_hw *hw)
+static int enetc_mdio_wait_complete(struct enetc_mdio_priv *mdio_priv)
 {
 	u32 val;
 
@@ -46,7 +57,6 @@ static int enetc_mdio_wait_complete(struct enetc_hw *hw)
 int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 {
 	struct enetc_mdio_priv *mdio_priv = bus->priv;
-	struct enetc_hw *hw = mdio_priv->hw;
 	u32 mdio_ctl, mdio_cfg;
 	u16 dev_addr;
 	int ret;
@@ -61,29 +71,29 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 		mdio_cfg &= ~MDIO_CFG_ENC45;
 	}
 
-	enetc_mdio_wr(hw, MDIO_CFG, mdio_cfg);
+	enetc_mdio_wr(mdio_priv, MDIO_CFG, mdio_cfg);
 
-	ret = enetc_mdio_wait_complete(hw);
+	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
 		return ret;
 
 	/* set port and dev addr */
 	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
-	enetc_mdio_wr(hw, MDIO_CTL, mdio_ctl);
+	enetc_mdio_wr(mdio_priv, MDIO_CTL, mdio_ctl);
 
 	/* set the register address */
 	if (regnum & MII_ADDR_C45) {
-		enetc_mdio_wr(hw, MDIO_ADDR, regnum & 0xffff);
+		enetc_mdio_wr(mdio_priv, MDIO_ADDR, regnum & 0xffff);
 
-		ret = enetc_mdio_wait_complete(hw);
+		ret = enetc_mdio_wait_complete(mdio_priv);
 		if (ret)
 			return ret;
 	}
 
 	/* write the value */
-	enetc_mdio_wr(hw, MDIO_DATA, MDIO_DATA(value));
+	enetc_mdio_wr(mdio_priv, MDIO_DATA, MDIO_DATA(value));
 
-	ret = enetc_mdio_wait_complete(hw);
+	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
 		return ret;
 
@@ -93,7 +103,6 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 {
 	struct enetc_mdio_priv *mdio_priv = bus->priv;
-	struct enetc_hw *hw = mdio_priv->hw;
 	u32 mdio_ctl, mdio_cfg;
 	u16 dev_addr, value;
 	int ret;
@@ -107,41 +116,41 @@ int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 		mdio_cfg &= ~MDIO_CFG_ENC45;
 	}
 
-	enetc_mdio_wr(hw, MDIO_CFG, mdio_cfg);
+	enetc_mdio_wr(mdio_priv, MDIO_CFG, mdio_cfg);
 
-	ret = enetc_mdio_wait_complete(hw);
+	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
 		return ret;
 
 	/* set port and device addr */
 	mdio_ctl = MDIO_CTL_PORT_ADDR(phy_id) | MDIO_CTL_DEV_ADDR(dev_addr);
-	enetc_mdio_wr(hw, MDIO_CTL, mdio_ctl);
+	enetc_mdio_wr(mdio_priv, MDIO_CTL, mdio_ctl);
 
 	/* set the register address */
 	if (regnum & MII_ADDR_C45) {
-		enetc_mdio_wr(hw, MDIO_ADDR, regnum & 0xffff);
+		enetc_mdio_wr(mdio_priv, MDIO_ADDR, regnum & 0xffff);
 
-		ret = enetc_mdio_wait_complete(hw);
+		ret = enetc_mdio_wait_complete(mdio_priv);
 		if (ret)
 			return ret;
 	}
 
 	/* initiate the read */
-	enetc_mdio_wr(hw, MDIO_CTL, mdio_ctl | MDIO_CTL_READ);
+	enetc_mdio_wr(mdio_priv, MDIO_CTL, mdio_ctl | MDIO_CTL_READ);
 
-	ret = enetc_mdio_wait_complete(hw);
+	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
 		return ret;
 
 	/* return all Fs if nothing was there */
-	if (enetc_mdio_rd(hw, MDIO_CFG) & MDIO_CFG_RD_ER) {
+	if (enetc_mdio_rd(mdio_priv, MDIO_CFG) & MDIO_CFG_RD_ER) {
 		dev_dbg(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
 		return 0xffff;
 	}
 
-	value = enetc_mdio_rd(hw, MDIO_DATA) & 0xffff;
+	value = enetc_mdio_rd(mdio_priv, MDIO_DATA) & 0xffff;
 
 	return value;
 }
@@ -164,6 +173,7 @@ int enetc_mdio_probe(struct enetc_pf *pf)
 	bus->parent = dev;
 	mdio_priv = bus->priv;
 	mdio_priv->hw = &pf->si->hw;
+	mdio_priv->mdio_base = ENETC_EMDIO_BASE;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
 	np = of_get_child_by_name(dev->of_node, "mdio");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.h b/drivers/net/ethernet/freescale/enetc/enetc_mdio.h
index 60c9a3889824..a8ea3607c7bf 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.h
@@ -2,10 +2,10 @@
 /* Copyright 2019 NXP */
 
 #include <linux/phy.h>
-#include "enetc_pf.h"
 
 struct enetc_mdio_priv {
 	struct enetc_hw *hw;
+	int mdio_base;
 };
 
 int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
index fbd41ce01f06..e12159ac1fa6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2019 NXP */
 #include <linux/of_mdio.h>
+#include "enetc_pf.h"
 #include "enetc_mdio.h"
 
 #define ENETC_MDIO_DEV_ID	0xee01
@@ -31,6 +32,7 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
 	bus->parent = dev;
 	mdio_priv = bus->priv;
 	mdio_priv->hw = hw;
+	mdio_priv->mdio_base = ENETC_EMDIO_BASE;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
 	pcie_flr(pdev);
-- 
2.17.1

