Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F06C345C92
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 12:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCWLPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 07:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCWLOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 07:14:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14915C061574;
        Tue, 23 Mar 2021 04:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y84vyVtzN2lJMPwpRJEXd+7sY33jMaB9TI4VW5KpThg=; b=dbK6qh0oPN5dwcqBP4Lotym+K9
        Dq7fBGlbxPIi0u+BDfP00Sdg5tGCo2fI8Y2rSVuJvC+POqPpL2hlE/dMoMrYk7XTOXBa+gh8BED9N
        KmBI5DBFkms8lTdcUUfSf/MUxo4I0c2wgeTIbQ8ikTpv0ci3u5TRavf2MU7fzAYETLyTxNBhwcKJ1
        udsNEo60MGTKOlAySosXIqHxOXaeibaTCdaQI0S49LSX6UdRPknjShmT7RSn9oBG3Cxj9uG7d2boz
        BCvCfPi3S9AVqPgLWlqAuZQ22M5tiYUzDgyuaHbwCD5zz5yUzD8lmgwg9VyA81lVVl/K0yOYof5NS
        UFmFud4Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOeyI-009xbs-43; Tue, 23 Mar 2021 11:13:34 +0000
Date:   Tue, 23 Mar 2021 11:13:14 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210323111314.GB1719932@casper.infradead.org>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
 <C1DEE677-47B2-4B12-BA70-6E29F0D199D9@oracle.com>
 <20210322194948.GI3697@techsingularity.net>
 <0E0B33DE-9413-4849-8E78-06B0CDF2D503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0E0B33DE-9413-4849-8E78-06B0CDF2D503@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 08:32:54PM +0000, Chuck Lever III wrote:
> > It's not expected that the array implementation would be worse *unless*
> > you are passing in arrays with holes in the middle. Otherwise, the success
> > rate should be similar.
> 
> Essentially, sunrpc will always pass an array with a hole.
> Each RPC consumes the first N elements in the rq_pages array.
> Sometimes N == ARRAY_SIZE(rq_pages). AFAIK sunrpc will not
> pass in an array with more than one hole. Typically:
> 
> .....PPPP
> 
> My results show that, because svc_alloc_arg() ends up calling
> __alloc_pages_bulk() twice in this case, it ends up being
> twice as expensive as the list case, on average, for the same
> workload.

Can you call memmove() to shift all the pointers down to be the
first N elements?  That prevents creating a situation where we have

PPPPPPPP (consume 6)
......PP (try to allocate 6, only 4 available)
PPPP..PP

instead, you'd do:

PPPPPPPP (consume 6)
PP...... (try to allocate 6, only 4 available)
PPPPPP..

Alternatively, you could consume from the tail of the array instead of
the head.  Some CPUs aren't as effective about backwards walks as they
are for forwards walks, but let's keep the pressure on CPU manufacturers
to make better CPUs.

