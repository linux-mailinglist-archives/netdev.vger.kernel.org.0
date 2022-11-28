Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9387E63A7C4
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiK1MBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiK1MAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567CB1901E
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:45 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoQ-0005HV-TH; Mon, 28 Nov 2022 13:00:38 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoP-000oAv-88; Mon, 28 Nov 2022 13:00:38 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoO-00H6PN-2w; Mon, 28 Nov 2022 13:00:36 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v1 14/26] net: dsa: microchip: KSZ88x3 fix loopback support
Date:   Mon, 28 Nov 2022 13:00:22 +0100
Message-Id: <20221128120034.4075562-15-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128120034.4075562-1-o.rempel@pengutronix.de>
References: <20221128120034.4075562-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With current code loopback is not working and selftest will always fail.
Fix register and bit offsets to make loopback on KSZ88x3 switches.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c     | 24 ++++++++++++++++++------
 drivers/net/dsa/microchip/ksz8795_reg.h |  1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 208cf4dde397..a6d5de41a754 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -625,8 +625,13 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		if (ret)
 			return ret;
 
-		if (restart & PORT_PHY_LOOPBACK)
-			data |= BMCR_LOOPBACK;
+		if (ksz_is_ksz88x3(dev)) {
+			if (restart & KSZ8873_PORT_PHY_LOOPBACK)
+				data |= BMCR_LOOPBACK;
+		} else {
+			if (restart & PORT_PHY_LOOPBACK)
+				data |= BMCR_LOOPBACK;
+		}
 		if (ctrl & PORT_FORCE_100_MBIT)
 			data |= BMCR_SPEED100;
 		if (ksz_is_ksz88x3(dev)) {
@@ -849,10 +854,17 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			data |= PORT_FORCE_MDIX;
 		else
 			data &= ~PORT_FORCE_MDIX;
-		if (val & BMCR_LOOPBACK)
-			data |= PORT_PHY_LOOPBACK;
-		else
-			data &= ~PORT_PHY_LOOPBACK;
+		if (ksz_is_ksz88x3(dev)) {
+			if (val & BMCR_LOOPBACK)
+				data |= KSZ8873_PORT_PHY_LOOPBACK;
+			else
+				data &= ~KSZ8873_PORT_PHY_LOOPBACK;
+		} else {
+			if (val & BMCR_LOOPBACK)
+				data |= PORT_PHY_LOOPBACK;
+			else
+				data &= ~PORT_PHY_LOOPBACK;
+		}
 
 		if (data != restart) {
 			ret = ksz_pwrite8(dev, p, regs[P_NEG_RESTART_CTRL],
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 0bdceb534192..08204da7d621 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -262,6 +262,7 @@
 #define PORT_AUTO_MDIX_DISABLE		BIT(2)
 #define PORT_FORCE_MDIX			BIT(1)
 #define PORT_MAC_LOOPBACK		BIT(0)
+#define KSZ8873_PORT_PHY_LOOPBACK	BIT(0)
 
 #define REG_PORT_1_STATUS_2		0x1E
 #define REG_PORT_2_STATUS_2		0x2E
-- 
2.30.2

