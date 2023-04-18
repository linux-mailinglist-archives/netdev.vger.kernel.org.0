Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65006E6CA0
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjDRTFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbjDRTFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:05:11 -0400
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C116E8E;
        Tue, 18 Apr 2023 12:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ad78D/NezaURB5FDAeVbS8FIfyUkmpsrLqg/B5M52Zw=; b=qPc7NaoSsl5kfNX53vYE1p6eBB
        2otqgXkjrIxR/mzYvm4rIxtXdPB/5nYKgfI6ZmaRPK/Yxkj7g2+8HOhaSNYtq3JgCrB7BVhEAm5Pp
        V5gldeitVq9fZxcICIymTQUxv+VQHZtphLNEkpHnW/xI+t+VNEUPNutoSn+/ndhahN5Q=;
Received: from 88-117-57-231.adsl.highway.telekom.at ([88.117.57.231] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1poqdX-0002eV-EN; Tue, 18 Apr 2023 21:05:07 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 3/6] tsnep: Add functions for queue enable/disable
Date:   Tue, 18 Apr 2023 21:04:56 +0200
Message-Id: <20230418190459.19326-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230418190459.19326-1-gerhard@engleder-embedded.com>
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move queue enable and disable code to separate functions. This way the
activation and deactivation of the queues are defined actions, which can
be used in future execution paths.

This functions will be used for the queue reconfiguration at runtime,
which is necessary for XSK zero-copy support.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 97 ++++++++++++++--------
 1 file changed, 64 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 095d36e953fc..039629af6a43 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -866,6 +866,24 @@ static void tsnep_rx_init(struct tsnep_rx *rx)
 	rx->increment_owner_counter = TSNEP_RING_SIZE - 1;
 }
 
+static void tsnep_rx_enable(struct tsnep_rx *rx)
+{
+	/* descriptor properties shall be valid before hardware is notified */
+	dma_wmb();
+
+	iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
+}
+
+static void tsnep_rx_disable(struct tsnep_rx *rx)
+{
+	u32 val;
+
+	iowrite32(TSNEP_CONTROL_RX_DISABLE, rx->addr + TSNEP_CONTROL);
+	readx_poll_timeout(ioread32, rx->addr + TSNEP_CONTROL, val,
+			   ((val & TSNEP_CONTROL_RX_ENABLE) == 0), 10000,
+			   1000000);
+}
+
 static int tsnep_rx_desc_available(struct tsnep_rx *rx)
 {
 	if (rx->read <= rx->write)
@@ -932,19 +950,15 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
 	entry->desc->properties = __cpu_to_le32(entry->properties);
 }
 
-static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
+static int tsnep_rx_alloc(struct tsnep_rx *rx, int count, bool reuse)
 {
-	int index;
 	bool alloc_failed = false;
-	bool enable = false;
-	int i;
-	int retval;
+	int i, index;
 
 	for (i = 0; i < count && !alloc_failed; i++) {
 		index = (rx->write + i) & TSNEP_RING_MASK;
 
-		retval = tsnep_rx_alloc_buffer(rx, index);
-		if (unlikely(retval)) {
+		if (unlikely(tsnep_rx_alloc_buffer(rx, index))) {
 			rx->alloc_failed++;
 			alloc_failed = true;
 
@@ -956,22 +970,23 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 		}
 
 		tsnep_rx_activate(rx, index);
-
-		enable = true;
 	}
 
-	if (enable) {
+	if (i)
 		rx->write = (rx->write + i) & TSNEP_RING_MASK;
 
-		/* descriptor properties shall be valid before hardware is
-		 * notified
-		 */
-		dma_wmb();
+	return i;
+}
 
-		iowrite32(TSNEP_CONTROL_RX_ENABLE, rx->addr + TSNEP_CONTROL);
-	}
+static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
+{
+	int desc_refilled;
 
-	return i;
+	desc_refilled = tsnep_rx_alloc(rx, count, reuse);
+	if (desc_refilled)
+		tsnep_rx_enable(rx);
+
+	return desc_refilled;
 }
 
 static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
@@ -1199,6 +1214,7 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
 
 static int tsnep_rx_open(struct tsnep_rx *rx)
 {
+	int desc_available;
 	int retval;
 
 	retval = tsnep_rx_ring_create(rx);
@@ -1207,20 +1223,19 @@ static int tsnep_rx_open(struct tsnep_rx *rx)
 
 	tsnep_rx_init(rx);
 
-	tsnep_rx_refill(rx, tsnep_rx_desc_available(rx), false);
+	desc_available = tsnep_rx_desc_available(rx);
+	retval = tsnep_rx_alloc(rx, desc_available, false);
+	if (retval != desc_available) {
+		tsnep_rx_ring_cleanup(rx);
+
+		return -ENOMEM;
+	}
 
 	return 0;
 }
 
 static void tsnep_rx_close(struct tsnep_rx *rx)
 {
-	u32 val;
-
-	iowrite32(TSNEP_CONTROL_RX_DISABLE, rx->addr + TSNEP_CONTROL);
-	readx_poll_timeout(ioread32, rx->addr + TSNEP_CONTROL, val,
-			   ((val & TSNEP_CONTROL_RX_ENABLE) == 0), 10000,
-			   1000000);
-
 	tsnep_rx_ring_cleanup(rx);
 }
 
@@ -1377,6 +1392,27 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
 	return retval;
 }
 
+static void tsnep_queue_enable(struct tsnep_queue *queue)
+{
+	napi_enable(&queue->napi);
+	tsnep_enable_irq(queue->adapter, queue->irq_mask);
+
+	if (queue->rx)
+		tsnep_rx_enable(queue->rx);
+}
+
+static void tsnep_queue_disable(struct tsnep_queue *queue)
+{
+	napi_disable(&queue->napi);
+	tsnep_disable_irq(queue->adapter, queue->irq_mask);
+
+	/* disable RX after NAPI polling has been disabled, because RX can be
+	 * enabled during NAPI polling
+	 */
+	if (queue->rx)
+		tsnep_rx_disable(queue->rx);
+}
+
 static int tsnep_netdev_open(struct net_device *netdev)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
@@ -1413,11 +1449,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
 	if (retval)
 		goto phy_failed;
 
-	for (i = 0; i < adapter->num_queues; i++) {
-		napi_enable(&adapter->queue[i].napi);
-
-		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
-	}
+	for (i = 0; i < adapter->num_queues; i++)
+		tsnep_queue_enable(&adapter->queue[i]);
 
 	return 0;
 
@@ -1444,9 +1477,7 @@ static int tsnep_netdev_close(struct net_device *netdev)
 	tsnep_phy_close(adapter);
 
 	for (i = 0; i < adapter->num_queues; i++) {
-		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
-
-		napi_disable(&adapter->queue[i].napi);
+		tsnep_queue_disable(&adapter->queue[i]);
 
 		tsnep_queue_close(&adapter->queue[i], i == 0);
 
-- 
2.30.2

