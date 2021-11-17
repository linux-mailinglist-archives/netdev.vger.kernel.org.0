Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839614549E5
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbhKQPcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhKQPcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 10:32:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71862C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 07:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pM9RqqgqXQUBfxxPczlvb62iYPFSnxraY0XFMpKgbFQ=; b=hBv0lHgtf9xIstXidFle+EA+Cf
        yHtg0ooSqDp1mx/Ww0RxwHtGjZP+9NGoYd5h/rwt514frIurH3XgYV3OXGnBbHXHe9JdO3f6mN3/a
        iev4zQiaz0XhE1XizATLwButihcWIbt4+WrSdHgyknQ7PyW20Mgt4Hr1+DbXMQyXU9AgDdl3f+pBe
        DhpPD6i3T18YBTIUxXxOnESbWBzTnu0dYGw/q4TBcRBgBvd78eDjrmSlC/057AZU3XXaR6e734kjr
        WJW6ae8cNZKEFaor5nr/H2wdodwPDvlvfKRAvP7WZTqByQ0fzAUdWslkbgjysNRL639C07oWGCuHj
        9zaogtxQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45520 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnMsM-0001z6-Sj; Wed, 17 Nov 2021 15:29:30 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnMsM-007y7z-F5; Wed, 17 Nov 2021 15:29:30 +0000
In-Reply-To: <YZUfU8fot1puQoRj@shell.armlinux.org.uk>
References: <YZUfU8fot1puQoRj@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     netdev@vger.kernel.org
Subject: [PATCH RFC net-next 3/3] net: ag71xx: convert to
 phylink_get_linkmodes()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mnMsM-007y7z-F5@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 17 Nov 2021 15:29:30 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ag71xx only supports MII port type, so can't use the generic phylink
validation callback. Update to use phylink_get_linkmodes() instead.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
This implementation seems wrong. If it only supports the MII port type,
then it doesn't support fibre or twisted pair - yet it can as a PHY can
be connected. If this can be fixed, we can convert it to use
phylink_generic_validate() and get rid of ag71xx_mac_validate()
entirely.

 drivers/net/ethernet/atheros/ag71xx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 20c2cfdc30da..2d2725b2a6ae 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1032,20 +1032,8 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 
 	phylink_set(mask, MII);
 
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
 	phylink_set(mask, Autoneg);
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
+	phylink_get_linkmodes(mask, state->interface, config->mac_capabilities);
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
@@ -1138,6 +1126,8 @@ static int ag71xx_phylink_setup(struct ag71xx *ag)
 
 	ag->phylink_config.dev = &ag->ndev->dev;
 	ag->phylink_config.type = PHYLINK_NETDEV;
+	ag->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
+		MAC_10 | MAC_100 | MAC_1000FD;
 
 	if ((ag71xx_is(ag, AR9330) && ag->mac_idx == 0) ||
 	    ag71xx_is(ag, AR9340) ||
-- 
2.30.2

