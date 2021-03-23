Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70B93467F0
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhCWSna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:43:30 -0400
Received: from outbound-smtp11.blacknight.com ([46.22.139.106]:60609 "EHLO
        outbound-smtp11.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231615AbhCWSnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:43:09 -0400
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp11.blacknight.com (Postfix) with ESMTPS id D8D041C3DBC
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:43:06 +0000 (GMT)
Received: (qmail 13406 invoked from network); 23 Mar 2021 18:43:06 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 23 Mar 2021 18:43:06 -0000
Date:   Tue, 23 Mar 2021 18:43:05 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210323184305.GN3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <20210322091845.16437-3-mgorman@techsingularity.net>
 <20210323170008.5d0732be@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210323170008.5d0732be@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 05:00:08PM +0100, Jesper Dangaard Brouer wrote:
> > +	/*
> > +	 * If there are no allowed local zones that meets the watermarks then
> > +	 * try to allocate a single page and reclaim if necessary.
> > +	 */
> > +	if (!zone)
> > +		goto failed;
> > +
> > +	/* Attempt the batch allocation */
> > +	local_irq_save(flags);
> > +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> > +	pcp_list = &pcp->lists[ac.migratetype];
> > +
> > +	while (allocated < nr_pages) {
> > +		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
> > +								pcp, pcp_list);
> 
> The function __rmqueue_pcplist() is now used two places, this cause the
> compiler to uninline the static function.
> 

This was expected. It was not something I was particularly happy with
but avoiding it was problematic without major refactoring.

> My tests show you should inline __rmqueue_pcplist().  See patch I'm
> using below signature, which also have some benchmark notes. (Please
> squash it into your patch and drop these notes).
> 

The cycle savings per element is very marginal at just 4 cycles. I
expect just the silly stat updates are way more costly but the series
that addresses that is likely to be controversial. As I know the cycle
budget for processing a packet is tight, I've applied the patch but am
keeping it separate to preserve the data in case someone points out that
is a big function to inline and "fixes" it.

-- 
Mel Gorman
SUSE Labs
