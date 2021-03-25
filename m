Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C126349307
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCYN02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:26:28 -0400
Received: from outbound-smtp16.blacknight.com ([46.22.139.233]:40767 "EHLO
        outbound-smtp16.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229764AbhCYN0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 09:26:00 -0400
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp16.blacknight.com (Postfix) with ESMTPS id 684521C362A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 13:25:58 +0000 (GMT)
Received: (qmail 25209 invoked from network); 25 Mar 2021 13:25:58 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 25 Mar 2021 13:25:58 -0000
Date:   Thu, 25 Mar 2021 13:25:56 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/9 v6] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210325132556.GS3697@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325125001.GW1719932@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210325125001.GW1719932@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:50:01PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 25, 2021 at 11:42:19AM +0000, Mel Gorman wrote:
> > This series introduces a bulk order-0 page allocator with sunrpc and
> > the network page pool being the first users. The implementation is not
> > efficient as semantics needed to be ironed out first. If no other semantic
> > changes are needed, it can be made more efficient.  Despite that, this
> > is a performance-related for users that require multiple pages for an
> > operation without multiple round-trips to the page allocator. Quoting
> > the last patch for the high-speed networking use-case
> > 
> >             Kernel          XDP stats       CPU     pps           Delta
> >             Baseline        XDP-RX CPU      total   3,771,046       n/a
> >             List            XDP-RX CPU      total   3,940,242    +4.49%
> >             Array           XDP-RX CPU      total   4,249,224   +12.68%
> > 
> > >From the SUNRPC traces of svc_alloc_arg()
> > 
> > 	Single page: 25.007 us per call over 532,571 calls
> > 	Bulk list:    6.258 us per call over 517,034 calls
> > 	Bulk array:   4.590 us per call over 517,442 calls
> > 
> > Both potential users in this series are corner cases (NFS and high-speed
> > networks) so it is unlikely that most users will see any benefit in the
> > short term. Other potential other users are batch allocations for page
> > cache readahead, fault around and SLUB allocations when high-order pages
> > are unavailable. It's unknown how much benefit would be seen by converting
> > multiple page allocation calls to a single batch or what difference it may
> > make to headline performance.
> 
> We have a third user, vmalloc(), with a 16% perf improvement.  I know the
> email says 21% but that includes the 5% improvement from switching to
> kvmalloc() to allocate area->pages.
> 
> https://lore.kernel.org/linux-mm/20210323133948.GA10046@pc638.lan/
> 

That's fairly promising. Assuming the bulk allocator gets merged, it would
make sense to add vmalloc on top. That's for bringing it to my attention
because it's far more relevant than my imaginary potential use cases.

> I don't know how many _frequent_ vmalloc users we have that will benefit
> from this, but it's probably more than will benefit from improvements
> to 200Gbit networking performance.

I think it was 100Gbit being looked at but your point is still valid and
there is no harm in incrementally improving over time.

-- 
Mel Gorman
SUSE Labs
