Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04E1259C49
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbgIARN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:13:28 -0400
Received: from elvis.franken.de ([193.175.24.41]:46009 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729705AbgIARNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 13:13:11 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kD9qC-0004aY-00; Tue, 01 Sep 2020 19:13:04 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id A3E0EC0E68; Tue,  1 Sep 2020 19:12:41 +0200 (CEST)
Date:   Tue, 1 Sep 2020 19:12:41 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     alsa-devel@alsa-project.org, linux-ia64@vger.kernel.org,
        linux-doc@vger.kernel.org, nouveau@lists.freedesktop.org,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
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
Message-ID: <20200901171241.GA20685@alpha.franken.de>
References: <20200819065555.1802761-1-hch@lst.de>
 <20200819065555.1802761-23-hch@lst.de>
 <20200901152209.GA14288@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901152209.GA14288@alpha.franken.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 05:22:09PM +0200, Thomas Bogendoerfer wrote:
> On Wed, Aug 19, 2020 at 08:55:49AM +0200, Christoph Hellwig wrote:
> > Use the proper modern API to transfer cache ownership for incoherent DMA.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/net/ethernet/seeq/sgiseeq.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
> > index 39599bbb5d45b6..f91dae16d69a19 100644
> > --- a/drivers/net/ethernet/seeq/sgiseeq.c
> > +++ b/drivers/net/ethernet/seeq/sgiseeq.c
> > @@ -112,14 +112,18 @@ struct sgiseeq_private {
> >  
> >  static inline void dma_sync_desc_cpu(struct net_device *dev, void *addr)
> >  {
> > -	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
> > -		       DMA_FROM_DEVICE);
> > +	struct sgiseeq_private *sp = netdev_priv(dev);
> > +
> > +	dma_sync_single_for_cpu(dev->dev.parent, VIRT_TO_DMA(sp, addr),
> > +			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
> >  }
> >  
> >  static inline void dma_sync_desc_dev(struct net_device *dev, void *addr)
> >  {
> > -	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
> > -		       DMA_TO_DEVICE);
> > +	struct sgiseeq_private *sp = netdev_priv(dev);
> > +
> > +	dma_sync_single_for_device(dev->dev.parent, VIRT_TO_DMA(sp, addr),
> > +			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
> >  }
> 
> this breaks ethernet on IP22 completely, but I haven't figured out why, yet.

the problem is that dma_sync_single_for_cpu() doesn't flush anything
for IP22, because it only flushes for CPUs which do speculation. So
either MIPS arch_sync_dma_for_cpu() should always flush or sgiseeq
needs to use a different sync funktion, when it wants to re-read descriptors
from memory.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
