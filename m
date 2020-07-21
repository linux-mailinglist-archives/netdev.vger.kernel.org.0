Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCCE227E04
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgGULEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729469AbgGULEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:04:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F7BC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vCW+j/j1peLzr1eWCV7c2mJ15Y3zdDfZXpLSL57hbs8=; b=iCXyya12EQljBD9rEu1HgOc39x
        1kKYaaTdiLQSqcDxZ5lIQ7Hxs2FyCXrxVMc1Q4rAOS173g9sz4tUpeGcnRaL9X3AykANtCj7N81Fq
        Y7R+5DTpfFRbwesxfu0m0ko/c5d34zQtRaMnA6DtG5w7NcTAapvalQ7C/OZm5v9XfYNYs6YjgVNXj
        Ec5CxVupuhZ+NOd0yksnUwocA/B7Qrfpao4oYMg/uAOtnJFlXNpL53oUSDli8PP4PZlKy1VBOwiwv
        SZCCk9UF1Lz5nHT33/OGeW6vm5OtrIFYtlAxY/VRqu5A998f0fdJLR2WBw2aWvOfRjil8janHDa8+
        JBLUcv5g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41760 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq40-0004En-TP; Tue, 21 Jul 2020 12:04:00 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq40-0004RU-MW; Tue, 21 Jul 2020 12:04:00 +0100
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
Subject: [PATCH net-next 04/14] net: phylink: ensure link is down when
 changing interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq40-0004RU-MW@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:04:00 +0100
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

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

