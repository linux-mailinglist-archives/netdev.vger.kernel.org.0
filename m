Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC8B20F73E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389012AbgF3O3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbgF3O3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:29:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E282C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1cIE79Iq64qMgBDPAe4iyWDvDYvejT7NlrJ/AhRlvJU=; b=LklJ+CjDtkWTIol1r5Z5oWBxmk
        MJ6yeNb57mNoixzUbaVTIfWXkXUjBt0zAE49FPZX5Q+VokUFNw7p3bFiJLATghcSXsIlXWczKH8sQ
        xe+F0EqO8oCoQrMXefnDJR0xGFqjhgh5bUu3EYzBouvSsj6etj2ZsGxzSnvZTTWioSy4jMy5YamVi
        th1tQ7cShsdSOMfR8QuwOergdH9SpAZIly7u935PGyeiECUR6SxLU8rwQ7ElzcqqnfLsMyWEb4mWi
        vf4YtQZcKixbkarkG5H53ZDUXNBxyWiAKmpqplmSSI2ScBD4BQ/yrmxSDYXBQtUBuIfqsRVo6inXT
        xse9XEug==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47280 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHGJ-0000fr-Kz; Tue, 30 Jun 2020 15:29:27 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHGJ-0006QA-E2; Tue, 30 Jun 2020 15:29:27 +0100
In-Reply-To: <20200630142754.GC1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 11/13] net: phylink: re-implement interface
 configuration with PCS
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqHGJ-0006QA-E2@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 15:29:27 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With PCS support, how we implement interface reconfiguration is not up
to the job; we end up reconfiguring the PCS for an interface change
while the link could potentially be up.  In order to solve this, add
two additional MAC methods for interface configuration, one to prepare
for the change, and one to finish the change.

This allows mvneta and mvpp2 to shutdown what they require prior to the
MAC and PCS configuration calls, and then restart as appropriate.

This impacts ksettings_set(), which now needs to identify whether the
change is a minor tweak to the advertisement masks or whether the
interface mode has changed, and call the appropriate function for that
update.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 80 ++++++++++++++++++++++++++-------------
 include/linux/phylink.h   | 48 +++++++++++++++++++++++
 2 files changed, 102 insertions(+), 26 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09f4aeef15c7..a31a00fb4974 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -433,23 +433,47 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
 	}
 }
 
-static void phylink_pcs_config(struct phylink *pl, bool force_restart,
-			       const struct phylink_link_state *state)
+static void phylink_change_interface(struct phylink *pl, bool restart,
+				     const struct phylink_link_state *state)
 {
-	bool restart = force_restart;
+	int err;
+
+	phylink_dbg(pl, "change interface %s\n", phy_modes(state->interface));
 
-	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->config,
-						   pl->cur_link_an_mode,
-						   state->interface,
-						   state->advertising,
-						   !!(pl->link_config.pause &
-						      MLO_PAUSE_AN)))
-		restart = true;
+	if (pl->mac_ops->mac_prepare) {
+		err = pl->mac_ops->mac_prepare(pl->config, pl->cur_link_an_mode,
+					       state->interface);
+		if (err < 0) {
+			phylink_err(pl, "mac_prepare failed: %pe\n",
+				    ERR_PTR(err));
+			return;
+		}
+	}
 
 	phylink_mac_config(pl, state);
 
+	if (pl->pcs_ops) {
+		err = pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,
+					      state->interface,
+					      state->advertising,
+					      !!(pl->link_config.pause &
+						 MLO_PAUSE_AN));
+		if (err < 0)
+			phylink_err(pl, "pcs_config failed: %pe\n",
+				    ERR_PTR(err));
+		if (err > 0)
+			restart = true;
+	}
 	if (restart)
 		phylink_mac_pcs_an_restart(pl);
