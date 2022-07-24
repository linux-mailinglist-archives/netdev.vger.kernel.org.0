Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD03057F46D
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 11:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiGXJas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 05:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiGXJal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 05:30:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E9F1261A;
        Sun, 24 Jul 2022 02:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658655039; x=1690191039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ftsk9FmDGrPFYktU3nKTVrwHhsXtZW1VZkvbU2+18So=;
  b=oJYUJ/IRAH9Aq8gb4WzOqw9nLxtwB1x7FPvN7kfa/fTN620/VzVj7TZk
   Vtco7xj+4cyE0vLSd7pjmhqWUYefObUqroA4KT5KbL8FhhrGe/+gY6+ae
   oIaaQMMNmKw98XLmE0zrapYWsbN+m0+B9bj4TrEXfXw6avXwyVIfaCXdk
   xfHx1A2UaUoK0HY8VibN4sfVR3VWz3SyoTDtauf4FHqygB6KJrbWacozd
   wfZylY4STnyGRnuCLrVV7RWBobN4kRKhw9ECRnKJ4e4JIaeUvWf56MRdE
   5LnePFIM0hUswMp3A7lM2izj31K1mY03UnfIhHZexkNn14ZL9X85KXb/1
   g==;
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="169239365"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2022 02:30:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Jul 2022 02:30:38 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Sun, 24 Jul 2022 02:30:26 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next v2 7/9] net: dsa: microchip: ksz9477: use common xmii function
Date:   Sun, 24 Jul 2022 14:58:21 +0530
Message-ID: <20220724092823.24567-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724092823.24567-1-arun.ramadoss@microchip.com>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ksz9477.c file, configuring the xmii register is performed based on
the flag NEW_XMII. The flag is reset for ksz9893 switch and set for
other switch. This patch uses the ksz common xmii set and get function.
The bit values are configured based on the chip id.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c     | 153 +-----------------------
 drivers/net/dsa/microchip/ksz9477_reg.h |  18 ---
 drivers/net/dsa/microchip/ksz_common.c  |  38 +++++-
 drivers/net/dsa/microchip/ksz_common.h  |   7 +-
 4 files changed, 49 insertions(+), 167 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index cfa7ddf60718..301283d1ba82 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -19,11 +19,6 @@
 #include "ksz_common.h"
 #include "ksz9477.h"
 
-/* Used with variable features to indicate capabilities. */
-#define GBIT_SUPPORT			BIT(0)
-#define NEW_XMII			BIT(1)
-#define IS_9893				BIT(2)
-
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -866,116 +861,18 @@ void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
-static int ksz9477_get_xmii(struct ksz_device *dev, u8 data)
-{
-	int mode;
-
-	if (dev->features & NEW_XMII) {
-		switch (data & PORT_MII_SEL_M) {
-		case PORT_MII_SEL:
-			mode = 0;
-			break;
-		case PORT_RMII_SEL:
-			mode = 1;
-			break;
-		case PORT_GMII_SEL:
-			mode = 2;
-			break;
-		default:
-			mode = 3;
-		}
-	} else {
-		switch (data & PORT_MII_SEL_M) {
-		case PORT_MII_SEL_S1:
-			mode = 0;
-			break;
-		case PORT_RMII_SEL_S1:
-			mode = 1;
-			break;
-		case PORT_GMII_SEL_S1:
-			mode = 2;
-			break;
-		default:
-			mode = 3;
-		}
-	}
-	return mode;
-}
-
-static void ksz9477_set_xmii(struct ksz_device *dev, int mode, u8 *data)
-{
-	u8 xmii;
-
-	if (dev->features & NEW_XMII) {
-		switch (mode) {
-		case 0:
-			xmii = PORT_MII_SEL;
-			break;
-		case 1:
-			xmii = PORT_RMII_SEL;
-			break;
-		case 2:
-			xmii = PORT_GMII_SEL;
-			break;
-		default:
-			xmii = PORT_RGMII_SEL;
-			break;
-		}
-	} else {
-		switch (mode) {
-		case 0:
-			xmii = PORT_MII_SEL_S1;
-			break;
-		case 1:
-			xmii = PORT_RMII_SEL_S1;
-			break;
-		case 2:
-			xmii = PORT_GMII_SEL_S1;
-			break;
-		default:
-			xmii = PORT_RGMII_SEL_S1;
-			break;
-		}
-	}
-	*data &= ~PORT_MII_SEL_M;
-	*data |= xmii;
-}
-
 static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
 {
 	phy_interface_t interface;
 	bool gbit;
-	int mode;
-	u8 data8;
 
 	if (port < dev->phy_port_cnt)
 		return PHY_INTERFACE_MODE_NA;
-	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
+
 	gbit = ksz_get_gbit(dev, port);
-	mode = ksz9477_get_xmii(dev, data8);
-	switch (mode) {
-	case 2:
-		interface = PHY_INTERFACE_MODE_GMII;
-		if (gbit)
-			break;
-		fallthrough;
-	case 0:
-		interface = PHY_INTERFACE_MODE_MII;
-		break;
-	case 1:
-		interface = PHY_INTERFACE_MODE_RMII;
-		break;
-	default:
-		interface = PHY_INTERFACE_MODE_RGMII;
-		if (data8 & PORT_RGMII_ID_EG_ENABLE)
-			interface = PHY_INTERFACE_MODE_RGMII_TXID;
-		if (data8 & PORT_RGMII_ID_IG_ENABLE) {
-			interface = PHY_INTERFACE_MODE_RGMII_RXID;
-			if (data8 & PORT_RGMII_ID_EG_ENABLE)
-				interface = PHY_INTERFACE_MODE_RGMII_ID;
-		}
-		break;
-	}
+
+	interface = ksz_get_xmii(dev, port, gbit);
+
 	return interface;
 }
 
