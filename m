Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E562C2BBB1
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfE0VW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:22:59 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50830 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbfE0VW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:22:56 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C19B1200C5F;
        Mon, 27 May 2019 23:22:53 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AF2F8200C59;
        Mon, 27 May 2019 23:22:53 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 251012060A;
        Mon, 27 May 2019 23:22:53 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 10/11] net: dsa: Use PHYLINK for the CPU/DSA ports
Date:   Tue, 28 May 2019 00:22:06 +0300
Message-Id: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For DSA switches that do not have an .adjust_link callback, aka those
who transitioned totally to the PHYLINK-compliant API, use PHYLINK to
drive the CPU/DSA ports.

The PHYLIB usage and .adjust_link are kept but deprecated, and users are
asked to transition from it.  The reason why we can't do anything for
them is because PHYLINK does not wrap the fixed-link state behind a
phydev object, so we cannot wrap .phylink_mac_config into .adjust_link
unless we fabricate a phy_device structure.

For these ports, the newly introduced PHYLINK_DEV operation type is
used and the dsa_switch device structure is passed to PHYLINK for
printing purposes.  The handling of the PHYLINK_NETDEV and PHYLINK_DEV
PHYLINK instances is common from the perspective of the driver.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/port.c | 69 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 6 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 0051f5006248..30d5b08a5653 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -481,12 +481,15 @@ void dsa_port_phylink_mac_link_down(struct phylink_config *config,
 				    phy_interface_t interface)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct net_device *dev = dp->slave;
+	struct phy_device *phydev = NULL;
 	struct dsa_switch *ds = dp->ds;
 
+	if (dsa_is_user_port(ds, dp->index))
+		phydev = dp->slave->phydev;
+
 	if (!ds->ops->phylink_mac_link_down) {
-		if (ds->ops->adjust_link && dev->phydev)
-			ds->ops->adjust_link(ds, dp->index, dev->phydev);
+		if (ds->ops->adjust_link && phydev)
+			ds->ops->adjust_link(ds, dp->index, phydev);
 		return;
 	}
 
@@ -500,12 +503,11 @@ void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 				  struct phy_device *phydev)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
-	struct net_device *dev = dp->slave;
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_link_up) {
-		if (ds->ops->adjust_link && dev->phydev)
-			ds->ops->adjust_link(ds, dp->index, dev->phydev);
+		if (ds->ops->adjust_link && phydev)
+			ds->ops->adjust_link(ds, dp->index, phydev);
 		return;
 	}
 
@@ -599,8 +601,53 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 	return 0;
 }
 
+int dsa_port_phylink_register(struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct device_node *port_dn = dp->dn;
+	int mode, err;
+
+	mode = of_get_phy_mode(port_dn);
+	if (mode < 0)
+		mode = PHY_INTERFACE_MODE_NA;
+
+	dp->pl_config.dev = ds->dev;
+	dp->pl_config.type = PHYLINK_DEV;
+
+	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn),
+				mode, &dsa_port_phylink_mac_ops);
+	if (IS_ERR(dp->pl)) {
+		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
+		return PTR_ERR(dp->pl);
+	}
+
+	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
+	if (err) {
+		pr_err("could not attach to PHY: %d\n", err);
+		goto err_phy_connect;
+	}
+
+	rtnl_lock();
+	phylink_start(dp->pl);
+	rtnl_unlock();
+
+	return 0;
+
+err_phy_connect:
+	phylink_destroy(dp->pl);
+	return err;
+}
+
 int dsa_port_link_register_of(struct dsa_port *dp)
 {
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->adjust_link)
+		return dsa_port_phylink_register(dp);
+
+	dev_warn(ds->dev,
+		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
+
 	if (of_phy_is_fixed_link(dp->dn))
 		return dsa_port_fixed_link_register_of(dp);
 	else
@@ -609,6 +656,16 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 
 void dsa_port_link_unregister_of(struct dsa_port *dp)
 {
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->adjust_link) {
+		rtnl_lock();
+		phylink_disconnect_phy(dp->pl);
+		rtnl_unlock();
+		phylink_destroy(dp->pl);
+		return;
+	}
+
 	if (of_phy_is_fixed_link(dp->dn))
 		of_phy_deregister_fixed_link(dp->dn);
 	else
-- 
2.21.0

