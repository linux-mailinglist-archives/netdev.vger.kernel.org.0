Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10478276909
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 08:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgIXGg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 02:36:57 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:27933 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbgIXGg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 02:36:56 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08O6aeja003455;
        Wed, 23 Sep 2020 23:36:49 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net-next v2 1/3] ch_ktls: Issue if connection offload fails
Date:   Thu, 24 Sep 2020 12:06:37 +0530
Message-Id: <20200924063639.18005-2-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200924063639.18005-1-rohitm@chelsio.com>
References: <20200924063639.18005-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since driver first return success to tls_dev_add, if req to HW is
successful, but later if HW returns failure, that connection traffic
fails permanently and connection status remains unknown to stack.

v1->v2:
- removed conn_up from all places.

Fixes: 34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 251 ++++++++----------
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |  13 +-
 2 files changed, 112 insertions(+), 152 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 4609f1f78426..d4c8184c82a1 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -125,60 +125,6 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 	return ret;
 }
 
-static int chcr_ktls_update_connection_state(struct chcr_ktls_info *tx_info,
-					     int new_state)
-{
-	/* This function can be called from both rx (interrupt context) and tx
-	 * queue contexts.
-	 */
-	spin_lock_bh(&tx_info->lock);
-	switch (tx_info->connection_state) {
-	case KTLS_CONN_CLOSED:
-		tx_info->connection_state = new_state;
-		break;
-
-	case KTLS_CONN_ACT_OPEN_REQ:
-		/* only go forward if state is greater than current state. */
-		if (new_state <= tx_info->connection_state)
-			break;
-		/* update to the next state and also initialize TCB */
-		tx_info->connection_state = new_state;
-		fallthrough;
-	case KTLS_CONN_ACT_OPEN_RPL:
-		/* if we are stuck in this state, means tcb init might not
-		 * received by HW, try sending it again.
-		 */
-		if (!chcr_init_tcb_fields(tx_info))
-			tx_info->connection_state = KTLS_CONN_SET_TCB_REQ;
-		break;
-
-	case KTLS_CONN_SET_TCB_REQ:
-		/* only go forward if state is greater than current state. */
-		if (new_state <= tx_info->connection_state)
-			break;
-		/* update to the next state and check if l2t_state is valid  */
-		tx_info->connection_state = new_state;
-		fallthrough;
-	case KTLS_CONN_SET_TCB_RPL:
-		/* Check if l2t state is valid, then move to ready state. */
-		if (cxgb4_check_l2t_valid(tx_info->l2te)) {
-			tx_info->connection_state = KTLS_CONN_TX_READY;
-			atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_ctx);
-		}
-		break;
-
-	case KTLS_CONN_TX_READY:
-		/* nothing to be done here */
-		break;
-
-	default:
-		pr_err("unknown KTLS connection state\n");
-		break;
-	}
-	spin_unlock_bh(&tx_info->lock);
-
-	return tx_info->connection_state;
-}
 /*
  * chcr_ktls_act_open_req: creates TCB entry for ipv4 connection.
  * @sk - tcp socket.
@@ -298,27 +244,17 @@ static int chcr_setup_connection(struct sock *sk,
 		return -EINVAL;
 
 	tx_info->atid = atid;
-	tx_info->ip_family = sk->sk_family;
 
-	if (sk->sk_family == AF_INET) {
-		tx_info->ip_family = AF_INET;
+	if (tx_info->ip_family == AF_INET) {
 		ret = chcr_ktls_act_open_req(sk, tx_info, atid);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		if (!sk->sk_ipv6only &&
-		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED) {
-			tx_info->ip_family = AF_INET;
-			ret = chcr_ktls_act_open_req(sk, tx_info, atid);
-		} else {
-			tx_info->ip_family = AF_INET6;
-			ret = cxgb4_clip_get(tx_info->netdev,
-					     (const u32 *)
-					     &sk->sk_v6_rcv_saddr.s6_addr,
-					     1);
-			if (ret)
-				goto out;
-			ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
-		}
+		ret = cxgb4_clip_get(tx_info->netdev, (const u32 *)
+				     &sk->sk_v6_rcv_saddr,
+				     1);
+		if (ret)
+			return ret;
+		ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
 #endif
 	}
 
@@ -326,16 +262,21 @@ static int chcr_setup_connection(struct sock *sk,
 	 * success, if any other return type clear atid and return that failure.
 	 */
 	if (ret) {
-		if (ret == NET_XMIT_CN)
+		if (ret == NET_XMIT_CN) {
 			ret = 0;
-		else
+		} else {
+#if IS_ENABLED(CONFIG_IPV6)
+			/* clear clip entry */
+			if (tx_info->ip_family == AF_INET6)
+				cxgb4_clip_release(tx_info->netdev,
+						   (const u32 *)
+						   &sk->sk_v6_rcv_saddr,
+						   1);
+#endif
 			cxgb4_free_atid(t, atid);
-		goto out;
+		}
 	}
 
