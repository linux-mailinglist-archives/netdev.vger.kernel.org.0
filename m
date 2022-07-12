Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE457572042
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbiGLQEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiGLQEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:04:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106BEC6365;
        Tue, 12 Jul 2022 09:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657641871; x=1689177871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LEnpFsG/pCFrgxG8E2N4UxKFg+VfChLBoOo+WblJu0c=;
  b=f7nxFiasH83S83TuF9dbIorZ0Z+SaG4i7da58uvqWcYh/WuPEFUCmJrN
   9ucVk17UKf00qO6PxLwLikUie/AynWD++rG2n99TGxMI3JzOJa3D0FN8N
   jZ8FI/tIVoKRRq+P6R4eBAUMLTVetN1GJG9jF5zxSZ56tpz8wUaC8i+Cq
   zvYesX8p/aClyFzn6x0v9wD/vsu0/DYTsuEmQAn26+5cxAxEcu+Z9Rk+/
   e1M+5eaP4F/w+FoBxnJFxhJHtRUdiB2KK9OPCKsgqV4bz50TNEY52FAdd
   oi+7E5kEqcZH35Vt3cIIDaSlYYiPwQalW6qw82YRwnAynceSz+V83LL/1
   w==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="167484197"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2022 09:04:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Jul 2022 09:04:27 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:04:18 -0700
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
Subject: [RFC Patch net-next 04/10] net: dsa: microchip: add common duplex and flow control function
Date:   Tue, 12 Jul 2022 21:33:02 +0530
Message-ID: <20220712160308.13253-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220712160308.13253-1-arun.ramadoss@microchip.com>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add common function for configuring the Full/Half duplex and
transmit/receive flow control. KSZ8795 uses the Global control register
4 for configuring the duplex and flow control, whereas all other KSZ9477
based switch uses the xMII Control 0 register.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477_reg.h  |  1 -
 drivers/net/dsa/microchip/ksz_common.c   | 64 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  8 +++
 drivers/net/dsa/microchip/lan937x_main.c | 24 +++------
 drivers/net/dsa/microchip/lan937x_reg.h  |  3 --
 5 files changed, 80 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 2649fdf0bae1..6ca859345932 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1178,7 +1178,6 @@
 #define REG_PORT_XMII_CTRL_0		0x0300
 
 #define PORT_SGMII_SEL			BIT(7)
-#define PORT_MII_FULL_DUPLEX		BIT(6)
 #define PORT_GRXC_ENABLE		BIT(0)
 
 #define REG_PORT_XMII_CTRL_1		0x0301
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index f41cd2801210..4ef0ee9a245d 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -280,6 +280,8 @@ static const u32 ksz8795_masks[] = {
 	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
 	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(5),
 };
 
 static const u8 ksz8795_values[] = {
@@ -287,6 +289,8 @@ static const u8 ksz8795_values[] = {
 	[P_MII_NOT_1GBIT]		= 0,
 	[P_MII_100MBIT]			= 0,
 	[P_MII_10MBIT]			= 1,
+	[P_MII_FULL_DUPLEX]		= 0,
+	[P_MII_HALF_DUPLEX]		= 1,
 };
 
 static const u8 ksz8795_shifts[] = {
@@ -366,6 +370,8 @@ static const u16 ksz9477_regs[] = {
 static const u32 ksz9477_masks[] = {
 	[ALU_STAT_WRITE]		= 0,
 	[ALU_STAT_READ]			= 1,
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(3),
 };
 
 static const u8 ksz9477_shifts[] = {
@@ -377,6 +383,8 @@ static const u8 ksz9477_values[] = {
 	[P_MII_NOT_1GBIT]		= 1,
 	[P_MII_100MBIT]			= 1,
 	[P_MII_10MBIT]			= 0,
+	[P_MII_FULL_DUPLEX]		= 1,
+	[P_MII_HALF_DUPLEX]		= 0,
 };
 
 static const u8 ksz9893_values[] = {
@@ -384,11 +392,15 @@ static const u8 ksz9893_values[] = {
 	[P_MII_NOT_1GBIT]		= 0,
 	[P_MII_100MBIT]			= 1,
 	[P_MII_10MBIT]			= 0,
+	[P_MII_FULL_DUPLEX]		= 1,
+	[P_MII_HALF_DUPLEX]		= 0,
 };
 
 static const u32 lan937x_masks[] = {
 	[ALU_STAT_WRITE]		= 1,
 	[ALU_STAT_READ]			= 2,
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(3),
 };
 
 static const u8 lan937x_shifts[] = {
@@ -1447,6 +1459,58 @@ void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed)
 	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
 }
 
+void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val)
+{
+	const u8 *bitval = dev->info->bitval;
+	const u16 *regs = dev->info->regs;
+	u8 data8;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
+
+	data8 &= ~P_MII_DUPLEX_M;
+
+	if (val)
+		data8 |= FIELD_PREP(P_MII_DUPLEX_M,
+				    bitval[P_MII_FULL_DUPLEX]);
+	else
+		data8 |= FIELD_PREP(P_MII_DUPLEX_M,
+				    bitval[P_MII_HALF_DUPLEX]);
+
+	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
+}
+
+void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val)
+{
+	const u32 *masks = dev->info->masks;
+	const u16 *regs = dev->info->regs;
+	u8 data8;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
+
+	if (val)
+		data8 |= masks[P_MII_TX_FLOW_CTRL];
+	else
+		data8 &= ~masks[P_MII_TX_FLOW_CTRL];
+
+	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
+}
+
+void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val)
+{
+	const u32 *masks = dev->info->masks;
+	const u16 *regs = dev->info->regs;
+	u8 data8;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
+
+	if (val)
+		data8 |= masks[P_MII_RX_FLOW_CTRL];
+	else
+		data8 &= ~masks[P_MII_RX_FLOW_CTRL];
+
+	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
+}
+
 static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f1fa6feca559..851ee50895a4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -198,6 +198,8 @@ enum ksz_masks {
 	DYNAMIC_MAC_TABLE_TIMESTAMP,
 	ALU_STAT_WRITE,
 	ALU_STAT_READ,
+	P_MII_TX_FLOW_CTRL,
+	P_MII_RX_FLOW_CTRL,
 };
 
 enum ksz_shifts {
@@ -218,6 +220,8 @@ enum ksz_values {
 	P_MII_NOT_1GBIT,
 	P_MII_100MBIT,
 	P_MII_10MBIT,
+	P_MII_FULL_DUPLEX,
+	P_MII_HALF_DUPLEX,
 };
 
 struct alu_struct {
@@ -308,6 +312,9 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
 void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed);
+void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val);
+void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val);
+void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -472,6 +479,7 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define SW_START			0x01
 
 /* xMII configuration */
