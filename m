Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B0E3C5FB0
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhGLPuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbhGLPuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 11:50:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0932BC0613E5
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 08:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XbkVCgYF5uWorQdNy1xvU1j7qEP5msiEYPAdMbJGIwo=; b=rcnAHuEavcCPMmmPQIRjZ6KAgx
        UT7ta1t/jCCA7sQ+UeOVK5xxSe1avIzeR3tIKCR9OH0ZqfYIumZSM//gLXgvWs3Ln++5/lWrczd5K
        KTuQO3Cn/ZJgz0ivGl1D2F64NSyFUfKZHayIAj/fR+AxMkVTtCJuzqBvicX5GJ74hk2/EuIpR8l6A
        RlB0BVOOXdcDlE1dPv8UmrfVyaes1sG+ROepOHR12x2oDek9dPOMWxdqNWcG+QE5k+oif0GqB/EHf
        ORZBNZZrEBAhMzgomMnvM+6soQ3Hy1sEy9f89VwNt4XrX4De3BnsYmYiy/jUW5hjJ51woTM9q2Q5M
        xIqg2mkQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40096 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m2y9M-0004z9-Bx; Mon, 12 Jul 2021 16:47:16 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m2y9M-0005w4-3p; Mon, 12 Jul 2021 16:47:16 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH net-next] net: mvneta: deny disabling autoneg for 802.3z modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1m2y9M-0005w4-3p@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 12 Jul 2021 16:47:16 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation for Armada 38x says:

  Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
  When <PortType> = 1 (1000BASE-X) this field must be set to 1.

We presently ignore whether userspace requests autonegotiation or not
through the ethtool ksettings interface. However, we have some network
interfaces that wish to do this. To offer a consistent API across
network interfaces, deny the ability to disable autonegotiation on
mvneta hardware when in 1000BASE-X and 2500BASE-X.

This means the only way to switch between 2500BASE-X and 1000BASE-X
on SFPs that support this will be:

 # ethtool -s ethX advertise 0x20000002000 # 1000BASE-X Pause
 # ethtool -s ethX advertise 0xa000        # 2500BASE-X Pause

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
net-next is currently closed, but I'd like to collect acks for this
patch. Thanks.

 drivers/net/ethernet/marvell/mvneta.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 361bc4fbe20b..0a35d216b742 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3832,12 +3832,20 @@ static void mvneta_validate(struct phylink_config *config,
 	struct mvneta_port *pp = netdev_priv(ndev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	/* We only support QSGMII, SGMII, 802.3z and RGMII modes */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != PHY_INTERFACE_MODE_QSGMII &&
-	    state->interface != PHY_INTERFACE_MODE_SGMII &&
-	    !phy_interface_mode_is_8023z(state->interface) &&
-	    !phy_interface_mode_is_rgmii(state->interface)) {
+	/* We only support QSGMII, SGMII, 802.3z and RGMII modes.
+	 * When in 802.3z mode, we must have AN enabled:
+	 * "Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
+	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1."
+	 */
+	if (phy_interface_mode_is_8023z(state->interface)) {
+		if (!phylink_test(state->advertising, Autoneg)) {
+			bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+			return;
+		}
+	} else if (state->interface != PHY_INTERFACE_MODE_NA &&
+		   state->interface != PHY_INTERFACE_MODE_QSGMII &&
+		   state->interface != PHY_INTERFACE_MODE_SGMII &&
+		   !phy_interface_mode_is_rgmii(state->interface)) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
 	}
-- 
2.20.1

