Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F223454AE8B
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355822AbiFNKfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352455AbiFNKet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:34:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1584839C;
        Tue, 14 Jun 2022 03:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655202889; x=1686738889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J5gIj9lwPtTsfI2FmF3Of9EpSZvPoLczu0NNsEIyFnw=;
  b=Uqe3O5onhT2XpJ/HArZjCHLVOBkXna853g6aKiQ9OhO6dh3zAz19Krug
   9TTNBDimjPaYKuDSglxWLxFlrDP39b4HCgMTMR6awqXNPvphFG/iAM+XJ
   iqgTv4uMByXo75G0/zPiTRCGa74iLQaDCYmpl66bQld8HSP1A+OPnZImD
   cxyaA2avARbO/PQmnv442HaHrxWD/VeH4ifivoQ0ijY7GgoBtjISNR9+L
   Nv8Ga5pdxVtwvxIa1D5nQLEmKvYF32PG5xB3NfMdPgEnznm8oOebOil9l
   GUsbOfU1npRFCDBSz5vM8Kj0PwVcxM5aCpW9FtE4CMnGryLT8GTf0WDG5
   A==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="160222577"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2022 03:34:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Jun 2022 03:34:45 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 14 Jun 2022 03:34:42 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 3/5] net: lan743x: Add support to SGMII block access functions
Date:   Tue, 14 Jun 2022 16:04:22 +0530
Message-ID: <20220614103424.58971-4-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add SGMII access read and write functions

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 69 +++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.h | 12 ++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 6352cba19691..e496769efb54 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -909,6 +909,74 @@ static int lan743x_mdiobus_c45_write(struct mii_bus *bus,
 	return ret;
 }
 
+static int lan743x_sgmii_wait_till_not_busy(struct lan743x_adapter *adapter)
+{
+	u32 data;
+	int ret;
+
+	ret = readx_poll_timeout(LAN743X_CSR_READ_OP, SGMII_ACC, data,
+				 !(data & SGMII_ACC_SGMII_BZY_), 100, 1000000);
+	if (unlikely(ret < 0))
+		netif_err(adapter, drv, adapter->netdev,
+			  "%s: error %d sgmii wait timeout\n", __func__, ret);
+
+	return ret;
+}
+
+static int lan743x_sgmii_read(struct lan743x_adapter *adapter, u8 mmd, u16 addr)
+{
+	u32 mmd_access;
+	int ret;
+	u32 val;
+
+	if (mmd > 31) {
+		netif_err(adapter, probe, adapter->netdev,
+			  "%s mmd should <= 31\n", __func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&adapter->sgmii_rw_lock);
+	/* Load Register Address */
+	mmd_access = mmd << SGMII_ACC_SGMII_MMD_SHIFT_;
+	mmd_access |= (addr | SGMII_ACC_SGMII_BZY_);
+	lan743x_csr_write(adapter, SGMII_ACC, mmd_access);
+	ret = lan743x_sgmii_wait_till_not_busy(adapter);
+	if (ret < 0)
+		goto sgmii_unlock;
+
+	val = lan743x_csr_read(adapter, SGMII_DATA);
+	ret = (int)(val & SGMII_DATA_MASK_);
+
+sgmii_unlock:
+	mutex_unlock(&adapter->sgmii_rw_lock);
+
+	return ret;
+}
+
+static int lan743x_sgmii_write(struct lan743x_adapter *adapter,
+			       u8 mmd, u16 addr, u16 val)
+{
+	u32 mmd_access;
+	int ret;
+
+	if (mmd > 31) {
+		netif_err(adapter, probe, adapter->netdev,
+			  "%s mmd should <= 31\n", __func__);
+		return -EINVAL;
+	}
+	mutex_lock(&adapter->sgmii_rw_lock);
+	/* Load Register Data */
+	lan743x_csr_write(adapter, SGMII_DATA, (u32)(val & SGMII_DATA_MASK_));
+	/* Load Register Address */
+	mmd_access = mmd << SGMII_ACC_SGMII_MMD_SHIFT_;
+	mmd_access |= (addr | SGMII_ACC_SGMII_BZY_ | SGMII_ACC_SGMII_WR_);
+	lan743x_csr_write(adapter, SGMII_ACC, mmd_access);
+	ret = lan743x_sgmii_wait_till_not_busy(adapter);
+	mutex_unlock(&adapter->sgmii_rw_lock);
+
+	return ret;
+}
+
 static void lan743x_mac_set_address(struct lan743x_adapter *adapter,
 				    u8 *addr)
 {
@@ -2875,6 +2943,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 		adapter->max_vector_count = PCI11X1X_MAX_VECTOR_COUNT;
 		pci11x1x_strap_get_status(adapter);
 		spin_lock_init(&adapter->eth_syslock_spinlock);
+		mutex_init(&adapter->sgmii_rw_lock);
 	} else {
 		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = LAN743X_USED_TX_CHANNELS;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 5d37263b25c8..4268b1d56090 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -288,6 +288,17 @@
 
 #define MAC_WUCSR2			(0x600)
 
+#define SGMII_ACC			(0x720)
+#define SGMII_ACC_SGMII_BZY_		BIT(31)
+#define SGMII_ACC_SGMII_WR_		BIT(30)
+#define SGMII_ACC_SGMII_MMD_SHIFT_	(16)
+#define SGMII_ACC_SGMII_MMD_MASK_	GENMASK(20, 16)
+#define SGMII_ACC_SGMII_MMD_VSR_	BIT(15)
+#define SGMII_ACC_SGMII_ADDR_SHIFT_	(0)
+#define SGMII_ACC_SGMII_ADDR_MASK_	GENMASK(15, 0)
+#define SGMII_DATA			(0x724)
+#define SGMII_DATA_SHIFT_		(0)
+#define SGMII_DATA_MASK_		GENMASK(15, 0)
 #define SGMII_CTL			(0x728)
 #define SGMII_CTL_SGMII_ENABLE_		BIT(31)
 #define SGMII_CTL_LINK_STATUS_SOURCE_	BIT(8)
@@ -940,6 +951,7 @@ struct lan743x_adapter {
 	spinlock_t		eth_syslock_spinlock;
 	bool			eth_syslock_en;
 	u32			eth_syslock_acquire_cnt;
+	struct mutex		sgmii_rw_lock;
 	u8			max_tx_channels;
 	u8			used_tx_channels;
 	u8			max_vector_count;
-- 
2.25.1

