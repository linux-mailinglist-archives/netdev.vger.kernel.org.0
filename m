Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539594ADC17
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379526AbiBHPMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351656AbiBHPMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:12:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7274C061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=y778rSaer7SHdzoEBNUEkWOYz2DakYuXvuN0Yx0h/tw=; b=eHoGCniHEojFT16Q39LWL66DGW
        WsgR2Fg3kzALklsKJu6HvYXRGw9BfIWT3BzBWr2/PdP8Z9msgkjBYXGKfMeTvV844szhMoUSMZG8U
        6ZtfwNnRj+sx/9KRGOEMo1+s+qlMepftPlttwKOQ9j8XpMQSghDmvn+sjTBWchaane3UM1lT6xf/5
        bMPC8HgPRJ6eUniQf8+6Z3Bt4CMB1VPq1xLp+ymO4pDcI6M8j6/IK3tLPCpZaxrJ4vpAqoQvfJqm9
        yaM+QCdt0BJ8CC+1vSWAkLtnSW31QRukjGbxVAGfTEZv7V7OnAhqIDSFM31ZOCYlveR0AOlocfu3b
        GNO0512A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38406 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nHS9x-0003Ia-Jz; Tue, 08 Feb 2022 15:12:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nHS9x-0070ZN-0l; Tue, 08 Feb 2022 15:12:01 +0000
In-Reply-To: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
References: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH CFT net-next 3/6] net: dsa: qca8k: move
 qca8k_phylink_mac_link_state()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nHS9x-0070ZN-0l@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 08 Feb 2022 15:12:01 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move qca8k_phylink_mac_link_state() to separate the code movement from
code changes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca8k.c | 84 ++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 22938d7cd161..fb052d6eae52 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1852,48 +1852,6 @@ static void qca8k_phylink_get_caps(struct dsa_switch *ds, int port,
 		MAC_10 | MAC_100 | MAC_1000FD;
 }
 
-static int
-qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			     struct phylink_link_state *state)
-{
-	struct qca8k_priv *priv = ds->priv;
-	u32 reg;
-	int ret;
-
-	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
-	if (ret < 0)
-		return ret;
-
-	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
-	state->an_complete = state->link;
-	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
-	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
-							   DUPLEX_HALF;
-
-	switch (reg & QCA8K_PORT_STATUS_SPEED) {
-	case QCA8K_PORT_STATUS_SPEED_10:
-		state->speed = SPEED_10;
-		break;
-	case QCA8K_PORT_STATUS_SPEED_100:
-		state->speed = SPEED_100;
-		break;
-	case QCA8K_PORT_STATUS_SPEED_1000:
-		state->speed = SPEED_1000;
-		break;
-	default:
-		state->speed = SPEED_UNKNOWN;
-		break;
-	}
-
-	state->pause = MLO_PAUSE_NONE;
-	if (reg & QCA8K_PORT_STATUS_RXFLOW)
-		state->pause |= MLO_PAUSE_RX;
-	if (reg & QCA8K_PORT_STATUS_TXFLOW)
-		state->pause |= MLO_PAUSE_TX;
-
-	return 1;
-}
-
 static void
 qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 			    phy_interface_t interface)
@@ -1944,6 +1902,48 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 	qca8k_write(priv, QCA8K_REG_PORT_STATUS(port), reg);
 }
 
+static int
+qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
+			     struct phylink_link_state *state)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg;
+	int ret;
+
+	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
+	if (ret < 0)
+		return ret;
+
+	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
+	state->an_complete = state->link;
+	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
+	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
+							   DUPLEX_HALF;
+
+	switch (reg & QCA8K_PORT_STATUS_SPEED) {
+	case QCA8K_PORT_STATUS_SPEED_10:
+		state->speed = SPEED_10;
+		break;
+	case QCA8K_PORT_STATUS_SPEED_100:
+		state->speed = SPEED_100;
+		break;
+	case QCA8K_PORT_STATUS_SPEED_1000:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		state->speed = SPEED_UNKNOWN;
+		break;
+	}
+
+	state->pause = MLO_PAUSE_NONE;
+	if (reg & QCA8K_PORT_STATUS_RXFLOW)
+		state->pause |= MLO_PAUSE_RX;
+	if (reg & QCA8K_PORT_STATUS_TXFLOW)
+		state->pause |= MLO_PAUSE_TX;
+
+	return 1;
+}
+
 static void
 qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 {
-- 
2.30.2

