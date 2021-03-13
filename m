Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5433A07A
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 20:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhCMTeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 14:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbhCMTeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 14:34:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A231C061574;
        Sat, 13 Mar 2021 11:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XEK6hz1RiF2srncvGYUoijb4RJd3OOh8GOj97RoSgzg=; b=MfLfCrbDHkQGKWILAZJ0QdhdYE
        vhWE5RlzGxTVbg9r852SBDzIOPB3EJqKi28Po9JTtiQd7NPnOqGQfuxX7eD0QZHV3Du8wZjZN6XGH
        nZaJnkHZqH3NTVyDiiLdmSZAT7G5YcquYKzoEd2I2dJJ5jyq9imbeeggSWID82KnEMYk8ClCsv5n1
        kjp1FjVdjRAesnxBn0VDXNFgz/iNWZm9xPzzHWWTDq4x4qVlY1JyYmuTqAHDKsD1zzz92R9bdxRga
        FdT9KgoHX9CpqCHdmF7AaFdHQQ5/oTCxxj/HZJ+B+1ZnXbxHfzH0aqETs5zNWid28HojwjEefhiWt
        HUYC76kw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLA19-00Ef89-Oh; Sat, 13 Mar 2021 19:33:45 +0000
Date:   Sat, 13 Mar 2021 19:33:43 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210313193343.GJ2577561@casper.infradead.org>
References: <20210310104618.22750-3-mgorman@techsingularity.net>
 <20210310154650.ad9760cd7cb9ac4acccf77ee@linux-foundation.org>
 <20210311084200.GR3697@techsingularity.net>
 <20210312124609.33d4d4ba@carbon>
 <20210312145814.GA2577561@casper.infradead.org>
 <20210312160350.GW3697@techsingularity.net>
 <20210312210823.GE2577561@casper.infradead.org>
 <20210313131648.GY3697@techsingularity.net>
 <20210313163949.GI2577561@casper.infradead.org>
 <7D8C62E1-77FD-4B41-90D7-253D13715A6F@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7D8C62E1-77FD-4B41-90D7-253D13715A6F@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 04:56:31PM +0000, Chuck Lever III wrote:
> IME lists are indeed less CPU-efficient, but I wonder if that
> expense is insignificant compared to serialization primitives like
> disabling and re-enabling IRQs, which we are avoiding by using
> bulk page allocation.

Cache misses are a worse problem than serialisation.  Paul McKenney had
a neat demonstration where he took a sheet of toilet paper to represent
an instruction, and then unrolled two rolls of toilet paper around the
lecture theatre to represent an L3 cache miss.  Obviously a serialising
instruction is worse than an add instruction, but i'm thinking maybe
50-100 sheets of paper, not an entire roll?

Anyway, I'm not arguing against a bulk allocator, nor even saying this
is a bad interface.  It just maybe could be better.

> My initial experience with the current interface left me feeling
> uneasy about re-using the lru list field. That seems to expose an
> internal API feature to consumers of the page allocator. If we
> continue with a list-centric bulk allocator API I hope there can
> be some conveniently-placed documentation that explains when it is
> safe to use that field. Or perhaps the field should be renamed.

Heh.  Spoken like a filesystem developer who's never been exposed to the
->readpages API (it's almost dead).  It's fairly common in the memory
management world to string pages together through the lru list_head.
Slab does it, as does put_pages_list() in mm/swap.c.  It's natural for
Mel to keep using this pattern ... and I dislike it intensely.

> I have a mild preference for an array-style interface because that's
> more natural for the NFSD consumer, but I'm happy to have a bulk
> allocator either way. Purely from a code-reuse point of view, I
> wonder how many consumers of alloc_pages_bulk() will be like
> svc_alloc_arg(), where they need to fill in pages in an array. Each
> such consumer would need to repeat the logic to convert the returned
> list into an array. We have, for instance, release_pages(), which is
> an array-centric page allocator API. Maybe a helper function or two
> might prevent duplication of the list conversion logic.
> 
> And I agree with Mel that passing a single large array seems more
> useful then having to build code at each consumer call-site to
> iterate over smaller page_vecs until that array is filled.

So how about this?

You provide the interface you'd _actually_ like to use (array-based) and
implement it on top of Mel's lru-list implementation.  If it's general
enough to be used by Jesper's use-case, we lift it to page_alloc.c.
If we go a year and there are no users of the lru-list interface, we
can just change the implementation.

