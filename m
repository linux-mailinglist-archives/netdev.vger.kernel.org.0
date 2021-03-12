Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6B333860E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 07:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhCLGkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 01:40:49 -0500
Received: from mga04.intel.com ([192.55.52.120]:1795 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhCLGkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 01:40:37 -0500
IronPort-SDR: WpSkSycepxtyrJacb5u8TFUU4Wd7Jg3rfPfr2AovdFpNpfUNaZNyCwsC4K8RiwvGMhjFCzk3tj
 16edUv7Pe+xg==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="186416776"
X-IronPort-AV: E=Sophos;i="5.81,242,1610438400"; 
   d="scan'208";a="186416776"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 22:40:36 -0800
IronPort-SDR: T6+IIT5dUJgvUP2o5e2S60+UU2tbglvfwcnw/zvytnFpNdDjZhOgeCvMaop0Q4TNhHm0iQCpkg
 RecChuH4nEUA==
X-IronPort-AV: E=Sophos;i="5.81,242,1610438400"; 
   d="scan'208";a="410909635"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.214.210]) ([10.254.214.210])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 22:40:33 -0800
Subject: Re: [PATCH V3 6/6] vDPA/ifcvf: verify mandatory feature bits for vDPA
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@linux.intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-7-lingshan.zhu@intel.com>
 <3e53a5c9-c531-48ee-c9a7-907dfdacc9d1@redhat.com>
 <9c2fb3d0-2d69-20b9-589d-cc5ffc830f38@linux.intel.com>
 <4f3ef2bb-d823-d53d-3bb0-0152a3f6c9f1@redhat.com>
 <a1f346cc-c9fd-6d16-39d7-b59965a18b0a@intel.com>
 <67be60b6-bf30-de85-ed42-d9fad974f42b@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <2a6e31d3-ea31-9b64-0749-1f149b656623@intel.com>
