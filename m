Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1341239B0
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLQWT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:19:56 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56219 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfLQWTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:19:55 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so54959wmj.5
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4gjpCRWwt5ERYRKgEjQg8RjqfD6v/izIFM0DEXTbsWI=;
        b=tI3vCrb1BnbFiyvrBsQudVEh9PRk5S6eVY5hOkIzOICcqKomFH9P3WjnqpJY6ftXNq
         3VwgyD8/xk83PheTxuPR5lChTcA0NtctMGLLRVq95V6cDh4P9wok80U3AWAdXqhDs1f5
         sycfgaL8n+LGyaBIZWC95I+pOqLoskazkWoGdBDk48GKCvFO0eWTHQpuL5fl27aiKwU2
         q15dzSyIrX1AWZqitIjF8vaVZzAP8ihfSgcoi5IWPGa0Cx0DXVlJ4jUBVwix+KdclTue
         ZOSYiMLwVmscFKso0dgfyqAkJnM4KNIEocDidecLLGHFrICQBUBOQmPxTb9TIiQaH4po
         4YFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4gjpCRWwt5ERYRKgEjQg8RjqfD6v/izIFM0DEXTbsWI=;
        b=Ydui2H4ulWoSW0YQy/ZYbhvXVs6kWPC7L9aVyyWJtzpfCmqb0iRsBJkdIthoS33qZF
         ES59RrZSYl/HJ6wve2WI9OlAUf+SzgyENELUtIfUOLVJ16IK4eFnXO013dDJnHb38VXX
         YRA0rv9CUlZ47tPKx4WKLJNanyy10UO7plkqrG8Sq12AhgmieYbL1hKMtyJZbsS14v6U
         +FL8EnuhdraTcEqPjvl3vDsmxEKYkk7lMQO/h6/+dk/ffdLrG/Mwnm7nLFbbDqITUJrH
         oukjY276+OeDnnizH/zwxUFsy2nag3SJQaUcXasTDu+Hh1durw2DffM0bg2efFE8XdBJ
         WEdA==
X-Gm-Message-State: APjAAAXCX5tX0h2XfvJLSaPak2m+pGb4qQrzKEPtxShCuzjERy6uK1/k
        gC9p36LQiInFGd8icAJmXlA=
X-Google-Smtp-Source: APXvYqwTGdQxpgjtWZMoBn7NGH/iU1h7SHwLmxSGUr2lDRB1w6eLN/PW1cfdCR6fd6C4ClFdR1VR9g==
X-Received: by 2002:a1c:48c1:: with SMTP id v184mr8250234wma.5.1576621190380;
        Tue, 17 Dec 2019 14:19:50 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id e6sm196808wru.44.2019.12.17.14.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:19:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 8/8] net: dsa: felix: Add PCS operations for PHYLINK
Date:   Wed, 18 Dec 2019 00:18:31 +0200
Message-Id: <20191217221831.10923-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217221831.10923-1-olteanv@gmail.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Layerscape SoCs traditionally expose the SerDes configuration/status for
Ethernet protocols (PCS for SGMII/XFI/USXGMII etc etc) in a register
format that is compatible with clause 22 or clause 45 (depending on
SerDes protocol). Each MAC has its own internal MDIO bus on which there
is one or more of these PCS's, responding to commands at a configurable
PHY address. The per-port internal MDIO bus (which is just for PCSs) is
totally separate and has nothing to do with the dedicated external MDIO
controller (which is just for PHYs), but the register map for the MDIO
controller is the same.

The VSC9959 (Felix) switch instantiated in the LS1028A is integrated
in hardware with the ENETC PCS of its DSA master, and reuses its MDIO
controller driver, so Felix has been made to depend on it in Kconfig.

