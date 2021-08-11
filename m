Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1BC3E98CC
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhHKTdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhHKTdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 15:33:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E55AC60E78;
        Wed, 11 Aug 2021 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628710361;
        bh=zZ4jSUjQIOnj/gEHEf9S+GTyogRCKb06WhYWjacd4WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwpDaSLi78PlcUKNSyQGraTW1lfQBQlcZ4rn11mgjyNid93sUquPZr9bFnFw/H1KM
         Mlwqu0gFuZApDkFWNtuc2aFXsOXS5qTj4pboTcICmo6N/LiBUDvbK/tGXIy7R4/Y20
         6rwpLye82nNNJc9dqWK8lhvU/b3Sj82COa0cbuleWYhQktgTg8yDKM5XrKUhKatH1F
         J3l/LXzj7XUlNmPlcGmaVdm6ojn7K9N2nqlroYoeBtWdoqtW2i/95qPGlslZ3+rSPb
         BOe3b0DlQivi2ulEiEI3bHpH0SKwmXNbEzsv5i2FfxtyD8nQpmX6Utl+txMzIHT7hM
         9Fu5XCb8vv9mw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/4] bnxt: don't lock the tx queue from napi poll
Date:   Wed, 11 Aug 2021 12:32:36 -0700
Message-Id: <20210811193239.3155396-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811193239.3155396-1-kuba@kernel.org>
References: <20210811193239.3155396-1-kuba@kernel.org>
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
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 865fcb8cf29f..07827d6b0fec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -730,15 +730,10 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	 */
 	smp_mb();
 
-	if (unlikely(netif_tx_queue_stopped(txq)) &&
-	    (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)) {
-		__netif_tx_lock(txq, smp_processor_id());
-		if (netif_tx_queue_stopped(txq) &&
-		    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
-		    txr->dev_state != BNXT_DEV_STATE_CLOSING)
-			netif_tx_wake_queue(txq);
-		__netif_tx_unlock(txq);
-	}
+	if (netif_tx_queue_stopped(txq) &&
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

