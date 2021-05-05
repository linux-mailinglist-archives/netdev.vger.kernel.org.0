Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D5B37375F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhEEJXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhEEJW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 05:22:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1973C06137E
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 02:20:40 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1leDhn-0005Xb-1o; Wed, 05 May 2021 11:20:31 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1leDhj-0002dm-QQ; Wed, 05 May 2021 11:20:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [RFC PATCH v1 1/9] net: phy: micrel: move phy reg offsets to common header
Date:   Wed,  5 May 2021 11:20:17 +0200
Message-Id: <20210505092025.8785-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210505092025.8785-1-o.rempel@pengutronix.de>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
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

Some micrel devices share the same phy register defines. This patch
moves them to one common header so other drivers can reuse them.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c     |  1 +
 drivers/net/dsa/microchip/ksz8795_reg.h | 62 ----------------------
 drivers/net/ethernet/micrel/ksz884x.c   | 70 +------------------------
 include/linux/micrel_phy.h              | 63 ++++++++++++++++++++++
 4 files changed, 65 insertions(+), 131 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ad509a57a945..4ca352fbe81c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -15,6 +15,7 @@
 #include <linux/phy.h>
 #include <linux/etherdevice.h>
 #include <linux/if_bridge.h>
+#include <linux/micrel_phy.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
 
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
index 9ed264ed7070..481426d0bda7 100644
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
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 416ee6dd2574..ee23acc4d551 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -45,4 +45,67 @@
 #define MICREL_KSZ9021_RGMII_CLK_CTRL_PAD_SCEW	0x104
 #define MICREL_KSZ9021_RGMII_RX_DATA_PAD_SCEW	0x105
 
+#define PHY_REG_CTRL			0
+
+#define PHY_RESET			BIT(15)
+#define PHY_LOOPBACK			BIT(14)
+#define PHY_SPEED_100MBIT		BIT(13)
+#define PHY_AUTO_NEG_ENABLE		BIT(12)
+#define PHY_POWER_DOWN			BIT(11)
+#define PHY_MII_DISABLE			BIT(10)
+#define PHY_AUTO_NEG_RESTART		BIT(9)
+#define PHY_FULL_DUPLEX			BIT(8)
+#define PHY_COLLISION_TEST_NOT		BIT(7)
+#define PHY_HP_MDIX			BIT(5)
+#define PHY_FORCE_MDIX			BIT(4)
+#define PHY_AUTO_MDIX_DISABLE		BIT(3)
+#define PHY_REMOTE_FAULT_DISABLE	BIT(2)
+#define PHY_TRANSMIT_DISABLE		BIT(1)
+#define PHY_LED_DISABLE			BIT(0)
+
+#define PHY_REG_STATUS			1
+
+#define PHY_100BT4_CAPABLE		BIT(15)
+#define PHY_100BTX_FD_CAPABLE		BIT(14)
+#define PHY_100BTX_CAPABLE		BIT(13)
+#define PHY_10BT_FD_CAPABLE		BIT(12)
+#define PHY_10BT_CAPABLE		BIT(11)
+#define PHY_MII_SUPPRESS_CAPABLE_NOT	BIT(6)
+#define PHY_AUTO_NEG_ACKNOWLEDGE	BIT(5)
+#define PHY_REMOTE_FAULT		BIT(4)
+#define PHY_AUTO_NEG_CAPABLE		BIT(3)
+#define PHY_LINK_STATUS			BIT(2)
+#define PHY_JABBER_DETECT_NOT		BIT(1)
+#define PHY_EXTENDED_CAPABILITY		BIT(0)
+
+#define PHY_REG_ID_1			2
+#define PHY_REG_ID_2			3
+
+#define PHY_REG_AUTO_NEGOTIATION	4
+
+#define PHY_AUTO_NEG_NEXT_PAGE_NOT	BIT(15)
+#define PHY_AUTO_NEG_REMOTE_FAULT_NOT	BIT(13)
+#define PHY_AUTO_NEG_ASYM_PAUSE		BIT(11)
+#define PHY_AUTO_NEG_SYM_PAUSE		BIT(10)
+#define PHY_AUTO_NEG_100BT4		BIT(9)
+#define PHY_AUTO_NEG_100BTX_FD		BIT(8)
+#define PHY_AUTO_NEG_100BTX		BIT(7)
+#define PHY_AUTO_NEG_10BT_FD		BIT(6)
+#define PHY_AUTO_NEG_10BT		BIT(5)
+#define PHY_AUTO_NEG_SELECTOR		0x001F
+#define PHY_AUTO_NEG_802_3		0x0001
+
+#define PHY_AUTO_NEG_PAUSE  (PHY_AUTO_NEG_SYM_PAUSE | PHY_AUTO_NEG_ASYM_PAUSE)
+
+#define PHY_REG_REMOTE_CAPABILITY	5
+
+#define PHY_REMOTE_NEXT_PAGE_NOT	BIT(15)
+#define PHY_REMOTE_ACKNOWLEDGE_NOT	BIT(14)
+#define PHY_REMOTE_REMOTE_FAULT_NOT	BIT(13)
+#define PHY_REMOTE_SYM_PAUSE		BIT(10)
+#define PHY_REMOTE_100BTX_FD		BIT(8)
+#define PHY_REMOTE_100BTX		BIT(7)
+#define PHY_REMOTE_10BT_FD		BIT(6)
+#define PHY_REMOTE_10BT			BIT(5)
+
 #endif /* _MICREL_PHY_H */
-- 
2.29.2

