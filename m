Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482B054B7DE
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbiFNRm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237116AbiFNRm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:42:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EF330551
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:42:54 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g7so12688397eda.3
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZ7uNZbC9+yTZfOF+S8H5P/tTA3aEEJiibgzduYZ1vA=;
        b=BYge5D4McgiBwmwrgBIx8/EHu5aSGUoM6CstHrAmF3gnxKC64QZ7idYTfbItE5lQ7Y
         U7rm6acQNKbtXuPEfHQPiahxNS8vH3yejj6QQUxWmHQm4+TprUSWKXexyXg9iFB+f8JG
         vDVbGQBvbTwrk5kgWkiwTiO+zcdFWsU9KwIuPs8RYAf5KgDQ4FeTyhFSVGj/UAauuMLq
         4lLkK1RFNU2u85U+0nZJzJB4tIVZfZXebv5My5Lc5839hpN/PtUXA3gH/w2raBElalyr
         xw3r0SjNg8CykhYI3JCQvAzwQu/e4LJVnobx3d7KSd5IEKbCCORw26zJuD+ypKsqtoRH
         jCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZ7uNZbC9+yTZfOF+S8H5P/tTA3aEEJiibgzduYZ1vA=;
        b=qnCxVLAGxRsMgnHTGDrigOZNQBDOyO6qtalsP4Brx4v3PZh/vy+J9qniJnVnN1F6X6
         4IrwgMjHZH2gSoAMky3bcN4rjOqzVM4ck/fg+3VIzDTK0PRO3sFXYfwoQMI12qsyKt3q
         AyTu8YG+G4Ds7ezFXbWmfLRFaGe/QQdvjHkLX1YOiVJZCYUKTuokZDS6Ms1vNZkG70ni
         rVhPX0kHaB5qnkDdy9LPW8/ZDu5hE647EMuicMgz5DQic2bBpiP179lYp4ftyVjf7iON
         dRK5sBvGU75Mxy1+Yfva/5b5ZDfqpKvXO/sS1dCdYtRfIVXExRZP1RP7HnMM3X9q2mKO
         xYKw==
X-Gm-Message-State: AOAM532kadGViE/wCG/GPYE5O5qAQxBqv90iiW3ZnqRXj46dNANdxB7M
        RQLbTnLKlq5wBMTlXCrY5CU+FF4OTv2JUr0txChLqQ==
X-Google-Smtp-Source: ABdhPJzPiAlsDcslpkAhkQD4alYPIyUhs5Lo0RwNomNtUMqIvl72zCQWVkCkNhUJDkPzbShymgeToVWC1Q6gcPYIRvE=
X-Received: by 2002:a05:6402:847:b0:42d:91ed:82f3 with SMTP id
 b7-20020a056402084700b0042d91ed82f3mr7699672edz.416.1655228572327; Tue, 14
 Jun 2022 10:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com> <20220614171734.1103875-3-eric.dumazet@gmail.com>
In-Reply-To: <20220614171734.1103875-3-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 14 Jun 2022 13:42:15 -0400
Message-ID: <CACSApvZPx8G8+TaZbxqS19M8tmBmcSq4uGtQskGxD=dGwm7T3A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] tcp: fix possible freeze in tx path under
 memory pressure
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 1:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Blamed commit only dealt with applications issuing small writes.
>
> Issue here is that we allow to force memory schedule for the sk_buff
> allocation, but we have no guarantee that sendmsg() is able to
> copy some payload in it.
>
> In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.
>
> For example, if we consider tcp_wmem[0] = 4096 (default on x86),
> and initial skb->truesize being 1280, tcp_sendmsg() is able to
> copy up to 2816 bytes under memory pressure.
>
> Before this patch a sendmsg() sending more than 2816 bytes
> would either block forever (if persistent memory pressure),
> or return -EAGAIN.
>
> For bigger MTU networks, it is advised to increase tcp_wmem[0]
> to avoid sending too small packets.
>
> v2: deal with zero copy paths.
>
> Fixes: 8e4d980ac215 ("tcp: fix behavior for epoll edge trigger")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Very nice find! Thank you!

> ---
>  net/ipv4/tcp.c | 33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 14ebb4ec4a51f3c55501aa53423ce897599e8637..56083c2497f0b695c660256aa43f8a743d481697 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -951,6 +951,23 @@ static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
>         return 0;
>  }
>
> +static int tcp_wmem_schedule(struct sock *sk, int copy)
> +{
> +       int left;
> +
> +       if (likely(sk_wmem_schedule(sk, copy)))
> +               return copy;
> +
> +       /* We could be in trouble if we have nothing queued.
> +        * Use whatever is left in sk->sk_forward_alloc and tcp_wmem[0]
> +        * to guarantee some progress.
> +        */
> +       left = sock_net(sk)->ipv4.sysctl_tcp_wmem[0] - sk->sk_wmem_queued;
> +       if (left > 0)
> +               sk_forced_mem_schedule(sk, min(left, copy));
> +       return min(copy, sk->sk_forward_alloc);
> +}
> +
>  static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>                                       struct page *page, int offset, size_t *size)
>  {
> @@ -986,7 +1003,11 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>                 tcp_mark_push(tp, skb);
>                 goto new_segment;
>         }
> -       if (tcp_downgrade_zcopy_pure(sk, skb) || !sk_wmem_schedule(sk, copy))
> +       if (tcp_downgrade_zcopy_pure(sk, skb))
> +               return NULL;
> +
> +       copy = tcp_wmem_schedule(sk, copy);
> +       if (!copy)
>                 return NULL;
>
>         if (can_coalesce) {
> @@ -1334,8 +1355,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>
>                         copy = min_t(int, copy, pfrag->size - pfrag->offset);
>
> -                       if (tcp_downgrade_zcopy_pure(sk, skb) ||
> -                           !sk_wmem_schedule(sk, copy))
> +                       if (tcp_downgrade_zcopy_pure(sk, skb))
> +                               goto wait_for_space;
> +
> +                       copy = tcp_wmem_schedule(sk, copy);
> +                       if (!copy)
>                                 goto wait_for_space;
>
>                         err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
> @@ -1362,7 +1386,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                                 skb_shinfo(skb)->flags |= SKBFL_PURE_ZEROCOPY;
>
>                         if (!skb_zcopy_pure(skb)) {
> -                               if (!sk_wmem_schedule(sk, copy))
> +                               copy = tcp_wmem_schedule(sk, copy);
> +                               if (!copy)
>                                         goto wait_for_space;
>                         }
>
> --
> 2.36.1.476.g0c4daa206d-goog
>
