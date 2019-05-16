Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651451FE4D
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 06:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfEPEQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 00:16:03 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43390 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfEPEQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 00:16:03 -0400
Received: by mail-io1-f67.google.com with SMTP id v7so1445985iob.10
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 21:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QLiMXQioZ20aDL1JBasJ8pUI6TPP8CYeQvbRGTDRhe8=;
        b=NdEC5f4chTPvnhsVZla+hDSqZwcG8uPkxZ0aN7wepqW07VsBn8fDxQnaqGOaDPpr3A
         rpvZ2ffJQTbyOwtgyRjXFaveWVfvYMB5FL6NgVNBTUnbrsF1uNuSSnnLoq6UAVKOg/AG
         QIwCmBcFf6KeVNrPtGM0LyAxdLoga01n9+41VAelXrUfL/n9pFth/oXZX620O8EESQ+B
         EVy9kZXu7AvZyn5DPuz/ozqn5IfoemqFahprnrx6+uMFqk1lsy5DE9BfdCC04gKgYM5u
         0pWgGDbBRiQF6C39p3LKR+C9XOZnB0TZQRiJgRPxakMDdDNerOy/ewkSNsMZI1njkfU3
         eYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QLiMXQioZ20aDL1JBasJ8pUI6TPP8CYeQvbRGTDRhe8=;
        b=fgC7FGloAYGQq7TMO9IaIxw3wFR+ETHNlLzdiptSJYAv/xGKTXx7vncRCWjTYmJxVv
         GVEnhB0jABG5Ch++pMn0NdH5Q7khXzPES64fQhdL4F33bVlMV/BZxjZf2UjKl7501/Bo
         4KKkDR8F+lba+jYpNvRObIVvVaHg1zeH+UdTFeYUapWBxM8K8LPp/8ZdssNwfRt4LKBA
         OaXTTznyVslZPLjQtYUc5EchbYaG8p4Y3PoJxIUTsnICfcaLIdtrIK/Ssihtj2tp4ULl
         c5zY39yK/7EyEG8rsejI7azbdZzoXsN+QgfYyMgqFOrb4/Y8ReY5YjhaFwMIY+tn+8OR
         BApQ==
X-Gm-Message-State: APjAAAX9Hb5P3xrq6bnOITsH7AfZa+O6zoXd5c5W67tZ/zkqem9t84+C
        VGDsYasV14YynTkJ3tP//LGXMdY8EftVNwL1Ay6PGg==
X-Google-Smtp-Source: APXvYqx0FSBoongb7HVM5hlH7DU/UowbnN9FWN4cK5veK8zcrf4TeeJPr4K6ACXYcGN2Qvbr8ZK1YcW5ni4Dk4K7YwE=
X-Received: by 2002:a6b:d81a:: with SMTP id y26mr29917053iob.122.1557980162085;
 Wed, 15 May 2019 21:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190516023952.28943-1-edumazet@google.com>
In-Reply-To: <20190516023952.28943-1-edumazet@google.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 15 May 2019 21:15:50 -0700
Message-ID: <CAEA6p_CWuuQk0KxZ=yf+TuNdSUWq1zD0gtejUVyzczinBot8JA@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: prevent possible fib6 leaks
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@gmail.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 7:40 PM Eric Dumazet <edumazet@google.com> wrote:
>
> At ipv6 route dismantle, fib6_drop_pcpu_from() is responsible
> for finding all percpu routes and set their ->from pointer
> to NULL, so that fib6_ref can reach its expected value (1).
>
> The problem right now is that other cpus can still catch the
> route being deleted, since there is no rcu grace period
> between the route deletion and call to fib6_drop_pcpu_from()
>
> This can leak the fib6 and associated resources, since no
> notifier will take care of removing the last reference(s).
>
> I decided to add another boolean (fib6_destroying) instead
> of reusing/renaming exception_bucket_flushed to ease stable backports,
> and properly document the memory barriers used to implement this fix.
>
> This patch has been co-developped with Wei Wang.
>
> Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin Lau <kafai@fb.com>
> ---
Thanks for the fix Eric.

Acked-by: Wei Wang <weiwan@google.com>

>  include/net/ip6_fib.h |  3 ++-
>  net/ipv6/ip6_fib.c    | 12 +++++++++---
>  net/ipv6/route.c      |  7 +++++++
>  3 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
> index 40105738e2f6b8e37adac1ff46879ce6c09381b8..525f701653ca69596b941f5f3b4a438d634c4e6c 100644
> --- a/include/net/ip6_fib.h
> +++ b/include/net/ip6_fib.h
> @@ -167,7 +167,8 @@ struct fib6_info {
>                                         dst_nocount:1,
>                                         dst_nopolicy:1,
>                                         dst_host:1,
> -                                       unused:3;
> +                                       fib6_destroying:1,
> +                                       unused:2;
>
>         struct fib6_nh                  fib6_nh;
>         struct rcu_head                 rcu;
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 08e0390e001c270ae21013f3fd3ef3bf2a52e039..008421b550c6bfd449665aa5e7ba5505fcabe53d 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -904,6 +904,12 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
>  {
>         int cpu;
>
> +       /* Make sure rt6_make_pcpu_route() wont add other percpu routes
> +        * while we are cleaning them here.
> +        */
> +       f6i->fib6_destroying = 1;
> +       mb(); /* paired with the cmpxchg() in rt6_make_pcpu_route() */
> +
>         /* release the reference to this fib entry from
>          * all of its cached pcpu routes
>          */
> @@ -927,6 +933,9 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
>  {
>         struct fib6_table *table = rt->fib6_table;
>
> +       if (rt->rt6i_pcpu)
> +               fib6_drop_pcpu_from(rt, table);
> +
>         if (refcount_read(&rt->fib6_ref) != 1) {
>                 /* This route is used as dummy address holder in some split
>                  * nodes. It is not leaked, but it still holds other resources,
> @@ -948,9 +957,6 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
>                         fn = rcu_dereference_protected(fn->parent,
>                                     lockdep_is_held(&table->tb6_lock));
>                 }
> -
> -               if (rt->rt6i_pcpu)
> -                       fib6_drop_pcpu_from(rt, table);
>         }
>  }
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 23a20d62daac29e3252725b8cf95d1d1c2b567c4..27c0cc5d9d30e3689ebe6b8428cd4c586669d808 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1295,6 +1295,13 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
>         prev = cmpxchg(p, NULL, pcpu_rt);
>         BUG_ON(prev);
>
> +       if (res->f6i->fib6_destroying) {
> +               struct fib6_info *from;
> +
> +               from = xchg((__force struct fib6_info **)&pcpu_rt->from, NULL);
> +               fib6_info_release(from);
> +       }
> +
>         return pcpu_rt;
>  }
>
> --
> 2.21.0.1020.gf2820cf01a-goog
>
