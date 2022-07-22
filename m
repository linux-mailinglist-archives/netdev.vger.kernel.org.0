Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E115857E66B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbiGVSX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGVSX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:23:26 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F87E691D1
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658514205; x=1690050205;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NIvth5uMmjqBoczvKAEc1NDkZBYu5Z0QkxkIcvikevY=;
  b=WaFo4xutrd04vO2hVMcUvk9tbdbGODk09esMfug70eNA2nItaXMAP64E
   Bkx8il8YnP3J4h9oXs5eeaCtnxbhmQhMyi6D+NquE+T2gMgEZBOtDYATP
   0/aA5h8YATUhCDQztqIC4xmCRn05R1NXGew4+y8Xw/64oDpMeXcqwyCXb
   U=;
X-IronPort-AV: E=Sophos;i="5.93,186,1654560000"; 
   d="scan'208";a="111515959"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 22 Jul 2022 18:23:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id 8FC5D14209D;
        Fri, 22 Jul 2022 18:23:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 22 Jul 2022 18:23:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 22 Jul 2022 18:23:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 2/7] net: Fix data-races around sysctl_[rw]mem(_offset)?.
Date:   Fri, 22 Jul 2022 11:22:00 -0700
Message-ID: <20220722182205.96838-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220722182205.96838-1-kuniyu@amazon.com>
References: <20220722182205.96838-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading these sysctl variables, they can be changed concurrently.
Thus, we need to add READ_ONCE() to their readers.

  - .sysctl_rmem
  - .sysctl_rwmem
  - .sysctl_rmem_offset
  - .sysctl_wmem_offset
  - sysctl_tcp_rmem[1, 2]
  - sysctl_tcp_wmem[1, 2]
  - sysctl_decnet_rmem[1]
  - sysctl_decnet_wmem[1]
  - sysctl_tipc_rmem[1]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/sock.h     |  8 ++++----
 net/decnet/af_decnet.c |  4 ++--
 net/ipv4/tcp.c         |  6 +++---
 net/ipv4/tcp_input.c   | 13 +++++++------
 net/ipv4/tcp_output.c  |  2 +-
 net/mptcp/protocol.c   |  6 +++---
 net/tipc/socket.c      |  2 +-
 7 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9fa54762e077..7a48991cdb19 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2843,18 +2843,18 @@ static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_wmem ? */
 	if (proto->sysctl_wmem_offset)
-		return *(int *)((void *)sock_net(sk) + proto->sysctl_wmem_offset);
+		return READ_ONCE(*(int *)((void *)sock_net(sk) + proto->sysctl_wmem_offset));
 
-	return *proto->sysctl_wmem;
+	return READ_ONCE(*proto->sysctl_wmem);
 }
 
 static inline int sk_get_rmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_rmem ? */
 	if (proto->sysctl_rmem_offset)
-		return *(int *)((void *)sock_net(sk) + proto->sysctl_rmem_offset);
+		return READ_ONCE(*(int *)((void *)sock_net(sk) + proto->sysctl_rmem_offset));
 
