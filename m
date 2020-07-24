Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E4322C062
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 10:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgGXICK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 04:02:10 -0400
Received: from inva021.nxp.com ([92.121.34.21]:56348 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgGXICJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 04:02:09 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A3463200EC7;
        Fri, 24 Jul 2020 10:02:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8AC06200EBF;
        Fri, 24 Jul 2020 10:02:05 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E63ED202D1;
        Fri, 24 Jul 2020 10:02:04 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, linux@armlinux.org.uk,
        f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 4/5] net: phy: add Lynx PCS module
Date:   Fri, 24 Jul 2020 11:01:42 +0300
Message-Id: <20200724080143.12909-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724080143.12909-1-ioana.ciornei@nxp.com>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a Lynx PCS module which exposes the necessary operations to drive
the PCS using phylink.

The majority of the code is extracted from the Felix DSA driver, which
will be also modified in a later patch, and exposed as a separate module
for code reusability purposes.
At the moment, USXGMII, SGMII, QSGMII and 2500Base-X (only w/o in-band
AN) are supported by the Lynx PCS module since these were also supported
by Felix.

The module can only be enabled by the drivers in need and not user
selectable.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v4:
 * use the newly introduced phylink PCS mechanism
 * do no use the SGMII_ prefix when referring to the IF_MORE register

 MAINTAINERS                |   7 +
 drivers/net/phy/Kconfig    |   6 +
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/pcs-lynx.c | 314 +++++++++++++++++++++++++++++++++++++
 include/linux/pcs-lynx.h   |  21 +++
 5 files changed, 349 insertions(+)
 create mode 100644 drivers/net/phy/pcs-lynx.c
 create mode 100644 include/linux/pcs-lynx.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6200eb14757c..bfd0d174f4e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10158,6 +10158,13 @@ S:	Maintained
 W:	http://linux-test-project.github.io/
 T:	git git://github.com/linux-test-project/ltp.git
 
+LYNX PCS MODULE
+M:	Ioana Ciornei <ioana.ciornei@nxp.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/phy/pcs-lynx.c
+F:	include/linux/pcs-lynx.h
+
 M68K ARCHITECTURE
 M:	Geert Uytterhoeven <geert@linux-m68k.org>
 L:	linux-m68k@lists.linux-m68k.org
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index dd20c2c27c2f..f8016e64e1a5 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -239,6 +239,12 @@ config MDIO_XPCS
 	  This module provides helper functions for Synopsys DesignWare XPCS
 	  controllers.
 
+config PCS_LYNX
+	tristate
+	help
+	  This module provides helpers to phylink for managing the Lynx PCS
+	  which is part of the Layerscape and QorIQ Ethernet SERDES.
+
 endif
 endif
 
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index d84bab489a53..0e5539c05c81 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
 obj-$(CONFIG_MDIO_XPCS)		+= mdio-xpcs.o
+obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
 
 obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
 
