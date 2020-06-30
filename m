Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634E120F738
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388990AbgF3O3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgF3O3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:29:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7636AC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6W1I88WGshiq243j7m7ZmNGQDYe5ytB4FUIRYfi3dpw=; b=NjPjzHgFcEmKkBRnXGjeh/+v+t
        qbPbEo57+dVfVr10To4dN0O7tB4k5f5LsgjJEQif4w2YPuZkemj9KPVXKgxERR/OiQRz1zYA22u/L
        Dotgi4uNm56NqyFju94BjsqO5qNe9YzyB/CiuA1Gxwj6ipBnY9dyaZ+9s6NRDlOzW34u7v0d/ol2D
        wphCcz/6s4r8oQUQgO8zys9uitsp59DZHW1tF81HYnIRvagh/HEOLNd3tC+h3/JfSVVfdlRr+BAXc
        5Z9UpYU5TlZTGC7X3czHdyi5mkgfODQ64Izqf0EYtUEcjJGA5kOqYlZDvQru2+VcVcKPjt6GtpO3c
        82bOKq0Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47266 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFo-0000eJ-Hw; Tue, 30 Jun 2020 15:28:56 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFo-0006Ot-Ac; Tue, 30 Jun 2020 15:28:56 +0100
In-Reply-To: <20200630142754.GC1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 05/13] net: phylink: update PCS when changing
 interface during resolution
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqHFo-0006Ot-Ac@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 15:28:56 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only PHYs that are used with phylink which change their interface
are the BCM84881 and MV88X3310 family, both of which only change their
interface modes on link-up events.  This will break when drivers are
converted to split-PCS.  Fix this.

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

