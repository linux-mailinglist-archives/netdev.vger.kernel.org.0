Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC5C668486
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240704AbjALUyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbjALUxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:53:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AE9140C1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ut0oHZmUlSfWhXqfYECviDD2lPh/AxfnTisdiH5avRU=; b=ZQcgPjxHaCEk/Lal32rwDDMJ/Y
        08HVaIlsTyAt1AuAJY3Z19GSABtssiTOb9qBOFa2BPwFdDqQEuhZEtkR5oxAwMLzcYYwGgxCpIBPR
        Rh8kI9Bi7iBw++y8ObLRizfZgNv/JOSvyvfC0xd3qptwfYJ97qTeerTT7dss+kwHyr6A4eP8FhAII
        IZva3xCtS3gppU6kQxwqfYU2PC2hRvs9yIvt3IhY49oDM/A9DocOuL4RWBR6G88onJNWZcJIamRL1
        6GUTy2x4Vr7/6d3AZv+WVpmBh8Lwtbej9ynQ6mzY7NoeMDw8NkKlk4gSPQDrA9IJcGXDRXcJvEJ22
        H5ANJGjw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pG4Ct-005RyA-Ub; Thu, 12 Jan 2023 20:29:51 +0000
Date:   Thu, 12 Jan 2023 20:29:51 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 05/26] page_pool: Start using netmem in allocation
 path.
Message-ID: <Y8Btv2hwEkP02jnY@casper.infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
 <20230111042214.907030-6-willy@infradead.org>
 <pj41zlpmbjn4ld.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pj41zlpmbjn4ld.fsf@u570694869fb251.ant.amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 05:36:58PM +0200, Shay Agroskin wrote:
> 
> "Matthew Wilcox (Oracle)" <willy@infradead.org> writes:
> 
> > Convert __page_pool_alloc_page_order() and
> > __page_pool_alloc_pages_slow()
> > ...
> >  TRACE_EVENT(page_pool_update_nid,
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 437241aba5a7..4e985502c569 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > ...
> >   @@ -421,7 +422,8 @@ static struct page
> > *__page_pool_alloc_pages_slow(struct page_pool *pool,
> >  		page = NULL;
> >  	}
> >   -	/* When page just alloc'ed is should/must have refcnt 1. */
> > +	/* When page just allocated it should have refcnt 1 (but may have
> > +	 * speculative references) */
> 
> Sorry for the pity comment, but the comment style here is inconsistent
> https://www.kernel.org/doc/html/v4.11/process/coding-style.html#commenting
> 
> You should have the last '*/' to be on its own line
> (again sorry for not giving more useful feedback... then again, it's a
> rather simply fix (: )

But networking doesn't follow that part of coding style.
