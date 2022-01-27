Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5808049E019
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbiA0LCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239912AbiA0LC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:02:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48F5C061749
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4Di5E1w7ObUAjnFhgjtyr2X5biwECi2MJA8v52fFbTg=; b=nUQzObuD6rFefjejcdI/nto6YM
        wspFXNDVz8f/XUb7QSQd56Eb+aU5TlKEPwNsaZplwc0gn1mUZtMYwnlVlGgVYORlN6pVbGpT7Heoi
        BHUJzTr12lFjVwyXGFfQLjqctCLvbfMVTceeAajzr9LeF47ELePIIZ5rQHwlu7w9+7JywQt5xUJLc
        PHpxc5r2mSo8riXP9dYkgth2nU1836RTXluL5EOTEWWZdf7yghNnEtVXJsOFeCons9Lmlchxx75rR
        UGou5p7F00piXCklthMKd8yveskAtu/kgteLw9FJJ/vNjk9XkvXyfyOQQFf5BJvrZG65MI6slQaUR
        U167OYMQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43574 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nD2Xp-0004MQ-4C; Thu, 27 Jan 2022 11:02:25 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nD2Xo-005UcR-HG; Thu, 27 Jan 2022 11:02:24 +0000
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
Subject: [PATCH CFT net-next 3/5] net: dsa: ksz8795: convert to
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nD2Xo-005UcR-HG@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Jan 2022 11:02:24 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the
Microchip KSZ8795 DSA switch and remove the old validate implementation
to allow DSA to use phylink_generic_validate() for this switch driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/microchip/ksz8795.c | 45 ++++++++---------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 991b9c6b6ce7..5dc9899bc0a6 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1461,27 +1461,22 @@ static int ksz8_setup(struct dsa_switch *ds)
 	return 0;
 }
 
-static void ksz8_validate(struct dsa_switch *ds, int port,
-			  unsigned long *supported,
-			  struct phylink_link_state *state)
+static void ksz8_get_caps(struct dsa_switch *ds, int port,
+			  struct phylink_config *config)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct ksz_device *dev = ds->priv;
 
 	if (port == dev->cpu_port) {
-		if (state->interface != PHY_INTERFACE_MODE_RMII &&
-		    state->interface != PHY_INTERFACE_MODE_MII &&
-		    state->interface != PHY_INTERFACE_MODE_NA)
-			goto unsupported;
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_MII,
+			  config->supported_interfaces);
 	} else {
-		if (state->interface != PHY_INTERFACE_MODE_INTERNAL &&
-		    state->interface != PHY_INTERFACE_MODE_NA)
-			goto unsupported;
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
 	}
 
-	/* Allow all the expected bits */
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
+	config->mac_capabilities = MAC_10 | MAC_100;
 
 	/* Silicon Errata Sheet (DS80000830A):
 	 * "Port 1 does not respond to received flow control PAUSE frames"
@@ -1489,27 +1484,11 @@ static void ksz8_validate(struct dsa_switch *ds, int port,
 	 * switches.
 	 */
 	if (!ksz_is_ksz88x3(dev) || port)
-		phylink_set(mask, Pause);
+		config->mac_capabilities |= MAC_SYM_PAUSE;
 
 	/* Asym pause is not supported on KSZ8863 and KSZ8873 */
 	if (!ksz_is_ksz88x3(dev))
-		phylink_set(mask, Asym_Pause);
-
-	/* 10M and 100M are only supported */
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
-	dev_err(ds->dev, "Unsupported interface: %s, port: %d\n",
-		phy_modes(state->interface), port);
+		config->mac_capabilities |= MAC_ASYM_PAUSE;
 }
 
 static const struct dsa_switch_ops ksz8_switch_ops = {
@@ -1518,7 +1497,7 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
-	.phylink_validate	= ksz8_validate,
+	.phylink_get_caps	= ksz8_get_caps,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz8_get_strings,
-- 
2.30.2

