Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB304248A36
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgHRPla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:41:30 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:2266 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgHRPl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:41:26 -0400
Received: from localhost (fedora32ganji.blr.asicdesigners.com [10.193.80.135])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07IFfHk7024135;
        Tue, 18 Aug 2020 08:41:18 -0700
From:   Ganji Aravind <ganji.aravind@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: [PATCH net 2/2] cxgb4: Fix race between loopback and normal Tx path
Date:   Tue, 18 Aug 2020 21:10:58 +0530
Message-Id: <20200818154058.1770002-3-ganji.aravind@chelsio.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
References: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even after Tx queues are marked stopped, there exists a
small window where the current packet in the normal Tx
path is still being sent out and loopback selftest ends
up corrupting the same Tx ring. So, ensure selftest takes
the Tx lock to synchronize access the Tx ring.

Fixes: 7235ffae3d2c ("cxgb4: add loopback ethtool self-test")
Signed-off-by: Ganji Aravind <ganji.aravind@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 7c9fe4bc235b..869431a1eedd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2561,11 +2561,14 @@ int cxgb4_selftest_lb_pkt(struct net_device *netdev)
 	lb->loopback = 1;
 
 	q = &adap->sge.ethtxq[pi->first_qset];
+	__netif_tx_lock(q->txq, smp_processor_id());
 
 	reclaim_completed_tx(adap, &q->q, -1, true);
 	credits = txq_avail(&q->q) - ndesc;
-	if (unlikely(credits < 0))
+	if (unlikely(credits < 0)) {
+		__netif_tx_unlock(q->txq);
 		return -ENOMEM;
+	}
 
 	wr = (void *)&q->q.desc[q->q.pidx];
 	memset(wr, 0, sizeof(struct tx_desc));
@@ -2598,6 +2601,7 @@ int cxgb4_selftest_lb_pkt(struct net_device *netdev)
 	init_completion(&lb->completion);
 	txq_advance(&q->q, ndesc);
 	cxgb4_ring_tx_db(adap, &q->q, ndesc);
+	__netif_tx_unlock(q->txq);
 
 	/* wait for the pkt to return */
 	ret = wait_for_completion_timeout(&lb->completion, 10 * HZ);
-- 
2.26.2

