Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261E54B3619
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 16:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbiBLPyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 10:54:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiBLPyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 10:54:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1715BB9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 07:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644681237; x=1676217237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8vqGicj7zfVebLekovN7cQkuZZJ1uhyh2QzhEZxgwsM=;
  b=fiIypdS4UwPGX/YdJ3FVs2ox7TomLb+yX90P4ZpR3YzAt2Iuy6H/pzlp
   34OzwGbPZsPUC8Zu98CA9HqYD19+kPQdwpQ29IYG097JQfpSIWBJrKzGY
   YNHGpu1T3SNiYETRvTQpAgz6EkTcXT565rb2bw//0t8wIdSVMtbyiReEw
   Fr9HeIK+jsKFQL6I3WMXfGskUjiiQSaJlaKjnS8mpyJlXLqJd7bqfFKRd
   Gtp41UMOG+70vDAs0cJLCqz+c6TUl7IsK7wfrErYzkkJwvAYQodiSP1ia
   EPwQLnkHc5wVnBa3HCLvOcpw6rZuHzbCqvN7YL1DARQqNFjyrEfkDltgx
   g==;
IronPort-SDR: flMxT2nOxWWwidYFgOn2aqnashi5dtc69LhUPFUSTRfTK3vjtPt9+1vyd3H+zKyWDi5uX3veFz
 CmAo0z6DyzVINuuBKO//8spBrvNylHg/eAZSE0bMZBKCBP36GmgLhIT7VCn6LRJtGqLxusuvMm
 EFO6yJFgJA5HXW0Kkf+ufeLUan+eX6Hjr8Msb0T54TkhhzHovx1C0ssrESjNsDWMjHU8uGGxgV
 GckywL3Gfj3ek6a0dLRxcvmfzjQ2bJrgBJAfvE4pHh/fmO+CZDVE3a0WZjYmUW+5x2fYSBMeK0
 us8STZk9kc+A2mjdAT4gxSUT
X-IronPort-AV: E=Sophos;i="5.88,363,1635231600"; 
   d="scan'208";a="152858649"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2022 08:53:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Feb 2022 08:53:28 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 12 Feb 2022 08:53:25 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next V1 2/5] net: lan743x: Add support for 4 Tx queues
Date:   Sat, 12 Feb 2022 21:23:12 +0530
Message-ID: <20220212155315.340359-3-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
References: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 4 Tx queues

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
  V1: 1. Correct the device name
      2. use "used_tx_channels" instead of "max_used_tx_channels"
      3. Based on review comments, optimise the code

 drivers/net/ethernet/microchip/lan743x_main.c | 83 +++++++++++++++----
 drivers/net/ethernet/microchip/lan743x_main.h | 12 ++-
 drivers/net/ethernet/microchip/lan743x_ptp.c  |  8 +-
 3 files changed, 79 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 5c0ef33a61d5..dc5f77bb525e 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -18,6 +18,18 @@
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
 
