Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022B45230CA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbiEKKjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbiEKKjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:39:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C144980AD;
        Wed, 11 May 2022 03:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652265538; x=1683801538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ByAro7yTrMCyf7KbrY6Jjd3Vt9QJ8tPXpMaBiP1tPZE=;
  b=tQnWzLahGR+arapyhcohjbnpTONUtQ4FqOOxigHxaP2ES7KcWPeCaAPe
   iBtfEPKPdo66N+FizVF+fUn2eDAz8wttB2170cJWBbmTiRI6rRD0C646t
   xmgWJt5fVIvVSbbExIFTy9IznmhswO10veuuYzaGgXdr1hVI2wLCK/vhB
   T/omOTPwDsfsqy5+dXFT3fb3Rn5etyhdPZQLbz926aJkwejMCrkuVwvWg
   MFSJRgtI80kR9cmfDDuXlCUzwimQvnFGrHPsNO507v4Fc4hWiZF1TK44z
   PiBWFkWRvf53vmX1Zva0rnY1xJ5ETAlBRpvHopoqvyl9MQLsCNuFeO91O
   g==;
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="158596694"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2022 03:38:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 11 May 2022 03:38:54 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 11 May 2022 03:38:48 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [RFC Patch net-next 5/9] net: dsa: microchip: move struct mib_names to ksz_chip_data
Date:   Wed, 11 May 2022 16:07:51 +0530
Message-ID: <20220511103755.12553-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220511103755.12553-1-arun.ramadoss@microchip.com>
References: <20220511103755.12553-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ksz88xx family has one set of mib_names. The ksz87xx, ksz9477,
LAN937x based switches has one set of mib_names. In order to remove
redundant declaration, moved the struct mib_names to ksz_chip_data
structure. And allocated the mib memory in switch_register instead of
individual switch_init function.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 116 ++------------------
 drivers/net/dsa/microchip/ksz9477.c    |  70 ++----------
 drivers/net/dsa/microchip/ksz_common.c | 143 +++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h |  11 +-
 4 files changed, 159 insertions(+), 181 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 91f29ff7256c..3490b6072641 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -126,86 +126,6 @@ static u8 ksz8863_shifts[] = {
 	[DYNAMIC_MAC_SRC_PORT]		= 20,
 };
 