diff --git a/drivers/net/phy/pcs-lynx.c b/drivers/net/phy/pcs-lynx.c
new file mode 100644
index 000000000000..9ea8b90a1350
--- /dev/null
+++ b/drivers/net/phy/pcs-lynx.c
@@ -0,0 +1,314 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2020 NXP
+ * Lynx PCS MDIO helpers
+ */
+
+#include <linux/mdio.h>
+#include <linux/phylink.h>
+#include <linux/pcs-lynx.h>
+
+#define SGMII_CLOCK_PERIOD_NS		8 /* PCS is clocked at 125 MHz */
+#define LINK_TIMER_VAL(ns)		((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
+
+#define SGMII_AN_LINK_TIMER_NS		1600000 /* defined by SGMII spec */
+
+#define LINK_TIMER_LO			0x12
+#define LINK_TIMER_HI			0x13
+#define IF_MODE				0x14
+#define IF_MODE_SGMII_EN		BIT(0)
+#define IF_MODE_USE_SGMII_AN		BIT(1)
+#define IF_MODE_SPEED(x)		(((x) << 2) & GENMASK(3, 2))
+#define IF_MODE_SPEED_MSK		GENMASK(3, 2)
+#define IF_MODE_DUPLEX			BIT(4)
+
+enum sgmii_speed {
+	SGMII_SPEED_10		= 0,
+	SGMII_SPEED_100		= 1,
+	SGMII_SPEED_1000	= 2,
+	SGMII_SPEED_2500	= 2,
+};
+
+#define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
+
+static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
+				       struct phylink_link_state *state)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
+	int status, lpa;
+
+	status = mdiobus_c45_read(bus, addr, MDIO_MMD_VEND2, MII_BMSR);
+	if (status < 0)
+		return;
+
+	state->link = !!(status & MDIO_STAT1_LSTATUS);
+	state->an_complete = !!(status & MDIO_AN_STAT1_COMPLETE);
+	if (!state->link || !state->an_complete)
+		return;
+
+	lpa = mdiobus_c45_read(bus, addr, MDIO_MMD_VEND2, MII_LPA);
+	if (lpa < 0)
+		return;
+
+	phylink_decode_usxgmii_word(state, lpa);
+}
+
+static void lynx_pcs_get_state_2500basex(struct mdio_device *pcs,
+					 struct phylink_link_state *state)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
+	int bmsr, lpa;
+
+	bmsr = mdiobus_read(bus, addr, MII_BMSR);
+	lpa = mdiobus_read(bus, addr, MII_LPA);
+	if (bmsr < 0 || lpa < 0) {
+		state->link = false;
+		return;
+	}
+
+	state->link = !!(bmsr & BMSR_LSTATUS);
+	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
+	if (!state->link)
+		return;
+
+	state->speed = SPEED_2500;
+	state->pause |= MLO_PAUSE_TX | MLO_PAUSE_RX;
+	state->duplex = DUPLEX_FULL;
+}
+
+static void lynx_pcs_get_state(struct phylink_pcs *pcs,
+			       struct phylink_link_state *state)
+{
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		phylink_mii_c22_pcs_get_state(lynx->mdio, state);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		lynx_pcs_get_state_2500basex(lynx->mdio, state);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		lynx_pcs_get_state_usxgmii(lynx->mdio, state);
+		break;
+	default:
+		break;
+	}
+
+	dev_dbg(&lynx->mdio->dev,
+		"mode=%s/%s/%s link=%u an_enabled=%u an_complete=%u\n",
+		phy_modes(state->interface),
+		phy_speed_to_str(state->speed),
+		phy_duplex_to_str(state->duplex),
+		state->link, state->an_enabled, state->an_complete);
+}
+
+static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int mode,
+				 const unsigned long *advertising)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
+	u16 if_mode;
+	int err;
+
+	if_mode = IF_MODE_SGMII_EN;
+	if (mode == MLO_AN_INBAND) {
+		u32 link_timer;
+
+		if_mode |= IF_MODE_USE_SGMII_AN;
+
+		/* Adjust link timer for SGMII */
+		link_timer = LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
+		mdiobus_write(bus, addr, LINK_TIMER_LO, link_timer & 0xffff);
+		mdiobus_write(bus, addr, LINK_TIMER_HI, link_timer >> 16);
+	}
+	mdiobus_modify(bus, addr, IF_MODE,
+		       IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN,
+		       if_mode);
+
+	err = phylink_mii_c22_pcs_config(pcs, mode, PHY_INTERFACE_MODE_SGMII,
+					 advertising);
+	return err;
+}
+
+static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
+				   const unsigned long *advertising)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
+
+	if (!phylink_autoneg_inband(mode)) {
+		dev_err(&pcs->dev, "USXGMII only supports in-band AN for now\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* Configure device ability for the USXGMII Replicator */
+	mdiobus_c45_write(bus, addr, MDIO_MMD_VEND2, MII_ADVERTISE,
+			  MDIO_USXGMII_10G | MDIO_USXGMII_LINK |
+			  MDIO_USXGMII_FULL_DUPLEX |
+			  ADVERTISE_SGMII | ADVERTISE_LPACK);
+	return 0;
+}
+
+static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			   phy_interface_t ifmode,
+			   const unsigned long *advertising,
+			   bool permit)
+{
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	switch (ifmode) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		lynx_pcs_config_sgmii(lynx->mdio, mode, advertising);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		if (phylink_autoneg_inband(mode)) {
+			dev_err(&lynx->mdio->dev,
+				"AN not supported on 3.125GHz SerDes lane\n");
+			return -EOPNOTSUPP;
+		}
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		lynx_pcs_config_usxgmii(lynx->mdio, mode, advertising);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int mode,
+				   int speed, int duplex)
+{
+	struct mii_bus *bus = pcs->bus;
+	u16 if_mode = 0, sgmii_speed;
+	int addr = pcs->addr;
+
+	/* The PCS needs to be configured manually only
+	 * when not operating on in-band mode
+	 */
+	if (mode == MLO_AN_INBAND)
+		return;
+
+	if (duplex == DUPLEX_HALF)
+		if_mode |= IF_MODE_DUPLEX;
+
+	switch (speed) {
+	case SPEED_1000:
+		sgmii_speed = SGMII_SPEED_1000;
+		break;
+	case SPEED_100:
+		sgmii_speed = SGMII_SPEED_100;
+		break;
+	case SPEED_10:
+		sgmii_speed = SGMII_SPEED_10;
+		break;
+	case SPEED_UNKNOWN:
+		/* Silently don't do anything */
+		return;
+	default:
+		dev_err(&pcs->dev, "Invalid PCS speed %d\n", speed);
+		return;
+	}
+	if_mode |= IF_MODE_SPEED(sgmii_speed);
+
+	mdiobus_modify(bus, addr, IF_MODE,
+		       IF_MODE_DUPLEX | IF_MODE_SPEED_MSK,
+		       if_mode);
+}
+
+/* 2500Base-X is SerDes protocol 7 on Felix and 6 on ENETC. It is a SerDes lane
+ * clocked at 3.125 GHz which encodes symbols with 8b/10b and does not have
+ * auto-negotiation of any link parameters. Electrically it is compatible with
+ * a single lane of XAUI.
+ * The hardware reference manual wants to call this mode SGMII, but it isn't
+ * really, since the fundamental features of SGMII:
+ * - Downgrading the link speed by duplicating symbols
+ * - Auto-negotiation
+ * are not there.
+ * The speed is configured at 1000 in the IF_MODE because the clock frequency
+ * is actually given by a PLL configured in the Reset Configuration Word (RCW).
+ * Since there is no difference between fixed speed SGMII w/o AN and 802.3z w/o
+ * AN, we call this PHY interface type 2500Base-X. In case a PHY negotiates a
+ * lower link speed on line side, the system-side interface remains fixed at
+ * 2500 Mbps and we do rate adaptation through pause frames.
+ */
+static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
+				       unsigned int mode,
+				       int speed, int duplex)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
+	u16 if_mode = 0;
+
+	if (mode == MLO_AN_INBAND) {
+		dev_err(&pcs->dev, "AN not supported for 2500BaseX\n");
+		return;
+	}
+
+	if (duplex == DUPLEX_HALF)
+		if_mode |= IF_MODE_DUPLEX;
+	if_mode |= IF_MODE_SPEED(SGMII_SPEED_2500);
+
+	mdiobus_modify(bus, addr, IF_MODE,
+		       IF_MODE_DUPLEX | IF_MODE_SPEED_MSK,
+		       if_mode);
+}
+
+static void lynx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+			     phy_interface_t interface,
+			     int speed, int duplex)
+{
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		lynx_pcs_link_up_sgmii(lynx->mdio, mode, speed, duplex);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		lynx_pcs_link_up_2500basex(lynx->mdio, mode, speed, duplex);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		/* At the moment, only in-band AN is supported for USXGMII
+		 * so nothing to do in link_up
+		 */
+		break;
+	default:
+		break;
+	}
+}
+
+static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
+	.pcs_get_state = lynx_pcs_get_state,
+	.pcs_config = lynx_pcs_config,
+	.pcs_link_up = lynx_pcs_link_up,
+};
+
+struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
+{
+	struct lynx_pcs *lynx_pcs;
+
+	lynx_pcs = kzalloc(sizeof(*lynx_pcs), GFP_KERNEL);
+	if (!lynx_pcs)
+		return NULL;
+
+	lynx_pcs->mdio = mdio;
+	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
+	lynx_pcs->pcs.poll = true;
+
+	return lynx_pcs;
+}
+EXPORT_SYMBOL(lynx_pcs_create);
+
+void lynx_pcs_destroy(struct lynx_pcs *pcs)
+{
+	kfree(pcs);
+}
+EXPORT_SYMBOL(lynx_pcs_destroy);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
new file mode 100644
index 000000000000..a6440d6ebe95
--- /dev/null
+++ b/include/linux/pcs-lynx.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2020 NXP
+ * Lynx PCS helpers
+ */
+
+#ifndef __LINUX_PCS_LYNX_H
+#define __LINUX_PCS_LYNX_H
+
+#include <linux/mdio.h>
+#include <linux/phylink.h>
+
+struct lynx_pcs {
+	struct phylink_pcs pcs;
+	struct mdio_device *mdio;
+};
+
+struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio);
+
+void lynx_pcs_destroy(struct lynx_pcs *pcs);
+
+#endif /* __LINUX_PCS_LYNX_H */
-- 
2.25.1

