Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F3A18BEB9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgCSRtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:49:04 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:21915 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgCSRtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:49:03 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02JHmx6x015044;
        Thu, 19 Mar 2020 10:49:00 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net] cxgb4: fix throughput drop during Tx backpressure
Date:   Thu, 19 Mar 2020 23:08:09 +0530
Message-Id: <1584639490-27208-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 7c3bebc3d868 ("cxgb4: request the TX CIDX updates to status page")
reverted back to getting Tx CIDX updates via DMA, instead of interrupts,
introduced by commit d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE
doorbell queue timer")

However, it missed reverting back several code changes where Tx CIDX
updates are not explicitly requested during backpressure when using
interrupt mode. These missed changes cause slow recovery during
backpressure because the corresponding interrupt no longer comes and
hence results in Tx throughput drop.

So, revert back these missed code changes, as well, which will allow
explicitly requesting Tx CIDX updates when backpressure happens.
This enables the corresponding interrupt with Tx CIDX update message
to get generated and hence speed up recovery and restore back
throughput.

Fixes: 7c3bebc3d868 ("cxgb4: request the TX CIDX updates to status page")
Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 42 ++----------------------
 1 file changed, 2 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 97cda501e7e8..c816837fbd85 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1486,16 +1486,7 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * has opened up.
 		 */
 		eth_txq_stop(q);
-
-		/* If we're using the SGE Doorbell Queue Timer facility, we
-		 * don't need to ask the Firmware to send us Egress Queue CIDX
-		 * Updates: the Hardware will do this automatically.  And
-		 * since we send the Ingress Queue CIDX Updates to the
-		 * corresponding Ethernet Response Queue, we'll get them very
-		 * quickly.
-		 */
-		if (!q->dbqt)
-			wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
 	}
 
 	wr = (void *)&q->q.desc[q->q.pidx];
@@ -1805,16 +1796,7 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 		 * has opened up.
 		 */
 		eth_txq_stop(txq);
-
-		/* If we're using the SGE Doorbell Queue Timer facility, we
-		 * don't need to ask the Firmware to send us Egress Queue CIDX
-		 * Updates: the Hardware will do this automatically.  And
-		 * since we send the Ingress Queue CIDX Updates to the
-		 * corresponding Ethernet Response Queue, we'll get them very
-		 * quickly.
-		 */
-		if (!txq->dbqt)
-			wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
 	}
 
 	/* Start filling in our Work Request.  Note that we do _not_ handle
@@ -3370,26 +3352,6 @@ static void t4_tx_completion_handler(struct sge_rspq *rspq,
 	}
 
 	txq = &s->ethtxq[pi->first_qset + rspq->idx];
-
-	/* We've got the Hardware Consumer Index Update in the Egress Update
-	 * message.  If we're using the SGE Doorbell Queue Timer mechanism,
-	 * these Egress Update messages will be our sole CIDX Updates we get
-	 * since we don't want to chew up PCIe bandwidth for both Ingress
-	 * Messages and Status Page writes.  However, The code which manages
-	 * reclaiming successfully DMA'ed TX Work Requests uses the CIDX value
-	 * stored in the Status Page at the end of the TX Queue.  It's easiest
-	 * to simply copy the CIDX Update value from the Egress Update message
-	 * to the Status Page.  Also note that no Endian issues need to be
-	 * considered here since both are Big Endian and we're just copying
-	 * bytes consistently ...
-	 */
-	if (txq->dbqt) {
-		struct cpl_sge_egr_update *egr;
-
-		egr = (struct cpl_sge_egr_update *)rsp;
-		WRITE_ONCE(txq->q.stat->cidx, egr->cidx);
-	}
-
 	t4_sge_eth_txq_egress_update(adapter, txq, -1);
 }
 
-- 
2.24.0