-	return *proto->sysctl_rmem;
+	return READ_ONCE(*proto->sysctl_rmem);
 }
 
 /* Default TCP Small queue budget is ~1 ms of data (1sec >> 10)
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index dc92a67baea3..7d542eb46172 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -480,8 +480,8 @@ static struct sock *dn_alloc_sock(struct net *net, struct socket *sock, gfp_t gf
 	sk->sk_family      = PF_DECnet;
 	sk->sk_protocol    = 0;
 	sk->sk_allocation  = gfp;
-	sk->sk_sndbuf	   = sysctl_decnet_wmem[1];
-	sk->sk_rcvbuf	   = sysctl_decnet_rmem[1];
+	sk->sk_sndbuf	   = READ_ONCE(sysctl_decnet_wmem[1]);
+	sk->sk_rcvbuf	   = READ_ONCE(sysctl_decnet_rmem[1]);
 
 	/* Initialization of DECnet Session Control Port		*/
 	scp = DN_SK(sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a11e5de3a4c3..002a4a04efbe 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -452,8 +452,8 @@ void tcp_init_sock(struct sock *sk)
 
 	icsk->icsk_sync_mss = tcp_sync_mss;
 
-	WRITE_ONCE(sk->sk_sndbuf, sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
-	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
+	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
 
 	sk_sockets_allocated_inc(sk);
 }
@@ -1724,7 +1724,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
 		cap = sk->sk_rcvbuf >> 1;
 	else
-		cap = sock_net(sk)->ipv4.sysctl_tcp_rmem[2] >> 1;
+		cap = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
 	val = min(val, cap);
 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dd05238f79f6..ff2e0d87aee4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -426,7 +426,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 
 	if (sk->sk_sndbuf < sndmem)
 		WRITE_ONCE(sk->sk_sndbuf,
-			   min(sndmem, sock_net(sk)->ipv4.sysctl_tcp_wmem[2]));
+			   min(sndmem, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[2])));
 }
 
 /* 2. Tuning advertised window (window_clamp, rcv_ssthresh)
@@ -461,7 +461,7 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
 	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
-	int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
+	int window = tcp_win_from_space(sk, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2])) >> 1;
 
 	while (tp->rcv_ssthresh <= window) {
 		if (truesize <= skb->len)
@@ -574,16 +574,17 @@ static void tcp_clamp_window(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
+	int rmem2;
 
 	icsk->icsk_ack.quick = 0;
+	rmem2 = READ_ONCE(net->ipv4.sysctl_tcp_rmem[2]);
 
-	if (sk->sk_rcvbuf < net->ipv4.sysctl_tcp_rmem[2] &&
+	if (sk->sk_rcvbuf < rmem2 &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK) &&
 	    !tcp_under_memory_pressure(sk) &&
 	    sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)) {
 		WRITE_ONCE(sk->sk_rcvbuf,
-			   min(atomic_read(&sk->sk_rmem_alloc),
-			       net->ipv4.sysctl_tcp_rmem[2]));
+			   min(atomic_read(&sk->sk_rmem_alloc), rmem2));
 	}
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
 		tp->rcv_ssthresh = min(tp->window_clamp, 2U * tp->advmss);
@@ -745,7 +746,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 		do_div(rcvwin, tp->advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		if (rcvbuf > sk->sk_rcvbuf) {
 			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cf6713c9567e..80ffbd402918 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -241,7 +241,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	*rcv_wscale = 0;
 	if (wscale_ok) {
 		/* Set window scaling on max possible window */
-		space = max_t(u32, space, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+		space = max_t(u32, space, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		space = max_t(u32, space, sysctl_rmem_max);
 		space = min_t(u32, space, *window_clamp);
 		*rcv_wscale = clamp_t(int, ilog2(space) - 15,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9bbd8cbe0acb..7e1518bb6115 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1926,7 +1926,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 
 		do_div(rcvwin, advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 
 		if (rcvbuf > sk->sk_rcvbuf) {
 			u32 window_clamp;
@@ -2669,8 +2669,8 @@ static int mptcp_init_sock(struct sock *sk)
 	mptcp_ca_reset(sk);
 
 	sk_sockets_allocated_inc(sk);
-	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
-	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	sk->sk_sndbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
 
 	return 0;
 }
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 43509c7e90fc..f1c3b8eb4b3d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -517,7 +517,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	timer_setup(&sk->sk_timer, tipc_sk_timeout, 0);
 	sk->sk_shutdown = 0;
 	sk->sk_backlog_rcv = tipc_sk_backlog_rcv;
-	sk->sk_rcvbuf = sysctl_tipc_rmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sysctl_tipc_rmem[1]);
 	sk->sk_data_ready = tipc_data_ready;
 	sk->sk_write_space = tipc_write_space;
 	sk->sk_destruct = tipc_sock_destruct;
-- 
2.30.2

