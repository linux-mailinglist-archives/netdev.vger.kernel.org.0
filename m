Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132A62D522F
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbgLJD4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729955AbgLJD4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:56:25 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05857C0613D6;
        Wed,  9 Dec 2020 19:55:45 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id q7so1797560qvt.12;
        Wed, 09 Dec 2020 19:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DWuqm1IHzYvq5waqUReJGhdmosrFVLVkKFItkW/Zkl8=;
        b=ZZBNfoEFVLTsnm1892ushz+X2QSbH/FDgGDRQ5JsXFE/yZMXZq5pvXn2ZARaMJX3gK
         R7PS3F5nJi1xoF5EbDnyHOc1XuEw0Bu2xJ6jh6XDWEyFypq515lxhwlKjsBmkz2/WpYQ
         24J5Ylv/R1mLMXZbDyfxY25qYuIDuUTvdI+qkNfrMuOQf688Pwb/ZrY1NUm/UE/RNMAf
         KbdF+La5pjLmK4H+hnUlQEZcTwofxWInaRHgJHd6Mm6mWKC4DNbspI+0/Y9n1PqZ6Gvd
         ImzR18s69Fwwj2cZL35KNMxjWCi/9R6zesPCMdn63h9phgYpOWnlhqnFJZwDJWs0o2uo
         lcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DWuqm1IHzYvq5waqUReJGhdmosrFVLVkKFItkW/Zkl8=;
        b=DyjPnrNbDTKem3M1+YNWNsvJ1RmxoeUJUuZWTX41D7UgTqZI/qfQru3TGEAIUn+hGS
         KhfMWaVdlB5AOHhZV8GG4pqVA0N3823V8J86Jmv62fwD0645GfmPIQeuoZgBDEAkVFWi
         blYGtdOitp9Yy9V8S8yN3oZ5qSb3kP/Bd908TRmci/Aqikxi4ce1al58g9AZGjpP8pqr
         S4QJhJjZc1Q7sw20LTxtxEBAdv94CMtyJtidrDX6FVSY8Sd9YL5UwBO60fpIXS6VlYj5
         MxJD2cswlmlAe5HwYVoa3IhDEUV9/Vs/2v4nxK/0vGs5yNAqqBw7OCMww/U0uo6MDBKw
         3MNQ==
X-Gm-Message-State: AOAM530lQcLJVodQqDz+l0ICqo/nKn2HffPE3KGMsdS2dWNhH5s3ReQv
        jVH+N9Q2zfW9X6wKfYYKwhZby4RKL13YMQ==
X-Google-Smtp-Source: ABdhPJw0jlBU5STbcSqU6PMg8L0gZBGHbRIBBI3MzW3j2aqBtHQW2iKab/MKcmfyUgr1BWdxxnfz8Q==
X-Received: by 2002:a0c:f791:: with SMTP id s17mr6565638qvn.7.1607572543875;
        Wed, 09 Dec 2020 19:55:43 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id s21sm2671583qtn.13.2020.12.09.19.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 19:55:43 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] lan743x: fix rx_napi_poll/interrupt ping-pong
Date:   Wed,  9 Dec 2020 22:55:40 -0500
Message-Id: <20201210035540.32530-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Even if there is more rx data waiting on the chip, the rx napi poll fn
will never run more than once - it will always read a few buffers, then
bail out and re-arm interrupts. Which results in ping-pong between napi
and interrupt.

This defeats the purpose of napi, and is bad for performance.

Fix by making the rx napi poll behave identically to other ethernet
drivers:
1. initialize rx napi polling with an arbitrary budget (64).
2. in the polling fn, return full weight if rx queue is not depleted,
   this tells the napi core to "keep polling".
3. update the rx tail ("ring the doorbell") once for every 8 processed
   rx ring buffers.

Thanks to Jakub Kicinski, Eric Dumazet and Andrew Lunn for their expert
opinions and suggestions.

