Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8005755465B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357309AbiFVJJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357187AbiFVJJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:09:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4260A655D;
        Wed, 22 Jun 2022 02:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888876; x=1687424876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=icS9ww33nS5c6vx3JRhg5AukSknYpFlZE6EotAMz4ts=;
  b=syU0htRzFv64npyQBtXV4/PVk1JUH8U0yRq9R71weLLbGZzkLW2E1Fm4
   BK2T0iYJ0Bo3Kklw1zJF/j47CghHev45z15ujPShqp9PcN0aLxIljq9OV
   6puRDC6MpJ77oAHOsWniB5HTJ6Tla/6C6VrRsRGH/pjEu/b5Tiwn+e11P
   j+Xouy2LuobFMoqlPlEcaPEYwMTNstxj90uiYgtfI88r/gyqhQ0QSHe+l
   Tfb7Vkq1KRRGDiGtRaWMJVXlxqAPTVGEXmMTZ7yJpnCTQwYyXb8Gf1aYB
   e63IhsoUfo4BL56yI1YNd2sEOViUGADhoW/d3i7arqvNohlB2dGD+3HPE
   g==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="169425168"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:07:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:07:53 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:07:48 -0700
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
Subject: [Patch net-next 06/13] net: dsa: microchip: move multicast enable to ksz_setup
Date:   Wed, 22 Jun 2022 14:34:18 +0530
Message-ID: <20220622090425.17709-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
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

This patch moves the enabling the multicast storm protection from
individual setup function to ksz_setup function.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     |  2 --
 drivers/net/dsa/microchip/ksz8795_reg.h |  1 -
 drivers/net/dsa/microchip/ksz9477.c     |  2 --
 drivers/net/dsa/microchip/ksz9477_reg.h |  1 -
 drivers/net/dsa/microchip/ksz_common.c  | 16 ++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  3 +++
 6 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 1bbad202b238..662493db8638 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1406,8 +1406,6 @@ static int ksz8_setup(struct dsa_switch *ds)
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP,
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP);
 
-	ksz_cfg(dev, REG_SW_CTRL_2, MULTICAST_STORM_DISABLE, true);
-
 	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_REPLACE_VID, false);
 
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 7b56e533a688..f2b0399d69d1 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -44,7 +44,6 @@
 #define REG_SW_CTRL_2			0x04
 
 #define UNICAST_VLAN_BOUNDARY		BIT(7)
-#define MULTICAST_STORM_DISABLE		BIT(6)
 #define SW_BACK_PRESSURE		BIT(5)
 #define FAIR_FLOW_CTRL			BIT(4)
 #define NO_EXC_COLLISION_DROP		BIT(3)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index b2a6d2365c82..827e62b032d2 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1281,8 +1281,6 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ksz_cfg(dev, REG_SW_MAC_CTRL_1, MULTICAST_STORM_DISABLE, true);
-
 	/* queue based egress rate limit */
 	ksz_cfg(dev, REG_SW_MAC_CTRL_5, SW_OUT_RATE_LIMIT_QUEUE_BASED, true);
 
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 0345fc7ac850..57e03dfcf869 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -265,7 +265,6 @@
 
 #define REG_SW_MAC_CTRL_1		0x0331
 
-#define MULTICAST_STORM_DISABLE		BIT(6)
 #define SW_BACK_PRESSURE		BIT(5)
 #define FAIR_FLOW_CTRL			BIT(4)
 #define NO_EXC_COLLISION_DROP		BIT(3)
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 976b2b18908f..719fa1b0884e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -154,6 +154,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
+		.multicast_ctrl_reg = 0x04,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -188,6 +189,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
+		.multicast_ctrl_reg = 0x04,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -208,6 +210,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
+		.multicast_ctrl_reg = 0x04,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -227,6 +230,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
+		.multicast_ctrl_reg = 0x04,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.internal_phy = {true, true, false},
@@ -246,6 +250,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
 		.supports_rmii	= {false, false, false, false,
@@ -270,6 +275,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -293,6 +299,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
@@ -313,6 +320,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -336,6 +344,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -355,6 +364,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
@@ -374,6 +384,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -397,6 +408,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -420,6 +432,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
+		.multicast_ctrl_reg = 0x0331,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -646,6 +659,9 @@ int ksz_setup(struct dsa_switch *ds)
 
 	dev->dev_ops->enable_stp_addr(dev);
 
+	regmap_update_bits(dev->regmap[0], dev->info->multicast_ctrl_reg,
+			   MULTICAST_STORM_DISABLE, MULTICAST_STORM_DISABLE);
+
 	ksz_init_mib_timer(dev);
 
 	ds->configure_vlan_while_not_filtering = false;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 6aeee4771f06..35d734ee932e 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -48,6 +48,7 @@ struct ksz_chip_data {
 	u8 reg_mib_cnt;
 	int stp_ctrl_reg;
 	int broadcast_ctrl_reg;
+	int multicast_ctrl_reg;
 	bool supports_mii[KSZ_MAX_NUM_PORTS];
 	bool supports_rmii[KSZ_MAX_NUM_PORTS];
 	bool supports_rgmii[KSZ_MAX_NUM_PORTS];
@@ -426,6 +427,8 @@ static inline void ksz_regmap_unlock(void *__mtx)
 #define BROADCAST_STORM_RATE_LO		0xFF
 #define BROADCAST_STORM_RATE		0x07FF
 
+#define MULTICAST_STORM_DISABLE		BIT(6)
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
-- 
2.36.1

