Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267E455EABB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiF1ROa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiF1ROa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:14:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD61E2B196;
        Tue, 28 Jun 2022 10:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656436468; x=1687972468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6lVXwkW1jzzRilI6/9b+EBfwv5lxJ8J+J0kSzXW729w=;
  b=XTXyMYeY50PGrOaj4EGNgJZzH04XVYc6ofvYmAGBLHsLODlJvNQ6hii/
   l1+ugIWkW55bq942kZPPUB/1+IAknL7UIg9F8JTvAnsIhHc/oSIcC3ydN
   /Th+zvGeVQdCeQc0WRy554I0D08MPOIteh954yRauNC9Fg1omktxD6scM
   j80fgnglOk4Jy2af8ucX1ts7x2cfX1xyrO2elbcSxY4fAfmsS0aeZukbz
   R1lap7zqOkvj8FZqOtuOBq9AGfFRWW/r5L1T8LgmzRb0POgHEqWrlaaBv
   39eCYOyrfU+2YHkunSaKfjBmTgOHvbEDNUanK5fzuif++2fQvUdCvMVYf
   w==;
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="179885868"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 10:14:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 10:14:22 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 10:14:12 -0700
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
Subject: [Patch net-next 2/7] net: dsa: microchip: move ksz8->masks to ksz_common
Date:   Tue, 28 Jun 2022 22:43:24 +0530
Message-ID: <20220628171329.25503-3-arun.ramadoss@microchip.com>
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

This patch moves the ksz8->masks from ksz8795.c to ksz_common.c. The
mask will be dereferenced using dev->info->masks.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8.h        | 23 --------
 drivers/net/dsa/microchip/ksz8795.c     | 71 ++++---------------------
 drivers/net/dsa/microchip/ksz9477_reg.h |  2 -
 drivers/net/dsa/microchip/ksz_common.c  | 48 +++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  | 23 ++++++++
 5 files changed, 81 insertions(+), 86 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 465b91496ea0..22a047761aa5 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -12,28 +12,6 @@
 #include <net/dsa.h>
 #include "ksz_common.h"
 
-enum ksz_masks {
-	PORT_802_1P_REMAPPING,
-	SW_TAIL_TAG_ENABLE,
-	MIB_COUNTER_OVERFLOW,
-	MIB_COUNTER_VALID,
-	VLAN_TABLE_FID,
-	VLAN_TABLE_MEMBERSHIP,
-	VLAN_TABLE_VALID,
-	STATIC_MAC_TABLE_VALID,
-	STATIC_MAC_TABLE_USE_FID,
-	STATIC_MAC_TABLE_FID,
-	STATIC_MAC_TABLE_OVERRIDE,
-	STATIC_MAC_TABLE_FWD_PORTS,
-	DYNAMIC_MAC_TABLE_ENTRIES_H,
-	DYNAMIC_MAC_TABLE_MAC_EMPTY,
-	DYNAMIC_MAC_TABLE_NOT_READY,
-	DYNAMIC_MAC_TABLE_ENTRIES,
-	DYNAMIC_MAC_TABLE_FID,
-	DYNAMIC_MAC_TABLE_SRC_PORT,
-	DYNAMIC_MAC_TABLE_TIMESTAMP,
-};
-
 enum ksz_shifts {
 	VLAN_TABLE_MEMBERSHIP_S,
 	VLAN_TABLE,
@@ -47,7 +25,6 @@ enum ksz_shifts {
 };
 
 struct ksz8 {
-	const u32 *masks;
 	const u8 *shifts;
 	void *priv;
 };
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index deac3a40381e..0c72ec50c04d 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -26,28 +26,6 @@
 #include "ksz8795_reg.h"
 #include "ksz8.h"
 
-static const u32 ksz8795_masks[] = {
-	[PORT_802_1P_REMAPPING]		= BIT(7),
-	[SW_TAIL_TAG_ENABLE]		= BIT(1),
-	[MIB_COUNTER_OVERFLOW]		= BIT(6),
-	[MIB_COUNTER_VALID]		= BIT(5),
-	[VLAN_TABLE_FID]		= GENMASK(6, 0),
-	[VLAN_TABLE_MEMBERSHIP]		= GENMASK(11, 7),
-	[VLAN_TABLE_VALID]		= BIT(12),
-	[STATIC_MAC_TABLE_VALID]	= BIT(21),
-	[STATIC_MAC_TABLE_USE_FID]	= BIT(23),
-	[STATIC_MAC_TABLE_FID]		= GENMASK(30, 24),
-	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(26),
-	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(24, 20),
-	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(6, 0),
-	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(8),
-	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
-	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 29),
-	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
-	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
-	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
-};
-
 static const u8 ksz8795_shifts[] = {
 	[VLAN_TABLE_MEMBERSHIP_S]	= 7,
 	[VLAN_TABLE]			= 16,
@@ -60,28 +38,6 @@ static const u8 ksz8795_shifts[] = {
 	[DYNAMIC_MAC_SRC_PORT]		= 24,
 };
 
-static const u32 ksz8863_masks[] = {
-	[PORT_802_1P_REMAPPING]		= BIT(3),
-	[SW_TAIL_TAG_ENABLE]		= BIT(6),
-	[MIB_COUNTER_OVERFLOW]		= BIT(7),
-	[MIB_COUNTER_VALID]		= BIT(6),
-	[VLAN_TABLE_FID]		= GENMASK(15, 12),
-	[VLAN_TABLE_MEMBERSHIP]		= GENMASK(18, 16),
-	[VLAN_TABLE_VALID]		= BIT(19),
-	[STATIC_MAC_TABLE_VALID]	= BIT(19),
-	[STATIC_MAC_TABLE_USE_FID]	= BIT(21),
-	[STATIC_MAC_TABLE_FID]		= GENMASK(29, 26),
-	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
-	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
-	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(5, 0),
-	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(7),
-	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
-	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 28),
-	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(19, 16),
-	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(21, 20),
-	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(23, 22),
-};
-
 static u8 ksz8863_shifts[] = {
 	[VLAN_TABLE_MEMBERSHIP_S]	= 16,
 	[STATIC_MAC_FWD_PORTS]		= 16,
@@ -183,7 +139,6 @@ static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 
 void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	const u32 *masks;
 	const u8 *regs;
 	u16 ctrl_addr;
@@ -191,7 +146,7 @@ void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	u8 check;
 	int loop;
 
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 	regs = dev->info->regs;
 
 	ctrl_addr = addr + dev->info->reg_mib_cnt * port;
@@ -220,7 +175,6 @@ void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			      u64 *dropped, u64 *cnt)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	const u32 *masks;
 	const u8 *regs;
 	u16 ctrl_addr;