+------------------------------------------------------------------------+
|                   +--------+ GMII (typically disabled via RCW)         |
| ENETC PCI         |  ENETC |--------------------------+                |
| Root Complex      | port 3 |-----------------------+  |                |
| Integrated        +--------+                       |  |                |
| Endpoint                                           |  |                |
|                   +--------+ 2.5G GMII             |  |                |
|                   |  ENETC |--------------+        |  |                |
|                   | port 2 |-----------+  |        |  |                |
|                   +--------+           |  |        |  |                |
|                                     +--------+  +--------+             |
|                                     |  Felix |  |  Felix |             |
|                                     | port 4 |  | port 5 |             |
|                                     +--------+  +--------+             |
|                                                                        |
| +--------+  +--------+  +--------+  +--------+  +--------+  +--------+ |
| |  ENETC |  |  ENETC |  |  Felix |  |  Felix |  |  Felix |  |  Felix | |
| | port 0 |  | port 1 |  | port 0 |  | port 1 |  | port 2 |  | port 3 | |
+------------------------------------------------------------------------+
|    ||||  SerDes |          ||||        ||||        ||||        ||||    |
| +--------+block |       +--------------------------------------------+ |
| |  ENETC |      |       |       ENETC port 2 internal MDIO bus       | |
| | port 0 |      |       |  PCS         PCS          PCS        PCS   | |
| |   PCS  |      |       |   0           1            2          3    | |
+-----------------|------------------------------------------------------+
       v          v           v           v            v          v
    SGMII/      RGMII    QSGMII/QSXGMII/4xSGMII/4x100Base-X/4x2500Base-X
   USXGMII/   (bypasses
 1000Base-X/   SerDes)
 2500Base-X

In the LS1028A SoC described above, the VSC9959 Felix switch is PF5 of
the ENETC root complex, and has 2 BARs:
- BAR 4: the switch's effective registers
- BAR 0: the MDIO controller register map lended from ENETC port 2
         (PF2), for accessing its associated PCS's.

This explanation is necessary because the patch does some renaming
"pci_bar" -> "switch_pci_bar" for clarity, which would otherwise appear
a bit obtuse.

