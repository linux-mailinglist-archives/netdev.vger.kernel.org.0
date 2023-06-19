Return-Path: <netdev+bounces-12043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4BE735CB7
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17E5A1C20B4F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950B213AEE;
	Mon, 19 Jun 2023 17:03:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8380913AD4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 17:03:46 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4564F1;
	Mon, 19 Jun 2023 10:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1687194211; x=1718730211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qAdjcjZOKhCJYps/VsVq3P/dtdL65NDTqBgCUh7nKvQ=;
  b=FQ0BX5JUpDL14UDS2E/w6g+w4palAJyfsNzKlGIfEIM7s6gPAtVIFr3a
   k6JOV1+ecJwXpYii2zqfOoT1ZniW7HE68BiGHKyuKXyP4wf5FW6RH9DuY
   hRUb8asO/4CSoSrqfwCoR2RMq0bW5TiDcENMzKLNRReIKdsBhxU9rcowF
   4=;
X-IronPort-AV: E=Sophos;i="6.00,255,1681171200"; 
   d="scan'208";a="341928229"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 17:03:28 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 99DFC40D65;
	Mon, 19 Jun 2023 17:03:26 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 19 Jun 2023 17:03:26 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.47) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 19 Jun 2023 17:03:23 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>, <duanmuquan@baidu.com>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
	<kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
Date: Mon, 19 Jun 2023 10:03:14 -0700
Message-ID: <20230619170314.42333-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iK8snOz8TYOhhwfimC7ykYA78GA3Nyv8x06SZYa1nKdyA@mail.gmail.com>
References: <CANn89iK8snOz8TYOhhwfimC7ykYA78GA3Nyv8x06SZYa1nKdyA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.100.47]
X-ClientProxiedBy: EX19D046UWA001.ant.amazon.com (10.13.139.112) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 8 Jun 2023 08:35:20 +0200
> On Thu, Jun 8, 2023 at 7:48 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> > Date: Wed, 7 Jun 2023 15:32:57 +0200
> > > On Wed, Jun 7, 2023 at 1:59 PM Duan,Muquan <duanmuquan@baidu.com> wrote:
> > > >
> > > > Hi, Eric,
> > > >
> > > >  Thanks for your comments!
> > > >
> > > >  About the second lookup, I am sorry that I did not give enough explanations about it. Here are some details:
> > > >
> > > >  1.  The second lookup can find the tw sock and avoid the connection refuse error on userland applications:
> > > >
> > > > If the original sock is found, but when validating its refcnt, it has been destroyed and sk_refcnt has become 0 after decreased by tcp_time_wait()->tcp_done()->inet_csk_destory_sock()->sock_put().The validation for refcnt fails and the lookup process gets a listener sock.
> > > >
> > > > When this case occurs, the hashdance has definitely finished，because tcp_done() is executed after inet_twsk_hashdance(). Then if look up the ehash table again, hashdance has already finished, tw sock will be found.
> > > >
> > > >  With this fix, logically we can solve the connection reset issue completely when no established sock is found due to hashdance race.In my reproducing environment, the connection refuse error will occur about every 6 hours with only the fix of bad case (2). But with both of the 2 fixes, I tested it many times, the longest test continues for 10 days, it does not occur again,
> > > >
> > > >
> > > >
> > > > 2. About the performance impact:
> > > >
> > > >      A similar scenario is that __inet_lookup_established() will do inet_match() check for the second time, if fails it will look up    the list again. It is the extra effort to reduce the race impact without using reader lock. inet_match() failure occurs with about the same probability with refcnt validation failure in my test environment.
> > > >
> > > >  The second lookup will only be done in the condition that FIN segment gets a listener sock.
> > > >
> > > >   About the performance impact:
> > > >
> > > > 1)  Most of the time, this condition will not met, the added codes introduces at most 3 comparisons for each segment.
> > > >
> > > > The second inet_match() in __inet_lookup_established()  does least 3 comparisons for each segmet.
> > > >
> > > >
> > > > 2)  When this condition is met, the probability is very small. The impact is similar to the second try due to inet_match() failure. Since tw sock can definitely be found in the second try, I think this cost is worthy to avoid connection reused error on userland applications.
> > > >
> > > >
> > > >
> > > > My understanding is, current philosophy is avoiding the reader lock by tolerating the minor defect which occurs in a small probability.For example, if the FIN from passive closer is dropped due to the found sock is destroyed, a retransmission can be tolerated, it only makes the connection termination slower. But I think the bottom line is that it does not affect the userland applications’ functionality. If application fails to connect due to the hashdance race, it can’t be tolerated. In fact, guys from product department push hard on the connection refuse error.
> > > >
> > > >
> > > > About bad case (2):
> > > >
> > > >  tw sock is found, but its tw_refcnt has not been set to 3, it is still 0, validating for sk_refcnt will fail.
> > > >
> > > > I do not know the reason why setting tw_refcnt after adding it into list, could anyone help point out the reason? It adds  extra race because the new added tw sock may be found and checked in other CPU concurrently before ƒsetting tw_refcnt to 3.
> > > >
> > > > By setting tw_refcnt to 3 before adding it into list, this case will be solved, and almost no cost. In my reproducing environment, it occurs more frequently than bad case (1), it appears about every 20 minutes, bad case (1) appears about every 6 hours.
> > > >
> > > >
> > > >
> > > > About the bucket spinlock, the original established sock and tw sock are stored in the ehash table, I concern about the performance when there are lots of short TCP connections, the reader lock may affect the performance of connection creation and termination. Could you share some details of your idea? Thanks in advance.
> > > >
> > > >
> > >
> > > Again, you can write a lot of stuff, the fact is that your patch does
> > > not solve the issue.
> > >
> > > You could add 10 lookups, and still miss some cases, because they are
> > > all RCU lookups with no barriers.
> > >
> > > In order to solve the issue of packets for the same 4-tuple being
> > > processed by many cpus, the only way to solve races is to add mutual
> > > exclusion.
> > >
> > > Note that we already have to lock the bucket spinlock every time we
> > > transition a request socket to socket, a socket to timewait, or any
> > > insert/delete.
> > >
> > > We need to expand the scope of this lock, and cleanup things that we
> > > added in the past, because we tried too hard to 'detect races'
> >
> > How about this ?  This is still a workaround though, retry sounds
> > better than expanding the scope of the lock given the race is rare.
> 
> The chance of two cpus having to hold the same spinlock is rather small.
> 
> Algo is the following:
> 
> Attempt a lockless/RCU lookup.
> 
> 1) Socket is found, we are good to go. Fast path is still fast.
> 
> 2) Socket  is not found in ehash
>    - We lock the bucket spinlock.
>    - We retry the lookup
>    - If socket found, continue with it (release the spinlock when
> appropriate, after all write manipulations in the bucket are done)
>    - If socket still not found, we lookup a listener.
>       We insert a TCP_NEW_SYN_RECV ....
>        Again, we release the spinlock when appropriate, after all
> write manipulations in the bucket are done)
> 
> No more races, and the fast path is the same.

