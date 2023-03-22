Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA1C6C5A5C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCVXa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCVXa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:30:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73D92D63
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 16:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDD2CB81E93
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 23:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64118C4339B;
        Wed, 22 Mar 2023 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679527853;
        bh=tJQFwAP+BtH3jAkdgrdJneDMfmk6i68LwgOjJP/bhLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVqv1wY6Tpaz8N+vVUsgDAFQNXFLnEaV4m0JReqKjELX6IDLaKfMvQUg5Hz1Xyq1W
         czHeexhumF1riOTKTOMaH1XYuQOJqbfwUc3NUfcHeGjFi3vZUfEZvLESYlpF0L9ZOB
         xB0nzFMqNso0m2jPdT96mVmQ/c1kPkbSn6S0Tv1q5k6LnbdB1JEGHrmqOI+cOYFsRO
         r/nVtgqbLs/tLGKSUN/F181dpLOTtzU5DVh6pHryHPpPpdiA7RkiG7gd6YTSzwXIPY
         liZ7yBZVdQNpCSdbNLhs1ugDGsCI0K4dLGMh+8SvIoFZcGdL61Rub2GgitYb1oeepw
         ZtTPU9IyvxN2Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, alexander.duyck@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] ixgbe: use new queue try_stop/try_wake macros
Date:   Wed, 22 Mar 2023 16:30:27 -0700
Message-Id: <20230322233028.269410-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322233028.269410-1-kuba@kernel.org>
References: <20230322233028.269410-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert ixgbe to use the new macros, I think a lot of people
copy the ixgbe code. The only functional change is that the
unlikely() in ixgbe_clean_tx_irq() turns into a likely()
inside the new macro and no longer includes

  total_packets && netif_carrier_ok(tx_ring->netdev)

which is probably for the best, anyway.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 37 +++++--------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 773c35fecace..db00e50a40ff 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -36,6 +36,7 @@
 #include <net/tc_act/tc_mirred.h>
 #include <net/vxlan.h>
 #include <net/mpls.h>
+#include <net/netdev_queues.h>
 #include <net/xdp_sock_drv.h>
 #include <net/xfrm.h>
 
@@ -1253,20 +1254,12 @@ static bool ixgbe_clean_tx_irq(struct ixgbe_q_vector *q_vector,
 				  total_packets, total_bytes);
 
 #define TX_WAKE_THRESHOLD (DESC_NEEDED * 2)
-	if (unlikely(total_packets && netif_carrier_ok(tx_ring->netdev) &&
-		     (ixgbe_desc_unused(tx_ring) >= TX_WAKE_THRESHOLD))) {
-		/* Make sure that anybody stopping the queue after this
-		 * sees the new next_to_clean.
-		 */
-		smp_mb();
-		if (__netif_subqueue_stopped(tx_ring->netdev,
-					     tx_ring->queue_index)
-		    && !test_bit(__IXGBE_DOWN, &adapter->state)) {
-			netif_wake_subqueue(tx_ring->netdev,
-					    tx_ring->queue_index);
-			++tx_ring->tx_stats.restart_queue;
-		}
-	}
+	if (total_packets && netif_carrier_ok(tx_ring->netdev) &&
+	    !__netif_subqueue_maybe_wake(tx_ring->netdev, tx_ring->queue_index,
+					 ixgbe_desc_unused(tx_ring),
+					 TX_WAKE_THRESHOLD,
+					 test_bit(__IXGBE_DOWN, &adapter->state)))
+		++tx_ring->tx_stats.restart_queue;
 
 	return !!budget;
 }
@@ -8270,22 +8263,10 @@ static void ixgbe_tx_olinfo_status(union ixgbe_adv_tx_desc *tx_desc,
 
 static int __ixgbe_maybe_stop_tx(struct ixgbe_ring *tx_ring, u16 size)
 {
-	netif_stop_subqueue(tx_ring->netdev, tx_ring->queue_index);
-
-	/* Herbert's original patch had:
-	 *  smp_mb__after_netif_stop_queue();
-	 * but since that doesn't exist yet, just open code it.
-	 */
-	smp_mb();
-
-	/* We need to check again in a case another CPU has just
-	 * made room available.
-	 */
-	if (likely(ixgbe_desc_unused(tx_ring) < size))
+	if (!netif_subqueue_try_stop(tx_ring->netdev, tx_ring->queue_index,
+				     ixgbe_desc_unused(tx_ring), size))
 		return -EBUSY;
 
-	/* A reprieve! - use start_queue because it doesn't call schedule */
-	netif_start_subqueue(tx_ring->netdev, tx_ring->queue_index);
 	++tx_ring->tx_stats.restart_queue;
 	return 0;
 }
-- 
2.39.2

