Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D8A4A315B
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 19:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353003AbiA2SfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 13:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352989AbiA2SfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 13:35:20 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7FCC06173B
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 10:35:19 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p12so17438884edq.9
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 10:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lkva27FDjuVXd9S3ZHFPXZitqiWm2JkfT+kk1tdT5BM=;
        b=nGF1gWV6YNalWl9D+pDdCpzXiouUK6T+3xbKaiLJkUH0fEwYI+ueZjHcpqtPAntgyp
         xlF0Dw/lWyN+bXH9mtKvGrKdXi7FTmvYebnB6szWLJP9ijICdsccfIMhjUhTGDM5wymK
         hcjpWbGSaUav2/x+Bh7wRPBNTjWcgWy8j2I+tB3g7KWfqYuwIE/QxedDswS920ZRx5g8
         +bqhUur6NwxA1YSPj1FidTvQ6DK6M1+XgvoPtGp/EjCzAEn2GGYvm8hEX3hWwmAZqYz2
         4j4HIwrJre7PCH4Esd0UP+HbjJyYfsdavyC5gvu7Z8R+Z05ZtOyPYOEXVytYOXOsBwQx
         trBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lkva27FDjuVXd9S3ZHFPXZitqiWm2JkfT+kk1tdT5BM=;
        b=sOFI6j87wqdbhsjan9oDBFF/Zb8etYcs1y7GwZsUH89mPNhDTLeXeZ0aS7Uls0RfSx
         MAQdn+xHVIGOpdef7dRhDUTkaYUP+XDny6l5Q7EyllyWyFAUquV0OaCCoOD+kTBvg1Wo
         8wpJmBZKzl4iSQCn3urWXYB45OP7WihYimnUJHbLg0cw5HnrYK8Zb8ZAOC6JIKNXNzZn
         2GvhFmh0Mqw9+jYPC8p5YvT7noj3SqFQ8hBNRcrTKJaobzGSEJEC+X8Dq45LjJ3qdiln
         KcTLOKRooBv6KHautEXseIOjrR5rKl74oritN/HZkMmxE7qhdhaItHCZWLXuDQtzQUTd
         TPDA==
X-Gm-Message-State: AOAM530Nxrk+avG3jqF53zll/QfgEMFSCgG2OZlFwqpVYSSswoBGw3a5
        Q3KjiikGCxSBkZQU9IG/oy1kzu1xz/wrLxfrlUo=
X-Google-Smtp-Source: ABdhPJzRT94VbZKBA1hmvZm+FX/pJeSTC4wAfQY+7STA6CblQkj4hctZFs4Ghs/ggxosgevyt2Y+gnTEHnd7iOlpGsI=
X-Received: by 2002:aa7:da4b:: with SMTP id w11mr13623890eds.118.1643481317815;
 Sat, 29 Jan 2022 10:35:17 -0800 (PST)
MIME-Version: 1.0
References: <164329517024.130462.875087745767169286.stgit@localhost.localdomain>
 <eae2e24f-03c7-8e92-9e70-8a50d620c1ca@huawei.com> <YfUOTkboCcHok27N@hades>
