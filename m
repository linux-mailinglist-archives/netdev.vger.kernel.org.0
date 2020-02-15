Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4469B15FF13
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgBOPtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:49:46 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34092 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:49:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pAF8utSsP3NRljv+C8FAVdwLTPLWjXzrLP1UL+fImLw=; b=vA3bReZ/xFoIN1LUc61qz/rgQB
        3ZB05EBZrdNvQyZzrpay/7ZFMshtPAPFYQzZ+5n3iRYCSvp5c2qhwD8yitdOfY+QdpueN9lGJckr5
        jL1S06zxbpyDoxysJD0pcT0JMo223UlwcCW8TmyZFQNHb2OUF5nz1hBhv6wdGg5vD6SeNwNvnJXNq
        dQFYdPX4u/D2/DX5DQt6ilzLPWfj3iaZWu/ldx2iEcvb2JAwWydKnq4C3CUnNQjnynpW1UJSM00vZ
        /mhhPTes3OBt/itfQbxxbnEZWLlF1njbyLd5/ftenwM42B+cYIj8HYneb281orYFNab6chkvo7tFz
        TSy+X7Yw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45446 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhK-0005jY-Sk; Sat, 15 Feb 2020 15:49:38 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhJ-0003XT-V5; Sat, 15 Feb 2020 15:49:38 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 04/10] net: phylink: remove pause mode ethtool
 setting for fixed links
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zhJ-0003XT-V5@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:49:37 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the ability for ethtool -A to change the pause settings for
fixed links; if this is really required, we can reinstate it later.

Andrew Lunn agrees: "So I think it is safe to not implement ethtool
-A, at least until somebody has a real use case for it."

Lets avoid making things too complex for use cases that aren't being
used.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 70b9a143db84..de7b7499ae38 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1373,6 +1373,9 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 
 	ASSERT_RTNL();
 
+	if (pl->cur_link_an_mode == MLO_AN_FIXED)
+		return -EOPNOTSUPP;
+
 	if (!phylink_test(pl->supported, Pause) &&
 	    !phylink_test(pl->supported, Asym_Pause))
 		return -EOPNOTSUPP;
@@ -1399,18 +1402,8 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 				   pause->tx_pause);
 	} else if (!test_bit(PHYLINK_DISABLE_STOPPED,
 			     &pl->phylink_disable_state)) {
-		switch (pl->cur_link_an_mode) {
-		case MLO_AN_FIXED:
-			/* Should we allow fixed links to change against the config? */
-			phylink_resolve_flow(pl, config);
-			phylink_mac_config(pl, config);
-			break;
-
-		case MLO_AN_INBAND:
-			phylink_mac_config(pl, config);
-			phylink_mac_an_restart(pl);
-			break;
-		}
+		phylink_mac_config(pl, &pl->link_config);
+		phylink_mac_an_restart(pl);
 	}
 
 	return 0;
-- 
2.20.1

