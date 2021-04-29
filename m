Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F1C36E987
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 13:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhD2L1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 07:27:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:25966 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhD2L1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 07:27:10 -0400
IronPort-SDR: bnyy8rVzjFI5xhK0bs8y4Km/MubCcK/VuLQlst4JM8XlCwgrirRcKaIx1E9CPKK5Oy1ksEqBiw
 7uVPm8Yq7cAg==
X-IronPort-AV: E=McAfee;i="6200,9189,9968"; a="197029050"
X-IronPort-AV: E=Sophos;i="5.82,259,1613462400"; 
   d="scan'208";a="197029050"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 04:26:18 -0700
IronPort-SDR: 6rR9y8kmfinDUbQKppRZ/uP7sAONhZL9QHkj0hsR2petOMhD4RcjAcsVG9avvMqHSm/TJ53V0B
 2zgSBYfu6JHQ==
X-IronPort-AV: E=Sophos;i="5.82,259,1613462400"; 
   d="scan'208";a="526904265"
Received: from xli56-mobl.ccr.corp.intel.com (HELO [10.254.211.239]) ([10.254.211.239])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 04:26:16 -0700
Subject: Re: [PATCH 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
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
 <bca66845-b16d-ee5e-807b-a3570e290813@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <d3bb5231-47cc-86e6-a4b2-a05bd81140a5@intel.com>
Date:   Thu, 29 Apr 2021 19:26:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <bca66845-b16d-ee5e-807b-a3570e290813@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 9:08 PM, Jason Wang wrote:
>
> 在 2021/4/28 下午6:20, Zhu, Lingshan 写道:
>>
>>
>> On 4/28/2021 6:03 PM, Jason Wang wrote:
>>>
>>> 在 2021/4/28 下午5:56, Zhu, Lingshan 写道:
>>>>
>>>>
>>>> On 4/28/2021 5:21 PM, Jason Wang wrote:
>>>>>
>>>>> 在 2021/4/28 下午4:59, Zhu, Lingshan 写道:
>>>>>>
>>>>>>
>>>>>> On 4/28/2021 4:42 PM, Jason Wang wrote:
>>>>>>>
>>>>>>> 在 2021/4/28 下午4:21, Zhu Lingshan 写道:
>>>>>>>> This commit implements doorbell mapping feature for ifcvf.
>>>>>>>> This feature maps the notify page to userspace, to eliminate
>>>>>>>> vmexit when kick a vq.
>>>>>>>>
>>>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>>>> ---
>>>>>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 18 ++++++++++++++++++
>>>>>>>>   1 file changed, 18 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>>>>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>>>> index e48e6b74fe2e..afcb71bc0f51 100644
>>>>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>>>> @@ -413,6 +413,23 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>>>>>>>> vdpa_device *vdpa_dev,
>>>>>>>>       return vf->vring[qid].irq;
>>>>>>>>   }
>>>>>>>>   +static struct vdpa_notification_area 
>>>>>>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>>>>>>>> +                                   u16 idx)
>>>>>>>> +{
>>>>>>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>>>>>> +    struct vdpa_notification_area area;
>>>>>>>> +
>>>>>>>> +    if (vf->notify_pa % PAGE_SIZE) {
>>>>>>>> +        area.addr = 0;
>>>>>>>> +        area.size = 0;
>>>>>>>
>>>>>>>
>>>>>>> We don't need this since:
>>>>>>>
>>>>>>> 1) there's a check in the vhost vDPA
>>>>>> I think you mean this code block in vdpa.c
>>>>>>         notify = ops->get_vq_notification(vdpa, index);
>>>>>>         if (notify.addr & (PAGE_SIZE - 1))
>>>>>>                 return -EINVAL;
>>>>>>
>>>>>> This should work, however, I think the parent driver should 
>>>>>> ensure it passes a PAGE_SIZE aligned address to userspace, to be 
>>>>>> robust, to be reliable.
>>>>>
>>>>>
>>>>> The point is parent is unaware of whether or not there's a userspace.
>>>> when calling this, I think it targets a usersapce program, why 
>>>> kernel space need it, so IMHO no harm if we check this to keep the 
>>>> parent driver robust.
>>>
>>>
>>> Again, vDPA device is unaware of what driver that is bound. It could 
>>> be virtio-vpda, vhost-vdpa or other in the future. It's only the 
>>> vDPA bus driver know how it is actually used.
>>>
>>>
>>>>>
>>>>>
>>>>>>> 2) device is unaware of the bound driver, non page aligned 
>>>>>>> doorbell doesn't necessarily meant it can be used
>>>>>> Yes, non page aligned doorbell can not be used, so there is a check.
>>>>>
>>>>>
>>>>> Typo, what I meant is "it can't be used". That is to say, we 
>>>>> should let the vDPA bus driver to decide whether or not it can be 
>>>>> used.
>>>> If it is not page aligned, there would be extra complexities for 
>>>> vhost/qemu, I see it as a hardware defect, 
>>>
>>>
>>> It is allowed by the virtio spec, isn't it?
>> The spec does not require the doorbell to be page size aligned, 
>> however it still a hardware defect if non page size aligned notify 
>> base present, I will leave a warning message here instead of the 0 
>> value.
>>
>
> Another note is that, using PAGE_SIZE is wrong here since it varies 
> among archs (at most 64K on some one).
For the page alignment checks, I think this is the point of using 
PAGE_SIZE, we want the doorbell placed at the page boundary, PAGE_SIZE 
depends on the arch,
so I think we don't want to use hard code here. We will pass the 
notify_pa to upper layer anyway, just print an warning if not PAGE_SIZE 
aligned.

However I think this may refer to vdpa_notification_area.size, YES, I 
think use PAGE_SIZE directly is wrong here, this size depends on the 
device(bar layout) than the arch, so I will add more code to tell which 
device is probed by the driver, then assign correct value.

Thanks
>
> Thanks
>
>
>> Thanks
>> Zhu Lingshan
>>>
>>> Thanks
>>>
>>>
>>>> why adapt to this kind of defects?
>>>>
>>>> Thanks
>>>> Zhu Lingshan
>>>>>
>>>>> Thanks
>>>>>
>>>>>
>>>>>>
>>>>>> Thanks
>>>>>> Zhu Lingshan
>>>>>>>
>>>>>>> Let's leave those polices to the driver.
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>
>>>>>>>> +    } else {
>>>>>>>> +        area.addr = vf->notify_pa;
>>>>>>>> +        area.size = PAGE_SIZE;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    return area;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>   /*
>>>>>>>>    * IFCVF currently does't have on-chip IOMMU, so not
>>>>>>>>    * implemented set_map()/dma_map()/dma_unmap()
>>>>>>>> @@ -440,6 +457,7 @@ static const struct vdpa_config_ops 
>>>>>>>> ifc_vdpa_ops ={
>>>>>>>>       .get_config    = ifcvf_vdpa_get_config,
>>>>>>>>       .set_config    = ifcvf_vdpa_set_config,
>>>>>>>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>>>>>>>> +    .get_vq_notification = ifcvf_get_vq_notification,
>>>>>>>>   };
>>>>>>>>     static int ifcvf_probe(struct pci_dev *pdev, const struct 
>>>>>>>> pci_device_id *id)
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>

