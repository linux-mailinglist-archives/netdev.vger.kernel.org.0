Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F71C12BB52
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfL0VhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:37:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37752 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfL0VhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:37:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id f129so9324736wmf.2
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PI6Mu6bUkQ4xa8J760mGJUxE44m1xX+QrZlkblvo0aA=;
        b=chO6fy/0WJ0JfqSID6soFIftquTh5OdUX+diHK51611nui7kL0qvEVChvYkCsdElYY
         q+Vv8h9iEC1mvTSrIpVbd9QJugk+ZNNExaB/x9pzY/MdKxzsK9PyNm/qTtRT9wLZW1vJ
         b0JLgERGmLQ1TIt4TDeO0x67iKdJsmAclczWkn/YZnRCwadMfIihGyxYGrkIfQ9CxmmI
         hn0VtbIqD8SnBE/iLQKrriPz3zw4rTASN/M0FF+pfWUwmMe1mzgpXR4t+J3ZK2VqMbP5
         un3mYtftP5fgkxYqcHHBPmxvC3e3Z9tubAQ6IeUZjUWHEFDQzFws6DpLaBvWWeouxLOg
         1lHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PI6Mu6bUkQ4xa8J760mGJUxE44m1xX+QrZlkblvo0aA=;
        b=bNIYHbd9/KiPkAe+KQtH17DGJSrt519MwO96rGkY4145wm7re+8WKzp7pqUQ6TcCyL
         koUoHOkx9y4N0Rc4ILB9C/1sHLI3kLj+mSH6FPxjAI1trQPFGDIm529Nkib0iq+aHAI3
         oviuY4mf4I/wZW8Br8dSEQESB/7chb4q0tm8rpe3vmQwqNwAXr1+CgJZx8GMX0DFdxMa
         VAwYoE0D55JUNbeJzmT6bHJ955ErSnZCH1jLySxhPPiPM3IlLxbhg7lWUeO4Qh+znrrQ
         qhg1hHRltsJ4wbrS6jUBY5mXzU9sUsiflep0UNG4zFgvGYmkQWtuMypaqkBJujsVV+Ne
         Pxhw==
X-Gm-Message-State: APjAAAW2F2FWhZmq3ltxZhd0Fsv67RDzlMyOVAayBr6vEZqIuDIAkaEu
        rdHjEaaXZsXAmyw/KNCdzLI=
X-Google-Smtp-Source: APXvYqwORFmqttWczIzKN2V7WhuG9d4crMTffL46VTcqCYAbmrSo8LqdUc1M1JKXbLvVcbAkMXnoYw==
X-Received: by 2002:a1c:9c4c:: with SMTP id f73mr21829424wme.125.1577482618371;
        Fri, 27 Dec 2019 13:36:58 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:57 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 07/11] enetc: Make MDIO accessors more generic and export to include/linux/fsl
Date:   Fri, 27 Dec 2019 23:36:22 +0200
Message-Id: <20191227213626.4404-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191227213626.4404-1-olteanv@gmail.com>
References: <20191227213626.4404-1-olteanv@gmail.com>
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

The ENETC MDIO bus operations are exported from the fsl-enetc-mdio
kernel object, the same that registers the central MDIO controller (the
dedicated PF). The ENETC main driver has been changed to select it, and
use its exported helpers to further register its private MDIO bus. The
DSA Felix driver will do the same.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Removed enetc_mdio.o from fsl-enetc.o, which caused a build error in
  the previous series, because enetc_mdio_read and enetc_mdio_write were
  exported from 2 different kernel objects.
- Some associated code movement from enetc_mdio.c to enetc_pf.c

 drivers/net/ethernet/freescale/enetc/Kconfig  |   1 +
 drivers/net/ethernet/freescale/enetc/Makefile |   2 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   1 +
 .../net/ethernet/freescale/enetc/enetc_mdio.c | 110 +++++++-----------
 .../net/ethernet/freescale/enetc/enetc_mdio.h |  12 --
 .../ethernet/freescale/enetc/enetc_pci_mdio.c |  43 ++++---
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  47 ++++++++
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   4 -
 include/linux/fsl/enetc_mdio.h                |  55 +++++++++
 9 files changed, 176 insertions(+), 99 deletions(-)
 delete mode 100644 drivers/net/ethernet/freescale/enetc/enetc_mdio.h
 create mode 100644 include/linux/fsl/enetc_mdio.h

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index edad4ca46327..fe942de19597 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -2,6 +2,7 @@
 config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	select FSL_ENETC_MDIO
 	select PHYLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index d0db33e5b6b7..74f7ac253b8b 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -3,7 +3,7 @@
 common-objs := enetc.o enetc_cbdr.o enetc_ethtool.o
 
 obj-$(CONFIG_FSL_ENETC) += fsl-enetc.o
