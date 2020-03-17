Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51C018881C
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgCQOxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:53:07 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40946 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgCQOxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=22ndCDyPmdee4Exto8Ki6Mk04KCrxJERlHrsSBm4c9Q=; b=1/682CIPCmI2KlpHIvE37TXVoC
        wbL8Z18KqlaJFEqmkzJIzgTpRkWQI/1fccUY/XzvbY3MKd/VLSWqLgI/KjNMbfuUu3uZ5dKvdw2/G
        7fT/hMZvr7hDTZfSSi59ftd0Do+Rd9fladcEr3Tprwhu1XWkGYKpGvyrZx5S+KU/YmJrQMoR8PQ82
        YE8ViIa/SNPXjCMjaDkc7ZQOiQvB1kOVxjQwqVtQhETSGhvvlsk9MIMfc/NKT9XUp7fgBB66E14g8
        5cwOimpc8Sez9F4Rh+9ux/9DnFbMnnayzKX9pto6qne0PxJF/1NvU108UpKNM07H/qv/nb7FFmN1E
        /+P11pAA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:36226 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDaP-0007iQ-9j; Tue, 17 Mar 2020 14:52:53 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDaN-0008JH-MY; Tue, 17 Mar 2020 14:52:51 +0000
In-Reply-To: <20200317144944.GP25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Mar 2020 14:52:51 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*NOT FOR MERGING*

Add a separate set of PCS operations, which MAC drivers can use to
couple phylink with their associated MAC PCS layer.  The PCS
operations include:

- pcs_get_state() - reads the link up/down, resolved speed, duplex
   and pause from the PCS.
- pcs_config() - configures the PCS for the specified mode, PHY
   interface type, and setting the advertisement.
- pcs_an_restart() - restarts 802.3 in-band negotiation with the
   link partner
- pcs_link_up() - informs the PCS that link has come up, and the
   parameters of the link. Link parameters are used to program the
   PCS for fixed speed and non-inband modes.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 76 +++++++++++++++++++++++++++------------
 include/linux/phylink.h   | 11 ++++++
 2 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a34a3be92dba..abe2cc168f93 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -41,6 +41,7 @@ struct phylink {
 	/* private: */
 	struct net_device *netdev;
 	const struct phylink_mac_ops *mac_ops;
+	const struct phylink_pcs_ops *pcs_ops;
 	struct phylink_config *config;
 	struct device *dev;
 	unsigned int old_link_state:1;
@@ -425,11 +426,31 @@ static void phylink_mac_config_up(struct phylink *pl,
 		phylink_mac_config(pl, state);
 }
 
-static void phylink_mac_an_restart(struct phylink *pl)
+static void phylink_mac_pcs_an_restart(struct phylink *pl)
 {
 	if (pl->link_config.an_enabled &&
-	    phy_interface_mode_is_8023z(pl->link_config.interface))
-		pl->mac_ops->mac_an_restart(pl->config);
+	    phy_interface_mode_is_8023z(pl->link_config.interface)) {
+		if (pl->pcs_ops)
+			pl->pcs_ops->pcs_an_restart(pl->config);
+		else
+			pl->mac_ops->mac_an_restart(pl->config);
+	}
+}
+
+static void phylink_pcs_config(struct phylink *pl, bool force_restart,
+			       const struct phylink_link_state *state)
+{
+	bool restart = force_restart;
+
+	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->config,
+						   pl->cur_link_an_mode,
+						   state))
+		restart = true;
+
+	phylink_mac_config(pl, state);
+
+	if (restart)
+		phylink_mac_pcs_an_restart(pl);
 }
 
 static void phylink_mac_pcs_get_state(struct phylink *pl,
@@ -445,7 +466,10 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	state->an_complete = 0;
 	state->link = 1;
 
-	pl->mac_ops->mac_pcs_get_state(pl->config, state);
+	if (pl->pcs_ops)
+		pl->pcs_ops->pcs_get_state(pl->config, state);
+	else
+		pl->mac_ops->mac_pcs_get_state(pl->config, state);
 }
 
 /* The fixed state is... fixed except for the link state,
@@ -463,7 +487,7 @@ static void phylink_get_fixed_state(struct phylink *pl,
 	phylink_resolve_flow(state);
 }
 
-static void phylink_mac_initial_config(struct phylink *pl)
+static void phylink_mac_initial_config(struct phylink *pl, bool force_restart)
 {
 	struct phylink_link_state link_state;
 
@@ -489,7 +513,7 @@ static void phylink_mac_initial_config(struct phylink *pl)
 	link_state.link = false;
 
 	phylink_apply_manual_flow(pl, &link_state);
-	phylink_mac_config(pl, &link_state);
+	phylink_pcs_config(pl, force_restart, &link_state);
 }
 
 static const char *phylink_pause_to_str(int pause)
@@ -506,12 +530,18 @@ static const char *phylink_pause_to_str(int pause)
 	}
 }
 
-static void phylink_mac_link_up(struct phylink *pl,
-				struct phylink_link_state link_state)
+static void phylink_link_up(struct phylink *pl,
+			    struct phylink_link_state link_state)
 {
 	struct net_device *ndev = pl->netdev;
 
 	pl->cur_interface = link_state.interface;
+
+	if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)
+		pl->pcs_ops->pcs_link_up(pl->config, pl->cur_link_an_mode,
+					 pl->cur_interface,
+					 link_state.speed, link_state.duplex);
+
 	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
 				 pl->cur_link_an_mode, pl->cur_interface,
 				 link_state.speed, link_state.duplex,
@@ -528,7 +558,7 @@ static void phylink_mac_link_up(struct phylink *pl,
 		     phylink_pause_to_str(link_state.pause));
 }
 
-static void phylink_mac_link_down(struct phylink *pl)
+static void phylink_link_down(struct phylink *pl)
 {
 	struct net_device *ndev = pl->netdev;
 
@@ -597,9 +627,9 @@ static void phylink_resolve(struct work_struct *w)
 	if (link_changed) {
 		pl->old_link_state = link_state.link;
 		if (!link_state.link)
-			phylink_mac_link_down(pl);
+			phylink_link_down(pl);
 		else
-			phylink_mac_link_up(pl, link_state);
+			phylink_link_up(pl, link_state);
 	}
 	if (!link_state.link && pl->mac_link_dropped) {
 		pl->mac_link_dropped = false;
@@ -746,6 +776,12 @@ struct phylink *phylink_create(struct phylink_config *config,
 }
 EXPORT_SYMBOL_GPL(phylink_create);
 
+void phylink_add_pcs(struct phylink *pl, const struct phylink_pcs_ops *ops)
+{
+	pl->pcs_ops = ops;
+}
+EXPORT_SYMBOL_GPL(phylink_add_pcs);
+
 /**
  * phylink_destroy() - cleanup and destroy the phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
@@ -1082,14 +1118,12 @@ void phylink_start(struct phylink *pl)
 	/* Apply the link configuration to the MAC when starting. This allows
 	 * a fixed-link to start with the correct parameters, and also
 	 * ensures that we set the appropriate advertisement for Serdes links.
-	 */
-	phylink_mac_initial_config(pl);
-
-	/* Restart autonegotiation if using 802.3z to ensure that the link
+	 *
+	 * Restart autonegotiation if using 802.3z to ensure that the link
 	 * parameters are properly negotiated.  This is necessary for DSA
 	 * switches using 802.3z negotiation to ensure they see our modes.
 	 */
