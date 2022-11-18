Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96F62FE7B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 20:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiKRT6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 14:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKRT6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 14:58:38 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24219167C2;
        Fri, 18 Nov 2022 11:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668801516; x=1700337516;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9LGGa1TZPcUqXKsPM/xFpGA9nDTS3OR1XZ6pot1N/6E=;
  b=ZVtiLrWkEvl2/pOhmfxpNfpMO5iHwpXLvLnvNQMTiIGD/ErZUEEhOkas
   SR15aw1have4wSVFSirWifyl+SQV0AT8oD1qFsRyjXhGXlNp0HtiUFfS8
   e8UhaRA46HuCvWRUHgLI16nENjn+etKnSCkxEepVnRkVkTcSMgBLz5fMz
   I=;
X-IronPort-AV: E=Sophos;i="5.96,175,1665446400"; 
   d="scan'208";a="268375497"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 19:58:33 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id C630B341E77;
        Fri, 18 Nov 2022 19:58:28 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 18 Nov 2022 19:58:27 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 18 Nov 2022 19:58:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <joannelkoong@gmail.com>
CC:     <acme@mandriva.com>, <davem@davemloft.net>, <dccp@vger.kernel.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>, <martin.lau@kernel.org>,
        <mathew.j.martineau@linux.intel.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <pengfei.xu@intel.com>,
        <stephen@networkplumber.org>, <william.xuanziyang@huawei.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 net 3/4] dccp/tcp: Don't update saddr before unlinking sk from the old bucket
Date:   Fri, 18 Nov 2022 11:58:16 -0800
Message-ID: <20221118195816.11413-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAJnrk1anz-tFrGV-ZB_75nucXJE=tAf2JGLf3Ud_iLn_Gt+HqA@mail.gmail.com>
References: <CAJnrk1anz-tFrGV-ZB_75nucXJE=tAf2JGLf3Ud_iLn_Gt+HqA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D41UWB003.ant.amazon.com (10.43.161.243) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 18 Nov 2022 11:02:10 -0800
> On Thu, Nov 17, 2022 at 5:08 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Joanne Koong <joannelkoong@gmail.com>
> > Date:   Thu, 17 Nov 2022 16:55:59 -0800
> > > On Thu, Nov 17, 2022 at 4:06 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > From:   Joanne Koong <joannelkoong@gmail.com>
> > > > Date:   Thu, 17 Nov 2022 13:32:18 -0800
> > > > > On Wed, Nov 16, 2022 at 2:29 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > > >
> > > > > > Currently, we update saddr before calling inet_bhash2_update_saddr(), so
> > > > > > another thread iterating over the bhash2 bucket might see an inconsistent
> > > >
> > > > Sorry this should be just bhash       ^^^ here.
> > > >
> > > > > > address.
> > > > > >
> > > > > > Let's update saddr after unlinking sk from the old bhash2 bucket.
> > > > >
> > > > > I'm not sure whether this patch is necessary and I'm curious to hear
> > > > > your thoughts. There's no adverse effect that comes from updating the
> > > > > sk's saddr before calling inet_bhash2_update_saddr() in the current
> > > > > code. Another thread can be iterating over the bhash2 bucket, but it
> > > > > has no effect whether they see this new address or not (eg when they
> > > > > are iterating through the bucket they are trying to check for bind
> > > > > conflicts on another socket, and the sk having the new address doesn't
> > > > > affect this). What are your thoughts?
> > > >
> > > > You are right, it seems I was confused.
> > > >
> > > > I was thinking that lockless change of saddr could result in data race;
> > > > another process iterating over bhash might see a corrupted address.
> > > >
> > > > So, we need to acquire the bhash lock before updating saddr, and then
> > > > related code should be in inet_bhash2_update_saddr().
> > > >
> > > > But I seem to have forgot to add the lock part... :p
> > >
> > > No worries! :) Is acquiring the bhash lock necessary before updating
> > > saddr? I think the worst case scenario (which would only happen very
> > > rarely) is that there is another process iterating over bhash, that
> > > process tries to access the address the exact time the address is
> > > being updated in this function, causing the other process to see the
> > > corrupted address, that corrupted address matches that other process's
> > > socket address, thus causing that other process to reject the bind
> > > request.
> > >
> > > It doesn't seem like that is a big deal, in the rare event where that
> > > would happen. In my opinion, it's not worth solving for by making the
> > > common case slower by grabbing the bhash lock.
> > >
> > > What are your thoughts?
> >
> > In that sense, inet_bhash2_update_saddr() is not the common case, I think.
> >
> > For the IPv4 case, we need not acquire the lock.  Adding READ_ONCE()
> > and WRITE_ONCE() would be enough, but we cannot do so for IPv6 addr.
> >
> > Also, I think netdev code often fixes such data races reported by
> > KCSAN.
> 
> I'll leave the final decision on this up to you :)

