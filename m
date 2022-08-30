Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF185A6CED
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 21:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiH3TQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiH3TQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:16:32 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14B763F1D
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 12:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661886978; x=1693422978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LrIBv4aSsT/hA/73+O0iFhh6uxrOLG1n5cPaI4EoIb0=;
  b=OF7YbprTZadCeWQwy5JWeBAkt0hd90Idwh3wKgticbI2epZ/xp9P/0M5
   /bbDZVLRVvPaXXITvbv5Qj9PIm1i4kjIFA2AkYusZPOqT2OdyisClVSXS
   jsc/kPD17b+I9gn7MlN/ZL0TdBw7vO6YNnS6bBZT/jdj5XN+ir+kInmr3
   o=;
X-IronPort-AV: E=Sophos;i="5.93,275,1654560000"; 
   d="scan'208";a="124958214"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 19:16:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com (Postfix) with ESMTPS id D4BF3A2967;
        Tue, 30 Aug 2022 19:16:14 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 30 Aug 2022 19:16:14 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 30 Aug 2022 19:16:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 2/5] tcp: Set NULL to sk->sk_prot->h.hashinfo.
Date:   Tue, 30 Aug 2022 12:15:15 -0700
Message-ID: <20220830191518.77083-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220830191518.77083-1-kuniyu@amazon.com>
References: <20220830191518.77083-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D18UWA001.ant.amazon.com (10.43.160.11) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will soon introduce an optional per-netns ehash.

This means we cannot use the global sk->sk_prot->h.hashinfo
to fetch a TCP hashinfo.

Instead, set NULL to sk->sk_prot->h.hashinfo for TCP and get
a proper hashinfo from net->ipv4.tcp_death_row->hashinfo.

Note that we need not use sk->sk_prot->h.hashinfo if DCCP is
disabled.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/inet_hashtables.h   | 10 ++++++++++
 net/ipv4/af_inet.c              |  2 +-
 net/ipv4/inet_connection_sock.c |  9 ++++-----
 net/ipv4/inet_hashtables.c      | 14 +++++++-------
 net/ipv4/tcp_ipv4.c             |  2 +-
 net/ipv6/tcp_ipv6.c             |  2 +-
 6 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 44a419b9e3d5..1ff5603cddff 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -170,6 +170,16 @@ struct inet_hashinfo {
 	struct inet_listen_hashbucket	*lhash2;
 };
 
+static inline struct inet_hashinfo *tcp_or_dccp_get_hashinfo(const struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IP_DCCP)
+	return sk->sk_prot->h.hashinfo ? :
+		sock_net(sk)->ipv4.tcp_death_row->hashinfo;
+#else
+	return sock_net(sk)->ipv4.tcp_death_row->hashinfo;
+#endif
+}
+
 static inline struct inet_listen_hashbucket *
 inet_lhash2_bucket(struct inet_hashinfo *h, u32 hash)
 {
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d3ab1ae32ef5..e2c219382345 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1250,7 +1250,7 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	}
 
 	prev_addr_hashbucket =