-struct mib_names {
-	char string[ETH_GSTRING_LEN];
-};
-
-static const struct mib_names ksz87xx_mib_names[] = {
-	{ "rx_hi" },
-	{ "rx_undersize" },
-	{ "rx_fragments" },
-	{ "rx_oversize" },
-	{ "rx_jabbers" },
-	{ "rx_symbol_err" },
-	{ "rx_crc_err" },
-	{ "rx_align_err" },
-	{ "rx_mac_ctrl" },
-	{ "rx_pause" },
-	{ "rx_bcast" },
-	{ "rx_mcast" },
-	{ "rx_ucast" },
-	{ "rx_64_or_less" },
-	{ "rx_65_127" },
-	{ "rx_128_255" },
-	{ "rx_256_511" },
-	{ "rx_512_1023" },
-	{ "rx_1024_1522" },
-	{ "rx_1523_2000" },
-	{ "rx_2001" },
-	{ "tx_hi" },
-	{ "tx_late_col" },
-	{ "tx_pause" },
-	{ "tx_bcast" },
-	{ "tx_mcast" },
-	{ "tx_ucast" },
-	{ "tx_deferred" },
-	{ "tx_total_col" },
-	{ "tx_exc_col" },
-	{ "tx_single_col" },
-	{ "tx_mult_col" },
-	{ "rx_total" },
-	{ "tx_total" },
-	{ "rx_discards" },
-	{ "tx_discards" },
-};
-
-static const struct mib_names ksz88xx_mib_names[] = {
-	{ "rx" },
-	{ "rx_hi" },
-	{ "rx_undersize" },
-	{ "rx_fragments" },
-	{ "rx_oversize" },
-	{ "rx_jabbers" },
-	{ "rx_symbol_err" },
-	{ "rx_crc_err" },
-	{ "rx_align_err" },
-	{ "rx_mac_ctrl" },
-	{ "rx_pause" },
-	{ "rx_bcast" },
-	{ "rx_mcast" },
-	{ "rx_ucast" },
-	{ "rx_64_or_less" },
-	{ "rx_65_127" },
-	{ "rx_128_255" },
-	{ "rx_256_511" },
-	{ "rx_512_1023" },
-	{ "rx_1024_1522" },
-	{ "tx" },
-	{ "tx_hi" },
-	{ "tx_late_col" },
-	{ "tx_pause" },
-	{ "tx_bcast" },
-	{ "tx_mcast" },
-	{ "tx_ucast" },
-	{ "tx_deferred" },
-	{ "tx_total_col" },
-	{ "tx_exc_col" },
-	{ "tx_single_col" },
-	{ "tx_mult_col" },
-	{ "rx_discards" },
-	{ "tx_discards" },
-};
-
 static bool ksz_is_ksz88x3(struct ksz_device *dev)
 {
 	return dev->chip_id == 0x8830;
@@ -306,7 +226,7 @@ static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	masks = ksz8->masks;
 	regs = ksz8->regs;
 
-	ctrl_addr = addr + dev->reg_mib_cnt * port;
+	ctrl_addr = addr + dev->info->reg_mib_cnt * port;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
@@ -343,7 +263,7 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	masks = ksz8->masks;
 	regs = ksz8->regs;
 
-	addr -= dev->reg_mib_cnt;
+	addr -= dev->info->reg_mib_cnt;
 	ctrl_addr = (KSZ8795_MIB_TOTAL_RX_1 - KSZ8795_MIB_TOTAL_RX_0) * port;
 	ctrl_addr += addr + KSZ8795_MIB_TOTAL_RX_0;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
@@ -392,7 +312,7 @@ static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	u32 data;
 	u32 cur;
 
-	addr -= dev->reg_mib_cnt;
+	addr -= dev->info->reg_mib_cnt;
 	ctrl_addr = addr ? KSZ8863_MIB_PACKET_DROPPED_TX_0 :
 			   KSZ8863_MIB_PACKET_DROPPED_RX_0;
 	ctrl_addr += port;
@@ -453,23 +373,23 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 	mib->cnt_ptr = 0;
 
 	/* Some ports may not have MIB counters before SWITCH_COUNTER_NUM. */
-	while (mib->cnt_ptr < dev->reg_mib_cnt) {
+	while (mib->cnt_ptr < dev->info->reg_mib_cnt) {
 		dev->dev_ops->r_mib_cnt(dev, port, mib->cnt_ptr,
 					&mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
 
 	/* last one in storage */
-	dropped = &mib->counters[dev->mib_cnt];
+	dropped = &mib->counters[dev->info->mib_cnt];
 
 	/* Some ports may not have MIB counters after SWITCH_COUNTER_NUM. */
-	while (mib->cnt_ptr < dev->mib_cnt) {
+	while (mib->cnt_ptr < dev->info->mib_cnt) {
 		dev->dev_ops->r_mib_pkt(dev, port, mib->cnt_ptr,
 					dropped, &mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
 	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
+	memset(mib->counters, 0, dev->info->mib_cnt * sizeof(u64));
 }
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
@@ -1009,9 +929,9 @@ static void ksz8_get_strings(struct dsa_switch *ds, int port,
 	struct ksz_device *dev = ds->priv;
 	int i;
 
-	for (i = 0; i < dev->mib_cnt; i++) {
+	for (i = 0; i < dev->info->mib_cnt; i++) {
 		memcpy(buf + i * ETH_GSTRING_LEN,
-		       dev->mib_names[i].string, ETH_GSTRING_LEN);
+		       dev->info->mib_names[i].string, ETH_GSTRING_LEN);
 	}
 }
 
@@ -1574,7 +1494,6 @@ static int ksz8_switch_detect(struct ksz_device *dev)
 static int ksz8_switch_init(struct ksz_device *dev)
 {
 	struct ksz8 *ksz8 = dev->priv;
-	int i;
 
 	dev->ds->ops = &ksz8_switch_ops;
 
@@ -1587,27 +1506,10 @@ static int ksz8_switch_init(struct ksz_device *dev)
 		ksz8->regs = ksz8863_regs;
 		ksz8->masks = ksz8863_masks;
 		ksz8->shifts = ksz8863_shifts;
-		dev->mib_cnt = ARRAY_SIZE(ksz88xx_mib_names);
-		dev->mib_names = ksz88xx_mib_names;
 	} else {
 		ksz8->regs = ksz8795_regs;
 		ksz8->masks = ksz8795_masks;
 		ksz8->shifts = ksz8795_shifts;
-		dev->mib_cnt = ARRAY_SIZE(ksz87xx_mib_names);
-		dev->mib_names = ksz87xx_mib_names;
-	}
-
-	dev->reg_mib_cnt = MIB_COUNTER_NUM;
-
-	for (i = 0; i < dev->info->port_cnt; i++) {
-		mutex_init(&dev->ports[i].mib.cnt_mutex);
-		dev->ports[i].mib.counters =
-			devm_kzalloc(dev->dev,
-				     sizeof(u64) *
-				     (dev->mib_cnt + 1),
-				     GFP_KERNEL);
-		if (!dev->ports[i].mib.counters)
-			return -ENOMEM;
 	}
 
 	/* We rely on software untagging on the CPU port, so that we
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 1a0fd36e180e..d4729f0dd831 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -23,48 +23,6 @@
 #define NEW_XMII			BIT(1)
 #define IS_9893				BIT(2)
 
-static const struct {
-	int index;
-	char string[ETH_GSTRING_LEN];
-} ksz9477_mib_names[TOTAL_SWITCH_COUNTER_NUM] = {
-	{ 0x00, "rx_hi" },
-	{ 0x01, "rx_undersize" },
-	{ 0x02, "rx_fragments" },
-	{ 0x03, "rx_oversize" },
-	{ 0x04, "rx_jabbers" },
-	{ 0x05, "rx_symbol_err" },
-	{ 0x06, "rx_crc_err" },
-	{ 0x07, "rx_align_err" },
-	{ 0x08, "rx_mac_ctrl" },
-	{ 0x09, "rx_pause" },
-	{ 0x0A, "rx_bcast" },
-	{ 0x0B, "rx_mcast" },
-	{ 0x0C, "rx_ucast" },
-	{ 0x0D, "rx_64_or_less" },
-	{ 0x0E, "rx_65_127" },
-	{ 0x0F, "rx_128_255" },
-	{ 0x10, "rx_256_511" },
-	{ 0x11, "rx_512_1023" },
-	{ 0x12, "rx_1024_1522" },
-	{ 0x13, "rx_1523_2000" },
-	{ 0x14, "rx_2001" },
-	{ 0x15, "tx_hi" },
-	{ 0x16, "tx_late_col" },
-	{ 0x17, "tx_pause" },
-	{ 0x18, "tx_bcast" },
-	{ 0x19, "tx_mcast" },
-	{ 0x1A, "tx_ucast" },
-	{ 0x1B, "tx_deferred" },
-	{ 0x1C, "tx_total_col" },
-	{ 0x1D, "tx_exc_col" },
-	{ 0x1E, "tx_single_col" },
-	{ 0x1F, "tx_mult_col" },
-	{ 0x80, "rx_total" },
-	{ 0x81, "tx_total" },
-	{ 0x82, "rx_discards" },
-	{ 0x83, "tx_discards" },
-};
-
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -287,7 +245,7 @@ static void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
 static void ksz9477_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			      u64 *dropped, u64 *cnt)
 {
-	addr = ksz9477_mib_names[addr].index;
+	addr = dev->info->mib_names[addr].index;
 	ksz9477_r_mib_cnt(dev, port, addr, cnt);
 }
 
@@ -318,7 +276,7 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 
 	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
+	memset(mib->counters, 0, dev->info->mib_cnt * sizeof(u64));
 }
 
 static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
@@ -403,14 +361,15 @@ static int ksz9477_phy_write16(struct dsa_switch *ds, int addr, int reg,
 static void ksz9477_get_strings(struct dsa_switch *ds, int port,
 				u32 stringset, uint8_t *buf)
 {
+	struct ksz_device *dev = ds->priv;
 	int i;
 
 	if (stringset != ETH_SS_STATS)
 		return;
 
-	for (i = 0; i < TOTAL_SWITCH_COUNTER_NUM; i++) {
-		memcpy(buf + i * ETH_GSTRING_LEN, ksz9477_mib_names[i].string,
-		       ETH_GSTRING_LEN);
+	for (i = 0; i < dev->info->mib_cnt; i++) {
+		memcpy(buf + i * ETH_GSTRING_LEN,
+		       dev->info->mib_names[i].string, ETH_GSTRING_LEN);
 	}
 }
 
@@ -1473,27 +1432,10 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 
 static int ksz9477_switch_init(struct ksz_device *dev)
 {
-	int i;
-
 	dev->ds->ops = &ksz9477_switch_ops;
 
 	dev->port_mask = (1 << dev->info->port_cnt) - 1;
 
-	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
-	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
-
-	for (i = 0; i < dev->info->port_cnt; i++) {
-		spin_lock_init(&dev->ports[i].mib.stats64_lock);
-		mutex_init(&dev->ports[i].mib.cnt_mutex);
-		dev->ports[i].mib.counters =
-			devm_kzalloc(dev->dev,
-				     sizeof(u64) *
-				     (TOTAL_SWITCH_COUNTER_NUM + 1),
-				     GFP_KERNEL);
-		if (!dev->ports[i].mib.counters)
-			return -ENOMEM;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 59af4142cb6d..46d745e0e58e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -21,6 +21,8 @@
 
 #include "ksz_common.h"
 
+#define MIB_COUNTER_NUM 0x20
+
 struct ksz_stats_raw {
 	u64 rx_hi;
 	u64 rx_undersize;
@@ -60,6 +62,82 @@ struct ksz_stats_raw {
 	u64 tx_discards;
 };
 
+static const struct ksz_mib_names ksz88xx_mib_names[] = {
+	{ 0x00, "rx" },
+	{ 0x01, "rx_hi" },
+	{ 0x02, "rx_undersize" },
+	{ 0x03, "rx_fragments" },
+	{ 0x04, "rx_oversize" },
+	{ 0x05, "rx_jabbers" },
+	{ 0x06, "rx_symbol_err" },
+	{ 0x07, "rx_crc_err" },
+	{ 0x08, "rx_align_err" },
+	{ 0x09, "rx_mac_ctrl" },
+	{ 0x0a, "rx_pause" },
+	{ 0x0b, "rx_bcast" },
+	{ 0x0c, "rx_mcast" },
+	{ 0x0d, "rx_ucast" },
+	{ 0x0e, "rx_64_or_less" },
+	{ 0x0f, "rx_65_127" },
+	{ 0x10, "rx_128_255" },
+	{ 0x11, "rx_256_511" },
+	{ 0x12, "rx_512_1023" },
+	{ 0x13, "rx_1024_1522" },
+	{ 0x14, "tx" },
+	{ 0x15, "tx_hi" },
+	{ 0x16, "tx_late_col" },
+	{ 0x17, "tx_pause" },
+	{ 0x18, "tx_bcast" },
+	{ 0x19, "tx_mcast" },
+	{ 0x1a, "tx_ucast" },
+	{ 0x1b, "tx_deferred" },
+	{ 0x1c, "tx_total_col" },
+	{ 0x1d, "tx_exc_col" },
+	{ 0x1e, "tx_single_col" },
+	{ 0x1f, "tx_mult_col" },
+	{ 0x100, "rx_discards" },
+	{ 0x101, "tx_discards" },
+};
+
+const struct ksz_mib_names ksz9477_mib_names[] = {
+	{ 0x00, "rx_hi" },
+	{ 0x01, "rx_undersize" },
+	{ 0x02, "rx_fragments" },
+	{ 0x03, "rx_oversize" },
+	{ 0x04, "rx_jabbers" },
+	{ 0x05, "rx_symbol_err" },
+	{ 0x06, "rx_crc_err" },
+	{ 0x07, "rx_align_err" },
+	{ 0x08, "rx_mac_ctrl" },
+	{ 0x09, "rx_pause" },
+	{ 0x0A, "rx_bcast" },
+	{ 0x0B, "rx_mcast" },
+	{ 0x0C, "rx_ucast" },
+	{ 0x0D, "rx_64_or_less" },
+	{ 0x0E, "rx_65_127" },
+	{ 0x0F, "rx_128_255" },
+	{ 0x10, "rx_256_511" },
+	{ 0x11, "rx_512_1023" },
+	{ 0x12, "rx_1024_1522" },
+	{ 0x13, "rx_1523_2000" },
+	{ 0x14, "rx_2001" },
+	{ 0x15, "tx_hi" },
+	{ 0x16, "tx_late_col" },
+	{ 0x17, "tx_pause" },
+	{ 0x18, "tx_bcast" },
+	{ 0x19, "tx_mcast" },
+	{ 0x1A, "tx_ucast" },
+	{ 0x1B, "tx_deferred" },
+	{ 0x1C, "tx_total_col" },
+	{ 0x1D, "tx_exc_col" },
+	{ 0x1E, "tx_single_col" },
+	{ 0x1F, "tx_mult_col" },
+	{ 0x80, "rx_total" },
+	{ 0x81, "tx_total" },
+	{ 0x82, "rx_discards" },
+	{ 0x83, "tx_discards" },
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8795] = {
 		.chip_id = 0x8795,
@@ -70,6 +148,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
 		.ksz87xx_eee_link_erratum = true,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[KSZ8794] = {
@@ -95,6 +176,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
 		.ksz87xx_eee_link_erratum = true,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[KSZ8765] = {
@@ -106,6 +190,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
 		.ksz87xx_eee_link_erratum = true,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[KSZ8830] = {
@@ -116,6 +203,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 8,
 		.cpu_ports = 0x4,	/* can be configured as cpu port */
 		.port_cnt = 3,
+		.mib_names = ksz88xx_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[KSZ9477] = {
@@ -127,6 +217,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.phy_errata_9477 = true,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[KSZ9897] = {
@@ -138,6 +231,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.phy_errata_9477 = true,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[KSZ9893] = {
@@ -148,6 +244,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[KSZ9567] = {
@@ -159,6 +258,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
 		.phy_errata_9477 = true,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[LAN9370] = {
@@ -169,6 +271,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[LAN9371] = {
@@ -179,6 +284,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[LAN9372] = {
@@ -189,6 +297,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[LAN9373] = {
@@ -199,6 +310,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x38,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 
 	[LAN9374] = {
@@ -209,6 +323,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
 	},
 };
 
@@ -365,17 +482,17 @@ static void port_r_cnt(struct ksz_device *dev, int port)
 	u64 *dropped;
 
 	/* Some ports may not have MIB counters before SWITCH_COUNTER_NUM. */
-	while (mib->cnt_ptr < dev->reg_mib_cnt) {
+	while (mib->cnt_ptr < dev->info->reg_mib_cnt) {
 		dev->dev_ops->r_mib_cnt(dev, port, mib->cnt_ptr,
 					&mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
 
 	/* last one in storage */
-	dropped = &mib->counters[dev->mib_cnt];
+	dropped = &mib->counters[dev->info->mib_cnt];
 
 	/* Some ports may not have MIB counters after SWITCH_COUNTER_NUM. */
-	while (mib->cnt_ptr < dev->mib_cnt) {
+	while (mib->cnt_ptr < dev->info->mib_cnt) {
 		dev->dev_ops->r_mib_pkt(dev, port, mib->cnt_ptr,
 					dropped, &mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
@@ -406,7 +523,7 @@ static void ksz_mib_read_work(struct work_struct *work)
 			const struct dsa_port *dp = dsa_to_port(dev->ds, i);
 
 			if (!netif_carrier_ok(dp->slave))
-				mib->cnt_ptr = dev->reg_mib_cnt;
+				mib->cnt_ptr = dev->info->reg_mib_cnt;
 		}
 		port_r_cnt(dev, i);
 		p->read = false;
@@ -473,7 +590,7 @@ int ksz_sset_count(struct dsa_switch *ds, int port, int sset)
 	if (sset != ETH_SS_STATS)
 		return 0;
 
-	return dev->mib_cnt;
+	return dev->info->mib_cnt;
 }
 EXPORT_SYMBOL_GPL(ksz_sset_count);
 
@@ -488,9 +605,9 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 
 	/* Only read dropped counters if no link. */
 	if (!netif_carrier_ok(dp->slave))
-		mib->cnt_ptr = dev->reg_mib_cnt;
+		mib->cnt_ptr = dev->info->reg_mib_cnt;
 	port_r_cnt(dev, port);
-	memcpy(buf, mib->counters, dev->mib_cnt * sizeof(u64));
+	memcpy(buf, mib->counters, dev->info->mib_cnt * sizeof(u64));
 	mutex_unlock(&mib->cnt_mutex);
 }
 EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
@@ -726,6 +843,7 @@ int ksz_switch_register(struct ksz_device *dev,
 	phy_interface_t interface;
 	unsigned int port_num;
 	int ret;
+	int i;
 
 	if (dev->pdata)
 		dev->chip_id = dev->pdata->chip_id;
@@ -773,6 +891,17 @@ int ksz_switch_register(struct ksz_device *dev,
 	if (!dev->ports)
 		return -ENOMEM;
 
+	for (i = 0; i < dev->info->port_cnt; i++) {
+		mutex_init(&dev->ports[i].mib.cnt_mutex);
+		dev->ports[i].mib.counters =
+			devm_kzalloc(dev->dev,
+				     sizeof(u64) *
+				     (dev->info->mib_cnt + 1),
+				     GFP_KERNEL);
+		if (!dev->ports[i].mib.counters)
+			return -ENOMEM;
+	}
+
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->info->port_cnt;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d6c4c4b7f7bf..6b968369bf49 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -26,6 +26,11 @@ struct ksz_port_mib {
 	struct spinlock stats64_lock;
 };
 
+struct ksz_mib_names {
+	int index;
+	char string[ETH_GSTRING_LEN];
+};
+
 struct ksz_chip_data {
 	u32 chip_id;
 	const char *dev_name;
@@ -36,6 +41,9 @@ struct ksz_chip_data {
 	int port_cnt;
 	bool phy_errata_9477;
 	bool ksz87xx_eee_link_erratum;
+	const struct ksz_mib_names *mib_names;
+	int mib_cnt;
+	u8 reg_mib_cnt;
 };
 
 struct ksz_port {
@@ -79,9 +87,6 @@ struct ksz_device {
 	u32 chip_id;
 	int cpu_port;			/* port connected to CPU */
 	int phy_port_cnt;
-	u8 reg_mib_cnt;
-	int mib_cnt;
-	const struct mib_names *mib_names;
 	phy_interface_t compat_interface;
 	u32 regs_size;
 	bool synclko_125;
-- 
2.33.0

