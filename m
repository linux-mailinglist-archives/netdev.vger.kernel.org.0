Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3507C55EAC8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiF1RPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiF1RPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:15:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F392CDFF;
        Tue, 28 Jun 2022 10:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656436540; x=1687972540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J+3M0iKZHAnoFTbrr1G4kQpS3+nwFQ1xAT9f0AR8Ybg=;
  b=Jwb0S7/7nAJ16UAXitd0TZyiHNbgXJGUdIZzpGKPqzoNcmcdubzzQGRc
   NVHjqVkLgJPr0t5qoULUHoUgLnWubF70fIBaOExprmOrXakIAK6KmCtcG
   Q1V5Nrq8j+SghEaUXlqjxftfUa3Jpb2LDp9+37FkHoC+tXFhGc8UbDP7M
   qXtgvTUAG31vTU+z7EAjMZMoYlw4uZS5sDogLsFBzSCIcf4ZxKjGzB3TP
   yFICgFUdKADuYRaCyHrTdRxPJ5vin3oJRM4daSwOetlvAQUJNoXHzr+Wx
   FZpauOMCkhwiqU84wCmiSwTa+63mZsbQy4BuWUrIl7UZLOYBpUf6xiXIo
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="162448097"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 10:15:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 10:15:31 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 10:15:20 -0700
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
Subject: [Patch net-next 7/7] net: dsa: microchip: move remaining register offset to ksz_chip_reg
Date:   Tue, 28 Jun 2022 22:43:29 +0530
Message-ID: <20220628171329.25503-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628171329.25503-1-arun.ramadoss@microchip.com>
References: <20220628171329.25503-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the broadcast ctrl, multicast ctrl and start control
registers from ksz_chip_dat to ksz_chip_reg.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 57 +++++++-------------------
 drivers/net/dsa/microchip/ksz_common.h |  3 ++
 2 files changed, 18 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 2f336b991d5a..1354804171a1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -217,6 +217,9 @@ static const u16 ksz8795_regs[] = {
 	[P_SPEED_STATUS]		= 0x09,
 	[S_TAIL_TAG_CTRL]		= 0x0C,
 	[P_STP_CTRL]			= 0x02,
+	[S_START_CTRL]			= 0x01,
+	[S_BROADCAST_CTRL]		= 0x06,
+	[S_MULTICAST_CTRL]		= 0x04,
 };
 
 static const u32 ksz8795_masks[] = {
@@ -268,6 +271,9 @@ static const u16 ksz8863_regs[] = {
 	[P_SPEED_STATUS]		= 0x0F,
 	[S_TAIL_TAG_CTRL]		= 0x03,
 	[P_STP_CTRL]			= 0x02,
+	[S_START_CTRL]			= 0x01,
+	[S_BROADCAST_CTRL]		= 0x06,
+	[S_MULTICAST_CTRL]		= 0x04,
 };
 
 static const u32 ksz8863_masks[] = {
@@ -305,6 +311,9 @@ static u8 ksz8863_shifts[] = {
 
 static const u16 ksz9477_regs[] = {
 	[P_STP_CTRL]			= 0x0B04,
+	[S_START_CTRL]			= 0x0300,
+	[S_BROADCAST_CTRL]		= 0x0332,
+	[S_MULTICAST_CTRL]		= 0x0331,
 
 };
 
@@ -325,9 +334,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
-		.broadcast_ctrl_reg =  0x06,
-		.multicast_ctrl_reg = 0x04,
-		.start_ctrl_reg = 0x01,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -364,9 +370,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
-		.broadcast_ctrl_reg =  0x06,
-		.multicast_ctrl_reg = 0x04,
-		.start_ctrl_reg = 0x01,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -389,9 +392,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
-		.broadcast_ctrl_reg =  0x06,
-		.multicast_ctrl_reg = 0x04,
-		.start_ctrl_reg = 0x01,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -413,9 +413,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8863_regs,
 		.masks = ksz8863_masks,
 		.shifts = ksz8863_shifts,
-		.broadcast_ctrl_reg =  0x06,
-		.multicast_ctrl_reg = 0x04,
-		.start_ctrl_reg = 0x01,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.internal_phy = {true, true, false},
@@ -435,9 +432,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
 		.supports_rmii	= {false, false, false, false,
@@ -462,9 +456,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -488,9 +479,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
@@ -511,9 +499,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -536,9 +521,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -557,9 +539,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
@@ -578,9 +557,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -603,9 +579,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -628,9 +601,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
-		.broadcast_ctrl_reg =  0x0332,
-		.multicast_ctrl_reg = 0x0331,
-		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -830,8 +800,11 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 static int ksz_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	const u16 *regs;
 	int ret;
 
+	regs = dev->info->regs;
+
 	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
 				       dev->info->num_vlans, GFP_KERNEL);
 	if (!dev->vlan_cache)
@@ -844,7 +817,7 @@ static int ksz_setup(struct dsa_switch *ds)
 	}
 
 	/* set broadcast storm protection 10% rate */
-	regmap_update_bits(dev->regmap[1], dev->info->broadcast_ctrl_reg,
+	regmap_update_bits(dev->regmap[1], regs[S_BROADCAST_CTRL],
 			   BROADCAST_STORM_RATE,
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
@@ -853,7 +826,7 @@ static int ksz_setup(struct dsa_switch *ds)
 
 	dev->dev_ops->enable_stp_addr(dev);
 
-	regmap_update_bits(dev->regmap[0], dev->info->multicast_ctrl_reg,
+	regmap_update_bits(dev->regmap[0], regs[S_MULTICAST_CTRL],
 			   MULTICAST_STORM_DISABLE, MULTICAST_STORM_DISABLE);
 
 	ksz_init_mib_timer(dev);
@@ -867,7 +840,7 @@ static int ksz_setup(struct dsa_switch *ds)
 	}
 
 	/* start switch */
-	regmap_update_bits(dev->regmap[0], dev->info->start_ctrl_reg,
+	regmap_update_bits(dev->regmap[0], regs[S_START_CTRL],
 			   SW_START, SW_START);
 
 	return 0;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 2a9b2b59fa79..91fbb3b62536 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -165,6 +165,9 @@ enum ksz_regs {
 	P_SPEED_STATUS,
 	S_TAIL_TAG_CTRL,
 	P_STP_CTRL,
+	S_START_CTRL,
+	S_BROADCAST_CTRL,
+	S_MULTICAST_CTRL,
 };
 
 enum ksz_masks {
-- 
2.36.1

