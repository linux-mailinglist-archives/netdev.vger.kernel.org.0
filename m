Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D0A63E0D8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiK3ThX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiK3ThS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:37:18 -0500
Received: from mx03lb.world4you.com (mx03lb.world4you.com [81.19.149.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295BB8C444
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Rx0Ryjeqzj8D7ew5WPgQPfDRjDYRPzhKOYVVi0a/AnM=; b=ERafZ7xUdVrR4F2wDQP0en+AtI
        w5Cz8g9SbbM9PQPc7fyb+1ma0Yi3B780cgNB4MgPTFJedz7N50kCDFSOppAofowKoUazSW0HSZqqA
        oM4LdX3G9ygESxqi77bsKuI4PgybefwcfiCCze1ACDUx90SAY3Lv5jTTD+4DG6NPH3bg=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx03lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p0StP-0004tu-KM; Wed, 30 Nov 2022 20:37:15 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 3/4] tsnep: Throttle interrupts
Date:   Wed, 30 Nov 2022 20:37:07 +0100
Message-Id: <20221130193708.70747-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221130193708.70747-1-gerhard@engleder-embedded.com>
References: <20221130193708.70747-1-gerhard@engleder-embedded.com>
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

Reduce interrupt load by throttling of interrupts. Interrupt delay
default is 64us. For iperf server mode the CPU load is significantly
reduced to ~20% and the throughput reaches the maximum of 941MBit/s.
Interrupts are generated every ~140us.

RX and TX coalesce can be configured with ethtool. RX coalesce has
priority over TX coalesce if the same interrupt is used.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h         |   4 +
 drivers/net/ethernet/engleder/tsnep_ethtool.c | 134 ++++++++++++++++++
 drivers/net/ethernet/engleder/tsnep_hw.h      |   7 +
 drivers/net/ethernet/engleder/tsnep_main.c    |  42 ++++++
 4 files changed, 187 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 09a723b827c7..6bb74dd36544 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -132,6 +132,8 @@ struct tsnep_queue {
 
 	int irq;
 	u32 irq_mask;
+	void __iomem *irq_delay_addr;
+	u8 irq_delay;
 };
 
 struct tsnep_adapter {
@@ -223,5 +225,7 @@ static inline void tsnep_ethtool_self_test(struct net_device *dev,
 #endif /* CONFIG_TSNEP_SELFTESTS */
 
 void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time);
+int tsnep_set_irq_coalesce(struct tsnep_queue *queue, u32 usecs);
+u32 tsnep_get_irq_coalesce(struct tsnep_queue *queue);
 
 #endif /* _TSNEP_H */
diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
index 517ac8de32bb..b97ba3544708 100644
--- a/drivers/net/ethernet/engleder/tsnep_ethtool.c
+++ b/drivers/net/ethernet/engleder/tsnep_ethtool.c
@@ -324,7 +324,137 @@ static int tsnep_ethtool_get_ts_info(struct net_device *netdev,
 	return 0;
 }
 
+static struct tsnep_queue *tsnep_get_queue_with_tx(struct tsnep_adapter *adapter,
+						   int index)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_queues; i++) {
+		if (adapter->queue[i].tx) {
+			if (index == 0)
+				return &adapter->queue[i];
+
+			index--;
+		}
+	}
+
+	return NULL;
+}
+
+static struct tsnep_queue *tsnep_get_queue_with_rx(struct tsnep_adapter *adapter,
+						   int index)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_queues; i++) {
+		if (adapter->queue[i].rx) {
+			if (index == 0)
+				return &adapter->queue[i];
+
+			index--;
+		}
+	}
+
+	return NULL;
+}
+
+static int tsnep_ethtool_get_coalesce(struct net_device *netdev,
+				      struct ethtool_coalesce *ec,
+				      struct kernel_ethtool_coalesce *kernel_coal,
+				      struct netlink_ext_ack *extack)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	struct tsnep_queue *queue;
+
+	queue = tsnep_get_queue_with_rx(adapter, 0);
+	if (queue)
+		ec->rx_coalesce_usecs = tsnep_get_irq_coalesce(queue);
+
+	queue = tsnep_get_queue_with_tx(adapter, 0);
+	if (queue)
+		ec->tx_coalesce_usecs = tsnep_get_irq_coalesce(queue);
+
+	return 0;
+}
+
+static int tsnep_ethtool_set_coalesce(struct net_device *netdev,
+				      struct ethtool_coalesce *ec,
+				      struct kernel_ethtool_coalesce *kernel_coal,
+				      struct netlink_ext_ack *extack)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	int i;
+	int retval;
+
+	for (i = 0; i < adapter->num_queues; i++) {
+		/* RX coalesce has priority for queues with TX and RX */
+		if (adapter->queue[i].rx)
+			retval = tsnep_set_irq_coalesce(&adapter->queue[i],
+							ec->rx_coalesce_usecs);
+		else
+			retval = tsnep_set_irq_coalesce(&adapter->queue[i],
+							ec->tx_coalesce_usecs);
+		if (retval != 0)
+			return retval;
+	}
+
+	return 0;
+}
+
+static int tsnep_ethtool_get_per_queue_coalesce(struct net_device *netdev,
+						u32 queue,
+						struct ethtool_coalesce *ec)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	struct tsnep_queue *queue_with_rx;
+	struct tsnep_queue *queue_with_tx;
+
+	if (queue >= max(adapter->num_tx_queues, adapter->num_rx_queues))
+		return -EINVAL;
+
+	queue_with_rx = tsnep_get_queue_with_rx(adapter, queue);
+	if (queue_with_rx)
+		ec->rx_coalesce_usecs = tsnep_get_irq_coalesce(queue_with_rx);
+
+	queue_with_tx = tsnep_get_queue_with_tx(adapter, queue);
+	if (queue_with_tx)
+		ec->tx_coalesce_usecs = tsnep_get_irq_coalesce(queue_with_tx);
+
+	return 0;
+}
+
+static int tsnep_ethtool_set_per_queue_coalesce(struct net_device *netdev,
+						u32 queue,
+						struct ethtool_coalesce *ec)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+	struct tsnep_queue *queue_with_rx;
+	struct tsnep_queue *queue_with_tx;
+	int retval;
+
+	if (queue >= max(adapter->num_tx_queues, adapter->num_rx_queues))
+		return -EINVAL;
+
+	queue_with_rx = tsnep_get_queue_with_rx(adapter, queue);
+	if (queue_with_rx) {
+		retval = tsnep_set_irq_coalesce(queue_with_rx, ec->rx_coalesce_usecs);
+		if (retval != 0)
+			return retval;
+	}
+
+	/* RX coalesce has priority for queues with TX and RX */
+	queue_with_tx = tsnep_get_queue_with_tx(adapter, queue);
+	if (queue_with_tx && !queue_with_tx->rx) {
+		retval = tsnep_set_irq_coalesce(queue_with_tx, ec->tx_coalesce_usecs);
+		if (retval != 0)
+			return retval;
+	}
+
+	return 0;
+}
+
 const struct ethtool_ops tsnep_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo = tsnep_ethtool_get_drvinfo,
 	.get_regs_len = tsnep_ethtool_get_regs_len,
 	.get_regs = tsnep_ethtool_get_regs,