-		inet_bhashfn_portaddr(sk->sk_prot->h.hashinfo, sk,
+		inet_bhashfn_portaddr(tcp_or_dccp_get_hashinfo(sk), sk,
 				      sock_net(sk), inet->inet_num);
 
 	inet->inet_saddr = inet->inet_rcv_saddr = new_saddr;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 8e71d65cfad4..ebca860e113f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -285,7 +285,7 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
 			struct inet_bind2_bucket **tb2_ret,
 			struct inet_bind_hashbucket **head2_ret, int *port_ret)
 {
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
 	int i, low, high, attempt_half, port, l3mdev;
 	struct inet_bind_hashbucket *head, *head2;
 	struct net *net = sock_net(sk);
@@ -467,8 +467,8 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
  */
 int inet_csk_get_port(struct sock *sk, unsigned short snum)
 {
+	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
 	bool found_port = false, check_bind_conflict = true;
 	bool bhash_created = false, bhash2_created = false;
 	struct inet_bind_hashbucket *head, *head2;
@@ -910,10 +910,9 @@ static bool reqsk_queue_unlink(struct request_sock *req)
 	bool found = false;
 
 	if (sk_hashed(sk)) {
-		struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
-		spinlock_t *lock;
+		struct inet_hashinfo *hashinfo = tcp_or_dccp_get_hashinfo(sk);
+		spinlock_t *lock = inet_ehash_lockp(hashinfo, req->rsk_hash);
 
-		lock = inet_ehash_lockp(hashinfo, req->rsk_hash);
 		spin_lock(lock);
 		found = __sk_nulls_del_node_init_rcu(sk);
 		spin_unlock(lock);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 29dce78de179..bdb5427a7a3d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -168,7 +168,7 @@ void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
  */
 static void __inet_put_port(struct sock *sk)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hashinfo = tcp_or_dccp_get_hashinfo(sk);
 	struct inet_bind_hashbucket *head, *head2;
 	struct net *net = sock_net(sk);
 	struct inet_bind_bucket *tb;
@@ -208,7 +208,7 @@ EXPORT_SYMBOL(inet_put_port);
 
 int __inet_inherit_port(const struct sock *sk, struct sock *child)
 {
-	struct inet_hashinfo *table = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *table = tcp_or_dccp_get_hashinfo(sk);
 	unsigned short port = inet_sk(child)->inet_num;
 	struct inet_bind_hashbucket *head, *head2;
 	bool created_inet_bind_bucket = false;
@@ -629,7 +629,7 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
  */
 bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hashinfo = tcp_or_dccp_get_hashinfo(sk);
 	struct inet_ehash_bucket *head;
 	struct hlist_nulls_head *list;
 	spinlock_t *lock;
@@ -701,7 +701,7 @@ static int inet_reuseport_add_sock(struct sock *sk,
 
 int __inet_hash(struct sock *sk, struct sock *osk)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hashinfo = tcp_or_dccp_get_hashinfo(sk);
 	struct inet_listen_hashbucket *ilb2;
 	int err = 0;
 
@@ -747,7 +747,7 @@ EXPORT_SYMBOL_GPL(inet_hash);
 
 void inet_unhash(struct sock *sk)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hashinfo = tcp_or_dccp_get_hashinfo(sk);
 
 	if (sk_unhashed(sk))
 		return;
@@ -834,7 +834,7 @@ inet_bind2_bucket_find(const struct inet_bind_hashbucket *head, const struct net
 struct inet_bind_hashbucket *
 inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, int port)
 {
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
 	u32 hash;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr addr_any = {};
@@ -850,7 +850,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
 
 int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
 {
-	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
+	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
 	struct inet_bind2_bucket *tb2, *new_tb2;
 	int l3mdev = inet_sk_bound_l3mdev(sk);
 	struct inet_bind_hashbucket *head2;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 61a9bf661814..7c3b3ce85a5e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3083,7 +3083,7 @@ struct proto tcp_prot = {
 	.slab_flags		= SLAB_TYPESAFE_BY_RCU,
 	.twsk_prot		= &tcp_timewait_sock_ops,
 	.rsk_prot		= &tcp_request_sock_ops,
-	.h.hashinfo		= &tcp_hashinfo,
+	.h.hashinfo		= NULL,
 	.no_autobind		= true,
 	.diag_destroy		= tcp_abort,
 };
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index ff5c4fc135fc..791f24da9212 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2193,7 +2193,7 @@ struct proto tcpv6_prot = {
 	.slab_flags		= SLAB_TYPESAFE_BY_RCU,
 	.twsk_prot		= &tcp6_timewait_sock_ops,
 	.rsk_prot		= &tcp6_request_sock_ops,
-	.h.hashinfo		= &tcp_hashinfo,
+	.h.hashinfo		= NULL,
 	.no_autobind		= true,
 	.diag_destroy		= tcp_abort,
 };
-- 
2.30.2

