Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE65B1239AB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfLQWTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:19:47 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38985 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfLQWTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:19:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so139602wrt.6
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AZv3WqXzIE2LxPC6RMk4X6XJ8qUoUmB69q0AQw98iTQ=;
        b=hqfpQnQG2/iYbsxQkki+rJzJelB46ogUOUbe7mdAoszJ5KNQznGkNYrokFwKoBZ/gM
         3gfVZ+yzbfvUFz6ZzHkguvd7CL3J9XZEhQB7PimdNYMUSojO0Tvk5+R8DOqwJagt8eLP
         QEhGZ0sawqkrkbB/0sGGH+YiiO9a/UZIyvPfzkNq82IfQQkWVqRcuouQWR6IsY3c66J8
         XhrRADuTYmxTgKMqyVNM0QTYJ+aVaea+XqibEF1dUJrKnKbJIXec5184HxfVtsvALb3J
         QxItiLuIpEQdS4E6CCuuMBvuPLgwYegKdxrMTqqrpk2wgqkrjo96w+rBlvUZ9lMBMLqk
         EXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AZv3WqXzIE2LxPC6RMk4X6XJ8qUoUmB69q0AQw98iTQ=;
        b=sHypGnJ2HGAlbS/glP99RXuV5zZVSeZqwdS05Jjft1Kjhgswz98gVPUXZ6W1BRBRtj
         XuxWf5QSn2mncN7zV+M5RFWk5yW0EIFrU80xYu1LBUGfKtkoeJ576OmTh62VPs0seTVs
         Kn3ek1XO5MOtus+G+RvDp3eN1z6T16tLxIzUH3y+nV1vhPdFbKYrUo9LjCIaXH4iGBEF
         TW9StqS4ETC1UfWi0+6JOdqx/BWR8koxB6oemrIxnXDW5VRpN64ZS77UOSxGWwTxdbod
         4hvVNfVZqlsmBDF95t5p5a1sKJ9bCz8wUfc1sDXwdxbRXCR7o0x5PWY3SG68UmcF+TjT
         KbGA==
X-Gm-Message-State: APjAAAV7sDpGGmf8+ciLopJc1obYIMUlykcbgIhN6dIM/5C7GIwOdDJm
        Y+b/joGXOXsgtX/BIQ82TYHgGzWqXiM=
X-Google-Smtp-Source: APXvYqw1jd8mugLwZLAwjNC1LF7HgUkbwwibmkDXa5CrruNs0cZMOO49FQ62Kn0z4ufuXAmsAul1aA==
X-Received: by 2002:a5d:4044:: with SMTP id w4mr39327286wrp.322.1576621184170;
        Tue, 17 Dec 2019 14:19:44 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id e6sm196808wru.44.2019.12.17.14.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:19:43 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 4/8] enetc: Make MDIO accessors more generic and export to include/linux/fsl
Date:   Wed, 18 Dec 2019 00:18:27 +0200
Message-Id: <20191217221831.10923-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217221831.10923-1-olteanv@gmail.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

Within the LS1028A SoC, the register map for the ENETC MDIO controller
is instantiated a few times: for the central (external) MDIO controller,
for the internal bus of each standalone ENETC port, and for the internal
bus of the Felix switch.

Refactoring is needed to support multiple MDIO buses from multiple
drivers. The enetc_hw structure is made an opaque type and a smaller
enetc_mdio_priv is created.

'mdio_base' - MDIO registers base address - is being parameterized, to
be able to work with different MDIO register bases.

Some includes get cleaned up in the process.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |  1 +
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c  | 78 ++++++++++++++--------
 drivers/net/ethernet/freescale/enetc/enetc_mdio.h  | 12 ----
 .../net/ethernet/freescale/enetc/enetc_pci_mdio.c  | 43 +++++++-----
 include/linux/fsl/enetc_mdio.h                     | 34 ++++++++++
 5 files changed, 113 insertions(+), 55 deletions(-)
 delete mode 100644 drivers/net/ethernet/freescale/enetc/enetc_mdio.h
 create mode 100644 include/linux/fsl/enetc_mdio.h

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 51f543ef37a8..7df4482af1b7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -200,6 +200,7 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PFPMR		0x1900
 #define ENETC_PFPMR_PMACE	BIT(1)
 #define ENETC_PFPMR_MWLM	BIT(0)
+#define ENETC_EMDIO_BASE	0x1c00
 #define ENETC_PSIUMHFR0(n, err)	(((err) ? 0x1d08 : 0x1d00) + (n) * 0x10)
 #define ENETC_PSIUMHFR1(n)	(0x1d04 + (n) * 0x10)
 #define ENETC_PSIMMHFR0(n, err)	(((err) ? 0x1d00 : 0x1d08) + (n) * 0x10)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 149883c8f0b8..6f6e31492b1c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -1,24 +1,35 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2019 NXP */
 
+#include <linux/fsl/enetc_mdio.h>
 #include <linux/mdio.h>
 #include <linux/of_mdio.h>
 #include <linux/iopoll.h>
 #include <linux/of.h>
 