-	/* update the connection state */
-	chcr_ktls_update_connection_state(tx_info, KTLS_CONN_ACT_OPEN_REQ);
-out:
 	return ret;
 }
 
@@ -396,15 +337,9 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 	struct chcr_ktls_ofld_ctx_tx *tx_ctx =
 				chcr_get_ktls_tx_context(tls_ctx);
 	struct chcr_ktls_info *tx_info = tx_ctx->chcr_info;
-	struct sock *sk;
 
 	if (!tx_info)
 		return;
-	sk = tx_info->sk;
-
-	spin_lock(&tx_info->lock);
-	tx_info->connection_state = KTLS_CONN_CLOSED;
-	spin_unlock(&tx_info->lock);
 
 	/* clear l2t entry */
 	if (tx_info->l2te)
@@ -413,8 +348,8 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 #if IS_ENABLED(CONFIG_IPV6)
 	/* clear clip entry */
 	if (tx_info->ip_family == AF_INET6)
-		cxgb4_clip_release(netdev,
-				   (const u32 *)&sk->sk_v6_daddr.in6_u.u6_addr8,
+		cxgb4_clip_release(netdev, (const u32 *)
+				   &tx_info->sk->sk_v6_rcv_saddr,
 				   1);
 #endif
 
@@ -461,28 +396,19 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 
 	pi = netdev_priv(netdev);
 	adap = pi->adapter;
+
+	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_open);
 	if (direction == TLS_OFFLOAD_CTX_DIR_RX) {
 		pr_err("not expecting for RX direction\n");
-		ret = -EINVAL;
 		goto out;
 	}
-	if (tx_ctx->chcr_info) {
-		ret = -EINVAL;
+
+	if (tx_ctx->chcr_info)
 		goto out;
-	}
 
 	tx_info = kvzalloc(sizeof(*tx_info), GFP_KERNEL);
-	if (!tx_info) {
-		ret = -ENOMEM;
+	if (!tx_info)
 		goto out;
-	}
-
-	spin_lock_init(&tx_info->lock);
-
-	/* clear connection state */
-	spin_lock(&tx_info->lock);
-	tx_info->connection_state = KTLS_CONN_CLOSED;
-	spin_unlock(&tx_info->lock);
 
 	tx_info->sk = sk;
 	/* initialize tid and atid to -1, 0 is a also a valid id. */
@@ -495,10 +421,12 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	tx_info->tx_chan = pi->tx_chan;
 	tx_info->smt_idx = pi->smt_idx;
 	tx_info->port_id = pi->port_id;
+	tx_info->prev_ack = 0;
+	tx_info->prev_win = 0;
 
 	tx_info->rx_qid = chcr_get_first_rx_qid(adap);
 	if (unlikely(tx_info->rx_qid < 0))
-		goto out2;
+		goto free_tx_info;
 
 	tx_info->prev_seq = start_offload_tcp_sn;
 	tx_info->tcp_start_seq_number = start_offload_tcp_sn;
