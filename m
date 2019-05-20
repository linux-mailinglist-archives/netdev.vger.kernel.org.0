Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0149823BAC
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389703AbfETPHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:07:30 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48734 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731505AbfETPHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FqB6S/tNDJgVGAZ5YtmgeWM9hBhTLl7/9/eQ2HfncBM=; b=1vKAMU4XlnRxybSKIhr6/WFlJd
        7/e5Jpao4SX1fcIu3QGWk7im/jnIRaOc53bz6j7J/RB6bypLEcPXRPesn455hrN4cdtYA+/OE/VS8
        Hzx6aVbv0VVPJwNAnJypVUrRqHTwA+1TLpvgBFWMX/M5cxJsZqgfxrAhazBRPGSf/mHH3y799KP44
        WRd3CRdhtkip/l9JBt+rcjerL7PG1jglwxBELuNuYY8hj0p8o3ovze8s/89x6aENJwaKLqvUWPNAj
        btxRNBxehY5WGriwfdT9nA+roC2XdzKcSe+q17TVuY87ls7IF2OfzOUh1GgSVmhfzQmA4DFIxitrb
        U2INLPZA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:42758 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hSjsn-0003WQ-TC; Mon, 20 May 2019 16:07:21 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hSjsm-0000o3-Q7; Mon, 20 May 2019 16:07:21 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: ensure inband AN works correctly
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hSjsm-0000o3-Q7@rmk-PC.armlinux.org.uk>
Date:   Mon, 20 May 2019 16:07:20 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not update the link interface mode while the link is down to avoid
spurious link interface changes.

Always call mac_config if we have a PHY to propagate the pause mode
settings to the MAC.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 89750c7dfd6f..74983593834b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -422,28 +422,21 @@ static void phylink_resolve(struct work_struct *w)
 
 		case MLO_AN_INBAND:
 			phylink_get_mac_state(pl, &link_state);
-			if (pl->phydev) {
-				bool changed = false;
-
-				link_state.link = link_state.link &&
-						  pl->phy_state.link;
-
-				if (pl->phy_state.interface !=
-				    link_state.interface) {
-					link_state.interface = pl->phy_state.interface;
-					changed = true;
-				}
-
-				/* Propagate the flow control from the PHY
-				 * to the MAC. Also propagate the interface
-				 * if changed.
-				 */
-				if (pl->phy_state.link || changed) {
-					link_state.pause |= pl->phy_state.pause;
-					phylink_resolve_flow(pl, &link_state);
-
-					phylink_mac_config(pl, &link_state);
-				}
+
+			/* If we have a phy, the "up" state is the union of
+			 * both the PHY and the MAC */
+			if (pl->phydev)
+				link_state.link &= pl->phy_state.link;
+
+			/* Only update if the PHY link is up */
+			if (pl->phydev && pl->phy_state.link) {
+				link_state.interface = pl->phy_state.interface;
+
+				/* If we have a PHY, we need to update with
+				 * the pause mode bits. */
+				link_state.pause |= pl->phy_state.pause;
+				phylink_resolve_flow(pl, &link_state);
+				phylink_mac_config(pl, &link_state);
 			}
 			break;
 		}
-- 
2.7.4

