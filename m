Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA803BBA76
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 11:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhGEJta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 05:49:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:7585 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGEJt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 05:49:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10035"; a="189332553"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="189332553"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 02:46:50 -0700
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="456668177"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.31.182]) ([10.255.31.182])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 02:46:48 -0700
Subject: Re: [PATCH 3/3] vDPA/ifcvf: set_status() should get a adapter from
 the mgmt dev
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
 <20210630082145.5729-4-lingshan.zhu@intel.com>
 <81d8aaed-f2e8-bbf8-a7d5-71e41837d866@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <15c5660e-3db8-a41e-072a-c8f710d10ab0@intel.com>
Date:   Mon, 5 Jul 2021 17:46:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <81d8aaed-f2e8-bbf8-a7d5-71e41837d866@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2021 1:09 PM, Jason Wang wrote:
>
> 在 2021/6/30 下午4:21, Zhu Lingshan 写道:
>> ifcvf_vdpa_set_status() should get a adapter from the
>> management device
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 7c2f64ca2163..28c71eef1d2b 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -212,13 +212,15 @@ static u8 ifcvf_vdpa_get_status(struct 
>> vdpa_device *vdpa_dev)
>>     static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, 
>> u8 status)
>>   {
>> +    struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>>       struct ifcvf_adapter *adapter;
>>       struct ifcvf_hw *vf;
>>       u8 status_old;
>>       int ret;
>>         vf  = vdpa_to_vf(vdpa_dev);
>> -    adapter = dev_get_drvdata(vdpa_dev->dev.parent);
>
>
> If this is a fix for patch 2, you need to squash this into that one.
sure will squash it to patch 2
>
> Any reason that vdpa_to_adapter() can't work?
will use it in V2.
>
> And I see:
>
> +struct ifcvf_vdpa_mgmt_dev {
> +    struct vdpa_mgmt_dev mdev;
> +    struct ifcvf_adapter *adapter;
> +    struct pci_dev *pdev;
> +};
>
> What's the reason for having a adapter pointer here?
because in ifcvf_remove(), we need to get the management device from 
pdev struct, so need to set the management device pointor
to the pdev drvdata, then need this *adapter pointor to address the adapter.

Thanks
>
>
> Thanks
>
>
>> +    ifcvf_mgmt_dev = dev_get_drvdata(vdpa_dev->dev.parent);
>> +    adapter = ifcvf_mgmt_dev->adapter;
>>       status_old = ifcvf_get_status(vf);
>>         if (status_old == status)
>

