Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EA4537943
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiE3Kng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiE3Kne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:43:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6475176280;
        Mon, 30 May 2022 03:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653907413; x=1685443413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4SWaC9gWE/iDiogcXxavwBo/qrYz9X2kmDYIdlo+yvk=;
  b=Cg636Zp0cjxETe/or5irqOjkm8A0VWbzrIeTsxzwPLYZt+fdmC7nP8rC
   mhZ1B3+65tA87Mj8itjcx0ouUD7mu/dB8+lhY5KYHOQHjV4eN4bWvR9oR
   QLA6MKODnzBOKRkre//LnW+7fgIZZpdcuiXaG3QWQlyW8xbYliR13dMZC
   jWSCF2PSLTtNf4XLnzbjkzT+eqyTVSO8+TX86q1fhfOcF0cwCpX5jUg9g
   a8z+WKZz1FOUDLUTIYAKLT2jtY8Q/w87JVAtewOI0RSP0EDB+hPTTCd3M
   nEE8RSe+uAA5l2XOx8Uz1S+0KZcgZjuo8W9qFCa5GWg0V5xYLUKTRo+UF
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="158094365"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 03:43:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 03:43:32 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 30 May 2022 03:43:27 -0700
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
Subject: [RFC Patch net-next v2 02/15] net: dsa: microchip: move switch chip_id detection to ksz_common
Date:   Mon, 30 May 2022 16:12:44 +0530
Message-ID: <20220530104257.21485-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530104257.21485-1-arun.ramadoss@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
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

KSZ87xx and KSZ88xx have chip_id representation at reg location 0. And
KSZ9477 compatible switch and LAN937x switch have same chip_id detection
at location 0x01 and 0x02. To have the common switch detect
functionality for ksz switches, ksz_switch_detect function is
introduced.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c     | 46 ---------------
 drivers/net/dsa/microchip/ksz8795_reg.h | 13 -----
 drivers/net/dsa/microchip/ksz9477.c     | 21 -------
 drivers/net/dsa/microchip/ksz9477_reg.h |  1 -
 drivers/net/dsa/microchip/ksz_common.c  | 78 +++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h  | 19 +++++-
 6 files changed, 92 insertions(+), 86 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 12a599d5e61a..927db57d02db 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1424,51 +1424,6 @@ static u32 ksz8_get_port_addr(int port, int offset)
 	return PORT_CTRL_ADDR(port, offset);
 }
 
-static int ksz8_switch_detect(struct ksz_device *dev)
-{
-	u8 id1, id2;
-	u16 id16;
-	int ret;
-
-	/* read chip id */
-	ret = ksz_read16(dev, REG_CHIP_ID0, &id16);
-	if (ret)
-		return ret;
-
-	id1 = id16 >> 8;
-	id2 = id16 & SW_CHIP_ID_M;
-
-	switch (id1) {
-	case KSZ87_FAMILY_ID:
-		if ((id2 != CHIP_ID_94 && id2 != CHIP_ID_95))
-			return -ENODEV;
-
-		if (id2 == CHIP_ID_95) {
-			u8 val;
-
-			id2 = 0x95;
-			ksz_read8(dev, REG_PORT_STATUS_0, &val);
-			if (val & PORT_FIBER_MODE)
-				id2 = 0x65;
-		} else if (id2 == CHIP_ID_94) {
-			id2 = 0x94;
-		}
-		break;
-	case KSZ88_FAMILY_ID:
-		if (id2 != CHIP_ID_63)
-			return -ENODEV;
-		break;
-	default:
-		dev_err(dev->dev, "invalid family id: %d\n", id1);
-		return -ENODEV;
-	}
-	id16 &= ~0xff;
-	id16 |= id2;
-	dev->chip_id = id16;
-
-	return 0;
-}
-
 static int ksz8_switch_init(struct ksz_device *dev)
 {
 	struct ksz8 *ksz8 = dev->priv;
@@ -1522,7 +1477,6 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
 	.shutdown = ksz8_reset_switch,
-	.detect = ksz8_switch_detect,
 	.init = ksz8_switch_init,
 	.exit = ksz8_switch_exit,
 };
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 4109433b6b6c..50cdc2a09f5a 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -14,23 +14,10 @@
 #define KS_PRIO_M			0x3
 #define KS_PRIO_S			2
 
