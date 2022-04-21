Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6319B50A449
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390119AbiDUPfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiDUPfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:35:32 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D766EB85C
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 08:32:42 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2edbd522c21so55830697b3.13
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 08:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jar6sfpOgdWusYd79O/dOND2V4EqrDxlzqTKtAI4nHo=;
        b=BzdsLw0e+lIkr2rxKdj6CXog7QqngoW0Zj4s1QEeCSPlD12T/RFWJWJ0M8w0DgDDI3
         oXBwU7yzTOuCEOIw6VFdkwlBppVfsE0kjzDWjfOxZfe1n6eTJGGem0armlc4ypHv6ZDf
         h2cnxiPQRwgHJ6XZqhNLMwOorZDcVOERf0hwMZtmzAwu5yqHs9htv2OKnu/qgU3vkyhw
         7lwvrVLSIcM9wQ/6K3cCvQ2BhtRt+3P3pXAsdQgJz4Ygp/drpkLrlZ1/WIbDB+hZEY4u
         /2vJsUMrvk/3gEeKTRf4Ct3T7J5zdVENRen6QNOY0M/3gxpyaCyAHcsi8QXNW2vwitv0
         60QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jar6sfpOgdWusYd79O/dOND2V4EqrDxlzqTKtAI4nHo=;
        b=4kyOy6qEnefD3pdbQBvSbZkFB0rOxqDo+cOr/KoB7vcLz2UIJ/fDKvyrL2f2jF5tcl
         wNKxO4PRx3sQnCGGPO9O+rpKlSBKj/5Y1VgVUNwrOOJp2huXnKVPTBku8PccgifDrkLY
         yF1uWrwn8Ju27tU27eeSyHV6efAAv7OJvPUJKbTC7h4pLo7N7wEV/9YdIu5EsN4w5n7C
         8kXE8TziFSxl6Qgzw8upyjR46QnPlNlzOQXXYNmKrRtdWdkQFoi35p9XFlOhik5C7wOp
         0LeRZm0NOhw/3w96sfgdf0pOoi6TRosBe7uGP7yjMLhE5zz5ia/6TXlqOSJ3chqbeD/E
         +RrQ==
X-Gm-Message-State: AOAM532FhIOfCu0VM0YBeif8xXgqfodYIXx5aFvLnQxA9Tq3aPL7KK2b
        Ckd4A+y3dP0wfqxVN6ALtjgaX6hUXOigAX+BHr3+lA==
X-Google-Smtp-Source: ABdhPJwn2RZJaZqI37hACCGI17pw+HK2aLpcm4Cuen+s7QrwQLu4RQxeWbqoq9SqEUtdTNYzCQu5LG2gw/Ox2HvFy8c=
X-Received: by 2002:a0d:cb07:0:b0:2f1:c718:b273 with SMTP id
 n7-20020a0dcb07000000b002f1c718b273mr171328ywd.467.1650555161702; Thu, 21 Apr
 2022 08:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <YmFjdOp+R5gVGZ7p@linutronix.de>
In-Reply-To: <YmFjdOp+R5gVGZ7p@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Apr 2022 08:32:30 -0700
Message-ID: <CANn89i+0u=DmAd1_vv-vJsJ53L2y6v7pvvTgrVN9D=rGo9-ifA@mail.gmail.com>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
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

On Thu, Apr 21, 2022 at 7:00 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The macro dev_core_stats_##FIELD##_inc() disables preemption and invokes
> netdev_core_stats_alloc() to return a per-CPU pointer.
> netdev_core_stats_alloc() will allocate memory on its first invocation
> which breaks on PREEMPT_RT because it requires non-atomic context for
> memory allocation.

Can you elaborate on this, I am confused ?

You are saying that on PREEMPT_RT, we can not call
alloc_percpu_gfp(XXX, GFP_ATOMIC | __GFP_NOWARN);
under some contexts ?

preemption might be disabled by callers of net->core_stats anyways...


