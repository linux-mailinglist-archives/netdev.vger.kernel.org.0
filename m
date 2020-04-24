Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC0B1B6CED
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 06:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgDXE7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 00:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgDXE7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 00:59:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EE7C09B045
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 21:59:24 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jRqQo-0001DJ-IO; Fri, 24 Apr 2020 06:59:18 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jRqQm-0006xK-0d; Fri, 24 Apr 2020 06:59:16 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1] net: ag71xx: extend link validation to support other SoCs
Date:   Fri, 24 Apr 2020 06:59:14 +0200
Message-Id: <20200424045914.26682-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most (all?) QCA SoCs have two MAC with different supported link
capabilities. Extend ag71xx_mac_validate() to properly validate this
variants.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/atheros/ag71xx.c | 43 +++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 02b7705393ca7..112edbd308230 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -871,13 +871,40 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 			    unsigned long *supported,
 			    struct phylink_link_state *state)
 {
+	struct ag71xx *ag = netdev_priv(to_net_dev(config->dev));
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != PHY_INTERFACE_MODE_GMII &&
-	    state->interface != PHY_INTERFACE_MODE_MII) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		if ((ag71xx_is(ag, AR9330) && ag->mac_idx == 0) ||
+		    ag71xx_is(ag, AR9340) ||
+		    ag71xx_is(ag, QCA9530) ||
+		    (ag71xx_is(ag, QCA9550) && ag->mac_idx == 1))
+			break;
+		goto unsupported;
+	case PHY_INTERFACE_MODE_GMII:
+		if ((ag71xx_is(ag, AR9330) && ag->mac_idx == 1) ||
+		    (ag71xx_is(ag, AR9340) && ag->mac_idx == 1) ||
+		    (ag71xx_is(ag, QCA9530) && ag->mac_idx == 1))
+			break;
+		goto unsupported;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (ag71xx_is(ag, QCA9550) && ag->mac_idx == 0)
+			break;
+		goto unsupported;
+	case PHY_INTERFACE_MODE_RMII:
+		if (ag71xx_is(ag, AR9340) && ag->mac_idx == 0)
+			break;
+		goto unsupported;
+	case PHY_INTERFACE_MODE_RGMII:
+		if ((ag71xx_is(ag, AR9340) && ag->mac_idx == 0) ||
+		    (ag71xx_is(ag, QCA9550) && ag->mac_idx == 1))
+			break;
+		goto unsupported;
+	default:
+		goto unsupported;
 	}
 
 	phylink_set(mask, MII);
@@ -889,6 +916,8 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 	phylink_set(mask, 100baseT_Full);
 
 	if (state->interface == PHY_INTERFACE_MODE_NA ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII ||
+	    state->interface == PHY_INTERFACE_MODE_RGMII ||
 	    state->interface == PHY_INTERFACE_MODE_GMII) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
@@ -898,6 +927,10 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	return;
+unsupported:
+	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
 static void ag71xx_mac_pcs_get_state(struct phylink_config *config,
-- 
2.26.1

