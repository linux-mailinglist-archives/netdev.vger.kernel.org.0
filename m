Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097845471AD
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 05:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiFKDpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 23:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiFKDpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 23:45:32 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB90A192
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 20:45:30 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id s12so1397311ejx.3
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 20:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GKajT/mF2nWek0G8DoEp6SQcDRqRwnNb+72MDCUVYv4=;
        b=iGGjZE/UHOGcpX7ZF3/xnUxeWDDxvWPxcjp6S+K6zDsmFhr2AAiYvLDFhDa2gHG44K
         xs78pP4wVTHNa4x2HSh08wyEamaw3q6ph0kBwBRaN67b7AHaGJPt53mFAomX+AO574gV
         W5Dx9rLbmtsTdHHe3QKUYQQldVonrWYYdCqWjGsZAR1IKl44s5v+rRta76BEUuO5q4+u
         +PnVI/CPQVh+roKWXn2MDvj/5d0oBao46WnZ4YuauEdJTJZD1BdKGZzDiwEh/o97niJ4
         zsC5AMIG7jEXtGlWBjRCyOwWfY/Hk4SkPNilFe6F12mMi4tZ7gDoJ5nrqIpfObh2ISb8
         pagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GKajT/mF2nWek0G8DoEp6SQcDRqRwnNb+72MDCUVYv4=;
        b=AZZBEGHFhMNS/mjL7Pxr3iAllDgLlkg+ES2ogv7BXI0Xod2REXLQS3h+vHOWEdgjsk
         dwRGXHpKBFvyDjsPpdfC+4TedXgsNymR8V5A5n/sjqGXuugNIgjKtloQJDBLSW9VKXGF
         RxuZm9JjhgZSK2RogzydpkFIXQoq+Q5KYfm2RGEm/T3bkjj8+EQLfKFbwIVDxOPwl+ul
         RalipJvLJNezLzzF8sL93gZO5fZi1krHH0d8/kBDzm4nV3N0Vp0w4MFpJt75pYLCu5NP
         UMXj5SSnfHRhbSiohN2eA8N96pi/F0VqaOTR0GjRf4kOStIaDSAxDFgShzv88r+moDOv
         08Fw==
X-Gm-Message-State: AOAM5302aLIxKZZFip8lOM6qjOEsrIvm+yXqGufnYWOL6aeQfNXCB134
        jA4hQbpcFpGt12q9+cIoelFLf8r6eEQ0dNiaXRd9t+q+SM6VXtXJ
X-Google-Smtp-Source: ABdhPJwXflEAsMRLmBWRgLJ/doPhUgXqzHuhNYAb/Uv04JAjVImJUKEsn2RGTWWaiVwQsUNzhbO4hEtvxr9pEDUJ0no=
X-Received: by 2002:a17:906:b048:b0:6fe:be4a:3ecf with SMTP id
 bj8-20020a170906b04800b006febe4a3ecfmr43543790ejb.104.1654919128910; Fri, 10
 Jun 2022 20:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220611033016.3697610-1-eric.dumazet@gmail.com>
In-Reply-To: <20220611033016.3697610-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 10 Jun 2022 23:44:52 -0400
Message-ID: <CACSApvaK=YFk=A8=YaRUoJF4yyNo03fSg9JCAqm7HNp2Wc7Cvg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: sk_forced_mem_schedule() optimization
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

On Fri, Jun 10, 2022 at 11:30 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> sk_memory_allocated_add() has three callers, and returns
> to them @memory_allocated.
>
> sk_forced_mem_schedule() is one of them, and ignores
> the returned value.
>
> Change sk_memory_allocated_add() to return void.
>
> Change sock_reserve_memory() and __sk_mem_raise_allocated()
> to call sk_memory_allocated().
>
> This removes one cache line miss [1] for RPC workloads,
> as first skbs in TCP write queue and receive queue go through
> sk_forced_mem_schedule().
>
> [1] Cache line holding tcp_memory_allocated.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice find!

> ---
>  include/net/sock.h | 3 +--
>  net/core/sock.c    | 9 ++++++---
>  2 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 0063e8410a4e3ed91aef9cf34eb1127f7ce33b93..304a5e39d41e27105148058066e8fa23490cf9fa 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1412,7 +1412,7 @@ sk_memory_allocated(const struct sock *sk)
>  /* 1 MB per cpu, in page units */
>  #define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
>
> -static inline long
> +static inline void
>  sk_memory_allocated_add(struct sock *sk, int amt)
>  {
>         int local_reserve;
> @@ -1424,7 +1424,6 @@ sk_memory_allocated_add(struct sock *sk, int amt)
>                 atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
>         }
>         preempt_enable();
> -       return sk_memory_allocated(sk);
>  }
>
>  static inline void
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 697d5c8e2f0def49351a7d38ec59ab5e875d3b10..92a0296ccb1842f11fb8dd4b2f768885d05daa8f 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1019,7 +1019,8 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
>                 return -ENOMEM;
>
>         /* pre-charge to forward_alloc */
> -       allocated = sk_memory_allocated_add(sk, pages);
> +       sk_memory_allocated_add(sk, pages);
> +       allocated = sk_memory_allocated(sk);
>         /* If the system goes into memory pressure with this
>          * precharge, give up and return error.
>          */
> @@ -2906,11 +2907,13 @@ EXPORT_SYMBOL(sk_wait_data);
>   */
>  int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>  {
> -       struct proto *prot = sk->sk_prot;
> -       long allocated = sk_memory_allocated_add(sk, amt);
>         bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
> +       struct proto *prot = sk->sk_prot;
>         bool charged = true;
> +       long allocated;
>
> +       sk_memory_allocated_add(sk, amt);
> +       allocated = sk_memory_allocated(sk);
>         if (memcg_charge &&
>             !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
>                                                 gfp_memcg_charge())))
> --
> 2.36.1.476.g0c4daa206d-goog
>
