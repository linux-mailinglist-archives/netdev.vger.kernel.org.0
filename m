Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78C62A0D0B
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgJ3SDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:03:10 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:26430 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgJ3SDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:03:09 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09UI2Sv0020754;
        Fri, 30 Oct 2020 11:03:05 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v4 06/10] ch_ktls: Correction in middle record handling
Date:   Fri, 30 Oct 2020 23:32:21 +0530
Message-Id: <20201030180225.11089-7-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201030180225.11089-1-rohitm@chelsio.com>
References: <20201030180225.11089-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a record starts in middle, reset TCB UNA so that
we could avoid sending out extra packet which is
needed to make it 16 byte aligned to start AES CTR.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c         | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index e547c6a3045c..2c92ded79b49 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -827,7 +827,7 @@ static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
  */
 static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 				   struct sge_eth_txq *q, u64 tcp_seq,
-				   u64 tcp_ack, u64 tcp_win)
+				   u64 tcp_ack, u64 tcp_win, bool offset)
 {
 	bool first_wr = ((tx_info->prev_ack == 0) && (tx_info->prev_win == 0));
 	struct ch_ktls_port_stats_debug *port_stats;
@@ -862,7 +862,7 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 		cpl++;
 	}
 	/* reset snd una if it's a re-transmit pkt */
-	if (tcp_seq != tx_info->prev_seq) {
+	if (tcp_seq != tx_info->prev_seq || offset) {
 		/* reset snd_una */
 		port_stats =
 			&tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
@@ -871,7 +871,8 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 						 TCB_SND_UNA_RAW_V
 						 (TCB_SND_UNA_RAW_M),
 						 TCB_SND_UNA_RAW_V(0), 0);
-		atomic64_inc(&port_stats->ktls_tx_ooo);
+		if (tcp_seq != tx_info->prev_seq)
+			atomic64_inc(&port_stats->ktls_tx_ooo);
 		cpl++;
 	}
 	/* update ack */
@@ -1863,7 +1864,9 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 
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

