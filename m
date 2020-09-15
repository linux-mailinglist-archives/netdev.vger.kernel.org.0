Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EAF269EA7
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 08:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgIOGgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 02:36:31 -0400
Received: from verein.lst.de ([213.95.11.211]:46605 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgIOGgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 02:36:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CFEFC6736F; Tue, 15 Sep 2020 08:36:18 +0200 (CEST)
Date:   Tue, 15 Sep 2020 08:36:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
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
Subject: Re: a saner API for allocating DMA addressable pages v2
Message-ID: <20200915063618.GD19113@lst.de>
References: <20200914144433.1622958-1-hch@lst.de> <20200914152617.GR6583@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914152617.GR6583@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 04:26:17PM +0100, Matthew Wilcox wrote:
> On Mon, Sep 14, 2020 at 04:44:16PM +0200, Christoph Hellwig wrote:
> > I'm still a little unsure about the API naming, as alloc_pages sort of
> > implies a struct page return value, but we return a kernel virtual
> > address.
> 
> Erm ... dma_alloc_pages() returns a struct page, so is this sentence
> stale?

Yes.

> You say that like it's a bad thing.  I think the problem is more that
> people don't understand what non-coherent means and think they're
> supporting it when they're not.
> 
> dma_alloc_manual_flushing()?

That sounds pretty awkward..

> 
> > As a follow up I plan to move the implementation of the
> > DMA_ATTR_NO_KERNEL_MAPPING flag over to this framework as well, given
> > that is also is a fundamentally non coherent allocation.  The replacement
> > for that flag would then return a struct page, as it is allowed to
> > actually return pages without a kernel mapping as the name suggested
> > (although most of the time they will actually have a kernel mapping..)
> 
> If the page doesn't have a kernel mapping, shouldn't it return a PFN
> or a phys_addr?

Most APIs we'll feed it into need a struct page.  The difference is just
that it can be a highmem page.  And if we want to get fancy we could
change the kernel mapping to PROT_NONE eventually.
