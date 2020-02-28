Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C94173FCA
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgB1SkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:40:16 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:4079 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1SkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:40:15 -0500
Received: from redhouse.blr.asicdesginers.com ([10.193.187.72])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01SIdlBH032397;
        Fri, 28 Feb 2020 10:40:09 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, varun@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next v2 6/6] cxgb4/chcr: Add ipv6 support and statistics
Date:   Sat, 29 Feb 2020 00:09:45 +0530
Message-Id: <20200228183945.11594-7-rohitm@chelsio.com>
X-Mailer: git-send-email 2.25.0.191.gde93cc1
In-Reply-To: <20200228183945.11594-1-rohitm@chelsio.com>
References: <20200228183945.11594-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding ipv6 support and ktls related statistics.

v1->v2:
- aaded blank lines at 2 places.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ktls.c            | 84 ++++++++++++++++++-
 drivers/crypto/chelsio/chcr_ktls.h            |  1 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 25 ++++++
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    | 13 +++
 4 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 04f4ee568c99..c437e640f34d 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -3,6 +3,7 @@
 
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 #include "chcr_ktls.h"
+#include "clip_tbl.h"
 
 static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info);
 /*
@@ -219,6 +220,56 @@ static int chcr_ktls_act_open_req(struct sock *sk,
 	return cxgb4_l2t_send(tx_info->netdev, skb, tx_info->l2te);
 }
 
+/*
+ * chcr_ktls_act_open_req6: creates TCB entry for ipv6 connection.
+ * @sk - tcp socket.
+ * @tx_info - driver specific tls info.
+ * @atid - connection active tid.
+ * return - send success/failure.
+ */
+static int chcr_ktls_act_open_req6(struct sock *sk,
+				   struct chcr_ktls_info *tx_info,
+				   int atid)
+{
+	struct inet_sock *inet = inet_sk(sk);
+	struct cpl_t6_act_open_req6 *cpl6;
+	struct cpl_act_open_req6 *cpl;
+	struct sk_buff *skb;
+	unsigned int len;
+	int qid_atid;
+	u64 options;
+
+	len = sizeof(*cpl6);
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (unlikely(!skb))
+		return -ENOMEM;
+	/* mark it a control pkt */
+	set_wr_txq(skb, CPL_PRIORITY_CONTROL, tx_info->port_id);
+
+	cpl6 = __skb_put_zero(skb, len);
+	cpl = (struct cpl_act_open_req6 *)cpl6;
+	INIT_TP_WR(cpl6, 0);
+	qid_atid = TID_QID_V(tx_info->rx_qid) | TID_TID_V(atid);
+	OPCODE_TID(cpl) = htonl(MK_OPCODE_TID(CPL_ACT_OPEN_REQ6, qid_atid));
+	cpl->local_port = inet->inet_sport;
+	cpl->peer_port = inet->inet_dport;
+	cpl->local_ip_hi = *(__be64 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8[0];
+	cpl->local_ip_lo = *(__be64 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8[8];
+	cpl->peer_ip_hi = *(__be64 *)&sk->sk_v6_daddr.in6_u.u6_addr8[0];
+	cpl->peer_ip_lo = *(__be64 *)&sk->sk_v6_daddr.in6_u.u6_addr8[8];
+
+	/* first 64 bit option field. */
+	options = TCAM_BYPASS_F | ULP_MODE_V(ULP_MODE_NONE) | NON_OFFLOAD_F |
+		  SMAC_SEL_V(tx_info->smt_idx) | TX_CHAN_V(tx_info->tx_chan);
+	cpl->opt0 = cpu_to_be64(options);
+	/* next 64 bit option field. */
+	options =
+		TX_QUEUE_V(tx_info->adap->params.tp.tx_modq[tx_info->tx_chan]);
+	cpl->opt2 = htonl(options);
+
+	return cxgb4_l2t_send(tx_info->netdev, skb, tx_info->l2te);
+}
+
 /*
  * chcr_setup_connection:  create a TCB entry so that TP will form tcp packets.
  * @sk - tcp socket.
@@ -245,7 +296,13 @@ static int chcr_setup_connection(struct sock *sk,
 		ret = chcr_ktls_act_open_req(sk, tx_info, atid);
 	} else {
 		tx_info->ip_family = AF_INET6;
-		ret = -EOPNOTSUPP;
+		ret =
+		cxgb4_clip_get(tx_info->netdev,
+			       (const u32 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8,
+			       1);
+		if (ret)
+			goto out;
+		ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
 	}
 
 	/* if return type is NET_XMIT_CN, msg will be sent but delayed, mark ret
@@ -322,23 +379,35 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx =
 				chcr_get_ktls_tx_context(tls_ctx);
 	struct chcr_ktls_info *tx_info = tx_ctx->chcr_info;
+	struct sock *sk;
 
 	if (!tx_info)
 		return;
+	sk = tx_info->sk;
 
 	spin_lock(&tx_info->lock);
 	tx_info->connection_state = KTLS_CONN_CLOSED;
 	spin_unlock(&tx_info->lock);
 
+	/* clear l2t entry */
 	if (tx_info->l2te)
 		cxgb4_l2t_release(tx_info->l2te);
 
+	/* clear clip entry */
+	if (tx_info->ip_family == AF_INET6)
+		cxgb4_clip_release(netdev,
+				   (const u32 *)&sk->sk_v6_daddr.in6_u.u6_addr8,
+				   1);
+
+	/* clear tid */
 	if (tx_info->tid != -1) {
 		/* clear tcb state and then release tid */
 		chcr_ktls_mark_tcb_close(tx_info);
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
 	}
+
+	atomic_inc(&tx_info->adap->chcr_stats.ktls_tx_connection_close);
 	kvfree(tx_info);
 	tx_ctx->chcr_info = NULL;
 }
@@ -424,7 +493,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
 		memcpy(daaddr, &sk->sk_daddr, 4);
 	} else {
-		goto out2;
+		memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
 	}
 
 	/* get the l2t index */
