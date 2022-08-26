Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFEC5A2657
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343619AbiHZK5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344149AbiHZK5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:57:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E29A261C
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:56:57 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0x-0002vY-Fz; Fri, 26 Aug 2022 12:56:39 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0w-0024ZV-E2; Fri, 26 Aug 2022 12:56:38 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0t-00GB2C-Dj; Fri, 26 Aug 2022 12:56:35 +0200
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
Subject: [PATCH net-next v4 02/17] net: dsa: microchip: do per-port Gbit detection instead of per-chip
Date:   Fri, 26 Aug 2022 12:56:19 +0200
Message-Id: <20220826105634.3855578-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826105634.3855578-1-o.rempel@pengutronix.de>
References: <20220826105634.3855578-1-o.rempel@pengutronix.de>
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

KSZ8563 has two 100Mbit PHYs and CPU port with RGMII support. Since
1000Mbit configuration for the RGMII capable MAC is present, we should
use per port validation.

As main part of migration to per-port validation we need to rework
ksz9477_switch_init() function. Which is using undocumented
REG_GLOBAL_OPTIONS register to detect per-chip Gbit support. So, it is
related to some sort of risk for regressions.

To reduce this risk I compared the code with publicly available
documentations. This function will executed on following currently
supported chips:
struct ksz_chip_data            OF compatible
KSZ9477				KSZ9477
KSZ9897				KSZ9897
KSZ9893				KSZ9893, KSZ9563
KSZ8563				KSZ8563
KSZ9567				KSZ9567

Only KSZ9893, KSZ9563, KSZ8563 document existence of 0xf ==
REG_GLOBAL_OPTIONS register with bit field description "SKU ID":
KSZ9893 0x0C
KSZ9563 0x1C
KSZ8563 0x3C

The existence of hidden flags is not documented.

KSZ9477, KSZ9897, KSZ9567 do not document this register at all.

Only KSZ8563 is documented as non Gbit chip: 100Mbit PHYs and RGMII CPU
port. So, this change should not introduce a regression for
configurations with properly used OF compatibles.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 20 +++-----------------
 drivers/net/dsa/microchip/ksz_common.c |  5 +++++
 drivers/net/dsa/microchip/ksz_common.h |  2 +-
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index e4f446db0ca18..0f7f44358d7b3 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -320,7 +320,7 @@ void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 		return;
 
 	/* No gigabit support.  Do not write to this register. */
-	if (!(dev->features & GBIT_SUPPORT) && reg == MII_CTRL1000)
+	if (!dev->info->gbit_capable[addr] && reg == MII_CTRL1000)
 		return;
 
 	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
@@ -914,7 +914,7 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 	/* Energy Efficient Ethernet (EEE) feature select must
 	 * be manually disabled (except on KSZ8565 which is 100Mbit)
 	 */
-	if (dev->features & GBIT_SUPPORT)
+	if (dev->info->gbit_capable[port])
 		ksz9477_port_mmd_write(dev, port, 0x07, 0x3c, 0x0000);
 
 	/* Register settings are required to meet data sheet
@@ -941,7 +941,7 @@ void ksz9477_get_caps(struct ksz_device *dev, int port,
 	config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
 				   MAC_SYM_PAUSE;
 
-	if (dev->features & GBIT_SUPPORT)
+	if (dev->info->gbit_capable[port])
 		config->mac_capabilities |= MAC_1000FD;
 }
 
@@ -1158,27 +1158,13 @@ int ksz9477_switch_init(struct ksz_device *dev)
 	if (ret)
 		return ret;
 
-	ret = ksz_read8(dev, REG_GLOBAL_OPTIONS, &data8);
-	if (ret)
-		return ret;
-
 	/* Number of ports can be reduced depending on chip. */
 	dev->phy_port_cnt = 5;
 
-	/* Default capability is gigabit capable. */
-	dev->features = GBIT_SUPPORT;
-
 	if (dev->chip_id == KSZ9893_CHIP_ID) {
 		dev->features |= IS_9893;
 
-		/* Chip does not support gigabit. */
-		if (data8 & SW_QW_ABLE)
-			dev->features &= ~GBIT_SUPPORT;
 		dev->phy_port_cnt = 2;
-	} else {
-		/* Chip does not support gigabit. */
-		if (!(data8 & SW_GIGABIT_ABLE))
-			dev->features &= ~GBIT_SUPPORT;
 	}
 
 	return 0;
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5cadc831c75d5..7b6d7efc0a002 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -434,6 +434,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
 		.internal_phy = {true, true, false},
+		.gbit_capable = {false, false, true},
 	},
 
 	[KSZ8795] = {
@@ -568,6 +569,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 				   false, true, false},
 		.internal_phy	= {true, true, true, true,
 				   true, false, false},
+		.gbit_capable	= {true, true, true, true, true, true, true},
 	},
 
 	[KSZ9897] = {
@@ -596,6 +598,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 				   false, true, true},
 		.internal_phy	= {true, true, true, true,
 				   true, false, false},
+		.gbit_capable	= {true, true, true, true, true, true, true},
 	},
 
 	[KSZ9893] = {
@@ -619,6 +622,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
 		.internal_phy = {true, true, false},
+		.gbit_capable = {true, true, true},
 	},
 
 	[KSZ9567] = {
@@ -647,6 +651,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 				   false, true, true},
 		.internal_phy	= {true, true, true, true,
 				   true, false, false},
+		.gbit_capable	= {true, true, true, true, true, true, true},
 	},
 
 	[LAN9370] = {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index eedcbcddd000c..e3e120d659410 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -61,6 +61,7 @@ struct ksz_chip_data {
 	bool supports_rmii[KSZ_MAX_NUM_PORTS];
 	bool supports_rgmii[KSZ_MAX_NUM_PORTS];
 	bool internal_phy[KSZ_MAX_NUM_PORTS];
+	bool gbit_capable[KSZ_MAX_NUM_PORTS];
 };
 
 struct ksz_port {
@@ -504,7 +505,6 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define SW_START			0x01
 
 /* Used with variable features to indicate capabilities. */
-#define GBIT_SUPPORT			BIT(0)
 #define IS_9893				BIT(2)
 
 /* xMII configuration */
-- 
2.30.2

