Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72151E72CA
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 14:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389639AbfJ1Nmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 09:42:46 -0400
Received: from foss.arm.com ([217.140.110.172]:39980 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbfJ1Nmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 09:42:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C01261F1;
        Mon, 28 Oct 2019 06:42:45 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A0AF3F6C4;
        Mon, 28 Oct 2019 06:42:44 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] dma-mapping: introduce new dma unmap and sync api
 variants
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
        Madalin Bucur <madalin.bucur@nxp.com>
References: <20191024124130.16871-1-laurentiu.tudor@nxp.com>
 <20191024124130.16871-2-laurentiu.tudor@nxp.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <ffcdb378-85df-f662-4961-49ff280f39d9@arm.com>
Date:   Mon, 28 Oct 2019 13:42:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20191024124130.16871-2-laurentiu.tudor@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/10/2019 13:41, Laurentiu Tudor wrote:
> From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> 
> Introduce a few new dma unmap and sync variants that, on top of the
> original variants, return the virtual address corresponding to the
> input dma address.
> In order to implement this a new dma map op is added and used:
>      void *get_virt_addr(dev, dma_handle);
> It does the actual conversion of an input dma address to the output
> virtual address.

At this point, I think it might be better to just change the prototype 
of the .unmap_page/.sync_single_for_cpu callbacks themselves. In cases 
where .get_virt_addr would be non-trivial, it's most likely duplicating 
work that the relevant callback has to do anyway (i.e. where the virtual 
and/or physical address is needed internally for a cache maintenance or 
bounce buffer operation). It would also help avoid any possible 
ambiguity about whether .get_virt_addr returns the VA corresponding 
dma_handle (if one exists) rather than the VA of the buffer *mapped to* 
dma_handle, which for a bounce-buffering implementation would be 
different, and the one you actually need - a naive 
phys_to_virt(dma_to_phys(dma_handle)) would lead you to the wrong place 
(in fact it looks like DPAA2 would currently go wrong with 
"swiotlb=force" and the SMMU disabled or in passthrough).

One question there is whether we'd want careful special-casing to avoid 
introducing overhead where unmap/sync are currently complete no-ops, or 
whether an extra phys_to_virt() or so in those paths would be tolerable.

> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> ---
>   include/linux/dma-mapping.h | 55 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 55 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 4a1c4fca475a..ae7bb8a84b9d 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -132,6 +132,7 @@ struct dma_map_ops {
>   	u64 (*get_required_mask)(struct device *dev);
>   	size_t (*max_mapping_size)(struct device *dev);
>   	unsigned long (*get_merge_boundary)(struct device *dev);
> +	void *(*get_virt_addr)(struct device *dev, dma_addr_t dma_handle);
>   };
>   
>   #define DMA_MAPPING_ERROR		(~(dma_addr_t)0)
> @@ -304,6 +305,21 @@ static inline void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr,
>   	debug_dma_unmap_page(dev, addr, size, dir);
>   }
>   
> +static inline struct page *
> +dma_unmap_page_attrs_desc(struct device *dev, dma_addr_t addr, size_t size,
> +			  enum dma_data_direction dir, unsigned long attrs)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	void *ptr = NULL;
> +
> +	if (ops && ops->get_virt_addr)
> +		ptr = ops->get_virt_addr(dev, addr);

Note that this doesn't work for dma-direct, but for the sake of arm64 at 
least it almost certainly wants to.

Robin.

> +	dma_unmap_page_attrs(dev, addr, size, dir, attrs);
> +
> +	return ptr ? virt_to_page(ptr) : NULL;
> +}
> +
>   /*
>    * dma_maps_sg_attrs returns 0 on error and > 0 on success.
>    * It should never return a value < 0.
> @@ -390,6 +406,21 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
>   	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
>   }
>   
> +static inline void *
> +dma_sync_single_for_cpu_desc(struct device *dev, dma_addr_t addr, size_t size,
> +			     enum dma_data_direction dir)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	void *ptr = NULL;
> +
> +	if (ops && ops->get_virt_addr)
> +		ptr = ops->get_virt_addr(dev, addr);
> +
> +	dma_sync_single_for_cpu(dev, addr, size, dir);
> +
> +	return ptr;
> +}
> +
>   static inline void dma_sync_single_for_device(struct device *dev,
>   					      dma_addr_t addr, size_t size,
>   					      enum dma_data_direction dir)
> @@ -500,6 +531,12 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
>   		size_t size, enum dma_data_direction dir)
>   {
>   }
> +
> +static inline void *
> +dma_sync_single_for_cpu_desc(struct device *dev, dma_addr_t addr, size_t size,
> +			     enum dma_data_direction dir)
> +{
> +}
>   static inline void dma_sync_single_for_device(struct device *dev,
>   		dma_addr_t addr, size_t size, enum dma_data_direction dir)
>   {
> @@ -594,6 +631,21 @@ static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
>   	return dma_unmap_page_attrs(dev, addr, size, dir, attrs);
>   }
>   
> +static inline void *
> +dma_unmap_single_attrs_desc(struct device *dev, dma_addr_t addr, size_t size,
> +			    enum dma_data_direction dir, unsigned long attrs)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	void *ptr = NULL;
> +
> +	if (ops && ops->get_virt_addr)
> +		ptr = ops->get_virt_addr(dev, addr);
> +
> +	dma_unmap_single_attrs(dev, addr, size, dir, attrs);
> +
> +	return ptr;
> +}
> +
>   static inline void dma_sync_single_range_for_cpu(struct device *dev,
>   		dma_addr_t addr, unsigned long offset, size_t size,
>   		enum dma_data_direction dir)
> @@ -610,10 +662,13 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
>   
>   #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, 0)
>   #define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, 0)
> +#define dma_unmap_single_desc(d, a, s, r) \
> +		dma_unmap_single_attrs_desc(d, a, s, r, 0)
>   #define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, 0)
>   #define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, 0)
>   #define dma_map_page(d, p, o, s, r) dma_map_page_attrs(d, p, o, s, r, 0)
>   #define dma_unmap_page(d, a, s, r) dma_unmap_page_attrs(d, a, s, r, 0)
> +#define dma_unmap_page_desc(d, a, s, r) dma_unmap_page_attrs_desc(d, a, s, r, 0)
>   #define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, 0)
>   #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, 0)
>   
> 