The fact that the internal MDIO bus is "borrowed" is relevant because
the register map is found in PF5 (the switch) but it triggers an access
fault if PF2 (the ENETC DSA master) is not enabled. This is not treated
in any way (and I don't think it can be treated).

All of this is so SoC-specific, that it was contained as much as
possible in the platform-integration file felix_vsc9959.c.

We need to parse and pre-validate the device tree because of 2 reasons:
- The PHY mode (SerDes protocol) cannot change at runtime due to SoC
  design.
- There is a circular dependency in that we need to know what clause the
  PCS speaks in order to find it on the internal MDIO bus. But the
  clause of the PCS depends on what phy-mode it is configured for.

The goal of this patch is to make steps towards removing the bootloader
dependency for SGMII PCS pre-configuration, as well as to add support
for monitoring the in-band SGMII AN between the PCS and the system-side
link partner (PHY or other MAC).

In practice the bootloader dependency is not completely removed. U-Boot
pre-programs the PHY address at which each PCS can be found on the
internal MDIO bus (MDEV_PORT). This is needed because the PCS of each
port has the same out-of-reset PHY address of zero. The SerDes register
for changing MDEV_PORT is pretty deep in the SoC (outside the addresses
of the ENETC PCI BARs) and therefore inaccessible to us from here.

Felix VSC9959 and Ocelot VSC7514 are integrated very differently in
their respective SoCs, and for that reason Felix does not use the Ocelot
core library for PHYLINK. On one hand we don't want to impose the
fixed phy-mode limitation to Ocelot, and on the other hand Felix doesn't
need to force the MAC link speed the way Ocelot does, since the MAC is
connected to the PCS through a fixed GMII, and the PCS is the one who
does the rate adaptation at lower link speeds, which the MAC does not
even need to know about. In fact changing the GMII speed for Felix
irrecoverably breaks transmission through that port until a reset.

Yet another reason for wanting to convert Felix to PHYLINK is to
configure the MAC of port 5 (the one that is typically disabled, in the
setup with ENETC 2 as DSA master it doesn't support tagging so when it's
enabled it is a regular fixed-link slave port, something that DSA PHYLIB
doesn't control with .adjust_link).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig         |   1 +
 drivers/net/dsa/ocelot/felix.c         | 260 ++++++++++++++++--
 drivers/net/dsa/ocelot/felix.h         |  16 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 475 ++++++++++++++++++++++++++++++++-
 4 files changed, 735 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 0031ca814346..03794d2a7fd5 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -4,6 +4,7 @@ config NET_DSA_MSCC_FELIX
 	depends on NET_DSA && PCI
 	select MSCC_OCELOT_SWITCH
 	select NET_DSA_TAG_OCELOT
+	select FSL_ENETC_MDIO
 	help
 	  This driver supports the VSC9959 network switch, which is a member of
 	  the Vitesse / Microsemi / Microchip Ocelot family of switching cores.
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b7f92464815d..3bbe142ccfe2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2,9 +2,14 @@
 /* Copyright 2019 NXP Semiconductors
  */
 #include <uapi/linux/if_bridge.h>
+#include <soc/mscc/ocelot_qsys.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot_dev.h>
+#include <soc/mscc/ocelot_ana.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/packing.h>
 #include <linux/module.h>
+#include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/of.h>
 #include <net/dsa.h>
@@ -26,14 +31,6 @@ static int felix_set_ageing_time(struct dsa_switch *ds,
 	return 0;
 }
 
-static void felix_adjust_link(struct dsa_switch *ds, int port,
-			      struct phy_device *phydev)
-{
-	struct ocelot *ocelot = ds->priv;
-
-	ocelot_adjust_link(ocelot, port, phydev);
-}
-
 static int felix_fdb_dump(struct dsa_switch *ds, int port,
 			  dsa_fdb_dump_cb_t *cb, void *data)
 {
@@ -155,6 +152,139 @@ static void felix_port_disable(struct dsa_switch *ds, int port)
 	return ocelot_port_disable(ocelot, port);
 }
 
+static void felix_phylink_validate(struct dsa_switch *ds, int port,
+				   unsigned long *supported,
+				   struct phylink_link_state *state)
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
+	if (state->interface != PHY_INTERFACE_MODE_2500BASEX) {
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseT_Full);
+	}
+	/* The internal ports that run at 2.5G are overclocked GMII */
+	if (state->interface == PHY_INTERFACE_MODE_GMII ||
+	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
+	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
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
+static int felix_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
+					   struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->pcs_link_state)
+		felix->info->pcs_link_state(ocelot, port, state);
+
+	return 0;
+}
+
+static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
+				     unsigned int link_an_mode,
+				     const struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct felix *felix = ocelot_to_felix(ocelot);
+	u32 mac_fc_cfg;
+
+	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
+	 * reset */
+	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(state->speed),
+			   DEV_CLOCK_CFG);
+
+	/* No PFC */
+	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(state->speed),
+			 ANA_PFC_PFC_CFG, port);
+
+	/* Core: Enable port for frame transfer */
+	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
+			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
+			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
+			 QSYS_SWITCH_PORT_MODE, port);
+
+	/* Flow control */
+	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
+	if (state->pause & MLO_PAUSE_RX)
+		mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
+	if (state->pause & MLO_PAUSE_TX)
+		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
+			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
+			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
+			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
+	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
+
+	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
+
+	if (felix->info->pcs_init)
+		felix->info->pcs_init(ocelot, port, link_an_mode, state);
+}
+
+static void felix_phylink_mac_an_restart(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->pcs_an_restart)
+		felix->info->pcs_an_restart(ocelot, port);
+}
+
+static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
+					unsigned int link_an_mode,
+					phy_interface_t interface)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
+	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
+		       QSYS_SWITCH_PORT_MODE, port);
+}
+
+static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
+				      unsigned int link_an_mode,
+				      phy_interface_t interface,
+				      struct phy_device *phydev)
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
+}
+
 static void felix_get_strings(struct dsa_switch *ds, int port,
 			      u32 stringset, u8 *data)
 {
@@ -185,10 +315,76 @@ static int felix_get_ts_info(struct dsa_switch *ds, int port,
 	return ocelot_get_ts_info(ocelot, port, info);
 }
 
+static int felix_parse_ports_node(struct felix *felix,
+				  struct device_node *ports_node,
+				  phy_interface_t *port_phy_modes)
+{
+	struct ocelot *ocelot = &felix->ocelot;
+	struct device *dev = felix->ocelot.dev;
+	struct device_node *child;
+
+	for_each_child_of_node(ports_node, child) {
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
+		err = felix->info->prevalidate_phy_mode(ocelot, port, phy_mode);
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
+static int felix_parse_dt(struct felix *felix, phy_interface_t *port_phy_modes)
+{
+	struct device *dev = felix->ocelot.dev;
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
+	err = felix_parse_ports_node(felix, ports_node, port_phy_modes);
+	of_node_put(ports_node);
+
+	return err;
+}
+
 static int felix_init_structs(struct felix *felix, int num_phys_ports)
 {
 	struct ocelot *ocelot = &felix->ocelot;
-	resource_size_t base;
+	phy_interface_t *port_phy_modes;
+	resource_size_t switch_base;
 	int port, i, err;
 
 	ocelot->num_phys_ports = num_phys_ports;
@@ -203,7 +399,19 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
 	ocelot->ops		= felix->info->ops;
 
-	base = pci_resource_start(felix->pdev, felix->info->pci_bar);
+	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
+				 GFP_KERNEL);
+	if (!port_phy_modes)
+		return -ENOMEM;
+
+	err = felix_parse_dt(felix, port_phy_modes);
+	if (err) {
+		kfree(port_phy_modes);
+		return err;
+	}
+
+	switch_base = pci_resource_start(felix->pdev,
+					 felix->info->switch_pci_bar);
 
 	for (i = 0; i < TARGET_MAX; i++) {
 		struct regmap *target;
@@ -214,13 +422,14 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 		res = &felix->info->target_io_res[i];
 		res->flags = IORESOURCE_MEM;
-		res->start += base;
-		res->end += base;
+		res->start += switch_base;
+		res->end += switch_base;
 
 		target = ocelot_regmap_init(ocelot, res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
+			kfree(port_phy_modes);
 			return PTR_ERR(target);
 		}
 
@@ -230,6 +439,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	err = ocelot_regfields_init(ocelot, felix->info->regfields);
 	if (err) {
 		dev_err(ocelot->dev, "failed to init reg fields map\n");
+		kfree(port_phy_modes);
 		return err;
 	}
 
@@ -244,26 +454,37 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		if (!ocelot_port) {
 			dev_err(ocelot->dev,
 				"failed to allocate port memory\n");
+			kfree(port_phy_modes);
 			return -ENOMEM;
 		}
 
 		res = &felix->info->port_io_res[port];
 		res->flags = IORESOURCE_MEM;
-		res->start += base;
-		res->end += base;
+		res->start += switch_base;
+		res->end += switch_base;
 
 		port_regs = devm_ioremap_resource(ocelot->dev, res);
 		if (IS_ERR(port_regs)) {
 			dev_err(ocelot->dev,
 				"failed to map registers for port %d\n", port);
+			kfree(port_phy_modes);
 			return PTR_ERR(port_regs);
 		}
 
+		ocelot_port->phy_mode = port_phy_modes[port];
 		ocelot_port->ocelot = ocelot;
 		ocelot_port->regs = port_regs;
 		ocelot->ports[port] = ocelot_port;
 	}
 
+	kfree(port_phy_modes);
+
+	if (felix->info->mdio_bus_alloc) {
+		err = felix->info->mdio_bus_alloc(ocelot);
+		if (err < 0)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -299,6 +520,10 @@ static int felix_setup(struct dsa_switch *ds)
 static void felix_teardown(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->mdio_bus_free)
+		felix->info->mdio_bus_free(ocelot);
 
 	/* stop workqueue thread */
 	ocelot_deinit(ocelot);
@@ -369,7 +594,12 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.get_ethtool_stats	= felix_get_ethtool_stats,
 	.get_sset_count		= felix_get_sset_count,
 	.get_ts_info		= felix_get_ts_info,
-	.adjust_link		= felix_adjust_link,
+	.phylink_validate	= felix_phylink_validate,
+	.phylink_mac_link_state	= felix_phylink_mac_pcs_get_state,
+	.phylink_mac_config	= felix_phylink_mac_config,
+	.phylink_mac_an_restart	= felix_phylink_mac_an_restart,
+	.phylink_mac_link_down	= felix_phylink_mac_link_down,
+	.phylink_mac_link_up	= felix_phylink_mac_link_up,
 	.port_enable		= felix_port_enable,
 	.port_disable		= felix_port_disable,
 	.port_fdb_dump		= felix_fdb_dump,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 204296e51d0c..3a7580015b62 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -10,6 +10,7 @@
 struct felix_info {
 	struct resource			*target_io_res;
 	struct resource			*port_io_res;
+	struct resource			*imdio_res;
 	const struct reg_field		*regfields;
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
@@ -17,7 +18,18 @@ struct felix_info {
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 	int				num_ports;
-	int				pci_bar;
+	int				switch_pci_bar;
+	int				imdio_pci_bar;
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
 };
 
 extern struct felix_info		felix_info_vsc9959;
@@ -32,6 +44,8 @@ struct felix {
 	struct pci_dev			*pdev;
 	struct felix_info		*info;
 	struct ocelot			ocelot;
+	struct mii_bus			*imdio;
+	struct phy_device		**pcs;
 };
 
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b9758b0d18c7..42d931a21dde 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2,12 +2,33 @@
 /* Copyright 2017 Microsemi Corporation
  * Copyright 2018-2019 NXP Semiconductors
  */
+#include <linux/fsl/enetc_mdio.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 #include "felix.h"
 
+/* TODO: should find a better place for these */
+#define USXGMII_BMCR_RESET		BIT(15)
+#define USXGMII_BMCR_AN_EN		BIT(12)
+#define USXGMII_BMCR_RST_AN		BIT(9)
+#define USXGMII_BMSR_LNKS(status)	(((status) & GENMASK(2, 2)) >> 2)
+#define USXGMII_BMSR_AN_CMPL(status)	(((status) & GENMASK(5, 5)) >> 5)
+#define USXGMII_ADVERTISE_LNKS(x)	(((x) << 15) & BIT(15))
+#define USXGMII_ADVERTISE_FDX		BIT(12)
+#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
+#define USXGMII_LPA_LNKS(lpa)		((lpa) >> 15)
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
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
 	REG(ANA_VLANMASK,			0x0089a4),
@@ -386,6 +407,15 @@ static struct resource vsc9959_port_io_res[] = {
 	},
 };
 
+/* Port MAC 0 Internal MDIO bus through which the SerDes acting as an
+ * SGMII/QSGMII MAC PCS can be found.
+ */
+static struct resource vsc9959_imdio_res = {
+	.start		= 0x8030,
+	.end		= 0x8040,
+	.name		= "imdio",
+};
+
 static const struct reg_field vsc9959_regfields[] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 6, 6),
 	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 5),
@@ -565,13 +595,449 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	return 0;
 }
 
+static void vsc9959_pcs_an_restart_sgmii(struct phy_device *pcs)
+{
+	phy_set_bits(pcs, MII_BMCR, BMCR_ANRESTART);
+}
+
+static void vsc9959_pcs_an_restart_usxgmii(struct phy_device *pcs)
+{
+	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_BMCR,
+		      USXGMII_BMCR_RESET |
+		      USXGMII_BMCR_AN_EN |
+		      USXGMII_BMCR_RST_AN);
+}
+
+static void vsc9959_pcs_an_restart(struct ocelot *ocelot, int port)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct phy_device *pcs = felix->pcs[port];
+
+	if (!pcs)
+		return;
+
+	switch (pcs->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		vsc9959_pcs_an_restart_sgmii(pcs);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		vsc9959_pcs_an_restart_usxgmii(pcs);
+		break;
+	default:
+		dev_err(ocelot->dev, "Invalid PCS interface type %s\n",
+			phy_modes(pcs->interface));
+		break;
+	}
+}
+
+/* TODO: Should we enable SGMII AN only when link_an_mode == MLO_AN_INBAND?  If
+ * in MLO_AN_PHY mode, we have the option of programming directly state->speed
+ * into the PCS, which is retrieved out-of-band over MDIO. This would also have
+ * the benefit of working with SGMII fixed-links, like switches, where both
+ * link partners attempt to operate as AN masters and therefore AN never
+ * completes.
+ * But some PHY drivers like at803x explicitly check that we acknowledged the
+ * SGMII AN word sent to us, and print "803x_aneg_done: SGMII link is not ok"
+ * otherwise.
+ * The implication is that we would need to explicitly add managed =
+ * "in-band-status" to all SGMII PHY bindings, otherwise SGMII AN would be
+ * disabled by default.
+ */
+static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
+				   unsigned int link_an_mode,
+				   const struct phylink_link_state *state)
+{
+	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
+	 * for the MAC PCS in order to acknowledge the AN.
+	 */
+	phy_write(pcs, MII_ADVERTISE, ADVERTISE_SGMII | ADVERTISE_LPACK);
+
+	phy_write(pcs, ENETC_PCS_IF_MODE, ENETC_PCS_IF_MODE_SGMII_EN |
+					  ENETC_PCS_IF_MODE_USE_SGMII_AN);
+
+	/* Adjust link timer for SGMII */
+	phy_write(pcs, ENETC_PCS_LINK_TIMER1, ENETC_PCS_LINK_TIMER1_VAL);
+	phy_write(pcs, ENETC_PCS_LINK_TIMER2, ENETC_PCS_LINK_TIMER2_VAL);
+
+	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 |
+				 BMCR_FULLDPLX |
+				 BMCR_ANENABLE);
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
+ * The speed is configured at 1000 in the IF_MODE and BMCR MDIO registers
+ * because the clock frequency is actually given by a PLL configured in the
+ * Reset Configuration Word (RCW).
+ * Since there is no difference between fixed speed SGMII w/o AN and 802.3z w/o
+ * AN, we call this PHY interface type 2500Base-X. In case a PHY negotiates a
+ * lower link speed on line side, the system-side interface remains fixed at
+ * 2500 Mbps and we do rate adaptation through pause frames.
+ */
+static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
+				       unsigned int link_an_mode,
+				       const struct phylink_link_state *state)
+{
+	if (link_an_mode == MLO_AN_INBAND) {
+		phydev_err(pcs, "AN not supported on 3.125GHz SerDes lane\n");
+		return;
+	}
+
+	phy_write(pcs, ENETC_PCS_IF_MODE,
+		  ENETC_PCS_IF_MODE_SGMII_EN |
+		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
+
+	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 |
+				 BMCR_FULLDPLX |
+				 BMCR_RESET);
+}
+
+static void vsc9959_pcs_init_usxgmii(struct phy_device *pcs,
+				     unsigned int link_an_mode,
+				     const struct phylink_link_state *state)
+{
+	/* Configure device ability for the USXGMII Replicator */
+	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
+		      USXGMII_ADVERTISE_SPEED(USXGMII_SPEED_2500) |
+		      USXGMII_ADVERTISE_LNKS(1) |
+		      ADVERTISE_SGMII |
+		      ADVERTISE_LPACK |
+		      USXGMII_ADVERTISE_FDX);
+}
+
+static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
+			     unsigned int link_an_mode,
+			     const struct phylink_link_state *state)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct phy_device *pcs = felix->pcs[port];
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
+	if (pcs->interface == PHY_INTERFACE_MODE_2500BASEX ||
+	    pcs->interface == PHY_INTERFACE_MODE_USXGMII)
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
+		vsc9959_pcs_init_sgmii(pcs, link_an_mode, state);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		vsc9959_pcs_init_2500basex(pcs, link_an_mode, state);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		vsc9959_pcs_init_usxgmii(pcs, link_an_mode, state);
+		break;
+	default:
+		dev_err(ocelot->dev, "Unsupported link mode %s\n",
+			phy_modes(pcs->interface));
+	}
+}
+
+static void vsc9959_pcs_link_state_resolve(struct phy_device *pcs,
+					   struct phylink_link_state *state)
+{
+	state->an_complete = pcs->autoneg_complete;
+	state->an_enabled = pcs->autoneg;
+	state->link = pcs->link;
+	state->duplex = pcs->duplex;
+	state->speed = pcs->speed;
+	/* SGMII AN does not negotiate flow control, but that's ok,
+	 * since phylink already knows that, and does:
+	 *	link_state.pause |= pl->phy_state.pause;
+	 */
+	state->pause = MLO_PAUSE_NONE;
+
+	phydev_dbg(pcs,
+		   "mode=%s/%s/%s adv=%*pb lpa=%*pb link=%u an_enabled=%u an_complete=%u\n",
+		   phy_modes(pcs->interface),
+		   phy_speed_to_str(pcs->speed),
+		   phy_duplex_to_str(pcs->duplex),
+		   __ETHTOOL_LINK_MODE_MASK_NBITS, pcs->advertising,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS, pcs->lp_advertising,
+		   pcs->link, pcs->autoneg, pcs->autoneg_complete);
+}
+
+static void vsc9959_pcs_link_state_sgmii(struct phy_device *pcs,
+					 struct phylink_link_state *state)
+{
+	int err;
+
+	err = genphy_update_link(pcs);
+	if (err < 0)
+		return;
+
+	if (pcs->autoneg_complete) {
+		u16 lpa = phy_read(pcs, MII_LPA);
+
+		mii_lpa_to_linkmode_lpa_sgmii(pcs->lp_advertising, lpa);
+
+		phy_resolve_aneg_linkmode(pcs);
+	}
+}
+
+static void vsc9959_pcs_link_state_2500basex(struct phy_device *pcs,
+					     struct phylink_link_state *state)
+{
+	int err;
+
+	err = genphy_update_link(pcs);
+	if (err < 0)
+		return;
+
+	pcs->speed = SPEED_2500;
+	pcs->asym_pause = true;
+	pcs->pause = true;
+}
+
+static void vsc9959_pcs_link_state_usxgmii(struct phy_device *pcs,
+					   struct phylink_link_state *state)
+{
+	int status, lpa;
+
+	status = phy_read_mmd(pcs, MDIO_MMD_VEND2, MII_BMSR);
+	if (status < 0)
+		return;
+
+	pcs->autoneg = true;
+	pcs->autoneg_complete = USXGMII_BMSR_AN_CMPL(status);
+	pcs->link = USXGMII_BMSR_LNKS(status);
+
+	if (!pcs->link || !pcs->autoneg_complete)
+		return;
+
+	lpa = phy_read_mmd(pcs, MDIO_MMD_VEND2, MII_LPA);
+	if (lpa < 0)
+		return;
+
+	switch (USXGMII_LPA_SPEED(lpa)) {
+	case USXGMII_SPEED_10:
+		pcs->speed = SPEED_10;
+		break;
+	case USXGMII_SPEED_100:
+		pcs->speed = SPEED_100;
+		break;
+	case USXGMII_SPEED_1000:
+		pcs->speed = SPEED_1000;
+		break;
+	case USXGMII_SPEED_2500:
+		pcs->speed = SPEED_2500;
+		break;
+	default:
+		break;
+	}
+
+	pcs->link = USXGMII_LPA_LNKS(lpa);
+	if (USXGMII_LPA_DUPLEX(lpa))
+		pcs->duplex = DUPLEX_FULL;
+	else
+		pcs->duplex = DUPLEX_HALF;
+}
+
+static void vsc9959_pcs_link_state(struct ocelot *ocelot, int port,
+				   struct phylink_link_state *state)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct phy_device *pcs = felix->pcs[port];
+	int tries = 3;
+
+	if (!pcs)
+		return;
+
+	pcs->speed = SPEED_UNKNOWN;
+	pcs->duplex = DUPLEX_UNKNOWN;
+	pcs->pause = 0;
+	pcs->asym_pause = 0;
+
+	/* It looks like the MAC/PCS interrupt register - PM0_IEVENT (0x8040)
+	 * isn't instantiated for the Felix PF.
+	 * In-band AN may take a while to complete, so we need to poll.
+	 */
+	do {
+		switch (pcs->interface) {
+		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_QSGMII:
+			vsc9959_pcs_link_state_sgmii(pcs, state);
+			break;
+		case PHY_INTERFACE_MODE_2500BASEX:
+			vsc9959_pcs_link_state_2500basex(pcs, state);
+			break;
+		case PHY_INTERFACE_MODE_USXGMII:
+			vsc9959_pcs_link_state_usxgmii(pcs, state);
+			break;
+		default:
+			return;
+		}
+
+		if (pcs->link)
+			break;
+
+		msleep(1);
+	} while (tries--);
+
+	vsc9959_pcs_link_state_resolve(pcs, state);
+}
+
+static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
+					phy_interface_t phy_mode)
+{
+	switch (phy_mode) {
+	case PHY_INTERFACE_MODE_GMII:
+		/* Only supported on internal to-CPU ports */
+		if (port != 4 && port != 5)
+			return -ENOTSUPP;
+		return 0;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		/* Not supported on internal to-CPU ports */
+		if (port == 4 || port == 5)
+			return -ENOTSUPP;
+		return 0;
+	default:
+		return -ENOTSUPP;
+	}
+}
+
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 };
 