@@ -1049,8 +946,8 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
 	struct dsa_switch *ds = dev->ds;
-	u8 data8, member;
 	u16 data16;
+	u8 member;
 
 	/* enable tag tail for host port */
 	if (cpu_port)
@@ -1092,42 +989,7 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			     true);
 
 		/* configure MAC to 1G & RGMII mode */
-		ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
-		switch (p->interface) {
-		case PHY_INTERFACE_MODE_MII:
-			ksz9477_set_xmii(dev, 0, &data8);
-			ksz_set_gbit(dev, port, false);
-			p->phydev.speed = SPEED_100;
-			break;
-		case PHY_INTERFACE_MODE_RMII:
-			ksz9477_set_xmii(dev, 1, &data8);
-			ksz_set_gbit(dev, port, false);
-			p->phydev.speed = SPEED_100;
-			break;
-		case PHY_INTERFACE_MODE_GMII:
-			ksz9477_set_xmii(dev, 2, &data8);
-			ksz_set_gbit(dev, port, true);
-			p->phydev.speed = SPEED_1000;
-			break;
-		default:
-			ksz9477_set_xmii(dev, 3, &data8);
-			ksz_set_gbit(dev, port, true);
-			data8 &= ~PORT_RGMII_ID_IG_ENABLE;
-			data8 &= ~PORT_RGMII_ID_EG_ENABLE;
-			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
-				data8 |= PORT_RGMII_ID_IG_ENABLE;
-			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
-				data8 |= PORT_RGMII_ID_EG_ENABLE;
-			/* On KSZ9893, disable RGMII in-band status support */
-			if (dev->features & IS_9893)
-				data8 &= ~PORT_MII_MAC_MODE;
-			p->phydev.speed = SPEED_1000;
-			break;
-		}
-		ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
-		p->phydev.duplex = 1;
+		ksz_set_xmii(dev, port, p->interface);
 	}
 
 	if (cpu_port)
