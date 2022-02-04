Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C67A4A9B1F
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359353AbiBDOkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiBDOkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 09:40:03 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC588C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 06:40:02 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id k25so19904398ejp.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 06:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PDL+z4vxYSErLxS9pLlkxiGGYXAj9CtEidy70eutPpM=;
        b=PrzECi/O/qMj0kN4dMM42fvZJeEooBzZ0fO5iJxpqjgMRRWcq0ICYWM38+P/ndikX5
         qfyNYihUAC/s72OYagc9ErIkqc6d1z6WOWwEhM+dE590hOZ8hwk0l2Pbx7lAhEfHqFhV
         Jm8kej+dR83w3km17l2jP3BMYrqf6SMDVbo2gvanYDvUl5rBydY5CaWCRGmi27ISsScc
         LgNBbhXt79Yxh4P8OWCIvF88p1jHPVZc0Cg2S8pWhTU4IxmkRLGodcmkSSZeyIuTeAnR
         jI9sTHOdfFJF6xbL4O4qgpbT7+QqU7MDvVXefc3/P2k4rijr9WT1rezQNEiwZybg9spV
         pGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PDL+z4vxYSErLxS9pLlkxiGGYXAj9CtEidy70eutPpM=;
        b=BDQoCHsc3P5MsAo6qBLDqPzGAAq1593Wmx7r38RbnKxMIaKl8+GpzXVDkEIu6JpkJQ
         i5SPD746HJknco66XkHDhcZzGVKsOIVU2fRvLifrRDgjqJyPZfsRG+QG52PT5VN78+fS
         ThAIqwSnu7mklb6inrskjcUL4YNblASPuUlPGA9vybjcuNglvds26KfOfA3iXcSZ4ugH
         waa47o92SQVuw+wR8xfwNAYfN8bl1YpSISIFgztDblrIWrBz/cYFmENmDBGY8fxOsikl
         4IFH1ACap7FwgM6iHSZc7DeqV2RRhd7G5FoWWCmIuSkYCdH6YPJW2ItJ1IUI1TW4qrtv
         V2Sg==
X-Gm-Message-State: AOAM532nxdyHoM+MYuzeEibbVZMjxbu+mNn/8BQ8DH/1WvRijCzfgVUQ
        6hfnnj82w3YpuSgcqwXszQuCKlpr6CBNF0SECn7SEw==
X-Google-Smtp-Source: ABdhPJxA2mBW2ydQkuVDZGC+F0bIn4KCkrFgMDPZ3CNzVdEeE1xKWEs9qkk8nXzs8CSphN/CsUPaikSwgJkSxhIZeJo=
X-Received: by 2002:a17:906:c110:: with SMTP id do16mr2757518ejc.175.1643985600816;
 Fri, 04 Feb 2022 06:40:00 -0800 (PST)
MIME-Version: 1.0
References: <20220203225547.665114-1-eric.dumazet@gmail.com>
In-Reply-To: <20220203225547.665114-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 4 Feb 2022 09:39:24 -0500
Message-ID: <CACSApvZomRy2VXrcRWbfk5sxxW9L+rwK7+TUCZxUWbmXWFH2VQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: take care of mixed splice()/sendmsg(MSG_ZEROCOPY)
 case
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 5:55 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> syzbot found that mixing sendpage() and sendmsg(MSG_ZEROCOPY)
> calls over the same TCP socket would again trigger the
> infamous warning in inet_sock_destruct()
>
>         WARN_ON(sk_forward_alloc_get(sk));
>
> While Talal took into account a mix of regular copied data
> and MSG_ZEROCOPY one in the same skb, the sendpage() path
> has been forgotten.
>
> We want the charging to happen for sendpage(), because
> pages could be coming from a pipe. What is missing is the
> downgrading of pure zerocopy status to make sure
> sk_forward_alloc will stay synced.
>
> Add tcp_downgrade_zcopy_pure() helper so that we can
> use it from the two callers.
>
> Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Talal Ahmad <talalahmad@google.com>
> Cc: Arjun Roy <arjunroy@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice catch!

> ---
>  net/ipv4/tcp.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index bdf108f544a45a2aa24bc962fb81dfd0ca1e0682..e1f259da988df7493ce7d71ad8743ec5025e4e7c 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -937,6 +937,22 @@ void tcp_remove_empty_skb(struct sock *sk)
>         }
>  }
>
> +/* skb changing from pure zc to mixed, must charge zc */
> +static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
> +{
> +       if (unlikely(skb_zcopy_pure(skb))) {
> +               u32 extra = skb->truesize -
> +                           SKB_TRUESIZE(skb_end_offset(skb));
> +
> +               if (!sk_wmem_schedule(sk, extra))
> +                       return ENOMEM;
> +
> +               sk_mem_charge(sk, extra);
> +               skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
> +       }
> +       return 0;
> +}
> +
>  static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>                                       struct page *page, int offset, size_t *size)
>  {
> @@ -972,7 +988,7 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
>                 tcp_mark_push(tp, skb);
>                 goto new_segment;
>         }
> -       if (!sk_wmem_schedule(sk, copy))
> +       if (tcp_downgrade_zcopy_pure(sk, skb) || !sk_wmem_schedule(sk, copy))
>                 return NULL;
>
>         if (can_coalesce) {
> @@ -1320,19 +1336,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>
>                         copy = min_t(int, copy, pfrag->size - pfrag->offset);
>
> -                       /* skb changing from pure zc to mixed, must charge zc */
> -                       if (unlikely(skb_zcopy_pure(skb))) {
> -                               u32 extra = skb->truesize -
> -                                           SKB_TRUESIZE(skb_end_offset(skb));
> -
> -                               if (!sk_wmem_schedule(sk, extra))
> -                                       goto wait_for_space;
> -
> -                               sk_mem_charge(sk, extra);
> -                               skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
> -                       }
> -
> -                       if (!sk_wmem_schedule(sk, copy))
> +                       if (tcp_downgrade_zcopy_pure(sk, skb) ||
> +                           !sk_wmem_schedule(sk, copy))
>                                 goto wait_for_space;
>
>                         err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
> --
> 2.35.0.263.gb82422642f-goog
>
