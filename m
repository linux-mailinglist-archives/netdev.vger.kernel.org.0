Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D74225980F
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbgIAQWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:22:02 -0400
Received: from elvis.franken.de ([193.175.24.41]:45872 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731021AbgIAPcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 11:32:24 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kD8Gf-0002rq-00; Tue, 01 Sep 2020 17:32:17 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 92E50C0E4C; Tue,  1 Sep 2020 17:22:09 +0200 (CEST)
Date:   Tue, 1 Sep 2020 17:22:09 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 22/28] sgiseeq: convert from dma_cache_sync to
 dma_sync_single_for_device
Message-ID: <20200901152209.GA14288@alpha.franken.de>
References: <20200819065555.1802761-1-hch@lst.de>
 <20200819065555.1802761-23-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819065555.1802761-23-hch@lst.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 08:55:49AM +0200, Christoph Hellwig wrote:
> Use the proper modern API to transfer cache ownership for incoherent DMA.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/net/ethernet/seeq/sgiseeq.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
> index 39599bbb5d45b6..f91dae16d69a19 100644
> --- a/drivers/net/ethernet/seeq/sgiseeq.c
> +++ b/drivers/net/ethernet/seeq/sgiseeq.c
> @@ -112,14 +112,18 @@ struct sgiseeq_private {
>  
>  static inline void dma_sync_desc_cpu(struct net_device *dev, void *addr)
>  {
> -	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
> -		       DMA_FROM_DEVICE);
> +	struct sgiseeq_private *sp = netdev_priv(dev);
> +
> +	dma_sync_single_for_cpu(dev->dev.parent, VIRT_TO_DMA(sp, addr),
> +			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
>  }
>  
>  static inline void dma_sync_desc_dev(struct net_device *dev, void *addr)
>  {
> -	dma_cache_sync(dev->dev.parent, addr, sizeof(struct sgiseeq_rx_desc),
> -		       DMA_TO_DEVICE);
> +	struct sgiseeq_private *sp = netdev_priv(dev);
> +
> +	dma_sync_single_for_device(dev->dev.parent, VIRT_TO_DMA(sp, addr),
> +			sizeof(struct sgiseeq_rx_desc), DMA_BIDIRECTIONAL);
>  }

this breaks ethernet on IP22 completely, but I haven't figured out why, yet.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
