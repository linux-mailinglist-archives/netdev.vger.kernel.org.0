Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98EA5ECD81
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiI0T7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiI0T65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:58:57 -0400
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1891D263F;
        Tue, 27 Sep 2022 12:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MWwdkCNgAk3sirVM5Vc88GEss7kAzPvg02RTVeN3zGY=; b=hvap+7qdRE/q6bOS+9EygFbJrL
        IBrfAtymgS8ztiDIyj+lF2Z0zDBDfdCb+vBqf3k0qfeQhguPncsGEuXZ+iOqWpNNqmPS2A14gV7+G
        mYnHi363hYRpL4gFkIy6h+SNX4ZSoh2y4JFSYiSnMFkH91A2GrrrFgsa5qDOiYxlqXTw=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1odGj9-0005u7-Eu; Tue, 27 Sep 2022 21:58:47 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 3/6] tsnep: Move interrupt from device to queue
Date:   Tue, 27 Sep 2022 21:58:39 +0200
Message-Id: <20220927195842.44641-4-gerhard@engleder-embedded.com>
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

For multiple queues multiple interrupts shall be used. Therefore, rework
global interrupt to per queue interrupt.

Every interrupt name shall contain interface name and queue information.
To get a valid interface name, the interrupt request needs to by done
during open like in other drivers. Additionally, this allows the removal
of some initialisation checks in the interrupt handler.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |   4 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 128 +++++++++++++++------
 2 files changed, 99 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 147fe03ca979..149c9acbae9c 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -55,6 +55,7 @@ struct tsnep_tx_entry {
 struct tsnep_tx {
 	struct tsnep_adapter *adapter;
 	void __iomem *addr;
+	int queue_index;
 
 	void *page[TSNEP_RING_PAGE_COUNT];
 	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
@@ -105,12 +106,14 @@ struct tsnep_rx {
 
 struct tsnep_queue {
 	struct tsnep_adapter *adapter;
+	char name[IFNAMSIZ + 9];
 
 	struct tsnep_tx *tx;
 	struct tsnep_rx *rx;
 
 	struct napi_struct napi;
 
+	int irq;
 	u32 irq_mask;
 };
 
@@ -126,7 +129,6 @@ struct tsnep_adapter {
 	struct platform_device *pdev;
 	struct device *dmadev;
 	void __iomem *addr;
-	int irq;
 
 	bool gate_control;
 	/* gate control lock */
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 19db8b1dddc4..c95328ef992b 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -60,22 +60,29 @@ static irqreturn_t tsnep_irq(int irq, void *arg)
 		iowrite32(active, adapter->addr + ECM_INT_ACKNOWLEDGE);
 
 	/* handle link interrupt */
-	if ((active & ECM_INT_LINK) != 0) {
-		if (adapter->netdev->phydev)
-			phy_mac_interrupt(adapter->netdev->phydev);
-	}
+	if ((active & ECM_INT_LINK) != 0)
+		phy_mac_interrupt(adapter->netdev->phydev);
 
 	/* handle TX/RX queue 0 interrupt */
 	if ((active & adapter->queue[0].irq_mask) != 0) {
-		if (adapter->netdev) {
-			tsnep_disable_irq(adapter, adapter->queue[0].irq_mask);
-			napi_schedule(&adapter->queue[0].napi);
-		}
+		tsnep_disable_irq(adapter, adapter->queue[0].irq_mask);
+		napi_schedule(&adapter->queue[0].napi);
 	}
 
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t tsnep_irq_txrx(int irq, void *arg)
+{
+	struct tsnep_queue *queue = arg;
+
+	/* handle TX/RX queue interrupt */
+	tsnep_disable_irq(queue->adapter, queue->irq_mask);
+	napi_schedule(&queue->napi);
+
+	return IRQ_HANDLED;
+}
+
 static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
 {
 	struct tsnep_adapter *adapter = bus->priv;
@@ -536,7 +543,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 }
 
 static int tsnep_tx_open(struct tsnep_adapter *adapter, void __iomem *addr,
-			 struct tsnep_tx *tx)
+			 int queue_index, struct tsnep_tx *tx)
 {
 	dma_addr_t dma;
 	int retval;
@@ -544,6 +551,7 @@ static int tsnep_tx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	memset(tx, 0, sizeof(*tx));
 	tx->adapter = adapter;
 	tx->addr = addr;
+	tx->queue_index = queue_index;
 
 	retval = tsnep_tx_ring_init(tx);
 	if (retval)
@@ -854,6 +862,56 @@ static int tsnep_poll(struct napi_struct *napi, int budget)
 	return min(done, budget - 1);
 }
 
+static int tsnep_request_irq(struct tsnep_queue *queue, bool first)
+{
+	const char *name = netdev_name(queue->adapter->netdev);
+	irq_handler_t handler;
+	void *dev;
+	int retval;
+
+	if (first) {
+		sprintf(queue->name, "%s-mac", name);
+		handler = tsnep_irq;
+		dev = queue->adapter;
+	} else {
+		if (queue->tx && queue->rx)
+			sprintf(queue->name, "%s-txrx-%d", name,
+				queue->rx->queue_index);
+		else if (queue->tx)
+			sprintf(queue->name, "%s-tx-%d", name,
+				queue->tx->queue_index);
+		else
+			sprintf(queue->name, "%s-rx-%d", name,
+				queue->rx->queue_index);
+		handler = tsnep_irq_txrx;
+		dev = queue;
+	}
+
+	retval = request_irq(queue->irq, handler, 0, queue->name, dev);
+	if (retval) {
+		/* if name is empty, then interrupt won't be freed */
+		memset(queue->name, 0, sizeof(queue->name));
+	}
+
+	return retval;
+}
+
+static void tsnep_free_irq(struct tsnep_queue *queue, bool first)
+{
+	void *dev;
+
+	if (!strlen(queue->name))
+		return;
+
+	if (first)
+		dev = queue->adapter;
+	else
+		dev = queue;
+
+	free_irq(queue->irq, dev);
+	memset(queue->name, 0, sizeof(queue->name));
+}
+
 static int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
@@ -863,15 +921,11 @@ static int tsnep_netdev_open(struct net_device *netdev)
 	int rx_queue_index = 0;
 	int retval;
 
-	retval = tsnep_phy_open(adapter);
-	if (retval)
-		return retval;
-
 	for (i = 0; i < adapter->num_queues; i++) {
 		adapter->queue[i].adapter = adapter;
 		if (adapter->queue[i].tx) {
 			addr = adapter->addr + TSNEP_QUEUE(tx_queue_index);
-			retval = tsnep_tx_open(adapter, addr,
+			retval = tsnep_tx_open(adapter, addr, tx_queue_index,
 					       adapter->queue[i].tx);
 			if (retval)
 				goto failed;
@@ -886,6 +940,14 @@ static int tsnep_netdev_open(struct net_device *netdev)
 				goto failed;
 			rx_queue_index++;
 		}
+
+		retval = tsnep_request_irq(&adapter->queue[i], i == 0);
+		if (retval) {
+			netif_err(adapter, drv, adapter->netdev,
+				  "can't get assigned irq %d.\n",
+				  adapter->queue[i].irq);
+			goto failed;
+		}
 	}
 
 	retval = netif_set_real_num_tx_queues(adapter->netdev,
@@ -897,6 +959,11 @@ static int tsnep_netdev_open(struct net_device *netdev)
 	if (retval)
 		goto failed;
 
+	tsnep_enable_irq(adapter, ECM_INT_LINK);
+	retval = tsnep_phy_open(adapter);
+	if (retval)
+		goto phy_failed;
+
 	for (i = 0; i < adapter->num_queues; i++) {
 		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
 			       tsnep_poll, 64);
@@ -907,14 +974,18 @@ static int tsnep_netdev_open(struct net_device *netdev)
 
 	return 0;
 
+phy_failed:
+	tsnep_disable_irq(adapter, ECM_INT_LINK);
+	tsnep_phy_close(adapter);
 failed:
 	for (i = 0; i < adapter->num_queues; i++) {
+		tsnep_free_irq(&adapter->queue[i], i == 0);
+
 		if (adapter->queue[i].rx)
 			tsnep_rx_close(adapter->queue[i].rx);
 		if (adapter->queue[i].tx)
 			tsnep_tx_close(adapter->queue[i].tx);
 	}
-	tsnep_phy_close(adapter);
 	return retval;
 }
 
@@ -923,20 +994,23 @@ static int tsnep_netdev_close(struct net_device *netdev)
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int i;
 
+	tsnep_disable_irq(adapter, ECM_INT_LINK);
+	tsnep_phy_close(adapter);
+
 	for (i = 0; i < adapter->num_queues; i++) {
 		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
 
 		napi_disable(&adapter->queue[i].napi);
 		netif_napi_del(&adapter->queue[i].napi);
 
+		tsnep_free_irq(&adapter->queue[i], i == 0);
+
 		if (adapter->queue[i].rx)
 			tsnep_rx_close(adapter->queue[i].rx);
 		if (adapter->queue[i].tx)
 			tsnep_tx_close(adapter->queue[i].tx);
 	}
 
-	tsnep_phy_close(adapter);
-
 	return 0;
 }
 
@@ -1225,10 +1299,8 @@ static int tsnep_probe(struct platform_device *pdev)
 	adapter->addr = devm_ioremap_resource(&pdev->dev, io);
 	if (IS_ERR(adapter->addr))
 		return PTR_ERR(adapter->addr);
-	adapter->irq = platform_get_irq(pdev, 0);
 	netdev->mem_start = io->start;
 	netdev->mem_end = io->end;
-	netdev->irq = adapter->irq;
 
 	type = ioread32(adapter->addr + ECM_TYPE);
 	revision = (type & ECM_REVISION_MASK) >> ECM_REVISION_SHIFT;
@@ -1238,10 +1310,14 @@ static int tsnep_probe(struct platform_device *pdev)
 	adapter->num_tx_queues = TSNEP_QUEUES;
 	adapter->num_rx_queues = TSNEP_QUEUES;
 	adapter->num_queues = TSNEP_QUEUES;
+	adapter->queue[0].irq = platform_get_irq(pdev, 0);
 	adapter->queue[0].tx = &adapter->tx[0];
 	adapter->queue[0].rx = &adapter->rx[0];
 	adapter->queue[0].irq_mask = ECM_INT_TX_0 | ECM_INT_RX_0;
 
+	netdev->irq = adapter->queue[0].irq;
+	tsnep_disable_irq(adapter, ECM_INT_ALL);
+
 	retval = dma_set_mask_and_coherent(&adapter->pdev->dev,
 					   DMA_BIT_MASK(64));
 	if (retval) {
@@ -1249,19 +1325,9 @@ static int tsnep_probe(struct platform_device *pdev)
 		return retval;
 	}
 
-	tsnep_disable_irq(adapter, ECM_INT_ALL);
-	retval = devm_request_irq(&adapter->pdev->dev, adapter->irq, tsnep_irq,
-				  0, TSNEP, adapter);
-	if (retval != 0) {
-		dev_err(&adapter->pdev->dev, "can't get assigned irq %d.\n",
-			adapter->irq);
-		return retval;
-	}
-	tsnep_enable_irq(adapter, ECM_INT_LINK);
-
 	retval = tsnep_mac_init(adapter);
 	if (retval)
-		goto mac_init_failed;
+		return retval;
 
 	retval = tsnep_mdio_init(adapter);
 	if (retval)
@@ -1307,8 +1373,6 @@ static int tsnep_probe(struct platform_device *pdev)
 	if (adapter->mdiobus)
 		mdiobus_unregister(adapter->mdiobus);
 mdio_init_failed:
-mac_init_failed:
-	tsnep_disable_irq(adapter, ECM_INT_ALL);
 	return retval;
 }
 
-- 
2.30.2

