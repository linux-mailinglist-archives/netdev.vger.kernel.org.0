Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECFD20F739
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388995AbgF3O3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgF3O3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:29:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCC6C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WYoiq8QfoDQH1OpvTKxyu4dfRNgPrLdMcnE+gbPxucs=; b=zGfKuQYb/2Dw/r6fjPeoBrVref
        CDN1eyXVDSPp8CryWb1GxZzflJI4REJL4WC+oq8EmTtw9M7bd1lRH5/ebpRKDbLd7m5xsoUN/4cXH
        ATGInIcxCRbEUefAuo4toBuLQ+GUxXiEmZcGWlLGVYYzs9SBsJ24oifI1jkc/6p3baDXEG75e+PS4
        pT7iiDblo4Qgv+Vxb41LsC7W52pandGoKORX0AAfAQ5RgDxX2aaZ1xJcxEWcCsKxrcf7G6ALQt3x7
        BR+UfLH+sWpYYhMawOe8E8/UlOWld9kfVmmHoUZn70GGT1B7FttHp6El0YcdXLcFV0SoC3XqXXNEM
        FBYMkGxw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47268 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFt-0000eZ-U3; Tue, 30 Jun 2020 15:29:01 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFt-0006P7-Ed; Tue, 30 Jun 2020 15:29:01 +0100
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
Subject: [PATCH RFC net-next 06/13] net: phylink: avoid mac_config calls
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqHFt-0006P7-Ed@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 15:29:01 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid calling mac_config() when using split PCS, and the interface
remains the same.

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

