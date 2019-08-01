Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA997DAA4
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 13:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731156AbfHALxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 07:53:01 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53764 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730927AbfHALw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 07:52:58 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 00D7A2000A8;
        Thu,  1 Aug 2019 13:52:56 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E73BF20008C;
        Thu,  1 Aug 2019 13:52:55 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 81F00205E3;
        Thu,  1 Aug 2019 13:52:55 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     andrew@lunn.ch, Rob Herring <robh+dt@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, alexandru.marginean@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 3/5] enetc: Add mdio bus driver for the PCIe MDIO endpoint
Date:   Thu,  1 Aug 2019 14:52:51 +0300
Message-Id: <1564660373-4607-4-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564660373-4607-1-git-send-email-claudiu.manoil@nxp.com>
References: <1564660373-4607-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENETC ports can manage the MDIO bus via local register
interface.  However there's also a centralized way
to manage the MDIO bus, via the MDIO PCIe endpoint
device integrated by the same root complex that also
integrates the ENETC ports (eth controllers).

Depending on board design and use case, centralized
access to MDIO may be better than using local ENETC
port registers.  For instance, on the LS1028A QDS board
where MDIO muxing is required.  Also, the LS1028A on-chip
switch doesn't have a local MDIO register interface.

The current patch registers the above PCIe endpoint as a
separate MDIO bus and provides a driver for it by re-using
the code used for local MDIO access.  It also allows the
ENETC port PHYs to be managed by this driver if the local
"mdio" node is missing from the ENETC port node.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v1 - fixed mdio bus allocation
   - requested only BAR0 region, as it's the only one used by the driver
v2 - reworked accessors as per Andrew Lunn's request
v3 - none
v4 - err path check fix
v5 - refactored as separate kbuild module, to fix loadable module build

 drivers/net/ethernet/freescale/enetc/Kconfig  |   9 ++
 drivers/net/ethernet/freescale/enetc/Makefile |   3 +
 .../net/ethernet/freescale/enetc/enetc_mdio.c |  11 +-
 .../net/ethernet/freescale/enetc/enetc_mdio.h |  12 +++
 .../ethernet/freescale/enetc/enetc_pci_mdio.c | 101 ++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   5 +-
 6 files changed, 132 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_mdio.h
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index ed0d010c7cf2..9c530f75134f 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -18,6 +18,15 @@ config FSL_ENETC_VF
 
 	  If compiled as module (M), the module name is fsl-enetc-vf.
 
+config FSL_ENETC_MDIO
+	tristate "ENETC MDIO driver"
+	depends on PCI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	help
+	  This driver supports NXP ENETC Central MDIO controller as a PCIe
+	  physical function (PF) device.
+
+	  If compiled as module (M), the module name is fsl-enetc-mdio.
+
 config FSL_ENETC_PTP_CLOCK
 	tristate "ENETC PTP clock driver"
 	depends on PTP_1588_CLOCK_QORIQ && (FSL_ENETC || FSL_ENETC_VF)
diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index 164453a5dc1d..d200c27c3bf6 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -9,5 +9,8 @@ fsl-enetc-$(CONFIG_PCI_IOV) += enetc_msg.o
 obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
 fsl-enetc-vf-y := enetc_vf.o $(common-objs)
 
+obj-$(CONFIG_FSL_ENETC_MDIO) += fsl-enetc-mdio.o
+fsl-enetc-mdio-y := enetc_pci_mdio.o enetc_mdio.o
+
 obj-$(CONFIG_FSL_ENETC_PTP_CLOCK) += fsl-enetc-ptp.o
 fsl-enetc-ptp-y := enetc_ptp.o
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 05094601ece8..149883c8f0b8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -6,7 +6,7 @@
 #include <linux/iopoll.h>
 #include <linux/of.h>
 
-#include "enetc_pf.h"
+#include "enetc_mdio.h"
 
 #define	ENETC_MDIO_REG_OFFSET	0x1c00
 #define	ENETC_MDIO_CFG	0x0	/* MDIO configuration and status */
@@ -20,10 +20,6 @@
 	enetc_port_wr(hw, ENETC_##off + ENETC_MDIO_REG_OFFSET, val)
 #define enetc_mdio_rd_reg(off)	enetc_mdio_rd(hw, off)
 
-struct enetc_mdio_priv {
-	struct enetc_hw *hw;
-};
-
 #define ENETC_MDC_DIV		258
 
 #define MDIO_CFG_CLKDIV(x)	((((x) >> 1) & 0xff) << 8)
@@ -47,8 +43,7 @@ static int enetc_mdio_wait_complete(struct enetc_hw *hw)
 				  !(val & MDIO_CFG_BSY), 10, 10 * TIMEOUT);
 }
 
