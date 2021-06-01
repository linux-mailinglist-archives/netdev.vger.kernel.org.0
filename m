Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AADB397377
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhFAMrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:47:17 -0400
Received: from outbound-smtp55.blacknight.com ([46.22.136.239]:59057 "EHLO
        outbound-smtp55.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233657AbhFAMrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 08:47:17 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp55.blacknight.com (Postfix) with ESMTPS id D8825FB122
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 13:45:34 +0100 (IST)
Received: (qmail 716 invoked from network); 1 Jun 2021 12:45:34 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.255])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 1 Jun 2021 12:45:34 -0000
Date:   Tue, 1 Jun 2021 13:45:33 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Linux-MM <linux-mm@kvack.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/page_alloc: Allow high-order pages to be stored
 on the per-cpu lists
Message-ID: <20210601124533.GU30378@techsingularity.net>
References: <20210531120412.17411-1-mgorman@techsingularity.net>
 <20210531120412.17411-3-mgorman@techsingularity.net>
 <20210531172338.2e7cb070@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210531172338.2e7cb070@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 05:23:38PM +0200, Jesper Dangaard Brouer wrote:
> On Mon, 31 May 2021 13:04:12 +0100
> Mel Gorman <mgorman@techsingularity.net> wrote:
> 
> > The per-cpu page allocator (PCP) only stores order-0 pages. This means
> > that all THP and "cheap" high-order allocations including SLUB contends
> > on the zone->lock. This patch extends the PCP allocator to store THP and
> > "cheap" high-order pages. Note that struct per_cpu_pages increases in
> > size to 256 bytes (4 cache lines) on x86-64.
> > 
> > Note that this is not necessarily a universal performance win because of
> > how it is implemented. High-order pages can cause pcp->high to be exceeded
> > prematurely for lower-orders so for example, a large number of THP pages
> > being freed could release order-0 pages from the PCP lists. Hence, much
> > depends on the allocation/free pattern as observed by a single CPU to
> > determine if caching helps or hurts a particular workload.
> > 
> > That said, basic performance testing passed. The following is a netperf
> > UDP_STREAM test which hits the relevant patches as some of the network
> > allocations are high-order.
> 
> This series[1] looks very interesting!  I confirm that some network
> allocations do use high-order allocations.  Thus, I think this will
> increase network performance in general, like you confirm below:
> 

Would you be able to do a small test on a real high-speed network? It's
something I can do easily myself in a few weeks but I do not have testbed
readily available at the moment. It's ok if you do not have the time,
it would just be nice if I could include independent results in the
changelog if the results are positive. Alternatively, a negative result
would mean going back to the drawing board :)

-- 
Mel Gorman
SUSE Labs
