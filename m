Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165734F6E95
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 01:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbiDFXiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 19:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237595AbiDFXiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 19:38:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7AC1E95F5
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 16:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mR7jo8qAh/7AGTnB4RvyFh83yTV8cnDXBx2qe/Lj9ZU=; b=N89jlYm/3Fe1JfSRoVYVmk32Pt
        KPcYOxQAktcxiY78Fn1IZrq5KyCM3jPVktwIJwPOKBYNBit2d913BiQjsyMrE8v8EYNxE7FBi4x8U
        Gucy27xtjvWgBe181Tx4Q3L3eHZ+ewySOktVPyAdBgwy8wErWmfGJlq0seOlXn++QY60=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncFBx-00EX9K-Sb; Thu, 07 Apr 2022 01:36:01 +0200
Date:   Thu, 7 Apr 2022 01:36:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joe Damato <jdamato@fastly.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
Message-ID: <Yk4j4YCVuOLK/1uE@lunn.ch>
References: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
 <Yk2X6KPyeN3z7OUW@lunn.ch>
 <Yk2dhD2rjQQaF4Pc@lore-desk>
 <20220406230136.GA96269@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406230136.GA96269@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 04:01:37PM -0700, Joe Damato wrote:
> On Wed, Apr 06, 2022 at 04:02:44PM +0200, Lorenzo Bianconi wrote:
> > > > +static void mvneta_ethtool_update_pp_stats(struct mvneta_port *pp,
> > > > +					   struct page_pool_stats *stats)
> > > > +{
> > > > +	int i;
> > > > +
> > > > +	memset(stats, 0, sizeof(*stats));
> > > > +	for (i = 0; i < rxq_number; i++) {
> > > > +		struct page_pool *page_pool = pp->rxqs[i].page_pool;
> > > > +		struct page_pool_stats pp_stats = {};
> > > > +
> > > > +		if (!page_pool_get_stats(page_pool, &pp_stats))
> > > > +			continue;
> > > > +
> > > > +		stats->alloc_stats.fast += pp_stats.alloc_stats.fast;
> > > > +		stats->alloc_stats.slow += pp_stats.alloc_stats.slow;
> > > > +		stats->alloc_stats.slow_high_order +=
> > > > +			pp_stats.alloc_stats.slow_high_order;
> > > > +		stats->alloc_stats.empty += pp_stats.alloc_stats.empty;
> > > > +		stats->alloc_stats.refill += pp_stats.alloc_stats.refill;
> > > > +		stats->alloc_stats.waive += pp_stats.alloc_stats.waive;
> > > > +		stats->recycle_stats.cached += pp_stats.recycle_stats.cached;
> > > > +		stats->recycle_stats.cache_full +=
> > > > +			pp_stats.recycle_stats.cache_full;
> > > > +		stats->recycle_stats.ring += pp_stats.recycle_stats.ring;
> > > > +		stats->recycle_stats.ring_full +=
> > > > +			pp_stats.recycle_stats.ring_full;
> > > > +		stats->recycle_stats.released_refcnt +=
> > > > +			pp_stats.recycle_stats.released_refcnt;
> > > 
> > > Am i right in saying, these are all software stats? They are also
> > > generic for any receive queue using the page pool?
> > 
> > yes, these stats are accounted by the kernel so they are sw stats, but I guess
> > xdp ones are sw as well, right?
> > 
> > > 
> > > It seems odd the driver is doing the addition here. Why not pass stats
> > > into page_pool_get_stats()? That will make it easier when you add
> > > additional statistics?
> > > 
> > > I'm also wondering if ethtool -S is even the correct API. It should be
> > > for hardware dependent statistics, those which change between
> > > implementations. Where as these statistics should be generic. Maybe
> > > they should be in /sys/class/net/ethX/statistics/ and the driver
> > > itself is not even involved, the page pool code implements it?
> > 
> > I do not have a strong opinion on it, but I can see an issue for some drivers
> > (e.g. mvpp2 iirc) where page_pools are not specific for each net_device but are shared
> > between multiple ports, so maybe it is better to allow the driver to decide how
> > to report them. What do you think?
> 
> When I did the implementation of this API the feedback was essentially
> that the drivers should be responsible for reporting the stats of their
> active page_pool structures; this is why the first driver to use this
> (mlx5) uses the API and outputs the stats via ethtool -S.
> 
> I have no strong preference, either, but I think that exposing the stats
> via an API for the drivers to consume is less tricky; the driver knows
> which page_pools are active and which pool is associated with which
> RX-queue, and so on.
> 
> If there is general consensus for a different approach amongst the
> page_pool maintainers, I am happy to implement it.

If we keep it in the drivers, it would be good to try to move some of
the code into the core, to keep cut/paste to a minimum. We want the
same strings for every driver for example, and it looks like it is
going to be hard to add new counters, since you will need to touch
every driver using the page pool.

Maybe even consider adding ETH_SS_PAGE_POOL. You can then put
page_pool_get_sset_count() and page_pool_get_sset_strings() as helpers
in the core, and the driver just needs to implement the get_stats()
part, again with a helper in the core which can do most of the work.

       Andrew
