Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9075C4C4A18
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbiBYQHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239075AbiBYQHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:07:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB15A21131E
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YIpDc3yegHwwo44ZYd6EawMHMos5VGkzXqJknoaRyHg=; b=nuucN4Y/CrZF/+/l49yI+WIM/2
        6z0/9qmDzUDIzFWl5JigLNUXTrp6VVt74Fft1ZjO1eEkHk7Ixinuk95Xwr5u0ue/wlCz0tm9gELa2
        FFQW3EJGJda5kiSXnwhBJcEmfRJHTlcb/W08LJBTsZwvGzMlcJ6aXlTrT7QygEz8WVT3OE0JdP2bN
        VuY8xnw+s2WbQDgi3N+3vEXH6rnqhkleGG7Ympp1VoQuymU7f2miKyM/f9FPvO49zBs3jMbm+tKlY
        uHuISaz2Fl5vpX54RdogNdVgl1HA7iLflikRGPGH6Bop+KljNnb7n42w3OHBHlJ+l0X27hTwksPv3
        mpPfIf3w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47510 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNd77-0005f8-5H; Fri, 25 Feb 2022 16:06:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNd76-00Anzt-IH; Fri, 25 Feb 2022 16:06:36 +0000
In-Reply-To: <Yhj+NnrggVRPmlT8@shell.armlinux.org.uk>
References: <Yhj+NnrggVRPmlT8@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: dsa: ocelot: populate supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNd76-00Anzt-IH@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 16:06:36 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces bitmap for the Ocelot DSA switches.

Since all sub-drivers only support a single interface mode, defined by
ocelot_port->phy_mode, we can handle this in the main driver code
without reference to the sub-driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/ocelot/felix.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9959407fede8..88fbbd03c81b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -778,6 +778,15 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 	return ocelot_vlan_del(ocelot, port, vlan->vid);
 }
 
+static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
+				   struct phylink_config *config)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	__set_bit(ocelot->ports[port].phy_mode,
+		  config->supported_interfaces);
+}
+
 static void felix_phylink_validate(struct dsa_switch *ds, int port,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
@@ -1587,6 +1596,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.get_ethtool_stats		= felix_get_ethtool_stats,
 	.get_sset_count			= felix_get_sset_count,
 	.get_ts_info			= felix_get_ts_info,
+	.phylink_get_caps		= felix_phylink_get_caps,
 	.phylink_validate		= felix_phylink_validate,
 	.phylink_mac_config		= felix_phylink_mac_config,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
-- 
2.30.2

