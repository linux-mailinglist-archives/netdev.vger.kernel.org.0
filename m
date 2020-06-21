Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E76202D8F
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 00:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgFUW4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 18:56:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36628 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbgFUW4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 18:56:05 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 882D81A08CA;
        Mon, 22 Jun 2020 00:56:02 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7B4CA1A08C9;
        Mon, 22 Jun 2020 00:56:02 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0B31820414;
        Mon, 22 Jun 2020 00:56:02 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 8/9] net: dsa: felix: use resolved link config in mac_link_up()
Date:   Mon, 22 Jun 2020 01:54:50 +0300
Message-Id: <20200621225451.12435-9-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621225451.12435-1-ioana.ciornei@nxp.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

PHYLINK now requires that parameters established through
auto-negotiation be written into the MAC at the time of the
mac_link_up() callback. In the case of felix, that means taking the port
out of reset, setting the correct timers for PAUSE frames, and
enabling/disabling TX flow control.

Note that this appears to be one of those cases where git fails
spectacularly: in the diff, it doesn't appear that code is moving from
felix_phylink_mac_config to felix_phylink_mac_link_up. Instead, it
appears as if code was moving _around_ it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v3:
 * patch added

 drivers/net/dsa/ocelot/felix.c | 83 +++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 98ae8421ef7f..f6a7e0839bb5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -208,6 +208,41 @@ static int felix_phylink_mac_pcs_get_state(struct dsa_switch *ds, int port,
 static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 				     unsigned int link_an_mode,
 				     const struct phylink_link_state *state)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
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
+				      struct phy_device *phydev,
+				      int speed, int duplex,
+				      bool tx_pause, bool rx_pause)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -225,7 +260,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
 			   DEV_CLOCK_CFG);
 
-	switch (state->speed) {
+	switch (speed) {
 	case SPEED_10:
 		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
 		break;
@@ -241,7 +276,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	default:
 		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
-			port, state->speed);
+			port, speed);
 		return;
 	}
 
@@ -250,7 +285,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	 */
 	mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
 
-	if (state->pause & MLO_PAUSE_TX)
+	if (tx_pause)
 		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
 			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
 			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
@@ -263,45 +298,6 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 
-	if (felix->info->pcs_init)
-		felix->info->pcs_init(ocelot, port, link_an_mode, state);
-
-	if (felix->info->port_sched_speed_set)
-		felix->info->port_sched_speed_set(ocelot, port,
-						  state->speed);
-}
-
-static void felix_phylink_mac_an_restart(struct dsa_switch *ds, int port)
-{
-	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
-
-	if (felix->info->pcs_an_restart)
-		felix->info->pcs_an_restart(ocelot, port);
-}
-
-static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
-					unsigned int link_an_mode,
-					phy_interface_t interface)
-{
-	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
-	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
-		       QSYS_SWITCH_PORT_MODE, port);
-}
-
-static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
-				      unsigned int link_an_mode,
-				      phy_interface_t interface,
-				      struct phy_device *phydev,
-				      int speed, int duplex,
-				      bool tx_pause, bool rx_pause)
-{
-	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
 	/* Enable MAC module */
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
@@ -319,6 +315,9 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
 			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
 			 QSYS_SWITCH_PORT_MODE, port);
+
+	if (felix->info->port_sched_speed_set)
+		felix->info->port_sched_speed_set(ocelot, port, speed);
 }
 
 static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
-- 
2.25.1

