Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123F16993EC
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBPMKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBPMKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:10:38 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F3155E45;
        Thu, 16 Feb 2023 04:10:36 -0800 (PST)
Received: from kwepemm600003.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PHYcX6PTSz16Ncd;
        Thu, 16 Feb 2023 20:08:12 +0800 (CST)
Received: from [10.174.179.79] (10.174.179.79) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 16 Feb 2023 20:10:33 +0800
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To:     Jason Wang <jasowang@redhat.com>, <joro@8bytes.org>,
        <will@kernel.org>, <robin.murphy@arm.com>, <mst@redhat.com>
CC:     <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <wangrong68@huawei.com>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <3bb88db8-1283-f16d-d16a-5d3fb958b584@redhat.com>
From:   Nanyong Sun <sunnanyong@huawei.com>
Message-ID: <31bb1d1e-22ac-e576-110d-4e13fb822167@huawei.com>
Date:   Thu, 16 Feb 2023 20:10:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3bb88db8-1283-f16d-d16a-5d3fb958b584@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.79]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/2/16 12:43, Jason Wang wrote:

>
> 在 2023/2/7 20:08, Nanyong Sun 写道:
>> From: Rong Wang <wangrong68@huawei.com>
>>
>> Once enable iommu domain for one device, the MSI
>> translation tables have to be there for software-managed MSI.
>> Otherwise, platform with software-managed MSI without an
>> irq bypass function, can not get a correct memory write event
>> from pcie, will not get irqs.
>> The solution is to obtain the MSI phy base address from
>> iommu reserved region, and set it to iommu MSI cookie,
>> then translation tables will be created while request irq.
>>
>> Change log
>> ----------
>>
>> v1->v2:
>> - add resv iotlb to avoid overlap mapping.
>>
>> Signed-off-by: Rong Wang <wangrong68@huawei.com>
>> Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
>> ---
>>   drivers/iommu/iommu.c |  1 +
>>   drivers/vhost/vdpa.c  | 59 ++++++++++++++++++++++++++++++++++++++++---
>>   2 files changed, 57 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 5f6a85aea501..af9c064ad8b2 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2623,6 +2623,7 @@ void iommu_get_resv_regions(struct device *dev, 
>> struct list_head *list)
>>       if (ops->get_resv_regions)
>>           ops->get_resv_regions(dev, list);
>>   }
>> +EXPORT_SYMBOL(iommu_get_resv_regions);
>>     /**
>>    * iommu_put_resv_regions - release resered regions
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index ec32f785dfde..a58979da8acd 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -49,6 +49,7 @@ struct vhost_vdpa {
>>       struct completion completion;
>>       struct vdpa_device *vdpa;
>>       struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
>> +    struct vhost_iotlb resv_iotlb;
>
>
> Nit: it might be better to rename this as resv_regions.
>

Agree, and will do that in version3

>
>>       struct device dev;
>>       struct cdev cdev;
>>       atomic_t opened;
>> @@ -216,6 +217,8 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>>         v->in_batch = 0;
>>   +    vhost_iotlb_reset(&v->resv_iotlb);
>> +
>>       return vdpa_reset(vdpa);
>>   }
>>   @@ -1013,6 +1016,10 @@ static int 
>> vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>           msg->iova + msg->size - 1 > v->range.last)
>>           return -EINVAL;
>>   +    if (vhost_iotlb_itree_first(&v->resv_iotlb, msg->iova,
>> +                    msg->iova + msg->size - 1))
>> +        return -EINVAL;
>> +
>>       if (vhost_iotlb_itree_first(iotlb, msg->iova,
>>                       msg->iova + msg->size - 1))
>>           return -EEXIST;
>> @@ -1103,6 +1110,45 @@ static ssize_t 
>> vhost_vdpa_chr_write_iter(struct kiocb *iocb,
>>       return vhost_chr_write_iter(dev, from);
>>   }
>>   +static int vhost_vdpa_resv_iommu_region(struct iommu_domain 
>> *domain, struct device *dma_dev,
>> +    struct vhost_iotlb *resv_iotlb)
>> +{
>> +    struct list_head dev_resv_regions;
>> +    phys_addr_t resv_msi_base = 0;
>> +    struct iommu_resv_region *region;
>> +    int ret = 0;
>> +    bool with_sw_msi = false;
>> +    bool with_hw_msi = false;
>> +
>> +    INIT_LIST_HEAD(&dev_resv_regions);
>> +    iommu_get_resv_regions(dma_dev, &dev_resv_regions);
>> +
>> +    list_for_each_entry(region, &dev_resv_regions, list) {
>> +        ret = vhost_iotlb_add_range_ctx(resv_iotlb, region->start,
>> +                region->start + region->length - 1,
>> +                0, 0, NULL);
>> +        if (ret) {
>> +            vhost_iotlb_reset(resv_iotlb);
>> +            break;
>> +        }
>> +
>> +        if (region->type == IOMMU_RESV_MSI)
>> +            with_hw_msi = true;
>> +
>> +        if (region->type == IOMMU_RESV_SW_MSI) {
>> +            resv_msi_base = region->start;
>> +            with_sw_msi = true;
>> +        }
>> +    }
>> +
>> +    if (!ret && !with_hw_msi && with_sw_msi)
>> +        ret = iommu_get_msi_cookie(domain, resv_msi_base);
>> +
>> +    iommu_put_resv_regions(dma_dev, &dev_resv_regions);
>> +
>> +    return ret;
>> +}
>
>
> As discussed in v1, I still prefer to factor out the common logic and 
> move them to iommu.c. It helps to simplify the future bug fixing and 
> enhancement.

Ok, will do that in version3

>
>
>> +
>>   static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>>   {
>>       struct vdpa_device *vdpa = v->vdpa;
>> @@ -1128,11 +1174,16 @@ static int vhost_vdpa_alloc_domain(struct 
>> vhost_vdpa *v)
>>         ret = iommu_attach_device(v->domain, dma_dev);
>>       if (ret)
>> -        goto err_attach;
>> +        goto err_alloc_domain;
>>   -    return 0;
>> +    ret = vhost_vdpa_resv_iommu_region(v->domain, dma_dev, 
>> &v->resv_iotlb);
>> +    if (ret)
>> +        goto err_attach_device;
>>   -err_attach:
>> +    return 0;
>> +err_attach_device:
>> +    iommu_detach_device(v->domain, dma_dev);
>> +err_alloc_domain:
>>       iommu_domain_free(v->domain);
>>       return ret;
>>   }
>> @@ -1385,6 +1436,8 @@ static int vhost_vdpa_probe(struct vdpa_device 
>> *vdpa)
>>           goto err;
>>       }
>>   +    vhost_iotlb_init(&v->resv_iotlb, 0, 0);
>> +
>>       r = dev_set_name(&v->dev, "vhost-vdpa-%u", minor);
>>       if (r)
>>           goto err;
>
>
> We need clean resv_iotlb during release().

I added vhost_iotlb_reset in vhost_vdpa_reset, so will clean while call vhost_vdpa_release() and vhost_vdpa_open().

>
> Other looks good.
>
> Thanks
>
> .
