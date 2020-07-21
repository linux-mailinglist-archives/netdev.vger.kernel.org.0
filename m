Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAED227E06
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgGULEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbgGULEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:04:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D04C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZmDAWBmQ1mjEVOy/XSV4DqY6vdMpujLrr9X0uNnvqbc=; b=BeMPrMXve6UxiVeNJCcFYDQUzk
        zXTtSUFxzP/im+nCR/+r5qrIv+6UzXaNOFnGhNgVM+xnahm3SWdLG/lZLQIrFPbPQ8mpIUyba3rm1
        CLjBKaDdrYzwWqyLQsLG+vBMCFQPJCCdeDZke5hj2xxsjzONN+Gf4/w+mYKwTsDKv8TMqcnZpbcG9
        0mrzrheze4l8uUGy8KabJI4XgweeTxzz7ChpK+xwGH7EZ7BAv3AWEaeleHeyrmiLuopGQKhuEtU0p
        YeyIg8Q+Y1yg77NC48Rc7rBUeOn3TqwLoSOsVPlBXsPqIqT+JMEtUNu3x6otfVZkhKEE2DVaPoWJ5
        YJsiMyqg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41764 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4B-0004FJ-5R; Tue, 21 Jul 2020 12:04:11 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4A-0004Rt-UB; Tue, 21 Jul 2020 12:04:10 +0100
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
Subject: [PATCH net-next 06/14] net: phylink: avoid mac_config calls
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq4A-0004Rt-UB@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:04:10 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid calling mac_config() when using split PCS, and the interface
remains the same.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f1693ec63366..424a927d7889 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -631,10 +631,12 @@ static void phylink_resolve(struct work_struct *w)
 			}
 			phylink_pcs_config(pl, false, &link_state);
 			pl->link_config.interface = link_state.interface;
-		} else {
+		} else if (!pl->pcs_ops) {
 			/* The interface remains unchanged, only the speed,
 			 * duplex or pause settings have changed. Call the
-			 * old mac_config() method to configure the MAC/PCS.
+			 * old mac_config() method to configure the MAC/PCS
+			 * only if we do not have a PCS installed (an
+			 * unconverted user.)
 			 */
 			phylink_mac_config(pl, &link_state);
 		}
-- 
2.20.1

