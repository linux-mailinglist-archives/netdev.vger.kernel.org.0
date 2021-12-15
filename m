Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73131475BE7
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243963AbhLOPeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243961AbhLOPee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:34:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B17C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gvScNo3qi2TTahJbWTiB0fSj+uuJpxCLJG+07IacN0c=; b=CasxHDesnjJT/jch5oUjzmLDzU
        6CPuenkUj+SQNcuF1U3j0YYNNv960xbRmBmulYQsmHF1xrX3zcgNL56GE5OHNPoilaXzSIfZl9amS
        wWk34kX3jhRjBa7AlJuP2ok16Y17p8s0SFitAudDbU5+0hfWD8zhID7sriQB6aG3bxhPmMzfsCr+s
        d8vqCLTltw09Y7kIKNcu3On7Q7R5o7F5WXgUbcAT19an7aM70XG2mbOzaMDZvPxD5R7/rczQUJedG
        woOwlCaTHfrVTJ94W1GFpwYDzVFjgR4PbSRxFMLeyvke2zK4T8njLmWCgKavOab+FkA8kmhL8rQgq
        bn9Yjqow==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43824 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIY-0006ZZ-TZ; Wed, 15 Dec 2021 15:34:30 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIY-00GPiQ-GH; Wed, 15 Dec 2021 15:34:30 +0000
In-Reply-To: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
References: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 net-next 4/7] net: mvpp2: convert to pcs_validate() and
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxWIY-00GPiQ-GH@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 15 Dec 2021 15:34:30 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvpp2 to validate the autoneg state for 1000base-X in the
pcs_validate() operation, rather than the MAC validate() operation.
This allows us to switch the MAC validate() to use
phylink_generic_validate().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 37 +++++++++----------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f5e10fe7812b..c5e49bbf462f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6166,6 +6166,21 @@ static const struct phylink_pcs_ops mvpp2_phylink_xlg_pcs_ops = {
 	.pcs_config = mvpp2_xlg_pcs_config,
 };
 
+static int mvpp2_gmac_pcs_validate(struct phylink_pcs *pcs,
+				   unsigned long *supported,
+				   const struct phylink_link_state *state)
+{
+	/* When in 802.3z mode, we must have AN enabled:
+	 * Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
+	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1.
+	 */
+	if (phy_interface_mode_is_8023z(state->interface) &&
+	    !phylink_test(state->advertising, Autoneg))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void mvpp2_gmac_pcs_get_state(struct phylink_pcs *pcs,
 				     struct phylink_link_state *state)
 {
@@ -6270,30 +6285,12 @@ static void mvpp2_gmac_pcs_an_restart(struct phylink_pcs *pcs)
 }
 
 static const struct phylink_pcs_ops mvpp2_phylink_gmac_pcs_ops = {
+	.pcs_validate = mvpp2_gmac_pcs_validate,
 	.pcs_get_state = mvpp2_gmac_pcs_get_state,
 	.pcs_config = mvpp2_gmac_pcs_config,
 	.pcs_an_restart = mvpp2_gmac_pcs_an_restart,
 };
 
-static void mvpp2_phylink_validate(struct phylink_config *config,
-				   unsigned long *supported,
-				   struct phylink_link_state *state)
-{
-	/* When in 802.3z mode, we must have AN enabled:
-	 * Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
-	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1.
-	 */
-	if (phy_interface_mode_is_8023z(state->interface) &&
-	    !phylink_test(state->advertising, Autoneg))
-		goto empty_set;
-
-	phylink_generic_validate(config, supported, state);
-	return;
-
-empty_set:
-	linkmode_zero(supported);
-}
-
 static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
@@ -6611,7 +6608,7 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops mvpp2_phylink_ops = {
-	.validate = mvpp2_phylink_validate,
+	.validate = phylink_generic_validate,
 	.mac_select_pcs = mvpp2_select_pcs,
 	.mac_prepare = mvpp2_mac_prepare,
 	.mac_config = mvpp2_mac_config,
-- 
2.30.2