-#define REG_CHIP_ID0			0x00
-
-#define KSZ87_FAMILY_ID			0x87
-#define KSZ88_FAMILY_ID			0x88
-
-#define REG_CHIP_ID1			0x01
-
-#define SW_CHIP_ID_M			0xF0
-#define SW_CHIP_ID_S			4
 #define SW_REVISION_M			0x0E
 #define SW_REVISION_S			1
 #define SW_START			0x01
 
-#define CHIP_ID_94			0x60
-#define CHIP_ID_95			0x90
-#define CHIP_ID_63			0x30
-
 #define KSZ8863_REG_SW_RESET		0x43
 
 #define KSZ8863_GLOBAL_SOFTWARE_RESET	BIT(4)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 7afc06681c02..7d3c8f6908b6 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1360,23 +1360,6 @@ static u32 ksz9477_get_port_addr(int port, int offset)
 	return PORT_CTRL_ADDR(port, offset);
 }
 
-static int ksz9477_switch_detect(struct ksz_device *dev)
-{
-	u32 id32;
-	int ret;
-
-	/* read chip id */
-	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
-	if (ret)
-		return ret;
-
-	dev_dbg(dev->dev, "Switch detect: ID=%08x\n", id32);
-
-	dev->chip_id = id32 & 0x00FFFF00;
-
-	return 0;
-}
-
 static int ksz9477_switch_init(struct ksz_device *dev)
 {
 	u8 data8;
@@ -1407,8 +1390,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	dev->features = GBIT_SUPPORT;
 
 	if (dev->chip_id == KSZ9893_CHIP_ID) {
-		/* Chip is from KSZ9893 design. */
-		dev_info(dev->dev, "Found KSZ9893\n");
 		dev->features |= IS_9893;
 
 		/* Chip does not support gigabit. */
@@ -1416,7 +1397,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 			dev->features &= ~GBIT_SUPPORT;
 		dev->phy_port_cnt = 2;
 	} else {
-		dev_info(dev->dev, "Found KSZ9477 or compatible\n");
 		/* Chip uses new XMII register definitions. */
 		dev->features |= NEW_XMII;
 
@@ -1443,7 +1423,6 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.shutdown = ksz9477_reset_switch,
-	.detect = ksz9477_switch_detect,
 	.init = ksz9477_switch_init,
 	.exit = ksz9477_switch_exit,
 };
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 7a2c8d4767af..077e35ab11b5 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -25,7 +25,6 @@
 
 #define REG_CHIP_ID2__1			0x0002
 
-#define CHIP_ID_63			0x63
 #define CHIP_ID_66			0x66
 #define CHIP_ID_67			0x67
 #define CHIP_ID_77			0x77
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9ca8c8d7740f..9057cdb5971c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -930,6 +930,72 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
 
+static int ksz_switch_detect(struct ksz_device *dev)
+{
+	u8 id1, id2;
+	u16 id16;
+	u32 id32;
+	int ret;
+
+	/* read chip id */
+	ret = ksz_read16(dev, REG_CHIP_ID0, &id16);
+	if (ret)
+		return ret;
+
+	id1 = FIELD_GET(SW_FAMILY_ID_M, id16);
+	id2 = FIELD_GET(SW_CHIP_ID_M, id16);
+
+	switch (id1) {
+	case KSZ87_FAMILY_ID:
+		if (id2 == CHIP_ID_95) {
+			u8 val;
+
+			dev->chip_id = KSZ8795_CHIP_ID;
+
+			ksz_read8(dev, KSZ8_PORT_STATUS_0, &val);
+			if (val & KSZ8_PORT_FIBER_MODE)
+				dev->chip_id = KSZ8765_CHIP_ID;
+		} else if (id2 == CHIP_ID_94) {
+			dev->chip_id = KSZ8794_CHIP_ID;
+		} else {
+			return -ENODEV;
+		}
+		break;
+	case KSZ88_FAMILY_ID:
+		if (id2 == CHIP_ID_63)
+			dev->chip_id = KSZ8830_CHIP_ID;
+		else
+			return -ENODEV;
+		break;
+	default:
+		ret = ksz_read32(dev, REG_CHIP_ID0, &id32);
+		if (ret)
+			return ret;
+
+		dev->chip_rev = FIELD_GET(SW_REV_ID_M, id32);
+		id32 &= ~0xFF;
+
+		switch (id32) {
+		case KSZ9477_CHIP_ID:
+		case KSZ9897_CHIP_ID:
+		case KSZ9893_CHIP_ID:
+		case KSZ9567_CHIP_ID:
+		case LAN9370_CHIP_ID:
+		case LAN9371_CHIP_ID:
+		case LAN9372_CHIP_ID:
+		case LAN9373_CHIP_ID:
+		case LAN9374_CHIP_ID:
+			dev->chip_id = id32;
+			break;
+		default:
+			dev_err(dev->dev,
+				"unsupported switch detected %x)\n", id32);
+			return -ENODEV;
+		}
+	}
+	return 0;
+}
+
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
@@ -986,10 +1052,9 @@ int ksz_switch_register(struct ksz_device *dev,
 	mutex_init(&dev->alu_mutex);
 	mutex_init(&dev->vlan_mutex);
 
-	dev->dev_ops = ops;
-
-	if (dev->dev_ops->detect(dev))
-		return -EINVAL;
+	ret = ksz_switch_detect(dev);
+	if (ret)
+		return ret;
 
 	info = ksz_lookup_info(dev->chip_id);
 	if (!info)
@@ -998,10 +1063,15 @@ int ksz_switch_register(struct ksz_device *dev,
 	/* Update the compatible info with the probed one */
 	dev->info = info;
 
+	dev_info(dev->dev, "found switch: %s, rev %i\n",
+		 dev->info->dev_name, dev->chip_rev);
+
 	ret = ksz_check_device_id(dev);
 	if (ret)
 		return ret;
 
+	dev->dev_ops = ops;
+
 	ret = dev->dev_ops->init(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8500eaedad67..d16c095cdefb 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -90,6 +90,7 @@ struct ksz_device {
 
 	/* chip specific data */
 	u32 chip_id;
+	u8 chip_rev;
 	int cpu_port;			/* port connected to CPU */
 	int phy_port_cnt;
 	phy_interface_t compat_interface;
@@ -182,7 +183,6 @@ struct ksz_dev_ops {
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
-	int (*detect)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
 	void (*exit)(struct ksz_device *dev);
 };
@@ -353,6 +353,23 @@ static inline void ksz_regmap_unlock(void *__mtx)
 #define PORT_RX_ENABLE			BIT(1)
 #define PORT_LEARN_DISABLE		BIT(0)
 
+/* Switch ID Defines */
+#define REG_CHIP_ID0			0x00
+
+#define SW_FAMILY_ID_M			GENMASK(15, 8)
+#define KSZ87_FAMILY_ID			0x87
+#define KSZ88_FAMILY_ID			0x88
+
+#define KSZ8_PORT_STATUS_0		0x08
+#define KSZ8_PORT_FIBER_MODE		BIT(7)
+
+#define SW_CHIP_ID_M			GENMASK(7, 4)
+#define CHIP_ID_94			0x6
+#define CHIP_ID_95			0x9
+#define CHIP_ID_63			0x3
+
+#define SW_REV_ID_M			GENMASK(7, 4)
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
-- 
2.36.1

