Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F65671311
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 06:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjARFRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 00:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjARFRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 00:17:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D38C41B71
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 21:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zpeZ7xJdduTbUjubbB3znu1VjyoPIaNapdi9kr0F5ds=; b=AopJM9OwFcbu6lZB24J/xdjB2R
        Pp3wgRbLaC47dvEN+l5OHHmVpTNePAAiNyfvS2Mz2P5r9o/jNkS3zcwsz/syab6SwPHq7rlRlVBNo
        K0RKYM2Iz+VV1mR6mQYV7e0jnkuBkowsSL8WPE4I0uXOuPk3/TZYXA7yXnd/iEYq+gWYXnaikP0fq
        4AVOSNVkIwm0VqXcsY+CZ+1Ydqmts2kdDFmWqDjY+odNgwGZZ/kH0sc2TOycAt8llqAHknFHOIDAK
        F0Ya+KSmgmLBzquW0ii5ak23NIIOdz5rnCa9KWflx5uN/LmhePzmmhdVtk9g5MEJJlBU1YQ4mGkGh
        MbFMbQmA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pI0p1-00ANE1-7k; Wed, 18 Jan 2023 05:17:15 +0000
Date:   Wed, 18 Jan 2023 05:17:15 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Lameter <cl@gentwo.de>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
        vbabka@suse.cz, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
Message-ID: <Y8eA2xZ0KC2ZDinu@casper.infradead.org>
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
 <36f5761f-d4d9-4ec9-a64-7a6c6c8b956f@gentwo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36f5761f-d4d9-4ec9-a64-7a6c6c8b956f@gentwo.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 03:54:34PM +0100, Christoph Lameter wrote:
> On Tue, 17 Jan 2023, Jesper Dangaard Brouer wrote:
> 
> > When running different network performance microbenchmarks, I started
> > to notice that performance was reduced (slightly) when machines had
> > longer uptimes. I believe the cause was 'skbuff_head_cache' got
> > aliased/merged into the general slub for 256 bytes sized objects (with
> > my kernel config, without CONFIG_HARDENED_USERCOPY).
> 
> Well that is a common effect that we see in multiple subsystems. This is
> due to general memory fragmentation. Depending on the prior load the
> performance could actually be better after some runtime if the caches are
> populated avoiding the page allocator etc.

The page allocator isn't _that_ expensive.  I could see updating several
slabs being more expensive than allocating a new page.

> The merging could actually be beneficial since there may be more partial
> slabs to allocate from and thus avoiding expensive calls to the page
> allocator.

What might be more effective is allocating larger order slabs.  I see
that kmalloc-256 allocates a pair of pages and manages 32 objects within
that pair.  It should perform better in Jesper's scenario if it allocated
4 pages and managed 64 objects per slab.

Simplest way to test that should be booting a kernel with
'slub_min_order=2'.  Does that help matters at all, Jesper?  You could
also try slub_min_order=3.  Going above that starts to get a bit sketchy.
