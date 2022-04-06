Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBC04F657E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbiDFQjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbiDFQhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:37:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B1C32B5EDE;
        Wed,  6 Apr 2022 06:57:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E2F912FC;
        Wed,  6 Apr 2022 06:57:06 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E682C3F73B;
        Wed,  6 Apr 2022 06:57:01 -0700 (PDT)
Message-ID: <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
Date:   Wed, 6 Apr 2022 14:56:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with
 dev_is_dma_coherent()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-05 17:16, Jason Gunthorpe wrote:
> vdpa and usnic are trying to test if IOMMU_CACHE is supported. The correct
> way to do this is via dev_is_dma_coherent()

Not necessarily...

Disregarding the complete disaster of PCIe No Snoop on Arm-Based 
systems, there's the more interesting effectively-opposite scenario 
where an SMMU bridges non-coherent devices to a coherent interconnect. 
It's not something we take advantage of yet in Linux, and it can only be 
properly described in ACPI, but there do exist situations where 
IOMMU_CACHE is capable of making the device's traffic snoop, but 
dev_is_dma_coherent() - and device_get_dma_attr() for external users - 
would still say non-coherent because they can't assume that the SMMU is 
enabled and programmed in just the right way.

I've also not thought too much about how things might look with S2FWB 
thrown into the mix in future...

Robin.

> like the DMA API does. If
> IOMMU_CACHE is not supported then these drivers won't work as they don't
> call any coherency-restoring routines around their DMAs.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/infiniband/hw/usnic/usnic_uiom.c | 16 +++++++---------
>   drivers/vhost/vdpa.c                     |  3 ++-
>   2 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index 760b254ba42d6b..24d118198ac756 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -42,6 +42,7 @@
>   #include <linux/list.h>
>   #include <linux/pci.h>
>   #include <rdma/ib_verbs.h>
> +#include <linux/dma-map-ops.h>
>   
>   #include "usnic_log.h"
>   #include "usnic_uiom.h"
> @@ -474,6 +475,12 @@ int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev)
>   	struct usnic_uiom_dev *uiom_dev;
>   	int err;
>   
> +	if (!dev_is_dma_coherent(dev)) {
> +		usnic_err("IOMMU of %s does not support cache coherency\n",
> +				dev_name(dev));
> +		return -EINVAL;
> +	}
> +
>   	uiom_dev = kzalloc(sizeof(*uiom_dev), GFP_ATOMIC);
>   	if (!uiom_dev)
>   		return -ENOMEM;
> @@ -483,13 +490,6 @@ int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev)
>   	if (err)
>   		goto out_free_dev;
>   
> -	if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY)) {
> -		usnic_err("IOMMU of %s does not support cache coherency\n",
> -				dev_name(dev));
> -		err = -EINVAL;
> -		goto out_detach_device;
> -	}
> -
>   	spin_lock(&pd->lock);
>   	list_add_tail(&uiom_dev->link, &pd->devs);
>   	pd->dev_cnt++;
> @@ -497,8 +497,6 @@ int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev)
>   
>   	return 0;
>   
> -out_detach_device:
> -	iommu_detach_device(pd->domain, dev);
>   out_free_dev:
>   	kfree(uiom_dev);
>   	return err;
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 4c2f0bd062856a..05ea5800febc37 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -22,6 +22,7 @@
>   #include <linux/vdpa.h>
>   #include <linux/nospec.h>
>   #include <linux/vhost.h>
> +#include <linux/dma-map-ops.h>
>   
>   #include "vhost.h"
>   
> @@ -929,7 +930,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>   	if (!bus)
>   		return -EFAULT;
>   
> -	if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> +	if (!dev_is_dma_coherent(dma_dev))
>   		return -ENOTSUPP;
>   
>   	v->domain = iommu_domain_alloc(bus);
