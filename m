Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9C058938A
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 22:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbiHCUuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 16:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbiHCUuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 16:50:09 -0400
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3015C96F
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 13:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+WFpUtNm6KQ8tMxf0+2OnIZvUX8JYDdXALzEIVWj4gw=; b=fah4oCqmaRqmQzjPB4e31Jdl/w
        9ymmFZjNc7UpMMO53Y93rTgpW/8GmiwLGEKhYr6xgwV3P91+sDoOVAPBlN/urfL9bWPyvZLae3ojB
        nREOe0d73AXMHG8ByGSGLH+qzEm8h99Y+bheZ9AMxtZ2+mpoA73PwtaM7KWqjcja7H1E=;
Received: from 88-117-54-219.adsl.highway.telekom.at ([88.117.54.219] helo=hornet.engleder.at)
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oJLJb-0001TF-Sc; Wed, 03 Aug 2022 22:50:03 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 3/6] tsnep: Improve TX length handling
Date:   Wed,  3 Aug 2022 22:49:44 +0200
Message-Id: <20220803204947.52789-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803204947.52789-1-gerhard@engleder-embedded.com>
References: <20220803204947.52789-1-gerhard@engleder-embedded.com>
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

TX length can by calculated more efficient during map and unmap of
fragments. Another reason is that, by moving TX statistic counting to
tsnep_tx_poll() it can be used there for XDP too.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 32 ++++++++++++++--------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 203039671040..3cae485e8689 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -262,14 +262,14 @@ static int tsnep_tx_ring_init(struct tsnep_tx *tx)
 	return retval;
 }
 
-static void tsnep_tx_activate(struct tsnep_tx *tx, int index, bool last)
+static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
+			      bool last)
 {
 	struct tsnep_tx_entry *entry = &tx->entry[index];
 
 	entry->properties = 0;
 	if (entry->skb) {
-		entry->properties =
-			skb_pagelen(entry->skb) & TSNEP_DESC_LENGTH_MASK;
+		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
 		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
 		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
 			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
@@ -334,6 +334,7 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 	struct tsnep_tx_entry *entry;
 	unsigned int len;
 	dma_addr_t dma;
+	int map_len = 0;
 	int i;
 
 	for (i = 0; i < count; i++) {
@@ -356,15 +357,18 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 		dma_unmap_addr_set(entry, dma, dma);
 
 		entry->desc->tx = __cpu_to_le64(dma);
+
+		map_len += len;
 	}
 
-	return 0;
+	return map_len;
 }
 
-static void tsnep_tx_unmap(struct tsnep_tx *tx, int count)
+static int tsnep_tx_unmap(struct tsnep_tx *tx, int count)
 {
 	struct device *dmadev = tx->adapter->dmadev;
 	struct tsnep_tx_entry *entry;
+	int map_len = 0;
 	int i;
 
 	for (i = 0; i < count; i++) {
@@ -381,9 +385,12 @@ static void tsnep_tx_unmap(struct tsnep_tx *tx, int count)
 					       dma_unmap_addr(entry, dma),
 					       dma_unmap_len(entry, len),
 					       DMA_TO_DEVICE);
+			map_len += entry->len;
 			entry->len = 0;
 		}
 	}
+
+	return map_len;
 }
 
 static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
@@ -392,6 +399,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	unsigned long flags;
 	int count = 1;
 	struct tsnep_tx_entry *entry;
+	int length;
 	int i;
 	int retval;
 
@@ -415,7 +423,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	entry->skb = skb;
 
 	retval = tsnep_tx_map(skb, tx, count);
-	if (retval != 0) {
+	if (retval < 0) {
 		tsnep_tx_unmap(tx, count);
 		dev_kfree_skb_any(entry->skb);
 		entry->skb = NULL;
@@ -428,12 +436,13 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 		return NETDEV_TX_OK;
 	}
+	length = retval;
 
 	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 	for (i = 0; i < count; i++)
-		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE,
+		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
 				  i == (count - 1));
 	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
 
@@ -449,9 +458,6 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 		netif_stop_queue(tx->adapter->netdev);
 	}
 
-	tx->packets++;
-	tx->bytes += skb_pagelen(entry->skb) + ETH_FCS_LEN;
-
 	spin_unlock_irqrestore(&tx->lock, flags);
 
 	return NETDEV_TX_OK;
@@ -463,6 +469,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 	int budget = 128;
 	struct tsnep_tx_entry *entry;
 	int count;
+	int length;
 
 	spin_lock_irqsave(&tx->lock, flags);
 
@@ -485,7 +492,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		if (skb_shinfo(entry->skb)->nr_frags > 0)
 			count += skb_shinfo(entry->skb)->nr_frags;
 
-		tsnep_tx_unmap(tx, count);
+		length = tsnep_tx_unmap(tx, count);
 
 		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
 		    (__le32_to_cpu(entry->desc_wb->properties) &
@@ -512,6 +519,9 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 
 		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
 
+		tx->packets++;
+		tx->bytes += length + ETH_FCS_LEN;
+
 		budget--;
 	} while (likely(budget));
 
-- 
2.30.2

