Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1C046BFFE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbhLGP5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239225AbhLGP5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:57:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77F4C0617A1
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 07:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OfTLau7QBehAOgKbnPkiwzUDJdFs+hq19bKHAj/PBls=; b=d+COFeY/oHL96hI00tr/3Z6DpF
        slDluxmH2aeVH8vj6WPwMIMiiFUpjx/AauYP6qG/yaSZU/dC9Ed3Mrm7vEUSyTEWPVB7vHV/d6dMx
        3WxGzth6WvHq3lDzox+j8EaIHwZvwv9RPck/bAF3ewNjJVPaT5EH73em5m6ZDX0FAewWxKIb/j7Va
        KldBrwfsSHn8qlG++KGT9Q5XzAeQP1Del8pyM04NI6PCT9hvC33CCPTc4Mo/LIr7K0R7GuUi6FGeo
        uffZEP89hMyacsn+zdBazxllf4ioZYuTtFINappaSr7ncTn+5ZK38oxKOZTAp347ellhzjmjq34Jx
        vQ41Bo4A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56790 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mucn0-0006Pv-HW; Tue, 07 Dec 2021 15:53:58 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mucn0-00EyDE-3m; Tue, 07 Dec 2021 15:53:58 +0000
In-Reply-To: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
References: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/5] net: ag71xx: remove unnecessary legacy methods
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mucn0-00EyDE-3m@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Dec 2021 15:53:58 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ag71xx may have a PCS, but it does not appear to support configuration
of the PCS in the current code. The functions to get its state merely
report that the link is down, and the AN restart function is empty.

Since neither of these functions will be called unless phylink's legacy
flag is set, we can safely remove these functions and indicate this is
a modern driver.

Should PCS support be added later, it will need to be modelled using
the phylink_pcs support rather than operating as a legacy driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/atheros/ag71xx.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index ff924f06581e..270c2935591b 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1024,17 +1024,6 @@ static void ag71xx_mac_config(struct phylink_config *config, unsigned int mode,
 	ag71xx_wr(ag, AG71XX_REG_FIFO_CFG3, ag->fifodata[2]);
 }
 
-static void ag71xx_mac_pcs_get_state(struct phylink_config *config,
-				     struct phylink_link_state *state)
-{
-	state->link = 0;
-}
-
-static void ag71xx_mac_an_restart(struct phylink_config *config)
-{
-	/* Not Supported */
-}
-
 static void ag71xx_mac_link_down(struct phylink_config *config,
 				 unsigned int mode, phy_interface_t interface)
 {
@@ -1098,8 +1087,6 @@ static void ag71xx_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops ag71xx_phylink_mac_ops = {
 	.validate = phylink_generic_validate,
-	.mac_pcs_get_state = ag71xx_mac_pcs_get_state,
-	.mac_an_restart = ag71xx_mac_an_restart,
 	.mac_config = ag71xx_mac_config,
 	.mac_link_down = ag71xx_mac_link_down,
 	.mac_link_up = ag71xx_mac_link_up,
-- 
2.30.2

