Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2809C5F13CE
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiI3Ujz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiI3Ujy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:39:54 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3542A12D20;
        Fri, 30 Sep 2022 13:39:43 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s206so5093894pgs.3;
        Fri, 30 Sep 2022 13:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=n3jf4asg8qPOB4ZVRerfUH0HCpQ2R9zhm0DdRq9708Y=;
        b=BUnlwXNWai3J+cJI5X1npv7AjpoyVNsQ0j0Xxrh0kozSOol60kjNSGpQQWtTtE6b3e
         Lz+nd4TBiMI0qXZmaJRg7BqVDutiu0faJo5tPVWk6j1iH2Zhh53n71eFXKDBmMwAfNmE
         gkkXJgzs2o/RsPXpk0if9CChK0g3LPbtWmfKa+SuDOD+vpUo/YqbTIR2mXs7ceLRlGqL
         ZDIpjfOvlz6wzJeoWVYiCt/BmwumiAiH1s9cEcFuiGubgSwzbxFdCeQgiiOG/9FPbl5M
         aGjTNaYew1OoF75cS04C2ElVB7ChkndDhE/0Ch+tyjgcSEdaIU5JYcVJCSOQbd3jMx8r
         t/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=n3jf4asg8qPOB4ZVRerfUH0HCpQ2R9zhm0DdRq9708Y=;
        b=kvKYZGy9gm/fnfblScc0owBwhqCgGnYkm0Kc+yOSt2IxcR01AX2GlRhOmkms9YYXiD
         uhuFqmxXpUgGz65wnMxdUiwNo2Ekt5UQH9QnkJT0JSVnLa3l97u8hhDcH32D2E43TGN6
         etBrDvtC0Yn7TmdHXQwp8u/JtWlkD4+ZEIIPAewOyZyJZp2XXqyoHfakmU3Nv8jExaPp
         ZAto1bFf5appTvDKm78T3TRcYZhr2YvjVjZtgou58v8RDQSbJc48ZRatYIdxCYDI2BNF
         UU8o6OeTxwxfbxw3NrkXVzPjNTLArBElfQFysvo5PFWJFwe0MgzWkYkCVqO9NfHjkVa1
         TPUg==
X-Gm-Message-State: ACrzQf0ABcQebeStS+Pc+SCYxEowPk9Dd3aCHCvRNFZQkaeTXeAkJY+3
        PxiJYKdCab6qJAdcWkMFgGQ=
X-Google-Smtp-Source: AMsMyM6z2SOgF5rbW7ElE3hI8IskGd4uE3ym85/aZxa1i2b3T0qUORVzkcMckgY+06A3vM0jR9f9KQ==
X-Received: by 2002:a62:c584:0:b0:558:2095:e5ed with SMTP id j126-20020a62c584000000b005582095e5edmr10768898pfg.64.1664570382648;
        Fri, 30 Sep 2022 13:39:42 -0700 (PDT)
Received: from y.dmz.cipunited.com ([104.28.245.203])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b0016dbe37cebdsm2327065plf.246.2022.09.30.13.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 13:39:42 -0700 (PDT)
From:   David Yang <mmyangfl@gmail.com>
To:     mmyangfl@gmail.com
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: mv643xx_eth: support MII/GMII/RGMII modes
Date:   Sat,  1 Oct 2022 04:39:25 +0800
Message-Id: <20220930203926.958776-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <YzdRdC1qgZY+8gQk@lunn.ch>
References: <YzdRdC1qgZY+8gQk@lunn.ch>
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
 drivers/net/ethernet/marvell/mv643xx_eth.c | 36 ++++++++++++++++++++--
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b6be0552a..ddaccc979 100644
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
+	u32 psc1r = rdlp(mp, PORT_SERIAL_CONTROL1);
 
 	if (dev->phydev->autoneg == AUTONEG_ENABLE) {
 		/* enable auto negotiation */
@@ -1245,6 +1247,30 @@ static void mv643xx_eth_adjust_link(struct net_device *dev)
 
 out_write:
 	wrlp(mp, PORT_SERIAL_CONTROL, pscr);
+
+	/* If two Ethernet controllers present in the SoC, and both of them have
+	 * RGMII_EN disabled, the first controller will be in GMII mode and the
+	 * second one is effectively disabled, instead of two MII interfaces.
+	 *
+	 * To enable GMII in the first controller, the second one must also be
+	 * configured (and may be enabled) with RGMII_EN disabled too, even
+	 * though it cannot be used at all.
+	 */
+	switch (dev->phydev->interface) {
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_GMII:
+		wrlp(mp, PORT_SERIAL_CONTROL1, psc1r & ~RGMII_EN);
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		wrlp(mp, PORT_SERIAL_CONTROL1, psc1r | RGMII_EN);
+		break;
+	default:
+		/* Unknown; don't touch */
+		break;
+	}
 }
 
 /* statistics ***************************************************************/
@@ -2975,11 +3001,15 @@ static int get_phy_mode(struct mv643xx_eth_private *mp)
 	if (dev->of_node)
 		err = of_get_phy_mode(dev->of_node, &iface);
 
-	/* Historical default if unspecified. We could also read/write
-	 * the interface state in the PSC1
+	/* Read the interface state in the PSC1.
+	 *
+	 * Modes of two devices may interact; see comments in
+	 * mv643xx_eth_adjust_link. Currently there is no way to detect another
+	 * device within this scope; blindly set MII here.
 	 */
 	if (!dev->of_node || err)
-		iface = PHY_INTERFACE_MODE_GMII;
+		iface = rdlp(mp, PORT_SERIAL_CONTROL1) & RGMII_EN ?
+			PHY_INTERFACE_MODE_RGMII : PHY_INTERFACE_MODE_MII;
 	return iface;
 }
 
-- 
2.35.1

