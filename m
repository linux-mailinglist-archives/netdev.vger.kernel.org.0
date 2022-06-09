Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26EA5443D8
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbiFIGeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbiFIGeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:34:22 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B7B2FFD8
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:34:21 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so19517483plg.5
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 23:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fhWyeWhT9LwHFgXSPn+7wxyv2FqOKN3ir1NGekf3NRw=;
        b=NUTnoKQ+aPiz36k+CZatMIILvI682jMO7gn9wDKmA86cHASrxzKdlhLlEqgrMYxmV2
         oEFeWrwVq9XbDetboYZ5AddXxCrRkOjdzXdpKHEgBLZNVNrJSA75zZFcuXqsEzIDLSGR
         BifB0Wd2oRjK33+I0OEaA5J8jmXEUoABTLcTJKTsSqBURVEtatEUB8xioyqL+jNf44SK
         In2RtMvxnpy+O0qURApQu1yZtJ7yfaQNFpP8nE/9m4ivAUm7RS3qDw3ZPZA5ja1bb/Al
         hzTKmzyQ1/iTpSR5fvjADLwGTQvS5UFpxPshgYKZy/SxIzf9tODWs0lRt79YBZS1ZNWH
         Y8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhWyeWhT9LwHFgXSPn+7wxyv2FqOKN3ir1NGekf3NRw=;
        b=3JeXzkCom7vF4+EK1QhepJg6hzkPiibYCOVpLvflbGpL+z6apuoFzi00r0gAhoV6W+
         2DNPB5rSlfBh5p0Fvx4NXFzWkIeKw1PT+XDOW7LaPDrdi1cvEkoI15S//4sKtFSCnWwA
         GgCTUtM66NfoSA+xcwf0c4HexP3PGZTCKcFvsHlKakopFjLfmLhZGhg79nlVPb5e4U3S
         T62TEfIZofOhgGIoHXZq8CaSAuw1l/U9qKwUjqf7kTl8k4CqF1DYlS1eDZ9U5+im8bYf
         Q0TLvt+8U2pDBjhHDlTyyUYD1OUAKlKmnNxEZyox6V3vAz8ziYQUsQ0e4dfDXSQ+j1ZG
         gLDA==
X-Gm-Message-State: AOAM531gRpS1FA0JmSQr4ekyQGed+C01BDqjEj4HxBY3JOnfuELbn8WR
        +MeTt8QL3BHvH7JCHi3tPSQ=
X-Google-Smtp-Source: ABdhPJwEi24tlEUZQnD/tmOv02ysZhDPLkftZrASzabAHxG4CTDxc/wxf2jsLAKusXDM5MqEvhWlLA==
X-Received: by 2002:a17:902:ecc9:b0:163:f779:f97a with SMTP id a9-20020a170902ecc900b00163f779f97amr37455965plh.167.1654756460417;
        Wed, 08 Jun 2022 23:34:20 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id 199-20020a6215d0000000b0051b9c0af43dsm16340050pfv.155.2022.06.08.23.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:34:20 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/7] net: remove SK_MEM_QUANTUM and SK_MEM_QUANTUM_SHIFT
Date:   Wed,  8 Jun 2022 23:34:07 -0700
Message-Id: <20220609063412.2205738-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Due to memcg interface, SK_MEM_QUANTUM is effectively PAGE_SIZE.

This might change in the future, but it seems better to avoid the
confusion.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h    |  8 +++-----
 net/core/sock.c       | 16 ++++++++--------
 net/ipv4/tcp.c        |  4 ++--
 net/ipv4/tcp_input.c  |  2 +-
 net/ipv4/tcp_output.c |  2 +-
 net/ipv4/udp.c        | 10 +++++-----
 net/mptcp/protocol.c  |  8 ++++----
 net/sctp/protocol.c   |  4 ++--
 8 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5c5265269899091a7bb8f14766085a463a476403..298897bbfb3a3ea6ba88f76bc486ae636e2b1cfd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1532,8 +1532,6 @@ int __sk_mem_schedule(struct sock *sk, int size, int kind);
 void __sk_mem_reduce_allocated(struct sock *sk, int amount);
 void __sk_mem_reclaim(struct sock *sk, int amount);
 
-#define SK_MEM_QUANTUM ((int)PAGE_SIZE)
-#define SK_MEM_QUANTUM_SHIFT ilog2(SK_MEM_QUANTUM)
 #define SK_MEM_SEND	0
 #define SK_MEM_RECV	1
 
@@ -1545,7 +1543,7 @@ static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 
 static inline int sk_mem_pages(int amt)
 {
-	return (amt + SK_MEM_QUANTUM - 1) >> SK_MEM_QUANTUM_SHIFT;
+	return (amt + PAGE_SIZE - 1) >> PAGE_SHIFT;
 }
 
 static inline bool sk_has_account(struct sock *sk)
@@ -1594,7 +1592,7 @@ static inline void sk_mem_reclaim(struct sock *sk)
 
 	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
 
-	if (reclaimable >= SK_MEM_QUANTUM)
+	if (reclaimable >= (int)PAGE_SIZE)
 		__sk_mem_reclaim(sk, reclaimable);
 }
 
