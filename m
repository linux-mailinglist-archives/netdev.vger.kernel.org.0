Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E2329531F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 21:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440737AbgJUTvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 15:51:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:57150 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438863AbgJUTvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 15:51:12 -0400
IronPort-SDR: OsLnKHu/KBJEUHG4TNk7p0FV6qwYsnr1UtMVGOZAlERh6Nejlerhb/zEBiMHWmsj0VvFnEa4jn
 z4wmlkQo2Zdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="231618709"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="231618709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 12:51:10 -0700
IronPort-SDR: zNo4mY4bV+UL8d/Aucq5fnVEuSlkvwyJErhpMOs/pb3ysyJDRmTxdc2AC/M4xM/bV0EeUyK9Hn
 sAbUWDok+9xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="392834643"
Received: from harshitha-linux4.jf.intel.com ([10.166.17.87])
  by orsmga001.jf.intel.com with ESMTP; 21 Oct 2020 12:51:10 -0700
From:   Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     tom@herbertland.com, carolyn.wyborny@intel.com,
        jacob.e.keller@intel.com, amritha.nambiar@intel.com,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Subject: [RFC PATCH net-next 3/3] sock: Use dev_and_queue structure for TX queue mapping in sock
Date:   Wed, 21 Oct 2020 12:47:43 -0700
Message-Id: <20201021194743.781583-4-harshitha.ramamurthy@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
References: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>

Replace sk_tx_queue_mapping with sk_tx_dev_and_queue_mapping and
change associated functions to set, get, and clear mapping. This
patch ensures that the queue picked for transmit is correct by
setting the queue and ifindex and then retriveing the queue number
only if the ifindex matches the one stored.

Signed-off-by: Tom Herbert <tom@herbertland.com>
Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
---
 drivers/net/hyperv/netvsc_drv.c |  4 ++--
 include/net/request_sock.h      |  2 +-
 include/net/sock.h              | 31 +++++++++++++------------------
 net/core/dev.c                  |  4 ++--
 net/core/sock.c                 |  8 ++++----
 5 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 261e6e55a907..9f8a4efa39c0 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -307,7 +307,7 @@ static inline int netvsc_get_tx_queue(struct net_device *ndev,
 	/* If queue index changed record the new value */
 	if (q_idx != old_idx &&
 	    sk && sk_fullsock(sk) && rcu_access_pointer(sk->sk_dst_cache))
-		sk_tx_queue_set(sk, q_idx);
+		sk_tx_dev_and_queue_set(sk, ndev->ifindex, q_idx);
 
 	return q_idx;
 }
