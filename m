Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3B345141
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCVU6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:58:53 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:57380 "EHLO
        outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhCVU6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:58:50 -0400
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp02.blacknight.com (Postfix) with ESMTPS id F21E4BB098
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 20:58:28 +0000 (GMT)
Received: (qmail 5808 invoked from network); 22 Mar 2021 20:58:28 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 22 Mar 2021 20:58:28 -0000
Date:   Mon, 22 Mar 2021 20:58:27 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210322205827.GJ3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
 <20210322194948.GI3697@techsingularity.net>
 <0E0B33DE-9413-4849-8E78-06B0CDF2D503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <0E0B33DE-9413-4849-8E78-06B0CDF2D503@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 08:32:54PM +0000, Chuck Lever III wrote:
> >> It is returning some confusing (to me) results. I'd like
> >> to get these resolved before posting any benchmark
> >> results.
> >> 
> >> 1. When it has visited every array element, it returns the
> >> same value as was passed in @nr_pages. That's the N + 1th
> >> array element, which shouldn't be touched. Should the
> >> allocator return nr_pages - 1 in the fully successful case?
> >> Or should the documentation describe the return value as
> >> "the number of elements visited" ?
> >> 
> > 
> > I phrased it as "the known number of populated elements in the
> > page_array".
> 
> The comment you added states:
> 
> + * For lists, nr_pages is the number of pages that should be allocated.
> + *
> + * For arrays, only NULL elements are populated with pages and nr_pages
> + * is the maximum number of pages that will be stored in the array.
> + *
> + * Returns the number of pages added to the page_list or the index of the
> + * last known populated element of page_array.
> 
> 
> > I did not want to write it as "the number of valid elements
> > in the array" because that is not necessarily the case if an array is
> > passed in with holes in the middle. I'm open to any suggestions on how
> > the __alloc_pages_bulk description can be improved.
> 
> The comments states that, for the array case, a /count/ of
> pages is passed in, and an /index/ is returned. If you want
> to return the same type for lists and arrays, it should be
> documented as a count in both cases, to match @nr_pages.
> Consumers will want to compare @nr_pages with the return
> value to see if they need to call again.
> 

Then I'll just say it's the known count of pages in the array. That
might still be less than the number of requested pages if holes are
encountered.

> > The definition of the return value as-is makes sense for either a list
> > or an array. Returning "nr_pages - 1" suits an array because it's the
> > last valid index but it makes less sense when returning a list.
> > 
> >> 2. Frequently the allocator returns a number smaller than
> >> the total number of elements. As you may recall, sunrpc
> >> will delay a bit (via a call to schedule_timeout) then call
> >> again. This is supposed to be a rare event, and the delay
> >> is substantial. But with the array-based API, a not-fully-
> >> successful allocator call seems to happen more than half
> >> the time. Is that expected? I'm calling with GFP_KERNEL,
> >> seems like the allocator should be trying harder.
> >> 
> > 
> > It's not expected that the array implementation would be worse *unless*
> > you are passing in arrays with holes in the middle. Otherwise, the success
> > rate should be similar.
> 
> Essentially, sunrpc will always pass an array with a hole.
> Each RPC consumes the first N elements in the rq_pages array.
> Sometimes N == ARRAY_SIZE(rq_pages). AFAIK sunrpc will not
> pass in an array with more than one hole. Typically:
> 
> .....PPPP
> 
> My results show that, because svc_alloc_arg() ends up calling
> __alloc_pages_bulk() twice in this case, it ends up being
> twice as expensive as the list case, on average, for the same
> workload.
> 

Ok, so in this case the caller knows that holes are always at the
start. If the API returns an index that is a valid index and populated,
it can check the next index and if it is valid then the whole array
must be populated.

Right now, the implementation checks for populated elements at the *start*
because it is required for calling prep_new_page starting at the correct
index and the API cannot make assumptions about the location of the hole.

The patch below would check the rest of the array but note that it's
slower for the API to do this check because it has to check every element
while the sunrpc user could check one element. Let me know if a) this
hunk helps and b) is desired behaviour.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c83d38dfe936..4bf20650e5f5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5107,6 +5107,9 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	} else {
 		while (prep_index < nr_populated)
 			prep_new_page(page_array[prep_index++], 0, gfp, 0);
+
+		while (nr_populated < nr_pages && page_array[nr_populated])
+			nr_populated++;
 	}
 
 	return nr_populated;

-- 
Mel Gorman
SUSE Labs
