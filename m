Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB3B698B71
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 05:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBPEn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 23:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPEn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 23:43:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F252ED45
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 20:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676522589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3DDHO8i0zvrnMlu2LxipZBzY2ZSSiL5SyYkVWHiaTdo=;
        b=VTkjZLv4aDGdghk9qh2B1loERMLXGSuuiNwNJDRNq6xYYJxjU+ng44yk/8UncSWzcvYAeU
        cKzDyTgnLPXOQHRvMKJnUBGf7AOPalBqKyKj610Eg8YUd3ddz12iEH4TegLdul71+F7ppr
        XkEi05UPVUDKpER5V8bTfDl7+dBMYVs=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-241-1BSTEoGENV-2d2E0nRfT3A-1; Wed, 15 Feb 2023 23:43:08 -0500
X-MC-Unique: 1BSTEoGENV-2d2E0nRfT3A-1
Received: by mail-pj1-f72.google.com with SMTP id fh18-20020a17090b035200b002341fa85405so358276pjb.5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 20:43:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3DDHO8i0zvrnMlu2LxipZBzY2ZSSiL5SyYkVWHiaTdo=;
        b=u77JsxjiN+OfTzS/9ZqQNwpuFQgrC46G2pUT481EAfsHrNAICfQ5CAOpXqdOVUz30/
         N9fOOYLkQFpT0i0gPGf3sFkuHN9TPsSOFIGqFMQ7UAlZvyYYBZ/APAa1gwDh/IVTP15z
         8Q2H6xTeu/HXnWYj+ILf+wPfCNZj+1qxjVkB9lUW1osAwT9zmWonkNmwc1eAFKJoFP2P
         ywCSyjUBQ+G8SCdMU4Mws3y0x7S1JuTo1SxcJJxWxTFxyVS8yCabZ6bMhTjGrCC9I4tm
         3smamhIVUsHz7ZZrkSGZi4BCHCBVX5jFBn9uzXJY88MjbLyW9QhoStI4D3I0r01ua+Dn
         WoFQ==
X-Gm-Message-State: AO0yUKUEZT/KSSw/NnJN8eew2G7I8xbkUa5FWVDRc1w0i3z0nfLxqLsz
        hAH9VKiibv7K+Itt9mEEAsKXiovswLj0p2AiOzV7NEcIiCf2oodAPkug5lddFiUcTWmNjWt/VRp
        Mt7IhrWLMeUouJnnk
X-Received: by 2002:a17:90b:4c04:b0:234:bf0:86bc with SMTP id na4-20020a17090b4c0400b002340bf086bcmr5369919pjb.31.1676522587176;
        Wed, 15 Feb 2023 20:43:07 -0800 (PST)
X-Google-Smtp-Source: AK7set/qQ5O/TZ0PJALyrxA2Lethp9rxzMGA6y2yAhomtgRtTLlXGq4nNUzsUdYKVT2TS5pjlJl+Xw==
X-Received: by 2002:a17:90b:4c04:b0:234:bf0:86bc with SMTP id na4-20020a17090b4c0400b002340bf086bcmr5369907pjb.31.1676522586789;
        Wed, 15 Feb 2023 20:43:06 -0800 (PST)
