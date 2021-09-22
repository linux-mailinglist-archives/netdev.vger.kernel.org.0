Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E751414F07
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbhIVR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:28:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236867AbhIVR2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632331628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxxplK21M64p9hR45/jYVkT90OzzKHal/FHla5Gxp/8=;
        b=gvEGU+L0GJppWmE3J9YHppkrPifNbWKO1etQ0Q/dPO9NZcPsES03/esT8hOBW8UuywHmtw
        JxELZSACIkVq2StCoqSNH4xpD3rsffbC1gidwslUlcYoaXiR0syYEm8uU6U1fkPsn9FWLq
        zk2nfOzAaks0E5VqYC7MDI5vTbC7AtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-YAtBsCSNPYGjyrbVHzmwoA-1; Wed, 22 Sep 2021 13:27:06 -0400
X-MC-Unique: YAtBsCSNPYGjyrbVHzmwoA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0677010151F8;
        Wed, 22 Sep 2021 17:27:05 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F36519724;
        Wed, 22 Sep 2021 17:27:03 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [PATCH net-next 4/4] tcp: remove sk_{tr}x_skb_cache
Date:   Wed, 22 Sep 2021 19:26:43 +0200
Message-Id: <f14bcb96638a4bccc5763233153702be689749e1.1632318035.git.pabeni@redhat.com>
In-Reply-To: <cover.1632318035.git.pabeni@redhat.com>
References: <cover.1632318035.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This reverts the following patches :

- commit 2e05fcae83c4 ("tcp: fix compile error if !CONFIG_SYSCTL")
- commit 4f661542a402 ("tcp: fix zerocopy and notsent_lowat issues")
- commit 472c2e07eef0 ("tcp: add one skb cache for tx")
- commit 8b27dae5a2e8 ("tcp: add one skb cache for rx")

Having a cache of one skb (in each direction) per TCP socket is fragile,
since it can cause a significant increase of memory needs,
and not good enough for high speed flows anyway where more than one skb
is needed.

We want instead to add a generic infrastructure, with more flexible
per-cpu caches, for alien NUMA nodes.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/networking/ip-sysctl.rst |  8 --------
 include/net/sock.h                     | 19 -------------------
 net/ipv4/af_inet.c                     |  4 ----
 net/ipv4/sysctl_net_ipv4.c             | 12 ------------
 net/ipv4/tcp.c                         | 26 --------------------------
 net/ipv4/tcp_ipv4.c                    |  6 ------
 net/ipv6/tcp_ipv6.c                    |  6 ------
 7 files changed, 81 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index d91ab28718d4..16b8bf72feaf 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -989,14 +989,6 @@ tcp_challenge_ack_limit - INTEGER
 	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
 	Default: 1000
 
-tcp_rx_skb_cache - BOOLEAN
-	Controls a per TCP socket cache of one skb, that might help
-	performance of some workloads. This might be dangerous
-	on systems with a lot of TCP sockets, since it increases
-	memory usage.
-
-	Default: 0 (disabled)
-
 UDP variables
 =============
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 66a9a90f9558..708b9de3cdbb 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -262,7 +262,6 @@ struct bpf_local_storage;
   *	@sk_dst_cache: destination cache
   *	@sk_dst_pending_confirm: need to confirm neighbour
   *	@sk_policy: flow policy
-  *	@sk_rx_skb_cache: cache copy of recently accessed RX skb
   *	@sk_receive_queue: incoming packets
   *	@sk_wmem_alloc: transmit queue bytes committed
   *	@sk_tsq_flags: TCP Small Queues flags
@@ -328,7 +327,6 @@ struct bpf_local_storage;
   *	@sk_peek_off: current peek_offset value
   *	@sk_send_head: front of stuff to transmit
   *	@tcp_rtx_queue: TCP re-transmit queue [union with @sk_send_head]
-  *	@sk_tx_skb_cache: cache copy of recently accessed TX skb
   *	@sk_security: used by security modules
   *	@sk_mark: generic packet mark
   *	@sk_cgrp_data: cgroup data for this cgroup
