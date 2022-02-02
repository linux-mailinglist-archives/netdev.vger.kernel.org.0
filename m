Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA40C4A75C7
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiBBQ3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiBBQ3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:29:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409E3C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 08:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dX1e3Nz967zNd88Noseq10yvF2rReoRyJ/7uQ0W9LaM=; b=TLpVFMdsbaXGRV7v7hk1FF/IP8
        FdfAG4AMfplLVEyQvuZ4ELjg1l3ZOkYi5OEj6K00kl0zZ7TnZmaYM40F8amXpHm92DCy3eFVK/LNk
        YpS/VJlXChUpDpPRIYzDXuBGVruPCPO7LVJfECwFjVia3xy5+tLTWOqWVVN9NFVmDCY74LBmUR5Xn
        bf7nHWxTqIfcILBJzMeXeFhFqlUJ+s2g5m1GSN++s1Dao4Xikxul+5/MBG1wcdOTM/o3CkCan0qXJ
        GE+xy83Zl15aie78ypDNgV9E9b36/okzgS5CSlFEP96FHEQGCGqgdNq+HOWQc6VClAiyNQrsOTxFl
        9J4vs6Sw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49410 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFIVZ-0001m6-Ng; Wed, 02 Feb 2022 16:29:25 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFIVZ-006Lgp-0o; Wed, 02 Feb 2022 16:29:25 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: realtek: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFIVZ-006Lgp-0o@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 02 Feb 2022 16:29:25 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the Realtek
rtl8365 DSA switch and remove the old validate implementation to allow
DSA to use phylink_generic_validate() for this switch driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
I seem to have missed this driver, so here's an update for it - but only
build tested.

 drivers/net/dsa/realtek/rtl8365mb.c | 46 ++++++++---------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index e1c5a67a21c4..2ed592147c20 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -952,39 +952,17 @@ static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
 	return false;
 }
 
-static void rtl8365mb_phylink_validate(struct dsa_switch *ds, int port,
-				       unsigned long *supported,
-				       struct phylink_link_state *state)
+static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
+				       struct phylink_config *config)
 {
-	struct realtek_priv *priv = ds->priv;
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0 };
-
-	/* include/linux/phylink.h says:
-	 *     When @state->interface is %PHY_INTERFACE_MODE_NA, phylink
-	 *     expects the MAC driver to return all supported link modes.
-	 */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    !rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
-		dev_err(priv->dev, "phy mode %s is unsupported on port %d\n",
-			phy_modes(state->interface), port);
-		linkmode_zero(supported);
-		return;
-	}
-
-	phylink_set_port_modes(mask);
-
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 1000baseT_Full);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+	if (dsa_is_user_port(ds, port))
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+	else if (dsa_is_cpu_port(ds, port))
+		phy_interface_set_rgmii(config->supported_interfaces);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
+				   MAC_10 | MAC_100 | MAC_1000FD;
 }
 
 static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
@@ -2020,7 +1998,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
-	.phylink_validate = rtl8365mb_phylink_validate,
+	.phylink_get_caps = rtl8365mb_phylink_get_caps,
 	.phylink_mac_config = rtl8365mb_phylink_mac_config,
 	.phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
 	.phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
@@ -2038,7 +2016,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
-	.phylink_validate = rtl8365mb_phylink_validate,
+	.phylink_get_caps = rtl8365mb_phylink_get_caps,
 	.phylink_mac_config = rtl8365mb_phylink_mac_config,
 	.phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
 	.phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
-- 
2.30.2

