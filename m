Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0943540BCCF
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 03:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhIOBBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 21:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhIOBBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 21:01:12 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91446C061574;
        Tue, 14 Sep 2021 17:59:54 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g8so1621889edt.7;
        Tue, 14 Sep 2021 17:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHRkfoGV/JDtay0OAy54FNdaPkESKSJLp312mEEJC/0=;
        b=K9L56VrepPokBE12YXaxmjOZw72bVoaHXuQRiK9jNpu+3vhcL+a2Ej9qp6Le2hn7eX
         hcAgdHtkFoKZpA2oAWz3/bANF8eRcGAKhqvO32CCLejWaF7rtIz444MHc1aUibdWuUPv
         QlozTnAxyKPJnWHfmS1w88XXTG7IOvRgXDQCo7Fd9pl4HfxMhclYWgyoHdg0sd2SEl2r
         HHMbUcEJy22Rc8IOwm00ehkEyuGxslNZSgqi5rLOaiwaORbrU0i+Z6m5zuizw4lSnBta
         NAW2fLD6NGiQNUKcMtusLPMPmVi27Zp46aLRAFc0lerqP928dlb/16iBsipohm+Ygv5C
         688w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHRkfoGV/JDtay0OAy54FNdaPkESKSJLp312mEEJC/0=;
        b=1XsTbpTaPl3WbBFWGEyJTcFy3+DnYeI4I80EJEX/4jLPdN+CF+6GPHbxNObHOKwlwV
         332YJhKChjX4kdKA6xFz8BK6yjVd/497GfHqrQATUwtbX7cziFCYdjr2tqOxkGmiiTbX
         zPsng6Aa3Pwp7k1rQeFf33mHy41/de5oUZiHdA1yjRZ+J9tYxYIhLT/7+ykAYpXO7xr5
         s8/vhOjjsitNo9UHdbsSFiBZWc5QOBYVTt1Ii8FWMS8UBFQJ5o96FxWG+Pg7GPhQGzMd
         N/V0rP/HpP7wpM3h4uqaY13l9Xb7UCVMoQBBdu+ZhX/ZRsRsTD99pgHYbp/eVOqJGv8S
         843Q==
X-Gm-Message-State: AOAM530gG4d+lY/+jJuVHB6JjcqWaHd6BlDIq16Qe9Zu+W7rR0eDwBL9
        lHAEBKa+i5tFSkc18I+VbSBmfrnfjxrVEUAFXSc=
X-Google-Smtp-Source: ABdhPJzswtVaIeo9sqeFnrQzkptY4mtdW2Wbr+CwQZQU8xVOwCebt0prUYjATGW4QWmTdHw1wE64JKS8YQHj7l2imNQ=
X-Received: by 2002:aa7:d402:: with SMTP id z2mr22750399edq.291.1631667592979;
 Tue, 14 Sep 2021 17:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210914121114.28559-1-linyunsheng@huawei.com> <20210914121114.28559-4-linyunsheng@huawei.com>
In-Reply-To: <20210914121114.28559-4-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 14 Sep 2021 17:59:41 -0700
Message-ID: <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] skbuff: keep track of pp page when
 __skb_frag_ref() is called
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        jonathan.lemon@gmail.com, alobakin@pm.me, willemb@google.com,
        cong.wang@bytedance.com, pabeni@redhat.com, haokexin@gmail.com,
        nogikh@google.com, elver@google.com, memxor@gmail.com,
        edumazet@google.com, dsahern@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 5:12 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> As the skb->pp_recycle and page->pp_magic may not be enough
> to track if a frag page is from page pool after the calling
> of __skb_frag_ref(), mostly because of a data race, see:
> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
> recycling page_pool packets").

I'm not sure how this comment actually applies. It is an issue that
was fixed. If anything my concern is that this change will introduce
new races instead of fixing any existing ones.

