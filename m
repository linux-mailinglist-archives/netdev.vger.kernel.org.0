Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB88500D2E
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243223AbiDNM1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243218AbiDNM1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:18 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F93C2E0A4;
        Thu, 14 Apr 2022 05:24:49 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0E01D4000C;
        Thu, 14 Apr 2022 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ssNs5yXTL9mvQvG0qY2xgZ2mvkOGo3Ko6vSPOCq9GNo=;
        b=U+HJNqnvnsQEWFZyAznl6TMK1DIZELxWm2PPMsz2JJKDE5NXNbgJUT+k9S3QT91JCBAfcD
        YglLbqm+LIP/mQvWQ16EsJhdBbMrSYPM76IWJ0ByEX8VHVIzuQkzPVOjkeYhjspEssskH+
        2vAezjKNpSqLjKwFFFFjiCj+JSFQi7McYpT5I7ZuH3Uxs6dCRGZYVj2rKt/zUEkHqAZmoF
        u2Tg98gr6pfuibIm+TulEjCDfRvWZbWWcH/4JurYUQZGKqOH7w4sLNYhBl3iKQ2yI9MSI7
        8nlwv3mrUyhkGhYeuBuRDH2KFYXy6/Wu9sLCIOIR9TwRWAZBJBvgDnQSbVc/UA==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 04/12] net: pcs: add Renesas MII converter driver
Date:   Thu, 14 Apr 2022 14:22:42 +0200
Message-Id: <20220414122250.158113-5-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414122250.158113-1-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PCS driver for the MII converter that is present on Renesas RZ/N1
SoC. This MII converter is reponsible of converting MII to RMII/RGMII
or act as a MII passtrough. Exposing it as a PCS allows to reuse it
in both the switch driver and the stmmac driver. Currently, this driver
only allows the PCS to be used by the dual Cortex-A7 subsystem since
the register locking system is not used.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/pcs/Kconfig         |   7 +
 drivers/net/pcs/Makefile        |   1 +
 drivers/net/pcs/pcs-rzn1-miic.c | 350 ++++++++++++++++++++++++++++++++
 include/linux/pcs-rzn1-miic.h   |  18 ++
 4 files changed, 376 insertions(+)
 create mode 100644 drivers/net/pcs/pcs-rzn1-miic.c
 create mode 100644 include/linux/pcs-rzn1-miic.h

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..fb0d36d46ffb 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -18,4 +18,11 @@ config PCS_LYNX
 	  This module provides helpers to phylink for managing the Lynx PCS
 	  which is part of the Layerscape and QorIQ Ethernet SERDES.
 
+config PCS_RZN1_MIIC
+	tristate "Renesas RZN1 MII converter"
+	help
+	  This module provides a driver for the MII converter that is available
+	  on RZN1 SoC. This PCS convert MII to RMII/RGMII or can be in
+	  passthrough mode for MII.
+
 endmenu
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index 0603d469bd57..0ff5388fcdea 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -5,3 +5,4 @@ pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
 
 obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
 obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
