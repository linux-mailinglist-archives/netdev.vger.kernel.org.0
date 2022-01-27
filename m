Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202A649E908
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbiA0RbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:31:08 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:32122 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241602AbiA0RbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643304667; x=1674840667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XvwmIP89LS3O/UopTr9pAPqkBncFWKxPM5cMEZS0mhY=;
  b=mAmIIlJ6FDKI1GBldKctFYVN2YWXP9ZoAUhIpET1hORuUIGUmrg8d6ow
   ZhNpPrAvibCMHy8MIV8Abjk8eHCSWJce/A5XiAf0niTtHqqlrDPmSa3VV
   glSea23tJ9VoEcl/8q9py70KNGdaA3lVC9UAqcX0yyNzc2rjLN8fnolDK
   lNWbFKeucUHxgcBniim8J6/lVzx4Z5d22yWrU3FqNDP50rlsKrgcFmTqz
   lc/CCxKhhOwvjALam23sszK2ptQxe5kYXGMibH5Vr1zg9o2mGo8tmR6UN
   PX3tmzqKZ+gwR7lPLdnrkVre10jcI3UaHeYP5Nhfy2Xn5tgEesRJkfUkY
   w==;
IronPort-SDR: wMYHqoiHhZlXkl6O+sqJ3PTbhx8AEaDr4moRwQiwjQ4oHJ9I2VQgjlY0YWStWRWS4kd17jXYp2
 YskfnK/g1jt7y8Sa6tbwhqFWsceLtaFB9On7btcf5nMwi8/cjimAJiFwXWOrKlqLe2Gc8Lm5dp
 tgPVNPVTRpYDURV37t5LEvg4s0yUGg0ugEkJyYBpWhKbA6TNK90YYwywRgqE4rb07dtFZW3ChU
 /u/UFA3O2vVlVAXo2Bni3/hUBRxLf1H+W+0n+FScg9UvEvY/CyiyA2A9W81x6xUcwpjEROEXLK
 C5591adnU0V+eUqEftxv5atU
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="144113622"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 10:31:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 10:31:07 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 10:31:04 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 2/5] net: lan743x: Add Tx 4 Queue enhancements
Date:   Thu, 27 Jan 2022 23:00:52 +0530
Message-ID: <20220127173055.308918-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI1A011/PCI1A041 chip support the 4 Tx Queues

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 85 +++++++++++++++----
 drivers/net/ethernet/microchip/lan743x_main.h | 10 ++-
 drivers/net/ethernet/microchip/lan743x_ptp.c  |  8 +-
 3 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 49eeff8757e5..ce97c8ce8b1c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -18,6 +18,18 @@
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
 
