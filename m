Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA36A346190
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhCWOei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:34:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:53558 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231830AbhCWOeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 10:34:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616510061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U6AYmAE3axZU7Y0KUT99DSxo5RPJIf5s+7Dy88I1Wdg=;
        b=vUoROcuhUJ8TVeKb7PORfNjQR1dmz/iSaXTllYT7iJQTfH0qjQLXrU+7jK2uLB7GR2hoFG
        m+8V9mml9J2vpquf2lzURMMvfwwKcmQCcNKfWXvUV0odfTIdwUgQSOhBILiplh1EFx4ucw
        ppXcwU9GX3xYTiamctYDF0mhMZc1NBQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1ECE0ACBF;
        Tue, 23 Mar 2021 14:34:21 +0000 (UTC)
Date:   Tue, 23 Mar 2021 15:34:20 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Arjun Roy <arjunroy@google.com>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFJ+5+NBOBiUbGWS@cmpxchg.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
[...]
> Here is an idea of how it could work:
> 
> struct page already has
> 
>                 struct {        /* page_pool used by netstack */
>                         /**
>                          * @dma_addr: might require a 64-bit value even on
>                          * 32-bit architectures.
>                          */
>                         dma_addr_t dma_addr;
>                 };
> 
> and as you can see from its union neighbors, there is quite a bit more
> room to store private data necessary for the page pool.
> 
> When a page's refcount hits zero and it's a networking page, we can
> feed it back to the page pool instead of the page allocator.
> 
> From a first look, we should be able to use the PG_owner_priv_1 page
> flag for network pages (see how this flag is overloaded, we can add a
> PG_network alias). With this, we can identify the page in __put_page()
> and __release_page(). These functions are already aware of different
> types of pages and do their respective cleanup handling. We can
> similarly make network a first-class citizen and hand pages back to
> the network allocator from in there.

For compound pages we have a concept of destructors. Maybe we can extend
that for order-0 pages as well. The struct page is heavily packed and
compound_dtor shares the storage without other metadata
                                        int    pages;    /*    16     4 */
                        unsigned char compound_dtor;     /*    16     1 */
                        atomic_t   hpage_pinned_refcount; /*    16     4 */
                        pgtable_t  pmd_huge_pte;         /*    16     8 */
                        void *     zone_device_data;     /*    16     8 */

But none of those should really require to be valid when a page is freed
unless I am missing something. It would really require to check their
users whether they can leave the state behind. But if we can establish a
contract that compound_dtor can be always valid when a page is freed
this would be really a nice and useful abstraction because you wouldn't
have to care about the specific type of page.

But maybe I am just overlooking the real complexity there.
-- 
Michal Hocko
SUSE Labs
