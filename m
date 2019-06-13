Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5C94505A
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfFMX4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:56:39 -0400
Received: from inva021.nxp.com ([92.121.34.21]:34636 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfFMX4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 19:56:36 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4DC63200514;
        Fri, 14 Jun 2019 01:56:33 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3E8AD200503;
        Fri, 14 Jun 2019 01:56:33 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CE80C205DC;
        Fri, 14 Jun 2019 01:56:32 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, alexandru.marginean@nxp.com,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Date:   Fri, 14 Jun 2019 02:55:51 +0300
Message-Id: <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa2-mac driver binds to DPAA2 DPMAC objects, dynamically
discovered on the fsl-mc bus. It acts as a proxy between the PHY
management layer and the MC firmware, delivering any configuration
changes to the firmware and also setting any new configuration requested
though PHYLINK.

A in-depth view of the software architecture and the implementation can
be found in
'Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst'.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 MAINTAINERS                                      |   7 +
 drivers/net/ethernet/freescale/dpaa2/Kconfig     |  13 +
 drivers/net/ethernet/freescale/dpaa2/Makefile    |   2 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 541 +++++++++++++++++++++++
 4 files changed, 563 insertions(+)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c

diff --git a/MAINTAINERS b/MAINTAINERS
index dd247a059889..a024ab2b2548 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4929,6 +4929,13 @@ S:	Maintained
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp*
 F:	drivers/net/ethernet/freescale/dpaa2/dprtc*
 
+DPAA2 MAC DRIVER
+M:	Ioana Ciornei <ioana.ciornei@nxp.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*
+F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
+
 DPT_I2O SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
 L:	linux-scsi@vger.kernel.org
diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index 8bd384720f80..4ffa666c0a43 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -16,3 +16,16 @@ config FSL_DPAA2_PTP_CLOCK
 	help
 	  This driver adds support for using the DPAA2 1588 timer module
 	  as a PTP clock.
+
+config FSL_DPAA2_MAC
+	tristate "DPAA2 MAC / PHY proxy interface"
+	depends on FSL_MC_BUS
+	select MDIO_BUS_MUX_MMIOREG
+	select FSL_XGMAC_MDIO
+	select PHYLINK
+	help
+	  Prototype driver for DPAA2 MAC / PHY interface object.
+	  This driver works as a proxy between PHYLINK including phy drivers and
+	  the MC firmware.  It receives updates on link state changes from PHYLINK
+	  and forwards them to MC and receives interrupt from MC whenever a
+	  request is made to change the link state or configuration.
diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index d1e78cdd512f..e96386ab23ea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -5,10 +5,12 @@
 
 obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
 obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
+obj-$(CONFIG_FSL_DPAA2_MAC)		+= fsl-dpaa2-mac.o
 
 fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
+fsl-dpaa2-mac-objs	:= dpaa2-mac.o dpmac.o
 
 # Needed by the tracing framework
 CFLAGS_dpaa2-eth.o := -I$(src)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
new file mode 100644
index 000000000000..145ab4771788
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -0,0 +1,541 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2015 Freescale Semiconductor Inc.
+ * Copyright 2018-2019 NXP
+ */
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/msi.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_vlan.h>
+
+#include <net/netlink.h>
+#include <uapi/linux/if_bridge.h>
+
+#include <linux/of.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/phylink.h>
+#include <linux/notifier.h>
+
+#include <linux/fsl/mc.h>
+
+#include "dpmac.h"
+#include "dpmac-cmd.h"
+
+#define to_dpaa2_mac_priv(phylink_config) \
+	container_of(config, struct dpaa2_mac_priv, phylink_config)
+
+struct dpaa2_mac_priv {
+	struct fsl_mc_device *mc_dev;
+	struct dpmac_attr attr;
+	struct dpmac_link_state state;
+	u16 dpmac_ver_major;
+	u16 dpmac_ver_minor;
+
+	struct phylink *phylink;
+	struct phylink_config phylink_config;
+	struct ethtool_link_ksettings kset;
+};
+
+static phy_interface_t phy_mode(enum dpmac_eth_if eth_if)
+{
+	switch (eth_if) {
+	case DPMAC_ETH_IF_RGMII:
+		return PHY_INTERFACE_MODE_RGMII;
+	case DPMAC_ETH_IF_XFI:
+		return PHY_INTERFACE_MODE_10GKR;
+	case DPMAC_ETH_IF_USXGMII:
+		return PHY_INTERFACE_MODE_USXGMII;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int cmp_dpmac_ver(struct dpaa2_mac_priv *priv,
+			 u16 ver_major, u16 ver_minor)
+{
+	if (priv->dpmac_ver_major == ver_major)
+		return priv->dpmac_ver_minor - ver_minor;
+	return priv->dpmac_ver_major - ver_major;
+}
+
+struct dpaa2_mac_link_mode_map {
+	u64 dpmac_lm;
+	enum ethtool_link_mode_bit_indices ethtool_lm;
+};
+
+static const struct dpaa2_mac_link_mode_map dpaa2_mac_lm_map[] = {
+	{DPMAC_ADVERTISED_10BASET_FULL, ETHTOOL_LINK_MODE_10baseT_Full_BIT},
+	{DPMAC_ADVERTISED_100BASET_FULL, ETHTOOL_LINK_MODE_100baseT_Full_BIT},
+	{DPMAC_ADVERTISED_1000BASET_FULL, ETHTOOL_LINK_MODE_1000baseT_Full_BIT},
+	{DPMAC_ADVERTISED_10000BASET_FULL, ETHTOOL_LINK_MODE_10000baseT_Full_BIT},
+	{DPMAC_ADVERTISED_AUTONEG, ETHTOOL_LINK_MODE_Autoneg_BIT},
+};
+
+static void link_mode_phydev2dpmac(unsigned long *phydev_lm,
+				   u64 *dpmac_lm)
+{
+	enum ethtool_link_mode_bit_indices link_mode;
+	int i;
+
+	*dpmac_lm = 0;
+	for (i = 0; i < ARRAY_SIZE(dpaa2_mac_lm_map); i++) {
+		link_mode = dpaa2_mac_lm_map[i].ethtool_lm;
+		if (linkmode_test_bit(link_mode, phydev_lm))
+			*dpmac_lm |= dpaa2_mac_lm_map[i].dpmac_lm;
+	}
+}
+
+static void dpaa2_mac_ksettings_change(struct dpaa2_mac_priv *priv)
+{
+	struct fsl_mc_device *mc_dev = priv->mc_dev;
+	struct dpmac_link_cfg link_cfg = { 0 };
+	int err, i;
+
+	err = dpmac_get_link_cfg(mc_dev->mc_io, 0,
+				 mc_dev->mc_handle,
+				 &link_cfg);
+
+	if (err) {
+		dev_err(&mc_dev->dev, "dpmac_get_link_cfg() = %d\n", err);
+		return;
+	}
+
+	phylink_ethtool_ksettings_get(priv->phylink, &priv->kset);
+
+	priv->kset.base.speed = link_cfg.rate;
+	priv->kset.base.duplex = !!(link_cfg.options & DPMAC_LINK_OPT_HALF_DUPLEX);
+
+	ethtool_link_ksettings_zero_link_mode(&priv->kset, advertising);
+	for (i = 0; i < ARRAY_SIZE(dpaa2_mac_lm_map); i++) {
+		if (link_cfg.advertising & dpaa2_mac_lm_map[i].dpmac_lm)
+			__set_bit(dpaa2_mac_lm_map[i].ethtool_lm,
+				  priv->kset.link_modes.advertising);
+	}
+
+	if (link_cfg.options & DPMAC_LINK_OPT_AUTONEG) {
+		priv->kset.base.autoneg = AUTONEG_ENABLE;
+		__set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			  priv->kset.link_modes.advertising);
+	} else {
+		priv->kset.base.autoneg = AUTONEG_DISABLE;
+		__clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			    priv->kset.link_modes.advertising);
+	}
+
+	phylink_ethtool_ksettings_set(priv->phylink, &priv->kset);
+}
+
+static irqreturn_t dpaa2_mac_irq_handler(int irq_num, void *arg)
+{
+	struct device *dev = arg;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	struct dpaa2_mac_priv *priv = dev_get_drvdata(dev);
+	u32 status;
+	int err;
+
+	err = dpmac_get_irq_status(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				   DPMAC_IRQ_INDEX, &status);
+	if (unlikely(err || !status))
+		return IRQ_NONE;
+
+	rtnl_lock();
+	if (status & DPMAC_IRQ_EVENT_LINK_CFG_REQ)
+		dpaa2_mac_ksettings_change(priv);
+
+	if (status & DPMAC_IRQ_EVENT_LINK_UP_REQ)
+		phylink_start(priv->phylink);
+
+	if (status & DPMAC_IRQ_EVENT_LINK_DOWN_REQ)
+		phylink_stop(priv->phylink);
+	rtnl_unlock();
+
+	dpmac_clear_irq_status(mc_dev->mc_io, 0, mc_dev->mc_handle,
+			       DPMAC_IRQ_INDEX, status);
+
+	return IRQ_HANDLED;
+}
+
+static int dpaa2_mac_setup_irqs(struct fsl_mc_device *mc_dev)
+{
+	struct device *dev = &mc_dev->dev;
+	struct fsl_mc_device_irq *irq;
+	u32 irq_mask;
+	int err;
+
+	err = fsl_mc_allocate_irqs(mc_dev);
+	if (err) {
+		dev_err(dev, "fsl_mc_allocate_irqs() = %d\n", err);
+		return err;
+	}
+
+	irq = mc_dev->irqs[0];
+	err = devm_request_threaded_irq(dev, irq->msi_desc->irq,
+					NULL, &dpaa2_mac_irq_handler,
+					IRQF_NO_SUSPEND | IRQF_ONESHOT,
+					dev_name(&mc_dev->dev), dev);
+	if (err) {
+		dev_err(dev, "devm_request_threaded_irq() = %d\n", err);
+		goto free_irq;
+	}
+
+	irq_mask = DPMAC_IRQ_EVENT_LINK_CFG_REQ |
+		   DPMAC_IRQ_EVENT_LINK_CHANGED |
+		   DPMAC_IRQ_EVENT_LINK_UP_REQ |
+		   DPMAC_IRQ_EVENT_LINK_DOWN_REQ;
+
+	err = dpmac_set_irq_mask(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				 DPMAC_IRQ_INDEX, irq_mask);
+	if (err) {
+		dev_err(dev, "dpmac_set_irq_mask() = %d\n", err);
+		goto free_irq;
+	}
+	err = dpmac_set_irq_enable(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				   DPMAC_IRQ_INDEX, 1);
+	if (err) {
+		dev_err(dev, "dpmac_set_irq_enable() = %d\n", err);
+		goto free_irq;
+	}
+
+	return 0;
+
+free_irq:
+	fsl_mc_free_irqs(mc_dev);
+
+	return err;
+}
+
+static void dpaa2_mac_teardown_irqs(struct fsl_mc_device *mc_dev)
+{
+	int err;
+
+	err = dpmac_set_irq_enable(mc_dev->mc_io, 0, mc_dev->mc_handle,
+				   DPMAC_IRQ_INDEX, 0);
+	if (err)
+		dev_err(&mc_dev->dev, "dpmac_set_irq_enable err %d\n", err);
+
+	fsl_mc_free_irqs(mc_dev);
+}
+
+static struct device_node *of_find_dpmac_node(struct device *dev, u16 dpmac_id)
+{
+	struct device_node *dpmacs, *dpmac = NULL;
+	struct device_node *mc_node = dev->of_node;
+	u32 id;
+	int err;
+
+	dpmacs = of_find_node_by_name(mc_node, "dpmacs");
+	if (!dpmacs) {
+		dev_err(dev, "No dpmacs subnode in device-tree\n");
+		return NULL;
+	}
+
+	while ((dpmac = of_get_next_child(dpmacs, dpmac))) {
+		err = of_property_read_u32(dpmac, "reg", &id);
+		if (err)
+			continue;
+		if (id == dpmac_id)
+			return dpmac;
+	}
+
+	return NULL;
+}
+
+static void dpaa2_mac_validate(struct phylink_config *config,
+			       unsigned long *supported,
+			       struct phylink_link_state *state)
+{
+	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
+	struct dpmac_link_state *dpmac_state = &priv->state;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	phylink_set(mask, Autoneg);
+	phylink_set_port_modes(mask);
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_10GKR:
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 10000baseT_Full);
+		break;
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseT_Full);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 10000baseT_Full);
+		break;
+	default:
+		goto empty_set;
+	}
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	link_mode_phydev2dpmac(supported, &dpmac_state->supported);
+	link_mode_phydev2dpmac(state->advertising, &dpmac_state->advertising);
+
+	return;
+
+empty_set:
+	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
+			     const struct phylink_link_state *state)
+{
+	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
+	struct dpmac_link_state *dpmac_state = &priv->state;
+	struct device *dev = &priv->mc_dev->dev;
+	int err;
+
+	if (state->speed == SPEED_UNKNOWN && state->duplex == DUPLEX_UNKNOWN)
+		return;
+
+	dpmac_state->up = !!state->link;
+	if (dpmac_state->up) {
+		dpmac_state->rate = state->speed;
+
+		if (!state->duplex)
+			dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
+		else
+			dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
+
+		if (state->an_enabled)
+			dpmac_state->options |= DPMAC_LINK_OPT_AUTONEG;
+		else
+			dpmac_state->options &= ~DPMAC_LINK_OPT_AUTONEG;
+	}
+
+	err = dpmac_set_link_state(priv->mc_dev->mc_io, 0,
+				   priv->mc_dev->mc_handle, dpmac_state);
+	if (err)
+		dev_err(dev, "dpmac_set_link_state() = %d\n", err);
+}
+
+static void dpaa2_mac_link_up(struct phylink_config *config, unsigned int mode,
+			      phy_interface_t interface, struct phy_device *phy)
+{
+	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
+	struct dpmac_link_state *dpmac_state = &priv->state;
+	struct device *dev = &priv->mc_dev->dev;
+	int err;
+
+	dpmac_state->up = 1;
+	err = dpmac_set_link_state(priv->mc_dev->mc_io, 0,
+				   priv->mc_dev->mc_handle, dpmac_state);
+	if (err)
+		dev_err(dev, "dpmac_set_link_state() = %d\n", err);
+}
+
+static void dpaa2_mac_link_down(struct phylink_config *config,
+				unsigned int mode,
+				phy_interface_t interface)
+{
+	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
+	struct dpmac_link_state *dpmac_state = &priv->state;
+	struct device *dev = &priv->mc_dev->dev;
+	int err;
+
+	dpmac_state->up = 0;
+
+	err = dpmac_set_link_state(priv->mc_dev->mc_io, 0,
+				   priv->mc_dev->mc_handle, dpmac_state);
+	if (err)
+		dev_err(dev, "dpmac_set_link_state() = %d\n", err);
+}
+
+static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
+	.validate = dpaa2_mac_validate,
+	.mac_config = dpaa2_mac_config,
+	.mac_link_up = dpaa2_mac_link_up,
+	.mac_link_down = dpaa2_mac_link_down,
+};
+
+static int dpaa2_mac_probe(struct fsl_mc_device *mc_dev)
+{
+	struct dpaa2_mac_priv *priv = NULL;
+	struct device_node *dpmac_node;
+	struct phylink *phylink;
+	int if_mode, err = 0;
+	struct device *dev;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	dev = &mc_dev->dev;
+	priv->mc_dev = mc_dev;
+	dev_set_drvdata(dev, priv);
+
+	/* We may need to issue MC commands while in atomic context */
+	err = fsl_mc_portal_allocate(mc_dev, FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
+				     &mc_dev->mc_io);
+	if (err || !mc_dev->mc_io) {
+		dev_dbg(dev, "fsl_mc_portal_allocate error: %d\n", err);
+		err = -EPROBE_DEFER;
+		goto err_exit;
+	}
+
+	err = dpmac_open(mc_dev->mc_io, 0, mc_dev->obj_desc.id,
+			 &mc_dev->mc_handle);
+	if (err || !mc_dev->mc_handle) {
+		dev_err(dev, "dpmac_open error: %d\n", err);
+		err = -ENODEV;
+		goto err_free_mcp;
+	}
+
+	err = dpmac_get_api_version(mc_dev->mc_io, 0, &priv->dpmac_ver_major,
+				    &priv->dpmac_ver_minor);
+	if (err) {
+		dev_err(dev, "dpmac_get_api_version failed\n");
+		goto err_version;
+	}
+
+	if (cmp_dpmac_ver(priv, DPMAC_VER_MAJOR, DPMAC_VER_MINOR) < 0) {
+		dev_err(dev, "DPMAC version %u.%u lower than supported %u.%u\n",
+			priv->dpmac_ver_major, priv->dpmac_ver_minor,
+			DPMAC_VER_MAJOR, DPMAC_VER_MINOR);
+		err = -ENOTSUPP;
+		goto err_version;
+	}
+
+	err = dpmac_get_attributes(mc_dev->mc_io, 0,
+				   mc_dev->mc_handle, &priv->attr);
+	if (err) {
+		dev_err(dev, "dpmac_get_attributes err %d\n", err);
+		err = -EINVAL;
+		goto err_close;
+	}
+
+	if (priv->attr.link_type == DPMAC_LINK_TYPE_FIXED) {
+		dev_err(dev, "will not be probed because it's listed as TYPE_FIXED\n");
+		err = -EINVAL;
+		goto err_close;
+	}
+
+	/* Look up the DPMAC node in the device-tree. */
+	dpmac_node = of_find_dpmac_node(dev, priv->attr.id);
+	if (!dpmac_node) {
+		dev_err(dev, "No dpmac@%d subnode found.\n", priv->attr.id);
+		err = -ENODEV;
+		goto err_close;
+	}
+
+	err = dpaa2_mac_setup_irqs(mc_dev);
+	if (err) {
+		err = -EFAULT;
+		goto err_close;
+	}
+
+	/* Get the interface mode from the dpmac of node or
+	 * from the MC attributes
+	 */
+	if_mode = of_get_phy_mode(dpmac_node);
+	if (if_mode >= 0) {
+		dev_dbg(dev, "\tusing if mode %s for eth_if %d\n",
+			phy_modes(if_mode), priv->attr.eth_if);
+		goto operation_mode;
+	}
+
+	if_mode = phy_mode(priv->attr.eth_if);
+	if (if_mode >= 0) {
+		dev_dbg(dev, "\tusing if mode %s for eth_if %d\n",
+			phy_modes(if_mode), priv->attr.eth_if);
+	} else {
+		dev_err(dev, "Unexpected interface mode %d\n",
+			priv->attr.eth_if);
+		err = -EINVAL;
+		goto err_no_if_mode;
+	}
+
+operation_mode:
+	priv->phylink_config.dev = dev;
+	priv->phylink_config.type = PHYLINK_DEV;
+
+	phylink = phylink_create(&priv->phylink_config,
+				 of_fwnode_handle(dpmac_node), if_mode,
+				 &dpaa2_mac_phylink_ops);
+	if (IS_ERR(phylink)) {
+		err = PTR_ERR(phylink);
+		goto err_phylink_create;
+	}
+	priv->phylink = phylink;
+
+	err = phylink_of_phy_connect(priv->phylink, dpmac_node, 0);
+	if (err) {
+		pr_err("phylink_of_phy_connect() = %d\n", err);
+		goto err_phylink_connect;
+	}
+
+	return 0;
+
+err_phylink_connect:
+	phylink_destroy(priv->phylink);
+err_phylink_create:
+err_no_if_mode:
+	dpaa2_mac_teardown_irqs(mc_dev);
+err_version:
+err_close:
+	dpmac_close(mc_dev->mc_io, 0, mc_dev->mc_handle);
+err_free_mcp:
+	fsl_mc_portal_free(mc_dev->mc_io);
+err_exit:
+	return err;
+}
+
+static int dpaa2_mac_remove(struct fsl_mc_device *mc_dev)
+{
+	struct device *dev = &mc_dev->dev;
+	struct dpaa2_mac_priv *priv = dev_get_drvdata(dev);
+
+	/* PHY teardown */
+	phylink_stop(priv->phylink);
+	phylink_disconnect_phy(priv->phylink);
+	phylink_destroy(priv->phylink);
+
+	/* free resources */
+	dpaa2_mac_teardown_irqs(priv->mc_dev);
+	dpmac_close(priv->mc_dev->mc_io, 0, priv->mc_dev->mc_handle);
+	fsl_mc_portal_free(priv->mc_dev->mc_io);
+
+	kfree(priv);
+	dev_set_drvdata(dev, NULL);
+
+	return 0;
+}
+
+static const struct fsl_mc_device_id dpaa2_mac_match_id_table[] = {
+	{
+		.vendor = FSL_MC_VENDOR_FREESCALE,
+		.obj_type = "dpmac",
+	},
+	{ .vendor = 0x0 }
+};
+MODULE_DEVICE_TABLE(fslmc, dpaa2_mac_match_id_table);
+
+static struct fsl_mc_driver dpaa2_mac_drv = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = dpaa2_mac_probe,
+	.remove = dpaa2_mac_remove,
+	.match_id_table = dpaa2_mac_match_id_table,
+};
+
+module_fsl_mc_driver(dpaa2_mac_drv);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("DPAA2 PHY proxy interface driver");
-- 
1.9.1

