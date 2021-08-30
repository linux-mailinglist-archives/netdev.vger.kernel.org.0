Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9982D3FB8E0
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbhH3PPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbhH3PPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 11:15:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2946BC061575;
        Mon, 30 Aug 2021 08:14:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i6so22204192edu.1;
        Mon, 30 Aug 2021 08:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bpyvzhLmSHmRSMIpQj5jbzqpJ3n4albotiHOuJXPyF8=;
        b=p46xWdqYzCpdOOYaYHI6M6WUnZuZFVv4u1Huh823CGOE9djdsGq1+On56VbOanGNp+
         egSEhAJP48473wspkuJG3EE4NM3nlTXC4BoNlI24Vb5XFdN32DuKnYN9ghwc/uTUMItg
         7JLA8f9u4REqVQ7aUNN3ZEwZXIYYwtWeBBA8gufE2ERGc0lMfpM8hNoOdVzGJXyzgZZ1
         JLKhopDjhmQnonzOFP6q2ppPezrwjgZUd5vRHQ6koAy+mp3x7GAjKyxwGaVjjB1uIxm0
         tstN/rAJBFZCjmTWn6v9qKOOhQpV2nTPzcrUTzSKNjYYVe3u1qzXUHFVcFA4iMibrOTX
         cnkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bpyvzhLmSHmRSMIpQj5jbzqpJ3n4albotiHOuJXPyF8=;
        b=S5yPJxXk0hUTXfFL+9ROxeWvW2gLjTJ1xqY5otDZFQluJZInhGAKiFP2mXlK0/aKOw
         uvdKR7mtoApX4958hxecrRjlAlUrKA+Ln+S2/kxGi4LI4oAB6snOJZsgmSTQoVMA8371
         leTUHJnvNo8VP7lMpsLdifp0FtgYsyj639y0jlvb5psOQWiC6CBWMSB3jBlJVq5sBhuw
         iaBpHw3Mzp5QS2a+Rfk2afKIOD39zuiSPBDHAt4R6fIOTciPBXC/pIGxPJoemUFsUvss
         8wWfVf/SepFk+mt/tE4zGidFcC7MOOGnblsW+cOtQ6VntCZ5ybIv1dTXdqlh4ShzcpW4
         n3Hw==
X-Gm-Message-State: AOAM532F7jOIBtgNp3dVlmM0rA+CPAiu//ugblh8Gpz2hk5yERB/jBgp
        1a+jrHK7DAswN9aOh+r1pRuDy47nONPHuPMMt7P+cBxh
X-Google-Smtp-Source: ABdhPJzP3VtuLbSuA67KHhVlcNUFji6PTTdpvcCAPIhQ5+fMGlevfHRnihSPJubexw+iVjPSPUl9eTSC53+q8XBT5g4=
X-Received: by 2002:a05:6402:1d56:: with SMTP id dz22mr24717889edb.69.1630336495677;
 Mon, 30 Aug 2021 08:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com> <1630286290-43714-3-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1630286290-43714-3-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 30 Aug 2021 08:14:44 -0700
Message-ID: <CAKgT0UfmcB93Hn1AS_o2a_h98xxZMouTiGzJfG09qsWf+O6L1Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] skbuff: keep track of pp page when
 __skb_frag_ref() is called
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        hawk@kernel.org, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, memxor@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 6:19 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> As the skb->pp_recycle and page->pp_magic may not be enough
> to track if a frag page is from page pool after the calling
> of __skb_frag_ref(), mostly because of a data race, see:
> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
> recycling page_pool packets").
>
> There may be clone and expand head case that might lose the
> track if a frag page is from page pool or not.
>
> So increment the frag count when __skb_frag_ref() is called,
> and only use page->pp_magic to indicate if a frag page is from
> page pool, to avoid the above data race.
>
> For 32 bit systems with 64 bit dma, we preserve the orginial
> behavior as frag count is used to trace how many time does a
> frag page is called with __skb_frag_ref().
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Is this really a common enough case to justify adding this extra overhead?

> ---
>  include/linux/skbuff.h  | 13 ++++++++++++-
>  include/net/page_pool.h | 17 +++++++++++++++++
>  net/core/page_pool.c    | 12 ++----------
>  3 files changed, 31 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 6bdb0db..8311482 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3073,6 +3073,16 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
>   */
>  static inline void __skb_frag_ref(skb_frag_t *frag)
>  {
> +       struct page *page = skb_frag_page(frag);
> +
> +#ifdef CONFIG_PAGE_POOL
> +       if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> +           page_pool_is_pp_page(page)) {
> +               page_pool_atomic_inc_frag_count(page);
> +               return;
> +       }
> +#endif
> +
>         get_page(skb_frag_page(frag));
>  }
>

This just seems like a bad idea in general. We are likely increasing
the potential for issues with this patch instead of avoiding them. I
really feel it would be better for us to just give up on the page and
kick it out of the page pool if we are cloning frames and multiple
references are being taken on the pages.

> @@ -3101,7 +3111,8 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>         struct page *page = skb_frag_page(frag);
>
>  #ifdef CONFIG_PAGE_POOL
> -       if (recycle && page_pool_return_skb_page(page))
> +       if ((!PAGE_POOL_DMA_USE_PP_FRAG_COUNT || recycle) &&
> +           page_pool_return_skb_page(page))
>                 return;
>  #endif
>         put_page(page);
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 2ad0706..8b43e3d9 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -244,6 +244,23 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
>         atomic_long_set(&page->pp_frag_count, nr);
>  }
>
> +static inline void page_pool_atomic_inc_frag_count(struct page *page)
> +{
> +       atomic_long_inc(&page->pp_frag_count);
> +}
> +
> +static inline bool page_pool_is_pp_page(struct page *page)
> +{
> +       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> +        * in order to preserve any existing bits, such as bit 0 for the
> +        * head page of compound page and bit 1 for pfmemalloc page, so
> +        * mask those bits for freeing side when doing below checking,
> +        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
> +        * to avoid recycling the pfmemalloc page.
> +        */
> +       return (page->pp_magic & ~0x3UL) == PP_SIGNATURE;
> +}
> +
>  static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>                                                           long nr)
>  {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ba9f14d..442d37b 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -24,7 +24,7 @@
>  #define DEFER_TIME (msecs_to_jiffies(1000))
>  #define DEFER_WARN_INTERVAL (60 * HZ)
>
> -#define BIAS_MAX       LONG_MAX
> +#define BIAS_MAX       (LONG_MAX / 2)

This piece needs some explaining in the patch. Why are you changing
the BIAS_MAX?

>  static int page_pool_init(struct page_pool *pool,
>                           const struct page_pool_params *params)
> @@ -741,15 +741,7 @@ bool page_pool_return_skb_page(struct page *page)
>         struct page_pool *pp;
>
>         page = compound_head(page);
> -
> -       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> -        * in order to preserve any existing bits, such as bit 0 for the
> -        * head page of compound page and bit 1 for pfmemalloc page, so
> -        * mask those bits for freeing side when doing below checking,
> -        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
> -        * to avoid recycling the pfmemalloc page.
> -        */
> -       if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
> +       if (!page_pool_is_pp_page(page))
>                 return false;
>
>         pp = page->pp;
> --
> 2.7.4
>