@@ -393,7 +391,6 @@ struct sock {
 	atomic_t		sk_drops;
 	int			sk_rcvlowat;
 	struct sk_buff_head	sk_error_queue;
-	struct sk_buff		*sk_rx_skb_cache;
 	struct sk_buff_head	sk_receive_queue;
 	/*
 	 * The backlog queue is special, it is always used with
@@ -442,7 +439,6 @@ struct sock {
 		struct sk_buff	*sk_send_head;
 		struct rb_root	tcp_rtx_queue;
 	};
-	struct sk_buff		*sk_tx_skb_cache;
 	struct sk_buff_head	sk_write_queue;
 	__s32			sk_peek_off;
 	int			sk_write_pending;
@@ -1555,18 +1551,10 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 		__sk_mem_reclaim(sk, 1 << 20);
 }
 
-DECLARE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
 static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 {
 	sk_wmem_queued_add(sk, -skb->truesize);
 	sk_mem_uncharge(sk, skb->truesize);
-	if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
-	    !sk->sk_tx_skb_cache && !skb_cloned(skb)) {
-		skb_ext_reset(skb);
-		skb_zcopy_clear(skb, true);
-		sk->sk_tx_skb_cache = skb;
-		return;
-	}
 	__kfree_skb(skb);
 }
 
@@ -2575,7 +2563,6 @@ static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
 			   &skb_shinfo(skb)->tskey);
 }
 
-DECLARE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
@@ -2587,12 +2574,6 @@ DECLARE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
 static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
 {
 	__skb_unlink(skb, &sk->sk_receive_queue);
-	if (static_branch_unlikely(&tcp_rx_skb_cache_key) &&
-	    !sk->sk_rx_skb_cache) {
-		sk->sk_rx_skb_cache = skb;
-		skb_orphan(skb);
-		return;
-	}
 	__kfree_skb(skb);
 }
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1d816a5fd3eb..40558033f857 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -133,10 +133,6 @@ void inet_sock_destruct(struct sock *sk)
 	struct inet_sock *inet = inet_sk(sk);
 
 	__skb_queue_purge(&sk->sk_receive_queue);
-	if (sk->sk_rx_skb_cache) {
-		__kfree_skb(sk->sk_rx_skb_cache);
-		sk->sk_rx_skb_cache = NULL;
-	}
 	__skb_queue_purge(&sk->sk_error_queue);
 
 	sk_mem_reclaim(sk);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6f1e64d49232..6eb43dc91218 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -594,18 +594,6 @@ static struct ctl_table ipv4_table[] = {
 		.extra1		= &sysctl_fib_sync_mem_min,
 		.extra2		= &sysctl_fib_sync_mem_max,
 	},
-	{
-		.procname	= "tcp_rx_skb_cache",
-		.data		= &tcp_rx_skb_cache_key.key,
-		.mode		= 0644,
-		.proc_handler	= proc_do_static_key,
-	},
-	{
-		.procname	= "tcp_tx_skb_cache",
-		.data		= &tcp_tx_skb_cache_key.key,
-		.mode		= 0644,
-		.proc_handler	= proc_do_static_key,
-	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 29cb7bf9dc1c..414c179c28e0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -325,11 +325,6 @@ struct tcp_splice_state {
 unsigned long tcp_memory_pressure __read_mostly;
 EXPORT_SYMBOL_GPL(tcp_memory_pressure);
 
-DEFINE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
-EXPORT_SYMBOL(tcp_rx_skb_cache_key);
-
-DEFINE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
-
 void tcp_enter_memory_pressure(struct sock *sk)
 {
 	unsigned long val;
@@ -866,18 +861,6 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 {
 	struct sk_buff *skb;
 
-	if (likely(!size)) {
-		skb = sk->sk_tx_skb_cache;
-		if (skb) {
-			skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
-			sk->sk_tx_skb_cache = NULL;
-			pskb_trim(skb, 0);
-			INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
-			skb_shinfo(skb)->tx_flags = 0;
-			memset(TCP_SKB_CB(skb), 0, sizeof(struct tcp_skb_cb));
-			return skb;
-		}
-	}
 	/* The TCP header must be at least 32-bit aligned.  */
 	size = ALIGN(size, 4);
 
@@ -2920,11 +2903,6 @@ void tcp_write_queue_purge(struct sock *sk)
 		sk_wmem_free_skb(sk, skb);
 	}
 	tcp_rtx_queue_purge(sk);
-	skb = sk->sk_tx_skb_cache;
-	if (skb) {
-		__kfree_skb(skb);
-		sk->sk_tx_skb_cache = NULL;
-	}
 	INIT_LIST_HEAD(&tcp_sk(sk)->tsorted_sent_queue);
 	sk_mem_reclaim(sk);
 	tcp_clear_all_retrans_hints(tcp_sk(sk));
@@ -2961,10 +2939,6 @@ int tcp_disconnect(struct sock *sk, int flags)
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
-	if (sk->sk_rx_skb_cache) {
-		__kfree_skb(sk->sk_rx_skb_cache);
-		sk->sk_rx_skb_cache = NULL;
-	}
 	WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 	tp->urg_data = 0;
 	tcp_write_queue_purge(sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2e62e0d6373a..29a57bd159f0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1941,7 +1941,6 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
 int tcp_v4_rcv(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
-	struct sk_buff *skb_to_free;
 	int sdif = inet_sdif(skb);
 	int dif = inet_iif(skb);
 	const struct iphdr *iph;
@@ -2082,17 +2081,12 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	tcp_segs_in(tcp_sk(sk), skb);
 	ret = 0;
 	if (!sock_owned_by_user(sk)) {
-		skb_to_free = sk->sk_rx_skb_cache;
-		sk->sk_rx_skb_cache = NULL;
 		ret = tcp_v4_do_rcv(sk, skb);
 	} else {
 		if (tcp_add_backlog(sk, skb))
 			goto discard_and_relse;
-		skb_to_free = NULL;
 	}
 	bh_unlock_sock(sk);
-	if (skb_to_free)
-		__kfree_skb(skb_to_free);
 
 put_and_return:
 	if (refcounted)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0ce52d46e4f8..8cf5ff2e9504 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1618,7 +1618,6 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 
 INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 {
-	struct sk_buff *skb_to_free;
 	int sdif = inet6_sdif(skb);
 	int dif = inet6_iif(skb);
 	const struct tcphdr *th;
@@ -1754,17 +1753,12 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	tcp_segs_in(tcp_sk(sk), skb);
 	ret = 0;
 	if (!sock_owned_by_user(sk)) {
-		skb_to_free = sk->sk_rx_skb_cache;
-		sk->sk_rx_skb_cache = NULL;
 		ret = tcp_v6_do_rcv(sk, skb);
 	} else {
 		if (tcp_add_backlog(sk, skb))
 			goto discard_and_relse;
-		skb_to_free = NULL;
 	}
 	bh_unlock_sock(sk);
-	if (skb_to_free)
-		__kfree_skb(skb_to_free);
 put_and_return:
 	if (refcounted)
 		sock_put(sk);
-- 
2.26.3

