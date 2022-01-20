Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8596494FA3
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242119AbiATN4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:56:08 -0500
Received: from verein.lst.de ([213.95.11.211]:44706 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241390AbiATN4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 08:56:07 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8957B68BEB; Thu, 20 Jan 2022 14:56:02 +0100 (CET)
Date:   Thu, 20 Jan 2022 14:56:02 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120135602.GA11223@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111004126.GJ2328285@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 08:41:26PM -0400, Jason Gunthorpe wrote:
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

No special allocations as in no vmalloc?  The chaining still has to
allocate memory using a mempool.

Anyway, to explain my idea which is very similar but not identical to
the one willy has:

 - on the input side to dma mapping the bio_vecs (or phyrs) are chained
   as bios or whatever the containing structure is.  These already exist
   and have infrastructure at least in the block layer
 - on the output side I plan for two options:

	1) we have a sane IOMMU and everyting will be coalesced into a
	   single dma_range.  This requires setting the block layer
	   merge boundary to match the IOMMU page size, but that is
	   a very good thing to do anyway.
	2) we have no IOMMU (or a weird one) and get one output dma_range
	   per input bio_vec.  We'd eithe have to support chaining or use
	   vmalloc or huge numbers of entries.

> If you limit to that scenario then we can be more optimal because
> things like byte granular offsets and size in the interior pages don't
> need to exist. Every interior chunk is always aligned to its order and
> we only need to record the order.

The block layer does not small offsets.  Direct I/O can often be
512 byte aligned, and some other passthrough commands can have even
smaller alignment, although I don't think we ever go below 4-byte
alignment anywhere in the block layer.

> IMHO storage density here is quite important, we end up having to keep
> this stuff around for a long time.

If we play these tricks it won't be general purpose enough to get rid
of the existing scatterlist usage.
