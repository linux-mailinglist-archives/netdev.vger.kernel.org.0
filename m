Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A435162CDAA
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiKPW3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiKPW3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:29:42 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5956455;
        Wed, 16 Nov 2022 14:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668637781; x=1700173781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sF3Q1E6l3j5/oDeI3Oze+fUmPlLA5/mvzoBTutUwJ6I=;
  b=g+q/FlvaMatpN2pxxP+olttXOpZ4gW4GzLDFXrWjjXFHHCxjFlV8VNj6
   dUQhdr7wIH7g6GzGKiNeySD2iwXQxolM6eR9xkJm75Yjy6NlWoSTMyFZW
   4L97KVQEKO7xTwZAKDWGDq+Ii9XDJ5rBYyfCJdxOW0HHTqidVWLc2n61j
   c=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 22:29:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com (Postfix) with ESMTPS id 57A48A285F;
        Wed, 16 Nov 2022 22:29:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 16 Nov 2022 22:29:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 16 Nov 2022 22:29:30 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Mat Martineau" <mathew.j.martineau@linux.intel.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>
Subject: [PATCH v2 net 3/4] dccp/tcp: Don't update saddr before unlinking sk from the old bucket
Date:   Wed, 16 Nov 2022 14:28:04 -0800
Message-ID: <20221116222805.64734-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116222805.64734-1-kuniyu@amazon.com>
References: <20221116222805.64734-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D49UWC002.ant.amazon.com (10.43.162.215) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we update saddr before calling inet_bhash2_update_saddr(), so
another thread iterating over the bhash2 bucket might see an inconsistent
address.

Let's update saddr after unlinking sk from the old bhash2 bucket.

Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/inet_hashtables.h |  2 +-
 net/dccp/ipv4.c               | 22 ++++------------------
 net/dccp/ipv6.c               | 23 ++++-------------------
 net/ipv4/af_inet.c            | 11 +----------
 net/ipv4/inet_hashtables.c    | 31 ++++++++++++++++++++++++++++---
 net/ipv4/tcp_ipv4.c           | 20 ++++----------------
 net/ipv6/tcp_ipv6.c           | 19 +++----------------
 7 files changed, 45 insertions(+), 83 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 3af1e927247d..ba06e8b52264 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -281,7 +281,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
  * sk_v6_rcv_saddr (ipv6) changes after it has been binded. The socket's
  * rcv_saddr field should already have been updated when this is called.
  */
-int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk);
+int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family);
 
 void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
 		    struct inet_bind2_bucket *tb2, unsigned short port);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 40640c26680e..95e376e3b911 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -45,11 +45,10 @@ static unsigned int dccp_v4_pernet_id __read_mostly;
 int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
 	const struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
-	struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
-	__be32 daddr, nexthop, prev_sk_rcv_saddr;
 	struct inet_sock *inet = inet_sk(sk);
 	struct dccp_sock *dp = dccp_sk(sk);
 	__be16 orig_sport, orig_dport;
+	__be32 daddr, nexthop;
 	struct flowi4 *fl4;
 	struct rtable *rt;
 	int err;
@@ -91,26 +90,13 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		daddr = fl4->daddr;
 
 	if (inet->inet_saddr == 0) {
-		if (inet_csk(sk)->icsk_bind2_hash) {
-			prev_addr_hashbucket =
-				inet_bhashfn_portaddr(&dccp_hashinfo, sk,
-						      sock_net(sk),
-						      inet->inet_num);
-			prev_sk_rcv_saddr = sk->sk_rcv_saddr;
-		}
-		inet->inet_saddr = fl4->saddr;
-	}
-
-	sk_rcv_saddr_set(sk, inet->inet_saddr);
-
-	if (prev_addr_hashbucket) {
-		err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
+		err = inet_bhash2_update_saddr(sk,  &fl4->saddr, AF_INET);
 		if (err) {
-			inet->inet_saddr = 0;
-			sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
 			ip_rt_put(rt);
 			return err;
 		}
+	} else {
+		sk_rcv_saddr_set(sk, inet->inet_saddr);
 	}
 
 	inet->inet_dport = usin->sin_port;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 626166cb6d7e..94c101ed57a9 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -934,26 +934,11 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	}
 
 	if (saddr == NULL) {
-		struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
-		struct in6_addr prev_v6_rcv_saddr;
-
-		if (icsk->icsk_bind2_hash) {
-			prev_addr_hashbucket = inet_bhashfn_portaddr(&dccp_hashinfo,
-								     sk, sock_net(sk),
-								     inet->inet_num);
-			prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
-		}
-
 		saddr = &fl6.saddr;
-		sk->sk_v6_rcv_saddr = *saddr;
-
-		if (prev_addr_hashbucket) {
-			err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
-			if (err) {
-				sk->sk_v6_rcv_saddr = prev_v6_rcv_saddr;
-				goto failure;
-			}
-		}
+
+		err = inet_bhash2_update_saddr(sk, saddr, AF_INET6);
+		if (err)
+			goto failure;
 	}
 
 	/* set the source address */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 4728087c42a5..0da679411330 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1230,7 +1230,6 @@ EXPORT_SYMBOL(inet_unregister_protosw);
 
 static int inet_sk_reselect_saddr(struct sock *sk)
 {
-	struct inet_bind_hashbucket *prev_addr_hashbucket;
 	struct inet_sock *inet = inet_sk(sk);
 	__be32 old_saddr = inet->inet_saddr;
 	__be32 daddr = inet->inet_daddr;
@@ -1260,16 +1259,8 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 		return 0;
 	}
 
