Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5201E5AFC70
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiIGGeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIGGeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:34:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2EA9F753;
        Tue,  6 Sep 2022 23:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662532440; x=1694068440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dFZX0qK6MTt2A3mkxGb+9auzFgdBy2ny1iBzIgzmkck=;
  b=ADJD/ke5c40cbZKvJqgDhaTqxm2OVymIKyIvz9tKE1Dbuj79oU3jOsbp
   xsfmzix7QXSH12tg5KG1FpyeGQ8xVracHw+CGI3prl/UkNIcr8qOjMZYz
   WMzIuFvVx/7Q33dccy7MMl1W1B//mUEwT7El19CzGIYLtKWIrkybzmiZ4
   Bmj3wcekO26xw1lZMXR8pWzZNJvmdXHKVx6dW+pyUYmKuwIFWxiDzK1UU
   DzgUeBvqL/Uts2GKXNmBDdH87G6HLFFchu20vrNBAtQ/cFj6ZcT2+z4Vy
   zP9ihFx/8/YItZVKL1v8f+APBX+YYjuhtLA28NHN1184u7H4jf6ijdVZr
   A==;
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="172707303"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2022 23:33:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Sep 2022 23:33:57 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Sep 2022 23:33:54 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 1/2] net: lan743x: Fix to use multiqueue start/stop APIs
Date:   Wed, 7 Sep 2022 11:51:26 +0530
Message-ID: <20220907062127.15473-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220907062127.15473-1-Raju.Lakkaraju@microchip.com>
References: <20220907062127.15473-1-Raju.Lakkaraju@microchip.com>
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

- Fix to use multiqueue start/stop APIs
- Change to return NETDEV_TX_BUSY instead of holding the TX skb when busy
- Increase Tx ring size to 128 to address performance issues in some platforms
- Use NAPI_POLL_WEIGHT for Tx Napi handler instead of ring dependent value
- Use multiqueue to register 4 Rx channels

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
V0 -> V1:
 - Remove chip SKU check conditionals
 - Update the changes description 

 drivers/net/ethernet/microchip/lan743x_main.c | 50 +++++++++----------
 drivers/net/ethernet/microchip/lan743x_main.h |  5 +-
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a9a1dea6d731..3f4e1ab63f8a 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2066,11 +2066,13 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 {
 	int required_number_of_descriptors = 0;
 	unsigned int start_frame_length = 0;
+	netdev_tx_t retval = NETDEV_TX_OK;
 	unsigned int frame_length = 0;
 	unsigned int head_length = 0;
 	unsigned long irq_flags = 0;
 	bool do_timestamp = false;
 	bool ignore_sync = false;
+	struct netdev_queue *txq;
 	int nr_frags = 0;
 	bool gso = false;
 	int j;
@@ -2083,9 +2085,12 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 		if (required_number_of_descriptors > (tx->ring_size - 1)) {
 			dev_kfree_skb_irq(skb);
 		} else {
-			/* save to overflow buffer */
-			tx->overflow_skb = skb;
-			netif_stop_queue(tx->adapter->netdev);
+			/* save how many descriptors we needed to restart the queue */
+			tx->rqd_descriptors = required_number_of_descriptors;
+			retval = NETDEV_TX_BUSY;
+			txq = netdev_get_tx_queue(tx->adapter->netdev,
+						  tx->channel_number);
+			netif_tx_stop_queue(txq);
 		}
 		goto unlock;
 	}
@@ -2144,15 +2149,15 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 
 unlock:
 	spin_unlock_irqrestore(&tx->ring_lock, irq_flags);
