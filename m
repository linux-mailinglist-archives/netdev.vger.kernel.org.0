Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DC41FF144
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgFRMJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:09:19 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34948 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgFRMJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:09:11 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A5E3D1A0F41;
        Thu, 18 Jun 2020 14:09:07 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 96A621A0F3B;
        Thu, 18 Jun 2020 14:09:07 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2F4B92048B;
        Thu, 18 Jun 2020 14:09:07 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Date:   Thu, 18 Jun 2020 15:08:36 +0300
Message-Id: <20200618120837.27089-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618120837.27089-1-ioana.ciornei@nxp.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a Lynx PCS MDIO module which exposes the necessary operations to
drive the PCS using PHYLINK.

The majority of the code is extracted from the Felix DSA driver, which
will be also modified in a later patch, and exposed as a separate module
for code reusability purposes.

At the moment, USXGMII (only with in-band AN and speeds up to 2500),
SGMII, QSGMII and 2500Base-X (only w/o in-band AN) are supported by the
Lynx PCS MDIO module since these were also supported by Felix.

The module can only be enabled by the drivers in need and not user
selectable.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 MAINTAINERS                     |   7 +
 drivers/net/phy/Kconfig         |   6 +
 drivers/net/phy/Makefile        |   1 +
 drivers/net/phy/mdio-lynx-pcs.c | 358 ++++++++++++++++++++++++++++++++
 include/linux/mdio-lynx-pcs.h   |  43 ++++
 5 files changed, 415 insertions(+)
 create mode 100644 drivers/net/phy/mdio-lynx-pcs.c
 create mode 100644 include/linux/mdio-lynx-pcs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 301330e02bca..febba4b0a1fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10529,6 +10529,13 @@ F:	Documentation/devicetree/bindings/net/ieee802154/mcr20a.txt
 F:	drivers/net/ieee802154/mcr20a.c
 F:	drivers/net/ieee802154/mcr20a.h
 
+MDIO LYNX PCS MODULE
+M:	Ioana Ciornei <ioana.ciornei@nxp.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/phy/mdio-lynx-pcs.c
+F:	include/linux/mdio-lynx-pcs.h
+
 MEASUREMENT COMPUTING CIO-DAC IIO DRIVER
 M:	William Breathitt Gray <vilhelm.gray@gmail.com>
 L:	linux-iio@vger.kernel.org
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index f25702386d83..6ea835e5d8ec 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -235,6 +235,12 @@ config MDIO_XPCS
 	  This module provides helper functions for Synopsys DesignWare XPCS
 	  controllers.
 
+config MDIO_LYNX_PCS
+	bool
+	help
+	  This module provides helper functions for Lynx PCS enablement
+	  representing the PCS as an MDIO device.
+
 endif
 endif
 
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index dc9e53b511d6..931d826b3a2b 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
 obj-$(CONFIG_MDIO_XPCS)		+= mdio-xpcs.o
+obj-$(CONFIG_MDIO_LYNX_PCS)	+= mdio-lynx-pcs.o
 
 obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
 
