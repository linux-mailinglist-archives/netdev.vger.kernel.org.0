Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD79306C7C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhA1Eux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhA1Eus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 23:50:48 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825DFC061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 20:50:03 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id a8so5897153lfi.8
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 20:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f0cI/ckw7DLIekGbQqV/HZ0owi+imz+Pvn1Fxdq4h50=;
        b=CItajB14+USJK0F7eg9fMRc0wTpL3KmiV0oIiYRr6QakWl/zRKCaT3yHIp1wpqNVNG
         gZFbbrmsLIIMHIxW4b6aazWcq7ZaVqdyB+RK0IgTjw8L79hG5pkd40tiQNjs/a7zfdFc
         vP+t/5CzlXiyktfobDLBC29tFni3PKVRMiexfnitdI9eePGGKqFwJMeJo/qdWrVGbAiR
         ajblBgf58BV2qP1ApDM5QDjVpQQQPnkC6lV2OS1ZvrO6ISHm/NR7vT3TuyHcQY6Tci/p
         I2I5LYixg279KDwwGNwiu9QmFC1LbaG+w6MIx5PUAcfaExeALdxiBDa4fokbZ/yoOESC
         ludw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f0cI/ckw7DLIekGbQqV/HZ0owi+imz+Pvn1Fxdq4h50=;
        b=bXTQlgxPuvaB0Z9FN6UL6G+/tXf+WZT3qO/cxdTvQBmciuJ+czQg2+x708Dy6HcwBC
         VekaMZfkpp16rZfZ4tE6q+DCPCeM7xJpmmNrVEczKCQyFAdSl9H/wnbnqAAtiEjPGFGq
         0yRO6dUyvNA9gUMD1WYCPnJgS5NhPy+bTGybVXDtAH/s7OFJEurm23vXh1Dg4kWJjVKz
         FUtwkq4qPJE63Bm/QM2Ni4lO25D3gtDnRRHNcod+X2pHfBkU+psTRsh1H5XsAWZN38gz
         ExpS9yXVkUB7RQ/wRojK0lva9CVlXFZpH9hUDSJ3uuwJfj8fxIpSP48xbSUfZTy7BFWl
         hMqA==
X-Gm-Message-State: AOAM531C9xs1QKBWW85BAwk+MCPJpRpHRbb8JLg2775XfjvR7gGBrSKo
        RepTAPw8MIHB6SCw7mJ+uEE=
X-Google-Smtp-Source: ABdhPJwzbnAAMS8kGI+eBEbkZChI0DpU1W+Pk9YXx27eZw2XcFZY0LE2AUr5uILX9MlJx2liqEej2g==
X-Received: by 2002:ac2:52af:: with SMTP id r15mr544632lfm.333.1611809402018;
        Wed, 27 Jan 2021 20:50:02 -0800 (PST)
Received: from denisov-pc.mrn.ru ([46.146.202.208])
        by smtp.gmail.com with ESMTPSA id n7sm1199156lfu.123.2021.01.27.20.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 20:50:01 -0800 (PST)
From:   Alexey Denisov <rtgbnm@gmail.com>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, kuba@kernel.org,
        Alexey Denisov <rtgbnm@gmail.com>
Subject: [PATCH v2] lan743x: fix endianness when accessing descriptors
Date:   Thu, 28 Jan 2021 09:48:59 +0500
Message-Id: <20210128044859.280219-1-rtgbnm@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210126183117.22514d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210126183117.22514d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX/RX descriptor ring fields are always little-endian, but conversion
wasn't performed for big-endian CPUs, so the driver failed to work.

This patch makes the driver work on big-endian CPUs. It was tested and
confirmed to work on NXP P1010 processor (PowerPC).

