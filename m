Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1DB21702A
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgGGPPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:15:16 -0400
Received: from verein.lst.de ([213.95.11.211]:59269 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgGGPOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E6E5268AFE; Tue,  7 Jul 2020 17:14:41 +0200 (CEST)
Date:   Tue, 7 Jul 2020 17:14:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dma-mapping: add a new dma_need_sync API
Message-ID: <20200707151440.GA23816@lst.de>
References: <20200629130359.2690853-1-hch@lst.de> <20200629130359.2690853-2-hch@lst.de> <20200706194227.vfhv5o4lporxjxmq@bsd-mbp.dhcp.thefacebook.com> <20200707064730.GA23602@lst.de> <20200707151109.qui5uzzzq4dihfie@bsd-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707151109.qui5uzzzq4dihfie@bsd-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 08:11:09AM -0700, Jonathan Lemon wrote:
> > You need to check every mapping.  E.g. this API pairs with a
> > dma_map_single/page call.  For S/G mappings you'd need to call it for
> > each entry, although if you have a use case for that we really should
> > add a dma_sg_need_sync helper instea of open coding the scatterlist walk.
> 
> My use case is setting up a pinned memory area, and caching the dma
> mappings.  I'd like to bypass storing the DMA addresses if they aren't
> needed.  For example:
> 
> setup()
> {
>     if (dma_need_sync(dev, addr, len)) {
>         kvmalloc_array(...)
>         cache_dma_mappings(...)
>     }
> 
> 
> dev_get_dma(page)
> {
>     if (!cache)
>         return page_to_phys(page)
> 
>     return dma_cache_lookup(...)
> 
> 
> 
> The reason for doing it this way is that the page in question may be
> backed by either system memory, or device memory such as a GPU.  For the
> latter, the GPU provides a table of DMA addresses where data may be
> accessed, so I'm unable to use the dma_map_page() API.

dma_need_sync doesn't tell you if the unmap needs the dma_addr_t.
I've been think about replacing CONFIG_NEED_DMA_MAP_STATE with a runtime
for a while, which would give you exattly what you need.  For now it
isn't very useful as there are very few configs left that do not have
CONFIG_NEED_DMA_MAP_STATE set.
