Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503061CB600
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgEHRac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgEHRab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:30:31 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F323C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 10:30:31 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u4so2041693lfm.7
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 10:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wIPQ6D2Pk935lwgSi24gbHzGXnfwihoTNwfxTOymAfo=;
        b=dSaJ4IZk58Ki92R4tceiFupERDrjYmz8Yreyby1ki9nrX53ca8Bib0inaAIxr9Wkrb
         pPsORzEFLrL1YN/iFIsJj3CcMNlLpUYTXWp+cQjGqXDRFpWiHuCFaHb08Q+aLjdRPR7j
         Jzu0uIP9jNz2lwq5emV/OC7Al9aq1QfG2AoGdn59qczo6okRSuba6ZFs/Vb0YlWaxwnS
         H3IYmsWYrj3m1GvCINoP3drCGeJsZMEP9DHk8DFCCBhwhdvom36zYXxEn3W8QgfPphBa
         skwVxRuHOXNQyz+RREHeqm86URUNdy2uD2v5p00aRayApWekTG36v2pZzAu07XmJzKK8
         fBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wIPQ6D2Pk935lwgSi24gbHzGXnfwihoTNwfxTOymAfo=;
        b=Sg+8fwFxTXLr/s0+JUKpxn7a6Cu2Wd8iNzN3B0LGusyakaQzPnX4pqyD64OCPjKzBh
         760hZxvLIkwpNdcxZdRcnrk6zD7U//HXatnaGr5gydaTXGsRTVZGPDJ+emWElvKMBIA5
         ALF5XBkXVhxq6+DPQ8owi3Sx0HZrwR7jFTvfZ6jHBoJiLEzG8hRQsxk/QQd7rjoT0RXC
         pBXOfjPiZXUOLe55KgRq0sMa6ETE/guNKFBpPT9YI9LwP4OTStoZhyxTHehk7feqm9M8
         55fe42J1+G1onIfoYRR8/rojapB7YAyXlPU0PcZkeDlLICeRR8G+bReBL7qoxmb8sFKY
         TA+A==
X-Gm-Message-State: AOAM531TD8ZyFxO/GNd6fjLNOhUpgsg1crC2eArukhlWKbvSIVIeR8s/
        oM4C7oisb+ITMZ5eWQ/IZIo9vhzbXc9vZ6djtMw=
X-Google-Smtp-Source: ABdhPJw3fCfsZgyhd4T0omv6MmoMctf3bHgfzjfXME1XVnYNW/cpark4db+YA6qknv03I9kIvAwYWQnO8OzFk6l/OQg=
X-Received: by 2002:ac2:5212:: with SMTP id a18mr2606900lfl.83.1588959029324;
 Fri, 08 May 2020 10:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200508015810.46023-1-edumazet@google.com>
In-Reply-To: <20200508015810.46023-1-edumazet@google.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Fri, 8 May 2020 10:30:17 -0700
Message-ID: <CABCgpaUqymfoGGyExvKv65UDvLfHnw2cavVCr1Pq8coz21ujKA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/dst: use a smaller percpu_counter batch for
 dst entries accounting
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 7:00 PM Eric Dumazet <edumazet@google.com> wrote:
>
> percpu_counter_add() uses a default batch size which is quite big
> on platforms with 256 cpus. (2*256 -> 512)
>
> This means dst_entries_get_fast() can be off by +/- 2*(nr_cpus^2)
> (131072 on servers with 256 cpus)
>
> Reduce the batch size to something more reasonable, and
> add logic to ip6_dst_gc() to call dst_entries_get_slow()
> before calling the _very_ expensive fib6_run_gc() function.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/dst_ops.h | 4 +++-
>  net/core/dst.c        | 8 ++++----
>  net/ipv6/route.c      | 3 +++
>  3 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
> index 443863c7b8da362476c15fd290ac2a32a8aa86e3..88ff7bb2bb9bd950cc54fd5e0ae4573d4c66873d 100644
> --- a/include/net/dst_ops.h
> +++ b/include/net/dst_ops.h
> @@ -53,9 +53,11 @@ static inline int dst_entries_get_slow(struct dst_ops *dst)
>         return percpu_counter_sum_positive(&dst->pcpuc_entries);
>  }
>
> +#define DST_PERCPU_COUNTER_BATCH 32
>  static inline void dst_entries_add(struct dst_ops *dst, int val)
>  {
> -       percpu_counter_add(&dst->pcpuc_entries, val);
> +       percpu_counter_add_batch(&dst->pcpuc_entries, val,
> +                                DST_PERCPU_COUNTER_BATCH);
>  }
>
>  static inline int dst_entries_init(struct dst_ops *dst)
> diff --git a/net/core/dst.c b/net/core/dst.c
> index 193af526e908afa4b868cf128470f0fbc3850698..d6b6ced0d451a39c0ccb88ae39dba225ea9f5705 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -81,11 +81,11 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
>  {
>         struct dst_entry *dst;
>
> -       if (ops->gc && dst_entries_get_fast(ops) > ops->gc_thresh) {
> +       if (ops->gc &&
> +           !(flags & DST_NOCOUNT) &&
> +           dst_entries_get_fast(ops) > ops->gc_thresh) {
>                 if (ops->gc(ops)) {
> -                       printk_ratelimited(KERN_NOTICE "Route cache is full: "
> -                                          "consider increasing sysctl "
> -                                          "net.ipv[4|6].route.max_size.\n");
> +                       pr_notice_ratelimited("Route cache is full: consider increasing sysctl net.ipv6.route.max_size.\n");
>                         return NULL;
>                 }
>         }
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 1ff142393c768f85c495474a1d05e1ae1642301c..a9072dba00f4fb0b61bce1fc0f44a3a81ba702fa 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3195,6 +3195,9 @@ static int ip6_dst_gc(struct dst_ops *ops)
>         int entries;
>
>         entries = dst_entries_get_fast(ops);
> +       if (entries > rt_max_size)
> +               entries = dst_entries_get_slow(ops);
> +
>         if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
if this part of the condition is not satisfied, you are going to call
fib6_run_gc anyways and after that you will update the entries. So I
was wondering if code here could be something like:
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3197,11 +3197,16 @@ static int ip6_dst_gc(struct dst_ops *ops)
        unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
        int entries;

+       if (time_before(rt_last_gc + rt_min_interval, jiffies)
+               goto run_gc;
+
        entries = dst_entries_get_fast(ops);
-       if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
-           entries <= rt_max_size)
+       if (entries > rt_max_size)
+               entries = dst_entries_get_slow(ops);
+       if (entries <= rt_max_size)
                goto out;

+run_gc:
        net->ipv6.ip6_rt_gc_expire++;
        fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
        entries = dst_entries_get_slow(ops);

That way you could potentially avoid an extra call to
dst_entries_get_slow when you know for sure that fib6_run_gc will be
run. WDYT?
>             entries <= rt_max_size)
>                 goto out;
> --
> 2.26.2.645.ge9eca65c58-goog
>
