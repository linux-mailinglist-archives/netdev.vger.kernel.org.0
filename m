Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BE849E909
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbiA0RbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:31:12 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:57213 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244590AbiA0RbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:31:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643304670; x=1674840670;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cpRZx4IhilKUxpJCI7B+EuOwwo+7TJWxSBDt/W0BKgg=;
  b=w0Vd01bhD20BKUexsA7kKmTO8loFpGJ1OBlIH1ZLsySYxUlucwpVn8UT
   DaqBUxUKGlO03OTgPwsIS8Xo1uIivRM4E+xoxadR5YjOw41ptCWXaQVfb
   Gm3wF7W27Fb8DSWR9ZdIKGDiZbIdwBh6qxPdMqlvSgpduw7DchUSLZxY/
   K1Bvkxgi3RxeWxUfZ7Rwhs/q/5gsXP8cJZF+3uADWmhRzq8QIbkTosO6Z
   OGs+gTxlXI3+OJUtZaNHbIVc8uWHMXyrouaQVQpy2El1zI7Dp6p+MqF/a
   qA2EDlJ46FUO1fGJILi/2pzm8i1reaGY4LT8wVyt8lq+2CPr+5r9dJOjY
   w==;
IronPort-SDR: zlqQ+i5xDQ8FnkDqLr4manO2VBo3p6Ex3/Ed7nZ2311ExjsFRrBc6o7uYfS3k+fhs8XqdjXx5I
 F82wcDmHM/vKWB/J6bJ9i2+kr8Ip8+wvf6IvSgTXt9yLWfwpuVsKdsoYOTg95T2h3uRVT1ez6Z
 8KE5pWX4x71GN7v8gXr+ajycy5W7zJqJoextV+IhN9iwM943vd0lyimfhGMSG2JL0AboLlGxOv
 U29xiYDjbGWzeed3hAVINYgO9XR+eYzs85UNMCzv/WNKCcX5fJPHVyEEpou+je8ZByhq2dN5fJ
 smkNMWCryBuJKIUzJmAvQFR0
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="83901379"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 10:31:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 10:31:09 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 10:31:07 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 3/5] net: lan743x: Add MSI-X interrupts increased from 8 to 16 and Interrupt De-assertion timers increased from 8 to 16
Date:   Thu, 27 Jan 2022 23:00:53 +0530
Message-ID: <20220127173055.308918-4-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI1A011/PCI1A041 support upto 16 MSI-X interrupts and 16 De-assertion timers

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 37 +++++++++++++++----
 drivers/net/ethernet/microchip/lan743x_main.h |  6 ++-
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index ce97c8ce8b1c..daba17b0ad6c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -422,7 +422,7 @@ static u32 lan743x_intr_get_vector_flags(struct lan743x_adapter *adapter,
 {
 	int index;
 
-	for (index = 0; index < LAN743X_MAX_VECTOR_COUNT; index++) {
+	for (index = 0; index < adapter->max_vector_counter; index++) {
 		if (adapter->intr.vector_list[index].int_mask & int_mask)
 			return adapter->intr.vector_list[index].flags;
 	}
@@ -435,9 +435,12 @@ static void lan743x_intr_close(struct lan743x_adapter *adapter)
 	int index = 0;
 
 	lan743x_csr_write(adapter, INT_EN_CLR, INT_BIT_MAS_);
-	lan743x_csr_write(adapter, INT_VEC_EN_CLR, 0x000000FF);
+	if (adapter->is_pcia0x1)
+		lan743x_csr_write(adapter, INT_VEC_EN_CLR, 0x0000FFFF);
+	else
+		lan743x_csr_write(adapter, INT_VEC_EN_CLR, 0x000000FF);
 
-	for (index = 0; index < LAN743X_MAX_VECTOR_COUNT; index++) {
+	for (index = 0; index < intr->number_of_vectors; index++) {
 		if (intr->flags & INTR_FLAG_IRQ_REQUESTED(index)) {
 			lan743x_intr_unregister_isr(adapter, index);
 			intr->flags &= ~INTR_FLAG_IRQ_REQUESTED(index);
@@ -457,10 +460,11 @@ static void lan743x_intr_close(struct lan743x_adapter *adapter)
 
 static int lan743x_intr_open(struct lan743x_adapter *adapter)
 {
-	struct msix_entry msix_entries[LAN743X_MAX_VECTOR_COUNT];
+	struct msix_entry msix_entries[PCIA0X1_MAX_VECTOR_COUNT];
 	struct lan743x_intr *intr = &adapter->intr;
 	unsigned int max_used_tx_channels;
 	u32 int_vec_en_auto_clr = 0;
+	u8 max_vector_counter;
 	u32 int_vec_map0 = 0;
 	u32 int_vec_map1 = 0;
 	int ret = -ENODEV;
@@ -470,9 +474,10 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 	intr->number_of_vectors = 0;
 
 	/* Try to set up MSIX interrupts */
+	max_vector_counter = adapter->max_vector_counter;
 	memset(&msix_entries[0], 0,
-	       sizeof(struct msix_entry) * LAN743X_MAX_VECTOR_COUNT);
-	for (index = 0; index < LAN743X_MAX_VECTOR_COUNT; index++)
+	       sizeof(struct msix_entry) * max_vector_counter);
+	for (index = 0; index < max_vector_counter; index++)
 		msix_entries[index].entry = index;
 	max_used_tx_channels = adapter->max_used_tx_channels;
 	ret = pci_enable_msix_range(adapter->pdev,
@@ -561,7 +566,21 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 		lan743x_csr_write(adapter, INT_VEC_EN_SET,
 				  INT_VEC_EN_(0));
 
-	if (!(adapter->csr.flags & LAN743X_CSR_FLAG_IS_A0)) {
+	if (adapter->is_pcia0x1) {
+		lan743x_csr_write(adapter, INT_MOD_CFG0, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG1, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG2, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG3, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG4, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG5, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG6, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG7, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG8, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_CFG9, LAN743X_INT_MOD);
+		lan743x_csr_write(adapter, INT_MOD_MAP0, 0x00008765);
+		lan743x_csr_write(adapter, INT_MOD_MAP1, 0x00004321);
+		lan743x_csr_write(adapter, INT_MOD_MAP2, 0x00FFFFFF);
+	} else if (!(adapter->csr.flags & LAN743X_CSR_FLAG_IS_A0)) {
 		lan743x_csr_write(adapter, INT_MOD_CFG0, LAN743X_INT_MOD);
 		lan743x_csr_write(adapter, INT_MOD_CFG1, LAN743X_INT_MOD);
 		lan743x_csr_write(adapter, INT_MOD_CFG2, LAN743X_INT_MOD);
@@ -646,7 +665,7 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 				LAN743X_VECTOR_FLAG_SOURCE_STATUS_AUTO_CLEAR;
 		}
 		for (index = 0; index < number_of_rx_vectors; index++) {
-			int vector = index + 1 + LAN743X_USED_TX_CHANNELS;
+			int vector = index + 1 + max_used_tx_channels;
 			u32 int_bit = INT_BIT_DMA_RX_(index);
 
 			/* map RX interrupt to vector */
@@ -2733,9 +2752,11 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 	if (adapter->is_pcia0x1) {
 		adapter->max_tx_channels = PCIA0X1_MAX_TX_CHANNELS;
 		adapter->max_used_tx_channels = PCIA0X1_USED_TX_CHANNELS;
+		adapter->max_vector_counter = PCIA0X1_MAX_VECTOR_COUNT;
 	} else {
 		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
 		adapter->max_used_tx_channels = LAN743X_USED_TX_CHANNELS;
+		adapter->max_vector_counter = LAN743X_MAX_VECTOR_COUNT;
 	}
 
 	adapter->intr.irq = adapter->pdev->irq;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index d7b1b5e44518..9c6bb8be2013 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -265,6 +265,8 @@
 #define INT_MOD_CFG5			(0x7D4)
 #define INT_MOD_CFG6			(0x7D8)
 #define INT_MOD_CFG7			(0x7DC)
+#define INT_MOD_CFG8			(0x7E0)
+#define INT_MOD_CFG9			(0x7E4)
 
 #define PTP_CMD_CTL					(0x0A00)
 #define PTP_CMD_CTL_PTP_CLK_STP_NSEC_			BIT(6)
@@ -618,13 +620,14 @@ struct lan743x_vector {
 };
 
 #define LAN743X_MAX_VECTOR_COUNT	(8)
+#define PCIA0X1_MAX_VECTOR_COUNT	(16)
 
 struct lan743x_intr {
 	int			flags;
 
 	unsigned int		irq;
 
-	struct lan743x_vector	vector_list[LAN743X_MAX_VECTOR_COUNT];
+	struct lan743x_vector	vector_list[PCIA0X1_MAX_VECTOR_COUNT];
 	int			number_of_vectors;
 	bool			using_vectors;
 
@@ -737,6 +740,7 @@ struct lan743x_adapter {
 	bool			is_pcia0x1;
 	u8			max_tx_channels;
 	u8			max_used_tx_channels;
+	u8			max_vector_counter;
 
 #define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
 	u32			flags;
-- 
2.25.1

