Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B95E396FB3
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhFAJAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:00:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:55975 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233438AbhFAJAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:00:37 -0400
IronPort-SDR: AyfSQx/xNlFNpqBM1efqbWms3kekNBjRZz10JjX/2NRnSFvVAdSbpZgZWbmxhkCDBzpXuhuIwV
 /R1kxOZ8QmaQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="289124070"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="289124070"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:58:55 -0700
IronPort-SDR: tW72peD34BIQ9NGkVbEaGI+B0ED1hsNEgf8l5k9IWBj51ku5TLfNLLTBzgRNP1K0jlZT840Z83
 JvahvCxbXKPQ==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="549667077"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.211.211]) ([10.254.211.211])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:58:54 -0700
Subject: Re: [PATCH V3 2/2] vDPA/ifcvf: implement doorbell mapping for ifcvf
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210601062850.4547-1-lingshan.zhu@intel.com>
 <20210601062850.4547-3-lingshan.zhu@intel.com>
 <d286a8f9-ac5c-ba95-777e-df926ea45292@redhat.com>
 <0e40f29a-5d37-796a-5d01-8594b3afbfdb@intel.com>
 <5c8ebd49-59fe-31c3-71bf-44bd0bf64e2a@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <68a31c70-cc9f-346a-14a0-cbc05905c287@intel.com>
Date:   Tue, 1 Jun 2021 16:58:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <5c8ebd49-59fe-31c3-71bf-44bd0bf64e2a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/1/2021 4:57 PM, Jason Wang wrote:
>
> 在 2021/6/1 下午4:56, Zhu, Lingshan 写道:
>>
>>
>> On 6/1/2021 4:50 PM, Jason Wang wrote:
>>>
>>> 在 2021/6/1 下午2:28, Zhu Lingshan 写道:
>>>> This commit implements doorbell mapping feature for ifcvf.
>>>> This feature maps the notify page to userspace, to eliminate
>>>> vmexit when kick a vq.
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 21 +++++++++++++++++++++
>>>>   1 file changed, 21 insertions(+)
>>>>
>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> index ab0ab5cf0f6e..d41db042612c 100644
>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>> @@ -413,6 +413,26 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>>>> vdpa_device *vdpa_dev,
>>>>       return vf->vring[qid].irq;
>>>>   }
>>>>   +static struct vdpa_notification_area 
>>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>>>> +                                   u16 idx)
>>>> +{
>>>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>> +    struct pci_dev *pdev = adapter->pdev;
>>>> +    struct vdpa_notification_area area;
>>>> +
>>>> +    area.addr = vf->vring[idx].notify_pa;
>>>> +    if (!vf->notify_off_multiplier)
>>>> +        area.size = PAGE_SIZE;
>>>> +    else
>>>> +        area.size = vf->notify_off_multiplier;
>>>> +
>>>> +    if (area.addr % PAGE_SIZE)
>>>> +        IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE 
>>>> aligned\n", idx);
>>>
>>>
>>> I don't see the reason to keep this, or get_notification is not the 
>>> proper place to do this kind of warning.
>>>
>>> Thanks
>> some customers have ever complained have troubles to enable such 
>> features with their IP,
>> I think this can help them debug.
>
>
> If you want to do this, the ifcvf_init_hw() is the proper place.
>
> Note that this function is called by userspace.
>
> Thanks
OK, will move to there.

Thanks!
>
>
>>
>> Thanks
>>>
>>>
>>>> +
>>>> +    return area;
>>>> +}
>>>> +
>>>>   /*
>>>>    * IFCVF currently does't have on-chip IOMMU, so not
>>>>    * implemented set_map()/dma_map()/dma_unmap()
>>>> @@ -440,6 +460,7 @@ static const struct vdpa_config_ops 
>>>> ifc_vdpa_ops = {
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

