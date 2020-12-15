Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53402DB134
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbgLOQVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730667AbgLOQUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:20:39 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A7CC06179C;
        Tue, 15 Dec 2020 08:19:59 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 22so9427877qkf.9;
        Tue, 15 Dec 2020 08:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jh/FYZqSiUedTCmKPnwcuAjv/q6UQYy+G14dvQgnqak=;
        b=aVWeZsVdgs0IAMR+VHk12hrwLF663aMcOA31rjUI06XX+nAUH/8sNwB8OS+5pUyElm
         Pqc50Wd4eMyf7HyZbUszwddUwHTRyiw7G8kliAx27r1Ti3Ir6fB6PYOPmHiN/8D4e9cn
         DtW8p5edA2JV4mj0Rp8dFb0b+sM4io53ZI269oBuvLAOCzRIw9bGv8J5SWYXGNb+SAkC
         is+NsaN8JKxhhhMuDM8fZxra5xdT0tvFlQctOME1cVrTwBgPyNTrN9AZxSSkX1Z53kpJ
         35/Bh+0KJyEXjs1qbTZ8CIs+4uJ7txTcPGvZiPAA6dHxcwdzlFXMXCSy1czqx0QNiAYa
         pZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jh/FYZqSiUedTCmKPnwcuAjv/q6UQYy+G14dvQgnqak=;
        b=NGGSp7ea2XSYAemu4Z0t1SvlnJXHTVyPtBC8F3v0kQ7yfMAQBPOYWyRNT9RFxskNBo
         OskU2095zcuSsfsQCcDU7URxnK9DKCqMmNonS9NRUMqKcK9wl4BKEC3bTar6QtwKahPQ
         sKQKYED9gafWvfVuiwOGs8S1n9gR1aqXVI2yGkENVeqJ7GB81JF9p7CYDzYXRbDI5hIB
         wN7zAkGgVAxiQiWQuQJbuhjfGcXWRJ6z7D8YDzJC+MDvvlIpSS0by9f6b5ERf8nsvrE/
         nxEqNFDar1/TZ7s+Zr7E9NcwlfjXpV2JjS41B++/ZXDtNrls/O2mJCOOJwgMoYSkVcsQ
         GdmQ==
X-Gm-Message-State: AOAM530OplH/fACmKZsLg8WOCl/ZEhew4TLj/0BLb/qrnivy/TVJg1Iv
        tbxXZ7v8LGc0hxkPe6jppvw=
X-Google-Smtp-Source: ABdhPJzFE4Ap82FL6ueWPlkkqksffHkesI+j6iDih9T/zdMs6Pllu0NLUjTK7+Z5p4VFXuC0aXOEBg==
X-Received: by 2002:a37:b342:: with SMTP id c63mr38923602qkf.146.1608049197870;
        Tue, 15 Dec 2020 08:19:57 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id d72sm445213qkg.34.2020.12.15.08.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 08:19:57 -0800 (PST)
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
Subject: [PATCH net v4] lan743x: fix rx_napi_poll/interrupt ping-pong
Date:   Tue, 15 Dec 2020 11:19:54 -0500
Message-Id: <20201215161954.5950-1-TheSven73@gmail.com>
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

v3 -> v4:
	- eliminate potential undefined behaviour in corner case
	  (if weight == 0)

v2 -> v3:
	- use NAPI_POLL_WEIGHT
	  (Heiner Kallweit)

v1 -> v2:
	- make napi rx polling behave identically to existing ethernet drivers
	  (Jacub Kicinski, Eric Dumazet, Andrew Lunn)

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 7f376f1917d7

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 43 ++++++++++---------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index b319c22c211c..8947c3a62810 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1962,6 +1962,14 @@ static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
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
@@ -1992,6 +2000,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
 			    (length & RX_DESC_DATA0_BUF_LENGTH_MASK_));
 	skb_reserve(buffer_info->skb, RX_HEAD_PADDING);
+	lan743x_rx_update_tail(rx, index);
 
 	return 0;
 }
@@ -2010,6 +2019,7 @@ static void lan743x_rx_reuse_ring_element(struct lan743x_rx *rx, int index)
 	descriptor->data0 = (RX_DESC_DATA0_OWN_ |
 			    ((buffer_info->buffer_length) &
 			    RX_DESC_DATA0_BUF_LENGTH_MASK_));
+	lan743x_rx_update_tail(rx, index);
 }
 
 static void lan743x_rx_release_ring_element(struct lan743x_rx *rx, int index)
@@ -2220,6 +2230,7 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 {
 	struct lan743x_rx *rx = container_of(napi, struct lan743x_rx, napi);
 	struct lan743x_adapter *adapter = rx->adapter;
+	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
 	u32 rx_tail_flags = 0;
 	int count;
 
@@ -2228,27 +2239,19 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
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
@@ -2258,10 +2261,10 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
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
 
@@ -2405,7 +2408,7 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
 
 	netif_napi_add(adapter->netdev,
 		       &rx->napi, lan743x_rx_napi_poll,
-		       rx->ring_size - 1);
+		       NAPI_POLL_WEIGHT);
 
 	lan743x_csr_write(adapter, DMAC_CMD,
 			  DMAC_CMD_RX_SWR_(rx->channel_number));
-- 
2.17.1

