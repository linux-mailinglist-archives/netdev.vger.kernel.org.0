Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0EC6D3A09
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 21:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDBTi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 15:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjDBTiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 15:38:54 -0400
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEE5AD04;
        Sun,  2 Apr 2023 12:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XJYgTM6hC5vPLx4y1Yyz67wu8NxCOMBdgWh/s2B5zc8=; b=wRGuEHCpD5PxQhLZB60588Emkm
        nCMSW3beMI7NOSIe45t+6uFDqX5qfcjK/k75AgqXqIKhgOg7fvIJ71uiPNyfyUw9yMuIJ3LmV3w5Q
        168eqYi25E/1+7oVWll69SnyG9GR9IOsQjJRwDesRQlGL569MfGn28s4iSoalsuwxWLo=;
Received: from 88-117-56-218.adsl.highway.telekom.at ([88.117.56.218] helo=hornet.engleder.at)
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pj3XP-0007Gn-Dg; Sun, 02 Apr 2023 21:38:51 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 2/5] tsnep: Add functions for queue enable/disable
Date:   Sun,  2 Apr 2023 21:38:35 +0200
Message-Id: <20230402193838.54474-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230402193838.54474-1-gerhard@engleder-embedded.com>
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
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
 drivers/net/ethernet/engleder/tsnep_main.c | 94 +++++++++++++++-------
 1 file changed, 63 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index f2162a25e97c..c49e1d322def 100644
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
@@ -932,13 +950,10 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
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
+	int i, index, retval;
 
 	for (i = 0; i < count && !alloc_failed; i++) {
 		index = (rx->write + i) % TSNEP_RING_SIZE;
@@ -956,22 +971,23 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 		}
 
 		tsnep_rx_activate(rx, index);
-
-		enable = true;
 	}
 
-	if (enable) {
+	if (i)
 		rx->write = (rx->write + i) % TSNEP_RING_SIZE;
 
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
@@ -1199,6 +1215,7 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
 
 static int tsnep_rx_open(struct tsnep_rx *rx)
 {
+	int desc_available;
 	int retval;
 
 	retval = tsnep_rx_ring_create(rx);
@@ -1207,20 +1224,19 @@ static int tsnep_rx_open(struct tsnep_rx *rx)
 
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
 
@@ -1379,6 +1395,27 @@ static int tsnep_queue_open(struct tsnep_adapter *adapter,
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
@@ -1415,11 +1452,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
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
 
@@ -1446,9 +1480,7 @@ static int tsnep_netdev_close(struct net_device *netdev)
 	tsnep_phy_close(adapter);
 
 	for (i = 0; i < adapter->num_queues; i++) {
-		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
-
-		napi_disable(&adapter->queue[i].napi);
+		tsnep_queue_disable(&adapter->queue[i]);
 
 		tsnep_queue_close(&adapter->queue[i], i == 0);
 
-- 
2.30.2

