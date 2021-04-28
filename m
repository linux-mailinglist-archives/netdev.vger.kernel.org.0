Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B1836D541
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 12:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbhD1KBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 06:01:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:63791 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233396AbhD1KBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 06:01:02 -0400
IronPort-SDR: Y+z8L2G0UNYVsnll2m02PPaz2IjF69kLWteyo0wDfadxocdt4Y+Cq5w8dcnF766KGsWQ4izx31
 XUR7mrESEh6g==
X-IronPort-AV: E=McAfee;i="6200,9189,9967"; a="196811684"
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="196811684"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 03:00:17 -0700
IronPort-SDR: f7aF1oNaLFBuNCA2P0mGV7AtrmkAbXk1n/4Hj0QI2NR+Zt9QbZxP75HRIVkxVsUyF0d/FgYsqV
 YjtEYF8HWpjw==
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="423454172"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.93]) ([10.254.209.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 03:00:09 -0700
Subject: Re: [PATCH 1/2] vDPA/ifcvf: record virtio notify base
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210428082133.6766-1-lingshan.zhu@intel.com>
 <20210428082133.6766-2-lingshan.zhu@intel.com>
 <55217869-b456-f3bc-0b5a-6beaf34c19f8@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <3243eeef-2891-5b79-29cb-bc969802c5dc@intel.com>
Date:   Wed, 28 Apr 2021 18:00:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <55217869-b456-f3bc-0b5a-6beaf34c19f8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 4:39 PM, Jason Wang wrote:
>
> 在 2021/4/28 下午4:21, Zhu Lingshan 写道:
>> This commit records virtio notify base addr to implemente
>> doorbell mapping feature
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.c | 1 +
>>   drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c 
>> b/drivers/vdpa/ifcvf/ifcvf_base.c
>> index 1a661ab45af5..cc61a5bfc5b1 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>> @@ -133,6 +133,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct 
>> pci_dev *pdev)
>> &hw->notify_off_multiplier);
>>               hw->notify_bar = cap.bar;
>>               hw->notify_base = get_cap_addr(hw, &cap);
>> +            hw->notify_pa = pci_resource_start(pdev, cap.bar) + 
>> cap.offset;
>
>
> To be more generic and avoid future changes, let's use the math 
> defined in the virtio spec.
>
> You may refer how it is implemented in virtio_pci vdpa driver[1].
Are you suggesting every vq keep its own notify_pa? In this case, we 
still need to record notify_pa in hw when init_hw, then initialize 
vq->notify_pa accrediting to hw->notify_pa.

Thanks
Zhu Lingshan
>
> Thanks
>
> [1] 
> https://lore.kernel.org/virtualization/20210415073147.19331-5-jasowang@redhat.com/T/
>
>
>> IFCVF_DBG(pdev, "hw->notify_base = %p\n",
>>                     hw->notify_base);
>>               break;
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index 0111bfdeb342..bcca7c1669dd 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -98,6 +98,7 @@ struct ifcvf_hw {
>>       char config_msix_name[256];
>>       struct vdpa_callback config_cb;
>>       unsigned int config_irq;
>> +    phys_addr_t  notify_pa;
>>   };
>>     struct ifcvf_adapter {
>

