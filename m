Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4264E48A6CB
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 05:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347870AbiAKEdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 23:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiAKEdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 23:33:01 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA24C06173F;
        Mon, 10 Jan 2022 20:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Weh6b9gFW7u95WZ3fLgbX0xHy9YQw+y8aATtGfb9KPk=; b=QbEVmLb7c71g917OtGsCpYozqz
        NahoDOK/ASMcUKOsu8udIeCBf7rigwUpe17iM9vaZsxms0gwiYv74P/RUIZesqYIcv4/bgM7D92cE
        OUo+2dK5IqhimAh4KvP9MBSgIpQmy9oD3lk+R6zzZDsIC5EvPaI/sR6nZNo3ENDOrWrH5uExLX/qQ
        9sRGHC2d2IuVaNdNwZKYoKblFN1JOIhANzNpXPKbEXQ5zRayxoS7X9I3HoxbjQfqdilVLIV4FjmVx
        65MinbN8fCC2biLDFMYV54SUO1f1oKjno5s+fAzi26w/3BM3QTvBzkmUp3v1iLy5hJW17b5I6UeXS
        xV4oTKag==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n78q8-002y1G-Cq; Tue, 11 Jan 2022 04:32:56 +0000
Date:   Tue, 11 Jan 2022 04:32:56 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <Yd0IeK5s/E0fuWqn@casper.infradead.org>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111004126.GJ2328285@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 08:41:26PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 10, 2022 at 07:34:49PM +0000, Matthew Wilcox wrote:
> 
> > Finally, it may be possible to stop using scatterlist to describe the
> > input to the DMA-mapping operation.  We may be able to get struct
> > scatterlist down to just dma_address and dma_length, with chaining
> > handled through an enclosing struct.
> 
> Can you talk about this some more? IMHO one of the key properties of
> the scatterlist is that it can hold huge amounts of pages without
> having to do any kind of special allocation due to the chaining.
> 
> The same will be true of the phyr idea right?

My thinking is that we'd pass a relatively small array of phyr (maybe 16
entries) to get_user_phyr().  If that turned out not to be big enough,
then we have two options; one is to map those 16 ranges with sg and use
the sg chaining functionality before throwing away the phyr and calling
get_user_phyr() again.  The other is to stash those 16 ranges somewhere
(eg a resizing array of some kind) and keep calling get_user_phyr()
to get the next batch of 16; once we've got the entire range, call
sg_map_phyr() passing all of the phyrs.

> > I would like to see phyr replace bio_vec everywhere it's currently used.
> > I don't have time to do that work now because I'm busy with folios.
> > If someone else wants to take that on, I shall cheer from the sidelines.
> > What I do intend to do is:
> 
> I wonder if we mixed things though..
> 
> IMHO there is a lot of optimization to be had by having a
> datastructure that is expressly 'the physical pages underlying a
> contiguous chunk of va'
> 
> If you limit to that scenario then we can be more optimal because
> things like byte granular offsets and size in the interior pages don't
> need to exist. Every interior chunk is always aligned to its order and
> we only need to record the order.
> 
> An overall starting offset and total length allow computing the slice
> of the first/last entry.
> 
> If the physical address is always aligned then we get 12 free bits
> from the min 4k alignment and also only need to store order, not an
> arbitary byte granular length.
> 
> The win is I think we can meaningfully cover most common cases using
> only 8 bytes per physical chunk. The 12 bits can be used to encode the
> common orders (4k, 2M, 1G, etc) and some smart mechanism to get
> another 16 bits to cover 'everything'.
> 
> IMHO storage density here is quite important, we end up having to keep
> this stuff around for a long time.
> 
> I say this here, because I've always though bio_vec/etc are more
> general than we actually need, being byte granular at every chunk.

Oh, I can do you one better on the bit-packing scheme.  There's a
representation of every power-of-two that is naturally aligned, using
just one extra bit.  Let's say we have 3 bits of address space and
4 bits to represent any power of two allocation within that address
space:

0000 index-0, order-0
0010 index-1, order-0
...
1110 index-7, order-0
0001 index-0, order-1
0101 index-2, order-1
1001 index-4, order-1
1101 index-6, order-1
0011 index-0, order-2
1011 index-4, order-2
0111 index-0, order-3

1111 has no meaning and can be used to represent an invalid range, if
that's useful.  The lowest clear bit decodes to the order, and
(x & (x+1))/2 gets you the index.

That leaves you with another 11 bits to represent something smart about
partial pages.

The question is whether this is the right kind of optimisation to be
doing.  I hear you that we want a dense format, but it's questionable
whether the kind of thing you're suggesting is actually denser than this
scheme.  For example, if we have 1GB pages and userspace happens to have
allocated pages (3, 4, 5, 6, 7, 8, 9, 10) then this can be represented
as a single phyr.  A power-of-two scheme would have us use four entries
(3, 4-7, 8-9, 10).

Using a (dma_addr, size_t) tuple makes coalescing adjacent pages very
cheap.  If I have to walk PTEs looking for pages which can be combined
together, I end up with interesting behaviour where the length of the
list shrinks and expands.  Using the example above, as I walk successive
PUDs, the data struct looks like this:

(3)
(3, 4)
(3, 4-5)
(3, 4-5, 6)
(3, 4-7)
(3, 4-7, 8)
(3, 4-7, 8-9)
(3, 4-7, 8-9, 10)

We could end up with a situation where we stop because the array is
full, even though if we kept going, it'd shrink back down below the
length of the array (in this example, an array of length 2 would stop
when it saw page 6, even though page 7 shrinks it back down again).

> What is needed is a full scatterlist replacement, including the IOMMU
> part.
> 
> For the IOMMU I would expect the datastructure to be re-used, we start
> with a list of physical pages and then 'dma map' gives us a list of
> IOVA physical pages, in another allocation, but exactly the same
> datastructure.
> 
> This 'dma map' could return a pointer to the first datastructure if
> there is no iommu, allocate a single entry list if the whole thing can
> be linearly mapped with the iommu, and other baroque cases (like pci
> offset/etc) will need to allocate full array. ie good HW runs fast and
> is memory efficient.
> 
> It would be nice to see a patch sketching showing what this
> datastructure could look like.
> 
> VFIO would like this structure as well as it currently is a very
> inefficient page at a time loop when it iommu maps things.

I agree that you need these things.  I think I'll run into trouble
if I try to do them for you ... so I'm going to stop after doing the
top end (pinning pages and getting them into an sg list) and let
people who know that area better than I do work on that.
