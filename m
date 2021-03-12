Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AA53390E1
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhCLPLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbhCLPKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:10:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608EAC061574;
        Fri, 12 Mar 2021 07:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PGicOecPTl82O+7IKA07blzMMq5LKKLTqGu6MRSyaSY=; b=Wug9nQ81BRxnzSIOt7fbCTQild
        cafzlxjkiw5dVoXgkCIKFukV6WYtZhr6HlbGnjnPFvrctWDCWSNbIOsXPg+0qkOKZ8a7aS1OffmxQ
        KW2eLbB+lddTJ6aTYiKXUffO6QAI8wbFE4/1pML2749rrxd9p+DJYJ174htipjl7V4a2mDBTkq1kT
        jC46EyvUwnS7FJQnDFpLCeEwi5jZEl29P469M/jyYD7pqhESrZUJz6URb6Bupd6mRrL0jeEtL9qB7
        aHqsj35XEb51oD/PMP+ICUny6ZB5VqKfpbn5x3pS2vPDYSbeMnWp/YWucWNy7ESv4sqgPlq8CwDwJ
        Um2NDW1w==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKjQn-00Ax1J-2I; Fri, 12 Mar 2021 15:10:27 +0000
Date:   Fri, 12 Mar 2021 15:10:25 +0000
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
Subject: Re: [PATCH 0/5] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210312151025.GB2577561@casper.infradead.org>
References: <20210310104618.22750-1-mgorman@techsingularity.net>
 <20210310154704.9389055d0be891a0c3549cc2@linux-foundation.org>
 <20210311084827.GS3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311084827.GS3697@techsingularity.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 08:48:27AM +0000, Mel Gorman wrote:
> I don't have that information unfortunately. It's a chicken and egg
> problem because without the API, there is no point creating new users.
> For example, fault around or readahead could potentially batch pages
> but whether it is actually noticable when page zeroing has to happen
> is a completely different story. It's a similar story for SLUB, we know
> lower order allocations hurt some microbenchmarks like hackbench-sockets
> but have not quantified what happens if SLUB batch allocates pages when
> high-order allocations fail.

I'm planning on reducing overhead in the readahead path by allocating
higher-order pages rather than by allocating a batch of order-0 pages.
With the old ->readpages interface, it would have made sense to allocate a
batch of pages, but with the new ->readahead interface, we put the pages
into the page cache for the filesystem, so it doesn't make as much sense
any more.

Right now, measuring performance in the readahead path is hard because
we end up contending against kswapd that's trying to evict all the clean
pages that we earlier readahead into this same file.  Could avoid that by
having N files, each about half the size of memory, but then we restart
the readahead algorithm for each file ...

I feel like the real solution for that is to do a GFP_NOWAIT allocation,
then try to evict earlier pages for the same file we're working on so
that kswapd doesn't get woken up if we're just streaming a read through
a gargantuan file.  But I should probably talk to Johannes first.
