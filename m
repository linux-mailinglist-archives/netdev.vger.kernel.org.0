Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6773A33C261
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhCOQmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:42:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232832AbhCOQmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:42:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fGluRhk+PJrpzTtViETCiWQbIPiyTfmSvpP2ZDxvRgw=;
        b=VWEhKfsOYLHURNavR871EhK8f7kwwtw1W8PTLX/61eNdCin2havzT+5LeClsJ53mXbj6s0
        GqOboAjRmFJXIHeez14l6zKvIjXUYZ2NJ69Vqgp+PH9Zo4E3v9DSvj7+Z8CGPMr6zzNeVU
        VNGYPCPgpzytJIvrNcG0WNVng7F2+b0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-cl6paFfuOZioICwlchD9fw-1; Mon, 15 Mar 2021 12:42:30 -0400
X-MC-Unique: cl6paFfuOZioICwlchD9fw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2C9EDF8A0;
        Mon, 15 Mar 2021 16:42:28 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D91A55C3E6;
        Mon, 15 Mar 2021 16:42:22 +0000 (UTC)
Date:   Mon, 15 Mar 2021 17:42:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        brouer@redhat.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210315174221.1c9e0fe7@carbon>
In-Reply-To: <20210315104204.GB3697@techsingularity.net>
References: <20210312124609.33d4d4ba@carbon>
        <20210312145814.GA2577561@casper.infradead.org>
        <20210312160350.GW3697@techsingularity.net>
        <20210312210823.GE2577561@casper.infradead.org>
        <20210313131648.GY3697@techsingularity.net>
        <20210313163949.GI2577561@casper.infradead.org>
        <7D8C62E1-77FD-4B41-90D7-253D13715A6F@oracle.com>
        <20210313193343.GJ2577561@casper.infradead.org>
        <20210314125231.GA3697@techsingularity.net>
        <325875A2-A98A-4ECF-AFDF-0B70BCCB79AD@oracle.com>
        <20210315104204.GB3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 10:42:05 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Sun, Mar 14, 2021 at 03:22:02PM +0000, Chuck Lever III wrote:
> > >> Anyway, I'm not arguing against a bulk allocator, nor even saying this
> > >> is a bad interface.  It just maybe could be better.
> > >>   
> > > 
> > > I think it puts more responsibility on the caller to use the API correctly
> > > but I also see no value in arguing about it further because there is no
> > > supporting data either way (I don't have routine access to a sufficiently
> > > fast network to generate the data). I can add the following patch and let
> > > callers figure out which interface is preferred. If one of the interfaces
> > > is dead in a year, it can be removed.
> > > 
> > > As there are a couple of ways the arrays could be used, I'm leaving it
> > > up to Jesper and Chuck which interface they want to use. In particular,
> > > it would be preferred if the array has no valid struct pages in it but
> > > it's up to them to judge how practical that is.  
> > 
> > I'm interested to hear from Jesper.
> > 
> > My two cents (US):
> > 
> > If svc_alloc_arg() is the /only/ consumer that wants to fill
> > a partially populated array of page pointers, then there's no
> > code-duplication benefit to changing the synopsis of
> > alloc_pages_bulk() at this point.
> > 
> > Also, if the consumers still have to pass in the number of
> > pages the array needs, rather than having the bulk allocator
> > figure it out, then there's not much additional benefit, IMO.
> > 
> > Ideally (for SUNRPC) alloc_pages_bulk() would take a pointer
> > to a sparsely-populated array and the total number of elements
> > in that array, and fill in the NULL elements. The return value
> > would be "success -- all elements are populated" or "failure --
> > some elements remain NULL".
> >   
> 
> If the array API interface was expected to handle sparse arrays, it would
> make sense to define nr_pages are the number of pages that need to be
> in the array instead of the number of pages to allocate. The preamble
> would skip the first N number of allocated pages and decrement nr_pages
> accordingly before the watermark check. The return value would then be the
> last populated array element and the caller decides if that is enough to
> proceed or if the API needs to be called again. There is a slight risk
> that with a spare array that only needed 1 page in reality would fail
> the watermark check but on low memory, allocations take more work anyway.
> That definition of nr_pages would avoid the potential buffer overrun but
> both you and Jesper would need to agree that it's an appropriate API.

I actually like the idea of doing it this way.  Even-though the
page_pool fast-path (__page_pool_get_cached()) doesn't clear/mark the
"consumed" elements with NULL.  I'm ready to change page_pool to handle
this when calling this API, as I think it will be faster than walking
the linked list.

Even-though my page_pool use-case doesn't have a sparse array to
populate (like NFS/SUNRPC) then I can still use this API that Chuck is
suggesting. Thus, I'm fine with this :-)


(p.s. working on implementing Alexander Duyck's suggestions, but I
don't have it ready yet, I will try to send new patch tomorrow. And I
do realize that with this API change I have to reimplement it again,
but as long as we make forward progress then I'll happily do it).
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

/* fast path */
static struct page *__page_pool_get_cached(struct page_pool *pool)
{
	struct page *page;

	/* Caller MUST guarantee safe non-concurrent access, e.g. softirq */
	if (likely(pool->alloc.count)) {
		/* Fast-path */
		page = pool->alloc.cache[--pool->alloc.count];
	} else {
		page = page_pool_refill_alloc_cache(pool);
	}

	return page;
}