@@ -458,10 +527,12 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (ret)
 		goto out2;
 
+	atomic_inc(&adap->chcr_stats.ktls_tx_connection_open);
 	return 0;
 out2:
 	kvfree(tx_info);
 out:
+	atomic_inc(&adap->chcr_stats.ktls_tx_connection_fail);
 	return ret;
 }
 
@@ -728,6 +799,7 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 						 TCB_SND_UNA_RAW_V
 						 (TCB_SND_UNA_RAW_M),
 						 TCB_SND_UNA_RAW_V(0), 0);
+		atomic_inc(&tx_info->adap->chcr_stats.ktls_tx_retransmit_pkts);
 		cpl++;
 	}
 	/* update ack */
@@ -1152,6 +1224,7 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 
 	chcr_txq_advance(&q->q, ndesc);
 	cxgb4_ring_tx_db(adap, &q->q, ndesc);
+	atomic_inc(&adap->chcr_stats.ktls_tx_send_records);
 
 	return 0;
 }
@@ -1562,6 +1635,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 	/* check if it is a complete record */
 	if (tls_end_offset == record->len) {
 		nskb = skb;
+		atomic_inc(&tx_info->adap->chcr_stats.ktls_tx_complete_pkts);
 	} else {
 		nskb = alloc_skb(0, GFP_KERNEL);
 		if (!nskb) {
@@ -1580,6 +1654,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 		 */
 		if (chcr_ktls_update_snd_una(tx_info, q))
 			goto out;
+		atomic_inc(&tx_info->adap->chcr_stats.ktls_tx_end_pkts);
 	}
 
 	if (chcr_ktls_xmit_wr_complete(nskb, tx_info, q, tcp_seq,
@@ -1650,6 +1725,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		/* free the last trimmed portion */
 		kfree_skb(skb);
 		skb = tmp_skb;
+		atomic_inc(&tx_info->adap->chcr_stats.ktls_tx_trimmed_pkts);
 	}
 	data_len = skb->data_len;
 	/* check if the middle record's start point is 16 byte aligned. CTR
@@ -1721,6 +1797,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		 */
 		if (chcr_ktls_update_snd_una(tx_info, q))
 			goto out;
+		atomic_inc(&tx_info->adap->chcr_stats.ktls_tx_middle_pkts);
 	} else {
 		/* Else means, its a partial first part of the record. Check if
 		 * its only the header, don't need to send for encryption then.
@@ -1735,6 +1812,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 			}
 			return 0;
 		}
+		atomic_inc(&tx_info->adap->chcr_stats.ktls_tx_start_pkts);
 	}
 
 	if (chcr_ktls_xmit_wr_short(skb, tx_info, q, tcp_seq, tcp_push_no_fin,
@@ -1811,6 +1889,8 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 				      ntohs(th->window));
 	if (ret)
 		return NETDEV_TX_BUSY;
+
+	atomic_inc(&adap->chcr_stats.ktls_tx_pkts_received);
 	/* don't touch the original skb, make a new skb to extract each records
 	 * and send them separately.
 	 */
diff --git a/drivers/crypto/chelsio/chcr_ktls.h b/drivers/crypto/chelsio/chcr_ktls.h
index 9ffb8cc85db1..5a7ae2ca446e 100644
--- a/drivers/crypto/chelsio/chcr_ktls.h
+++ b/drivers/crypto/chelsio/chcr_ktls.h
@@ -11,6 +11,7 @@
 #include "t4_tcb.h"
 #include "l2t.h"
 #include "chcr_common.h"
+#include "cxgb4_uld.h"
 
 #define CHCR_TCB_STATE_CLOSED	0
 #define CHCR_KTLS_KEY_CTX_LEN	16
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index de30d61af065..ae71f3832988 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3409,6 +3409,31 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&adap->chcr_stats.tls_pdu_rx));
 	seq_printf(seq, "TLS Keys (DDR) Count: %10u\n",
 		   atomic_read(&adap->chcr_stats.tls_key));
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
+	seq_printf(seq, "KTLS connection opened:                  %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_connection_open));
+	seq_printf(seq, "KTLS connection failed:                  %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_connection_fail));
+	seq_printf(seq, "KTLS connection closed:                  %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_connection_close));
+	seq_printf(seq, "KTLS Tx pkt received from stack:         %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_pkts_received));
+	seq_printf(seq, "KTLS tx records send:                    %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_send_records));
+	seq_printf(seq, "KTLS tx partial start of records:        %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_start_pkts));
+	seq_printf(seq, "KTLS tx partial middle of records:       %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_middle_pkts));
+	seq_printf(seq, "KTLS tx partial end of record:           %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_end_pkts));
+	seq_printf(seq, "KTLS tx complete records:                %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_complete_pkts));
+	seq_printf(seq, "KTLS tx trim pkts :                      %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_trimmed_pkts));
+	seq_printf(seq, "KTLS tx retransmit packets:              %10u\n",
+		   atomic_read(&adap->chcr_stats.ktls_tx_retransmit_pkts));
+#endif
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index d9d27bc1ae67..c07339abfade 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -357,6 +357,19 @@ struct chcr_stats_debug {
 	atomic_t tls_pdu_tx;
 	atomic_t tls_pdu_rx;
 	atomic_t tls_key;
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	atomic_t ktls_tx_pkts_received;
+	atomic_t ktls_tx_connection_open;
+	atomic_t ktls_tx_connection_fail;
+	atomic_t ktls_tx_connection_close;
+	atomic_t ktls_tx_send_records;
+	atomic_t ktls_tx_end_pkts;
+	atomic_t ktls_tx_start_pkts;
+	atomic_t ktls_tx_middle_pkts;
+	atomic_t ktls_tx_retransmit_pkts;
+	atomic_t ktls_tx_complete_pkts;
+	atomic_t ktls_tx_trimmed_pkts;
+#endif
 };
 
 #define OCQ_WIN_OFFSET(pdev, vres) \
-- 
2.25.0.191.gde93cc1

