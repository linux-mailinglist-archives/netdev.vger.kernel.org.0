Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C0717CEC7
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 15:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgCGOhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 09:37:11 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:31700 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgCGOhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 09:37:11 -0500
Received: from redhouse-blr-asicdesigners-com.blr.asicdesigners.com (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 027Ea9n2031095;
        Sat, 7 Mar 2020 06:36:35 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     borisp@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net
Cc:     herbert@gondor.apana.org.au, kuba@kernel.org, secdev@chelsio.com,
        varun@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next v4 6/6] cxgb4/chcr: Add ipv6 support and statistics
Date:   Sat,  7 Mar 2020 20:06:08 +0530
Message-Id: <20200307143608.13109-7-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200307143608.13109-1-rohitm@chelsio.com>
References: <20200307143608.13109-1-rohitm@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding ipv6 support and ktls related statistics.

v1->v2:
- added blank lines at 2 places.

v3->v4:
- Replaced atomic_t with atomic64_t
- added few necessary stat counters.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ktls.c            | 96 ++++++++++++++++++-
 drivers/crypto/chelsio/chcr_ktls.h            |  1 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 35 +++++++
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    | 20 ++++
 4 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 5dff444b4104..f0c3834eda4f 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -3,6 +3,7 @@
 
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 #include "chcr_ktls.h"
+#include "clip_tbl.h"
 
 static int chcr_init_tcb_fields(struct chcr_ktls_info *tx_info);
 /*
@@ -153,8 +154,10 @@ static int chcr_ktls_update_connection_state(struct chcr_ktls_info *tx_info,
 		/* FALLTHRU */
 	case KTLS_CONN_SET_TCB_RPL:
 		/* Check if l2t state is valid, then move to ready state. */
-		if (cxgb4_check_l2t_valid(tx_info->l2te))
+		if (cxgb4_check_l2t_valid(tx_info->l2te)) {
 			tx_info->connection_state = KTLS_CONN_TX_READY;
+			atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_ctx);
+		}
 		break;
 
 	case KTLS_CONN_TX_READY:
@@ -219,6 +222,56 @@ static int chcr_ktls_act_open_req(struct sock *sk,
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
@@ -245,7 +298,13 @@ static int chcr_setup_connection(struct sock *sk,
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
@@ -322,23 +381,35 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
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
+	atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_connection_close);
 	kvfree(tx_info);
 	tx_ctx->chcr_info = NULL;
 }
@@ -424,7 +495,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
 		memcpy(daaddr, &sk->sk_daddr, 4);
 	} else {
-		goto out2;
+		memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
 	}
 
 	/* get the l2t index */
@@ -458,10 +529,12 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (ret)
 		goto out2;
 
+	atomic64_inc(&adap->chcr_stats.ktls_tx_connection_open);
 	return 0;
 out2:
 	kvfree(tx_info);
 out:
+	atomic64_inc(&adap->chcr_stats.ktls_tx_connection_fail);
 	return ret;
 }
 
@@ -729,6 +802,7 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 						 TCB_SND_UNA_RAW_V
 						 (TCB_SND_UNA_RAW_M),
 						 TCB_SND_UNA_RAW_V(0), 0);
+		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_ooo);
 		cpl++;
 	}
 	/* update ack */
@@ -1152,6 +1226,7 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 
 	chcr_txq_advance(&q->q, ndesc);
 	cxgb4_ring_tx_db(adap, &q->q, ndesc);
+	atomic64_inc(&adap->chcr_stats.ktls_tx_send_records);
 
 	return 0;
 }
@@ -1562,6 +1637,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 	/* check if it is a complete record */
 	if (tls_end_offset == record->len) {
 		nskb = skb;
+		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_complete_pkts);
 	} else {
 		dev_kfree_skb_any(skb);
 
@@ -1579,6 +1655,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 		 */
 		if (chcr_ktls_update_snd_una(tx_info, q))
 			goto out;
+		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_end_pkts);
 	}
 
 	if (chcr_ktls_xmit_wr_complete(nskb, tx_info, q, tcp_seq,
@@ -1649,6 +1726,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		/* free the last trimmed portion */
 		dev_kfree_skb_any(skb);
 		skb = tmp_skb;
+		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_trimmed_pkts);
 	}
 	data_len = skb->data_len;
 	/* check if the middle record's start point is 16 byte aligned. CTR
@@ -1720,6 +1798,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 		 */
 		if (chcr_ktls_update_snd_una(tx_info, q))
 			goto out;
