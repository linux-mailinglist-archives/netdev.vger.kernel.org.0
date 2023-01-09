Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9750766301E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbjAITPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbjAITPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:15:32 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D6538B8
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/9VMDhSEzU8zqPLgjpTrpBAFfIcPrVuwGjBeg6TPd44=; b=ULky5jlP5lmcpGN45lR2xRX6UB
        1gOaH07fllA4+9Vb/WLcm9K8IWzE33HipPMuGwisqQ2rY7dQN1yFlpKIcXS6G6gLX97dnaz4+H0ji
        ufjbhGcne8INJkVMl4rMfCQZ5c3N9NY7oLOJXA1JTLjw/Iolv0X8fUQFcmm5XznYZ44U=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pExcF-0007WQ-Sc; Mon, 09 Jan 2023 20:15:27 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 01/10] tsnep: Use spin_lock_bh for TX
Date:   Mon,  9 Jan 2023 20:15:14 +0100
Message-Id: <20230109191523.12070-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230109191523.12070-1-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
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

TX processing is done only within BH context. Therefore, _irqsafe
variant is not necessary.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index bf0190e1d2ea..7cc5e2407809 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -434,7 +434,6 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 					 struct tsnep_tx *tx)
 {
-	unsigned long flags;
 	int count = 1;
 	struct tsnep_tx_entry *entry;
 	int length;
@@ -444,7 +443,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	if (skb_shinfo(skb)->nr_frags > 0)
 		count += skb_shinfo(skb)->nr_frags;
 
-	spin_lock_irqsave(&tx->lock, flags);
+	spin_lock_bh(&tx->lock);
 
 	if (tsnep_tx_desc_available(tx) < count) {
 		/* ring full, shall not happen because queue is stopped if full
@@ -452,7 +451,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 		 */
 		netif_stop_queue(tx->adapter->netdev);
 
-		spin_unlock_irqrestore(&tx->lock, flags);
+		spin_unlock_bh(&tx->lock);
 
 		return NETDEV_TX_BUSY;
 	}
@@ -468,7 +467,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 		tx->dropped++;
 
-		spin_unlock_irqrestore(&tx->lock, flags);
+		spin_unlock_bh(&tx->lock);
 
 		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
 
@@ -496,20 +495,19 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 		netif_stop_queue(tx->adapter->netdev);
 	}
 
-	spin_unlock_irqrestore(&tx->lock, flags);
+	spin_unlock_bh(&tx->lock);
 
 	return NETDEV_TX_OK;
 }
 
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
-	unsigned long flags;
 	int budget = 128;
 	struct tsnep_tx_entry *entry;
 	int count;
 	int length;
 
-	spin_lock_irqsave(&tx->lock, flags);
+	spin_lock_bh(&tx->lock);
 
 	do {
 		if (tx->read == tx->write)
@@ -568,18 +566,17 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		netif_wake_queue(tx->adapter->netdev);
 	}
 
-	spin_unlock_irqrestore(&tx->lock, flags);
+	spin_unlock_bh(&tx->lock);
 
 	return (budget != 0);
 }
 
 static bool tsnep_tx_pending(struct tsnep_tx *tx)
 {
-	unsigned long flags;
 	struct tsnep_tx_entry *entry;
 	bool pending = false;
 
-	spin_lock_irqsave(&tx->lock, flags);
+	spin_lock_bh(&tx->lock);
 
 	if (tx->read != tx->write) {
 		entry = &tx->entry[tx->read];
@@ -589,7 +586,7 @@ static bool tsnep_tx_pending(struct tsnep_tx *tx)
 			pending = true;
 	}
 
-	spin_unlock_irqrestore(&tx->lock, flags);
+	spin_unlock_bh(&tx->lock);
 
 	return pending;
 }
-- 
2.30.2

