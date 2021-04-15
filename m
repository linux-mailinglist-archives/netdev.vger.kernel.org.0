Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5225C360312
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhDOHRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:17:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230201AbhDOHRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618471007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wCRl0VxJxSL9UjqcPN4nvBTKlzJxeSk0M+fzlCzX4vs=;
        b=bQBxqyWObtrKXVjWmBJZc2eoR1VoxqhM4WQCE4z27LdaX2s6lAoP20/+1SjVXgRo/tsVgF
        7CcF0BQOAi6tdJNADwaEMXT+9+LIffwRkqysPRmXAkBgkr5e4KOoeN7TR0vCSGuBIy05Am
        7Tp05cVUM999EC0jN30r8hxH5LlUif8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-QmM1FKnsNjOGZJ6okvmyGg-1; Thu, 15 Apr 2021 03:16:45 -0400
X-MC-Unique: QmM1FKnsNjOGZJ6okvmyGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E78F481431F;
        Thu, 15 Apr 2021 07:16:43 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B20F05C255;
        Thu, 15 Apr 2021 07:16:37 +0000 (UTC)
Subject: Re: [PATCH 1/3] vDPA/ifcvf: deduce VIRTIO device ID when probe
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-2-lingshan.zhu@intel.com>
 <85483ff1-cf98-ad05-0c53-74caa2464459@redhat.com>
 <ccf7001b-27f0-27ea-40d2-52ca3cc2386b@linux.intel.com>
 <ffd2861d-2395-de51-a227-f1ef33f74322@redhat.com>
 <92ef6264-4462-cbd4-5db8-6ce6b68762e0@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d3c7ea9f-1849-f890-f647-6caf764a7542@redhat.com>
Date:   Thu, 15 Apr 2021 15:16:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <92ef6264-4462-cbd4-5db8-6ce6b68762e0@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/15 下午2:36, Zhu Lingshan 写道:
>
>
> On 4/15/2021 2:30 PM, Jason Wang wrote:
>>
>> 在 2021/4/15 下午1:52, Zhu Lingshan 写道:
>>>
>>>
>>> On 4/15/2021 11:30 AM, Jason Wang wrote:
>>>>
>>>> 在 2021/4/14 下午5:18, Zhu Lingshan 写道:
>>>>> This commit deduces VIRTIO device ID as device type when probe,
>>>>> then ifcvf_vdpa_get_device_id() can simply return the ID.
>>>>> ifcvf_vdpa_get_features() and ifcvf_vdpa_get_config_size()
>>>>> can work properly based on the device ID.
>>>>>
>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>> ---
>>>>>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 22 ++++++++++------------
>>>>>   2 files changed, 11 insertions(+), 12 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>>>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>>> index b2eeb16b9c2c..1c04cd256fa7 100644
>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>>> @@ -84,6 +84,7 @@ struct ifcvf_hw {
>>>>>       u32 notify_off_multiplier;
>>>>>       u64 req_features;
>>>>>       u64 hw_features;
>>>>> +    u32 dev_type;
>>>>>       struct virtio_pci_common_cfg __iomem *common_cfg;
>>>>>       void __iomem *net_cfg;
>>>>>       struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>> index 44d7586019da..99b0a6b4c227 100644
>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>> @@ -323,19 +323,9 @@ static u32 ifcvf_vdpa_get_generation(struct 
>>>>> vdpa_device *vdpa_dev)
>>>>>     static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>>>>>   {
>>>>> -    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>>>>> -    struct pci_dev *pdev = adapter->pdev;
>>>>> -    u32 ret = -ENODEV;
>>>>> -
>>>>> -    if (pdev->device < 0x1000 || pdev->device > 0x107f)
>>>>> -        return ret;
>>>>> -
>>>>> -    if (pdev->device < 0x1040)
>>>>> -        ret =  pdev->subsystem_device;
>>>>> -    else
>>>>> -        ret =  pdev->device-0x1040;
>>>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>>>   -    return ret;
>>>>> +    return vf->dev_type;
>>>>>   }
>>>>>     static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
>>>>> @@ -466,6 +456,14 @@ static int ifcvf_probe(struct pci_dev *pdev, 
>>>>> const struct pci_device_id *id)
>>>>>       pci_set_drvdata(pdev, adapter);
>>>>>         vf = &adapter->vf;
>>>>> +    if (pdev->device < 0x1000 || pdev->device > 0x107f)
>>>>> +        return -EOPNOTSUPP;
>>>>> +
>>>>> +    if (pdev->device < 0x1040)
>>>>> +        vf->dev_type =  pdev->subsystem_device;
>>>>> +    else
>>>>> +        vf->dev_type =  pdev->device - 0x1040;
>>>>
>>>>
>>>> So a question here, is the device a transtional device or modern one?
>>>>
>>>> If it's a transitonal one, can it swtich endianess automatically or 
>>>> not?
>>>>
>>>> Thanks
>>> Hi Jason,
>>>
>>> This driver should drive both modern and transitional devices as we 
>>> discussed before.
>>> If it's a transitional one, it will act as a modern device by 
>>> default, legacy mode is a fail-over path.
>>
>>
>> Note that legacy driver use native endian, support legacy driver 
>> requires the device to know native endian which I'm not sure your 
>> device can do that.
>>
>> Thanks
> Yes, legacy requires guest native endianess, I think we don't need to 
> worry about this because our transitional device should work in modern 
> mode by
> default(legacy mode is the failover path we will never reach, 
> get_features will fail if no ACCESS_PLATFORM), we don't support legacy 
> device in vDPA.
>
> Thanks


Ok, so I think it's better to add a comment here.

Thanks


>>
>>
>>> For vDPA, it has to support VIRTIO_1 and ACCESS_PLATFORM, so it must 
>>> in modern mode.
>>> I think we don't need to worry about endianess for legacy mode.
>>>
>>> Thanks
>>> Zhu Lingshan
>>>>
>>>>
>>>>> +
>>>>>       vf->base = pcim_iomap_table(pdev);
>>>>>         adapter->pdev = pdev;
>>>>
>>>
>>
>

