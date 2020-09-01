Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8214259C87
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732579AbgIARQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:16:40 -0400
Received: from verein.lst.de ([213.95.11.211]:54502 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgIARQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 13:16:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 48CDB68B05; Tue,  1 Sep 2020 19:16:27 +0200 (CEST)
Date:   Tue, 1 Sep 2020 19:16:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Christoph Hellwig <hch@lst.de>, alsa-devel@alsa-project.org,
        linux-ia64@vger.kernel.org, linux-doc@vger.kernel.org,
        nouveau@lists.freedesktop.org, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-scsi@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        linux-media@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-mips@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 22/28] sgiseeq: convert from dma_cache_sync to
 dma_sync_single_for_device
Message-ID: <20200901171627.GA8255@lst.de>
References: <20200819065555.1802761-1-hch@lst.de> <20200819065555.1802761-23-hch@lst.de> <20200901152209.GA14288@alpha.franken.de> <20200901171241.GA20685@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901171241.GA20685@alpha.franken.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 07:12:41PM +0200, Thomas Bogendoerfer wrote:
> On Tue, Sep 01, 2020 at 05:22:09PM +0200, Thomas Bogendoerfer wrote:
> > On Wed, Aug 19, 2020 at 08:55:49AM +0200, Christoph Hellwig wrote:
> > > Use the proper modern API to transfer cache ownership for incoherent DMA.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  drivers/net/ethernet/seeq/sgiseeq.c | 12 ++++++++----
> > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
> > > index 39599bbb5d45b6..f91dae16d69a19 100644
> > > --- a/drivers/net/ethernet/seeq/sgiseeq.c
> > > +++ b/drivers/net/ethernet/seeq/sgiseeq.c
> > > @@ -112,14 +112,18 @@ struct sgiseeq_private {
> > >  
> > >  static inline void dma_sync_desc_cpu(struct net_device *dev, void *addr)
> > >  {
> > > -	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
> > > -		       DMA_FROM_DEVICE);
> > > +	struct sgiseeq_private *sp = netdev_priv(dev);
> > > +
> > > +	dma_sync_single_for_cpu(dev->dev.parent, VIRT_TO_DMA(sp, addr),
> > > +			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
> > >  }
> > >  
> > >  static inline void dma_sync_desc_dev(struct net_device *dev, void *addr)
> > >  {
> > > -	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
> > > -		       DMA_TO_DEVICE);
> > > +	struct sgiseeq_private *sp = netdev_priv(dev);
> > > +
> > > +	dma_sync_single_for_device(dev->dev.parent, VIRT_TO_DMA(sp, addr),
> > > +			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
> > >  }
> > 
> > this breaks ethernet on IP22 completely, but I haven't figured out why, yet.
> 
> the problem is that dma_sync_single_for_cpu() doesn't flush anything
> for IP22, because it only flushes for CPUs which do speculation. So
> either MIPS arch_sync_dma_for_cpu() should always flush or sgiseeq
> needs to use a different sync funktion, when it wants to re-read descriptors
> from memory.

Well, if IP22 doesn't speculate (which I'm pretty sure is the case),
dma_sync_single_for_cpu should indeeed be a no-op.  But then there
also shouldn't be anything in the cache, as the previous
dma_sync_single_for_device should have invalidated it.  So it seems like
we are missing one (or more) ownership transfers to the device.  I'll
try to look at the the ownership management in a little more detail
tomorrow.
