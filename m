Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F0D57204C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiGLQF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiGLQFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:05:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B2FC84E5;
        Tue, 12 Jul 2022 09:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657641901; x=1689177901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IGU9NEoGjqgkC//Wwn5vNBch3gCGqb5UkQZMv+AM6Cw=;
  b=eoF3bUC/XTONbf8dqyxUydNLWXEy7hWHCsSHxxaLjcFfV6KReC0S1eAs
   oGAsNTTG+qkNtWAQUz9bjdxucoBVeFISOlU0+k9rUS7SSpUp8BB4dQ6QQ
   ze30moGsE4I2DLxsUEJevvgvhkdfyJ+GH3vph6qaxJX05AnixdOfZXQVz
   2/kScwXs7/go60/9zCNBuwrFbpppYC/vLwV6htK5Co3/+K1WBorazIUiw
   yzMcaNWBV5jDLL+ZrVW811VulpFPvxRyvTCAwkfGM04lwpfLROelVBzUx
   lxu+kMqZUpRyl1uuxJouqLlIeze/iiINSD9qx7+5jSR02egzIj/9/G2Zn
   g==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="167484429"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2022 09:05:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Jul 2022 09:04:57 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:04:45 -0700
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
Subject: [RFC Patch net-next 06/10] net: dsa: microchip: lan937x: add support for configuing xMII register
Date:   Tue, 12 Jul 2022 21:33:04 +0530
Message-ID: <20220712160308.13253-7-arun.ramadoss@microchip.com>
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

This patch add the common ksz_set_xmii function for ksz series switch
and update the lan937x code phylink mac config. The register address for
the ksz8795 is Port 5 Interface control 6 and for all other switch is
xMII Control 1.
The bit value for selecting the interface is same for
KSZ8795 and KSZ9893 are same. The bit values for KSZ9477 and lan973x are
same. So, this patch add the bit value for each switches in
ksz_chip_data and configure the registers based on the chip id.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   | 57 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  8 ++++
 drivers/net/dsa/microchip/lan937x_main.c | 32 +------------
 drivers/net/dsa/microchip/lan937x_reg.h  |  9 ----
 4 files changed, 66 insertions(+), 40 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 0cb711fcf046..649da4c361c1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -284,6 +284,10 @@ static const u32 ksz8795_masks[] = {
 };
 
 static const u8 ksz8795_values[] = {
+	[P_RGMII_SEL]			= 3,
+	[P_GMII_SEL]			= 2,
+	[P_RMII_SEL]			= 1,
+	[P_MII_SEL]			= 0,
 	[P_MII_1GBIT]			= 1,
 	[P_MII_NOT_1GBIT]		= 0,
 	[P_MII_100MBIT]			= 0,
@@ -378,6 +382,10 @@ static const u8 ksz9477_shifts[] = {
 };
 
 static const u8 ksz9477_values[] = {
+	[P_RGMII_SEL]			= 0,
+	[P_RMII_SEL]			= 1,
+	[P_GMII_SEL]			= 2,
+	[P_MII_SEL]			= 3,
 	[P_MII_1GBIT]			= 0,
 	[P_MII_NOT_1GBIT]		= 1,
 	[P_MII_100MBIT]			= 1,
@@ -387,6 +395,10 @@ static const u8 ksz9477_values[] = {
 };
 
 static const u8 ksz9893_values[] = {
+	[P_RGMII_SEL]			= 3,
+	[P_GMII_SEL]			= 2,
+	[P_RMII_SEL]			= 1,
+	[P_MII_SEL]			= 0,
 	[P_MII_1GBIT]			= 1,
 	[P_MII_NOT_1GBIT]		= 0,
 	[P_MII_100MBIT]			= 1,
@@ -1390,6 +1402,51 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 	return dev->dev_ops->max_mtu(dev, port);
 }
 
+void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface)
+{
+	const u8 *bitval = dev->info->bitval;
+	const u16 *regs = dev->info->regs;
+	u8 data8;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
+
+	data8 &= ~(P_MII_SEL_M | P_RGMII_ID_IG_ENABLE |
+		   P_RGMII_ID_EG_ENABLE);
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_MII:
+		data8 |= bitval[P_MII_SEL];
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		data8 |= bitval[P_RMII_SEL];
+		break;
+	case PHY_INTERFACE_MODE_GMII:
+		data8 |= bitval[P_GMII_SEL];
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		data8 |= bitval[P_RGMII_SEL];
+		break;
+	default:
+		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
+			phy_modes(interface), port);
+		return;
+	}
+
+	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    interface == PHY_INTERFACE_MODE_RGMII_RXID)
+		data8 |= P_RGMII_ID_IG_ENABLE;
+
+	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    interface == PHY_INTERFACE_MODE_RGMII_TXID)
+		data8 |= P_RGMII_ID_EG_ENABLE;
+
+	/* Write the updated value */
+	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
+}
+
 static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 				   unsigned int mode,
 				   const struct phylink_link_state *state)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index db836b376341..90f3ec9ddaec 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -216,6 +216,10 @@ enum ksz_shifts {
 };
 
 enum ksz_values {
+	P_RGMII_SEL,
+	P_RMII_SEL,
+	P_GMII_SEL,
+	P_MII_SEL,
 	P_MII_1GBIT,
 	P_MII_NOT_1GBIT,
 	P_MII_100MBIT,
@@ -311,6 +315,7 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
+void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -479,6 +484,9 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define P_MII_100MBIT_M			BIT(4)
 
 #define P_MII_1GBIT_M			BIT(6)
+#define P_RGMII_ID_IG_ENABLE		BIT(4)
+#define P_RGMII_ID_EG_ENABLE		BIT(3)
+#define P_MII_SEL_M			0x3
 
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index a2e648eacd19..d86ffdf976b0 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -315,36 +315,6 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
 	return 0;
 }
 
