Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AA6336B12
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 05:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCKEV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 23:21:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:33617 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhCKEVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 23:21:51 -0500
IronPort-SDR: yJQPSWQ3T/Wpr99F48lKRe4CirL5sj+fndyEwuCzyuX7EaiYZiDubzI23MCg7UHARo3flOYBKe
 9udlW2oEbNwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="175716896"
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="175716896"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 20:21:50 -0800
IronPort-SDR: 55TR9K9caS5NVQLkbSlzyZ3lHQOoazlWGFpZarFnzMTjZ9KbQwjDgIGXQWNDyxVz7Z70qQVMJU
 OaEJ8EA0Vsqw==
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="410467824"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.170.224]) ([10.249.170.224])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 20:21:48 -0800
Subject: Re: [PATCH V3 1/6] vDPA/ifcvf: get_vendor_id returns a device
 specific vendor id
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-2-lingshan.zhu@intel.com>
 <ff5fc8f9-f886-bd2a-60cc-771c628c6c4b@redhat.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <5f2d915f-e1b0-c9eb-9fc8-4b64f5d8cd0f@linux.intel.com>
Date:   Thu, 11 Mar 2021 12:21:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <ff5fc8f9-f886-bd2a-60cc-771c628c6c4b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/2021 11:23 AM, Jason Wang wrote:
>
> On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
>> In this commit, ifcvf_get_vendor_id() will return
>> a device specific vendor id of the probed pci device
>> than a hard code.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index fa1af301cf55..e501ee07de17 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -324,7 +324,10 @@ static u32 ifcvf_vdpa_get_device_id(struct 
>> vdpa_device *vdpa_dev)
>>     static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
>>   {
>> -    return IFCVF_SUBSYS_VENDOR_ID;
>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>> +    struct pci_dev *pdev = adapter->pdev;
>> +
>> +    return pdev->subsystem_vendor;
>>   }
>
>
> While at this, I wonder if we can do something similar in 
> get_device_id() if it could be simple deduced from some simple math 
> from the pci device id?
>
> Thanks
Hi Jason,

IMHO, this implementation is just some memory read ops, I think other 
implementations may not save many cpu cycles, an if cost at least three 
cpu cycles.

Thanks!
>
>
>>     static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>

