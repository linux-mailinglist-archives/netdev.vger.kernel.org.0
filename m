Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F358725B5FD
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgIBVid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:38:33 -0400
Received: from elvis.franken.de ([193.175.24.41]:49452 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgIBVic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 17:38:32 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kDaSO-0001KH-00; Wed, 02 Sep 2020 23:38:16 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 29A9AC0E7B; Wed,  2 Sep 2020 23:38:09 +0200 (CEST)
Date:   Wed, 2 Sep 2020 23:38:09 +0200
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
Message-ID: <20200902213809.GA7998@alpha.franken.de>
References: <20200819065555.1802761-1-hch@lst.de>
 <20200819065555.1802761-23-hch@lst.de>
 <20200901152209.GA14288@alpha.franken.de>
 <20200901171241.GA20685@alpha.franken.de>
 <20200901171627.GA8255@lst.de>
 <20200901173810.GA25282@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901173810.GA25282@alpha.franken.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 07:38:10PM +0200, Thomas Bogendoerfer wrote:
> On Tue, Sep 01, 2020 at 07:16:27PM +0200, Christoph Hellwig wrote:
> > Well, if IP22 doesn't speculate (which I'm pretty sure is the case),
> > dma_sync_single_for_cpu should indeeed be a no-op.  But then there
> > also shouldn't be anything in the cache, as the previous
> > dma_sync_single_for_device should have invalidated it.  So it seems like
> > we are missing one (or more) ownership transfers to the device.  I'll
> > try to look at the the ownership management in a little more detail
> > tomorrow.
> 
> this is the problem:
> 
>        /* Always check for received packets. */
>         sgiseeq_rx(dev, sp, hregs, sregs);
> 
> so the driver will look at the rx descriptor on every interrupt, so
> we cache the rx descriptor on the first interrupt and if there was
> $no rx packet, we will only see it, if cache line gets flushed for
> some other reason. kick_tx() does a busy loop checking tx descriptors,
> with just sync_desc_cpu...

the patch below fixes the problem.

Thomas.


diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 8507ff242014..876e3700a0e4 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -112,14 +112,18 @@ struct sgiseeq_private {
 
 static inline void dma_sync_desc_cpu(struct net_device *dev, void *addr)
 {
-       dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
-                      DMA_FROM_DEVICE);
+       struct sgiseeq_private *sp = netdev_priv(dev);
+
+       dma_sync_single_for_device(dev->dev.parent, VIRT_TO_DMA(sp, addr),
+                       sizeof(struct sgiseeq_rx_desc), DMA_FROM_DEVICE);
 }
 
 static inline void dma_sync_desc_dev(struct net_device *dev, void *addr)
 {
-       dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
-                      DMA_TO_DEVICE);
+       struct sgiseeq_private *sp = netdev_priv(dev);
+
+       dma_sync_single_for_device(dev->dev.parent, VIRT_TO_DMA(sp, addr),
+                       sizeof(struct sgiseeq_rx_desc), DMA_TO_DEVICE);
 }
 
-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
