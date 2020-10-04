Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC80282BAF
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgJDQNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:13:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgJDQNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 12:13:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kP6dJ-0003eR-8M; Sun, 04 Oct 2020 18:13:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 3/7] net: dsa: Register devlink ports before calling DSA driver setup()
Date:   Sun,  4 Oct 2020 18:12:53 +0200
Message-Id: <20201004161257.13945-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201004161257.13945-1-andrew@lunn.ch>
References: <20201004161257.13945-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA drivers want to create regions on devlink ports as well as the
devlink device instance, in order to export registers and other tables
per port. To keep all this code together in the drivers, have the
devlink ports registered early, so the setup() method can setup both
device and port devlink regions.

v3:
Remove dp->setup
Move common code out of switch statement.
Fix wrong goto

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h |   1 +
 net/dsa/dsa2.c    | 125 ++++++++++++++++++++++++++--------------------
 2 files changed, 73 insertions(+), 53 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8b0696e08cac..049140b2f593 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -215,6 +215,7 @@ struct dsa_port {
 	u8			stp_state;
 	struct net_device	*bridge_dev;
 	struct devlink_port	devlink_port;
+	bool			devlink_port_setup;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 2c149fb36928..183003e45762 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -251,47 +251,19 @@ static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
 
 static int dsa_port_setup(struct dsa_port *dp)
 {
-	struct dsa_switch *ds = dp->ds;
-	struct dsa_switch_tree *dst = ds->dst;
-	const unsigned char *id = (const unsigned char *)&dst->index;
-	const unsigned char len = sizeof(dst->index);
 	struct devlink_port *dlp = &dp->devlink_port;
 	bool dsa_port_link_registered = false;
-	bool devlink_port_registered = false;
-	struct devlink_port_attrs attrs = {};
-	struct devlink *dl = ds->devlink;
 	bool dsa_port_enabled = false;
 	int err = 0;
 
-	attrs.phys.port_number = dp->index;
-	memcpy(attrs.switch_id.id, id, len);
-	attrs.switch_id.id_len = len;
-
 	if (dp->setup)
 		return 0;
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
-		memset(dlp, 0, sizeof(*dlp));
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
-		devlink_port_attrs_set(dlp, &attrs);
-		err = devlink_port_register(dl, dlp, dp->index);
-		if (err)
-			break;
-
-		devlink_port_registered = true;
-
 		dsa_port_disable(dp);
 		break;
 	case DSA_PORT_TYPE_CPU:
-		memset(dlp, 0, sizeof(*dlp));
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
-		devlink_port_attrs_set(dlp, &attrs);
-		err = devlink_port_register(dl, dlp, dp->index);
-		if (err)
-			break;
-		devlink_port_registered = true;
-
 		err = dsa_port_link_register_of(dp);
 		if (err)
 			break;
@@ -304,14 +276,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_DSA:
-		memset(dlp, 0, sizeof(*dlp));
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
-		devlink_port_attrs_set(dlp, &attrs);
-		err = devlink_port_register(dl, dlp, dp->index);
-		if (err)
-			break;
-		devlink_port_registered = true;
-
 		err = dsa_port_link_register_of(dp);
 		if (err)
 			break;
@@ -324,14 +288,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_USER:
-		memset(dlp, 0, sizeof(*dlp));
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		devlink_port_attrs_set(dlp, &attrs);
-		err = devlink_port_register(dl, dlp, dp->index);
-		if (err)
-			break;
-		devlink_port_registered = true;
-
 		dp->mac = of_get_mac_address(dp->dn);
 		err = dsa_slave_create(dp);
 		if (err)
@@ -345,8 +301,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
 		dsa_port_link_unregister_of(dp);
-	if (err && devlink_port_registered)
-		devlink_port_unregister(dlp);
 	if (err)
 		return err;
 
@@ -355,30 +309,66 @@ static int dsa_port_setup(struct dsa_port *dp)
 	return 0;
 }
 
-static void dsa_port_teardown(struct dsa_port *dp)
+static int dsa_port_devlink_setup(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch_tree *dst = dp->ds->dst;
+	struct devlink_port_attrs attrs = {};
+	struct devlink *dl = dp->ds->devlink;
+	const unsigned char *id;
+	unsigned char len;
+	int err;
 
+	id = (const unsigned char *)&dst->index;
+	len = sizeof(dst->index);
+
+	attrs.phys.port_number = dp->index;
+	memcpy(attrs.switch_id.id, id, len);
+	attrs.switch_id.id_len = len;
+	memset(dlp, 0, sizeof(*dlp));
+
+	switch (dp->type) {
+	case DSA_PORT_TYPE_UNUSED:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
+		break;
+	case DSA_PORT_TYPE_CPU:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
+		break;
+	case DSA_PORT_TYPE_DSA:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
+		break;
+	case DSA_PORT_TYPE_USER:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		break;
+	}
+
+	devlink_port_attrs_set(dlp, &attrs);
+	err = devlink_port_register(dl, dlp, dp->index);
+
+	if (!err)
+		dp->devlink_port_setup = true;
+
+	return err;
+}
+
+static void dsa_port_teardown(struct dsa_port *dp)
+{
 	if (!dp->setup)
 		return;
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
-		devlink_port_unregister(dlp);
 		break;
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
 		dsa_tag_driver_put(dp->tag_ops);
-		devlink_port_unregister(dlp);
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
 		dsa_port_disable(dp);
-		devlink_port_unregister(dlp);
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
-		devlink_port_unregister(dlp);
 		if (dp->slave) {
 			dsa_slave_destroy(dp->slave);
 			dp->slave = NULL;
@@ -389,6 +379,15 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	dp->setup = false;
 }
 
+static void dsa_port_devlink_teardown(struct dsa_port *dp)
+{
+	struct devlink_port *dlp = &dp->devlink_port;
+
+	if (dp->devlink_port_setup)
+		devlink_port_unregister(dlp);
+	dp->devlink_port_setup = false;
+}
+
 static int dsa_devlink_info_get(struct devlink *dl,
 				struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
@@ -408,6 +407,7 @@ static const struct devlink_ops dsa_devlink_ops = {
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
+	struct dsa_port *dp;
 	int err;
 
 	if (ds->setup)
@@ -433,9 +433,20 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err)
 		goto free_devlink;
 
+	/* Setup devlink port instances now, so that the switch
+	 * setup() can register regions etc, against the ports
+	 */
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if (dp->ds == ds) {
+			err = dsa_port_devlink_setup(dp);
+			if (err)
+				goto unregister_devlink_ports;
+		}
+	}
+
 	err = dsa_switch_register_notifier(ds);
 	if (err)
-		goto unregister_devlink;
+		goto unregister_devlink_ports;
 
 	err = ds->ops->setup(ds);
 	if (err < 0)
@@ -463,7 +474,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 unregister_notifier:
 	dsa_switch_unregister_notifier(ds);
-unregister_devlink:
+unregister_devlink_ports:
+	list_for_each_entry(dp, &ds->dst->ports, list)
+		if (dp->ds == ds)
+			dsa_port_devlink_teardown(dp);
 	devlink_unregister(ds->devlink);
 free_devlink:
 	devlink_free(ds->devlink);
@@ -474,6 +488,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 static void dsa_switch_teardown(struct dsa_switch *ds)
 {
+	struct dsa_port *dp;
+
 	if (!ds->setup)
 		return;
 
@@ -486,6 +502,9 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 		ds->ops->teardown(ds);
 
 	if (ds->devlink) {
+		list_for_each_entry(dp, &ds->dst->ports, list)
+			if (dp->ds == ds)
+				dsa_port_devlink_teardown(dp);
 		devlink_unregister(ds->devlink);
 		devlink_free(ds->devlink);
 		ds->devlink = NULL;
-- 
2.28.0

