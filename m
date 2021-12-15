Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAC0475BEA
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243983AbhLOPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243972AbhLOPet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:34:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44F8C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1m29PSbfdHpACxG4MMZjqjf6bdfcXLrNGITGRBHO2+U=; b=b7q8CP7bZ40QDcE326x6gy1fBX
        pDewzgfwOue9GF4mjtQvuQAQ3FpPOOUkPVtN9HW1TM1gRobwLprr4vZVHJS8P/hLGhKxKN1GDUUnp
        e5aSDqKdjFiNvlerasM1zTOuq3hTvaBrRvE1RR9SYGVnxvu8BX7nK1YtNMWXOKE2uPyEAN7Qx2A0o
        20mhzHyey0fOskj6OfbQNDp5ocrJFyJSbn+7Tlu8rPSlzn+4IiHxw0gyr/SvWIqBBp7WWio/MYgBc
        WcEuA7ZKn2D6zmxXMORNRkrBeiURgLAWxteVitlcMLbYr6XRvt6DTT7Yj9HjmiYV4SAj+FqFW4zXQ
        u7uzZAiw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43834 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIo-0006aQ-84; Wed, 15 Dec 2021 15:34:46 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIn-00GPin-QS; Wed, 15 Dec 2021 15:34:45 +0000
In-Reply-To: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
References: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 net-next 7/7] net: mvneta: convert to pcs_validate() and
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxWIn-00GPin-QS@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 15 Dec 2021 15:34:45 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvneta to validate the autoneg state for 1000base-X in the
pcs_validate() operation, rather than the MAC validate() operation.
This allows us to switch the MAC validate() to use
phylink_generic_validate().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 37 +++++++++++++--------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f40eb282c522..e4c328f61188 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3852,6 +3852,22 @@ static struct mvneta_port *mvneta_pcs_to_port(struct phylink_pcs *pcs)
 	return container_of(pcs, struct mvneta_port, phylink_pcs);
 }
 
+static int mvneta_pcs_validate(struct phylink_pcs *pcs,
+			       unsigned long *supported,
+			       const struct phylink_link_state *state)
+{
+	/* We only support QSGMII, SGMII, 802.3z and RGMII modes.
+	 * When in 802.3z mode, we must have AN enabled:
+	 * "Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
+	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1."
+	 */
+	if (phy_interface_mode_is_8023z(state->interface) &&
+	    !phylink_test(state->advertising, Autoneg))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void mvneta_pcs_get_state(struct phylink_pcs *pcs,
 				 struct phylink_link_state *state)
 {
@@ -3947,29 +3963,12 @@ static void mvneta_pcs_an_restart(struct phylink_pcs *pcs)
 }
 
 static const struct phylink_pcs_ops mvneta_phylink_pcs_ops = {
+	.pcs_validate = mvneta_pcs_validate,
 	.pcs_get_state = mvneta_pcs_get_state,
 	.pcs_config = mvneta_pcs_config,
 	.pcs_an_restart = mvneta_pcs_an_restart,
 };
 
-static void mvneta_validate(struct phylink_config *config,
-			    unsigned long *supported,
-			    struct phylink_link_state *state)
-{
-	/* We only support QSGMII, SGMII, 802.3z and RGMII modes.
-	 * When in 802.3z mode, we must have AN enabled:
-	 * "Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
-	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1."
-	 */
-	if (phy_interface_mode_is_8023z(state->interface) &&
-	    !phylink_test(state->advertising, Autoneg)) {
-		linkmode_zero(supported);
-		return;
-	}
-
-	phylink_generic_validate(config, supported, state);
-}
-
 static int mvneta_mac_prepare(struct phylink_config *config, unsigned int mode,
 			      phy_interface_t interface)
 {
@@ -4176,7 +4175,7 @@ static void mvneta_mac_link_up(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops mvneta_phylink_ops = {
-	.validate = mvneta_validate,
+	.validate = phylink_generic_validate,
 	.mac_prepare = mvneta_mac_prepare,
 	.mac_config = mvneta_mac_config,
 	.mac_finish = mvneta_mac_finish,
-- 
2.30.2

