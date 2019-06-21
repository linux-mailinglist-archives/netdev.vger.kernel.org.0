Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D8B4EC3B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfFUPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:39:04 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48390 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbfFUPjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:39:01 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 93F392009FE;
        Fri, 21 Jun 2019 17:38:57 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 836B1200071;
        Fri, 21 Jun 2019 17:38:57 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id F3E5820629;
        Fri, 21 Jun 2019 17:38:56 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Catalin Horghidan <catalin.horghidan@gmail.com>
Subject: [PATCH net-next 6/6] net/mssc/ocelot: Add basic Felix switch driver
Date:   Fri, 21 Jun 2019 18:38:52 +0300
Message-Id: <1561131532-14860-7-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This supports a switch core ethernet device from Microsemi
(VSC9959) that can be integrated on different SoCs as a PCIe
endpoint device.

The switchdev functionality is provided by the core Ocelot
switch driver. In this regard, the current driver is an
instance of Microsemi's Ocelot core driver.

The patch adds the PCI device driver part and defines the
register map for the Felix switch core, as it has some
differences in register addresses and bitfield mappings
compared to the Ocelot switch.  Also some registers or
bitfields present on Ocelot are not available on Felix.
That's why this driver has its own register map instance.
Other than that, the common registers and bitfields have the
same functionality and share the same name.

In a few cases, some h/w operations have to be done differently
on Felix due to missing bitfields.  This is the case for the
switch core reset and init.  Because for this operation Ocelot
uses some bits that are not present on Felix, the later has to
use a register from the global registers block (GCB) instead.

Signed-off-by: Catalin Horghidan <catalin.horghidan@gmail.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/mscc/Kconfig       |   8 +
 drivers/net/ethernet/mscc/Makefile      |   9 +-
 drivers/net/ethernet/mscc/felix_board.c | 392 +++++++++++++++++++++
 drivers/net/ethernet/mscc/felix_regs.c  | 448 ++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h      |   7 +
 5 files changed, 862 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/felix_board.c
 create mode 100644 drivers/net/ethernet/mscc/felix_regs.c

diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index bcec0587cf61..e5a7fa69307e 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -29,4 +29,12 @@ config MSCC_OCELOT_SWITCH_OCELOT
 	  This driver supports the Ocelot network switch device as present on
 	  the Ocelot SoCs.
 
+config MSCC_FELIX_SWITCH
+	tristate "Felix switch driver"
+	depends on MSCC_OCELOT_SWITCH
+	depends on PCI
+	help
+	  This driver supports the Felix network switch device, connected as a
+	  PCI device.
+
 endif # NET_VENDOR_MICROSEMI
diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 9a36c26095c8..81593feb2ea1 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -1,5 +1,10 @@
 # SPDX-License-Identifier: (GPL-2.0 OR MIT)
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot_common.o
 mscc_ocelot_common-y := ocelot.o ocelot_io.o
