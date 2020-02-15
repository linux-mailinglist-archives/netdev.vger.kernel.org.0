Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D7915FF18
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgBOPuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:50:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34148 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Tobe9412L+dBFcbflXpmDHUSd8kdBKPhQ++y7Xg7feo=; b=DhuNLW+ZivCAHxwLLVrjUx+L0H
        jmgxgPBw4J6xs71L04+DSiFupJW1BI6idE7cBXVOIY6KqBdXU/Ayz2mcwjMj+opHIervpndVosTOU
        xDGCA8CEQhfUTE/DdJU/WZie/7lthU4RYgxE0ptBpUFov+WMR6Yzya9D3GcD0sg+dBmnzyTS/CvPP
        hYZTXbU+WwdNfD6aNX8IVNiFf+2gDNu3wEmrktf2/yMdI8T872esrFnQHX7i4guwbjnQA5ZK/fpBS
        1AelTYJJ+y86Tl9OjnIt9Hb185qs/xBocShy0kf8rHjugDTn+Qjx5EE19Me1i+lqvsPRzsueQKOlu
        f/aGSnCQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:41214 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhm-0005kJ-FW; Sat, 15 Feb 2020 15:50:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhj-0003YU-TF; Sat, 15 Feb 2020 15:50:03 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 09/10] net: phylink: improve initial mac
 configuration
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zhj-0003YU-TF@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:50:03 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the initial MAC configuration so we get a configuration which
more represents the final operating mode, in particular with respect
to the flow control settings.

We do this by:
1) more fully initialising our phy state, so we can use this as the
   initial state for PHY based connections.
2) reading the fixed link state.
3) ensuring that in-band mode has sane pause settings for SGMII vs
   802.3z negotiation modes.

In all three cases, we ensure that state->link is false, just in case
any MAC drivers have other ideas by mis-using this member, and we also
take account of manual pause mode configuration at this point.

This avoids MLO_PAUSE_AN being seen in mac_config() when operating in
PHY, fixed mode or inband SGMII mode, thereby giving cleaner semantics
to the pause flags.  As a result of this, the pause flags now indicate
in a mode-independent way what is required from a mac_config()
implementation.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ab72bd1a7dca..2899fbe699ab 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -431,6 +431,35 @@ static void phylink_get_fixed_state(struct phylink *pl,
 	phylink_resolve_flow(state);
 }
 
+static void phylink_mac_initial_config(struct phylink *pl)
+{
+	struct phylink_link_state link_state;
+
+	switch (pl->cur_link_an_mode) {
+	case MLO_AN_PHY:
+		link_state = pl->phy_state;
+		break;
+
+	case MLO_AN_FIXED:
+		phylink_get_fixed_state(pl, &link_state);
+		break;
+
+	case MLO_AN_INBAND:
+		link_state = pl->link_config;
+		if (link_state.interface == PHY_INTERFACE_MODE_SGMII)
+			link_state.pause = MLO_PAUSE_NONE;
+		break;
+
+	default: /* can't happen */
+		return;
+	}
+
+	link_state.link = false;
+
+	phylink_apply_manual_flow(pl, &link_state);
+	phylink_mac_config(pl, &link_state);
+}
+
 static const char *phylink_pause_to_str(int pause)
 {
 	switch (pause & MLO_PAUSE_TXRX_MASK) {
@@ -779,6 +808,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	mutex_lock(&pl->state_mutex);
 	pl->phydev = phy;
 	pl->phy_state.interface = interface;
+	pl->phy_state.pause = MLO_PAUSE_NONE;
+	pl->phy_state.speed = SPEED_UNKNOWN;
+	pl->phy_state.duplex = DUPLEX_UNKNOWN;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
@@ -1008,7 +1040,7 @@ void phylink_start(struct phylink *pl)
 	 * a fixed-link to start with the correct parameters, and also
 	 * ensures that we set the appropriate advertisement for Serdes links.
 	 */
-	phylink_mac_config(pl, &pl->link_config);
+	phylink_mac_initial_config(pl);
 
 	/* Restart autonegotiation if using 802.3z to ensure that the link
 	 * parameters are properly negotiated.  This is necessary for DSA
@@ -1826,7 +1858,7 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 
 	if (changed && !test_bit(PHYLINK_DISABLE_STOPPED,
 				 &pl->phylink_disable_state))
-		phylink_mac_config(pl, &pl->link_config);
+		phylink_mac_initial_config(pl);
 
 	return ret;
 }
-- 
2.20.1

