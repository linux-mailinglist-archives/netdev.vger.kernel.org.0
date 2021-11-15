Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CD34514B4
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242810AbhKOUMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345820AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DDFC06EDC4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:23 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so60330pjb.2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ro2ByOc87T3RNhfRZN4emKA5tVoBW1OfE+eXAwv54hM=;
        b=jhsX8d2KdJCLOaklsXSRf1alOfRDSu0E3HbgT+GzaQLP23C2z4By/bi7vBrljH5jrd
         fke2XgF/VdP3RiwbTSI05NXG5RdmnnnLVmHY4AOkFTGIKmLQR64PvvfgMVypm5tK6HIf
         VS9CKexJjcU0RWGaInz7WIJHBqyCx4gpl24ylEpc0YRpJd6JPOl4A1yt4C92hFP8YfNw
         LcYFfs+IVN2VL8CgJW/P9S/+QjoFkJHkMHJoIpJSIAF9t6P/7W5RNlVohag3X1c0QMKT
         Q8eVdR3gQ0IHuG4Qxtx7L+MlxAq86mL3GrI27X2PltKswOfFY+TvZGEZlGBKjIWhEl7t
         fBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ro2ByOc87T3RNhfRZN4emKA5tVoBW1OfE+eXAwv54hM=;
        b=OaW0snda1WbXXEcO6ZueCijgtYMuZMA28IXpieHQHWgnguxam08t/RspBQRA5uiGMK
         5o417EXfzE/S2mJZuD8YJdsJ9ZUqXZs8hU2P1bi/dfdG3Tdxtg3M4Jg4Ow+HEmqI68FN
         /HhepfxT61rdwnKxnfio9mZ1DGUaRJpj2LC55y1LlY0lpTbLVcTPZA6uGJXEr2TUkdAa
         7lx3YURPEQuolYy1rgkPe82KfTuE6SwAZcVVZgmhng+YmkWqy4FTk4ZfSA7QwT1uSsxm
         z1Bah9yW39qq9Hl0ADi1FVAFMETHbls8yqPl4N3qSB1eCJOAn6j29ocU1hxGWs9A/sry
         +uXw==
X-Gm-Message-State: AOAM531PUWS4klkCoGotDvNNcNYSP5gkRIRKTY7517Br6TBdouTlj8pJ
        Fqw6x8VUTF9XzKjxrXZwirk=
X-Google-Smtp-Source: ABdhPJxEYO18HJFegFhlfjITIaVwNoT0hdlUDej/gt6Yl+2iamsHtpfk/IjKfS882ezDxJi7C7bdeQ==
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr969221pjb.113.1637003003065;
        Mon, 15 Nov 2021 11:03:23 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:22 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock is released
Date:   Mon, 15 Nov 2021 11:02:46 -0800
Message-Id: <20211115190249.3936899-18-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tcp recvmsg() (or rx zerocopy) spends a fair amount of time
freeing skbs after their payload has been consumed.

A typical ~64KB GRO packet has to release ~45 page
references, eventually going to page allocator
for each of them.

Currently, this freeing is performed while socket lock
is held, meaning that there is a high chance that
BH handler has to queue incoming packets to tcp socket backlog.

This can cause additional latencies, because the user
thread has to process the backlog at release_sock() time,
and while doing so, additional frames can be added
by BH handler.

This patch adds logic to defer these frees after socket
lock is released, or directly from BH handler if possible.

Being able to free these skbs from BH handler helps a lot,
because this avoids the usual alloc/free assymetry,
when BH handler and user thread do not run on same cpu or
NUMA node.

One cpu can now be fully utilized for the kernel->user copy,
and another cpu is handling BH processing and skb/page
allocs/frees (assuming RFS is not forcing use of a single CPU)

Tested:
 100Gbit NIC
 Max throughput for one TCP_STREAM flow, over 10 runs

MTU : 1500
Before: 55 Gbit
After:  66 Gbit

MTU : 4096+(headers)
Before: 82 Gbit
After:  95 Gbit

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h |  2 ++
 include/net/sock.h     |  3 +++
 include/net/tcp.h      | 10 ++++++++++
 net/ipv4/tcp.c         | 27 +++++++++++++++++++++++++--
 net/ipv4/tcp_ipv4.c    |  1 +
 net/ipv6/tcp_ipv6.c    |  1 +
 6 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 686a666d073d5106526f3c5c20d64f26131be72d..b8b806512e1615fad2bc9935baba3fff14996012 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -36,6 +36,7 @@
 #include <linux/splice.h>
 #include <linux/in6.h>
 #include <linux/if_packet.h>
+#include <linux/llist.h>
 #include <net/flow.h>
 #include <net/page_pool.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -743,6 +744,7 @@ struct sk_buff {
 		};
 		struct rb_node		rbnode; /* used in netem, ip4 defrag, and tcp stack */
 		struct list_head	list;
