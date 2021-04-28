Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B0E36D816
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 15:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbhD1NLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 09:11:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239739AbhD1NLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 09:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619615465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F60S2PJ1+RaTbmbuAvPt9+LozPZrWdCqAvitq2IPjV8=;
        b=fBc7jt1bhA4SL77mEB0J1cmUKehYLHt/pmlkLSpZ44wYoSBFtNIC8x9nvQf8jz5OXau6gI
        nA0h+3VXn1vbnxNe49uICb1hlj5FY88OeI2LiAHXXTiucA5yivbEtXrm1aW80HfiNBbRG2
        KrpB4I/n3X815IgSP7bF9SiWiU8fLPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-QhXAdeguPwidVecbidxciA-1; Wed, 28 Apr 2021 09:10:58 -0400
X-MC-Unique: QhXAdeguPwidVecbidxciA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D621287300E;
        Wed, 28 Apr 2021 13:09:04 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-103.pek2.redhat.com [10.72.12.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D95276787D;
        Wed, 28 Apr 2021 13:08:36 +0000 (UTC)
Subject: Re: [PATCH 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210428082133.6766-1-lingshan.zhu@intel.com>
 <20210428082133.6766-3-lingshan.zhu@intel.com>
 <f6d9a424-9025-3eb5-1cb4-0ff22f7bec63@redhat.com>
 <5052fced-cd9a-e453-5cb2-39cdde60a208@intel.com>
 <1984491f-cd5e-d4bc-b328-41e2f2e935fd@redhat.com>
 <ef510c97-1f1c-a121-99db-b659a5f9518c@intel.com>
 <4e0eda74-04ac-a889-471b-03fe65c65606@redhat.com>
 <f4cb4619-5634-e42d-0629-5c40f6b0dcd1@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bca66845-b16d-ee5e-807b-a3570e290813@redhat.com>
Date:   Wed, 28 Apr 2021 21:08:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <f4cb4619-5634-e42d-0629-5c40f6b0dcd1@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/28 下午6:20, Zhu, Lingshan 写道:
>
>
> On 4/28/2021 6:03 PM, Jason Wang wrote:
>>
>> 在 2021/4/28 下午5:56, Zhu, Lingshan 写道:
>>>
>>>
>>> On 4/28/2021 5:21 PM, Jason Wang wrote:
>>>>
>>>> 在 2021/4/28 下午4:59, Zhu, Lingshan 写道:
>>>>>
>>>>>
>>>>> On 4/28/2021 4:42 PM, Jason Wang wrote:
>>>>>>
>>>>>> 在 2021/4/28 下午4:21, Zhu Lingshan 写道:
>>>>>>> This commit implements doorbell mapping feature for ifcvf.
>>>>>>> This feature maps the notify page to userspace, to eliminate
>>>>>>> vmexit when kick a vq.
>>>>>>>
>>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>>> ---
>>>>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 18 ++++++++++++++++++
>>>>>>>   1 file changed, 18 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>>>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>>> index e48e6b74fe2e..afcb71bc0f51 100644
>>>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>>> @@ -413,6 +413,23 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>>>>>>> vdpa_device *vdpa_dev,
>>>>>>>       return vf->vring[qid].irq;
>>>>>>>   }
>>>>>>>   +static struct vdpa_notification_area 
>>>>>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>>>>>>> +                                   u16 idx)
>>>>>>> +{
>>>>>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>>>>> +    struct vdpa_notification_area area;
>>>>>>> +
>>>>>>> +    if (vf->notify_pa % PAGE_SIZE) {
>>>>>>> +        area.addr = 0;
>>>>>>> +        area.size = 0;
>>>>>>
>>>>>>
>>>>>> We don't need this since:
>>>>>>
>>>>>> 1) there's a check in the vhost vDPA
>>>>> I think you mean this code block in vdpa.c
>>>>>         notify = ops->get_vq_notification(vdpa, index);
>>>>>         if (notify.addr & (PAGE_SIZE - 1))
>>>>>                 return -EINVAL;
>>>>>
>>>>> This should work, however, I think the parent driver should ensure 
>>>>> it passes a PAGE_SIZE aligned address to userspace, to be robust, 
>>>>> to be reliable.
>>>>
>>>>
>>>> The point is parent is unaware of whether or not there's a userspace.
>>> when calling this, I think it targets a usersapce program, why 
>>> kernel space need it, so IMHO no harm if we check this to keep the 
>>> parent driver robust.
>>
>>
>> Again, vDPA device is unaware of what driver that is bound. It could 
>> be virtio-vpda, vhost-vdpa or other in the future. It's only the vDPA 
>> bus driver know how it is actually used.
>>
>>
>>>>
>>>>
>>>>>> 2) device is unaware of the bound driver, non page aligned 
>>>>>> doorbell doesn't necessarily meant it can be used
>>>>> Yes, non page aligned doorbell can not be used, so there is a check.
>>>>
>>>>
>>>> Typo, what I meant is "it can't be used". That is to say, we should 
>>>> let the vDPA bus driver to decide whether or not it can be used.
>>> If it is not page aligned, there would be extra complexities for 
>>> vhost/qemu, I see it as a hardware defect, 
>>
>>
>> It is allowed by the virtio spec, isn't it?
> The spec does not require the doorbell to be page size aligned, 
> however it still a hardware defect if non page size aligned notify 
> base present, I will leave a warning message here instead of the 0 value.
>

Another note is that, using PAGE_SIZE is wrong here since it varies 
among archs (at most 64K on some one).

Thanks


> Thanks
> Zhu Lingshan
>>
>> Thanks
>>
>>
>>> why adapt to this kind of defects?
>>>
>>> Thanks
>>> Zhu Lingshan
>>>>
>>>> Thanks
>>>>
>>>>
>>>>>
>>>>> Thanks
>>>>> Zhu Lingshan
>>>>>>
>>>>>> Let's leave those polices to the driver.
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>> +    } else {
>>>>>>> +        area.addr = vf->notify_pa;
>>>>>>> +        area.size = PAGE_SIZE;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    return area;
>>>>>>> +}
>>>>>>> +
>>>>>>>   /*
>>>>>>>    * IFCVF currently does't have on-chip IOMMU, so not
>>>>>>>    * implemented set_map()/dma_map()/dma_unmap()
>>>>>>> @@ -440,6 +457,7 @@ static const struct vdpa_config_ops 
>>>>>>> ifc_vdpa_ops ={
>>>>>>>       .get_config    = ifcvf_vdpa_get_config,
>>>>>>>       .set_config    = ifcvf_vdpa_set_config,
>>>>>>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>>>>>>> +    .get_vq_notification = ifcvf_get_vq_notification,
>>>>>>>   };
>>>>>>>     static int ifcvf_probe(struct pci_dev *pdev, const struct 
>>>>>>> pci_device_id *id)
>>>>>>
>>>>>
>>>>
>>>
>>
>

