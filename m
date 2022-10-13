Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12985FDE01
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJMQJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJMQJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:09:45 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF7060DF
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:09:43 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-354c7abf786so22432657b3.0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fEcQ804ZM33HyiNbybc52EJ+ZyxsGbPyZDbBCZuJgc4=;
        b=GXfhXBKC6eeh4h6WmJzU2yWCAELLalNFH8hHzhWtUdAcOTRWQFemLx+2g/l5DYwWhf
         dukN7vpCtoX4X6JF3HtNxhuFjXhX0pAq2KGJsjkHFoTDBu/uHb8EoEa4iKU5EmThFzbu
         s9cl3lfIewSaJbHVejm4rHK8eTyqkwC77lMEtT8ljqUSDIdC7J/cN1WfuLMD686FX2Q7
         +7zJm/IPecWvjMDqoeomU42ASy/90EZBpMZZdbNmM4+beQAD2qBzvrO+leK4+pygUMoz
         h2PXnsf6oZDKVCH4FTyyel4k5U22y6lP2Ftwk/QC2ryhUMViypcpz/9OZjA/cwTEqJmr
         2eEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fEcQ804ZM33HyiNbybc52EJ+ZyxsGbPyZDbBCZuJgc4=;
        b=UVUXCCJMvkyFtrRw28fa9+/VT5KGXIr6hPfkm7c3Om6izXO+6/1lclQpHbTCEWZMnf
         noBfP43dAbYZof4R4krVUwzyWnY04PKtnGE0S1GI53FczxrboB8lrxh9pCfOVeqUCxfZ
         TUGh3MnmpZnhltoSSRAzzJPtogZA1O86u0WEVVcHDGuhV+LL7Ddi83sHpk18YkK4RElx
         /DjOCZIC2XAVX3P49KhjXBD6rOVifCgKoG7iagTnZfM/aSv0JHiaqZi4IgZMNTsFPvjR
         GcL51/5FTQ/Hph0N3uIKz9rLs7UkUoED6JzAVzh7bHqTFQ30R9D+PdsWKhzS/VnwdOnk
         IbLw==
X-Gm-Message-State: ACrzQf0HmKcu90fwD/Q19L58pS5r+iR3DP8zLnMBYWX61dgFSmyi6hy+
        tTXhYhVYlMoFO841M3mS/bRn6dBoGfd9iNxgNVPvAQ==
X-Google-Smtp-Source: AMsMyM6oL25zAaK9mucjKttghovzHYEIZq1/TdBLfjEcVVTZ1549bE1Vsm2ksU3gSya0vxvluE9jQSwYfS0tIYdb/v0=
X-Received: by 2002:a81:9202:0:b0:35e:face:a087 with SMTP id
 j2-20020a819202000000b0035efacea087mr683025ywg.55.1665677382516; Thu, 13 Oct
 2022 09:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iJn-T_rKg67h6deW0Oyh=X4kWXVBrtvUJU+VpDTfpde0w@mail.gmail.com>
 <20221012192739.91505-1-kuniyu@amazon.com>
In-Reply-To: <20221012192739.91505-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Oct 2022 09:09:31 -0700
Message-ID: <CANn89iLja=eQHbsM_Ta2sQF0tOGU8vAGrh_izRuuHjuO1ouUag@mail.gmail.com>
Subject: Re: [PATCH v2 net] udp: Update reuse->has_conns under reuseport_lock.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, kraig@google.com,
        kuba@kernel.org, kuni1840@gmail.com, martin.lau@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, willemb@google.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 12:28 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Wed, 12 Oct 2022 11:59:43 -0700
