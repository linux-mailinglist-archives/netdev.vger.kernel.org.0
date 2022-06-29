Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E202F55FFB7
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiF2MVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiF2MVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:21:14 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C6C2EA2F;
        Wed, 29 Jun 2022 05:21:10 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 96B94100002;
        Wed, 29 Jun 2022 12:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656505269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=c83soaBUi/uJOyhuJxfgA9+0o0F+wKpVmr2GzEnt4rM=;
        b=kGcnfWJWZlnAzSbBxJysIe3WGP9752id2n6DN9QVWk/Zpz75XuqU8yvD+dm8TkTwayyZMP
        NqCADVRu7iKk2knk22U5A5SFZ1yV2FT02jgIDoE7jDXW/PnjO2KizVzlfSOtCPvP9xd88f
        bUs6oByIwRyh99+jXXBmVtrOU+MpDjlW70b1A4vttUQ0qsZTHGXT1dZjyaJt9ejJJUhH5x
        6br3/EuRYFZl6oTRTJkGa3Ngppf0tOf5ewEyCP/mSrZ2YtfheAM5R7Xs2l9J0ic1YIKzsf
        2qznzpdihAnfr5SGN4vnrNXQMnwN5pPXFa7MW/K6mvbJtLCij/Y/gESgSgs/Bg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: [PATCH net-next] net: pcs: rzn1-miic: update speed only if interface is changed
Date:   Wed, 29 Jun 2022 14:20:03 +0200
Message-Id: <20220629122003.189397-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated by Russel King, miic_config() can be called as a result of
ethtool setting the configuration while the link is already up. Since
the speed is also set in this function, it could potentially modify
the current speed that is set. This will only happen if there is
no PHY present and we aren't using fixed-link mode.

Handle that by storing the current interface mode in the miic_port
structure and update the speed only if the interface mode is going to
be changed.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/pcs/pcs-rzn1-miic.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
index 8f5e910f443d..a7dab7b48dda 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -138,11 +138,13 @@ struct miic {
  * @miic: backiling to MII converter structure
  * @pcs: PCS structure associated to the port
  * @port: port number
+ * @interface: interface mode of the port
  */
 struct miic_port {
 	struct miic *miic;
 	struct phylink_pcs pcs;
 	int port;
+	phy_interface_t interface;
 };
 
 static struct miic_port *phylink_pcs_to_miic_port(struct phylink_pcs *pcs)
@@ -190,8 +192,8 @@ static int miic_config(struct phylink_pcs *pcs, unsigned int mode,
 {
 	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
 	struct miic *miic = miic_port->miic;
+	u32 speed, conv_mode, val, mask;
 	int port = miic_port->port;
-	u32 speed, conv_mode, val;
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_RMII:
@@ -216,11 +218,20 @@ static int miic_config(struct phylink_pcs *pcs, unsigned int mode,
 		return -EOPNOTSUPP;
 	}
 
-	val = FIELD_PREP(MIIC_CONVCTRL_CONV_MODE, conv_mode) |
-	      FIELD_PREP(MIIC_CONVCTRL_CONV_SPEED, speed);
+	val = FIELD_PREP(MIIC_CONVCTRL_CONV_MODE, conv_mode);
+	mask = MIIC_CONVCTRL_CONV_MODE;
 
-	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
-		     MIIC_CONVCTRL_CONV_MODE | MIIC_CONVCTRL_CONV_SPEED, val);
+	/* Update speed only if we are going to change the interface because
+	 * the link might already be up and it would break it if the speed is
+	 * changed.
+	 */
+	if (interface != miic_port->interface) {
+		val |= FIELD_PREP(MIIC_CONVCTRL_CONV_SPEED, speed);
+		mask |= MIIC_CONVCTRL_CONV_SPEED;
+		miic_port->interface = interface;
+	}
+
+	miic_reg_rmw(miic, MIIC_CONVCTRL(port), mask, val);
 	miic_converter_enable(miic_port->miic, miic_port->port, 1);
 
 	return 0;
-- 
2.36.1

