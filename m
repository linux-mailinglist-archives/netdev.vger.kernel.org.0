Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FECE295320
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 21:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440748AbgJUTvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 15:51:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:57150 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410356AbgJUTvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 15:51:13 -0400
IronPort-SDR: QT1Cl1mx6lOOchffuO7eZZcP3r9gLY79/4UCSM9AHJp5n3D5CsIyX0PRo43opky0VG6ANk/Rau
 WMhG7MW8lciw==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="231618708"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="231618708"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 12:51:10 -0700
IronPort-SDR: k+xdczRMHUVv1h+JPGf3LiM5molzLewinoyDmqES50OUh+0qDlEMytym2oO5wY8J+axWplJSWD
 vWDE25dbrXWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="392834640"
Received: from harshitha-linux4.jf.intel.com ([10.166.17.87])
  by orsmga001.jf.intel.com with ESMTP; 21 Oct 2020 12:51:10 -0700
From:   Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     tom@herbertland.com, carolyn.wyborny@intel.com,
        jacob.e.keller@intel.com, amritha.nambiar@intel.com,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Subject: [RFC PATCH net-next 2/3] sock: Use dev_and_queue structure for RX queue mapping in sock
Date:   Wed, 21 Oct 2020 12:47:42 -0700
Message-Id: <20201021194743.781583-3-harshitha.ramamurthy@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
References: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>

Replace sk_rx_queue_mapping with sk_rx_dev_and_queue_mapping and
change associated function to set, get, and clear mapping. This
patch ensures that the queue picked for transmit is correct by
setting the queue and ifindex and then retrieving the queue number
only if the ifindex matches the one stored.

Fixes: c6345ce7d361d ("net: Record receive queue number for a connection")
Signed-off-by: Tom Herbert <tom@herbertland.com>
Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  6 ++--
 include/net/busy_poll.h                       |  2 +-
 include/net/sock.h                            | 30 ++++++++-----------
 net/core/dev.c                                |  2 +-
 net/core/filter.c                             |  7 +++--
 net/core/sock.c                               |  2 +-
 net/ipv4/tcp_input.c                          |  2 +-
 7 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index ccaccb9fc2f7..fe0756a6ada4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -548,9 +548,9 @@ void mlx5e_ktls_handle_ctx_completion(struct mlx5e_icosq_wqe_info *wi)
 	queue_work(rule->priv->tls->rx_wq, &rule->work);
 }
 
-static int mlx5e_ktls_sk_get_rxq(struct sock *sk)
+static int mlx5e_ktls_sk_get_rxq(struct sock *sk, struct net_device *dev)
 {
-	int rxq = sk_rx_queue_get(sk);
+	int rxq = sk_rx_dev_and_queue_get(sk, dev->ifindex);
 
 	if (unlikely(rxq == -1))
 		rxq = 0;
@@ -584,7 +584,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 
-	rxq = mlx5e_ktls_sk_get_rxq(sk);
+	rxq = mlx5e_ktls_sk_get_rxq(sk, netdev);
 	priv_rx->rxq = rxq;
 	priv_rx->sk = sk;
 
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index b001fa91c14e..f04283c54bcd 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -128,7 +128,7 @@ static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
-	sk_rx_queue_set(sk, skb);
+	sk_rx_dev_and_queue_set(sk, skb);
 }
 
 /* variant used for unconnected sockets */
diff --git a/include/net/sock.h b/include/net/sock.h
index 9755a6cab1a1..d47b310cf132 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -151,7 +151,7 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_node: main hash linkage for various protocol lookup tables
  *	@skc_nulls_node: main hash linkage for TCP/UDP/UDP-Lite protocol
  *	@skc_tx_queue_mapping: tx queue number for this connection
- *	@skc_rx_queue_mapping: rx queue number for this connection
+ *	@skc_rx_dev_and_queue_mapping: rx ifindex/queue number for this connection
  *	@skc_flags: place holder for sk_flags
  *		%SO_LINGER (l_onoff), %SO_BROADCAST, %SO_KEEPALIVE,
  *		%SO_OOBINLINE settings, %SO_TIMESTAMPING settings
@@ -237,7 +237,7 @@ struct sock_common {
 	};
 	unsigned short		skc_tx_queue_mapping;
 #ifdef CONFIG_XPS
