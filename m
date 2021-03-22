Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7576E34503F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCVTuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:50:23 -0400
Received: from outbound-smtp50.blacknight.com ([46.22.136.234]:59135 "EHLO
        outbound-smtp50.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230218AbhCVTtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 15:49:51 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp50.blacknight.com (Postfix) with ESMTPS id D7246FA95A
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 19:49:49 +0000 (GMT)
Received: (qmail 32117 invoked from network); 22 Mar 2021 19:49:49 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 22 Mar 2021 19:49:49 -0000
Date:   Mon, 22 Mar 2021 19:49:48 +0000
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
Message-ID: <20210322194948.GI3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 06:25:03PM +0000, Chuck Lever III wrote:
> 
> 
> > On Mar 22, 2021, at 5:18 AM, Mel Gorman <mgorman@techsingularity.net> wrote:
> > 
> > This series is based on top of Matthew Wilcox's series "Rationalise
> > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> > test and are not using Andrew's tree as a baseline, I suggest using the
> > following git tree
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9
> > 
> > The users of the API have been dropped in this version as the callers
> > need to check whether they prefer an array or list interface (whether
> > preference is based on convenience or performance).
> 
> I now have a consumer implementation that uses the array
> API. If I understand the contract correctly, the return
> value is the last array index that __alloc_pages_bulk()
> visits. My consumer uses the return value to determine
> if it needs to call the allocator again.
> 

For either arrays or lists, the return value is the number of valid
pages. For arrays, the pattern is expected to be

nr_pages = alloc_pages_bulk(gfp, nr_requested, page_array);
for (i = 0; i < nr_pages; i++) {
	do something with page_array[i] 
}

There *could* be populated valid elements on and after nr_pages but the
implementation did not visit those elements. The implementation can abort
early if the array looks like this

PPP....PPP

Where P is a page and . is NULL. The implementation would skip the
first three pages, allocate four pages and then abort when a new page
was encountered. This is an implementation detail around how I handled
prep_new_page. It could be addressed if many callers expect to pass in
an array that has holes in the middle.

> It is returning some confusing (to me) results. I'd like
> to get these resolved before posting any benchmark
> results.
> 
> 1. When it has visited every array element, it returns the
> same value as was passed in @nr_pages. That's the N + 1th
> array element, which shouldn't be touched. Should the
> allocator return nr_pages - 1 in the fully successful case?
> Or should the documentation describe the return value as
> "the number of elements visited" ?
> 

I phrased it as "the known number of populated elements in the
page_array". I did not want to write it as "the number of valid elements
in the array" because that is not necessarily the case if an array is
passed in with holes in the middle. I'm open to any suggestions on how
the __alloc_pages_bulk description can be improved.

The definition of the return value as-is makes sense for either a list
or an array. Returning "nr_pages - 1" suits an array because it's the
last valid index but it makes less sense when returning a list.

> 2. Frequently the allocator returns a number smaller than
> the total number of elements. As you may recall, sunrpc
> will delay a bit (via a call to schedule_timeout) then call
> again. This is supposed to be a rare event, and the delay
> is substantial. But with the array-based API, a not-fully-
> successful allocator call seems to happen more than half
> the time. Is that expected? I'm calling with GFP_KERNEL,
> seems like the allocator should be trying harder.
> 

It's not expected that the array implementation would be worse *unless*
you are passing in arrays with holes in the middle. Otherwise, the success
rate should be similar.

> 3. Is the current design intended so that if the consumer
> does call again, is it supposed to pass in the array address
> + the returned index (and @nr_pages reduced by the returned
> index) ?
> 

The caller does not have to pass in array address + returned index but
it's more efficient if it does.

If you are passing in arrays with holes in the middle then the following
might work (not tested)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c83d38dfe936..4dc38516a5bd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5002,6 +5002,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags;
 	int nr_populated = 0, prep_index = 0;
+	bool hole = false;
 
 	if (WARN_ON_ONCE(nr_pages <= 0))
 		return 0;
@@ -5057,6 +5058,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	if (!zone)
 		goto failed;
 
+retry_hole:
 	/* Attempt the batch allocation */
 	local_irq_save(flags);
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
@@ -5069,6 +5071,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 		 * IRQs are enabled.
 		 */
 		if (page_array && page_array[nr_populated]) {
+			hole = true;
 			nr_populated++;
 			break;
 		}
@@ -5109,6 +5112,9 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			prep_new_page(page_array[prep_index++], 0, gfp, 0);
 	}
 
+	if (hole && nr_populated < nr_pages && hole)
+		goto retry_hole;
+
 	return nr_populated;
 
 failed_irq:

-- 
Mel Gorman
SUSE Labs
