Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3215F1616
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiI3W0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiI3W03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:26:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2E9C1102;
        Fri, 30 Sep 2022 15:26:28 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so10333633pjs.4;
        Fri, 30 Sep 2022 15:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Vd+ezwHI+XbFG5sYoINEgOA71mjuxAxKQMS6k4S65cM=;
        b=bNxXowrzlghED/m8Qr9iu9w8tQuGJhk6ktqp8UkH6+0Vy1ZwnbVNcDul6CDEG9UP4W
         Hc89w6q645U0fcX2ig8SraoH7HeT5WHHUN5JO6lxqxk2LcJ9IcxWulfbYTyxwnmaxSs4
         cLBFhYN1bMtBeyITWqXlsWOFB2sWm9VzRjAHPQwD5EPq9h84zERQkhjJkDJUAEKvPCdz
         n7AFKWaBrPwc8Kz+1i3LpmjSSxYnZbIQiiobIkCwlr8Ht72yWXyZ5Y20tkXTN4CfZs50
         SyUkfJw+oY7tUN309a+lM4Z+QsWWjpvGxGLI4dWoXu7+G49HCTj1UIqnhbG0YXZL4yd1
         ZmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Vd+ezwHI+XbFG5sYoINEgOA71mjuxAxKQMS6k4S65cM=;
        b=mCg3tT/I2Equhbiyl+T6B1GM2hEPcROsRCnSeFPR2p3X/e2DWbgiiqNY82zP60D4rU
         puxZ3Dadcbhn84VHUNm2T7ZNaH69jtL8BYYZ58yFpMxt6dgQMjEWPXoQ5O6QBZA1KigN
         wu0Myqkq5zdwOT4ADaogUrQfd+ZuO9t91pTrRQZtwHcruaEbrTPSLf8gfdPIgpGQvQLJ
         s/JiupjCe0tM2seRXx6B+kvuZIIcbNtBaRklUKzDjBA2tHf+kbk7aRYTv+FlI7oGvLQl
         WB51rgAYDc+nr5NV7ryUcIlng+IvCOV93YEY9wQfiPF0m5Cb9/9f6cHnR/Gt2ZCdJm36
         bgcQ==
X-Gm-Message-State: ACrzQf1yOpnZR4PauZHFkWE7iVg0IEUNwtwSOf23D4kth32dUkPh64IJ
        PVgoPM+n1PsUp2wWygqE8bw=
X-Google-Smtp-Source: AMsMyM7SPngUdwIUOS7nyrZRsepXWNheopEzkCTAPzt+dz73T5/ZC+TTfIuTdEGHNP60QkkMy4+bCQ==
X-Received: by 2002:a17:902:900a:b0:178:77c7:aa28 with SMTP id a10-20020a170902900a00b0017877c7aa28mr10933215plp.3.1664576788323;
        Fri, 30 Sep 2022 15:26:28 -0700 (PDT)
Received: from y.dmz.cipunited.com ([104.28.245.203])
        by smtp.gmail.com with ESMTPSA id ei23-20020a17090ae55700b0020a11217682sm1733790pjb.27.2022.09.30.15.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 15:26:27 -0700 (PDT)
From:   David Yang <mmyangfl@gmail.com>
To:     mmyangfl@gmail.com
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] net: mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood
Date:   Sat,  1 Oct 2022 06:25:39 +0800
Message-Id: <20220930222540.966357-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930213534.962336-1-mmyangfl@gmail.com>
References: <20220930213534.962336-1-mmyangfl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support mode switch properly, which is not available before.

If SoC has two Ethernet controllers, by setting both of them into MII
mode, the first controller enters GMII mode, while the second
controller is effectively disabled. This requires configuring (and
maybe enabling) the second controller in the device tree, even though
it cannot be used.

