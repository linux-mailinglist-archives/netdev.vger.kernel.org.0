Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA958D575
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 10:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbiHIIgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 04:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240542AbiHIIgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 04:36:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E981EAFE;
        Tue,  9 Aug 2022 01:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660034208; x=1691570208;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tU4ICht2TOgLGArM7FP2OTiD81+/PhEHs/4VqKJDb94=;
  b=WEpctERC+izwPF9OAv1J+3GCvP+9j5qexUefCppV1nk+HtS2lCRbsSXz
   C1Ji0p8KI/QXc7YbAvrdLDQ6AjioBWKqQ4h9b+VlHELvmvgN6FWfSAzgO
   unUktec90AyNW6aHUgh53Zlnx5Ulgcy2iJMlVHQobD9VCGnMgUgW9IoTo
   RXzCsVkhC2PVNeOqpZRarOJIMYRci+66L4iSa7vAf7QNzrc0drIh6Rrn3
   BECQ/ngAQzNLzSlh5yDJp+sTdnuCRMb7kLLbFPdx0hyULdu5Sgi5vSGKZ
   8+FAyVSwpuLTI5KIPGu7XObqY8WjH0rjlds/RZ1IxWI7WH58UjKHfmIn1
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="171582123"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Aug 2022 01:36:48 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 9 Aug 2022 01:36:36 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Tue, 9 Aug 2022 01:36:33 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: [PATCH net-next] net: lan743x: Fix the multi queue overflow issue
Date:   Tue, 9 Aug 2022 14:06:28 +0530
Message-ID: <20220809083628.650493-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
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

Fix the Tx multi-queue overflow issue

Tx ring size of 128 (for TCP) provides ability to handle way more data than
what Rx can (Rx buffers are constrained to one frame or even less during a
dynamic mtu size change)

TX napi weight dependent of the ring size like it is now (ring size -1)
because there is an express warning in the kernel about not registering weight
values > NAPI_POLL_WEIGHT (currently 64)

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 64 +++++++++++--------
 drivers/net/ethernet/microchip/lan743x_main.h |  5 +-
 2 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a9a1dea6d731..d7c14ee7e413 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2064,8 +2064,10 @@ static void lan743x_tx_frame_end(struct lan743x_tx *tx,
 static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 					 struct sk_buff *skb)
 {
+	struct lan743x_adapter *adapter = tx->adapter;
 	int required_number_of_descriptors = 0;
 	unsigned int start_frame_length = 0;
+	netdev_tx_t retval = NETDEV_TX_OK;
 	unsigned int frame_length = 0;
 	unsigned int head_length = 0;
 	unsigned long irq_flags = 0;
@@ -2083,9 +2085,13 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 		if (required_number_of_descriptors > (tx->ring_size - 1)) {
 			dev_kfree_skb_irq(skb);
 		} else {
-			/* save to overflow buffer */
-			tx->overflow_skb = skb;
-			netif_stop_queue(tx->adapter->netdev);
+			/* save how many descriptors we needed to restart the queue */
+			tx->rqd_descriptors = required_number_of_descriptors;
+			retval = NETDEV_TX_BUSY;
+			if (is_pci11x1x_chip(adapter))
+				netif_stop_subqueue(adapter->netdev, tx->channel_number);
+			else
+				netif_stop_queue(adapter->netdev);
 		}
 		goto unlock;
 	}
@@ -2093,7 +2099,7 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 	/* space available, transmit skb  */
 	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 	    (tx->ts_flags & TX_TS_FLAG_TIMESTAMPING_ENABLED) &&
-	    (lan743x_ptp_request_tx_timestamp(tx->adapter))) {
+	    (lan743x_ptp_request_tx_timestamp(adapter))) {
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		do_timestamp = true;
 		if (tx->ts_flags & TX_TS_FLAG_ONE_STEP_SYNC)
@@ -2144,14 +2150,13 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 
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
 	u32 ioc_bit = 0;
 
@@ -2163,24 +2168,36 @@ static int lan743x_tx_napi_poll(struct napi_struct *napi, int weight)
 
 	/* clean up tx ring */
 	lan743x_tx_release_completed_descriptors(tx);
-	if (netif_queue_stopped(adapter->netdev)) {
-		if (tx->overflow_skb) {
-			if (lan743x_tx_get_desc_cnt(tx, tx->overflow_skb) <=
-				lan743x_tx_get_avail_desc(tx))
-				start_transmitter = true;
-		} else {
-			netif_wake_queue(adapter->netdev);
+	if (is_pci11x1x_chip(adapter)) {
+		if (__netif_subqueue_stopped(adapter->netdev,
+		    tx->channel_number)) {
+			if (tx->rqd_descriptors) {
+				if (tx->rqd_descriptors <=
+					lan743x_tx_get_avail_desc(tx)) {
+					tx->rqd_descriptors = 0;
+					netif_wake_subqueue(adapter->netdev,
+							    tx->channel_number);
+				}
+			} else {
+				netif_wake_subqueue(adapter->netdev,
+						    tx->channel_number);
+			}
+		}
+	} else {
+		if (netif_queue_stopped(adapter->netdev)) {
+			if (tx->rqd_descriptors) {
+				if (tx->rqd_descriptors <=
+				    lan743x_tx_get_avail_desc(tx)) {
+					tx->rqd_descriptors = 0;
+					netif_wake_queue(adapter->netdev);
+				}
+			} else {
+				netif_wake_queue(adapter->netdev);
+			}
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
 
@@ -2304,10 +2321,7 @@ static void lan743x_tx_close(struct lan743x_tx *tx)
 
 	lan743x_tx_release_all_descriptors(tx);
 
-	if (tx->overflow_skb) {
-		dev_kfree_skb(tx->overflow_skb);
-		tx->overflow_skb = NULL;
-	}
+	tx->rqd_descriptors = 0;
 
 	lan743x_tx_ring_cleanup(tx);
 }
@@ -2387,7 +2401,7 @@ static int lan743x_tx_open(struct lan743x_tx *tx)
 							 (tx->channel_number));
 	netif_napi_add_tx_weight(adapter->netdev,
 				 &tx->napi, lan743x_tx_napi_poll,
-				 tx->ring_size - 1);
+				 NAPI_POLL_WEIGHT);
 	napi_enable(&tx->napi);
 
 	data = 0;
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