-#include "enetc_mdio.h"
+#include "enetc_pf.h"
 
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
@@ -61,39 +71,39 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
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
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(enetc_mdio_write);
 
 int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 {
 	struct enetc_mdio_priv *mdio_priv = bus->priv;
-	struct enetc_hw *hw = mdio_priv->hw;
 	u32 mdio_ctl, mdio_cfg;
 	u16 dev_addr, value;
 	int ret;
@@ -107,44 +117,59 @@ int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
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
+EXPORT_SYMBOL_GPL(enetc_mdio_read);
+
+struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
+{
+	struct enetc_hw *hw;
+
+	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
+	if (!hw)
+		return ERR_PTR(-ENOMEM);
+
+	hw->port = port_regs;
+
+	return hw;
+}
+EXPORT_SYMBOL_GPL(enetc_hw_alloc);
 
 int enetc_mdio_probe(struct enetc_pf *pf)
 {
@@ -164,6 +189,7 @@ int enetc_mdio_probe(struct enetc_pf *pf)
 	bus->parent = dev;
 	mdio_priv = bus->priv;
 	mdio_priv->hw = &pf->si->hw;
+	mdio_priv->mdio_base = ENETC_EMDIO_BASE;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
 	np = of_get_child_by_name(dev->of_node, "mdio");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.h b/drivers/net/ethernet/freescale/enetc/enetc_mdio.h
deleted file mode 100644
index 60c9a3889824..000000000000
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
-/* Copyright 2019 NXP */
-
-#include <linux/phy.h>
-#include "enetc_pf.h"
-
-struct enetc_mdio_priv {
-	struct enetc_hw *hw;
-};
-
-int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value);
-int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
index fbd41ce01f06..87c0e969da40 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2019 NXP */
+#include <linux/fsl/enetc_mdio.h>
 #include <linux/of_mdio.h>
-#include "enetc_mdio.h"
+#include "enetc_pf.h"
 
 #define ENETC_MDIO_DEV_ID	0xee01
 #define ENETC_MDIO_DEV_NAME	"FSL PCIe IE Central MDIO"
@@ -13,17 +14,29 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
 {
 	struct enetc_mdio_priv *mdio_priv;
 	struct device *dev = &pdev->dev;
+	void __iomem *port_regs;
 	struct enetc_hw *hw;
 	struct mii_bus *bus;
 	int err;
 
-	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
-	if (!hw)
-		return -ENOMEM;
+	port_regs = pci_iomap(pdev, 0, 0);
+	if (!port_regs) {
+		dev_err(dev, "iomap failed\n");
+		err = -ENXIO;
+		goto err_ioremap;
+	}
+
+	hw = enetc_hw_alloc(dev, port_regs);
+	if (IS_ERR(enetc_hw_alloc)) {
+		err = PTR_ERR(hw);
+		goto err_hw_alloc;
+	}
 
 	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
-	if (!bus)
-		return -ENOMEM;
+	if (!bus) {
+		err = -ENOMEM;
+		goto err_mdiobus_alloc;
+	}
 
 	bus->name = ENETC_MDIO_BUS_NAME;
 	bus->read = enetc_mdio_read;
@@ -31,13 +44,14 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
 	bus->parent = dev;
 	mdio_priv = bus->priv;
 	mdio_priv->hw = hw;
+	mdio_priv->mdio_base = ENETC_EMDIO_BASE;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
 	pcie_flr(pdev);
 	err = pci_enable_device_mem(pdev);
 	if (err) {
 		dev_err(dev, "device enable failed\n");
-		return err;
+		goto err_pci_enable;
 	}
 
 	err = pci_request_region(pdev, 0, KBUILD_MODNAME);
@@ -46,13 +60,6 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
 		goto err_pci_mem_reg;
 	}
 
-	hw->port = pci_iomap(pdev, 0, 0);
-	if (!hw->port) {
-		err = -ENXIO;
-		dev_err(dev, "iomap failed\n");
-		goto err_ioremap;
-	}
-
 	err = of_mdiobus_register(bus, dev->of_node);
 	if (err)
 		goto err_mdiobus_reg;
@@ -62,12 +69,14 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
 	return 0;
 
 err_mdiobus_reg:
-	iounmap(mdio_priv->hw->port);
-err_ioremap:
 	pci_release_mem_regions(pdev);
 err_pci_mem_reg:
 	pci_disable_device(pdev);
-
+err_pci_enable:
+err_mdiobus_alloc:
+	iounmap(port_regs);
+err_hw_alloc:
+err_ioremap:
 	return err;
 }
 
diff --git a/include/linux/fsl/enetc_mdio.h b/include/linux/fsl/enetc_mdio.h
new file mode 100644
index 000000000000..8a1127b79243
--- /dev/null
+++ b/include/linux/fsl/enetc_mdio.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2019 NXP */
+
+#include <linux/phy.h>
+
+/* PCS registers */
+#define ENETC_PCS_LINK_TIMER1			0x12
+#define ENETC_PCS_LINK_TIMER1_VAL		0x06a0
+#define ENETC_PCS_LINK_TIMER2			0x13
+#define ENETC_PCS_LINK_TIMER2_VAL		0x0003
+#define ENETC_PCS_IF_MODE			0x14
+#define ENETC_PCS_IF_MODE_SGMII_EN		BIT(0)
+#define ENETC_PCS_IF_MODE_USE_SGMII_AN		BIT(1)
+#define ENETC_PCS_IF_MODE_SGMII_SPEED(x)	(((x) << 2) & GENMASK(3, 2))
+
+/* Not a mistake, the SerDes PLL needs to be set at 3.125 GHz by Reset
+ * Configuration Word (RCW, outside Linux control) for 2.5G SGMII mode. The PCS
+ * still thinks it's at gigabit.
+ */
+enum enetc_pcs_speed {
+	ENETC_PCS_SPEED_10	= 0,
+	ENETC_PCS_SPEED_100	= 1,
+	ENETC_PCS_SPEED_1000	= 2,
+	ENETC_PCS_SPEED_2500	= 2,
+};
+
+struct enetc_mdio_priv {
+	struct enetc_hw *hw;
+	int mdio_base;
+};
+
+int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value);
+int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum);
+struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs);
-- 
2.7.4