Signed-off-by: David Yang <mmyangfl@gmail.com>
---
v2: clarify modes work on controllers, read default value from PSC1
v3: Kirkwood only
v4: cleanup
 drivers/net/ethernet/marvell/mv643xx_eth.c | 57 +++++++++++++++++++---
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b6be0552a..4d4ee36b5 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -108,6 +108,7 @@ static char mv643xx_eth_driver_version[] = "1.4";
 #define TXQ_COMMAND			0x0048
 #define TXQ_FIX_PRIO_CONF		0x004c
 #define PORT_SERIAL_CONTROL1		0x004c
+#define  RGMII_EN			0x00000008
 #define  CLK125_BYPASS_EN		0x00000010
 #define TX_BW_RATE			0x0050
 #define TX_BW_MTU			0x0058
@@ -1215,6 +1216,7 @@ static void mv643xx_eth_adjust_link(struct net_device *dev)
 	             DISABLE_AUTO_NEG_SPEED_GMII |
 		     DISABLE_AUTO_NEG_FOR_FLOW_CTRL |
 		     DISABLE_AUTO_NEG_FOR_DUPLEX;
+	u32 psc1r;
 
 	if (dev->phydev->autoneg == AUTONEG_ENABLE) {
 		/* enable auto negotiation */
@@ -1245,6 +1247,38 @@ static void mv643xx_eth_adjust_link(struct net_device *dev)
 
 out_write:
 	wrlp(mp, PORT_SERIAL_CONTROL, pscr);
+
+	if (dev->dev->of_node &&
+	    of_device_is_compatible(dev->dev->of_node,
+				    "marvell,kirkwood-eth-port")) {
+		psc1r = rdlp(mp, PORT_SERIAL_CONTROL1);
+		/* On Kirkwood with two Ethernet controllers, if both of them
+		 * have RGMII_EN disabled, the first controller will be in GMII
+		 * mode and the second one is effectively disabled, instead of
+		 * two MII interfaces.
+		 *
+		 * To enable GMII in the first controller, the second one must
+		 * also be configured (and may be enabled) with RGMII_EN
+		 * disabled too, even though it cannot be used at all.
+		 */
+		switch (dev->phydev->interface) {
+		case PHY_INTERFACE_MODE_MII:
+		case PHY_INTERFACE_MODE_GMII:
+			psc1r &= ~RGMII_EN;
+			break;
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+			psc1r |= RGMII_EN;
+			break;
+		default:
+			/* Unknown; don't touch */
+			break;
+		}
+
+		wrlp(mp, PORT_SERIAL_CONTROL1, psc1r);
+	}
 }
 
 /* statistics ***************************************************************/
@@ -2972,15 +3006,26 @@ static int get_phy_mode(struct mv643xx_eth_private *mp)
 	phy_interface_t iface;
 	int err;
 
-	if (dev->of_node)
+	if (dev->of_node) {
 		err = of_get_phy_mode(dev->of_node, &iface);
+		if (!err)
+			return iface;
+	}
+
+	/* Read the interface state in the PSC1 */
+	if (rdlp(mp, PORT_SERIAL_CONTROL1) & RGMII_EN)
+		return PHY_INTERFACE_MODE_RGMII;
 
-	/* Historical default if unspecified. We could also read/write
-	 * the interface state in the PSC1
+	/* Modes of two devices may interact on Kirkwood. Currently there is no
+	 * way to detect another device within this scope; blindly set MII
+	 * here.
 	 */
-	if (!dev->of_node || err)
-		iface = PHY_INTERFACE_MODE_GMII;
-	return iface;
+	if (dev->of_node &&
+	    of_device_is_compatible(dev->of_node, "marvell,kirkwood-eth"))
+		return PHY_INTERFACE_MODE_MII;
+
+	/* Historical default if unspecified */
+	return PHY_INTERFACE_MODE_GMII;
 }
 
 static struct phy_device *phy_scan(struct mv643xx_eth_private *mp,
-- 
2.35.1

