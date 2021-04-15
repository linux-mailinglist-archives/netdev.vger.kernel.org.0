Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078FD3601ED
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 07:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhDOFw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 01:52:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:25726 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhDOFwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 01:52:54 -0400
IronPort-SDR: TbkUdDfVXElomNtXHWjrAI1w9AVEoQXlAVVJokbeUvedM5tG3yGEkoreGNO1f6BHCkKnwe8b1S
 AWs8a/hNU2uA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="194815407"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="194815407"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 22:52:31 -0700
IronPort-SDR: le0ePrD8dHFzeHU/i6bw3s4nn51etvnkSpndLPjm4rQvetke09KhH4n/uymUhDXJzUEwfISQ/r
 EzsDssBx+nBw==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="418621890"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.173]) ([10.254.209.173])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 22:52:28 -0700
Subject: Re: [PATCH 1/3] vDPA/ifcvf: deduce VIRTIO device ID when probe
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-2-lingshan.zhu@intel.com>
 <85483ff1-cf98-ad05-0c53-74caa2464459@redhat.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <ccf7001b-27f0-27ea-40d2-52ca3cc2386b@linux.intel.com>
Date:   Thu, 15 Apr 2021 13:52:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <85483ff1-cf98-ad05-0c53-74caa2464459@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 11:30 AM, Jason Wang wrote:
>
> 在 2021/4/14 下午5:18, Zhu Lingshan 写道:
>> This commit deduces VIRTIO device ID as device type when probe,
>> then ifcvf_vdpa_get_device_id() can simply return the ID.
>> ifcvf_vdpa_get_features() and ifcvf_vdpa_get_config_size()
>> can work properly based on the device ID.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 22 ++++++++++------------
>>   2 files changed, 11 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index b2eeb16b9c2c..1c04cd256fa7 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -84,6 +84,7 @@ struct ifcvf_hw {
>>       u32 notify_off_multiplier;
>>       u64 req_features;
>>       u64 hw_features;
>> +    u32 dev_type;
>>       struct virtio_pci_common_cfg __iomem *common_cfg;
>>       void __iomem *net_cfg;
>>       struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 44d7586019da..99b0a6b4c227 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -323,19 +323,9 @@ static u32 ifcvf_vdpa_get_generation(struct 
>> vdpa_device *vdpa_dev)
>>     static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>>   {
>> -    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>> -    struct pci_dev *pdev = adapter->pdev;
>> -    u32 ret = -ENODEV;
>> -
>> -    if (pdev->device < 0x1000 || pdev->device > 0x107f)
>> -        return ret;
>> -
>> -    if (pdev->device < 0x1040)
>> -        ret =  pdev->subsystem_device;
>> -    else
>> -        ret =  pdev->device - 0x1040;
>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>   -    return ret;
>> +    return vf->dev_type;
>>   }
>>     static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
>> @@ -466,6 +456,14 @@ static int ifcvf_probe(struct pci_dev *pdev, 
>> const struct pci_device_id *id)
>>       pci_set_drvdata(pdev, adapter);
>>         vf = &adapter->vf;
>> +    if (pdev->device < 0x1000 || pdev->device > 0x107f)
>> +        return -EOPNOTSUPP;
>> +
>> +    if (pdev->device < 0x1040)
>> +        vf->dev_type =  pdev->subsystem_device;
>> +    else
>> +        vf->dev_type =  pdev->device - 0x1040;
>
>
> So a question here, is the device a transtional device or modern one?
>
> If it's a transitonal one, can it swtich endianess automatically or not?
>
> Thanks
Hi Jason,

This driver should drive both modern and transitional devices as we 
discussed before.
If it's a transitional one, it will act as a modern device by default, 
legacy mode is a fail-over path.
For vDPA, it has to support VIRTIO_1 and ACCESS_PLATFORM, so it must in 
modern mode.
I think we don't need to worry about endianess for legacy mode.

Thanks
Zhu Lingshan
>
>
>> +
>>       vf->base = pcim_iomap_table(pdev);
>>         adapter->pdev = pdev;
>

