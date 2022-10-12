Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837385FCB37
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 21:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJLTAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 15:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiJLS75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 14:59:57 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D928C6440
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 11:59:55 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-360871745b0so103964987b3.3
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 11:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CITEcy3H9RvWfgD6/tq34bn3UFkan53XGYeqNtVspRw=;
        b=P/Ng3C3+UN5W5glGaP6oXhfEttj7Fw1Jklmfv+mc+MwuDhGra2RqWeKkX0so0zMuEI
         biiCxYgVe3munH+k2ynaBQ7KgfkzB4ghjFvN9/Q/1w5+o6DgFk82jNTsqrGnfGFVaf09
         sRMJCweaIecezbOAxTJnAFudJvKsUjWiy3uAwUHz95mXgXF05XQZeC9YbJGVl4/34vw/
         iQDs7sv14DLUE9HcrH87SosU9wbPw/MWakipAHCJ4kdYQflNtfaVe9l5MlKiZSk1Myzg
         iOkyvZYZa8uOfDwmhMCqZf/n7tOiQDgQ4p6B634ZZL9AGeDk+i+Zy+tiqooIvD1N5DqB
         5z/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CITEcy3H9RvWfgD6/tq34bn3UFkan53XGYeqNtVspRw=;
        b=1/4vbdKNlxtoNY8KBRm2rAljaLV3wrC9cBqJMYC0PXo/IPrnKkTVop9icP0azo4cuw
         zNIqvu08AMJPOCJOH4KRqFAvaElrBrJJetYtOnbhtFDGRgl877O5pq4iTzPQJ92t+62D
         1Y3HHn9B8J8QsCuJAbwC6oxectjREeTCJCygZ16hbWp9iSu21OstI4Kfh2mUTTKeUyMP
         5GT7G9F3qnGtnCzso+7NM/YiYUtCBL2HJpQIg1EscYln5Mz4mJ4Mi+NgO9eKATlBCge5
         xuTgF5LopCAGHdhMNz/L/yKQZcUWnWRpnH9pvV5jLyE8FhB3O00wvNjxGe7tisJIS59V
         c82Q==
X-Gm-Message-State: ACrzQf0Iqxn20c1dr65OWSP5gkU3z+K/iQIctupu68Kbb/CSAqP7XNKx
        EIREDg0lyccnFbkvvjT5gl/8nZrxnAxSzjUDQXYFiA==
X-Google-Smtp-Source: AMsMyM65MA/tfAyuQ+LxJ6Kh1NrTyfl/ofknbUTC7dcAJw/QwuyrQf5rTrvWs9UtqjTFPaQc2gDKrvgXpPZWFWWdzHk=
X-Received: by 2002:a81:48d6:0:b0:355:8d0a:d8a1 with SMTP id
 v205-20020a8148d6000000b003558d0ad8a1mr27180226ywa.467.1665601194844; Wed, 12
 Oct 2022 11:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20221012185243.88948-1-kuniyu@amazon.com>
In-Reply-To: <20221012185243.88948-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Oct 2022 11:59:43 -0700
Message-ID: <CANn89iJn-T_rKg67h6deW0Oyh=X4kWXVBrtvUJU+VpDTfpde0w@mail.gmail.com>
Subject: Re: [PATCH v2 net] udp: Update reuse->has_conns under reuseport_lock.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Craig Gallek <kraig@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
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

