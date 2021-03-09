Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AFB331CFD
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhCIC2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:28:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:25880 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230327AbhCIC2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 21:28:14 -0500
IronPort-SDR: IXyzxNqad/6vfqIgb41veMaKC9nrGHpfetgCycvvaH8jKFSXVu/qnbDGsal0L4MP1hHKHPrzqi
 4J6a5kFY+FBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="175254364"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="175254364"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 18:28:13 -0800
IronPort-SDR: 8r4wJ68tJbcIJQdY3LlMj9iCA32P8h8E22pR3j4pRFftuq36G+FNP1VHDQUNV1s7Iuvo3cNKpj
 mWHvQud1cJiA==
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="509128872"
Received: from szhan21-mobl.ccr.corp.intel.com (HELO [10.255.31.165]) ([10.255.31.165])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 18:28:11 -0800
Subject: Re: [PATCH V2 2/4] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for
 vDPA
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
 <20210308083525.382514-3-lingshan.zhu@intel.com>
 <d37ea3f4-1c18-087b-a444-0d4e1ebbe417@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <93aabf0c-3ea0-72d7-e7d7-1d503fe6cc75@intel.com>
Date:   Tue, 9 Mar 2021 10:28:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d37ea3f4-1c18-087b-a444-0d4e1ebbe417@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/2021 10:23 AM, Jason Wang wrote:
>
> On 2021/3/8 4:35 下午, Zhu Lingshan wrote:
>> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-net
>> for vDPA
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.h | 5 +++++
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
>>   2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index 64696d63fe07..75d9a8052039 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -23,6 +23,11 @@
>>   #define IFCVF_SUBSYS_VENDOR_ID    0x8086
>>   #define IFCVF_SUBSYS_DEVICE_ID    0x001A
>>   +#define C5000X_PL_VENDOR_ID        0x1AF4
>> +#define C5000X_PL_DEVICE_ID        0x1000
>> +#define C5000X_PL_SUBSYS_VENDOR_ID    0x8086
>> +#define C5000X_PL_SUBSYS_DEVICE_ID    0x0001
>
>
> I just notice that the device is a transtitional one. Any reason for 
> doing this?
>
> Note that IFCVF is a moden device anyhow (0x1041). Supporting legacy 
> drive may bring many issues (e.g the definition is non-nomartive). One 
> example is the support of VIRTIO_F_IOMMU_PLATFORM, legacy driver may 
> assume the device can bypass IOMMU.
>
> Thanks
Hi Jason,

This device will support virtio1.0 by default, so has 
VIRTIO_F_IOMMU_PLATFORM by default. Transitional device gives the 
software a chance to fall back to virtio 0.95.
ifcvf drives this device in virtio 1.0 mode, set features 
VIRTIO_F_IOMMU_PLATFORM successfully.

Thanks,
Zhu Lingshan
>
>
>> +
>>   #define IFCVF_SUPPORTED_FEATURES \
>>           ((1ULL << VIRTIO_NET_F_MAC)            | \
>>            (1ULL << VIRTIO_F_ANY_LAYOUT)            | \
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index e501ee07de17..26a2dab7ca66 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -484,6 +484,11 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>>           IFCVF_DEVICE_ID,
>>           IFCVF_SUBSYS_VENDOR_ID,
>>           IFCVF_SUBSYS_DEVICE_ID) },
>> +    { PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
>> +             C5000X_PL_DEVICE_ID,
>> +             C5000X_PL_SUBSYS_VENDOR_ID,
>> +             C5000X_PL_SUBSYS_DEVICE_ID) },
>> +
>>       { 0 },
>>   };
>>   MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);
>

