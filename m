Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A56549A23
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbiFMRfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242267AbiFMRe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:34:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E548F12E826
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HrwRonIxblTTouEfPKm9hz2IxHPlaC8X+xGP1hKHvmI=; b=lvjHXEfL6gPiL+Sn+JT1LkYz4m
        dlOb12ReHf0TKXYiJ9z4e5h/YAndPG54vM5a78fbIA/c9eiX39zE8aMN1gw7jCFVKbk4Vitz4djs+
        j+R+aTYcYhHd18n16sG3oCubRv1OBZoGtkekwmvI+4CbW6W0Lm4cW9SVm5tXYePng5r58LRR/A+0X
        md8+ESq2XTuowV/QJiXZ129ib4k4sjTERK8p5FvNz7zHcA+dx2I5A8gsjkDyRIkebT4BHp6fxbvo/
        vZTHfhhgu4epnMEr8Cvfsx6H+gFy21u26dxrbzFY6SVhM7e3GFEWp7NJN6uMHpMQuxo4CnWIJB19E
        xZYGWOSw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52082 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgQ-0001r2-07; Mon, 13 Jun 2022 14:00:42 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jgP-000JYO-B3; Mon, 13 Jun 2022 14:00:41 +0100
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 04/15] net: phylink: disable PCS polling over major
 configuration
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jgP-000JYO-B3@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:00:41 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While we are performing a major configuration, there is no point having
the PCS polling timer running. Stop it before we begin preparing for
the configuration change, and restart it only once we've successfully
completed the change.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0ce1602513b9..24ef98950600 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -758,6 +758,18 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
 	}
 }
 
+static void phylink_pcs_poll_stop(struct phylink *pl)
+{
+	if (pl->cfg_link_an_mode == MLO_AN_INBAND)
+		del_timer(&pl->link_poll);
+}
+
+static void phylink_pcs_poll_start(struct phylink *pl)
+{
+	if (pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
+		mod_timer(&pl->link_poll, jiffies + HZ);
+}
+
 static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
@@ -789,6 +801,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 				  const struct phylink_link_state *state)
 {
 	struct phylink_pcs *pcs = NULL;
+	bool pcs_changed = false;
 	int err;
 
 	phylink_dbg(pl, "major config %s\n", phy_modes(state->interface));
@@ -801,8 +814,12 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 				    pcs);
 			return;
 		}
+
+		pcs_changed = pcs && pl->pcs != pcs;
 	}
 
+	phylink_pcs_poll_stop(pl);
+
 	if (pl->mac_ops->mac_prepare) {
 		err = pl->mac_ops->mac_prepare(pl->config, pl->cur_link_an_mode,
 					       state->interface);
@@ -816,16 +833,8 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 	/* If we have a new PCS, switch to the new PCS after preparing the MAC
 	 * for the change.
 	 */
-	if (pcs) {
+	if (pcs_changed) {
 		pl->pcs = pcs;
-
-		if (!pl->phylink_disable_state &&
-		    pl->cfg_link_an_mode == MLO_AN_INBAND) {
-			if (pcs->poll)
-				mod_timer(&pl->link_poll, jiffies + HZ);
-			else
-				del_timer(&pl->link_poll);
-		}
 	}
 
 	phylink_mac_config(pl, state);
@@ -852,6 +861,8 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 			phylink_err(pl, "mac_finish failed: %pe\n",
 				    ERR_PTR(err));
 	}
+
+	phylink_pcs_poll_start(pl);
 }
 
 /*
-- 
2.30.2

