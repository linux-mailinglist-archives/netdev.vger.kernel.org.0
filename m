Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70A9563660
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiGAPBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiGAPBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:01:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9553F24F28;
        Fri,  1 Jul 2022 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656687691; x=1688223691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XrVdSgF7L+yor5zvc9iVb53OIWV9KFn0hFs6z5pSf/I=;
  b=kOTC7Fw9jc+Qji6yLTLmXN6l9OLTqo+MIInmHH7WXGbSnQVSy+qvfaws
   IaRytEikZTzTe82VOOuuBpX+bW1pRjSys8eHUtJkF+dLe2JZuEx1nyQg0
   nZ8nNrfupZcAzzt5yESaAlQ0TeiVsYMvBKPkf0BXq4YtXzLfZVoONK+r9
   ISiBZ3yQqhUAvFsIGQKbsOgE7H4zLK0CG6HT9pxjqQuN16TY3fI9knl0G
   w9VOS6wuQyA3+JFDAJVLAK2U0gtSsSKxTlzBvl7np9hgyi12jBODGpNOG
   Orh/mEd/kpO5Oiza+fzIwbSlXE7uVUDiuZXfzd8EASCTKkQoD6sTrq9BC
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="166022701"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 08:01:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 08:01:29 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 08:01:08 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v15 04/13] net: dsa: microchip: generic access to ksz9477 static and reserved table
Date:   Fri, 1 Jul 2022 20:31:01 +0530
Message-ID: <20220701150101.23787-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701144652.10526-1-arun.ramadoss@microchip.com>
References: <20220701144652.10526-1-arun.ramadoss@microchip.com>
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

