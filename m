Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4525B11E2
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiIHBLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiIHBLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:11:11 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A96C6B70
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662599470; x=1694135470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lRflVImd4yx+YAxZmsnawKY2fsOLYex/RhvTqdB+72o=;
  b=upC9YkNFlfopWZt5QVZan6zIRlMq670C8c6kFD2o1TPQUFh93hVzwFat
   dpByKgqnmJYn3w9JzKogaod4Eje172CWDesL5663og4zf69Ev9+9rUsq4
   8/Uuox1R/5XAHqwyuq2qxKv5QKk0OruzUFJdRAmsJr4VAItg8Xgf/DjI3
   E=;
X-IronPort-AV: E=Sophos;i="5.93,298,1654560000"; 
   d="scan'208";a="127769672"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 01:10:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com (Postfix) with ESMTPS id 44E4044C08;
        Thu,  8 Sep 2022 01:10:53 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 8 Sep 2022 01:10:52 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 8 Sep 2022 01:10:50 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 net-next 1/6] tcp: Clean up some functions.
Date:   Wed, 7 Sep 2022 18:10:17 -0700
Message-ID: <20220908011022.45342-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908011022.45342-1-kuniyu@amazon.com>
References: <20220908011022.45342-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
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

This patch adds no functional change and cleans up some functions
that the following patches touch around so that we make them tidy
and easy to review/revert.  The changes are

  - Keep reverse christmas tree order
  - Remove unnecessary init of port in inet_csk_find_open_port()
  - Use req_to_sk() once in reqsk_queue_unlink()
  - Use sock_net(sk) once in tcp_time_wait() and tcp_v[46]_connect()

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/inet_connection_sock.c | 21 ++++++++++-----------
 net/ipv4/inet_hashtables.c      | 29 +++++++++++++++--------------
 net/ipv4/tcp_ipv4.c             | 18 +++++++++---------
 net/ipv4/tcp_minisocks.c        |  6 +++---
 net/ipv6/tcp_ipv6.c             | 17 ++++++++---------
 5 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f0038043b661..8e71d65cfad4 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -286,15 +286,13 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
 			struct inet_bind_hashbucket **head2_ret, int *port_ret)
 {
 	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
-	int port = 0;
+	int i, low, high, attempt_half, port, l3mdev;
 	struct inet_bind_hashbucket *head, *head2;
 	struct net *net = sock_net(sk);
-	bool relax = false;
-	int i, low, high, attempt_half;
 	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
-	int l3mdev;
+	bool relax = false;
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
 ports_exhausted:
@@ -471,15 +469,14 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 {
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
 	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
-	int ret = 1, port = snum;
-	struct net *net = sock_net(sk);
 	bool found_port = false, check_bind_conflict = true;
 	bool bhash_created = false, bhash2_created = false;
 	struct inet_bind_hashbucket *head, *head2;
 	struct inet_bind2_bucket *tb2 = NULL;
 	struct inet_bind_bucket *tb = NULL;
 	bool head2_lock_acquired = false;
-	int l3mdev;
+	int ret = 1, port = snum, l3mdev;
+	struct net *net = sock_net(sk);
 
 	l3mdev = inet_sk_bound_l3mdev(sk);
 
@@ -909,14 +906,16 @@ static void reqsk_migrate_reset(struct request_sock *req)
 /* return true if req was found in the ehash table */
 static bool reqsk_queue_unlink(struct request_sock *req)
 {
-	struct inet_hashinfo *hashinfo = req_to_sk(req)->sk_prot->h.hashinfo;
+	struct sock *sk = req_to_sk(req);
 	bool found = false;
 
-	if (sk_hashed(req_to_sk(req))) {
-		spinlock_t *lock = inet_ehash_lockp(hashinfo, req->rsk_hash);
+	if (sk_hashed(sk)) {
+		struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+		spinlock_t *lock;
 
+		lock = inet_ehash_lockp(hashinfo, req->rsk_hash);
 		spin_lock(lock);
-		found = __sk_nulls_del_node_init_rcu(req_to_sk(req));
+		found = __sk_nulls_del_node_init_rcu(sk);
 		spin_unlock(lock);
 	}
 	if (timer_pending(&req->rsk_timer) && del_timer_sync(&req->rsk_timer))
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 60d77e234a68..29dce78de179 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -169,13 +169,14 @@ void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
 static void __inet_put_port(struct sock *sk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
-	const int bhash = inet_bhashfn(sock_net(sk), inet_sk(sk)->inet_num,
-			hashinfo->bhash_size);
-	struct inet_bind_hashbucket *head = &hashinfo->bhash[bhash];
-	struct inet_bind_hashbucket *head2 =
-		inet_bhashfn_portaddr(hashinfo, sk, sock_net(sk),
-				      inet_sk(sk)->inet_num);
+	struct inet_bind_hashbucket *head, *head2;
+	struct net *net = sock_net(sk);
 	struct inet_bind_bucket *tb;
+	int bhash;
+
+	bhash = inet_bhashfn(net, inet_sk(sk)->inet_num, hashinfo->bhash_size);
+	head = &hashinfo->bhash[bhash];
+	head2 = inet_bhashfn_portaddr(hashinfo, sk, net, inet_sk(sk)->inet_num);
 
 	spin_lock(&head->lock);
 	tb = inet_csk(sk)->icsk_bind_hash;
@@ -209,17 +210,17 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
 {
 	struct inet_hashinfo *table = sk->sk_prot->h.hashinfo;
 	unsigned short port = inet_sk(child)->inet_num;
-	const int bhash = inet_bhashfn(sock_net(sk), port,
-			table->bhash_size);
-	struct inet_bind_hashbucket *head = &table->bhash[bhash];
-	struct inet_bind_hashbucket *head2 =
-		inet_bhashfn_portaddr(table, child, sock_net(sk), port);
+	struct inet_bind_hashbucket *head, *head2;
 	bool created_inet_bind_bucket = false;
-	bool update_fastreuse = false;
 	struct net *net = sock_net(sk);
+	bool update_fastreuse = false;
 	struct inet_bind2_bucket *tb2;
 	struct inet_bind_bucket *tb;
-	int l3mdev;
+	int bhash, l3mdev;
+
+	bhash = inet_bhashfn(net, port, table->bhash_size);
+	head = &table->bhash[bhash];
+	head2 = inet_bhashfn_portaddr(table, child, net, port);
 
 	spin_lock(&head->lock);
 	spin_lock(&head2->lock);
@@ -629,8 +630,8 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
 bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
-	struct hlist_nulls_head *list;
 	struct inet_ehash_bucket *head;
+	struct hlist_nulls_head *list;
 	spinlock_t *lock;
 	bool ret = true;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 01b31f5c7aba..a07243f66d4c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -201,15 +201,16 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
 	struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
 	struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
+	struct inet_timewait_death_row *tcp_death_row;
 	__be32 daddr, nexthop, prev_sk_rcv_saddr;
 	struct inet_sock *inet = inet_sk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct ip_options_rcu *inet_opt;
+	struct net *net = sock_net(sk);
 	__be16 orig_sport, orig_dport;
 	struct flowi4 *fl4;
 	struct rtable *rt;
 	int err;
-	struct ip_options_rcu *inet_opt;
-	struct inet_timewait_death_row *tcp_death_row = sock_net(sk)->ipv4.tcp_death_row;
 
 	if (addr_len < sizeof(struct sockaddr_in))
 		return -EINVAL;
@@ -235,7 +236,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		if (err == -ENETUNREACH)
-			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
 		return err;
 	}
 
@@ -250,8 +251,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (!inet->inet_saddr) {
 		if (inet_csk(sk)->icsk_bind2_hash) {
 			prev_addr_hashbucket = inet_bhashfn_portaddr(&tcp_hashinfo,
-								     sk, sock_net(sk),
-								     inet->inet_num);
+								     sk, net, inet->inet_num);
 			prev_sk_rcv_saddr = sk->sk_rcv_saddr;
 		}
 		inet->inet_saddr = fl4->saddr;
@@ -292,6 +292,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * complete initialization after this.
 	 */
 	tcp_set_state(sk, TCP_SYN_SENT);
+	tcp_death_row = net->ipv4.tcp_death_row;
 	err = inet_hash_connect(tcp_death_row, sk);
 	if (err)
 		goto failure;
@@ -317,8 +318,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 						  inet->inet_daddr,
 						  inet->inet_sport,
 						  usin->sin_port));
-		tp->tsoffset = secure_tcp_ts_off(sock_net(sk),
-						 inet->inet_saddr,
+		tp->tsoffset = secure_tcp_ts_off(net, inet->inet_saddr,
 						 inet->inet_daddr);
 	}
 
@@ -2406,9 +2406,9 @@ static void *established_get_first(struct seq_file *seq)
 
 static void *established_get_next(struct seq_file *seq, void *cur)
 {
-	struct sock *sk = cur;
-	struct hlist_nulls_node *node;
 	struct tcp_iter_state *st = seq->private;
+	struct hlist_nulls_node *node;
+	struct sock *sk = cur;
 
 	++st->num;
 	++st->offset;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cb95d88497ae..80ce27f8f77e 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -247,10 +247,10 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	const struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
 	struct inet_timewait_sock *tw;
-	struct inet_timewait_death_row *tcp_death_row = sock_net(sk)->ipv4.tcp_death_row;
 
-	tw = inet_twsk_alloc(sk, tcp_death_row, state);
+	tw = inet_twsk_alloc(sk, net->ipv4.tcp_death_row, state);
 
 	if (tw) {
 		struct tcp_timewait_sock *tcptw = tcp_twsk((struct sock *)tw);
@@ -326,7 +326,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		 * socket up.  We've got bigger problems than
 		 * non-graceful socket closings.
 		 */
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPTIMEWAITOVERFLOW);
+		NET_INC_STATS(net, LINUX_MIB_TCPTIMEWAITOVERFLOW);
 	}
 
 	tcp_update_metrics(sk);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 35013497e407..5c562d69fddf 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -146,15 +146,16 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 			  int addr_len)
 {
 	struct sockaddr_in6 *usin = (struct sockaddr_in6 *) uaddr;
-	struct inet_sock *inet = inet_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct in6_addr *saddr = NULL, *final_p, final;
 	struct inet_timewait_death_row *tcp_death_row;
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
+	struct inet_sock *inet = inet_sk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
-	struct in6_addr *saddr = NULL, *final_p, final;
+	struct net *net = sock_net(sk);
 	struct ipv6_txoptions *opt;
-	struct flowi6 fl6;
 	struct dst_entry *dst;
+	struct flowi6 fl6;
 	int addr_type;
 	int err;
 
@@ -280,7 +281,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
-	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(net, sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
@@ -292,8 +293,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 		if (icsk->icsk_bind2_hash) {
 			prev_addr_hashbucket = inet_bhashfn_portaddr(&tcp_hashinfo,
-								     sk, sock_net(sk),
-								     inet->inet_num);
+								     sk, net, inet->inet_num);
 			prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
 		}
 		saddr = &fl6.saddr;
@@ -325,7 +325,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	inet->inet_dport = usin->sin6_port;
 
 	tcp_set_state(sk, TCP_SYN_SENT);
-	tcp_death_row = sock_net(sk)->ipv4.tcp_death_row;
+	tcp_death_row = net->ipv4.tcp_death_row;
 	err = inet6_hash_connect(tcp_death_row, sk);
 	if (err)
 		goto late_failure;
@@ -339,8 +339,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 						    sk->sk_v6_daddr.s6_addr32,
 						    inet->inet_sport,
 						    inet->inet_dport));
-		tp->tsoffset = secure_tcpv6_ts_off(sock_net(sk),
-						   np->saddr.s6_addr32,
+		tp->tsoffset = secure_tcpv6_ts_off(net, np->saddr.s6_addr32,
 						   sk->sk_v6_daddr.s6_addr32);
 	}
 
-- 
2.30.2

