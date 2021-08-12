Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4583EACBD
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbhHLVnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhHLVnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 17:43:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E8EC60F57;
        Thu, 12 Aug 2021 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628804565;
        bh=DNT6HQJNXRLzKDQYkiR4P7CrxnbFyl8lONuvJTYR9+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d00a2agi3+ScYxGmGFegxWuH9GVYH8wVvLfLU27J6L1kRiLpcfUuo4xrbjIpJdcib
         la9IiYl2etOWe5rVrVPRf/vGTNryLhMua3QNhy6/g5RYB/eTDf0ueWdYLDN+q+y6dk
         hC1DM6ctu3qoITO9jYGUyVBBnd2olukj/BorUvLVQMGiDYKyjG6cJ9VKzIsPsCoJ7Z
         fyRg7l5COgVJdOaMJijlEpepFtq7Y7xK0QSOTFt6RI900hD4Lw8yUFuuIJI1+XvA82
         7KDbEPc8hAK9nZLI7odUOuwtcLxR1jYYfxcy0XggbV8WPIHFKTsVFItcQ/uv6iWEpx
         EPlOdk9PkaAng==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        prashant@broadcom.com, eddie.wai@broadcom.com,
        huangjw@broadcom.com, gospo@broadcom.com, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 1/4] bnxt: don't lock the tx queue from napi poll
Date:   Thu, 12 Aug 2021 14:42:39 -0700
Message-Id: <20210812214242.578039-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812214242.578039-1-kuba@kernel.org>
References: <20210812214242.578039-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't take the tx lock from the napi poll routine, because
netpoll can poll napi at any moment, including with the tx lock
already held.

The tx lock is protecting against two paths - the disable
path, and (as Michael points out) the NETDEV_TX_BUSY case
which may occur if NAPI completions race with start_xmit
and both decide to re-enable the queue.

For the disable/ifdown path use synchronize_net() to make sure
closing the device does not race we restarting the queues.
Annotate accesses to dev_state against data races.

For the NAPI cleanup vs start_xmit path - appropriate barriers
are already in place in the main spot where Tx queue is stopped
but we need to do the same careful dance in the TX_BUSY case.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: keep the unlikely in bnxt_tx_int() [Edwin]
v3: be careful about stopping in the BUSY case [Michael]
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 54 ++++++++++++++---------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2fe743503949..84aa25875050 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -365,6 +365,26 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
 	return md_dst->u.port_info.port_id;
 }
 
+static bool bnxt_txr_netif_try_stop_queue(struct bnxt *bp,
+					  struct bnxt_tx_ring_info *txr,
+					  struct netdev_queue *txq)
+{
+	netif_tx_stop_queue(txq);
+
+	/* netif_tx_stop_queue() must be done before checking
+	 * tx index in bnxt_tx_avail() below, because in
+	 * bnxt_tx_int(), we update tx index before checking for
+	 * netif_tx_queue_stopped().
+	 */
+	smp_mb();
+	if (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh) {
+		netif_tx_wake_queue(txq);
+		return false;
+	}
+
+	return true;
+}
+
 static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -393,8 +413,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
-		netif_tx_stop_queue(txq);
-		return NETDEV_TX_BUSY;
+		if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
+			return NETDEV_TX_BUSY;
 	}
 
 	length = skb->len;
@@ -626,16 +646,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (netdev_xmit_more() && !tx_buf->is_push)
 			bnxt_db_write(bp, &txr->tx_db, prod);
 
-		netif_tx_stop_queue(txq);
-
-		/* netif_tx_stop_queue() must be done before checking
-		 * tx index in bnxt_tx_avail() below, because in
-		 * bnxt_tx_int(), we update tx index before checking for
-		 * netif_tx_queue_stopped().
-		 */
-		smp_mb();
-		if (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)
-			netif_tx_wake_queue(txq);
+		bnxt_txr_netif_try_stop_queue(bp, txr, txq);
 	}
 	return NETDEV_TX_OK;
 
@@ -732,14 +743,9 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	smp_mb();
 
 	if (unlikely(netif_tx_queue_stopped(txq)) &&
-	    (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)) {
-		__netif_tx_lock(txq, smp_processor_id());
-		if (netif_tx_queue_stopped(txq) &&
-		    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
-		    txr->dev_state != BNXT_DEV_STATE_CLOSING)
-			netif_tx_wake_queue(txq);
-		__netif_tx_unlock(txq);
-	}
+	    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
+	    READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING)
+		netif_tx_wake_queue(txq);
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
@@ -9165,9 +9171,11 @@ void bnxt_tx_disable(struct bnxt *bp)
 	if (bp->tx_ring) {
 		for (i = 0; i < bp->tx_nr_rings; i++) {
 			txr = &bp->tx_ring[i];
-			txr->dev_state = BNXT_DEV_STATE_CLOSING;
+			WRITE_ONCE(txr->dev_state, BNXT_DEV_STATE_CLOSING);
 		}
 	}
+	/* Make sure napi polls see @dev_state change */
+	synchronize_net();
 	/* Drop carrier first to prevent TX timeout */
 	netif_carrier_off(bp->dev);
 	/* Stop all TX queues */
@@ -9181,8 +9189,10 @@ void bnxt_tx_enable(struct bnxt *bp)
 
 	for (i = 0; i < bp->tx_nr_rings; i++) {
 		txr = &bp->tx_ring[i];
-		txr->dev_state = 0;
+		WRITE_ONCE(txr->dev_state, 0);
 	}
+	/* Make sure napi polls see @dev_state change */
+	synchronize_net();
 	netif_tx_wake_all_queues(bp->dev);
 	if (bp->link_info.link_up)
 		netif_carrier_on(bp->dev);
-- 
2.31.1

