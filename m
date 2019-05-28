Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61862CDCB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfE1Rk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:40:56 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60312 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbfE1Rkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 13:40:55 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3F9161A0FB3;
        Tue, 28 May 2019 19:40:53 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 316EC1A0FAE;
        Tue, 28 May 2019 19:40:53 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8ABA6205F4;
        Tue, 28 May 2019 19:40:52 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 09/11] net: dsa: Move the phylink driver calls into port.c
Date:   Tue, 28 May 2019 20:38:15 +0300
Message-Id: <1559065097-31832-10-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
References: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to have a common handling of PHYLINK for the slave and non-user
ports, the DSA core glue logic (between PHYLINK and the driver) must use
an API that does not rely on a struct net_device.

These will also be called by the CPU-port-handling code in a further
patch.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
 - none

 net/dsa/dsa_priv.h |  17 +++++++++
 net/dsa/port.c     | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c    |  96 +-------------------------------------------------
 3 files changed, 118 insertions(+), 95 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8f1222324646..418490bda3a4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -163,6 +163,23 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
+void dsa_port_phylink_validate(struct phylink_config *config,
+			       unsigned long *supported,
+			       struct phylink_link_state *state);
+int dsa_port_phylink_mac_link_state(struct phylink_config *config,
+				    struct phylink_link_state *state);
+void dsa_port_phylink_mac_config(struct phylink_config *config,
+				 unsigned int mode,
+				 const struct phylink_link_state *state);
+void dsa_port_phylink_mac_an_restart(struct phylink_config *config);
+void dsa_port_phylink_mac_link_down(struct phylink_config *config,
+				    unsigned int mode,
+				    phy_interface_t interface);
+void dsa_port_phylink_mac_link_up(struct phylink_config *config,
+				  unsigned int mode,
+				  phy_interface_t interface,
+				  struct phy_device *phydev);
+extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ed8ba9daa3ba..0051f5006248 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -422,6 +422,106 @@ static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
 	return phydev;
 }
 
+void dsa_port_phylink_validate(struct phylink_config *config,
+			       unsigned long *supported,
+			       struct phylink_link_state *state)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->phylink_validate)
+		return;
+
+	ds->ops->phylink_validate(ds, dp->index, supported, state);
+}
+EXPORT_SYMBOL_GPL(dsa_port_phylink_validate);
+
+int dsa_port_phylink_mac_link_state(struct phylink_config *config,
+				    struct phylink_link_state *state)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+
+	/* Only called for SGMII and 802.3z */
+	if (!ds->ops->phylink_mac_link_state)
+		return -EOPNOTSUPP;
+
+	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
+}
+EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_state);
+
+void dsa_port_phylink_mac_config(struct phylink_config *config,
+				 unsigned int mode,
+				 const struct phylink_link_state *state)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->phylink_mac_config)
+		return;
+
+	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
+}
+EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_config);
+
+void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->phylink_mac_an_restart)
+		return;
+
+	ds->ops->phylink_mac_an_restart(ds, dp->index);
+}
+EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_an_restart);
+
+void dsa_port_phylink_mac_link_down(struct phylink_config *config,
+				    unsigned int mode,
+				    phy_interface_t interface)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct net_device *dev = dp->slave;
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->phylink_mac_link_down) {
+		if (ds->ops->adjust_link && dev->phydev)
+			ds->ops->adjust_link(ds, dp->index, dev->phydev);
+		return;
+	}
+
+	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
+}
+EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_down);
+
+void dsa_port_phylink_mac_link_up(struct phylink_config *config,
+				  unsigned int mode,
+				  phy_interface_t interface,
+				  struct phy_device *phydev)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct net_device *dev = dp->slave;
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->phylink_mac_link_up) {
+		if (ds->ops->adjust_link && dev->phydev)
+			ds->ops->adjust_link(ds, dp->index, dev->phydev);
+		return;
+	}
+
+	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
+}
+EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_up);
+
+const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
+	.validate = dsa_port_phylink_validate,
+	.mac_link_state = dsa_port_phylink_mac_link_state,
+	.mac_config = dsa_port_phylink_mac_config,
+	.mac_an_restart = dsa_port_phylink_mac_an_restart,
+	.mac_link_down = dsa_port_phylink_mac_link_down,
+	.mac_link_up = dsa_port_phylink_mac_link_up,
+};
+
 static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 48e017637d4f..1e2ae9d59b88 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1164,100 +1164,6 @@ static struct devlink_port *dsa_slave_get_devlink_port(struct net_device *dev)
 	.name	= "dsa",
 };
 
-static void dsa_slave_phylink_validate(struct phylink_config *config,
-				       unsigned long *supported,
-				       struct phylink_link_state *state)
-{
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->phylink_validate)
-		return;
-
-	ds->ops->phylink_validate(ds, dp->index, supported, state);
-}
-
-static int dsa_slave_phylink_mac_link_state(struct phylink_config *config,
-					    struct phylink_link_state *state)
-{
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct dsa_switch *ds = dp->ds;
-
-	/* Only called for SGMII and 802.3z */
-	if (!ds->ops->phylink_mac_link_state)
-		return -EOPNOTSUPP;
-
-	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
-}
-
-static void dsa_slave_phylink_mac_config(struct phylink_config *config,
-					 unsigned int mode,
-					 const struct phylink_link_state *state)
-{
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->phylink_mac_config)
-		return;
-
-	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
-}
-
-static void dsa_slave_phylink_mac_an_restart(struct phylink_config *config)
-{
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->phylink_mac_an_restart)
-		return;
-
-	ds->ops->phylink_mac_an_restart(ds, dp->index);
-}
-
-static void dsa_slave_phylink_mac_link_down(struct phylink_config *config,
-					    unsigned int mode,
-					    phy_interface_t interface)
-{
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct net_device *dev = dp->slave;
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->phylink_mac_link_down) {
-		if (ds->ops->adjust_link && dev->phydev)
-			ds->ops->adjust_link(ds, dp->index, dev->phydev);
-		return;
-	}
-
-	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
-}
-
-static void dsa_slave_phylink_mac_link_up(struct phylink_config *config,
-					  unsigned int mode,
-					  phy_interface_t interface,
-					  struct phy_device *phydev)
-{
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct net_device *dev = dp->slave;
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->phylink_mac_link_up) {
-		if (ds->ops->adjust_link && dev->phydev)
-			ds->ops->adjust_link(ds, dp->index, dev->phydev);
-		return;
-	}
-
-	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
-}
-
-static const struct phylink_mac_ops dsa_slave_phylink_mac_ops = {
-	.validate = dsa_slave_phylink_validate,
-	.mac_link_state = dsa_slave_phylink_mac_link_state,
-	.mac_config = dsa_slave_phylink_mac_config,
-	.mac_an_restart = dsa_slave_phylink_mac_an_restart,
-	.mac_link_down = dsa_slave_phylink_mac_link_down,
-	.mac_link_up = dsa_slave_phylink_mac_link_up,
-};
-
 void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up)
 {
 	const struct dsa_port *dp = dsa_to_port(ds, port);
@@ -1309,7 +1215,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	dp->pl_config.type = PHYLINK_NETDEV;
 
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn), mode,
-				&dsa_slave_phylink_mac_ops);
+				&dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
 		netdev_err(slave_dev,
 			   "error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
-- 
1.9.1