diff --git a/drivers/net/phy/mdio-lynx-pcs.c b/drivers/net/phy/mdio-lynx-pcs.c
new file mode 100644
index 000000000000..becd01651500
--- /dev/null
+++ b/drivers/net/phy/mdio-lynx-pcs.c
@@ -0,0 +1,358 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2020 NXP
+ * Lynx PCS MDIO helpers
+ */
+
+#include <linux/mdio.h>
+#include <linux/phylink.h>
+#include <linux/mdio-lynx-pcs.h>
+
+#define SGMII_CLOCK_PERIOD_NS		8 /* PCS is clocked at 125 MHz */
+#define SGMII_LINK_TIMER_VAL(ns)	((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
+
+#define SGMII_AN_LINK_TIMER_NS		1600000 /* defined by SGMII spec */
+
+#define SGMII_LINK_TIMER_LO		0x12
+#define SGMII_LINK_TIMER_HI		0x13
+#define SGMII_IF_MODE			0x14
+#define SGMII_IF_MODE_SGMII_EN		BIT(0)
+#define SGMII_IF_MODE_USE_SGMII_AN	BIT(1)
+#define SGMII_IF_MODE_SPEED(x)		(((x) << 2) & GENMASK(3, 2))
+#define SGMII_IF_MODE_SPEED_MSK		GENMASK(3, 2)
+#define SGMII_IF_MODE_DUPLEX		BIT(4)
+
+#define USXGMII_ADVERTISE_LSTATUS(x)	(((x) << 15) & BIT(15))
+#define USXGMII_ADVERTISE_FDX		BIT(12)
+#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
+
+#define USXGMII_LPA_LSTATUS(lpa)	((lpa) >> 15)
+#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
+#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
+
+enum usxgmii_speed {
+	USXGMII_SPEED_10	= 0,
+	USXGMII_SPEED_100	= 1,
+	USXGMII_SPEED_1000	= 2,
+	USXGMII_SPEED_2500	= 4,
+};
+
+enum sgmii_speed {
+	SGMII_SPEED_10		= 0,
+	SGMII_SPEED_100		= 1,
+	SGMII_SPEED_1000	= 2,
+	SGMII_SPEED_2500	= 2,
+};
+
+static void lynx_pcs_an_restart_usxgmii(struct mdio_device *pcs)
+{
+	mdiobus_c45_write(pcs->bus, pcs->addr,
+			  MDIO_MMD_VEND2, MII_BMCR,
+			  BMCR_RESET | BMCR_ANENABLE | BMCR_ANRESTART);
+}
+
+static void lynx_pcs_an_restart(struct mdio_lynx_pcs *pcs, phy_interface_t ifmode)
+{
+	switch (ifmode) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		phylink_mii_c22_pcs_an_restart(pcs->dev);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		lynx_pcs_an_restart_usxgmii(pcs->dev);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		break;
+	default:
+		dev_err(&pcs->dev->dev, "Invalid PCS interface type %s\n",
+			phy_modes(ifmode));
+		break;
+	}
+}
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
+	switch (USXGMII_LPA_SPEED(lpa)) {
+	case USXGMII_SPEED_10:
+		state->speed = SPEED_10;
+		break;
+	case USXGMII_SPEED_100:
+		state->speed = SPEED_100;
+		break;
+	case USXGMII_SPEED_1000:
+		state->speed = SPEED_1000;
+		break;
+	case USXGMII_SPEED_2500:
+		state->speed = SPEED_2500;
+		break;
+	default:
+		break;
+	}
+
+	if (USXGMII_LPA_DUPLEX(lpa))
+		state->duplex = DUPLEX_FULL;
+	else
+		state->duplex = DUPLEX_HALF;
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
+}
+
+static void lynx_pcs_get_state(struct mdio_lynx_pcs *pcs, phy_interface_t ifmode,
+			       struct phylink_link_state *state)
+{
+	switch (ifmode) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		phylink_mii_c22_pcs_get_state(pcs->dev, state);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		lynx_pcs_get_state_2500basex(pcs->dev, state);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		lynx_pcs_get_state_usxgmii(pcs->dev, state);
+		break;
+	default:
+		break;
+	}
+
+	dev_dbg(&pcs->dev->dev,
+		"mode=%s/%s/%s link=%u an_enabled=%u an_complete=%u\n",
+		phy_modes(ifmode),
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
+	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
+	 * for the MAC PCS in order to acknowledge the AN.
+	 */
+	mdiobus_write(bus, addr, MII_ADVERTISE,
+		      ADVERTISE_SGMII | ADVERTISE_LPACK);
+
+	if_mode = SGMII_IF_MODE_SGMII_EN;
+	if (mode == MLO_AN_INBAND) {
+		u32 link_timer;
+
+		if_mode |= SGMII_IF_MODE_USE_SGMII_AN;
+
+		/* Adjust link timer for SGMII */
+		link_timer = SGMII_LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
+		mdiobus_write(bus, addr, SGMII_LINK_TIMER_LO, link_timer & 0xffff);
+		mdiobus_write(bus, addr, SGMII_LINK_TIMER_HI, link_timer >> 16);
+	}
+	mdiobus_modify(bus, addr, SGMII_IF_MODE,
+		       SGMII_IF_MODE_SGMII_EN | SGMII_IF_MODE_USE_SGMII_AN,
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
+	/* Configure device ability for the USXGMII Replicator */
+	mdiobus_c45_write(bus, addr, MDIO_MMD_VEND2, MII_ADVERTISE,
+			  USXGMII_ADVERTISE_SPEED(USXGMII_SPEED_2500) |
+			  USXGMII_ADVERTISE_LSTATUS(1) |
+			  ADVERTISE_SGMII |
+			  ADVERTISE_LPACK |
+			  USXGMII_ADVERTISE_FDX);
+	return 0;
+}
+
+static int lynx_pcs_config(struct mdio_lynx_pcs *pcs, unsigned int mode,
+			   phy_interface_t ifmode,
+			   const unsigned long *advertising)
+{
+	switch (ifmode) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		lynx_pcs_config_sgmii(pcs->dev, mode, advertising);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		/* 2500Base-X only works without in-band AN,
+		 * thus nothing to do here
+		 */
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		lynx_pcs_config_usxgmii(pcs->dev, mode, advertising);
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
+		if_mode |= SGMII_IF_MODE_DUPLEX;
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
+	if_mode |= SGMII_IF_MODE_SPEED(sgmii_speed);
+
+	mdiobus_modify(bus, addr, SGMII_IF_MODE,
+		       SGMII_IF_MODE_DUPLEX | SGMII_IF_MODE_SPEED_MSK,
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
+
+	if (mode == MLO_AN_INBAND) {
+		dev_err(&pcs->dev, "AN not supported for 2500BaseX\n");
+		return;
+	}
+
+	mdiobus_write(bus, addr, SGMII_IF_MODE,
+		      SGMII_IF_MODE_SGMII_EN |
+		      SGMII_IF_MODE_SPEED(SGMII_SPEED_2500));
+}
+
+static void lynx_pcs_link_up(struct mdio_lynx_pcs *pcs, unsigned int mode,
+			     phy_interface_t interface,
+			     int speed, int duplex)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		lynx_pcs_link_up_sgmii(pcs->dev, mode, speed, duplex);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		lynx_pcs_link_up_2500basex(pcs->dev, mode, speed, duplex);
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
+struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device *mdio_dev)
+{
+	struct mdio_lynx_pcs *pcs;
+
+	if (WARN_ON(!mdio_dev))
+		return NULL;
+
+	pcs = kzalloc(sizeof(*pcs), GFP_KERNEL);
+	if (!pcs)
+		return NULL;
+
+	pcs->dev = mdio_dev;
+	pcs->an_restart = lynx_pcs_an_restart;
+	pcs->get_state = lynx_pcs_get_state;
+	pcs->link_up = lynx_pcs_link_up;
+	pcs->config = lynx_pcs_config;
+
+	return pcs;
+}
+EXPORT_SYMBOL(mdio_lynx_pcs_create);
+
+void mdio_lynx_pcs_free(struct mdio_lynx_pcs *pcs)
+{
+	kfree(pcs);
+}
+EXPORT_SYMBOL(mdio_lynx_pcs_free);
diff --git a/include/linux/mdio-lynx-pcs.h b/include/linux/mdio-lynx-pcs.h
new file mode 100644
index 000000000000..480ae2e2ecd8
--- /dev/null
+++ b/include/linux/mdio-lynx-pcs.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2020 NXP
+ * Lynx PCS MDIO helpers
+ */
+
+#ifndef __LINUX_MDIO_LYNX_PCS_H
+#define __LINUX_MDIO_LYNX_PCS_H
+
+#include <linux/phy.h>
+#include <linux/mdio.h>
+
+struct mdio_lynx_pcs {
+	struct mdio_device *dev;
+
+	void (*an_restart)(struct mdio_lynx_pcs *pcs, phy_interface_t ifmode);
+
+	void (*get_state)(struct mdio_lynx_pcs *pcs, phy_interface_t ifmode,
+			  struct phylink_link_state *state);
+
+	int (*config)(struct mdio_lynx_pcs *pcs, unsigned int mode,
+		      phy_interface_t ifmode,
+		      const unsigned long *advertising);
+
+	void (*link_up)(struct mdio_lynx_pcs *pcs, unsigned int mode,
+			phy_interface_t ifmode, int speed, int duplex);
+};
+
+#if IS_ENABLED(CONFIG_MDIO_LYNX_PCS)
+struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device *mdio_dev);
+
+void mdio_lynx_pcs_free(struct mdio_lynx_pcs *pcs);
+#else
+static struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device *mdio_dev)
+{
+	return NULL;
+}
+
+static void mdio_lynx_pcs_free(struct mdio_lynx_pcs *pcs)
+{
+}
+#endif
+
+#endif /* __LINUX_MDIO_LYNX_PCS_H */
-- 
2.25.1

