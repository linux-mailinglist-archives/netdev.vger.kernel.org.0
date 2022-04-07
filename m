Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EDE4F8808
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiDGT2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 15:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiDGT2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 15:28:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78E8283F54
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 12:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OA1TG6DYmJ7cPenLz3RcMnDq1LUbrQCNBy4gYnQEdUo=; b=SIdQk3oXrTbHFHvL3L0P2JVH9V
        gScKyOMUG5JcmJGcro5Vm5GomKdMNdKXOXnGGjeoo/9vOG54RdP7FnSbURMrf7YsM1KZs2lhkNXqL
        TOM4SYipctG6LvYzDNOZdgQtrAUYXSAt/l1UIW7ml5Nbn5fSVo1o2DwreKVIJ9IPFWjM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncXlO-00EhMk-Bh; Thu, 07 Apr 2022 21:25:50 +0200
Date:   Thu, 7 Apr 2022 21:25:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [RFC net-next 2/2] net: mvneta: add support for
 page_pool_get_stats
Message-ID: <Yk86vuqcCOZVxgOe@lunn.ch>
References: <cover.1649350165.git.lorenzo@kernel.org>
 <cd1bb62e5efe9d151fe96a5224add25122f5044a.1649350165.git.lorenzo@kernel.org>
 <Yk8sqA8sxutE+HRO@lunn.ch>
 <CAC_iWjKttCb-oDk27vb_Ar58qLN8vY_1cFbGtLB+YUMXtTX8nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_iWjKttCb-oDk27vb_Ar58qLN8vY_1cFbGtLB+YUMXtTX8nw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 09:35:52PM +0300, Ilias Apalodimas wrote:
> Hi Andrew,
> 
> On Thu, 7 Apr 2022 at 21:25, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +static void mvneta_ethtool_pp_stats(struct mvneta_port *pp, u64 *data)
> > > +{
> > > +     struct page_pool_stats stats = {};
> > > +     int i;
> > > +
> > > +     for (i = 0; i < rxq_number; i++) {
> > > +             struct page_pool *page_pool = pp->rxqs[i].page_pool;
> > > +             struct page_pool_stats pp_stats = {};
> > > +
> > > +             if (!page_pool_get_stats(page_pool, &pp_stats))
> > > +                     continue;
> > > +
> > > +             stats.alloc_stats.fast += pp_stats.alloc_stats.fast;
> > > +             stats.alloc_stats.slow += pp_stats.alloc_stats.slow;
> > > +             stats.alloc_stats.slow_high_order +=
> > > +                     pp_stats.alloc_stats.slow_high_order;
> > > +             stats.alloc_stats.empty += pp_stats.alloc_stats.empty;
> > > +             stats.alloc_stats.refill += pp_stats.alloc_stats.refill;
> > > +             stats.alloc_stats.waive += pp_stats.alloc_stats.waive;
> > > +             stats.recycle_stats.cached += pp_stats.recycle_stats.cached;
> > > +             stats.recycle_stats.cache_full +=
> > > +                     pp_stats.recycle_stats.cache_full;
> > > +             stats.recycle_stats.ring += pp_stats.recycle_stats.ring;
> > > +             stats.recycle_stats.ring_full +=
> > > +                     pp_stats.recycle_stats.ring_full;
> > > +             stats.recycle_stats.released_refcnt +=
> > > +                     pp_stats.recycle_stats.released_refcnt;
> >
> > We should be trying to remove this sort of code from the driver, and
> > put it all in the core.  It wants to be something more like:
> >
> >         struct page_pool_stats stats = {};
> >         int i;
> >
> >         for (i = 0; i < rxq_number; i++) {
> >                 struct page_pool *page_pool = pp->rxqs[i].page_pool;
> >
> >                 if (!page_pool_get_stats(page_pool, &stats))
> >                         continue;
> >
> >         page_pool_ethtool_stats_get(data, &stats);
> >
> > Let page_pool_get_stats() do the accumulate as it puts values in stats.
> 
> Unless I misunderstand this, I don't think that's doable in page pool.
> That means page pool is aware of what stats to accumulate per driver
> and I certainly don't want anything driver specific to creep in there.
> The driver knows the number of pools he is using and he can gather
> them all together.

I agree that the driver knows about the number of pools. For mvneta,
there is one per RX queue. Which is this part of my suggestion

> >         for (i = 0; i < rxq_number; i++) {
> >                 struct page_pool *page_pool = pp->rxqs[i].page_pool;
> >

However, it has no idea about the stats themselves. They are purely a
construct of the page pool. Hence the next part of my suggest, ask the
page pool for the stats, place them into stats, doing the accumulate
at the same time.:

> >                 if (!page_pool_get_stats(page_pool, &stats))
> >                         continue;

and now we have the accumulated stats, turn them into ethtool format:

> >         page_pool_ethtool_stats_get(data, &stats);

Where do you see any driver knowledge required in either of
page_pool_get_stats() or page_pool_ethtool_stats_get().

      Andrew
