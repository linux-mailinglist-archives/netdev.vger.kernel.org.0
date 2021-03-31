Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7839C35042B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhCaQI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:08:26 -0400
Received: from foss.arm.com ([217.140.110.172]:45924 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233757AbhCaQIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:08:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D11FD6E;
        Wed, 31 Mar 2021 09:08:04 -0700 (PDT)
Received: from [10.57.24.208] (unknown [10.57.24.208])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FF463F792;
        Wed, 31 Mar 2021 09:08:02 -0700 (PDT)
Subject: Re: [PATCH 16/18] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
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
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-17-hch@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <163376d7-ab23-a470-5bba-7fcd8ae95a4e@arm.com>
Date:   Wed, 31 Mar 2021 17:07:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210316153825.135976-17-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-16 15:38, Christoph Hellwig wrote:
[...]
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index f1e38526d5bd40..996dfdf9d375dd 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2017,7 +2017,7 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>   		.iommu_dev	= smmu->dev,
>   	};
>   
> -	if (smmu_domain->non_strict)
> +	if (!iommu_get_dma_strict())

As Will raised, this also needs to be checking "domain->type == 
IOMMU_DOMAIN_DMA" to maintain equivalent behaviour to the attribute code 
below.

>   		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_NON_STRICT;
>   
>   	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
> @@ -2449,52 +2449,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>   	return group;
>   }
>   
> -static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
> -				    enum iommu_attr attr, void *data)
> -{
> -	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> -
> -	switch (domain->type) {
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
> -}
[...]
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index f985817c967a25..edb1de479dd1a7 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -668,7 +668,6 @@ struct arm_smmu_domain {
>   	struct mutex			init_mutex; /* Protects smmu pointer */
>   
>   	struct io_pgtable_ops		*pgtbl_ops;
> -	bool				non_strict;
>   	atomic_t			nr_ats_masters;
>   
>   	enum arm_smmu_domain_stage	stage;
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> index 0aa6d667274970..3dde22b1f8ffb0 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> @@ -761,6 +761,9 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
>   		.iommu_dev	= smmu->dev,
>   	};
>   
> +	if (!iommu_get_dma_strict())

Ditto here.

Sorry for not spotting that sooner :(

Robin.

> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_NON_STRICT;
> +
>   	if (smmu->impl && smmu->impl->init_context) {
>   		ret = smmu->impl->init_context(smmu_domain, &pgtbl_cfg, dev);
>   		if (ret)
