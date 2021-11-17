Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE32E454B4D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbhKQQt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239237AbhKQQt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 11:49:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E23FC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 08:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TJWsQEQaHiTvQtN+zUvqAuiQTyoh1ybLoZenhjB9auw=; b=FFDIrwv5GYFjZisDrnH/5MwRXL
        ztckuVFawRTx160jxM5afu866iJ2jAZbrINip93hhRlxF6rBqLuFgANQ8X5poxYSIex1fL5hkBBoM
        QDSYDYVaM5qhraPzGYPi+sFRAOC5BG9dfB27ivSLqo4jrQx1OUVEEZzu2YBSQjuA9DFcC37rS8QLN
        Oz10GCBNXB2MQFK/ETvag19yZcNQTDpEBViP/Ow+JNGJwyklcXuaAFnLs9Ydk4p5i417gCLqeazjq
        nHKPFWA7fEA/3RV8lctUD7YaCabfZwAgyQpN/TScX9ZcxXhSWrkh91d7gF/KqUcni/Se5mpHAt00B
        9k8KQarg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46118 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnO4o-00027c-AG; Wed, 17 Nov 2021 16:46:26 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnO4n-007yn9-Si; Wed, 17 Nov 2021 16:46:25 +0000
In-Reply-To: <YZUxxU30M4IgNNPi@shell.armlinux.org.uk>
References: <YZUxxU30M4IgNNPi@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: ag71xx: remove interface checks in
 ag71xx_mac_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mnO4n-007yn9-Si@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 17 Nov 2021 16:46:25 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode, nor handle
PHY_INTERFACE_MODE_NA in the validation function. Remove these to
simplify the implementation.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/atheros/ag71xx.c | 41 +--------------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 8d55ce266aa3..20c2cfdc30da 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1028,42 +1028,8 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 			    unsigned long *supported,
 			    struct phylink_link_state *state)
 {
-	struct ag71xx *ag = netdev_priv(to_net_dev(config->dev));
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_NA:
-		break;
-	case PHY_INTERFACE_MODE_MII:
-		if ((ag71xx_is(ag, AR9330) && ag->mac_idx == 0) ||
-		    ag71xx_is(ag, AR9340) ||
-		    ag71xx_is(ag, QCA9530) ||
-		    (ag71xx_is(ag, QCA9550) && ag->mac_idx == 1))
-			break;
-		goto unsupported;
-	case PHY_INTERFACE_MODE_GMII:
-		if ((ag71xx_is(ag, AR9330) && ag->mac_idx == 1) ||
-		    (ag71xx_is(ag, AR9340) && ag->mac_idx == 1) ||
-		    (ag71xx_is(ag, QCA9530) && ag->mac_idx == 1))
-			break;
-		goto unsupported;
-	case PHY_INTERFACE_MODE_SGMII:
-		if (ag71xx_is(ag, QCA9550) && ag->mac_idx == 0)
-			break;
-		goto unsupported;
-	case PHY_INTERFACE_MODE_RMII:
-		if (ag71xx_is(ag, AR9340) && ag->mac_idx == 0)
-			break;
-		goto unsupported;
-	case PHY_INTERFACE_MODE_RGMII:
-		if ((ag71xx_is(ag, AR9340) && ag->mac_idx == 0) ||
-		    (ag71xx_is(ag, QCA9550) && ag->mac_idx == 1))
-			break;
-		goto unsupported;
-	default:
-		goto unsupported;
-	}
-
 	phylink_set(mask, MII);
 
 	phylink_set(mask, Pause);
@@ -1074,8 +1040,7 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
 
-	if (state->interface == PHY_INTERFACE_MODE_NA ||
-	    state->interface == PHY_INTERFACE_MODE_SGMII ||
+	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
 	    state->interface == PHY_INTERFACE_MODE_RGMII ||
 	    state->interface == PHY_INTERFACE_MODE_GMII) {
 		phylink_set(mask, 1000baseT_Full);
@@ -1084,10 +1049,6 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
-
-	return;
-unsupported:
-	linkmode_zero(supported);
 }
 
 static void ag71xx_mac_pcs_get_state(struct phylink_config *config,
-- 
2.30.2

