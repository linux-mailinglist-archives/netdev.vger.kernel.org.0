Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCB42D780C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406125AbgLKOjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406306AbgLKOin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 09:38:43 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EC2C0613CF;
        Fri, 11 Dec 2020 06:38:03 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id q22so8551380qkq.6;
        Fri, 11 Dec 2020 06:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pty5GK5U+KCQW5qWF1bqAji+naz9G7gouMnlOutEGqc=;
        b=sDOJFvA/WmK+MbnkzzP0XS8DJkI9Mvl034fGf9AGW6WnqDA/HJG1/Up4MqoMbK2EtL
         wcAQwA0/SzwHtPrtiidl7UEqiH8+DAfnAFlkeWMYFdT4abn54iBsjEg1/JXlwkPT15Bj
         VWVRfPM/FxUlR6cZ0kjYjLaGtZGICCQNPkpt0i/YxnWIRAdzXG0erAg3FzAAjDqrXMqg
         4bGQN5DwOh8vmlcJ4xdtDtVIYjBhYj4xvHCvmUntlKpLorUlwkjxfWNgXua+i4yz8Z5B
         AX2girf2RL8CtSzIsn+bdmpCeZ/zrMc+UhlhHlEGRMUdC5BG8n8kfDMppS8CTHaoqcZh
         eE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pty5GK5U+KCQW5qWF1bqAji+naz9G7gouMnlOutEGqc=;
        b=FEnj/7P1s60vBlpUAzOUMmZqYL+EIglS3zRgmrT3CVEzSnFZVO+j5DclRheNKKhXf7
         GMExiMhmVswEhn6qNb1a03S7DSJmy1xXZR8jJo9okj5G11CrQWZTxBkvWXZyxDHr3hPT
         cknSGpbUWZ4KezjyKX9u4Mf4zR03ACay+p1dqBnheWj7uHzorKmCe7ul5LBXidTnYnWk
         i6WmPSRuEBzecpnm9spyOHWfuLd7SODKJTPfGjaXXtrvJgxXmjOD3B5GvOhcjMYbwqsQ
         EFqSGB8ShxsB6siya+ZVO22AS+q+kP0NnKFuqBaMjOopMfjl9f9foQji9Yx9yJgvoDSu
         YOXQ==
X-Gm-Message-State: AOAM531TLfO3V7TukClrVxDd8R4EWOrhF1NuG1ktjUlvGaHMDK9FfKSZ
        RP5sn2yr6U00CHdePgR014U=
X-Google-Smtp-Source: ABdhPJzrxwhsbg5bMlkUXz8imeaUXyTc/pMrkTSC4i9Z2XpyfdUvnVM/og5LUKGmWErLEefi3r0qMg==
X-Received: by 2002:a37:b82:: with SMTP id 124mr1600660qkl.294.1607697481942;
        Fri, 11 Dec 2020 06:38:01 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id 8sm7372007qkr.28.2020.12.11.06.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:38:01 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v3] lan743x: fix rx_napi_poll/interrupt ping-pong
Date:   Fri, 11 Dec 2020 09:37:58 -0500
Message-Id: <20201211143758.28528-1-TheSven73@gmail.com>
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

v2 -> v3:
	- use NAPI_POLL_WEIGHT
	  (Heiner Kallweit)

v1 -> v2:
	- make napi rx polling behave identically to existing ethernet drivers
	  (Jacub Kicinski, Eric Dumazet, Andrew Lunn)

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # b7e4ba9a91df

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
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
+		       NAPI_POLL_WEIGHT);
 
 	lan743x_csr_write(adapter, DMAC_CMD,
 			  DMAC_CMD_RX_SWR_(rx->channel_number));
-- 
2.17.1

