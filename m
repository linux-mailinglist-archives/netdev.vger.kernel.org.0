Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB3B631116
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 22:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbiKSVSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 16:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiKSVSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 16:18:35 -0500
Received: from mx16lb.world4you.com (mx16lb.world4you.com [81.19.149.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CB510F5
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 13:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S1z9XfboDJDdtSnN5UHpyY9KNc9kGVVZ6jfFH7MsMqM=; b=iPuK0uC226ix0S3r2kr3X1118N
        JkERvCF9Bio+LGvqv8pOXyiD8WZ+inYysB5jtxcmdTnRgszIIxaVPR7+6wwFJraLKjDTK2ZUj+3Aa
        UPm1iUlYXX+te7xxaNVhGRYc05dY95XqiqGXqhfzW8S/57HNp1Mys/tFy7xJzLCriAnw=;
Received: from [88.117.56.227] (helo=hornet.engleder.at)
        by mx16lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1owVEL-0004eG-GI; Sat, 19 Nov 2022 22:18:29 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next] tsnep: Fix rotten packets
Date:   Sat, 19 Nov 2022 22:18:25 +0100
Message-Id: <20221119211825.81805-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
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

If PTP synchronisation is done every second, then sporadic the interval
is higher than one second:

ptp4l[696.582]: master offset        -17 s2 freq   -1891 path delay 573
ptp4l[697.582]: master offset        -22 s2 freq   -1901 path delay 573
ptp4l[699.368]: master offset         -1 s2 freq   -1887 path delay 573
      ^^^^^^^ Should be 698.582!

This problem is caused by rotten packets, which are received after
polling but before interrupts are enabled again. This can be fixed by
checking for pending work and rescheduling if necessary after interrupts
has been enabled again.

Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 57 +++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 48fb391951dd..13d5ff4e0e02 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -542,6 +542,27 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 	return (budget != 0);
 }
 
+static bool tsnep_tx_pending(struct tsnep_tx *tx)
+{
+	unsigned long flags;
+	struct tsnep_tx_entry *entry;
+	bool pending = false;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	if (tx->read != tx->write) {
+		entry = &tx->entry[tx->read];
+		if ((__le32_to_cpu(entry->desc_wb->properties) &
+		     TSNEP_TX_DESC_OWNER_MASK) ==
+		    (entry->properties & TSNEP_TX_DESC_OWNER_MASK))
+			pending = true;
+	}
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	return pending;
+}
+
 static int tsnep_tx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 			 int queue_index, struct tsnep_tx *tx)
 {
@@ -821,6 +842,19 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 	return done;
 }
 
+static bool tsnep_rx_pending(struct tsnep_rx *rx)
+{
+	struct tsnep_rx_entry *entry;
+
+	entry = &rx->entry[rx->read];
+	if ((__le32_to_cpu(entry->desc_wb->properties) &
+	     TSNEP_DESC_OWNER_COUNTER_MASK) ==
+	    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
+		return true;
+
+	return false;
+}
+
 static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 			 int queue_index, struct tsnep_rx *rx)
 {
@@ -866,6 +900,17 @@ static void tsnep_rx_close(struct tsnep_rx *rx)
 	tsnep_rx_ring_cleanup(rx);
 }
 
+static bool tsnep_pending(struct tsnep_queue *queue)
+{
+	if (queue->tx && tsnep_tx_pending(queue->tx))
+		return true;
+
+	if (queue->rx && tsnep_rx_pending(queue->rx))
+		return true;
+
+	return false;
+}
+
 static int tsnep_poll(struct napi_struct *napi, int budget)
 {
 	struct tsnep_queue *queue = container_of(napi, struct tsnep_queue,
@@ -886,9 +931,19 @@ static int tsnep_poll(struct napi_struct *napi, int budget)
 	if (!complete)
 		return budget;
 
-	if (likely(napi_complete_done(napi, done)))
+	if (likely(napi_complete_done(napi, done))) {
 		tsnep_enable_irq(queue->adapter, queue->irq_mask);
 
+		/* reschedule if work is already pending, prevent rotten packets
+		 * which are transmitted or received after polling but before
+		 * interrupt enable
+		 */
+		if (tsnep_pending(queue)) {
+			tsnep_disable_irq(queue->adapter, queue->irq_mask);
+			napi_schedule(napi);
+		}
+	}
+
 	return min(done, budget - 1);
 }
 
-- 
2.30.2

