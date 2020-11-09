Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3C92AB282
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgKIIez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:34:55 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:26704 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgKIIez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:34:55 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A98XwJh010868;
        Mon, 9 Nov 2020 00:34:37 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v5 12/12] ch_ktls: stop the txq if reaches threshold
Date:   Mon,  9 Nov 2020 14:03:56 +0530
Message-Id: <20201109083356.11117-13-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201109083356.11117-1-rohitm@chelsio.com>
References: <20201109083356.11117-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop the queue and ask for the credits if queue reaches to
threashold.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c  | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index a732051b21e4..c24485c0d512 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -835,7 +835,7 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 {
 	bool first_wr = ((tx_info->prev_ack == 0) && (tx_info->prev_win == 0));
 	struct ch_ktls_port_stats_debug *port_stats;
-	u32 len, cpl = 0, ndesc, wr_len;
+	u32 len, cpl = 0, ndesc, wr_len, wr_mid = 0;
 	struct fw_ulptx_wr *wr;
 	int credits;
 	void *pos;
@@ -851,6 +851,11 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
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
@@ -905,7 +910,8 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 		wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
 		wr->cookie = 0;
 		/* fill len in wr field */
-		wr->flowid_len16 = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(len, 16)));
+		wr->flowid_len16 = htonl(wr_mid |
+					 FW_WR_LEN16_V(DIV_ROUND_UP(len, 16)));
 
 		ndesc = DIV_ROUND_UP(len, 64);
 		chcr_txq_advance(&q->q, ndesc);
@@ -986,6 +992,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	struct tcphdr *tcp;
 	int len16, pktlen;
 	struct iphdr *ip;
+	u32 wr_mid = 0;
 	int credits;
 	u8 buf[150];
 	u64 cntrl1;
@@ -1010,6 +1017,11 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
+		chcr_eth_txq_stop(q);
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+	}
+
 	pos = &q->q.desc[q->q.pidx];
 	wr = pos;
 
@@ -1017,7 +1029,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	wr->op_immdlen = htonl(FW_WR_OP_V(FW_ETH_TX_PKT_WR) |
 			       FW_WR_IMMDLEN_V(ctrl));
 
-	wr->equiq_to_len16 = htonl(FW_WR_LEN16_V(len16));
+	wr->equiq_to_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
 	wr->r3 = 0;
 
 	cpl = (void *)(wr + 1);
-- 
2.18.1

