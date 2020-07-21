Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E093227E0A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgGULEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgGULEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:04:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FCDC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E/tzKOtzXfn9USd1QNNerSLlsiIbtry/I2uCYFO9/uE=; b=KRaVuHZR925KYn46u3XckNAVNR
        A93EJ2xl66dZLdQxz4ObYC3XMwFmzLmcFj8bP1x5krJBpFHb2IpahsXiogL32Sh89XTE0HJBiHlrM
        a/bPRwSS9HmisXMvzQy6cCU8ENbSQ5kymO3sZ//cCG1kp2B1lEJK3Aofi93DdTdFh+1Yiq6X/AKkh
        k8buqC1KeTXAkT0qy5q++iPJLH31HZgnauIYV3ak29c/vCKZ5u2rtzf6SPa1zYTTPxniWYGjGksT5
        Le3bWClnswzJxCucbzpt/7bJNVZMoc7pGnEDhHgBzdf+3W67L+eP2j9SNDfxB4m+/LGYkmQV4eiAz
        BKrMjEYw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41774 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4V-0004GL-JP; Tue, 21 Jul 2020 12:04:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4V-0004Sm-CV; Tue, 21 Jul 2020 12:04:31 +0100
In-Reply-To: <20200721110152.GY1551@shell.armlinux.org.uk>
References: <20200721110152.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/14] net: phylink: simplify fixed-link case for
 ksettings_set method
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq4V-0004Sm-CV@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:04:31 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For fixed links, we only allow the current settings, so this should be
a matter of merely rejecting an attempt to change the settings.  If the
settings agree, then there is nothing more we need to do.

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6cb9ca74341b..452d509803ca 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1360,22 +1360,31 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		if (!s)
 			return -EINVAL;
 
-		/* If we have a fixed link (as specified by firmware), refuse
-		 * to change link parameters.
+		/* If we have a fixed link, refuse to change link parameters.
+		 * If the link parameters match, accept them but do nothing.
 		 */
-		if (pl->cur_link_an_mode == MLO_AN_FIXED &&
-		    (s->speed != pl->link_config.speed ||
-		     s->duplex != pl->link_config.duplex))
-			return -EINVAL;
+		if (pl->cur_link_an_mode == MLO_AN_FIXED) {
+			if (s->speed != pl->link_config.speed ||
+			    s->duplex != pl->link_config.duplex)
+				return -EINVAL;
+			return 0;
+		}
 
 		config.speed = s->speed;
 		config.duplex = s->duplex;
 		break;
 
 	case AUTONEG_ENABLE:
-		/* If we have a fixed link, refuse to enable autonegotiation */
-		if (pl->cur_link_an_mode == MLO_AN_FIXED)
-			return -EINVAL;
+		/* If we have a fixed link, allow autonegotiation (since that
+		 * is our default case) but do not allow the advertisement to
+		 * be changed. If the advertisement matches, simply return.
+		 */
+		if (pl->cur_link_an_mode == MLO_AN_FIXED) {
+			if (!linkmode_equal(config.advertising,
+					    pl->link_config.advertising))
+				return -EINVAL;
+			return 0;
+		}
 
 		config.speed = SPEED_UNKNOWN;
 		config.duplex = DUPLEX_UNKNOWN;
@@ -1385,8 +1394,8 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		return -EINVAL;
 	}
 
-	/* For a fixed link, this isn't able to change any parameters,
-	 * which just leaves inband mode.
+	/* We have ruled out the case with a PHY attached, and the
+	 * fixed-link cases.  All that is left are in-band links.
 	 */
 	if (phylink_validate(pl, support, &config))
 		return -EINVAL;
-- 
2.20.1

