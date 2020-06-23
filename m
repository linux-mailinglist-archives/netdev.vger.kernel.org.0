Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F82057C9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387478AbgFWQrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733018AbgFWQra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:47:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE349C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1go2tsb4APlFvhK3Hs45Sl/l0xayUY86ZX++9/QcdT0=; b=kc08LZV/8ZIAXEUiQ67CiDkJlw
        Jg5K2VVaE2UNa2vvvhL5ZKpZtkeCiAt5h8FcmL74q325xXNuOA715/7tN4xgVBXA80FNQ/XerYFoo
        HnDh3cYDfIOINht6b0SNmHvZvEZa4dWfO6WyJ9+eA+oTTJV3BS3rEtbEBqQJbH9Y0Lwrm4/FpM0RV
        0DAr4WdY1ezWaxbn+Dt2X9c2HjmKAvCiT/RMQWLQ86ZV+GdGFyvQvzJeY9SL5rDW6q5wvhg4VEHlV
        PFCnnFvEcHj4uiMcXDDJsyrRl5oeyDmxe8EZMVT+eTBMTn+jLSmrUqhOlESij6fBiz5bxHCrCVajf
        9bxKFTnA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52978 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jnm53-0001zT-9e; Tue, 23 Jun 2020 17:47:29 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jnm53-0005hg-2Z; Tue, 23 Jun 2020 17:47:29 +0100
In-Reply-To: <20200623164642.GV1551@shell.armlinux.org.uk>
References: <20200623164642.GV1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/2] net: phylink: ensure manual pause mode configuration
 takes effect
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jnm53-0005hg-2Z@rmk-PC.armlinux.org.uk>
Date:   Tue, 23 Jun 2020 17:47:29 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have been relying on link events and mac_config() when the manual
pause modes are changed.  With recent developments, such as moving
the programming of link state to mac_link_up(), this no longer works.

To ensure that we update the MAC, we must generate a link-down followed
by a link-up event; we can do that by setting mac_link_dropped and
triggering a resolve.

Fixes: 91a208f2185a ("net: phylink: propagate resolved link config via mac_link_up()")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 453f9a399bb1..3b7c70e6c5dd 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1463,6 +1463,8 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 				   struct ethtool_pauseparam *pause)
 {
 	struct phylink_link_state *config = &pl->link_config;
+	bool manual_changed;
+	int pause_state;
 
 	ASSERT_RTNL();
 
@@ -1477,15 +1479,15 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	    !pause->autoneg && pause->rx_pause != pause->tx_pause)
 		return -EINVAL;
 
-	mutex_lock(&pl->state_mutex);
-	config->pause = 0;
+	pause_state = 0;
 	if (pause->autoneg)
-		config->pause |= MLO_PAUSE_AN;
+		pause_state |= MLO_PAUSE_AN;
 	if (pause->rx_pause)
-		config->pause |= MLO_PAUSE_RX;
+		pause_state |= MLO_PAUSE_RX;
 	if (pause->tx_pause)
-		config->pause |= MLO_PAUSE_TX;
+		pause_state |= MLO_PAUSE_TX;
 
+	mutex_lock(&pl->state_mutex);
 	/*
 	 * See the comments for linkmode_set_pause(), wrt the deficiencies
 	 * with the current implementation.  A solution to this issue would
@@ -1502,6 +1504,12 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	linkmode_set_pause(config->advertising, pause->tx_pause,
 			   pause->rx_pause);
 
+	manual_changed = (config->pause ^ pause_state) & MLO_PAUSE_AN ||
+			 (!(pause_state & MLO_PAUSE_AN) &&
+			   (config->pause ^ pause_state) & MLO_PAUSE_TXRX_MASK);
+
+	config->pause = pause_state;
+
 	if (!pl->phydev && !test_bit(PHYLINK_DISABLE_STOPPED,
 				     &pl->phylink_disable_state))
 		phylink_pcs_config(pl, true, &pl->link_config);
@@ -1517,6 +1525,15 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 		phy_set_asym_pause(pl->phydev, pause->rx_pause,
 				   pause->tx_pause);
 
+	/* If the manual pause settings changed, make sure we trigger a
+	 * resolve to update their state; we can not guarantee that the
+	 * link will cycle.
+	 */
+	if (manual_changed) {
+		pl->mac_link_dropped = true;
+		phylink_run_resolve(pl);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(phylink_ethtool_set_pauseparam);
-- 
2.20.1