-	prev_addr_hashbucket =
-		inet_bhashfn_portaddr(tcp_or_dccp_get_hashinfo(sk), sk,
-				      sock_net(sk), inet->inet_num);
-
-	inet->inet_saddr = inet->inet_rcv_saddr = new_saddr;
-
-	err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
+	err = inet_bhash2_update_saddr(sk, &new_saddr, AF_INET);
 	if (err) {
-		inet->inet_saddr = old_saddr;
-		inet->inet_rcv_saddr = old_saddr;
 		ip_rt_put(rt);
 		return err;
 	}
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index d745f962745e..dcb6bc918966 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -858,7 +858,20 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
 	return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
 }
 
-int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
+static void inet_update_saddr(struct sock *sk, void *saddr, int family)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (family == AF_INET6) {
+		sk->sk_v6_rcv_saddr = *(struct in6_addr *)saddr;
+	} else
+#endif
+	{
+		inet_sk(sk)->inet_saddr = *(__be32 *)saddr;
+		sk_rcv_saddr_set(sk, inet_sk(sk)->inet_saddr);
+	}
+}
+
+int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
 {
 	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
 	struct inet_bind2_bucket *tb2, *new_tb2;
@@ -867,6 +880,12 @@ int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct soc
 	int port = inet_sk(sk)->inet_num;
 	struct net *net = sock_net(sk);
 
+	if (!inet_csk(sk)->icsk_bind2_hash) {
+		/* Not bind()ed before. */
+		inet_update_saddr(sk, saddr, family);
+		return 0;
+	}
+
 	/* Allocate a bind2 bucket ahead of time to avoid permanently putting
 	 * the bhash2 table in an inconsistent state if a new tb2 bucket
 	 * allocation fails.
@@ -875,12 +894,18 @@ int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct soc
 	if (!new_tb2)
 		return -ENOMEM;
 
+	/* Unlink first not to show the wrong address for other threads. */
 	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
 
-	spin_lock_bh(&prev_saddr->lock);
+	spin_lock_bh(&head2->lock);
 	__sk_del_bind2_node(sk);
 	inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
-	spin_unlock_bh(&prev_saddr->lock);
+	spin_unlock_bh(&head2->lock);
+
+	inet_update_saddr(sk, saddr, family);
+
+	/* Update bhash2 bucket. */
+	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
 
 	spin_lock_bh(&head2->lock);
 	tb2 = inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6a3a732b584d..23dd7e9df2d5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -199,15 +199,14 @@ static int tcp_v4_pre_connect(struct sock *sk, struct sockaddr *uaddr,
 /* This will initiate an outgoing connection. */
 int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
-	struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
 	struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
 	struct inet_timewait_death_row *tcp_death_row;
-	__be32 daddr, nexthop, prev_sk_rcv_saddr;
 	struct inet_sock *inet = inet_sk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct ip_options_rcu *inet_opt;
 	struct net *net = sock_net(sk);
 	__be16 orig_sport, orig_dport;
+	__be32 daddr, nexthop;
 	struct flowi4 *fl4;
 	struct rtable *rt;
 	int err;
@@ -251,24 +250,13 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
 
 	if (!inet->inet_saddr) {
-		if (inet_csk(sk)->icsk_bind2_hash) {
-			prev_addr_hashbucket = inet_bhashfn_portaddr(tcp_death_row->hashinfo,
-								     sk, net, inet->inet_num);
-			prev_sk_rcv_saddr = sk->sk_rcv_saddr;
-		}
-		inet->inet_saddr = fl4->saddr;
-	}
-
-	sk_rcv_saddr_set(sk, inet->inet_saddr);
-
-	if (prev_addr_hashbucket) {
-		err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
+		err = inet_bhash2_update_saddr(sk,  &fl4->saddr, AF_INET);
 		if (err) {
-			inet->inet_saddr = 0;
-			sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
 			ip_rt_put(rt);
 			return err;
 		}
+	} else {
+		sk_rcv_saddr_set(sk, inet->inet_saddr);
 	}
 
 	if (tp->rx_opt.ts_recent_stamp && inet->inet_daddr != daddr) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 81b396e5cf79..2f3ca3190d26 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -292,24 +292,11 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
 
 	if (!saddr) {
-		struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
-		struct in6_addr prev_v6_rcv_saddr;
-
-		if (icsk->icsk_bind2_hash) {
-			prev_addr_hashbucket = inet_bhashfn_portaddr(tcp_death_row->hashinfo,
-								     sk, net, inet->inet_num);
-			prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
-		}
 		saddr = &fl6.saddr;
-		sk->sk_v6_rcv_saddr = *saddr;
 
-		if (prev_addr_hashbucket) {
-			err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
-			if (err) {
-				sk->sk_v6_rcv_saddr = prev_v6_rcv_saddr;
-				goto failure;
-			}
-		}
+		err = inet_bhash2_update_saddr(sk, saddr, AF_INET6);
+		if (err)
+			goto failure;
 	}
 
 	/* set the source address */
-- 
2.30.2

