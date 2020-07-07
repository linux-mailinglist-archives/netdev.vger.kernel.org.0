Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF45E216FE6
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgGGPLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:11:24 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:34496 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728652AbgGGPLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 11:11:18 -0400
Received: (qmail 99413 invoked by uid 89); 7 Jul 2020 15:11:12 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 7 Jul 2020 15:11:12 -0000
Date:   Tue, 7 Jul 2020 08:11:09 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dma-mapping: add a new dma_need_sync API
Message-ID: <20200707151109.qui5uzzzq4dihfie@bsd-mbp>
References: <20200629130359.2690853-1-hch@lst.de>
 <20200629130359.2690853-2-hch@lst.de>
 <20200706194227.vfhv5o4lporxjxmq@bsd-mbp.dhcp.thefacebook.com>
 <20200707064730.GA23602@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707064730.GA23602@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 08:47:30AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 06, 2020 at 12:42:27PM -0700, Jonathan Lemon wrote:
> > On Mon, Jun 29, 2020 at 03:03:56PM +0200, Christoph Hellwig wrote:
> > > Add a new API to check if calls to dma_sync_single_for_{device,cpu} are
> > > required for a given DMA streaming mapping.
> > > 
> > > +::
> > > +
> > > +	bool
> > > +	dma_need_sync(struct device *dev, dma_addr_t dma_addr);
> > > +
> > > +Returns %true if dma_sync_single_for_{device,cpu} calls are required to
> > > +transfer memory ownership.  Returns %false if those calls can be skipped.
> > 
> > Hi Christoph -
> > 
> > Thie call above is for a specific dma_addr.  For correctness, would I
> > need to check every addr, or can I assume that for a specific memory
> > type (pages returned from malloc), that the answer would be identical?
> 
> You need to check every mapping.  E.g. this API pairs with a
> dma_map_single/page call.  For S/G mappings you'd need to call it for
> each entry, although if you have a use case for that we really should
> add a dma_sg_need_sync helper instea of open coding the scatterlist walk.

My use case is setting up a pinned memory area, and caching the dma
mappings.  I'd like to bypass storing the DMA addresses if they aren't
needed.  For example:

setup()
{
    if (dma_need_sync(dev, addr, len)) {
        kvmalloc_array(...)
        cache_dma_mappings(...)
    }


dev_get_dma(page)
{
    if (!cache)
        return page_to_phys(page)

    return dma_cache_lookup(...)



The reason for doing it this way is that the page in question may be
backed by either system memory, or device memory such as a GPU.  For the
latter, the GPU provides a table of DMA addresses where data may be
accessed, so I'm unable to use the dma_map_page() API.
-- 
Jonathan
