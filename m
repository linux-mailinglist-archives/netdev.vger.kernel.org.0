Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445B4279A0A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 16:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgIZOOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 10:14:37 -0400
Received: from verein.lst.de ([213.95.11.211]:59292 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgIZOOh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 10:14:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6B5EE68B05; Sat, 26 Sep 2020 16:14:29 +0200 (CEST)
Date:   Sat, 26 Sep 2020 16:14:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 17/18] dma-iommu: implement ->alloc_noncoherent
Message-ID: <20200926141428.GB10379@lst.de>
References: <20200915155122.1768241-1-hch@lst.de> <20200915155122.1768241-18-hch@lst.de> <20200925184622.GB3607091@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925184622.GB3607091@chromium.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 06:46:22PM +0000, Tomasz Figa wrote:
> > +static void *iommu_dma_alloc_noncoherent(struct device *dev, size_t size,
> > +		dma_addr_t *handle, enum dma_data_direction dir, gfp_t gfp)
> > +{
> > +	if (!gfpflags_allow_blocking(gfp)) {
> > +		struct page *page;
> > +
> > +		page = dma_common_alloc_pages(dev, size, handle, dir, gfp);
> > +		if (!page)
> > +			return NULL;
> > +		return page_address(page);
> > +	}
> > +
> > +	return iommu_dma_alloc_remap(dev, size, handle, gfp | __GFP_ZERO,
> > +				     PAGE_KERNEL, 0);
> 
> iommu_dma_alloc_remap() makes use of the DMA_ATTR_ALLOC_SINGLE_PAGES attribute
> to optimize the allocations for devices which don't care about how contiguous
> the backing memory is. Do you think we could add an attrs argument to this
> function and pass it there?
> 
> As ARM is being moved to the common iommu-dma layer as well, we'll probably
> make use of the argument to support the DMA_ATTR_NO_KERNEL_MAPPING attribute to
> conserve the vmalloc area.

We could probably at it.  However I wonder why this is something the
drivers should care about.  Isn't this really something that should
be a kernel-wide policy for a given system?