> > On Wed, Oct 12, 2022 at 11:53 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > When we call connect() for a UDP socket in a reuseport group, we have
> > > to update sk->sk_reuseport_cb->has_conns to 1.  Otherwise, the kernel
> > > could select a unconnected socket wrongly for packets sent to the
> > > connected socket.
> > >
> > > However, the current way to set has_conns is illegal and possible to
> > > trigger that problem.  reuseport_has_conns() changes has_conns under
> > > rcu_read_lock(), which upgrades the RCU reader to the updater.  Then,
> > > it must do the update under the updater's lock, reuseport_lock, but
> > > it doesn't for now.
> > >
> > > For this reason, there is a race below where we fail to set has_conns
> > > resulting in the wrong socket selection.  To avoid the race, let's split
> > > the reader and updater with proper locking.
> > >
> > >  cpu1                               cpu2
> > > +----+                             +----+
> > >
> > > __ip[46]_datagram_connect()        reuseport_grow()
> > > .                                  .
> > > |- reuseport_has_conns(sk, true)   |- more_reuse = __reuseport_alloc(more_socks_size)
> > > |  .                               |
> > > |  |- rcu_read_lock()
> > > |  |- reuse = rcu_dereference(sk->sk_reuseport_cb)
> > > |  |
> > > |  |                               |  /* reuse->has_conns == 0 here */
> > > |  |                               |- more_reuse->has_conns = reuse->has_conns
> > > |  |- reuse->has_conns = 1         |  /* more_reuse->has_conns SHOULD BE 1 HERE */
> > > |  |                               |
> > > |  |                               |- rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
> > > |  |                               |                     more_reuse)
> > > |  `- rcu_read_unlock()            `- kfree_rcu(reuse, rcu)
> > > |
> > > |- sk->sk_state = TCP_ESTABLISHED
> > >
> > > Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > > v2:
> > >   * Fix build failure for CONFIG_IPV6=m
> > >   * Drop SO_INCOMING_CPU fix, which will be sent for net-next
> > >     after the v6.1 merge window
> > >
> > > v1: https://lore.kernel.org/netdev/20221010174351.11024-1-kuniyu@amazon.com/
> > > ---
> > >  include/net/sock_reuseport.h | 11 +++++------
> > >  net/core/sock_reuseport.c    | 15 +++++++++++++++
> > >  net/ipv4/datagram.c          |  2 +-
> > >  net/ipv4/udp.c               |  2 +-
> > >  net/ipv6/datagram.c          |  2 +-
> > >  net/ipv6/udp.c               |  2 +-
> > >  6 files changed, 24 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > > index 473b0b0fa4ab..efc9085c6892 100644
> > > --- a/include/net/sock_reuseport.h
> > > +++ b/include/net/sock_reuseport.h
> > > @@ -43,21 +43,20 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
> > >  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
> > >  extern int reuseport_detach_prog(struct sock *sk);
> > >
> > > -static inline bool reuseport_has_conns(struct sock *sk, bool set)
> > > +static inline bool reuseport_has_conns(struct sock *sk)
> > >  {
> > >         struct sock_reuseport *reuse;
> > >         bool ret = false;
> > >
> > >         rcu_read_lock();
> > >         reuse = rcu_dereference(sk->sk_reuseport_cb);
> > > -       if (reuse) {
> > > -               if (set)
> > > -                       reuse->has_conns = 1;
> > > -               ret = reuse->has_conns;
> > > -       }
> > > +       if (reuse && reuse->has_conns)
> > > +               ret = true;
> > >         rcu_read_unlock();
> > >
> > >         return ret;
> > >  }
> > >
> > > +void reuseport_has_conns_set(struct sock *sk);
> > > +
> > >  #endif  /* _SOCK_REUSEPORT_H */
> > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > index 5daa1fa54249..abb414ed4aa7 100644
> > > --- a/net/core/sock_reuseport.c
> > > +++ b/net/core/sock_reuseport.c
> > > @@ -21,6 +21,21 @@ static DEFINE_IDA(reuseport_ida);
> > >  static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> > >                                struct sock_reuseport *reuse, bool bind_inany);
> > >
> > > +void reuseport_has_conns_set(struct sock *sk)
> > > +{
> > > +       struct sock_reuseport *reuse;
> > > +
> > > +       if (!rcu_access_pointer(sk->sk_reuseport_cb))
> > > +               return;
> > > +
> > > +       spin_lock(&reuseport_lock);
> > > +       reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > > +                                         lockdep_is_held(&reuseport_lock));
> >
> > Could @reuse be NULL at this point ?
> >
> > Previous  test was performed without reuseport_lock being held.
>
> Usually, sk_reuseport_cb is changed under lock_sock().
>
> The only exception is reuseport_grow() & TCP reqsk migration case.
>
> 1) shutdown() TCP listener, which is moved into the latter part of
>    reuse->socks[] to migrate reqsk.
>
> 2) New listen() overflows reuse->socks[] and call reuseport_grow().
>
> 3) reuse->max_socks overflows u16 with the new listener.
>
> 4) reuseport_grow() pops the old shutdown()ed listener from the array
>    and update its sk->sk_reuseport_cb as NULL without lock_sock().
>
> shutdown()ed sk->sk_reuseport_cb can be changed without lock_sock().
>
> But, reuseport_has_conns_set() is called only for UDP and under
> lock_sock(), so @reuse never be NULL in this case.