-static int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
-			    u16 value)
+int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 {
 	struct enetc_mdio_priv *mdio_priv = bus->priv;
 	struct enetc_hw *hw = mdio_priv->hw;
@@ -95,7 +90,7 @@ static int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
 	return 0;
 }
 
-static int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
+int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 {
 	struct enetc_mdio_priv *mdio_priv = bus->priv;
 	struct enetc_hw *hw = mdio_priv->hw;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.h b/drivers/net/ethernet/freescale/enetc/enetc_mdio.h
new file mode 100644
index 000000000000..60c9a3889824
--- /dev/null
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2019 NXP */
+
+#include <linux/phy.h>
+#include "enetc_pf.h"
+
+struct enetc_mdio_priv {
+	struct enetc_hw *hw;
+};
+
+int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value);
+int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
new file mode 100644
index 000000000000..fbd41ce01f06
--- /dev/null
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2019 NXP */
+#include <linux/of_mdio.h>
+#include "enetc_mdio.h"
+
+#define ENETC_MDIO_DEV_ID	0xee01
+#define ENETC_MDIO_DEV_NAME	"FSL PCIe IE Central MDIO"
+#define ENETC_MDIO_BUS_NAME	ENETC_MDIO_DEV_NAME " Bus"
+#define ENETC_MDIO_DRV_NAME	ENETC_MDIO_DEV_NAME " driver"
+
+static int enetc_pci_mdio_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct enetc_mdio_priv *mdio_priv;
+	struct device *dev = &pdev->dev;
+	struct enetc_hw *hw;
+	struct mii_bus *bus;
+	int err;
+
+	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
+	if (!hw)
+		return -ENOMEM;
+
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = ENETC_MDIO_BUS_NAME;
+	bus->read = enetc_mdio_read;
+	bus->write = enetc_mdio_write;
+	bus->parent = dev;
+	mdio_priv = bus->priv;
+	mdio_priv->hw = hw;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
+
+	pcie_flr(pdev);
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		dev_err(dev, "device enable failed\n");
+		return err;
+	}
+
+	err = pci_request_region(pdev, 0, KBUILD_MODNAME);
+	if (err) {
+		dev_err(dev, "pci_request_region failed\n");
+		goto err_pci_mem_reg;
+	}
+
+	hw->port = pci_iomap(pdev, 0, 0);
+	if (!hw->port) {
+		err = -ENXIO;
+		dev_err(dev, "iomap failed\n");
+		goto err_ioremap;
+	}
+
+	err = of_mdiobus_register(bus, dev->of_node);
+	if (err)
+		goto err_mdiobus_reg;
+
+	pci_set_drvdata(pdev, bus);
+
+	return 0;
+
+err_mdiobus_reg:
+	iounmap(mdio_priv->hw->port);
+err_ioremap:
+	pci_release_mem_regions(pdev);
+err_pci_mem_reg:
+	pci_disable_device(pdev);
+
+	return err;
+}
+
+static void enetc_pci_mdio_remove(struct pci_dev *pdev)
+{
+	struct mii_bus *bus = pci_get_drvdata(pdev);
+	struct enetc_mdio_priv *mdio_priv;
+
+	mdiobus_unregister(bus);
+	mdio_priv = bus->priv;
+	iounmap(mdio_priv->hw->port);
+	pci_release_mem_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static const struct pci_device_id enetc_pci_mdio_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_FREESCALE, ENETC_MDIO_DEV_ID) },
+	{ 0, } /* End of table. */
+};
+MODULE_DEVICE_TABLE(pci, enetc_pci_mdio_id_table);
+
+static struct pci_driver enetc_pci_mdio_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = enetc_pci_mdio_id_table,
+	.probe = enetc_pci_mdio_probe,
+	.remove = enetc_pci_mdio_remove,
+};
+module_pci_driver(enetc_pci_mdio_driver);
+
+MODULE_DESCRIPTION(ENETC_MDIO_DRV_NAME);
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 258b3cb38a6f..7d6513ff8507 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -750,6 +750,7 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 {
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
 	struct device_node *np = priv->dev->of_node;
+	struct device_node *mdio_np;
 	int err;
 
 	if (!np) {
@@ -773,7 +774,9 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 		priv->phy_node = of_node_get(np);
 	}
 
-	if (!of_phy_is_fixed_link(np)) {
+	mdio_np = of_get_child_by_name(np, "mdio");
+	if (mdio_np) {
+		of_node_put(mdio_np);
 		err = enetc_mdio_probe(pf);
 		if (err) {
 			of_node_put(priv->phy_node);
-- 
2.17.1

