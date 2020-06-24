Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C98207110
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388753AbgFXKWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387843AbgFXKVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:21:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226A5C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 03:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G5QhO2boACgBm3Ag9dvwXyV+uQb+OjSmNJpYd0emGKo=; b=cOndrAporIerD+5EbVyxl/38J7
        Nbf4906zHq4c9SR09ZaMh9zjH31JPvBPMj/oHBxTgjUYhF0nv316olG7a7FE+ubZRVaeklgMm1VYf
        01szyvuAsnqdQEOrEDp2d7QiQSSTsQcKbNk0BeJ/bpY0h1eLmzUNMLivHM7BvawiB3abo2+j3rrjI
        QYB6vVALCI46StscukYd60AzwCcviCrkJ5izdKm2XKpWU54qyRlhCrJ0uNhhHU/LweE4nIgUfS1L/
        gLJjILAba0oWPousFjhU/B05vRktBk+TUTPV5h4fIijlLuTkb5kGbw+qfRDxqkIoBge9qMoYj8d/9
        up9erUuw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57920 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jo2X6-0002sS-GB; Wed, 24 Jun 2020 11:21:32 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jo2X6-0005yf-55; Wed, 24 Jun 2020 11:21:32 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next] net: dsa/ar9331: convert to mac_link_up()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jo2X6-0005yf-55@rmk-PC.armlinux.org.uk>
Date:   Wed, 24 Jun 2020 11:21:32 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the ar9331 DSA driver to use the finalised link parameters in
mac_link_up() rather than the parameters in mac_config().

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca/ar9331.c | 60 +++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 7c86056b9401..e24a99031b80 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -97,8 +97,7 @@
 	(AR9331_SW_PORT_STATUS_TXMAC | AR9331_SW_PORT_STATUS_RXMAC)
 
 #define AR9331_SW_PORT_STATUS_LINK_MASK \
-	(AR9331_SW_PORT_STATUS_LINK_EN | AR9331_SW_PORT_STATUS_FLOW_LINK_EN | \
-	 AR9331_SW_PORT_STATUS_DUPLEX_MODE | \
+	(AR9331_SW_PORT_STATUS_DUPLEX_MODE | \
 	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
 	 AR9331_SW_PORT_STATUS_SPEED_M)
 
@@ -410,33 +409,10 @@ static void ar9331_sw_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
 	struct regmap *regmap = priv->regmap;
 	int ret;
-	u32 val;
-
-	switch (state->speed) {
-	case SPEED_1000:
-		val = AR9331_SW_PORT_STATUS_SPEED_1000;
-		break;
-	case SPEED_100:
-		val = AR9331_SW_PORT_STATUS_SPEED_100;
-		break;
-	case SPEED_10:
-		val = AR9331_SW_PORT_STATUS_SPEED_10;
-		break;
-	default:
-		return;
-	}
-
-	if (state->duplex)
-		val |= AR9331_SW_PORT_STATUS_DUPLEX_MODE;
-
-	if (state->pause & MLO_PAUSE_TX)
-		val |= AR9331_SW_PORT_STATUS_TX_FLOW_EN;
-
-	if (state->pause & MLO_PAUSE_RX)
-		val |= AR9331_SW_PORT_STATUS_RX_FLOW_EN;
 
 	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_STATUS(port),
-				 AR9331_SW_PORT_STATUS_LINK_MASK, val);
+				 AR9331_SW_PORT_STATUS_LINK_EN |
+				 AR9331_SW_PORT_STATUS_FLOW_LINK_EN, 0);
 	if (ret)
 		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
 }
@@ -464,11 +440,37 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
 	struct regmap *regmap = priv->regmap;
+	u32 val;
 	int ret;
 
+	val = AR9331_SW_PORT_STATUS_MAC_MASK;
+	switch (speed) {
+	case SPEED_1000:
+		val |= AR9331_SW_PORT_STATUS_SPEED_1000;
+		break;
+	case SPEED_100:
+		val |= AR9331_SW_PORT_STATUS_SPEED_100;
+		break;
+	case SPEED_10:
+		val |= AR9331_SW_PORT_STATUS_SPEED_10;
+		break;
+	default:
+		return;
+	}
+
+	if (duplex)
+		val |= AR9331_SW_PORT_STATUS_DUPLEX_MODE;
+
+	if (tx_pause)
+		val |= AR9331_SW_PORT_STATUS_TX_FLOW_EN;
+
+	if (rx_pause)
+		val |= AR9331_SW_PORT_STATUS_RX_FLOW_EN;
+
 	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_STATUS(port),
-				 AR9331_SW_PORT_STATUS_MAC_MASK,
-				 AR9331_SW_PORT_STATUS_MAC_MASK);
+				 AR9331_SW_PORT_STATUS_MAC_MASK |
+				 AR9331_SW_PORT_STATUS_LINK_MASK,
+				 val);
 	if (ret)
 		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
 }
-- 
2.20.1