Signed-off-by: Alexey Denisov <rtgbnm@gmail.com>
---
 v2: Added __le32 sparse annotations for tx/rx descriptor fields as
     pointed out.

 drivers/net/ethernet/microchip/lan743x_main.c | 66 +++++++++----------
 drivers/net/ethernet/microchip/lan743x_main.h | 20 +++---
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 3804310c853a..51359ce650bd 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1253,7 +1253,7 @@ static void lan743x_tx_release_desc(struct lan743x_tx *tx,
 	if (!(buffer_info->flags & TX_BUFFER_INFO_FLAG_ACTIVE))
 		goto done;
 
-	descriptor_type = (descriptor->data0) &
+	descriptor_type = le32_to_cpu(descriptor->data0) &
 			  TX_DESC_DATA0_DTYPE_MASK_;
 	if (descriptor_type == TX_DESC_DATA0_DTYPE_DATA_)
 		goto clean_up_data_descriptor;
@@ -1313,7 +1313,7 @@ static int lan743x_tx_next_index(struct lan743x_tx *tx, int index)
 
 static void lan743x_tx_release_completed_descriptors(struct lan743x_tx *tx)
 {
-	while ((*tx->head_cpu_ptr) != (tx->last_head)) {
+	while (le32_to_cpu(*tx->head_cpu_ptr) != (tx->last_head)) {
 		lan743x_tx_release_desc(tx, tx->last_head, false);
 		tx->last_head = lan743x_tx_next_index(tx, tx->last_head);
 	}
@@ -1399,10 +1399,10 @@ static int lan743x_tx_frame_start(struct lan743x_tx *tx,
 	if (dma_mapping_error(dev, dma_ptr))
 		return -ENOMEM;
 
-	tx_descriptor->data1 = DMA_ADDR_LOW32(dma_ptr);
-	tx_descriptor->data2 = DMA_ADDR_HIGH32(dma_ptr);
-	tx_descriptor->data3 = (frame_length << 16) &
-		TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_;
+	tx_descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(dma_ptr));
+	tx_descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(dma_ptr));
+	tx_descriptor->data3 = cpu_to_le32((frame_length << 16) &
+		TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_);
 
 	buffer_info->skb = NULL;
 	buffer_info->dma_ptr = dma_ptr;
@@ -1443,7 +1443,7 @@ static void lan743x_tx_frame_add_lso(struct lan743x_tx *tx,
 		tx->frame_data0 |= TX_DESC_DATA0_IOC_;
 	}
 	tx_descriptor = &tx->ring_cpu_ptr[tx->frame_tail];
-	tx_descriptor->data0 = tx->frame_data0;
+	tx_descriptor->data0 = cpu_to_le32(tx->frame_data0);
 
 	/* move to next descriptor */
 	tx->frame_tail = lan743x_tx_next_index(tx, tx->frame_tail);
@@ -1487,7 +1487,7 @@ static int lan743x_tx_frame_add_fragment(struct lan743x_tx *tx,
 
 	/* wrap up previous descriptor */
 	tx_descriptor = &tx->ring_cpu_ptr[tx->frame_tail];
-	tx_descriptor->data0 = tx->frame_data0;
+	tx_descriptor->data0 = cpu_to_le32(tx->frame_data0);
 
 	/* move to next descriptor */
 	tx->frame_tail = lan743x_tx_next_index(tx, tx->frame_tail);
@@ -1513,10 +1513,10 @@ static int lan743x_tx_frame_add_fragment(struct lan743x_tx *tx,
 		return -ENOMEM;
 	}
 
-	tx_descriptor->data1 = DMA_ADDR_LOW32(dma_ptr);
-	tx_descriptor->data2 = DMA_ADDR_HIGH32(dma_ptr);
-	tx_descriptor->data3 = (frame_length << 16) &
-			       TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_;
+	tx_descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(dma_ptr));
+	tx_descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(dma_ptr));
+	tx_descriptor->data3 = cpu_to_le32((frame_length << 16) &
+			       TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_);
 
 	buffer_info->skb = NULL;
 	buffer_info->dma_ptr = dma_ptr;
@@ -1560,7 +1560,7 @@ static void lan743x_tx_frame_end(struct lan743x_tx *tx,
 	if (ignore_sync)
 		buffer_info->flags |= TX_BUFFER_INFO_FLAG_IGNORE_SYNC;
 
-	tx_descriptor->data0 = tx->frame_data0;
+	tx_descriptor->data0 = cpu_to_le32(tx->frame_data0);
 	tx->frame_tail = lan743x_tx_next_index(tx, tx->frame_tail);
 	tx->last_tail = tx->frame_tail;
 
@@ -1967,11 +1967,11 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 	}
 
 	buffer_info->buffer_length = length;
-	descriptor->data1 = DMA_ADDR_LOW32(buffer_info->dma_ptr);
-	descriptor->data2 = DMA_ADDR_HIGH32(buffer_info->dma_ptr);
+	descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(buffer_info->dma_ptr));
+	descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(buffer_info->dma_ptr));
 	descriptor->data3 = 0;
-	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
-			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_));
+	descriptor->data0 = cpu_to_le32((RX_DESC_DATA0_OWN_ |
+			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_)));
 	skb_reserve(buffer_info->skb, RX_HEAD_PADDING);
 	lan743x_rx_update_tail(rx, index);
 
@@ -1986,12 +1986,12 @@ static void lan743x_rx_reuse_ring_element(struct lan743x_rx *rx, int index)
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
 
-	descriptor->data1 = DMA_ADDR_LOW32(buffer_info->dma_ptr);
-	descriptor->data2 = DMA_ADDR_HIGH32(buffer_info->dma_ptr);
+	descriptor->data1 = cpu_to_le32(DMA_ADDR_LOW32(buffer_info->dma_ptr));
+	descriptor->data2 = cpu_to_le32(DMA_ADDR_HIGH32(buffer_info->dma_ptr));
 	descriptor->data3 = 0;
-	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
+	descriptor->data0 = cpu_to_le32((RX_DESC_DATA0_OWN_ |
 			    ((buffer_info->buffer_length) &
-			    RX_DESC_DATA0_BUF_LENGTH_MASK_));
+			    RX_DESC_DATA0_BUF_LENGTH_MASK_)));
 	lan743x_rx_update_tail(rx, index);
 }
 
