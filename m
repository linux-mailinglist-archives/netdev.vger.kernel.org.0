Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDA1271AF5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 08:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgIUGgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 02:36:36 -0400
Received: from verein.lst.de ([213.95.11.211]:38634 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgIUGge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 02:36:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B25CE68AFE; Mon, 21 Sep 2020 08:36:28 +0200 (CEST)
Date:   Mon, 21 Sep 2020 08:36:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-doc@vger.kernel.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: a saner API for allocating DMA addressable pages v3
Message-ID: <20200921063628.GB18349@lst.de>
References: <20200915155122.1768241-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915155122.1768241-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any comments?

Thomas: this should be identical to the git tree I gave you for mips
testing, and you add your tested-by (and reviewd-by tags where
applicable)?

Helge: for parisc this should effectively be the same as the first
version, but I've dropped the tested-by tags due to the reshuffle,
and chance you could retest it?

On Tue, Sep 15, 2020 at 05:51:04PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series replaced the DMA_ATTR_NON_CONSISTENT flag to dma_alloc_attrs
> with a separate new dma_alloc_pages API, which is available on all
> platforms.  In addition to cleaning up the convoluted code path, this
> ensures that other drivers that have asked for better support for
> non-coherent DMA to pages with incurring bounce buffering over can finally
> be properly supported.
> 
> As a follow up I plan to move the implementation of the
> DMA_ATTR_NO_KERNEL_MAPPING flag over to this framework as well, given
> that is also is a fundamentally non coherent allocation.  The replacement
> for that flag would then return a struct page, as it is allowed to
> actually return pages without a kernel mapping as the name suggested
> (although most of the time they will actually have a kernel mapping..)
> 
> In addition to the conversions of the existing non-coherent DMA users,
> I've also added a patch to convert the firewire ohci driver to use
> the new dma_alloc_pages API.
> 
> The first patch is queued up for 5.9 in the media tree, but included here
> for completeness.
> 
> 
> A git tree is available here:
> 
>     git://git.infradead.org/users/hch/misc.git dma_alloc_pages
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma_alloc_pages
> 
> 
> Changes since v2:
>  - fix up the patch reshuffle which wasn't quite correct
>  - fix up a few commit messages
> 
> Changes since v1:
>  - rebased on the latests dma-mapping tree, which merged many of the
>    cleanups
>  - fix an argument passing typo in 53c700, caught by sparse
>  - rename a few macro arguments in 53c700
>  - pass the right device to the DMA API in the lib82596 drivers
>  - fix memory ownershiptransfers in sgiseeq
>  - better document what a page in the direct kernel mapping means
>  - split into dma_alloc_pages that returns a struct page and is in the
>    direct mapping vs dma_alloc_noncoherent that can be vmapped
>  - conver the firewire ohci driver to dma_alloc_pages
> 
> Diffstat:
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
---end quoted text---
