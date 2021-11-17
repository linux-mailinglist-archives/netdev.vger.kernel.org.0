Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0906454BE5
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhKQR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhKQR1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 12:27:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EA2C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 09:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YaSxYWu9PQYSpuzQRWcrbD2AmvI9XW7bayMYYZ6mCFQ=; b=ad+Ple7KUK2oNQYqzlt9RvIm0j
        2sfihhF8WhWM50HNewdkTQAC2ZWsh/VgvvyxG+MQ6UhQdRqYc0lkOio6oLN7du/dEzDRMdrCr4ybj
        WaFu2mnKqI0xlh7AagjxJRnQEpSdtvN21B0AwCCgSInmXaYGYH0Lr382LW+kiTfH3qYOQo8IGDTNz
        5GLObz4ElICyN6uDEJbscAcGik9szEEIpzYCXSf5+81vjOK7St+W+CTCWHQvbFYvKM+7xOMkouI4R
        eCxURk5f+3S8MXMnij1c9TNXPjN0OPjePW2dqP1+G/zlKNTBiFbY82NjzIDcvEoWQ2MLH4gZthlFj
        mtyI+S8w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46364 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnOfN-00029c-IK; Wed, 17 Nov 2021 17:24:13 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mnOfN-0085Lq-0S; Wed, 17 Nov 2021 17:24:13 +0000
In-Reply-To: <YZU1oGJuGBpQF+vi@shell.armlinux.org.uk>
References: <YZU1oGJuGBpQF+vi@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: dpaa2-mac: use phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mnOfN-0085Lq-0S@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 17 Nov 2021 17:24:13 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPAA2 has no special behaviour in its validation implementation, so can
be switched to phylink_generic_validate().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 53 ++-----------------
 1 file changed, 5 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index bcc7fe127d91..34b2a73c347f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -90,53 +90,6 @@ static int dpaa2_mac_get_if_mode(struct fwnode_handle *dpmac_node,
 	return err;
 }
 
-static void dpaa2_mac_validate(struct phylink_config *config,
-			       unsigned long *supported,
-			       struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_10GBASER:
-	case PHY_INTERFACE_MODE_USXGMII:
-		phylink_set_10g_modes(mask);
-		if (state->interface == PHY_INTERFACE_MODE_10GBASER)
-			break;
-		phylink_set(mask, 5000baseT_Full);
-		phylink_set(mask, 2500baseT_Full);
-		fallthrough;
-	case PHY_INTERFACE_MODE_SGMII:
-	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		phylink_set(mask, 1000baseX_Full);
-		phylink_set(mask, 1000baseT_Full);
-		if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
-			break;
-		phylink_set(mask, 100baseT_Full);
-		phylink_set(mask, 10baseT_Full);
-		break;
-	default:
-		goto empty_set;
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-
-	return;
-
-empty_set:
-	linkmode_zero(supported);
-}
-
 static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
@@ -208,7 +161,7 @@ static void dpaa2_mac_link_down(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
-	.validate = dpaa2_mac_validate,
+	.validate = phylink_generic_validate,
 	.mac_config = dpaa2_mac_config,
 	.mac_link_up = dpaa2_mac_link_up,
 	.mac_link_down = dpaa2_mac_link_down,
@@ -305,6 +258,10 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink_config.dev = &net_dev->dev;
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
+	mac->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
+		MAC_10FD | MAC_100FD | MAC_1000FD | MAC_2500FD | MAC_5000FD |
+		MAC_10000FD;
+
 	/* We support the current interface mode, and if we have a PCS
 	 * similar interface modes that do not require the PLLs to be
 	 * reconfigured.
-- 
2.30.2

