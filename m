Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8761B345C7D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 12:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCWLJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 07:09:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhCWLJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 07:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616497744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jH64CwItD7+IDNu5T9rDTh1QqhWJhGHEtaUsuBHfOjI=;
        b=KtR9TPuXH2C6X3zmB0VHWNc0CGD1dHNX50z+7Tm00fB7ZAl2qZ4JahD+DfbD8BrPse85RT
        pgWew+WoB2+tXQKVp0oPuajpoFkbK/7o5xTx8lIDO1at2DzP1oBd8mZ+qj8VWQQ1U9Zq/z
        VFaAlJrzPMYIOduOL8JzwI+1+rZOtFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-XYjXjMkUNaOx1Y9hR_U8xA-1; Tue, 23 Mar 2021 07:09:01 -0400
X-MC-Unique: XYjXjMkUNaOx1Y9hR_U8xA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D7881009466;
        Tue, 23 Mar 2021 11:08:59 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38A1F5D9F0;
        Tue, 23 Mar 2021 11:08:52 +0000 (UTC)
Date:   Tue, 23 Mar 2021 12:08:51 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210323120851.18d430cf@carbon>
In-Reply-To: <20210322205827.GJ3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
        <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
        <20210322194948.GI3697@techsingularity.net>
        <0E0B33DE-9413-4849-8E78-06B0CDF2D503@oracle.com>
        <20210322205827.GJ3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 20:58:27 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Mon, Mar 22, 2021 at 08:32:54PM +0000, Chuck Lever III wrote:
> > >> It is returning some confusing (to me) results. I'd like
> > >> to get these resolved before posting any benchmark
> > >> results.
> > >> 
> > >> 1. When it has visited every array element, it returns the
> > >> same value as was passed in @nr_pages. That's the N + 1th
> > >> array element, which shouldn't be touched. Should the
> > >> allocator return nr_pages - 1 in the fully successful case?
> > >> Or should the documentation describe the return value as
> > >> "the number of elements visited" ?
> > >>   
> > > 
> > > I phrased it as "the known number of populated elements in the
> > > page_array".  
> > 
> > The comment you added states:
> > 
> > + * For lists, nr_pages is the number of pages that should be allocated.
> > + *
> > + * For arrays, only NULL elements are populated with pages and nr_pages
> > + * is the maximum number of pages that will be stored in the array.
> > + *
> > + * Returns the number of pages added to the page_list or the index of the
> > + * last known populated element of page_array.
> > 
> >   
> > > I did not want to write it as "the number of valid elements
> > > in the array" because that is not necessarily the case if an array is
> > > passed in with holes in the middle. I'm open to any suggestions on how
> > > the __alloc_pages_bulk description can be improved.  
> > 
> > The comments states that, for the array case, a /count/ of
> > pages is passed in, and an /index/ is returned. If you want
> > to return the same type for lists and arrays, it should be
> > documented as a count in both cases, to match @nr_pages.
> > Consumers will want to compare @nr_pages with the return
> > value to see if they need to call again.
> >   
> 
> Then I'll just say it's the known count of pages in the array. That
> might still be less than the number of requested pages if holes are
> encountered.
> 
> > > The definition of the return value as-is makes sense for either a list
> > > or an array. Returning "nr_pages - 1" suits an array because it's the
> > > last valid index but it makes less sense when returning a list.
> > >   
> > >> 2. Frequently the allocator returns a number smaller than
> > >> the total number of elements. As you may recall, sunrpc
> > >> will delay a bit (via a call to schedule_timeout) then call
> > >> again. This is supposed to be a rare event, and the delay
> > >> is substantial. But with the array-based API, a not-fully-
> > >> successful allocator call seems to happen more than half
> > >> the time. Is that expected? I'm calling with GFP_KERNEL,
> > >> seems like the allocator should be trying harder.
> > >>   
> > > 
> > > It's not expected that the array implementation would be worse *unless*
> > > you are passing in arrays with holes in the middle. Otherwise, the success
> > > rate should be similar.  
> > 
> > Essentially, sunrpc will always pass an array with a hole.
> > Each RPC consumes the first N elements in the rq_pages array.
> > Sometimes N == ARRAY_SIZE(rq_pages). AFAIK sunrpc will not
> > pass in an array with more than one hole. Typically:
> > 
> > .....PPPP
> > 
> > My results show that, because svc_alloc_arg() ends up calling
> > __alloc_pages_bulk() twice in this case, it ends up being
> > twice as expensive as the list case, on average, for the same
> > workload.
> >   
> 
> Ok, so in this case the caller knows that holes are always at the
> start. If the API returns an index that is a valid index and populated,
> it can check the next index and if it is valid then the whole array
> must be populated.
> 
> Right now, the implementation checks for populated elements at the *start*
> because it is required for calling prep_new_page starting at the correct
> index and the API cannot make assumptions about the location of the hole.
> 
> The patch below would check the rest of the array but note that it's
> slower for the API to do this check because it has to check every element
> while the sunrpc user could check one element. Let me know if a) this
> hunk helps and b) is desired behaviour.
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c83d38dfe936..4bf20650e5f5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5107,6 +5107,9 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	} else {
>  		while (prep_index < nr_populated)
>  			prep_new_page(page_array[prep_index++], 0, gfp, 0);
> +
> +		while (nr_populated < nr_pages && page_array[nr_populated])
> +			nr_populated++;
>  	}
>  
>  	return nr_populated;

I do know that I suggested moving prep_new_page() out of the
IRQ-disabled loop, but maybe was a bad idea, for several reasons.

All prep_new_page does is to write into struct page, unless some
debugging stuff (like kasan) is enabled. This cache-line is hot as
LRU-list update just wrote into this cache-line.  As the bulk size goes
up, as Matthew pointed out, this cache-line might be pushed into
L2-cache, and then need to be accessed again when prep_new_page() is
called.

Another observation is that moving prep_new_page() into loop reduced
function size with 253 bytes (which affect I-cache).

   ./scripts/bloat-o-meter mm/page_alloc.o-prep_new_page-outside mm/page_alloc.o-prep_new_page-inside
    add/remove: 18/18 grow/shrink: 0/1 up/down: 144/-397 (-253)
    Function                                     old     new   delta
    __alloc_pages_bulk                          1965    1712    -253
    Total: Before=60799, After=60546, chg -0.42%

Maybe it is better to keep prep_new_page() inside the loop.  This also
allows list vs array variant to share the call.  And it should simplify
the array variant code.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[PATCH] mm: move prep_new_page inside IRQ disabled loop

From: Jesper Dangaard Brouer <brouer@redhat.com>

./scripts/bloat-o-meter mm/page_alloc.o-prep_new_page-outside mm/page_alloc.o-prep_new_page-inside
add/remove: 18/18 grow/shrink: 0/1 up/down: 144/-397 (-253)
Function                                     old     new   delta
__alloc_pages_bulk                          1965    1712    -253
Total: Before=60799, After=60546, chg -0.42%


Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 88a5c1ce5b87..b4ff09b320bc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5096,11 +5096,13 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 		else
 			page_array[nr_populated] = page;
 		nr_populated++;
+		prep_new_page(page, 0, gfp, 0);
 	}
 
 	local_irq_restore(flags);
 
 	/* Prep pages with IRQs enabled. */
+/*
 	if (page_list) {
 		list_for_each_entry(page, page_list, lru)
 			prep_new_page(page, 0, gfp, 0);
@@ -5108,7 +5110,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 		while (prep_index < nr_populated)
 			prep_new_page(page_array[prep_index++], 0, gfp, 0);
 	}
-
+*/
 	return nr_populated;
 
 failed_irq:


