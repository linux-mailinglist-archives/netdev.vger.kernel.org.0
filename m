Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6885C338D59
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 13:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhCLMoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 07:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhCLMoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 07:44:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C65C061574;
        Fri, 12 Mar 2021 04:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kA2zAbVU2u9LtJpiwYGKaIj40CL11SeMzPwy8fqCxkY=; b=kf7NOn2KwwvzyGg78S230QQcFN
        MIXvadkSKEGfs3IHGJYDuqpq7MQvxUHU8YT1P8C7AoXgk/YM55DC8ixq3tLScOup5+O6bBCL/4JCg
        c8aAkcRMZMUU0iPxI0YHCmqB1j5nivVV7u8fXzId29IajJupo3WZOMQVJ9HjrGxBlvU60ue7gnFmr
        aQP7ZFF+qIVomRCv4AL4WFChMBhJDpQLWNHdV57AFLYIdTvsWmWrbJg0sCLvBYRXn9GAKns6AoM56
        3q48mGoGEOR8JwVIwMbtxOA5aND4OcK+zojxIaDwMqVwZQV5n2xLMvdZ37fEFAJUe34nQeuv2S+kk
        /+WdLXCg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKh8d-00Af8Y-Mi; Fri, 12 Mar 2021 12:43:38 +0000
Date:   Fri, 12 Mar 2021 12:43:31 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210312124331.GY3479805@casper.infradead.org>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310104618.22750-3-mgorman@techsingularity.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:46:15AM +0000, Mel Gorman wrote:
> +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> +				nodemask_t *nodemask, int nr_pages,
> +				struct list_head *list);

For the next revision, can you ditch the '_nodemask' part of the name?
Andrew just took this patch from me:

    mm/page_alloc: combine __alloc_pages and __alloc_pages_nodemask
    
    There are only two callers of __alloc_pages() so prune the thicket of
    alloc_page variants by combining the two functions together.  Current
    callers of __alloc_pages() simply add an extra 'NULL' parameter and
    current callers of __alloc_pages_nodemask() call __alloc_pages() instead.

...

-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
-                                                       nodemask_t *nodemask);
-
-static inline struct page *
-__alloc_pages(gfp_t gfp_mask, unsigned int order, int preferred_nid)
-{
-       return __alloc_pages_nodemask(gfp_mask, order, preferred_nid, NULL);
-}
+struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
+               nodemask_t *nodemask);

So calling this function __alloc_pages_bulk() fits with the new naming
scheme.

> @@ -4919,6 +4934,9 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  		struct alloc_context *ac, gfp_t *alloc_mask,
>  		unsigned int *alloc_flags)
>  {
> +	gfp_mask &= gfp_allowed_mask;
> +	*alloc_mask = gfp_mask;

Also I renamed alloc_mask to alloc_gfp.

