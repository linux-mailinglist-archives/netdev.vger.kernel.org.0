Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7124432D716
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 16:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhCDPtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 10:49:41 -0500
Received: from foss.arm.com ([217.140.110.172]:40288 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235674AbhCDPtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 10:49:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 684D61FB;
        Thu,  4 Mar 2021 07:48:26 -0800 (PST)
Received: from [10.57.48.219] (unknown [10.57.48.219])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AF083F766;
        Thu,  4 Mar 2021 07:48:23 -0800 (PST)
Subject: Re: [PATCH 16/17] iommu: remove DOMAIN_ATTR_IO_PGTABLE_CFG
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
 <20210301084257.945454-17-hch@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <d567ad5c-5f89-effa-7260-88c6d86b4695@arm.com>
Date:   Thu, 4 Mar 2021 15:48:23 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301084257.945454-17-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-01 08:42, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Moreso than the previous patch, where the feature is at least relatively 
generic (note that there's a bunch of in-flight development around 
DOMAIN_ATTR_NESTING), I'm really not convinced that it's beneficial to 
bloat the generic iommu_ops structure with private driver-specific 
interfaces. The attribute interface is a great compromise for these 
kinds of things, and you can easily add type-checked wrappers around it 
for external callers (maybe even make the actual attributes internal 
between the IOMMU core and drivers) if that's your concern.

Robin.

> ---
>   drivers/gpu/drm/msm/adreno/adreno_gpu.c |  2 +-
>   drivers/iommu/arm/arm-smmu/arm-smmu.c   | 40 +++++++------------------
>   drivers/iommu/iommu.c                   |  9 ++++++
>   include/linux/iommu.h                   |  9 +++++-
>   4 files changed, 29 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
> index 0f184c3dd9d9ec..78d98ab2ee3a68 100644
> --- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
> +++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
> @@ -191,7 +191,7 @@ void adreno_set_llc_attributes(struct iommu_domain *iommu)
>   	struct io_pgtable_domain_attr pgtbl_cfg;
>   
>   	pgtbl_cfg.quirks = IO_PGTABLE_QUIRK_ARM_OUTER_WBWA;
> -	iommu_domain_set_attr(iommu, DOMAIN_ATTR_IO_PGTABLE_CFG, &pgtbl_cfg);
> +	iommu_domain_set_pgtable_attr(iommu, &pgtbl_cfg);
>   }
>   
>   struct msm_gem_address_space *
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> index 2e17d990d04481..2858999c86dfd1 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> @@ -1515,40 +1515,22 @@ static int arm_smmu_domain_enable_nesting(struct iommu_domain *domain)
>   	return ret;
>   }
>   
> -static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
> -				    enum iommu_attr attr, void *data)
> +static int arm_smmu_domain_set_pgtable_attr(struct iommu_domain *domain,
> +		struct io_pgtable_domain_attr *pgtbl_cfg)
>   {
> -	int ret = 0;
>   	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	int ret = -EPERM;
>   
> -	mutex_lock(&smmu_domain->init_mutex);
> -
> -	switch(domain->type) {
> -	case IOMMU_DOMAIN_UNMANAGED:
> -		switch (attr) {
> -		case DOMAIN_ATTR_IO_PGTABLE_CFG: {
> -			struct io_pgtable_domain_attr *pgtbl_cfg = data;
> -
> -			if (smmu_domain->smmu) {
> -				ret = -EPERM;
> -				goto out_unlock;
> -			}
> +	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
> +		return -EINVAL;
>   
> -			smmu_domain->pgtbl_cfg = *pgtbl_cfg;
> -			break;
> -		}
> -		default:
> -			ret = -ENODEV;
> -		}
> -		break;
> -	case IOMMU_DOMAIN_DMA:
> -		ret = -ENODEV;
> -		break;
> -	default:
> -		ret = -EINVAL;
> +	mutex_lock(&smmu_domain->init_mutex);
> +	if (!smmu_domain->smmu) {
> +		smmu_domain->pgtbl_cfg = *pgtbl_cfg;
> +		ret = 0;
>   	}
> -out_unlock:
>   	mutex_unlock(&smmu_domain->init_mutex);
> +
>   	return ret;
>   }
>   
> @@ -1609,7 +1591,7 @@ static struct iommu_ops arm_smmu_ops = {
>   	.device_group		= arm_smmu_device_group,
>   	.dma_use_flush_queue	= arm_smmu_dma_use_flush_queue,
>   	.dma_enable_flush_queue	= arm_smmu_dma_enable_flush_queue,
> -	.domain_set_attr	= arm_smmu_domain_set_attr,
> +	.domain_set_pgtable_attr = arm_smmu_domain_set_pgtable_attr,
>   	.domain_enable_nesting	= arm_smmu_domain_enable_nesting,
>   	.of_xlate		= arm_smmu_of_xlate,
>   	.get_resv_regions	= arm_smmu_get_resv_regions,
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2e9e058501a953..8490aefd4b41f8 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2693,6 +2693,15 @@ int iommu_domain_enable_nesting(struct iommu_domain *domain)
>   }
>   EXPORT_SYMBOL_GPL(iommu_domain_enable_nesting);
>   
> +int iommu_domain_set_pgtable_attr(struct iommu_domain *domain,
> +		struct io_pgtable_domain_attr *pgtbl_cfg)
> +{
> +	if (!domain->ops->domain_set_pgtable_attr)
> +		return -EINVAL;
> +	return domain->ops->domain_set_pgtable_attr(domain, pgtbl_cfg);
> +}
> +EXPORT_SYMBOL_GPL(iommu_domain_set_pgtable_attr);
> +
>   void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>   {
>   	const struct iommu_ops *ops = dev->bus->iommu_ops;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index aed88aa3bd3edf..39d3ed4d2700ac 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -40,6 +40,7 @@ struct iommu_domain;
>   struct notifier_block;
>   struct iommu_sva;
>   struct iommu_fault_event;
> +struct io_pgtable_domain_attr;
>   
>   /* iommu fault flags */
>   #define IOMMU_FAULT_READ	0x0
> @@ -107,7 +108,6 @@ enum iommu_cap {
>    */
>   
>   enum iommu_attr {
> -	DOMAIN_ATTR_IO_PGTABLE_CFG,
>   	DOMAIN_ATTR_MAX,
>   };
>   
> @@ -196,6 +196,7 @@ struct iommu_iotlb_gather {
>    * @dma_enable_flush_queue: Try to enable the DMA flush queue
>    * @domain_set_attr: Change domain attributes
>    * @domain_enable_nesting: Enable nesting
> + * @domain_set_pgtable_attr: Set io page table attributes
>    * @get_resv_regions: Request list of reserved regions for a device
>    * @put_resv_regions: Free list of reserved regions for a device
>    * @apply_resv_region: Temporary helper call-back for iova reserved ranges
> @@ -249,6 +250,8 @@ struct iommu_ops {
>   	int (*domain_set_attr)(struct iommu_domain *domain,
>   			       enum iommu_attr attr, void *data);
>   	int (*domain_enable_nesting)(struct iommu_domain *domain);
> +	int (*domain_set_pgtable_attr)(struct iommu_domain *domain,
> +			struct io_pgtable_domain_attr *pgtbl_cfg);
>   
>   	/* Request/Free a list of reserved regions for a device */
>   	void (*get_resv_regions)(struct device *dev, struct list_head *list);
> @@ -493,9 +496,13 @@ extern int iommu_group_id(struct iommu_group *group);
>   extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
>   
>   bool iommu_dma_use_flush_queue(struct iommu_domain *domain);
> +int iommu_domain_set_pgtable_attr(struct iommu_domain *domain,
> +		struct io_pgtable_domain_attr *pgtbl_cfg);
>   extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
>   				 void *data);
>   int iommu_domain_enable_nesting(struct iommu_domain *domain);
> +int iommu_domain_set_pgtable_attr(struct iommu_domain *domain,
> +		struct io_pgtable_domain_attr *pgtbl_cfg);
>   
>   extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
>   			      unsigned long iova, int flags);
> 
