Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B172C1E51F2
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgE0Xlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgE0Xlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:40 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C70C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:40 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so30059889ejd.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cNAMDe8N9Frqf6f0M1hn6+fArt+mMdWHK5E9+0QvZfI=;
        b=SIZFVUA32B3K38D1WLvJXVTolB5EDVKUJur6bpMWXdM6D5XgWnU2Fc56eJ7pkiouMA
         P9Wu1xLQay46qwjZCeaepF4JY9DyHXh6SAqkU/U4mzzhSN2jPoDnScQqVWeXLWXxfsTz
         KYVD6ZHV8XJ7tJ9voCsIGqu+rcfdtx95sL5GhFJYcb7kLcivHjtSMzjTUQP5JZyo0zur
         x8O1XiUftXJsQKaJN8XmakFIJdce97/Tf9jmkem19TN3TOaWk8oRBKDvSRpHcuz4sP/p
         PbVkoJb+9YgPElzA4iVFtRlMZ5IQG3Pu5PCJ/7Fd6ADOpNVbNEwSDZPu8b2rvqxMi1pF
         Aw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cNAMDe8N9Frqf6f0M1hn6+fArt+mMdWHK5E9+0QvZfI=;
        b=G+blXCOolJ0KFco05mURwfQfSmKDTVIEi24wD97TVtzy1PyA41mv9YTivvmv7bUQHX
         PJDhunN5hZAbjWwTblI4ruY7vHskPX7A/3Ts2TFtNf/bebTuxvwcmPmnnbbYHAWfopcW
         qU+o4vv1hTCPoYOq1RqeQjhXoxo70bVQK9t2NeLi477wT3XjUwxEX68HDWZHsS9gBDHZ
         AArp7EW8CIqIFrli/P/b1+e6QE+vYnxOa6I6uoUOOCkgi+oOoS688Wwq8EAWI0FfyA0W
         CO1CUvKfb9a5tBPs4JUerBthpezUQW2fSIk0AfBmhQ3mdtqS4QzQ496X3JZiW/DT9new
         jQ3g==
X-Gm-Message-State: AOAM531GvSEElWoo9MyLoY+2khtm2POgWYmh79RWd6WOhOYxuoQTA5f6
        jrsjJ4Qqxx2OLedNla3ttA0=
X-Google-Smtp-Source: ABdhPJyQ6Pet7PjROnk6+LcWZLe+Z4qVeaWkHlE8xWW7BFrNZD8bfnEvjnaW7vlZP0jB/L7OGdyOcA==
X-Received: by 2002:a17:906:35cf:: with SMTP id p15mr344721ejb.520.1590622898358;
        Wed, 27 May 2020 16:41:38 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for Seville VSC9953 switch
Date:   Thu, 28 May 2020 02:41:13 +0300
Message-Id: <20200527234113.2491988-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

This is a 10-port (8 external, 2 internal) switch from
Vitesse/Microsemi/Microchip that is integrated into the Freescale/NXP
T1040 PowerPC SoC. The situation is very similar to Felix from NXP
LS1028A, except that this is a platform device and Felix is a PCI
device.

Extending the Felix driver to probe a PCI as well as a platform device
would have introduced unnecessary complexity. The 'meat' of both drivers
is in drivers/net/ethernet/mscc/ocelot*.c anyway, so let's just
duplicate the Felix driver, s/Felix/Seville/, and define the low-level
bits in seville_vsc9953.c.