@@ -506,18 +434,22 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	/* save crypto keys */
 	ret = chcr_ktls_save_keys(tx_info, crypto_info, direction);
 	if (ret < 0)
-		goto out2;
+		goto free_tx_info;
 
 	/* get peer ip */
 	if (sk->sk_family == AF_INET) {
 		memcpy(daaddr, &sk->sk_daddr, 4);
+		tx_info->ip_family = AF_INET;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		if (!sk->sk_ipv6only &&
-		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)
+		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED) {
 			memcpy(daaddr, &sk->sk_daddr, 4);
-		else
+			tx_info->ip_family = AF_INET;
+		} else {
 			memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
+			tx_info->ip_family = AF_INET6;
+		}
 #endif
 	}
 
@@ -525,13 +457,13 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	dst = sk_dst_get(sk);
 	if (!dst) {
 		pr_err("DST entry not found\n");
-		goto out2;
+		goto free_tx_info;
 	}
 	n = dst_neigh_lookup(dst, daaddr);
 	if (!n || !n->dev) {
 		pr_err("neighbour not found\n");
 		dst_release(dst);
-		goto out2;
+		goto free_tx_info;
 	}
 	tx_info->l2te  = cxgb4_l2t_get(adap->l2t, n, n->dev, 0);
 
@@ -540,31 +472,70 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 
 	if (!tx_info->l2te) {
 		pr_err("l2t entry not found\n");
-		goto out2;
+		goto free_tx_info;
 	}
 
-	tx_ctx->chcr_info = tx_info;
+	/* Driver shouldn't be removed until any single connection exists */
+	if (!try_module_get(THIS_MODULE))
+		goto free_l2t;
 
+	init_completion(&tx_info->completion);
 	/* create a filter and call cxgb4_l2t_send to send the packet out, which
 	 * will take care of updating l2t entry in hw if not already done.
 	 */
-	ret = chcr_setup_connection(sk, tx_info);
-	if (ret)
-		goto out2;
+	tx_info->open_pending = true;
 
-	/* Driver shouldn't be removed until any single connection exists */
-	if (!try_module_get(THIS_MODULE)) {
-		ret = -EINVAL;
-		goto out2;
-	}
+	if (chcr_setup_connection(sk, tx_info))
+		goto put_module;
+
+	/* Wait for reply */
+	wait_for_completion_timeout(&tx_info->completion, 30 * HZ);
+	if (tx_info->open_pending)
+		goto put_module;
+
+	/* initialize tcb */
+	reinit_completion(&tx_info->completion);
+	tx_info->open_pending = true;
+
+	if (chcr_init_tcb_fields(tx_info))
+		goto free_tid;
+
+	/* Wait for reply */
+	wait_for_completion_timeout(&tx_info->completion, 30 * HZ);
+	if (tx_info->open_pending)
+		goto free_tid;
+
+	if (!cxgb4_check_l2t_valid(tx_info->l2te))
+		goto close_tcb;
+
+	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_ctx);
+	tx_ctx->chcr_info = tx_info;
 
-	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_open);
 	return 0;
-out2:
+
+close_tcb:
+	chcr_ktls_mark_tcb_close(tx_info);
+free_tid:
+#if IS_ENABLED(CONFIG_IPV6)
+	/* clear clip entry */
+	if (tx_info->ip_family == AF_INET6)
+		cxgb4_clip_release(netdev, (const u32 *)
+				   &sk->sk_v6_rcv_saddr,
+				   1);
+#endif
+	cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
+			 tx_info->tid, tx_info->ip_family);
+
+put_module:
+	/* release module refcount */
+	module_put(THIS_MODULE);
+free_l2t:
+	cxgb4_l2t_release(tx_info->l2te);
+free_tx_info:
 	kvfree(tx_info);
 out:
 	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_fail);
