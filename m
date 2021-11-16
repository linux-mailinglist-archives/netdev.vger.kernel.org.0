Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337F9452EB5
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhKPKMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbhKPKMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:12:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615FAC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=N++MVuKPi4PnLapG0hp7YcjRlp2+KnA4ahYZsWusP/Q=; b=dQikKZFc0bfK6VnnHC2ZF6akjl
        H9aBe8Iy5Xf+tw2HR63g5STtxIagVCbXdQi8URU+bfbYGJfzMb0B7mqKP0qAQ4TgsoFwlDC4gJb0f
        oyTN/AqgGeMcQP0MqJOk9d/cH6Kfy1khFlVSO/BB95Ct0Xk0J0LTr39ydEDwL9dUUA69eQckEwYE/
        42O1QcXzoVpGv+t+H7kncXWVJw1m4KOcPlqU1GExABDwdzxHNFTtpCAIFbOJcBNDLqZ1uf9IgmuOd
        Y/RmDDvlyCw6+aB1+Ox8vikL8x7DBF9E5N/TjrTz0WTuNiXU4pWDij5IX6MxNkPSonm4EnXcT9YYH
        IcNWTNvA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39856 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvPJ-0000OD-T8; Tue, 16 Nov 2021 10:09:41 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvPJ-0078fj-FA; Tue, 16 Nov 2021 10:09:41 +0000
In-Reply-To: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
References: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: ocelot_net: use phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvPJ-0078fj-FA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:09:41 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_net has no special behaviour in its validation implementation, so
can be switched to phylink_generic_validate().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 29 +++-----------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 21df548dcf64..0fcf359a6975 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1498,31 +1498,6 @@ struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
 	.notifier_call = ocelot_switchdev_blocking_event,
 };
 
-static void vsc7514_phylink_validate(struct phylink_config *config,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = {};
-
-	phylink_set_port_modes(mask);
-
-	phylink_set(mask, Pause);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 1000baseT_Half);
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseX_Full);
-	phylink_set(mask, 2500baseT_Full);
-	phylink_set(mask, 2500baseX_Full);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 static void vsc7514_phylink_mac_config(struct phylink_config *config,
 				       unsigned int link_an_mode,
 				       const struct phylink_link_state *state)
@@ -1581,7 +1556,7 @@ static void vsc7514_phylink_mac_link_up(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops ocelot_phylink_ops = {
-	.validate		= vsc7514_phylink_validate,
+	.validate		= phylink_generic_validate,
 	.mac_config		= vsc7514_phylink_mac_config,
 	.mac_link_down		= vsc7514_phylink_mac_link_down,
 	.mac_link_up		= vsc7514_phylink_mac_link_up,
@@ -1645,6 +1620,8 @@ static int ocelot_port_phylink_create(struct ocelot *ocelot, int port,
 
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
+	priv->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD;
 
 	__set_bit(ocelot_port->phy_mode,
 		  priv->phylink_config.supported_interfaces);
-- 
2.30.2

