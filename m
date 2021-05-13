Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCF737F6F9
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhEMLoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhEMLow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:44:52 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3E6C06174A;
        Thu, 13 May 2021 04:43:42 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lh9kb-0007HF-9J; Thu, 13 May 2021 14:43:33 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v2 1/5] atl1c: show correct link speed on Mikrotik 10/25G NIC
Date:   Thu, 13 May 2021 14:43:22 +0300
Message-Id: <20210513114326.699663-2-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513114326.699663-1-gatis@mikrotik.com>
References: <20210513114326.699663-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new Mikrotik 10/25G NIC maintains compatibility with existing atl1c
driver. However it does have new features.

This defines some new register offsets, code for identifying the new type
of NIC and correct speed detection for the NIC.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h      | 1 +
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c   | 9 +++++++++
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h   | 7 +++++++
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++++
 4 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 28ae5c16831e..3fda7eb3bd69 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -289,6 +289,7 @@ enum atl1c_nic_type {
 	athr_l2c_b2,
 	athr_l1d,
 	athr_l1d_2,
+	athr_mt,
 };
 
 enum atl1c_trans_queue {
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
index 140358dcf61e..ddb9442416cd 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
@@ -648,6 +648,15 @@ int atl1c_get_speed_and_duplex(struct atl1c_hw *hw, u16 *speed, u16 *duplex)
 	int err;
 	u16 phy_data;
 
+	if (hw->nic_type == athr_mt) {
+		u32 spd;
+
+		AT_READ_REG(hw, REG_MT_SPEED, &spd);
+		*speed = spd;
+		*duplex = FULL_DUPLEX;
+		return 0;
+	}
+
 	/* Read   PHY Specific Status Register (17) */
 	err = atl1c_read_phy_reg(hw, MII_GIGA_PSSR, &phy_data);
 	if (err)
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
index ce1a123dce2c..73cbc049a63e 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -764,6 +764,13 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 #define REG_DEBUG_DATA0 		0x1900
 #define REG_DEBUG_DATA1 		0x1904
 
+#define REG_MT_MAGIC			0x1F00
+#define REG_MT_MODE			0x1F04
+#define REG_MT_SPEED			0x1F08
+#define REG_MT_VERSION			0x1F0C
+
+#define MT_MAGIC			0xaabb1234
+
 #define L1D_MPW_PHYID1			0xD01C  /* V7 */
 #define L1D_MPW_PHYID2			0xD01D  /* V1-V6 */
 #define L1D_MPW_PHYID3			0xD01E  /* V8 */
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index c6263cf8d3c0..28c30d5288e4 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -644,6 +644,7 @@ static int atl1c_alloc_queues(struct atl1c_adapter *adapter)
 
 static void atl1c_set_mac_type(struct atl1c_hw *hw)
 {
+	u32 magic;
 	switch (hw->device_id) {
 	case PCI_DEVICE_ID_ATTANSIC_L2C:
 		hw->nic_type = athr_l2c;
@@ -662,6 +663,9 @@ static void atl1c_set_mac_type(struct atl1c_hw *hw)
 		break;
 	case PCI_DEVICE_ID_ATHEROS_L1D_2_0:
 		hw->nic_type = athr_l1d_2;
+		AT_READ_REG(hw, REG_MT_MAGIC, &magic);
+		if (magic == MT_MAGIC)
+			hw->nic_type = athr_mt;
 		break;
 	default:
 		break;
-- 
2.31.1