-fsl-enetc-y := enetc_pf.o enetc_mdio.o $(common-objs)
+fsl-enetc-y := enetc_pf.o $(common-objs)
 fsl-enetc-$(CONFIG_PCI_IOV) += enetc_msg.o
 fsl-enetc-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
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
index 149883c8f0b8..18c68e048d43 100644
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
@@ -107,86 +117,56 @@ int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
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
 
-int enetc_mdio_probe(struct enetc_pf *pf)
+struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
 {
-	struct device *dev = &pf->si->pdev->dev;
-	struct enetc_mdio_priv *mdio_priv;
-	struct device_node *np;
-	struct mii_bus *bus;
-	int err;
-
-	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
-	if (!bus)
-		return -ENOMEM;
-
-	bus->name = "Freescale ENETC MDIO Bus";
-	bus->read = enetc_mdio_read;
-	bus->write = enetc_mdio_write;
-	bus->parent = dev;
-	mdio_priv = bus->priv;
-	mdio_priv->hw = &pf->si->hw;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
-
-	np = of_get_child_by_name(dev->of_node, "mdio");
-	if (!np) {
-		dev_err(dev, "MDIO node missing\n");
-		return -EINVAL;
-	}
-
-	err = of_mdiobus_register(bus, np);
-	if (err) {
-		of_node_put(np);
-		dev_err(dev, "cannot register MDIO bus\n");
-		return err;
-	}
+	struct enetc_hw *hw;
 
-	of_node_put(np);
-	pf->mdio = bus;
+	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
+	if (!hw)
+		return ERR_PTR(-ENOMEM);
 
-	return 0;
-}
+	hw->port = port_regs;
 
-void enetc_mdio_remove(struct enetc_pf *pf)
-{
-	if (pf->mdio)
-		mdiobus_unregister(pf->mdio);
+	return hw;
 }
+EXPORT_SYMBOL_GPL(enetc_hw_alloc);
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
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index e7482d483b28..fc0d7d99e9a1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -2,6 +2,7 @@
 /* Copyright 2017-2019 NXP */
 
 #include <linux/module.h>
+#include <linux/fsl/enetc_mdio.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include "enetc_pf.h"
@@ -749,6 +750,52 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
 }
 
+static int enetc_mdio_probe(struct enetc_pf *pf)
+{
+	struct device *dev = &pf->si->pdev->dev;
+	struct enetc_mdio_priv *mdio_priv;
+	struct device_node *np;
+	struct mii_bus *bus;
+	int err;
+
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = "Freescale ENETC MDIO Bus";
+	bus->read = enetc_mdio_read;
+	bus->write = enetc_mdio_write;
+	bus->parent = dev;
+	mdio_priv = bus->priv;
+	mdio_priv->hw = &pf->si->hw;
+	mdio_priv->mdio_base = ENETC_EMDIO_BASE;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
+
+	np = of_get_child_by_name(dev->of_node, "mdio");
+	if (!np) {
+		dev_err(dev, "MDIO node missing\n");
+		return -EINVAL;
+	}
+
+	err = of_mdiobus_register(bus, np);
+	if (err) {
+		of_node_put(np);
+		dev_err(dev, "cannot register MDIO bus\n");
+		return err;
+	}
+
+	of_node_put(np);
+	pf->mdio = bus;
+
+	return 0;
+}
+
+static void enetc_mdio_remove(struct enetc_pf *pf)
+{
+	if (pf->mdio)
+		mdiobus_unregister(pf->mdio);
+}
+
 static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 {
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 10dd1b53bb08..59e65a6f6c3e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -49,7 +49,3 @@ struct enetc_pf {
 int enetc_msg_psi_init(struct enetc_pf *pf);
 void enetc_msg_psi_free(struct enetc_pf *pf);
 void enetc_msg_handle_rxmsg(struct enetc_pf *pf, int mbox_id, u16 *status);
-
-/* MDIO */
-int enetc_mdio_probe(struct enetc_pf *pf);
-void enetc_mdio_remove(struct enetc_pf *pf);
diff --git a/include/linux/fsl/enetc_mdio.h b/include/linux/fsl/enetc_mdio.h
new file mode 100644
index 000000000000..4875dd38af7e
--- /dev/null
+++ b/include/linux/fsl/enetc_mdio.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2019 NXP */
+
+#ifndef _FSL_ENETC_MDIO_H_
+#define _FSL_ENETC_MDIO_H_
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
+struct enetc_hw;
+
+struct enetc_mdio_priv {
+	struct enetc_hw *hw;
+	int mdio_base;
+};
+
+#if IS_REACHABLE(CONFIG_FSL_ENETC_MDIO)
+
+int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum);
+int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value);
+struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs);
+
+#else
+
+static inline int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
+{ return -EINVAL; }
+static inline int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
+				   u16 value)
+{ return -EINVAL; }
+struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
+{ return ERR_PTR(-EINVAL); }
+
+#endif
+
+#endif
-- 
2.17.1

