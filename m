Return-Path: <netdev+bounces-9137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8BA7276E3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC245281664
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9CE5394;
	Thu,  8 Jun 2023 05:48:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0BC4C87
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:48:08 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75032697;
	Wed,  7 Jun 2023 22:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686203287; x=1717739287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=THuSbm1Ax3tKqgFnzCz6Vw8JBO4PpKe06mxdxzcoRF0=;
  b=U8aVj1ho3nWSW2oNqTwM/ibR76yu4iWSTZDVg+I3CP/3M9NBsqOvxrzB
   wN2erhxxSHApU6EmJUkliHW9YdRl6MQJKMwja77YXyIQZ4OYT3+xHfoih
   Xgmy5Rf4Bn86FdtxI4EGBkjSzXsL/MKa4zeRiKVET49nW6Aduu/oGRhYC
   I=;
X-IronPort-AV: E=Sophos;i="6.00,226,1681171200"; 
   d="scan'208";a="337594415"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 05:48:04 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-47cc8a4c.us-east-1.amazon.com (Postfix) with ESMTPS id C4946160F74;
	Thu,  8 Jun 2023 05:48:00 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 8 Jun 2023 05:47:51 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.9) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 8 Jun 2023 05:47:48 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <duanmuquan@baidu.com>,
	<kuba@kernel.org>, <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
Date: Wed, 7 Jun 2023 22:47:40 -0700
Message-ID: <20230608054740.11256-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iLm=UeSLBVjACnqyaLo7oMTrY7Ok8RXP9oGDHVwe8LVng@mail.gmail.com>
References: <CANn89iLm=UeSLBVjACnqyaLo7oMTrY7Ok8RXP9oGDHVwe8LVng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.187.170.9]
X-ClientProxiedBy: EX19D038UWB002.ant.amazon.com (10.13.139.185) To
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
Date: Wed, 7 Jun 2023 15:32:57 +0200
> On Wed, Jun 7, 2023 at 1:59 PM Duan,Muquan <duanmuquan@baidu.com> wrote:
> >
> > Hi, Eric,
> >
> >  Thanks for your comments!
> >
> >  About the second lookup, I am sorry that I did not give enough explanations about it. Here are some details:
> >
> >  1.  The second lookup can find the tw sock and avoid the connection refuse error on userland applications:
> >
> > If the original sock is found, but when validating its refcnt, it has been destroyed and sk_refcnt has become 0 after decreased by tcp_time_wait()->tcp_done()->inet_csk_destory_sock()->sock_put().The validation for refcnt fails and the lookup process gets a listener sock.
> >
> > When this case occurs, the hashdance has definitely finished，because tcp_done() is executed after inet_twsk_hashdance(). Then if look up the ehash table again, hashdance has already finished, tw sock will be found.
> >
> >  With this fix, logically we can solve the connection reset issue completely when no established sock is found due to hashdance race.In my reproducing environment, the connection refuse error will occur about every 6 hours with only the fix of bad case (2). But with both of the 2 fixes, I tested it many times, the longest test continues for 10 days, it does not occur again,
> >
> >
> >
> > 2. About the performance impact:
> >
> >      A similar scenario is that __inet_lookup_established() will do inet_match() check for the second time, if fails it will look up    the list again. It is the extra effort to reduce the race impact without using reader lock. inet_match() failure occurs with about the same probability with refcnt validation failure in my test environment.
> >
> >  The second lookup will only be done in the condition that FIN segment gets a listener sock.
> >
> >   About the performance impact:
> >
> > 1)  Most of the time, this condition will not met, the added codes introduces at most 3 comparisons for each segment.
> >
> > The second inet_match() in __inet_lookup_established()  does least 3 comparisons for each segmet.
> >
> >
> > 2)  When this condition is met, the probability is very small. The impact is similar to the second try due to inet_match() failure. Since tw sock can definitely be found in the second try, I think this cost is worthy to avoid connection reused error on userland applications.
> >
> >
> >
> > My understanding is, current philosophy is avoiding the reader lock by tolerating the minor defect which occurs in a small probability.For example, if the FIN from passive closer is dropped due to the found sock is destroyed, a retransmission can be tolerated, it only makes the connection termination slower. But I think the bottom line is that it does not affect the userland applications’ functionality. If application fails to connect due to the hashdance race, it can’t be tolerated. In fact, guys from product department push hard on the connection refuse error.
> >
> >
> > About bad case (2):
> >
> >  tw sock is found, but its tw_refcnt has not been set to 3, it is still 0, validating for sk_refcnt will fail.
> >
> > I do not know the reason why setting tw_refcnt after adding it into list, could anyone help point out the reason? It adds  extra race because the new added tw sock may be found and checked in other CPU concurrently before ƒsetting tw_refcnt to 3.
> >
> > By setting tw_refcnt to 3 before adding it into list, this case will be solved, and almost no cost. In my reproducing environment, it occurs more frequently than bad case (1), it appears about every 20 minutes, bad case (1) appears about every 6 hours.
> >
> >
> >
> > About the bucket spinlock, the original established sock and tw sock are stored in the ehash table, I concern about the performance when there are lots of short TCP connections, the reader lock may affect the performance of connection creation and termination. Could you share some details of your idea? Thanks in advance.
> >
> >
> 
> Again, you can write a lot of stuff, the fact is that your patch does
> not solve the issue.
> 
> You could add 10 lookups, and still miss some cases, because they are
> all RCU lookups with no barriers.
> 
> In order to solve the issue of packets for the same 4-tuple being
> processed by many cpus, the only way to solve races is to add mutual
> exclusion.
> 
> Note that we already have to lock the bucket spinlock every time we
> transition a request socket to socket, a socket to timewait, or any
> insert/delete.
> 
> We need to expand the scope of this lock, and cleanup things that we
> added in the past, because we tried too hard to 'detect races'

