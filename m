Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C11B665C53
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjAKNVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjAKNVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:21:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30540218E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZTxw1IhoqyhcP1yUo5XkUCWtzN92jEMENZkKcEWPu2U=; b=gnlfRi6PxMA1A3cV6DQB2p3Oot
        oyHvzbi6TmJyAVpvGY3lZkXtZL2A2SD237oT0K2N6ge7ObOZnx5vDr18gDeRuW6W66OEWFALIxH82
        y8inrGCm91jH/JSzomn65Do7VB6Z0Q9pUwQxNtwTn7L14HeJWl7ONy9oQ7EEqQFMV5MCmzHC7Xkb5
        roqs7yC0GAZsuLldmiNlfaR5CsR3gf8beVwmXZn9nZft9gLYGwRofuCQAOYQaO3cLIaeIxBawawGW
        QmgAkJpxLXJAa9KY1FkOBf5Lw4YFad0H2ObTROyzS4FKR7MFGwLh3/hxhWx5vphK0w0miJCCJ3Dw/
        TcHje3Zg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFb2L-0049x3-LQ; Wed, 11 Jan 2023 13:21:01 +0000
Date:   Wed, 11 Jan 2023 13:21:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3 00/26] Split netmem from struct page
Message-ID: <Y763vcTFUZvWNgYv@casper.infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
 <e9bb4841-6f9d-65c2-0f78-b307615b009a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9bb4841-6f9d-65c2-0f78-b307615b009a@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 04:25:46PM +0800, Yunsheng Lin wrote:
> On 2023/1/11 12:21, Matthew Wilcox (Oracle) wrote:
> > The MM subsystem is trying to reduce struct page to a single pointer.
> > The first step towards that is splitting struct page by its individual
> > users, as has already been done with folio and slab.  This patchset does
> > that for netmem which is used for page pools.
> 
> As page pool is only used for rx side in the net stack depending on the
> driver, a lot more memory for the net stack is from page_frag_alloc_align(),
> kmem cache, etc.
> naming it netmem seems a little overkill, perhaps a more specific name for
> the page pool? such as pp_cache.
> 
> @Jesper & Ilias
> Any better idea?
> And it seem some API may need changing too, as we are not pooling 'pages'
> now.

I raised the question of naming in v1, six weeks ago, and nobody had
any better names.  Seems a little unfair to ignore the question at first
and then bring it up now.  I'd hate to miss the merge window because of
a late-breaking major request like this.

https://lore.kernel.org/netdev/20221130220803.3657490-1-willy@infradead.org/

I'd like to understand what we think we'll do in networking when we trim
struct page down to a single pointer,  All these usages that aren't from
page_pool -- what information does networking need to track per-allocation?
Would it make sense for the netmem to describe all memory used by the
networking stack, and have allocators other than page_pool also return
netmem, or does the normal usage of memory in the net stack not need to
track that information?

> > Matthew Wilcox (Oracle) (26):
> >   netmem: Create new type
> >   netmem: Add utility functions
> >   page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
> >   page_pool: Convert page_pool_release_page() to
> >     page_pool_release_netmem()
> >   page_pool: Start using netmem in allocation path.
>                                                     ^
> nit: there is a '.' at the end of patch titile.

Thanks, I'll fix that for v4.

