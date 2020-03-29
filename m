Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81006196E44
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgC2QBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 12:01:21 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39192 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgC2QBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 12:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RBuZBe4FVnCNSJwbzOzTvDMK0bFPsgyJGxPhQI9OTa8=; b=jnpxgbOYfM+6Fh2dbgmeXWr2GS
        JHM6MFavW91X9zkNOXV3RQwRywemjy/jMnR3+lCJYFyh1CeoCvFJ+LQti+GGsz7uywqlldmi91Oo1
        7Pv23LU/ctnrpBkGTMHQB/2sCZW0VEyt3+8zH31zRZYSErC5vC3LUflbuZun5ww0cPHFyQT4dpfDN
        Anfu6QD2tdT546mrfSgs977nn/7T08s+vuO5FCCHkNZR5Lw+CYfRgu0Q2tvIGD3ph/jLVb1qa+0yp
        UuEsEbg/dsUsJW5QW2XQeE+FDILMBa+J3HAJR7+kEoHn7gJl41L5RzQvRAbMGLG9tjbr6bExXf3eN
        v6yNXxtQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55320 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jIaN7-0005oi-QH; Sun, 29 Mar 2020 17:01:13 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jIaN7-0007lh-3p; Sun, 29 Mar 2020 17:01:13 +0100
In-Reply-To: <20200329160036.GB25745@shell.armlinux.org.uk>
References: <20200329160036.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/3] net: phylink: rename 'ops' to 'mac_ops'
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jIaN7-0007lh-3p@rmk-PC.armlinux.org.uk>
Date:   Sun, 29 Mar 2020 17:01:13 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the bland 'ops' member of struct phylink to be a more
descriptive 'mac_ops' - this is necessary as we're about to introduce
another set of operations.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f31bfd39df4b..e2f30fd4d235 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -40,7 +40,7 @@ enum {
 struct phylink {
 	/* private: */
 	struct net_device *netdev;
-	const struct phylink_mac_ops *ops;
+	const struct phylink_mac_ops *mac_ops;
 	struct phylink_config *config;
 	struct device *dev;
 	unsigned int old_link_state:1;
@@ -154,7 +154,7 @@ static const char *phylink_an_mode_str(unsigned int mode)
 static int phylink_validate(struct phylink *pl, unsigned long *supported,
 			    struct phylink_link_state *state)
 {
-	pl->ops->validate(pl->config, supported, state);
+	pl->mac_ops->validate(pl->config, supported, state);
 
 	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
 }
@@ -415,7 +415,7 @@ static void phylink_mac_config(struct phylink *pl,
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
 		    state->pause, state->link, state->an_enabled);
 
-	pl->ops->mac_config(pl->config, pl->cur_link_an_mode, state);
+	pl->mac_ops->mac_config(pl->config, pl->cur_link_an_mode, state);
 }
 
 static void phylink_mac_config_up(struct phylink *pl,
@@ -429,7 +429,7 @@ static void phylink_mac_an_restart(struct phylink *pl)
 {
 	if (pl->link_config.an_enabled &&
 	    phy_interface_mode_is_8023z(pl->link_config.interface))
-		pl->ops->mac_an_restart(pl->config);
+		pl->mac_ops->mac_an_restart(pl->config);
 }
 
 static void phylink_mac_pcs_get_state(struct phylink *pl,
@@ -445,7 +445,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	state->an_complete = 0;
 	state->link = 1;
 
-	pl->ops->mac_pcs_get_state(pl->config, state);
+	pl->mac_ops->mac_pcs_get_state(pl->config, state);
 }
 
 /* The fixed state is... fixed except for the link state,
@@ -512,11 +512,11 @@ static void phylink_mac_link_up(struct phylink *pl,
 	struct net_device *ndev = pl->netdev;
 
 	pl->cur_interface = link_state.interface;
-	pl->ops->mac_link_up(pl->config, pl->phydev,
-			     pl->cur_link_an_mode, pl->cur_interface,
-			     link_state.speed, link_state.duplex,
-			     !!(link_state.pause & MLO_PAUSE_TX),
-			     !!(link_state.pause & MLO_PAUSE_RX));
+	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
+				 pl->cur_link_an_mode, pl->cur_interface,
+				 link_state.speed, link_state.duplex,
+				 !!(link_state.pause & MLO_PAUSE_TX),
+				 !!(link_state.pause & MLO_PAUSE_RX));
 
 	if (ndev)
 		netif_carrier_on(ndev);
@@ -534,8 +534,8 @@ static void phylink_mac_link_down(struct phylink *pl)
 
 	if (ndev)
 		netif_carrier_off(ndev);
-	pl->ops->mac_link_down(pl->config, pl->cur_link_an_mode,
-			       pl->cur_interface);
+	pl->mac_ops->mac_link_down(pl->config, pl->cur_link_an_mode,
+				   pl->cur_interface);
 	phylink_info(pl, "Link is Down\n");
 }
 
@@ -666,7 +666,7 @@ static int phylink_register_sfp(struct phylink *pl,
  * @fwnode: a pointer to a &struct fwnode_handle describing the network
  *	interface
  * @iface: the desired link mode defined by &typedef phy_interface_t
- * @ops: a pointer to a &struct phylink_mac_ops for the MAC.
+ * @mac_ops: a pointer to a &struct phylink_mac_ops for the MAC.
  *
  * Create a new phylink instance, and parse the link parameters found in @np.
  * This will parse in-band modes, fixed-link or SFP configuration.
@@ -679,7 +679,7 @@ static int phylink_register_sfp(struct phylink *pl,
 struct phylink *phylink_create(struct phylink_config *config,
 			       struct fwnode_handle *fwnode,
 			       phy_interface_t iface,
-			       const struct phylink_mac_ops *ops)
+			       const struct phylink_mac_ops *mac_ops)
 {
 	struct phylink *pl;
 	int ret;
@@ -712,7 +712,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 	pl->link_config.speed = SPEED_UNKNOWN;
 	pl->link_config.duplex = DUPLEX_UNKNOWN;
 	pl->link_config.an_enabled = true;
-	pl->ops = ops;
+	pl->mac_ops = mac_ops;
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
 
-- 
2.20.1

