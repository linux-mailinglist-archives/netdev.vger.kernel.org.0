Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FE8212032
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgGBJmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:42:39 -0400
Received: from linux.microsoft.com ([13.77.154.182]:44466 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGBJmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:42:39 -0400
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4892B20B4908;
        Thu,  2 Jul 2020 02:42:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4892B20B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1593682958;
        bh=yeT/YZEI04dXnABBuQyfYr8dFBGFkuBpRxXtbalM76w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iVEP/cK8yHqJpsyxDMO8ZfwOPci1aNNYB2lNs9aXM0g7tBc/CzUiFarfASqlIE090
         PkUMLNcGk2mtccCo8JMlYKzzxO1O4t4A+yGeYP8TA1WGZYr1sjWf4v3UCABSDo3wzo
         LFG2zjSzDbgQxIK6NCjiRbAmalBYEFWbM6CziNfo=
Received: by mail-qv1-f41.google.com with SMTP id dm12so12334814qvb.9;
        Thu, 02 Jul 2020 02:42:37 -0700 (PDT)
X-Gm-Message-State: AOAM530jsiKX0HB6+pM5RljyWu/oqgBjefxSeUnVjP3ZamkzbhUB3yye
        PGZt9BFZzZk9pYH8uX2Sr2vG5uSw8RmXRTQlDXg=
X-Google-Smtp-Source: ABdhPJzleLEvjXKmUACvkuYWy6CKyhad1vLj/r7ezZendZV2h4CwO3Ilr5pEHllRzgRwvP1cfZmYJ5QD88guKY/H3pA=
X-Received: by 2002:ad4:4672:: with SMTP id z18mr29940458qvv.104.1593682956992;
 Thu, 02 Jul 2020 02:42:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200630180930.87506-1-mcroce@linux.microsoft.com>
 <20200630180930.87506-3-mcroce@linux.microsoft.com> <20200702073104.GA496703@apalos.home>
In-Reply-To: <20200702073104.GA496703@apalos.home>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Thu, 2 Jul 2020 11:42:01 +0200
X-Gmail-Original-Message-ID: <CAFnufp09fvsyDxqJB0Hx0ag35h-XHrQt4=022cnBnRH_6iVD5g@mail.gmail.com>
Message-ID: <CAFnufp09fvsyDxqJB0Hx0ag35h-XHrQt4=022cnBnRH_6iVD5g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] mvpp2: use page_pool allocator
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 9:31 AM <ilias.apalodimas@linaro.org> wrote:
>
> Hi Matteo,
>
> Thanks for working on this!
>

:)

> On Tue, Jun 30, 2020 at 08:09:28PM +0200, Matteo Croce wrote:
> > From: Matteo Croce <mcroce@microsoft.com>
> > -static void *mvpp2_frag_alloc(const struct mvpp2_bm_pool *pool)
> > +/* Returns a struct page if page_pool is set, otherwise a buffer */
> > +static void *mvpp2_frag_alloc(const struct mvpp2_bm_pool *pool,
> > +                           struct page_pool *page_pool)
> >  {
> > +     if (page_pool)
> > +             return page_pool_alloc_pages(page_pool,
> > +                                          GFP_ATOMIC | __GFP_NOWARN);
>
> page_pool_dev_alloc_pages() can set these flags for you, instead of explicitly
> calling them
>

Ok

> >
> > +     if (priv->percpu_pools) {
> > +             err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id);
> > +             if (err < 0)
> > +                     goto err_free_dma;
> > +
> > +             err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id);
> > +             if (err < 0)
> > +                     goto err_unregister_rxq_short;
> > +
> > +             /* Every RXQ has a pool for short and another for long packets */
> > +             err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq_short,
> > +                                              MEM_TYPE_PAGE_POOL,
> > +                                              priv->page_pool[rxq->logic_rxq]);
> > +             if (err < 0)
> > +                     goto err_unregister_rxq_short;
> > +
> > +             err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq_long,
> > +                                              MEM_TYPE_PAGE_POOL,
> > +                                              priv->page_pool[rxq->logic_rxq +
> > +                                                              port->nrxqs]);
> > +             if (err < 0)
> > +                     goto err_unregister_rxq_long;
>
> Since mvpp2_rxq_init() will return an error shouldn't we unregister the short
> memory pool as well?
>

Ok, I'll add another label like:

err_unregister_mem_rxq_short:
        xdp_rxq_info_unreg_mem_model(&rxq->xdp_rxq_short);

-- 
per aspera ad upstream
