Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4370E66035E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbjAFPgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjAFPgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:36:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD1B76808
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Png50+d+uzA051GBdfy7sKVXvqEjJyuHL7UG2y9PYno=; b=sKykOzPrUEKuzf1Cy8r/f2n/rI
        jJ06jInTzN/kS4olbiqwyn8h+RE696XKkavIWIg3wzrmkuFzbjUwyxlbMvhuJcUjU4r8DgRndfsba
        dNw2J5yUIAx2i2Io1VQbql0nq5wnVfmpSWG78l/aZU8S9OHJi/Lxfemf3MOULwMEVSsiR9BP+cFxL
        51VJhtIHud8ByNqHURoaFWLVPJh7roG06ddn8Drrlgu334535VP5seYoWuqepMNblEtZ2rWOnl+Rp
        qs/brD2KCMKKD++GL/WuSqmCwDPy1eGIyY8xlvwf8L3m1fI/9Wfms1ZotATV3TArTqd6W6fwi/3xN
        Vl3tLiVw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDolG-00HHCg-Mz; Fri, 06 Jan 2023 15:36:02 +0000
Date:   Fri, 6 Jan 2023 15:36:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 05/24] page_pool: Start using netmem in allocation
 path.
Message-ID: <Y7g/4vLdpzGOxAKv@casper.infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-6-willy@infradead.org>
 <aa334df4-e362-a6d6-87bf-fd6be16023ec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa334df4-e362-a6d6-87bf-fd6be16023ec@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 02:59:30PM +0100, Jesper Dangaard Brouer wrote:
> On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> > Convert __page_pool_alloc_page_order() and __page_pool_alloc_pages_slow()
> > to use netmem internally.  This removes a couple of calls
> > to compound_head() that are hidden inside put_page().
> > Convert trace_page_pool_state_hold(), page_pool_dma_map() and
> > page_pool_set_pp_info() to take a netmem argument.
> > 
> > Saves 83 bytes of text in __page_pool_alloc_page_order() and 98 in
> > __page_pool_alloc_pages_slow() for a total of 181 bytes.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >   include/trace/events/page_pool.h | 14 +++++------
> >   net/core/page_pool.c             | 42 +++++++++++++++++---------------
> >   2 files changed, 29 insertions(+), 27 deletions(-)
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Question below.
> 
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 437241aba5a7..4e985502c569 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> [...]
> > @@ -421,7 +422,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> >   		page = NULL;
> >   	}
> > -	/* When page just alloc'ed is should/must have refcnt 1. */
> > +	/* When page just allocated it should have refcnt 1 (but may have
> > +	 * speculative references) */
> >   	return page;
> 
> What does it mean page may have speculative references ?
> 
> And do I/we need to worry about that for page_pool?

An excellent question.  There are two code paths (known to me) which
take speculative references on a page, and there may well be more.  One
is in GUP and the other is in the page cache.  Both take the form of:

	rcu_read_lock();
again:
	look-up-page
	try-get-page-ref
	check-lookup
	if lookup-failed drop-page-ref; goto again;
	rcu_read_unlock();

If a page _has been_ in the page tables, then GUP can find it.  If a
page _has been_ in the page cache, then filemap can find it.  Because
there's no RCU grace period between freeing and reallocating a page, it
actually means that any page can see its refcount temporarily raised.

Usually the biggest problem is consumers assuming that they will be the
last code to call put_page() / folio_put(), and can do their cleanup
at that time (when the last caller of folio_put() may be GUP or filemap
which knows nothing of what you're using the page for).

I didn't notice any problems with temporarily elevated refcounts while
doing the netmem conversion, and it's something I'm fairly sensitive to,
so I think you got it all right and there is no need to be concerned.

Hope that's helpful!
