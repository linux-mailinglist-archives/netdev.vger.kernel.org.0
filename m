Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9521961E9EF
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 04:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiKGD50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 22:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiKGD5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 22:57:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44489C762;
        Sun,  6 Nov 2022 19:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667793441; x=1699329441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6xoDohR+dK+0LjrYru6J9+T6Qu1usqCr04cNAJGYu8s=;
  b=o4JtdRBDOxNZA2LSy8tZzzps1zb1Jrsg3jHW0olyTY/sfg5gdEIE394V
   E2UQeRFMeJOlU1efk2Yye/Jxei8VcbR4BMdaz2EJH9vSw1gXgPPeA+uit
   DQ7ioDaf8NC6NMNmsBQUV8sFxZgVZqApLg2m+JgEcHN9U39XRk4lyZKek
   m+RH6qaEBrSidDS1EPOAxNQe8ic6nTeGC3gzThsmi1JUAXW3Wm6YWGJoM
   FyPNkFWV9EQT3PNCzwtq7O/JQbRaV4sSNDbp5g7cwvRwisu3P31R96r7a
   VBjg8mSyAHSU1bndGfTxoZt5wc0SD0zoaBvIUm3cqKkoB8pluI7gCscbj
   w==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="198654885"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 20:57:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 20:57:20 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 20:57:16 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next v2 1/5] net: dsa: microchip: add ksz9563 in ksz_switch_ops and select based on compatible string
Date:   Mon, 7 Nov 2022 14:59:18 +0530
Message-ID: <20221107092922.5926-2-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
References: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add KSZ9563 inside ksz_switch_chips structure with
port_nirq as 3. KSZ9563 use KSZ9893 switch parameters
but port_nirq count is 3 for KSZ9563 whereas 2 for
KSZ9893. Add KSZ9563 inside ksz_switch_chips as a separate
member and from device tree map compatible string into
KSZ9563 inside ksz_spi.c and ksz9477_i2c.c.
Global Chip ID 1 and 2 registers read value 9893, select
sku based on  Global Chip ID 4 Register which read 0x1c
for KSZ9563.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c     |  3 ++-
 drivers/net/dsa/microchip/ksz9477_i2c.c |  2 +-
 drivers/net/dsa/microchip/ksz_common.c  | 33 +++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h  |  3 +++
 drivers/net/dsa/microchip/ksz_spi.c     |  2 +-
 5 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a6a0321a8931..0d6b40968657 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -195,7 +195,8 @@ int ksz9477_reset_switch(struct ksz_device *dev)
 
 	/* KSZ9893 compatible chips do not support refclk configuration */
 	if (dev->chip_id == KSZ9893_CHIP_ID ||
-	    dev->chip_id == KSZ8563_CHIP_ID)
+	    dev->chip_id == KSZ8563_CHIP_ID ||
+	    dev->chip_id == KSZ9563_CHIP_ID)
 		return 0;
 
 	data8 = SW_ENABLE_REFCLKO;
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 3763930dc6fc..55146584e9b5 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -101,7 +101,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	},
 	{
 		.compatible = "microchip,ksz9563",
-		.data = &ksz_switch_chips[KSZ9893]
+		.data = &ksz_switch_chips[KSZ9563]
 	},
 	{
 		.compatible = "microchip,ksz8563",
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d612181b3226..f7e414e747ed 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1282,6 +1282,31 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.gbit_capable = {true, true, true},
 	},
 
+	[KSZ9563] = {
+		.chip_id = KSZ9563_CHIP_ID,
+		.dev_name = "KSZ9563",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x07,	/* can be configured as cpu port */
+		.port_cnt = 3,		/* total port count */
+		.port_nirqs = 3,
+		.ops = &ksz9477_dev_ops,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.regs = ksz9477_regs,
+		.masks = ksz9477_masks,
+		.shifts = ksz9477_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
+		.xmii_ctrl1 = ksz8795_xmii_ctrl1, /* Same as ksz8795 */
+		.supports_mii = {false, false, true},
+		.supports_rmii = {false, false, true},
+		.supports_rgmii = {false, false, true},
+		.internal_phy = {true, true, false},
+		.gbit_capable = {true, true, true},
+	},
+
 	[KSZ9567] = {
 		.chip_id = KSZ9567_CHIP_ID,
 		.dev_name = "KSZ9567",
@@ -2389,7 +2414,8 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 
 	if (dev->chip_id == KSZ8830_CHIP_ID ||
 	    dev->chip_id == KSZ8563_CHIP_ID ||
-	    dev->chip_id == KSZ9893_CHIP_ID)
+	    dev->chip_id == KSZ9893_CHIP_ID ||
+	    dev->chip_id == KSZ9563_CHIP_ID)
 		proto = DSA_TAG_PROTO_KSZ9893;
 
 	if (dev->chip_id == KSZ9477_CHIP_ID ||
@@ -2509,7 +2535,8 @@ static void ksz_set_xmii(struct ksz_device *dev, int port,
 		data8 |= bitval[P_RGMII_SEL];
 		/* On KSZ9893, disable RGMII in-band status support */
 		if (dev->chip_id == KSZ9893_CHIP_ID ||
-		    dev->chip_id == KSZ8563_CHIP_ID)
+		    dev->chip_id == KSZ8563_CHIP_ID ||
+		    dev->chip_id == KSZ9563_CHIP_ID)
 			data8 &= ~P_MII_MAC_MODE;
 		break;
 	default:
@@ -2782,6 +2809,8 @@ static int ksz_switch_detect(struct ksz_device *dev)
 
 			if (id4 == SKU_ID_KSZ8563)
 				dev->chip_id = KSZ8563_CHIP_ID;
+			else if (id4 == SKU_ID_KSZ9563)
+				dev->chip_id = KSZ9563_CHIP_ID;
 			else
 				dev->chip_id = KSZ9893_CHIP_ID;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 9cfa179575ce..c6726cbd5465 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -154,6 +154,7 @@ enum ksz_model {
 	KSZ9896,
 	KSZ9897,
 	KSZ9893,
+	KSZ9563,
 	KSZ9567,
 	LAN9370,
 	LAN9371,
@@ -172,6 +173,7 @@ enum ksz_chip_id {
 	KSZ9896_CHIP_ID = 0x00989600,
 	KSZ9897_CHIP_ID = 0x00989700,
 	KSZ9893_CHIP_ID = 0x00989300,
+	KSZ9563_CHIP_ID = 0x00956300,
 	KSZ9567_CHIP_ID = 0x00956700,
 	LAN9370_CHIP_ID = 0x00937000,
 	LAN9371_CHIP_ID = 0x00937100,
@@ -551,6 +553,7 @@ static inline int is_lan937x(struct ksz_device *dev)
 /* KSZ9893, KSZ9563, KSZ8563 specific register  */
 #define REG_CHIP_ID4			0x0f
 #define SKU_ID_KSZ8563			0x3c
+#define SKU_ID_KSZ9563			0x1c
 
 /* Driver set switch broadcast storm protection at 10% rate. */
 #define BROADCAST_STORM_PROT_RATE	10
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 1b6ab891b986..4f2186779082 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -163,7 +163,7 @@ static const struct of_device_id ksz_dt_ids[] = {
 	},
 	{
 		.compatible = "microchip,ksz9563",
-		.data = &ksz_switch_chips[KSZ9893]
+		.data = &ksz_switch_chips[KSZ9563]
 	},
 	{
 		.compatible = "microchip,ksz8563",
-- 
2.34.1