Like Felix, this driver configures its own PCS on the internal MDIO bus
using a phy_device abstraction for it (yes, it will be refactored to use
a raw mdio_device, like other phylink drivers do, but let's keep it like
that for now). But unlike Felix, the MDIO bus and the PCS are not from
the same vendor. The PCS is the same QorIQ/Layerscape PCS as found in
Felix/ENETC/DPAA*, but the internal MDIO bus that is used to access it
is actually an instantiation of drivers/net/phy/mdio-mscc-miim.c. But it
would be difficult to reuse that driver (it doesn't even use regmap, and
it's less than 200 lines of code), so we hand-roll here some internal
MDIO bus accessors within seville_vsc9953.c, which serves the purpose of
driving the PCS absolutely fine.

Also, same as Felix, the PCS doesn't support dynamic reconfiguration of
SerDes protocol, so we need to do pre-validation of PHY mode from device
tree and not let phylink change it.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig           |   12 +
 drivers/net/dsa/ocelot/Makefile          |    6 +
 drivers/net/dsa/ocelot/seville.c         |  742 +++++++++++++++
 drivers/net/dsa/ocelot/seville.h         |   50 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1064 ++++++++++++++++++++++
 5 files changed, 1874 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/seville.c
 create mode 100644 drivers/net/dsa/ocelot/seville.h
 create mode 100644 drivers/net/dsa/ocelot/seville_vsc9953.c

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index a5b7cca03d09..38763b829b17 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -12,3 +12,15 @@ config NET_DSA_MSCC_FELIX
 	  the Vitesse / Microsemi / Microchip Ocelot family of switching cores.
 	  It is embedded as a PCIe function of the NXP LS1028A ENETC integrated
 	  endpoint.
+
+config NET_DSA_MSCC_SEVILLE
+	tristate "Ocelot / Seville Ethernet switch support"
+	depends on NET_DSA
+	depends on NET_VENDOR_MICROSEMI
+	depends on NET_VENDOR_FREESCALE
+	select MSCC_OCELOT_SWITCH
+	select NET_DSA_TAG_OCELOT
+	help
+	  This driver supports the VSC9953 network switch, which is a member of
+	  the Vitesse / Microsemi / Microchip Ocelot family of switching cores.
+	  It is embedded inside the NXP T1040 SoC.
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index 37ad403e0b2a..17b1ccdcbf17 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -4,3 +4,9 @@ obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
 mscc_felix-objs := \
 	felix.o \
 	felix_vsc9959.o
+
+obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
+
+mscc_seville-objs := \
+	seville.o \
+	seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/seville.c b/drivers/net/dsa/ocelot/seville.c
new file mode 100644
index 000000000000..bc9c62d2d994
--- /dev/null
+++ b/drivers/net/dsa/ocelot/seville.c
@@ -0,0 +1,742 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Distributed Switch Architecture VSC9953 driver
+ * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
+ */
+#include <uapi/linux/if_bridge.h>
+#include <soc/mscc/ocelot_qsys.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot_dev.h>
+#include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot.h>
+#include <linux/packing.h>
+#include <linux/module.h>
+#include <linux/of_net.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <net/pkt_sched.h>
+#include <net/dsa.h>
+#include "seville.h"
+
+static enum dsa_tag_protocol seville_get_tag_protocol(struct dsa_switch *ds,
+						      int port,
+						      enum dsa_tag_protocol mp)
+{
+	return DSA_TAG_PROTO_OCELOT;
+}
+
+static int seville_set_ageing_time(struct dsa_switch *ds,
+				   unsigned int ageing_time)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_set_ageing_time(ocelot, ageing_time);
+
+	return 0;
+}
+
+static int seville_fdb_dump(struct dsa_switch *ds, int port,
+			    dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_fdb_dump(ocelot, port, cb, data);
+}
+
+static int seville_fdb_add(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_fdb_add(ocelot, port, addr, vid);
+}
+
+static int seville_fdb_del(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_fdb_del(ocelot, port, addr, vid);
+}
+
+static void seville_bridge_stp_state_set(struct dsa_switch *ds, int port,
+				         u8 state)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_bridge_stp_state_set(ocelot, port, state);
+}
+
+static int seville_bridge_join(struct dsa_switch *ds, int port,
+			       struct net_device *br)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_bridge_join(ocelot, port, br);
+}
+
+static void seville_bridge_leave(struct dsa_switch *ds, int port,
+			         struct net_device *br)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_bridge_leave(ocelot, port, br);
+}
+
+/* This callback needs to be present */
+static int seville_vlan_prepare(struct dsa_switch *ds, int port,
+			        const struct switchdev_obj_port_vlan *vlan)
+{
+	return 0;
+}
+
+static int seville_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_vlan_filtering(ocelot, port, enabled);
+
+	return 0;
+}
+
+static void seville_vlan_add(struct dsa_switch *ds, int port,
+			     const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ocelot *ocelot = ds->priv;
+	u16 flags = vlan->flags;
+	u16 vid;
+	int err;
+
+	if (dsa_is_cpu_port(ds, port))
+		flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		err = ocelot_vlan_add(ocelot, port, vid,
+				      flags & BRIDGE_VLAN_INFO_PVID,
+				      flags & BRIDGE_VLAN_INFO_UNTAGGED);
+		if (err) {
+			dev_err(ds->dev, "Failed to add VLAN %d to port %d: %d\n",
+				vid, port, err);
+			return;
+		}
+	}
+}
+
+static int seville_vlan_del(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_vlan *vlan)
+{
+	struct ocelot *ocelot = ds->priv;
+	u16 vid;
+	int err;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		err = ocelot_vlan_del(ocelot, port, vid);
+		if (err) {
+			dev_err(ds->dev, "Failed to remove VLAN %d from port %d: %d\n",
+				vid, port, err);
+			return err;
+		}
+	}
+	return 0;
+}
+
+static int seville_port_enable(struct dsa_switch *ds, int port,
+			       struct phy_device *phy)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_enable(ocelot, port, phy);
+
+	return 0;
+}
+
+static void seville_port_disable(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_disable(ocelot, port);
+}
+
+static void seville_phylink_validate(struct dsa_switch *ds, int port,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != ocelot_port->phy_mode) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	/* No half-duplex. */
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Full);
+
+	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
+	    state->interface == PHY_INTERFACE_MODE_2500BASEX) {
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+	}
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int seville_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
+					     struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct seville *seville = ocelot_to_seville(ocelot);
+
+	if (seville->info->pcs_link_state)
+		seville->info->pcs_link_state(ocelot, port, state);
+
+	return 0;
+}
+
+static void seville_phylink_mac_config(struct dsa_switch *ds, int port,
+				       unsigned int link_an_mode,
+				       const struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct seville *seville = ocelot_to_seville(ocelot);
+
+	if (port == 8 || port == 9) {
+		ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(OCELOT_SPEED_2500),
+			 ANA_PFC_PFC_CFG, port);
+		/* Flow control */
+		ocelot_write_rix(ocelot, SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
+				 SYS_MAC_FC_CFG_RX_FC_ENA |
+				 SYS_MAC_FC_CFG_TX_FC_ENA |
+				 SYS_MAC_FC_CFG_ZERO_PAUSE_ENA |
+				 SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
+				 SYS_MAC_FC_CFG_FC_LINK_SPEED(OCELOT_SPEED_2500),
+				 SYS_MAC_FC_CFG, port);
+	} else {
+		ocelot_write_gix(ocelot,
+				 ANA_PFC_PFC_CFG_FC_LINK_SPEED(OCELOT_SPEED_1000),
+				 ANA_PFC_PFC_CFG, port);
+		/* Flow control */
+		ocelot_write_rix(ocelot, SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
+				 SYS_MAC_FC_CFG_RX_FC_ENA |
+				 SYS_MAC_FC_CFG_TX_FC_ENA |
+				 SYS_MAC_FC_CFG_ZERO_PAUSE_ENA |
+				 SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
+				 SYS_MAC_FC_CFG_FC_LINK_SPEED(OCELOT_SPEED_1000),
+				 SYS_MAC_FC_CFG, port);
+	}
+
+	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
+			   DEV_CLOCK_CFG);
+
+	/* Enable MAC module */
+	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
+			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
+
+	if (seville->info->pcs_init)
+		seville->info->pcs_init(ocelot, port, link_an_mode, state);
+}
+
+static void seville_phylink_mac_an_restart(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct seville *seville = ocelot_to_seville(ocelot);
+
+	if (seville->info->pcs_an_restart)
+		seville->info->pcs_an_restart(ocelot, port);
+}
+
+static void seville_phylink_mac_link_down(struct dsa_switch *ds, int port,
+					  unsigned int link_an_mode,
+					  phy_interface_t interface)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
+	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
+}
+
+static void seville_phylink_mac_link_up(struct dsa_switch *ds, int port,
+					unsigned int link_an_mode,
+					phy_interface_t interface,
+					struct phy_device *phydev,
+					int speed, int duplex,
+					bool tx_pause, bool rx_pause)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	/* Enable MAC module */
+	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
+			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
+
+	/* Enable receiving frames on the port, and activate auto-learning of
+	 * MAC addresses.
+	 */
+	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_LEARNAUTO |
+			 ANA_PORT_PORT_CFG_RECV_ENA |
+			 ANA_PORT_PORT_CFG_PORTID_VAL(port),
+			 ANA_PORT_PORT_CFG, port);
+
+	/* Core: Enable port for frame transfer */
+	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE, 1);
+	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
+}
+
+static void seville_get_strings(struct dsa_switch *ds, int port,
+				u32 stringset, u8 *data)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_get_strings(ocelot, port, stringset, data);
+}
+
+static void seville_get_ethtool_stats(struct dsa_switch *ds, int port,
+				      u64 *data)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_get_ethtool_stats(ocelot, port, data);
+}
+
+static int seville_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_get_sset_count(ocelot, port, sset);
+}
+
+static int seville_parse_ports_node(struct seville *seville,
+				    struct device_node *ports_node,
+				    phy_interface_t *port_phy_modes)
+{
+	struct ocelot *ocelot = &seville->ocelot;
+	struct device *dev = seville->ocelot.dev;
+	struct device_node *child;
+
+	for_each_available_child_of_node(ports_node, child) {
+		phy_interface_t phy_mode;
+		u32 port;
+		int err;
+
+		/* Get switch port number from DT */
+		if (of_property_read_u32(child, "reg", &port) < 0) {
+			dev_err(dev, "Port number not defined in device tree "
+				"(property \"reg\")\n");
+			of_node_put(child);
+			return -ENODEV;
+		}
+
+		/* Get PHY mode from DT */
+		err = of_get_phy_mode(child, &phy_mode);
+		if (err) {
+			dev_err(dev, "Failed to read phy-mode or "
+				"phy-interface-type property for port %d\n",
+				port);
+			of_node_put(child);
+			return -ENODEV;
+		}
+
+		err = seville->info->prevalidate_phy_mode(ocelot, port,
+							  phy_mode);
+		if (err < 0) {
+			dev_err(dev, "Unsupported PHY mode %s on port %d\n",
+				phy_modes(phy_mode), port);
+			return err;
+		}
+
+		port_phy_modes[port] = phy_mode;
+	}
+
+	return 0;
+}
+
+static int seville_parse_dt(struct seville *seville,
+			    phy_interface_t *port_phy_modes)
+{
+	struct device *dev = seville->ocelot.dev;
+	struct device_node *switch_node;
+	struct device_node *ports_node;
+	int err;
+
+	switch_node = dev->of_node;
+
+	ports_node = of_get_child_by_name(switch_node, "ports");
+	if (!ports_node) {
+		dev_err(dev, "Incorrect bindings: absent \"ports\" node\n");
+		return -ENODEV;
+	}
+
+	err = seville_parse_ports_node(seville, ports_node, port_phy_modes);
+	of_node_put(ports_node);
+
+	return err;
+}
+
+static int seville_init_structs(struct seville *seville, int num_phys_ports)
+{
+	struct ocelot *ocelot = &seville->ocelot;
+	phy_interface_t *port_phy_modes;
+	struct resource res;
+	int port, i, err;
+
+	ocelot->num_phys_ports = num_phys_ports;
+	ocelot->ports = devm_kcalloc(ocelot->dev, num_phys_ports,
+				     sizeof(struct ocelot_port *), GFP_KERNEL);
+	if (!ocelot->ports)
+		return -ENOMEM;
+
+	ocelot->map		= seville->info->map;
+	ocelot->stats_layout	= seville->info->stats_layout;
+	ocelot->num_stats	= seville->info->num_stats;
+	ocelot->shared_queue_sz	= seville->info->shared_queue_sz;
+	ocelot->num_mact_rows	= seville->info->num_mact_rows;
+	ocelot->vcap_is2_keys	= seville->info->vcap_is2_keys;
+	ocelot->vcap_is2_actions = seville->info->vcap_is2_actions;
+	ocelot->vcap		= seville->info->vcap;
+	ocelot->ops		= seville->info->ops;
+
+	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
+				 GFP_KERNEL);
+	if (!port_phy_modes)
+		return -ENOMEM;
+
+	err = seville_parse_dt(seville, port_phy_modes);
+	if (err) {
+		kfree(port_phy_modes);
+		return err;
+	}
+
+	for (i = 0; i < TARGET_MAX; i++) {
+		struct regmap *target;
+
+		if (!seville->info->target_io_res[i].name)
+			continue;
+
+		memcpy(&res, &seville->info->target_io_res[i], sizeof(res));
+		res.flags = IORESOURCE_MEM;
+		res.start += seville->switch_base;
+		res.end += seville->switch_base;
+
+		target = ocelot_regmap_init(ocelot, &res);
+		if (IS_ERR(target)) {
+			dev_err(ocelot->dev,
+				"Failed to map device memory space\n");
+			kfree(port_phy_modes);
+			return PTR_ERR(target);
+		}
+
+		ocelot->targets[i] = target;
+	}
+
+	err = ocelot_regfields_init(ocelot, seville->info->regfields);
+	if (err) {
+		dev_err(ocelot->dev, "failed to init reg fields map\n");
+		kfree(port_phy_modes);
+		return err;
+	}
+
+	for (port = 0; port < num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port;
+		struct regmap *target;
+		u64 bypass, dest, src;
+		u8 *template;
+
+		ocelot_port = devm_kzalloc(ocelot->dev,
+					   sizeof(struct ocelot_port),
+					   GFP_KERNEL);
+		if (!ocelot_port) {
+			dev_err(ocelot->dev,
+				"failed to allocate port memory\n");
+			kfree(port_phy_modes);
+			return -ENOMEM;
+		}
+
+		memcpy(&res, &seville->info->port_io_res[port], sizeof(res));
+		res.flags = IORESOURCE_MEM;
+		res.start += seville->switch_base;
+		res.end += seville->switch_base;
+
+		target = ocelot_regmap_init(ocelot, &res);
+		if (IS_ERR(target)) {
+			dev_err(ocelot->dev,
+				"Failed to map memory space for port %d\n",
+				port);
+			kfree(port_phy_modes);
+			return PTR_ERR(target);
+		}
+
+		template = devm_kzalloc(ocelot->dev, OCELOT_TAG_LEN,
+					GFP_KERNEL);
+		if (!template) {
+			dev_err(ocelot->dev,
+				"Failed to allocate memory for DSA tag\n");
+			kfree(port_phy_modes);
+			return -ENOMEM;
+		}
+
+		/* Set the source port as the CPU port module and not the
+		 * NPI port
+		 */
+		src = ocelot->num_phys_ports;
+		dest = BIT(port);
+		bypass = true;
+
+		packing(template, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
+		packing(template, &dest,    67,  57, OCELOT_TAG_LEN, PACK, 0);
+		packing(template, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
+
+		ocelot_port->phy_mode = port_phy_modes[port];
+		ocelot_port->ocelot = ocelot;
+		ocelot_port->target = target;
+		ocelot_port->xmit_template = template;
+		ocelot->ports[port] = ocelot_port;
+	}
+
+	kfree(port_phy_modes);
+
+	if (seville->info->mdio_bus_alloc) {
+		err = seville->info->mdio_bus_alloc(ocelot);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+static int seville_setup(struct dsa_switch *ds)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct seville *seville = ocelot_to_seville(ocelot);
+	int port, err;
+
+	err = seville_init_structs(seville, ds->num_ports);
+	if (err)
+		return err;
+
+	ocelot_init(ocelot);
+
+	for (port = 0; port < ds->num_ports; port++) {
+		ocelot_init_port(ocelot, port);
+		if (dsa_is_cpu_port(ds, port))
+			ocelot_configure_cpu(ocelot, port,
+					     OCELOT_TAG_PREFIX_NONE,
+					     OCELOT_TAG_PREFIX_LONG);
+	}
+
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_UC);
+
+	ds->mtu_enforcement_ingress = true;
+	ds->configure_vlan_while_not_filtering = true;
+	return 0;
+}
+
+static void seville_teardown(struct dsa_switch *ds)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct seville *seville = ocelot_to_seville(ocelot);
+
+	if (seville->info->mdio_bus_free)
+		seville->info->mdio_bus_free(ocelot);
+
+	/* stop workqueue thread */
+	ocelot_deinit(ocelot);
+}
+
+static int seville_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_set_maxlen(ocelot, port, new_mtu);
+
+	return 0;
+}
+
+static int seville_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_get_max_mtu(ocelot, port);
+}
+
+static int seville_cls_flower_add(struct dsa_switch *ds, int port,
+				struct flow_cls_offload *cls, bool ingress)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_cls_flower_replace(ocelot, port, cls, ingress);
+}
+
+static int seville_cls_flower_del(struct dsa_switch *ds, int port,
+				struct flow_cls_offload *cls, bool ingress)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_cls_flower_destroy(ocelot, port, cls, ingress);
+}
+
+static int seville_cls_flower_stats(struct dsa_switch *ds, int port,
+				  struct flow_cls_offload *cls, bool ingress)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_cls_flower_stats(ocelot, port, cls, ingress);
+}
+
+static int seville_port_policer_add(struct dsa_switch *ds, int port,
+				  struct dsa_mall_policer_tc_entry *policer)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_policer pol = {
+		.rate = div_u64(policer->rate_bytes_per_sec, 1000) * 8,
+		.burst = div_u64(policer->rate_bytes_per_sec *
+				 PSCHED_NS2TICKS(policer->burst),
+				 PSCHED_TICKS_PER_SEC),
+	};
+
+	return ocelot_port_policer_add(ocelot, port, &pol);
+}
+
+static void seville_port_policer_del(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_policer_del(ocelot, port);
+}
+
+static const struct dsa_switch_ops seville_switch_ops = {
+	.get_tag_protocol	= seville_get_tag_protocol,
+	.setup			= seville_setup,
+	.teardown		= seville_teardown,
+	.set_ageing_time	= seville_set_ageing_time,
+	.get_strings		= seville_get_strings,
+	.get_ethtool_stats	= seville_get_ethtool_stats,
+	.get_sset_count		= seville_get_sset_count,
+	.phylink_validate	= seville_phylink_validate,
+	.phylink_mac_link_state	= seville_phylink_mac_pcs_get_state,
+	.phylink_mac_config	= seville_phylink_mac_config,
+	.phylink_mac_an_restart	= seville_phylink_mac_an_restart,
+	.phylink_mac_link_down	= seville_phylink_mac_link_down,
+	.phylink_mac_link_up	= seville_phylink_mac_link_up,
+	.port_enable		= seville_port_enable,
+	.port_disable		= seville_port_disable,
+	.port_fdb_dump		= seville_fdb_dump,
+	.port_fdb_add		= seville_fdb_add,
+	.port_fdb_del		= seville_fdb_del,
+	.port_bridge_join	= seville_bridge_join,
+	.port_bridge_leave	= seville_bridge_leave,
+	.port_stp_state_set	= seville_bridge_stp_state_set,
+	.port_vlan_prepare	= seville_vlan_prepare,
+	.port_vlan_filtering	= seville_vlan_filtering,
+	.port_vlan_add		= seville_vlan_add,
+	.port_vlan_del		= seville_vlan_del,
+	.port_change_mtu	= seville_change_mtu,
+	.port_max_mtu		= seville_get_max_mtu,
+	.port_policer_add	= seville_port_policer_add,
+	.port_policer_del	= seville_port_policer_del,
+	.cls_flower_add		= seville_cls_flower_add,
+	.cls_flower_del		= seville_cls_flower_del,
+	.cls_flower_stats	= seville_cls_flower_stats,
+};
+
+static int seville_probe(struct platform_device *pdev)
+{
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct seville *seville;
+	struct resource *res;
+	int err;
+
+	seville = kzalloc(sizeof(struct seville), GFP_KERNEL);
+	if (!seville) {
+		err = -ENOMEM;
+		dev_err(&pdev->dev, "Failed to allocate driver memory\n");
+		goto err_alloc_seville;
+	}
+
+	platform_set_drvdata(pdev, seville);
+
+	ocelot = &seville->ocelot;
+	ocelot->dev = &pdev->dev;
+	seville->pdev = pdev;
+	seville->info = &seville_info_vsc9953;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	seville->switch_base = res->start;
+
+	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
+	if (!ds) {
+		err = -ENOMEM;
+		dev_err(&pdev->dev, "Failed to allocate DSA switch\n");
+		goto err_alloc_ds;
+	}
+
+	ds->dev = &pdev->dev;
+	ds->num_ports = seville->info->num_ports;
+	ds->ops = &seville_switch_ops;
+	ds->priv = ocelot;
+	seville->ds = ds;
+
+	err = dsa_register_switch(ds);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
+		goto err_register_ds;
+	}
+
+	return 0;
+
+err_register_ds:
+	kfree(ds);
+err_alloc_ds:
+err_alloc_seville:
+	kfree(seville);
+	return err;
+}
+
+static int seville_remove(struct platform_device *pdev)
+{
+	struct seville *seville;
+
+	seville = platform_get_drvdata(pdev);
+
+	dsa_unregister_switch(seville->ds);
+
+	kfree(seville->ds);
+	kfree(seville);
+
+	return 0;
+}
+
+static const struct of_device_id seville_of_match[] = {
+	{ .compatible = "mscc,vsc9953-switch" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, seville_of_match);
+
+static struct platform_driver seville_driver = {
+	.probe		= seville_probe,
+	.remove		= seville_remove,
+	.driver = {
+		.name		= KBUILD_MODNAME,
+		.of_match_table	= of_match_ptr(seville_of_match),
+	},
+};
+module_platform_driver(seville_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Maxim Kochetkov <fido_max@inbox.ru>");
+MODULE_DESCRIPTION("Seville Switch driver");
diff --git a/drivers/net/dsa/ocelot/seville.h b/drivers/net/dsa/ocelot/seville.h
new file mode 100644
index 000000000000..242e7ce27de9
--- /dev/null
+++ b/drivers/net/dsa/ocelot/seville.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Distributed Switch Architecture VSC9953 driver
+ * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
+ */
+#ifndef _MSCC_SEVILLE_H
+#define _MSCC_SEVILLE_H
+
+#define ocelot_to_seville(o)		container_of((o), struct seville, ocelot)
+
+/* Platform-specific information */
+struct seville_info {
+	const struct resource		*target_io_res;
+	const struct resource		*port_io_res;
+	const struct reg_field		*regfields;
+	const u32 *const		*map;
+	const struct ocelot_ops		*ops;
+	int				shared_queue_sz;
+	int				num_mact_rows;
+	const struct ocelot_stat_layout	*stats_layout;
+	unsigned int			num_stats;
+	int				num_ports;
+	struct vcap_field		*vcap_is2_keys;
+	struct vcap_field		*vcap_is2_actions;
+	const struct vcap_props		*vcap;
+	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
+	void	(*mdio_bus_free)(struct ocelot *ocelot);
+	void	(*pcs_init)(struct ocelot *ocelot, int port,
+			    unsigned int link_an_mode,
+			    const struct phylink_link_state *state);
+	void	(*pcs_an_restart)(struct ocelot *ocelot, int port);
+	void	(*pcs_link_state)(struct ocelot *ocelot, int port,
+				  struct phylink_link_state *state);
+	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
+					phy_interface_t phy_mode);
+};
+
+extern struct seville_info		seville_info_vsc9953;
+
+/* DSA glue / front-end for struct ocelot */
+struct seville {
+	struct dsa_switch		*ds;
+	struct platform_device			*pdev;
+	struct seville_info		*info;
+	struct ocelot			ocelot;
+	resource_size_t switch_base;
+	struct mii_bus			*imdio;
+	struct phy_device		**pcs;
+};
+
+#endif
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
new file mode 100644
index 000000000000..e40d3a318a14
--- /dev/null
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -0,0 +1,1064 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Distributed Switch Architecture VSC9953 driver
+ * Copyright (C) 2020, Maxim Kochetkov <fido_max@inbox.ru>
+ */
+#include <linux/types.h>
+#include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot.h>
+#include <linux/iopoll.h>
+#include <linux/pci.h>
+#include "seville.h"
+
+#define VSC9953_VCAP_IS2_CNT		1024
+#define VSC9953_VCAP_IS2_ENTRY_WIDTH	376
+#define VSC9953_VCAP_PORT_CNT		10
+
+/* PCS registers */
+#define MDIO_SGMII_DEV_ABIL_SGMII	0x04
+#define MDIO_SGMII_LINK_TMR_L		0x12
+#define MDIO_SGMII_LINK_TMR_H		0x13
+#define MDIO_SGMII_IF_MODE		0x14
+
+/* SGMII Control defines */
+#define SGMII_CR_AN_EN			0x1000
+#define SGMII_CR_RESTART_AN		0x0200
+#define SGMII_CR_FD			0x0100
+#define SGMII_CR_SPEED_SEL1_1G		0x0040
+#define SGMII_CR_DEF_VAL		(SGMII_CR_AN_EN | SGMII_CR_FD | \
+					 SGMII_CR_SPEED_SEL1_1G)
+
+/* SGMII Device Ability for SGMII defines */
+#define MDIO_SGMII_DEV_ABIL_SGMII_MODE	0x01a1
+#define MDIO_SGMII_DEV_ABIL_BASEX_MODE	0x01A0
+
+/* SGMII IF Mode defines */
+#define IF_MODE_USE_SGMII_AN		0x0002
+#define IF_MODE_SGMII_EN		0x0001
+#define IF_MODE_SGMII_SPEED_100M	0x0004
+#define IF_MODE_SGMII_SPEED_1G		0x0008
+#define IF_MODE_SGMII_DUPLEX_HALF	0x0010
+
+#define MSCC_MIIM_REG_STATUS		0x0
+#define		MSCC_MIIM_STATUS_STAT_BUSY	BIT(3)
+#define MSCC_MIIM_REG_CMD		0x8
+#define		MSCC_MIIM_CMD_OPR_WRITE		BIT(1)
+#define		MSCC_MIIM_CMD_OPR_READ		BIT(2)
+#define		MSCC_MIIM_CMD_WRDATA_SHIFT	4
+#define		MSCC_MIIM_CMD_REGAD_SHIFT	20
+#define		MSCC_MIIM_CMD_PHYAD_SHIFT	25
+#define		MSCC_MIIM_CMD_VLD		BIT(31)
+#define MSCC_MIIM_REG_DATA		0xC
+#define		MSCC_MIIM_DATA_ERROR		(BIT(16) | BIT(17))
+
+#define MSCC_PHY_REG_PHY_CFG	0x0
+#define		PHY_CFG_PHY_ENA		(BIT(0) | BIT(1) | BIT(2) | BIT(3))
+#define		PHY_CFG_PHY_COMMON_RESET BIT(4)
+#define		PHY_CFG_PHY_RESET	(BIT(5) | BIT(6) | BIT(7) | BIT(8))
+#define MSCC_PHY_REG_PHY_STATUS	0x4
+
+static const u32 vsc9953_ana_regmap[] = {
+	REG(ANA_ADVLEARN,			0x00b500),
+	REG(ANA_VLANMASK,			0x00b504),
+	REG_RESERVED(ANA_PORT_B_DOMAIN),
+	REG(ANA_ANAGEFIL,			0x00b50c),
+	REG(ANA_ANEVENTS,			0x00b510),
+	REG(ANA_STORMLIMIT_BURST,		0x00b514),
+	REG(ANA_STORMLIMIT_CFG,			0x00b518),
+	REG(ANA_ISOLATED_PORTS,			0x00b528),
+	REG(ANA_COMMUNITY_PORTS,		0x00b52c),
+	REG(ANA_AUTOAGE,			0x00b530),
+	REG(ANA_MACTOPTIONS,			0x00b534),
+	REG(ANA_LEARNDISC,			0x00b538),
+	REG(ANA_AGENCTRL,			0x00b53c),
+	REG(ANA_MIRRORPORTS,			0x00b540),
+	REG(ANA_EMIRRORPORTS,			0x00b544),
+	REG(ANA_FLOODING,			0x00b548),
+	REG(ANA_FLOODING_IPMC,			0x00b54c),
+	REG(ANA_SFLOW_CFG,			0x00b550),
+	REG(ANA_PORT_MODE,			0x00b57c),
+	REG_RESERVED(ANA_CUT_THRU_CFG),
+	REG(ANA_PGID_PGID,			0x00b600),
+	REG(ANA_TABLES_ANMOVED,			0x00b4ac),
+	REG(ANA_TABLES_MACHDATA,		0x00b4b0),
+	REG(ANA_TABLES_MACLDATA,		0x00b4b4),
+	REG_RESERVED(ANA_TABLES_STREAMDATA),
+	REG(ANA_TABLES_MACACCESS,		0x00b4b8),
+	REG(ANA_TABLES_MACTINDX,		0x00b4bc),
+	REG(ANA_TABLES_VLANACCESS,		0x00b4c0),
+	REG(ANA_TABLES_VLANTIDX,		0x00b4c4),
+	REG_RESERVED(ANA_TABLES_ISDXACCESS),
+	REG_RESERVED(ANA_TABLES_ISDXTIDX),
+	REG(ANA_TABLES_ENTRYLIM,		0x00b480),
+	REG_RESERVED(ANA_TABLES_PTP_ID_HIGH),
+	REG_RESERVED(ANA_TABLES_PTP_ID_LOW),
+	REG_RESERVED(ANA_TABLES_STREAMACCESS),
+	REG_RESERVED(ANA_TABLES_STREAMTIDX),
+	REG_RESERVED(ANA_TABLES_SEQ_HISTORY),
+	REG_RESERVED(ANA_TABLES_SEQ_MASK),
+	REG_RESERVED(ANA_TABLES_SFID_MASK),
+	REG_RESERVED(ANA_TABLES_SFIDACCESS),
+	REG_RESERVED(ANA_TABLES_SFIDTIDX),
+	REG_RESERVED(ANA_MSTI_STATE),
+	REG_RESERVED(ANA_OAM_UPM_LM_CNT),
+	REG_RESERVED(ANA_SG_ACCESS_CTRL),
+	REG_RESERVED(ANA_SG_CONFIG_REG_1),
+	REG_RESERVED(ANA_SG_CONFIG_REG_2),
+	REG_RESERVED(ANA_SG_CONFIG_REG_3),
+	REG_RESERVED(ANA_SG_CONFIG_REG_4),
+	REG_RESERVED(ANA_SG_CONFIG_REG_5),
+	REG_RESERVED(ANA_SG_GCL_GS_CONFIG),
+	REG_RESERVED(ANA_SG_GCL_TI_CONFIG),
+	REG_RESERVED(ANA_SG_STATUS_REG_1),
+	REG_RESERVED(ANA_SG_STATUS_REG_2),
+	REG_RESERVED(ANA_SG_STATUS_REG_3),
+	REG(ANA_PORT_VLAN_CFG,			0x000000),
+	REG(ANA_PORT_DROP_CFG,			0x000004),
+	REG(ANA_PORT_QOS_CFG,			0x000008),
+	REG(ANA_PORT_VCAP_CFG,			0x00000c),
+	REG(ANA_PORT_VCAP_S1_KEY_CFG,		0x000010),
+	REG(ANA_PORT_VCAP_S2_CFG,		0x00001c),
+	REG(ANA_PORT_PCP_DEI_MAP,		0x000020),
+	REG(ANA_PORT_CPU_FWD_CFG,		0x000060),
+	REG(ANA_PORT_CPU_FWD_BPDU_CFG,		0x000064),
+	REG(ANA_PORT_CPU_FWD_GARP_CFG,		0x000068),
+	REG(ANA_PORT_CPU_FWD_CCM_CFG,		0x00006c),
+	REG(ANA_PORT_PORT_CFG,			0x000070),
+	REG(ANA_PORT_POL_CFG,			0x000074),
+	REG_RESERVED(ANA_PORT_PTP_CFG),
+	REG_RESERVED(ANA_PORT_PTP_DLY1_CFG),
+	REG_RESERVED(ANA_PORT_PTP_DLY2_CFG),
+	REG_RESERVED(ANA_PORT_SFID_CFG),
+	REG(ANA_PFC_PFC_CFG,			0x00c000),
+	REG_RESERVED(ANA_PFC_PFC_TIMER),
+	REG_RESERVED(ANA_IPT_OAM_MEP_CFG),
+	REG_RESERVED(ANA_IPT_IPT),
+	REG_RESERVED(ANA_PPT_PPT),
+	REG_RESERVED(ANA_FID_MAP_FID_MAP),
+	REG(ANA_AGGR_CFG,			0x00c600),
+	REG(ANA_CPUQ_CFG,			0x00c604),
+	REG_RESERVED(ANA_CPUQ_CFG2),
+	REG(ANA_CPUQ_8021_CFG,			0x00c60c),
+	REG(ANA_DSCP_CFG,			0x00c64c),
+	REG(ANA_DSCP_REWR_CFG,			0x00c74c),
+	REG(ANA_VCAP_RNG_TYPE_CFG,		0x00c78c),
+	REG(ANA_VCAP_RNG_VAL_CFG,		0x00c7ac),
+	REG_RESERVED(ANA_VRAP_CFG),
+	REG_RESERVED(ANA_VRAP_HDR_DATA),
+	REG_RESERVED(ANA_VRAP_HDR_MASK),
+	REG(ANA_DISCARD_CFG,			0x00c7d8),
+	REG(ANA_FID_CFG,			0x00c7dc),
+	REG(ANA_POL_PIR_CFG,			0x00a000),
+	REG(ANA_POL_CIR_CFG,			0x00a004),
+	REG(ANA_POL_MODE_CFG,			0x00a008),
+	REG(ANA_POL_PIR_STATE,			0x00a00c),
+	REG(ANA_POL_CIR_STATE,			0x00a010),
+	REG_RESERVED(ANA_POL_STATE),
+	REG(ANA_POL_FLOWC,			0x00c280),
+	REG(ANA_POL_HYST,			0x00c2ec),
+	REG_RESERVED(ANA_POL_MISC_CFG),
+};
+
+static const u32 vsc9953_qs_regmap[] = {
+	REG(QS_XTR_GRP_CFG,			0x000000),
+	REG(QS_XTR_RD,				0x000008),
+	REG(QS_XTR_FRM_PRUNING,			0x000010),
+	REG(QS_XTR_FLUSH,			0x000018),
+	REG(QS_XTR_DATA_PRESENT,		0x00001c),
+	REG(QS_XTR_CFG,				0x000020),
+	REG(QS_INJ_GRP_CFG,			0x000024),
+	REG(QS_INJ_WR,				0x00002c),
+	REG(QS_INJ_CTRL,			0x000034),
+	REG(QS_INJ_STATUS,			0x00003c),
+	REG(QS_INJ_ERR,				0x000040),
+	REG_RESERVED(QS_INH_DBG),
+};
+
+static const u32 vsc9953_s2_regmap[] = {
+	REG(S2_CORE_UPDATE_CTRL,		0x000000),
+	REG(S2_CORE_MV_CFG,			0x000004),
+	REG(S2_CACHE_ENTRY_DAT,			0x000008),
+	REG(S2_CACHE_MASK_DAT,			0x000108),
+	REG(S2_CACHE_ACTION_DAT,		0x000208),
+	REG(S2_CACHE_CNT_DAT,			0x000308),
+	REG(S2_CACHE_TG_DAT,			0x000388),
+};
+
+static const u32 vsc9953_qsys_regmap[] = {
+	REG(QSYS_PORT_MODE,			0x003600),
+	REG(QSYS_SWITCH_PORT_MODE,		0x003630),
+	REG(QSYS_STAT_CNT_CFG,			0x00365c),
+	REG(QSYS_EEE_CFG,			0x003660),
+	REG(QSYS_EEE_THRES,			0x003688),
+	REG(QSYS_IGR_NO_SHARING,		0x00368c),
+	REG(QSYS_EGR_NO_SHARING,		0x003690),
+	REG(QSYS_SW_STATUS,			0x003694),
+	REG(QSYS_EXT_CPU_CFG,			0x0036c0),
+	REG_RESERVED(QSYS_PAD_CFG),
+	REG(QSYS_CPU_GROUP_MAP,			0x0036c8),
+	REG_RESERVED(QSYS_QMAP),
+	REG_RESERVED(QSYS_ISDX_SGRP),
+	REG_RESERVED(QSYS_TIMED_FRAME_ENTRY),
+	REG_RESERVED(QSYS_TFRM_MISC),
+	REG_RESERVED(QSYS_TFRM_PORT_DLY),
+	REG_RESERVED(QSYS_TFRM_TIMER_CFG_1),
+	REG_RESERVED(QSYS_TFRM_TIMER_CFG_2),
+	REG_RESERVED(QSYS_TFRM_TIMER_CFG_3),
+	REG_RESERVED(QSYS_TFRM_TIMER_CFG_4),
+	REG_RESERVED(QSYS_TFRM_TIMER_CFG_5),
+	REG_RESERVED(QSYS_TFRM_TIMER_CFG_6),
+	REG_RESERVED(QSYS_TFRM_TIMER_CFG_7),
+	REG_RESERVED(QSYS_TFRM_TIMER_CFG_8),
+	REG(QSYS_RED_PROFILE,			0x003724),
+	REG(QSYS_RES_QOS_MODE,			0x003764),
+	REG(QSYS_RES_CFG,			0x004000),
+	REG(QSYS_RES_STAT,			0x004004),
+	REG(QSYS_EGR_DROP_MODE,			0x003768),
+	REG(QSYS_EQ_CTRL,			0x00376c),
+	REG_RESERVED(QSYS_EVENTS_CORE),
+	REG_RESERVED(QSYS_QMAXSDU_CFG_0),
+	REG_RESERVED(QSYS_QMAXSDU_CFG_1),
+	REG_RESERVED(QSYS_QMAXSDU_CFG_2),
+	REG_RESERVED(QSYS_QMAXSDU_CFG_3),
+	REG_RESERVED(QSYS_QMAXSDU_CFG_4),
+	REG_RESERVED(QSYS_QMAXSDU_CFG_5),
+	REG_RESERVED(QSYS_QMAXSDU_CFG_6),
+	REG_RESERVED(QSYS_QMAXSDU_CFG_7),
+	REG_RESERVED(QSYS_PREEMPTION_CFG),
+	REG(QSYS_CIR_CFG,			0x000000),
+	REG_RESERVED(QSYS_EIR_CFG),
+	REG(QSYS_SE_CFG,			0x000008),
+	REG(QSYS_SE_DWRR_CFG,			0x00000c),
+	REG_RESERVED(QSYS_SE_CONNECT),
+	REG_RESERVED(QSYS_SE_DLB_SENSE),
+	REG(QSYS_CIR_STATE,			0x000044),
+	REG_RESERVED(QSYS_EIR_STATE),
+	REG_RESERVED(QSYS_SE_STATE),
+	REG(QSYS_HSCH_MISC_CFG,			0x003774),
+	REG_RESERVED(QSYS_TAG_CONFIG),
+	REG_RESERVED(QSYS_TAS_PARAM_CFG_CTRL),
+	REG_RESERVED(QSYS_PORT_MAX_SDU),
+	REG_RESERVED(QSYS_PARAM_CFG_REG_1),
+	REG_RESERVED(QSYS_PARAM_CFG_REG_2),
+	REG_RESERVED(QSYS_PARAM_CFG_REG_3),
+	REG_RESERVED(QSYS_PARAM_CFG_REG_4),
+	REG_RESERVED(QSYS_PARAM_CFG_REG_5),
+	REG_RESERVED(QSYS_GCL_CFG_REG_1),
+	REG_RESERVED(QSYS_GCL_CFG_REG_2),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_1),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_2),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_3),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_4),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_5),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_6),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_7),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_8),
+	REG_RESERVED(QSYS_PARAM_STATUS_REG_9),
+	REG_RESERVED(QSYS_GCL_STATUS_REG_1),
+	REG_RESERVED(QSYS_GCL_STATUS_REG_2),
+};
+
+static const u32 vsc9953_rew_regmap[] = {
+	REG(REW_PORT_VLAN_CFG,			0x000000),
+	REG(REW_TAG_CFG,			0x000004),
+	REG(REW_PORT_CFG,			0x000008),
+	REG(REW_DSCP_CFG,			0x00000c),
+	REG(REW_PCP_DEI_QOS_MAP_CFG,		0x000010),
+	REG_RESERVED(REW_PTP_CFG),
+	REG_RESERVED(REW_PTP_DLY1_CFG),
+	REG_RESERVED(REW_RED_TAG_CFG),
+	REG(REW_DSCP_REMAP_DP1_CFG,		0x000610),
+	REG(REW_DSCP_REMAP_CFG,			0x000710),
+	REG_RESERVED(REW_STAT_CFG),
+	REG_RESERVED(REW_REW_STICKY),
+	REG_RESERVED(REW_PPT),
+};
+
+static const u32 vsc9953_sys_regmap[] = {
+	REG(SYS_COUNT_RX_OCTETS,		0x000000),
+	REG(SYS_COUNT_RX_MULTICAST,		0x000008),
+	REG(SYS_COUNT_RX_SHORTS,		0x000010),
+	REG(SYS_COUNT_RX_FRAGMENTS,		0x000014),
+	REG(SYS_COUNT_RX_JABBERS,		0x000018),
+	REG(SYS_COUNT_RX_64,			0x000024),
+	REG(SYS_COUNT_RX_65_127,		0x000028),
+	REG(SYS_COUNT_RX_128_255,		0x00002c),
+	REG(SYS_COUNT_RX_256_1023,		0x000030),
+	REG(SYS_COUNT_RX_1024_1526,		0x000034),
+	REG(SYS_COUNT_RX_1527_MAX,		0x000038),
+	REG(SYS_COUNT_RX_LONGS,			0x000048),
+	REG(SYS_COUNT_TX_OCTETS,		0x000100),
+	REG(SYS_COUNT_TX_COLLISION,		0x000110),
+	REG(SYS_COUNT_TX_DROPS,			0x000114),
+	REG(SYS_COUNT_TX_64,			0x00011c),
+	REG(SYS_COUNT_TX_65_127,		0x000120),
+	REG(SYS_COUNT_TX_128_511,		0x000124),
+	REG(SYS_COUNT_TX_512_1023,		0x000128),
+	REG(SYS_COUNT_TX_1024_1526,		0x00012c),
+	REG(SYS_COUNT_TX_1527_MAX,		0x000130),
+	REG(SYS_COUNT_TX_AGING,			0x000178),
+	REG(SYS_RESET_CFG,			0x000318),
+	REG_RESERVED(SYS_SR_ETYPE_CFG),
+	REG(SYS_VLAN_ETYPE_CFG,			0x000320),
+	REG(SYS_PORT_MODE,			0x000324),
+	REG(SYS_FRONT_PORT_MODE,		0x000354),
+	REG(SYS_FRM_AGING,			0x00037c),
+	REG(SYS_STAT_CFG,			0x000380),
+	REG_RESERVED(SYS_SW_STATUS),
+	REG_RESERVED(SYS_MISC_CFG),
+	REG_RESERVED(SYS_REW_MAC_HIGH_CFG),
+	REG_RESERVED(SYS_REW_MAC_LOW_CFG),
+	REG_RESERVED(SYS_TIMESTAMP_OFFSET),
+	REG(SYS_PAUSE_CFG,			0x00044c),
+	REG(SYS_PAUSE_TOT_CFG,			0x000478),
+	REG(SYS_ATOP,				0x00047c),
+	REG(SYS_ATOP_TOT_CFG,			0x0004a8),
+	REG(SYS_MAC_FC_CFG,			0x0004ac),
+	REG(SYS_MMGT,				0x0004d4),
+	REG_RESERVED(SYS_MMGT_FAST),
+	REG_RESERVED(SYS_EVENTS_DIF),
+	REG_RESERVED(SYS_EVENTS_CORE),
+	REG_RESERVED(SYS_CNT),
+	REG_RESERVED(SYS_PTP_STATUS),
+	REG_RESERVED(SYS_PTP_TXSTAMP),
+	REG_RESERVED(SYS_PTP_NXT),
+	REG_RESERVED(SYS_PTP_CFG),
+	REG_RESERVED(SYS_RAM_INIT),
+	REG_RESERVED(SYS_CM_ADDR),
+	REG_RESERVED(SYS_CM_DATA_WR),
+	REG_RESERVED(SYS_CM_DATA_RD),
+	REG_RESERVED(SYS_CM_OP),
+	REG_RESERVED(SYS_CM_DATA),
+};
+
+static const u32 vsc9953_gcb_regmap[] = {
+	REG(GCB_SOFT_RST,			0x000008),
+	REG(GCB_MIIM_MII_STATUS,		0x0000ac),
+	REG(GCB_MIIM_MII_CMD,			0x0000b4),
+	REG(GCB_MIIM_MII_DATA,			0x0000b8),
+};
+
+static const u32 vsc9953_dev_gmii_regmap[] = {
+	REG(DEV_CLOCK_CFG,			0x0),
+	REG(DEV_PORT_MISC,			0x4),
+	REG_RESERVED(DEV_EVENTS),
+	REG(DEV_EEE_CFG,			0xc),
+	REG_RESERVED(DEV_RX_PATH_DELAY),
+	REG_RESERVED(DEV_TX_PATH_DELAY),
+	REG_RESERVED(DEV_PTP_PREDICT_CFG),
+	REG(DEV_MAC_ENA_CFG,			0x10),
+	REG(DEV_MAC_MODE_CFG,			0x14),
+	REG(DEV_MAC_MAXLEN_CFG,			0x18),
+	REG(DEV_MAC_TAGS_CFG,			0x1c),
+	REG(DEV_MAC_ADV_CHK_CFG,		0x20),
+	REG(DEV_MAC_IFG_CFG,			0x24),
+	REG(DEV_MAC_HDX_CFG,			0x28),
+	REG_RESERVED(DEV_MAC_DBG_CFG),
+	REG(DEV_MAC_FC_MAC_LOW_CFG,		0x30),
+	REG(DEV_MAC_FC_MAC_HIGH_CFG,		0x34),
+	REG(DEV_MAC_STICKY,			0x38),
+	REG_RESERVED(PCS1G_CFG),
+	REG_RESERVED(PCS1G_MODE_CFG),
+	REG_RESERVED(PCS1G_SD_CFG),
+	REG_RESERVED(PCS1G_ANEG_CFG),
+	REG_RESERVED(PCS1G_ANEG_NP_CFG),
+	REG_RESERVED(PCS1G_LB_CFG),
+	REG_RESERVED(PCS1G_DBG_CFG),
+	REG_RESERVED(PCS1G_CDET_CFG),
+	REG_RESERVED(PCS1G_ANEG_STATUS),
+	REG_RESERVED(PCS1G_ANEG_NP_STATUS),
+	REG_RESERVED(PCS1G_LINK_STATUS),
+	REG_RESERVED(PCS1G_LINK_DOWN_CNT),
+	REG_RESERVED(PCS1G_STICKY),
+	REG_RESERVED(PCS1G_DEBUG_STATUS),
+	REG_RESERVED(PCS1G_LPI_CFG),
+	REG_RESERVED(PCS1G_LPI_WAKE_ERROR_CNT),
+	REG_RESERVED(PCS1G_LPI_STATUS),
+	REG_RESERVED(PCS1G_TSTPAT_MODE_CFG),
+	REG_RESERVED(PCS1G_TSTPAT_STATUS),
+	REG_RESERVED(DEV_PCS_FX100_CFG),
+	REG_RESERVED(DEV_PCS_FX100_STATUS),
+};
+
+static const u32 *vsc9953_regmap[] = {
+	[ANA]	= vsc9953_ana_regmap,
+	[QS]	= vsc9953_qs_regmap,
+	[QSYS]	= vsc9953_qsys_regmap,
+	[REW]	= vsc9953_rew_regmap,
+	[SYS]	= vsc9953_sys_regmap,
+	[S2]	= vsc9953_s2_regmap,
+	[GCB]	= vsc9953_gcb_regmap,
+	[DEV_GMII] = vsc9953_dev_gmii_regmap,
+};
+
+/* Addresses are relative to the device's base address */
+static const struct resource vsc9953_target_io_res[TARGET_MAX] = {
+	[ANA] = {
+		.start	= 0x0280000,
+		.end	= 0x028ffff,
+		.name	= "ana",
+	},
+	[QS] = {
+		.start	= 0x0080000,
+		.end	= 0x00800ff,
+		.name	= "qs",
+	},
+	[QSYS] = {
+		.start	= 0x0200000,
+		.end	= 0x021ffff,
+		.name	= "qsys",
+	},
+	[REW] = {
+		.start	= 0x0030000,
+		.end	= 0x003ffff,
+		.name	= "rew",
+	},
+	[SYS] = {
+		.start	= 0x0010000,
+		.end	= 0x001ffff,
+		.name	= "sys",
+	},
+	[S2] = {
+		.start	= 0x0060000,
+		.end	= 0x00603ff,
+		.name	= "s2",
+	},
+	[PTP] = {
+		.start	= 0x0090000,
+		.end	= 0x00900cb,
+		.name	= "ptp",
+	},
+	[GCB] = {
+		.start	= 0x0070000,
+		.end	= 0x00701ff,
+		.name	= "devcpu_gcb",
+	},
+};
+
+static const struct resource vsc9953_port_io_res[] = {
+	{
+		.start	= 0x0100000,
+		.end	= 0x010ffff,
+		.name	= "port0",
+	},
+	{
+		.start	= 0x0110000,
+		.end	= 0x011ffff,
+		.name	= "port1",
+	},
+	{
+		.start	= 0x0120000,
+		.end	= 0x012ffff,
+		.name	= "port2",
+	},
+	{
+		.start	= 0x0130000,
+		.end	= 0x013ffff,
+		.name	= "port3",
+	},
+	{
+		.start	= 0x0140000,
+		.end	= 0x014ffff,
+		.name	= "port4",
+	},
+	{
+		.start	= 0x0150000,
+		.end	= 0x015ffff,
+		.name	= "port5",
+	},
+	{
+		.start	= 0x0160000,
+		.end	= 0x016ffff,
+		.name	= "port6",
+	},
+	{
+		.start	= 0x0170000,
+		.end	= 0x017ffff,
+		.name	= "port7",
+	},
+	{
+		.start	= 0x0180000,
+		.end	= 0x018ffff,
+		.name	= "port8",
+	},
+	{
+		.start	= 0x0190000,
+		.end	= 0x019ffff,
+		.name	= "port9",
+	},
+};
+
+static const struct reg_field vsc9953_regfields[] = {
+	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 10, 10),
+	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 9),
+	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
+	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
+	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
+	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
+	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
+	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
+	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
+	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
+	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
+	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
+	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
+	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
+	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
+	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
+	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
+	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
+	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
+	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
+	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
+	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
+	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
+	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
+	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
+	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 16, 16),
+	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 11, 12),
+	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 10),
+	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 7, 7),
+	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 6, 6),
+	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 5, 5),
+	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 0, 0),
+	[GCB_MIIM_MII_STATUS_PENDING] = REG_FIELD(GCB_MIIM_MII_STATUS, 2, 2),
+	[GCB_MIIM_MII_STATUS_BUSY] = REG_FIELD(GCB_MIIM_MII_STATUS, 3, 3),
+	/* Replicated per number of ports (11), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 13, 13, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 11, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 4, 5, 11, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 2, 3, 11, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 11, 20, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 10, 11, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 11, 4),
+};
+
+static const struct ocelot_stat_layout vsc9953_stats_layout[] = {
+	{ .offset = 0x00,	.name = "rx_octets", },
+	{ .offset = 0x01,	.name = "rx_unicast", },
+	{ .offset = 0x02,	.name = "rx_multicast", },
+	{ .offset = 0x03,	.name = "rx_broadcast", },
+	{ .offset = 0x04,	.name = "rx_shorts", },
+	{ .offset = 0x05,	.name = "rx_fragments", },
+	{ .offset = 0x06,	.name = "rx_jabbers", },
+	{ .offset = 0x07,	.name = "rx_crc_align_errs", },
+	{ .offset = 0x08,	.name = "rx_sym_errs", },
+	{ .offset = 0x09,	.name = "rx_frames_below_65_octets", },
+	{ .offset = 0x0A,	.name = "rx_frames_65_to_127_octets", },
+	{ .offset = 0x0B,	.name = "rx_frames_128_to_255_octets", },
+	{ .offset = 0x0C,	.name = "rx_frames_256_to_511_octets", },
+	{ .offset = 0x0D,	.name = "rx_frames_512_to_1023_octets", },
+	{ .offset = 0x0E,	.name = "rx_frames_1024_to_1526_octets", },
+	{ .offset = 0x0F,	.name = "rx_frames_over_1526_octets", },
+	{ .offset = 0x10,	.name = "rx_pause", },
+	{ .offset = 0x11,	.name = "rx_control", },
+	{ .offset = 0x12,	.name = "rx_longs", },
+	{ .offset = 0x13,	.name = "rx_classified_drops", },
+	{ .offset = 0x14,	.name = "rx_red_prio_0", },
+	{ .offset = 0x15,	.name = "rx_red_prio_1", },
+	{ .offset = 0x16,	.name = "rx_red_prio_2", },
+	{ .offset = 0x17,	.name = "rx_red_prio_3", },
+	{ .offset = 0x18,	.name = "rx_red_prio_4", },
+	{ .offset = 0x19,	.name = "rx_red_prio_5", },
+	{ .offset = 0x1A,	.name = "rx_red_prio_6", },
+	{ .offset = 0x1B,	.name = "rx_red_prio_7", },
+	{ .offset = 0x1C,	.name = "rx_yellow_prio_0", },
+	{ .offset = 0x1D,	.name = "rx_yellow_prio_1", },
+	{ .offset = 0x1E,	.name = "rx_yellow_prio_2", },
+	{ .offset = 0x1F,	.name = "rx_yellow_prio_3", },
+	{ .offset = 0x20,	.name = "rx_yellow_prio_4", },
+	{ .offset = 0x21,	.name = "rx_yellow_prio_5", },
+	{ .offset = 0x22,	.name = "rx_yellow_prio_6", },
+	{ .offset = 0x23,	.name = "rx_yellow_prio_7", },
+	{ .offset = 0x24,	.name = "rx_green_prio_0", },
+	{ .offset = 0x25,	.name = "rx_green_prio_1", },
+	{ .offset = 0x26,	.name = "rx_green_prio_2", },
+	{ .offset = 0x27,	.name = "rx_green_prio_3", },
+	{ .offset = 0x28,	.name = "rx_green_prio_4", },
+	{ .offset = 0x29,	.name = "rx_green_prio_5", },
+	{ .offset = 0x2A,	.name = "rx_green_prio_6", },
+	{ .offset = 0x2B,	.name = "rx_green_prio_7", },
+	{ .offset = 0x40,	.name = "tx_octets", },
+	{ .offset = 0x41,	.name = "tx_unicast", },
+	{ .offset = 0x42,	.name = "tx_multicast", },
+	{ .offset = 0x43,	.name = "tx_broadcast", },
+	{ .offset = 0x44,	.name = "tx_collision", },
+	{ .offset = 0x45,	.name = "tx_drops", },
+	{ .offset = 0x46,	.name = "tx_pause", },
+	{ .offset = 0x47,	.name = "tx_frames_below_65_octets", },
+	{ .offset = 0x48,	.name = "tx_frames_65_to_127_octets", },
+	{ .offset = 0x49,	.name = "tx_frames_128_255_octets", },
+	{ .offset = 0x4A,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x4B,	.name = "tx_frames_512_1023_octets", },
+	{ .offset = 0x4C,	.name = "tx_frames_1024_1526_octets", },
+	{ .offset = 0x4D,	.name = "tx_frames_over_1526_octets", },
+	{ .offset = 0x4E,	.name = "tx_yellow_prio_0", },
+	{ .offset = 0x4F,	.name = "tx_yellow_prio_1", },
+	{ .offset = 0x50,	.name = "tx_yellow_prio_2", },
+	{ .offset = 0x51,	.name = "tx_yellow_prio_3", },
+	{ .offset = 0x52,	.name = "tx_yellow_prio_4", },
+	{ .offset = 0x53,	.name = "tx_yellow_prio_5", },
+	{ .offset = 0x54,	.name = "tx_yellow_prio_6", },
+	{ .offset = 0x55,	.name = "tx_yellow_prio_7", },
+	{ .offset = 0x56,	.name = "tx_green_prio_0", },
+	{ .offset = 0x57,	.name = "tx_green_prio_1", },
+	{ .offset = 0x58,	.name = "tx_green_prio_2", },
+	{ .offset = 0x59,	.name = "tx_green_prio_3", },
+	{ .offset = 0x5A,	.name = "tx_green_prio_4", },
+	{ .offset = 0x5B,	.name = "tx_green_prio_5", },
+	{ .offset = 0x5C,	.name = "tx_green_prio_6", },
+	{ .offset = 0x5D,	.name = "tx_green_prio_7", },
+	{ .offset = 0x5E,	.name = "tx_aged", },
+	{ .offset = 0x80,	.name = "drop_local", },
+	{ .offset = 0x81,	.name = "drop_tail", },
+	{ .offset = 0x82,	.name = "drop_yellow_prio_0", },
+	{ .offset = 0x83,	.name = "drop_yellow_prio_1", },
+	{ .offset = 0x84,	.name = "drop_yellow_prio_2", },
+	{ .offset = 0x85,	.name = "drop_yellow_prio_3", },
+	{ .offset = 0x86,	.name = "drop_yellow_prio_4", },
+	{ .offset = 0x87,	.name = "drop_yellow_prio_5", },
+	{ .offset = 0x88,	.name = "drop_yellow_prio_6", },
+	{ .offset = 0x89,	.name = "drop_yellow_prio_7", },
+	{ .offset = 0x8A,	.name = "drop_green_prio_0", },
+	{ .offset = 0x8B,	.name = "drop_green_prio_1", },
+	{ .offset = 0x8C,	.name = "drop_green_prio_2", },
+	{ .offset = 0x8D,	.name = "drop_green_prio_3", },
+	{ .offset = 0x8E,	.name = "drop_green_prio_4", },
+	{ .offset = 0x8F,	.name = "drop_green_prio_5", },
+	{ .offset = 0x90,	.name = "drop_green_prio_6", },
+	{ .offset = 0x91,	.name = "drop_green_prio_7", },
+};
+
+struct vcap_field vsc9953_vcap_is2_keys[] = {
+	/* Common: 41 bits */
+	[VCAP_IS2_TYPE]				= {  0,   4},
+	[VCAP_IS2_HK_FIRST]			= {  4,   1},
+	[VCAP_IS2_HK_PAG]			= {  5,   8},
+	[VCAP_IS2_HK_IGR_PORT_MASK]		= { 13,  11},
+	[VCAP_IS2_HK_RSV2]			= { 24,   1},
+	[VCAP_IS2_HK_HOST_MATCH]		= { 25,   1},
+	[VCAP_IS2_HK_L2_MC]			= { 26,   1},
+	[VCAP_IS2_HK_L2_BC]			= { 27,   1},
+	[VCAP_IS2_HK_VLAN_TAGGED]		= { 28,   1},
+	[VCAP_IS2_HK_VID]			= { 29,  12},
+	[VCAP_IS2_HK_DEI]			= { 41,   1},
+	[VCAP_IS2_HK_PCP]			= { 42,   3},
+	/* MAC_ETYPE / MAC_LLC / MAC_SNAP / OAM common */
+	[VCAP_IS2_HK_L2_DMAC]			= { 45,  48},
+	[VCAP_IS2_HK_L2_SMAC]			= { 93,  48},
+	/* MAC_ETYPE (TYPE=000) */
+	[VCAP_IS2_HK_MAC_ETYPE_ETYPE]		= {141,  16},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0]	= {157,  16},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1]	= {173,   8},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2]	= {181,   3},
+	/* MAC_LLC (TYPE=001) */
+	[VCAP_IS2_HK_MAC_LLC_L2_LLC]		= {141,  40},
+	/* MAC_SNAP (TYPE=010) */
+	[VCAP_IS2_HK_MAC_SNAP_L2_SNAP]		= {141,  40},
+	/* MAC_ARP (TYPE=011) */
+	[VCAP_IS2_HK_MAC_ARP_SMAC]		= { 45,  48},
+	[VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK]	= { 93,   1},
+	[VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK]	= { 94,   1},
+	[VCAP_IS2_HK_MAC_ARP_LEN_OK]		= { 95,   1},
+	[VCAP_IS2_HK_MAC_ARP_TARGET_MATCH]	= { 96,   1},
+	[VCAP_IS2_HK_MAC_ARP_SENDER_MATCH]	= { 97,   1},
+	[VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN]	= { 98,   1},
+	[VCAP_IS2_HK_MAC_ARP_OPCODE]		= { 99,   2},
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP]	= {101,  32},
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP]	= {133,  32},
+	[VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP]	= {165,   1},
+	/* IP4_TCP_UDP / IP4_OTHER common */
+	[VCAP_IS2_HK_IP4]			= { 45,   1},
+	[VCAP_IS2_HK_L3_FRAGMENT]		= { 46,   1},
+	[VCAP_IS2_HK_L3_FRAG_OFS_GT0]		= { 47,   1},
+	[VCAP_IS2_HK_L3_OPTIONS]		= { 48,   1},
+	[VCAP_IS2_HK_IP4_L3_TTL_GT0]		= { 49,   1},
+	[VCAP_IS2_HK_L3_TOS]			= { 50,   8},
+	[VCAP_IS2_HK_L3_IP4_DIP]		= { 58,  32},
+	[VCAP_IS2_HK_L3_IP4_SIP]		= { 90,  32},
+	[VCAP_IS2_HK_DIP_EQ_SIP]		= {122,   1},
+	/* IP4_TCP_UDP (TYPE=100) */
+	[VCAP_IS2_HK_TCP]			= {123,   1},
+	[VCAP_IS2_HK_L4_SPORT]			= {124,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {140,  16},
+	[VCAP_IS2_HK_L4_RNG]			= {156,   8},
+	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {164,   1},
+	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {165,   1},
+	[VCAP_IS2_HK_L4_URG]			= {166,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {167,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {168,   1},
+	[VCAP_IS2_HK_L4_RST]			= {169,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {170,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {171,   1},
+	/* IP4_OTHER (TYPE=101) */
+	[VCAP_IS2_HK_IP4_L3_PROTO]		= {123,   8},
+	[VCAP_IS2_HK_L3_PAYLOAD]		= {131,  56},
+	/* IP6_STD (TYPE=110) */
+	[VCAP_IS2_HK_IP6_L3_TTL_GT0]		= { 45,   1},
+	[VCAP_IS2_HK_L3_IP6_SIP]		= { 46, 128},
+	[VCAP_IS2_HK_IP6_L3_PROTO]		= {174,   8},
+};
+
+struct vcap_field vsc9953_vcap_is2_actions[] = {
+	[VCAP_IS2_ACT_HIT_ME_ONCE]		= {  0,  1},
+	[VCAP_IS2_ACT_CPU_COPY_ENA]		= {  1,  1},
+	[VCAP_IS2_ACT_CPU_QU_NUM]		= {  2,  3},
+	[VCAP_IS2_ACT_MASK_MODE]		= {  5,  2},
+	[VCAP_IS2_ACT_MIRROR_ENA]		= {  7,  1},
+	[VCAP_IS2_ACT_LRN_DIS]			= {  8,  1},
+	[VCAP_IS2_ACT_POLICE_ENA]		= {  9,  1},
+	[VCAP_IS2_ACT_POLICE_IDX]		= { 10,  8},
+	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]		= { 21,  1},
+	[VCAP_IS2_ACT_PORT_MASK]		= { 22, 10},
+	[VCAP_IS2_ACT_ACL_ID]			= { 44,  6},
+	[VCAP_IS2_ACT_HIT_CNT]			= { 50, 32},
+};
+
+static const struct vcap_props vsc9953_vcap_props[] = {
+	[VCAP_IS2] = {
+		.tg_width = 2,
+		.sw_count = 4,
+		.entry_count = VSC9953_VCAP_IS2_CNT,
+		.entry_width = VSC9953_VCAP_IS2_ENTRY_WIDTH,
+		.action_count = VSC9953_VCAP_IS2_CNT +
+				VSC9953_VCAP_PORT_CNT + 2,
+		.action_width = 101,
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 44,
+				.count = 2
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4
+			},
+		},
+		.counter_words = 4,
+		.counter_width = 32,
+	},
+};
+
+#define VSC9953_INIT_TIMEOUT			50000
+#define VSC9953_GCB_RST_SLEEP			100
+#define VSC9953_SYS_RAMINIT_SLEEP		80
+#define VCS9953_MII_TIMEOUT			10000
+
+static int vsc9953_gcb_soft_rst_status(struct ocelot *ocelot)
+{
+	int val;
+
+	ocelot_field_read(ocelot, GCB_SOFT_RST_SWC_RST, &val);
+
+	return val;
+}
+
+static int vsc9953_gcb_miim_pending_status(struct ocelot *ocelot)
+{
+	int val;
+
+	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_PENDING, &val);
+
+	return val;
+}
+
+static int vsc9953_gcb_miim_busy_status(struct ocelot *ocelot)
+{
+	int val;
+
+	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_BUSY, &val);
+
+	return val;
+}
+
+static int vsc9953_sys_ram_init_status(struct ocelot *ocelot)
+{
+	int val;
+
+	ocelot_field_read(ocelot, SYS_RESET_CFG_MEM_INIT, &val);
+
+	return val;
+}
+
+static int vsc9953_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
+{
+	struct ocelot *ocelot = bus->priv;
+	int err, cmd, val;
+
+	/* Wait while MIIM controller becomes idle */
+	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
+				 val, !val, 10, VCS9953_MII_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "MDIO write:  pending timeout\n");
+		goto out;
+	}
+
+	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
+	      (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
+	      MSCC_MIIM_CMD_OPR_WRITE;
+
+	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
+
+out:
+	return err;
+}
+
+static int vsc9953_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
+{
+	int err, cmd, val;
+	struct ocelot *ocelot = bus->priv;
+
+	/* Wait until MIIM controller becomes idle */
+	err = readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
+				 val, !val, 10, VCS9953_MII_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "MDIO read: pending timeout\n");
+		goto out;
+	}
+
+	/* Write the MIIM COMMAND register */
+	cmd = MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
+	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ;
+
+	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
+
+	/* Wait while read operation via the MIIM controller is in progress */
+	err = readx_poll_timeout(vsc9953_gcb_miim_busy_status, ocelot,
+				 val, !val, 10, VCS9953_MII_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "MDIO read: busy timeout\n");
+		goto out;
+	}
+
+	val = ocelot_read(ocelot, GCB_MIIM_MII_DATA);
+
+	err = val & 0xFFFF;
+out:
+	return err;
+}
+
+static int vsc9953_reset(struct ocelot *ocelot)
+{
+	int val, err;
+
+	/* soft-reset the switch core */
+	ocelot_field_write(ocelot, GCB_SOFT_RST_SWC_RST, 1);
+
+	err = readx_poll_timeout(vsc9953_gcb_soft_rst_status, ocelot, val, !val,
+				 VSC9953_GCB_RST_SLEEP, VSC9953_INIT_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "timeout: switch core reset\n");
+		return err;
+	}
+
+	/* initialize switch mem ~40us */
+	ocelot_field_write(ocelot, SYS_RESET_CFG_MEM_INIT, 1);
+	ocelot_field_write(ocelot, SYS_RESET_CFG_MEM_ENA, 1);
+
+	err = readx_poll_timeout(vsc9953_sys_ram_init_status, ocelot, val, !val,
+				 VSC9953_SYS_RAMINIT_SLEEP,
+				 VSC9953_INIT_TIMEOUT);
+	if (err) {
+		dev_err(ocelot->dev, "timeout: switch sram init\n");
+		return err;
+	}
+
+	/* enable switch core */
+	ocelot_field_write(ocelot, SYS_RESET_CFG_MEM_ENA, 1);
+	ocelot_field_write(ocelot, SYS_RESET_CFG_CORE_ENA, 1);
+
+	return 0;
+}
+
+static void vsc9953_pcs_init_sgmii(struct phy_device *pcs,
+				   unsigned int link_an_mode,
+				   const struct phylink_link_state *state)
+{
+	/* Interface Mode Register */
+	phy_write(pcs, MDIO_SGMII_IF_MODE,
+		  IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN);
+	/* Device Ability Register */
+	phy_write(pcs, MII_ADVERTISE, MDIO_SGMII_DEV_ABIL_SGMII_MODE);
+	/* Adjust link timer for SGMII
+	 * 1.6 ms in units of 8 ns = 2 * 10^5 = 0x30d40
+	 */
+	/* Timer Upper Register */
+	phy_write(pcs, MDIO_SGMII_LINK_TMR_H, 0x0003);
+	/* Timer Lower Register */
+	phy_write(pcs, MDIO_SGMII_LINK_TMR_L, 0x0d40);
+	/* Control Register */
+	phy_write(pcs, MII_BMCR, SGMII_CR_DEF_VAL);
+}
+
+static void vsc9953_pcs_init(struct ocelot *ocelot, int port,
+			     unsigned int link_an_mode,
+			     const struct phylink_link_state *state)
+{
+	struct seville *seville = ocelot_to_seville(ocelot);
+	struct phy_device *pcs = seville->pcs[port];
+
+	if (!pcs)
+		return;
+
+	/* The PCS does not implement the BMSR register fully, so capability
+	 * detection via genphy_read_abilities does not work. Since we can get
+	 * the PHY config word from the LPA register though, there is still
+	 * value in using the generic phy_resolve_aneg_linkmode function. So
+	 * populate the supported and advertising link modes manually here.
+	 */
+	linkmode_set_bit_array(phy_basic_ports_array,
+			       ARRAY_SIZE(phy_basic_ports_array),
+			       pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, pcs->supported);
+	if (pcs->interface == PHY_INTERFACE_MODE_2500BASEX)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+				 pcs->supported);
+	if (pcs->interface != PHY_INTERFACE_MODE_2500BASEX)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				 pcs->supported);
+	phy_advertise_supported(pcs);
+
+	switch (pcs->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		vsc9953_pcs_init_sgmii(pcs, link_an_mode, state);
+		break;
+	default:
+		dev_err(ocelot->dev, "Unsupported link mode %s\n",
+			phy_modes(pcs->interface));
+	}
+}
+
+static int vsc9953_prevalidate_phy_mode(struct ocelot *ocelot, int port,
+					phy_interface_t phy_mode)
+{
+	switch (phy_mode) {
+	case PHY_INTERFACE_MODE_INTERNAL:
+		if (port != 8 && port != 9)
+			return -ENOTSUPP;
+		return 0;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		/* Not supported on internal to-CPU ports */
+		if (port == 8 || port == 9)
+			return -ENOTSUPP;
+		return 0;
+	default:
+		return -ENOTSUPP;
+	}
+}
+
+/* Watermark encode
+ * Bit 9:   Unit; 0:1, 1:16
+ * Bit 8-0: Value to be multiplied with unit
+ */
+static u16 seville_wm_enc(u16 value)
+{
+	if (value >= BIT(9))
+		return BIT(9) | (value / 16);
+
+	return value;
+}
+
+static const struct ocelot_ops vsc9953_ops = {
+	.reset			= vsc9953_reset,
+	.wm_enc			= seville_wm_enc,
+};
+
+static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
+{
+	struct seville *seville = ocelot_to_seville(ocelot);
+	struct device *dev = ocelot->dev;
+	struct mii_bus *bus;
+	int port;
+	int rc;
+
+	seville->pcs = devm_kcalloc(dev, seville->info->num_ports,
+				  sizeof(struct phy_device *),
+				  GFP_KERNEL);
+	if (!seville->pcs) {
+		dev_err(dev, "failed to allocate array for PCS PHYs\n");
+		return -ENOMEM;
+	}
+
+	bus = devm_mdiobus_alloc(dev);
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = "VSC9953 internal MDIO bus";
+	bus->read = vsc9953_mdio_read;
+	bus->write = vsc9953_mdio_write;
+	bus->parent = dev;
+	bus->priv = ocelot;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
+
+	/* Needed in order to initialize the bus mutex lock */
+	rc = mdiobus_register(bus);
+	if (rc < 0) {
+		dev_err(dev, "failed to register MDIO bus\n");
+		return rc;
+	}
+
+	seville->imdio = bus;
+
+	for (port = 0; port < seville->info->num_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct phy_device *pcs;
+
+		pcs = get_phy_device(seville->imdio, port + 4, false);
+		if (IS_ERR(pcs))
+			continue;
+
+		pcs->interface = ocelot_port->phy_mode;
+		seville->pcs[port] = pcs;
+
+		dev_info(dev, "Found PCS at internal MDIO address %d\n",
+			 port + 4);
+	}
+
+	return 0;
+}
+
+static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
+{
+	struct seville *seville = ocelot_to_seville(ocelot);
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct phy_device *pcs = seville->pcs[port];
+
+		if (!pcs)
+			continue;
+
+		put_device(&pcs->mdio.dev);
+	}
+	mdiobus_unregister(seville->imdio);
+}
+
+struct seville_info seville_info_vsc9953 = {
+	.target_io_res		= vsc9953_target_io_res,
+	.port_io_res		= vsc9953_port_io_res,
+	.regfields		= vsc9953_regfields,
+	.map			= vsc9953_regmap,
+	.ops			= &vsc9953_ops,
+	.stats_layout		= vsc9953_stats_layout,
+	.num_stats		= ARRAY_SIZE(vsc9953_stats_layout),
+	.vcap_is2_keys		= vsc9953_vcap_is2_keys,
+	.vcap_is2_actions	= vsc9953_vcap_is2_actions,
+	.vcap			= vsc9953_vcap_props,
+	.shared_queue_sz	= 128 * 1024,
+	.num_mact_rows		= 2048,
+	.num_ports		= 10,
+	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
+	.mdio_bus_free		= vsc9953_mdio_bus_free,
+	.pcs_init		= vsc9953_pcs_init,
+	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+};
-- 
2.25.1