-	return NETDEV_TX_OK;
+	return retval;
 }
 
 static int lan743x_tx_napi_poll(struct napi_struct *napi, int weight)
 {
 	struct lan743x_tx *tx = container_of(napi, struct lan743x_tx, napi);
 	struct lan743x_adapter *adapter = tx->adapter;
-	bool start_transmitter = false;
 	unsigned long irq_flags = 0;
+	struct netdev_queue *txq;
 	u32 ioc_bit = 0;
 
 	ioc_bit = DMAC_INT_BIT_TX_IOC_(tx->channel_number);
@@ -2163,24 +2168,20 @@ static int lan743x_tx_napi_poll(struct napi_struct *napi, int weight)
 
 	/* clean up tx ring */
 	lan743x_tx_release_completed_descriptors(tx);
-	if (netif_queue_stopped(adapter->netdev)) {
-		if (tx->overflow_skb) {
-			if (lan743x_tx_get_desc_cnt(tx, tx->overflow_skb) <=
-				lan743x_tx_get_avail_desc(tx))
-				start_transmitter = true;
+	txq = netdev_get_tx_queue(adapter->netdev, tx->channel_number);
+	if (netif_tx_queue_stopped(txq)) {
+		if (tx->rqd_descriptors) {
+			if (tx->rqd_descriptors <=
+			    lan743x_tx_get_avail_desc(tx)) {
+				tx->rqd_descriptors = 0;
+				netif_tx_wake_queue(txq);
+			}
 		} else {
-			netif_wake_queue(adapter->netdev);
+			netif_tx_wake_queue(txq);
 		}
 	}
 	spin_unlock_irqrestore(&tx->ring_lock, irq_flags);
 
-	if (start_transmitter) {
-		/* space is now available, transmit overflow skb */
-		lan743x_tx_xmit_frame(tx, tx->overflow_skb);
-		tx->overflow_skb = NULL;
-		netif_wake_queue(adapter->netdev);
-	}
-
 	if (!napi_complete(napi))
 		goto done;
 
@@ -2304,10 +2305,7 @@ static void lan743x_tx_close(struct lan743x_tx *tx)
 
 	lan743x_tx_release_all_descriptors(tx);
 
-	if (tx->overflow_skb) {
-		dev_kfree_skb(tx->overflow_skb);
-		tx->overflow_skb = NULL;
-	}
+	tx->rqd_descriptors = 0;
 
 	lan743x_tx_ring_cleanup(tx);
 }
@@ -2387,7 +2385,7 @@ static int lan743x_tx_open(struct lan743x_tx *tx)
 							 (tx->channel_number));
 	netif_napi_add_tx_weight(adapter->netdev,
 				 &tx->napi, lan743x_tx_napi_poll,
-				 tx->ring_size - 1);
+				 NAPI_POLL_WEIGHT);
 	napi_enable(&tx->napi);
 
 	data = 0;
@@ -3347,8 +3345,10 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 						 PCI11X1X_USED_TX_CHANNELS,
 						 LAN743X_USED_RX_CHANNELS);
 	} else {
-		netdev = devm_alloc_etherdev(&pdev->dev,
-					     sizeof(struct lan743x_adapter));
+		netdev = devm_alloc_etherdev_mqs(&pdev->dev,
+						 sizeof(struct lan743x_adapter),
+						 LAN743X_USED_TX_CHANNELS,
+						 LAN743X_USED_RX_CHANNELS);
 	}
 
 	if (!netdev)
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 72adae4f2aa0..58eb7abf976b 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -954,8 +954,7 @@ struct lan743x_tx {
 
 	struct napi_struct napi;
 	u32 frame_count;
-
-	struct sk_buff *overflow_skb;
+	u32 rqd_descriptors;
 };
 
 void lan743x_tx_set_timestamping_mode(struct lan743x_tx *tx,
@@ -1110,7 +1109,7 @@ struct lan743x_tx_buffer_info {
 	unsigned int    buffer_length;
 };
 
-#define LAN743X_TX_RING_SIZE    (50)
+#define LAN743X_TX_RING_SIZE    (128)
 
 /* OWN bit is set. ie, Descs are owned by RX DMAC */
 #define RX_DESC_DATA0_OWN_                (0x00008000)
-- 
2.25.1

