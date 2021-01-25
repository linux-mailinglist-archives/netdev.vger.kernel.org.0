Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6432304B5D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbhAZEq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbhAYJPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:15:23 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382C9C061225
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 01:03:50 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id f2so9135024ljp.11
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 01:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=am1eLwIE+FOK3HS7GnVwONuR9YBK6NLPFHdkHE3pNFE=;
        b=AQKEYycHtGqodteT0Y/PwLv54mqDztSuhYB9clcp0uR2ZCwcwSe+kYhzI3JFal6NuG
         M6RREFkx27ADvyAjJJC4VFCVFyT4b+mayWeLsMte0Q8sIWC3qJ30GRdg0rTuXuj90w4I
         KGjk7TgS4yi/6i2LpJG4LS84rFzsGB/nybp+hrOnRWusE4aeSmmff0cl1vnuSgatWSt+
         Oh/+JVuJ+4574eOXK3u6lEWscjTxc59bAWR1iyD3lcgIzcgYF1xKKw6bbogxeCPrjuTL
         34z3luCapOcvw4WU/u/e4eLqpLoX2/WJM/h6f7MWMHO36U8p8rIezYZbDWOhCA07Asd1
         2+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=am1eLwIE+FOK3HS7GnVwONuR9YBK6NLPFHdkHE3pNFE=;
        b=uPD1NhR7EeDkn9jSGGucT/UcNhl686wOVdh0S17BlbRtV3QQrGbxhyFLBLqowTtKKh
         N+sI79UH68dfMZzaQCxNzhhOXOZ1WGeEw6sWZKhrnGcs9SYjncOXwDwQWUagdQb0SogS
         oPhA+n5+NCoeDZ4148hL+1q7pH0ap6eSC7M/pZgtElT+6jPIkyLhpoeC0iBc7TXidDFQ
         zJ/d6JnPc52c1elIyw9ZnatH/+dYjAu54Fq3X3+giF4Ok6uT7vq5201JumX7uIEJsXed
         kt0rbuKNQA47sXxMK7aZ3NPLhe073uPKEfMKKBRVmc37Xif+XdZqo+rnCwafdCGAX8dG
         +KQQ==
X-Gm-Message-State: AOAM533JhksiSeRA7cbkXBtNqt4KAMzq62hjr3DGvPRpnnlLnk4YTp0q
        T1OPVWrp9B5k3wOF2xF+DlvmrcjAvQnD7K1REeE=
X-Google-Smtp-Source: ABdhPJzAw5BfJfepplNRgunm5/W2WETMSRKGfLe0SwD8FSIQpyy5x0ICU+xfeD/72LxG8Av1LQYIIA==
X-Received: by 2002:a2e:5456:: with SMTP id y22mr201239ljd.450.1611565428762;
        Mon, 25 Jan 2021 01:03:48 -0800 (PST)
Received: from denisov-pc.mrn.ru ([46.146.202.208])
        by smtp.gmail.com with ESMTPSA id b31sm2141533ljf.38.2021.01.25.01.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 01:03:48 -0800 (PST)
From:   Alexey Denisov <rtgbnm@gmail.com>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, Alexey Denisov <rtgbnm@gmail.com>
Subject: [PATCH] lan743x: fix endianness when accessing descriptors
Date:   Mon, 25 Jan 2021 14:03:20 +0500
Message-Id: <20210125090320.27954-1-rtgbnm@gmail.com>
X-Mailer: git-send-email 2.25.1
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
 drivers/net/ethernet/microchip/lan743x_main.c | 66 +++++++++----------
 1 file changed, 33 insertions(+), 33 deletions(-)

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
-- 
2.25.1

