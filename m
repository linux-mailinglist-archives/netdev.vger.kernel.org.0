Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9615636D527
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 11:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbhD1J4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 05:56:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:55726 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhD1J4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 05:56:51 -0400
IronPort-SDR: lkpQhPGSx0IMmKw/ZN1ed+cFC4CR+3ZZ8AtRfWaBXYjalaIgIWaKG/wiOj4bRp/OahK2hApr6t
 WBgNLex10XEw==
X-IronPort-AV: E=McAfee;i="6200,9189,9967"; a="196258062"
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="196258062"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 02:56:06 -0700
IronPort-SDR: /jvroPBN/VZ3UMZDpzwauVfbEJ4mVOZswAFhEHEX1XPOpFgJu1IRQRcQk2hz5CEP7DN3NMMPi1
 MUtnimI6c2Vg==
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="423452748"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.93]) ([10.254.209.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 02:56:04 -0700
Subject: Re: [PATCH 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210428082133.6766-1-lingshan.zhu@intel.com>
 <20210428082133.6766-3-lingshan.zhu@intel.com>
 <f6d9a424-9025-3eb5-1cb4-0ff22f7bec63@redhat.com>
 <5052fced-cd9a-e453-5cb2-39cdde60a208@intel.com>
 <1984491f-cd5e-d4bc-b328-41e2f2e935fd@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <ef510c97-1f1c-a121-99db-b659a5f9518c@intel.com>
Date:   Wed, 28 Apr 2021 17:56:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1984491f-cd5e-d4bc-b328-41e2f2e935fd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 5:21 PM, Jason Wang wrote:
>
> 在 2021/4/28 下午4:59, Zhu, Lingshan 写道:
>>
>>
>> On 4/28/2021 4:42 PM, Jason Wang wrote:
>>>
>>> 在 2021/4/28 下午4:21, Zhu Lingshan 写道:
>>>> This commit implements doorbell mapping feature for ifcvf.
>>>> This feature maps the notify page to userspace, to eliminate
>>>> vmexit when kick a vq.
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 18 ++++++++++++++++++
>>>>   1 file changed, 18 insertions(+)
>>>>
>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> index e48e6b74fe2e..afcb71bc0f51 100644
>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> @@ -413,6 +413,23 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>>>> vdpa_device *vdpa_dev,
>>>>       return vf->vring[qid].irq;
>>>>   }
>>>>   +static struct vdpa_notification_area 
>>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>>>> +                                   u16 idx)
>>>> +{
>>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>> +    struct vdpa_notification_area area;
>>>> +
>>>> +    if (vf->notify_pa % PAGE_SIZE) {
>>>> +        area.addr = 0;
>>>> +        area.size = 0;
>>>
>>>
>>> We don't need this since:
>>>
>>> 1) there's a check in the vhost vDPA
>> I think you mean this code block in vdpa.c
>>         notify = ops->get_vq_notification(vdpa, index);
>>         if (notify.addr & (PAGE_SIZE - 1))
>>                 return -EINVAL;
>>
>> This should work, however, I think the parent driver should ensure it 
>> passes a PAGE_SIZE aligned address to userspace, to be robust, to be 
>> reliable.
>
>
> The point is parent is unaware of whether or not there's a userspace.
when calling this, I think it targets a usersapce program, why kernel 
space need it, so IMHO no harm if we check this to keep the parent 
driver robust.
>
>
>>> 2) device is unaware of the bound driver, non page aligned doorbell 
>>> doesn't necessarily meant it can be used
>> Yes, non page aligned doorbell can not be used, so there is a check.
>
>
> Typo, what I meant is "it can't be used". That is to say, we should 
> let the vDPA bus driver to decide whether or not it can be used.
If it is not page aligned, there would be extra complexities for 
vhost/qemu, I see it as a hardware defect, why adapt to this kind of 
defects?

Thanks
Zhu Lingshan
>
> Thanks
>
>
>>
>> Thanks
>> Zhu Lingshan
>>>
>>> Let's leave those polices to the driver.
>>>
>>> Thanks
>>>
>>>
>>>> +    } else {
>>>> +        area.addr = vf->notify_pa;
>>>> +        area.size = PAGE_SIZE;
>>>> +    }
>>>> +
>>>> +    return area;
>>>> +}
>>>> +
>>>>   /*
>>>>    * IFCVF currently does't have on-chip IOMMU, so not
>>>>    * implemented set_map()/dma_map()/dma_unmap()
>>>> @@ -440,6 +457,7 @@ static const struct vdpa_config_ops 
>>>> ifc_vdpa_ops ={
>>>>       .get_config    = ifcvf_vdpa_get_config,
>>>>       .set_config    = ifcvf_vdpa_set_config,
>>>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>>>> +    .get_vq_notification = ifcvf_get_vq_notification,
>>>>   };
>>>>     static int ifcvf_probe(struct pci_dev *pdev, const struct 
>>>> pci_device_id *id)
>>>
>>
>

