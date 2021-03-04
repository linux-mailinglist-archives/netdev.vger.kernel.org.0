Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2B32D696
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 16:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhCDP0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 10:26:45 -0500
Received: from foss.arm.com ([217.140.110.172]:39962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233783AbhCDP0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 10:26:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D51141FB;
        Thu,  4 Mar 2021 07:25:34 -0800 (PST)
Received: from [10.57.48.219] (unknown [10.57.48.219])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2435D3F766;
        Thu,  4 Mar 2021 07:25:32 -0800 (PST)
Subject: Re: [PATCH 14/17] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
To:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>, Li Yang <leoyang.li@nxp.com>
Cc:     freedreno@lists.freedesktop.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
References: <20210301084257.945454-1-hch@lst.de>
 <20210301084257.945454-15-hch@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <1658805c-ed28-b650-7385-a56fab3383e3@arm.com>
Date:   Thu, 4 Mar 2021 15:25:27 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301084257.945454-15-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-01 08:42, Christoph Hellwig wrote:
> Use explicit methods for setting and querying the information instead.

Now that everyone's using iommu-dma, is there any point in bouncing this 
through the drivers at all? Seems like it would make more sense for the 
x86 drivers to reflect their private options back to iommu_dma_strict 
(and allow Intel's caching mode to override it as well), then have 
iommu_dma_init_domain just test !iommu_dma_strict && 
domain->ops->flush_iotlb_all.

Robin.

> Also remove the now unused iommu_domain_get_attr functionality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/iommu/amd/iommu.c                   | 23 ++-------
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++-----------
>   drivers/iommu/arm/arm-smmu/arm-smmu.c       | 56 +++++----------------
>   drivers/iommu/dma-iommu.c                   |  8 ++-
>   drivers/iommu/intel/iommu.c                 | 27 ++--------
>   drivers/iommu/iommu.c                       | 19 +++----
>   include/linux/iommu.h                       | 17 ++-----
>   7 files changed, 51 insertions(+), 146 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index a69a8b573e40d0..37a8e51db17656 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1771,24 +1771,11 @@ static struct iommu_group *amd_iommu_device_group(struct device *dev)
>   	return acpihid_device_group(dev);
>   }
>   
> -static int amd_iommu_domain_get_attr(struct iommu_domain *domain,
> -		enum iommu_attr attr, void *data)
> +static bool amd_iommu_dma_use_flush_queue(struct iommu_domain *domain)
>   {
> -	switch (domain->type) {
> -	case IOMMU_DOMAIN_UNMANAGED:
> -		return -ENODEV;
> -	case IOMMU_DOMAIN_DMA:
> -		switch (attr) {
> -		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
> -			*(int *)data = !amd_iommu_unmap_flush;
> -			return 0;
> -		default:
> -			return -ENODEV;
> -		}
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> +	if (domain->type != IOMMU_DOMAIN_DMA)
> +		return false;
> +	return !amd_iommu_unmap_flush;
>   }
>   
>   /*****************************************************************************
> @@ -2257,7 +2244,7 @@ const struct iommu_ops amd_iommu_ops = {
>   	.release_device = amd_iommu_release_device,
>   	.probe_finalize = amd_iommu_probe_finalize,
>   	.device_group = amd_iommu_device_group,
> -	.domain_get_attr = amd_iommu_domain_get_attr,
> +	.dma_use_flush_queue = amd_iommu_dma_use_flush_queue,
>   	.get_resv_regions = amd_iommu_get_resv_regions,
>   	.put_resv_regions = generic_iommu_put_resv_regions,
>   	.is_attach_deferred = amd_iommu_is_attach_deferred,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 8594b4a8304375..bf96172e8c1f71 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2449,33 +2449,21 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>   	return group;
>   }
>   
> -static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
> -				    enum iommu_attr attr, void *data)
> +static bool arm_smmu_dma_use_flush_queue(struct iommu_domain *domain)
>   {
>   	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>   
> -	switch (domain->type) {
> -	case IOMMU_DOMAIN_UNMANAGED:
> -		switch (attr) {
> -		case DOMAIN_ATTR_NESTING:
> -			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
> -			return 0;
> -		default:
> -			return -ENODEV;
> -		}
> -		break;
> -	case IOMMU_DOMAIN_DMA:
> -		switch (attr) {
> -		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
> -			*(int *)data = smmu_domain->non_strict;
> -			return 0;
> -		default:
> -			return -ENODEV;
> -		}
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> +	if (domain->type != IOMMU_DOMAIN_DMA)
> +		return false;
> +	return smmu_domain->non_strict;
> +}
> +
> +
> +static void arm_smmu_dma_enable_flush_queue(struct iommu_domain *domain)
> +{
> +	if (domain->type != IOMMU_DOMAIN_DMA)
> +		return;
> +	to_smmu_domain(domain)->non_strict = true;
>   }
>   
>   static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
> @@ -2505,13 +2493,7 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
>   		}
>   		break;
>   	case IOMMU_DOMAIN_DMA:
> -		switch(attr) {
> -		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
> -			smmu_domain->non_strict = *(int *)data;
> -			break;
> -		default:
> -			ret = -ENODEV;
> -		}
> +		ret = -ENODEV;
>   		break;
>   	default:
>   		ret = -EINVAL;
> @@ -2619,7 +2601,8 @@ static struct iommu_ops arm_smmu_ops = {
>   	.probe_device		= arm_smmu_probe_device,
>   	.release_device		= arm_smmu_release_device,
>   	.device_group		= arm_smmu_device_group,
> -	.domain_get_attr	= arm_smmu_domain_get_attr,
> +	.dma_use_flush_queue	= arm_smmu_dma_use_flush_queue,
> +	.dma_enable_flush_queue	= arm_smmu_dma_enable_flush_queue,
>   	.domain_set_attr	= arm_smmu_domain_set_attr,
>   	.of_xlate		= arm_smmu_of_xlate,
>   	.get_resv_regions	= arm_smmu_get_resv_regions,
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> index d8c6bfde6a6158..e7893e96f5177a 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> @@ -1481,42 +1481,20 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>   	return group;
>   }
>   
> -static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
> -				    enum iommu_attr attr, void *data)
> +static bool arm_smmu_dma_use_flush_queue(struct iommu_domain *domain)
>   {
>   	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>   
> -	switch(domain->type) {
> -	case IOMMU_DOMAIN_UNMANAGED:
> -		switch (attr) {
> -		case DOMAIN_ATTR_NESTING:
> -			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
> -			return 0;
> -		case DOMAIN_ATTR_IO_PGTABLE_CFG: {
> -			struct io_pgtable_domain_attr *pgtbl_cfg = data;
> -			*pgtbl_cfg = smmu_domain->pgtbl_cfg;
> +	if (domain->type != IOMMU_DOMAIN_DMA)
> +		return false;
> +	return smmu_domain->pgtbl_cfg.quirks & IO_PGTABLE_QUIRK_NON_STRICT;
> +}
>   
> -			return 0;
> -		}
> -		default:
> -			return -ENODEV;
> -		}
> -		break;
> -	case IOMMU_DOMAIN_DMA:
> -		switch (attr) {
> -		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE: {
> -			bool non_strict = smmu_domain->pgtbl_cfg.quirks &
> -					  IO_PGTABLE_QUIRK_NON_STRICT;
> -			*(int *)data = non_strict;
> -			return 0;
> -		}
> -		default:
> -			return -ENODEV;
> -		}
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> +static void arm_smmu_dma_enable_flush_queue(struct iommu_domain *domain)
> +{
> +	if (domain->type != IOMMU_DOMAIN_DMA)
> +		return;
> +	to_smmu_domain(domain)->pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_NON_STRICT;
>   }
>   
>   static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
> @@ -1557,16 +1535,7 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
>   		}
>   		break;
>   	case IOMMU_DOMAIN_DMA:
> -		switch (attr) {
> -		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
> -			if (*(int *)data)
> -				smmu_domain->pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_NON_STRICT;
> -			else
> -				smmu_domain->pgtbl_cfg.quirks &= ~IO_PGTABLE_QUIRK_NON_STRICT;
> -			break;
> -		default:
> -			ret = -ENODEV;
> -		}
> +		ret = -ENODEV;
>   		break;
>   	default:
>   		ret = -EINVAL;
> @@ -1631,7 +1600,8 @@ static struct iommu_ops arm_smmu_ops = {
>   	.probe_device		= arm_smmu_probe_device,
>   	.release_device		= arm_smmu_release_device,
>   	.device_group		= arm_smmu_device_group,
> -	.domain_get_attr	= arm_smmu_domain_get_attr,
> +	.dma_use_flush_queue	= arm_smmu_dma_use_flush_queue,
> +	.dma_enable_flush_queue	= arm_smmu_dma_enable_flush_queue,
>   	.domain_set_attr	= arm_smmu_domain_set_attr,
>   	.of_xlate		= arm_smmu_of_xlate,
>   	.get_resv_regions	= arm_smmu_get_resv_regions,
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 9ab6ee22c11088..d3fe5aad9d6ecf 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -305,8 +305,8 @@ static void iommu_dma_flush_iotlb_all(struct iova_domain *iovad)
>   	cookie = container_of(iovad, struct iommu_dma_cookie, iovad);
>   	domain = cookie->fq_domain;
>   	/*
> -	 * The IOMMU driver supporting DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
> -	 * implies that ops->flush_iotlb_all must be non-NULL.
> +	 * The IOMMU driver supporting a DMA flush queue implies that
> +	 * ops->flush_iotlb_all must be non-NULL.
>   	 */
>   	domain->ops->flush_iotlb_all(domain);
>   }
> @@ -329,7 +329,6 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
>   	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>   	unsigned long order, base_pfn;
>   	struct iova_domain *iovad;
> -	int attr;
>   
>   	if (!cookie || cookie->type != IOMMU_DMA_IOVA_COOKIE)
>   		return -EINVAL;
> @@ -365,8 +364,7 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
>   
>   	init_iova_domain(iovad, 1UL << order, base_pfn);
>   
> -	if (!cookie->fq_domain && !iommu_domain_get_attr(domain,
> -			DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE, &attr) && attr) {
> +	if (!cookie->fq_domain && iommu_dma_use_flush_queue(domain)) {
>   		if (init_iova_flush_queue(iovad, iommu_dma_flush_iotlb_all,
>   					  iommu_dma_entry_dtor))
>   			pr_warn("iova flush queue initialization failed\n");
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ee0932307d646b..eaa80c33f4bc91 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5453,13 +5453,13 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
>   	return ret;
>   }
>   
> -static bool domain_use_flush_queue(void)
> +static bool intel_iommu_dma_use_flush_queue(struct iommu_domain *domain)
>   {
>   	struct dmar_drhd_unit *drhd;
>   	struct intel_iommu *iommu;
>   	bool r = true;
>   
> -	if (intel_iommu_strict)
> +	if (domain->type != IOMMU_DOMAIN_DMA || intel_iommu_strict)
>   		return false;
>   
>   	/*
> @@ -5483,27 +5483,6 @@ static bool domain_use_flush_queue(void)
>   	return r;
>   }
>   
> -static int
> -intel_iommu_domain_get_attr(struct iommu_domain *domain,
> -			    enum iommu_attr attr, void *data)
> -{
> -	switch (domain->type) {
> -	case IOMMU_DOMAIN_UNMANAGED:
> -		return -ENODEV;
> -	case IOMMU_DOMAIN_DMA:
> -		switch (attr) {
> -		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
> -			*(int *)data = domain_use_flush_queue();
> -			return 0;
> -		default:
> -			return -ENODEV;
> -		}
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
>   /*
>    * Check that the device does not live on an external facing PCI port that is
>    * marked as untrusted. Such devices should not be able to apply quirks and
> @@ -5576,7 +5555,7 @@ const struct iommu_ops intel_iommu_ops = {
>   	.capable		= intel_iommu_capable,
>   	.domain_alloc		= intel_iommu_domain_alloc,
>   	.domain_free		= intel_iommu_domain_free,
> -	.domain_get_attr        = intel_iommu_domain_get_attr,
> +	.dma_use_flush_queue	= intel_iommu_dma_use_flush_queue,
>   	.domain_set_attr	= intel_iommu_domain_set_attr,
>   	.attach_dev		= intel_iommu_attach_device,
>   	.detach_dev		= intel_iommu_detach_device,
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 23daaea7883b75..0f12c4d58cdc42 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1512,12 +1512,8 @@ static int iommu_group_alloc_default_domain(struct bus_type *bus,
>   	if (!group->domain)
>   		group->domain = dom;
>   
> -	if (!iommu_dma_strict) {
> -		int attr = 1;
> -		iommu_domain_set_attr(dom,
> -				      DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
> -				      &attr);
> -	}
> +	if (!iommu_dma_strict && dom->ops->dma_enable_flush_queue)
> +		dom->ops->dma_enable_flush_queue(dom);
>   
>   	return 0;
>   }
> @@ -2664,14 +2660,13 @@ static int __init iommu_init(void)
>   }
>   core_initcall(iommu_init);
>   
> -int iommu_domain_get_attr(struct iommu_domain *domain,
> -			  enum iommu_attr attr, void *data)
> +bool iommu_dma_use_flush_queue(struct iommu_domain *domain)
>   {
> -	if (!domain->ops->domain_get_attr)
> -		return -EINVAL;
> -	return domain->ops->domain_get_attr(domain, attr, data);
> +	if (!domain->ops->dma_use_flush_queue)
> +		return false;
> +	return domain->ops->dma_use_flush_queue(domain);
>   }
> -EXPORT_SYMBOL_GPL(iommu_domain_get_attr);
> +EXPORT_SYMBOL_GPL(iommu_dma_use_flush_queue);
>   
>   int iommu_domain_set_attr(struct iommu_domain *domain,
>   			  enum iommu_attr attr, void *data)
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index c15a8658daad64..f30de33c6ff56e 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -108,7 +108,6 @@ enum iommu_cap {
>   
>   enum iommu_attr {
>   	DOMAIN_ATTR_NESTING,	/* two stages of translation */
> -	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
>   	DOMAIN_ATTR_IO_PGTABLE_CFG,
>   	DOMAIN_ATTR_MAX,
>   };
> @@ -194,7 +193,8 @@ struct iommu_iotlb_gather {
>    * @probe_finalize: Do final setup work after the device is added to an IOMMU
>    *                  group and attached to the groups domain
>    * @device_group: find iommu group for a particular device
> - * @domain_get_attr: Query domain attributes
> + * @dma_use_flush_queue: Returns %true if a DMA flush queue is used
> + * @dma_enable_flush_queue: Try to enable the DMA flush queue
>    * @domain_set_attr: Change domain attributes
>    * @get_resv_regions: Request list of reserved regions for a device
>    * @put_resv_regions: Free list of reserved regions for a device
> @@ -244,8 +244,8 @@ struct iommu_ops {
>   	void (*release_device)(struct device *dev);
>   	void (*probe_finalize)(struct device *dev);
>   	struct iommu_group *(*device_group)(struct device *dev);
> -	int (*domain_get_attr)(struct iommu_domain *domain,
> -			       enum iommu_attr attr, void *data);
> +	bool (*dma_use_flush_queue)(struct iommu_domain *domain);
> +	void (*dma_enable_flush_queue)(struct iommu_domain *domain);
>   	int (*domain_set_attr)(struct iommu_domain *domain,
>   			       enum iommu_attr attr, void *data);
>   
> @@ -491,8 +491,7 @@ extern int iommu_page_response(struct device *dev,
>   extern int iommu_group_id(struct iommu_group *group);
>   extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
>   
> -extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
> -				 void *data);
> +bool iommu_dma_use_flush_queue(struct iommu_domain *domain);
>   extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
>   				 void *data);
>   
> @@ -861,12 +860,6 @@ static inline int iommu_group_id(struct iommu_group *group)
>   	return -ENODEV;
>   }
>   
> -static inline int iommu_domain_get_attr(struct iommu_domain *domain,
> -					enum iommu_attr attr, void *data)
> -{
> -	return -EINVAL;
> -}
> -
>   static inline int iommu_domain_set_attr(struct iommu_domain *domain,
>   					enum iommu_attr attr, void *data)
>   {
> 
