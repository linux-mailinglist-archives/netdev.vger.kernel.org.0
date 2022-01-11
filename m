Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8E48B963
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiAKVZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiAKVZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:25:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB6BC06173F;
        Tue, 11 Jan 2022 13:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7YIdvCOYX163JNG4239+4esl2HeeXcNsGWrdL0xg2YA=; b=u1Qxt2awbRu7BIYKpqKoP6QqrJ
        PAoK0pYJO0npqFgnmoat3cPH4r/kKiEj/005I94Nhesk0TWmuGwwtHKDdKblHmH52LCLZQdaxUMhg
        nxbzZtO9+DkzQ4KBBEJzHDNDG5VicIQZquwaVeHSY7GnkkTF16Iv6JgNgwf+gtzXgjJy8iZUNQYhx
        se88avHiAVIvEv/82vRLQKEVEVe3QWXF7+mt20TqrOdWZFxxKXzvTsG72adiSJpSTcNxEh/Ua3kJI
        CqVLwQ2k7pZRiVBWybULM4rcp8s5j2cHarbzzPROawS1/fyPQSFQObt7qXiJFeyLBMlol8Gm/WwOs
        kk7cp+ZA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7OeC-003ab4-K5; Tue, 11 Jan 2022 21:25:40 +0000
Date:   Tue, 11 Jan 2022 21:25:40 +0000
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
Message-ID: <Yd311C45gpQ3LqaW@casper.infradead.org>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com>
 <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111202159.GO2328285@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 04:21:59PM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 11, 2022 at 06:33:57PM +0000, Matthew Wilcox wrote:
> 
> > > Then we are we using get_user_phyr() at all if we are just storing it
> > > in a sg?
> > 
> > I did consider just implementing get_user_sg() (actually 4 years ago),
> > but that cements the use of sg as both an input and output data structure
> > for DMA mapping, which I am under the impression we're trying to get
> > away from.
> 
> I know every time I talked about a get_user_sg() Christoph is against
> it and we need to stop using scatter list...
> 
> > > Also 16 entries is way to small, it should be at least a whole PMD
> > > worth so we don't have to relock the PMD level each iteration.
> > > 
> > > I would like to see a flow more like:
> > > 
> > >   cpu_phyr_list = get_user_phyr(uptr, 1G);
> > >   dma_phyr_list = dma_map_phyr(device, cpu_phyr_list);
> > >   [..]
> > >   dma_unmap_phyr(device, dma_phyr_list);
> > >   unpin_drity_free(cpu_phy_list);
> > > 
> > > Where dma_map_phyr() can build a temporary SGL for old iommu drivers
> > > compatability. iommu drivers would want to implement natively, of
> > > course.
> > > 
> > > ie no loops in drivers.
> > 
> > Let me just rewrite that for you ...
> > 
> > 	umem->phyrs = get_user_phyrs(addr, size, &umem->phyr_len);
> > 	umem->sgt = dma_map_phyrs(device, umem->phyrs, umem->phyr_len,
> > 			DMA_BIDIRECTIONAL, dma_attr);
> > 	...
> > 	dma_unmap_phyr(device, umem->phyrs, umem->phyr_len, umem->sgt->sgl,
> > 			umem->sgt->nents, DMA_BIDIRECTIONAL, dma_attr);
> > 	sg_free_table(umem->sgt);
> > 	free_user_phyrs(umem->phyrs, umem->phyr_len);
> 
> Why? As above we want to get rid of the sgl, so you are telling me to
> adopt phyrs I need to increase the memory consumption by a hefty
> amount to store the phyrs and still keep the sgt now? Why?
> 
> I don't need the sgt at all. I just need another list of physical
> addresses for DMA. I see no issue with a phsr_list storing either CPU
> Physical Address or DMA Physical Addresses, same data structure.

There's a difference between a phys_addr_t and a dma_addr_t.  They
can even be different sizes; some architectures use a 32-bit dma_addr_t
and a 64-bit phys_addr_t or vice-versa.  phyr cannot store DMA addresses.

