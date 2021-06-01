Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A51396BD8
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 05:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhFAD32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 23:29:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:18754 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhFAD32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 23:29:28 -0400
IronPort-SDR: 8Y6gkBWA4n93WbURa/Zi+boRI4v3M01Qx2liCxryoOzseSCfKesVQ3VX15fXp33JQ5VRuHNKbr
 M8kYxAbm2dcw==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="203267176"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="203267176"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 20:27:47 -0700
IronPort-SDR: Ut/19svZPkIiIO53f0VSY49q/qX06epLglQU70tOb4zT+Q93Y2nwsAQhDnoA9bQ+x7vFOb5nds
 hUzCGZgjI7hA==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="445169944"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.215.13]) ([10.254.215.13])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 20:27:45 -0700
Subject: Re: [PATCH V2 RESEND 2/2] vDPA/ifcvf: implement doorbell mapping for
 ifcvf
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210531073316.363655-1-lingshan.zhu@intel.com>
 <20210531073316.363655-3-lingshan.zhu@intel.com>
 <f3c28e92-3e8d-2a8a-ec5a-fc64f2098678@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <5dbdc6a5-1510-9411-6b85-d947d091089c@intel.com>
Date:   Tue, 1 Jun 2021 11:27:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <f3c28e92-3e8d-2a8a-ec5a-fc64f2098678@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/2021 3:56 PM, Jason Wang wrote:
>
> 在 2021/5/31 下午3:33, Zhu Lingshan 写道:
>> This commit implements doorbell mapping feature for ifcvf.
>> This feature maps the notify page to userspace, to eliminate
>> vmexit when kick a vq.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index ab0ab5cf0f6e..effb0e549135 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -413,6 +413,22 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>> vdpa_device *vdpa_dev,
>>       return vf->vring[qid].irq;
>>   }
>>   +static struct vdpa_notification_area 
>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>> +                                   u16 idx)
>> +{
>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>> +    struct pci_dev *pdev = adapter->pdev;
>> +    struct vdpa_notification_area area;
>> +
>> +    area.addr = vf->vring[idx].notify_pa;
>> +    area.size = PAGE_SIZE;
>> +    if (area.addr % PAGE_SIZE)
>> +        IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE 
>> aligned\n", idx);
>
>
> Let's leave the decision to upper layer by: (see 
> vp_vdpa_get_vq_notification)
>
> area.addr = notify_pa;
> area.size = notify_offset_multiplier;
>
> Thanks

Hi Jason,

notify_offset_multiplier can be zero, means vqs share the same doorbell 
address, distinguished by qid.
and in vdpa.c:

         if (vma->vm_end - vma->vm_start != notify.size)
                 return -ENOTSUPP;

so a zero size would cause this feature failure.
mmap should work on at least a page, so if we really want "area.size = 
notify_offset_multiplier;"
I think we should add some code in vdpa.c, like:

if(!notify.size)
     notify.size = PAGE_SIZE;

sounds good?

Thanks
Zhu Lingshan
>
>
>> +
>> +    return area;
>> +}
>> +
>>   /*
>>    * IFCVF currently does't have on-chip IOMMU, so not
>>    * implemented set_map()/dma_map()/dma_unmap()
>> @@ -440,6 +456,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>>       .get_config    = ifcvf_vdpa_get_config,
>>       .set_config    = ifcvf_vdpa_set_config,
>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>> +    .get_vq_notification = ifcvf_get_vq_notification,
>>   };
>>     static int ifcvf_probe(struct pci_dev *pdev, const struct 
>> pci_device_id *id)
>