+		struct llist_node	ll_node;
 	};
 
 	union {
diff --git a/include/net/sock.h b/include/net/sock.h
index 2d40fe4c7718ee702bf7e5a847ceff6f8f2f5b7d..2578d1f455a7af0d7f4ce5d3b4ac25ee41fdaeb4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -63,6 +63,7 @@
 #include <linux/indirect_call_wrapper.h>
 #include <linux/atomic.h>
 #include <linux/refcount.h>
+#include <linux/llist.h>
 #include <net/dst.h>
 #include <net/checksum.h>
 #include <net/tcp_states.h>
@@ -408,6 +409,8 @@ struct sock {
 		struct sk_buff	*head;
 		struct sk_buff	*tail;
 	} sk_backlog;
+	struct llist_head defer_list;
+
 #define sk_rmem_alloc sk_backlog.rmem_alloc
 
 	int			sk_forward_alloc;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 05c81677aaf782f23b8c63d6ed133df802b43064..44e442bf23f9ccc0a1a914345c3faf1fc9f99d5f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1368,6 +1368,16 @@ static inline bool tcp_checksum_complete(struct sk_buff *skb)
 }
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb);
+
+void __sk_defer_free_flush(struct sock *sk);
+
+static inline void sk_defer_free_flush(struct sock *sk)
+{
+	if (llist_empty(&sk->defer_list))
+		return;
+	__sk_defer_free_flush(sk);
+}
+
 int tcp_filter(struct sock *sk, struct sk_buff *skb);
 void tcp_set_state(struct sock *sk, int state);
 void tcp_done(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4e7011672aa9a04370b7a03b972fe19cd48ea232..33cd9a1c199cef9822ec0ddb3aec91c1111754c7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1580,14 +1580,34 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
 		tcp_send_ack(sk);
 }
 
+void __sk_defer_free_flush(struct sock *sk)
+{
+	struct llist_node *head;
+	struct sk_buff *skb, *n;
+
+	head = llist_del_all(&sk->defer_list);
+	llist_for_each_entry_safe(skb, n, head, ll_node) {
+		prefetch(n);
+		skb_mark_not_on_list(skb);
+		__kfree_skb(skb);
+	}
+}
+EXPORT_SYMBOL(__sk_defer_free_flush);
+
 static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
 {
+	__skb_unlink(skb, &sk->sk_receive_queue);
 	if (likely(skb->destructor == sock_rfree)) {
 		sock_rfree(skb);
 		skb->destructor = NULL;
 		skb->sk = NULL;
+		if (!skb_queue_empty(&sk->sk_receive_queue) ||
+		    !llist_empty(&sk->defer_list)) {
+			llist_add(&skb->ll_node, &sk->defer_list);
+			return;
+		}
 	}
-	sk_eat_skb(sk, skb);
+	__kfree_skb(skb);
 }
 
 static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
@@ -2422,6 +2442,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 			/* Do not sleep, just process backlog. */
 			__sk_flush_backlog(sk);
 		} else {
+			sk_defer_free_flush(sk);
 			sk_wait_data(sk, &timeo, last);
 		}
 
@@ -2540,6 +2561,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	ret = tcp_recvmsg_locked(sk, msg, len, nonblock, flags, &tss,
 				 &cmsg_flags);
 	release_sock(sk);
+	sk_defer_free_flush(sk);
 
 	if (cmsg_flags && ret >= 0) {
 		if (cmsg_flags & TCP_CMSG_TS)
@@ -3065,7 +3087,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 		sk->sk_frag.page = NULL;
 		sk->sk_frag.offset = 0;
 	}
-
+	sk_defer_free_flush(sk);
 	sk_error_report(sk);
 	return 0;
 }
@@ -4194,6 +4216,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
 							  &zc, &len, err);
 		release_sock(sk);
+		sk_defer_free_flush(sk);
 		if (len >= offsetofend(struct tcp_zerocopy_receive, msg_flags))
 			goto zerocopy_rcv_cmsg;
 		switch (len) {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5ad81bfb27b2f8d9a3cfe11141160b48092cfa3a..3dd19a2bf06c483b43d7e60080c624f10bb2f63d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2102,6 +2102,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	sk_incoming_cpu_update(sk);
 
+	sk_defer_free_flush(sk);
 	bh_lock_sock_nested(sk);
 	tcp_segs_in(tcp_sk(sk), skb);
 	ret = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f41f14b701233dd2d0f5ad464a623a5ba9774763..3b7d6ede13649d2589f5a456c5a132409486880f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1758,6 +1758,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 	sk_incoming_cpu_update(sk);
 
+	sk_defer_free_flush(sk);
 	bh_lock_sock_nested(sk);
 	tcp_segs_in(tcp_sk(sk), skb);
 	ret = 0;
-- 
2.34.0.rc1.387.gb447b232ab-goog