>
> This can be avoided by enabling preemption in netdev_core_stats_alloc()
> assuming the caller always disables preemption.
>
> It might be better to replace local_inc() with this_cpu_inc() now that
> dev_core_stats_##FIELD##_inc() gained a preempt-disable section and does
> not rely on already disabled preemption. This results in less
> instructions on x86-64:
> local_inc:
> |          incl %gs:__preempt_count(%rip)  # __preempt_count
> |          movq    488(%rdi), %rax # _1->core_stats, _22
> |          testq   %rax, %rax      # _22
> |          je      .L585   #,
> |          add %gs:this_cpu_off(%rip), %rax        # this_cpu_off, tcp_ptr__
> |  .L586:
> |          testq   %rax, %rax      # _27
> |          je      .L587   #,
> |          incq (%rax)            # _6->a.counter
> |  .L587:
> |          decl %gs:__preempt_count(%rip)  # __preempt_count
>
> this_cpu_inc(), this patch:
> |         movq    488(%rdi), %rax # _1->core_stats, _5
> |         testq   %rax, %rax      # _5
> |         je      .L591   #,
> | .L585:
> |         incq %gs:(%rax) # _18->rx_dropped
>
> Use unsigned long as type for the counter. Use this_cpu_inc() to
> increment the counter. Use a plain read of the counter.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  include/linux/netdevice.h | 17 +++++++----------
>  net/core/dev.c            | 14 +++++---------
>  2 files changed, 12 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 59e27a2b7bf04..0009112b23767 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -199,10 +199,10 @@ struct net_device_stats {
>   * Try to fit them in a single cache line, for dev_get_stats() sake.
>   */
>  struct net_device_core_stats {
> -       local_t         rx_dropped;
> -       local_t         tx_dropped;
> -       local_t         rx_nohandler;
> -} __aligned(4 * sizeof(local_t));
> +       unsigned long   rx_dropped;
> +       unsigned long   tx_dropped;
> +       unsigned long   rx_nohandler;
> +} __aligned(4 * sizeof(unsigned long));
>
>  #include <linux/cache.h>
>  #include <linux/skbuff.h>
> @@ -3843,7 +3843,7 @@ static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
>         return false;
>  }
>
> -struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev);
> +struct net_device_core_stats __percpu *netdev_core_stats_alloc(struct net_device *dev);
>
>  static inline struct net_device_core_stats *dev_core_stats(struct net_device *dev)
>  {
> @@ -3851,7 +3851,7 @@ static inline struct net_device_core_stats *dev_core_stats(struct net_device *de
>         struct net_device_core_stats __percpu *p = READ_ONCE(dev->core_stats);
>
>         if (likely(p))
> -               return this_cpu_ptr(p);
> +               return p;
>
>         return netdev_core_stats_alloc(dev);
>  }
> @@ -3861,12 +3861,9 @@ static inline void dev_core_stats_##FIELD##_inc(struct net_device *dev)          \
>  {                                                                              \
>         struct net_device_core_stats *p;                                        \
>                                                                                 \
> -       preempt_disable();                                                      \
>         p = dev_core_stats(dev);                                                \
> -                                                                               \
>         if (p)                                                                  \
> -               local_inc(&p->FIELD);                                           \
> -       preempt_enable();                                                       \
> +               this_cpu_inc(p->FIELD);                                         \
>  }
>  DEV_CORE_STATS_INC(rx_dropped)
>  DEV_CORE_STATS_INC(tx_dropped)
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9ec51c1d77cf4..bf6026158874e 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10309,7 +10309,7 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
>  }
>  EXPORT_SYMBOL(netdev_stats_to_stats64);
>
> -struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev)
> +struct net_device_core_stats __percpu *netdev_core_stats_alloc(struct net_device *dev)
>  {
>         struct net_device_core_stats __percpu *p;
>
> @@ -10320,11 +10320,7 @@ struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev)
>                 free_percpu(p);
>
>         /* This READ_ONCE() pairs with the cmpxchg() above */
> -       p = READ_ONCE(dev->core_stats);
> -       if (!p)
> -               return NULL;
> -
> -       return this_cpu_ptr(p);
> +       return READ_ONCE(dev->core_stats);
>  }
>  EXPORT_SYMBOL(netdev_core_stats_alloc);
>
> @@ -10361,9 +10357,9 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
>
>                 for_each_possible_cpu(i) {
>                         core_stats = per_cpu_ptr(p, i);
> -                       storage->rx_dropped += local_read(&core_stats->rx_dropped);
> -                       storage->tx_dropped += local_read(&core_stats->tx_dropped);
> -                       storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
> +                       storage->rx_dropped += core_stats->rx_dropped;
> +                       storage->tx_dropped += core_stats->tx_dropped;
> +                       storage->rx_nohandler += core_stats->rx_nohandler;
>                 }
>         }
>         return storage;
> --
> 2.35.2
>