The ksz9477 and lan937x has few difference in the static and reserved
table register 0x041C. For the ksz9477 if the bit 0 is 1 - read
operation and 0 - write operation. But for lan937x bit 1:0 used for
selecting the read/write operation, 01 - write and 10 - read.
To use ksz9477 mdb add/del and enable_stp_addr for the lan937x, masks &
shifts are introduced for ksz9477 & lan937x in ksz_common.c. Then
updated the function with masks & shifts based on the switch instead of
hard coding it.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c     | 27 ++++++++++++++-----
 drivers/net/dsa/microchip/ksz9477_reg.h |  3 ---
 drivers/net/dsa/microchip/ksz_common.c  | 35 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  3 +++
 4 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 0e808d27124c..6453642fa14c 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -644,11 +644,16 @@ int ksz9477_mdb_add(struct ksz_device *dev, int port,
 		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
 {
 	u32 static_table[4];
+	const u8 *shifts;
+	const u32 *masks;
 	u32 data;
 	int index;
 	u32 mac_hi, mac_lo;
 	int err = 0;
 
+	shifts = dev->info->shifts;
+	masks = dev->info->masks;
+
 	mac_hi = ((mdb->addr[0] << 8) | mdb->addr[1]);
 	mac_lo = ((mdb->addr[2] << 24) | (mdb->addr[3] << 16));
 	mac_lo |= ((mdb->addr[4] << 8) | mdb->addr[5]);
@@ -657,8 +662,8 @@ int ksz9477_mdb_add(struct ksz_device *dev, int port,
 
 	for (index = 0; index < dev->info->num_statics; index++) {
 		/* find empty slot first */
-		data = (index << ALU_STAT_INDEX_S) |
-			ALU_STAT_READ | ALU_STAT_START;
+		data = (index << shifts[ALU_STAT_INDEX]) |
+			masks[ALU_STAT_READ] | ALU_STAT_START;
 		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 		/* wait to be finished */
@@ -702,7 +707,7 @@ int ksz9477_mdb_add(struct ksz_device *dev, int port,
 
 	ksz9477_write_table(dev, static_table);
 
-	data = (index << ALU_STAT_INDEX_S) | ALU_STAT_START;
+	data = (index << shifts[ALU_STAT_INDEX]) | ALU_STAT_START;
 	ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 	/* wait to be finished */
@@ -718,11 +723,16 @@ int ksz9477_mdb_del(struct ksz_device *dev, int port,
 		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db)
 {
 	u32 static_table[4];
+	const u8 *shifts;
+	const u32 *masks;
 	u32 data;
 	int index;
 	int ret = 0;
 	u32 mac_hi, mac_lo;
 
+	shifts = dev->info->shifts;
+	masks = dev->info->masks;
+
 	mac_hi = ((mdb->addr[0] << 8) | mdb->addr[1]);
 	mac_lo = ((mdb->addr[2] << 24) | (mdb->addr[3] << 16));
 	mac_lo |= ((mdb->addr[4] << 8) | mdb->addr[5]);
@@ -731,8 +741,8 @@ int ksz9477_mdb_del(struct ksz_device *dev, int port,
 
 	for (index = 0; index < dev->info->num_statics; index++) {
 		/* find empty slot first */
-		data = (index << ALU_STAT_INDEX_S) |
-			ALU_STAT_READ | ALU_STAT_START;
+		data = (index << shifts[ALU_STAT_INDEX]) |
+			masks[ALU_STAT_READ] | ALU_STAT_START;
 		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 		/* wait to be finished */
@@ -774,7 +784,7 @@ int ksz9477_mdb_del(struct ksz_device *dev, int port,
 
 	ksz9477_write_table(dev, static_table);
 
-	data = (index << ALU_STAT_INDEX_S) | ALU_STAT_START;
+	data = (index << shifts[ALU_STAT_INDEX]) | ALU_STAT_START;
 	ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 	/* wait to be finished */
@@ -1230,9 +1240,12 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
 
 int ksz9477_enable_stp_addr(struct ksz_device *dev)
 {
+	const u32 *masks;
 	u32 data;
 	int ret;
 
+	masks = dev->info->masks;
+
 	/* Enable Reserved multicast table */
 	ksz_cfg(dev, REG_SW_LUE_CTRL_0, SW_RESV_MCAST_ENABLE, true);
 
@@ -1242,7 +1255,7 @@ int ksz9477_enable_stp_addr(struct ksz_device *dev)
 	if (ret < 0)
 		return ret;
 
-	data = ALU_STAT_START | ALU_RESV_MCAST_ADDR;
+	data = ALU_STAT_START | ALU_RESV_MCAST_ADDR | masks[ALU_STAT_WRITE];
 
 	ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 	if (ret < 0)
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 2ba0f4449130..d0cce4ca3cf9 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -419,12 +419,9 @@
 
 #define REG_SW_ALU_STAT_CTRL__4		0x041C
 
-#define ALU_STAT_INDEX_M		(BIT(4) - 1)
-#define ALU_STAT_INDEX_S		16
 #define ALU_RESV_MCAST_INDEX_M		(BIT(6) - 1)
 #define ALU_STAT_START			BIT(7)
 #define ALU_RESV_MCAST_ADDR		BIT(1)
-#define ALU_STAT_READ			BIT(0)
 
 #define REG_SW_ALU_VAL_A		0x0420
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 29b42b3b39c9..d631a4bf35ed 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -314,7 +314,24 @@ static const u16 ksz9477_regs[] = {
 	[S_START_CTRL]			= 0x0300,
 	[S_BROADCAST_CTRL]		= 0x0332,
 	[S_MULTICAST_CTRL]		= 0x0331,
+};
+
+static const u32 ksz9477_masks[] = {
+	[ALU_STAT_WRITE]		= 0,
+	[ALU_STAT_READ]			= 1,
+};
+
+static const u8 ksz9477_shifts[] = {
+	[ALU_STAT_INDEX]		= 16,
+};
+
+static const u32 lan937x_masks[] = {
+	[ALU_STAT_WRITE]		= 1,
+	[ALU_STAT_READ]			= 2,
+};
 
+static const u8 lan937x_shifts[] = {
+	[ALU_STAT_INDEX]		= 8,
 };
 
 const struct ksz_chip_data ksz_switch_chips[] = {
@@ -432,6 +449,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = ksz9477_masks,
+		.shifts = ksz9477_shifts,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
 		.supports_rmii	= {false, false, false, false,
@@ -456,6 +475,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = ksz9477_masks,
+		.shifts = ksz9477_shifts,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -479,6 +500,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = ksz9477_masks,
+		.shifts = ksz9477_shifts,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
@@ -499,6 +522,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = ksz9477_masks,
+		.shifts = ksz9477_shifts,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -521,6 +546,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = lan937x_masks,
+		.shifts = lan937x_shifts,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -539,6 +566,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = lan937x_masks,
+		.shifts = lan937x_shifts,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
@@ -557,6 +586,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = lan937x_masks,
+		.shifts = lan937x_shifts,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -579,6 +610,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = lan937x_masks,
+		.shifts = lan937x_shifts,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -601,6 +634,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
 		.regs = ksz9477_regs,
+		.masks = lan937x_masks,
+		.shifts = lan937x_shifts,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index b61e569a9949..5f69dc872752 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -191,6 +191,8 @@ enum ksz_masks {
 	DYNAMIC_MAC_TABLE_FID,
 	DYNAMIC_MAC_TABLE_SRC_PORT,
 	DYNAMIC_MAC_TABLE_TIMESTAMP,
+	ALU_STAT_WRITE,
+	ALU_STAT_READ,
 };
 
 enum ksz_shifts {
@@ -203,6 +205,7 @@ enum ksz_shifts {
 	DYNAMIC_MAC_FID,
 	DYNAMIC_MAC_TIMESTAMP,
 	DYNAMIC_MAC_SRC_PORT,
+	ALU_STAT_INDEX,
 };
 
 struct alu_struct {
-- 
2.36.1