+static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct enetc_mdio_priv *mdio_priv;
+	struct device *dev = ocelot->dev;
+	resource_size_t imdio_base;
+	void __iomem *imdio_regs;
+	struct resource *res;
+	struct enetc_hw *hw;
+	struct mii_bus *bus;
+	int port;
+	int rc;
+
+	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
+				  sizeof(struct phy_device *),
+				  GFP_KERNEL);
+	if (!felix->pcs) {
+		dev_err(dev, "failed to allocate array for PCS PHYs\n");
+		return -ENOMEM;
+	}
+
+	imdio_base = pci_resource_start(felix->pdev,
+					felix->info->imdio_pci_bar);
+
+	res = felix->info->imdio_res;
+	res->flags = IORESOURCE_MEM;
+	res->start += imdio_base;
+	res->end += imdio_base;
+
+	imdio_regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(imdio_regs)) {
+		dev_err(dev, "failed to map internal MDIO registers\n");
+		return PTR_ERR(imdio_regs);
+	}
+
+	hw = enetc_hw_alloc(dev, imdio_regs);
+	if (IS_ERR(hw)) {
+		dev_err(dev, "failed to allocate ENETC HW structure\n");
+		return PTR_ERR(hw);
+	}
+
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = "VSC9959 internal MDIO bus";
+	bus->read = enetc_mdio_read;
+	bus->write = enetc_mdio_write;
+	bus->parent = dev;
+	mdio_priv = bus->priv;
+	mdio_priv->hw = hw;
+	/* This gets added to imdio_regs, which already maps addresses
+	 * starting with the proper offset.
+	 */
+	mdio_priv->mdio_base = 0;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
+
+	/* Needed in order to initialize the bus mutex lock */
+	rc = mdiobus_register(bus);
+	if (rc < 0) {
+		dev_err(dev, "failed to register MDIO bus\n");
+		return rc;
+	}
+
+	felix->imdio = bus;
+
+	for (port = 0; port < felix->info->num_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct phy_device *pcs;
+		bool is_c45 = false;
+
+		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_USXGMII)
+			is_c45 = true;
+
+		pcs = get_phy_device(felix->imdio, port, is_c45);
+		if (IS_ERR(pcs))
+			continue;
+
+		pcs->interface = ocelot_port->phy_mode;
+		felix->pcs[port] = pcs;
+
+		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
+	}
+
+	return 0;
+}
+
+static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct phy_device *pcs = felix->pcs[port];
+
+		if (!pcs)
+			continue;
+
+		put_device(&pcs->mdio.dev);
+	}
+	mdiobus_unregister(felix->imdio);
+}
+
 struct felix_info felix_info_vsc9959 = {
 	.target_io_res		= vsc9959_target_io_res,
 	.port_io_res		= vsc9959_port_io_res,
+	.imdio_res		= &vsc9959_imdio_res,
 	.regfields		= vsc9959_regfields,
 	.map			= vsc9959_regmap,
 	.ops			= &vsc9959_ops,
@@ -579,5 +1045,12 @@ struct felix_info felix_info_vsc9959 = {
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.shared_queue_sz	= 128 * 1024,
 	.num_ports		= 6,
-	.pci_bar		= 4,
+	.switch_pci_bar		= 4,
+	.imdio_pci_bar		= 0,
+	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
+	.mdio_bus_free		= vsc9959_mdio_bus_free,
+	.pcs_init		= vsc9959_pcs_init,
+	.pcs_an_restart		= vsc9959_pcs_an_restart,
+	.pcs_link_state		= vsc9959_pcs_link_state,
+	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 };
-- 
2.7.4

