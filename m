Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE3D374152
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhEEQhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234787AbhEEQfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:35:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2658261422;
        Wed,  5 May 2021 16:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232375;
        bh=q8uouMgsjHeRPHa+R+tAbyGFheMQJ6VUjD+jk0OFQII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGYBh6rWlIO7jmi0hQVaQPuPAODIDcCSuooZl9TOhLF/dolvmMtZ+R1ACPW2J1HC7
         N9yBxcSYMM9sEhnfvVcleSEnHZlXKGSaaoBeNvnA0CBJB2DybS83nt2f6wR9MnKdPC
         EeNVpWfKQhSXO6FhQsBiwWyATqRceIL4QYrhz9Jo5PxoS71nm2IbLLVVZZnsbjkxNQ
         c+eBgf2GRwagCSJy1p3hIO0JwIduMDqHu7GJzrPI0XY8ReYEr4VhwTeY80HQ+HbODD
         Cb6n0yeUQfeyT272mYolsfNTx664YMSQOPkqkSQZ8mv6byvrYzb9UGU7JBZ3GZk/ze
         Y6+9kudb8TaBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryder Lee <ryder.lee@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 064/116] mt76: mt7915: add wifi subsystem reset
Date:   Wed,  5 May 2021 12:30:32 -0400
Message-Id: <20210505163125.3460440-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit e07419a7dca97dd9bddfe5d099380857c19535f3 ]

Reset wifi subsystem when MCU is already running.
Fixes firmware download failure after soft reboot on systems where the PCIe
reset could not be performed properly.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/init.c  | 58 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 15 +----
 .../net/wireless/mediatek/mt76/mt7915/regs.h  | 13 +++++
 3 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ad4e5b95158b..16ad53316c38 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -4,6 +4,7 @@
 #include <linux/etherdevice.h>
 #include "mt7915.h"
 #include "mac.h"
+#include "mcu.h"
 #include "eeprom.h"
 
 #define CCK_RATE(_idx, _rate) {						\
@@ -283,9 +284,50 @@ static void mt7915_init_work(struct work_struct *work)
 	mt7915_register_ext_phy(dev);
 }
 