-mscc_ocelot_common-y += ocelot_regs.o ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o
-obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += ocelot_board.o
+mscc_ocelot_common-y += ocelot_tc.o ocelot_police.o ocelot_ace.o ocelot_flower.o
+
+obj-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) += mscc_ocelot.o
+mscc_ocelot-$(CONFIG_MSCC_OCELOT_SWITCH_OCELOT) := ocelot_regs.o ocelot_board.o
+
+obj-$(CONFIG_MSCC_FELIX_SWITCH) += mscc_felix.o
+mscc_felix-$(CONFIG_MSCC_FELIX_SWITCH) := felix_regs.o felix_board.o
diff --git a/drivers/net/ethernet/mscc/felix_board.c b/drivers/net/ethernet/mscc/felix_board.c
new file mode 100644
index 000000000000..57f7a897b3ae
--- /dev/null
+++ b/drivers/net/ethernet/mscc/felix_board.c
@@ -0,0 +1,392 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Felix Switch driver
+ *
+ * Copyright 2018-2019 NXP
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/phy_fixed.h>
+#include <linux/phy.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/iopoll.h>
+#include <net/switchdev.h>
+#include "ocelot.h"
+
+#define FELIX_DRV_VER_MAJ 1
+#define FELIX_DRV_VER_MIN 0
+
+#define FELIX_DRV_STR	"Felix Switch driver"
+#define FELIX_DRV_VER_STR __stringify(FELIX_DRV_VER_MAJ) "." \
+			  __stringify(FELIX_DRV_VER_MIN)
+
+#define PCI_DEVICE_ID_FELIX	0xEEF0
+
+/* Switch register block BAR */
+#define FELIX_SWITCH_BAR	4
+
+static struct pci_device_id felix_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_FREESCALE, PCI_DEVICE_ID_FELIX) },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, felix_ids);
+
+static struct {
+	enum ocelot_target id;
+	struct resource res;
+} felix_io_res[] = {
+	{	.id = ANA,
+		{
+			.start = 0x0280000,
+			.end = 0x028ffff,
+			.name = "ana",
+		}
+	},
+	{	.id = QS,
+		{
+			.start = 0x0080000,
+			.end = 0x00800ff,
+			.name = "qs",
+		}
+	},
+	{	.id = QSYS,
+		{
+			.start = 0x0200000,
+			.end = 0x021ffff,
+			.name = "qsys",
+		}
+	},
+	{	.id = REW,
+		{
+			.start = 0x0030000,
+			.end = 0x003ffff,
+			.name = "rew",
+		}
+	},
+	{	.id = SYS,
+		{
+			.start = 0x0010000,
+			.end = 0x001ffff,
+			.name = "sys",
+		}
+	},
+	{	.id = S2,
+		{
+			.start = 0x0060000,
+			.end = 0x00603ff,
+			.name = "s2",
+		}
+	},
+	{	.id = GCB,
+		{
+			.start = 0x0070000,
+			.end = 0x00701ff,
+			.name = "devcpu_gcb",
+		}
+	}
+};
+
+#define FELIX_MAX_NUM_PHY_PORTS	6
+
+#define FELIX_PORT_RES_START	0x0100000
+#define FELIX_PORT_RES_SIZE	0x10000
+
+static void __iomem *regs;
+
+static void felix_release_ports(struct ocelot *ocelot)
+{
+	struct ocelot_port *ocelot_port;
+	struct phy_device *phydev;
+	struct device_node *dn;
+	int i;
+
+	for (i = 0; i < ocelot->num_phys_ports; i++) {
+		ocelot_port = ocelot->ports[i];
+		if (!ocelot_port || !ocelot_port->phy || !ocelot_port->dev)
+			continue;
+
+		phydev = ocelot_port->phy;
+		unregister_netdev(ocelot_port->dev);
+		free_netdev(ocelot_port->dev);
+
+		if (phy_is_pseudo_fixed_link(phydev)) {
+			dn = phydev->mdio.dev.of_node;
+			/* decr refcnt: of_phy_register_fixed_link */
+			of_phy_deregister_fixed_link(dn);
+		}
+		phy_device_free(phydev); /* decr refcnt: of_phy_find_device */
+	}
+}
+
+static int felix_ports_init(struct pci_dev *pdev)
+{
+	struct ocelot *ocelot = pci_get_drvdata(pdev);
+	struct device_node *np = ocelot->dev->of_node;
+	struct device_node *phy_node, *portnp;
+	struct phy_device *phydev;
+	void __iomem *port_regs;
+	resource_size_t base;
+	u32 port;
+	int err;
+
+	ocelot->num_phys_ports = FELIX_MAX_NUM_PHY_PORTS;
+
+	np = of_get_child_by_name(np, "ethernet-ports");
+	if (!np) {
+		dev_err(&pdev->dev, "ethernet-ports sub-node not found\n");
+		return -ENODEV;
+	}
+
+	/* alloc netdev for each port */
+	err = ocelot_init(ocelot);
+	if (err)
+		return err;
+
+	base = pci_resource_start(pdev, FELIX_SWITCH_BAR);
+	for_each_available_child_of_node(np, portnp) {
+		struct resource res = {};
+		int phy_mode;
+
+		if (!portnp || !portnp->name ||
+		    of_node_cmp(portnp->name, "port") ||
+		    of_property_read_u32(portnp, "reg", &port))
+			continue;
+
+		if (port >= FELIX_MAX_NUM_PHY_PORTS) {
+			dev_err(ocelot->dev, "invalid port num: %d\n", port);
+			continue;
+		}
+
+		res.start = base + FELIX_PORT_RES_START +
+			    FELIX_PORT_RES_SIZE * port;
+		res.end = res.start + FELIX_PORT_RES_SIZE - 1;
+		res.flags = IORESOURCE_MEM;
+		res.name = "port";
+
+		port_regs = devm_ioremap_resource(ocelot->dev, &res);
+		if (IS_ERR(port_regs)) {
+			dev_err(ocelot->dev,
+				"failed to map registers for port %d\n", port);
+			continue;
+		}
+
+		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
+		if (!phy_node) {
+			if (!of_phy_is_fixed_link(portnp))
+				continue;
+
+			err = of_phy_register_fixed_link(portnp);
+			if (err < 0) {
+				dev_err(ocelot->dev,
+					"can't create fixed link for port:%d\n",
+					port);
+				continue;
+			}
+			phydev = of_phy_find_device(portnp);
+		} else {
+			phydev = of_phy_find_device(phy_node);
+		}
+
+		of_node_put(phy_node);
+
+		if (!phydev)
+			continue;
+
+		phy_mode = of_get_phy_mode(portnp);
+		if (phy_mode < 0)
+			phy_mode = PHY_INTERFACE_MODE_NA;
+
+		err = ocelot_probe_port(ocelot, port, port_regs, phydev);
+		if (err) {
+			dev_err(ocelot->dev, "failed to probe ports\n");
+			goto release_ports;
+		}
+
+		/* Felix configs */
+		ocelot->ports[port]->phy_mode = phy_mode;
+	}
+
+	return 0;
+
+release_ports:
+	felix_release_ports(ocelot);
+
+	return err;
+}
+
+#define FELIX_INIT_TIMEOUT	50000
+#define FELIX_GCB_RST_SLEEP	100
+#define FELIX_SYS_RAMINIT_SLEEP	80
+
+static int felix_gcb_soft_rst_status(struct ocelot *ocelot)
+{
+	int val;
+
+	regmap_field_read(ocelot->regfields[GCB_SOFT_RST_SWC_RST], &val);
+	return val;
+}
+
+static int felix_sys_ram_init_status(struct ocelot *ocelot)
+{
+	return ocelot_read(ocelot, SYS_RAM_INIT);
+}
+
+static int felix_init_switch_core(struct ocelot *ocelot)
+{
+	int val, err;
+
+	/* soft-reset the switch core */
+	regmap_field_write(ocelot->regfields[GCB_SOFT_RST_SWC_RST], 1);
+
+	err = readx_poll_timeout(felix_gcb_soft_rst_status, ocelot, val, !val,
+				 FELIX_GCB_RST_SLEEP, FELIX_INIT_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "timeout: switch core reset\n");
+		return err;
+	}
+
+	/* initialize switch mem ~40us */
+	ocelot_write(ocelot, SYS_RAM_INIT_RAM_INIT, SYS_RAM_INIT);
+	err = readx_poll_timeout(felix_sys_ram_init_status, ocelot, val, !val,
+				 FELIX_SYS_RAMINIT_SLEEP, FELIX_INIT_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "timeout: switch sram init\n");
+		return err;
+	}
+
+	/* enable switch core */
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+
+	return 0;
+}
+
+static int felix_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ocelot *ocelot;
+	resource_size_t base;
+	size_t len;
+	int i, err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "device enable failed\n");
+		return err;
+	}
+
+	/* set up for high or low dma */
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (err) {
+			dev_err(&pdev->dev,
+				"DMA configuration failed: 0x%x\n", err);
+			goto err_dma;
+		}
+	}
+
+	base = pci_resource_start(pdev, FELIX_SWITCH_BAR);
+
+	pci_set_master(pdev);
+
+	ocelot = devm_kzalloc(&pdev->dev, sizeof(*ocelot), GFP_KERNEL);
+	if (!ocelot) {
+		err = -ENOMEM;
+		goto err_alloc_ocelot;
+	}
+
+	pci_set_drvdata(pdev, ocelot);
+	ocelot->dev = &pdev->dev;
+
+	len = pci_resource_len(pdev, FELIX_SWITCH_BAR);
+	if (!len) {
+		err = -EINVAL;
+		goto err_resource_len;
+	}
+
+	regs = pci_iomap(pdev, FELIX_SWITCH_BAR, len);
+	if (!regs) {
+		err = -ENXIO;
+		dev_err(&pdev->dev, "ioremap() failed\n");
+		goto err_iomap;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(felix_io_res); i++) {
+		struct resource *res = &felix_io_res[i].res;
+		struct regmap *target;
+
+		res->flags = IORESOURCE_MEM;
+		res->start += base;
+		res->end += base;
+
+		target = ocelot_io_init(ocelot, res);
+		if (IS_ERR(target)) {
+			err = PTR_ERR(target);
+			goto err_iomap;
+		}
+
+		ocelot->targets[felix_io_res[i].id] = target;
+	}
+
+	err = felix_chip_init(ocelot);
+	if (err)
+		goto err_chip_init;
+
+	err = felix_init_switch_core(ocelot);
+	if (err)
+		goto err_sw_core_init;
+
+	err = felix_ports_init(pdev);
+	if (err)
+		goto err_ports_init;
+
+	register_netdevice_notifier(&ocelot_netdevice_nb);
+	register_switchdev_notifier(&ocelot_switchdev_nb);
+	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
+
+	dev_info(&pdev->dev, "%s v%s\n", FELIX_DRV_STR, FELIX_DRV_VER_STR);
+	return 0;
+
+err_ports_init:
+err_chip_init:
+err_sw_core_init:
+	pci_iounmap(pdev, regs);
+err_iomap:
+err_resource_len:
+err_alloc_ocelot:
+err_dma:
+	pci_disable_device(pdev);
+
+	return err;
+}
+
+static void felix_pci_remove(struct pci_dev *pdev)
+{
+	struct ocelot *ocelot;
+
+	ocelot = pci_get_drvdata(pdev);
+
+	/* stop workqueue thread */
+	ocelot_deinit(ocelot);
+	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
+	unregister_switchdev_notifier(&ocelot_switchdev_nb);
+	unregister_netdevice_notifier(&ocelot_netdevice_nb);
+
+	felix_release_ports(ocelot);
+
+	pci_iounmap(pdev, regs);
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver felix_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = felix_ids,
+	.probe = felix_pci_probe,
+	.remove = felix_pci_remove,
+};
+
+module_pci_driver(felix_pci_driver);
+
+MODULE_DESCRIPTION(FELIX_DRV_STR);
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/net/ethernet/mscc/felix_regs.c b/drivers/net/ethernet/mscc/felix_regs.c
new file mode 100644
index 000000000000..33e545505b4e
--- /dev/null
+++ b/drivers/net/ethernet/mscc/felix_regs.c
@@ -0,0 +1,448 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Felix Switch driver
+ *
+ * Copyright 2017 Microsemi Corporation
+ * Copyright 2018-2019 NXP
+ */
+#include "ocelot.h"
+
+static const u32 felix_ana_regmap[] = {
+	REG(ANA_ADVLEARN,                  0x0089a0),
+	REG(ANA_VLANMASK,                  0x0089a4),
+	REG_RESERVED(ANA_PORT_B_DOMAIN),
+	REG(ANA_ANAGEFIL,                  0x0089ac),
+	REG(ANA_ANEVENTS,                  0x0089b0),
+	REG(ANA_STORMLIMIT_BURST,          0x0089b4),
+	REG(ANA_STORMLIMIT_CFG,            0x0089b8),
+	REG(ANA_ISOLATED_PORTS,            0x0089c8),
+	REG(ANA_COMMUNITY_PORTS,           0x0089cc),
+	REG(ANA_AUTOAGE,                   0x0089d0),
+	REG(ANA_MACTOPTIONS,               0x0089d4),
+	REG(ANA_LEARNDISC,                 0x0089d8),
+	REG(ANA_AGENCTRL,                  0x0089dc),
+	REG(ANA_MIRRORPORTS,               0x0089e0),
+	REG(ANA_EMIRRORPORTS,              0x0089e4),
+	REG(ANA_FLOODING,                  0x0089e8),
+	REG(ANA_FLOODING_IPMC,             0x008a08),
+	REG(ANA_SFLOW_CFG,                 0x008a0c),
+	REG(ANA_PORT_MODE,                 0x008a28),
+	REG(ANA_CUT_THRU_CFG,              0x008a48),
+	REG(ANA_PGID_PGID,                 0x008400),
+	REG(ANA_TABLES_ANMOVED,            0x007f1c),
+	REG(ANA_TABLES_MACHDATA,           0x007f20),
+	REG(ANA_TABLES_MACLDATA,           0x007f24),
+	REG(ANA_TABLES_STREAMDATA,         0x007f28),
+	REG(ANA_TABLES_MACACCESS,          0x007f2c),
+	REG(ANA_TABLES_MACTINDX,           0x007f30),
+	REG(ANA_TABLES_VLANACCESS,         0x007f34),
+	REG(ANA_TABLES_VLANTIDX,           0x007f38),
+	REG(ANA_TABLES_ISDXACCESS,         0x007f3c),
+	REG(ANA_TABLES_ISDXTIDX,           0x007f40),
+	REG(ANA_TABLES_ENTRYLIM,           0x007f00),
+	REG(ANA_TABLES_PTP_ID_HIGH,        0x007f44),
+	REG(ANA_TABLES_PTP_ID_LOW,         0x007f48),
+	REG(ANA_TABLES_STREAMACCESS,       0x007f4c),
+	REG(ANA_TABLES_STREAMTIDX,         0x007f50),
+	REG(ANA_TABLES_SEQ_HISTORY,        0x007f54),
+	REG(ANA_TABLES_SEQ_MASK,           0x007f58),
+	REG(ANA_TABLES_SFID_MASK,          0x007f5c),
+	REG(ANA_TABLES_SFIDACCESS,         0x007f60),
+	REG(ANA_TABLES_SFIDTIDX,           0x007f64),
+	REG(ANA_MSTI_STATE,                0x008600),
+	REG(ANA_OAM_UPM_LM_CNT,            0x008000),
+	REG(ANA_SG_ACCESS_CTRL,            0x008a64),
+	REG(ANA_SG_CONFIG_REG_1,           0x007fb0),
+	REG(ANA_SG_CONFIG_REG_2,           0x007fb4),
+	REG(ANA_SG_CONFIG_REG_3,           0x007fb8),
+	REG(ANA_SG_CONFIG_REG_4,           0x007fbc),
+	REG(ANA_SG_CONFIG_REG_5,           0x007fc0),
+	REG(ANA_SG_GCL_GS_CONFIG,          0x007f80),
+	REG(ANA_SG_GCL_TI_CONFIG,          0x007f90),
+	REG(ANA_SG_STATUS_REG_1,           0x008980),
+	REG(ANA_SG_STATUS_REG_2,           0x008984),
+	REG(ANA_SG_STATUS_REG_3,           0x008988),
+	REG(ANA_PORT_VLAN_CFG,             0x007800),
+	REG(ANA_PORT_DROP_CFG,             0x007804),
+	REG(ANA_PORT_QOS_CFG,              0x007808),
+	REG(ANA_PORT_VCAP_CFG,             0x00780c),
+	REG(ANA_PORT_VCAP_S1_KEY_CFG,      0x007810),
+	REG(ANA_PORT_VCAP_S2_CFG,          0x00781c),
+	REG(ANA_PORT_PCP_DEI_MAP,          0x007820),
+	REG(ANA_PORT_CPU_FWD_CFG,          0x007860),
+	REG(ANA_PORT_CPU_FWD_BPDU_CFG,     0x007864),
+	REG(ANA_PORT_CPU_FWD_GARP_CFG,     0x007868),
+	REG(ANA_PORT_CPU_FWD_CCM_CFG,      0x00786c),
+	REG(ANA_PORT_PORT_CFG,             0x007870),
+	REG(ANA_PORT_POL_CFG,              0x007874),
+	REG(ANA_PORT_PTP_CFG,              0x007878),
+	REG(ANA_PORT_PTP_DLY1_CFG,         0x00787c),
+	REG(ANA_PORT_PTP_DLY2_CFG,         0x007880),
+	REG(ANA_PORT_SFID_CFG,             0x007884),
+	REG(ANA_PFC_PFC_CFG,               0x008800),
+	REG_RESERVED(ANA_PFC_PFC_TIMER),
+	REG_RESERVED(ANA_IPT_OAM_MEP_CFG),
+	REG_RESERVED(ANA_IPT_IPT),
+	REG_RESERVED(ANA_PPT_PPT),
+	REG_RESERVED(ANA_FID_MAP_FID_MAP),
+	REG(ANA_AGGR_CFG,                  0x008a68),
+	REG(ANA_CPUQ_CFG,                  0x008a6c),
+	REG_RESERVED(ANA_CPUQ_CFG2),
+	REG(ANA_CPUQ_8021_CFG,             0x008a74),
+	REG(ANA_DSCP_CFG,                  0x008ab4),
+	REG(ANA_DSCP_REWR_CFG,             0x008bb4),
+	REG(ANA_VCAP_RNG_TYPE_CFG,         0x008bf4),
+	REG(ANA_VCAP_RNG_VAL_CFG,          0x008c14),
+	REG_RESERVED(ANA_VRAP_CFG),
+	REG_RESERVED(ANA_VRAP_HDR_DATA),
+	REG_RESERVED(ANA_VRAP_HDR_MASK),
+	REG(ANA_DISCARD_CFG,               0x008c40),
+	REG(ANA_FID_CFG,                   0x008c44),
+	REG(ANA_POL_PIR_CFG,               0x004000),
+	REG(ANA_POL_CIR_CFG,               0x004004),
+	REG(ANA_POL_MODE_CFG,              0x004008),
+	REG(ANA_POL_PIR_STATE,             0x00400c),
+	REG(ANA_POL_CIR_STATE,             0x004010),
+	REG_RESERVED(ANA_POL_STATE),
+	REG(ANA_POL_FLOWC,                 0x008c48),
+	REG(ANA_POL_HYST,                  0x008cb4),
+	REG_RESERVED(ANA_POL_MISC_CFG),
+};
+
+static const u32 felix_qs_regmap[] = {
+	REG(QS_XTR_GRP_CFG,                0x000000),
+	REG(QS_XTR_RD,                     0x000008),
+	REG(QS_XTR_FRM_PRUNING,            0x000010),
+	REG(QS_XTR_FLUSH,                  0x000018),
+	REG(QS_XTR_DATA_PRESENT,           0x00001c),
+	REG(QS_XTR_CFG,                    0x000020),
+	REG(QS_INJ_GRP_CFG,                0x000024),
+	REG(QS_INJ_WR,                     0x00002c),
+	REG(QS_INJ_CTRL,                   0x000034),
+	REG(QS_INJ_STATUS,                 0x00003c),
+	REG(QS_INJ_ERR,                    0x000040),
+	REG_RESERVED(QS_INH_DBG),
+};
+
+static const u32 felix_s2_regmap[] = {
+	REG(S2_CORE_UPDATE_CTRL,           0x000000),
+	REG(S2_CORE_MV_CFG,                0x000004),
+	REG(S2_CACHE_ENTRY_DAT,            0x000008),
+	REG(S2_CACHE_MASK_DAT,             0x000108),
+	REG(S2_CACHE_ACTION_DAT,           0x000208),
+	REG(S2_CACHE_CNT_DAT,              0x000308),
+	REG(S2_CACHE_TG_DAT,               0x000388),
+};
+
+static const u32 felix_qsys_regmap[] = {
+	REG(QSYS_PORT_MODE,                0x00f460),
+	REG(QSYS_SWITCH_PORT_MODE,         0x00f480),
+	REG(QSYS_STAT_CNT_CFG,             0x00f49c),
+	REG(QSYS_EEE_CFG,                  0x00f4a0),
+	REG(QSYS_EEE_THRES,                0x00f4b8),
+	REG(QSYS_IGR_NO_SHARING,           0x00f4bc),
+	REG(QSYS_EGR_NO_SHARING,           0x00f4c0),
+	REG(QSYS_SW_STATUS,                0x00f4c4),
+	REG(QSYS_EXT_CPU_CFG,              0x00f4e0),
+	REG_RESERVED(QSYS_PAD_CFG),
+	REG(QSYS_CPU_GROUP_MAP,            0x00f4e8),
+	REG_RESERVED(QSYS_QMAP),
+	REG_RESERVED(QSYS_ISDX_SGRP),
+	REG_RESERVED(QSYS_TIMED_FRAME_ENTRY),
+	REG(QSYS_TFRM_MISC,                0x00f50c),
+	REG(QSYS_TFRM_PORT_DLY,            0x00f510),
+	REG(QSYS_TFRM_TIMER_CFG_1,         0x00f514),
+	REG(QSYS_TFRM_TIMER_CFG_2,         0x00f518),
+	REG(QSYS_TFRM_TIMER_CFG_3,         0x00f51c),
+	REG(QSYS_TFRM_TIMER_CFG_4,         0x00f520),
+	REG(QSYS_TFRM_TIMER_CFG_5,         0x00f524),
+	REG(QSYS_TFRM_TIMER_CFG_6,         0x00f528),
+	REG(QSYS_TFRM_TIMER_CFG_7,         0x00f52c),
+	REG(QSYS_TFRM_TIMER_CFG_8,         0x00f530),
+	REG(QSYS_RED_PROFILE,              0x00f534),
+	REG(QSYS_RES_QOS_MODE,             0x00f574),
+	REG(QSYS_RES_CFG,                  0x00c000),
+	REG(QSYS_RES_STAT,                 0x00c004),
+	REG(QSYS_EGR_DROP_MODE,            0x00f578),
+	REG(QSYS_EQ_CTRL,                  0x00f57c),
+	REG_RESERVED(QSYS_EVENTS_CORE),
+	REG(QSYS_QMAXSDU_CFG_0,            0x00f584),
+	REG(QSYS_QMAXSDU_CFG_1,            0x00f5a0),
+	REG(QSYS_QMAXSDU_CFG_2,            0x00f5bc),
+	REG(QSYS_QMAXSDU_CFG_3,            0x00f5d8),
+	REG(QSYS_QMAXSDU_CFG_4,            0x00f5f4),
+	REG(QSYS_QMAXSDU_CFG_5,            0x00f610),
+	REG(QSYS_QMAXSDU_CFG_6,            0x00f62c),
+	REG(QSYS_QMAXSDU_CFG_7,            0x00f648),
+	REG(QSYS_PREEMPTION_CFG,           0x00f664),
+	REG_RESERVED(QSYS_CIR_CFG),
+	REG(QSYS_EIR_CFG,                  0x000004),
+	REG(QSYS_SE_CFG,                   0x000008),
+	REG(QSYS_SE_DWRR_CFG,              0x00000c),
+	REG_RESERVED(QSYS_SE_CONNECT),
+	REG(QSYS_SE_DLB_SENSE,             0x000040),
+	REG(QSYS_CIR_STATE,                0x000044),
+	REG(QSYS_EIR_STATE,                0x000048),
+	REG_RESERVED(QSYS_SE_STATE),
+	REG(QSYS_HSCH_MISC_CFG,            0x00f67c),
+	REG(QSYS_TAG_CONFIG,               0x00f680),
+	REG(QSYS_TAS_PARAM_CFG_CTRL,       0x00f698),
+	REG(QSYS_PORT_MAX_SDU,             0x00f69c),
+	REG(QSYS_PARAM_CFG_REG_1,          0x00f440),
+	REG(QSYS_PARAM_CFG_REG_2,          0x00f444),
+	REG(QSYS_PARAM_CFG_REG_3,          0x00f448),
+	REG(QSYS_PARAM_CFG_REG_4,          0x00f44c),
+	REG(QSYS_PARAM_CFG_REG_5,          0x00f450),
+	REG(QSYS_GCL_CFG_REG_1,            0x00f454),
+	REG(QSYS_GCL_CFG_REG_2,            0x00f458),
+	REG(QSYS_PARAM_STATUS_REG_1,       0x00f400),
+	REG(QSYS_PARAM_STATUS_REG_2,       0x00f404),
+	REG(QSYS_PARAM_STATUS_REG_3,       0x00f408),
+	REG(QSYS_PARAM_STATUS_REG_4,       0x00f40c),
+	REG(QSYS_PARAM_STATUS_REG_5,       0x00f410),
+	REG(QSYS_PARAM_STATUS_REG_6,       0x00f414),
+	REG(QSYS_PARAM_STATUS_REG_7,       0x00f418),
+	REG(QSYS_PARAM_STATUS_REG_8,       0x00f41c),
+	REG(QSYS_PARAM_STATUS_REG_9,       0x00f420),
+	REG(QSYS_GCL_STATUS_REG_1,         0x00f424),
+	REG(QSYS_GCL_STATUS_REG_2,         0x00f428),
+};
+
+static const u32 felix_rew_regmap[] = {
+	REG(REW_PORT_VLAN_CFG,             0x000000),
+	REG(REW_TAG_CFG,                   0x000004),
+	REG(REW_PORT_CFG,                  0x000008),
+	REG(REW_DSCP_CFG,                  0x00000c),
+	REG(REW_PCP_DEI_QOS_MAP_CFG,       0x000010),
+	REG(REW_PTP_CFG,                   0x000050),
+	REG(REW_PTP_DLY1_CFG,              0x000054),
+	REG(REW_RED_TAG_CFG,               0x000058),
+	REG(REW_DSCP_REMAP_DP1_CFG,        0x000410),
+	REG(REW_DSCP_REMAP_CFG,            0x000510),
+	REG_RESERVED(REW_STAT_CFG),
+	REG_RESERVED(REW_REW_STICKY),
+	REG_RESERVED(REW_PPT),
+};
+
+static const u32 felix_sys_regmap[] = {
+	REG(SYS_COUNT_RX_OCTETS,	   0x000000),
+	REG(SYS_COUNT_RX_MULTICAST,	   0x000008),
+	REG(SYS_COUNT_RX_SHORTS,	   0x000010),
+	REG(SYS_COUNT_RX_FRAGMENTS,	   0x000014),
+	REG(SYS_COUNT_RX_JABBERS,	   0x000018),
+	REG(SYS_COUNT_RX_64,		   0x000024),
+	REG(SYS_COUNT_RX_65_127,	   0x000028),
+	REG(SYS_COUNT_RX_128_255,	   0x00002c),
+	REG(SYS_COUNT_RX_256_1023,	   0x000030),
+	REG(SYS_COUNT_RX_1024_1526,	   0x000034),
+	REG(SYS_COUNT_RX_1527_MAX,	   0x000038),
+	REG(SYS_COUNT_RX_LONGS,		   0x000044),
+	REG(SYS_COUNT_TX_OCTETS,	   0x000200),
+	REG(SYS_COUNT_TX_COLLISION,	   0x000210),
+	REG(SYS_COUNT_TX_DROPS,		   0x000214),
+	REG(SYS_COUNT_TX_64,		   0x00021c),
+	REG(SYS_COUNT_TX_65_127,	   0x000220),
+	REG(SYS_COUNT_TX_128_511,	   0x000224),
+	REG(SYS_COUNT_TX_512_1023,	   0x000228),
+	REG(SYS_COUNT_TX_1024_1526,	   0x00022c),
+	REG(SYS_COUNT_TX_1527_MAX,	   0x000230),
+	REG(SYS_COUNT_TX_AGING,		   0x000278),
+	REG(SYS_RESET_CFG,                 0x000e00),
+	REG(SYS_SR_ETYPE_CFG,              0x000e04),
+	REG(SYS_VLAN_ETYPE_CFG,            0x000e08),
+	REG(SYS_PORT_MODE,                 0x000e0c),
+	REG(SYS_FRONT_PORT_MODE,           0x000e2c),
+	REG(SYS_FRM_AGING,                 0x000e44),
+	REG(SYS_STAT_CFG,                  0x000e48),
+	REG(SYS_SW_STATUS,                 0x000e4c),
+	REG_RESERVED(SYS_MISC_CFG),
+	REG(SYS_REW_MAC_HIGH_CFG,          0x000e6c),
+	REG(SYS_REW_MAC_LOW_CFG,           0x000e84),
+	REG(SYS_TIMESTAMP_OFFSET,          0x000e9c),
+	REG(SYS_PAUSE_CFG,                 0x000ea0),
+	REG(SYS_PAUSE_TOT_CFG,             0x000ebc),
+	REG(SYS_ATOP,                      0x000ec0),
+	REG(SYS_ATOP_TOT_CFG,              0x000edc),
+	REG(SYS_MAC_FC_CFG,                0x000ee0),
+	REG(SYS_MMGT,                      0x000ef8),
+	REG_RESERVED(SYS_MMGT_FAST),
+	REG_RESERVED(SYS_EVENTS_DIF),
+	REG_RESERVED(SYS_EVENTS_CORE),
+	REG_RESERVED(SYS_CNT),
+	REG(SYS_PTP_STATUS,                0x000f14),
+	REG(SYS_PTP_TXSTAMP,               0x000f18),
+	REG(SYS_PTP_NXT,                   0x000f1c),
+	REG(SYS_PTP_CFG,                   0x000f20),
+	REG(SYS_RAM_INIT,                  0x000f24),
+	REG_RESERVED(SYS_CM_ADDR),
+	REG_RESERVED(SYS_CM_DATA_WR),
+	REG_RESERVED(SYS_CM_DATA_RD),
+	REG_RESERVED(SYS_CM_OP),
+	REG_RESERVED(SYS_CM_DATA),
+};
+
+static const u32 felix_gcb_regmap[] = {
+	REG(GCB_SOFT_RST,                  0x000004),
+};
+
+static const u32 *felix_regmap[] = {
+	[ANA] = felix_ana_regmap,
+	[QS] = felix_qs_regmap,
+	[QSYS] = felix_qsys_regmap,
+	[REW] = felix_rew_regmap,
+	[SYS] = felix_sys_regmap,
+	[S2] = felix_s2_regmap,
+	[GCB] = felix_gcb_regmap,
+};
+
+static const struct reg_field felix_regfields[REGFIELD_MAX] = {
+	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 6, 6),
+	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 5),
+	[ANA_ANEVENTS_FLOOD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 30, 30),
+	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 26, 26),
+	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 24, 24),
+	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 23, 23),
+	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 22, 22),
+	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 21, 21),
+	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 20, 20),
+	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 19, 19),
+	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
+	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 17, 17),
+	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 15, 15),
+	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 14, 14),
+	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 13, 13),
+	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 12, 12),
+	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
+	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
+	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 9, 9),
+	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 8, 8),
+	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 7, 7),
+	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
+	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
+	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 4, 4),
+	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 3, 3),
+	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 2, 2),
+	[ANA_ANEVENTS_SEQ_GEN_ERR_0] = REG_FIELD(ANA_ANEVENTS, 1, 1),
+	[ANA_ANEVENTS_SEQ_GEN_ERR_1] = REG_FIELD(ANA_ANEVENTS, 0, 0),
+	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 16, 16),
+	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 11, 12),
+	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 10),
+	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 0, 0),
+	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 0, 0),
+};
+
+static const struct ocelot_stat_layout felix_stats_layout[] = {
+	{ .name = "rx_octets", .offset = 0x00, },
+	{ .name = "rx_unicast", .offset = 0x01, },
+	{ .name = "rx_multicast", .offset = 0x02, },
+	{ .name = "rx_broadcast", .offset = 0x03, },
+	{ .name = "rx_shorts", .offset = 0x04, },
+	{ .name = "rx_fragments", .offset = 0x05, },
+	{ .name = "rx_jabbers", .offset = 0x06, },
+	{ .name = "rx_crc_align_errs", .offset = 0x07, },
+	{ .name = "rx_sym_errs", .offset = 0x08, },
+	{ .name = "rx_frames_below_65_octets", .offset = 0x09, },
+	{ .name = "rx_frames_65_to_127_octets", .offset = 0x0A, },
+	{ .name = "rx_frames_128_to_255_octets", .offset = 0x0B, },
+	{ .name = "rx_frames_256_to_511_octets", .offset = 0x0C, },
+	{ .name = "rx_frames_512_to_1023_octets", .offset = 0x0D, },
+	{ .name = "rx_frames_1024_to_1526_octets", .offset = 0x0E, },
+	{ .name = "rx_frames_over_1526_octets", .offset = 0x0F, },
+	{ .name = "rx_pause", .offset = 0x10, },
+	{ .name = "rx_control", .offset = 0x11, },
+	{ .name = "rx_longs", .offset = 0x12, },
+	{ .name = "rx_classified_drops", .offset = 0x13, },
+	{ .name = "rx_red_prio_0", .offset = 0x14, },
+	{ .name = "rx_red_prio_1", .offset = 0x15, },
+	{ .name = "rx_red_prio_2", .offset = 0x16, },
+	{ .name = "rx_red_prio_3", .offset = 0x17, },
+	{ .name = "rx_red_prio_4", .offset = 0x18, },
+	{ .name = "rx_red_prio_5", .offset = 0x19, },
+	{ .name = "rx_red_prio_6", .offset = 0x1A, },
+	{ .name = "rx_red_prio_7", .offset = 0x1B, },
+	{ .name = "rx_yellow_prio_0", .offset = 0x1C, },
+	{ .name = "rx_yellow_prio_1", .offset = 0x1D, },
+	{ .name = "rx_yellow_prio_2", .offset = 0x1E, },
+	{ .name = "rx_yellow_prio_3", .offset = 0x1F, },
+	{ .name = "rx_yellow_prio_4", .offset = 0x20, },
+	{ .name = "rx_yellow_prio_5", .offset = 0x21, },
+	{ .name = "rx_yellow_prio_6", .offset = 0x22, },
+	{ .name = "rx_yellow_prio_7", .offset = 0x23, },
+	{ .name = "rx_green_prio_0", .offset = 0x24, },
+	{ .name = "rx_green_prio_1", .offset = 0x25, },
+	{ .name = "rx_green_prio_2", .offset = 0x26, },
+	{ .name = "rx_green_prio_3", .offset = 0x27, },
+	{ .name = "rx_green_prio_4", .offset = 0x28, },
+	{ .name = "rx_green_prio_5", .offset = 0x29, },
+	{ .name = "rx_green_prio_6", .offset = 0x2A, },
+	{ .name = "rx_green_prio_7", .offset = 0x2B, },
+	{ .name = "tx_octets", .offset = 0x80, },
+	{ .name = "tx_unicast", .offset = 0x81, },
+	{ .name = "tx_multicast", .offset = 0x82, },
+	{ .name = "tx_broadcast", .offset = 0x83, },
+	{ .name = "tx_collision", .offset = 0x84, },
+	{ .name = "tx_drops", .offset = 0x85, },
+	{ .name = "tx_pause", .offset = 0x86, },
+	{ .name = "tx_frames_below_65_octets", .offset = 0x87, },
+	{ .name = "tx_frames_65_to_127_octets", .offset = 0x88, },
+	{ .name = "tx_frames_128_255_octets", .offset = 0x89, },
+	{ .name = "tx_frames_256_511_octets", .offset = 0x8A, },
+	{ .name = "tx_frames_512_1023_octets", .offset = 0x8B, },
+	{ .name = "tx_frames_1024_1526_octets", .offset = 0x8C, },
+	{ .name = "tx_frames_over_1526_octets", .offset = 0x8D, },
+	{ .name = "tx_yellow_prio_0", .offset = 0x8E, },
+	{ .name = "tx_yellow_prio_1", .offset = 0x8F, },
+	{ .name = "tx_yellow_prio_2", .offset = 0x90, },
+	{ .name = "tx_yellow_prio_3", .offset = 0x91, },
+	{ .name = "tx_yellow_prio_4", .offset = 0x92, },
+	{ .name = "tx_yellow_prio_5", .offset = 0x93, },
+	{ .name = "tx_yellow_prio_6", .offset = 0x94, },
+	{ .name = "tx_yellow_prio_7", .offset = 0x95, },
+	{ .name = "tx_green_prio_0", .offset = 0x96, },
+	{ .name = "tx_green_prio_1", .offset = 0x97, },
+	{ .name = "tx_green_prio_2", .offset = 0x98, },
+	{ .name = "tx_green_prio_3", .offset = 0x99, },
+	{ .name = "tx_green_prio_4", .offset = 0x9A, },
+	{ .name = "tx_green_prio_5", .offset = 0x9B, },
+	{ .name = "tx_green_prio_6", .offset = 0x9C, },
+	{ .name = "tx_green_prio_7", .offset = 0x9D, },
+	{ .name = "tx_aged", .offset = 0x9E, },
+	{ .name = "drop_local", .offset = 0x100, },
+	{ .name = "drop_tail", .offset = 0x101, },
+	{ .name = "drop_yellow_prio_0", .offset = 0x102, },
+	{ .name = "drop_yellow_prio_1", .offset = 0x103, },
+	{ .name = "drop_yellow_prio_2", .offset = 0x104, },
+	{ .name = "drop_yellow_prio_3", .offset = 0x105, },
+	{ .name = "drop_yellow_prio_4", .offset = 0x106, },
+	{ .name = "drop_yellow_prio_5", .offset = 0x107, },
+	{ .name = "drop_yellow_prio_6", .offset = 0x108, },
+	{ .name = "drop_yellow_prio_7", .offset = 0x109, },
+	{ .name = "drop_green_prio_0", .offset = 0x10A, },
+	{ .name = "drop_green_prio_1", .offset = 0x10B, },
+	{ .name = "drop_green_prio_2", .offset = 0x10C, },
+	{ .name = "drop_green_prio_3", .offset = 0x10D, },
+	{ .name = "drop_green_prio_4", .offset = 0x10E, },
+	{ .name = "drop_green_prio_5", .offset = 0x10F, },
+	{ .name = "drop_green_prio_6", .offset = 0x110, },
+	{ .name = "drop_green_prio_7", .offset = 0x111, },
+};
+
+int felix_chip_init(struct ocelot *ocelot)
+{
+	int ret;
+
+	ocelot->map = felix_regmap;
+	ocelot->stats_layout = felix_stats_layout;
+	ocelot->num_stats = ARRAY_SIZE(felix_stats_layout);
+	ocelot->shared_queue_sz = 128 * 1024;
+
+	ret = ocelot_regfields_init(ocelot, felix_regfields);
+	if (ret) {
+		dev_err(ocelot->dev, "failed to init reg fields map\n");
+		return ret;
+	}
+
+	eth_random_addr(ocelot->base_mac);
+	ocelot->base_mac[5] &= 0xf0;
+	return 0;
+}
+EXPORT_SYMBOL(felix_chip_init);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 4235d7294772..1d9e76584037 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -63,6 +63,9 @@ struct frame_info {
 #define REG_MASK GENMASK(TARGET_OFFSET - 1, 0)
 #define REG(reg, offset) [reg & REG_MASK] = offset
 
+#define REG_RESERVED_ADDR	0xffffffff
+#define REG_RESERVED(reg)	REG(reg, REG_RESERVED_ADDR)
+
 enum ocelot_target {
 	ANA = 1,
 	QS,
@@ -70,6 +73,7 @@ enum ocelot_target {
 	REW,
 	SYS,
 	S2,
+	GCB,
 	HSIO,
 	TARGET_MAX,
 };
@@ -343,6 +347,7 @@ enum ocelot_reg {
 	S2_CACHE_ACTION_DAT,
 	S2_CACHE_CNT_DAT,
 	S2_CACHE_TG_DAT,
+	GCB_SOFT_RST = GCB << TARGET_OFFSET,
 };
 
 enum ocelot_regfield {
@@ -390,6 +395,7 @@ enum ocelot_regfield {
 	SYS_RESET_CFG_CORE_ENA,
 	SYS_RESET_CFG_MEM_ENA,
 	SYS_RESET_CFG_MEM_INIT,
+	GCB_SOFT_RST_SWC_RST,
 	REGFIELD_MAX
 };
 
@@ -501,6 +507,7 @@ struct regmap *ocelot_io_init(struct ocelot *ocelot, struct resource *res);
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
 int ocelot_chip_init(struct ocelot *ocelot);
+int felix_chip_init(struct ocelot *ocelot);
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
 		      struct phy_device *phy);
-- 
2.17.1

