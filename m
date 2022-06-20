Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001755516B8
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 13:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241378AbiFTLKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 07:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241352AbiFTLKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 07:10:04 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB4355B9;
        Mon, 20 Jun 2022 04:10:02 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9A9F624000B;
        Mon, 20 Jun 2022 11:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655723400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ywsUcFT+AmKQedVr/xIG8o4SHWDmoIJPfk298Jklb94=;
        b=FnkTVHLrKrT8kZmrKa6xxRuN0RXq1kVX4imnyDPJC6e6qWdC/WrcJyWyHla2Ctlx/NJzMm
        LCMVgnHnuRHQF/UAZiUwptNLfS6ejK4vktCj7UidJwsqYYW8tj99m//Tc07VLYwIgoL4qx
        AnH4ibXM5libHgergWkprx0VBiB5vCS4zj9XkIcZK/+ckqA13Vs9A8PFsuLs7ze7uAOvYX
        cAUejw3eFviowX/+VZvvMo10QlpFP/EHx5zi9dbp+5LTRx1bzVKXZAAIAGPnwj6d8xF5Xi
        YEqCPeTSxQWCEkMeppMTwNTvVV7vUkkj0+4JhCM7df5WQr3wyBAAQByXI+yuPg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v8 05/16] net: pcs: add Renesas MII converter driver
Date:   Mon, 20 Jun 2022 13:08:35 +0200
Message-Id: <20220620110846.374787-6-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620110846.374787-1-clement.leger@bootlin.com>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
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

Add a PCS driver for the MII converter that is present on the Renesas
RZ/N1 SoC. This MII converter is reponsible for converting MII to
RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
reuse it in both the switch driver and the stmmac driver. Currently,
this driver only allows the PCS to be used by the dual Cortex-A7
subsystem since the register locking system is not used.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/pcs/Kconfig         |   8 +
 drivers/net/pcs/Makefile        |   1 +
 drivers/net/pcs/pcs-rzn1-miic.c | 520 ++++++++++++++++++++++++++++++++
 include/linux/pcs-rzn1-miic.h   |  18 ++
 4 files changed, 547 insertions(+)
 create mode 100644 drivers/net/pcs/pcs-rzn1-miic.c
 create mode 100644 include/linux/pcs-rzn1-miic.h

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..6a500d30ca4c 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -18,4 +18,12 @@ config PCS_LYNX
 	  This module provides helpers to phylink for managing the Lynx PCS
 	  which is part of the Layerscape and QorIQ Ethernet SERDES.
 