+static bool is_pci11x1x_chip(struct lan743x_adapter *adapter)
+{
+	struct lan743x_csr *csr = &adapter->csr;
+	u32 id_rev = csr->id_rev;
+
+	if (((id_rev & 0xFFFF0000) == ID_REV_ID_A011_) ||
+	    ((id_rev & 0xFFFF0000) == ID_REV_ID_A041_)) {
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
+		for (channel = 0; channel < adapter->used_tx_channels;
 			channel++) {
 			u32 int_bit = INT_BIT_DMA_TX_(channel);
 
@@ -447,6 +459,7 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 {
 	struct msix_entry msix_entries[LAN743X_MAX_VECTOR_COUNT];
 	struct lan743x_intr *intr = &adapter->intr;
+	unsigned int used_tx_channels;
 	u32 int_vec_en_auto_clr = 0;
 	u32 int_vec_map0 = 0;
 	u32 int_vec_map1 = 0;
@@ -461,9 +474,10 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 	       sizeof(struct msix_entry) * LAN743X_MAX_VECTOR_COUNT);
 	for (index = 0; index < LAN743X_MAX_VECTOR_COUNT; index++)
 		msix_entries[index].entry = index;
+	used_tx_channels = adapter->used_tx_channels;
 	ret = pci_enable_msix_range(adapter->pdev,
 				    msix_entries, 1,
-				    1 + LAN743X_USED_TX_CHANNELS +
+				    1 + used_tx_channels +
 				    LAN743X_USED_RX_CHANNELS);
 
 	if (ret > 0) {
@@ -570,8 +584,8 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 	if (intr->number_of_vectors > 1) {
 		int number_of_tx_vectors = intr->number_of_vectors - 1;
 
-		if (number_of_tx_vectors > LAN743X_USED_TX_CHANNELS)
-			number_of_tx_vectors = LAN743X_USED_TX_CHANNELS;
+		if (number_of_tx_vectors > used_tx_channels)
+			number_of_tx_vectors = used_tx_channels;
 		flags = LAN743X_VECTOR_FLAG_SOURCE_STATUS_READ |
 			LAN743X_VECTOR_FLAG_SOURCE_STATUS_W2C |
 			LAN743X_VECTOR_FLAG_SOURCE_ENABLE_CHECK |
@@ -609,9 +623,9 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 						  INT_VEC_EN_(vector));
 		}
 	}
-	if ((intr->number_of_vectors - LAN743X_USED_TX_CHANNELS) > 1) {
+	if ((intr->number_of_vectors - used_tx_channels) > 1) {
 		int number_of_rx_vectors = intr->number_of_vectors -
-					   LAN743X_USED_TX_CHANNELS - 1;
+						used_tx_channels - 1;
 
 		if (number_of_rx_vectors > LAN743X_USED_RX_CHANNELS)
 			number_of_rx_vectors = LAN743X_USED_RX_CHANNELS;
@@ -2491,7 +2505,8 @@ static int lan743x_netdev_close(struct net_device *netdev)
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 	int index;
 
-	lan743x_tx_close(&adapter->tx[0]);
+	for (index = 0; index < adapter->used_tx_channels; index++)
+		lan743x_tx_close(&adapter->tx[index]);
 
 	for (index = 0; index < LAN743X_USED_RX_CHANNELS; index++)
 		lan743x_rx_close(&adapter->rx[index]);
@@ -2537,12 +2552,19 @@ static int lan743x_netdev_open(struct net_device *netdev)
 			goto close_rx;
 	}
 
-	ret = lan743x_tx_open(&adapter->tx[0]);
-	if (ret)
-		goto close_rx;
-
+	for (index = 0; index < adapter->used_tx_channels; index++) {
+		ret = lan743x_tx_open(&adapter->tx[index]);
+		if (ret)
+			goto close_tx;
+	}
 	return 0;
 
+close_tx:
+	for (index = 0; index < adapter->used_tx_channels; index++) {
+		if (adapter->tx[index].ring_cpu_ptr)
+			lan743x_tx_close(&adapter->tx[index]);
+	}
+
 close_rx:
 	for (index = 0; index < LAN743X_USED_RX_CHANNELS; index++) {
 		if (adapter->rx[index].ring_cpu_ptr)
@@ -2569,8 +2591,12 @@ static netdev_tx_t lan743x_netdev_xmit_frame(struct sk_buff *skb,
 					     struct net_device *netdev)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	u8 ch = 0;
+
+	if (adapter->is_pci11x1x)
+		ch = skb->queue_mapping % PCI11X1X_USED_TX_CHANNELS;
 
-	return lan743x_tx_xmit_frame(&adapter->tx[0], skb);
+	return lan743x_tx_xmit_frame(&adapter->tx[ch], skb);
 }
 
 static int lan743x_netdev_ioctl(struct net_device *netdev,
@@ -2701,6 +2727,15 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 	int index;
 	int ret;
 
+	adapter->is_pci11x1x = is_pci11x1x_chip(adapter);
+	if (adapter->is_pci11x1x) {
+		adapter->max_tx_channels = PCI11X1X_MAX_TX_CHANNELS;
+		adapter->used_tx_channels = PCI11X1X_USED_TX_CHANNELS;
+	} else {
+		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
+		adapter->used_tx_channels = LAN743X_USED_TX_CHANNELS;
+	}
+
 	adapter->intr.irq = adapter->pdev->irq;
 	lan743x_csr_write(adapter, INT_EN_CLR, 0xFFFFFFFF);
 
@@ -2731,10 +2766,13 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 		adapter->rx[index].channel_number = index;
 	}
 
-	tx = &adapter->tx[0];
-	tx->adapter = adapter;
-	tx->channel_number = 0;
-	spin_lock_init(&tx->ring_lock);
+	for (index = 0; index < adapter->used_tx_channels; index++) {
+		tx = &adapter->tx[index];
+		tx->adapter = adapter;
+		tx->channel_number = index;
+		spin_lock_init(&tx->ring_lock);
+	}
+
 	return 0;
 }
 
@@ -2786,8 +2824,17 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 	struct net_device *netdev = NULL;
 	int ret = -ENODEV;
 
-	netdev = devm_alloc_etherdev(&pdev->dev,
-				     sizeof(struct lan743x_adapter));
+	if (id->device == PCI_DEVICE_ID_SMSC_A011 ||
+	    id->device == PCI_DEVICE_ID_SMSC_A041) {
+		netdev = devm_alloc_etherdev_mqs(&pdev->dev,
+						 sizeof(struct lan743x_adapter),
+						 PCI11X1X_USED_TX_CHANNELS,
+						 LAN743X_USED_RX_CHANNELS);
+	} else {
+		netdev = devm_alloc_etherdev(&pdev->dev,
+					     sizeof(struct lan743x_adapter));
+	}
+
 	if (!netdev)
 		goto return_error;
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 0143ac327d2b..f2fa33357c17 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -546,10 +546,12 @@
 
 #define LAN743X_MAX_RX_CHANNELS		(4)
 #define LAN743X_MAX_TX_CHANNELS		(1)
+#define PCI11X1X_MAX_TX_CHANNELS	(4)
 struct lan743x_adapter;
 
 #define LAN743X_USED_RX_CHANNELS	(4)
 #define LAN743X_USED_TX_CHANNELS	(1)
+#define PCI11X1X_USED_TX_CHANNELS	(4)
 #define LAN743X_INT_MOD	(400)
 
 #if (LAN743X_USED_RX_CHANNELS > LAN743X_MAX_RX_CHANNELS)
@@ -558,6 +560,9 @@ struct lan743x_adapter;
 #if (LAN743X_USED_TX_CHANNELS > LAN743X_MAX_TX_CHANNELS)
 #error Invalid LAN743X_USED_TX_CHANNELS
 #endif
+#if (PCI11X1X_USED_TX_CHANNELS > PCI11X1X_MAX_TX_CHANNELS)
+#error Invalid PCI11X1X_USED_TX_CHANNELS
+#endif
 
 /* PCI */
 /* SMSC acquired EFAR late 1990's, MCHP acquired SMSC 2012 */
@@ -728,8 +733,11 @@ struct lan743x_adapter {
 	u8			mac_address[ETH_ALEN];
 
 	struct lan743x_phy      phy;
-	struct lan743x_tx       tx[LAN743X_MAX_TX_CHANNELS];
-	struct lan743x_rx       rx[LAN743X_MAX_RX_CHANNELS];
+	struct lan743x_tx       tx[PCI11X1X_USED_TX_CHANNELS];
+	struct lan743x_rx       rx[LAN743X_USED_RX_CHANNELS];
+	bool			is_pci11x1x;
+	u8			max_tx_channels;
+	u8			used_tx_channels;
 
 #define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
 	u32			flags;
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 8b7a8d879083..ec082594bbbd 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -1307,21 +1307,21 @@ int lan743x_ptp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
-		for (index = 0; index < LAN743X_MAX_TX_CHANNELS;
-			index++)
+		for (index = 0; index < adapter->used_tx_channels;
+		     index++)
 			lan743x_tx_set_timestamping_mode(&adapter->tx[index],
 							 false, false);
 		lan743x_ptp_set_sync_ts_insert(adapter, false);
 		break;
 	case HWTSTAMP_TX_ON:
-		for (index = 0; index < LAN743X_MAX_TX_CHANNELS;
+		for (index = 0; index < adapter->used_tx_channels;
 			index++)
 			lan743x_tx_set_timestamping_mode(&adapter->tx[index],
 							 true, false);
 		lan743x_ptp_set_sync_ts_insert(adapter, false);
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
-		for (index = 0; index < LAN743X_MAX_TX_CHANNELS;
+		for (index = 0; index < adapter->used_tx_channels;
 			index++)
 			lan743x_tx_set_timestamping_mode(&adapter->tx[index],
 							 true, true);
-- 
2.25.1