Given the complexity of this code and how much time is needed to
review all possibilities, please add an additional

if (reuse)
   reuse->has_conns = 1;

I doubt anyone will object to such safety measures.

Thanks.

>
>
> > > +       reuse->has_conns = 1;
> > > +       spin_unlock(&reuseport_lock);
> > > +}
> > > +EXPORT_SYMBOL(reuseport_has_conns_set);
> > > +
> > >  static int reuseport_sock_index(struct sock *sk,
> > >                                 const struct sock_reuseport *reuse,
> > >                                 bool closed)
> > > diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
> > > index 405a8c2aea64..5e66add7befa 100644
> > > --- a/net/ipv4/datagram.c
> > > +++ b/net/ipv4/datagram.c
> > > @@ -70,7 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
> > >         }
> > >         inet->inet_daddr = fl4->daddr;
> > >         inet->inet_dport = usin->sin_port;
> > > -       reuseport_has_conns(sk, true);
> > > +       reuseport_has_conns_set(sk);
> > >         sk->sk_state = TCP_ESTABLISHED;
> > >         sk_set_txhash(sk);
> > >         inet->inet_id = prandom_u32();
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index d63118ce5900..29228231b058 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -448,7 +448,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
> > >                         result = lookup_reuseport(net, sk, skb,
> > >                                                   saddr, sport, daddr, hnum);
> > >                         /* Fall back to scoring if group has connections */
> > > -                       if (result && !reuseport_has_conns(sk, false))
> > > +                       if (result && !reuseport_has_conns(sk))
> > >                                 return result;
> > >
> > >                         result = result ? : sk;
> > > diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> > > index df665d4e8f0f..5ecb56522f9d 100644
> > > --- a/net/ipv6/datagram.c
> > > +++ b/net/ipv6/datagram.c
> > > @@ -256,7 +256,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
> > >                 goto out;
> > >         }
> > >
> > > -       reuseport_has_conns(sk, true);
> > > +       reuseport_has_conns_set(sk);
> > >         sk->sk_state = TCP_ESTABLISHED;
> > >         sk_set_txhash(sk);
> > >  out:
> > > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > > index 91e795bb9ade..56e4523a3004 100644
> > > --- a/net/ipv6/udp.c
> > > +++ b/net/ipv6/udp.c
> > > @@ -182,7 +182,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
> > >                         result = lookup_reuseport(net, sk, skb,
> > >                                                   saddr, sport, daddr, hnum);
> > >                         /* Fall back to scoring if group has connections */
> > > -                       if (result && !reuseport_has_conns(sk, false))
> > > +                       if (result && !reuseport_has_conns(sk))
> > >                                 return result;
> > >
> > >                         result = result ? : sk;
> > > --
> > > 2.30.2
