Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AF65ED397
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiI1Dow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiI1DoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:44:25 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504291684FA
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:44:04 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-346cd4c3d7aso118621767b3.8
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ZcDD5FakUasQtSrmSRi1FEIDVSTBNtqDq8bmU2CJRkc=;
        b=qqRJ+ZxtW0UA+5bKuznEKZmvZ44Wtj8gY0XrLrBfmRkR8OCLkJOmRGS2FY9FqapLR6
         /DFRr6IgM37XKP1t/iBK4a7cdZYW+oRHM9EMZWxA8h2FuOFEAf5U14yonQNIJm4Rwq9h
         pNkn9AWtSo2IldgA1u7pi1iSb1GhvJDxr6oqdJBG+um5F7uiiaEECSRreqzBLZLQCGML
         wBjs4E/0RmNZ2bs9PPA8bWu6KXa+BtN+ZtQz35UAots2o+qXrKEKYKc4VCZ83z4LpiDi
         bg9Du7QpwV3UmrWVQ7g1umrBiZ9P1K/mQpwdhoAvPv8+spxVCH7/yMWwZS6rxqXIbJ+P
         wAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ZcDD5FakUasQtSrmSRi1FEIDVSTBNtqDq8bmU2CJRkc=;
        b=mCg0P1eTkrDmogUaRPi4fW7BBqD98GmQ2xG9Xn/8+efxIykbm2nJaG1YPVdY/519PU
         f1PuLhQZNpX3BKPD8UHly9nw3b3pFpD7VZeWaZIl3TbJOpDeS+cqgPd1vgOu+Yo6NGVu
         MJcmG1vSi4mZoyj3pNU3ilyJsJOofmlnRefI2HIpEHSQUmB5F19PaBzRAjy+/LmdeIEY
         p4BQDevTxRUtZvakypphhpYER64XH1QtZr7pEVIDYgQ+dRBusPdbNLEUwLDdlMWq2eDo
         M/6KjyVHVSC8AFmP/vNKxPL07TJIp4OdZ3epTMQm+ZuVtpfO8yAndCI8AqlswHw0P8bN
         Qwfg==
X-Gm-Message-State: ACrzQf1aUkQdZl0ah3rzO96xVTal0Bqepmyiv2ai5Eur6ZRHjcUeOMoF
        Scjyx7ts7KxZJasjbtM6U7POefrD7yWQk/vOgYyS3Q==
X-Google-Smtp-Source: AMsMyM5ga9IMIHn2ikCjiqTnH3pVhIznBVDbB/q5sqVgB+IVDn6HT2sFj6OG5Tn5oK+bcShxKAd8o+7cBwu11KWk3Rc=
X-Received: by 2002:a0d:d508:0:b0:352:43a6:7ddc with SMTP id
 x8-20020a0dd508000000b0035243a67ddcmr5144965ywd.55.1664336643109; Tue, 27 Sep
 2022 20:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220928002741.64237-1-kuniyu@amazon.com> <20220928002741.64237-4-kuniyu@amazon.com>
