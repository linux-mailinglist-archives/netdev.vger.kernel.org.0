Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1372E04EF
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388707AbfJVN0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 09:26:12 -0400
Received: from [217.140.110.172] ([217.140.110.172]:52688 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2387941AbfJVN0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 09:26:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E4932B;
        Tue, 22 Oct 2019 06:25:48 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE9C23F71F;
        Tue, 22 Oct 2019 06:25:46 -0700 (PDT)
Subject: Re: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
References: <20191022125502.12495-1-laurentiu.tudor@nxp.com>
 <20191022125502.12495-2-laurentiu.tudor@nxp.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <62561dca-cdd7-fe01-a0c3-7b5971c96e7e@arm.com>
Date:   Tue, 22 Oct 2019 14:25:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20191022125502.12495-2-laurentiu.tudor@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/10/2019 13:55, Laurentiu Tudor wrote:
> From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> 
> Introduce a new dma map op called dma_addr_to_phys_addr() that converts
> a dma address to the physical address backing it up and add wrapper for
> it.

I'd really love it if there was a name which could encapsulate that this 
is *only* for extreme special cases of constrained descriptors/pagetable 
entries/etc. where there's simply no practical way to keep track of a 
CPU address alongside the DMA address, and the only option is this 
potentially-arbitrarily-complex operation (I mean, on some systems it 
may end up taking locks and poking hardware).

Either way it's tricky - much as I don't like adding an interface which 
is ripe for drivers to misuse, I also really don't want hacks like 
bdf95923086f shoved into other APIs to compensate, so on balance I'd 
probably consider this proposal ever so slightly the lesser evil.

> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> ---
>   include/linux/dma-mapping.h | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 4a1c4fca475a..5965d159c9a9 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -132,6 +132,8 @@ struct dma_map_ops {
>   	u64 (*get_required_mask)(struct device *dev);
>   	size_t (*max_mapping_size)(struct device *dev);
>   	unsigned long (*get_merge_boundary)(struct device *dev);
> +	phys_addr_t (*dma_addr_to_phys_addr)(struct device *dev,
> +					     dma_addr_t dma_handle);

I'd be inclined to name the internal callback something a bit snappier 
like .get_phys_addr.

>   };
>   
>   #define DMA_MAPPING_ERROR		(~(dma_addr_t)0)
> @@ -442,6 +444,19 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>   	return 0;
>   }
>   
> +static inline phys_addr_t dma_addr_to_phys_addr(struct device *dev,
> +						dma_addr_t dma_handle)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +
> +	if (dma_is_direct(ops))
> +		return (phys_addr_t)dma_handle;

Well that's not right, is it - remember why you had that namespace 
collision? ;)

Robin.

> +	else if (ops->dma_addr_to_phys_addr)
> +		return ops->dma_addr_to_phys_addr(dev, dma_handle);
> +
> +	return 0;
> +}
> +
>   void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
>   		gfp_t flag, unsigned long attrs);
>   void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
> @@ -578,6 +593,12 @@ static inline unsigned long dma_get_merge_boundary(struct device *dev)
>   {
>   	return 0;
>   }
> +
> +static inline phys_addr_t dma_addr_to_phys_addr(struct device *dev,
> +						dma_addr_t dma_handle)
> +{
> +	return 0;
> +}
>   #endif /* CONFIG_HAS_DMA */
>   
>   static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
> 