+obj-$(CONFIG_PCS_RZN1_MIIC)	+= pcs-rzn1-miic.o
diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
new file mode 100644
index 000000000000..84599e767689
--- /dev/null
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -0,0 +1,350 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Schneider Electric
+ *
+ * Clément Léger <clement.leger@bootlin.com>
+ */
+
+#include <linux/clk.h>
+#include <linux/mdio.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/phylink.h>
+#include <linux/pcs-rzn1-miic.h>
+
+#define MIIC_PRCMD			0x0
+#define MIIC_ESID_CODE			0x4
+
+#define MIIC_MODCTRL			0x20
+#define MIIC_MODCTRL_SW_MODE		GENMASK(4, 0)
+
+#define MIIC_CONVCTRL(port)		(0x100 + (port) * 4)
+#define MIIC_CONVCTRL_CONV_MODE		GENMASK(4, 0)
+#define CONV_MODE_MII			0
+#define CONV_MODE_RMII			BIT(2)
+#define CONV_MODE_RGMII			BIT(3)
+#define CONV_MODE_10MBPS		0
+#define CONV_MODE_100MBPS		BIT(0)
+#define CONV_MODE_1000MBPS		BIT(1)
+#define MIIC_CONVCTRL_FULLD		BIT(8)
+#define MIIC_CONVCTRL_RGMII_LINK	BIT(12)
+#define MIIC_CONVCTRL_RGMII_DUPLEX	BIT(13)
+#define MIIC_CONVCTRL_RGMII_SPEED	GENMASK(15, 14)
+
+#define MIIC_CONVRST			0x114
+#define MIIC_CONVRST_PHYIF_RST(port)	BIT(port)
+#define MIIC_CONVRST_PHYIF_RST_MASK	GENMASK(4, 0)
+
+#define MIIC_SWCTRL			0x304
+#define MIIC_SWDUPC			0x308
+
+#define MIIC_MAX_NR_PORTS		5
+
+#define phylink_pcs_to_miic_port(pcs) container_of((pcs), struct miic_port, pcs)
+
+/**
+ * struct miic - MII converter structure
+ * @base: base address of the MII converter
+ * @dev: Device associated to the MII converter
+ * @lock: Lock used for read-modify-write access
+ */
+struct miic {
+	void __iomem *base;
+	struct device *dev;
+	spinlock_t lock;
+};
+
+/**
+ * struct miic_port - Per port MII converter struct
+ * @miic: backiling to MII converter structure
+ * @pcs: PCS structure associated to the port
+ * @port: port number
+ */
+struct miic_port {
+	struct miic *miic;
+	struct phylink_pcs pcs;
+	int port;
+};
+
+static void miic_reg_writel(struct miic *miic, int offset, u32 value)
+{
+	writel(value, miic->base + offset);
+}
+
+static u32 miic_reg_readl(struct miic *miic, int offset)
+{
+	return readl(miic->base + offset);
+}
+
+static void miic_reg_rmw(struct miic *miic, int offset, u32 mask, u32 val)
+{
+	u32 reg;
+
+	spin_lock(&miic->lock);
+
+	reg = miic_reg_readl(miic, offset);
+	reg &= ~mask;
+	reg |= val;
+	miic_reg_writel(miic, offset, reg);
+
+	spin_unlock(&miic->lock);
+}
+
+static void miic_converter_enable(struct miic *miic, int port, int enable)
+{
+	u32 val = 0;
+
+	if (enable)
+		val = MIIC_CONVRST_PHYIF_RST(port);
+
+	miic_reg_rmw(miic, MIIC_CONVRST, MIIC_CONVRST_PHYIF_RST(port), val);
+}
+
+static int miic_config(struct phylink_pcs *pcs, unsigned int mode,
+		       phy_interface_t interface,
+		       const unsigned long *advertising, bool permit)
+{
+	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
+	struct miic *miic = miic_port->miic;
+	int port = miic_port->port;
+	u32 val;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		val = CONV_MODE_RMII | CONV_MODE_1000MBPS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+		val = CONV_MODE_RGMII | CONV_MODE_1000MBPS;
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		val = CONV_MODE_MII;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	miic_reg_rmw(miic, MIIC_CONVCTRL(port), MIIC_CONVCTRL_CONV_MODE, val);
+	miic_converter_enable(miic_port->miic, miic_port->port, 1);
+
+	return 0;
+}
+
+static void miic_link_up(struct phylink_pcs *pcs, unsigned int mode,
+			 phy_interface_t interface, int speed, int duplex)
+{
+	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
+	struct miic *miic = miic_port->miic;
+	int port = miic_port->port;
+	u32 val = 0;
+
+	if (duplex == DUPLEX_FULL)
+		val |= MIIC_CONVCTRL_FULLD;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		val |= CONV_MODE_RMII;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+		val |= CONV_MODE_RGMII;
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		val |= CONV_MODE_MII;
+		break;
+	default:
+		dev_err(miic->dev, "Unsupported interface %s\n",
+			phy_modes(interface));
+		return;
+	}
+
+	/* No speed in MII through-mode */
+	if (interface != PHY_INTERFACE_MODE_MII) {
+		switch (speed) {
+		case SPEED_1000:
+			val |= CONV_MODE_1000MBPS;
+			break;
+		case SPEED_100:
+			val |= CONV_MODE_100MBPS;
+			break;
+		case SPEED_10:
+			val |= CONV_MODE_10MBPS;
+			break;
+		case SPEED_UNKNOWN:
+			pr_err("Invalid speed\n");
+			/* Silently don't do anything */
+			return;
+		default:
+			dev_err(miic->dev, "Invalid PCS speed %d\n", speed);
+			return;
+		}
+	}
+
+	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
+		     (MIIC_CONVCTRL_CONV_MODE | MIIC_CONVCTRL_FULLD), val);
+}
+
+static bool miic_mode_supported(phy_interface_t interface)
+{
+	return (interface == PHY_INTERFACE_MODE_RGMII ||
+		interface == PHY_INTERFACE_MODE_RMII ||
+		interface == PHY_INTERFACE_MODE_MII);
+}
+
+static int miic_validate(struct phylink_pcs *pcs, unsigned long *supported,
+			 const struct phylink_link_state *state)
+{
+	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
+	struct miic *miic = miic_port->miic;
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    !miic_mode_supported(state->interface)) {
+		dev_err(miic->dev, "phy mode %s is unsupported on port %d\n",
+			phy_modes(state->interface), miic_port->port);
+		linkmode_zero(supported);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static const struct phylink_pcs_ops miic_phylink_ops = {
+	.pcs_config = miic_config,
+	.pcs_link_up = miic_link_up,
+	.pcs_validate = miic_validate,
+};
+
+struct phylink_pcs *miic_create(struct device_node *np)
+{
+	struct platform_device *pdev;
+	struct miic_port *miic_port;
+	struct device_node *pcs_np;
+	u32 port;
+
+	if (of_property_read_u32(np, "reg", &port))
+		return ERR_PTR(-EINVAL);
+
+	if (port >= MIIC_MAX_NR_PORTS)
+		return ERR_PTR(-EINVAL);
+
+	/* The PCS pdev is attached to the parent node */
+	pcs_np = of_get_parent(np);
+	if (!pcs_np)
+		return ERR_PTR(-EINVAL);
+
+	pdev = of_find_device_by_node(pcs_np);
+	if (!pdev || !platform_get_drvdata(pdev))
+		return ERR_PTR(-EPROBE_DEFER);
+
+	miic_port = kzalloc(sizeof(*miic_port), GFP_KERNEL);
+	if (!miic_port)
+		return ERR_PTR(-ENOMEM);
+
+	miic_port->miic = platform_get_drvdata(pdev);
+	miic_port->port = port;
+	miic_port->pcs.ops = &miic_phylink_ops;
+
+	return &miic_port->pcs;
+}
+EXPORT_SYMBOL(miic_create);
+
+void miic_destroy(struct phylink_pcs *pcs)
+{
+	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
+
+	miic_converter_enable(miic_port->miic, miic_port->port, 0);
+	kfree(miic_port);
+}
+EXPORT_SYMBOL(miic_destroy);
+
+static int miic_init_hw(struct miic *miic, u32 mode)
+{
+	int port;
+
+	/* Unlock write access to accessory registers (cf datasheet). If this
+	 * is going to be used in conjunction with the Cortex-M3, this sequence
+	 * will have to be moved in register write
+	 */
+	miic_reg_writel(miic, MIIC_PRCMD, 0x00A5);
+	miic_reg_writel(miic, MIIC_PRCMD, 0x0001);
+	miic_reg_writel(miic, MIIC_PRCMD, 0xFFFE);
+	miic_reg_writel(miic, MIIC_PRCMD, 0x0001);
+
+	miic_reg_writel(miic, MIIC_MODCTRL,
+			FIELD_PREP(MIIC_MODCTRL_SW_MODE, mode));
+
+	for (port = 0; port < MIIC_MAX_NR_PORTS; port++) {
+		miic_converter_enable(miic, port, 0);
+		/* Disable speed/duplex control from these registers, datasheet
+		 * says switch registers should be used to setup switch port
+		 * speed and duplex.
+		 */
+		miic_reg_writel(miic, MIIC_SWCTRL, 0x0);
+		miic_reg_writel(miic, MIIC_SWDUPC, 0x0);
+	}
+
+	return 0;
+}
+
+static int miic_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct clk_bulk_data *clks;
+	struct miic *miic;
+	u32 mode_cfg;
+	int nclk;
+	int ret;
+
+	if (of_property_read_u32(dev->of_node, "renesas,miic-cfg-mode", &mode_cfg)) {
+		dev_err(dev, "Missing renesas,miic-cfg-mode property for miic\n");
+		return -EINVAL;
+	}
+
+	miic = devm_kzalloc(dev, sizeof(*miic), GFP_KERNEL);
+	if (!miic)
+		return -ENOMEM;
+
+	spin_lock_init(&miic->lock);
+	miic->dev = dev;
+	miic->base = devm_platform_ioremap_resource(pdev, 0);
+	if (!miic->base)
+		return -EINVAL;
+
+	nclk = devm_clk_bulk_get_all(dev, &clks);
+	if (nclk < 0)
+		return nclk;
+
+	ret = clk_bulk_prepare_enable(nclk, clks);
+	if (ret)
+		return ret;
+
+	ret = miic_init_hw(miic, mode_cfg);
+	if (ret)
+		goto disable_clocks;
+
+	platform_set_drvdata(pdev, miic);
+
+	return 0;
+
+disable_clocks:
+	clk_bulk_disable_unprepare(nclk, clks);
+
+	return ret;
+}
+
+static const struct of_device_id miic_of_mtable[] = {
+	{ .compatible = "renesas,rzn1-miic" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, miic_of_mtable);
+
+static struct platform_driver miic_driver = {
+	.driver = {
+		.name	 = "mtip_miic",
+		.of_match_table = of_match_ptr(miic_of_mtable),
+	},
+	.probe = miic_probe,
+};
+module_platform_driver(miic_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Renesas MII converter PCS driver");
+MODULE_AUTHOR("Clément Léger <clement.leger@bootlin.com>");
diff --git a/include/linux/pcs-rzn1-miic.h b/include/linux/pcs-rzn1-miic.h
new file mode 100644
index 000000000000..7a303af57e40
--- /dev/null
+++ b/include/linux/pcs-rzn1-miic.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Schneider Electric
+ *
+ * Clément Léger <clement.leger@bootlin.com>
+ */
+
+#ifndef __LINUX_PCS_MIIC_H
+#define __LINUX_PCS_MIIC_H
+
+struct phylink;
+struct device_node;
+
+struct phylink_pcs *miic_create(struct device_node *np);
+
+void miic_destroy(struct phylink_pcs *pcs);
+
+#endif /* __LINUX_PCS_MIIC_H */
-- 
2.34.1

