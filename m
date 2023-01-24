Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A9367A272
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 20:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjAXTPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 14:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjAXTPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 14:15:03 -0500
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292054B4AD
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4T78B+RlxXXg+VLUQmY0eyW1+b4sW26iTrlsx3knAo8=; b=FTe6A08EK+hqQh8Gt1nl8M3r/8
        balKSXT4fDhzwIPgeiHWxjtUBPAJeeKsYP5/nU7IPJSVmWTd+0WEcyu0NB6ODGvkF04yDmJ4BWa+f
        Lad5770IbTIxSCep48EmMbWakfurQrGu7J8T70hGW+zU8ywMVDfwtV7AhmQWNEyl+J2E=;
Received: from [88.117.49.184] (helo=hornet.engleder.at)
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pKOl2-0006Ms-A2; Tue, 24 Jan 2023 20:15:00 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net] tsnep: Fix TX queue stop/wake for multiple queues
Date:   Tue, 24 Jan 2023 20:14:40 +0100
Message-Id: <20230124191440.56887-1-gerhard@engleder-embedded.com>
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

netif_stop_queue() and netif_wake_queue() act on TX queue 0. This is ok
as long as only a single TX queue is supported. But support for multiple
TX queues was introduced with 762031375d5c and I missed to adapt stop
and wake of TX queues.

Use netif_stop_subqueue() and netif_tx_wake_queue() to act on specific
TX queue.

Fixes: 762031375d5c ("tsnep: Support multiple TX/RX queue pairs")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index bf0190e1d2ea..00e2108f2ca4 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -450,7 +450,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 		/* ring full, shall not happen because queue is stopped if full
 		 * below
 		 */
-		netif_stop_queue(tx->adapter->netdev);
+		netif_stop_subqueue(tx->adapter->netdev, tx->queue_index);
 
 		spin_unlock_irqrestore(&tx->lock, flags);
 
@@ -493,7 +493,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1)) {
 		/* ring can get full with next frame */
-		netif_stop_queue(tx->adapter->netdev);
+		netif_stop_subqueue(tx->adapter->netdev, tx->queue_index);
 	}
 
 	spin_unlock_irqrestore(&tx->lock, flags);
@@ -503,11 +503,14 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
+	struct tsnep_tx_entry *entry;
+	struct netdev_queue *nq;
 	unsigned long flags;
 	int budget = 128;
-	struct tsnep_tx_entry *entry;
-	int count;
 	int length;
+	int count;
+
+	nq = netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
 
 	spin_lock_irqsave(&tx->lock, flags);
 
@@ -564,8 +567,8 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 	} while (likely(budget));
 
 	if ((tsnep_tx_desc_available(tx) >= ((MAX_SKB_FRAGS + 1) * 2)) &&
-	    netif_queue_stopped(tx->adapter->netdev)) {
-		netif_wake_queue(tx->adapter->netdev);
+	    netif_tx_queue_stopped(nq)) {
+		netif_tx_wake_queue(nq);
 	}
 
 	spin_unlock_irqrestore(&tx->lock, flags);
-- 
2.30.2

