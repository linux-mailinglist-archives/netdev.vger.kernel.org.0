Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C281F62E5AB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbiKQUPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240377AbiKQUOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:14:55 -0500
Received: from mx18lb.world4you.com (mx18lb.world4you.com [81.19.149.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1F97EBF3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qaX8m+ucI0YH5OuD/T26rP5t/xLNa+d15VetJQazLvM=; b=GWvbs9WEYmJJr7sJTuTHY4h+uq
        8Zg3757EApwiw/W0FtsyBN1mGHnyYnPjbHcyYbzMDg19lVdIt59Z+MU2WVn0va6coUuR18pnj1pzO
        e8Gb79iMHlQJRiWUHMpuBkivSpifJM+86ck/P6rA2iSk56l7SCvabCW33SvbyptY1Do0=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx18lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ovlHb-0001s8-AP; Thu, 17 Nov 2022 21:14:47 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 1/4] tsnep: Throttle interrupts
Date:   Thu, 17 Nov 2022 21:14:37 +0100
Message-Id: <20221117201440.21183-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117201440.21183-1-gerhard@engleder-embedded.com>
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without interrupt throttling, iperf server mode generates a CPU load of
100% (A53 1.2GHz). Also the throughput suffers with less than 900Mbit/s
on a 1Gbit/s link. The reason is a high interrupt load with interrupts
every ~20us.

Reduce interrupt load by throttling of interrupts. Interrupt delay is
configured statically to 64us. For iperf server mode the CPU load is
significantly reduced to ~20% and the throughput reaches the maximum of
941MBit/s. Interrupts are generated every ~140us.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_hw.h   | 7 +++++++
 drivers/net/ethernet/engleder/tsnep_main.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
index 315dada75323..55e1caf193a6 100644
--- a/drivers/net/ethernet/engleder/tsnep_hw.h
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -48,6 +48,13 @@
 #define ECM_COUNTER_LOW 0x0028
 #define ECM_COUNTER_HIGH 0x002C
 
+/* interrupt delay */
+#define ECM_INT_DELAY 0x0030
+#define ECM_INT_DELAY_MASK 0xF0
+#define ECM_INT_DELAY_SHIFT 4
+#define ECM_INT_DELAY_BASE_US 16
+#define ECM_INT_DELAY_OFFSET 1
+
 /* control and status */
 #define ECM_STATUS 0x0080
 #define ECM_LINK_MODE_OFF 0x01000000
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 48fb391951dd..a99320e03279 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -39,6 +39,8 @@
 #endif
 #define DMA_ADDR_LOW(dma_addr) ((u32)((dma_addr) & 0xFFFFFFFF))
 
+#define INT_DELAY (64 / ECM_INT_DELAY_BASE_US)
+
 static void tsnep_enable_irq(struct tsnep_adapter *adapter, u32 mask)
 {
 	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
@@ -1298,6 +1300,7 @@ static int tsnep_phy_init(struct tsnep_adapter *adapter)
 static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 {
 	u32 irq_mask = ECM_INT_TX_0 | ECM_INT_RX_0;
+	u8 irq_delay = (INT_DELAY << ECM_INT_DELAY_SHIFT) & ECM_INT_DELAY_MASK;
 	char name[8];
 	int i;
 	int retval;
@@ -1316,6 +1319,7 @@ static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 	adapter->queue[0].tx = &adapter->tx[0];
 	adapter->queue[0].rx = &adapter->rx[0];
 	adapter->queue[0].irq_mask = irq_mask;
+	iowrite8(irq_delay, adapter->addr + ECM_INT_DELAY);
 
 	adapter->netdev->irq = adapter->queue[0].irq;
 
@@ -1336,6 +1340,8 @@ static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 		adapter->queue[i].rx = &adapter->rx[i];
 		adapter->queue[i].irq_mask =
 			irq_mask << (ECM_INT_TXRX_SHIFT * i);
+		iowrite8(irq_delay, adapter->addr + ECM_INT_DELAY +
+				    ECM_INT_DELAY_OFFSET * i);
 	}
 
 	return 0;
-- 
2.30.2