I was looking around the issue this weekend.  Is this what you were
thinking ?  I'm wondering if you were also thinking another races like
found_dup_sk/own_req things. e.g.) acquire ehash lock when we start to
process reqsk ?

Duan, could you test the diff below ?

If this resolves the FIN issue, we can also revert 3f4ca5fafc08 ("tcp:
avoid the lookup process failing to get sk in ehash table").

---8<---
diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 56f1286583d3..bb8e49a6e80f 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -48,6 +48,11 @@ struct sock *__inet6_lookup_established(struct net *net,
 					const u16 hnum, const int dif,
 					const int sdif);
 
+struct sock *__inet6_lookup_established_lock(struct net *net, struct inet_hashinfo *hashinfo,
+					     const struct in6_addr *saddr, const __be16 sport,
+					     const struct in6_addr *daddr, const u16 hnum,
+					     const int dif, const int sdif);
+
 struct sock *inet6_lookup_listener(struct net *net,
 				   struct inet_hashinfo *hashinfo,
 				   struct sk_buff *skb, int doff,
@@ -70,9 +75,15 @@ static inline struct sock *__inet6_lookup(struct net *net,
 	struct sock *sk = __inet6_lookup_established(net, hashinfo, saddr,
 						     sport, daddr, hnum,
 						     dif, sdif);
-	*refcounted = true;
-	if (sk)
+
+	if (!sk)
+		sk = __inet6_lookup_established_lock(net, hashinfo, saddr, sport,
+						     daddr, hnum, dif, sdif);
+	if (sk) {
+		*refcounted = true;
 		return sk;
+	}
+
 	*refcounted = false;
 	return inet6_lookup_listener(net, hashinfo, skb, doff, saddr, sport,
 				     daddr, hnum, dif, sdif);
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 99bd823e97f6..ad97fec63d7a 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -379,6 +379,12 @@ struct sock *__inet_lookup_established(struct net *net,
 				       const __be32 daddr, const u16 hnum,
 				       const int dif, const int sdif);
 
+struct sock *__inet_lookup_established_lock(struct net *net,
+					    struct inet_hashinfo *hashinfo,
+					    const __be32 saddr, const __be16 sport,
+					    const __be32 daddr, const u16 hnum,
+					    const int dif, const int sdif);
+
 static inline struct sock *
 	inet_lookup_established(struct net *net, struct inet_hashinfo *hashinfo,
 				const __be32 saddr, const __be16 sport,
@@ -402,9 +408,14 @@ static inline struct sock *__inet_lookup(struct net *net,
 
 	sk = __inet_lookup_established(net, hashinfo, saddr, sport,
 				       daddr, hnum, dif, sdif);
-	*refcounted = true;
-	if (sk)
+	if (!sk)
+		sk = __inet_lookup_established_lock(net, hashinfo, saddr, sport,
+						    daddr, hnum, dif, sdif);
+	if (sk) {
+		*refcounted = true;
 		return sk;
+	}
+
 	*refcounted = false;
 	return __inet_lookup_listener(net, hashinfo, skb, doff, saddr,
 				      sport, daddr, hnum, dif, sdif);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e7391bf310a7..1eeadaf1c9f9 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -514,6 +514,41 @@ struct sock *__inet_lookup_established(struct net *net,
 }
 EXPORT_SYMBOL_GPL(__inet_lookup_established);
 
+struct sock *__inet_lookup_established_lock(struct net *net, struct inet_hashinfo *hashinfo,
+					    const __be32 saddr, const __be16 sport,
+					    const __be32 daddr, const u16 hnum,
+					    const int dif, const int sdif)
+{
+	const __portpair ports = INET_COMBINED_PORTS(sport, hnum);
+	INET_ADDR_COOKIE(acookie, saddr, daddr);
+	const struct hlist_nulls_node *node;
+	struct inet_ehash_bucket *head;
+	unsigned int hash;
+	spinlock_t *lock;
+	struct sock *sk;
+
+	hash = inet_ehashfn(net, daddr, hnum, saddr, sport);
+	head = inet_ehash_bucket(hashinfo, hash);
+	lock = inet_ehash_lockp(hashinfo, hash);
+
+	spin_lock(lock);
+	sk_nulls_for_each(sk, node, &head->chain) {
+		if (sk->sk_hash != hash)
+			continue;
+
+		if (unlikely(!inet_match(net, sk, acookie, ports, dif, sdif)))
+			continue;
+
+		sock_hold(sk);
+		spin_unlock(lock);
+		return sk;
+	}
+	spin_unlock(lock);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(__inet_lookup_established_lock);
+
 /* called with local bh disabled */
 static int __inet_check_established(struct inet_timewait_death_row *death_row,
 				    struct sock *sk, __u16 lport,
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index b64b49012655..1b2c971859c0 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -89,6 +89,40 @@ struct sock *__inet6_lookup_established(struct net *net,
 }
 EXPORT_SYMBOL(__inet6_lookup_established);
 
+struct sock *__inet6_lookup_established_lock(struct net *net, struct inet_hashinfo *hashinfo,
+					     const struct in6_addr *saddr, const __be16 sport,
+					     const struct in6_addr *daddr, const u16 hnum,
+					     const int dif, const int sdif)
+{
+	const __portpair ports = INET_COMBINED_PORTS(sport, hnum);
+	const struct hlist_nulls_node *node;
+	struct inet_ehash_bucket *head;
+	unsigned int hash;
+	spinlock_t *lock;
+	struct sock *sk;
+
+	hash = inet6_ehashfn(net, daddr, hnum, saddr, sport);
+	head = inet_ehash_bucket(hashinfo, hash);
+	lock = inet_ehash_lockp(hashinfo, hash);
+
+	spin_lock(lock);
+	sk_nulls_for_each(sk, node, &head->chain) {
+		if (sk->sk_hash != hash)
+			continue;
+
+		if (unlikely(!inet6_match(net, sk, saddr, daddr, ports, dif, sdif)))
+			continue;
+
+		sock_hold(sk);
+		spin_unlock(lock);
+		return sk;
+	}
+	spin_unlock(lock);
+
+	return NULL;
+}
+EXPORT_SYMBOL(__inet6_lookup_established_lock);
+
 static inline int compute_score(struct sock *sk, struct net *net,
 				const unsigned short hnum,
 				const struct in6_addr *daddr,
---8<---

