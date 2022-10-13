Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60655FDE7D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJMQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJMQvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:51:40 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5ED4D821
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665679897; x=1697215897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mJJuDNLYo8QJafRQ/pupnF9uKTRAcp2Py8XfGegAYpw=;
  b=kSf7QkQrMeSStU4o4i8e7nvEOxhCwV344yvyRH9QzRg04s4+DyDHwTtX
   csH7HbP2L5TQg+lIjtD/HP0dQuQpCdGXvGsw3KyBvtwkTuVKNcXx2Unqy
   B7pRmU7Jdf3YwPMUhPNdr7VvkA37BVJ3bCh89LcdILvSmVhSoo+CGozG9
   U=;
X-IronPort-AV: E=Sophos;i="5.95,182,1661817600"; 
   d="scan'208";a="255142455"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:51:34 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id 8BB04A2347;
        Thu, 13 Oct 2022 16:51:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 13 Oct 2022 16:51:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 13 Oct 2022 16:51:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kraig@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <martin.lau@kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <willemb@google.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 net] udp: Update reuse->has_conns under reuseport_lock.
Date:   Thu, 13 Oct 2022 09:51:13 -0700
Message-ID: <20221013165113.71105-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iLja=eQHbsM_Ta2sQF0tOGU8vAGrh_izRuuHjuO1ouUag@mail.gmail.com>
References: <CANn89iLja=eQHbsM_Ta2sQF0tOGU8vAGrh_izRuuHjuO1ouUag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D07UWA004.ant.amazon.com (10.43.160.32) To
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

From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Oct 2022 09:09:31 -0700
> On Wed, Oct 12, 2022 at 12:28 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > From:   Eric Dumazet <edumazet@google.com>
> > Date:   Wed, 12 Oct 2022 11:59:43 -0700
> > > On Wed, Oct 12, 2022 at 11:53 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > >
> > > > When we call connect() for a UDP socket in a reuseport group, we have
> > > > to update sk->sk_reuseport_cb->has_conns to 1.  Otherwise, the kernel
> > > > could select a unconnected socket wrongly for packets sent to the
> > > > connected socket.
> > > >
> > > > However, the current way to set has_conns is illegal and possible to
> > > > trigger that problem.  reuseport_has_conns() changes has_conns under
> > > > rcu_read_lock(), which upgrades the RCU reader to the updater.  Then,
> > > > it must do the update under the updater's lock, reuseport_lock, but
> > > > it doesn't for now.
> > > >
> > > > For this reason, there is a race below where we fail to set has_conns
> > > > resulting in the wrong socket selection.  To avoid the race, let's split
> > > > the reader and updater with proper locking.
> > > >
> > > >  cpu1                               cpu2
> > > > +----+                             +----+
> > > >
> > > > __ip[46]_datagram_connect()        reuseport_grow()
> > > > .                                  .
> > > > |- reuseport_has_conns(sk, true)   |- more_reuse = __reuseport_alloc(more_socks_size)
> > > > |  .                               |
> > > > |  |- rcu_read_lock()
> > > > |  |- reuse = rcu_dereference(sk->sk_reuseport_cb)
> > > > |  |
> > > > |  |                               |  /* reuse->has_conns == 0 here */
> > > > |  |                               |- more_reuse->has_conns = reuse->has_conns
> > > > |  |- reuse->has_conns = 1         |  /* more_reuse->has_conns SHOULD BE 1 HERE */
> > > > |  |                               |
> > > > |  |                               |- rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
> > > > |  |                               |                     more_reuse)
> > > > |  `- rcu_read_unlock()            `- kfree_rcu(reuse, rcu)
> > > > |
> > > > |- sk->sk_state = TCP_ESTABLISHED
> > > >
> > > > Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > > v2:
> > > >   * Fix build failure for CONFIG_IPV6=m
> > > >   * Drop SO_INCOMING_CPU fix, which will be sent for net-next
> > > >     after the v6.1 merge window
> > > >
> > > > v1: https://lore.kernel.org/netdev/20221010174351.11024-1-kuniyu@amazon.com/
> > > > ---
> > > >  include/net/sock_reuseport.h | 11 +++++------
> > > >  net/core/sock_reuseport.c    | 15 +++++++++++++++
> > > >  net/ipv4/datagram.c          |  2 +-
> > > >  net/ipv4/udp.c               |  2 +-
> > > >  net/ipv6/datagram.c          |  2 +-
> > > >  net/ipv6/udp.c               |  2 +-
> > > >  6 files changed, 24 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > > > index 473b0b0fa4ab..efc9085c6892 100644
> > > > --- a/include/net/sock_reuseport.h
> > > > +++ b/include/net/sock_reuseport.h
> > > > @@ -43,21 +43,20 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
> > > >  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
> > > >  extern int reuseport_detach_prog(struct sock *sk);
> > > >
> > > > -static inline bool reuseport_has_conns(struct sock *sk, bool set)
> > > > +static inline bool reuseport_has_conns(struct sock *sk)
> > > >  {
> > > >         struct sock_reuseport *reuse;
> > > >         bool ret = false;
> > > >
> > > >         rcu_read_lock();
> > > >         reuse = rcu_dereference(sk->sk_reuseport_cb);
> > > > -       if (reuse) {
> > > > -               if (set)
> > > > -                       reuse->has_conns = 1;
> > > > -               ret = reuse->has_conns;
> > > > -       }
> > > > +       if (reuse && reuse->has_conns)
> > > > +               ret = true;
> > > >         rcu_read_unlock();
> > > >
> > > >         return ret;
> > > >  }
> > > >
> > > > +void reuseport_has_conns_set(struct sock *sk);
> > > > +
> > > >  #endif  /* _SOCK_REUSEPORT_H */
> > > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > > index 5daa1fa54249..abb414ed4aa7 100644
> > > > --- a/net/core/sock_reuseport.c
> > > > +++ b/net/core/sock_reuseport.c
> > > > @@ -21,6 +21,21 @@ static DEFINE_IDA(reuseport_ida);
> > > >  static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> > > >                                struct sock_reuseport *reuse, bool bind_inany);
> > > >
> > > > +void reuseport_has_conns_set(struct sock *sk)
> > > > +{
> > > > +       struct sock_reuseport *reuse;
> > > > +
> > > > +       if (!rcu_access_pointer(sk->sk_reuseport_cb))
> > > > +               return;
> > > > +
> > > > +       spin_lock(&reuseport_lock);
> > > > +       reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > > > +                                         lockdep_is_held(&reuseport_lock));
> > >
> > > Could @reuse be NULL at this point ?
> > >
> > > Previous  test was performed without reuseport_lock being held.
> >
> > Usually, sk_reuseport_cb is changed under lock_sock().
> >
> > The only exception is reuseport_grow() & TCP reqsk migration case.
> >
> > 1) shutdown() TCP listener, which is moved into the latter part of
> >    reuse->socks[] to migrate reqsk.
> >
> > 2) New listen() overflows reuse->socks[] and call reuseport_grow().
> >
> > 3) reuse->max_socks overflows u16 with the new listener.
> >
> > 4) reuseport_grow() pops the old shutdown()ed listener from the array
> >    and update its sk->sk_reuseport_cb as NULL without lock_sock().
> >
> > shutdown()ed sk->sk_reuseport_cb can be changed without lock_sock().
> >
> > But, reuseport_has_conns_set() is called only for UDP and under
> > lock_sock(), so @reuse never be NULL in this case.
> 
> Given the complexity of this code and how much time is needed to
> review all possibilities, please add an additional
> 
> if (reuse)
>    reuse->has_conns = 1;
> 
> I doubt anyone will object to such safety measures.

