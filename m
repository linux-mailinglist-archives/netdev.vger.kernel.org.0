Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71111396FCE
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhFAJFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:05:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:36550 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232869AbhFAJFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:05:23 -0400
IronPort-SDR: bXjv26V61Ha+BXtc3te2czQLbXemRLFhaQXw+c5wFjxivtLoUrXxa8QtdIWGTDO3Ule3W44gh0
 jM5N4T1xW3IQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="190862736"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="190862736"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 02:03:41 -0700
IronPort-SDR: 2YhH0qmkGRYSzS3nMEORkuSpV41nkD+6Fo/2j0bacEuhhBeEy2VmaSn5pQGbNDyEJLzLkeLRvj
 Q6o0uMm1V80A==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="549668408"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.211.211]) ([10.254.211.211])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 02:03:39 -0700
Subject: Re: [PATCH V3 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210601062850.4547-1-lingshan.zhu@intel.com>
 <20210601062850.4547-3-lingshan.zhu@intel.com>
 <d286a8f9-ac5c-ba95-777e-df926ea45292@redhat.com>
 <0e40f29a-5d37-796a-5d01-8594b3afbfdb@intel.com>
 <5c8ebd49-59fe-31c3-71bf-44bd0bf64e2a@redhat.com>
 <68a31c70-cc9f-346a-14a0-cbc05905c287@intel.com>
Message-ID: <9ecf0004-6022-121d-5515-97f543c3acd3@intel.com>
Date:   Tue, 1 Jun 2021 17:03:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <68a31c70-cc9f-346a-14a0-cbc05905c287@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/1/2021 4:58 PM, Zhu, Lingshan wrote:
>
>
> On 6/1/2021 4:57 PM, Jason Wang wrote:
>>
>> 在 2021/6/1 下午4:56, Zhu, Lingshan 写道:
>>>
>>>
>>> On 6/1/2021 4:50 PM, Jason Wang wrote:
>>>>
>>>> 在 2021/6/1 下午2:28, Zhu Lingshan 写道:
>>>>> This commit implements doorbell mapping feature for ifcvf.
>>>>> This feature maps the notify page to userspace, to eliminate
>>>>> vmexit when kick a vq.
>>>>>
>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>> ---
>>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 21 +++++++++++++++++++++
>>>>>   1 file changed, 21 insertions(+)
>>>>>
>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>> index ab0ab5cf0f6e..d41db042612c 100644
>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>> @@ -413,6 +413,26 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>>>>> vdpa_device *vdpa_dev,
>>>>>       return vf->vring[qid].irq;
>>>>>   }
>>>>>   +static struct vdpa_notification_area 
>>>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>>>>> +                                   u16 idx)
>>>>> +{
>>>>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>>>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>>> +    struct pci_dev *pdev = adapter->pdev;
>>>>> +    struct vdpa_notification_area area;
>>>>> +
>>>>> +    area.addr = vf->vring[idx].notify_pa;
>>>>> +    if (!vf->notify_off_multiplier)
>>>>> +        area.size = PAGE_SIZE;
>>>>> +    else
>>>>> +        area.size = vf->notify_off_multiplier;
>>>>> +
>>>>> +    if (area.addr % PAGE_SIZE)
>>>>> +        IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE 
>>>>> aligned\n", idx);
>>>>
>>>>
>>>> I don't see the reason to keep this, or get_notification is not the 
>>>> proper place to do this kind of warning.
>>>>
>>>> Thanks
>>> some customers have ever complained have troubles to enable such 
>>> features with their IP,
>>> I think this can help them debug.
>>
>>
>> If you want to do this, the ifcvf_init_hw() is the proper place.
>>
>> Note that this function is called by userspace.
>>
>> Thanks
> OK, will move to there.
>
> Thanks!
oh, I see patch 1 is already has been acked, so I will remove this warning.

Thanks!
>>
>>
>>>
>>> Thanks
>>>>
>>>>
>>>>> +
>>>>> +    return area;
>>>>> +}
>>>>> +
>>>>>   /*
>>>>>    * IFCVF currently does't have on-chip IOMMU, so not
>>>>>    * implemented set_map()/dma_map()/dma_unmap()
>>>>> @@ -440,6 +460,7 @@ static const struct vdpa_config_ops 
>>>>> ifc_vdpa_ops = {
>>>>>       .get_config    = ifcvf_vdpa_get_config,
>>>>>       .set_config    = ifcvf_vdpa_set_config,
>>>>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>>>>> +    .get_vq_notification = ifcvf_get_vq_notification,
>>>>>   };
>>>>>     static int ifcvf_probe(struct pci_dev *pdev, const struct 
>>>>> pci_device_id *id)
>>>>
>>>
>>
>