How about this ?  This is still a workaround though, retry sounds
better than expanding the scope of the lock given the race is rare.

---8<---
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e7391bf310a7..b034be2f37c8 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -484,14 +484,24 @@ struct sock *__inet_lookup_established(struct net *net,
 	unsigned int hash = inet_ehashfn(net, daddr, hnum, saddr, sport);
 	unsigned int slot = hash & hashinfo->ehash_mask;
 	struct inet_ehash_bucket *head = &hashinfo->ehash[slot];
+	bool should_retry = true;
 
 begin:
 	sk_nulls_for_each_rcu(sk, node, &head->chain) {
 		if (sk->sk_hash != hash)
 			continue;
 		if (likely(inet_match(net, sk, acookie, ports, dif, sdif))) {
-			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt))) {
+				if (sk->sk_state == TCP_TIME_WAIT)
+					goto begin;
+
+				if (sk->sk_state == TCP_CLOSE && should_retry) {
+					should_retry = false;
+					goto begin;
+				}
+
 				goto out;
+			}
 			if (unlikely(!inet_match(net, sk, acookie,
 						 ports, dif, sdif))) {
 				sock_gen_put(sk);
---8<---


> 
> >
> >
> >
> > Best Regards!
> >
> > Duan
> >
> >
> > 2023年6月6日 下午3:07，Eric Dumazet <edumazet@google.com> 写道：
> >
> > On Tue, Jun 6, 2023 at 8:43 AM Duan Muquan <duanmuquan@baidu.com> wrote:
> >
> >
> > If the FIN from passive closer and the ACK for active closer's FIN are
> > processed on different CPUs concurrently, tw hashdance race may occur.
> > On loopback interface, transmit function queues a skb to current CPU's
> > softnet's input queue by default. Suppose active closer runs on CPU 0,
> > and passive closer runs on CPU 1. If the ACK for the active closer's
> > FIN is sent with no delay, it will be processed and tw hashdance will
> > be done on CPU 0; The passive closer's FIN will be sent in another
> > segment and processed on CPU 1, it may fail to find tw sock in the
> > ehash table due to tw hashdance on CPU 0, then get a RESET.
> > If application reconnects immediately with the same source port, it
> > will get reset because tw sock's tw_substate is still TCP_FIN_WAIT2.
> >
> > The dmesg to trace down this issue:
> >
> > .333516] tcp_send_fin: sk 0000000092105ad2 cookie 9 cpu 3
> > .333524] rcv_state_process:FIN_WAIT2 sk 0000000092105ad2 cookie 9 cpu 3
> > .333534] tcp_close: tcp_time_wait: sk 0000000092105ad2 cookie 9 cpu 3
> > .333538] hashdance: tw 00000000690fdb7a added to ehash cookie 9 cpu 3
> > .333541] hashdance: sk 0000000092105ad2 removed cookie 9 cpu 3
> > .333544] __inet_lookup_established: Failed the refcount check:
> >                 !refcount_inc_not_zero 00000000690fdb7a ref 0 cookie 9 cpu 0
> > .333549] hashdance: tw 00000000690fdb7a before add ref 0 cookie 9 cpu 3
> > .333552] rcv_state: RST for FIN listen 000000003c50afa6 cookie 0 cpu 0
> > .333574] tcp_send_fin: sk 0000000066757bf8 ref 2 cookie 0 cpu 0
> > .333611] timewait_state: TCP_TW_RST tw 00000000690fdb7a cookie 9 cpu 0
> > .333626] tcp_connect: sk 0000000066757bf8 cpu 0 cookie 0
> >
> > Here is the call trace map:
> >
> > CPU 0                                    CPU 1
> >
> > --------                                 --------
> > tcp_close()
> > tcp_send_fin()
> > loopback_xmit()
> > netif_rx()
> > tcp_v4_rcv()
> > tcp_ack_snd_check()
> > loopback_xmit
> > netif_rx()                              tcp_close()
> > ...                                     tcp_send_fin()
> >                                                                                loopback_xmit()
> >                                                                                netif_rx()
> >                                                                                tcp_v4_rcv()
> >                                                                                ...
> > tcp_time_wait()
> > inet_twsk_hashdance() {
> > ...
> >                                    <-__inet_lookup_established()
> >                                                                (bad case (1), find sk, may fail tw_refcnt check)
> > inet_twsk_add_node_tail_rcu(tw, ...)
> >                                    <-__inet_lookup_established()
> >                                                                (bad case (1), find sk, may fail tw_refcnt check)
> >
> > __sk_nulls_del_node_init_rcu(sk)
> >                                    <-__inet_lookup_established()
> >                                                                (bad case (2), find tw, may fail tw_refcnt check)
> > refcount_set(&tw->tw_refcnt, 3)
> >                                    <-__inet_lookup_established()
> >                                                                (good case, find tw, tw_refcnt is not 0)
> > ...
> > }
> >
> > This issue occurs with a small probability on our application working
> > on loopback interface, client gets a connection refused error when it
> > reconnects. In reproducing environments on kernel 4.14,5.10 and
> > 6.4-rc1, modify tcp_ack_snd_check() to disable delay ack all the
> > time; Let client connect server and server sends a message to client
> > then close the connection; Repeat this process forever; Let the client
> > bind the same source port every time, it can be reproduced in about 20
> > minutes.
> >
> > Brief of the scenario:
> >
> > 1. Server runs on CPU 0 and Client runs on CPU 1. Server closes
> > connection actively and sends a FIN to client. The lookback's driver
> > enqueues the FIN segment to backlog queue of CPU 0 via
> > loopback_xmit()->netif_rx(), one of the conditions for non-delay ack
> > meets in __tcp_ack_snd_check(), and the ACK is sent immediately.
> >
> > 2. On loopback interface, the ACK is received and processed on CPU 0,
> > the 'dance' from original sock to tw sock will perfrom, tw sock will
> > be inserted to ehash table, then the original sock will be removed.
> >
> > 3. On CPU 1, client closes the connection, a FIN segment is sent and
> > processed on CPU 1. When it is looking up sock in ehash table (with no
> > lock), tw hashdance race may occur, it fails to find the tw sock and
> > get a listener sock in the flowing 3 cases:
> >
> >  (1) Original sock is found, but it has been destroyed and sk_refcnt
> >          has become 0 when validating it.
> >  (2) tw sock is found, but its tw_refcnt has not been set to 3, it is
> >          still 0, validating for sk_refcnt will fail.
> >  (3) For versions without Eric and Jason's commit(3f4ca5fafc08881d7a5
> >          7daa20449d171f2887043), tw sock is added to the head of the list.
> >          It will be missed if the list is traversed before tw sock is
> >          added. And if the original sock is removed before it is found, no
> >          established sock will be found.
> >
> > The listener sock will reset the FIN segment which has ack bit set.
> >
> > 4. If client reconnects immediately and is assigned with the same
> > source port as previous connection, the tw sock with tw_substate
> > TCP_FIN_WAIT2 will reset client's SYN and destroy itself in
> > inet_twsk_deschedule_put(). Application gets a connection refused
> > error.
> >
> > 5. If client reconnects again, it will succeed.
> >
> > Introduce the flowing 2 modifications to solve the above 3 bad cases:
> >
> > For bad case (2):
> > Set tw_refcnt to 3 before adding it into list.
> >
> > For bad case (1):
> > In function tcp_v4_rcv(), if __inet_lookup_skb() returns a listener
> > sock and this segment has FIN bit set, then retry the lookup process
> > one time. This fix can cover bad case (3) for the versions without
> > Eric and Jason's fix.
> >
> > There may be another bad case, if the original sock is found and passes
> > validation, but during further process for the passive closer's FIN on
> > CPU 1, the sock has been destroyed on CPU 0, then the FIN segment will
> > be dropped and retransmitted. This case does not hurt application as
> > much as resetting reconnection, and this case has less possibility than
> > the other bad cases, it does not occur on our product and in
> > experimental environment, so it is not considered in this patch.
> >
> > Could you please check whether this fix is OK, or any suggestions?
> > Looking forward for your precious comments!
> >
> > Signed-off-by: Duan Muquan <duanmuquan@baidu.com>
> > ---
> > net/ipv4/inet_timewait_sock.c | 15 +++++++--------
> > net/ipv4/tcp_ipv4.c           | 13 +++++++++++++
> > 2 files changed, 20 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > index 40052414c7c7..ed1f255c9aa8 100644
> > --- a/net/ipv4/inet_timewait_sock.c
> > +++ b/net/ipv4/inet_timewait_sock.c
> > @@ -144,14 +144,6 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
> >
> >        spin_lock(lock);
> >
> > -       inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> > -
> > -       /* Step 3: Remove SK from hash chain */
> > -       if (__sk_nulls_del_node_init_rcu(sk))
> > -               sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> > -
> > -       spin_unlock(lock);
> > -
> >        /* tw_refcnt is set to 3 because we have :
> >         * - one reference for bhash chain.
> >         * - one reference for ehash chain.
> > @@ -162,6 +154,13 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
> >         * so we are not allowed to use tw anymore.
> >         */
> >        refcount_set(&tw->tw_refcnt, 3);
> > +       inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> > +
> > +       /* Step 3: Remove SK from hash chain */
> > +       if (__sk_nulls_del_node_init_rcu(sk))
> > +               sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> > +
> > +       spin_unlock(lock);
> > }
> > EXPORT_SYMBOL_GPL(inet_twsk_hashdance);
> >
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 06d2573685ca..3e3cef202f76 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -2018,6 +2018,19 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >        sk = __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo,
> >                               skb, __tcp_hdrlen(th), th->source,
> >                               th->dest, sdif, &refcounted);
> > +
> > +       /* If tw "dance" is performed on another CPU, the lookup process may find
> > +        * no tw sock for the passive closer's FIN segment, but a listener sock,
> > +        * which will reset the FIN segment. If application reconnects immediately
> > +        * with the same source port, it will get reset because the tw sock's
> > +        * tw_substate is still TCP_FIN_WAIT2. Try to get the tw sock in another try.
> > +        */
> > +       if (unlikely(th->fin && sk && sk->sk_state == TCP_LISTEN)) {
> > +               sk = __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo,
> > +                                      skb, __tcp_hdrlen(th), th->source,
> > +                                      th->dest, sdif, &refcounted);
> > +       }
> > +
> >
> >
> > I do not think this fixes anything, there is no barrier between first
> > and second lookup.
> > This might reduce race a little bit, but at the expense of extra code
> > in the fast path.
> >
> > If you want to fix this properly, I think we need to revisit handling
> > for non established sockets,
> > to hold the bucket spinlock over the whole thing.
> >
> > This will be slightly more complex than this...

