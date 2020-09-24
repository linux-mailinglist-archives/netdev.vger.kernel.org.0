Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A9227690D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 08:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgIXGhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 02:37:04 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:1060 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbgIXGhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 02:37:04 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08O6aejc003455;
        Wed, 23 Sep 2020 23:36:59 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net-next v2 3/3] cxgb4/ch_ktls: ktls stats are added at port level
Date:   Thu, 24 Sep 2020 12:06:39 +0530
Message-Id: <20200924063639.18005-4-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200924063639.18005-1-rohitm@chelsio.com>
References: <20200924063639.18005-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the ktls stats were at adapter level, but now changing it
to port level.

Fixes: 62370a4f346d ("cxgb4/chcr: Add ipv6 support and statistics")

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 35 ++++++-------
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 50 +++++++++++++------
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    | 21 +++++---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 28 +++++++----
 4 files changed, 80 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 5491a41fd1be..0273f40b85f7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3527,6 +3527,10 @@ DEFINE_SHOW_ATTRIBUTE(meminfo);
 
 static int chcr_stats_show(struct seq_file *seq, void *v)
 {
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
+	struct ch_ktls_port_stats_debug *ktls_port;
+	int i = 0;
+#endif
 	struct adapter *adap = seq->private;
 
 	seq_puts(seq, "Chelsio Crypto Accelerator Stats \n");
@@ -3557,18 +3561,6 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 	seq_puts(seq, "\nChelsio KTLS Crypto Accelerator Stats\n");
 	seq_printf(seq, "Tx TLS offload refcount:          %20u\n",
 		   refcount_read(&adap->chcr_ktls.ktls_refcount));
-	seq_printf(seq, "Tx HW offload contexts added:     %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_ctx));
-	seq_printf(seq, "Tx connection created:            %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_connection_open));
-	seq_printf(seq, "Tx connection failed:             %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_connection_fail));
-	seq_printf(seq, "Tx connection closed:             %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_connection_close));
-	seq_printf(seq, "Packets passed for encryption :   %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_encrypted_packets));
-	seq_printf(seq, "Bytes passed for encryption :     %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_encrypted_bytes));
 	seq_printf(seq, "Tx records send:                  %20llu\n",
 		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_send_records));
 	seq_printf(seq, "Tx partial start of records:      %20llu\n",
@@ -3581,14 +3573,17 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_complete_pkts));
 	seq_printf(seq, "TX trim pkts :                    %20llu\n",
 		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_trimmed_pkts));
-	seq_printf(seq, "Tx out of order packets:          %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_ooo));
-	seq_printf(seq, "Tx drop pkts before HW offload:   %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_skip_no_sync_data));
-	seq_printf(seq, "Tx drop not synced packets:       %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_drop_no_sync_data));
-	seq_printf(seq, "Tx drop bypass req:               %20llu\n",
-		   atomic64_read(&adap->ch_ktls_stats.ktls_tx_drop_bypass_req));
+	while (i < MAX_NPORTS) {
+		ktls_port = &adap->ch_ktls_stats.ktls_port[i];
+		seq_printf(seq, "Port %d\n", i);
+		seq_printf(seq, "Tx connection created:            %20llu\n",
+			   atomic64_read(&ktls_port->ktls_tx_connection_open));
+		seq_printf(seq, "Tx connection failed:             %20llu\n",
+			   atomic64_read(&ktls_port->ktls_tx_connection_fail));
+		seq_printf(seq, "Tx connection closed:             %20llu\n",
+			   atomic64_read(&ktls_port->ktls_tx_connection_close));
+		i++;
+	}
 #endif
 	return 0;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 8c6c9bedcba1..61ea3ec5c3fc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -117,14 +117,6 @@ static const char stats_strings[][ETH_GSTRING_LEN] = {
 	"vlan_insertions        ",
 	"gro_packets            ",
 	"gro_merged             ",
-};
-
-static char adapter_stats_strings[][ETH_GSTRING_LEN] = {
-	"db_drop                ",
-	"db_full                ",
-	"db_empty               ",
-	"write_coal_success     ",
-	"write_coal_fail        ",
 #if  IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	"tx_tls_encrypted_packets",
 	"tx_tls_encrypted_bytes  ",
@@ -136,6 +128,14 @@ static char adapter_stats_strings[][ETH_GSTRING_LEN] = {
 #endif
 };
 
+static char adapter_stats_strings[][ETH_GSTRING_LEN] = {
+	"db_drop                ",
+	"db_full                ",
+	"db_empty               ",
+	"write_coal_success     ",
+	"write_coal_fail        ",
+};
+
 static char loopback_stats_strings[][ETH_GSTRING_LEN] = {
 	"-------Loopback----------- ",
 	"octets_ok              ",
@@ -257,14 +257,6 @@ struct queue_port_stats {
 	u64 vlan_ins;
 	u64 gro_pkts;
 	u64 gro_merged;
-};
-
-struct adapter_stats {
-	u64 db_drop;
-	u64 db_full;
-	u64 db_empty;
-	u64 wc_success;
-	u64 wc_fail;
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	u64 tx_tls_encrypted_packets;
 	u64 tx_tls_encrypted_bytes;
@@ -276,12 +268,23 @@ struct adapter_stats {
 #endif
 };
 
+struct adapter_stats {
+	u64 db_drop;
+	u64 db_full;
+	u64 db_empty;
+	u64 wc_success;
+	u64 wc_fail;
+};
+
 static void collect_sge_port_stats(const struct adapter *adap,
 				   const struct port_info *p,
 				   struct queue_port_stats *s)
 {
 	const struct sge_eth_txq *tx = &adap->sge.ethtxq[p->first_qset];
 	const struct sge_eth_rxq *rx = &adap->sge.ethrxq[p->first_qset];
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
+	const struct ch_ktls_port_stats_debug *ktls_stats;
+#endif
 	struct sge_eohw_txq *eohw_tx;
 	unsigned int i;
 
@@ -306,6 +309,21 @@ static void collect_sge_port_stats(const struct adapter *adap,
 			s->vlan_ins += eohw_tx->vlan_ins;
 		}
 	}
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
+	ktls_stats = &adap->ch_ktls_stats.ktls_port[p->port_id];
+	s->tx_tls_encrypted_packets =
+		atomic64_read(&ktls_stats->ktls_tx_encrypted_packets);
+	s->tx_tls_encrypted_bytes =
+		atomic64_read(&ktls_stats->ktls_tx_encrypted_bytes);
+	s->tx_tls_ctx = atomic64_read(&ktls_stats->ktls_tx_ctx);
+	s->tx_tls_ooo = atomic64_read(&ktls_stats->ktls_tx_ooo);
+	s->tx_tls_skip_no_sync_data =
+		atomic64_read(&ktls_stats->ktls_tx_skip_no_sync_data);
+	s->tx_tls_drop_no_sync_data =
+		atomic64_read(&ktls_stats->ktls_tx_drop_no_sync_data);
+	s->tx_tls_drop_bypass_req =
+		atomic64_read(&ktls_stats->ktls_tx_drop_bypass_req);
+#endif
 }
 
 static void collect_adapter_stats(struct adapter *adap, struct adapter_stats *s)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index ea2fabbdd934..b169776ab484 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -44,6 +44,7 @@
 #include "cxgb4.h"
 
 #define MAX_ULD_QSETS 16
+#define MAX_ULD_NPORTS 4
 
 /* CPL message priority levels */
 enum {
@@ -365,17 +366,10 @@ struct cxgb4_virt_res {                      /* virtualized HW resources */
 };
 
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
-struct ch_ktls_stats_debug {
+struct ch_ktls_port_stats_debug {
 	atomic64_t ktls_tx_connection_open;
 	atomic64_t ktls_tx_connection_fail;
 	atomic64_t ktls_tx_connection_close;
-	atomic64_t ktls_tx_send_records;
-	atomic64_t ktls_tx_end_pkts;
-	atomic64_t ktls_tx_start_pkts;
-	atomic64_t ktls_tx_middle_pkts;
-	atomic64_t ktls_tx_retransmit_pkts;
-	atomic64_t ktls_tx_complete_pkts;
-	atomic64_t ktls_tx_trimmed_pkts;
 	atomic64_t ktls_tx_encrypted_packets;
 	atomic64_t ktls_tx_encrypted_bytes;
 	atomic64_t ktls_tx_ctx;
@@ -384,6 +378,17 @@ struct ch_ktls_stats_debug {
 	atomic64_t ktls_tx_drop_no_sync_data;
 	atomic64_t ktls_tx_drop_bypass_req;
 };
+
+struct ch_ktls_stats_debug {
+	struct ch_ktls_port_stats_debug ktls_port[MAX_ULD_NPORTS];
+	atomic64_t ktls_tx_send_records;
+	atomic64_t ktls_tx_end_pkts;
+	atomic64_t ktls_tx_start_pkts;
+	atomic64_t ktls_tx_middle_pkts;
+	atomic64_t ktls_tx_retransmit_pkts;
+	atomic64_t ktls_tx_complete_pkts;
+	atomic64_t ktls_tx_trimmed_pkts;
+};
 #endif
 
 struct chcr_stats_debug {
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index d4c8184c82a1..85767ff2fe84 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -337,6 +337,7 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx =
 				chcr_get_ktls_tx_context(tls_ctx);
 	struct chcr_ktls_info *tx_info = tx_ctx->chcr_info;
+	struct ch_ktls_port_stats_debug *port_stats;
 
 	if (!tx_info)
 		return;
@@ -361,7 +362,8 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 				 tx_info->tid, tx_info->ip_family);
 	}
 
-	atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_connection_close);
+	port_stats = &tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
+	atomic64_inc(&port_stats->ktls_tx_connection_close);
 	kvfree(tx_info);
 	tx_ctx->chcr_info = NULL;
 	/* release module refcount */
@@ -383,6 +385,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 			     u32 start_offload_tcp_sn)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct ch_ktls_port_stats_debug *port_stats;
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
 	struct chcr_ktls_info *tx_info;
 	struct dst_entry *dst;
@@ -396,8 +399,9 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 
 	pi = netdev_priv(netdev);
 	adap = pi->adapter;
+	port_stats = &adap->ch_ktls_stats.ktls_port[pi->port_id];
+	atomic64_inc(&port_stats->ktls_tx_connection_open);
 
-	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_open);
 	if (direction == TLS_OFFLOAD_CTX_DIR_RX) {
 		pr_err("not expecting for RX direction\n");
 		goto out;
@@ -508,7 +512,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (!cxgb4_check_l2t_valid(tx_info->l2te))
 		goto close_tcb;
 
-	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_ctx);
+	atomic64_inc(&port_stats->ktls_tx_ctx);
 	tx_ctx->chcr_info = tx_info;
 
 	return 0;
@@ -534,7 +538,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 free_tx_info:
 	kvfree(tx_info);
 out:
-	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_fail);
+	atomic64_inc(&port_stats->ktls_tx_connection_fail);
 	return -1;
 }
 
@@ -744,6 +748,7 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 				   u64 tcp_ack, u64 tcp_win)
 {
 	bool first_wr = ((tx_info->prev_ack == 0) && (tx_info->prev_win == 0));
+	struct ch_ktls_port_stats_debug *port_stats;
 	u32 len, cpl = 0, ndesc, wr_len;
 	struct fw_ulptx_wr *wr;
 	int credits;
@@ -777,12 +782,14 @@ static int chcr_ktls_xmit_tcb_cpls(struct chcr_ktls_info *tx_info,
 	/* reset snd una if it's a re-transmit pkt */
 	if (tcp_seq != tx_info->prev_seq) {
 		/* reset snd_una */
+		port_stats =
+			&tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
 		pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
 						 TCB_SND_UNA_RAW_W,
 						 TCB_SND_UNA_RAW_V
 						 (TCB_SND_UNA_RAW_M),
 						 TCB_SND_UNA_RAW_V(0), 0);
-		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_ooo);
+		atomic64_inc(&port_stats->ktls_tx_ooo);
 		cpl++;
 	}
 	/* update ack */
@@ -1815,6 +1822,7 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 /* nic tls TX handler */
 static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	struct ch_ktls_port_stats_debug *port_stats;
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx;
 	struct ch_ktls_stats_debug *stats;
 	struct tcphdr *th = tcp_hdr(skb);
@@ -1856,6 +1864,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	adap = tx_info->adap;
 	stats = &adap->ch_ktls_stats;
+	port_stats = &stats->ktls_port[tx_info->port_id];
 
 	qidx = skb->queue_mapping;
 	q = &adap->sge.ethtxq[qidx + tx_info->first_qset];
@@ -1901,13 +1910,13 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 		 */
 		if (unlikely(!record)) {
 			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
-			atomic64_inc(&stats->ktls_tx_drop_no_sync_data);
+			atomic64_inc(&port_stats->ktls_tx_drop_no_sync_data);
 			goto out;
 		}
 
 		if (unlikely(tls_record_is_start_marker(record))) {
 			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
-			atomic64_inc(&stats->ktls_tx_skip_no_sync_data);
+			atomic64_inc(&port_stats->ktls_tx_skip_no_sync_data);
 			goto out;
 		}
 
@@ -1978,9 +1987,8 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	} while (data_len > 0);
 
 	tx_info->prev_seq = ntohl(th->seq) + skb->data_len;
-
-	atomic64_inc(&stats->ktls_tx_encrypted_packets);
-	atomic64_add(skb->data_len, &stats->ktls_tx_encrypted_bytes);
+	atomic64_inc(&port_stats->ktls_tx_encrypted_packets);
+	atomic64_add(skb->data_len, &port_stats->ktls_tx_encrypted_bytes);
 
 	/* tcp finish is set, send a separate tcp msg including all the options
 	 * as well.
-- 
2.18.1

