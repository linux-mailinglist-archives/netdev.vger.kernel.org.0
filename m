Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EA518BEBB
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgCSRtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:49:12 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:65110 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCSRtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:49:12 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02JHn86S015047;
        Thu, 19 Mar 2020 10:49:09 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net] cxgb4: fix Txq restart check during backpressure
Date:   Thu, 19 Mar 2020 23:08:10 +0530
Message-Id: <1584639490-27208-2-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <1584639490-27208-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1584639490-27208-1-git-send-email-rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver reclaims descriptors in much smaller batches, even if hardware
indicates more to reclaim, during backpressure. So, fix the check to
restart the Txq during backpressure, by looking at how many
descriptors hardware had indicated to reclaim, and not on how many
descriptors that driver had actually reclaimed. Once the Txq is
restarted, driver will reclaim even more descriptors when Tx path
is entered again.

Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index c816837fbd85..cab3d17e0e1a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1307,8 +1307,9 @@ static inline void *write_tso_wr(struct adapter *adap, struct sk_buff *skb,
 int t4_sge_eth_txq_egress_update(struct adapter *adap, struct sge_eth_txq *eq,
 				 int maxreclaim)
 {
+	unsigned int reclaimed, hw_cidx;
 	struct sge_txq *q = &eq->q;
-	unsigned int reclaimed;
+	int hw_in_use;
 
 	if (!q->in_use || !__netif_tx_trylock(eq->txq))
 		return 0;
@@ -1316,12 +1317,17 @@ int t4_sge_eth_txq_egress_update(struct adapter *adap, struct sge_eth_txq *eq,
 	/* Reclaim pending completed TX Descriptors. */
 	reclaimed = reclaim_completed_tx(adap, &eq->q, maxreclaim, true);
 
+	hw_cidx = ntohs(READ_ONCE(q->stat->cidx));
+	hw_in_use = q->pidx - hw_cidx;
+	if (hw_in_use < 0)
+		hw_in_use += q->size;
+
 	/* If the TX Queue is currently stopped and there's now more than half
 	 * the queue available, restart it.  Otherwise bail out since the rest
 	 * of what we want do here is with the possibility of shipping any
 	 * currently buffered Coalesced TX Work Request.
 	 */
-	if (netif_tx_queue_stopped(eq->txq) && txq_avail(q) > (q->size / 2)) {
+	if (netif_tx_queue_stopped(eq->txq) && hw_in_use < (q->size / 2)) {
 		netif_tx_wake_queue(eq->txq);
 		eq->q.restarts++;
 	}
-- 
2.24.0

