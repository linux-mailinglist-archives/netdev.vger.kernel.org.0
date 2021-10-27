Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936E543C6CD
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241277AbhJ0Jvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241276AbhJ0Jvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:51:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAB3C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HU5uc70YIAULo++nK8ObE8rMtFH3kbR4hjaXP8HY9WQ=; b=k/ufNmC5MwPKjCG8q4+8HyGsc4
        3Whqd0S/LyZVZNKzt9tiLRStpWjQ6xvaICtzzsH+S/nZW+GD1e2LAEyoeILQnzuXJb3M8k/IcktSF
        xiZs4574gH5w/167jTvAvg62s6WyQ5xKsnSMysUrTlOk8ha1nigba07+R+ysSh1cL4CY/Nqsx08Z2
        7+5iNPj1qQt9FIA9jDEryDWQy0tAyeqG792uxHpPiRYfMuCmAGXRxL/cbV/RLRMPDiSUpFSfHdT3K
        Y5mpTjdJD8IhZv7+8gjXn67Oc4EGQnc4r0uQKs+zkMPswIJxRzbaJv0GtLDaqNMhW9MdVPbnQDyz7
        3jfBN6iw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34474 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mffYe-0006Fb-5u; Wed, 27 Oct 2021 10:49:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mffYd-001vqa-OE; Wed, 27 Oct 2021 10:49:19 +0100
In-Reply-To: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
References: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: mvpp2: remove interface checks in
 mvpp2_phylink_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mffYd-001vqa-OE@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 27 Oct 2021 10:49:19 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode in the
validation function. Remove this to simplify it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 33 ++++---------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 43ffff01bd44..48703b6dff1e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6261,32 +6261,13 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	/* Invalid combinations */
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_10GBASER:
-	case PHY_INTERFACE_MODE_XAUI:
-		if (!mvpp2_port_supports_xlg(port))
-			goto empty_set;
-		break;
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (!mvpp2_port_supports_rgmii(port))
-			goto empty_set;
-		break;
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_2500BASEX:
-		/* When in 802.3z mode, we must have AN enabled:
-		 * Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
-		 * When <PortType> = 1 (1000BASE-X) this field must be set to 1.
-		 */
-		if (!phylink_test(state->advertising, Autoneg))
-			goto empty_set;
-		break;
-	default:
-		break;
-	}
+	/* When in 802.3z mode, we must have AN enabled:
+	 * Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
+	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1.
+	 */
+	if (phy_interface_mode_is_8023z(state->interface) &&
+	    !phylink_test(state->advertising, Autoneg))
+		goto empty_set;
 
 	phylink_set(mask, Autoneg);
 	phylink_set_port_modes(mask);
-- 
2.30.2

