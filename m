Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66802F5199
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbhAMSBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbhAMSBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 13:01:23 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E26DC061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 10:00:43 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q2so4265595iow.13
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 10:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8oVyV0Cd2sbC+BGOjlGGVGmUzatq7OrKLny89DeMR8=;
        b=HHgUstqIdqDrdcvDSK3/xvm+4ZogX8R2HQOXQqtJgg1jrAGAyKRzzh2j5WkRc3sDl9
         sKzIQ2aa3FsaCP5uV0Y4nD0WvSGM3UNpLKFuFEluixLhHkilLNoPsDROCs78oR+UqfRN
         wk9qiZhY9x19T2UkU2WFFxlz0gCzvEABdcO7AKv2saoyf+1dN6uwDOsnmSnr+usuW1y2
         kFZOBDml2IfqYtVDa/mzz8pQUSk6HvnvjBfJTXdMr9R465eNGfjdN6vD9FZFEl5eqbld
         xo2yEAFMp4lw7BO1Fcr1IcmhJl+VgVVSI/PMWB7Ns6gePL/2zDJYpcxA9VuKTKsTLdCX
         6dSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8oVyV0Cd2sbC+BGOjlGGVGmUzatq7OrKLny89DeMR8=;
        b=MA0XUCN7kuI+/BF9Hnr9vYgrjvIg9aCZB3UFphVurbu/OQW5lZLTN4HMEloU9mJOGA
         uyi01yBC0RcBw8zD/cyQeexgOdjhoZT5ZyGcGD/L+X1QomBmhDUMxcj8fDdlTTteJgsy
         jfgKM6G2gH6TmUNHnI+wTuXHX/JI2wJCtEp+hpScoPHWhwa0GyYHqasfmLJFFXQ9Yxbg
         ZXrUYxf7LFLlsBpxhYIYhVViMM00L8i9S+51eYasI9T5sz8Zd6R4okZkw8blVKxqTd9E
         1Odfhm7LPJ6VjEsXUaX3j0npBUd1GvstORKpTmTMrbuvwcIZore5p5zfsW9LGk/TMKSK
         GpSg==
X-Gm-Message-State: AOAM532P+77xsFfVc5uJ6rx5bsf6inaZC9FeHmPtvssc31Wn9xfweN9G
        /BXFhe3XRLa3bZ8zje5TcHO9SGclnnT+LHIQvT9U3poulqxbAA==
X-Google-Smtp-Source: ABdhPJynDsGOKS78CMwjG0tYz1H0ND5o80XuvdZDf4njUhDcriUo/kcPYCw1Zc+1yYBU3asUFrfC3gyxPUrJ0+rCshY=
X-Received: by 2002:a92:d210:: with SMTP id y16mr3401985ily.97.1610560842491;
 Wed, 13 Jan 2021 10:00:42 -0800 (PST)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
In-Reply-To: <20210113161819.1155526-1-eric.dumazet@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 13 Jan 2021 10:00:31 -0800
Message-ID: <CAKgT0UeyiQdHASed8x5Lkn1cfq58j6OLsM8n993V9i9XDJqiiQ@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 8:20 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Both virtio net and napi_get_frags() allocate skbs
> with a very small skb->head
>
> While using page fragments instead of a kmalloc backed skb->head might give
> a small performance improvement in some cases, there is a huge risk of
> under estimating memory usage.
>
> For both GOOD_COPY_LEN and GRO_MAX_HEAD, we can fit at least 32 allocations
> per page (order-3 page in x86), or even 64 on PowerPC
>
> We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> but consuming far more memory for TCP buffers than instructed in tcp_mem[2]
>
> Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> would still be there on arches with PAGE_SIZE >= 32768
>
> This patch makes sure that small skb head are kmalloc backed, so that
> other objects in the slab page can be reused instead of being held as long
> as skbs are sitting in socket queues.
>
> Note that we might in the future use the sk_buff napi cache,
> instead of going through a more expensive __alloc_skb()
>
> Another idea would be to use separate page sizes depending
> on the allocated length (to never have more than 4 frags per page)
>
> I would like to thank Greg Thelen for his precious help on this matter,
> analysing crash dumps is always a time consuming task.
>
> Fixes: fd11a83dd363 ("net: Pull out core bits of __netdev_alloc_skb and add __napi_alloc_skb")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Duyck <alexanderduyck@fb.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Greg Thelen <gthelen@google.com>
> ---
>  net/core/skbuff.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7626a33cce590e530f36167bd096026916131897..3a8f55a43e6964344df464a27b9b1faa0eb804f3 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -501,13 +501,17 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
>  struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>                                  gfp_t gfp_mask)
>  {
> -       struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> +       struct napi_alloc_cache *nc;
>         struct sk_buff *skb;
>         void *data;
>
>         len += NET_SKB_PAD + NET_IP_ALIGN;
>
> -       if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
> +       /* If requested length is either too small or too big,
> +        * we use kmalloc() for skb->head allocation.
> +        */
> +       if (len <= SKB_WITH_OVERHEAD(1024) ||
> +           len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
>             (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
>                 skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
>                 if (!skb)
> @@ -515,6 +519,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
>                 goto skb_success;
>         }
>
> +       nc = this_cpu_ptr(&napi_alloc_cache);
>         len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>         len = SKB_DATA_ALIGN(len);
>

The fix here looks good to me.
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

I think at some point in the future we may need to follow up and do a
rework of a bunch of this code. One thing I am wondering is if we
should look at doing some sort of memory accounting per napi_struct.
Maybe it is something we could work on tying into the page pool work
that Jesper did earlier.
