Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A43545CB79
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350037AbhKXR45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350061AbhKXR4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:56:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C24C061757
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8bmHlukqPEMjCX1KKqdy4+ziV2fvo1J+jdlZwVNd5vg=; b=UxEa2kzXqdkpbP6tBhfJQfPhND
        6rqftQwujFXk9imwOLblwJUs6Dk9JQsLzigh7NnLeAEp+nOWtkI9ZR/F6AHuepTDsABwaKklzbcTx
        gseHqThIttQE5DKrWJGTUWg+I7HrLzpMqxh4H1+amjKniW/EiUah0TO1CPr52vU0M11HY6PHl6+QI
        4OkZbfFaurZLui/cTXPK5lGAzBaKnjiSRGtVOhRnRvUYI8Qckd6RLjxGD5PpIRvIzumPN0Z8FiFPv
        IkMSWYJYPLnzozG23UzPIT5OuRsdf2iHdFQKtvtZL/Y7zgjxFJXbNgp6Yva2s0dHs5QgaZUFywcmq
        jUJSYoZQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49540 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwST-0000z6-3O; Wed, 24 Nov 2021 17:53:25 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwSS-00D8M5-K7; Wed, 24 Nov 2021 17:53:24 +0000
In-Reply-To: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH RFC net-next 12/12] net: dsa: xrs700x: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwSS-00D8M5-K7@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:53:24 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the xrs700x
family of DSA switches and remove the old validate implementation to
allow DSA to use phylink_generic_validate() for this switch driver.

According to commit ee00b24f32eb ("net: dsa: add Arrow SpeedChips
XRS700x driver") the switch supports one RMII port and up to three
RGMII ports. This commit assumes that port 0 is the RMII port and the
remainder are RGMII.

This commit also results in the Autoneg bit being set in the ethtool
link modes, which wasn't in the original; if this switch supports
RGMII to a 10/100/1G PHY, then surely we want to allow Autoneg on the
PHY.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/xrs700x/xrs700x.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 910fcb3b252b..7a6cfa41900f 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -441,34 +441,27 @@ static void xrs700x_teardown(struct dsa_switch *ds)
 	cancel_delayed_work_sync(&priv->mib_work);
 }
 
-static void xrs700x_phylink_validate(struct dsa_switch *ds, int port,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
+static void xrs700x_phylink_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
 	switch (port) {
 	case 0:
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
+		config->mac_capabilities = MAC_10FD | MAC_100FD;
 		break;
+
 	case 1:
 	case 2:
 	case 3:
-		phylink_set(mask, 1000baseT_Full);
+		phy_interface_set_rgmii(config->supported_interfaces);
+		config->mac_capabilities = MAC_10FD | MAC_100FD | MAC_1000FD;
 		break;
+
 	default:
-		linkmode_zero(supported);
 		dev_err(ds->dev, "Unsupported port: %i\n", port);
-		return;
+		break;
 	}
-
-	phylink_set_port_modes(mask);
-
-	/* The switch only supports full duplex. */
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Full);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void xrs700x_mac_link_up(struct dsa_switch *ds, int port,
@@ -702,7 +695,7 @@ static const struct dsa_switch_ops xrs700x_ops = {
 	.setup			= xrs700x_setup,
 	.teardown		= xrs700x_teardown,
 	.port_stp_state_set	= xrs700x_port_stp_state_set,
-	.phylink_validate	= xrs700x_phylink_validate,
+	.phylink_get_caps	= xrs700x_phylink_get_caps,
 	.phylink_mac_link_up	= xrs700x_mac_link_up,
 	.get_strings		= xrs700x_get_strings,
 	.get_sset_count		= xrs700x_get_sset_count,
-- 
2.30.2