> In the fairly important passthrough DMA case the CPU list and DMA list
> are identical, so we don't even need to do anything.
> 
> In the typical iommu case my dma map's phyrs is only one entry.

That becomes a very simple sg table then.

> As an example coding - Use the first 8 bytes to encode this:
> 
>  51:0 - Physical address / 4k (ie pfn)
>  56:52 - Order (simple, your order encoding can do better)
>  61:57 - Unused
>  63:62 - Mode, one of:
>          00 = natural order pfn (8 bytes)
>          01 = order aligned with length (12 bytes)
>          10 = arbitary (12 bytes)
> 
> Then the optional 4 bytes are used as:
> 
> Mode 01 (Up to 2^48 bytes of memory on a 4k alignment)
>   31:0 - # of order pages
> 
> Mode 10 (Up to 2^25 bytes of memory on a 1 byte alignment)
>   11:0 - starting byte offset in the 4k
>   31:12 - 20 bits, plus the 5 bit order from the first 8 bytes:
>           length in bytes

Honestly, this looks awful to operate on.  Mandatory 8-bytes per entry
with an optional 4 byte extension?

> > > The last case is, perhaps, a possible route to completely replace
> > > scatterlist. Few places need true byte granularity for interior pages,
> > > so we can invent some coding to say 'this is 8 byte aligned, and n
> > > bytes long' that only fits < 4k or something. Exceptional cases can
> > > then still work. I'm not sure what block needs here - is it just 512?
> > 
> > Replacing scatterlist is not my goal.  That seems like a lot more work
> > for little gain.  
> 
> Well, I'm not comfortable with the idea above where RDMA would have to
> take a memory penalty to use the new interface. To avoid that memory
> penalty we need to get rid of scatterlist entirely.
> 
> If we do the 16 byte struct from the first email then a umem for MRs
> will increase in memory consumption by 160% compared today's 24
> bytes/page. I think the HPC workloads will veto this.

Huh?  We do 16 bytes per physically contiguous range.  Then, if your HPC
workloads use an IOMMU that can map a virtually contiguous range
into a single sg entry, it uses 24 bytes for the entire mapping.
It should shrink.

> > I just want to delete page_link, offset and length from struct
> > scatterlist.  Given the above sequence of calls, we're going to get
> > sg lists that aren't chained.  They may have to be vmalloced, but
> > they should be contiguous.
> 
> I don't understand that? Why would the SGL out of the iommu suddenly
> not be chained?

Because it's being given a single set of ranges to map, instead of
being given 512 pages at a time.

> >From what I've heard I'm also not keen on a physr list using vmalloc
> either, that is said to be quite slow?

It would only be slow for degenerate cases where the pinned memory
is fragmented and not contiguous.

> > > I would imagine a few steps to this process:
> > >  1) 'phyr_list' datastructure, with chaining, pre-allocation, etc
> > >  2) Wrapper around existing gup to get a phyr_list for user VA
> > >  3) Compat 'dma_map_phyr()' that coverts a phyr_list to a sgl and back
> > >     (However, with full performance for iommu passthrough)
> > >  4) Patches changing RDMA/VFIO/DRM to this API
> > >  5) Patches optimizing get_user_phyr()
> > >  6) Patches implementing dma_map_phyr in the AMD or Intel IOMMU driver
> > 
> > I was thinking ...
> > 
> > 1. get_user_phyrs() & free_user_phyrs()
> > 2. dma_map_phyrs() and dma_unmap_phyrs() wrappers that create a
> >    scatterlist from phyrs and call dma_map_sg() / dma_unmap_sg() to work
> >    with current IOMMU drivers
> 
> IMHO, the scatterlist has to go away. The interface should be physr
> list in, physr list out.

That's reproducing the bad decision of the scatterlist, only with
a different encoding.  You end up with something like:

struct neoscat {
	dma_addr_t dma_addr;
	phys_addr_t phys_addr;
	size_t dma_len;
	size_t phys_len;
};

and the dma_addr and dma_len are unused by all-but-the-first entry when
you have a competent IOMMU.  We want a different data structure in and
out, and we may as well keep using the scatterlist for the dma-map-out.

