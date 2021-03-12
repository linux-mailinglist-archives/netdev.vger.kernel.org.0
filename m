Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2803F339087
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhCLO6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbhCLO6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:58:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C87C061574;
        Fri, 12 Mar 2021 06:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gbwXnklzt/GG9mR0QlG6dEwq91Rd29SehOBGiJv9f4I=; b=CpQ/MsjIbARHlgT6/AtQcg8Ca1
        AlCQYEU5FW9EGK2Rh6SM3snZpU86x48JpBlCdpy5TpenJW/oXb2UTZDN1/V0FUv6ChVHZYKr3xOek
        dAbLoi2hZdasuqQ0TQcHeJxAU6/LvEsR3Wr9F+tZDJ4S8y1sWwAW95zs9m4MAt1Lq4UMFztOHzWJt
        Pr5Vr3ICL7BxnigC+pwYsEqwbXIYVcHlx9CHqjYYDbr7mho/t1vPUDDy9j9onA912rxluott0fDxB
        3DX/ErLlSB6dKS7zBPlRyvG3jYtRzNXhXsphl3ghNthhllxd5SJEcymDO1Yj4K8gTgKRAjQzi1wEG
        2n+zmszA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKjF0-00AvFJ-OO; Fri, 12 Mar 2021 14:58:16 +0000
Date:   Fri, 12 Mar 2021 14:58:14 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210312145814.GA2577561@casper.infradead.org>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net>
 <20210312124609.33d4d4ba@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312124609.33d4d4ba@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 12:46:09PM +0100, Jesper Dangaard Brouer wrote:
> In my page_pool patch I'm bulk allocating 64 pages. I wanted to ask if
> this is too much? (PP_ALLOC_CACHE_REFILL=64).
> 
> The mlx5 driver have a while loop for allocation 64 pages, which it
> used in this case, that is why 64 is chosen.  If we choose a lower
> bulk number, then the bulk-alloc will just be called more times.

The thing about batching is that smaller batches are often better.
Let's suppose you need to allocate 100 pages for something, and the page
allocator takes up 90% of your latency budget.  Batching just ten pages
at a time is going to reduce the overhead to 9%.  Going to 64 pages
reduces the overhead from 9% to 2% -- maybe that's important, but
possibly not.

> The result of the API is to deliver pages as a double-linked list via
> LRU (page->lru member).  If you are planning to use llist, then how to
> handle this API change later?
> 
> Have you notice that the two users store the struct-page pointers in an
> array?  We could have the caller provide the array to store struct-page
> pointers, like we do with kmem_cache_alloc_bulk API.

My preference would be for a pagevec.  That does limit you to 15 pages
per call [1], but I do think that might be enough.  And the overhead of
manipulating a linked list isn't free.

[1] patches exist to increase this, because it turns out that 15 may
not be enough for all systems!  but it would limit to 255 as an absolute
hard cap.
