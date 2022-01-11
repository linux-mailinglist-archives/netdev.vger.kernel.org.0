Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D3A48B5B5
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345015AbiAKSeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242661AbiAKSeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:34:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB837C06173F;
        Tue, 11 Jan 2022 10:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eAKZlQsmjfI+koCxrlOr8+ragZ61WF+HNKacitVGsa4=; b=uwPUp9egKUiNPj/3oywvH0xvRN
        4PPC5HjY8DzksQkP3NNIVA3wuap90vioZPUxvKU+U8l8TJ6L6kuRzplWIg5V6euZGII00kt6f/UEL
        X2q3LxlpAQWQll8GNYuMSf8LfYeJ2Fpw45EvAB43k1sIrVDdYadiCu4uwSX0JrzmofoNvYfXV5VWv
        YTPBq1Rdg1bV72nGunzOJ87kOf8gcKJMX8rFX2pF34koHZ0zaH6437jAi7WWFo8kzdDI3+nB0Agmi
        NN4EprO5pS0q4lqzaUN6vTNXlZ3OmwYAD1pwVnFgdM1CwKwHtyY3020wqFB7otx3+ezOehhfR+vcn
        jPz7KxVA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7Ly1-003U8D-O7; Tue, 11 Jan 2022 18:33:57 +0000
Date:   Tue, 11 Jan 2022 18:33:57 +0000
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
Message-ID: <Yd3Nle3YN063ZFVY@casper.infradead.org>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111150142.GL2328285@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 11:01:42AM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 11, 2022 at 04:32:56AM +0000, Matthew Wilcox wrote:
> > On Mon, Jan 10, 2022 at 08:41:26PM -0400, Jason Gunthorpe wrote:
> > > On Mon, Jan 10, 2022 at 07:34:49PM +0000, Matthew Wilcox wrote:
> > > 
> > > > Finally, it may be possible to stop using scatterlist to describe the
> > > > input to the DMA-mapping operation.  We may be able to get struct
> > > > scatterlist down to just dma_address and dma_length, with chaining
> > > > handled through an enclosing struct.
> > > 
> > > Can you talk about this some more? IMHO one of the key properties of
> > > the scatterlist is that it can hold huge amounts of pages without
> > > having to do any kind of special allocation due to the chaining.
> > > 
> > > The same will be true of the phyr idea right?
> > 
> > My thinking is that we'd pass a relatively small array of phyr (maybe 16
> > entries) to get_user_phyr().  If that turned out not to be big enough,
> > then we have two options; one is to map those 16 ranges with sg and use
> > the sg chaining functionality before throwing away the phyr and calling
> > get_user_phyr() again. 
> 
> Then we are we using get_user_phyr() at all if we are just storing it
> in a sg?

I did consider just implementing get_user_sg() (actually 4 years ago),
but that cements the use of sg as both an input and output data structure
for DMA mapping, which I am under the impression we're trying to get
away from.

> Also 16 entries is way to small, it should be at least a whole PMD
> worth so we don't have to relock the PMD level each iteration.
> 
> I would like to see a flow more like:
> 
>   cpu_phyr_list = get_user_phyr(uptr, 1G);
>   dma_phyr_list = dma_map_phyr(device, cpu_phyr_list);
>   [..]
>   dma_unmap_phyr(device, dma_phyr_list);
>   unpin_drity_free(cpu_phy_list);
> 
> Where dma_map_phyr() can build a temporary SGL for old iommu drivers
> compatability. iommu drivers would want to implement natively, of
> course.
> 
> ie no loops in drivers.

Let me just rewrite that for you ...

	umem->phyrs = get_user_phyrs(addr, size, &umem->phyr_len);
	umem->sgt = dma_map_phyrs(device, umem->phyrs, umem->phyr_len,
			DMA_BIDIRECTIONAL, dma_attr);
	...
	dma_unmap_phyr(device, umem->phyrs, umem->phyr_len, umem->sgt->sgl,
			umem->sgt->nents, DMA_BIDIRECTIONAL, dma_attr);
	sg_free_table(umem->sgt);
	free_user_phyrs(umem->phyrs, umem->phyr_len);

> > The question is whether this is the right kind of optimisation to be
> > doing.  I hear you that we want a dense format, but it's questionable
> > whether the kind of thing you're suggesting is actually denser than this
> > scheme.  For example, if we have 1GB pages and userspace happens to have
> > allocated pages (3, 4, 5, 6, 7, 8, 9, 10) then this can be represented
> > as a single phyr.  A power-of-two scheme would have us use four entries
> > (3, 4-7, 8-9, 10).
> 
> That is not quite what I had in mind..
> 
> struct phyr_list {
>    unsigned int first_page_offset_bytes;
>    size_t total_length_bytes;
>    phys_addr_t min_alignment;
>    struct packed_phyr *list_of_pages;
> };
> 
> Where each 'packed_phyr' is an aligned page of some kind. The packing
> has to be able to represent any number of pfns, so we have four major
> cases:
>  - 4k pfns (use 8 bytes)
>  - Natural order pfn (use 8 bytes)
>  - 4k aligned pfns, arbitary number (use 12 bytes)
>  - <4k aligned, arbitary length (use 16 bytes?)
> 
> In all cases the interior pages are fully used, only the first and
> last page is sliced based on the two parameters in the phyr_list.

This kind of representation works for a virtually contiguous range.
Unfortunately, that's not sufficient for some bio users (as I discovered
after getting a representation like this enshrined in the NVMe spec as
the PRP List).

> The last case is, perhaps, a possible route to completely replace
> scatterlist. Few places need true byte granularity for interior pages,
> so we can invent some coding to say 'this is 8 byte aligned, and n
> bytes long' that only fits < 4k or something. Exceptional cases can
> then still work. I'm not sure what block needs here - is it just 512?

Replacing scatterlist is not my goal.  That seems like a lot more work
for little gain.  I just want to delete page_link, offset and length
from struct scatterlist.  Given the above sequence of calls, we're going
to get sg lists that aren't chained.  They may have to be vmalloced,
but they should be contiguous.

> I would imagine a few steps to this process:
>  1) 'phyr_list' datastructure, with chaining, pre-allocation, etc
>  2) Wrapper around existing gup to get a phyr_list for user VA
>  3) Compat 'dma_map_phyr()' that coverts a phyr_list to a sgl and back
>     (However, with full performance for iommu passthrough)
>  4) Patches changing RDMA/VFIO/DRM to this API
>  5) Patches optimizing get_user_phyr()
>  6) Patches implementing dma_map_phyr in the AMD or Intel IOMMU driver

I was thinking ...

1. get_user_phyrs() & free_user_phyrs()
2. dma_map_phyrs() and dma_unmap_phyrs() wrappers that create a
   scatterlist from phyrs and call dma_map_sg() / dma_unmap_sg() to work
   with current IOMMU drivers
3. Convert umem to work with it
4-n. Hand it off to people who can implement dma_map_phyrs() properly
   and do the hard work of converting all the drivers.

