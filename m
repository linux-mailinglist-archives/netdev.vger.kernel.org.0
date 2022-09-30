Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56845F14FD
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 23:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiI3Vf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 17:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiI3Vf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 17:35:56 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93621005F9;
        Fri, 30 Sep 2022 14:35:54 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id u69so5202167pgd.2;
        Fri, 30 Sep 2022 14:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=aehKvygnNVnwWIxV17HHVrvOkb3OM5/7lXvhi9XQib4=;
        b=hgj9Yl3opLNyN2ew9Q72rD0g/i+rSTBxJNWHJ1VKEs1YIef3zenlNa+PH3ragLaEcB
         8DEi1uNY0VHu264f09M+K7PE3Q45r9pnMmCyPWH9iwEbj3JN7wSIgjAFHdQjnfPkWMmF
         Yb+52NPmmRnPymZQ9j0133QdR3pJ2Bre6rh1SUxrDj6hdI2TJio8BEiTtUUuU2NKWcW+
         Equa8gom0eh6vNMtgz0at4/xqrjaioGFjEXxhifySTVMHbZ86vH8Hb0EULn+8dcUrfc5
         RwXTaZIMjRhUQGcnYFA7JFqFeylaeQ03f6qTrxT0SE0ZQa7izehmpYsliKDjtrWVxuRY
         nd3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=aehKvygnNVnwWIxV17HHVrvOkb3OM5/7lXvhi9XQib4=;
        b=H4MCHSVh0tJiqARDSwQ7HWjD2AO+P1Vu/b7e7wijXEDgbPEVn2Q+3zsKxOU5vmiLbR
         Nj8TUTst+ygWbZGlveYGpvoBCnx0IbuKlX5Lk9XmiCQ4GYYjfPGGc47G89mYaHERB90W
         WbgIXsGV6b7ZG2D1NpLdz4iQGFB/y5fD7C4OIoRksMRoeNclnszVyv0+sIgOePP6zNeC
         ooCPVj6rR/hOezjhytUki1F82XzTMXZmS+Fsm94f1qcrOHNRbosG4DYgXRHWYlANfqnG
         1PL4MbVuU2FbAv3bxMX/ohuGUsApZErlRz4mkLAQFk/ybWg6nEAyQSbRnlk/vEeutkYa
         seRA==
X-Gm-Message-State: ACrzQf2hZLMtTU4gwFeyQ2vKB/3Sul3tFOok029IgQ8HGSON7wE4w21f
        mrz+Wy2DD9pAfNPCd3PMG4s=
X-Google-Smtp-Source: AMsMyM7ljjvr/bTd87ubin7tY29cHxp/Q0Tk6wUqxZ/dLU67g9RXnqJiRcazjrNGaWQuggLKJDN5iQ==
X-Received: by 2002:a63:18c:0:b0:43c:b924:342c with SMTP id 134-20020a63018c000000b0043cb924342cmr9144890pgb.496.1664573754047;
        Fri, 30 Sep 2022 14:35:54 -0700 (PDT)
Received: from y.dmz.cipunited.com ([104.28.245.203])
        by smtp.gmail.com with ESMTPSA id y17-20020a170903011100b001788494b764sm2314192plc.231.2022.09.30.14.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 14:35:53 -0700 (PDT)
From:   David Yang <mmyangfl@gmail.com>
To:     mmyangfl@gmail.com
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood
Date:   Sat,  1 Oct 2022 05:35:34 +0800
Message-Id: <20220930213534.962336-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <YzdaAlg77SyrgjE3@lunn.ch>
References: <YzdaAlg77SyrgjE3@lunn.ch>
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
 drivers/net/ethernet/marvell/mv643xx_eth.c | 48 ++++++++++++++++++++--
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b6be0552a..355bb8ba7 100644
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
@@ -367,6 +368,7 @@ struct mv643xx_eth_private {
 	struct mv643xx_eth_shared_private *shared;
 	void __iomem *base;
 	int port_num;
+	bool kirkwood;
 
 	struct net_device *dev;
 
@@ -1215,6 +1217,7 @@ static void mv643xx_eth_adjust_link(struct net_device *dev)
 	             DISABLE_AUTO_NEG_SPEED_GMII |
 		     DISABLE_AUTO_NEG_FOR_FLOW_CTRL |
 		     DISABLE_AUTO_NEG_FOR_DUPLEX;
+	u32 psc1r;
 
 	if (dev->phydev->autoneg == AUTONEG_ENABLE) {
 		/* enable auto negotiation */
@@ -1245,6 +1248,36 @@ static void mv643xx_eth_adjust_link(struct net_device *dev)
 
 out_write:
 	wrlp(mp, PORT_SERIAL_CONTROL, pscr);
+
+	if (mp->kirkwood) {
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
@@ -2975,11 +3008,16 @@ static int get_phy_mode(struct mv643xx_eth_private *mp)
 	if (dev->of_node)
 		err = of_get_phy_mode(dev->of_node, &iface);
 
-	/* Historical default if unspecified. We could also read/write
-	 * the interface state in the PSC1
+	/* Read the interface state in the PSC1.
+	 *
+	 * Modes of two devices may interact on Kirkwood. Currently there is no
+	 * way to detect another device within this scope; blindly set MII
+	 * here.
 	 */
 	if (!dev->of_node || err)
-		iface = PHY_INTERFACE_MODE_GMII;
+		iface = rdlp(mp, PORT_SERIAL_CONTROL1) & RGMII_EN ?
+			PHY_INTERFACE_MODE_RGMII : mp->kirkwood ?
+			PHY_INTERFACE_MODE_MII : PHY_INTERFACE_MODE_GMII;
 	return iface;
 }
 
@@ -3124,9 +3162,11 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	 * all other SoCs/System Controllers using this driver.
 	 */
 	if (of_device_is_compatible(pdev->dev.of_node,
-				    "marvell,kirkwood-eth-port"))
+				    "marvell,kirkwood-eth-port")) {
 		wrlp(mp, PORT_SERIAL_CONTROL1,
 		     rdlp(mp, PORT_SERIAL_CONTROL1) & ~CLK125_BYPASS_EN);
+		mp->kirkwood = 1;
+	}
 
 	/*
 	 * Start with a default rate, and if there is a clock, allow
-- 
2.35.1

