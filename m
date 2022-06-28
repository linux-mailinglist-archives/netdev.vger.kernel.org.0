Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1707355EAB8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiF1ROO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiF1ROL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:14:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A2A2B196;
        Tue, 28 Jun 2022 10:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656436450; x=1687972450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NIPcuY+NNf8GaIfdmPmjmQBCBxQr8BX2SAgmu6yHNIE=;
  b=xRbGuvDqnB+OWDTd9lHBqlaiHpozBFyr2MYx31NnOoUjf2wuhE5/eRAM
   kC3OG+jq+KQ8cpgm7y+mpqvrJ1hroalIgmWQAGij46nNJftzNNufFWk83
   dnM+4FRaCUS9hb9+7kcz+hfc+BGp6WuyLuINSTezNX3mS7Eb3WettkANW
   QB2/mWtOoK6HPkmYS0UDH/0iZ4a4MswPhrZEO//DKosJXnpumxIuU9eJY
   I4ld/RGaTWf/XEv28aci3oL3lLm7Kpg7ROIC+dj1Ib5JKVjqxueU/HuDv
   iGq6aLBayAwhIp4BF4saeOYv70bAc9XVskIe/DomVyRZx8FWLOlQKSSXf
   A==;
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="102137950"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 10:14:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 10:14:09 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 10:13:57 -0700
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
Subject: [Patch net-next 1/7] net: dsa: microchip: move ksz8->regs to ksz_common
Date:   Tue, 28 Jun 2022 22:43:23 +0530
Message-ID: <20220628171329.25503-2-arun.ramadoss@microchip.com>
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

This patch moves the ksz8->regs from ksz8795.c to the ksz_common.c. And
the regs is dereferrenced using dev->info->regs.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8.h        | 18 ------
 drivers/net/dsa/microchip/ksz8795.c     | 76 ++++++++-----------------
 drivers/net/dsa/microchip/ksz9477_reg.h |  3 -
 drivers/net/dsa/microchip/ksz_common.c  | 37 ++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  | 18 ++++++
 5 files changed, 79 insertions(+), 73 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index de246989c81b..465b91496ea0 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -12,23 +12,6 @@
 #include <net/dsa.h>
 #include "ksz_common.h"
 