+		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_middle_pkts);
 	} else {
 		/* Else means, its a partial first part of the record. Check if
 		 * its only the header, don't need to send for encryption then.
@@ -1734,6 +1813,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 			}
 			return 0;
 		}
+		atomic64_inc(&tx_info->adap->chcr_stats.ktls_tx_start_pkts);
 	}
 
 	if (chcr_ktls_xmit_wr_short(skb, tx_info, q, tcp_seq, tcp_push_no_fin,
@@ -1755,6 +1835,7 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct tcphdr *th = tcp_hdr(skb);
 	int data_len, qidx, ret = 0, mss;
 	struct tls_record_info *record;
+	struct chcr_stats_debug *stats;
 	struct chcr_ktls_info *tx_info;
 	u32 tls_end_offset, tcp_seq;
 	struct tls_context *tls_ctx;
@@ -1800,6 +1881,8 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 
 	adap = tx_info->adap;
+	stats = &adap->chcr_stats;
+
 	qidx = skb->queue_mapping;
 	q = &adap->sge.ethtxq[qidx + tx_info->first_qset];
 	cxgb4_reclaim_completed_tx(adap, &q->q, true);
@@ -1829,6 +1912,7 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * part of the record is received. Incase of partial end part of record,
 	 * we will send the complete record again.
 	 */
+
 	do {
 		int i;
 
@@ -1843,11 +1927,13 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		 */
 		if (unlikely(!record)) {
 			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
+			atomic64_inc(&stats->ktls_tx_drop_no_sync_data);
 			goto out;
 		}
 
 		if (unlikely(tls_record_is_start_marker(record))) {
 			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
+			atomic64_inc(&stats->ktls_tx_skip_no_sync_data);
 			goto out;
 		}
 
@@ -1918,6 +2004,10 @@ int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	} while (data_len > 0);
 
 	tx_info->prev_seq = ntohl(th->seq) + skb->data_len;
+
+	atomic64_inc(&stats->ktls_tx_encrypted_packets);
+	atomic64_add(skb->data_len, &stats->ktls_tx_encrypted_bytes);
+
 	/* tcp finish is set, send a separate tcp msg including all the options
 	 * as well.
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
index fe883cb1a7af..ebed99f3d4cf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3409,6 +3409,41 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&adap->chcr_stats.tls_pdu_rx));
 	seq_printf(seq, "TLS Keys (DDR) Count: %10u\n",
 		   atomic_read(&adap->chcr_stats.tls_key));
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
+	seq_printf(seq, "Tx HW offload contexts added:     %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_ctx));
+	seq_printf(seq, "Tx connection created:            %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_connection_open));
+	seq_printf(seq, "Tx connection failed:             %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_connection_fail));
+	seq_printf(seq, "Tx connection closed:             %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_connection_close));
+	seq_printf(seq, "Packets passed for encryption :   %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_encrypted_packets));
+	seq_printf(seq, "Bytes passed for encryption :     %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_encrypted_bytes));
+	seq_printf(seq, "Tx records send:                  %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_send_records));
+	seq_printf(seq, "Tx partial start of records:      %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_start_pkts));
+	seq_printf(seq, "Tx partial middle of records:     %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_middle_pkts));
+	seq_printf(seq, "Tx partial end of record:         %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_end_pkts));
+	seq_printf(seq, "Tx complete records:              %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_complete_pkts));
+	seq_printf(seq, "TX trim pkts :                    %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_trimmed_pkts));
+	seq_printf(seq, "Tx out of order packets:          %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_ooo));
+	seq_printf(seq, "Tx drop pkts before HW offload:   %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_skip_no_sync_data));
+	seq_printf(seq, "Tx drop not synced packets:       %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_drop_no_sync_data));
+	seq_printf(seq, "Tx drop bypass req:               %20llu\n",
+		   atomic64_read(&adap->chcr_stats.ktls_tx_drop_bypass_req));
+#endif
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index d9d27bc1ae67..03b9bdc812cc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -357,6 +357,26 @@ struct chcr_stats_debug {
 	atomic_t tls_pdu_tx;
 	atomic_t tls_pdu_rx;
 	atomic_t tls_key;
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	atomic64_t ktls_tx_connection_open;
+	atomic64_t ktls_tx_connection_fail;
+	atomic64_t ktls_tx_connection_close;
+	atomic64_t ktls_tx_send_records;
+	atomic64_t ktls_tx_end_pkts;
+	atomic64_t ktls_tx_start_pkts;
+	atomic64_t ktls_tx_middle_pkts;
+	atomic64_t ktls_tx_retransmit_pkts;
+	atomic64_t ktls_tx_complete_pkts;
+	atomic64_t ktls_tx_trimmed_pkts;
+	atomic64_t ktls_tx_encrypted_packets;
+	atomic64_t ktls_tx_encrypted_bytes;
+	atomic64_t ktls_tx_ctx;
+	atomic64_t ktls_tx_ooo;
+	atomic64_t ktls_tx_skip_no_sync_data;
+	atomic64_t ktls_tx_drop_no_sync_data;
+	atomic64_t ktls_tx_drop_bypass_req;
+
+#endif
 };
 
 #define OCQ_WIN_OFFSET(pdev, vres) \
-- 
2.18.1

