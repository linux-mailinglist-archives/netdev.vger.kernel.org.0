Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FDC57DEFE
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiGVJh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbiGVJhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:37:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1582A9E7AC;
        Fri, 22 Jul 2022 02:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658481975; x=1690017975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6+jS0l7HUYGawJ41iiWm2aLYlRn1NvijBpO+FSvmcQ0=;
  b=ykARd1CG+tPZzGiEixudlSegfFJJeKRVSDcpnxNnRue2x2FxcaJDJPeg
   1GeRueMFEYYtYBD+wbQATU56yROUVN57lubBrETe8hOIi2prh/Ld/GPJB
   Fdq2B2ZxVBYIUIQ52r4Rqp+OqEsKQ74zCR5V2fjImw7sU8mogf3/4P22P
   q4Y/v/x7MCPE0h2V3gFCqL+9piZaND05ujyf6+6RvPjmEE+dxT2H+VI5z
   zAWHtzsbCXL9WyUX+KiECIvFTThsvVpqrKxH4ryrTkr6ezFiXPe5bHZx8
   x8tEvQvt/3ziuHus07tueSgkSro4+D6f4NMHisPvL5qMluN56opaZ38QB
   w==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="165939395"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 02:26:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 22 Jul 2022 02:26:06 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 22 Jul 2022 02:26:01 -0700
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
        "Arun Ramadoss" <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [Patch net-next v1 3/9] net: dsa: microchip: add common duplex and flow control function
Date:   Fri, 22 Jul 2022 14:54:53 +0530
Message-ID: <20220722092459.18653-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722092459.18653-1-arun.ramadoss@microchip.com>
References: <20220722092459.18653-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/microchip/ksz_common.c   | 62 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  8 +++
 drivers/net/dsa/microchip/lan937x_main.c | 24 +++------
 drivers/net/dsa/microchip/lan937x_reg.h  |  3 --
 5 files changed, 78 insertions(+), 20 deletions(-)

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
index 85392d3b1c2b..16825fcf43a8 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -281,11 +281,15 @@ static const u32 ksz8795_masks[] = {
 	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
 	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(5),
 };
 
 static const u8 ksz8795_xmii_ctrl0[] = {
 	[P_MII_100MBIT]			= 0,
 	[P_MII_10MBIT]			= 1,
+	[P_MII_FULL_DUPLEX]		= 0,
+	[P_MII_HALF_DUPLEX]		= 1,
 };
 
 static const u8 ksz8795_xmii_ctrl1[] = {
@@ -370,6 +374,8 @@ static const u16 ksz9477_regs[] = {
 static const u32 ksz9477_masks[] = {
 	[ALU_STAT_WRITE]		= 0,
 	[ALU_STAT_READ]			= 1,
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(3),
 };
 
 static const u8 ksz9477_shifts[] = {
@@ -379,6 +385,8 @@ static const u8 ksz9477_shifts[] = {
 static const u8 ksz9477_xmii_ctrl0[] = {
 	[P_MII_100MBIT]			= 1,
 	[P_MII_10MBIT]			= 0,
+	[P_MII_FULL_DUPLEX]		= 1,
+	[P_MII_HALF_DUPLEX]		= 0,
 };
 
 static const u8 ksz9477_xmii_ctrl1[] = {
@@ -389,6 +397,8 @@ static const u8 ksz9477_xmii_ctrl1[] = {
 static const u32 lan937x_masks[] = {
 	[ALU_STAT_WRITE]		= 1,
 	[ALU_STAT_READ]			= 2,
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(3),
 };
 
 static const u8 lan937x_shifts[] = {
@@ -1468,6 +1478,58 @@ void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed)
 		ksz_set_100_10mbit(dev, port, speed);
 }
 
+void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val)
+{
+	const u8 *bitval = dev->info->xmii_ctrl0;
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
index d87dc88d9f20..df8759dc02bd 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -197,6 +197,8 @@ enum ksz_masks {
 	DYNAMIC_MAC_TABLE_TIMESTAMP,
 	ALU_STAT_WRITE,
 	ALU_STAT_READ,
+	P_MII_TX_FLOW_CTRL,
+	P_MII_RX_FLOW_CTRL,
 };
 
 enum ksz_shifts {
@@ -215,6 +217,8 @@ enum ksz_shifts {
 enum ksz_xmii_ctrl0 {
 	P_MII_100MBIT,
 	P_MII_10MBIT,
+	P_MII_FULL_DUPLEX,
+	P_MII_HALF_DUPLEX,
 };
 
 enum ksz_xmii_ctrl1 {
@@ -310,6 +314,9 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
 void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed);
+void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val);
+void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val);
+void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -474,6 +481,7 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define SW_START			0x01
 
 /* xMII configuration */
+#define P_MII_DUPLEX_M			BIT(6)
 #define P_MII_100MBIT_M			BIT(4)
 
 #define P_GMII_1GBIT_M			BIT(6)
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index c48bae285758..92275064fa6b 100644
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
@@ -346,25 +349,14 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 				     int speed, int duplex,
 				     bool tx_pause, bool rx_pause)
 {
-	u8 xmii_ctrl0;
-
 	ksz_port_set_xmii_speed(dev, port, speed);
 
-	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
-
-	xmii_ctrl0 &= ~(PORT_MII_FULL_DUPLEX | PORT_MII_TX_FLOW_CTRL |
-			PORT_MII_RX_FLOW_CTRL);
-
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