-	phylink_mac_an_restart(pl);
+	phylink_mac_initial_config(pl, true);
 
 	clear_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	phylink_run_resolve(pl);
@@ -1386,8 +1420,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 			 * advertisement; the only thing we have is the pause
 			 * modes which can only come from a PHY.
 			 */
-			phylink_mac_config(pl, &pl->link_config);
-			phylink_mac_an_restart(pl);
+			phylink_pcs_config(pl, true, &pl->link_config);
 		}
 		mutex_unlock(&pl->state_mutex);
 	}
@@ -1415,7 +1448,7 @@ int phylink_ethtool_nway_reset(struct phylink *pl)
 
 	if (pl->phydev)
 		ret = phy_restart_aneg(pl->phydev);
-	phylink_mac_an_restart(pl);
+	phylink_mac_pcs_an_restart(pl);
 
 	return ret;
 }
@@ -1494,8 +1527,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 				   pause->tx_pause);
 	} else if (!test_bit(PHYLINK_DISABLE_STOPPED,
 			     &pl->phylink_disable_state)) {
-		phylink_mac_config(pl, &pl->link_config);
-		phylink_mac_an_restart(pl);
+		phylink_pcs_config(pl, true, &pl->link_config);
 	}
 	mutex_unlock(&pl->state_mutex);
 
@@ -1901,7 +1933,7 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 
 	if (changed && !test_bit(PHYLINK_DISABLE_STOPPED,
 				 &pl->phylink_disable_state))
-		phylink_mac_initial_config(pl);
+		phylink_mac_initial_config(pl, false);
 
 	return ret;
 }
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 8fa6df3b881b..dc27dd341ebd 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -97,6 +97,16 @@ struct phylink_mac_ops {
 			    bool tx_pause, bool rx_pause);
 };
 
+struct phylink_pcs_ops {
+	void (*pcs_get_state)(struct phylink_config *config,
+			      struct phylink_link_state *state);
+	int (*pcs_config)(struct phylink_config *config, unsigned int mode,
+			  const struct phylink_link_state *state);
+	void (*pcs_an_restart)(struct phylink_config *config);
+	void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
+			    phy_interface_t interface, int speed, int duplex);
+};
+
 #if 0 /* For kernel-doc purposes only. */
 /**
  * validate - Validate and update the link configuration
@@ -273,6 +283,7 @@ void mac_link_up(struct phylink_config *config, struct phy_device *phy,
 struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *ops);
+void phylink_add_pcs(struct phylink *, const struct phylink_pcs_ops *ops);
 void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
-- 
2.20.1

