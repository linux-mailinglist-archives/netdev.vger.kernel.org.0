Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28DF227E05
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgGULEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbgGULEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:04:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606B2C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ts7EeotYO9oloR6fBRnJaK+id7Sxqw/m555A9g9nLBw=; b=KiT5nFLYLu4TQ5ODN0w9zMR9Ya
        beux3wlLtPPSubz0JlinzzVKmuQhMuOgw0ssOA42piBps65PSOsVWcXnK9PHgJESgDp6GW3wcNY1D
        10+Om50/UPZ69ZoEsp1SNRUgTSO1oCiBo7a6190prXq9JMjhNkp8pGBEyStR/VlM47/T0nGOolx1M
        C52YMQIZi6VTZnEuzYCzdSlsq1wKcIO2wGZrEa3E76rgthhj1sFvw8cwF/TImcSZZfWLH8jaGIw3q
        IwXzGgzwH2k5yhRcg5Ibk0FQ1JmRge2S1nLUETE8GJJHhy2OGLbZ/EsQRKZ4gySp6guPJ3WwUJtj7
        1pnKRmqQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41762 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq46-0004F3-1A; Tue, 21 Jul 2020 12:04:06 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq45-0004Rh-QB; Tue, 21 Jul 2020 12:04:05 +0100
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
Subject: [PATCH net-next 05/14] net: phylink: update PCS when changing
 interface during resolution
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq45-0004Rh-QB@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:04:05 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only PHYs that are used with phylink which change their interface
are the BCM84881 and MV88X3310 family, both of which only change their
interface modes on link-up events.  This will break when drivers are
converted to split-PCS.  Fix this.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1507ea8a9385..f1693ec63366 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -629,8 +629,15 @@ static void phylink_resolve(struct work_struct *w)
 				phylink_link_down(pl);
 				cur_link_state = false;
 			}
+			phylink_pcs_config(pl, false, &link_state);
+			pl->link_config.interface = link_state.interface;
+		} else {
+			/* The interface remains unchanged, only the speed,
+			 * duplex or pause settings have changed. Call the
+			 * old mac_config() method to configure the MAC/PCS.
+			 */
+			phylink_mac_config(pl, &link_state);
 		}
-		phylink_mac_config(pl, &link_state);
 	}
 
 	if (link_state.link != cur_link_state) {
-- 
2.20.1

