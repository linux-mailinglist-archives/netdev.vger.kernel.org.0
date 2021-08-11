Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D07E3E9A72
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhHKVil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhHKVif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 17:38:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C316461058;
        Wed, 11 Aug 2021 21:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628717891;
        bh=wdyVY3R03IHB/Nh75ncQqgmTDMEvafXIvuM/ZyeyZOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXb5GeY2XLdEkEUKfAdCRPSMn7gcdCaoFl3xZHdfZinTx81XVplMVB3pZBgrHyHYV
         GtGrLYb82go081vc8GAnBbd3C7cg4yh8EBCf7gDgUUwFxwUMm+UFFSZg4j0TXWrn46
         Hq5MIGbS4FU+WtAmful+1ECNW2gWc5J0Cz9W3et9t2o55IltwbhEZYToTOtibM6073
         TmTFhlhVu9b91tGIP/gHrDKkWWxK1GWHH7Qo/RY2PE7tyGX4dFvUo2TsbxxDS1YwPV
         /V0utM4VOQdfRyB/74EiWzR0pyyHbKNnj7WIC9WSDtaBDWQEkDJlXTv3D15VmWEC5M
         8fgcRbc2taDMg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 1/4] bnxt: don't lock the tx queue from napi poll
Date:   Wed, 11 Aug 2021 14:37:46 -0700
Message-Id: <20210811213749.3276687-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811213749.3276687-1-kuba@kernel.org>
References: <20210811213749.3276687-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't take the tx lock from the napi poll routine, because
netpoll can poll napi at any moment, including with the tx lock
already held.

It seems that the tx lock is only protecting against the disable
path, appropriate barriers are already in place to make sure
cleanup can safely run concurrently with start_xmit. I don't see
any other reason why 'stopped && avail > thresh' needs to be
re-checked under the lock.

Remove the tx lock and use synchronize_net() to make sure
closing the device does not race we restarting the queues.
Annotate accesses to dev_state against data races.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: keep the unlikely in bnxt_tx_int() [Edwin]
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 865fcb8cf29f..365f8ae91acb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -731,14 +731,9 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
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
@@ -9264,9 +9259,11 @@ void bnxt_tx_disable(struct bnxt *bp)
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
@@ -9280,8 +9277,10 @@ void bnxt_tx_enable(struct bnxt *bp)
 
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