+
+	if (pl->mac_ops->mac_finish) {
+		err = pl->mac_ops->mac_finish(pl->config, pl->cur_link_an_mode,
+					      state->interface);
+		if (err < 0)
+			phylink_err(pl, "mac_prepare failed: %pe\n",
+				    ERR_PTR(err));
+	}
 }
 
 /*
@@ -555,7 +579,7 @@ static void phylink_mac_initial_config(struct phylink *pl, bool force_restart)
 	link_state.link = false;
 
 	phylink_apply_manual_flow(pl, &link_state);
-	phylink_pcs_config(pl, force_restart, &link_state);
+	phylink_change_interface(pl, force_restart, &link_state);
 }
 
 static const char *phylink_pause_to_str(int pause)
@@ -674,7 +698,7 @@ static void phylink_resolve(struct work_struct *w)
 				phylink_link_down(pl);
 				cur_link_state = false;
 			}
-			phylink_pcs_config(pl, false, &link_state);
+			phylink_change_interface(pl, false, &link_state);
 			pl->link_config.interface = link_state.interface;
 		} else if (!pl->pcs_ops) {
 			/* The interface remains unchanged, only the speed,
@@ -1450,22 +1474,26 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		return -EINVAL;
 
 	mutex_lock(&pl->state_mutex);
-	linkmode_copy(pl->link_config.advertising, config.advertising);
-	pl->link_config.interface = config.interface;
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
-	pl->link_config.an_enabled = kset->base.autoneg !=
-				     AUTONEG_DISABLE;
-
-	if (pl->cur_link_an_mode == MLO_AN_INBAND &&
-	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
-		/* If in 802.3z mode, this updates the advertisement.
-		 *
-		 * If we are in SGMII mode without a PHY, there is no
-		 * advertisement; the only thing we have is the pause
-		 * modes which can only come from a PHY.
-		 */
-		phylink_pcs_config(pl, true, &pl->link_config);
+	pl->link_config.an_enabled = kset->base.autoneg != AUTONEG_DISABLE;
+
+	if (pl->link_config.interface != config.interface) {
+		/* The interface changed, e.g. 1000base-X <-> 2500base-X */
+		/* We need to force the link down, then change the interface */
+		if (pl->old_link_state) {
+			phylink_link_down(pl);
+			pl->old_link_state = false;
+		}
+		if (!test_bit(PHYLINK_DISABLE_STOPPED,
+			      &pl->phylink_disable_state))
+			phylink_change_interface(pl, false, &config);
+		pl->link_config.interface = config.interface;
+		linkmode_copy(pl->link_config.advertising, config.advertising);
+	} else if (!linkmode_equal(pl->link_config.advertising,
+				   config.advertising)) {
+		linkmode_copy(pl->link_config.advertising, config.advertising);
+		phylink_change_inband_advert(pl);
 	}
 	mutex_unlock(&pl->state_mutex);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index d9913d8e6b91..2f1315f32113 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -76,7 +76,9 @@ struct phylink_config {
  * struct phylink_mac_ops - MAC operations structure.
  * @validate: Validate and update the link configuration.
  * @mac_pcs_get_state: Read the current link state from the hardware.
+ * @mac_prepare: prepare for a major reconfiguration of the interface.
  * @mac_config: configure the MAC for the selected mode and state.
+ * @mac_finish: finish a major reconfiguration of the interface.
  * @mac_an_restart: restart 802.3z BaseX autonegotiation.
  * @mac_link_down: take the link down.
  * @mac_link_up: allow the link to come up.
@@ -89,8 +91,12 @@ struct phylink_mac_ops {
 			 struct phylink_link_state *state);
 	void (*mac_pcs_get_state)(struct phylink_config *config,
 				  struct phylink_link_state *state);
+	int (*mac_prepare)(struct phylink_config *config, unsigned int mode,
+			   phy_interface_t iface);
 	void (*mac_config)(struct phylink_config *config, unsigned int mode,
 			   const struct phylink_link_state *state);
+	int (*mac_finish)(struct phylink_config *config, unsigned int mode,
+			  phy_interface_t iface);
 	void (*mac_an_restart)(struct phylink_config *config);
 	void (*mac_link_down)(struct phylink_config *config, unsigned int mode,
 			      phy_interface_t interface);
@@ -145,6 +151,31 @@ void validate(struct phylink_config *config, unsigned long *supported,
 void mac_pcs_get_state(struct phylink_config *config,
 		       struct phylink_link_state *state);
 
+/**
+ * mac_prepare() - prepare to change the PHY interface mode
+ * @config: a pointer to a &struct phylink_config.
+ * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
+ * @iface: interface mode to switch to
+ *
+ * phylink will call this method at the beginning of a full initialisation
+ * of the link, which includes changing the interface mode or at initial
+ * startup time. It may be called for the current mode. The MAC driver
+ * should perform whatever actions are required, e.g. disabling the
+ * Serdes PHY.
+ *
+ * This will be the first call in the sequence:
+ * - mac_prepare()
+ * - mac_config()
+ * - pcs_config()
+ * - possible pcs_an_restart()
+ * - mac_finish()
+ *
+ * Returns zero on success, or negative errno on failure which will be
+ * reported to the kernel log.
+ */
+int mac_prepare(struct phylink_config *config, unsigned int mode,
+		phy_interface_t iface);
+
 /**
  * mac_config() - configure the MAC for the selected mode and state
  * @config: a pointer to a &struct phylink_config.
@@ -220,6 +251,23 @@ void mac_pcs_get_state(struct phylink_config *config,
 void mac_config(struct phylink_config *config, unsigned int mode,
 		const struct phylink_link_state *state);
 
+/**
+ * mac_finish() - finish a to change the PHY interface mode
+ * @config: a pointer to a &struct phylink_config.
+ * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
+ * @iface: interface mode to switch to
+ *
+ * phylink will call this if it called mac_prepare() to allow the MAC to
+ * complete any necessary steps after the MAC and PCS have been configured
+ * for the @mode and @iface. E.g. a MAC driver may wish to re-enable the
+ * Serdes PHY here if it was previously disabled by mac_prepare().
+ *
+ * Returns zero on success, or negative errno on failure which will be
+ * reported to the kernel log.
+ */
+int mac_finish(struct phylink_config *config, unsigned int mode,
+		phy_interface_t iface);
+
 /**
  * mac_an_restart() - restart 802.3z BaseX autonegotiation
  * @config: a pointer to a &struct phylink_config.
-- 
2.20.1

