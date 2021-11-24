Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A7045CB67
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349873AbhKXRzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbhKXRzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:55:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8B2C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=duXHLomEjDNg78y+Mdk92Vi4EmOn6BUlBnGXhSw1tg4=; b=YbeBHmdDEFaZdqD5FaoOkjUkY5
        UC8Hh7t71R+zZdScmXS03eDmXTYUwSCEUslOHEZNEG3BuGy1l8Hs0nMJhIIy///cB6kJYUZQfofo1
        qKLmojrVJv480EPfSqZKqNtRcuugMeWe0sP2zjLfklnDIker0RDUkyavJDXkR4s1YboMokwgE6ozX
        /sIJ4iKU4cpjIpm/STR3K49tTuHCUtY2fF4ARIE9RD1rBRJ2q3qtfGMPUpZjVqk0DDZ6sURDsVEx6
        zJhDcftqlsFhEFS+/QsDc5+Sc6rIjSoIZMZhxg2zu3LXve1iVb1ONKJtdFK/L6zXTPHGWPithX5ik
        pdL3Sz+g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49514 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRY-0000w7-NH; Wed, 24 Nov 2021 17:52:28 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRY-00D8Kw-6S; Wed, 24 Nov 2021 17:52:28 +0000
In-Reply-To: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH RFC net-next 01/12] net: dsa: consolidate phylink creation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwRY-00D8Kw-6S@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:52:28 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code in port.c and slave.c creating the phylink instance is very
similar - let's consolidate this into a single function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/dsa/dsa_priv.h |  2 +-
 net/dsa/port.c     | 44 ++++++++++++++++++++++++++++----------------
 net/dsa/slave.c    | 19 +++----------------
 3 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a5c9bc7b66c6..3fb2c37c9b88 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -258,13 +258,13 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
+int dsa_port_phylink_create(struct dsa_port *dp);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
-extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
 static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
 						 const struct net_device *dev)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f6f12ad2b525..eaa66114924b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1072,7 +1072,7 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 				     speed, duplex, tx_pause, rx_pause);
 }
 
-const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
+static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.validate = dsa_port_phylink_validate,
 	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
 	.mac_config = dsa_port_phylink_mac_config,
@@ -1081,6 +1081,30 @@ const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.mac_link_up = dsa_port_phylink_mac_link_up,
 };
 
+int dsa_port_phylink_create(struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+	phy_interface_t mode;
+	int err;
+
+	err = of_get_phy_mode(dp->dn, &mode);
+	if (err)
+		mode = PHY_INTERFACE_MODE_NA;
+
+	if (ds->ops->phylink_get_interfaces)
+		ds->ops->phylink_get_interfaces(ds, dp->index,
+					dp->pl_config.supported_interfaces);
+
+	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
+				mode, &dsa_port_phylink_mac_ops);
+	if (IS_ERR(dp->pl)) {
+		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
+		return PTR_ERR(dp->pl);
+	}
+
+	return 0;
+}
+
 static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
@@ -1157,27 +1181,15 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *port_dn = dp->dn;
-	phy_interface_t mode;
 	int err;
 
-	err = of_get_phy_mode(port_dn, &mode);
-	if (err)
-		mode = PHY_INTERFACE_MODE_NA;
-
 	dp->pl_config.dev = ds->dev;
 	dp->pl_config.type = PHYLINK_DEV;
 	dp->pl_config.pcs_poll = ds->pcs_poll;
 
-	if (ds->ops->phylink_get_interfaces)
-		ds->ops->phylink_get_interfaces(ds, dp->index,
-					dp->pl_config.supported_interfaces);
-
-	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn),
-				mode, &dsa_port_phylink_mac_ops);
-	if (IS_ERR(dp->pl)) {
-		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
-		return PTR_ERR(dp->pl);
-	}
+	err = dsa_port_phylink_create(dp);
+	if (err)
+		return err;
 
 	err = phylink_of_phy_connect(dp->pl, port_dn, 0);
 	if (err && err != -ENODEV) {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad61f6bc8886..33b54eadc641 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1851,14 +1851,9 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
 	struct device_node *port_dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
-	phy_interface_t mode;
 	u32 phy_flags = 0;
 	int ret;
 
-	ret = of_get_phy_mode(port_dn, &mode);
-	if (ret)
-		mode = PHY_INTERFACE_MODE_NA;
-
 	dp->pl_config.dev = &slave_dev->dev;
 	dp->pl_config.type = PHYLINK_NETDEV;
 
@@ -1871,17 +1866,9 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		dp->pl_config.poll_fixed_state = true;
 	}
 
-	if (ds->ops->phylink_get_interfaces)
-		ds->ops->phylink_get_interfaces(ds, dp->index,
-					dp->pl_config.supported_interfaces);
-
-	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn), mode,
-				&dsa_port_phylink_mac_ops);
-	if (IS_ERR(dp->pl)) {
-		netdev_err(slave_dev,
-			   "error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
-		return PTR_ERR(dp->pl);
-	}
+	ret = dsa_port_phylink_create(dp);
+	if (ret)
+		return ret;
 
 	if (ds->ops->get_phy_flags)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
-- 
2.30.2

