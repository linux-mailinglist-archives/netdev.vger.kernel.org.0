Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C463355EAC9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiF1ROr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiF1ROk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:14:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94B52CCA0;
        Tue, 28 Jun 2022 10:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656436480; x=1687972480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4aUB8XdEZI44hkwWiLzjnR4eIChSP8Np2Da2KuqwoQs=;
  b=xDcJ9HlJSG4KI9L0bJJnBpWiFTp+4EyBmNYVSrwGmPmI68pd08MMpK92
   NhrjL/ojAzAjyYO8xiIFlWyvjf4cY0kRnotk1yIzOgRjr+r5OTFfs8Wac
   SEKSdFGQfeTMoqHBqf6m5a/qu35Ny1nnnFlsKfUb+sZeW1kbDobtx8Ocs
   SSNf0cgcCCRb7TUo4ESBmkjdVCLGppJ+/7Ed/rMB2jLwp5ngnhQFIOOo6
   1W/OQnq1lYQn3GShwq94+//XH4WeqDP0t5DN4U6QsBg/7COFDUOFJ+dxB
   q7kDI782TZV9W5MR8xQN0FT4Q4w2MSwW15VbhnGBlzsGomffeHNwavSzn
   A==;
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="169967896"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 10:14:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 10:14:36 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 10:14:25 -0700
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
Subject: [Patch net-next 3/7] net: dsa: microchip: move ksz8->shifts to ksz_common
Date:   Tue, 28 Jun 2022 22:43:25 +0530
Message-ID: <20220628171329.25503-4-arun.ramadoss@microchip.com>
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

This patch moves ksz8->shifts from ksz8795.c to ksz_common.c. The shifts
are dereferenced using dev->info->shifts.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8.h       | 13 -------
 drivers/net/dsa/microchip/ksz8795.c    | 49 ++++----------------------
 drivers/net/dsa/microchip/ksz_common.c | 27 ++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h | 13 +++++++
 4 files changed, 46 insertions(+), 56 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 22a047761aa5..a4a2dc889b30 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -12,20 +12,7 @@
 #include <net/dsa.h>
 #include "ksz_common.h"
 
-enum ksz_shifts {
-	VLAN_TABLE_MEMBERSHIP_S,
-	VLAN_TABLE,
-	STATIC_MAC_FWD_PORTS,
-	STATIC_MAC_FID,
-	DYNAMIC_MAC_ENTRIES_H,
-	DYNAMIC_MAC_ENTRIES,
-	DYNAMIC_MAC_FID,
-	DYNAMIC_MAC_TIMESTAMP,
-	DYNAMIC_MAC_SRC_PORT,
-};
-
 struct ksz8 {
-	const u8 *shifts;
 	void *priv;
 };
 
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 0c72ec50c04d..2b3db33c32ce 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -26,29 +26,6 @@
 #include "ksz8795_reg.h"
 #include "ksz8.h"
 
-static const u8 ksz8795_shifts[] = {
-	[VLAN_TABLE_MEMBERSHIP_S]	= 7,
-	[VLAN_TABLE]			= 16,
-	[STATIC_MAC_FWD_PORTS]		= 16,
-	[STATIC_MAC_FID]		= 24,
-	[DYNAMIC_MAC_ENTRIES_H]		= 3,
-	[DYNAMIC_MAC_ENTRIES]		= 29,
-	[DYNAMIC_MAC_FID]		= 16,
-	[DYNAMIC_MAC_TIMESTAMP]		= 27,
-	[DYNAMIC_MAC_SRC_PORT]		= 24,
-};
-
-static u8 ksz8863_shifts[] = {
-	[VLAN_TABLE_MEMBERSHIP_S]	= 16,
-	[STATIC_MAC_FWD_PORTS]		= 16,
-	[STATIC_MAC_FID]		= 22,
-	[DYNAMIC_MAC_ENTRIES_H]		= 3,
-	[DYNAMIC_MAC_ENTRIES]		= 24,
-	[DYNAMIC_MAC_FID]		= 16,
-	[DYNAMIC_MAC_TIMESTAMP]		= 24,
-	[DYNAMIC_MAC_SRC_PORT]		= 20,
-};
-
 static bool ksz_is_ksz88x3(struct ksz_device *dev)
 {
 	return dev->chip_id == 0x8830;
@@ -374,7 +351,6 @@ static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 			 u8 *fid, u8 *src_port, u8 *timestamp, u16 *entries)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	u32 data_hi, data_lo;
 	const u8 *shifts;
 	const u32 *masks;
@@ -383,7 +359,7 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 	u8 data;
 	int rc;
 
-	shifts = ksz8->shifts;
+	shifts = dev->info->shifts;
 	masks = dev->info->masks;
 	regs = dev->info->regs;
 
@@ -438,13 +414,12 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 			 struct alu_struct *alu)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	u32 data_hi, data_lo;
 	const u8 *shifts;
 	const u32 *masks;
 	u64 data;
 
-	shifts = ksz8->shifts;
+	shifts = dev->info->shifts;
 	masks = dev->info->masks;
 
 	ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
@@ -477,13 +452,12 @@ int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
 void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 			  struct alu_struct *alu)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	u32 data_hi, data_lo;
 	const u8 *shifts;
 	const u32 *masks;
 	u64 data;
 
-	shifts = ksz8->shifts;
+	shifts = dev->info->shifts;
 	masks = dev->info->masks;
 
 	data_lo = ((u32)alu->mac[2] << 24) |
