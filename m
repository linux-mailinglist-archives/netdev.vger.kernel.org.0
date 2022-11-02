Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F53616FAA
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKBVZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKBVZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:25:27 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92D53B3
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:25:24 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id j130so89161ybj.9
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 14:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UK8U8geFqEyhiJ2/Gv99gaINXS+MCbyZbhud7pyaR8w=;
        b=HQ6i6X1swccy+Nkm/yfglNWj0kkq6fHsJlzE9mio1RfRyIFQJbXiIlV5hNQzYseU2g
         +8375i4N1tW7om0I+KtGG0vaIaAwbeQF0vEegufxTxF6dbrnvdHbEl0cK7fU/y0BE1BF
         WA2rmJ+Jdg4u3vI8B33VML50MAVgRb3hQjcBdhKkTIezkmJexHUfnEGEDusxoqd9CA+I
         PljErAb35V+RCvEpduDfIrX6GHCzbLKL+EVwvC7LBoNc7euHVsWY8GT4eX1JVAuB9yNu
         w7C6QfrMkNQfsNhI4042BaBizjbRYUxHqNpXpTvba/DbmGnyL7oUSCd8Jd+WZ07Z9jzB
         ZWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UK8U8geFqEyhiJ2/Gv99gaINXS+MCbyZbhud7pyaR8w=;
        b=DWxf/aJ+/AJYmwHMUS3HpyUUabhG71z9++L4RqOCSh8tur664h0pGZ27gLaY5Qx+8a
         +7B169qQVdnrPlV6GWP7pXapgyuF4IXko77fged20H7wbWtdr/KQORddz2eP6ug4Txhd
         vwks1CW5lYt1l/9OtbGHO9E5bhIcH+fwwLSHrCdxLRsU1LK+GUrqW4c2Zl5LqcxpgU9R
         /qhLRv7xGQZTJCz4GBKQtQBnEcUzbFEHfBqNKiSC5dkKY7VqqENUvQ1nBiDPvxcZL6Au
         Rmty5KwwBcUbKlVLYFeiN6vcy3aJDq0bOX6qf8rk2PpRV8BYzKFwu/NoJ6jnHvfwr2cq
         03AQ==
X-Gm-Message-State: ACrzQf0lj5AtYSiiFqXSFTfR2xuO2TnSuT1i5OeM7iZfj+D5NRZJG88C
        W2ybJFzzZ3cORNz9tMEjvoeDdJrBINUzk8yDGN3mMA==
X-Google-Smtp-Source: AMsMyM6Bftf0+wsCVnm4oDj6G4NFOD51SuFrpHRO0sP0ofIQsPPsqhyzLDsZb4eE8AimK/dgvsAxpzTP25fQBkNRFDI=
X-Received: by 2002:a25:6647:0:b0:6cb:8601:238a with SMTP id
 z7-20020a256647000000b006cb8601238amr24770436ybm.598.1667424323698; Wed, 02
 Nov 2022 14:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221102211350.625011-1-dima@arista.com> <20221102211350.625011-3-dima@arista.com>
In-Reply-To: <20221102211350.625011-3-dima@arista.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Nov 2022 14:25:12 -0700
Message-ID: <CANn89iLbOikuG9+Tna9M0Gr-diF2vFpfMV8MDP8rBuN49+Mwrg@mail.gmail.com>
Subject: Re: [PATCH 2/2] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
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

