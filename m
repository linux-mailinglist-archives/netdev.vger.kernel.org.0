Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B2F413778
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhIUQXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhIUQXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:23:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EF0C061574;
        Tue, 21 Sep 2021 09:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9/YVI0YfDL2V4vcHeVmIRPEOUQt1TJerDuRFTwKveSE=; b=AVS/5IVt0MCm2i6EdN5eEegLQo
        y4M1Ea3I0Vii+1zNHmWuCVaMY72NHXxis7XkhIug7SJCSHUJk6gUwX7A8DwjBMrKyoJg7iAWec7OC
        HV8Bc4tHIM5Of2fmfhIQZarEfk/f5KLKmSpSHBZMvTO76TzWlHhIGnj6i9Auoi4vhN/NizQVQWbuu
        NFnOYCQZOkgB4KEHzmWWgP/FY3zHJ2D1EBKX3oTEh2sojbj7wjNEpernXSyfyw6Bsjk5hqJXdBAiZ
        J8zqJb6fNxwgSxO/qnWezM10SOUMPPTyYKldhdco+ZnmPf69EFrzyWdoIzYGrL7WRGt88kWkIMxb0
        MCgeNkCw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSiS6-003xNv-8T; Tue, 21 Sep 2021 16:18:00 +0000
Date:   Tue, 21 Sep 2021 17:17:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC v2 PATCH] mm, sl[au]b: Introduce lockless cache
Message-ID: <YUoFfrQBmOdPEKpJ@casper.infradead.org>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
 <YUkErK1vVZMht4s8@casper.infradead.org>
 <20210921154239.GA5092@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921154239.GA5092@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 03:42:39PM +0000, Hyeonggon Yoo wrote:
> > > +	/* slowpath */
> > > +	cache->size = kmem_cache_alloc_bulk(s, gfpflags,
> > > +			KMEM_LOCKLESS_CACHE_QUEUE_SIZE, cache->queue);
> > 
> > Go back to the Bonwick paper and look at the magazine section again.
> > You have to allocate _half_ the size of the queue, otherwise you get
> > into pathological situations where you start to free and allocate
> > every time.
> 
> I want to ask you where idea of allocating 'half' the size of queue came from.
> the paper you sent does not work with single queue(magazine). Instead,
> it manages pool of magazines.
> 
> And after reading the paper, I see managing pool of magazine (where M is
> an boot parameter) is valid approach to reduce hitting slowpath.

Bonwick uses two magazines per cpu; if both are empty, one is replaced
with a full one.  If both are full, one is replaced with an empty one.
Our slab implementation doesn't provide magazine allocation, but it does
provide bulk allocation.  So translating the Bonwick implementation to
our implementation, we need to bulk-allocate or bulk-free half of the
array at any time.