+#define P_MII_DUPLEX_M			BIT(6)
 #define P_MII_100MBIT_M			BIT(4)
 
 #define P_MII_1GBIT_M			BIT(6)
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 37f63110e5bb..67b03ab0ede3 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -234,6 +234,8 @@ int lan937x_reset_switch(struct ksz_device *dev)
 
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
+	const u32 *masks = dev->info->masks;
+	const u16 *regs = dev->info->regs;
 	struct dsa_switch *ds = dev->ds;
 	u8 member;
 
@@ -254,8 +256,9 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
 
 	if (!dev->info->internal_phy[port])
-		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
-				 PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL,
+		lan937x_port_cfg(dev, port, regs[P_XMII_CTRL_0],
+				 masks[P_MII_TX_FLOW_CTRL] |
+				 masks[P_MII_RX_FLOW_CTRL],
 				 true);
 
 	if (cpu_port)
@@ -346,29 +349,18 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 				     int speed, int duplex,
 				     bool tx_pause, bool rx_pause)
 {
-	u8 xmii_ctrl0;
-
-	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
-
-	xmii_ctrl0 &= ~(PORT_MII_FULL_DUPLEX | PORT_MII_TX_FLOW_CTRL |
-			PORT_MII_RX_FLOW_CTRL);
-
 	if (speed == SPEED_1000)
 		ksz_set_gbit(dev, port, true);
 
 	if (speed == SPEED_100 || speed == SPEED_10)
 		ksz_set_100_10mbit(dev, port, speed);
 
-	if (duplex)
-		xmii_ctrl0 |= PORT_MII_FULL_DUPLEX;
+	ksz_set_fullduplex(dev, port, duplex);
 
-	if (tx_pause)
-		xmii_ctrl0 |= PORT_MII_TX_FLOW_CTRL;
+	ksz_set_tx_pause(dev, port, tx_pause);
 
-	if (rx_pause)
-		xmii_ctrl0 |= PORT_MII_RX_FLOW_CTRL;
+	ksz_set_rx_pause(dev, port, rx_pause);
 
-	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
 }
 
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index b9364f6a4f8f..d5eb6dc3a739 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -133,9 +133,6 @@
 /* 3 - xMII */
 #define REG_PORT_XMII_CTRL_0		0x0300
 #define PORT_SGMII_SEL			BIT(7)
-#define PORT_MII_FULL_DUPLEX		BIT(6)
-#define PORT_MII_TX_FLOW_CTRL		BIT(5)
-#define PORT_MII_RX_FLOW_CTRL		BIT(3)
 #define PORT_GRXC_ENABLE		BIT(0)
 
 #define REG_PORT_XMII_CTRL_1		0x0301
-- 
2.36.1