-	return ret;
+	return -1;
 }
 
 /*
@@ -628,19 +599,28 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
 
 	if (!tx_info || tx_info->atid != atid) {
 		pr_err("tx_info or atid is not correct\n");
-		return -1;
+		goto done;
 	}
 
+	cxgb4_free_atid(t, atid);
+	tx_info->atid = -1;
+
 	if (!status) {
 		tx_info->tid = tid;
 		cxgb4_insert_tid(t, tx_info, tx_info->tid, tx_info->ip_family);
-
-		cxgb4_free_atid(t, atid);
-		tx_info->atid = -1;
-		/* update the connection state */
-		chcr_ktls_update_connection_state(tx_info,
-						  KTLS_CONN_ACT_OPEN_RPL);
+		tx_info->open_pending = false;
+	} else {
+#if IS_ENABLED(CONFIG_IPV6)
+		/* clear clip entry */
+		if (tx_info->ip_family == AF_INET6)
+			cxgb4_clip_release(tx_info->netdev, (const u32 *)
+					   &tx_info->sk->sk_v6_rcv_saddr,
+					   1);
+#endif
 	}
+
+done:
+	complete(&tx_info->completion);
 	return 0;
 }
 
@@ -658,12 +638,11 @@ static int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 
 	t = &adap->tids;
 	tx_info = lookup_tid(t, tid);
-	if (!tx_info || tx_info->tid != tid) {
-		pr_err("tx_info or atid is not correct\n");
-		return -1;
-	}
-	/* update the connection state */
-	chcr_ktls_update_connection_state(tx_info, KTLS_CONN_SET_TCB_RPL);
+
+	if (tx_info && tx_info->tid == tid)
+		tx_info->open_pending = false;
+
+	complete(&tx_info->completion);
 	return 0;
 }
 
@@ -1845,7 +1824,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	u32 tls_end_offset, tcp_seq;
 	struct tls_context *tls_ctx;
 	struct sk_buff *local_skb;
-	int new_connection_state;
 	struct sge_eth_txq *q;
 	struct adapter *adap;
 	unsigned long flags;
@@ -1868,15 +1846,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(!tx_info))
 		goto out;
 
-	/* check the connection state, we don't need to pass new connection
-	 * state, state machine will check and update the new state if it is
-	 * stuck due to responses not received from HW.
-	 * Start the tx handling only if state is KTLS_CONN_TX_READY.
-	 */
-	new_connection_state = chcr_ktls_update_connection_state(tx_info, 0);
-	if (new_connection_state != KTLS_CONN_TX_READY)
-		goto out;
-
 	/* don't touch the original skb, make a new skb to extract each records
 	 * and send them separately.
 	 */
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
index 4ae6ae38c406..e0c68cd17cae 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.h
@@ -27,22 +27,13 @@
 #define CHCR_KTLS_WR_SIZE	(CHCR_PLAIN_TX_DATA_LEN +\
 				 sizeof(struct cpl_tx_sec_pdu))
 
-enum chcr_ktls_conn_state {
-	KTLS_CONN_CLOSED,
-	KTLS_CONN_ACT_OPEN_REQ,
-	KTLS_CONN_ACT_OPEN_RPL,
-	KTLS_CONN_SET_TCB_REQ,
-	KTLS_CONN_SET_TCB_RPL,
-	KTLS_CONN_TX_READY,
-};
-
 struct chcr_ktls_info {
 	struct sock *sk;
-	spinlock_t lock; /* state machine lock */
 	struct ktls_key_ctx key_ctx;
 	struct adapter *adap;
 	struct l2t_entry *l2te;
 	struct net_device *netdev;
+	struct completion completion;
 	u64 iv;
 	u64 record_no;
 	int tid;
@@ -58,13 +49,13 @@ struct chcr_ktls_info {
 	u32 tcp_start_seq_number;
 	u32 scmd0_short_seqno_numivs;
 	u32 scmd0_short_ivgen_hdrlen;
-	enum chcr_ktls_conn_state connection_state;
 	u16 prev_win;
 	u8 tx_chan;
 	u8 smt_idx;
 	u8 port_id;
 	u8 ip_family;
 	u8 first_qset;
+	bool open_pending;
 };
 
 struct chcr_ktls_ofld_ctx_tx {
-- 
2.18.1

