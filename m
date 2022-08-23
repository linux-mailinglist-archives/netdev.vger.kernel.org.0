Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED9D59D2FE
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 10:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbiHWIDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 04:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241544AbiHWIC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 04:02:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE19E659F1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:02:54 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrt-0002vp-OU; Tue, 23 Aug 2022 10:02:38 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrr-001SvF-QS; Tue, 23 Aug 2022 10:02:35 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrp-00ALYe-5T; Tue, 23 Aug 2022 10:02:33 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 07/17] net: dsa: microchip: ksz8795: add error handling to ksz8_r/w_phy
Date:   Tue, 23 Aug 2022 10:02:21 +0200
Message-Id: <20220823080231.2466017-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220823080231.2466017-1-o.rempel@pengutronix.de>
References: <20220823080231.2466017-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now ksz_pread/ksz_pwrite can return error value. So, make use of it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 102 ++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index f2dd75ee0e075..f020d9f402845 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -560,14 +560,24 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 	u8 val1, val2;
 	u16 data = 0;
 	u8 p = phy;
+	int ret;
 
 	regs = dev->info->regs;
 
 	switch (reg) {
 	case MII_BMCR:
-		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
-		ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
-		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
+		ret = ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
+		if (ret)
+			return ret;
+
+		ret = ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
+		if (ret)
+			return ret;
+
+		ret = ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
+		if (ret)
+			return ret;
+
 		if (restart & PORT_PHY_LOOPBACK)
 			data |= BMCR_LOOPBACK;
 		if (ctrl & PORT_FORCE_100_MBIT)
@@ -597,7 +607,10 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= KSZ886X_BMCR_DISABLE_LED;
 		break;
 	case MII_BMSR:
-		ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
+		ret = ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
+		if (ret)
+			return ret;
+
 		data = BMSR_100FULL |
 		       BMSR_100HALF |
 		       BMSR_10FULL |
@@ -618,7 +631,10 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data = KSZ8795_ID_LO;
 		break;
 	case MII_ADVERTISE:
-		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
+		ret = ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
+		if (ret)
+			return ret;
+
 		data = ADVERTISE_CSMA;
 		if (ctrl & PORT_AUTO_NEG_SYM_PAUSE)
 			data |= ADVERTISE_PAUSE_CAP;
@@ -632,7 +648,10 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= ADVERTISE_10HALF;
 		break;
 	case MII_LPA:
-		ksz_pread8(dev, p, regs[P_REMOTE_STATUS], &link);
+		ret = ksz_pread8(dev, p, regs[P_REMOTE_STATUS], &link);
+		if (ret)
+			return ret;
+
 		data = LPA_SLCT;
 		if (link & PORT_REMOTE_SYM_PAUSE)
 			data |= LPA_PAUSE_CAP;
@@ -648,8 +667,14 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data |= LPA_LPACK;
 		break;
 	case PHY_REG_LINK_MD:
-		ksz_pread8(dev, p, REG_PORT_LINK_MD_CTRL, &val1);
-		ksz_pread8(dev, p, REG_PORT_LINK_MD_RESULT, &val2);
+		ret = ksz_pread8(dev, p, REG_PORT_LINK_MD_CTRL, &val1);
+		if (ret)
+			return ret;
+
+		ret = ksz_pread8(dev, p, REG_PORT_LINK_MD_RESULT, &val2);
+		if (ret)
+			return ret;
+
 		if (val1 & PORT_START_CABLE_DIAG)
 			data |= PHY_START_CABLE_DIAG;
 
@@ -664,7 +689,10 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 				FIELD_GET(PORT_CABLE_FAULT_COUNTER_L, val2));
 		break;
 	case PHY_REG_PHY_CTRL:
-		ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
+		ret = ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
+		if (ret)
+			return ret;
+
 		if (link & PORT_MDIX_STATUS)
 			data |= KSZ886X_CTRL_MDIX_STAT;
 		break;
@@ -683,6 +711,7 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	u8 restart, speed, ctrl, data;
 	const u16 *regs;
 	u8 p = phy;
+	int ret;
 
 	regs = dev->info->regs;
 
@@ -692,15 +721,26 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		/* Do not support PHY reset function. */
 		if (val & BMCR_RESET)
 			break;
-		ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
+		ret = ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
+		if (ret)
+			return ret;
+
 		data = speed;
 		if (val & KSZ886X_BMCR_HP_MDIX)
 			data |= PORT_HP_MDIX;
 		else
 			data &= ~PORT_HP_MDIX;
-		if (data != speed)
-			ksz_pwrite8(dev, p, regs[P_SPEED_STATUS], data);
-		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
+
+		if (data != speed) {
+			ret = ksz_pwrite8(dev, p, regs[P_SPEED_STATUS], data);
+			if (ret)
+				return ret;
+		}
+
+		ret = ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
+		if (ret)
+			return ret;
+
 		data = ctrl;
 		if (ksz_is_ksz88x3(dev)) {
 			if ((val & BMCR_ANENABLE))
@@ -726,9 +766,17 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			data |= PORT_FORCE_FULL_DUPLEX;
 		else
 			data &= ~PORT_FORCE_FULL_DUPLEX;
-		if (data != ctrl)
-			ksz_pwrite8(dev, p, regs[P_FORCE_CTRL], data);
-		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
+
+		if (data != ctrl) {
+			ret = ksz_pwrite8(dev, p, regs[P_FORCE_CTRL], data);
+			if (ret)
+				return ret;
+		}
+
+		ret = ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
+		if (ret)
+			return ret;
+
 		data = restart;
 		if (val & KSZ886X_BMCR_DISABLE_LED)
 			data |= PORT_LED_OFF;
@@ -758,11 +806,19 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			data |= PORT_PHY_LOOPBACK;
 		else
 			data &= ~PORT_PHY_LOOPBACK;
-		if (data != restart)
-			ksz_pwrite8(dev, p, regs[P_NEG_RESTART_CTRL], data);
+
+		if (data != restart) {
+			ret = ksz_pwrite8(dev, p, regs[P_NEG_RESTART_CTRL],
+					  data);
+			if (ret)
+				return ret;
+		}
 		break;
 	case MII_ADVERTISE:
-		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
+		ret = ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
+		if (ret)
+			return ret;
+
 		data = ctrl;
 		data &= ~(PORT_AUTO_NEG_SYM_PAUSE |
 			  PORT_AUTO_NEG_100BTX_FD |
@@ -779,8 +835,12 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			data |= PORT_AUTO_NEG_10BT_FD;
 		if (val & ADVERTISE_10HALF)
 			data |= PORT_AUTO_NEG_10BT;
-		if (data != ctrl)
-			ksz_pwrite8(dev, p, regs[P_LOCAL_CTRL], data);
+
+		if (data != ctrl) {
+			ret = ksz_pwrite8(dev, p, regs[P_LOCAL_CTRL], data);
+			if (ret)
+				return ret;
+		}
 		break;
 	case PHY_REG_LINK_MD:
 		if (val & PHY_START_CABLE_DIAG)
-- 
2.30.2