@@ -228,7 +182,7 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	u8 check;
 	int loop;
 
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 	regs = dev->info->regs;
 
 	addr -= dev->info->reg_mib_cnt;
@@ -391,12 +345,11 @@ static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
 
 static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	int timeout = 100;
 	const u32 *masks;
 	const u8 *regs;
 
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 	regs = dev->info->regs;
 
 	do {
@@ -431,7 +384,7 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 	int rc;
 
 	shifts = ksz8->shifts;
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 	regs = dev->info->regs;
 
 	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
@@ -492,7 +445,7 @@ int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 	u64 data;
 
 	shifts = ksz8->shifts;
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 
 	ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
 	data_hi = data >> 32;
@@ -531,7 +484,7 @@ void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 	u64 data;
 
 	shifts = ksz8->shifts;
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 
 	data_lo = ((u32)alu->mac[2] << 24) |
 		((u32)alu->mac[3] << 16) |
@@ -562,7 +515,7 @@ static void ksz8_from_vlan(struct ksz_device *dev, u32 vlan, u8 *fid,
 	const u32 *masks;
 
 	shifts = ksz8->shifts;
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 
 	*fid = vlan & masks[VLAN_TABLE_FID];
 	*member = (vlan & masks[VLAN_TABLE_MEMBERSHIP]) >>
@@ -578,7 +531,7 @@ static void ksz8_to_vlan(struct ksz_device *dev, u8 fid, u8 member, u8 valid,
 	const u32 *masks;
 
 	shifts = ksz8->shifts;
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 
 	*vlan = fid;
 	*vlan |= (u16)member << shifts[VLAN_TABLE_MEMBERSHIP_S];
@@ -1237,11 +1190,10 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct dsa_switch *ds = dev->ds;
-	struct ksz8 *ksz8 = dev->priv;
 	const u32 *masks;
 	u8 member;
 
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 
 	/* enable broadcast storm limit */
 	ksz_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
@@ -1274,14 +1226,13 @@ void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 void ksz8_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-	struct ksz8 *ksz8 = dev->priv;
 	struct ksz_port *p;
 	const u32 *masks;
 	const u8 *regs;
 	u8 remote;
 	int i;
 
-	masks = ksz8->masks;
+	masks = dev->info->masks;
 	regs = dev->info->regs;
 
 	/* Switch marks the maximum frame with extra byte as oversize. */
@@ -1422,10 +1373,8 @@ int ksz8_switch_init(struct ksz_device *dev)
 	dev->port_mask = (BIT(dev->phy_port_cnt) - 1) | dev->info->cpu_ports;
 
 	if (ksz_is_ksz88x3(dev)) {
-		ksz8->masks = ksz8863_masks;
 		ksz8->shifts = ksz8863_shifts;
 	} else {
-		ksz8->masks = ksz8795_masks;
 		ksz8->shifts = ksz8795_shifts;
 	}
 
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 2cbbfda22c67..6be2efe6334a 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1262,8 +1262,6 @@
 /* 5 - MIB Counters */
 #define REG_PORT_MIB_CTRL_STAT__4	0x0500
 
-#define MIB_COUNTER_OVERFLOW		BIT(31)
-#define MIB_COUNTER_VALID		BIT(30)
 #define MIB_COUNTER_READ		BIT(25)
 #define MIB_COUNTER_FLUSH_FREEZE	BIT(24)
 #define MIB_COUNTER_INDEX_M		(BIT(8) - 1)
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index acaa0e96f5ff..fc1ef0e50bff 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -218,6 +218,28 @@ static const u8 ksz8795_regs[] = {
 	[S_TAIL_TAG_CTRL]		= 0x0C,
 };
 
+static const u32 ksz8795_masks[] = {
+	[PORT_802_1P_REMAPPING]		= BIT(7),
+	[SW_TAIL_TAG_ENABLE]		= BIT(1),
+	[MIB_COUNTER_OVERFLOW]		= BIT(6),
+	[MIB_COUNTER_VALID]		= BIT(5),
+	[VLAN_TABLE_FID]		= GENMASK(6, 0),
+	[VLAN_TABLE_MEMBERSHIP]		= GENMASK(11, 7),
+	[VLAN_TABLE_VALID]		= BIT(12),
+	[STATIC_MAC_TABLE_VALID]	= BIT(21),
+	[STATIC_MAC_TABLE_USE_FID]	= BIT(23),
+	[STATIC_MAC_TABLE_FID]		= GENMASK(30, 24),
+	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(26),
+	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(24, 20),
+	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(6, 0),
+	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(8),
+	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
+	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 29),
+	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
+	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
+	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
+};
+
 static const u8 ksz8863_regs[] = {
 	[REG_IND_CTRL_0]		= 0x79,
 	[REG_IND_DATA_8]		= 0x7B,
@@ -234,6 +256,28 @@ static const u8 ksz8863_regs[] = {
 	[S_TAIL_TAG_CTRL]		= 0x03,
 };
 
+static const u32 ksz8863_masks[] = {
+	[PORT_802_1P_REMAPPING]		= BIT(3),
+	[SW_TAIL_TAG_ENABLE]		= BIT(6),
+	[MIB_COUNTER_OVERFLOW]		= BIT(7),
+	[MIB_COUNTER_VALID]		= BIT(6),
+	[VLAN_TABLE_FID]		= GENMASK(15, 12),
+	[VLAN_TABLE_MEMBERSHIP]		= GENMASK(18, 16),
+	[VLAN_TABLE_VALID]		= BIT(19),
+	[STATIC_MAC_TABLE_VALID]	= BIT(19),
+	[STATIC_MAC_TABLE_USE_FID]	= BIT(21),
+	[STATIC_MAC_TABLE_FID]		= GENMASK(29, 26),
+	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
+	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
+	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(5, 0),
+	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(7),
+	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
+	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 28),
+	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(19, 16),
+	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(21, 20),
+	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(23, 22),
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8795] = {
 		.chip_id = KSZ8795_CHIP_ID,
@@ -249,6 +293,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz8795_regs,
+		.masks = ksz8795_masks,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -287,6 +332,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz8795_regs,
+		.masks = ksz8795_masks,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -311,6 +357,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz8795_regs,
+		.masks = ksz8795_masks,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -334,6 +381,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz8863_regs,
+		.masks = ksz8863_masks,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d3cd29ef7885..b1e4732357a1 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -48,6 +48,7 @@ struct ksz_chip_data {
 	int mib_cnt;
 	u8 reg_mib_cnt;
 	const u8 *regs;
+	const u32 *masks;
 	int stp_ctrl_reg;
 	int broadcast_ctrl_reg;
 	int multicast_ctrl_reg;
@@ -164,6 +165,28 @@ enum ksz_regs {
 	S_TAIL_TAG_CTRL,
 };
 
+enum ksz_masks {
+	PORT_802_1P_REMAPPING,
+	SW_TAIL_TAG_ENABLE,
+	MIB_COUNTER_OVERFLOW,
+	MIB_COUNTER_VALID,
+	VLAN_TABLE_FID,
+	VLAN_TABLE_MEMBERSHIP,
+	VLAN_TABLE_VALID,
+	STATIC_MAC_TABLE_VALID,
+	STATIC_MAC_TABLE_USE_FID,
+	STATIC_MAC_TABLE_FID,
+	STATIC_MAC_TABLE_OVERRIDE,
+	STATIC_MAC_TABLE_FWD_PORTS,
+	DYNAMIC_MAC_TABLE_ENTRIES_H,
+	DYNAMIC_MAC_TABLE_MAC_EMPTY,
+	DYNAMIC_MAC_TABLE_NOT_READY,
+	DYNAMIC_MAC_TABLE_ENTRIES,
+	DYNAMIC_MAC_TABLE_FID,
+	DYNAMIC_MAC_TABLE_SRC_PORT,
+	DYNAMIC_MAC_TABLE_TIMESTAMP,
+};
+
 struct alu_struct {
 	/* entry 1 */
 	u8	is_static:1;
-- 
2.36.1

