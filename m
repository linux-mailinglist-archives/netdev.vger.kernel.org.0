Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4F41B6036
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgDWQDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729589AbgDWQDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:03:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA906C09B040
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 09:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SHtVf61IKa5rAHsf3RzOSoJtosYs/GQi8cfKMpg6ZsM=; b=MIuWVgsDOXt/ioBWWXJsykRWYV
        xcCuwUgG+q9v44ORqiOgiGVu5hAuq1NOKRYZvmD/rW6YZo3fMrUVMRYd6RfPZk1JWAfAgahyzka5a
        2oRdZpfBjj4YjOmNK2K4Pm5qt2q6t5Gj3P+oSe3b+0hNZwpvILPBmUKs0cDLPx73ZWZanONCXcj/D
        BX+4RtcrYaF90oXhRCAqqjQqLuzVmXGs547hLChB00tlJIhUKKWtBSnt76VoY37tfzQPQh9iFiryC
        QCCoJJwegBV/BjnoRv0yZ5WP4pvJjSPjfOhlvaNp/ow/fBdGy3+ExbAjkMJvn4W0X7y6eGRHzddoa
        e8CACKSQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58794 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jReJV-0007JT-8x; Thu, 23 Apr 2020 17:02:57 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jReJU-0008Mi-N1; Thu, 23 Apr 2020 17:02:56 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink, dsa: eliminate
 phylink_fixed_state_cb()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jReJU-0008Mi-N1@rmk-PC.armlinux.org.uk>
Date:   Thu, 23 Apr 2020 17:02:56 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the callback into the phylink_config structure, rather than
providing a callback to set this up.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 46 +++++++++++++--------------------------
 include/linux/phylink.h   |  6 ++---
 net/dsa/slave.c           | 20 +++++++++--------
 3 files changed, 29 insertions(+), 43 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 34ca12aec61b..0f23bec431c1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -480,8 +480,8 @@ static void phylink_get_fixed_state(struct phylink *pl,
 				    struct phylink_link_state *state)
 {
 	*state = pl->link_config;
-	if (pl->get_fixed_state)
-		pl->get_fixed_state(pl->netdev, state);
+	if (pl->config->get_fixed_state)
+		pl->config->get_fixed_state(pl->config, state);
 	else if (pl->link_gpio)
 		state->link = !!gpiod_get_value_cansleep(pl->link_gpio);
 
@@ -1044,32 +1044,6 @@ void phylink_disconnect_phy(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_disconnect_phy);
 
-/**
- * phylink_fixed_state_cb() - allow setting a fixed link callback
- * @pl: a pointer to a &struct phylink returned from phylink_create()
- * @cb: callback to execute to determine the fixed link state.
- *
- * The MAC driver should call this driver when the state of its link
- * can be determined through e.g: an out of band MMIO register.
- */
-int phylink_fixed_state_cb(struct phylink *pl,
-			   void (*cb)(struct net_device *dev,
-				      struct phylink_link_state *state))
-{
-	/* It does not make sense to let the link be overriden unless we use
-	 * MLO_AN_FIXED
-	 */
-	if (pl->cfg_link_an_mode != MLO_AN_FIXED)
-		return -EINVAL;
-
-	mutex_lock(&pl->state_mutex);
-	pl->get_fixed_state = cb;
-	mutex_unlock(&pl->state_mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(phylink_fixed_state_cb);
-
 /**
  * phylink_mac_change() - notify phylink of a change in MAC state
  * @pl: a pointer to a &struct phylink returned from phylink_create()
@@ -1106,6 +1080,8 @@ static irqreturn_t phylink_link_handler(int irq, void *data)
  */
 void phylink_start(struct phylink *pl)
 {
+	bool poll = false;
+
 	ASSERT_RTNL();
 
 	phylink_info(pl, "configuring for %s/%s link mode\n",
@@ -1142,10 +1118,18 @@ void phylink_start(struct phylink *pl)
 				irq = 0;
 		}
 		if (irq <= 0)
-			mod_timer(&pl->link_poll, jiffies + HZ);
+			poll = true;
+	}
+
+	switch (pl->cfg_link_an_mode) {
+	case MLO_AN_FIXED:
+		poll |= pl->config->poll_fixed_state;
+		break;
+	case MLO_AN_INBAND:
+		poll |= pl->config->pcs_poll;
+		break;
 	}
-	if ((pl->cfg_link_an_mode == MLO_AN_FIXED && pl->get_fixed_state) ||
-	    pl->config->pcs_poll)
+	if (poll)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 	if (pl->phydev)
 		phy_start(pl->phydev);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 3f8d37ec5503..cc5b452a184e 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -67,6 +67,9 @@ struct phylink_config {
 	struct device *dev;
 	enum phylink_op_type type;
 	bool pcs_poll;
+	bool poll_fixed_state;
+	void (*get_fixed_state)(struct phylink_config *config,
+				struct phylink_link_state *state);
 };
 
 /**
@@ -366,9 +369,6 @@ void phylink_destroy(struct phylink *);
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
 void phylink_disconnect_phy(struct phylink *);
-int phylink_fixed_state_cb(struct phylink *,
-			   void (*cb)(struct net_device *dev,
-				      struct phylink_link_state *));
 
 void phylink_mac_change(struct phylink *, bool up);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e94eb1aac602..cdb086af3b49 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1590,10 +1590,10 @@ void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up)
 }
 EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_change);
 
-static void dsa_slave_phylink_fixed_state(struct net_device *dev,
+static void dsa_slave_phylink_fixed_state(struct phylink_config *config,
 					  struct phylink_link_state *state)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
 
 	/* No need to check that this operation is valid, the callback would
@@ -1633,6 +1633,15 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	dp->pl_config.dev = &slave_dev->dev;
 	dp->pl_config.type = PHYLINK_NETDEV;
 
+	/* The get_fixed_state callback takes precedence over polling the
+	 * link GPIO in PHYLINK (see phylink_get_fixed_state).  Only set
+	 * this if the switch provides such a callback.
+	 */
+	if (ds->ops->phylink_fixed_state) {
+		dp->pl_config.get_fixed_state = dsa_slave_phylink_fixed_state;
+		dp->pl_config.poll_fixed_state = true;
+	}
+
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn), mode,
 				&dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
@@ -1641,13 +1650,6 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		return PTR_ERR(dp->pl);
 	}
 
-	/* Register only if the switch provides such a callback, since this
-	 * callback takes precedence over polling the link GPIO in PHYLINK
-	 * (see phylink_get_fixed_state).
-	 */
-	if (ds->ops->phylink_fixed_state)
-		phylink_fixed_state_cb(dp->pl, dsa_slave_phylink_fixed_state);
-
 	if (ds->ops->get_phy_flags)
 		phy_flags = ds->ops->get_phy_flags(ds, dp->index);
 
-- 
2.20.1

