Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D280452E9C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhKPKFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhKPKFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:05:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C896C061746
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KxgVXg7mT34lGPyCM109JVFlIcyhOsaKeUW5RXee1mg=; b=XFghwhHadK05FwTyNvHuQ+plXx
        er/dy7HMwxtM7SitjgwRw4IFT4wFkHxRro+8TMAxQM41LHAwNblZydFMiqeHNx/mVc+5p5SxLyLds
        YJeuLLM+kLucVMCycgOM4fIixdZpxGL5bh4BaDewMbL/X68f7q0uWZBTFvl71GVwGfzet1bdyzrdh
        KKEuJqYOnSXnEmVewj+iSUrrPfCIGf/3pNQQYxgZ8FKVcQgFBqxpRUA/Fz7TYINhHJkIh6J1+Mtbv
        yzVS0lEVMWGnqGBYFBgZPxpRduiB1FGJsqtMFvDzApVM4oCr9cRYjmVNin0IS8AqBYqlxEVFl8o6d
        aAC4QwOA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39830 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvHz-0000KO-59; Tue, 16 Nov 2021 10:02:07 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvHy-0078WI-Nk; Tue, 16 Nov 2021 10:02:06 +0000
In-Reply-To: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
References: <YZOBiFK8DkYUSRml@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 2/3] net: sparx5: clean up sparx5_phylink_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvHy-0078WI-Nk@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:02:06 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sparx5_phylink_validate() no longer needs to check for
PHY_INTERFACE_MODE_NA as phylink will walk the supported interface
types to discover the link mode capabilities. Neither is it necessary
to check the device capabilities as we will not be called for
unsupported interface modes. Remove these checks.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../microchip/sparx5/sparx5_phylink.c         | 63 +++++++------------
 1 file changed, 24 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
index fb74752de0ca..e77ddded4811 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -30,7 +30,6 @@ static void sparx5_phylink_validate(struct phylink_config *config,
 				    unsigned long *supported,
 				    struct phylink_link_state *state)
 {
-	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	phylink_set(mask, Autoneg);
@@ -40,34 +39,23 @@ static void sparx5_phylink_validate(struct phylink_config *config,
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_5GBASER:
+		phylink_set(mask, 5000baseT_Full);
+		break;
+
 	case PHY_INTERFACE_MODE_10GBASER:
+		phylink_set(mask, 10000baseT_Full);
+		phylink_set(mask, 10000baseCR_Full);
+		phylink_set(mask, 10000baseSR_Full);
+		phylink_set(mask, 10000baseLR_Full);
+		phylink_set(mask, 10000baseLRM_Full);
+		phylink_set(mask, 10000baseER_Full);
+		break;
+
 	case PHY_INTERFACE_MODE_25GBASER:
-	case PHY_INTERFACE_MODE_NA:
-		if (port->conf.bandwidth == SPEED_5000)
-			phylink_set(mask, 5000baseT_Full);
-		if (port->conf.bandwidth == SPEED_10000) {
-			phylink_set(mask, 5000baseT_Full);
-			phylink_set(mask, 10000baseT_Full);
-			phylink_set(mask, 10000baseCR_Full);
-			phylink_set(mask, 10000baseSR_Full);
-			phylink_set(mask, 10000baseLR_Full);
-			phylink_set(mask, 10000baseLRM_Full);
-			phylink_set(mask, 10000baseER_Full);
-		}
-		if (port->conf.bandwidth == SPEED_25000) {
-			phylink_set(mask, 5000baseT_Full);
-			phylink_set(mask, 10000baseT_Full);
-			phylink_set(mask, 10000baseCR_Full);
-			phylink_set(mask, 10000baseSR_Full);
-			phylink_set(mask, 10000baseLR_Full);
-			phylink_set(mask, 10000baseLRM_Full);
-			phylink_set(mask, 10000baseER_Full);
-			phylink_set(mask, 25000baseCR_Full);
-			phylink_set(mask, 25000baseSR_Full);
-		}
-		if (state->interface != PHY_INTERFACE_MODE_NA)
-			break;
-		fallthrough;
+		phylink_set(mask, 25000baseCR_Full);
+		phylink_set(mask, 25000baseSR_Full);
+		break;
+
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
 		phylink_set(mask, 10baseT_Half);
@@ -76,21 +64,18 @@ static void sparx5_phylink_validate(struct phylink_config *config,
 		phylink_set(mask, 100baseT_Full);
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
-		if (state->interface != PHY_INTERFACE_MODE_NA)
-			break;
-		fallthrough;
+		break;
+
 	case PHY_INTERFACE_MODE_1000BASEX:
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+		break;
+
 	case PHY_INTERFACE_MODE_2500BASEX:
-		if (state->interface != PHY_INTERFACE_MODE_2500BASEX) {
-			phylink_set(mask, 1000baseT_Full);
-			phylink_set(mask, 1000baseX_Full);
-		}
-		if (state->interface == PHY_INTERFACE_MODE_2500BASEX ||
-		    state->interface == PHY_INTERFACE_MODE_NA) {
-			phylink_set(mask, 2500baseT_Full);
-			phylink_set(mask, 2500baseX_Full);
-		}
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
 		break;
+
 	default:
 		linkmode_zero(supported);
 		return;
-- 
2.30.2