> There may be clone and expand head case that might lose the
> track if a frag page is from page pool or not.

Can you explain how? If there is such a case we should fix it instead
of trying to introduce new features to address it. This seems more
like a performance optimization rather than a fix.

> And not being able to keep track of pp page may cause problem
> for the skb_split() case in tso_fragment() too:
> Supposing a skb has 3 frag pages, all coming from a page pool,
> and is split to skb1 and skb2:
> skb1: first frag page + first half of second frag page
> skb2: second half of second frag page + third frag page
>
> How do we set the skb->pp_recycle of skb1 and skb2?
> 1. If we set both of them to 1, then we may have a similar
>    race as the above commit for second frag page.
> 2. If we set only one of them to 1, then we may have resource
>    leaking problem as both first frag page and third frag page
>    are indeed from page pool.

The question I would have is in the above cases how is skb->pp_recycle
being set on the second buffer? Is it already coming that way? If so,
maybe you should special case the __skb_frag_ref when you know you are
loading a recycling skb instead of just assuming you want to do it
automatically.

> So increment the frag count when __skb_frag_ref() is called,
> and only use page->pp_magic to indicate if a frag page is from
> page pool, to avoid the above data race.

This assumes the page is only going to be used by the network stack.
My concern is what happens when the page is pulled out of the skb and
used for example in storage?

> For 32 bit systems with 64 bit dma, we preserve the orginial
> behavior as frag count is used to trace how many time does a
> frag page is called with __skb_frag_ref().
>
> We still use both skb->pp_recycle and page->pp_magic to decide
> the head page for a skb is from page pool or not.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/linux/skbuff.h  | 40 ++++++++++++++++++++++++++++++++++++----
>  include/net/page_pool.h | 28 +++++++++++++++++++++++++++-
>  net/core/page_pool.c    | 16 ++--------------
>  3 files changed, 65 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 35eebc2310a5..4d975ab27078 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3073,7 +3073,16 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
>   */
>  static inline void __skb_frag_ref(skb_frag_t *frag)
>  {
> -       get_page(skb_frag_page(frag));
> +       struct page *page = skb_frag_page(frag);
> +
> +#ifdef CONFIG_PAGE_POOL
> +       if (page_pool_is_pp_page(page)) {
> +               page_pool_atomic_inc_frag_count(page);
> +               return;
> +       }
> +#endif
> +
> +       get_page(page);
>  }
>
>  /**
> @@ -3088,6 +3097,22 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
>         __skb_frag_ref(&skb_shinfo(skb)->frags[f]);
>  }
>
> +/**
> + * skb_frag_is_pp_page - decide if a page is recyclable.
> + * @page: frag page
> + * @recycle: skb->pp_recycle
> + *
> + * For 32 bit systems with 64 bit dma, the skb->pp_recycle is
> + * also used to decide if a page can be recycled to the page
> + * pool.
> + */
> +static inline bool skb_frag_is_pp_page(struct page *page,
> +                                      bool recycle)
> +{
> +       return page_pool_is_pp_page(page) ||
> +               (recycle && __page_pool_is_pp_page(page));
> +}
> +

The logic for this check is ugly. You are essentially calling
__page_pool_is_pp_page again if it fails the first check. It would
probably make more sense to rearrange things and just call
(!DMA_USE_PP_FRAG_COUNT || recycle)  && __page_pool_is_pp_page(). With
that the check of recycle could be dropped entirely if frag count is
valid to use, and in the non-fragcount case it reverts back to the
original check.