+static void mt7915_wfsys_reset(struct mt7915_dev *dev)
+{
+	u32 val = MT_TOP_PWR_KEY | MT_TOP_PWR_SW_PWR_ON | MT_TOP_PWR_PWR_ON;
+	u32 reg = mt7915_reg_map_l1(dev, MT_TOP_MISC);
+
+#define MT_MCU_DUMMY_RANDOM	GENMASK(15, 0)
+#define MT_MCU_DUMMY_DEFAULT	GENMASK(31, 16)
+
+	mt76_wr(dev, MT_MCU_WFDMA0_DUMMY_CR, MT_MCU_DUMMY_RANDOM);
+
+	/* change to software control */
+	val |= MT_TOP_PWR_SW_RST;
+	mt76_wr(dev, MT_TOP_PWR_CTRL, val);
+
+	/* reset wfsys */
+	val &= ~MT_TOP_PWR_SW_RST;
+	mt76_wr(dev, MT_TOP_PWR_CTRL, val);
+
+	/* release wfsys then mcu re-excutes romcode */
+	val |= MT_TOP_PWR_SW_RST;
+	mt76_wr(dev, MT_TOP_PWR_CTRL, val);
+
+	/* switch to hw control */
+	val &= ~MT_TOP_PWR_SW_RST;
+	val |= MT_TOP_PWR_HW_CTRL;
+	mt76_wr(dev, MT_TOP_PWR_CTRL, val);
+
+	/* check whether mcu resets to default */
+	if (!mt76_poll_msec(dev, MT_MCU_WFDMA0_DUMMY_CR, MT_MCU_DUMMY_DEFAULT,
+			    MT_MCU_DUMMY_DEFAULT, 1000)) {
+		dev_err(dev->mt76.dev, "wifi subsystem reset failure\n");
+		return;
+	}
+
+	/* wfsys reset won't clear host registers */
+	mt76_clear(dev, reg, MT_TOP_MISC_FW_STATE);
+
+	msleep(100);
+}
+
 static int mt7915_init_hardware(struct mt7915_dev *dev)
 {
 	int ret, idx;
+	u32 val;
 
 	mt76_wr(dev, MT_INT_SOURCE_CSR, ~0);
 
@@ -295,6 +337,12 @@ static int mt7915_init_hardware(struct mt7915_dev *dev)
 
 	dev->dbdc_support = !!(mt7915_l1_rr(dev, MT_HW_BOUND) & BIT(5));
 
+	val = mt76_rr(dev, mt7915_reg_map_l1(dev, MT_TOP_MISC));
+
+	/* If MCU was already running, it is likely in a bad state */
+	if (FIELD_GET(MT_TOP_MISC_FW_STATE, val) > FW_STATE_FW_DOWNLOAD)
+		mt7915_wfsys_reset(dev);
+
 	ret = mt7915_dma_init(dev);
 	if (ret)
 		return ret;
@@ -308,8 +356,14 @@ static int mt7915_init_hardware(struct mt7915_dev *dev)
 	mt76_wr(dev, MT_SWDEF_MODE, MT_SWDEF_NORMAL_MODE);
 
 	ret = mt7915_mcu_init(dev);
-	if (ret)
-		return ret;
+	if (ret) {
+		/* Reset and try again */
+		mt7915_wfsys_reset(dev);
+
+		ret = mt7915_mcu_init(dev);
+		if (ret)
+			return ret;
+	}
 
 	ret = mt7915_eeprom_init(dev);
 	if (ret < 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 12281e4cf817..f5431e4bd8de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2754,21 +2754,8 @@ static int mt7915_load_ram(struct mt7915_dev *dev)
 
 static int mt7915_load_firmware(struct mt7915_dev *dev)
 {
+	u32 reg = mt7915_reg_map_l1(dev, MT_TOP_MISC);
 	int ret;
-	u32 val, reg = mt7915_reg_map_l1(dev, MT_TOP_MISC);
-
-	val = FIELD_PREP(MT_TOP_MISC_FW_STATE, FW_STATE_FW_DOWNLOAD);
-
-	if (!mt76_poll_msec(dev, reg, MT_TOP_MISC_FW_STATE, val, 1000)) {
-		/* restart firmware once */
-		__mt76_mcu_restart(&dev->mt76);
-		if (!mt76_poll_msec(dev, reg, MT_TOP_MISC_FW_STATE,
-				    val, 1000)) {
-			dev_err(dev->mt76.dev,
-				"Firmware is not ready for download\n");
-			return -EIO;
-		}
-	}
 
 	ret = mt7915_load_patch(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index ed0c9a24bb53..dfb8880657bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -4,6 +4,11 @@
 #ifndef __MT7915_REGS_H
 #define __MT7915_REGS_H
 
+/* MCU WFDMA0 */
+#define MT_MCU_WFDMA0_BASE		0x2000
+#define MT_MCU_WFDMA0(ofs)		(MT_MCU_WFDMA0_BASE + (ofs))
+#define MT_MCU_WFDMA0_DUMMY_CR		MT_MCU_WFDMA0(0x120)
+
 /* MCU WFDMA1 */
 #define MT_MCU_WFDMA1_BASE		0x3000
 #define MT_MCU_WFDMA1(ofs)		(MT_MCU_WFDMA1_BASE + (ofs))
@@ -396,6 +401,14 @@
 #define MT_WFDMA1_PCIE1_BUSY_ENA_TX_FIFO1	BIT(1)
 #define MT_WFDMA1_PCIE1_BUSY_ENA_RX_FIFO	BIT(2)
 
+#define MT_TOP_RGU_BASE				0xf0000
+#define MT_TOP_PWR_CTRL				(MT_TOP_RGU_BASE + (0x0))
+#define MT_TOP_PWR_KEY				(0x5746 << 16)
+#define MT_TOP_PWR_SW_RST			BIT(0)
+#define MT_TOP_PWR_SW_PWR_ON			GENMASK(3, 2)
+#define MT_TOP_PWR_HW_CTRL			BIT(4)
+#define MT_TOP_PWR_PWR_ON			BIT(7)
+
 #define MT_INFRA_CFG_BASE		0xf1000
 #define MT_INFRA(ofs)			(MT_INFRA_CFG_BASE + (ofs))
 
-- 
2.30.2

