Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C3966D024
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjAPUZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbjAPUZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:17 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4070265AE
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Tb+O1eGDg1FCvTjZHuBMs6k3mXi1YWTReFPzbma+4/k=; b=gm7YviKyPFXWWcORuC9mMEj1+U
        4XXgjTp5ht0pWMwABXfdYlzLU9my1JT5aFZQYMMyS1pgPS9SPgRb9/+t7fX6FpSiVpYIKL1eTWoJI
        4b3YTM/9guJ/GNBHhiGHOkBOLI5AvZV5fbCAcYYehMAWz8w1x0XB0ZI/HCAge/Xw/c0I=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2Y-00018Q-5o; Mon, 16 Jan 2023 21:25:10 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v5 1/9] tsnep: Replace TX spin_lock with __netif_tx_lock
Date:   Mon, 16 Jan 2023 21:24:50 +0100
Message-Id: <20230116202458.56677-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX spin_lock can be eliminated, because the normal TX path is already
protected with __netif_tx_lock and this lock can be used for access to
queue outside of normal TX path too.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  2 --
 drivers/net/ethernet/engleder/tsnep_main.c | 29 ++++++++--------------
 2 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index f93ba48bac3f..48910cb1bd8a 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -78,8 +78,6 @@ struct tsnep_tx {
 	void *page[TSNEP_RING_PAGE_COUNT];
 	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
 
-	/* TX ring lock */
-	spinlock_t lock;
 	struct tsnep_tx_entry entry[TSNEP_RING_SIZE];
 	int write;
 	int read;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index bf0190e1d2ea..c182c40277dd 100644
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
@@ -444,16 +443,12 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	if (skb_shinfo(skb)->nr_frags > 0)
 		count += skb_shinfo(skb)->nr_frags;
 
-	spin_lock_irqsave(&tx->lock, flags);
-
 	if (tsnep_tx_desc_available(tx) < count) {
 		/* ring full, shall not happen because queue is stopped if full
 		 * below
 		 */
 		netif_stop_queue(tx->adapter->netdev);
 
-		spin_unlock_irqrestore(&tx->lock, flags);
-
 		return NETDEV_TX_BUSY;
 	}
 
@@ -468,8 +463,6 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 		tx->dropped++;
 
-		spin_unlock_irqrestore(&tx->lock, flags);
-
 		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
 
 		return NETDEV_TX_OK;
@@ -496,20 +489,19 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 		netif_stop_queue(tx->adapter->netdev);
 	}
 
-	spin_unlock_irqrestore(&tx->lock, flags);
-
 	return NETDEV_TX_OK;
 }
 
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
-	unsigned long flags;
-	int budget = 128;
 	struct tsnep_tx_entry *entry;
-	int count;
+	struct netdev_queue *nq;
+	int budget = 128;
 	int length;
+	int count;
 
-	spin_lock_irqsave(&tx->lock, flags);
+	nq = netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
+	__netif_tx_lock(nq, smp_processor_id());
 
 	do {
 		if (tx->read == tx->write)
@@ -568,18 +560,19 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		netif_wake_queue(tx->adapter->netdev);
 	}
 
-	spin_unlock_irqrestore(&tx->lock, flags);
+	__netif_tx_unlock(nq);
 
 	return (budget != 0);
 }
 
 static bool tsnep_tx_pending(struct tsnep_tx *tx)
 {
-	unsigned long flags;
 	struct tsnep_tx_entry *entry;
+	struct netdev_queue *nq;
 	bool pending = false;
 
-	spin_lock_irqsave(&tx->lock, flags);
+	nq = netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
+	__netif_tx_lock(nq, smp_processor_id());
 
 	if (tx->read != tx->write) {
 		entry = &tx->entry[tx->read];
@@ -589,7 +582,7 @@ static bool tsnep_tx_pending(struct tsnep_tx *tx)
 			pending = true;
 	}
 
-	spin_unlock_irqrestore(&tx->lock, flags);
+	__netif_tx_unlock(nq);
 
 	return pending;
 }
@@ -615,8 +608,6 @@ static int tsnep_tx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	tx->owner_counter = 1;
 	tx->increment_owner_counter = TSNEP_RING_SIZE - 1;
 
-	spin_lock_init(&tx->lock);
-
 	return 0;
 }
 
-- 
2.30.2

