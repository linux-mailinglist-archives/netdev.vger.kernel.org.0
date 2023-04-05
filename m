Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E572E6D8AA4
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbjDEWcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbjDEWcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16D3192
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 15:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0F4464005
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 22:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36D4C4339C;
        Wed,  5 Apr 2023 22:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680733925;
        bh=xAMqO4DeOSUkTNfEaIQZIKFTVRU+4+kT6XxZlpWpcN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJCrgCuD1XTsXqjmAosJ9epqVOqEszEwwoPn1mOlfJ5938V31Z1r0NNH6fDRTDNOi
         V326yr6egSX166ydCL3ZbPHCd/Oq/4pqY3FhW42hMT81hItMMtDwNTiX73LGasXLD+
         OTG739KZNz8PhzT8Azg0sWErX7uiNh1fiGO26Y/spqjcngIW+3EtPfseOWMugowsI5
         cyMdR107ZKLLoA+435HAm9eU3bc/65YoGqnmTLJ50g28CO7ln4jqhq/xzCnBnnO1qN
         efOLHd4CHviQizzuV0FGqH6Rz4U0jZiKGWdX3s+fIF8/ANnXQ0QtWOarAZUvUX5RrM
         NwmyF9C3aRNEw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next v3 5/7] ixgbe: use new queue try_stop/try_wake macros
Date:   Wed,  5 Apr 2023 15:31:32 -0700
Message-Id: <20230405223134.94665-6-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405223134.94665-1-kuba@kernel.org>
References: <20230405223134.94665-1-kuba@kernel.org>
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
v3:
 - call netdev_get_tx_queue() locally, avoid the need for
   another layer of macros in the core

CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 38 +++++--------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 773c35fecace..cbbddee55db1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -36,6 +36,7 @@
 #include <net/tc_act/tc_mirred.h>
 #include <net/vxlan.h>
 #include <net/mpls.h>
+#include <net/netdev_queues.h>
 #include <net/xdp_sock_drv.h>
 #include <net/xfrm.h>
 
@@ -1119,6 +1120,7 @@ static bool ixgbe_clean_tx_irq(struct ixgbe_q_vector *q_vector,
 	unsigned int total_bytes = 0, total_packets = 0, total_ipsec = 0;
 	unsigned int budget = q_vector->tx.work_limit;
 	unsigned int i = tx_ring->next_to_clean;
+	struct netdev_queue *txq;
 
 	if (test_bit(__IXGBE_DOWN, &adapter->state))
 		return true;
@@ -1253,20 +1255,12 @@ static bool ixgbe_clean_tx_irq(struct ixgbe_q_vector *q_vector,
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
+	txq = netdev_get_tx_queue(tx_ring->netdev, tx_ring->queue_index);
+	if (total_packets && netif_carrier_ok(tx_ring->netdev) &&
+	    !__netif_txq_maybe_wake(txq, ixgbe_desc_unused(tx_ring),
+				    TX_WAKE_THRESHOLD,
+				    test_bit(__IXGBE_DOWN, &adapter->state)))
+		++tx_ring->tx_stats.restart_queue;
 
 	return !!budget;
 }
@@ -8270,22 +8264,10 @@ static void ixgbe_tx_olinfo_status(union ixgbe_adv_tx_desc *tx_desc,
 
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

