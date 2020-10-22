Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80929295C73
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896372AbgJVKKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:10:48 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:6700 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896368AbgJVKKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:10:47 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09MAAK5f013211;
        Thu, 22 Oct 2020 03:10:43 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net 4/7] ch_ktls: Correction in middle record handling
Date:   Thu, 22 Oct 2020 15:40:16 +0530
Message-Id: <20201022101019.7363-5-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201022101019.7363-1-rohitm@chelsio.com>
References: <20201022101019.7363-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a record starts in middle, reset TCB UNA so that
we could avoid sending out extra packet which is
needed to make it 16 byte aligned to start AES CTR.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 9fa8e40ca0bf..ebbc9af9d551 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -827,11 +827,11 @@ static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
  */
 static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 				   struct sge_eth_txq *q, u64 tcp_seq,
-				   u64 tcp_ack, u64 tcp_win)
+				   u64 tcp_ack, u64 tcp_win, bool offset)
 {
 	bool first_wr = ((tx_info->prev_ack == 0) && (tx_info->prev_win == 0));
 	struct ch_ktls_port_stats_debug *port_stats;
-	u32 len, cpl = 0, ndesc, wr_len;
+	u32 len, cpl = 0, ndesc, wr_len, wr_mid = 0;
 	struct fw_ulptx_wr *wr;
 	int credits;
 	void *pos;
@@ -847,6 +847,11 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 		return NETDEV_TX_BUSY;
 	}
 
+	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
+		chcr_eth_txq_stop(q);
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+	}
+
 	pos = &q->q.desc[q->q.pidx];
 	/* make space for WR, we'll fill it later when we know all the cpls
 	 * being sent out and have complete length.
@@ -862,7 +867,7 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 		cpl++;
 	}
 	/* reset snd una if it's a re-transmit pkt */
-	if (tcp_seq != tx_info->prev_seq) {
+	if (tcp_seq != tx_info->prev_seq || offset) {
 		/* reset snd_una */
 		port_stats =
 			&tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
@@ -871,7 +876,8 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 						 TCB_SND_UNA_RAW_V
 						 (TCB_SND_UNA_RAW_M),
 						 TCB_SND_UNA_RAW_V(0), 0);
-		atomic64_inc(&port_stats->ktls_tx_ooo);
+		if (tcp_seq != tx_info->prev_seq)
+			atomic64_inc(&port_stats->ktls_tx_ooo);
 		cpl++;
 	}
 	/* update ack */
@@ -900,7 +906,8 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 		wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
 		wr->cookie = 0;
 		/* fill len in wr field */
-		wr->flowid_len16 = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(len, 16)));
+		wr->flowid_len16 = htonl(wr_mid |
+					 FW_WR_LEN16_V(DIV_ROUND_UP(len, 16)));
 
 		ndesc = DIV_ROUND_UP(len, 64);
 		chcr_txq_advance(&q->q, ndesc);
@@ -1869,7 +1876,9 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			ret = chcr_ktls_xmit_tcb_cpls(tx_info, q, tx_max,
 						      ntohl(th->ack_seq),
-						      ntohs(th->window));
+						      ntohs(th->window),
+						      tls_end_offset !=
+						      record->len);
 			if (ret) {
 				spin_unlock_irqrestore(&tx_ctx->base.lock,
 						       flags);
-- 
2.18.1