On Wed, Nov 2, 2022 at 2:14 PM Dmitry Safonov <dima@arista.com> wrote:
>
> To do that, separate two scenarios:
> - where it's the first MD5 key on the system, which means that enabling
>   of the static key may need to sleep;
> - copying of an existing key from a listening socket to the request
>   socket upon receiving a signed TCP segment, where static key was
>   already enabled (when the key was added to the listening socket).
>
> Now the life-time of the static branch for TCP-MD5 is until:
> - last tcp_md5sig_info is destroyed
> - last socket in time-wait state with MD5 key is closed.
>
> Which means that after all sockets with TCP-MD5 keys are gone, the
> system gets back the performance of disabled md5-key static branch.
>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  include/net/tcp.h        | 10 ++++---
>  net/ipv4/tcp.c           |  5 +---
>  net/ipv4/tcp_ipv4.c      | 56 ++++++++++++++++++++++++++++++----------
>  net/ipv4/tcp_minisocks.c |  9 ++++---
>  net/ipv4/tcp_output.c    |  4 +--
>  net/ipv6/tcp_ipv6.c      | 10 +++----
>  6 files changed, 63 insertions(+), 31 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 14d45661a84d..a0cdf013782a 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1675,7 +1675,11 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
>                         const struct sock *sk, const struct sk_buff *skb);
>  int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
>                    int family, u8 prefixlen, int l3index, u8 flags,
> -                  const u8 *newkey, u8 newkeylen, gfp_t gfp);
> +                  const u8 *newkey, u8 newkeylen);
> +int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
> +                    int family, u8 prefixlen, int l3index,
> +                    struct tcp_md5sig_key *key);
> +
>  int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr,
>                    int family, u8 prefixlen, int l3index, u8 flags);
>  struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
> @@ -1683,7 +1687,7 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
>
>  #ifdef CONFIG_TCP_MD5SIG
>  #include <linux/jump_label.h>
> -extern struct static_key_false tcp_md5_needed;
> +extern struct static_key_false_deferred tcp_md5_needed;
>  struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
>                                            const union tcp_md5_addr *addr,
>                                            int family);
> @@ -1691,7 +1695,7 @@ static inline struct tcp_md5sig_key *
>  tcp_md5_do_lookup(const struct sock *sk, int l3index,
>                   const union tcp_md5_addr *addr, int family)
>  {
> -       if (!static_branch_unlikely(&tcp_md5_needed))
> +       if (!static_branch_unlikely(&tcp_md5_needed.key))
>                 return NULL;
>         return __tcp_md5_do_lookup(sk, l3index, addr, family);
>  }
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index ef14efa1fb70..936ed566cc89 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4460,11 +4460,8 @@ bool tcp_alloc_md5sig_pool(void)
>         if (unlikely(!READ_ONCE(tcp_md5sig_pool_populated))) {
>                 mutex_lock(&tcp_md5sig_mutex);
>
> -               if (!tcp_md5sig_pool_populated) {
> +               if (!tcp_md5sig_pool_populated)
>                         __tcp_alloc_md5sig_pool();
> -                       if (tcp_md5sig_pool_populated)
> -                               static_branch_inc(&tcp_md5_needed);
> -               }
>
>                 mutex_unlock(&tcp_md5sig_mutex);
>         }
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index fae80b1a1796..f812d507fc9a 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1064,7 +1064,7 @@ static void tcp_v4_reqsk_destructor(struct request_sock *req)
>   * We need to maintain these in the sk structure.
>   */
>
> -DEFINE_STATIC_KEY_FALSE(tcp_md5_needed);
> +DEFINE_STATIC_KEY_DEFERRED_FALSE(tcp_md5_needed, HZ);
>  EXPORT_SYMBOL(tcp_md5_needed);
>
>  static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *new)
> @@ -1177,9 +1177,6 @@ static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct tcp_md5sig_info *md5sig;
>
> -       if (rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk)))
> -               return 0;
> -
>         md5sig = kmalloc(sizeof(*md5sig), gfp);
>         if (!md5sig)
>                 return -ENOMEM;
> @@ -1191,9 +1188,9 @@ static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
>  }
>
>  /* This can be called on a newly created socket, from other files */
> -int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
> -                  int family, u8 prefixlen, int l3index, u8 flags,
> -                  const u8 *newkey, u8 newkeylen, gfp_t gfp)
> +static int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
> +                           int family, u8 prefixlen, int l3index, u8 flags,
> +                           const u8 *newkey, u8 newkeylen, gfp_t gfp)
>  {
>         /* Add Key to the list */
>         struct tcp_md5sig_key *key;
> @@ -1220,9 +1217,6 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
>                 return 0;
>         }
>
> -       if (tcp_md5sig_info_add(sk, gfp))
> -               return -ENOMEM;
> -
>         md5sig = rcu_dereference_protected(tp->md5sig_info,
>                                            lockdep_sock_is_held(sk));
>
> @@ -1246,8 +1240,44 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
>         hlist_add_head_rcu(&key->node, &md5sig->head);
>         return 0;
>  }
> +
> +int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
> +                  int family, u8 prefixlen, int l3index, u8 flags,
> +                  const u8 *newkey, u8 newkeylen)
> +{
> +       struct tcp_sock *tp = tcp_sk(sk);
> +
> +       if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
> +               if (tcp_md5sig_info_add(sk, GFP_KERNEL))
> +                       return -ENOMEM;
> +
> +               static_branch_inc(&tcp_md5_needed.key);
> +       }
> +
> +       return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index, flags,
> +                               newkey, newkeylen, GFP_KERNEL);
> +}
>  EXPORT_SYMBOL(tcp_md5_do_add);
>
> +int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
> +                    int family, u8 prefixlen, int l3index,
> +                    struct tcp_md5sig_key *key)
> +{
> +       struct tcp_sock *tp = tcp_sk(sk);
> +
> +       if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
> +               if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
> +                       return -ENOMEM;
> +
> +               atomic_inc(&tcp_md5_needed.key.key.enabled);

static_branch_inc ?

> +       }
> +
> +       return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index,
> +                               key->flags, key->key, key->keylen,
> +                               sk_gfp_mask(sk, GFP_ATOMIC));
> +}
> +EXPORT_SYMBOL(tcp_md5_key_copy);
> +
>  int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family,
>                    u8 prefixlen, int l3index, u8 flags)
>  {
> @@ -1334,7 +1364,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
>                 return -EINVAL;
>
>         return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
> -                             cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
> +                             cmd.tcpm_key, cmd.tcpm_keylen);
>  }
>
>  static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
> @@ -1591,8 +1621,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
>                  * memory, then we end up not copying the key
>                  * across. Shucks.
>                  */
> -               tcp_md5_do_add(newsk, addr, AF_INET, 32, l3index, key->flags,
> -                              key->key, key->keylen, GFP_ATOMIC);
> +               tcp_md5_key_copy(newsk, addr, AF_INET, 32, l3index, key);
>                 sk_gso_disable(newsk);
>         }
>  #endif
> @@ -2284,6 +2313,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
>                 tcp_clear_md5_list(sk);
>                 kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
>                 tp->md5sig_info = NULL;
> +               static_branch_slow_dec_deferred(&tcp_md5_needed);
>         }
>  #endif
>
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index c375f603a16c..fb500160b8d2 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -291,13 +291,14 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
>                  */
>                 do {
>                         tcptw->tw_md5_key = NULL;
> -                       if (static_branch_unlikely(&tcp_md5_needed)) {
> +                       if (static_branch_unlikely(&tcp_md5_needed.key)) {
>                                 struct tcp_md5sig_key *key;
>
>                                 key = tp->af_specific->md5_lookup(sk, sk);
>                                 if (key) {
>                                         tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
>                                         BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
> +                                       atomic_inc(&tcp_md5_needed.key.key.enabled);

static_branch_inc

>                                 }
>                         }
>                 } while (0);
> @@ -337,11 +338,13 @@ EXPORT_SYMBOL(tcp_time_wait);
>  void tcp_twsk_destructor(struct sock *sk)
>  {
>  #ifdef CONFIG_TCP_MD5SIG
> -       if (static_branch_unlikely(&tcp_md5_needed)) {
> +       if (static_branch_unlikely(&tcp_md5_needed.key)) {
>                 struct tcp_timewait_sock *twsk = tcp_twsk(sk);
>
> -               if (twsk->tw_md5_key)
> +               if (twsk->tw_md5_key) {

Orthogonal to this patch, but I wonder why we do not clear
twsk->tw_md5_key before kfree_rcu()

It seems a lookup could catch the invalid pointer.

>                         kfree_rcu(twsk->tw_md5_key, rcu);
> +                       static_branch_slow_dec_deferred(&tcp_md5_needed);
> +               }
>         }
>  #endif
>  }
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index c69f4d966024..86e71c8c76bc 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -766,7 +766,7 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
>
>         *md5 = NULL;
>  #ifdef CONFIG_TCP_MD5SIG
> -       if (static_branch_unlikely(&tcp_md5_needed) &&
> +       if (static_branch_unlikely(&tcp_md5_needed.key) &&
>             rcu_access_pointer(tp->md5sig_info)) {
>                 *md5 = tp->af_specific->md5_lookup(sk, sk);
>                 if (*md5) {
> @@ -922,7 +922,7 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
>
>         *md5 = NULL;
>  #ifdef CONFIG_TCP_MD5SIG
> -       if (static_branch_unlikely(&tcp_md5_needed) &&
> +       if (static_branch_unlikely(&tcp_md5_needed.key) &&
>             rcu_access_pointer(tp->md5sig_info)) {
>                 *md5 = tp->af_specific->md5_lookup(sk, sk);
>                 if (*md5) {
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 2a3f9296df1e..3e3bdc120fc8 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -677,12 +677,11 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
>         if (ipv6_addr_v4mapped(&sin6->sin6_addr))
>                 return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
>                                       AF_INET, prefixlen, l3index, flags,
> -                                     cmd.tcpm_key, cmd.tcpm_keylen,
> -                                     GFP_KERNEL);
> +                                     cmd.tcpm_key, cmd.tcpm_keylen);
>
>         return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
>                               AF_INET6, prefixlen, l3index, flags,
> -                             cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
> +                             cmd.tcpm_key, cmd.tcpm_keylen);
>  }
>
>  static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
> @@ -1382,9 +1381,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
>                  * memory, then we end up not copying the key
>                  * across. Shucks.
>                  */
> -               tcp_md5_do_add(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
> -                              AF_INET6, 128, l3index, key->flags, key->key, key->keylen,
> -                              sk_gfp_mask(sk, GFP_ATOMIC));
> +               tcp_md5_key_copy(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
> +                                AF_INET6, 128, l3index, key);
>         }
>  #endif
>
> --
> 2.38.1
>
