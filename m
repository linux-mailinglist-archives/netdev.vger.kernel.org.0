Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085892057C7
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733073AbgFWQr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387466AbgFWQr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:47:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79283C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rc/YhpSCAawT6UVhYGtslDt32TIA48wAS+E4igSKad4=; b=gdJfivNCExGTJwyFx7mT0w7IF2
        TS0P0CcTLoiVyPbJ9RSYOOlTVFPEYGKtB+ysPynL7dJz8V2xL9K6LUK4ySBH1sEQXbtaEOTIZGijQ
        suh0rX81I6c4OWoXg8WroJfF5lhGwWcs2lWbXGSte2QsCVUMzSWh+vJ4HXZZtu7yG7AR1PkAJFi4q
        2EFZ7AdttO3fJtzBpcnhoqzLbKI7odBZtF2pJ4noBQwhqGvPczoBiDhh1gwCHy5nOV+KuZg03A4qO
        V+S94/d3wYiUyQCx11TetgbKENNnCsEi3H+sZOKgP1Oez8npninEwD5HxPnORRXhS9p7EqWcWR52N
        b2aPH/Gw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52976 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jnm4y-0001zD-7m; Tue, 23 Jun 2020 17:47:24 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jnm4x-0005hV-U6; Tue, 23 Jun 2020 17:47:23 +0100
In-Reply-To: <20200623164642.GV1551@shell.armlinux.org.uk>
References: <20200623164642.GV1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/2] net: phylink: fix ethtool -A with attached PHYs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jnm4x-0005hV-U6@rmk-PC.armlinux.org.uk>
Date:   Tue, 23 Jun 2020 17:47:23 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a phylink's ethtool set_pauseparam support deadlock caused by phylib
interacting with phylink: we must not hold the state lock while calling
phylib functions that may call into phylink_phy_change().

Fixes: f904f15ea9b5 ("net: phylink: allow ethtool -A to change flow control advertisement")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0ab65fb75258..453f9a399bb1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1502,18 +1502,20 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	linkmode_set_pause(config->advertising, pause->tx_pause,
 			   pause->rx_pause);
 
-	/* If we have a PHY, phylib will call our link state function if the
-	 * mode has changed, which will trigger a resolve and update the MAC
-	 * configuration.
+	if (!pl->phydev && !test_bit(PHYLINK_DISABLE_STOPPED,
+				     &pl->phylink_disable_state))
+		phylink_pcs_config(pl, true, &pl->link_config);
+
+	mutex_unlock(&pl->state_mutex);
+
+	/* If we have a PHY, a change of the pause frame advertisement will
+	 * cause phylib to renegotiate (if AN is enabled) which will in turn
+	 * call our phylink_phy_change() and trigger a resolve.  Note that
+	 * we can't hold our state mutex while calling phy_set_asym_pause().
 	 */
-	if (pl->phydev) {
+	if (pl->phydev)
 		phy_set_asym_pause(pl->phydev, pause->rx_pause,
 				   pause->tx_pause);
-	} else if (!test_bit(PHYLINK_DISABLE_STOPPED,
-			     &pl->phylink_disable_state)) {
-		phylink_pcs_config(pl, true, &pl->link_config);
-	}
-	mutex_unlock(&pl->state_mutex);
 
 	return 0;
 }
-- 
2.20.1

