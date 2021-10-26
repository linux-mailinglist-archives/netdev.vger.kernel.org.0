Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818AC43B7DF
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbhJZRHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237761AbhJZRGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 13:06:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05836C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 10:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fIGmeCluuotJTXyDERyf78/iH9W0wBUowDA2Hxk0uTE=; b=C45NPanohL7v+9s1NJhrqWccLf
        PwO5lG4ssuOYp+iFlpHcGVDlPE8TWJVeQ0kgbyW5IYihq9bFyhmuG0DfknF5gp6ZcHf0ysinnWGJr
        GFl6ibepv4rvT0OsgzQnP+pJW+aa23iuFkIjvSlbCy/Y5zZCCQEjD9wV6ULvoKkiByqbes00by1JC
        J9pDNJwuvvI1d2nTkQdGJ99RbwtVazVpbFE5j4iAQ7H31ca+6BmhJ09b9LKQaZSbt0j1DaQhkryrP
        ncFCLAGGn/AhiHon4igk655h0yoAvczZxVs1YGy2nVHcR0RV5VywuMnfhennN+TepoRfin0bkTULl
        cX6LgtDQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55320)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfPs9-0005ax-9W; Tue, 26 Oct 2021 18:04:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfPs7-0006ug-7q; Tue, 26 Oct 2021 18:04:23 +0100
Date:   Tue, 26 Oct 2021 18:04:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
Message-ID: <YXg1F7cGOEjd2a+c@shell.armlinux.org.uk>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
 <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
 <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 06:37:18PM +0200, Nicolas Ferre wrote:
> I like it as well. Thanks a lot for these enhancements.

So, would this work - have I understood all these capability flags
correctly? To aid this process, I've included the resulting code
below as well as the diff.

Should we only be setting have_10g if _all_ of MACB_CAPS_HIGH_SPEED,
MACB_CAPS_PCS, and MACB_CAPS_GIGABIT_MODE_AVAILABLE are set and we
have gem, or is what I have below sufficient (does it matter if
MACB_CAPS_PCS is clear?)

static void macb_validate(struct phylink_config *config,
			  unsigned long *supported,
			  struct phylink_link_state *state)
{
	struct net_device *ndev = to_net_dev(config->dev);
	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
	bool have_1g = false, have_10g = false;
	struct macb *bp = netdev_priv(ndev);

	if (macb_is_gem(bp) &&
	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
		if (bp->caps & MACB_CAPS_PCS)
			have_1g = true;
		if (bp->caps & MACB_CAPS_HIGH_SPEED)
			have_10g = true;
	}

	switch (state->interface) {
	case PHY_INTERFACE_MODE_NA:
	case PHY_INTERFACE_MODE_MII:
	case PHY_INTERFACE_MODE_RMII:
		break;

	case PHY_INTERFACE_MODE_GMII:
	case PHY_INTERFACE_MODE_RGMII:
	case PHY_INTERFACE_MODE_RGMII_ID:
	case PHY_INTERFACE_MODE_RGMII_RXID:
	case PHY_INTERFACE_MODE_RGMII_TXID:
	case PHY_INTERFACE_MODE_SGMII:
		if (!have_1g) {
			linkmode_zero(supported);
			return;
		}
		break;

	case PHY_INTERFACE_MODE_10GBASER:
		if (!have_10g) {
			linkmode_zero(supported);
			return;
		}
		break;

	default:
		linkmode_zero(supported);
		return;
	}

	phylink_set_port_modes(mask);
	phylink_set(mask, Autoneg);
	phylink_set(mask, Asym_Pause);

	switch (state->interface) {
	case PHY_INTERFACE_MODE_NA:
	case PHY_INTERFACE_MODE_10GBASER:
		if (have_10g) {
			phylink_set_10g_modes(mask);
			phylink_set(mask, 10000baseKR_Full);
		}
		if (state->interface != PHY_INTERFACE_MODE_NA)
			break;
		fallthrough;

	case PHY_INTERFACE_MODE_GMII:
	case PHY_INTERFACE_MODE_RGMII:
	case PHY_INTERFACE_MODE_RGMII_ID:
	case PHY_INTERFACE_MODE_RGMII_RXID:
	case PHY_INTERFACE_MODE_RGMII_TXID:
	case PHY_INTERFACE_MODE_SGMII:
		if (have_1g) {
			phylink_set(mask, 1000baseT_Full);
			phylink_set(mask, 1000baseX_Full);

			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
				phylink_set(mask, 1000baseT_Half);
		}
		fallthrough;

	default:
		phylink_set(mask, 10baseT_Half);
		phylink_set(mask, 10baseT_Full);
		phylink_set(mask, 100baseT_Half);
		phylink_set(mask, 100baseT_Full);
		break;
	}

	linkmode_and(supported, supported, mask);
	linkmode_and(state->advertising, state->advertising, mask);
}


diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 309371abfe23..36fcd5563a71 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -512,30 +512,43 @@ static void macb_validate(struct phylink_config *config,
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	bool have_1g = false, have_10g = false;
 	struct macb *bp = netdev_priv(ndev);
 
-	/* We only support MII, RMII, GMII, RGMII & SGMII. */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_RMII &&
-	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    state->interface != PHY_INTERFACE_MODE_SGMII &&
-	    state->interface != PHY_INTERFACE_MODE_10GBASER &&
-	    !phy_interface_mode_is_rgmii(state->interface)) {
-		linkmode_zero(supported);
-		return;
+	if (macb_is_gem(bp) &&
+	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
+		if (bp->caps & MACB_CAPS_PCS)
+			have_1g = true;
+		if (bp->caps & MACB_CAPS_HIGH_SPEED)
+			have_10g = true;
 	}
 
-	if (!macb_is_gem(bp) &&
-	    (state->interface == PHY_INTERFACE_MODE_GMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		linkmode_zero(supported);
-		return;
-	}
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_RMII:
+		break;
+
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_SGMII:
+		if (!have_1g) {
+			linkmode_zero(supported);
+			return;
+		}
+		break;
+
+	case PHY_INTERFACE_MODE_10GBASER:
+		if (!have_10g) {
+			linkmode_zero(supported);
+			return;
+		}
+		break;
 
-	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
-	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
-	      bp->caps & MACB_CAPS_PCS)) {
+	default:
 		linkmode_zero(supported);
 		return;
 	}
@@ -544,32 +557,40 @@ static void macb_validate(struct phylink_config *config,
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Asym_Pause);
 
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_10GBASER)) {
-		phylink_set_10g_modes(mask);
-		phylink_set(mask, 10000baseKR_Full);
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_10GBASER:
+		if (have_10g) {
+			phylink_set_10g_modes(mask);
+			phylink_set(mask, 10000baseKR_Full);
+		}
 		if (state->interface != PHY_INTERFACE_MODE_NA)
-			goto out;
-	}
+			break;
+		fallthrough;
+
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_SGMII:
+		if (have_1g) {
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
+
+			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
+				phylink_set(mask, 1000baseT_Half);
+		}
+		fallthrough;
 
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-
-	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
-	    (state->interface == PHY_INTERFACE_MODE_NA ||
-	     state->interface == PHY_INTERFACE_MODE_GMII ||
-	     state->interface == PHY_INTERFACE_MODE_SGMII ||
-	     phy_interface_mode_is_rgmii(state->interface))) {
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-
-		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
-			phylink_set(mask, 1000baseT_Half);
+	default:
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		break;
 	}
-out:
+
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
 }

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
