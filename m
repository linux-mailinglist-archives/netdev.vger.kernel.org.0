Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADB8390F8E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhEZEce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbhEZEcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:32:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D4FC06138D
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 21:30:52 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBo-0001Oq-Bb; Wed, 26 May 2021 06:30:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBm-0002bx-HG; Wed, 26 May 2021 06:30:38 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v3 1/9] net: phy: micrel: move phy reg offsets to common header
Date:   Wed, 26 May 2021 06:30:29 +0200
Message-Id: <20210526043037.9830-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210526043037.9830-1-o.rempel@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

Some micrel devices share the same PHY register defines. This patch
moves them to one common header so other drivers can reuse them.
And reuse generic MII_* defines where possible.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c     | 119 ++++++++++++------------
 drivers/net/dsa/microchip/ksz8795_reg.h |  62 ------------
 drivers/net/ethernet/micrel/ksz884x.c   | 105 +++------------------
 include/linux/micrel_phy.h              |  13 +++
 4 files changed, 88 insertions(+), 211 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ad509a57a945..ba065003623f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -15,6 +15,7 @@
 #include <linux/phy.h>
 #include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
+#include <linux/micrel_phy.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
 
@@ -731,88 +732,88 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 	u8 p = phy;
 
 	switch (reg) {
-	case PHY_REG_CTRL:
+	case MII_BMCR:
 		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
 		ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
 		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
 		if (restart & PORT_PHY_LOOPBACK)
-			data |= PHY_LOOPBACK;
+			data |= BMCR_LOOPBACK;
 		if (ctrl & PORT_FORCE_100_MBIT)
-			data |= PHY_SPEED_100MBIT;
+			data |= BMCR_SPEED100;
 		if (ksz_is_ksz88x3(dev)) {
 			if ((ctrl & PORT_AUTO_NEG_ENABLE))
-				data |= PHY_AUTO_NEG_ENABLE;
+				data |= BMCR_ANENABLE;
 		} else {
 			if (!(ctrl & PORT_AUTO_NEG_DISABLE))
-				data |= PHY_AUTO_NEG_ENABLE;
+				data |= BMCR_ANENABLE;
 		}
 		if (restart & PORT_POWER_DOWN)
-			data |= PHY_POWER_DOWN;
+			data |= BMCR_PDOWN;
 		if (restart & PORT_AUTO_NEG_RESTART)
-			data |= PHY_AUTO_NEG_RESTART;
+			data |= BMCR_ANRESTART;
 		if (ctrl & PORT_FORCE_FULL_DUPLEX)
-			data |= PHY_FULL_DUPLEX;
+			data |= BMCR_FULLDPLX;
 		if (speed & PORT_HP_MDIX)
-			data |= PHY_HP_MDIX;
+			data |= KSZ886X_BMCR_HP_MDIX;
 		if (restart & PORT_FORCE_MDIX)
-			data |= PHY_FORCE_MDIX;
+			data |= KSZ886X_BMCR_FORCE_MDI;
 		if (restart & PORT_AUTO_MDIX_DISABLE)
-			data |= PHY_AUTO_MDIX_DISABLE;
+			data |= KSZ886X_BMCR_DISABLE_AUTO_MDIX;
 		if (restart & PORT_TX_DISABLE)
-			data |= PHY_TRANSMIT_DISABLE;
+			data |= KSZ886X_BMCR_DISABLE_TRANSMIT;
 		if (restart & PORT_LED_OFF)
-			data |= PHY_LED_DISABLE;
+			data |= KSZ886X_BMCR_DISABLE_LED;
 		break;
-	case PHY_REG_STATUS:
+	case MII_BMSR:
 		ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
-		data = PHY_100BTX_FD_CAPABLE |
-		       PHY_100BTX_CAPABLE |
-		       PHY_10BT_FD_CAPABLE |
-		       PHY_10BT_CAPABLE |
-		       PHY_AUTO_NEG_CAPABLE;
+		data = BMSR_100FULL |
+		       BMSR_100HALF |
+		       BMSR_10FULL |
+		       BMSR_10HALF |
+		       BMSR_ANEGCAPABLE;
 		if (link & PORT_AUTO_NEG_COMPLETE)
-			data |= PHY_AUTO_NEG_ACKNOWLEDGE;
+			data |= BMSR_ANEGCOMPLETE;
 		if (link & PORT_STAT_LINK_GOOD)
-			data |= PHY_LINK_STATUS;
+			data |= BMSR_LSTATUS;
 		break;
-	case PHY_REG_ID_1:
+	case MII_PHYSID1:
 		data = KSZ8795_ID_HI;
 		break;
-	case PHY_REG_ID_2:
+	case MII_PHYSID2:
 		if (ksz_is_ksz88x3(dev))
 			data = KSZ8863_ID_LO;
 		else
 			data = KSZ8795_ID_LO;
 		break;
-	case PHY_REG_AUTO_NEGOTIATION:
+	case MII_ADVERTISE:
 		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
-		data = PHY_AUTO_NEG_802_3;
+		data = ADVERTISE_CSMA;
 		if (ctrl & PORT_AUTO_NEG_SYM_PAUSE)
-			data |= PHY_AUTO_NEG_SYM_PAUSE;
+			data |= ADVERTISE_PAUSE_CAP;
 		if (ctrl & PORT_AUTO_NEG_100BTX_FD)
-			data |= PHY_AUTO_NEG_100BTX_FD;
+			data |= ADVERTISE_100FULL;
 		if (ctrl & PORT_AUTO_NEG_100BTX)
-			data |= PHY_AUTO_NEG_100BTX;
+			data |= ADVERTISE_100HALF;
 		if (ctrl & PORT_AUTO_NEG_10BT_FD)
-			data |= PHY_AUTO_NEG_10BT_FD;
+			data |= ADVERTISE_10FULL;
 		if (ctrl & PORT_AUTO_NEG_10BT)
-			data |= PHY_AUTO_NEG_10BT;
+			data |= ADVERTISE_10HALF;
 		break;
-	case PHY_REG_REMOTE_CAPABILITY:
+	case MII_LPA:
 		ksz_pread8(dev, p, regs[P_REMOTE_STATUS], &link);
-		data = PHY_AUTO_NEG_802_3;
+		data = LPA_SLCT;
 		if (link & PORT_REMOTE_SYM_PAUSE)
-			data |= PHY_AUTO_NEG_SYM_PAUSE;
+			data |= LPA_PAUSE_CAP;
 		if (link & PORT_REMOTE_100BTX_FD)
-			data |= PHY_AUTO_NEG_100BTX_FD;
+			data |= LPA_100FULL;
 		if (link & PORT_REMOTE_100BTX)
-			data |= PHY_AUTO_NEG_100BTX;
+			data |= LPA_100HALF;
 		if (link & PORT_REMOTE_10BT_FD)
-			data |= PHY_AUTO_NEG_10BT_FD;
+			data |= LPA_10FULL;
 		if (link & PORT_REMOTE_10BT)
-			data |= PHY_AUTO_NEG_10BT;
-		if (data & ~PHY_AUTO_NEG_802_3)
-			data |= PHY_REMOTE_ACKNOWLEDGE_NOT;
+			data |= LPA_10HALF;
+		if (data & ~LPA_SLCT)
+			data |= LPA_LPACK;
 		break;
 	default:
 		processed = false;
@@ -830,14 +831,14 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	u8 p = phy;
 
 	switch (reg) {
-	case PHY_REG_CTRL:
+	case MII_BMCR:
 
 		/* Do not support PHY reset function. */
-		if (val & PHY_RESET)
+		if (val & BMCR_RESET)
 			break;
 		ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
 		data = speed;
-		if (val & PHY_HP_MDIX)
+		if (val & KSZ886X_BMCR_HP_MDIX)
 			data |= PORT_HP_MDIX;
 		else
 			data &= ~PORT_HP_MDIX;
@@ -846,12 +847,12 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
 		data = ctrl;
 		if (ksz_is_ksz88x3(dev)) {
-			if ((val & PHY_AUTO_NEG_ENABLE))
+			if ((val & BMCR_ANENABLE))
 				data |= PORT_AUTO_NEG_ENABLE;
 			else
 				data &= ~PORT_AUTO_NEG_ENABLE;
 		} else {
-			if (!(val & PHY_AUTO_NEG_ENABLE))
+			if (!(val & BMCR_ANENABLE))
 				data |= PORT_AUTO_NEG_DISABLE;
 			else
 				data &= ~PORT_AUTO_NEG_DISABLE;
@@ -861,11 +862,11 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 				data |= PORT_AUTO_NEG_DISABLE;
 		}
 
-		if (val & PHY_SPEED_100MBIT)
+		if (val & BMCR_SPEED100)
 			data |= PORT_FORCE_100_MBIT;
 		else
 			data &= ~PORT_FORCE_100_MBIT;
-		if (val & PHY_FULL_DUPLEX)
+		if (val & BMCR_FULLDPLX)
 			data |= PORT_FORCE_FULL_DUPLEX;
 		else
 			data &= ~PORT_FORCE_FULL_DUPLEX;
@@ -873,38 +874,38 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			ksz_pwrite8(dev, p, regs[P_FORCE_CTRL], data);
 		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
 		data = restart;
-		if (val & PHY_LED_DISABLE)
+		if (val & KSZ886X_BMCR_DISABLE_LED)
 			data |= PORT_LED_OFF;
 		else
 			data &= ~PORT_LED_OFF;
-		if (val & PHY_TRANSMIT_DISABLE)
+		if (val & KSZ886X_BMCR_DISABLE_TRANSMIT)
 			data |= PORT_TX_DISABLE;
 		else
 			data &= ~PORT_TX_DISABLE;
-		if (val & PHY_AUTO_NEG_RESTART)
+		if (val & BMCR_ANRESTART)
 			data |= PORT_AUTO_NEG_RESTART;
 		else
 			data &= ~(PORT_AUTO_NEG_RESTART);
-		if (val & PHY_POWER_DOWN)
+		if (val & BMCR_PDOWN)
 			data |= PORT_POWER_DOWN;
 		else
 			data &= ~PORT_POWER_DOWN;
-		if (val & PHY_AUTO_MDIX_DISABLE)
+		if (val & KSZ886X_BMCR_DISABLE_AUTO_MDIX)
 			data |= PORT_AUTO_MDIX_DISABLE;
 		else
 			data &= ~PORT_AUTO_MDIX_DISABLE;
-		if (val & PHY_FORCE_MDIX)
+		if (val & KSZ886X_BMCR_FORCE_MDI)
 			data |= PORT_FORCE_MDIX;
 		else
 			data &= ~PORT_FORCE_MDIX;
-		if (val & PHY_LOOPBACK)
+		if (val & BMCR_LOOPBACK)
 			data |= PORT_PHY_LOOPBACK;
 		else
 			data &= ~PORT_PHY_LOOPBACK;
 		if (data != restart)
 			ksz_pwrite8(dev, p, regs[P_NEG_RESTART_CTRL], data);
 		break;
-	case PHY_REG_AUTO_NEGOTIATION:
+	case MII_ADVERTISE:
 		ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
 		data = ctrl;
 		data &= ~(PORT_AUTO_NEG_SYM_PAUSE |
@@ -912,15 +913,15 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			  PORT_AUTO_NEG_100BTX |
 			  PORT_AUTO_NEG_10BT_FD |
 			  PORT_AUTO_NEG_10BT);
-		if (val & PHY_AUTO_NEG_SYM_PAUSE)
+		if (val & ADVERTISE_PAUSE_CAP)
 			data |= PORT_AUTO_NEG_SYM_PAUSE;
-		if (val & PHY_AUTO_NEG_100BTX_FD)
+		if (val & ADVERTISE_100FULL)
 			data |= PORT_AUTO_NEG_100BTX_FD;
-		if (val & PHY_AUTO_NEG_100BTX)
+		if (val & ADVERTISE_100HALF)
 			data |= PORT_AUTO_NEG_100BTX;
-		if (val & PHY_AUTO_NEG_10BT_FD)
+		if (val & ADVERTISE_10FULL)
 			data |= PORT_AUTO_NEG_10BT_FD;
-		if (val & PHY_AUTO_NEG_10BT)
+		if (val & ADVERTISE_10HALF)
 			data |= PORT_AUTO_NEG_10BT;
 		if (data != ctrl)
 			ksz_pwrite8(dev, p, regs[P_LOCAL_CTRL], data);
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index c2e52c40a54c..f925ddee5238 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -744,68 +744,6 @@
 
 #define PORT_ACL_FORCE_DLR_MISS		BIT(0)
 
-#ifndef PHY_REG_CTRL
-#define PHY_REG_CTRL			0
-
-#define PHY_RESET			BIT(15)
-#define PHY_LOOPBACK			BIT(14)
-#define PHY_SPEED_100MBIT		BIT(13)
-#define PHY_AUTO_NEG_ENABLE		BIT(12)
-#define PHY_POWER_DOWN			BIT(11)
-#define PHY_MII_DISABLE			BIT(10)
-#define PHY_AUTO_NEG_RESTART		BIT(9)
-#define PHY_FULL_DUPLEX			BIT(8)
-#define PHY_COLLISION_TEST_NOT		BIT(7)
-#define PHY_HP_MDIX			BIT(5)
-#define PHY_FORCE_MDIX			BIT(4)
-#define PHY_AUTO_MDIX_DISABLE		BIT(3)
-#define PHY_REMOTE_FAULT_DISABLE	BIT(2)
-#define PHY_TRANSMIT_DISABLE		BIT(1)
-#define PHY_LED_DISABLE			BIT(0)
-
-#define PHY_REG_STATUS			1
-
-#define PHY_100BT4_CAPABLE		BIT(15)
-#define PHY_100BTX_FD_CAPABLE		BIT(14)
-#define PHY_100BTX_CAPABLE		BIT(13)
-#define PHY_10BT_FD_CAPABLE		BIT(12)
-#define PHY_10BT_CAPABLE		BIT(11)
-#define PHY_MII_SUPPRESS_CAPABLE_NOT	BIT(6)
-#define PHY_AUTO_NEG_ACKNOWLEDGE	BIT(5)
-#define PHY_REMOTE_FAULT		BIT(4)
-#define PHY_AUTO_NEG_CAPABLE		BIT(3)
-#define PHY_LINK_STATUS			BIT(2)
-#define PHY_JABBER_DETECT_NOT		BIT(1)
-#define PHY_EXTENDED_CAPABILITY		BIT(0)
-
-#define PHY_REG_ID_1			2
-#define PHY_REG_ID_2			3
-
-#define PHY_REG_AUTO_NEGOTIATION	4
-
-#define PHY_AUTO_NEG_NEXT_PAGE_NOT	BIT(15)
-#define PHY_AUTO_NEG_REMOTE_FAULT_NOT	BIT(13)
-#define PHY_AUTO_NEG_SYM_PAUSE		BIT(10)
-#define PHY_AUTO_NEG_100BT4		BIT(9)
-#define PHY_AUTO_NEG_100BTX_FD		BIT(8)
-#define PHY_AUTO_NEG_100BTX		BIT(7)
-#define PHY_AUTO_NEG_10BT_FD		BIT(6)
-#define PHY_AUTO_NEG_10BT		BIT(5)
-#define PHY_AUTO_NEG_SELECTOR		0x001F
-#define PHY_AUTO_NEG_802_3		0x0001
-
-#define PHY_REG_REMOTE_CAPABILITY	5
-
-#define PHY_REMOTE_NEXT_PAGE_NOT	BIT(15)
-#define PHY_REMOTE_ACKNOWLEDGE_NOT	BIT(14)
-#define PHY_REMOTE_REMOTE_FAULT_NOT	BIT(13)
-#define PHY_REMOTE_SYM_PAUSE		BIT(10)
-#define PHY_REMOTE_100BTX_FD		BIT(8)
-#define PHY_REMOTE_100BTX		BIT(7)
-#define PHY_REMOTE_10BT_FD		BIT(6)
-#define PHY_REMOTE_10BT			BIT(5)
-#endif
-
 #define KSZ8795_ID_HI			0x0022
 #define KSZ8795_ID_LO			0x1550
 #define KSZ8863_ID_LO			0x1430
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 3532bfe936f6..7945eb5e2fe8 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -25,6 +25,7 @@
 #include <linux/crc32.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/micrel_phy.h>
 
 
 /* DMA Registers */
@@ -271,84 +272,15 @@
 
 #define KS884X_PHY_CTRL_OFFSET		0x00
 
-/* Mode Control Register */
-#define PHY_REG_CTRL			0
-
-#define PHY_RESET			0x8000
-#define PHY_LOOPBACK			0x4000
-#define PHY_SPEED_100MBIT		0x2000
-#define PHY_AUTO_NEG_ENABLE		0x1000
-#define PHY_POWER_DOWN			0x0800
-#define PHY_MII_DISABLE			0x0400
-#define PHY_AUTO_NEG_RESTART		0x0200
-#define PHY_FULL_DUPLEX			0x0100
-#define PHY_COLLISION_TEST		0x0080
-#define PHY_HP_MDIX			0x0020
-#define PHY_FORCE_MDIX			0x0010
-#define PHY_AUTO_MDIX_DISABLE		0x0008
-#define PHY_REMOTE_FAULT_DISABLE	0x0004
-#define PHY_TRANSMIT_DISABLE		0x0002
-#define PHY_LED_DISABLE			0x0001
-
 #define KS884X_PHY_STATUS_OFFSET	0x02
 
-/* Mode Status Register */
-#define PHY_REG_STATUS			1
-
-#define PHY_100BT4_CAPABLE		0x8000
-#define PHY_100BTX_FD_CAPABLE		0x4000
-#define PHY_100BTX_CAPABLE		0x2000
-#define PHY_10BT_FD_CAPABLE		0x1000
-#define PHY_10BT_CAPABLE		0x0800
-#define PHY_MII_SUPPRESS_CAPABLE	0x0040
-#define PHY_AUTO_NEG_ACKNOWLEDGE	0x0020
-#define PHY_REMOTE_FAULT		0x0010
-#define PHY_AUTO_NEG_CAPABLE		0x0008
-#define PHY_LINK_STATUS			0x0004
-#define PHY_JABBER_DETECT		0x0002
-#define PHY_EXTENDED_CAPABILITY		0x0001
-
 #define KS884X_PHY_ID_1_OFFSET		0x04
 #define KS884X_PHY_ID_2_OFFSET		0x06
 
-/* PHY Identifier Registers */
-#define PHY_REG_ID_1			2
-#define PHY_REG_ID_2			3
-
 #define KS884X_PHY_AUTO_NEG_OFFSET	0x08
 
-/* Auto-Negotiation Advertisement Register */
-#define PHY_REG_AUTO_NEGOTIATION	4
-
-#define PHY_AUTO_NEG_NEXT_PAGE		0x8000
-#define PHY_AUTO_NEG_REMOTE_FAULT	0x2000
-/* Not supported. */
-#define PHY_AUTO_NEG_ASYM_PAUSE		0x0800
-#define PHY_AUTO_NEG_SYM_PAUSE		0x0400
-#define PHY_AUTO_NEG_100BT4		0x0200
-#define PHY_AUTO_NEG_100BTX_FD		0x0100
-#define PHY_AUTO_NEG_100BTX		0x0080
-#define PHY_AUTO_NEG_10BT_FD		0x0040
-#define PHY_AUTO_NEG_10BT		0x0020
-#define PHY_AUTO_NEG_SELECTOR		0x001F
-#define PHY_AUTO_NEG_802_3		0x0001
-
-#define PHY_AUTO_NEG_PAUSE  (PHY_AUTO_NEG_SYM_PAUSE | PHY_AUTO_NEG_ASYM_PAUSE)
-
 #define KS884X_PHY_REMOTE_CAP_OFFSET	0x0A
 
-/* Auto-Negotiation Link Partner Ability Register */
-#define PHY_REG_REMOTE_CAPABILITY	5
-
-#define PHY_REMOTE_NEXT_PAGE		0x8000
-#define PHY_REMOTE_ACKNOWLEDGE		0x4000
-#define PHY_REMOTE_REMOTE_FAULT		0x2000
-#define PHY_REMOTE_SYM_PAUSE		0x0400
-#define PHY_REMOTE_100BTX_FD		0x0100
-#define PHY_REMOTE_100BTX		0x0080
-#define PHY_REMOTE_10BT_FD		0x0040
-#define PHY_REMOTE_10BT			0x0020
-
 /* P1VCT */
 #define KS884X_P1VCT_P			0x04F0
 #define KS884X_P1PHYCTRL_P		0x04F2
@@ -2886,15 +2818,6 @@ static void sw_block_addr(struct ksz_hw *hw)
 	}
 }
 