Thank you.

I understand what you are saying, but I still think this is needed.
But the final decision will be made by maintainers, so let's see what
they do :)

This series is now marked as Changes Requested in patchwork, so I'll
respin v3 with the bhash lock.


> My line of reasoning is that:
> 
> 1) This case will be run into *very* rarely - a lot of things would
> need to align, not only that the read and write occur at the same
> time, but that the address gets corrupted to the exact address of the
> other socket
> 
> 2) There's no pernicious effect from this scenario; the worst thing
> that happens is that the other socket's bind request fails and it'll
> need to retry

I think this is the same issue with the one syzbot reported in that
inconsistency exists in bhash and bhash2.  The difference is just the
span.  It is not a problem just because WARN_ON() fired, WARN_ON() only
caught the issue and WARN_ON() itself is not a problem.


> 3) Grabbing the bhash lock opens the door to unpleasant cases that
> would happen a lot more commonly than this one. In particular, the
> case I'm thinking of is where another socket is binding to the same
> port and can't use bhash2 (eg they're binding on INADDR_ANY or
> IPV6_ADDR_MAPPED); this socket will grab the bhash lock, go through
> every socket binded to this port to check for a bind conflict (can
> take a very long time if there are many sockets), while that is
> happening this connect call will be blocked waiting for the bhash lock
> to be released.

I think bind(INADDR_ANY) + connect() is not a common case and does not
affect common cases frequently.  And if it affects the common case, it
is what it is.  Even if it slows down the common case, it is not a good
reason we can leave a bug in the uncommon path.  It means we need another
improvements/optmisation.  Fast code which slows down by fixing bugs is
not fast code.

Thank you again for discussion!


> > > > > > Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > ---
> > > > > >  include/net/inet_hashtables.h |  2 +-
> > > > > >  net/dccp/ipv4.c               | 22 ++++------------------
> > > > > >  net/dccp/ipv6.c               | 23 ++++-------------------
> > > > > >  net/ipv4/af_inet.c            | 11 +----------
> > > > > >  net/ipv4/inet_hashtables.c    | 31 ++++++++++++++++++++++++++++---
> > > > > >  net/ipv4/tcp_ipv4.c           | 20 ++++----------------
> > > > > >  net/ipv6/tcp_ipv6.c           | 19 +++----------------
> > > > > >  7 files changed, 45 insertions(+), 83 deletions(-)
> > > > > >
> > > > > > diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> > > > > > index 3af1e927247d..ba06e8b52264 100644
> > > > > > --- a/include/net/inet_hashtables.h
> > > > > > +++ b/include/net/inet_hashtables.h
> > > > > > @@ -281,7 +281,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
> > > > > >   * sk_v6_rcv_saddr (ipv6) changes after it has been binded. The socket's
> > > > > >   * rcv_saddr field should already have been updated when this is called.
> > > > > >   */
> > > > > > -int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk);
> > > > > > +int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family);
> > > > > >
> > > > > >  void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
> > > > > >                     struct inet_bind2_bucket *tb2, unsigned short port);
> > > > > > diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> > > > > > index 40640c26680e..95e376e3b911 100644
> > > > > > --- a/net/dccp/ipv4.c
> > > > > > +++ b/net/dccp/ipv4.c
> > > > > > @@ -45,11 +45,10 @@ static unsigned int dccp_v4_pernet_id __read_mostly;
> > > > > >  int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > > > > >  {
> > > > > >         const struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
> > > > > > -       struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> > > > > > -       __be32 daddr, nexthop, prev_sk_rcv_saddr;
> > > > > >         struct inet_sock *inet = inet_sk(sk);
> > > > > >         struct dccp_sock *dp = dccp_sk(sk);
> > > > > >         __be16 orig_sport, orig_dport;
> > > > > > +       __be32 daddr, nexthop;
> > > > > >         struct flowi4 *fl4;
> > > > > >         struct rtable *rt;
> > > > > >         int err;
> > > > > > @@ -91,26 +90,13 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > > > > >                 daddr = fl4->daddr;
> > > > > >
> > > > > >         if (inet->inet_saddr == 0) {
> > > > > > -               if (inet_csk(sk)->icsk_bind2_hash) {
> > > > > > -                       prev_addr_hashbucket =
> > > > > > -                               inet_bhashfn_portaddr(&dccp_hashinfo, sk,
> > > > > > -                                                     sock_net(sk),
> > > > > > -                                                     inet->inet_num);
> > > > > > -                       prev_sk_rcv_saddr = sk->sk_rcv_saddr;
> > > > > > -               }
> > > > > > -               inet->inet_saddr = fl4->saddr;
> > > > > > -       }
> > > > > > -
> > > > > > -       sk_rcv_saddr_set(sk, inet->inet_saddr);
> > > > > > -
> > > > > > -       if (prev_addr_hashbucket) {
> > > > > > -               err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > > > > +               err = inet_bhash2_update_saddr(sk,  &fl4->saddr, AF_INET);
> > > > > >                 if (err) {
> > > > > > -                       inet->inet_saddr = 0;
> > > > > > -                       sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
> > > > > >                         ip_rt_put(rt);
> > > > > >                         return err;
> > > > > >                 }
> > > > > > +       } else {
> > > > > > +               sk_rcv_saddr_set(sk, inet->inet_saddr);
> > > > > >         }
> > > > > >
> > > > > >         inet->inet_dport = usin->sin_port;
> > > > > > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > > > > > index 626166cb6d7e..94c101ed57a9 100644
> > > > > > --- a/net/dccp/ipv6.c
> > > > > > +++ b/net/dccp/ipv6.c
> > > > > > @@ -934,26 +934,11 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > > > > >         }
> > > > > >
> > > > > >         if (saddr == NULL) {
> > > > > > -               struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> > > > > > -               struct in6_addr prev_v6_rcv_saddr;
> > > > > > -
> > > > > > -               if (icsk->icsk_bind2_hash) {
> > > > > > -                       prev_addr_hashbucket = inet_bhashfn_portaddr(&dccp_hashinfo,
> > > > > > -                                                                    sk, sock_net(sk),
> > > > > > -                                                                    inet->inet_num);
> > > > > > -                       prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
> > > > > > -               }
> > > > > > -
> > > > > >                 saddr = &fl6.saddr;
> > > > > > -               sk->sk_v6_rcv_saddr = *saddr;
> > > > > > -
> > > > > > -               if (prev_addr_hashbucket) {
> > > > > > -                       err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > > > > -                       if (err) {
> > > > > > -                               sk->sk_v6_rcv_saddr = prev_v6_rcv_saddr;
> > > > > > -                               goto failure;
> > > > > > -                       }
> > > > > > -               }
> > > > > > +
> > > > > > +               err = inet_bhash2_update_saddr(sk, saddr, AF_INET6);
> > > > > > +               if (err)
> > > > > > +                       goto failure;
> > > > > >         }
> > > > > >
> > > > > >         /* set the source address */
> > > > > > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > > > > > index 4728087c42a5..0da679411330 100644
> > > > > > --- a/net/ipv4/af_inet.c
> > > > > > +++ b/net/ipv4/af_inet.c
> > > > > > @@ -1230,7 +1230,6 @@ EXPORT_SYMBOL(inet_unregister_protosw);
> > > > > >
> > > > > >  static int inet_sk_reselect_saddr(struct sock *sk)
> > > > > >  {
> > > > > > -       struct inet_bind_hashbucket *prev_addr_hashbucket;
> > > > > >         struct inet_sock *inet = inet_sk(sk);
> > > > > >         __be32 old_saddr = inet->inet_saddr;
> > > > > >         __be32 daddr = inet->inet_daddr;
> > > > > > @@ -1260,16 +1259,8 @@ static int inet_sk_reselect_saddr(struct sock *sk)
> > > > > >                 return 0;
> > > > > >         }
> > > > > >
> > > > > > -       prev_addr_hashbucket =
> > > > > > -               inet_bhashfn_portaddr(tcp_or_dccp_get_hashinfo(sk), sk,
> > > > > > -                                     sock_net(sk), inet->inet_num);
> > > > > > -
> > > > > > -       inet->inet_saddr = inet->inet_rcv_saddr = new_saddr;
> > > > > > -
> > > > > > -       err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > > > > +       err = inet_bhash2_update_saddr(sk, &new_saddr, AF_INET);
> > > > > >         if (err) {
> > > > > > -               inet->inet_saddr = old_saddr;
> > > > > > -               inet->inet_rcv_saddr = old_saddr;
> > > > > >                 ip_rt_put(rt);
> > > > > >                 return err;
> > > > > >         }
> > > > > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > > > > index d745f962745e..dcb6bc918966 100644
> > > > > > --- a/net/ipv4/inet_hashtables.c
> > > > > > +++ b/net/ipv4/inet_hashtables.c
> > > > > > @@ -858,7 +858,20 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
> > > > > >         return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> > > > > >  }
> > > > > >
> > > > > > -int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
> > > > > > +static void inet_update_saddr(struct sock *sk, void *saddr, int family)
> > > > > > +{
> > > > > > +#if IS_ENABLED(CONFIG_IPV6)
> > > > > > +       if (family == AF_INET6) {
> > > > > > +               sk->sk_v6_rcv_saddr = *(struct in6_addr *)saddr;
> > > > > > +       } else
> > > > > > +#endif
> > > > > > +       {
> > > > > > +               inet_sk(sk)->inet_saddr = *(__be32 *)saddr;
> > > > > > +               sk_rcv_saddr_set(sk, inet_sk(sk)->inet_saddr);
> > > > > > +       }
> > > > > > +}
> > > > > > +
> > > > > > +int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> > > > > >  {
> > > > > >         struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
> > > > > >         struct inet_bind2_bucket *tb2, *new_tb2;
> > > > > > @@ -867,6 +880,12 @@ int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct soc
> > > > > >         int port = inet_sk(sk)->inet_num;
> > > > > >         struct net *net = sock_net(sk);
> > > > > >
> > > > > > +       if (!inet_csk(sk)->icsk_bind2_hash) {
> > > > > > +               /* Not bind()ed before. */
> > > > > > +               inet_update_saddr(sk, saddr, family);
> > > > > > +               return 0;
> > > > > > +       }
> > > > > > +
> > > > > >         /* Allocate a bind2 bucket ahead of time to avoid permanently putting
> > > > > >          * the bhash2 table in an inconsistent state if a new tb2 bucket
> > > > > >          * allocation fails.
> > > > > > @@ -875,12 +894,18 @@ int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct soc
> > > > > >         if (!new_tb2)
> > > > > >                 return -ENOMEM;
> > > > > >
> > > > > > +       /* Unlink first not to show the wrong address for other threads. */
> > > > > >         head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> > > > > >
> > > > > > -       spin_lock_bh(&prev_saddr->lock);
> > > > > > +       spin_lock_bh(&head2->lock);
> > > > > >         __sk_del_bind2_node(sk);
> > > > > >         inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
> > > > > > -       spin_unlock_bh(&prev_saddr->lock);
> > > > > > +       spin_unlock_bh(&head2->lock);
> > > > > > +
> > > > > > +       inet_update_saddr(sk, saddr, family);
> > > > > > +
> > > > > > +       /* Update bhash2 bucket. */
> > > > > > +       head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> > > > > >
> > > > > >         spin_lock_bh(&head2->lock);
> > > > > >         tb2 = inet_bind2_bucket_find(head2, net, port, l3mdev, sk);
> > > > > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > > > > index 6a3a732b584d..23dd7e9df2d5 100644
> > > > > > --- a/net/ipv4/tcp_ipv4.c
> > > > > > +++ b/net/ipv4/tcp_ipv4.c
> > > > > > @@ -199,15 +199,14 @@ static int tcp_v4_pre_connect(struct sock *sk, struct sockaddr *uaddr,
> > > > > >  /* This will initiate an outgoing connection. */
> > > > > >  int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > > > > >  {
> > > > > > -       struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> > > > > >         struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
> > > > > >         struct inet_timewait_death_row *tcp_death_row;
> > > > > > -       __be32 daddr, nexthop, prev_sk_rcv_saddr;
> > > > > >         struct inet_sock *inet = inet_sk(sk);
> > > > > >         struct tcp_sock *tp = tcp_sk(sk);
> > > > > >         struct ip_options_rcu *inet_opt;
> > > > > >         struct net *net = sock_net(sk);
> > > > > >         __be16 orig_sport, orig_dport;
> > > > > > +       __be32 daddr, nexthop;
> > > > > >         struct flowi4 *fl4;
> > > > > >         struct rtable *rt;
> > > > > >         int err;
> > > > > > @@ -251,24 +250,13 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
> > > > > >         tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
> > > > > >
> > > > > >         if (!inet->inet_saddr) {
> > > > > > -               if (inet_csk(sk)->icsk_bind2_hash) {
> > > > > > -                       prev_addr_hashbucket = inet_bhashfn_portaddr(tcp_death_row->hashinfo,
> > > > > > -                                                                    sk, net, inet->inet_num);
> > > > > > -                       prev_sk_rcv_saddr = sk->sk_rcv_saddr;
> > > > > > -               }
> > > > > > -               inet->inet_saddr = fl4->saddr;
> > > > > > -       }
> > > > > > -
> > > > > > -       sk_rcv_saddr_set(sk, inet->inet_saddr);
> > > > > > -
> > > > > > -       if (prev_addr_hashbucket) {
> > > > > > -               err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > > > > +               err = inet_bhash2_update_saddr(sk,  &fl4->saddr, AF_INET);
> > > > > >                 if (err) {
> > > > > > -                       inet->inet_saddr = 0;
> > > > > > -                       sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
> > > > > >                         ip_rt_put(rt);
> > > > > >                         return err;
> > > > > >                 }
> > > > > > +       } else {
> > > > > > +               sk_rcv_saddr_set(sk, inet->inet_saddr);
> > > > > >         }
> > > > > >
> > > > > >         if (tp->rx_opt.ts_recent_stamp && inet->inet_daddr != daddr) {
> > > > > > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > > > > > index 81b396e5cf79..2f3ca3190d26 100644
> > > > > > --- a/net/ipv6/tcp_ipv6.c
> > > > > > +++ b/net/ipv6/tcp_ipv6.c
> > > > > > @@ -292,24 +292,11 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
> > > > > >         tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
> > > > > >
> > > > > >         if (!saddr) {
> > > > > > -               struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> > > > > > -               struct in6_addr prev_v6_rcv_saddr;
> > > > > > -
> > > > > > -               if (icsk->icsk_bind2_hash) {
> > > > > > -                       prev_addr_hashbucket = inet_bhashfn_portaddr(tcp_death_row->hashinfo,
> > > > > > -                                                                    sk, net, inet->inet_num);
> > > > > > -                       prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
> > > > > > -               }
> > > > > >                 saddr = &fl6.saddr;
> > > > > > -               sk->sk_v6_rcv_saddr = *saddr;
> > > > > >
> > > > > > -               if (prev_addr_hashbucket) {
> > > > > > -                       err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> > > > > > -                       if (err) {
> > > > > > -                               sk->sk_v6_rcv_saddr = prev_v6_rcv_saddr;
> > > > > > -                               goto failure;
> > > > > > -                       }
> > > > > > -               }
> > > > > > +               err = inet_bhash2_update_saddr(sk, saddr, AF_INET6);
> > > > > > +               if (err)
> > > > > > +                       goto failure;
> > > > > >         }
> > > > > >
> > > > > >         /* set the source address */
> > > > > > --
> > > > > > 2.30.2
