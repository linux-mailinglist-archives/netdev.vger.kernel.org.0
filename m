Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3496134918D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhCYMHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhCYMH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:07:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01A9C06174A;
        Thu, 25 Mar 2021 05:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SX63SSXBBS8pfUBjqJXaKRwLtoxqCsaqqgX1eXw+KL8=; b=BlpX2J9DGfGSWThsGnCnGaLc8M
        IzFqTU3JIj7wN37putBxoc6ddcJ+pMmBH60tPqfy5guBXz+ObmQBpNkNwoDGlVvt1QuI+2ihyYdeX
        JOmM3sABRl/iWfAdzl8qRZVaTtYAKNuGvRQK3eZlHm3CUbmtOemmWoGwsUIKUZT8KJaRDaWJvzQbW
        0GrNHjHvJMHENl3NDzMNXzYMJ7OmmNVzenNTO920WJuWtEQrZg+vFhrPPXbM1jCTNA97WDzQFVu0f
        VsdOatqvv7RRv6/hmyQF6ROHBW9b+UqmiCwHVBW0jMvGRvpcjS9lh77rgsYfZHBJI6Dvfnr5s/G3Z
        C+TY7v2g==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPOjt-00CrhC-DX; Thu, 25 Mar 2021 12:05:34 +0000
Date:   Thu, 25 Mar 2021 12:05:25 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210325120525.GU1719932@casper.infradead.org>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-3-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325114228.27719-3-mgorman@techsingularity.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 11:42:21AM +0000, Mel Gorman wrote:
> +int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> +				nodemask_t *nodemask, int nr_pages,
> +				struct list_head *list);
> +
> +/* Bulk allocate order-0 pages */
> +static inline unsigned long
> +alloc_pages_bulk(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
> +{
> +	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, list);

Discrepancy in the two return types here.  Suspect they should both
be 'unsigned int' so there's no question about "can it return an errno".

>  
> +/*

If you could make that "/**" instead ...

