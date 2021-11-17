Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FE1454B4E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbhKQQtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239247AbhKQQtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 11:49:33 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B63C061764
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 08:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ewiFRHsp9/s0aet6bxtSjzPcLw7Ix6IoZEtWFK/tm6U=; b=BRsE4iaATwfF57w81wWqqPzrUW
        6XudiFPAMWzoegV9UaQ31ZrsN51nOjCisE+1YClpP/+znRTQenqpQYAvsuhkIdEzGqGgNiNCj7d+R
        x0Rwoaxja5KaITvaZH/hNyaGOpMtR6eNnPeqJJ5qyQ3hpsY7G0wEJk9i5T3jMoxlmwnb7Lhy6rnyv
        N3Q6kYN1tANI1PeN36T4HvH+ZvgkAyGuTN3osXMNG78oVGVbQCofNJnTUT5fy5S+RgugoHXBMCFbw
        sTec/gnToZ5ckCC0E8mrQGHn4fL12+l30Ez4KytIOi0TvBO3v2KgBLSVs6/F4WnlYTsK9KBN3ZChx
        7mUhVNpg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46120 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnO4t-00027n-Do; Wed, 17 Nov 2021 16:46:31 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnO4t-007ynF-0E; Wed, 17 Nov 2021 16:46:31 +0000
In-Reply-To: <YZUxxU30M4IgNNPi@shell.armlinux.org.uk>
References: <YZUxxU30M4IgNNPi@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: ag71xx: use phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mnO4t-007ynF-0E@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 17 Nov 2021 16:46:31 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ag71xx apparently only supports MII port type, which makes it different
from other implementations. However, Oleksij says there is no special
reason for this.

Convert the driver to use phylink_generic_validate(), which will allow
all ethtool port linkmodes instead of only MII, giving the driver
consistent behaviour with other drivers.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/atheros/ag71xx.c | 31 +++------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 20c2cfdc30da..c747dc7984fd 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1024,33 +1024,6 @@ static void ag71xx_mac_config(struct phylink_config *config, unsigned int mode,
 	ag71xx_wr(ag, AG71XX_REG_FIFO_CFG3, ag->fifodata[2]);
 }
 
-static void ag71xx_mac_validate(struct phylink_config *config,
-			    unsigned long *supported,
-			    struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	phylink_set(mask, MII);
-
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
-	    state->interface == PHY_INTERFACE_MODE_RGMII ||
-	    state->interface == PHY_INTERFACE_MODE_GMII) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 static void ag71xx_mac_pcs_get_state(struct phylink_config *config,
 				     struct phylink_link_state *state)
 {
@@ -1124,7 +1097,7 @@ static void ag71xx_mac_link_up(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops ag71xx_phylink_mac_ops = {
-	.validate = ag71xx_mac_validate,
+	.validate = phylink_generic_validate,
 	.mac_pcs_get_state = ag71xx_mac_pcs_get_state,
 	.mac_an_restart = ag71xx_mac_an_restart,
 	.mac_config = ag71xx_mac_config,
@@ -1138,6 +1111,8 @@ static int ag71xx_phylink_setup(struct ag71xx *ag)
 
 	ag->phylink_config.dev = &ag->ndev->dev;
 	ag->phylink_config.type = PHYLINK_NETDEV;
+	ag->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000FD;
 
 	if ((ag71xx_is(ag, AR9330) && ag->mac_idx == 0) ||
 	    ag71xx_is(ag, AR9340) ||
-- 
2.30.2

