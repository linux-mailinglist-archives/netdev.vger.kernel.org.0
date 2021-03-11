Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3B6336B0C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 05:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhCKEQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 23:16:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:47662 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhCKEQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 23:16:30 -0500
IronPort-SDR: liuYow++RLAci02jq+F+SclPp+ebV4fs6hB+keIcOhOfbtNSxhOg5SVx8ofzFCnTwybwck5hcn
 aZ5lZWzV+g4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="185253703"
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="185253703"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 20:16:30 -0800
IronPort-SDR: BdrwlhMDlrN0/JTKh33VYUlZNtT8ch+GwWcC94g1RfHk0/ut4vkZ08Z/PEcXc+XqZ1d4y7z0gp
 1yGs3oxHkwMA==
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="410467022"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.170.224]) ([10.249.170.224])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 20:16:27 -0800
Subject: Re: [PATCH V3 6/6] vDPA/ifcvf: verify mandatory feature bits for vDPA
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-7-lingshan.zhu@intel.com>
 <3e53a5c9-c531-48ee-c9a7-907dfdacc9d1@redhat.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <9c2fb3d0-2d69-20b9-589d-cc5ffc830f38@linux.intel.com>
Date:   Thu, 11 Mar 2021 12:16:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <3e53a5c9-c531-48ee-c9a7-907dfdacc9d1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/2021 11:20 AM, Jason Wang wrote:
>
> On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
>> vDPA requres VIRTIO_F_ACCESS_PLATFORM as a must, this commit
>> examines this when set features.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.c | 8 ++++++++
>>   drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
>>   3 files changed, 14 insertions(+)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c 
>> b/drivers/vdpa/ifcvf/ifcvf_base.c
>> index ea6a78791c9b..58f47fdce385 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>> @@ -224,6 +224,14 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
>>       return hw->hw_features;
>>   }
>>   +int ifcvf_verify_min_features(struct ifcvf_hw *hw)
>> +{
>> +    if (!(hw->hw_features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>> +        return -EINVAL;
>> +
>> +    return 0;
>> +}
>> +
>>   void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
>>                  void *dst, int length)
>>   {
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index dbb8c10aa3b1..91c5735d4dc9 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -123,6 +123,7 @@ void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
>>   void ifcvf_reset(struct ifcvf_hw *hw);
>>   u64 ifcvf_get_features(struct ifcvf_hw *hw);
>>   u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>> +int ifcvf_verify_min_features(struct ifcvf_hw *hw);
>>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 25fb9dfe23f0..f624f202447d 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -179,6 +179,11 @@ static u64 ifcvf_vdpa_get_features(struct 
>> vdpa_device *vdpa_dev)
>>   static int ifcvf_vdpa_set_features(struct vdpa_device *vdpa_dev, 
>> u64 features)
>>   {
>>       struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>> +    int ret;
>> +
>> +    ret = ifcvf_verify_min_features(vf);
>
>
> So this validate device features instead of driver which is the one we 
> really want to check?
>
> Thanks

Hi Jason,

Here we check device feature bits to make sure the device support 
ACCESS_PLATFORM. In get_features(),
it will return a intersection of device features bit and driver 
supported features bits(which includes ACCESS_PLATFORM).
Other components like QEMU should not set features bits more than this 
intersection of bits. so we can make sure if this
ifcvf_verify_min_features() passed, both device and driver support 
ACCESS_PLATFORM.

Are you suggesting check driver feature bits in 
ifcvf_verify_min_features() in the meantime as well?

Thanks！
>
>
>> +    if (ret)
>> +        return ret;
>>         vf->req_features = features;
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

