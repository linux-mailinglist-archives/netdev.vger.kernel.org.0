Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DFD3FC9B9
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 16:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhHaObW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 10:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbhHaObQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 10:31:16 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F7FC061575;
        Tue, 31 Aug 2021 07:30:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dm15so27120414edb.10;
        Tue, 31 Aug 2021 07:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uVmnUfJakwKz8+nOoS/IAi9hUvZN1m0f0PicDQB7RVA=;
        b=peCrgKks4iJhA95NMVzuTuBk9VLrObIWTl5Brs7Q/KxkViytoUOy0PuJEchGLaV58D
         VLfSeGzkd15E47Ml0EcgDMs6yTOhYMX71nixupIPhMcrCeemmajsindS16N9ocrwTZHu
         klTnpb31+xAfmGSXS/vN6XnzaE1+s58XU5/cp6nKsCNoxLPlm1Oz5cgf+t97tYiqix03
         1Q6y3rUhbGbEFi/J5OHi9yLDlPhwBHd5MCV0rogyp5fYtBfBH/cq7IgnIrLEVnX6xTlu
         QylXONNwsL6EefA7DXbvGFvXQSo7kAnXAbEtGmR/m7vTalsmm+O5OGF9sQ4hfTVvIxnC
         iCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uVmnUfJakwKz8+nOoS/IAi9hUvZN1m0f0PicDQB7RVA=;
        b=KFtXSHGzNL1sMo+D9dv8G7PgphE352kKzJHHqKe1y72+rybv1tVl6vE/2J2MuiUynA
         eGkiEX2d4wEv+3Os02pc5rb2wl1emW9XKrFRbDUXFNHcW4RGPugXawhOX3r+8pgbIXiw
         FJ47YH84WkQevIzYGNqJ0TBqub53RgGaqjR1i40/sdqLYsvsQm+xqu7vT87fX16Y9WjH
         hU52yiTXQ0/mr63wnNFl0iAxDalVjCndl0SynPn75+hok+WO11snVSaG2KLPTLDQgtcc
         8ugulmZ4lWWkiXLpYr5t4NSvceM+efbVd2p8a/hAt1iyi6vFw39EEWcvrAONNFTOKGS5
         t19A==
X-Gm-Message-State: AOAM531bR2Xgskn3K1DXKC0AWa5l33kVVgiFZ664Rgyn0HHzwTT1wMcn
        hLfL05Mx3VuVHT9UGwUDq5KMWMtgtnOH8VxbAnc=
X-Google-Smtp-Source: ABdhPJyZPdA5cs6m6TNkUmEYzgnGhX3YsmFNvA3lDju4KnoLlrJudCJSGk6PED7os/ibVRV5KnzUHHSqNrLg1y78iWE=
X-Received: by 2002:aa7:cb92:: with SMTP id r18mr30540558edt.282.1630420217400;
 Tue, 31 Aug 2021 07:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com>
 <1630286290-43714-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0UfmcB93Hn1AS_o2a_h98xxZMouTiGzJfG09qsWf+O6L1Q@mail.gmail.com> <9cf28179-0cd5-a8c5-2bfd-bd844315ad1a@huawei.com>
In-Reply-To: <9cf28179-0cd5-a8c5-2bfd-bd844315ad1a@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 31 Aug 2021 07:30:06 -0700
Message-ID: <CAKgT0UdheXoe3fK9yJLvj1TQcZLEa5utxV9E6Fn6EkdSabT=nQ@mail.gmail.com>
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

On Tue, Aug 31, 2021 at 12:20 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/8/30 23:14, Alexander Duyck wrote:
> > On Sun, Aug 29, 2021 at 6:19 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> As the skb->pp_recycle and page->pp_magic may not be enough
> >> to track if a frag page is from page pool after the calling
> >> of __skb_frag_ref(), mostly because of a data race, see:
> >> commit 2cc3aeb5eccc ("skbuff: Fix a potential race while
> >> recycling page_pool packets").
> >>
> >> There may be clone and expand head case that might lose the
> >> track if a frag page is from page pool or not.
> >>
> >> So increment the frag count when __skb_frag_ref() is called,
> >> and only use page->pp_magic to indicate if a frag page is from
> >> page pool, to avoid the above data race.
> >>
> >> For 32 bit systems with 64 bit dma, we preserve the orginial
> >> behavior as frag count is used to trace how many time does a
> >> frag page is called with __skb_frag_ref().
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >
> > Is this really a common enough case to justify adding this extra overhead?
>
> I am not sure I understand what does extra overhead mean here.
> But it seems this patch does not add any explicit overhead?
> As the added page_pool_is_pp_page() checking in __skb_frag_ref() is
> neutralized by avoiding the recycle checking in __skb_frag_unref(),
> and the atomic operation is with either pp_frag_count or _refcount?

My concern is maintenance overhead. Specifically what you are doing is
forking the code path in __skb_frag_ref so there are cases where it
will increment the page reference count and there are others where it
will increment the frag count. Changing things like this means we have
to be certain that any paths that are expecting the reference count to
be updated have been addressed and it means that any code dealing with
the reference count in the future will be that much more complex.

> >
> >> ---
> >>  include/linux/skbuff.h  | 13 ++++++++++++-
> >>  include/net/page_pool.h | 17 +++++++++++++++++
> >>  net/core/page_pool.c    | 12 ++----------
> >>  3 files changed, 31 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >> index 6bdb0db..8311482 100644
> >> --- a/include/linux/skbuff.h
> >> +++ b/include/linux/skbuff.h
> >> @@ -3073,6 +3073,16 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
> >>   */
> >>  static inline void __skb_frag_ref(skb_frag_t *frag)
> >>  {
> >> +       struct page *page = skb_frag_page(frag);
> >> +
> >> +#ifdef CONFIG_PAGE_POOL
> >> +       if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> >> +           page_pool_is_pp_page(page)) {
> >> +               page_pool_atomic_inc_frag_count(page);
> >> +               return;
> >> +       }
> >> +#endif
> >> +
> >>         get_page(skb_frag_page(frag));
> >>  }
> >>
> >
> > This just seems like a bad idea in general. We are likely increasing
> > the potential for issues with this patch instead of avoiding them. I
>
> Yes, I am agreed that calling the __skb_frag_ref() without calling the
> __skb_frag_unref() for the same page might be more likely to cause problem
> for this patch. But we are already depending on the calling of
> __skb_frag_unref() to free the pp page, making it more likely just enable
> us to catch the bug more quickly?

