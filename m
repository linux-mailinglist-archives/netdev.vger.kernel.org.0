Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D3520F737
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388985AbgF3O25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgF3O24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:28:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB697C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=f4iJ8XTNWdhSYBoqUClvdXprLvE0LDsKt204zIpPaJQ=; b=a3alhMBcXw0POQqKOLjzZhGJXK
        AxkqqYMEM3wM30IQ0xFivMYyXqGaWhdE9frHX62GWqB2JPuTPPA2pn+HhckReazkhgL/8u/MJjeqG
        8I/NdzmlMhEuAvLNx+8f+/Z3Nccclla+NyhbkfJMm4L5DyskaZ1XWP7otgIp+cmIbrVJgWnl4s752
        reSDrevTh9YSQHkAvFtLqyh4Dpjq2YbZ8jmwN1tnRlIcHTFW+idoID9kSm6Evba9sO0N1AIc7290P
        FDOQY+5IuHYv1EwLEAihXRApR+tdZb4lHJYxj/cKBUgHEyXQMH0d3+Mz1PM5701vZuTdk9WXXoyg8
        soSs8UkQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47264 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFj-0000e3-Dn; Tue, 30 Jun 2020 15:28:51 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFj-0006Og-5E; Tue, 30 Jun 2020 15:28:51 +0100
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
Subject: [PATCH RFC net-next 04/13] net: phylink: ensure link is down when
 changing interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqHFj-0006Og-5E@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 15:28:51 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only PHYs that are used with phylink which change their interface
are the BCM84881 and MV88X3310 family, both of which only change their
interface modes on link-up events.  However, rather than relying upon
this behaviour by the PHY, we should give a stronger guarantee when
resolving that the link will be down whenever we change the interface
mode.  This patch implements that stronger guarantee for resolve.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8ffe5df5c296..1507ea8a9385 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -620,8 +620,18 @@ static void phylink_resolve(struct work_struct *w)
 		}
 	}
 
-	if (mac_config)
+	if (mac_config) {
+		if (link_state.interface != pl->link_config.interface) {
+			/* The interface has changed, force the link down and
+			 * then reconfigure.
+			 */
+			if (cur_link_state) {
+				phylink_link_down(pl);
+				cur_link_state = false;
+			}
+		}
 		phylink_mac_config(pl, &link_state);
+	}
 
 	if (link_state.link != cur_link_state) {
 		pl->old_link_state = link_state.link;
-- 
2.20.1

