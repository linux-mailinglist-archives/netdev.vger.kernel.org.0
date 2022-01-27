Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5984149E014
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbiA0LCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbiA0LCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:02:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5422EC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=j3/Imnb3qWg1YKIuMQspCS4JLJ0anduqZBQSIIzRBFY=; b=etAEk8tM481jgMKEAfd+XOmkhT
        jSyW0dscFTm1YVWJsddG5hs7iCBy7dDIunMcaEZXo5PJOXJgEAvGl79Q47U8k4k7ensHp032vBZdC
        CZc/MNru0h3Ttz/v6BCtlwqxUT5AHIuMDhWKNdQSeFQu24SKcmEhHG3Qdt2wdDeprSFgP1WKuvg2n
        EVL5j9U1hWTCB8pVJa5NGsvs55lzhjcms9EGUJO7168H9gC8/iRgPwbuumuSAeDcdztDhFd+nfx8s
        NQCceG3+j+RxZqiCANMQddf0VzcK1W5jTNGK3K4noWOku03R1eV5O26pJhGKuVeTMdD0qPkLnYByd
        huyl3uwA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43570 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nD2Xe-0004M2-Rn; Thu, 27 Jan 2022 11:02:14 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nD2Xe-005UcF-8m; Thu, 27 Jan 2022 11:02:14 +0000
In-Reply-To: <YfJ7omKUSF6BY+CL@shell.armlinux.org.uk>
References: <YfJ7omKUSF6BY+CL@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH CFT net-next 1/5] net: dsa: ar9331: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nD2Xe-005UcF-8m@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Jan 2022 11:02:14 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the AR9331
DSA switch and remove the old validate implementation to allow DSA to
use phylink_generic_validate() for this switch driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca/ar9331.c | 45 ++++++++----------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index da0d7e68643a..3bda7015f0c1 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -499,52 +499,27 @@ static enum dsa_tag_protocol ar9331_sw_get_tag_protocol(struct dsa_switch *ds,
 	return DSA_TAG_PROTO_AR9331;
 }
 
-static void ar9331_sw_phylink_validate(struct dsa_switch *ds, int port,
-				       unsigned long *supported,
-				       struct phylink_link_state *state)
+static void ar9331_sw_phylink_get_caps(struct dsa_switch *ds, int port,
+				       struct phylink_config *config)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100;
 
 	switch (port) {
 	case 0:
-		if (state->interface != PHY_INTERFACE_MODE_GMII)
-			goto unsupported;
-
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseT_Half);
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+		config->mac_capabilities |= MAC_1000;
 		break;
 	case 1:
 	case 2:
 	case 3:
 	case 4:
 	case 5:
-		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
-			goto unsupported;
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
 		break;
-	default:
-		linkmode_zero(supported);
-		dev_err(ds->dev, "Unsupported port: %i\n", port);
-		return;
 	}
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-
-	return;
-
-unsupported:
-	linkmode_zero(supported);
-	dev_err(ds->dev, "Unsupported interface: %d, port: %d\n",
-		state->interface, port);
 }
 
 static void ar9331_sw_phylink_mac_config(struct dsa_switch *ds, int port,
@@ -697,7 +672,7 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
 	.port_disable		= ar9331_sw_port_disable,
-	.phylink_validate	= ar9331_sw_phylink_validate,
+	.phylink_get_caps	= ar9331_sw_phylink_get_caps,
 	.phylink_mac_config	= ar9331_sw_phylink_mac_config,
 	.phylink_mac_link_down	= ar9331_sw_phylink_mac_link_down,
 	.phylink_mac_link_up	= ar9331_sw_phylink_mac_link_up,
-- 
2.30.2