-	unsigned short		skc_rx_queue_mapping;
+	struct dev_and_queue	skc_rx_dev_and_queue_mapping;
 #endif
 	union {
 		int		skc_incoming_cpu;
@@ -365,7 +365,7 @@ struct sock {
 #define sk_refcnt		__sk_common.skc_refcnt
 #define sk_tx_queue_mapping	__sk_common.skc_tx_queue_mapping
 #ifdef CONFIG_XPS
-#define sk_rx_queue_mapping	__sk_common.skc_rx_queue_mapping
+#define sk_rx_dev_and_queue_mapping	__sk_common.skc_rx_dev_and_queue_mapping
 #endif
 
 #define sk_dontcopy_begin	__sk_common.skc_dontcopy_begin
@@ -1862,34 +1862,30 @@ static inline int sk_tx_queue_get(const struct sock *sk)
 	return -1;
 }
 
-static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
+static inline void sk_rx_dev_and_queue_set(struct sock *sk,
+					   const struct sk_buff *skb)
 {
 #ifdef CONFIG_XPS
-	if (skb_rx_queue_recorded(skb)) {
-		u16 rx_queue = skb_get_rx_queue(skb);
+	if (skb->dev && skb_rx_queue_recorded(skb)) {
+		int ifindex = skb->dev->ifindex;
 
-		if (WARN_ON_ONCE(rx_queue == NO_QUEUE_MAPPING))
-			return;
-
-		sk->sk_rx_queue_mapping = rx_queue;
+		__dev_and_queue_set(&sk->sk_rx_dev_and_queue_mapping, ifindex,
+				    skb_get_rx_queue(skb));
 	}
 #endif
 }
 
-static inline void sk_rx_queue_clear(struct sock *sk)
+static inline void sk_rx_dev_and_queue_clear(struct sock *sk)
 {
 #ifdef CONFIG_XPS
-	sk->sk_rx_queue_mapping = NO_QUEUE_MAPPING;
+	__dev_and_queue_clear(&sk->sk_rx_dev_and_queue_mapping);
 #endif
 }
 
 #ifdef CONFIG_XPS
-static inline int sk_rx_queue_get(const struct sock *sk)
+static inline int sk_rx_dev_and_queue_get(const struct sock *sk, int ifindex)
 {
-	if (sk && sk->sk_rx_queue_mapping != NO_QUEUE_MAPPING)
-		return sk->sk_rx_queue_mapping;
-
-	return -1;
+	return sk ? __dev_and_queue_get(&sk->sk_tx_dev_and_queue_mapping, ifindex) : -1;
 }
 #endif
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 751e5264fd49..83cd3ee801e8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3939,7 +3939,7 @@ static int get_xps_queue(struct net_device *dev, struct net_device *sb_dev,
 
 	dev_maps = rcu_dereference(sb_dev->xps_rxqs_map);
 	if (dev_maps) {
-		int tci = sk_rx_queue_get(sk);
+		int tci = sk_rx_dev_and_queue_get(sk, dev->ifindex);
 
 		if (tci >= 0 && tci < dev->num_rx_queues)
 			queue_index = __get_xps_queue_idx(dev, skb, dev_maps,
diff --git a/net/core/filter.c b/net/core/filter.c
index c5e2a1c5fd8d..13f2aa2f3e04 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8749,11 +8749,12 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct bpf_sock, rx_queue_mapping):
 #ifdef CONFIG_XPS
 		*insn++ = BPF_LDX_MEM(
-			BPF_FIELD_SIZEOF(struct sock, sk_rx_queue_mapping),
+			BPF_FIELD_SIZEOF(struct sock,
+					 sk_rx_dev_and_queue_mapping),
 			si->dst_reg, si->src_reg,
-			bpf_target_off(struct sock, sk_rx_queue_mapping,
+			bpf_target_off(struct sock, sk_rx_dev_and_queue_mapping.queue,
 				       sizeof_field(struct sock,
-						    sk_rx_queue_mapping),
+						    sk_rx_dev_and_queue_mapping.queue),
 				       target_size));
 		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, NO_QUEUE_MAPPING,
 				      1);
diff --git a/net/core/sock.c b/net/core/sock.c
index 4e8729357122..1bb846672a34 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3019,7 +3019,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
 
-	sk_rx_queue_clear(sk);
+	sk_rx_dev_and_queue_clear(sk);
 	/*
 	 * Before updating sk_refcnt, we must commit prior changes to memory
 	 * (Documentation/RCU/rculist_nulls.rst for details)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 67f10d3ec240..c13c35ba55a7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6842,7 +6842,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	tcp_rsk(req)->txhash = net_tx_rndhash();
 	tcp_rsk(req)->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
 	tcp_openreq_init_rwin(req, sk, dst);
-	sk_rx_queue_set(req_to_sk(req), skb);
+	sk_rx_dev_and_queue_set(req_to_sk(req), skb);
 	if (!want_cookie) {
 		tcp_reqsk_record_syn(sk, req, skb);
 		fastopen_sk = tcp_try_fastopen(sk, skb, req, &foc, dst);
-- 
2.26.2

