Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BECD2AB279
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgKIIec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:34:32 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:32844 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbgKIIeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:34:31 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A98XwJc010868;
        Mon, 9 Nov 2020 00:34:21 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v5 07/12] ch_ktls: Correction in middle record handling
Date:   Mon,  9 Nov 2020 14:03:51 +0530
Message-Id: <20201109083356.11117-8-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201109083356.11117-1-rohitm@chelsio.com>
References: <20201109083356.11117-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a record starts in middle, reset TCB UNA so that we could
avoid sending out extra packet which is needed to make it 16
byte aligned to start AES CTR.
Check also considers prev_seq, which should be what is
actually sent, not the skb data length.
Avoid updating partial TAG to HW at any point of time, that's
why we need to check if remaining part is smaller than TAG
size, then reset TX_MAX to be TAG starting sequence number.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 50 ++++++++++++-------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 8a54fce9bfae..026c66599d1e 100644
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
@@ -1661,11 +1662,6 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 		 * accordingly.
 		 */
 		tcp_seq = tls_record_start_seq(record);
-		/* reset snd una, so the middle record won't send the already
-		 * sent part.
-		 */
-		if (chcr_ktls_update_snd_una(tx_info, q))
-			goto out;
 		/* reset skb offset */
 		skb_offset = 0;
 
@@ -1684,6 +1680,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 				       mss)) {
 		goto out;
 	}
+	tx_info->prev_seq = record->end_seq;
 	return 0;
 out:
 	dev_kfree_skb_any(nskb);
@@ -1752,6 +1749,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 					  data_len, skb_offset, prior_data_len))
 			goto out;
 
+		tx_info->prev_seq = tcp_seq + data_len;
 		return 0;
 	}
 
@@ -1832,6 +1830,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		goto out;
 	}
 
+	tx_info->prev_seq = tcp_seq + data_len + prior_data_len;
 	return 0;
 out:
 	dev_kfree_skb_any(skb);
@@ -1885,13 +1884,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (ret)
 			return NETDEV_TX_BUSY;
 	}
-	/* update tcb */
-	ret = chcr_ktls_xmit_tcb_cpls(tx_info, q, ntohl(th->seq),
-				      ntohl(th->ack_seq),
-				      ntohs(th->window));
-	if (ret) {
-		return NETDEV_TX_BUSY;
-	}
 
 	/* TCP segments can be in received either complete or partial.
 	 * chcr_end_part_handler will handle cases if complete record or end
@@ -1922,6 +1914,30 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			atomic64_inc(&port_stats->ktls_tx_skip_no_sync_data);
 			goto out;
 		}
+		tls_end_offset = record->end_seq - tcp_seq;
+
+		pr_debug("seq 0x%x, end_seq 0x%x prev_seq 0x%x, datalen 0x%x\n",
+			 tcp_seq, record->end_seq, tx_info->prev_seq, data_len);
+		/* update tcb for the skb */
+		if (skb_data_len == data_len) {
+			u32 tx_max = tcp_seq;
+
+			if (!tls_record_is_start_marker(record) &&
+			    tls_end_offset < TLS_CIPHER_AES_GCM_128_TAG_SIZE)
+				tx_max = record->end_seq -
+					TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+
+			ret = chcr_ktls_xmit_tcb_cpls(tx_info, q, tx_max,
+						      ntohl(th->ack_seq),
+						      ntohs(th->window),
+						      tls_end_offset !=
+						      record->len);
+			if (ret) {
+				spin_unlock_irqrestore(&tx_ctx->base.lock,
+						       flags);
+				goto out;
+			}
+		}
 		/* increase page reference count of the record, so that there
 		 * won't be any chance of page free in middle if in case stack
 		 * receives ACK and try to delete the record.
@@ -1931,10 +1947,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* lock cleared */
 		spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 
-		tls_end_offset = record->end_seq - tcp_seq;
 
-		pr_debug("seq 0x%x, end_seq 0x%x prev_seq 0x%x, datalen 0x%x\n",
-			 tcp_seq, record->end_seq, tx_info->prev_seq, data_len);
 		/* if a tls record is finishing in this SKB */
 		if (tls_end_offset <= data_len) {
 			ret = chcr_end_part_handler(tx_info, skb, record,
@@ -1973,7 +1986,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	} while (data_len > 0);
 
-	tx_info->prev_seq = ntohl(th->seq) + skb_data_len;
 	atomic64_inc(&port_stats->ktls_tx_encrypted_packets);
 	atomic64_add(skb_data_len, &port_stats->ktls_tx_encrypted_bytes);
 
-- 
2.18.1