I see.
If no one has any objections, I'll respin tomorrow with likely().

Thank you.


> 
> Thanks.
> 
> >
> >
> > > > +       reuse->has_conns = 1;
> > > > +       spin_unlock(&reuseport_lock);
> > > > +}
> > > > +EXPORT_SYMBOL(reuseport_has_conns_set);
> > > > +
> > > >  static int reuseport_sock_index(struct sock *sk,
> > > >                                 const struct sock_reuseport *reuse,
> > > >                                 bool closed)
> > > > diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
> > > > index 405a8c2aea64..5e66add7befa 100644
> > > > --- a/net/ipv4/datagram.c
> > > > +++ b/net/ipv4/datagram.c
> > > > @@ -70,7 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
> > > >         }
> > > >         inet->inet_daddr = fl4->daddr;
> > > >         inet->inet_dport = usin->sin_port;
> > > > -       reuseport_has_conns(sk, true);
> > > > +       reuseport_has_conns_set(sk);
> > > >         sk->sk_state = TCP_ESTABLISHED;
> > > >         sk_set_txhash(sk);
> > > >         inet->inet_id = prandom_u32();
> > > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > > index d63118ce5900..29228231b058 100644
> > > > --- a/net/ipv4/udp.c
> > > > +++ b/net/ipv4/udp.c
> > > > @@ -448,7 +448,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
> > > >                         result = lookup_reuseport(net, sk, skb,
> > > >                                                   saddr, sport, daddr, hnum);
> > > >                         /* Fall back to scoring if group has connections */
> > > > -                       if (result && !reuseport_has_conns(sk, false))
> > > > +                       if (result && !reuseport_has_conns(sk))
> > > >                                 return result;
> > > >
> > > >                         result = result ? : sk;
> > > > diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> > > > index df665d4e8f0f..5ecb56522f9d 100644
> > > > --- a/net/ipv6/datagram.c
> > > > +++ b/net/ipv6/datagram.c
> > > > @@ -256,7 +256,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
> > > >                 goto out;
> > > >         }
> > > >
> > > > -       reuseport_has_conns(sk, true);
> > > > +       reuseport_has_conns_set(sk);
> > > >         sk->sk_state = TCP_ESTABLISHED;
> > > >         sk_set_txhash(sk);
> > > >  out:
> > > > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > > > index 91e795bb9ade..56e4523a3004 100644
> > > > --- a/net/ipv6/udp.c
> > > > +++ b/net/ipv6/udp.c
> > > > @@ -182,7 +182,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
> > > >                         result = lookup_reuseport(net, sk, skb,
> > > >                                                   saddr, sport, daddr, hnum);
> > > >                         /* Fall back to scoring if group has connections */
> > > > -                       if (result && !reuseport_has_conns(sk, false))
> > > > +                       if (result && !reuseport_has_conns(sk))
> > > >                                 return result;
> > > >
> > > >                         result = result ? : sk;
> > > > --
> > > > 2.30.2
