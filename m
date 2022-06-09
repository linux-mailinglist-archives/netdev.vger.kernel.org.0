Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088B1544DC5
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 15:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343850AbiFINeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 09:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343868AbiFINeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 09:34:08 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FDB1CBD36
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 06:34:03 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id m20so47439393ejj.10
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 06:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UFII/jdXXyENaS5LitNP6gQfMz9dvbF0Rf4bByE/gqw=;
        b=BdutLhQBGO2dz7dbHPmsm/bqhPRRDUi9OoedkwN7il5pj5WHrXEmIKpY3xzuuEbPSa
         I+ZqSxg+5HjJv9+hhB0n+p7bGwJdA+h1xcIaD0i21d2/0hHJstmUig+qtO/xrMEhyEoX
         +Usl6qN24HIMxYR2vDyma3y3dIF4uHuWRw5w4OhL36fu3EIHXBrqG3WO1LW7BSgHYf9E
         xssbMfvi+VK49bgNk1ZqJvXpRstXA67JBwb7r9wWX65wjqCQ9pw+clb/ist99nSuJSSI
         d8ECGoiP/I/3ZzD+oTJ7fPG3OLBmhT0tzULSutiQ/iwf1gM2RAzqnExj7sq8XqeghB+1
         0KrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UFII/jdXXyENaS5LitNP6gQfMz9dvbF0Rf4bByE/gqw=;
        b=OJGG4ZGh2GmBjuN71rxcQwuXdKEOtKEImHxhddDl+5mtW6ukGCO8s0guy3hh+u+ahy
         JRKkygjOpmxh7CtPOwVmkM2tELzoOpc9WKv6WCXLKyCL9b08Ce2d6TLrb2zJJbX1XVyA
         fIQQghgwKOLuFqH/SrjNg2Q38qQk/oCczUb8wWZBAbHFNY0FgVAUe9Q9jqjyRH6AzkZH
         fgLJJ3qtodu5fLMSmWjT6qFPaGuYuyLR+lgh6RoK+hx8dTxX/20uB4AE6ucqGFEZ+6SQ
         aJOrhfB9MRHgjzhHczpw2t2auTqynfGaShpQvATVgfUm7qEC9RysPa+xvbpG+YkqtId7
         Tq+Q==
X-Gm-Message-State: AOAM533OsmwcLgk5u/HXaPWWd+Ge18MHN0/fP+KIPLR3THx+KfFWygcj
        Iv0YKD++eUZStAYpRgOY405OIeQmKAZYJKMaNoGD6g==
X-Google-Smtp-Source: ABdhPJzm3yBYRjOKMq389bsu2aYAcYYVUWbxHQPBZJKRIfh1bSyyW6JdTFEA2AI/NUcF8BX6VJtH3J8A0zr4qSY4egY=
X-Received: by 2002:a17:907:ea9:b0:710:9003:9b33 with SMTP id
 ho41-20020a1709070ea900b0071090039b33mr25046575ejc.175.1654781641888; Thu, 09
 Jun 2022 06:34:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-5-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-5-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 9 Jun 2022 09:33:25 -0400
Message-ID: <CACSApvYEwczGVvOxOfDXNHd_x5LDb1vXT03y-=6CcrTv1uR9Kw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
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

On Thu, Jun 9, 2022 at 2:34 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> We plan keeping sk->sk_forward_alloc as small as possible
> in future patches.
>
> This means we are going to call sk_memory_allocated_add()
> and sk_memory_allocated_sub() more often.
>
> Implement a per-cpu cache of +1/-1 MB, to reduce number
> of changes to sk->sk_prot->memory_allocated, which
> would otherwise be cause of false sharing.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  include/net/sock.h | 38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 825f8cbf791f02d798f17dd4f7a2659cebb0e98a..59040fee74e7de8d63fbf719f46e172906c134bb 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1397,22 +1397,48 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
>         return !!*sk->sk_prot->memory_pressure;
>  }
>
> +static inline long
> +proto_memory_allocated(const struct proto *prot)
> +{
> +       return max(0L, atomic_long_read(prot->memory_allocated));
> +}
> +
>  static inline long
>  sk_memory_allocated(const struct sock *sk)
>  {
> -       return atomic_long_read(sk->sk_prot->memory_allocated);
> +       return proto_memory_allocated(sk->sk_prot);
>  }
>
> +/* 1 MB per cpu, in page units */
> +#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
> +
>  static inline long
>  sk_memory_allocated_add(struct sock *sk, int amt)
>  {
> -       return atomic_long_add_return(amt, sk->sk_prot->memory_allocated);
> +       int local_reserve;
> +
> +       preempt_disable();
> +       local_reserve = __this_cpu_add_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> +       if (local_reserve >= SK_MEMORY_PCPU_RESERVE) {
> +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);

This is just a nitpick, but we could
__this_cpu_write(*sk->sk_prot->per_cpu_fw_alloc, 0) instead which
should be slightly faster.

> +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> +       }
> +       preempt_enable();
> +       return sk_memory_allocated(sk);
>  }
>
>  static inline void
>  sk_memory_allocated_sub(struct sock *sk, int amt)
>  {
> -       atomic_long_sub(amt, sk->sk_prot->memory_allocated);
> +       int local_reserve;
> +
> +       preempt_disable();
> +       local_reserve = __this_cpu_sub_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
> +       if (local_reserve <= -SK_MEMORY_PCPU_RESERVE) {
> +               __this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
> +               atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
> +       }
> +       preempt_enable();
>  }
>
>  #define SK_ALLOC_PERCPU_COUNTER_BATCH 16
> @@ -1441,12 +1467,6 @@ proto_sockets_allocated_sum_positive(struct proto *prot)
>         return percpu_counter_sum_positive(prot->sockets_allocated);
>  }
>
> -static inline long
> -proto_memory_allocated(struct proto *prot)
> -{
> -       return atomic_long_read(prot->memory_allocated);
> -}
> -
>  static inline bool
>  proto_memory_pressure(struct proto *prot)
>  {
> --
> 2.36.1.255.ge46751e96f-goog
>