The problem is one of the things our earlier fix had changed is that
you could only have one skb running around with skb->pp_recycle after
cloning the head. So skb_frag_unref will not do the
page_pool_return_skb_page because it is cleared and it will likely
trigger a reference undercount since we incremented the frag count
instead of the reference count.

> Or is there other situation that I am not awared of, which might cause
> issues?

I'm pretty sure this breaks the case that was already called out in
commit 2cc3aeb5eccc ("skbuff: Fix a potential race while recycling
page_pool packets"). The problem is the clone would then need to
convert over the frag count to page references in order to move
forward. What it effectively does is lock the pages into the skb and
prevent them from being used elsewhere.

> > really feel it would be better for us to just give up on the page and
> > kick it out of the page pool if we are cloning frames and multiple
> > references are being taken on the pages.
>
> For Rx, it seems fine for normal case.
> For Tx, it seems the cloning and multiple references happens when
> tso_fragment() is called in tcp_write_xmit(), and the driver need to
> reliable way to tell if a page is from the page pool, so that the
> dma mapping can be avoided for Tx too.

The problem is cloning and page pool do not play well together. We are
better off just avoiding the page pool entirely for Tx. Now if we are
wanting to store the DMA for the page until it is freed that is one
thing, but the current page pool doesn't work well with cloning and
such because of all the refcount tricks that have to be played.

The main issue is that page pool assumes single producer, single
consumer. In the Tx path that isn't necessarily guaranteed since for
things like TCP we end up having to hold onto clones of the packets
until the transmission is completed.

> >
> >> @@ -3101,7 +3111,8 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
> >>         struct page *page = skb_frag_page(frag);
> >>
> >>  #ifdef CONFIG_PAGE_POOL
> >> -       if (recycle && page_pool_return_skb_page(page))
> >> +       if ((!PAGE_POOL_DMA_USE_PP_FRAG_COUNT || recycle) &&
> >> +           page_pool_return_skb_page(page))
> >>                 return;
> >>  #endif
> >>         put_page(page);
> >> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> >> index 2ad0706..8b43e3d9 100644
> >> --- a/include/net/page_pool.h
> >> +++ b/include/net/page_pool.h
> >> @@ -244,6 +244,23 @@ static inline void page_pool_set_frag_count(struct page *page, long nr)
> >>         atomic_long_set(&page->pp_frag_count, nr);
> >>  }
> >>
> >> +static inline void page_pool_atomic_inc_frag_count(struct page *page)
> >> +{
> >> +       atomic_long_inc(&page->pp_frag_count);
> >> +}
> >> +
> >> +static inline bool page_pool_is_pp_page(struct page *page)
> >> +{
> >> +       /* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
> >> +        * in order to preserve any existing bits, such as bit 0 for the
> >> +        * head page of compound page and bit 1 for pfmemalloc page, so
> >> +        * mask those bits for freeing side when doing below checking,
> >> +        * and page_is_pfmemalloc() is checked in __page_pool_put_page()
> >> +        * to avoid recycling the pfmemalloc page.
> >> +        */
> >> +       return (page->pp_magic & ~0x3UL) == PP_SIGNATURE;
> >> +}
> >> +
> >>  static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> >>                                                           long nr)
> >>  {
> >> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >> index ba9f14d..442d37b 100644
> >> --- a/net/core/page_pool.c
> >> +++ b/net/core/page_pool.c
> >> @@ -24,7 +24,7 @@
> >>  #define DEFER_TIME (msecs_to_jiffies(1000))
> >>  #define DEFER_WARN_INTERVAL (60 * HZ)
> >>
> >> -#define BIAS_MAX       LONG_MAX
> >> +#define BIAS_MAX       (LONG_MAX / 2)
> >
> > This piece needs some explaining in the patch. Why are you changing
> > the BIAS_MAX?
>
> When __skb_frag_ref() is called for the pp page that is not drained yet,
> the pp_frag_count could be overflowed if the BIAS is too big.

Aren't we only checking against 0 though? We are calling LONG_MAX
which is already half the maximum possible value since it is dropping
the signed bit. If we are treating the value like it is unsigned and
only testing against 0 that would leave half the space still available
anyway.
