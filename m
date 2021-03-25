Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B538B349270
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCYMw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhCYMwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:52:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31285C06174A;
        Thu, 25 Mar 2021 05:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+fJyRPjPHNtlghEko2J6bkm8lY/1dD+5carH2dkRuBY=; b=A54uDjel/l4krSoFnRy/JdfLER
        qeJhhESqagjhx8b7io6lqkwGBhhoSEta5dPJoijGsTJ0QwK1EKxLi2XKv0eUa2pMdj4M+VKv+9+Ss
        LxU8E8mh9hzYI+tc3wU29i6e1QG9eHMFADnARRDg93i7elTemxwP/hccNuc0Gm5lP1GKlgiBbfEUi
        gj0+meXzcXIQFpV7zrYlhAESkDdpOStg40WFVeRPGJuCQGeia/ftJrH0e2v3Fe5oQd0uBcr2PK5EN
        LgAG8CK2bXfnHT0XBAfIniFa/xDR53t9k2btD6RNVC7ajWgpu34wRUY4aOk5LvnpkPvH8uRc8CZwH
        0Oa5ybVw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPPR3-00Cv3Q-IW; Thu, 25 Mar 2021 12:50:42 +0000
Date:   Thu, 25 Mar 2021 12:50:01 +0000
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
Subject: Re: [PATCH 0/9 v6] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210325125001.GW1719932@casper.infradead.org>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325114228.27719-1-mgorman@techsingularity.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 11:42:19AM +0000, Mel Gorman wrote:
> This series introduces a bulk order-0 page allocator with sunrpc and
> the network page pool being the first users. The implementation is not
> efficient as semantics needed to be ironed out first. If no other semantic
> changes are needed, it can be made more efficient.  Despite that, this
> is a performance-related for users that require multiple pages for an
> operation without multiple round-trips to the page allocator. Quoting
> the last patch for the high-speed networking use-case
> 
>             Kernel          XDP stats       CPU     pps           Delta
>             Baseline        XDP-RX CPU      total   3,771,046       n/a
>             List            XDP-RX CPU      total   3,940,242    +4.49%
>             Array           XDP-RX CPU      total   4,249,224   +12.68%
> 
> >From the SUNRPC traces of svc_alloc_arg()
> 
> 	Single page: 25.007 us per call over 532,571 calls
> 	Bulk list:    6.258 us per call over 517,034 calls
> 	Bulk array:   4.590 us per call over 517,442 calls
> 
> Both potential users in this series are corner cases (NFS and high-speed
> networks) so it is unlikely that most users will see any benefit in the
> short term. Other potential other users are batch allocations for page
> cache readahead, fault around and SLUB allocations when high-order pages
> are unavailable. It's unknown how much benefit would be seen by converting
> multiple page allocation calls to a single batch or what difference it may
> make to headline performance.

We have a third user, vmalloc(), with a 16% perf improvement.  I know the
email says 21% but that includes the 5% improvement from switching to
kvmalloc() to allocate area->pages.

https://lore.kernel.org/linux-mm/20210323133948.GA10046@pc638.lan/

I don't know how many _frequent_ vmalloc users we have that will benefit
from this, but it's probably more than will benefit from improvements
to 200Gbit networking performance.
