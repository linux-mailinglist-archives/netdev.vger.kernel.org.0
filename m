Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DE35547BA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357243AbiFVJJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357635AbiFVJIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:08:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3193B3FA;
        Wed, 22 Jun 2022 02:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888856; x=1687424856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1JYFHe1c1rzapK2yuqTkIdHMlUULOYNSa/aUlcrTpxA=;
  b=FVKkIYq3TkF8huJvSORx2/lVVI+8BUvKNuLTeGmZulc+jgNq4Hw7sIgU
   Z26e1x1vOSPnH/k2syPFp8J+BFJHs8iUQttsNUA6cGa7wuN/P8tlOkIID
   43p8o74/ygUKKdF75Tzs13RW5y/x5Lwk9qvM5+IuIJLbD1gFAUCJurQty
   GPfdj28OBLdzE3Es8LEP0tt3WkVc1H/UTG95VGzb0tcLspMtf9it4Z6fm
   8BMNT+OrmKDYan1OF2hmlK4fNZC8eVAYoSj+2l9vHvB4JiFo9b3JQ7raa
   ibJ4X+y4s2eswWqdVXxo4REL7iozKf39lLQKgAtH6Wtysnv2K4Aqzg80t
   w==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="169425124"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:07:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:07:33 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:07:28 -0700
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
Subject: [Patch net-next 05/13] net: dsa: microchip: move broadcast rate limit to ksz_setup
Date:   Wed, 22 Jun 2022 14:34:17 +0530
Message-ID: <20220622090425.17709-6-arun.ramadoss@microchip.com>
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

This patch move the 10% broadcast protection from the individual setup
to ksz_setup. In the ksz9477, broadcast protection is updated in reset
function.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     |  6 ------
 drivers/net/dsa/microchip/ksz8795_reg.h | 10 ----------
 drivers/net/dsa/microchip/ksz9477.c     |  6 ------
 drivers/net/dsa/microchip/ksz9477_reg.h | 10 ----------
 drivers/net/dsa/microchip/ksz_common.c  | 19 +++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  | 11 +++++++++++
 6 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 3d692d5816cb..1bbad202b238 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1415,12 +1415,6 @@ static int ksz8_setup(struct dsa_switch *ds)
 	if (!ksz_is_ksz88x3(dev))
 		ksz_cfg(dev, REG_SW_CTRL_19, SW_INS_TAG_ENABLE, true);
 
-	/* set broadcast storm protection 10% rate */
-	regmap_update_bits(dev->regmap[1], S_REPLACE_VID_CTRL,
-			   BROADCAST_STORM_RATE,
-			   (BROADCAST_STORM_VALUE *
-			   BROADCAST_STORM_PROT_RATE) / 100);
-
 	for (i = 0; i < (dev->info->num_vlans / 4); i++)
 		ksz8_r_vlan_entries(dev, i);
 
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index b8f6ad7581bc..7b56e533a688 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -64,13 +64,9 @@
 #define SW_FLOW_CTRL			BIT(5)
 #define SW_10_MBIT			BIT(4)
 #define SW_REPLACE_VID			BIT(3)
-#define BROADCAST_STORM_RATE_HI		0x07
 
 #define REG_SW_CTRL_5			0x07
 
-#define BROADCAST_STORM_RATE_LO		0xFF
-#define BROADCAST_STORM_RATE		0x07FF
-
 #define REG_SW_CTRL_6			0x08
 
 #define SW_MIB_COUNTER_FLUSH		BIT(7)
@@ -797,12 +793,6 @@
 #define REG_IND_EEE_GLOB2_LO		0x34
 #define REG_IND_EEE_GLOB2_HI		0x35
 
