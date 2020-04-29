Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB381BE6E5
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgD2TEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:04:00 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:65461 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgD2TD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:03:59 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 03TJ3uDp031109;
        Wed, 29 Apr 2020 12:03:57 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net] cxgb4: fix EOTID leak when disabling TC-MQPRIO offload
Date:   Thu, 30 Apr 2020 00:22:19 +0530
Message-Id: <1588186339-6249-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under heavy load, the EOTID termination FLOWC request fails to get
enqueued to the end of the Tx ring due to lack of credits. This
results in EOTID leak.

When disabling TC-MQPRIO offload, the link is already brought down
to cleanup EOTIDs. So, flush any pending enqueued skbs that can't be
sent outside the wire, to make room for FLOWC request. Also, move the
FLOWC descriptor consumption logic closer to when the FLOWC request is
actually posted to hardware.

Fixes: 0e395b3cb1fb ("cxgb4: add FLOWC based QoS offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 39 ++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index f5dd34db4b54..2cfb1f691bf2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2207,6 +2207,9 @@ static void ethofld_hard_xmit(struct net_device *dev,
 	if (unlikely(skip_eotx_wr)) {
 		start = (u64 *)wr;
 		eosw_txq->state = next_state;
+		eosw_txq->cred -= wrlen16;
+		eosw_txq->ncompl++;
+		eosw_txq->last_compl = 0;
 		goto write_wr_headers;
 	}
 
@@ -2365,6 +2368,34 @@ netdev_tx_t t4_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return cxgb4_eth_xmit(skb, dev);
 }
 
+static void eosw_txq_flush_pending_skbs(struct sge_eosw_txq *eosw_txq)
+{
+	int pktcount = eosw_txq->pidx - eosw_txq->last_pidx;
+	int pidx = eosw_txq->pidx;
+	struct sk_buff *skb;
+
+	if (!pktcount)
+		return;
+
+	if (pktcount < 0)
+		pktcount += eosw_txq->ndesc;
+
+	while (pktcount--) {
+		pidx--;
+		if (pidx < 0)
+			pidx += eosw_txq->ndesc;
+
+		skb = eosw_txq->desc[pidx].skb;
+		if (skb) {
+			dev_consume_skb_any(skb);
+			eosw_txq->desc[pidx].skb = NULL;
+			eosw_txq->inuse--;
+		}
+	}
+
+	eosw_txq->pidx = eosw_txq->last_pidx + 1;
+}
+
 /**
  * cxgb4_ethofld_send_flowc - Send ETHOFLD flowc request to bind eotid to tc.
  * @dev - netdevice
@@ -2440,9 +2471,11 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 					    FW_FLOWC_MNEM_EOSTATE_CLOSING :
 					    FW_FLOWC_MNEM_EOSTATE_ESTABLISHED);
 
-	eosw_txq->cred -= len16;
-	eosw_txq->ncompl++;
-	eosw_txq->last_compl = 0;
+	/* Free up any pending skbs to ensure there's room for
+	 * termination FLOWC.
+	 */
+	if (tc == FW_SCHED_CLS_NONE)
+		eosw_txq_flush_pending_skbs(eosw_txq);
 
 	ret = eosw_txq_enqueue(eosw_txq, skb);
 	if (ret) {
-- 
2.24.0