Tested with 20 seconds of full bandwidth receive (iperf3):
        rx irqs      softirqs(NET_RX)
        -----------------------------
before  23827        33620
after   129          4081

Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Fixes: 23f0703c125be ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # b7e4ba9a91df

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 44 ++++++++++---------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 87b6c59a1e03..30ec308b9a4c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1964,6 +1964,14 @@ static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
 				  length, GFP_ATOMIC | GFP_DMA);
 }
 
+static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
+{
+	/* update the tail once per 8 descriptors */
+	if ((index & 7) == 7)
+		lan743x_csr_write(rx->adapter, RX_TAIL(rx->channel_number),
+				  index);
+}
+
 static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 					struct sk_buff *skb)
 {
@@ -1994,6 +2002,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
 			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_));
 	skb_reserve(buffer_info->skb, RX_HEAD_PADDING);
+	lan743x_rx_update_tail(rx, index);
 
 	return 0;
 }
@@ -2012,6 +2021,7 @@ static void lan743x_rx_reuse_ring_element(struct lan743x_rx *rx, int index)
 	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
 			    ((buffer_info->buffer_length) &
 			    RX_DESC_DATA0_BUF_LENGTH_MASK_));
+	lan743x_rx_update_tail(rx, index);
 }
 
 static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
@@ -2223,34 +2233,26 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 	struct lan743x_rx *rx = container_of(napi, struct lan743x_rx, napi);
 	struct lan743x_adapter *adapter = rx->adapter;
 	u32 rx_tail_flags = 0;
-	int count;
+	int count, result;
 
 	if (rx->vector_flags & LAN743X_VECTOR_FLAG_SOURCE_STATUS_W2C) {
 		/* clear int status bit before reading packet */
 		lan743x_csr_write(adapter, DMAC_INT_STS,
 				  DMAC_INT_BIT_RXFRM_(rx->channel_number));
 	}
-	count = 0;
-	while (count < weight) {
-		int rx_process_result = lan743x_rx_process_packet(rx);
-
-		if (rx_process_result == RX_PROCESS_RESULT_PACKET_RECEIVED) {
-			count++;
-		} else if (rx_process_result ==
-			RX_PROCESS_RESULT_NOTHING_TO_DO) {
+	for (count = 0; count < weight; count++) {
+		result = lan743x_rx_process_packet(rx);
+		if (result == RX_PROCESS_RESULT_NOTHING_TO_DO)
 			break;
-		} else if (rx_process_result ==
-			RX_PROCESS_RESULT_PACKET_DROPPED) {
-			continue;
-		}
 	}
 	rx->frame_count += count;
-	if (count == weight)
-		goto done;
+	if (count == weight || result == RX_PROCESS_RESULT_PACKET_RECEIVED)
+		return weight;
 
 	if (!napi_complete_done(napi, count))
-		goto done;
+		return count;
 
+	/* re-arm interrupts, must write to rx tail on some chip variants */
 	if (rx->vector_flags & LAN743X_VECTOR_FLAG_VECTOR_ENABLE_AUTO_SET)
 		rx_tail_flags |= RX_TAIL_SET_TOP_INT_VEC_EN_;
 	if (rx->vector_flags & LAN743X_VECTOR_FLAG_SOURCE_ENABLE_AUTO_SET) {
@@ -2260,10 +2262,10 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 				  INT_BIT_DMA_RX_(rx->channel_number));
 	}
 
-	/* update RX_TAIL */
-	lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
-			  rx_tail_flags | rx->last_tail);
-done:
+	if (rx_tail_flags)
+		lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
+				  rx_tail_flags | rx->last_tail);
+
 	return count;
 }
 
@@ -2407,7 +2409,7 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
 
 	netif_napi_add(adapter->netdev,
 		       &rx->napi, lan743x_rx_napi_poll,
-		       rx->ring_size - 1);
+		       64);
 
 	lan743x_csr_write(adapter, DMAC_CMD,
 			  DMAC_CMD_RX_SWR_(rx->channel_number));
-- 
2.17.1

