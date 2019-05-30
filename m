Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B352F760
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 08:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfE3GJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 02:09:19 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59394 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3GJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 02:09:19 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1B73A1A0639;
        Thu, 30 May 2019 08:09:17 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0E9561A0633;
        Thu, 30 May 2019 08:09:17 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 933AD2026B;
        Thu, 30 May 2019 08:09:16 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next] net: dsa: Add error path handling in dsa_tree_setup()
Date:   Thu, 30 May 2019 09:09:07 +0300
Message-Id: <1559196547-17917-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case a call to dsa_tree_setup() fails, an attempt to cleanup is made
by calling dsa_tree_remove_switch(), which should take care of
removing/unregistering any resources previously allocated. This does not
happen because it is conditioned by dst->setup being true, which is set
only after _all_ setup steps were performed successfully.

This is especially interesting when the internal MDIO bus is registered
but afterwards, a port setup fails and the mdiobus_unregister() is never
called. This leads to a BUG_ON() complaining about the fact that it's
trying to free an MDIO bus that's still registered.

Add proper error handling in all functions branching from
dsa_tree_setup().

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
---

Sorry for sending this again but the first time I mistyped the netdev list
address.

 net/dsa/dsa2.c | 89 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 66 insertions(+), 23 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3b5f434cad3f..b70befe8a3c8 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -261,7 +261,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	enum devlink_port_flavour flavour;
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	int err;
+	int err = 0;
 
 	if (dp->type == DSA_PORT_TYPE_UNUSED)
 		return 0;
@@ -299,19 +299,15 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		err = dsa_port_link_register_of(dp);
-		if (err) {
+		if (err)
 			dev_err(ds->dev, "failed to setup link for port %d.%d\n",
 				ds->index, dp->index);
-			return err;
-		}
 		break;
 	case DSA_PORT_TYPE_DSA:
 		err = dsa_port_link_register_of(dp);
-		if (err) {
+		if (err)
 			dev_err(ds->dev, "failed to setup link for port %d.%d\n",
 				ds->index, dp->index);
-			return err;
-		}
 		break;
 	case DSA_PORT_TYPE_USER:
 		err = dsa_slave_create(dp);
@@ -323,7 +319,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	}
 
-	return 0;
+	if (err)
+		devlink_port_unregister(&dp->devlink_port);
+
+	return err;
 }
 
 static void dsa_port_teardown(struct dsa_port *dp)
@@ -351,7 +350,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
 
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
-	int err;
+	int err = 0;
 
 	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
 	 * driver and before ops->setup() has run, since the switch drivers and
@@ -369,29 +368,41 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 	err = devlink_register(ds->devlink, ds->dev);
 	if (err)
-		return err;
+		goto free_devlink;
 
 	err = dsa_switch_register_notifier(ds);
 	if (err)
-		return err;
+		goto unregister_devlink;
 
 	err = ds->ops->setup(ds);
 	if (err < 0)
-		return err;
+		goto unregister_notifier;
 
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
-		if (!ds->slave_mii_bus)
-			return -ENOMEM;
+		if (!ds->slave_mii_bus) {
+			err = -ENOMEM;
+			goto unregister_notifier;
+		}
 
 		dsa_slave_mii_bus_init(ds);
 
 		err = mdiobus_register(ds->slave_mii_bus);
 		if (err < 0)
-			return err;
+			goto unregister_notifier;
 	}
 
 	return 0;
+
+unregister_notifier:
+	dsa_switch_unregister_notifier(ds);
+unregister_devlink:
+	devlink_unregister(ds->devlink);
+free_devlink:
+	devlink_free(ds->devlink);
+	ds->devlink = NULL;
+
+	return err;
 }
 
 static void dsa_switch_teardown(struct dsa_switch *ds)
@@ -413,8 +424,8 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 {
 	struct dsa_switch *ds;
 	struct dsa_port *dp;
-	int device, port;
-	int err;
+	int device, port, i;
+	int err = 0;
 
 	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
 		ds = dst->ds[device];
@@ -423,18 +434,41 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 
 		err = dsa_switch_setup(ds);
 		if (err)
-			return err;
+			goto switch_teardown;
 
 		for (port = 0; port < ds->num_ports; port++) {
 			dp = &ds->ports[port];
 
 			err = dsa_port_setup(dp);
 			if (err)
-				return err;
+				goto ports_teardown;
 		}
 	}
 
 	return 0;
+
+ports_teardown:
+	for (i = 0; i < port; i++)
+		dsa_port_teardown(&ds->ports[i]);
+
+	dsa_switch_teardown(ds);
+
+switch_teardown:
+	for (i = 0; i < device; i++) {
+		ds = dst->ds[i];
+		if (!ds)
+			continue;
+
+		for (port = 0; port < ds->num_ports; port++) {
+			dp = &ds->ports[port];
+
+			dsa_port_teardown(dp);
+		}
+
+		dsa_switch_teardown(ds);
+	}
+
+	return err;
 }
 
 static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
@@ -496,17 +530,24 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 	err = dsa_tree_setup_switches(dst);
 	if (err)
-		return err;
+		goto teardown_default_cpu;
 
 	err = dsa_tree_setup_master(dst);
 	if (err)
-		return err;
+		goto teardown_switches;
 
 	dst->setup = true;
 
 	pr_info("DSA: tree %d setup\n", dst->index);
 
 	return 0;
+
+teardown_switches:
+	dsa_tree_teardown_switches(dst);
+teardown_default_cpu:
+	dsa_tree_teardown_default_cpu(dst);
+
+	return err;
 }
 
 static void dsa_tree_teardown(struct dsa_switch_tree *dst)
@@ -547,8 +588,10 @@ static int dsa_tree_add_switch(struct dsa_switch_tree *dst,
 	dst->ds[index] = ds;
 
 	err = dsa_tree_setup(dst);
-	if (err)
-		dsa_tree_remove_switch(dst, index);
+	if (err) {
+		dst->ds[index] = NULL;
+		dsa_tree_put(dst);
+	}
 
 	return err;
 }
-- 
2.21.0