@@ -1315,9 +1177,6 @@ int ksz9477_switch_init(struct ksz_device *dev)
 			dev->features &= ~GBIT_SUPPORT;
 		dev->phy_port_cnt = 2;
 	} else {
-		/* Chip uses new XMII register definitions. */
-		dev->features |= NEW_XMII;
-
 		/* Chip does not support gigabit. */
 		if (!(data8 & SW_GIGABIT_ABLE))
 			dev->features &= ~GBIT_SUPPORT;
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 6ca859345932..ddf99d1e4bbd 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1175,29 +1175,11 @@
 #define PORT_LINK_STATUS_FAIL		BIT(0)
 
 /* 3 - xMII */
-#define REG_PORT_XMII_CTRL_0		0x0300
-
 #define PORT_SGMII_SEL			BIT(7)
 #define PORT_GRXC_ENABLE		BIT(0)
 
-#define REG_PORT_XMII_CTRL_1		0x0301
-
 #define PORT_RMII_CLK_SEL		BIT(7)
 #define PORT_MII_SEL_EDGE		BIT(5)
-#define PORT_RGMII_ID_IG_ENABLE		BIT(4)
-#define PORT_RGMII_ID_EG_ENABLE		BIT(3)
-#define PORT_MII_MAC_MODE		BIT(2)
-#define PORT_MII_SEL_M			0x3
-/* S1 */
-#define PORT_MII_SEL_S1			0x0
-#define PORT_RMII_SEL_S1		0x1
-#define PORT_GMII_SEL_S1		0x2
-#define PORT_RGMII_SEL_S1		0x3
-/* S2 */
-#define PORT_RGMII_SEL			0x0
-#define PORT_RMII_SEL			0x1
-#define PORT_GMII_SEL			0x2
-#define PORT_MII_SEL			0x3
 
 /* 4 - MAC */
 #define REG_PORT_MAC_CTRL_0		0x0400
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 237dec7c6e3c..86a2a40cacb4 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1436,6 +1436,9 @@ void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface)
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 		data8 |= bitval[P_RGMII_SEL];
+		/* On KSZ9893, disable RGMII in-band status support */
+		if (dev->features & IS_9893)
+			data8 &= ~P_MII_MAC_MODE;
 		break;
 	default:
 		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
@@ -1453,6 +1456,39 @@ void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface)
 	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
 }
 
+phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit)
+{
+	const u8 *bitval = dev->info->xmii_ctrl1;
+	const u16 *regs = dev->info->regs;
+	phy_interface_t interface;
+	u8 data8;
+	u8 val;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
+
+	val = FIELD_GET(P_MII_SEL_M, data8);
+
+	if (val == bitval[P_MII_SEL]) {
+		if (gbit)
+			interface = PHY_INTERFACE_MODE_GMII;
+		else
+			interface = PHY_INTERFACE_MODE_MII;
+	} else if (val == bitval[P_RMII_SEL]) {
+		interface = PHY_INTERFACE_MODE_RGMII;
+	} else {
+		interface = PHY_INTERFACE_MODE_RGMII;
+		if (data8 & P_RGMII_ID_EG_ENABLE)
+			interface = PHY_INTERFACE_MODE_RGMII_TXID;
+		if (data8 & P_RGMII_ID_IG_ENABLE) {
+			interface = PHY_INTERFACE_MODE_RGMII_RXID;
+			if (data8 & P_RGMII_ID_EG_ENABLE)
+				interface = PHY_INTERFACE_MODE_RGMII_ID;
+		}
+	}
+
+	return interface;
+}
+
 static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 				   unsigned int mode,
 				   const struct phylink_link_state *state)
@@ -1484,7 +1520,7 @@ bool ksz_get_gbit(struct ksz_device *dev, int port)
 	return gbit;
 }
 
-void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit)
+static void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit)
 {
 	const u8 *bitval = dev->info->xmii_ctrl1;
 	const u16 *regs = dev->info->regs;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index bf13f72fa9f2..0b5c565d1ff4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -319,8 +319,8 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
-void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
 void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface);
+phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -492,6 +492,10 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define SW_START			0x01
 
+/* Used with variable features to indicate capabilities. */
+#define GBIT_SUPPORT			BIT(0)
+#define IS_9893				BIT(2)
+
 /* xMII configuration */
 #define P_MII_DUPLEX_M			BIT(6)
 #define P_MII_100MBIT_M			BIT(4)
@@ -499,6 +503,7 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define P_GMII_1GBIT_M			BIT(6)
 #define P_RGMII_ID_IG_ENABLE		BIT(4)
 #define P_RGMII_ID_EG_ENABLE		BIT(3)
+#define P_MII_MAC_MODE			BIT(2)
 #define P_MII_SEL_M			0x3
 
 /* Regmap tables generation */
-- 
2.36.1

