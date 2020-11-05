Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A889A2A7E33
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 13:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgKEMF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 07:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgKEMF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 07:05:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33782C0613CF;
        Thu,  5 Nov 2020 04:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CRdjjbC6ta204KKisbGTc+8ducfw9SLJz/rtqPEhUcI=; b=veqZpURnKhUSYBpP+xOVgM5T3J
        vOS0stJpgC2YBhA9WijRTyRhuokLcI75f1HnvFuNPh3wJpi6xFrHB3F33HpMCWnvQLuWIDuOhKBhN
        qTFw2C4AxmgoGeIId5WzyjI1hU/YetnT7aGSHs2cnXysLxb257QuIzlxOdREE4PlUV0wccy5vYFTr
        HBXPNh44vq3O8GKQAdbTGk/s2uooNaOYssIu3ioV4iu7DeC7y/FgNCdddTZWodJJ6JIXm3PqTGQJU
        iYTNTlxW7PsnJY3IGDAwDotKhtqZY+pkuB84vr4KCxdLzk0/h0gE/Y8EE5+YVbT6jZUjz+EReVx21
        eRZl8S8A==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kae1a-0004aX-Qo; Thu, 05 Nov 2020 12:05:55 +0000
Date:   Thu, 5 Nov 2020 12:05:54 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org,
        Jann Horn <jannh@google.com>
Subject: Re: [PATCH] page_frag: Recover from memory pressure
Message-ID: <20201105120554.GJ17076@casper.infradead.org>
References: <20201105042140.5253-1-willy@infradead.org>
 <83d68f28-cae7-012d-0f4b-82960b248bd8@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83d68f28-cae7-012d-0f4b-82960b248bd8@suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 12:56:43PM +0100, Vlastimil Babka wrote:
> > +++ b/mm/page_alloc.c
> > @@ -5139,6 +5139,10 @@ void *page_frag_alloc(struct page_frag_cache *nc,
> >   		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
> >   			goto refill;
> > +		if (nc->pfmemalloc) {
> > +			free_the_page(page, compound_order(page));
> > +			goto refill;
> 
> Theoretically the refill can fail and we return NULL while leaving nc->va
> pointing to a freed page, so I think you should set nc->va to NULL.
> 
> Geez, can't the same thing already happen after we sub the nc->pagecnt_bias
> from page ref, and last users of the page fragments then return them and dec
> the ref to zero and the page gets freed?

I don't think you read __page_frag_cache_refill() closely enough ...

        if (unlikely(!page))
                page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);

        nc->va = page ? page_address(page) : NULL;

