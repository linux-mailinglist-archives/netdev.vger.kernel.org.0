Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1F4A610A
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 17:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbiBAQLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 11:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240802AbiBAQLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 11:11:19 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB89C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 08:11:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b13so35563010edn.0
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 08:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r72ipMSsw585C/2Ak7zqzoxsFblCJRuLe89NXnXj3nE=;
        b=oeELatbZwXdmHmH40WvUNgJCxyD/wZQJVZbMj8PqZbXGpWl/S7uboXRH7EDJ8igz6X
         sZ8giAeVkYfOol1mG7aagGqY9H4K6QJjWHAMrb/LU3FdtD0mXt1LKVmuQAC+9iC03hws
         IB0UM86ooX7Sp3ZHgrAp8eix3ju1WYYuOywvAcvdXxZk/wzyqqaINUxqwKqj4Gd7xH34
         PhE9DytwpMo/U6R+jimOYS/WeWDdaW40XP2/gXvPI3Sdpcfdv521/l8DAzJiQOIVTfHS
         TOrsU+1jYHVyfxsE8bdyj25qvzTQXJyuXRKjFw9kXOBzB0Ha3NImTv5ly6OG0svOKvVX
         A5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r72ipMSsw585C/2Ak7zqzoxsFblCJRuLe89NXnXj3nE=;
        b=p2lqu7MZ0RbfD/NQRb6Xo+RaGS0sGDT+CfOgMK//FyX8zT4iIOclWerfsRvOrlOxlY
         y57zbgFgqLQUJ855tKWSYzOv6ANQxxB+EsPo8/IlZyxp/ErcZoN9RRcemg7KQUIriKtn
         qdVQPoxNuMxs6Kb/f4Z+RubE4+UwLtLf/Dksy2uTkpdSv6wX+bCPolaf19HPjVoT4Gvr
         02HUP8BAKw9/wHN6z4HYN/MqyciP7MV1Nd25W0LLjRFvTD1zc6NujjPpBhHO9RTbCUwO
         sMvlOCFBAP8zW8d9w4n8iOs2yGU74iz+omttVjt84pjMQR7/50FAm2dHlW3RtINoKFlN
         4fnQ==
X-Gm-Message-State: AOAM5338cPSAYn39whjrUGV1VycUtHYW7cGjh9PozmDG9PmdsWuf3dhb
        Hk+T0En+lZJsQ6FzS3Vzr17C7ZjxLaBqnjDZy1UnhQ==
X-Google-Smtp-Source: ABdhPJyiKCwvKgDnktp5gf1G1nmb4zd44sF0WRj/TZfazLlsytd+QHNFrCpxH8w6G4+e/QAhd8Og0zxDgUmvelX9ThY=
X-Received: by 2002:a05:6402:5ca:: with SMTP id n10mr26114193edx.341.1643731877182;
 Tue, 01 Feb 2022 08:11:17 -0800 (PST)
MIME-Version: 1.0
References: <20220201065254.680532-1-eric.dumazet@gmail.com>
In-Reply-To: <20220201065254.680532-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 1 Feb 2022 11:10:40 -0500
Message-ID: <CACSApvbwWH2LQPKSU9Re2WFbO2ERCCEkN0LphO808XMCMfW6ig@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix mem under-charging with zerocopy sendmsg()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 1:53 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> We got reports of following warning in inet_sock_destruct()
>
>         WARN_ON(sk_forward_alloc_get(sk));
>
> Whenever we add a non zero-copy fragment to a pure zerocopy skb,
> we have to anticipate that whole skb->truesize will be uncharged
> when skb is finally freed.
>
> skb->data_len is the payload length. But the memory truesize
> estimated by __zerocopy_sg_from_iter() is page aligned.
>
> Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Talal Ahmad <talalahmad@google.com>
> Cc: Arjun Roy <arjunroy@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Willem de Bruijn <willemb@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice catch! and thank you for the fix!


> ---
>  net/ipv4/tcp.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 78e81465f5f3632f54093495d2f2a064e60c7237..bdf108f544a45a2aa24bc962fb81dfd0ca1e0682 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1322,10 +1322,13 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>
>                         /* skb changing from pure zc to mixed, must charge zc */
>                         if (unlikely(skb_zcopy_pure(skb))) {
> -                               if (!sk_wmem_schedule(sk, skb->data_len))
> +                               u32 extra = skb->truesize -
> +                                           SKB_TRUESIZE(skb_end_offset(skb));
> +
> +                               if (!sk_wmem_schedule(sk, extra))
>                                         goto wait_for_space;
>
> -                               sk_mem_charge(sk, skb->data_len);
> +                               sk_mem_charge(sk, extra);
>                                 skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
>                         }
>
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
