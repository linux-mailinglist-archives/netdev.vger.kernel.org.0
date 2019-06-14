Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F26B4592B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfFNJsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:48:05 -0400
Received: from verein.lst.de ([213.95.11.211]:45593 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfFNJsE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 05:48:04 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 1E342227A82; Fri, 14 Jun 2019 11:47:34 +0200 (CEST)
Date:   Fri, 14 Jun 2019 11:47:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:DMA MAPPING HELPERS" <iommu@lists.linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] swiotlb: Return consistent SWIOTLB segments/nr_tbl
Message-ID: <20190614094734.GH17292@lst.de>
References: <20190611175825.572-1-f.fainelli@gmail.com> <20190611175825.572-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611175825.572-3-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 10:58:25AM -0700, Florian Fainelli wrote:
> With a specifically contrived memory layout where there is no physical
> memory available to the kernel below the 4GB boundary, we will fail to
> perform the initial swiotlb_init() call and set no_iotlb_memory to true.
> 
> There are drivers out there that call into swiotlb_nr_tbl() to determine
> whether they can use the SWIOTLB. With the right DMA_BIT_MASK() value
> for these drivers (say 64-bit), they won't ever need to hit
> swiotlb_tbl_map_single() so this can go unoticed and we would be
> possibly lying about those drivers.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  kernel/dma/swiotlb.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index b2b5c5df273c..e906ef2e6315 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -129,15 +129,17 @@ setup_io_tlb_npages(char *str)
>  }
>  early_param("swiotlb", setup_io_tlb_npages);
>  
> +static bool no_iotlb_memory;
> +
>  unsigned long swiotlb_nr_tbl(void)
>  {
> -	return io_tlb_nslabs;
> +	return unlikely(no_iotlb_memory) ? 0 : io_tlb_nslabs;
>  }
>  EXPORT_SYMBOL_GPL(swiotlb_nr_tbl);
>  
>  unsigned int swiotlb_max_segment(void)
>  {
> -	return max_segment;
> +	return unlikely(no_iotlb_memory) ? 0 : max_segment;

I wouldn't bother with the unlikely here as anythign querying
swiotlb details should pretty much be a slow path already.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
