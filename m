Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607B345CB6D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349930AbhKXR4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349906AbhKXR4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:56:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8706DC061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ixC9lbMIAL8jpneUzGUybm5Q4tL2tORexx6tJ3IBO3o=; b=TPxOr1QHkwo4fgygdtInZVcquk
        Tb1jUi7E9HYajiqnTiTt8IliFoNdXJ/TWg7JQwgawROiRcVFZhgezkAKrrakjKzlVJPask+ms3Erk
        sMQrGkPP6ceWVjIztgt1vY6acpzn7LXkJwdM7dXM1OZ0iIp3Tm5/Ri0DcBI0JiE3DSDuCPDnX+naB
        /8JV7qKYLM9YsqaoNJ6h7yPYRxXJ5QTFupBzfILFpyEt9iMlxVYN6ECMBG3ycpuMN18lYVYJtN/Oj
        uMdBRzV9G65PW8tfXhANxTZIm0DnMYJFthav+yMq7Q21bbNWsNGVOu6y7vBUG9SalPF8sQHqocIue
        Yd2FudZg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49526 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRy-0000xT-9r; Wed, 24 Nov 2021 17:52:54 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRx-00D8LQ-RG; Wed, 24 Nov 2021 17:52:53 +0000
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
Subject: [PATCH RFC net-next 06/12] net: dsa: hellcreek: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwRx-00D8LQ-RG@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:52:53 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the
hellcreek DSA switch and remove the old validate implementation to
allow DSA to use phylink_generic_validate() for this switch driver.

The switch actually only supports MII and RGMII, but as phylib defaults
to GMII, we need to include this interface mode to keep existing DT
working.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 4e0b53d94b52..86839b43011b 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1384,14 +1384,19 @@ static void hellcreek_teardown(struct dsa_switch *ds)
 	dsa_devlink_resources_unregister(ds);
 }
 
-static void hellcreek_phylink_validate(struct dsa_switch *ds, int port,
-				       unsigned long *supported,
-				       struct phylink_link_state *state)
+static void hellcreek_phylink_get_caps(struct dsa_switch *ds, int port,
+				       struct phylink_config *config)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct hellcreek *hellcreek = ds->priv;
 
-	dev_dbg(hellcreek->dev, "Phylink validate for port %d\n", port);
+	__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_RGMII, config->supported_interfaces);
+
+	/* Include GMII - the hardware does not support this interface
+	 * mode, but it's the default interface mode for phylib, so we
+	 * need it for compatibility with existing DT.
+	 */
+	__set_bit(PHY_INTERFACE_MODE_GMII, config->supported_interfaces);
 
 	/* The MAC settings are a hardware configuration option and cannot be
 	 * changed at run time or by strapping. Therefore the attached PHYs
@@ -1399,12 +1404,9 @@ static void hellcreek_phylink_validate(struct dsa_switch *ds, int port,
 	 * by the hardware.
 	 */
 	if (hellcreek->pdata->is_100_mbits)
-		phylink_set(mask, 100baseT_Full);
+		config->mac_capabilities = MAC_100FD;
 	else
-		phylink_set(mask, 1000baseT_Full);
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
+		config->mac_capabilities = MAC_1000FD;
 }
 
 static int
@@ -1755,7 +1757,7 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.get_strings	       = hellcreek_get_strings,
 	.get_tag_protocol      = hellcreek_get_tag_protocol,
 	.get_ts_info	       = hellcreek_get_ts_info,
-	.phylink_validate      = hellcreek_phylink_validate,
+	.phylink_get_caps      = hellcreek_phylink_get_caps,
 	.port_bridge_flags     = hellcreek_bridge_flags,
 	.port_bridge_join      = hellcreek_port_bridge_join,
 	.port_bridge_leave     = hellcreek_port_bridge_leave,
-- 
2.30.2