-/* Driver set switch broadcast storm protection at 10% rate. */
-#define BROADCAST_STORM_PROT_RATE	10
-
-/* 148,800 frames * 67 ms / 100 */
-#define BROADCAST_STORM_VALUE		9969
-
 /**
  * MIB_COUNTER_VALUE			00-00000000-3FFFFFFF
  * MIB_TOTAL_BYTES			00-0000000F-FFFFFFFF
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index c8965012d1c7..b2a6d2365c82 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -197,12 +197,6 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 	ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0x7F);
 	ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
 
-	/* set broadcast storm protection 10% rate */
-	regmap_update_bits(dev->regmap[1], REG_SW_MAC_CTRL_2,
-			   BROADCAST_STORM_RATE,
-			   (BROADCAST_STORM_VALUE *
-			   BROADCAST_STORM_PROT_RATE) / 100);
-
 	data8 = SW_ENABLE_REFCLKO;
 	if (dev->synclko_disable)
 		data8 = 0;
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 077e35ab11b5..0345fc7ac850 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -276,13 +276,9 @@
 #define REG_SW_MAC_CTRL_2		0x0332
 
 #define SW_REPLACE_VID			BIT(3)
-#define BROADCAST_STORM_RATE_HI		0x07
 
 #define REG_SW_MAC_CTRL_3		0x0333
 
-#define BROADCAST_STORM_RATE_LO		0xFF
-#define BROADCAST_STORM_RATE		0x07FF
-
 #define REG_SW_MAC_CTRL_4		0x0334
 
 #define SW_PASS_PAUSE			BIT(3)
@@ -1652,12 +1648,6 @@
 #define PTP_TRIG_UNIT_M			(BIT(MAX_TRIG_UNIT) - 1)
 #define PTP_TS_UNIT_M			(BIT(MAX_TIMESTAMP_UNIT) - 1)
 
-/* Driver set switch broadcast storm protection at 10% rate. */
-#define BROADCAST_STORM_PROT_RATE	10
-
-/* 148,800 frames * 67 ms / 100 */
-#define BROADCAST_STORM_VALUE		9969
-
 #define KSZ9477_MAX_FRAME_SIZE		9000
 
 #endif /* KSZ9477_REGS_H */
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 792f891579ae..976b2b18908f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -153,6 +153,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x02,
+		.broadcast_ctrl_reg =  0x06,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -186,6 +187,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x02,
+		.broadcast_ctrl_reg =  0x06,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -205,6 +207,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x02,
+		.broadcast_ctrl_reg =  0x06,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -223,6 +226,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x02,
+		.broadcast_ctrl_reg =  0x06,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.internal_phy = {true, true, false},
@@ -241,6 +245,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
 		.supports_rmii	= {false, false, false, false,
@@ -264,6 +269,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -286,6 +292,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
@@ -305,6 +312,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -327,6 +335,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -345,6 +354,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
@@ -363,6 +373,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -385,6 +396,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -407,6 +419,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.stp_ctrl_reg = 0x0B04,
+		.broadcast_ctrl_reg =  0x0332,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -623,6 +636,12 @@ int ksz_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
+	/* set broadcast storm protection 10% rate */
+	regmap_update_bits(dev->regmap[1], dev->info->broadcast_ctrl_reg,
+			   BROADCAST_STORM_RATE,
+			   (BROADCAST_STORM_VALUE *
+			   BROADCAST_STORM_PROT_RATE) / 100);
+
 	dev->dev_ops->config_cpu_port(ds);
 
 	dev->dev_ops->enable_stp_addr(dev);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 3b8e1d1887b8..6aeee4771f06 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -47,6 +47,7 @@ struct ksz_chip_data {
 	int mib_cnt;
 	u8 reg_mib_cnt;
 	int stp_ctrl_reg;
+	int broadcast_ctrl_reg;
 	bool supports_mii[KSZ_MAX_NUM_PORTS];
 	bool supports_rmii[KSZ_MAX_NUM_PORTS];
 	bool supports_rgmii[KSZ_MAX_NUM_PORTS];
@@ -415,6 +416,16 @@ static inline void ksz_regmap_unlock(void *__mtx)
 
 #define SW_REV_ID_M			GENMASK(7, 4)
 
+/* Driver set switch broadcast storm protection at 10% rate. */
+#define BROADCAST_STORM_PROT_RATE	10
+
+/* 148,800 frames * 67 ms / 100 */
+#define BROADCAST_STORM_VALUE		9969
+
+#define BROADCAST_STORM_RATE_HI		0x07
+#define BROADCAST_STORM_RATE_LO		0xFF
+#define BROADCAST_STORM_RATE		0x07FF
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
-- 
2.36.1

