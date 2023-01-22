Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F036771B2
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 20:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjAVTEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 14:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjAVTEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 14:04:35 -0500
Received: from mx16lb.world4you.com (mx16lb.world4you.com [81.19.149.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C566E13D6B
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 11:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ma87xJ/iqZK9HY8CoAubsxP86YcB2KaIqdIrrOf7iUk=; b=L6Oy1oEQ7gHMK/1ng6bH/JPsxM
        VNHj/Ov7aqQtQ96fjCXBI+yB6Z9qPozxtDj6bo636U7e9wUREMECpN/q2JRZKbiGxeGHGHXruBtF4
        31H0kQSC0xgt4ox27GOOlttvvAtnlZRm+OOCsEBGFvdEyUW7Npm8Wvilms2tJZEKbDnY=;
Received: from [88.117.49.184] (helo=hornet.engleder.at)
        by mx16lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pJfdm-0001oe-Gh; Sun, 22 Jan 2023 20:04:30 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next] tsnep: Fix TX queue stop/wake for multiple queues
Date:   Sun, 22 Jan 2023 20:04:25 +0100
Message-Id: <20230122190425.10041-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
 drivers/net/ethernet/engleder/tsnep_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index e9dfefba5973..c3cf427a9409 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -458,7 +458,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 		/* ring full, shall not happen because queue is stopped if full
 		 * below
 		 */
-		netif_stop_queue(tx->adapter->netdev);
+		netif_stop_subqueue(tx->adapter->netdev, tx->queue_index);
 
 		return NETDEV_TX_BUSY;
 	}
@@ -495,7 +495,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1)) {
 		/* ring can get full with next frame */
-		netif_stop_queue(tx->adapter->netdev);
+		netif_stop_subqueue(tx->adapter->netdev, tx->queue_index);
 	}
 
 	return NETDEV_TX_OK;
@@ -701,8 +701,8 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 	} while (likely(budget));
 
 	if ((tsnep_tx_desc_available(tx) >= ((MAX_SKB_FRAGS + 1) * 2)) &&
-	    netif_queue_stopped(tx->adapter->netdev)) {
-		netif_wake_queue(tx->adapter->netdev);
+	    netif_tx_queue_stopped(nq)) {
+		netif_tx_wake_queue(nq);
 	}
 
 	__netif_tx_unlock(nq);
-- 
2.30.2