@@ -2025,7 +2025,7 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 {
 	struct skb_shared_hwtstamps *hwtstamps = NULL;
 	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
-	int current_head_index = *rx->head_cpu_ptr;
+	int current_head_index = le32_to_cpu(*rx->head_cpu_ptr);
 	struct lan743x_rx_buffer_info *buffer_info;
 	struct lan743x_rx_descriptor *descriptor;
 	int extension_index = -1;
@@ -2040,14 +2040,14 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 
 	if (rx->last_head != current_head_index) {
 		descriptor = &rx->ring_cpu_ptr[rx->last_head];
-		if (descriptor->data0 & RX_DESC_DATA0_OWN_)
+		if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
 			goto done;
 
-		if (!(descriptor->data0 & RX_DESC_DATA0_FS_))
+		if (!(le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_FS_))
 			goto done;
 
 		first_index = rx->last_head;
-		if (descriptor->data0 & RX_DESC_DATA0_LS_) {
+		if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_) {
 			last_index = rx->last_head;
 		} else {
 			int index;
@@ -2055,10 +2055,10 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			index = lan743x_rx_next_index(rx, first_index);
 			while (index != current_head_index) {
 				descriptor = &rx->ring_cpu_ptr[index];
-				if (descriptor->data0 & RX_DESC_DATA0_OWN_)
+				if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_OWN_)
 					goto done;
 
-				if (descriptor->data0 & RX_DESC_DATA0_LS_) {
+				if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_LS_) {
 					last_index = index;
 					break;
 				}
@@ -2067,17 +2067,17 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 		}
 		if (last_index >= 0) {
 			descriptor = &rx->ring_cpu_ptr[last_index];
-			if (descriptor->data0 & RX_DESC_DATA0_EXT_) {
+			if (le32_to_cpu(descriptor->data0) & RX_DESC_DATA0_EXT_) {
 				/* extension is expected to follow */
 				int index = lan743x_rx_next_index(rx,
 								  last_index);
 				if (index != current_head_index) {
 					descriptor = &rx->ring_cpu_ptr[index];
-					if (descriptor->data0 &
+					if (le32_to_cpu(descriptor->data0) &
 					    RX_DESC_DATA0_OWN_) {
 						goto done;
 					}
-					if (descriptor->data0 &
+					if (le32_to_cpu(descriptor->data0) &
 					    RX_DESC_DATA0_EXT_) {
 						extension_index = index;
 					} else {
@@ -2129,7 +2129,7 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			}
 			buffer_info->skb = NULL;
 			packet_length =	RX_DESC_DATA0_FRAME_LENGTH_GET_
-					(descriptor->data0);
+					(le32_to_cpu(descriptor->data0));
 			skb_put(skb, packet_length - 4);
 			skb->protocol = eth_type_trans(skb,
 						       rx->adapter->netdev);
@@ -2167,8 +2167,8 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			descriptor = &rx->ring_cpu_ptr[extension_index];
 			buffer_info = &rx->buffer_info[extension_index];
 
-			ts_sec = descriptor->data1;
-			ts_nsec = (descriptor->data2 &
+			ts_sec = le32_to_cpu(descriptor->data1);
+			ts_nsec = (le32_to_cpu(descriptor->data2) &
 				  RX_DESC_DATA2_TS_NS_MASK_);
 			lan743x_rx_reuse_ring_element(rx, extension_index);
 			real_last_index = extension_index;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 404af3f4635e..f3f778910fcc 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -661,7 +661,7 @@ struct lan743x_tx {
 
 	struct lan743x_tx_buffer_info *buffer_info;
 
-	u32		*head_cpu_ptr;
+	__le32		*head_cpu_ptr;
 	dma_addr_t	head_dma_ptr;
 	int		last_head;
 	int		last_tail;
@@ -691,7 +691,7 @@ struct lan743x_rx {
 
 	struct lan743x_rx_buffer_info *buffer_info;
 
-	u32		*head_cpu_ptr;
+	__le32		*head_cpu_ptr;
 	dma_addr_t	head_dma_ptr;
 	u32		last_head;
 	u32		last_tail;
@@ -775,10 +775,10 @@ struct lan743x_adapter {
 #define TX_DESC_DATA3_FRAME_LENGTH_MSS_MASK_	(0x3FFF0000)
 
 struct lan743x_tx_descriptor {
-	u32     data0;
-	u32     data1;
-	u32     data2;
-	u32     data3;
+	__le32     data0;
+	__le32     data1;
+	__le32     data2;
+	__le32     data3;
 } __aligned(DEFAULT_DMA_DESCRIPTOR_SPACING);
 
 #define TX_BUFFER_INFO_FLAG_ACTIVE		BIT(0)
@@ -813,10 +813,10 @@ struct lan743x_tx_buffer_info {
 #define RX_HEAD_PADDING		NET_IP_ALIGN
 
 struct lan743x_rx_descriptor {
-	u32     data0;
-	u32     data1;
-	u32     data2;
-	u32     data3;
+	__le32     data0;
+	__le32     data1;
+	__le32     data2;
+	__le32     data3;
 } __aligned(DEFAULT_DMA_DESCRIPTOR_SPACING);
 
 #define RX_BUFFER_INFO_FLAG_ACTIVE      BIT(0)
-- 
2.25.1