In-Reply-To: <YfUOTkboCcHok27N@hades>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 29 Jan 2022 10:35:06 -0800
Message-ID: <CAKgT0Ucjp3HKOPcjYNGh4ShGQzq7_7dMhQip_1P5Ei-xrv_pLQ@mail.gmail.com>
Subject: Re: [net-next PATCH v2] page_pool: Refactor page_pool to enable
 fragmenting after allocation
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Netdev <netdev@vger.kernel.org>, hawk@kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 1:52 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Sat, Jan 29, 2022 at 05:20:37PM +0800, Yunsheng Lin wrote:
> > On 2022/1/27 22:57, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexanderduyck@fb.com>
> > >
> > > This change is meant to permit a driver to perform "fragmenting" of the
> > > page from within the driver instead of the current model which requires
> > > pre-partitioning the page. The main motivation behind this is to support
> > > use cases where the page will be split up by the driver after DMA instead
> > > of before.
> > >
> > > With this change it becomes possible to start using page pool to replace
> > > some of the existing use cases where multiple references were being used
> > > for a single page, but the number needed was unknown as the size could be
> > > dynamic.
> > >
> > > For example, with this code it would be possible to do something like
> > > the following to handle allocation:
> > >   page = page_pool_alloc_pages();
> > >   if (!page)
> > >     return NULL;
> > >   page_pool_fragment_page(page, DRIVER_PAGECNT_BIAS_MAX);
> > >   rx_buf->page = page;
> > >   rx_buf->pagecnt_bias = DRIVER_PAGECNT_BIAS_MAX;
> > >
> > > Then we would process a received buffer by handling it with:
> > >   rx_buf->pagecnt_bias--;
> > >
> > > Once the page has been fully consumed we could then flush the remaining
> > > instances with:
> > >   if (page_pool_defrag_page(page, rx_buf->pagecnt_bias))
> > >     continue;
> > >   page_pool_put_defragged_page(pool, page -1, !!budget);
> >
> > page_pool_put_defragged_page(pool, page, -1, !!budget);
> >
> > Also I am not sure exporting the frag count to the driver is a good
> > idea, as the above example seems a little complex, maybe adding
> > the fragmenting after allocation support for a existing driver
> > is a good way to show if the API is really a good one.
>
> This is already kind of exposed since no one limits drivers from calling
> page_pool_atomic_sub_frag_count_return() right?
> What this patchset does is allow the drivers to actually use it and release
> pages without having to atomically decrement all the refcnt bias.
>
> And I do get the point that a driver might choose to do the refcounting
> internally.  That was the point all along with the fragment support in
> page_pool.  There's a wide variety of interfaces out there and each one
> handles buffers differently.
>
> What I am missing though is how this works with the current recycling
> scheme? The driver will still have to to make sure that
> page_pool_defrag_page(page, 1) == 0 for that to work no?

The general idea here is that we are getting away from doing in-driver
recycling and instead letting page pool take care of all that. That
was the original idea behind page pool, however the original
implementation was limited to a single use per page only.

So most of the legacy code out there is having to use the
page_ref_count == 1 or page_ref_count == bias trick in order to
determine if it can recycle the page. The page pool already takes care
of the page recycling by returning the pages to the pool when
page_ref_count == 1, what we get by adding the frag count is the
ability for the drivers to drop the need to perform their own ref
count tricks and instead offloads that to the kernel so when
page_pool_defrag_page(page, 1) == 0 it can then go immediately into
the checks for page_ref_count == 1 and just recycle the page into the
page pool.

> >
> >
> > >
> > > The general idea is that we want to have the ability to allocate a page
> > > with excess fragment count and then trim off the unneeded fragments.
> > >
> > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > > ---
> > >
> > > v2: Added page_pool_is_last_frag
> > >     Moved comment about CONFIG_PAGE_POOL to page_pool_put_page
> > >     Wrapped statements for page_pool_is_last_frag in parenthesis
> > >
> > >  include/net/page_pool.h |   82 ++++++++++++++++++++++++++++++-----------------
> > >  net/core/page_pool.c    |   23 ++++++-------
> > >  2 files changed, 62 insertions(+), 43 deletions(-)
> > >
> > > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > > index 79a805542d0f..fbed91469d42 100644
> > > --- a/include/net/page_pool.h
> > > +++ b/include/net/page_pool.h
> > > @@ -201,21 +201,67 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > >  }
> > >  #endif
> > >
> > > -void page_pool_put_page(struct page_pool *pool, struct page *page,
> > > -                   unsigned int dma_sync_size, bool allow_direct);
> > > +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> > > +                             unsigned int dma_sync_size,
> > > +                             bool allow_direct);
> > >
> > > -/* Same as above but will try to sync the entire area pool->max_len */
> > > -static inline void page_pool_put_full_page(struct page_pool *pool,
> > > -                                      struct page *page, bool allow_direct)
> > > +static inline void page_pool_fragment_page(struct page *page, long nr)
> > > +{
> > > +   atomic_long_set(&page->pp_frag_count, nr);
> > > +}
> > > +
> > > +static inline long page_pool_defrag_page(struct page *page, long nr)
> > > +{
> > > +   long ret;
> > > +
> > > +   /* If nr == pp_frag_count then we are have cleared all remaining
>
> s/are//

Will fix for v3.

Thanks,

Alex
