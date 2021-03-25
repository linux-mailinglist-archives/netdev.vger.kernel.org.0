Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4925A3493C9
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhCYOLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhCYOLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:11:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE444C06174A;
        Thu, 25 Mar 2021 07:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JP8HgLro6AbZLt2MNRw3IANQzsJHTI7f+9qGAMl8N+o=; b=DqxCWL1Jwo4lXLuI8106Mtc5CH
        xO+DdWDRM0Td8F33WQ76z6ScIV5K9cYesdzhidA/U59KlheKVM9ru2K4rQw+FnZkihJjyMCJWDrOB
        qoTYDqRIOc8GtvXzO7LrF3nxl7VwtYxe9RD0c91IGwws8nuVnV495Fsx1nuJK1jtbgWJHMI5raAKA
        vcAi/HluSaIZCxyhhvx9VlaqFcsrhsys7PvvJTLqBH8C4wVDp7quMAkJsNG3heDRjBQ2L8GmrV48a
        O994D1ERIF8PdGJwzN2cAFG6T8e9DjIxlVUAu62LmDxaGMO+iWxXfEG1g89MlJUqZu5sAmczL519w
        rZzBKMtg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPQfv-00D2MO-Bh; Thu, 25 Mar 2021 14:09:33 +0000
Date:   Thu, 25 Mar 2021 14:09:27 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 0/9 v6] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210325140927.GX1719932@casper.infradead.org>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325125001.GW1719932@casper.infradead.org>
 <20210325132556.GS3697@techsingularity.net>
 <20210325140657.GA1908@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140657.GA1908@pc638.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 03:06:57PM +0100, Uladzislau Rezki wrote:
> For the vmalloc we should be able to allocating on a specific NUMA node,
> at least the current interface takes it into account. As far as i see
> the current interface allocate on a current node:
> 
> static inline unsigned long
> alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
> {
>     return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
> }
> 
> Or am i missing something?

You can call __alloc_pages_bulk() directly; there's no need to indirect
through alloc_pages_bulk_array().