@@ -1613,7 +1611,7 @@ static inline void sk_mem_reclaim_partial(struct sock *sk)
 
 	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
 
-	if (reclaimable > SK_MEM_QUANTUM)
+	if (reclaimable > (int)PAGE_SIZE)
 		__sk_mem_reclaim(sk, reclaimable - 1);
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 2ff40dd0a7a652029cca1743109286b50c2a17f3..6b786e836c7f5fc74307f050d4f32b4b554eb53b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -991,7 +991,7 @@ EXPORT_SYMBOL(sock_set_mark);
 static void sock_release_reserved_memory(struct sock *sk, int bytes)
 {
 	/* Round down bytes to multiple of pages */
-	bytes &= ~(SK_MEM_QUANTUM - 1);
+	bytes = round_down(bytes, PAGE_SIZE);
 
 	WARN_ON(bytes > sk->sk_reserved_mem);
 	sk->sk_reserved_mem -= bytes;
@@ -1028,9 +1028,9 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 		mem_cgroup_uncharge_skmem(sk->sk_memcg, pages);
 		return -ENOMEM;
 	}
-	sk->sk_forward_alloc += pages << SK_MEM_QUANTUM_SHIFT;
+	sk->sk_forward_alloc += pages << PAGE_SHIFT;
 
-	sk->sk_reserved_mem += pages << SK_MEM_QUANTUM_SHIFT;
+	sk->sk_reserved_mem += pages << PAGE_SHIFT;
 
 	return 0;
 }
