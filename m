Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B58F5ECD82
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiI0T7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiI0T65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:58:57 -0400
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02B41CE634;
        Tue, 27 Sep 2022 12:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=m9W/RohaKoA9CaHSW8srxvEN1ctgD/oolEbnyQspg2s=; b=U0IMWPqZx3Eoi/eI9k5e3aZE5A
        EJ5msaBetKaM8jiJhhsWN0g0p8ZcSyIRTilePCK8TGrzQ41dSiAqlzF+mzQlCvr3iGoMJGSu0i1FQ
        DPNQUeDPC5b/kF6qD1rcKXcpOfv3ho6gfn5DujKj+mK9duXfQ8C+du99GJ0/VSJmu4Fg=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1odGjA-0005u7-2S; Tue, 27 Sep 2022 21:58:48 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 4/6] tsnep: Support multiple TX/RX queue pairs
Date:   Tue, 27 Sep 2022 21:58:40 +0200
Message-Id: <20220927195842.44641-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927195842.44641-1-gerhard@engleder-embedded.com>
References: <20220927195842.44641-1-gerhard@engleder-embedded.com>
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

Support additional TX/RX queue pairs if dedicated interrupt is
available. Interrupts are detected by name in device tree.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  2 -
 drivers/net/ethernet/engleder/tsnep_hw.h   |  1 +
 drivers/net/ethernet/engleder/tsnep_main.c | 61 ++++++++++++++++++----
 3 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 149c9acbae9c..62a279bcb011 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -21,8 +21,6 @@
 #define TSNEP_RING_ENTRIES_PER_PAGE (PAGE_SIZE / TSNEP_DESC_SIZE)
 #define TSNEP_RING_PAGE_COUNT (TSNEP_RING_SIZE / TSNEP_RING_ENTRIES_PER_PAGE)
 
-#define TSNEP_QUEUES 1
-
 struct tsnep_gcl {
 	void __iomem *addr;
 
diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
index e03aaafab559..e6cc6fbaf0d7 100644
--- a/drivers/net/ethernet/engleder/tsnep_hw.h
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -34,6 +34,7 @@
 #define ECM_INT_LINK 0x00000020
 #define ECM_INT_TX_0 0x00000100
 #define ECM_INT_RX_0 0x00000200
+#define ECM_INT_TXRX_SHIFT 2
 #define ECM_INT_ALL 0x7FFFFFFF
 #define ECM_INT_DISABLE 0x80000000
 
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index c95328ef992b..bf088b91efb7 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1265,6 +1265,52 @@ static int tsnep_phy_init(struct tsnep_adapter *adapter)
 	return 0;
 }
 
+static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
+{
+	u32 irq_mask = ECM_INT_TX_0 | ECM_INT_RX_0;
+	char name[8];
+	int i;
+	int retval;
+
+	/* one TX/RX queue pair for netdev is mandatory */
+	if (platform_irq_count(adapter->pdev) == 1)
+		retval = platform_get_irq(adapter->pdev, 0);
+	else
+		retval = platform_get_irq_byname(adapter->pdev, "mac");
+	if (retval < 0)
+		return retval;
+	adapter->num_tx_queues = 1;
+	adapter->num_rx_queues = 1;
+	adapter->num_queues = 1;
+	adapter->queue[0].irq = retval;
+	adapter->queue[0].tx = &adapter->tx[0];
+	adapter->queue[0].rx = &adapter->rx[0];
+	adapter->queue[0].irq_mask = irq_mask;
+
+	adapter->netdev->irq = adapter->queue[0].irq;
+
+	/* add additional TX/RX queue pairs only if dedicated interrupt is
+	 * available
+	 */
+	for (i = 1; i < queue_count; i++) {
+		sprintf(name, "txrx-%d", i);
+		retval = platform_get_irq_byname_optional(adapter->pdev, name);
+		if (retval < 0)
+			break;
+
+		adapter->num_tx_queues++;
+		adapter->num_rx_queues++;
+		adapter->num_queues++;
+		adapter->queue[i].irq = retval;
+		adapter->queue[i].tx = &adapter->tx[i];
+		adapter->queue[i].rx = &adapter->rx[i];
+		adapter->queue[i].irq_mask =
+			irq_mask << (ECM_INT_TXRX_SHIFT * i);
+	}
+
+	return 0;
+}
+
 static int tsnep_probe(struct platform_device *pdev)
 {
 	struct tsnep_adapter *adapter;
@@ -1273,6 +1319,7 @@ static int tsnep_probe(struct platform_device *pdev)
 	u32 type;
 	int revision;
 	int version;
+	int queue_count;
 	int retval;
 
 	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
@@ -1305,19 +1352,15 @@ static int tsnep_probe(struct platform_device *pdev)
 	type = ioread32(adapter->addr + ECM_TYPE);
 	revision = (type & ECM_REVISION_MASK) >> ECM_REVISION_SHIFT;
 	version = (type & ECM_VERSION_MASK) >> ECM_VERSION_SHIFT;
+	queue_count = (type & ECM_QUEUE_COUNT_MASK) >> ECM_QUEUE_COUNT_SHIFT;
 	adapter->gate_control = type & ECM_GATE_CONTROL;
 
-	adapter->num_tx_queues = TSNEP_QUEUES;
-	adapter->num_rx_queues = TSNEP_QUEUES;
-	adapter->num_queues = TSNEP_QUEUES;
-	adapter->queue[0].irq = platform_get_irq(pdev, 0);
-	adapter->queue[0].tx = &adapter->tx[0];
-	adapter->queue[0].rx = &adapter->rx[0];
-	adapter->queue[0].irq_mask = ECM_INT_TX_0 | ECM_INT_RX_0;
-
-	netdev->irq = adapter->queue[0].irq;
 	tsnep_disable_irq(adapter, ECM_INT_ALL);
 
+	retval = tsnep_queue_init(adapter, queue_count);
+	if (retval)
+		return retval;
+
 	retval = dma_set_mask_and_coherent(&adapter->pdev->dev,
 					   DMA_BIT_MASK(64));
 	if (retval) {
-- 
2.30.2

