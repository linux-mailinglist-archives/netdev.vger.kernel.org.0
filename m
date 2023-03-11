Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9593C6B584A
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCKFBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCKFBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:01:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCFE13C374
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 740AEB82432
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 05:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E90C433A0;
        Sat, 11 Mar 2023 05:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678510898;
        bh=agEBpcxbVG06mVHh7F8o6z0MDZqopyTL4eBC+J32KyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVCKBSv+kk6HM//tuJxVD1eswYZ6R19c9vjFANewWbPVoRvbES0nBDAwR63zGeZ3F
         hZrdjsHgo1vYng6Upd40AqfzYdPtOOArOSVwY0t6WnEhzuvs2kO1WpJ0T7NLY0/NuH
         LjTQP3C5oXBu2ru447PDJ8iLeYlIaJbNOy3269G/btb5WSgUm1mfhDvfhLq6pllkbi
         LrqotFamxMspAoCIH5oWAYRszrunCj7sf66N8st4RCESixfs5ryL1+5FlHm4MocR4h
         31BUfHJYTEiZ6Juj3heu+gMFob6Op1Kb3RM4fjY73j1OFVmGm4X80sN7S4jKy27Qey
         +HTtSQwNaQhpA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     alexanderduyck@fb.com, roman.gushchin@linux.dev,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 3/3] bnxt: use new queue try_stop/try_wake macros
Date:   Fri, 10 Mar 2023 21:01:30 -0800
Message-Id: <20230311050130.115138-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230311050130.115138-1-kuba@kernel.org>
References: <20230311050130.115138-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert bnxt to use new macros rather than open code the logic.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 41 +++++------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dceaecab6605..b52d1e5d0ac7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -56,6 +56,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <net/page_pool.h>
 #include <linux/align.h>
+#include <net/netdev_queues.h>
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
@@ -331,26 +332,6 @@ static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
 	txr->kick_pending = 0;
 }
 
-static bool bnxt_txr_netif_try_stop_queue(struct bnxt *bp,
-					  struct bnxt_tx_ring_info *txr,
-					  struct netdev_queue *txq)
-{
-	netif_tx_stop_queue(txq);
-
-	/* netif_tx_stop_queue() must be done before checking
-	 * tx index in bnxt_tx_avail() below, because in
-	 * bnxt_tx_int(), we update tx index before checking for
-	 * netif_tx_queue_stopped().
-	 */
-	smp_mb();
-	if (bnxt_tx_avail(bp, txr) >= bp->tx_wake_thresh) {
-		netif_tx_wake_queue(txq);
-		return false;
-	}
-
-	return true;
-}
-
 static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -384,7 +365,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (net_ratelimit() && txr->kick_pending)
 			netif_warn(bp, tx_err, dev,
 				   "bnxt: ring busy w/ flush pending!\n");
-		if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
+		if (!netif_tx_queue_try_stop(txq, bnxt_tx_avail(bp, txr),
+					     bp->tx_wake_thresh))
 			return NETDEV_TX_BUSY;
 	}
 
@@ -614,7 +596,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (netdev_xmit_more() && !tx_buf->is_push)
 			bnxt_txr_db_kick(bp, txr, prod);
 
-		bnxt_txr_netif_try_stop_queue(bp, txr, txq);
+		netif_tx_queue_try_stop(txq, bnxt_tx_avail(bp, txr),
+					bp->tx_wake_thresh);
 	}
 	return NETDEV_TX_OK;
 
@@ -708,17 +691,9 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	netdev_tx_completed_queue(txq, nr_pkts, tx_bytes);
 	txr->tx_cons = cons;
 
-	/* Need to make the tx_cons update visible to bnxt_start_xmit()
-	 * before checking for netif_tx_queue_stopped().  Without the
-	 * memory barrier, there is a small possibility that bnxt_start_xmit()
-	 * will miss it and cause the queue to be stopped forever.
-	 */
-	smp_mb();
-
-	if (unlikely(netif_tx_queue_stopped(txq)) &&
-	    bnxt_tx_avail(bp, txr) >= bp->tx_wake_thresh &&
-	    READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING)
-		netif_tx_wake_queue(txq);
+	__netif_tx_queue_maybe_wake(txq, bnxt_tx_avail(bp, txr),
+				    bp->tx_wake_thresh,
+				    READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING);
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
-- 
2.39.2