On Wed, Oct 12, 2022 at 11:53 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> When we call connect() for a UDP socket in a reuseport group, we have
> to update sk->sk_reuseport_cb->has_conns to 1.  Otherwise, the kernel
> could select a unconnected socket wrongly for packets sent to the
> connected socket.
>
> However, the current way to set has_conns is illegal and possible to
> trigger that problem.  reuseport_has_conns() changes has_conns under
> rcu_read_lock(), which upgrades the RCU reader to the updater.  Then,
> it must do the update under the updater's lock, reuseport_lock, but
> it doesn't for now.
>
> For this reason, there is a race below where we fail to set has_conns
> resulting in the wrong socket selection.  To avoid the race, let's split
> the reader and updater with proper locking.
>
>  cpu1                               cpu2
> +----+                             +----+
>
> __ip[46]_datagram_connect()        reuseport_grow()
> .                                  .
> |- reuseport_has_conns(sk, true)   |- more_reuse = __reuseport_alloc(more_socks_size)
> |  .                               |
> |  |- rcu_read_lock()
> |  |- reuse = rcu_dereference(sk->sk_reuseport_cb)
> |  |
> |  |                               |  /* reuse->has_conns == 0 here */
> |  |                               |- more_reuse->has_conns = reuse->has_conns
> |  |- reuse->has_conns = 1         |  /* more_reuse->has_conns SHOULD BE 1 HERE */
> |  |                               |
> |  |                               |- rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
> |  |                               |                     more_reuse)
> |  `- rcu_read_unlock()            `- kfree_rcu(reuse, rcu)
> |
> |- sk->sk_state = TCP_ESTABLISHED
>
> Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> v2:
>   * Fix build failure for CONFIG_IPV6=m
>   * Drop SO_INCOMING_CPU fix, which will be sent for net-next
>     after the v6.1 merge window
>
> v1: https://lore.kernel.org/netdev/20221010174351.11024-1-kuniyu@amazon.com/
> ---
>  include/net/sock_reuseport.h | 11 +++++------
>  net/core/sock_reuseport.c    | 15 +++++++++++++++
>  net/ipv4/datagram.c          |  2 +-
>  net/ipv4/udp.c               |  2 +-
>  net/ipv6/datagram.c          |  2 +-
>  net/ipv6/udp.c               |  2 +-
>  6 files changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index 473b0b0fa4ab..efc9085c6892 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -43,21 +43,20 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
>  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
>  extern int reuseport_detach_prog(struct sock *sk);
>
> -static inline bool reuseport_has_conns(struct sock *sk, bool set)
> +static inline bool reuseport_has_conns(struct sock *sk)
>  {
>         struct sock_reuseport *reuse;
>         bool ret = false;
>
>         rcu_read_lock();
>         reuse = rcu_dereference(sk->sk_reuseport_cb);
> -       if (reuse) {
> -               if (set)
> -                       reuse->has_conns = 1;
> -               ret = reuse->has_conns;
> -       }
> +       if (reuse && reuse->has_conns)
> +               ret = true;
>         rcu_read_unlock();
>
>         return ret;
>  }
>
> +void reuseport_has_conns_set(struct sock *sk);
> +
>  #endif  /* _SOCK_REUSEPORT_H */
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index 5daa1fa54249..abb414ed4aa7 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -21,6 +21,21 @@ static DEFINE_IDA(reuseport_ida);
>  static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
>                                struct sock_reuseport *reuse, bool bind_inany);
>
> +void reuseport_has_conns_set(struct sock *sk)
> +{
> +       struct sock_reuseport *reuse;
> +
> +       if (!rcu_access_pointer(sk->sk_reuseport_cb))
> +               return;
> +
> +       spin_lock(&reuseport_lock);
> +       reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> +                                         lockdep_is_held(&reuseport_lock));

Could @reuse be NULL at this point ?

Previous  test was performed without reuseport_lock being held.

> +       reuse->has_conns = 1;
> +       spin_unlock(&reuseport_lock);
> +}
> +EXPORT_SYMBOL(reuseport_has_conns_set);
> +
>  static int reuseport_sock_index(struct sock *sk,
>                                 const struct sock_reuseport *reuse,
>                                 bool closed)
> diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
> index 405a8c2aea64..5e66add7befa 100644
> --- a/net/ipv4/datagram.c
> +++ b/net/ipv4/datagram.c
> @@ -70,7 +70,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
>         }
>         inet->inet_daddr = fl4->daddr;
>         inet->inet_dport = usin->sin_port;
> -       reuseport_has_conns(sk, true);
> +       reuseport_has_conns_set(sk);
>         sk->sk_state = TCP_ESTABLISHED;
>         sk_set_txhash(sk);
>         inet->inet_id = prandom_u32();
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index d63118ce5900..29228231b058 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -448,7 +448,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
>                         result = lookup_reuseport(net, sk, skb,
>                                                   saddr, sport, daddr, hnum);
>                         /* Fall back to scoring if group has connections */
> -                       if (result && !reuseport_has_conns(sk, false))
> +                       if (result && !reuseport_has_conns(sk))
>                                 return result;
>
>                         result = result ? : sk;
> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index df665d4e8f0f..5ecb56522f9d 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c
> @@ -256,7 +256,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
>                 goto out;
>         }
>
> -       reuseport_has_conns(sk, true);
> +       reuseport_has_conns_set(sk);
>         sk->sk_state = TCP_ESTABLISHED;
>         sk_set_txhash(sk);
>  out:
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 91e795bb9ade..56e4523a3004 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -182,7 +182,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
>                         result = lookup_reuseport(net, sk, skb,
>                                                   saddr, sport, daddr, hnum);
>                         /* Fall back to scoring if group has connections */
> -                       if (result && !reuseport_has_conns(sk, false))
> +                       if (result && !reuseport_has_conns(sk))
>                                 return result;
>
>                         result = result ? : sk;
> --
> 2.30.2
>