-#define PHY_LINK_SUPPORT		\
-	(PHY_AUTO_NEG_ASYM_PAUSE |	\
-	PHY_AUTO_NEG_SYM_PAUSE |	\
-	PHY_AUTO_NEG_100BT4 |		\
-	PHY_AUTO_NEG_100BTX_FD |	\
-	PHY_AUTO_NEG_100BTX |		\
-	PHY_AUTO_NEG_10BT_FD |		\
-	PHY_AUTO_NEG_10BT)
-
 static inline void hw_r_phy_ctrl(struct ksz_hw *hw, int phy, u16 *data)
 {
 	*data = readw(hw->io + phy + KS884X_PHY_CTRL_OFFSET);
@@ -3238,16 +3161,18 @@ static void determine_flow_ctrl(struct ksz_hw *hw, struct ksz_port *port,
 	rx = tx = 0;
 	if (port->force_link)
 		rx = tx = 1;
-	if (remote & PHY_AUTO_NEG_SYM_PAUSE) {
-		if (local & PHY_AUTO_NEG_SYM_PAUSE) {
+	if (remote & LPA_PAUSE_CAP) {
+		if (local & ADVERTISE_PAUSE_CAP) {
 			rx = tx = 1;
-		} else if ((remote & PHY_AUTO_NEG_ASYM_PAUSE) &&
-				(local & PHY_AUTO_NEG_PAUSE) ==
-				PHY_AUTO_NEG_ASYM_PAUSE) {
+		} else if ((remote & LPA_PAUSE_ASYM) &&
+			   (local &
+			    (ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM)) ==
+			   ADVERTISE_PAUSE_ASYM) {
 			tx = 1;
 		}
-	} else if (remote & PHY_AUTO_NEG_ASYM_PAUSE) {
-		if ((local & PHY_AUTO_NEG_PAUSE) == PHY_AUTO_NEG_PAUSE)
+	} else if (remote & LPA_PAUSE_ASYM) {
+		if ((local & (ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM))
+		    == (ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM))
 			rx = 1;
 	}
 	if (!hw->ksz_switch)
@@ -3428,16 +3353,16 @@ static void port_force_link_speed(struct ksz_port *port)
 		phy = KS884X_PHY_1_CTRL_OFFSET + p * PHY_CTRL_INTERVAL;
 		hw_r_phy_ctrl(hw, phy, &data);
 
-		data &= ~PHY_AUTO_NEG_ENABLE;
+		data &= ~BMCR_ANENABLE;
 
 		if (10 == port->speed)
-			data &= ~PHY_SPEED_100MBIT;
+			data &= ~BMCR_SPEED100;
 		else if (100 == port->speed)
-			data |= PHY_SPEED_100MBIT;
+			data |= BMCR_SPEED100;
 		if (1 == port->duplex)
-			data &= ~PHY_FULL_DUPLEX;
+			data &= ~BMCR_FULLDPLX;
 		else if (2 == port->duplex)
-			data |= PHY_FULL_DUPLEX;
+			data |= BMCR_FULLDPLX;
 		hw_w_phy_ctrl(hw, phy, data);
 	}
 }
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 416ee6dd2574..b03e2afcb53f 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -45,4 +45,17 @@
 #define MICREL_KSZ9021_RGMII_CLK_CTRL_PAD_SCEW	0x104
 #define MICREL_KSZ9021_RGMII_RX_DATA_PAD_SCEW	0x105
 
+/* Device specific MII_BMCR (Reg 0) bits */
+/* 1 = HP Auto MDI/MDI-X mode, 0 = Microchip Auto MDI/MDI-X mode */
+#define KSZ886X_BMCR_HP_MDIX			BIT(5)
+/* 1 = Force MDI (transmit on RXP/RXM pins), 0 = Normal operation
+ * (transmit on TXP/TXM pins)
+ */
+#define KSZ886X_BMCR_FORCE_MDI			BIT(4)
+/* 1 = Disable auto MDI-X */
+#define KSZ886X_BMCR_DISABLE_AUTO_MDIX		BIT(3)
+#define KSZ886X_BMCR_DISABLE_FAR_END_FAULT	BIT(2)
+#define KSZ886X_BMCR_DISABLE_TRANSMIT		BIT(1)
+#define KSZ886X_BMCR_DISABLE_LED		BIT(0)
+
 #endif /* _MICREL_PHY_H */
-- 
2.29.2

