Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E220020F73D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389009AbgF3O32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388849AbgF3O31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:29:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AD4C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ePHEHKj8qGSric55X2Hqpx4BLic588fCFn2O45mmvUw=; b=YuEaWWps1eICGYTbihFU7vUBV4
        h9gQQiWvOAQfWklLTp9cm9QQPum+1iJ5HdJPQBSvwZjJDgCipRta6zMblq6VZPpz4olQHhkzp4CD5
        Z7WGMIm6rjiFq7w1YHIqiBBNQIDoZww7zOGi0hKD2zp4MSK3wbww3hgYen+eI1pxmEyw/I3u7CE8K
        ynwxzC0fmzxTWILe/pC89eewZ0gRwGr4+KxufBTnI3G9h0G9mqBaR36F/zw2+cIW96lzV5YyPCnJf
        mnw16cty4+RmusMx59OupQdDvfRYXoi89is/KMiviK77I47iiWyCmd1MNfCF8OuVYEMwTtWznhF+e
        VdLQN4Ew==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47276 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHGE-0000fb-Gp; Tue, 30 Jun 2020 15:29:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHGE-0006Pz-5h; Tue, 30 Jun 2020 15:29:22 +0100
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
Subject: [PATCH RFC net-next 10/13] net: phylink: in-band pause mode
 advertisement update for PCS
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqHGE-0006Pz-5h@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 15:29:22 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-code the pause in-band advertisement update in light of the addition
of PCS support, so that we perform the minimum required; only the PCS
configuration function needs to be called in this case, followed by the
request to trigger a restart of negotiation if the programmed
advertisement changed.

We need to change the pcs_config() signature to pass whether resolved
pause should be passed to the MAC for setups such as mvneta and mvpp2
where doing so overrides the MAC manual flow controls.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 55 ++++++++++++++++++++++++++++++++++++---
 include/linux/phylink.h   |  7 +++--
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b91151062cdc..09f4aeef15c7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -441,7 +441,9 @@ static void phylink_pcs_config(struct phylink *pl, bool force_restart,
 	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->config,
 						   pl->cur_link_an_mode,
 						   state->interface,
-						   state->advertising))
+						   state->advertising,
+						   !!(pl->link_config.pause &
+						      MLO_PAUSE_AN)))
 		restart = true;
 
 	phylink_mac_config(pl, state);
@@ -450,6 +452,49 @@ static void phylink_pcs_config(struct phylink *pl, bool force_restart,
 		phylink_mac_pcs_an_restart(pl);
 }
 
+/*
+ * Reconfigure for a change of inband advertisement.
+ * If we have a separate PCS, we only need to call its pcs_config() method,
+ * and then restart AN if it indicates something changed. Otherwise, we do
+ * the full MAC reconfiguration.
+ */
+static int phylink_change_inband_advert(struct phylink *pl)
+{
+	int ret;
+
+	if (test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state))
+		return 0;
+
+	if (!pl->pcs_ops) {
+		/* Legacy method */
+		phylink_mac_config(pl, &pl->link_config);
+		phylink_mac_pcs_an_restart(pl);
+		return 0;
+	}
+
+	phylink_dbg(pl, "%s: mode=%s/%s adv=%*pb pause=%02x\n", __func__,
+		    phylink_an_mode_str(pl->cur_link_an_mode),
+		    phy_modes(pl->link_config.interface),
+		    __ETHTOOL_LINK_MODE_MASK_NBITS, pl->link_config.advertising,
+		    pl->link_config.pause);
+
+	/* Modern PCS-based method; update the advert at the PCS, and
+	 * restart negotiation if the pcs_config() helper indicates that
+	 * the programmed advertisement has changed.
+	 */
+	ret = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
+				      pl->link_config.interface,
+				      pl->link_config.advertising,
+				      !!(pl->link_config.pause & MLO_PAUSE_AN));
+	if (ret < 0)
+		return ret;
+
+	if (ret > 0)
+		phylink_mac_pcs_an_restart(pl);
+
+	return 0;
+}
+
 static void phylink_mac_pcs_get_state(struct phylink *pl,
 				      struct phylink_link_state *state)
 {
@@ -1525,9 +1570,11 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 
 	config->pause = pause_state;
 
-	if (!pl->phydev && !test_bit(PHYLINK_DISABLE_STOPPED,
-				     &pl->phylink_disable_state))
-		phylink_pcs_config(pl, true, &pl->link_config);
+	/* Update our in-band advertisement, triggering a renegotiation if
+	 * the advertisement changed.
+	 */
+	if (!pl->phydev)
+		phylink_change_inband_advert(pl);
 
 	mutex_unlock(&pl->state_mutex);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index b32b8b45421b..d9913d8e6b91 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -286,7 +286,8 @@ struct phylink_pcs_ops {
 			      struct phylink_link_state *state);
 	int (*pcs_config)(struct phylink_config *config, unsigned int mode,
 			  phy_interface_t interface,
-			  const unsigned long *advertising);
+			  const unsigned long *advertising,
+			  bool permit_pause_to_mac);
 	void (*pcs_an_restart)(struct phylink_config *config);
 	void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex);
@@ -317,9 +318,11 @@ void pcs_get_state(struct phylink_config *config,
  * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
  * @interface: interface mode to be used
  * @advertising: adertisement ethtool link mode mask
+ * @permit_pause_to_mac: permit forwarding pause resolution to MAC
  *
  * Configure the PCS for the operating mode, the interface mode, and set
- * the advertisement mask.
+ * the advertisement mask. @permit_pause_to_mac indicates whether the
+ * hardware may forward the pause mode resolution to the MAC.
  *
  * When operating in %MLO_AN_INBAND, inband should always be enabled,
  * otherwise inband should be disabled.
-- 
2.20.1

