Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3229C549A22
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbiFMRfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242083AbiFMRew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:34:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FE1132A10
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/Q9NriCo9lZuNT+qHXsCOBbqNSSrL4COwggMvRBMKy4=; b=VoFKKXzFsqJ0CIVJP6KJ/RorVz
        mARXIeC9oH9VpRepScQWkg71SdhMNvwoUvLC7J1VnBaeBzoI0urHm3JWmoNir7ecNP4PLck18Pdwl
        PQuh+n6X+SwA1K6g05xVxHe1Bj7WFYJKs0uMMz1tmT+0nFZL4XJU0EvB+lvKngJ9lLRTc59jMQVe/
        TqBmtINSFxIdgt9lqJD49hZGmovYGs0BLaCSAuePX4jL0VatpVXf7rrRuPvfRhMfJ9Bz2G/E0QCwe
        0YHA613IsEBF5i+FZW6yqZ5TXehJy4qXLFPFVISzVoxWj14Qs+QTtVTXt4t1Tp8z1m0G260Spb6gL
        qwXQA3Nw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52084 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgV-0001rF-2j; Mon, 13 Jun 2022 14:00:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jgU-000JYV-Em; Mon, 13 Jun 2022 14:00:46 +0100
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
Subject: [PATCH net-next 05/15] net: phylink: add pcs_enable()/pcs_disable()
 methods
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jgU-000JYV-Em@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:00:46 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add phylink PCS enable/disable callbacks that will allow us to place
IEEE 802.3 register compliant PCS in power-down mode while not being
used.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 48 +++++++++++++++++++++++++++++++--------
 include/linux/phylink.h   | 16 +++++++++++++
 2 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 24ef98950600..7721aea73c86 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -34,6 +34,10 @@ enum {
 	PHYLINK_DISABLE_STOPPED,
 	PHYLINK_DISABLE_LINK,
 	PHYLINK_DISABLE_MAC_WOL,
+
+	PCS_STATE_DOWN = 0,
+	PCS_STATE_STARTING,
+	PCS_STATE_STARTED,
 };
 
 /**
@@ -71,6 +75,7 @@ struct phylink {
 	struct mutex state_mutex;
 	struct phylink_link_state phy_state;
 	struct work_struct resolve;
+	unsigned int pcs_state;
 
 	bool mac_link_dropped;
 	bool using_mac_select_pcs;
@@ -758,6 +763,22 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
 	}
 }
 
+static void phylink_pcs_disable(struct phylink_pcs *pcs)
+{
+	if (pcs && pcs->ops->pcs_disable)
+		pcs->ops->pcs_disable(pcs);
+}
+
+static int phylink_pcs_enable(struct phylink_pcs *pcs)
+{
+	int err = 0;
+
+	if (pcs && pcs->ops->pcs_enable)
+		err = pcs->ops->pcs_enable(pcs);
+
+	return err;
+}
+
 static void phylink_pcs_poll_stop(struct phylink *pl)
 {
 	if (pl->cfg_link_an_mode == MLO_AN_INBAND)
@@ -766,7 +787,8 @@ static void phylink_pcs_poll_stop(struct phylink *pl)
 
 static void phylink_pcs_poll_start(struct phylink *pl)
 {
-	if (pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
+	if (pl->pcs && pl->pcs->poll &&
+	    pl->cfg_link_an_mode == MLO_AN_INBAND)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 }
 
@@ -834,11 +856,16 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 	 * for the change.
 	 */
 	if (pcs_changed) {
+		phylink_pcs_disable(pl->pcs);
+
 		pl->pcs = pcs;
 	}
 
 	phylink_mac_config(pl, state);
 
+	if (pl->pcs_state == PCS_STATE_STARTING || pcs_changed)
+		phylink_pcs_enable(pl->pcs);
+
 	if (pl->pcs) {
 		err = pl->pcs->ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
 					       state->interface,
@@ -1273,6 +1300,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 	pl->link_config.speed = SPEED_UNKNOWN;
 	pl->link_config.duplex = DUPLEX_UNKNOWN;
 	pl->link_config.an_enabled = true;
+	pl->pcs_state = PCS_STATE_DOWN;
 	pl->mac_ops = mac_ops;
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
@@ -1639,6 +1667,8 @@ void phylink_start(struct phylink *pl)
 	if (pl->netdev)
 		netif_carrier_off(pl->netdev);
 
+	pl->pcs_state = PCS_STATE_STARTING;
+
 	/* Apply the link configuration to the MAC when starting. This allows
 	 * a fixed-link to start with the correct parameters, and also
 	 * ensures that we set the appropriate advertisement for Serdes links.
@@ -1649,6 +1679,8 @@ void phylink_start(struct phylink *pl)
 	 */
 	phylink_mac_initial_config(pl, true);
 
+	pl->pcs_state = PCS_STATE_STARTED;
+
 	phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_STOPPED);
 
 	if (pl->cfg_link_an_mode == MLO_AN_FIXED && pl->link_gpio) {
@@ -1667,15 +1699,9 @@ void phylink_start(struct phylink *pl)
 			poll = true;
 	}
 
-	switch (pl->cfg_link_an_mode) {
-	case MLO_AN_FIXED:
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED)
 		poll |= pl->config->poll_fixed_state;
-		break;
-	case MLO_AN_INBAND:
-		if (pl->pcs)
-			poll |= pl->pcs->poll;
-		break;
-	}
+
 	if (poll)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 	if (pl->phydev)
@@ -1712,6 +1738,10 @@ void phylink_stop(struct phylink *pl)
 	}
 
 	phylink_run_resolve_and_disable(pl, PHYLINK_DISABLE_STOPPED);
+
+	pl->pcs_state = PCS_STATE_DOWN;
+
+	phylink_pcs_disable(pl->pcs);
 }
 EXPORT_SYMBOL_GPL(phylink_stop);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 91ba7e4d72db..eece482bce17 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -432,6 +432,8 @@ struct phylink_pcs {
 /**
  * struct phylink_pcs_ops - MAC PCS operations structure.
  * @pcs_validate: validate the link configuration.
+ * @pcs_enable: enable the PCS.
+ * @pcs_disable: disable the PCS.
  * @pcs_get_state: read the current MAC PCS link state from the hardware.
  * @pcs_config: configure the MAC PCS for the selected mode and state.
  * @pcs_an_restart: restart 802.3z BaseX autonegotiation.
@@ -441,6 +443,8 @@ struct phylink_pcs {
 struct phylink_pcs_ops {
 	int (*pcs_validate)(struct phylink_pcs *pcs, unsigned long *supported,
 			    const struct phylink_link_state *state);
+	int (*pcs_enable)(struct phylink_pcs *pcs);
+	void (*pcs_disable)(struct phylink_pcs *pcs);
 	void (*pcs_get_state)(struct phylink_pcs *pcs,
 			      struct phylink_link_state *state);
 	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
@@ -470,6 +474,18 @@ struct phylink_pcs_ops {
 int pcs_validate(struct phylink_pcs *pcs, unsigned long *supported,
 		 const struct phylink_link_state *state);
 
+/**
+ * pcs_enable() - enable the PCS.
+ * @pcs: a pointer to a &struct phylink_pcs.
+ */
+int pcs_enable(struct phylink_pcs *pcs);
+
+/**
+ * pcs_disable() - disable the PCS.
+ * @pcs: a pointer to a &struct phylink_pcs.
+ */
+void pcs_disable(struct phylink_pcs *pcs);
+
 /**
  * pcs_get_state() - Read the current inband link state from the hardware
  * @pcs: a pointer to a &struct phylink_pcs.
-- 
2.30.2