Date:   Fri, 12 Mar 2021 14:40:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <67be60b6-bf30-de85-ed42-d9fad974f42b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/12/2021 1:52 PM, Jason Wang wrote:
>
> On 2021/3/11 3:19 下午, Zhu, Lingshan wrote:
>>
>>
>> On 3/11/2021 2:20 PM, Jason Wang wrote:
>>>
>>> On 2021/3/11 12:16 下午, Zhu Lingshan wrote:
>>>>
>>>>
>>>> On 3/11/2021 11:20 AM, Jason Wang wrote:
>>>>>
>>>>> On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
>>>>>> vDPA requres VIRTIO_F_ACCESS_PLATFORM as a must, this commit
>>>>>> examines this when set features.
>>>>>>
>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> ---
>>>>>>   drivers/vdpa/ifcvf/ifcvf_base.c | 8 ++++++++
>>>>>>   drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
>>>>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
>>>>>>   3 files changed, 14 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c 
>>>>>> b/drivers/vdpa/ifcvf/ifcvf_base.c
>>>>>> index ea6a78791c9b..58f47fdce385 100644
>>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>>>>>> @@ -224,6 +224,14 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
>>>>>>       return hw->hw_features;
>>>>>>   }
>>>>>>   +int ifcvf_verify_min_features(struct ifcvf_hw *hw)
>>>>>> +{
>>>>>> +    if (!(hw->hw_features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>>>>>> +        return -EINVAL;
>>>>>> +
>>>>>> +    return 0;
>>>>>> +}
>>>>>> +
>>>>>>   void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
>>>>>>                  void *dst, int length)
>>>>>>   {
>>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>>>>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>>>> index dbb8c10aa3b1..91c5735d4dc9 100644
>>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>>>>> @@ -123,6 +123,7 @@ void io_write64_twopart(u64 val, u32 *lo, u32 
>>>>>> *hi);
>>>>>>   void ifcvf_reset(struct ifcvf_hw *hw);
>>>>>>   u64 ifcvf_get_features(struct ifcvf_hw *hw);
>>>>>>   u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>>>>>> +int ifcvf_verify_min_features(struct ifcvf_hw *hw);
>>>>>>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>>>>>>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>>>>>>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>>>>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>>>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>> index 25fb9dfe23f0..f624f202447d 100644
>>>>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>>>>> @@ -179,6 +179,11 @@ static u64 ifcvf_vdpa_get_features(struct 
>>>>>> vdpa_device *vdpa_dev)
>>>>>>   static int ifcvf_vdpa_set_features(struct vdpa_device 
>>>>>> *vdpa_dev, u64 features)
>>>>>>   {
>>>>>>       struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>>>>> +    int ret;
>>>>>> +
>>>>>> +    ret = ifcvf_verify_min_features(vf);
>>>>>
>>>>>
>>>>> So this validate device features instead of driver which is the 
>>>>> one we really want to check?
>>>>>
>>>>> Thanks
>>>>
>>>> Hi Jason,
>>>>
>>>> Here we check device feature bits to make sure the device support 
>>>> ACCESS_PLATFORM. 
>>>
>>>
>>> If you want to check device features, you need to do that during 
>>> probe() and fail the probing if without the feature. But I think you 
>>> won't ship cards without ACCESS_PLATFORM.
>> Yes, there are no reasons ship a card without ACCESS_PLATFORM
>>>
>>>
>>>> In get_features(),
>>>> it will return a intersection of device features bit and driver 
>>>> supported features bits(which includes ACCESS_PLATFORM).
>>>> Other components like QEMU should not set features bits more than 
>>>> this intersection of bits. so we can make sure if this
>>>> ifcvf_verify_min_features() passed, both device and driver support 
>>>> ACCESS_PLATFORM.
>>>>
>>>> Are you suggesting check driver feature bits in 
>>>> ifcvf_verify_min_features() in the meantime as well?
>>>
>>>
>>> So it really depends on your hardware. If you hardware can always 
>>> offer ACCESS_PLATFORM, you just need to check driver features. This 
>>> is how vdpa_sim and mlx5_vdpa work.
>> Yes, we always support ACCESS_PLATFORM, so it is hard coded in the 
>> macro IFCVF_SUPPORTED_FEATURES.
>
>
> That's not what I read from the code:
>
>         features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
ifcvf_get_features() reads device feature bits(which should always has 
ACCSSS_PLATFORM) and IFCVF_SUPPORTED_FEATURES is the driver supported 
feature bits which hard coded ACCESS_PLATFORM, so the intersection 
should include ACCESS_PLATFORM.
the intersection "features" is returned in get_features(), qemu should 
set features according to it.
>
>
>> Now we check whether device support this feature bit as a double 
>> conformation, are you suggesting we should check whether 
>> ACCESS_PLATFORM & IFCVF_SUPPORTED_FEATURES
>> in set_features() as well?
>
>
> If we know device will always offer ACCESS_PLATFORM, there's no need 
> to check it again. What we should check if whether driver set that, 
> and if it doesn't we need to fail set_features(). I think there's 
> little chance that IFCVF can work when IOMMU_PLATFORM is not negotiated.
Agree, will check the features bit to set instead of device feature 
bits. Thanks!
>
>
>
>> I prefer check both device and IFCVF_SUPPORTED_FEATURES both, more 
>> reliable.
>
>
> So again, if you want to check device features, set_features() is not 
> the proper place. We need to fail the probe in this case.
>
> Thanks
>
>
>>
>> Thanks!
>>>
>>> Thanks
>>>
>>>
>>>>
>>>> Thanks！
>>>>>
>>>>>
>>>>>> +    if (ret)
>>>>>> +        return ret;
>>>>>>         vf->req_features = features;
>>>>>
>>>>> _______________________________________________
>>>>> Virtualization mailing list
>>>>> Virtualization@lists.linux-foundation.org
>>>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>>>>
>>>
>>
>

