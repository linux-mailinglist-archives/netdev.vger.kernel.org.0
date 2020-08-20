Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EDB24AE34
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 07:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgHTFCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 01:02:24 -0400
Received: from verein.lst.de ([213.95.11.211]:40485 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgHTFCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 01:02:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7DCC068BEB; Thu, 20 Aug 2020 07:02:14 +0200 (CEST)
Date:   Thu, 20 Aug 2020 07:02:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Tomasz Figa <tfiga@chromium.org>, Christoph Hellwig <hch@lst.de>,
        alsa-devel@alsa-project.org, linux-ia64@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        nouveau@lists.freedesktop.org, linux-nvme@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-scsi@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 05/28] media/v4l2: remove
 V4L2-FLAG-MEMORY-NON-CONSISTENT
Message-ID: <20200820050214.GA4815@lst.de>
References: <20200819065555.1802761-1-hch@lst.de> <20200819065555.1802761-6-hch@lst.de> <CAAFQd5COLxjydDYrfx47ht8tj-aNPiaVnC+WyQA7nvpW4gs=ww@mail.gmail.com> <62e4f4fc-c8a5-3ee8-c576-fe7178cb4356@arm.com> <CAAFQd5AcCTDguB2C9KyDiutXWoEvBL8tL7+a==Uo8vj_8CLOJw@mail.gmail.com> <2b32f1d8-16f7-3352-40a5-420993d52fb5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b32f1d8-16f7-3352-40a5-420993d52fb5@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 03:07:04PM +0100, Robin Murphy wrote:
>> FWIW, I asked back in time what the plan is for non-coherent
>> allocations and it seemed like DMA_ATTR_NON_CONSISTENT and
>> dma_sync_*() was supposed to be the right thing to go with. [2] The
>> same thread also explains why dma_alloc_pages() isn't suitable for the
>> users of dma_alloc_attrs() and DMA_ATTR_NON_CONSISTENT.
>
> AFAICS even back then Christoph was implying getting rid of NON_CONSISTENT 
> and *replacing* it with something streaming-API-based - i.e. this series - 
> not encouraging mixing the existing APIs. It doesn't seem impossible to 
> implement a remapping version of this new dma_alloc_pages() for 
> IOMMU-backed ops if it's really warranted (although at that point it seems 
> like "non-coherent" vb2-dc starts to have significant conceptual overlap 
> with vb2-sg).

You can alway vmap the returned pages from dma_alloc_pages, but it will
make cache invalidation hell - you'll need to use
invalidate_kernel_vmap_range and flush_kernel_vmap_range to properly
handle virtually indexed caches.

Or with remapping you mean using the iommu do de-scatter/gather?

You can implement that trivially implement it yourself for the iommu
case:

{
	merge_boundary = dma_get_merge_boundary(dev);
	if (!merge_boundary || merge_boundary > chunk_size - 1) {
		/* can't coalesce */
		return -EINVAL;
	}

	
	nents = DIV_ROUND_UP(total_size, chunk_size);
	sg = sgl_alloc();
	for_each_sgl() {
		sg->page = __alloc_pages(get_order(chunk_size))
		sg->len = chunk_size;
	}
	dma_map_sg(sg, DMA_ATTR_SKIP_CPU_SYNC);
	// you are guaranteed to get a single dma_addr out
}

Of course this still uses the scatterlist structure with its annoying
mix of input and output parametes, so I'd rather not expose it as
an official API at the DMA layer.
