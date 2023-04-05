Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44C56D8AA3
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbjDEWcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbjDEWcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18362139
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 15:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E2E664010
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 22:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508F0C4339B;
        Wed,  5 Apr 2023 22:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680733925;
        bh=96wROkufBOK/jQf9HBH4ar0Gljv0MXFtAtTNUvb0LSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EV+VeMITowVXVUACdNrZw1qYaJejlOUJ3Uc7Rs+UVKjg2ZzXXBecOUiFTIGeiq5LD
         I6ltFsNsCIvyTLwrFVOfsqVtUH9rh1Oi6tL3g6Mh4eOsfk2GNwm/tZL5McwOVb283l
         +2UKjZXBpfTss3RBm711V6mE/Sn3EzZqJErZQrH3NryHc5TlsfV0saEPUAmekwK1WJ
         RkvLO7rXhpB8+dy6PV23+RBVbJmANWe+mKnkWXZC96U+xlCj6v34ycE/s0jfW+CLzt
         tGem30xhTQMDnNBPOgFqYd0XyLh2C5bLioM1XNy4cx5UDMsm8yCtfs1gi6x5/vprRk
         dgfpfgryWSidg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next v3 6/7] bnxt: use new queue try_stop/try_wake macros
Date:   Wed,  5 Apr 2023 15:31:33 -0700
Message-Id: <20230405223134.94665-7-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405223134.94665-1-kuba@kernel.org>
References: <20230405223134.94665-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert bnxt to use new macros rather than open code the logic.
Two differences:
(1) bnxt_tx_int() will now only issue a memory barrier if it sees
    enough space on the ring to wake the queue. This should be fine,
    the mb() is between the writes to the ring pointers and checking
    queue state.
(2) we'll start the queue instead of waking on race, this should
    be safe inside the xmit handler.

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v3:
 - no change
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 40 ++++-------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8ff5a4f98d6f..de97bee25249 100644
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
+		if (!netif_txq_try_stop(txq, bnxt_tx_avail(bp, txr),
+					bp->tx_wake_thresh))
 			return NETDEV_TX_BUSY;
 	}
 
@@ -614,7 +596,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (netdev_xmit_more() && !tx_buf->is_push)
 			bnxt_txr_db_kick(bp, txr, prod);
 
-		bnxt_txr_netif_try_stop_queue(bp, txr, txq);
+		netif_txq_try_stop(txq, bnxt_tx_avail(bp, txr),
+				   bp->tx_wake_thresh);
 	}
 	return NETDEV_TX_OK;
 
@@ -708,17 +691,8 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
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
+	__netif_txq_maybe_wake(txq, bnxt_tx_avail(bp, txr), bp->tx_wake_thresh,
+			       READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING);
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
-- 
2.39.2

