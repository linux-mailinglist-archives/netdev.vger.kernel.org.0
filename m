Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6CD34652F
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhCWQaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:30:09 -0400
Received: from outbound-smtp50.blacknight.com ([46.22.136.234]:40843 "EHLO
        outbound-smtp50.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233368AbhCWQ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:29:52 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp50.blacknight.com (Postfix) with ESMTPS id 22A1BFACD1
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 16:29:51 +0000 (GMT)
Received: (qmail 4407 invoked from network); 23 Mar 2021 16:29:50 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 23 Mar 2021 16:29:50 -0000
Date:   Tue, 23 Mar 2021 16:29:49 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210323162949.GM3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <20210323104421.GK3697@techsingularity.net>
 <20210323160814.62a248fb@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210323160814.62a248fb@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:08:14PM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 23 Mar 2021 10:44:21 +0000
> Mel Gorman <mgorman@techsingularity.net> wrote:
> 
> > On Mon, Mar 22, 2021 at 09:18:42AM +0000, Mel Gorman wrote:
> > > This series is based on top of Matthew Wilcox's series "Rationalise
> > > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> > > test and are not using Andrew's tree as a baseline, I suggest using the
> > > following git tree
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9
> > >   
> > 
> > Jesper and Chuck, would you mind rebasing on top of the following branch
> > please? 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v6r2
> > 
> > The interface is the same so the rebase should be trivial.
> > 
> > Jesper, I'm hoping you see no differences in performance but it's best
> > to check.
> 
> I will rebase and check again.
> 
> The current performance tests that I'm running, I observe that the
> compiler layout the code in unfortunate ways, which cause I-cache
> performance issues.  I wonder if you could integrate below patch with
> your patchset? (just squash it)
> 

Yes but I'll keep it as a separate patch that is modified slightly.
Otherwise it might get "fixed" as likely/unlikely has been used
inappropriately in the past. If there is pushback, I'll squash them
together.

> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Looking at perf-report and ASM-code for __alloc_pages_bulk() then the code
> activated is suboptimal. The compiler guess wrong and place unlikely code in
> the beginning. Due to the use of WARN_ON_ONCE() macro the UD2 asm
> instruction is added to the code, which confuse the I-cache prefetcher in
> the CPU
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  mm/page_alloc.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f60f51a97a7b..88a5c1ce5b87 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5003,10 +5003,10 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	unsigned int alloc_flags;
>  	int nr_populated = 0, prep_index = 0;
>  
> -	if (WARN_ON_ONCE(nr_pages <= 0))
> +	if (unlikely(nr_pages <= 0))
>  		return 0;
>  

Ok, I can make this change. It was a defensive check for the new callers
in case insane values were being passed in. 

> -	if (WARN_ON_ONCE(page_list && !list_empty(page_list)))
> +	if (unlikely(page_list && !list_empty(page_list)))
>  		return 0;
>  
>  	/* Skip populated array elements. */

FWIW, this check is now gone. The list only had to be empty if
prep_new_page was deferred until IRQs were enabled to avoid accidentally
calling prep_new_page() on a page that was already on the list when
alloc_pages_bulk was called.

> @@ -5018,7 +5018,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  		prep_index = nr_populated;
>  	}
>  
> -	if (nr_pages == 1)
> +	if (unlikely(nr_pages == 1))
>  		goto failed;
>  
>  	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */

I'm dropping this because nr_pages == 1 is common for the sunrpc user.

> @@ -5054,7 +5054,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	 * If there are no allowed local zones that meets the watermarks then
>  	 * try to allocate a single page and reclaim if necessary.
>  	 */
> -	if (!zone)
> +	if (unlikely(!zone))
>  		goto failed;
>  
>  	/* Attempt the batch allocation */

Ok.

> @@ -5075,7 +5075,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  
>  		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
>  								pcp, pcp_list);
> -		if (!page) {
> +		if (unlikely(!page)) {
>  			/* Try and get at least one page */
>  			if (!nr_populated)
>  				goto failed_irq;

Hmmm, ok. It depends on memory pressure but I agree !page is unlikely.

Current version applied is

--8<--
mm/page_alloc: optimize code layout for __alloc_pages_bulk

From: Jesper Dangaard Brouer <brouer@redhat.com>

Looking at perf-report and ASM-code for __alloc_pages_bulk() it is clear
that the code activated is suboptimal. The compiler guesses wrong and
places unlikely code at the beginning. Due to the use of WARN_ON_ONCE()
macro the UD2 asm instruction is added to the code, which confuse the
I-cache prefetcher in the CPU.

[mgorman: Minor changes and rebasing]
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index be1e33a4df39..1ec18121268b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5001,7 +5001,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	unsigned int alloc_flags;
 	int nr_populated = 0;
 
-	if (WARN_ON_ONCE(nr_pages <= 0))
+	if (unlikely(nr_pages <= 0))
 		return 0;
 
 	/*
@@ -5048,7 +5048,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	 * If there are no allowed local zones that meets the watermarks then
 	 * try to allocate a single page and reclaim if necessary.
 	 */
-	if (!zone)
+	if (unlikely(!zone))
 		goto failed;
 
 	/* Attempt the batch allocation */
@@ -5066,7 +5066,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 
 		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
-		if (!page) {
+		if (unlikely(!page)) {
 			/* Try and get at least one page */
 			if (!nr_populated)
 				goto failed_irq;
