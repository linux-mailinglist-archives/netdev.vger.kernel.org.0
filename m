Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8E049CF89
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbiAZQWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiAZQWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:22:33 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED142C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:22:32 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b13so35414edn.0
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ChwzZTRG63neeYkDuG5p4+7QYgaQ1JXUbn2vX9zUqqY=;
        b=OvG6XNqoMkyRYDsxaHtxZWlUsVi38qYgRzOQAK4J8DZL3USF2NSvoQDsdQgwng0wDL
         LZ/xFReHYTmFGwLgxUiM1HNC7WqoTiBM3Tw1mLE9ejjaPbrfVlEMpipMUFrKPDP1C5gT
         lf2//Tl8VGJ3d8KGB9b4L+5LgvTaPEkk4zWu6DwBnoEviZH/sOt7Jo/8YNX6hQqKPiKv
         zR5BTr5S4ooVoerdiu1ha8CMCAWYCcswO3IUQWrvRMtO9vCt3x5kPIaRQ6uDd4xXBatU
         PbJ3Z6jdKBi9leMFQussY3AeVA5SenZUlRJRo/q8y2HUk/WswbMBlu1SY42QPquMHp2Y
         Y+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ChwzZTRG63neeYkDuG5p4+7QYgaQ1JXUbn2vX9zUqqY=;
        b=TbHpUYT2iSss0owTZltouE5DrlKuFP2mmivPj/WVR9zAos+kRiBYMVbs2sJ+Zp8d29
         MOmkzi+NdoXp54X9m0yEWt+xsNpt2ifvQM6Z6Ar/kUqsZV2QBfm+duNsBWx42tRVvcH5
         bZSHrEgOBcNfAwgYUdOZFrIeHCAu0Put+7kGQwFaJ8S+XpADE3zO5LfDLMnfzRR1ocwJ
         nCQBmEmW0gURtGfULUdI52DLftj53u+pQv85IXn1ayD6eXG03CG4rCYCdei5lrW0HjvY
         FLPQpiFxVH7iQJlHpYhx4KcGO9Uu8YRnws/HE4A+F1ReM/PeYyH0lskelfdRcDP8owIs
         +mgg==
X-Gm-Message-State: AOAM532t0g8HK39MzEJoOtX3e7qSCL5+7m9gBKu0E9XIz/IzDVFa3SRz
        qvJs7uEC4oGEJk2DwspjGziuIWfFx32tVdb0kkc=
X-Google-Smtp-Source: ABdhPJwx8/GkRvUILsec3w6D2vfCrBkCyfKM/+j10st7koQBZGFqG8+rOup04cPu+Xm3X0NRViDbqAjWJvS7nu78he0=
X-Received: by 2002:a05:6402:1119:: with SMTP id u25mr25482182edv.367.1643214151273;
 Wed, 26 Jan 2022 08:22:31 -0800 (PST)
MIME-Version: 1.0
References: <164305938406.3234.4558403245506832559.stgit@localhost.localdomain>
 <YfD9KvMxl4D3+Tyi@hades>
In-Reply-To: <YfD9KvMxl4D3+Tyi@hades>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 26 Jan 2022 08:22:19 -0800
Message-ID: <CAKgT0UdhuakHDSnZ9cuW+TbogMn3t4UG7fz1QQS-VZj6_W2ODA@mail.gmail.com>
Subject: Re: [net-next PATCH] page_pool: Refactor page_pool to enable
 fragmenting after allocation
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Netdev <netdev@vger.kernel.org>, hawk@kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 11:50 PM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Alexander,
>
> Thanks for the patch
>
> On Mon, Jan 24, 2022 at 01:23:04PM -0800, Alexander Duyck wrote:
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > This change is meant to permit a driver to perform "fragmenting" of the
> > page from within the driver instead of the current model which requires
> > pre-partitioning the page. The main motivation behind this is to support
> > use cases where the page will be split up by the driver after DMA instead
> > of before.
> >
> > With this change it becomes possible to start using page pool to replace
> > some of the existing use cases where multiple references were being used
> > for a single page, but the number needed was unknown as the size could be
> > dynamic.
> >
>
> Any specific use cases you have in mind?

For example with the mlx5e we could probably do away with a number of
page_ref_inc calls and have the page pool take care of the DMA ops
instead of what happens right now where the DMA unmapping and refcount
are having to be manipulated by the driver.

The basic idea is to make it so that the drivers can make better use
of page_pool instead of working around it by disabling functionality,
cheating the page count, or implementing their own recycling schemes
on top of page pool.

