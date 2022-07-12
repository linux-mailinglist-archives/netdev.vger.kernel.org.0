Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CE757203F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiGLQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiGLQES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:04:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE2E2DAA2;
        Tue, 12 Jul 2022 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657641857; x=1689177857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tw3vuaWFvkhWlzTBnv9vhPxKEU2+UfaZIGjbVhEFYiA=;
  b=vSiMafjI9til8bixgkrG2aBh87QKVqVj/YvWz9w1nEpqtf8YS31FKeLx
   UMkw898extYD+F1jwzcnDY5zy4xgUN2obuAVDY3RGWdooAdN46BzoCf1u
   tThdvdaz9hQ8Ogu2H/lh0KrPznMsXO1BdzvovkmiyWMgC6oOjf4kF1s6i
   x1saGfJ4eSZAEzLlfxPUCUBEgwSDH9QHTRC9yEu+d2/DHbv+3yYHKWsfW
   Y63fAHKUPszZrS8NixeuDbBC44rj4m26QZAq5VhttvikD2jOmc9VDBN+e
   RDDmqM6JAcb7OL/TVNh1nXMtRtH4hUu3jGx/DdsRfat4QG9b/bhFkqKyr
   A==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="172070206"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2022 09:04:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Jul 2022 09:04:14 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:04:05 -0700
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
Subject: [RFC Patch net-next 03/10] net: dsa: microchip: add common 100/10Mbps selection function
Date:   Tue, 12 Jul 2022 21:33:01 +0530
Message-ID: <20220712160308.13253-4-arun.ramadoss@microchip.com>
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

This patch adds the function for configuring the 100/10Mbps speed
selection for the ksz switches. KSZ8795 switch uses Global control 4
register 0x06 bit 4 for choosing 100/10Mpbs. Other switches uses xMII
control 1 0xN300 for it.
For KSZ8795, if the bit is set then 10Mbps is chosen and if bit is
clear then 100Mbps chosen. For all other switches it is other way
around, if the bit is set then 100Mbps is chosen.
So, this patch add the generic function for ksz switch to select the
100/10Mbps speed selection. While configuring, first it disables the
gigabit functionality and then configure the respective speed.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477_reg.h  |  1 -
 drivers/net/dsa/microchip/ksz_common.c   | 29 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  6 +++++
 drivers/net/dsa/microchip/lan937x_main.c | 14 ++++--------
 drivers/net/dsa/microchip/lan937x_reg.h  |  1 -
 5 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index f23ed4809e47..2649fdf0bae1 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1179,7 +1179,6 @@
 
 #define PORT_SGMII_SEL			BIT(7)
 #define PORT_MII_FULL_DUPLEX		BIT(6)
-#define PORT_MII_100MBIT		BIT(4)
 #define PORT_GRXC_ENABLE		BIT(0)
 
 #define REG_PORT_XMII_CTRL_1		0x0301
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5ebcd87fc531..f41cd2801210 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -256,6 +256,7 @@ static const u16 ksz8795_regs[] = {
 	[S_START_CTRL]			= 0x01,
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
+	[P_XMII_CTRL_0]			= 0x06,
 	[P_XMII_CTRL_1]			= 0x56,
 };
 