@@ -510,11 +484,10 @@ void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 static void ksz8_from_vlan(struct ksz_device *dev, u32 vlan, u8 *fid,
 			   u8 *member, u8 *valid)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	const u8 *shifts;
 	const u32 *masks;
 
-	shifts = ksz8->shifts;
+	shifts = dev->info->shifts;
 	masks = dev->info->masks;
 
 	*fid = vlan & masks[VLAN_TABLE_FID];
@@ -526,11 +499,10 @@ static void ksz8_from_vlan(struct ksz_device *dev, u32 vlan, u8 *fid,
 static void ksz8_to_vlan(struct ksz_device *dev, u8 fid, u8 member, u8 valid,
 			 u16 *vlan)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	const u8 *shifts;
 	const u32 *masks;
 
-	shifts = ksz8->shifts;
+	shifts = dev->info->shifts;
 	masks = dev->info->masks;
 
 	*vlan = fid;
@@ -541,12 +513,11 @@ static void ksz8_to_vlan(struct ksz_device *dev, u8 fid, u8 member, u8 valid,
 
 static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 {
-	struct ksz8 *ksz8 = dev->priv;
 	const u8 *shifts;
 	u64 data;
 	int i;
 
-	shifts = ksz8->shifts;
+	shifts = dev->info->shifts;
 
 	ksz8_r_table(dev, TABLE_VLAN, addr, &data);
 	addr *= 4;
@@ -1366,18 +1337,10 @@ u32 ksz8_get_port_addr(int port, int offset)
 
 int ksz8_switch_init(struct ksz_device *dev)
 {
-	struct ksz8 *ksz8 = dev->priv;
-
 	dev->cpu_port = fls(dev->info->cpu_ports) - 1;
 	dev->phy_port_cnt = dev->info->port_cnt - 1;
 	dev->port_mask = (BIT(dev->phy_port_cnt) - 1) | dev->info->cpu_ports;
 
-	if (ksz_is_ksz88x3(dev)) {
-		ksz8->shifts = ksz8863_shifts;
-	} else {
-		ksz8->shifts = ksz8795_shifts;
-	}
-
 	/* We rely on software untagging on the CPU port, so that we
 	 * can support both tagged and untagged VLANs
 	 */
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fc1ef0e50bff..fa66bd14f66a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -240,6 +240,18 @@ static const u32 ksz8795_masks[] = {
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
 };
 
+static const u8 ksz8795_shifts[] = {
+	[VLAN_TABLE_MEMBERSHIP_S]	= 7,
+	[VLAN_TABLE]			= 16,
+	[STATIC_MAC_FWD_PORTS]		= 16,
+	[STATIC_MAC_FID]		= 24,
+	[DYNAMIC_MAC_ENTRIES_H]		= 3,
+	[DYNAMIC_MAC_ENTRIES]		= 29,
+	[DYNAMIC_MAC_FID]		= 16,
+	[DYNAMIC_MAC_TIMESTAMP]		= 27,
+	[DYNAMIC_MAC_SRC_PORT]		= 24,
+};
+
 static const u8 ksz8863_regs[] = {
 	[REG_IND_CTRL_0]		= 0x79,
 	[REG_IND_DATA_8]		= 0x7B,
@@ -278,6 +290,17 @@ static const u32 ksz8863_masks[] = {
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(23, 22),
 };
 
+static u8 ksz8863_shifts[] = {
+	[VLAN_TABLE_MEMBERSHIP_S]	= 16,
+	[STATIC_MAC_FWD_PORTS]		= 16,
+	[STATIC_MAC_FID]		= 22,
+	[DYNAMIC_MAC_ENTRIES_H]		= 3,
+	[DYNAMIC_MAC_ENTRIES]		= 24,
+	[DYNAMIC_MAC_FID]		= 16,
+	[DYNAMIC_MAC_TIMESTAMP]		= 24,
+	[DYNAMIC_MAC_SRC_PORT]		= 20,
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8795] = {
 		.chip_id = KSZ8795_CHIP_ID,
@@ -294,6 +317,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
+		.shifts = ksz8795_shifts,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -333,6 +357,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
+		.shifts = ksz8795_shifts,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -358,6 +383,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
+		.shifts = ksz8795_shifts,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
@@ -382,6 +408,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz8863_regs,
 		.masks = ksz8863_masks,
+		.shifts = ksz8863_shifts,
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index b1e4732357a1..c11adf67757d 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -49,6 +49,7 @@ struct ksz_chip_data {
 	u8 reg_mib_cnt;
 	const u8 *regs;
 	const u32 *masks;
+	const u8 *shifts;
 	int stp_ctrl_reg;
 	int broadcast_ctrl_reg;
 	int multicast_ctrl_reg;
@@ -187,6 +188,18 @@ enum ksz_masks {
 	DYNAMIC_MAC_TABLE_TIMESTAMP,
 };
 
+enum ksz_shifts {
+	VLAN_TABLE_MEMBERSHIP_S,
+	VLAN_TABLE,
+	STATIC_MAC_FWD_PORTS,
+	STATIC_MAC_FID,
+	DYNAMIC_MAC_ENTRIES_H,
+	DYNAMIC_MAC_ENTRIES,
+	DYNAMIC_MAC_FID,
+	DYNAMIC_MAC_TIMESTAMP,
+	DYNAMIC_MAC_SRC_PORT,
+};
+
 struct alu_struct {
 	/* entry 1 */
 	u8	is_static:1;
-- 
2.36.1