@@ -325,7 +325,7 @@ static inline int netvsc_get_tx_queue(struct net_device *ndev,
  */
 static u16 netvsc_pick_tx(struct net_device *ndev, struct sk_buff *skb)
 {
-	int q_idx = sk_tx_queue_get(skb->sk);
+	int q_idx = sk_tx_dev_and_queue_get(skb->sk, ndev->ifindex);
 
 	if (q_idx < 0 || skb->ooo_okay || q_idx >= ndev->real_num_tx_queues) {
 		/* If forwarding a packet, we use the recorded queue when
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 29e41ff3ec93..a663cc7c91b7 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -102,7 +102,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
 	req->rsk_ops = ops;
 	req_to_sk(req)->sk_prot = sk_listener->sk_prot;
 	sk_node_init(&req_to_sk(req)->sk_node);
-	sk_tx_queue_clear(req_to_sk(req));
+	sk_tx_dev_and_queue_clear(req_to_sk(req));
 	req->saved_syn = NULL;
 	req->num_timeout = 0;
 	req->num_retrans = 0;
diff --git a/include/net/sock.h b/include/net/sock.h
index d47b310cf132..4c469bbb47e4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -150,7 +150,7 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_cookie: socket's cookie value
  *	@skc_node: main hash linkage for various protocol lookup tables
  *	@skc_nulls_node: main hash linkage for TCP/UDP/UDP-Lite protocol
- *	@skc_tx_queue_mapping: tx queue number for this connection
+ *	@skc_tx_dev_and_queue_mapping: tx ifindex/queue number for this connection
  *	@skc_rx_dev_and_queue_mapping: rx ifindex/queue number for this connection
  *	@skc_flags: place holder for sk_flags
  *		%SO_LINGER (l_onoff), %SO_BROADCAST, %SO_KEEPALIVE,
@@ -235,7 +235,7 @@ struct sock_common {
 		struct hlist_node	skc_node;
 		struct hlist_nulls_node skc_nulls_node;
 	};
-	unsigned short		skc_tx_queue_mapping;
+	struct dev_and_queue	skc_tx_dev_and_queue_mapping;
 #ifdef CONFIG_XPS
 	struct dev_and_queue	skc_rx_dev_and_queue_mapping;
 #endif
@@ -363,7 +363,7 @@ struct sock {
 #define sk_node			__sk_common.skc_node
 #define sk_nulls_node		__sk_common.skc_nulls_node
 #define sk_refcnt		__sk_common.skc_refcnt
-#define sk_tx_queue_mapping	__sk_common.skc_tx_queue_mapping
+#define sk_tx_dev_and_queue_mapping	__sk_common.skc_tx_dev_and_queue_mapping
 #ifdef CONFIG_XPS
 #define sk_rx_dev_and_queue_mapping	__sk_common.skc_rx_dev_and_queue_mapping
 #endif
@@ -1841,25 +1841,20 @@ static inline void __dev_and_queue_clear(struct dev_and_queue *odandq)
 	odandq->val64 = dandq.val64;
 }
 
-static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
+static inline void sk_tx_dev_and_queue_set(struct sock *sk, int ifindex,
+					   int tx_queue)
 {
-	/* sk_tx_queue_mapping accept only upto a 16-bit value */
-	if (WARN_ON_ONCE((unsigned short)tx_queue >= USHRT_MAX))
-		return;
-	sk->sk_tx_queue_mapping = tx_queue;
+	__dev_and_queue_set(&sk->sk_tx_dev_and_queue_mapping, ifindex, tx_queue);
 }
 
-static inline void sk_tx_queue_clear(struct sock *sk)
+static inline void sk_tx_dev_and_queue_clear(struct sock *sk)
 {
-	sk->sk_tx_queue_mapping = NO_QUEUE_MAPPING;
+	__dev_and_queue_clear(&sk->sk_tx_dev_and_queue_mapping);
 }
 
-static inline int sk_tx_queue_get(const struct sock *sk)
+static inline int sk_tx_dev_and_queue_get(const struct sock *sk, int ifindex)
 {
-	if (sk && sk->sk_tx_queue_mapping != NO_QUEUE_MAPPING)
-		return sk->sk_tx_queue_mapping;
-
-	return -1;
+	return sk ? __dev_and_queue_get(&sk->sk_tx_dev_and_queue_mapping, ifindex) : -1;
 }
 
 static inline void sk_rx_dev_and_queue_set(struct sock *sk,
@@ -1984,7 +1979,7 @@ static inline void dst_negative_advice(struct sock *sk)
 
 		if (ndst != dst) {
 			rcu_assign_pointer(sk->sk_dst_cache, ndst);
-			sk_tx_queue_clear(sk);
+			sk_tx_dev_and_queue_clear(sk);
 			sk->sk_dst_pending_confirm = 0;
 		}
 	}
@@ -1995,7 +1990,7 @@ __sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
 	struct dst_entry *old_dst;
 
-	sk_tx_queue_clear(sk);
+	sk_tx_dev_and_queue_clear(sk);
 	sk->sk_dst_pending_confirm = 0;
 	old_dst = rcu_dereference_protected(sk->sk_dst_cache,
 					    lockdep_sock_is_held(sk));
@@ -2008,7 +2003,7 @@ sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
 	struct dst_entry *old_dst;
 
-	sk_tx_queue_clear(sk);
+	sk_tx_dev_and_queue_clear(sk);
 	sk->sk_dst_pending_confirm = 0;
 	old_dst = xchg((__force struct dst_entry **)&sk->sk_dst_cache, dst);
 	dst_release(old_dst);
diff --git a/net/core/dev.c b/net/core/dev.c
index 83cd3ee801e8..6146e04eb965 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3982,7 +3982,7 @@ u16 netdev_pick_tx(struct net_device *dev, struct sk_buff *skb,
 		     struct net_device *sb_dev)
 {
 	struct sock *sk = skb->sk;
-	int queue_index = sk_tx_queue_get(sk);
+	int queue_index = sk_tx_dev_and_queue_get(sk, dev->ifindex);
 
 	sb_dev = sb_dev ? : dev;
 
@@ -3996,7 +3996,7 @@ u16 netdev_pick_tx(struct net_device *dev, struct sk_buff *skb,
 		if (queue_index != new_index && sk &&
 		    sk_fullsock(sk) &&
 		    rcu_access_pointer(sk->sk_dst_cache))
-			sk_tx_queue_set(sk, new_index);
+			sk_tx_dev_and_queue_set(sk, dev->ifindex, new_index);
 
 		queue_index = new_index;
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index 1bb846672a34..93489966c749 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -531,7 +531,7 @@ struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie)
 	struct dst_entry *dst = __sk_dst_get(sk);
 
 	if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
-		sk_tx_queue_clear(sk);
+		sk_tx_dev_and_queue_clear(sk);
 		sk->sk_dst_pending_confirm = 0;
 		RCU_INIT_POINTER(sk->sk_dst_cache, NULL);
 		dst_release(dst);
@@ -1671,7 +1671,7 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 
 		if (!try_module_get(prot->owner))
 			goto out_free_sec;
-		sk_tx_queue_clear(sk);
+		sk_tx_dev_and_queue_clear(sk);
 	}
 
 	return sk;
@@ -1740,7 +1740,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
-		sk_tx_queue_clear(sk);
+		sk_tx_dev_and_queue_clear(sk);
 	}
 
 	return sk;
@@ -1964,7 +1964,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		 */
 		sk_refcnt_debug_inc(newsk);
 		sk_set_socket(newsk, NULL);
-		sk_tx_queue_clear(newsk);
+		sk_tx_dev_and_queue_clear(newsk);
 		RCU_INIT_POINTER(newsk->sk_wq, NULL);
 
 		if (newsk->sk_prot->sockets_allocated)
-- 
2.26.2