>  /**
>   * __skb_frag_unref - release a reference on a paged fragment.
>   * @frag: the paged fragment
> @@ -3101,8 +3126,10 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>         struct page *page = skb_frag_page(frag);
>
>  #ifdef CONFIG_PAGE_POOL
> -       if (recycle && page_pool_return_skb_page(page))
> +       if (skb_frag_is_pp_page(page, recycle)) {
> +               page_pool_return_skb_page(page);
>                 return;
> +       }
>  #endif
>         put_page(page);
>  }
> @@ -4720,9 +4747,14 @@ static inline void skb_mark_for_recycle(struct sk_buff *skb)
>
>  static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
>  {
> -       if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
> +       struct page *page = virt_to_head_page(data);
> +
> +       if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle ||
> +           !__page_pool_is_pp_page(page))
>                 return false;
> -       return page_pool_return_skb_page(virt_to_head_page(data));
> +
> +       page_pool_return_skb_page(page);
> +       return true;
>  }
>
>  #endif /* __KERNEL__ */

As I recall the virt_to_head_page isn't necessarily a cheap call as it
can lead to quite a bit of pointer chasing and a few extra math steps
to do the virt to page conversion. I would be curious how much extra
overhead this is adding to the non-fragcount or non-recycling case.

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 2ad0706566c5..eb103d86f453 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -164,7 +164,7 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
>         return pool->p.dma_dir;
>  }
>
> -bool page_pool_return_skb_page(struct page *page);
> +void page_pool_return_skb_page(struct page *page);
>
>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>
> @@ -244,6 +244,32 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
>         atomic_long_set(&page->pp_frag_count, nr);
>  }
>
> +static inline void page_pool_atomic_inc_frag_count(struct page *page)
> +{
> +       atomic_long_inc(&page->pp_frag_count);
> +}
> +

Your function name is almost as long as the function itself. Maybe you
don't need it?

> +static inline bool __page_pool_is_pp_page(struct page *page)
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
> +static inline bool page_pool_is_pp_page(struct page *page)
> +{
> +       /* For systems with the same dma addr as the bus addr, we can use
> +        * page->pp_magic to indicate a pp page uniquely.
> +        */
> +       return !PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> +                       __page_pool_is_pp_page(page);
> +}
> +

We should really change the name of the #define. I keep reading it as
we are using the PP_FRAG_COUNT, not that it is already in use. Maybe
we should look at something like PP_FRAG_COUNT_VALID and just invert
the logic for it.

Also this function naming is really confusing. You don't have to have
the frag count to be a page pool page. Maybe this should be something
like page_pool_is_pp_frag_page.

>  static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>                                                           long nr)
>  {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 09d7b8614ef5..3a419871d4bc 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -24,7 +24,7 @@
>  #define DEFER_TIME (msecs_to_jiffies(1000))
>  #define DEFER_WARN_INTERVAL (60 * HZ)
>
> -#define BIAS_MAX       LONG_MAX
> +#define BIAS_MAX       (LONG_MAX / 2)
>
>  static int page_pool_init(struct page_pool *pool,
>                           const struct page_pool_params *params)

I still think this would be better as a separate patch calling out the
fact that you are changing the value with the plan to support
incrementing it in the future.

> @@ -736,20 +736,10 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);
>
> -bool page_pool_return_skb_page(struct page *page)
> +void page_pool_return_skb_page(struct page *page)
>  {
>         struct page_pool *pp;
>
> -       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> -        * in order to preserve any existing bits, such as bit 0 for the
> -        * head page of compound page and bit 1 for pfmemalloc page, so
> -        * mask those bits for freeing side when doing below checking,
> -        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
> -        * to avoid recycling the pfmemalloc page.
> -        */
> -       if (unlikely((page->pp_magic & ~0x3UL) != PP_SIGNATURE))
> -               return false;
> -
>         pp = page->pp;
>
>         /* Driver set this to memory recycling info. Reset it on recycle.
> @@ -758,7 +748,5 @@ bool page_pool_return_skb_page(struct page *page)
>          * 'flipped' fragment being in use or not.
>          */
>         page_pool_put_full_page(pp, page, false);
> -
> -       return true;
>  }
>  EXPORT_SYMBOL(page_pool_return_skb_page);
> --
> 2.33.0
>