> > For example, with this code it would be possible to do something like
> > the following to handle allocation:
> >   page = page_pool_alloc_pages();
> >   if (!page)
> >     return NULL;
> >   page_pool_fragment_page(page, DRIVER_PAGECNT_BIAS_MAX);
> >   rx_buf->page = page;
> >   rx_buf->pagecnt_bias = DRIVER_PAGECNT_BIAS_MAX;
> >
> > Then we would process a received buffer by handling it with:
> >   rx_buf->pagecnt_bias--;
> >
> > Once the page has been fully consumed we could then flush the remaining
> > instances with:
> >   if (page_pool_defrag_page(page, rx_buf->pagecnt_bias))
> >     continue;
> >   page_pool_put_defragged_page(pool, page -1, !!budget);
> >
> > The general idea is that we want to have the ability to allocate a page
> > with excess fragment count and then trim off the unneeded fragments.
> >
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> >  include/net/page_pool.h |   71 ++++++++++++++++++++++++++++-------------------
> >  net/core/page_pool.c    |   24 +++++++---------
> >  2 files changed, 54 insertions(+), 41 deletions(-)
> >
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 79a805542d0f..a437c0383889 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -201,8 +201,49 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> >  }
> >  #endif
> >
> > -void page_pool_put_page(struct page_pool *pool, struct page *page,
> > -                     unsigned int dma_sync_size, bool allow_direct);
> > +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> > +                               unsigned int dma_sync_size,
> > +                               bool allow_direct);
> > +
> > +static inline void page_pool_fragment_page(struct page *page, long nr)
> > +{
> > +     atomic_long_set(&page->pp_frag_count, nr);
> > +}
> > +
> > +static inline long page_pool_defrag_page(struct page *page, long nr)
> > +{
> > +     long ret;
> > +
> > +     /* If nr == pp_frag_count then we are have cleared all remaining
> > +      * references to the page. No need to actually overwrite it, instead
> > +      * we can leave this to be overwritten by the calling function.
> > +      *
> > +      * The main advantage to doing this is that an atomic_read is
> > +      * generally a much cheaper operation than an atomic update,
> > +      * especially when dealing with a page that may be parititioned
> > +      * into only 2 or 3 pieces.
> > +      */
> > +     if (atomic_long_read(&page->pp_frag_count) == nr)
> > +             return 0;
> > +
> > +     ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> > +     WARN_ON(ret < 0);
> > +     return ret;
> > +}
> > +
> > +static inline void page_pool_put_page(struct page_pool *pool,
> > +                                   struct page *page,
> > +                                   unsigned int dma_sync_size,
> > +                                   bool allow_direct)
> > +{
> > +#ifdef CONFIG_PAGE_POOL
> > +     /* It is not the last user for the page frag case */
> > +     if (pool->p.flags & PP_FLAG_PAGE_FRAG && page_pool_defrag_page(page, 1))
> > +             return;
> > +
> > +     page_pool_put_defragged_page(pool, page, dma_sync_size, allow_direct);
> > +#endif
> > +}
> >
> >  /* Same as above but will try to sync the entire area pool->max_len */
> >  static inline void page_pool_put_full_page(struct page_pool *pool,
> > @@ -211,9 +252,7 @@ static inline void page_pool_put_full_page(struct page_pool *pool,
> >       /* When page_pool isn't compiled-in, net/core/xdp.c doesn't
> >        * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
>
> nit, but the comment can either go away or move to the new
> page_pool_put_page()

Okay, I will move the comment.

> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index bd62c01a2ec3..74fda40da51e 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -423,11 +423,6 @@ static __always_inline struct page *
> >  __page_pool_put_page(struct page_pool *pool, struct page *page,
> >                    unsigned int dma_sync_size, bool allow_direct)
> >  {
> > -     /* It is not the last user for the page frag case */
> > -     if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> > -         page_pool_atomic_sub_frag_count_return(page, 1))
> > -             return NULL;
> > -
> >       /* This allocator is optimized for the XDP mode that uses
> >        * one-frame-per-page, but have fallbacks that act like the
> >        * regular page allocator APIs.
> > @@ -471,8 +466,8 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
> >       return NULL;
> >  }
> >
> > -void page_pool_put_page(struct page_pool *pool, struct page *page,
> > -                     unsigned int dma_sync_size, bool allow_direct)
> > +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> > +                               unsigned int dma_sync_size, bool allow_direct)
> >  {
> >       page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
> >       if (page && !page_pool_recycle_in_ring(pool, page)) {
> > @@ -480,7 +475,7 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
> >               page_pool_return_page(pool, page);
> >       }
> >  }
> > -EXPORT_SYMBOL(page_pool_put_page);
> > +EXPORT_SYMBOL(page_pool_put_defragged_page);
> >
> >  /* Caller must not use data area after call, as this function overwrites it */
> >  void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > @@ -491,6 +486,11 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> >       for (i = 0; i < count; i++) {
> >               struct page *page = virt_to_head_page(data[i]);
> >
> > +             /* It is not the last user for the page frag case */
> > +             if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> > +                 page_pool_defrag_page(page, 1))
> > +                     continue;
>
> Would it make sense to have this check on a function?  Something like
> page_pool_is_last_frag() or similar? Also for for readability switch do
> (pool->p.flags & PP_FLAG_PAGE_FRAG) && ...

I will address the readability issue by wrapping the check in
parenthesis when I move it to a function. I will likely be inverting
it anyway so it will be: !(flags & FRAG) || (defrag_page() == 0)
