Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8A815FF17
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgBOPuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:50:16 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34136 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOPuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:50:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eaqaotz6wiUJZZwMl5Ko+l6IfD1kFPtM7PJiyR8mr6g=; b=Uzv2CVwWlLzqkoT/4ULvyycXko
        ih1iTU8g03MpC5amWjTUvFZUeoAmPBn55nEbJloX68P9GOcty/EQTHPxC9+d9bGPJ8QqyBx1cJ/l+
        BgvNqu3nWaAAxQWC97LCzN2TwpVr/dsZ5ODcGJI2Vi805A+gpkQkdvrov0c/y9qJwOv3c57HnZk8D
        HfgTk42dzvActCzvxFvIR4UxI4b8TkvktT92T1DAIPDdZRXThoKU+6BrZLwLEk3OD9ZDEZocE8ob5
        Ri+e5yM8aD+5EYkelIp9v5bcH802N+6HulsypJWZJYXvGCVq37YW6jSmy32Qn6O9hfAGEiSD6FzmO
        4r9TUuOg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:57256 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhf-0005k4-Vn; Sat, 15 Feb 2020 15:50:00 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhe-0003YH-OZ; Sat, 15 Feb 2020 15:49:58 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 08/10] net: phylink: allow ethtool -A to change flow
 control advertisement
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zhe-0003YH-OZ@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:49:58 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ethtool -A is used to change the pause modes, the pause
advertisement is not being changed, but the documentation in
uapi/linux/ethtool.h says we should be. Add that capability to
phylink.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index c29648b90ce7..ab72bd1a7dca 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1385,6 +1385,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	    !pause->autoneg && pause->rx_pause != pause->tx_pause)
 		return -EINVAL;
 
+	mutex_lock(&pl->state_mutex);
 	config->pause = 0;
 	if (pause->autoneg)
 		config->pause |= MLO_PAUSE_AN;
@@ -1393,6 +1394,22 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	if (pause->tx_pause)
 		config->pause |= MLO_PAUSE_TX;
 
+	/*
+	 * See the comments for linkmode_set_pause(), wrt the deficiencies
+	 * with the current implementation.  A solution to this issue would
+	 * be:
+	 * ethtool  Local device
+	 *  rx  tx  Pause AsymDir
+	 *  0   0   0     0
+	 *  1   0   1     1
+	 *  0   1   0     1
+	 *  1   1   1     1
+	 * and then use the ethtool rx/tx enablement status to mask the
+	 * rx/tx pause resolution.
+	 */
+	linkmode_set_pause(config->advertising, pause->tx_pause,
+			   pause->rx_pause);
+
 	/* If we have a PHY, phylib will call our link state function if the
 	 * mode has changed, which will trigger a resolve and update the MAC
 	 * configuration.
@@ -1405,6 +1422,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 		phylink_mac_config(pl, &pl->link_config);
 		phylink_mac_an_restart(pl);
 	}
+	mutex_unlock(&pl->state_mutex);
 
 	return 0;
 }
-- 
2.20.1