@@ -340,6 +470,10 @@ const struct ethtool_ops tsnep_ethtool_ops = {
 	.set_rxnfc = tsnep_ethtool_set_rxnfc,
 	.get_channels = tsnep_ethtool_get_channels,
 	.get_ts_info = tsnep_ethtool_get_ts_info,
+	.get_coalesce = tsnep_ethtool_get_coalesce,
+	.set_coalesce = tsnep_ethtool_set_coalesce,
+	.get_per_queue_coalesce = tsnep_ethtool_get_per_queue_coalesce,
+	.set_per_queue_coalesce = tsnep_ethtool_set_per_queue_coalesce,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 };
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
index 13d5ff4e0e02..5e0d23dd2d42 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -39,6 +39,10 @@
 #endif
 #define DMA_ADDR_LOW(dma_addr) ((u32)((dma_addr) & 0xFFFFFFFF))
 
+#define TSNEP_COALESCE_USECS_DEFAULT 64
+#define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
+				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
+
 static void tsnep_enable_irq(struct tsnep_adapter *adapter, u32 mask)
 {
 	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
@@ -83,6 +87,33 @@ static irqreturn_t tsnep_irq_txrx(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+int tsnep_set_irq_coalesce(struct tsnep_queue *queue, u32 usecs)
+{
+	if (usecs > TSNEP_COALESCE_USECS_MAX)
+		return -ERANGE;
+
+	usecs /= ECM_INT_DELAY_BASE_US;
+	usecs <<= ECM_INT_DELAY_SHIFT;
+	usecs &= ECM_INT_DELAY_MASK;
+
+	queue->irq_delay &= ~ECM_INT_DELAY_MASK;
+	queue->irq_delay |= usecs;
+	iowrite8(queue->irq_delay, queue->irq_delay_addr);
+
+	return 0;
+}
+
+u32 tsnep_get_irq_coalesce(struct tsnep_queue *queue)
+{
+	u32 usecs;
+
+	usecs = (queue->irq_delay & ECM_INT_DELAY_MASK);
+	usecs >>= ECM_INT_DELAY_SHIFT;
+	usecs *= ECM_INT_DELAY_BASE_US;
+
+	return usecs;
+}
+
 static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
 {
 	struct tsnep_adapter *adapter = bus->priv;
@@ -1371,6 +1402,11 @@ static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 	adapter->queue[0].tx = &adapter->tx[0];
 	adapter->queue[0].rx = &adapter->rx[0];
 	adapter->queue[0].irq_mask = irq_mask;
+	adapter->queue[0].irq_delay_addr = adapter->addr + ECM_INT_DELAY;
+	retval = tsnep_set_irq_coalesce(&adapter->queue[0],
+					TSNEP_COALESCE_USECS_DEFAULT);
+	if (retval < 0)
+		return retval;
 
 	adapter->netdev->irq = adapter->queue[0].irq;
 
@@ -1391,6 +1427,12 @@ static int tsnep_queue_init(struct tsnep_adapter *adapter, int queue_count)
 		adapter->queue[i].rx = &adapter->rx[i];
 		adapter->queue[i].irq_mask =
 			irq_mask << (ECM_INT_TXRX_SHIFT * i);
+		adapter->queue[i].irq_delay_addr =
+			adapter->addr + ECM_INT_DELAY + ECM_INT_DELAY_OFFSET * i;
+		retval = tsnep_set_irq_coalesce(&adapter->queue[i],
+						TSNEP_COALESCE_USECS_DEFAULT);
+		if (retval < 0)
+			return retval;
 	}
 
 	return 0;
-- 
2.30.2