Received: from [10.72.12.253] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090aec0200b00233b5d6b4b5sm2306741pjy.16.2023.02.15.20.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 20:43:06 -0800 (PST)
Message-ID: <3bb88db8-1283-f16d-d16a-5d3fb958b584@redhat.com>
Date:   Thu, 16 Feb 2023 12:43:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Content-Language: en-US
To:     Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, mst@redhat.com
Cc:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, wangrong68@huawei.com
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230207120843.1580403-1-sunnanyong@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/2/7 20:08, Nanyong Sun 写道:
> From: Rong Wang <wangrong68@huawei.com>
>
> Once enable iommu domain for one device, the MSI
> translation tables have to be there for software-managed MSI.
> Otherwise, platform with software-managed MSI without an
> irq bypass function, can not get a correct memory write event
> from pcie, will not get irqs.
> The solution is to obtain the MSI phy base address from
> iommu reserved region, and set it to iommu MSI cookie,
> then translation tables will be created while request irq.
>
> Change log
> ----------
>
> v1->v2:
> - add resv iotlb to avoid overlap mapping.
>
> Signed-off-by: Rong Wang <wangrong68@huawei.com>
> Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> ---
>   drivers/iommu/iommu.c |  1 +
>   drivers/vhost/vdpa.c  | 59 ++++++++++++++++++++++++++++++++++++++++---
>   2 files changed, 57 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 5f6a85aea501..af9c064ad8b2 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2623,6 +2623,7 @@ void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>   	if (ops->get_resv_regions)
>   		ops->get_resv_regions(dev, list);
>   }
> +EXPORT_SYMBOL(iommu_get_resv_regions);
>   
>   /**
>    * iommu_put_resv_regions - release resered regions
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec32f785dfde..a58979da8acd 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -49,6 +49,7 @@ struct vhost_vdpa {
>   	struct completion completion;
>   	struct vdpa_device *vdpa;
>   	struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
> +	struct vhost_iotlb resv_iotlb;


Nit: it might be better to rename this as resv_regions.


>   	struct device dev;
>   	struct cdev cdev;
>   	atomic_t opened;
> @@ -216,6 +217,8 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>   
>   	v->in_batch = 0;
>   
> +	vhost_iotlb_reset(&v->resv_iotlb);
> +
>   	return vdpa_reset(vdpa);
>   }
>   
> @@ -1013,6 +1016,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   	    msg->iova + msg->size - 1 > v->range.last)
>   		return -EINVAL;
>   
> +	if (vhost_iotlb_itree_first(&v->resv_iotlb, msg->iova,
> +					msg->iova + msg->size - 1))
> +		return -EINVAL;
> +
>   	if (vhost_iotlb_itree_first(iotlb, msg->iova,
>   				    msg->iova + msg->size - 1))
>   		return -EEXIST;
> @@ -1103,6 +1110,45 @@ static ssize_t vhost_vdpa_chr_write_iter(struct kiocb *iocb,
>   	return vhost_chr_write_iter(dev, from);
>   }
>   
> +static int vhost_vdpa_resv_iommu_region(struct iommu_domain *domain, struct device *dma_dev,
> +	struct vhost_iotlb *resv_iotlb)
> +{
> +	struct list_head dev_resv_regions;
> +	phys_addr_t resv_msi_base = 0;
> +	struct iommu_resv_region *region;
> +	int ret = 0;
> +	bool with_sw_msi = false;
> +	bool with_hw_msi = false;
> +
> +	INIT_LIST_HEAD(&dev_resv_regions);
> +	iommu_get_resv_regions(dma_dev, &dev_resv_regions);
> +
> +	list_for_each_entry(region, &dev_resv_regions, list) {
> +		ret = vhost_iotlb_add_range_ctx(resv_iotlb, region->start,
> +				region->start + region->length - 1,
> +				0, 0, NULL);
> +		if (ret) {
> +			vhost_iotlb_reset(resv_iotlb);
> +			break;
> +		}
> +
> +		if (region->type == IOMMU_RESV_MSI)
> +			with_hw_msi = true;
> +
> +		if (region->type == IOMMU_RESV_SW_MSI) {
> +			resv_msi_base = region->start;
> +			with_sw_msi = true;
> +		}
> +	}
> +
> +	if (!ret && !with_hw_msi && with_sw_msi)
> +		ret = iommu_get_msi_cookie(domain, resv_msi_base);
> +
> +	iommu_put_resv_regions(dma_dev, &dev_resv_regions);
> +
> +	return ret;
> +}


As discussed in v1, I still prefer to factor out the common logic and 
move them to iommu.c. It helps to simplify the future bug fixing and 
enhancement.


> +
>   static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>   {
>   	struct vdpa_device *vdpa = v->vdpa;
> @@ -1128,11 +1174,16 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>   
>   	ret = iommu_attach_device(v->domain, dma_dev);
>   	if (ret)
> -		goto err_attach;
> +		goto err_alloc_domain;
>   
> -	return 0;
> +	ret = vhost_vdpa_resv_iommu_region(v->domain, dma_dev, &v->resv_iotlb);
> +	if (ret)
> +		goto err_attach_device;
>   
> -err_attach:
> +	return 0;
> +err_attach_device:
> +	iommu_detach_device(v->domain, dma_dev);
> +err_alloc_domain:
>   	iommu_domain_free(v->domain);
>   	return ret;
>   }
> @@ -1385,6 +1436,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>   		goto err;
>   	}
>   
> +	vhost_iotlb_init(&v->resv_iotlb, 0, 0);
> +
>   	r = dev_set_name(&v->dev, "vhost-vdpa-%u", minor);
>   	if (r)
>   		goto err;


We need clean resv_iotlb during release().

Other looks good.

Thanks

