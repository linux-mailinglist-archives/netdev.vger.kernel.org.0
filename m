Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960D556ADF5
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 23:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbiGGVtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 17:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiGGVti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 17:49:38 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C229D57247
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 14:49:35 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-31c89111f23so132686207b3.0
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 14:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OjCiPujDwWAr96MY2U8dFxVH5SpHSOBsMxxBdetNe0o=;
        b=WXfOeJCSSBM8CaZ5uxzGhKHdjS8d4W0L4/CXoC4wIgwzRGU72isSnIvlCHdbJ6AfLA
         Rz6qLkiKGtnAZxWHhAodvc5n82OOPDaaUqXLFl2FfWqUONiq+f+Yvs42xtLQ1+xvXYBL
         fvszAuYuRg3aqgoX9jYg2s5YeqLlSF28esgKZvWisEe5cRMnDVBABfSeadz1w4KxAP3g
         ztDqvLR8fY4NwbjFOmxjPfER0p2r9C60+fhakQcX2TN+ONYU98BU6Lef3u/pW3XvkRO0
         CWYFIQyEV1mxJkDHpuT1cRou94V+NSx8hVRi5m5x1CPSIMy7UtIB0/QQj0QjvaU1vJIx
         XqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OjCiPujDwWAr96MY2U8dFxVH5SpHSOBsMxxBdetNe0o=;
        b=BijWPlzbqqDCd0tQlhP0tnVP60MkYt/Zhoc3QvDAwz8o86Aa0on3FZaveNsS6/fPsJ
         FGGmiEbQeCKFi2+n50Ml5cTyrsiDy/LkWGsh5vzmI7A/NOZ3Jji4FY3dENHZl+cKs8C/
         Y/Hdt3UKlA6NpB8+PZwLRgxajFN7nHw+iJ8xBwG9aaqd0SOvvY8fRmUAzCckaVJfzm9I
         259h9Kjnwrp8pk9OJ2Mui5PoxuhDMcijhJnM49jwzarX8CqbJF73XdbC7zZvk5BvKG7a
         A3tS6knw8TxkpM7ZazEr3E0iAoQzgP7PKEGbou74Yhq+2rIDTHeesCIzQhWC/37cwruD
         jZ6A==
X-Gm-Message-State: AJIora9vJujkNQzeLgCOGG2fzeSuWK8Pk1YZ5N0g/emY16p2HkugMiV7
        oexqLkNHQmOx3A7SuBUZ9OccbUluPeip7gJE22V+nQ==
X-Google-Smtp-Source: AGRyM1tfItuiWP2DcAnb+OiipszcN4h7gpGQANMfoYWOW1TY5G9MALOnWz+7agXA4SxBKJWbYJb9sYv4RZaL6LPztkE=
X-Received: by 2002:a81:52d5:0:b0:31c:924e:f569 with SMTP id
 g204-20020a8152d5000000b0031c924ef569mr369534ywb.382.1657230574957; Thu, 07
 Jul 2022 14:49:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220705113515.54342-1-huangguangbin2@huawei.com> <670cb075-a2a5-2e18-c4e4-2e71e5c5e456@redhat.com>
In-Reply-To: <670cb075-a2a5-2e18-c4e4-2e71e5c5e456@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 8 Jul 2022 00:48:58 +0300
Message-ID: <CAC_iWjLpYU=jsYOW3qfDOYPyKUJhzgRGowV+1FOmBkbCFZ-xkQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: page_pool: optimize page pool page
 allocation in NUMA scenario
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Guangbin Huang <huangguangbin2@huawei.com>, hawk@kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, brouer@redhat.com, lorenzo@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, lipeng321@huawei.com, chenhao288@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 at 22:14, Jesper Dangaard Brouer <jbrouer@redhat.com> wrote:
>
>
> On 05/07/2022 13.35, Guangbin Huang wrote:
> > From: Jie Wang <wangjie125@huawei.com>
> >
> > Currently NIC packet receiving performance based on page pool deteriorates
> > occasionally. To analysis the causes of this problem page allocation stats
> > are collected. Here are the stats when NIC rx performance deteriorates:
> >
> > bandwidth(Gbits/s)            16.8            6.91
> > rx_pp_alloc_fast              13794308        21141869
> > rx_pp_alloc_slow              108625          166481
> > rx_pp_alloc_slow_h            0               0
> > rx_pp_alloc_empty             8192            8192
> > rx_pp_alloc_refill            0               0
> > rx_pp_alloc_waive             100433          158289
> > rx_pp_recycle_cached          0               0
> > rx_pp_recycle_cache_full      0               0
> > rx_pp_recycle_ring            362400          420281
> > rx_pp_recycle_ring_full               6064893         9709724
> > rx_pp_recycle_released_ref    0               0
> >
> > The rx_pp_alloc_waive count indicates that a large number of pages' numa
> > node are inconsistent with the NIC device numa node. Therefore these pages
> > can't be reused by the page pool. As a result, many new pages would be
> > allocated by __page_pool_alloc_pages_slow which is time consuming. This
> > causes the NIC rx performance fluctuations.
> >
> > The main reason of huge numa mismatch pages in page pool is that page pool
> > uses alloc_pages_bulk_array to allocate original pages. This function is
> > not suitable for page allocation in NUMA scenario. So this patch uses
> > alloc_pages_bulk_array_node which has a NUMA id input parameter to ensure
> > the NUMA consistent between NIC device and allocated pages.
> >
> > Repeated NIC rx performance tests are performed 40 times. NIC rx bandwidth
> > is higher and more stable compared to the datas above. Here are three test
> > stats, the rx_pp_alloc_waive count is zero and rx_pp_alloc_slow which
> > indicates pages allocated from slow patch is relatively low.
> >
> > bandwidth(Gbits/s)            93              93.9            93.8
> > rx_pp_alloc_fast              60066264        61266386        60938254
> > rx_pp_alloc_slow              16512           16517           16539
> > rx_pp_alloc_slow_ho           0               0               0
> > rx_pp_alloc_empty             16512           16517           16539
> > rx_pp_alloc_refill            473841          481910          481585
> > rx_pp_alloc_waive             0               0               0
> > rx_pp_recycle_cached          0               0               0
> > rx_pp_recycle_cache_full      0               0               0
> > rx_pp_recycle_ring            29754145        30358243        30194023
> > rx_pp_recycle_ring_full               0               0               0
> > rx_pp_recycle_released_ref    0               0               0
> >
> > Signed-off-by: Jie Wang <wangjie125@huawei.com>
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> > ---
> > v2->v3:
> > 1, Delete the #ifdefs
> > 2, Use 'pool->p.nid' in the call to alloc_pages_bulk_array_node()
> >
> > v1->v2:
> > 1, Remove two inappropriate comments.
> > 2, Use NUMA_NO_NODE instead of numa_mem_id() for code maintenance.
> > ---
> >   net/core/page_pool.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index f18e6e771993..b74905fcc3a1 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -389,7 +389,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> >       /* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
> >       memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
> >
> > -     nr_pages = alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
> > +     nr_pages = alloc_pages_bulk_array_node(gfp, pool->p.nid, bulk,
> > +                                            pool->alloc.cache);
> >       if (unlikely(!nr_pages))
> >               return NULL;
> >
>

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