-enum ksz_regs {
-	REG_IND_CTRL_0,
-	REG_IND_DATA_8,
-	REG_IND_DATA_CHECK,
-	REG_IND_DATA_HI,
-	REG_IND_DATA_LO,
-	REG_IND_MIB_CHECK,
-	REG_IND_BYTE,
-	P_FORCE_CTRL,
-	P_LINK_STATUS,
-	P_LOCAL_CTRL,
-	P_NEG_RESTART_CTRL,
-	P_REMOTE_STATUS,
-	P_SPEED_STATUS,
-	S_TAIL_TAG_CTRL,
-};
-
 enum ksz_masks {
 	PORT_802_1P_REMAPPING,
 	SW_TAIL_TAG_ENABLE,
@@ -64,7 +47,6 @@ enum ksz_shifts {
 };
 
 struct ksz8 {
-	const u8 *regs;
 	const u32 *masks;
 	const u8 *shifts;
 	void *priv;
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index df7d782e3fcd..deac3a40381e 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -26,23 +26,6 @@
 #include "ksz8795_reg.h"
 #include "ksz8.h"
 
-static const u8 ksz8795_regs[] = {
-	[REG_IND_CTRL_0]		= 0x6E,
-	[REG_IND_DATA_8]		= 0x70,
-	[REG_IND_DATA_CHECK]		= 0x72,
-	[REG_IND_DATA_HI]		= 0x71,
-	[REG_IND_DATA_LO]		= 0x75,
-	[REG_IND_MIB_CHECK]		= 0x74,
-	[REG_IND_BYTE]			= 0xA0,
-	[P_FORCE_CTRL]			= 0x0C,
-	[P_LINK_STATUS]			= 0x0E,
-	[P_LOCAL_CTRL]			= 0x07,
-	[P_NEG_RESTART_CTRL]		= 0x0D,
-	[P_REMOTE_STATUS]		= 0x08,
-	[P_SPEED_STATUS]		= 0x09,
-	[S_TAIL_TAG_CTRL]		= 0x0C,
-};
-
 static const u32 ksz8795_masks[] = {
 	[PORT_802_1P_REMAPPING]		= BIT(7),
 	[SW_TAIL_TAG_ENABLE]		= BIT(1),
@@ -77,22 +60,6 @@ static const u8 ksz8795_shifts[] = {
 	[DYNAMIC_MAC_SRC_PORT]		= 24,
 };
 
-static const u8 ksz8863_regs[] = {
-	[REG_IND_CTRL_0]		= 0x79,
-	[REG_IND_DATA_8]		= 0x7B,
-	[REG_IND_DATA_CHECK]		= 0x7B,
-	[REG_IND_DATA_HI]		= 0x7C,
-	[REG_IND_DATA_LO]		= 0x80,
-	[REG_IND_MIB_CHECK]		= 0x80,
-	[P_FORCE_CTRL]			= 0x0C,
-	[P_LINK_STATUS]			= 0x0E,
-	[P_LOCAL_CTRL]			= 0x0C,
-	[P_NEG_RESTART_CTRL]		= 0x0D,
-	[P_REMOTE_STATUS]		= 0x0E,
-	[P_SPEED_STATUS]		= 0x0F,
-	[S_TAIL_TAG_CTRL]		= 0x03,
-};
-
 static const u32 ksz8863_masks[] = {
 	[PORT_802_1P_REMAPPING]		= BIT(3),
 	[SW_TAIL_TAG_ENABLE]		= BIT(6),
@@ -145,11 +112,12 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 
 static int ksz8_ind_write8(struct ksz_device *dev, u8 table, u16 addr, u8 data)
 {
-	struct ksz8 *ksz8 = dev->priv;
-	const u8 *regs = ksz8->regs;
+	const u8 *regs;
 	u16 ctrl_addr;
 	int ret = 0;
 
+	regs = dev->info->regs;
+
 	mutex_lock(&dev->alu_mutex);
 
 	ctrl_addr = IND_ACC_TABLE(table) | addr;
@@ -224,7 +192,7 @@ void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	int loop;
 
 	masks = ksz8->masks;
-	regs = ksz8->regs;
+	regs = dev->info->regs;
 
 	ctrl_addr = addr + dev->info->reg_mib_cnt * port;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
@@ -261,7 +229,7 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	int loop;
 
 	masks = ksz8->masks;
-	regs = ksz8->regs;
+	regs = dev->info->regs;
 
 	addr -= dev->info->reg_mib_cnt;
 	ctrl_addr = (KSZ8795_MIB_TOTAL_RX_1 - KSZ8795_MIB_TOTAL_RX_0) * port;
@@ -305,13 +273,14 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			      u64 *dropped, u64 *cnt)
 {
-	struct ksz8 *ksz8 = dev->priv;
-	const u8 *regs = ksz8->regs;
 	u32 *last = (u32 *)dropped;
+	const u8 *regs;
 	u16 ctrl_addr;
 	u32 data;
 	u32 cur;
 
+	regs = dev->info->regs;
+
 	addr -= dev->info->reg_mib_cnt;
 	ctrl_addr = addr ? KSZ8863_MIB_PACKET_DROPPED_TX_0 :
 			   KSZ8863_MIB_PACKET_DROPPED_RX_0;
@@ -392,10 +361,11 @@ void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 {
-	struct ksz8 *ksz8 = dev->priv;
-	const u8 *regs = ksz8->regs;
+	const u8 *regs;
 	u16 ctrl_addr;
 
+	regs = dev->info->regs;
+
 	ctrl_addr = IND_ACC_TABLE(table | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
@@ -406,10 +376,11 @@ static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 
 static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
 {
-	struct ksz8 *ksz8 = dev->priv;
-	const u8 *regs = ksz8->regs;
+	const u8 *regs;
 	u16 ctrl_addr;
 
+	regs = dev->info->regs;
+
 	ctrl_addr = IND_ACC_TABLE(table) | addr;
 
 	mutex_lock(&dev->alu_mutex);
@@ -426,7 +397,7 @@ static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 	const u8 *regs;
 
 	masks = ksz8->masks;
-	regs = ksz8->regs;
+	regs = dev->info->regs;
 
 	do {
 		ksz_read8(dev, regs[REG_IND_DATA_CHECK], data);
@@ -461,7 +432,7 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 
 	shifts = ksz8->shifts;
 	masks = ksz8->masks;
-	regs = ksz8->regs;
+	regs = dev->info->regs;
 
 	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
 
@@ -664,14 +635,15 @@ static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 
 void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	u8 restart, speed, ctrl, link;
-	const u8 *regs = ksz8->regs;
 	int processed = true;
+	const u8 *regs;
 	u8 val1, val2;
 	u16 data = 0;
 	u8 p = phy;
 
+	regs = dev->info->regs;
+
 	switch (reg) {
 	case MII_BMCR:
 		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
@@ -787,11 +759,12 @@ void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 
 void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	u8 restart, speed, ctrl, data;
-	const u8 *regs = ksz8->regs;
+	const u8 *regs;
 	u8 p = phy;
 
+	regs = dev->info->regs;
+
 	switch (reg) {
 	case MII_BMCR:
 
@@ -1302,13 +1275,14 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz8 *ksz8 = dev->priv;
-	const u8 *regs = ksz8->regs;
 	struct ksz_port *p;
 	const u32 *masks;
+	const u8 *regs;
 	u8 remote;
 	int i;
 
 	masks = ksz8->masks;
+	regs = dev->info->regs;
 
 	/* Switch marks the maximum frame with extra byte as oversize. */
 	ksz_cfg(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, true);
@@ -1448,11 +1422,9 @@ int ksz8_switch_init(struct ksz_device *dev)
 	dev->port_mask = (BIT(dev->phy_port_cnt) - 1) | dev->info->cpu_ports;
 
 	if (ksz_is_ksz88x3(dev)) {
-		ksz8->regs = ksz8863_regs;
 		ksz8->masks = ksz8863_masks;
 		ksz8->shifts = ksz8863_shifts;
 	} else {
-		ksz8->regs = ksz8795_regs;
 		ksz8->masks = ksz8795_masks;
 		ksz8->shifts = ksz8795_shifts;
 	}
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index c0ad83753b13..2cbbfda22c67 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1624,9 +1624,6 @@
 #define P_MIRROR_CTRL			REG_PORT_MRI_MIRROR_CTRL
 #define P_STP_CTRL			REG_PORT_LUE_MSTP_STATE
 #define P_PHY_CTRL			REG_PORT_PHY_CTRL
-#define P_NEG_RESTART_CTRL		REG_PORT_PHY_CTRL
-#define P_LINK_STATUS			REG_PORT_PHY_STATUS
-#define P_SPEED_STATUS			REG_PORT_PHY_PHY_CTRL
 #define P_RATE_LIMIT_CTRL		REG_PORT_MAC_IN_RATE_LIMIT
 
 #define S_LINK_AGING_CTRL		REG_SW_LUE_CTRL_1
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 59582eb3bcaf..acaa0e96f5ff 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -201,6 +201,39 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.exit = ksz9477_switch_exit,
 };
 
+static const u8 ksz8795_regs[] = {
+	[REG_IND_CTRL_0]		= 0x6E,
+	[REG_IND_DATA_8]		= 0x70,
+	[REG_IND_DATA_CHECK]		= 0x72,
+	[REG_IND_DATA_HI]		= 0x71,
+	[REG_IND_DATA_LO]		= 0x75,
+	[REG_IND_MIB_CHECK]		= 0x74,
+	[REG_IND_BYTE]			= 0xA0,
+	[P_FORCE_CTRL]			= 0x0C,
+	[P_LINK_STATUS]			= 0x0E,
+	[P_LOCAL_CTRL]			= 0x07,
+	[P_NEG_RESTART_CTRL]		= 0x0D,
+	[P_REMOTE_STATUS]		= 0x08,
+	[P_SPEED_STATUS]		= 0x09,
+	[S_TAIL_TAG_CTRL]		= 0x0C,
+};
+
+static const u8 ksz8863_regs[] = {
+	[REG_IND_CTRL_0]		= 0x79,
+	[REG_IND_DATA_8]		= 0x7B,
+	[REG_IND_DATA_CHECK]		= 0x7B,
+	[REG_IND_DATA_HI]		= 0x7C,
+	[REG_IND_DATA_LO]		= 0x80,
+	[REG_IND_MIB_CHECK]		= 0x80,
+	[P_FORCE_CTRL]			= 0x0C,
+	[P_LINK_STATUS]			= 0x0E,
+	[P_LOCAL_CTRL]			= 0x0C,
+	[P_NEG_RESTART_CTRL]		= 0x0D,
+	[P_REMOTE_STATUS]		= 0x0E,
+	[P_SPEED_STATUS]		= 0x0F,
+	[S_TAIL_TAG_CTRL]		= 0x03,
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8795] = {
 		.chip_id = KSZ8795_CHIP_ID,
@@ -215,6 +248,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.regs = ksz8795_regs,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -252,6 +286,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.regs = ksz8795_regs,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -275,6 +310,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.regs = ksz8795_regs,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -297,6 +333,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz88xx_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.regs = ksz8863_regs,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0e7f15efbb79..d3cd29ef7885 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -47,6 +47,7 @@ struct ksz_chip_data {
 	const struct ksz_mib_names *mib_names;
 	int mib_cnt;
 	u8 reg_mib_cnt;
+	const u8 *regs;
 	int stp_ctrl_reg;
 	int broadcast_ctrl_reg;
 	int multicast_ctrl_reg;
@@ -146,6 +147,23 @@ enum ksz_chip_id {
 	LAN9374_CHIP_ID = 0x00937400,
 };
 
+enum ksz_regs {
+	REG_IND_CTRL_0,
+	REG_IND_DATA_8,
+	REG_IND_DATA_CHECK,
+	REG_IND_DATA_HI,
+	REG_IND_DATA_LO,
+	REG_IND_MIB_CHECK,
+	REG_IND_BYTE,
+	P_FORCE_CTRL,
+	P_LINK_STATUS,
+	P_LOCAL_CTRL,
+	P_NEG_RESTART_CTRL,
+	P_REMOTE_STATUS,
+	P_SPEED_STATUS,
+	S_TAIL_TAG_CTRL,
+};
+
 struct alu_struct {
 	/* entry 1 */
 	u8	is_static:1;
-- 
2.36.1

