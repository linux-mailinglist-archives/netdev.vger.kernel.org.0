Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9DD36D598
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 12:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbhD1KTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 06:19:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:9704 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236343AbhD1KTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 06:19:24 -0400
IronPort-SDR: eEHR3xipS7jmHV3goQtnhO60sQSjKCOUqPMGiXuM17dyXusl715syWSE+yzgyWO738KoHviCfe
 HTQR7xe+7BvA==
X-IronPort-AV: E=McAfee;i="6200,9189,9967"; a="194591499"
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="194591499"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 03:18:39 -0700
IronPort-SDR: 35eRNRH85RVTLRH73OYtRFxH45vSLn0DOdo8/CCZsSD6++eUPlh3sleW61lx47OALi0ulx8Rt1
 jUYe0CbePGAA==
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="423462467"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.93]) ([10.254.209.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 03:18:37 -0700
Subject: Re: [PATCH 1/2] vDPA/ifcvf: record virtio notify base
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210428082133.6766-1-lingshan.zhu@intel.com>
 <20210428082133.6766-2-lingshan.zhu@intel.com>
 <55217869-b456-f3bc-0b5a-6beaf34c19f8@redhat.com>
 <3243eeef-2891-5b79-29cb-bc969802c5dc@intel.com>
 <4cee04f1-a3fc-eaf0-747a-004ca09b06c0@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <b9d6d777-0396-4c97-f463-3f85aa4e975e@intel.com>
Date:   Wed, 28 Apr 2021 18:18:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <4cee04f1-a3fc-eaf0-747a-004ca09b06c0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 6:09 PM, Jason Wang wrote:
>
> 在 2021/4/28 下午6:00, Zhu, Lingshan 写道:
>>
>>
>> On 4/28/2021 4:39 PM, Jason Wang wrote:
>>>
>>> 在 2021/4/28 下午4:21, Zhu Lingshan 写道:
>>>> This commit records virtio notify base addr to implemente
>>>> doorbell mapping feature
>>>>
>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>> ---
>>>>   drivers/vdpa/ifcvf/ifcvf_base.c | 1 +
>>>>   drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
>>>>   2 files changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c 
>>>> b/drivers/vdpa/ifcvf/ifcvf_base.c
>>>> index 1a661ab45af5..cc61a5bfc5b1 100644
>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>>>> @@ -133,6 +133,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct 
>>>> pci_dev *pdev)
>>>> &hw->notify_off_multiplier);
>>>>               hw->notify_bar = cap.bar;
>>>>               hw->notify_base = get_cap_addr(hw, &cap);
>>>> +            hw->notify_pa = pci_resource_start(pdev, cap.bar) + 
>>>> cap.offset;
>>>
>>>
>>> To be more generic and avoid future changes, let's use the math 
>>> defined in the virtio spec.
>>>
>>> You may refer how it is implemented in virtio_pci vdpa driver[1].
>> Are you suggesting every vq keep its own notify_pa? In this case, we 
>> still need to record notify_pa in hw when init_hw, then initialize 
>> vq->notify_pa accrediting to hw->notify_pa.
>
>
> I meant you need to follow how virtio spec did to calculate the 
> doorbell address per vq:
>
>         cap.offset + queue_notify_off * notify_off_multiplier
>
> Obviously, you ignore queue_notify_off and notify_off_multiplier here. 
> This may bring troubles for the existing device IFCVF and future devices.
>
> If I understand correctly, this device can be probed by virtio-pci 
> driver which use the above math. There's no reason for using ad-hoc hack.
sure, when talking about initialize vq->notify_pa, I mean calculate with 
with notify_base and multiplier, V2 will include this.

Thanks,
Zhu Lingshan
>
> Thanks
>
>
>>
>> Thanks
>> Zhu Lingshan
>>>
>>> Thanks
>>>
>>> [1] 
>>> https://lore.kernel.org/virtualization/20210415073147.19331-5-jasowang@redhat.com/T/
>>>
>>>
>>>> IFCVF_DBG(pdev, "hw->notify_base = %p\n",
>>>>                     hw->notify_base);
>>>>               break;
>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> index 0111bfdeb342..bcca7c1669dd 100644
>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>> @@ -98,6 +98,7 @@ struct ifcvf_hw {
>>>>       char config_msix_name[256];
>>>>       struct vdpa_callback config_cb;
>>>>       unsigned int config_irq;
>>>> +    phys_addr_t  notify_pa;
>>>>   };
>>>>     struct ifcvf_adapter {
>>>
>>
>