+config PCS_RZN1_MIIC
+	tristate "Renesas RZ/N1 MII converter"
+	depends on ARCH_RZN1 || COMPILE_TEST
+	help
+	  This module provides a driver for the MII converter that is available
+	  on RZ/N1 SoCs. This PCS converts MII to RMII/RGMII or can be set in
+	  pass-through mode for MII.
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
index 000000000000..6ddc5f8ccaf8
--- /dev/null
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -0,0 +1,520 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Schneider Electric
+ *
+ * Clément Léger <clement.leger@bootlin.com>
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/mdio.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/pcs-rzn1-miic.h>
+#include <linux/phylink.h>
+#include <linux/pm_runtime.h>
+#include <dt-bindings/net/pcs-rzn1-miic.h>
+
+#define MIIC_PRCMD			0x0
+#define MIIC_ESID_CODE			0x4
+
+#define MIIC_MODCTRL			0x20
+#define MIIC_MODCTRL_SW_MODE		GENMASK(4, 0)
+
+#define MIIC_CONVCTRL(port)		(0x100 + (port) * 4)
+
+#define MIIC_CONVCTRL_CONV_SPEED	GENMASK(1, 0)
+#define CONV_MODE_10MBPS		0
+#define CONV_MODE_100MBPS		1
+#define CONV_MODE_1000MBPS		2
+
+#define MIIC_CONVCTRL_CONV_MODE		GENMASK(3, 2)
+#define CONV_MODE_MII			0
+#define CONV_MODE_RMII			1
+#define CONV_MODE_RGMII			2
+
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
+#define MIIC_MODCTRL_CONF_CONV_NUM	6
+#define MIIC_MODCTRL_CONF_NONE		-1
+
+/**
+ * struct modctrl_match - Matching table entry for  convctrl configuration
+ *			  See section 8.2.1 of manual.
+ * @mode_cfg: Configuration value for convctrl
+ * @conv: Configuration of ethernet port muxes. First index is SWITCH_PORTIN,
+ *	  then index 1 - 5 are CONV1 - CONV5.
+ */
+struct modctrl_match {
+	u32 mode_cfg;
+	u8 conv[MIIC_MODCTRL_CONF_CONV_NUM];
+};
+
+static struct modctrl_match modctrl_match_table[] = {
+	{0x0, {MIIC_RTOS_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+	       MIIC_SWITCH_PORTC, MIIC_SERCOS_PORTB, MIIC_SERCOS_PORTA}},
+	{0x1, {MIIC_RTOS_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+	       MIIC_SWITCH_PORTC, MIIC_ETHERCAT_PORTB, MIIC_ETHERCAT_PORTA}},
+	{0x2, {MIIC_RTOS_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+	       MIIC_ETHERCAT_PORTC, MIIC_ETHERCAT_PORTB, MIIC_ETHERCAT_PORTA}},
+	{0x3, {MIIC_RTOS_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+	       MIIC_SWITCH_PORTC, MIIC_SWITCH_PORTB, MIIC_SWITCH_PORTA}},
+
+	{0x8, {MIIC_RTOS_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+	       MIIC_SWITCH_PORTC, MIIC_SERCOS_PORTB, MIIC_SERCOS_PORTA}},
+	{0x9, {MIIC_RTOS_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+	       MIIC_SWITCH_PORTC, MIIC_ETHERCAT_PORTB, MIIC_ETHERCAT_PORTA}},
+	{0xA, {MIIC_RTOS_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+	       MIIC_ETHERCAT_PORTC, MIIC_ETHERCAT_PORTB, MIIC_ETHERCAT_PORTA}},
+	{0xB, {MIIC_RTOS_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+	       MIIC_SWITCH_PORTC, MIIC_SWITCH_PORTB, MIIC_SWITCH_PORTA}},
+
+	{0x10, {MIIC_GMAC2_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+		MIIC_SWITCH_PORTC, MIIC_SERCOS_PORTB, MIIC_SERCOS_PORTA}},
+	{0x11, {MIIC_GMAC2_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+		MIIC_SWITCH_PORTC, MIIC_ETHERCAT_PORTB, MIIC_ETHERCAT_PORTA}},
+	{0x12, {MIIC_GMAC2_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+		MIIC_ETHERCAT_PORTC, MIIC_ETHERCAT_PORTB, MIIC_ETHERCAT_PORTA}},
+	{0x13, {MIIC_GMAC2_PORT, MIIC_GMAC1_PORT, MIIC_SWITCH_PORTD,
+		MIIC_SWITCH_PORTC, MIIC_SWITCH_PORTB, MIIC_SWITCH_PORTA}}
+};
+
+static const char * const conf_to_string[] = {
+	[MIIC_GMAC1_PORT]	= "GMAC1_PORT",
+	[MIIC_GMAC2_PORT]	= "GMAC2_PORT",
+	[MIIC_RTOS_PORT]	= "RTOS_PORT",
+	[MIIC_SERCOS_PORTA]	= "SERCOS_PORTA",
+	[MIIC_SERCOS_PORTB]	= "SERCOS_PORTB",
+	[MIIC_ETHERCAT_PORTA]	= "ETHERCAT_PORTA",
+	[MIIC_ETHERCAT_PORTB]	= "ETHERCAT_PORTB",
+	[MIIC_ETHERCAT_PORTC]	= "ETHERCAT_PORTC",
+	[MIIC_SWITCH_PORTA]	= "SWITCH_PORTA",
+	[MIIC_SWITCH_PORTB]	= "SWITCH_PORTB",
+	[MIIC_SWITCH_PORTC]	= "SWITCH_PORTC",
+	[MIIC_SWITCH_PORTD]	= "SWITCH_PORTD",
+	[MIIC_HSR_PORTA]	= "HSR_PORTA",
+	[MIIC_HSR_PORTB]	= "HSR_PORTB",
+};
+
+static const char *index_to_string[MIIC_MODCTRL_CONF_CONV_NUM] = {
+	"SWITCH_PORTIN",
+	"CONV1",
+	"CONV2",
+	"CONV3",
+	"CONV4",
+	"CONV5",
+};
+
+/**
+ * struct miic - MII converter structure
+ * @base: base address of the MII converter
+ * @dev: Device associated to the MII converter
+ * @clks: Clocks used for this device
+ * @nclk: Number of clocks
+ * @lock: Lock used for read-modify-write access
+ */
+struct miic {
+	void __iomem *base;
+	struct device *dev;
+	struct clk_bulk_data *clks;
+	int nclk;
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
+static struct miic_port *phylink_pcs_to_miic_port(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct miic_port, pcs);
+}
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
+	u32 speed, conv_mode, val;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		conv_mode = CONV_MODE_RMII;
+		speed = CONV_MODE_100MBPS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		conv_mode = CONV_MODE_RGMII;
+		speed = CONV_MODE_1000MBPS;
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		conv_mode = CONV_MODE_MII;
+		/* When in MII mode, speed should be set to 0 (which is actually
+		 * CONV_MODE_10MBPS)
+		 */
+		speed = CONV_MODE_10MBPS;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	val = FIELD_PREP(MIIC_CONVCTRL_CONV_MODE, conv_mode) |
+	      FIELD_PREP(MIIC_CONVCTRL_CONV_SPEED, speed);
+
+	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
+		     MIIC_CONVCTRL_CONV_MODE | MIIC_CONVCTRL_CONV_SPEED, val);
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
+	u32 conv_speed = 0, val = 0;
+	int port = miic_port->port;
+
+	if (duplex == DUPLEX_FULL)
+		val |= MIIC_CONVCTRL_FULLD;
+
+	/* No speed in MII through-mode */
+	if (interface != PHY_INTERFACE_MODE_MII) {
+		switch (speed) {
+		case SPEED_1000:
+			conv_speed = CONV_MODE_1000MBPS;
+			break;
+		case SPEED_100:
+			conv_speed = CONV_MODE_100MBPS;
+			break;
+		case SPEED_10:
+			conv_speed = CONV_MODE_10MBPS;
+			break;
+		default:
+			return;
+		}
+	}
+
+	val |= FIELD_PREP(MIIC_CONVCTRL_CONV_SPEED, conv_speed);
+
+	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
+		     (MIIC_CONVCTRL_CONV_SPEED | MIIC_CONVCTRL_FULLD), val);
+}
+
+static int miic_validate(struct phylink_pcs *pcs, unsigned long *supported,
+			 const struct phylink_link_state *state)
+{
+	if (phy_interface_mode_is_rgmii(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_RMII ||
+	    state->interface == PHY_INTERFACE_MODE_MII)
+		return 1;
+
+	return -EINVAL;
+}
+
+static const struct phylink_pcs_ops miic_phylink_ops = {
+	.pcs_validate = miic_validate,
+	.pcs_config = miic_config,
+	.pcs_link_up = miic_link_up,
+};
+
+struct phylink_pcs *miic_create(struct device *dev, struct device_node *np)
+{
+	struct platform_device *pdev;
+	struct miic_port *miic_port;
+	struct device_node *pcs_np;
+	struct miic *miic;
+	u32 port;
+
+	if (!of_device_is_available(np))
+		return ERR_PTR(-ENODEV);
+
+	if (of_property_read_u32(np, "reg", &port))
+		return ERR_PTR(-EINVAL);
+
+	if (port > MIIC_MAX_NR_PORTS || port < 1)
+		return ERR_PTR(-EINVAL);
+
+	/* The PCS pdev is attached to the parent node */
+	pcs_np = of_get_parent(np);
+	if (!pcs_np)
+		return ERR_PTR(-ENODEV);
+
+	if (!of_device_is_available(pcs_np)) {
+		of_node_put(pcs_np);
+		return ERR_PTR(-ENODEV);
+	}
+
+	pdev = of_find_device_by_node(pcs_np);
+	of_node_put(pcs_np);
+	if (!pdev || !platform_get_drvdata(pdev))
+		return ERR_PTR(-EPROBE_DEFER);
+
+	miic_port = kzalloc(sizeof(*miic_port), GFP_KERNEL);
+	if (!miic_port)
+		return ERR_PTR(-ENOMEM);
+
+	miic = platform_get_drvdata(pdev);
+	device_link_add(dev, miic->dev, DL_FLAG_AUTOREMOVE_CONSUMER);
+
+	miic_port->miic = miic;
+	miic_port->port = port - 1;
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
+static int miic_init_hw(struct miic *miic, u32 cfg_mode)
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
+			FIELD_PREP(MIIC_MODCTRL_SW_MODE, cfg_mode));
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
+static bool miic_modctrl_match(s8 table_val[MIIC_MODCTRL_CONF_CONV_NUM],
+			       s8 dt_val[MIIC_MODCTRL_CONF_CONV_NUM])
+{
+	int i;
+
+	for (i = 0; i < MIIC_MODCTRL_CONF_CONV_NUM; i++) {
+		if (dt_val[i] == MIIC_MODCTRL_CONF_NONE)
+			continue;
+
+		if (dt_val[i] != table_val[i])
+			return false;
+	}
+
+	return true;
+}
+
+static void miic_dump_conf(struct device *dev,
+			   s8 conf[MIIC_MODCTRL_CONF_CONV_NUM])
+{
+	const char *conf_name;
+	int i;
+
+	for (i = 0; i < MIIC_MODCTRL_CONF_CONV_NUM; i++) {
+		if (conf[i] != MIIC_MODCTRL_CONF_NONE)
+			conf_name = conf_to_string[conf[i]];
+		else
+			conf_name = "NONE";
+
+		dev_err(dev, "%s: %s\n", index_to_string[i], conf_name);
+	}
+}
+
+static int miic_match_dt_conf(struct device *dev,
+			      s8 dt_val[MIIC_MODCTRL_CONF_CONV_NUM],
+			      u32 *mode_cfg)
+{
+	struct modctrl_match *table_entry;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(modctrl_match_table); i++) {
+		table_entry = &modctrl_match_table[i];
+
+		if (miic_modctrl_match(table_entry->conv, dt_val)) {
+			*mode_cfg = table_entry->mode_cfg;
+			return 0;
+		}
+	}
+
+	dev_err(dev, "Failed to apply requested configuration\n");
+	miic_dump_conf(dev, dt_val);
+
+	return -EINVAL;
+}
+
+static int miic_parse_dt(struct device *dev, u32 *mode_cfg)
+{
+	s8 dt_val[MIIC_MODCTRL_CONF_CONV_NUM];
+	struct device_node *np = dev->of_node;
+	struct device_node *conv;
+	u32 conf;
+	int port;
+
+	memset(dt_val, MIIC_MODCTRL_CONF_NONE, sizeof(dt_val));
+
+	of_property_read_u32(np, "renesas,miic-switch-portin", &conf);
+	dt_val[0] = conf;
+
+	for_each_child_of_node(np, conv) {
+		if (of_property_read_u32(conv, "reg", &port))
+			continue;
+
+		if (!of_device_is_available(conv))
+			continue;
+
+		if (of_property_read_u32(conv, "renesas,miic-input", &conf) == 0)
+			dt_val[port] = conf;
+	}
+
+	return miic_match_dt_conf(dev, dt_val, mode_cfg);
+}
+
+static int miic_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct miic *miic;
+	u32 mode_cfg;
+	int ret;
+
+	ret = miic_parse_dt(dev, &mode_cfg);
+	if (ret < 0)
+		return -EINVAL;
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
+	ret = devm_pm_runtime_enable(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = miic_init_hw(miic, mode_cfg);
+	if (ret)
+		goto disable_runtime_pm;
+
+	/* miic_create() relies on that fact that data are attached to the
+	 * platform device to determine if the driver is ready so this needs to
+	 * be the last thing to be done after everything is initialized
+	 * properly.
+	 */
+	platform_set_drvdata(pdev, miic);
+
+	return 0;
+
+disable_runtime_pm:
+	pm_runtime_put(dev);
+
+	return ret;
+}
+
+static int miic_remove(struct platform_device *pdev)
+{
+	pm_runtime_put(&pdev->dev);
+
+	return 0;
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
+		.name	 = "rzn1_miic",
+		.suppress_bind_attrs = true,
+		.of_match_table = of_match_ptr(miic_of_mtable),
+	},
+	.probe = miic_probe,
+	.remove = miic_remove,
+};
+module_platform_driver(miic_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Renesas MII converter PCS driver");
+MODULE_AUTHOR("Clément Léger <clement.leger@bootlin.com>");
diff --git a/include/linux/pcs-rzn1-miic.h b/include/linux/pcs-rzn1-miic.h
new file mode 100644
index 000000000000..56d12b21365d
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
+struct phylink_pcs *miic_create(struct device *dev, struct device_node *np);
+
+void miic_destroy(struct phylink_pcs *pcs);
+
+#endif /* __LINUX_PCS_MIIC_H */
-- 
2.36.1

