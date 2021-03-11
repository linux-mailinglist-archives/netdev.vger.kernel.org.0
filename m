Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F7C336C01
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCKGVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:21:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230112AbhCKGU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:20:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615443659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pjTxE9BR2uNybLgUHvNoBdUWBPK4sh7rwx5cjZJ/jb8=;
        b=dYb7+kl/y1r3fFIGFjirFw9eKU0YygYgRM9fDQ0fENCcD3kCVNyB/l9lrx44zE7/b9ukLn
        s6ce0Dj/mzWuCRZISesyndrTGKPJ41zEeQsxhFZcgI4nA7zQQcZwSq7vjAra+SAPwHxWEA
        A5JMa4ja6bTwu4mAmJm/Y2wsS70VdOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-ul4rT5NMNz6JRQwGn0PCcw-1; Thu, 11 Mar 2021 01:20:55 -0500
X-MC-Unique: ul4rT5NMNz6JRQwGn0PCcw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C011A1005D45;
        Thu, 11 Mar 2021 06:20:53 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A94B5D746;
        Thu, 11 Mar 2021 06:20:47 +0000 (UTC)
Subject: Re: [PATCH V3 6/6] vDPA/ifcvf: verify mandatory feature bits for vDPA
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-7-lingshan.zhu@intel.com>
 <3e53a5c9-c531-48ee-c9a7-907dfdacc9d1@redhat.com>
 <9c2fb3d0-2d69-20b9-589d-cc5ffc830f38@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4f3ef2bb-d823-d53d-3bb0-0152a3f6c9f1@redhat.com>
Date:   Thu, 11 Mar 2021 14:20:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <9c2fb3d0-2d69-20b9-589d-cc5ffc830f38@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/11 12:16 下午, Zhu Lingshan wrote:
>
>
> On 3/11/2021 11:20 AM, Jason Wang wrote:
>>
>> On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
>>> vDPA requres VIRTIO_F_ACCESS_PLATFORM as a must, this commit
>>> examines this when set features.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_base.c | 8 ++++++++
>>>   drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
>>>   3 files changed, 14 insertions(+)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_base.c
>>> index ea6a78791c9b..58f47fdce385 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>>> @@ -224,6 +224,14 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
>>>       return hw->hw_features;
>>>   }
>>>   +int ifcvf_verify_min_features(struct ifcvf_hw *hw)
>>> +{
>>> +    if (!(hw->hw_features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>>> +        return -EINVAL;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>   void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
>>>                  void *dst, int length)
>>>   {
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> index dbb8c10aa3b1..91c5735d4dc9 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> @@ -123,6 +123,7 @@ void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
>>>   void ifcvf_reset(struct ifcvf_hw *hw);
>>>   u64 ifcvf_get_features(struct ifcvf_hw *hw);
>>>   u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>>> +int ifcvf_verify_min_features(struct ifcvf_hw *hw);
>>>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>>>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>>>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index 25fb9dfe23f0..f624f202447d 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -179,6 +179,11 @@ static u64 ifcvf_vdpa_get_features(struct 
>>> vdpa_device *vdpa_dev)
>>>   static int ifcvf_vdpa_set_features(struct vdpa_device *vdpa_dev, 
>>> u64 features)
>>>   {
>>>       struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>> +    int ret;
>>> +
>>> +    ret = ifcvf_verify_min_features(vf);
>>
>>
>> So this validate device features instead of driver which is the one 
>> we really want to check?
>>
>> Thanks
>
> Hi Jason,
>
> Here we check device feature bits to make sure the device support 
> ACCESS_PLATFORM. 


If you want to check device features, you need to do that during probe() 
and fail the probing if without the feature. But I think you won't ship 
cards without ACCESS_PLATFORM.


> In get_features(),
> it will return a intersection of device features bit and driver 
> supported features bits(which includes ACCESS_PLATFORM).
> Other components like QEMU should not set features bits more than this 
> intersection of bits. so we can make sure if this
> ifcvf_verify_min_features() passed, both device and driver support 
> ACCESS_PLATFORM.
>
> Are you suggesting check driver feature bits in 
> ifcvf_verify_min_features() in the meantime as well?


So it really depends on your hardware. If you hardware can always offer 
ACCESS_PLATFORM, you just need to check driver features. This is how 
vdpa_sim and mlx5_vdpa work.

Thanks


>
> Thanks！
>>
>>
>>> +    if (ret)
>>> +        return ret;
>>>         vf->req_features = features;
>>
>> _______________________________________________
>> Virtualization mailing list
>> Virtualization@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