@@ -284,6 +285,8 @@ static const u32 ksz8795_masks[] = {
 static const u8 ksz8795_values[] = {
 	[P_MII_1GBIT]			= 1,
 	[P_MII_NOT_1GBIT]		= 0,
+	[P_MII_100MBIT]			= 0,
+	[P_MII_10MBIT]			= 1,
 };
 
 static const u8 ksz8795_shifts[] = {
@@ -356,6 +359,7 @@ static const u16 ksz9477_regs[] = {
 	[S_START_CTRL]			= 0x0300,
 	[S_BROADCAST_CTRL]		= 0x0332,
 	[S_MULTICAST_CTRL]		= 0x0331,
+	[P_XMII_CTRL_0]			= 0x0300,
 	[P_XMII_CTRL_1]			= 0x0301,
 };
 
@@ -371,11 +375,15 @@ static const u8 ksz9477_shifts[] = {
 static const u8 ksz9477_values[] = {
 	[P_MII_1GBIT]			= 0,
 	[P_MII_NOT_1GBIT]		= 1,
+	[P_MII_100MBIT]			= 1,
+	[P_MII_10MBIT]			= 0,
 };
 
 static const u8 ksz9893_values[] = {
 	[P_MII_1GBIT]			= 1,
 	[P_MII_NOT_1GBIT]		= 0,
+	[P_MII_100MBIT]			= 1,
+	[P_MII_10MBIT]			= 0,
 };
 
 static const u32 lan937x_masks[] = {
@@ -1418,6 +1426,27 @@ void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit)
 	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
 }
 
+void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed)
+{
+	const u8 *bitval = dev->info->bitval;
+	const u16 *regs = dev->info->regs;
+	u8 data8;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
+
+	data8 &= ~P_MII_100MBIT_M;
+
+	ksz_set_gbit(dev, port, false);
+
+	if (speed == SPEED_100)
+		data8 |= FIELD_PREP(P_MII_100MBIT_M, bitval[P_MII_100MBIT]);
+	else
+		data8 |= FIELD_PREP(P_MII_100MBIT_M, bitval[P_MII_10MBIT]);
+
+	/* Write the updated value */
+	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
+}
+
 static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a76dfef6309c..f1fa6feca559 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -172,6 +172,7 @@ enum ksz_regs {
 	S_START_CTRL,
 	S_BROADCAST_CTRL,
 	S_MULTICAST_CTRL,
+	P_XMII_CTRL_0,
 	P_XMII_CTRL_1,
 };
 
@@ -215,6 +216,8 @@ enum ksz_shifts {
 enum ksz_values {
 	P_MII_1GBIT,
 	P_MII_NOT_1GBIT,
+	P_MII_100MBIT,
+	P_MII_10MBIT,
 };
 
 struct alu_struct {
@@ -304,6 +307,7 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
+void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -468,6 +472,8 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define SW_START			0x01
 
 /* xMII configuration */
+#define P_MII_100MBIT_M			BIT(4)
+
 #define P_MII_1GBIT_M			BIT(6)
 
 /* Regmap tables generation */
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index efca96b02e15..37f63110e5bb 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -346,21 +346,18 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 				     int speed, int duplex,
 				     bool tx_pause, bool rx_pause)
 {
-	u8 xmii_ctrl0, xmii_ctrl1;
+	u8 xmii_ctrl0;
 
 	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
-	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &xmii_ctrl1);
 
-	xmii_ctrl0 &= ~(PORT_MII_100MBIT | PORT_MII_FULL_DUPLEX |
-			PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL);
+	xmii_ctrl0 &= ~(PORT_MII_FULL_DUPLEX | PORT_MII_TX_FLOW_CTRL |
+			PORT_MII_RX_FLOW_CTRL);
 
 	if (speed == SPEED_1000)
 		ksz_set_gbit(dev, port, true);
-	else
-		ksz_set_gbit(dev, port, false);
 
-	if (speed == SPEED_100)
-		xmii_ctrl0 |= PORT_MII_100MBIT;
+	if (speed == SPEED_100 || speed == SPEED_10)
+		ksz_set_100_10mbit(dev, port, speed);
 
 	if (duplex)
 		xmii_ctrl0 |= PORT_MII_FULL_DUPLEX;
@@ -372,7 +369,6 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 		xmii_ctrl0 |= PORT_MII_RX_FLOW_CTRL;
 
 	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
-	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, xmii_ctrl1);
 }
 
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index 747295d34411..b9364f6a4f8f 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -135,7 +135,6 @@
 #define PORT_SGMII_SEL			BIT(7)
 #define PORT_MII_FULL_DUPLEX		BIT(6)
 #define PORT_MII_TX_FLOW_CTRL		BIT(5)
-#define PORT_MII_100MBIT		BIT(4)
 #define PORT_MII_RX_FLOW_CTRL		BIT(3)
 #define PORT_GRXC_ENABLE		BIT(0)
 
-- 
2.36.1