+static bool is_pcia0x1_chip(struct lan743x_adapter *adapter)
+{
+	struct lan743x_csr *csr = &adapter->csr;
+	u32 id_rev = csr->id_rev;
+
+	if (((id_rev & 0xFFFF0000) == ID_REV_ID_PCIA011_) ||
+	    ((id_rev & 0xFFFF0000) == ID_REV_ID_PCIA041_)) {
+		return true;
+	}
+	return false;
+}
+
 static void lan743x_pci_cleanup(struct lan743x_adapter *adapter)
 {
 	pci_release_selected_regions(adapter->pdev,
@@ -250,7 +262,7 @@ static void lan743x_intr_shared_isr(void *context, u32 int_sts, u32 flags)
 		}
 	}
 	if (int_sts & INT_BIT_ALL_TX_) {
-		for (channel = 0; channel < LAN743X_USED_TX_CHANNELS;
+		for (channel = 0; channel < adapter->max_used_tx_channels;
 			channel++) {
 			u32 int_bit = INT_BIT_DMA_TX_(channel);
 
@@ -447,6 +459,7 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 {
 	struct msix_entry msix_entries[LAN743X_MAX_VECTOR_COUNT];
 	struct lan743x_intr *intr = &adapter->intr;
+	unsigned int max_used_tx_channels;
 	u32 int_vec_en_auto_clr = 0;
 	u32 int_vec_map0 = 0;
 	u32 int_vec_map1 = 0;
@@ -461,9 +474,10 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 	       sizeof(struct msix_entry) * LAN743X_MAX_VECTOR_COUNT);
 	for (index = 0; index < LAN743X_MAX_VECTOR_COUNT; index++)
 		msix_entries[index].entry = index;
+	max_used_tx_channels = adapter->max_used_tx_channels;
 	ret = pci_enable_msix_range(adapter->pdev,
 				    msix_entries, 1,
-				    1 + LAN743X_USED_TX_CHANNELS +
+				    1 + max_used_tx_channels +
 				    LAN743X_USED_RX_CHANNELS);
 
 	if (ret > 0) {
@@ -570,8 +584,8 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 	if (intr->number_of_vectors > 1) {
 		int number_of_tx_vectors = intr->number_of_vectors - 1;
 
-		if (number_of_tx_vectors > LAN743X_USED_TX_CHANNELS)
-			number_of_tx_vectors = LAN743X_USED_TX_CHANNELS;
+		if (number_of_tx_vectors > max_used_tx_channels)
+			number_of_tx_vectors = max_used_tx_channels;
 		flags = LAN743X_VECTOR_FLAG_SOURCE_STATUS_READ |
 			LAN743X_VECTOR_FLAG_SOURCE_STATUS_W2C |
 			LAN743X_VECTOR_FLAG_SOURCE_ENABLE_CHECK |
@@ -609,9 +623,9 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 						  INT_VEC_EN_(vector));
 		}
 	}
-	if ((intr->number_of_vectors - LAN743X_USED_TX_CHANNELS) > 1) {
+	if ((intr->number_of_vectors - max_used_tx_channels) > 1) {
 		int number_of_rx_vectors = intr->number_of_vectors -
-					   LAN743X_USED_TX_CHANNELS - 1;
+						max_used_tx_channels - 1;
 
 		if (number_of_rx_vectors > LAN743X_USED_RX_CHANNELS)
 			number_of_rx_vectors = LAN743X_USED_RX_CHANNELS;
@@ -2489,9 +2503,12 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
 static int lan743x_netdev_close(struct net_device *netdev)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	unsigned int max_used_tx_channels;
 	int index;
 
-	lan743x_tx_close(&adapter->tx[0]);
+	max_used_tx_channels = adapter->max_used_tx_channels;
+	for (index = 0; index < max_used_tx_channels; index++)
+		lan743x_tx_close(&adapter->tx[index]);
 
 	for (index = 0; index < LAN743X_USED_RX_CHANNELS; index++)
 		lan743x_rx_close(&adapter->rx[index]);
@@ -2537,12 +2554,19 @@ static int lan743x_netdev_open(struct net_device *netdev)
 			goto close_rx;
 	}
 
-	ret = lan743x_tx_open(&adapter->tx[0]);
-	if (ret)
-		goto close_rx;
-
+	for (index = 0; index < adapter->max_used_tx_channels; index++) {
+		ret = lan743x_tx_open(&adapter->tx[index]);
+		if (ret)
+			goto close_tx;
+	}
 	return 0;
 
+close_tx:
+	for (index = 0; index < adapter->max_used_tx_channels; index++) {
+		if (adapter->tx[index].ring_cpu_ptr)
+			lan743x_tx_close(&adapter->tx[index]);
+	}
+
 close_rx:
 	for (index = 0; index < LAN743X_USED_RX_CHANNELS; index++) {
 		if (adapter->rx[index].ring_cpu_ptr)
@@ -2569,8 +2593,12 @@ static netdev_tx_t lan743x_netdev_xmit_frame(struct sk_buff *skb,
 					     struct net_device *netdev)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	u8 ch = 0;
+
+	if (adapter->is_pcia0x1)
+		ch = skb->queue_mapping % PCIA0X1_MAX_TX_CHANNELS;
 
-	return lan743x_tx_xmit_frame(&adapter->tx[0], skb);
+	return lan743x_tx_xmit_frame(&adapter->tx[ch], skb);
 }
 
 static int lan743x_netdev_ioctl(struct net_device *netdev,
@@ -2701,6 +2729,15 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 	int index;
 	int ret;
 
+	adapter->is_pcia0x1 = is_pcia0x1_chip(adapter);
+	if (adapter->is_pcia0x1) {
+		adapter->max_tx_channels = PCIA0X1_MAX_TX_CHANNELS;
+		adapter->max_used_tx_channels = PCIA0X1_USED_TX_CHANNELS;
+	} else {
+		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
+		adapter->max_used_tx_channels = LAN743X_USED_TX_CHANNELS;
+	}
+
 	adapter->intr.irq = adapter->pdev->irq;
 	lan743x_csr_write(adapter, INT_EN_CLR, 0xFFFFFFFF);
 
@@ -2731,10 +2768,13 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 		adapter->rx[index].channel_number = index;
 	}
 
-	tx = &adapter->tx[0];
-	tx->adapter = adapter;
-	tx->channel_number = 0;
-	spin_lock_init(&tx->ring_lock);
+	for (index = 0; index < adapter->max_used_tx_channels; index++) {
+		tx = &adapter->tx[index];
+		tx->adapter = adapter;
+		tx->channel_number = index;
+		spin_lock_init(&tx->ring_lock);
+	}
+
 	return 0;
 }
 
@@ -2790,8 +2830,17 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 	struct net_device *netdev = NULL;
 	int ret = -ENODEV;
 
-	netdev = devm_alloc_etherdev(&pdev->dev,
-				     sizeof(struct lan743x_adapter));
+	if ((id->device == (ID_REV_ID_PCIA011_ >> 16)) ||
+	    (id->device == (ID_REV_ID_PCIA041_ >> 16))) {
+		netdev = devm_alloc_etherdev_mqs(&pdev->dev,
+						 sizeof(struct lan743x_adapter),
+						 PCIA0X1_MAX_TX_CHANNELS,
+						 LAN743X_MAX_RX_CHANNELS);
+	} else {
+		netdev = devm_alloc_etherdev(&pdev->dev,
+					     sizeof(struct lan743x_adapter));
+	}
+
 	if (!netdev)
 		goto return_error;
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index a9d722f719f9..d7b1b5e44518 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -545,10 +545,12 @@
 
 #define LAN743X_MAX_RX_CHANNELS		(4)
 #define LAN743X_MAX_TX_CHANNELS		(1)
+#define PCIA0X1_MAX_TX_CHANNELS		(4)
 struct lan743x_adapter;
 
 #define LAN743X_USED_RX_CHANNELS	(4)
 #define LAN743X_USED_TX_CHANNELS	(1)
+#define PCIA0X1_USED_TX_CHANNELS	(4)
 #define LAN743X_INT_MOD	(400)
 
 #if (LAN743X_USED_RX_CHANNELS > LAN743X_MAX_RX_CHANNELS)
@@ -557,6 +559,9 @@ struct lan743x_adapter;
 #if (LAN743X_USED_TX_CHANNELS > LAN743X_MAX_TX_CHANNELS)
 #error Invalid LAN743X_USED_TX_CHANNELS
 #endif
+#if (PCIA0X1_USED_TX_CHANNELS > PCIA0X1_MAX_TX_CHANNELS)
+#error Invalid PCIA0X1_USED_TX_CHANNELS
+#endif
 
 /* PCI */
 /* SMSC acquired EFAR late 1990's, MCHP acquired SMSC 2012 */
@@ -727,8 +732,11 @@ struct lan743x_adapter {
 	u8			mac_address[ETH_ALEN];
 
 	struct lan743x_phy      phy;
-	struct lan743x_tx       tx[LAN743X_MAX_TX_CHANNELS];
+	struct lan743x_tx       tx[PCIA0X1_MAX_TX_CHANNELS];
 	struct lan743x_rx       rx[LAN743X_MAX_RX_CHANNELS];
+	bool			is_pcia0x1;
+	u8			max_tx_channels;
+	u8			max_used_tx_channels;
 
 #define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
 	u32			flags;
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 8b7a8d879083..e0e8bc352134 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -1307,21 +1307,21 @@ int lan743x_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
-		for (index = 0; index < LAN743X_MAX_TX_CHANNELS;
-			index++)
+		for (index = 0; index < adapter->max_tx_channels;
+		     index++)
 			lan743x_tx_set_timestamping_mode(&adapter->tx[index],
 							 false, false);
 		lan743x_ptp_set_sync_ts_insert(adapter, false);
 		break;
 	case HWTSTAMP_TX_ON:
-		for (index = 0; index < LAN743X_MAX_TX_CHANNELS;
+		for (index = 0; index < adapter->max_tx_channels;
 			index++)
 			lan743x_tx_set_timestamping_mode(&adapter->tx[index],
 							 true, false);
 		lan743x_ptp_set_sync_ts_insert(adapter, false);
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
-		for (index = 0; index < LAN743X_MAX_TX_CHANNELS;
+		for (index = 0; index < adapter->max_tx_channels;
 			index++)
 			lan743x_tx_set_timestamping_mode(&adapter->tx[index],
 							 true, true);
-- 
2.25.1

