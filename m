Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C502A0CCC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgJ3RsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:48:03 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:35106 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbgJ3RsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:48:02 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09UHl9pW020669;
        Fri, 30 Oct 2020 10:47:57 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v3 10/10] ch_ktls: stop the txq if reaches threshold
Date:   Fri, 30 Oct 2020 23:17:08 +0530
Message-Id: <20201030174708.9578-11-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201030174708.9578-1-rohitm@chelsio.com>
References: <20201030174708.9578-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop the queue and ask for the credits if queue reaches to
threashold.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 08595b0a6b6d..369144cca78b 100644
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
@@ -963,7 +969,7 @@ static int
 chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 			    struct sge_eth_txq *q, uint32_t tx_chan)
 {
-	u32 ctrl, iplen, maclen, pktlen, ndesc, len16;
+	u32 ctrl, iplen, maclen, pktlen, ndesc, len16, wr_mid = 0;
 	struct fw_eth_tx_pkt_wr *wr;
 	struct cpl_tx_pkt_core *cpl;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -995,6 +1001,11 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
+		chcr_eth_txq_stop(q);
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+	}
+
 	pos = &q->q.desc[q->q.pidx];
 	wr = pos;
 
@@ -1002,7 +1013,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	wr->op_immdlen = htonl(FW_WR_OP_V(FW_ETH_TX_PKT_WR) |
 			       FW_WR_IMMDLEN_V(ctrl));
 
-	wr->equiq_to_len16 = htonl(FW_WR_LEN16_V(len16));
+	wr->equiq_to_len16 = htonl(wr_mid | FW_WR_LEN16_V(len16));
 	wr->r3 = 0;
 
 	cpl = (void *)(wr + 1);
-- 
2.18.1

