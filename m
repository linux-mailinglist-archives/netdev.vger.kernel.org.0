Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3132ABEBB
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbgKIOcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbgKIOcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:32:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC39BC0613CF;
        Mon,  9 Nov 2020 06:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0difR5ntKAj8MZoF1u1JlIpHzFXzeXVoqzhSBb4MMM8=; b=Nu4sjnGp0d9e/mL6SCEb7z/rzl
        w5I5wiXBe9gQMf2iSt4w1ng+1MDTwjJVNZIlbmJx2aguFBmKakFsz40OHMeFaaiIDJ8CudtLokbFM
        OMGcKilTyI5v1HIJvE/V9wAAYoWhbbegp9KjnGVFauhToOQs+bv+6Z5/L46sZcs6YZy7e4mU9ZXTe
        DkBe64uAGsC4hJ2JSUQEorZ5y5iDV4pNNCrizvFtch9MwOoFrbcX9+O7W3q55/j5LmhQpYOxqdQ0G
        Jl10K7SjwssDUtlmaQswE+ewnAYx9mC0jLHkfQnheQ+boLSgxxBWnKpdYaibMCq5sRjgefeI0lGOY
        8mQXIMWQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kc8Dx-0001qu-Mx; Mon, 09 Nov 2020 14:32:49 +0000
Date:   Mon, 9 Nov 2020 14:32:49 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Dumazet <erdnetdev@gmail.com>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] page_frag: Recover from memory pressure
Message-ID: <20201109143249.GB17076@casper.infradead.org>
References: <20201105042140.5253-1-willy@infradead.org>
 <d673308e-c9a6-85a7-6c22-0377dd33c019@gmail.com>
 <20201105140224.GK17076@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105140224.GK17076@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 02:02:24PM +0000, Matthew Wilcox wrote:
> On Thu, Nov 05, 2020 at 02:21:25PM +0100, Eric Dumazet wrote:
> > On 11/5/20 5:21 AM, Matthew Wilcox (Oracle) wrote:
> > > When the machine is under extreme memory pressure, the page_frag allocator
> > > signals this to the networking stack by marking allocations with the
> > > 'pfmemalloc' flag, which causes non-essential packets to be dropped.
> > > Unfortunately, even after the machine recovers from the low memory
> > > condition, the page continues to be used by the page_frag allocator,
> > > so all allocations from this page will continue to be dropped.
> > > 
> > > Fix this by freeing and re-allocating the page instead of recycling it.
> > > 
> > > Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
> > > Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> > > Cc: Bert Barbe <bert.barbe@oracle.com>
> > > Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
> > > Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> > > Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
> > > Cc: Joe Jin <joe.jin@oracle.com>
> > > Cc: SRINIVAS <srinivas.eeda@oracle.com>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
> > 
> > Your patch looks fine, although this Fixes: tag seems incorrect.
> > 
> > 79930f5892e ("net: do not deplete pfmemalloc reserve") was propagating
> > the page pfmemalloc status into the skb, and seems correct to me.
> > 
> > The bug was the page_frag_alloc() was keeping a problematic page for
> > an arbitrary period of time ?
> 
> Isn't this the commit which unmasks the problem, though?  I don't think
> it's the buggy commit, but if your tree doesn't have 79930f5892e, then
> you don't need this patch.
> 
> Or are you saying the problem dates back all the way to
> c93bdd0e03e8 ("netvm: allow skb allocation to use PFMEMALLOC reserves")
> 
> > > +		if (nc->pfmemalloc) {
> > 
> >                 if (unlikely(nc->pfmemalloc)) {
> 
> ACK.  Will make the change once we've settled on an appropriate Fixes tag.

Which commit should I claim this fixes?
