Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77BE15FF15
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgBOPt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:49:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34112 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:49:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=z4+MTWxV7HSok19OYiazRtSvG9jdJeoPHiS7eVz9SU4=; b=vACt6aau1tucfXoAKkqs/btMsj
        lh+Xprww+87K4Y4LXAvzv/bUamMGX6/DfUiUFdjQxfHSe4HrqMrYg+riYrFlBgzKN0kN0tI1VJd5g
        YYasopgEhm1niEdHZwqMhsPUHfh8kRBPR4ZcV3BnEXSSc8ZgimN/Ntdb6u1736+xL7MWB+38uLKG8
        1fE+5x7+V4i2U5H5U5goE2EyHRfkDtMdOIYaXd5/WwikUeSefApkEixdl226qt3TDy5u4u31qCrVN
        4A3587PgaW4h7i6bYCMEYYo6UfO5c7kN635e5ob6iZMO/xSC7Q6SxjzEV5/f3qE0hveGwH13Z+lf+
        pDeezxvQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:57252 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhW-0005jq-4g; Sat, 15 Feb 2020 15:49:50 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhU-0003Xs-Ec; Sat, 15 Feb 2020 15:49:48 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 06/10] net: phylink: use phylib resolved flow control
 modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zhU-0003Xs-Ec@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:49:48 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new phy_get_pause() helper to get the resolved pause modes for
a PHY rather than resolving the pause modes ourselves. We temporarily
retain our pause mode resolution for causes where there is no PHY
attached, e.g. for fixed-link modes.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 846aee591684..e65e9c9dc759 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -500,7 +500,6 @@ static void phylink_resolve(struct work_struct *w)
 		switch (pl->cur_link_an_mode) {
 		case MLO_AN_PHY:
 			link_state = pl->phy_state;
-			phylink_resolve_flow(pl, &link_state);
 			phylink_apply_manual_flow(pl, &link_state);
 			phylink_mac_config_up(pl, &link_state);
 			break;
@@ -523,9 +522,8 @@ static void phylink_resolve(struct work_struct *w)
 				link_state.interface = pl->phy_state.interface;
 
 				/* If we have a PHY, we need to update with
-				 * the pause mode bits. */
-				link_state.pause |= pl->phy_state.pause;
-				phylink_resolve_flow(pl, &link_state);
+				 * the PHY flow control bits. */
+				link_state.pause = pl->phy_state.pause;
 				phylink_apply_manual_flow(pl, &link_state);
 				phylink_mac_config(pl, &link_state);
 			}
@@ -714,15 +712,18 @@ static void phylink_phy_change(struct phy_device *phydev, bool up,
 			       bool do_carrier)
 {
 	struct phylink *pl = phydev->phylink;
+	bool tx_pause, rx_pause;
+
+	phy_get_pause(phydev, &tx_pause, &rx_pause);
 
 	mutex_lock(&pl->state_mutex);
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
-	if (phydev->pause)
-		pl->phy_state.pause |= MLO_PAUSE_SYM;
-	if (phydev->asym_pause)
-		pl->phy_state.pause |= MLO_PAUSE_ASYM;
+	if (tx_pause)
+		pl->phy_state.pause |= MLO_PAUSE_TX;
+	if (rx_pause)
+		pl->phy_state.pause |= MLO_PAUSE_RX;
 	pl->phy_state.interface = phydev->interface;
 	pl->phy_state.link = up;
 	mutex_unlock(&pl->state_mutex);
-- 
2.20.1