-static void lan937x_mac_config(struct ksz_device *dev, int port,
-			       phy_interface_t interface)
-{
-	u8 data8;
-
-	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
-
-	/* clear MII selection & set it based on interface later */
-	data8 &= ~PORT_MII_SEL_M;
-
-	/* configure MAC based on interface */
-	switch (interface) {
-	case PHY_INTERFACE_MODE_MII:
-		ksz_set_gbit(dev, port, false);
-		data8 |= PORT_MII_SEL;
-		break;
-	case PHY_INTERFACE_MODE_RMII:
-		ksz_set_gbit(dev, port, false);
-		data8 |= PORT_RMII_SEL;
-		break;
-	default:
-		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
-			phy_modes(interface), port);
-		return;
-	}
-
-	/* Write the updated value */
-	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
-}
-
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config)
 {
@@ -370,7 +340,7 @@ void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
 		return;
 	}
 
-	lan937x_mac_config(dev, port, state->interface);
+	ksz_set_xmii(dev, port, state->interface);
 }
 
 int lan937x_setup(struct dsa_switch *ds)
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index d5eb6dc3a739..a6cb3ca22dc3 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -131,19 +131,10 @@
 #define REG_PORT_T1_PHY_CTRL_BASE	0x0100
 
 /* 3 - xMII */
-#define REG_PORT_XMII_CTRL_0		0x0300
 #define PORT_SGMII_SEL			BIT(7)
 #define PORT_GRXC_ENABLE		BIT(0)
 
-#define REG_PORT_XMII_CTRL_1		0x0301
 #define PORT_MII_SEL_EDGE		BIT(5)
-#define PORT_RGMII_ID_IG_ENABLE		BIT(4)
-#define PORT_RGMII_ID_EG_ENABLE		BIT(3)
-#define PORT_MII_MAC_MODE		BIT(2)
-#define PORT_MII_SEL_M			0x3
-#define PORT_RGMII_SEL			0x0
-#define PORT_RMII_SEL			0x1
-#define PORT_MII_SEL			0x2
 
 /* 4 - MAC */
 #define REG_PORT_MAC_CTRL_0		0x0400
-- 
2.36.1

