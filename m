Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB195227E03
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgGULD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728994AbgGULD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:03:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2AAC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yBUA6pu/TX+4cho+/urLgr6NCeVVLxAjZiF6hmr6CO4=; b=SJuShgsXN+vTzm2zDu0pIaQyg1
        2SGGWBuF2j6mldsuN7YtU7xYFz9T5OYobs15MunywWLnXeYFUZ5KK8Cyorb8IcrAaujbYuhFakSXG
        7wr5HiVvJlT2pN7FMeDK7nMVIg8zKOwAR1D9w+OBDtH+x9pIsvFWH4AQPOV+9CWYs8cSxI7vzpj9R
        6T8xc07i9MDsphQ4oo0p5Oawugd9KSoSmR3WQQ+P2H6ImnxOp0FIsdwi3I/DeaSvwLVCt9sw12RIz
        2M1wQ5E3oLexw7MwtOIDgZYSD+6NC3KsY2Q32LCyrcCsO5On8mDPgNZm3PDnVA5E1GRtCPbROIue4
        qs/Mevhw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41758 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq3v-0004EX-Pt; Tue, 21 Jul 2020 12:03:55 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq3v-0004RF-It; Tue, 21 Jul 2020 12:03:55 +0100
In-Reply-To: <20200721110152.GY1551@shell.armlinux.org.uk>
References: <20200721110152.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/14] net: phylink: rearrange resolve mac_config()
 call
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq3v-0004RF-It@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:03:55 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a boolean to indicate whether mac_config() should be called during
a resolution. This allows resolution to have a single location where
mac_config() will be called, which will allow us to make decisions
about how and what we do.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b36e0315f0b1..8ffe5df5c296 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -421,13 +421,6 @@ static void phylink_mac_config(struct phylink *pl,
 	pl->mac_ops->mac_config(pl->config, pl->cur_link_an_mode, state);
 }
 
-static void phylink_mac_config_up(struct phylink *pl,
-				  const struct phylink_link_state *state)
-{
-	if (state->link)
-		phylink_mac_config(pl, state);
-}
-
 static void phylink_mac_pcs_an_restart(struct phylink *pl)
 {
 	if (pl->link_config.an_enabled &&
@@ -578,6 +571,7 @@ static void phylink_resolve(struct work_struct *w)
 	struct phylink *pl = container_of(w, struct phylink, resolve);
 	struct phylink_link_state link_state;
 	struct net_device *ndev = pl->netdev;
+	bool mac_config = false;
 	bool cur_link_state;
 
 	mutex_lock(&pl->state_mutex);
@@ -596,12 +590,12 @@ static void phylink_resolve(struct work_struct *w)
 		case MLO_AN_PHY:
 			link_state = pl->phy_state;
 			phylink_apply_manual_flow(pl, &link_state);
-			phylink_mac_config_up(pl, &link_state);
+			mac_config = link_state.link;
 			break;
 
 		case MLO_AN_FIXED:
 			phylink_get_fixed_state(pl, &link_state);
-			phylink_mac_config_up(pl, &link_state);
+			mac_config = link_state.link;
 			break;
 
 		case MLO_AN_INBAND:
@@ -619,15 +613,16 @@ static void phylink_resolve(struct work_struct *w)
 				/* If we have a PHY, we need to update with
 				 * the PHY flow control bits. */
 				link_state.pause = pl->phy_state.pause;
-				phylink_apply_manual_flow(pl, &link_state);
-				phylink_mac_config(pl, &link_state);
-			} else {
-				phylink_apply_manual_flow(pl, &link_state);
+				mac_config = true;
 			}
+			phylink_apply_manual_flow(pl, &link_state);
 			break;
 		}
 	}
 
+	if (mac_config)
+		phylink_mac_config(pl, &link_state);
+
 	if (link_state.link != cur_link_state) {
 		pl->old_link_state = link_state.link;
 		if (!link_state.link)
-- 
2.20.1