In-Reply-To: <20220928002741.64237-4-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 20:43:51 -0700
Message-ID: <CANn89iL00_Gz+jiczvmHPCV9nO7Lzctq_JLyp1V-0obuPWBanQ@mail.gmail.com>
Subject: Re: [PATCH v2 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 5:29 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Originally, inet6_sk(sk)->XXX were changed under lock_sock(), so we were
> able to clean them up by calling inet6_destroy_sock() during the IPv6 ->
> IPv4 conversion by IPV6_ADDRFORM.  However, commit 03485f2adcde ("udpv6:
> Add lockless sendmsg() support") added a lockless memory allocation path,
> which could cause a memory leak:
>
> setsockopt(IPV6_ADDRFORM)                 sendmsg()
> +-----------------------+                 +-------+
> - do_ipv6_setsockopt(sk, ...)             - udpv6_sendmsg(sk, ...)
>   - lock_sock(sk)                           ^._ called via udpv6_prot
>   - WRITE_ONCE(sk->sk_prot, &tcp_prot)          before WRITE_ONCE()
>   - inet6_destroy_sock()
>   - release_sock(sk)                        - ip6_make_skb(sk, ...)
>                                               ^._ lockless fast path for
>                                                   the non-corking case
>
>                                               - __ip6_append_data(sk, ...)
>                                                 - ipv6_local_rxpmtu(sk, ...)
>                                                   - xchg(&np->rxpmtu, skb)
>                                                     ^._ rxpmtu is never freed.
>
>                                             - lock_sock(sk)
>
> For now, rxpmtu is only the case, but let's call inet6_destroy_sock()
> in IPv6 sk->sk_destruct() not to miss the future change and a similar
> bug fixed in commit e27326009a3d ("net: ping6: Fix memleak in
> ipv6_renew_options().")

I do not see how your patches prevent rxpmtu to be created at the time
of IPV6_ADDRFROM ?

There seem to be races.

lockless UDP sendmsg() is a disaster really.

>
> We can now remove all inet6_destroy_sock() calls from IPv6 protocol
> specific ->destroy() functions, but such changes are invasive to
> backport.  So they can be posted as a follow-up later for net-next.
>
> Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/ipv6.h  |  1 +
>  include/net/udp.h   |  2 +-
>  net/ipv4/udp.c      |  8 ++++++--
>  net/ipv6/af_inet6.c |  9 ++++++++-
>  net/ipv6/udp.c      | 15 ++++++++++++++-
>  5 files changed, 30 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index de9dcc5652c4..11f1a9a8b066 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1178,6 +1178,7 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
>  void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
>  void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
>
> +void inet6_sock_destruct(struct sock *sk);
>  int inet6_release(struct socket *sock);
>  int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
>  int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 5ee88ddf79c3..fee053bcd17c 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -247,7 +247,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
>  }
>
>  /* net/ipv4/udp.c */
> -void udp_destruct_sock(struct sock *sk);
> +void udp_destruct_common(struct sock *sk);
>  void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len);
>  int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb);
>  void udp_skb_destructor(struct sock *sk, struct sk_buff *skb);
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 560d9eadeaa5..a84ae44db7e2 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1598,7 +1598,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
>
> -void udp_destruct_sock(struct sock *sk)
> +void udp_destruct_common(struct sock *sk)
>  {
>         /* reclaim completely the forward allocated memory */
>         struct udp_sock *up = udp_sk(sk);
> @@ -1611,10 +1611,14 @@ void udp_destruct_sock(struct sock *sk)
>                 kfree_skb(skb);
>         }
>         udp_rmem_release(sk, total, 0, true);
> +}
> +EXPORT_SYMBOL_GPL(udp_destruct_common);
>
> +static void udp_destruct_sock(struct sock *sk)
> +{
> +       udp_destruct_common(sk);
>         inet_sock_destruct(sk);
>  }
> -EXPORT_SYMBOL_GPL(udp_destruct_sock);
>
>  int udp_init_sock(struct sock *sk)
>  {
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index dbb1430d6cc2..0774cff62f2d 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -109,6 +109,13 @@ static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
>         return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
>  }
>
> +void inet6_sock_destruct(struct sock *sk)
> +{
> +       inet6_destroy_sock(sk);
> +       inet_sock_destruct(sk);
> +}
> +EXPORT_SYMBOL_GPL(inet6_sock_destruct);
> +
>  static int inet6_create(struct net *net, struct socket *sock, int protocol,
>                         int kern)
>  {
> @@ -201,7 +208,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
>                         inet->hdrincl = 1;
>         }
>
> -       sk->sk_destruct         = inet_sock_destruct;
> +       sk->sk_destruct         = inet6_sock_destruct;
>         sk->sk_family           = PF_INET6;
>         sk->sk_protocol         = protocol;
>
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 3366d6a77ff2..a5256f7184ab 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -56,6 +56,19 @@
>  #include <trace/events/skb.h>
>  #include "udp_impl.h"
>
> +static void udpv6_destruct_sock(struct sock *sk)
> +{
> +       udp_destruct_common(sk);
> +       inet6_sock_destruct(sk);
> +}
> +
> +static int udpv6_init_sock(struct sock *sk)
> +{
> +       skb_queue_head_init(&udp_sk(sk)->reader_queue);
> +       sk->sk_destruct = udpv6_destruct_sock;
> +       return 0;
> +}
> +
>  static u32 udp6_ehashfn(const struct net *net,
>                         const struct in6_addr *laddr,
>                         const u16 lport,
> @@ -1723,7 +1736,7 @@ struct proto udpv6_prot = {
>         .connect                = ip6_datagram_connect,
>         .disconnect             = udp_disconnect,
>         .ioctl                  = udp_ioctl,
> -       .init                   = udp_init_sock,
> +       .init                   = udpv6_init_sock,
>         .destroy                = udpv6_destroy_sock,
>         .setsockopt             = udpv6_setsockopt,
>         .getsockopt             = udpv6_getsockopt,
> --
> 2.30.2
>