@@ -3003,10 +3003,10 @@ int __sk_mem_schedule(struct sock *sk, int size, int kind)
 {
 	int ret, amt = sk_mem_pages(size);
 
-	sk->sk_forward_alloc += amt << SK_MEM_QUANTUM_SHIFT;
+	sk->sk_forward_alloc += amt << PAGE_SHIFT;
 	ret = __sk_mem_raise_allocated(sk, size, amt, kind);
 	if (!ret)
-		sk->sk_forward_alloc -= amt << SK_MEM_QUANTUM_SHIFT;
+		sk->sk_forward_alloc -= amt << PAGE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(__sk_mem_schedule);
@@ -3034,12 +3034,12 @@ EXPORT_SYMBOL(__sk_mem_reduce_allocated);
 /**
  *	__sk_mem_reclaim - reclaim sk_forward_alloc and memory_allocated
  *	@sk: socket
- *	@amount: number of bytes (rounded down to a SK_MEM_QUANTUM multiple)
+ *	@amount: number of bytes (rounded down to a PAGE_SIZE multiple)
  */
 void __sk_mem_reclaim(struct sock *sk, int amount)
 {
-	amount >>= SK_MEM_QUANTUM_SHIFT;
-	sk->sk_forward_alloc -= amount << SK_MEM_QUANTUM_SHIFT;
+	amount >>= PAGE_SHIFT;
+	sk->sk_forward_alloc -= amount << PAGE_SHIFT;
 	__sk_mem_reduce_allocated(sk, amount);
 }
 EXPORT_SYMBOL(__sk_mem_reclaim);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9984d23a7f3e1353d2e1fc9053d98c77268c577e..9e696758a4c213f22919483dcd6740b10ee3294b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4661,11 +4661,11 @@ void __init tcp_init(void)
 	max_wshare = min(4UL*1024*1024, limit);
 	max_rshare = min(6UL*1024*1024, limit);
 
-	init_net.ipv4.sysctl_tcp_wmem[0] = SK_MEM_QUANTUM;
+	init_net.ipv4.sysctl_tcp_wmem[0] = PAGE_SIZE;
 	init_net.ipv4.sysctl_tcp_wmem[1] = 16*1024;
 	init_net.ipv4.sysctl_tcp_wmem[2] = max(64*1024, max_wshare);
 
-	init_net.ipv4.sysctl_tcp_rmem[0] = SK_MEM_QUANTUM;
+	init_net.ipv4.sysctl_tcp_rmem[0] = PAGE_SIZE;
 	init_net.ipv4.sysctl_tcp_rmem[1] = 131072;
 	init_net.ipv4.sysctl_tcp_rmem[2] = max(131072, max_rshare);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2e2a9ece9af27372e6b653d685a89a2c71ba05d1..3fb117022558a408a664ea7c8fe2303296247ead 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5287,7 +5287,7 @@ static void tcp_collapse_ofo_queue(struct sock *sk)
 		    before(TCP_SKB_CB(skb)->end_seq, start)) {
 			/* Do not attempt collapsing tiny skbs */
 			if (range_truesize != head->truesize ||
-			    end - start >= SKB_WITH_OVERHEAD(SK_MEM_QUANTUM)) {
+			    end - start >= SKB_WITH_OVERHEAD(PAGE_SIZE)) {
 				tcp_collapse(sk, NULL, &tp->out_of_order_queue,
 					     head, skb, start, end);
 			} else {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1c054431e358328fe3849f5a45aaa88308a1e1c8..8ab98e1aca6797a51eaaf8886680d2001a616948 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3367,7 +3367,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	if (size <= sk->sk_forward_alloc)
 		return;
 	amt = sk_mem_pages(size);
-	sk->sk_forward_alloc += amt * SK_MEM_QUANTUM;
+	sk->sk_forward_alloc += amt << PAGE_SHIFT;
 	sk_memory_allocated_add(sk, amt);
 
 	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aa9f2ec3dc4681f767e8be9d580096ba8b439327..bbc9970fa2e947ce8fdd08763033b6b5912af042 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1461,11 +1461,11 @@ static void udp_rmem_release(struct sock *sk, int size, int partial,
 
 
 	sk->sk_forward_alloc += size;
-	amt = (sk->sk_forward_alloc - partial) & ~(SK_MEM_QUANTUM - 1);
+	amt = (sk->sk_forward_alloc - partial) & ~(PAGE_SIZE - 1);
 	sk->sk_forward_alloc -= amt;
 
 	if (amt)
-		__sk_mem_reduce_allocated(sk, amt >> SK_MEM_QUANTUM_SHIFT);
+		__sk_mem_reduce_allocated(sk, amt >> PAGE_SHIFT);
 
 	atomic_sub(size, &sk->sk_rmem_alloc);
 
@@ -1558,7 +1558,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 	spin_lock(&list->lock);
 	if (size >= sk->sk_forward_alloc) {
 		amt = sk_mem_pages(size);
-		delta = amt << SK_MEM_QUANTUM_SHIFT;
+		delta = amt << PAGE_SHIFT;
 		if (!__sk_mem_raise_allocated(sk, delta, amt, SK_MEM_RECV)) {
 			err = -ENOBUFS;
 			spin_unlock(&list->lock);
@@ -3263,8 +3263,8 @@ EXPORT_SYMBOL(udp_flow_hashrnd);
 
 static void __udp_sysctl_init(struct net *net)
 {
-	net->ipv4.sysctl_udp_rmem_min = SK_MEM_QUANTUM;
-	net->ipv4.sysctl_udp_wmem_min = SK_MEM_QUANTUM;
+	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
+	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	net->ipv4.sysctl_udp_l3mdev_accept = 0;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 17e13396024ad8807ce00a28ab1d86c23a582e32..080a630d6902caa2022fda1c6b3edb65e4e74a8c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -167,8 +167,8 @@ static bool mptcp_ooo_try_coalesce(struct mptcp_sock *msk, struct sk_buff *to,
 
 static void __mptcp_rmem_reclaim(struct sock *sk, int amount)
 {
-	amount >>= SK_MEM_QUANTUM_SHIFT;
-	mptcp_sk(sk)->rmem_fwd_alloc -= amount << SK_MEM_QUANTUM_SHIFT;
+	amount >>= PAGE_SHIFT;
+	mptcp_sk(sk)->rmem_fwd_alloc -= amount << PAGE_SHIFT;
 	__sk_mem_reduce_allocated(sk, amount);
 }
 
@@ -327,7 +327,7 @@ static bool mptcp_rmem_schedule(struct sock *sk, struct sock *ssk, int size)
 		return true;
 
 	amt = sk_mem_pages(size);
-	amount = amt << SK_MEM_QUANTUM_SHIFT;
+	amount = amt << PAGE_SHIFT;
 	msk->rmem_fwd_alloc += amount;
 	if (!__sk_mem_raise_allocated(sk, size, amt, SK_MEM_RECV)) {
 		if (ssk->sk_forward_alloc < amount) {
@@ -972,7 +972,7 @@ static void __mptcp_mem_reclaim_partial(struct sock *sk)
 
 	lockdep_assert_held_once(&sk->sk_lock.slock);
 
-	if (reclaimable > SK_MEM_QUANTUM)
+	if (reclaimable > (int)PAGE_SIZE)
 		__mptcp_rmem_reclaim(sk, reclaimable - 1);
 
 	sk_mem_reclaim_partial(sk);
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 35928fefae3327f97688f0857de63bc17e3429d6..fa500ea3a1f1bb779e264ee999ac4b7252e716ee 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1523,11 +1523,11 @@ static __init int sctp_init(void)
 	limit = (sysctl_sctp_mem[1]) << (PAGE_SHIFT - 7);
 	max_share = min(4UL*1024*1024, limit);
 
-	sysctl_sctp_rmem[0] = SK_MEM_QUANTUM; /* give each asoc 1 page min */
+	sysctl_sctp_rmem[0] = PAGE_SIZE; /* give each asoc 1 page min */
 	sysctl_sctp_rmem[1] = 1500 * SKB_TRUESIZE(1);
 	sysctl_sctp_rmem[2] = max(sysctl_sctp_rmem[1], max_share);
 
-	sysctl_sctp_wmem[0] = SK_MEM_QUANTUM;
+	sysctl_sctp_wmem[0] = PAGE_SIZE;
 	sysctl_sctp_wmem[1] = 16*1024;
 	sysctl_sctp_wmem[2] = max(64*1024, max_share);
 
-- 
2.36.1.255.ge46751e96f-goog

