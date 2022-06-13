Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF145549A2A
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbiFMRgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241900AbiFMRe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:34:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE235A9F
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BfeQeEaR3dnIoWFf03tFG4sJ+0A700KaJng35c36mlY=; b=FIGjUdn95ts0nod8HSyYTS/nbJ
        A/3GYQ4myl/4iB/BuUl0FICA3OjxdEvzrAeN5zoG0JhiyNYohQ9HUh00hUQnj0AQoI1PP64Op2BaT
        KCM+F+9BQILwFreB+LiEAs50S0Cdhn9UYiL4OTZr9HxaHIx64cJQq6Bijv5yL112nicOVmcdNrymm
        0doHt7qm1XnJoEyUkDFa3zyGPiyA3NFxtQ2YFMQlD9V0MIhEpNUNgp7Wl/OZtYATK65LH9of2hup9
        XqoOBO/AMYfOzDjTRzIXCjSUJ71CvPSW0yJ7wLKtUWB0RG7j5TEFcl+nQ+rghLZLxXqf9l/7KQthg
        igIVx9zg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52076 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgA-0001qN-Js; Mon, 13 Jun 2022 14:00:26 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jg9-000JY6-Vx; Mon, 13 Jun 2022 14:00:26 +0100
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
Subject: [PATCH net-next 01/15] net: phylink: fix SGMII inband autoneg enable
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jg9-000JY6-Vx@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:00:25 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are operating in SGMII inband mode, it implies that there is a
PHY connected, and the ethtool advertisement for autoneg applies to
the PHY, not the SGMII link. When in 1000base-X mode, then this applies
to the 802.3z link and needs to be applied to the PCS.

Fix this.

Fixes: 92817dad7dcb ("net: phylink: Support disabling autonegotiation for PCS")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 066684b80919..5bc58e50e318 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3030,7 +3030,9 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 
 	/* Ensure ISOLATE bit is disabled */
 	if (mode == MLO_AN_INBAND &&
-	    linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising))
+	    (interface == PHY_INTERFACE_MODE_SGMII ||
+	     interface == PHY_INTERFACE_MODE_QSGMII ||
+	     linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)))
 		bmcr = BMCR_ANENABLE;
 	else
 		bmcr = 0;
-- 
2.30.2

