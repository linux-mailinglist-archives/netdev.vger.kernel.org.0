Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD2159B8A2
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 07:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbiHVFIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 01:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiHVFIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 01:08:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758F01262A;
        Sun, 21 Aug 2022 22:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661144889; x=1692680889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aJuO00bHFTFMl8KnIYlHE0QVGOXlS9O7zR3snvIDSO8=;
  b=Q3hBSgW5nyzQ2ZXzuwqoiCA2IVsRLCWRlPftWDV9LX3Z6YM+mSlzfz+z
   YF7wTEG9H0AH/UDpOad4gLnZcgUaMKhR/7xX62Ld6AROsHoNNPZ8flQ3I
   8j07PjUJSRNvxL9Fqsr1MzfLg9f8DRRrFfHYGOZB7p0ul3OwvW5n5Nq+y
   wkl0j2yyeVkoGRDgfv9nCnvktW6IusiaYhlqOFk9oCNZHjT2QMvNl2Prk
   YvcDqcfQYwA9o/sGYZmkfT8To8sctcPajW/uxvFya9WSsj/Yz1F4fRHu4
   LAt9XxjNIlx2knSKZURQYnOpOa+jt65IeBzNslvK1rnDwF6HjAdJL4iQq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="292063544"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="292063544"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 22:08:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="585360860"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.28.92]) ([10.255.28.92])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 22:07:57 -0700
Message-ID: <e06d1f6d-3199-1b75-d369-2e5d69040271@intel.com>
Date:   Mon, 22 Aug 2022 13:07:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.1.2
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
References: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
 <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
 <20220817063450-mutt-send-email-mst@kernel.org>
 <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
 <f0b6ea5c-1783-96d2-2d9f-e5cf726b0fc0@oracle.com>
 <CACGkMEumKfktMUJOTUYL_JYkFbw8qH331gGARPB2bTH=7wKWPg@mail.gmail.com>
 <4678fc51-a402-d3ea-e875-6eba175933ba@oracle.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <4678fc51-a402-d3ea-e875-6eba175933ba@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/2022 4:55 PM, Si-Wei Liu wrote:
>
>
> On 8/18/2022 5:42 PM, Jason Wang wrote:
>> On Fri, Aug 19, 2022 at 7:20 AM Si-Wei Liu <si-wei.liu@oracle.com> 
>> wrote:
>>>
>>>
>>> On 8/17/2022 9:15 PM, Jason Wang wrote:
>>>> 在 2022/8/17 18:37, Michael S. Tsirkin 写道:
>>>>> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
>>>>>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
>>>>>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
>>>>>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
>>>>>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>>>>>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1
>>>>>>>>>> because of
>>>>>>>>>> transitional devices, so maybe this is the best we can do for 
>>>>>>>>>> now
>>>>>>>>> I think vhost generally needs an API to declare config space
>>>>>>>>> endian-ness
>>>>>>>>> to kernel. vdpa can reuse that too then.
>>>>>>>> Yes, I remember you have mentioned some IOCTL to set the 
>>>>>>>> endian-ness,
>>>>>>>> for vDPA, I think only the vendor driver knows the endian,
>>>>>>>> so we may need a new function vdpa_ops->get_endian().
>>>>>>>> In the last thread, we say maybe it's better to add a comment for
>>>>>>>> now.
>>>>>>>> But if you think we should add a vdpa_ops->get_endian(), I can 
>>>>>>>> work
>>>>>>>> on it for sure!
>>>>>>>>
>>>>>>>> Thanks
>>>>>>>> Zhu Lingshan
>>>>>>> I think QEMU has to set endian-ness. No one else knows.
>>>>>> Yes, for SW based vhost it is true. But for HW vDPA, only
>>>>>> the device & driver knows the endian, I think we can not
>>>>>> "set" a hardware's endian.
>>>>> QEMU knows the guest endian-ness and it knows that
>>>>> device is accessed through the legacy interface.
>>>>> It can accordingly send endian-ness to the kernel and
>>>>> kernel can propagate it to the driver.
>>>>
>>>> I wonder if we can simply force LE and then Qemu can do the endian
>>>> conversion?
>>> convert from LE for config space fields only, or QEMU has to forcefully
>>> mediate and covert endianness for all device memory access including
>>> even the datapath (fields in descriptor and avail/used rings)?
>> Former. Actually, I want to force modern devices for vDPA when
>> developing the vDPA framework. But then we see requirements for
>> transitional or even legacy (e.g the Ali ENI parent). So it
>> complicates things a lot.
>>
>> I think several ideas has been proposed:
>>
>> 1) Your proposal of having a vDPA specific way for
>> modern/transitional/legacy awareness. This seems very clean since each
>> transport should have the ability to do that but it still requires
>> some kind of mediation for the case e.g running BE legacy guest on LE
>> host.
> In theory it seems like so, though practically I wonder if we can just 
> forbid BE legacy driver from running on modern LE host. For those who 
> care about legacy BE guest, they mostly like could and should talk to 
> vendor to get native BE support to achieve hardware acceleration, few 
> of them would count on QEMU in mediating or emulating the datapath 
> (otherwise I don't see the benefit of adopting vDPA?). I still feel 
> that not every hardware vendor has to offer backward compatibility 
> (transitional device) with legacy interface/behavior (BE being just 
> one), this is unlike the situation on software virtio device, which 
> has legacy support since day one. I think we ever discussed it before: 
> for those vDPA vendors who don't offer legacy guest support, maybe we 
> should mandate some feature for e.g. VERSION_1, as these devices 
> really don't offer functionality of the opposite side (!VERSION_1) 
> during negotiation.
>
> Having it said, perhaps we should also allow vendor device to 
> implement only partial support for legacy. We can define "reversed" 
> backend feature to denote some part of the legacy 
> interface/functionality not getting implemented by device. For 
> instance, VHOST_BACKEND_F_NO_BE_VRING, VHOST_BACKEND_F_NO_BE_CONFIG, 
> VHOST_BACKEND_F_NO_ALIGNED_VRING, 
> VHOST_BACKEND_NET_F_NO_WRITEABLE_MAC, and et al. Not all of these 
> missing features for legacy would be easy for QEMU to make up for, so 
> QEMU can selectively emulate those at its best when necessary and 
> applicable. In other word, this design shouldn't prevent QEMU from 
> making up for vendor device's partial legacy support.
>
>>
>> 2) Michael suggests using VHOST_SET_VRING_ENDIAN where it means we
>> need a new config ops for vDPA bus, but it doesn't solve the issue for
>> config space (at least from its name). We probably need a new ioctl
>> for both vring and config space.
> Yep adding a new ioctl makes things better, but I think the key is not 
> the new ioctl. It's whether or not we should enforce every vDPA vendor 
> driver to implement all transitional interfaces to be spec compliant. 
> If we allow them to reject the VHOST_SET_VRING_ENDIAN  or 
> VHOST_SET_CONFIG_ENDIAN call, what could we do? We would still end up 
> with same situation of either fail the guest, or trying to 
> mediate/emulate, right?
>
> Not to mention VHOST_SET_VRING_ENDIAN is rarely supported by vhost 
> today - few distro kernel has CONFIG_VHOST_CROSS_ENDIAN_LEGACY enabled 
> and QEMU just ignores the result. vhost doesn't necessarily depend on 
> it to determine endianness it looks.
I would like to suggest to add two new config ops get/set_vq_endian() 
and get/set_config_endian() for vDPA. This is used to:
a) support VHOST_GET/SET_VRING_ENDIAN as MST suggested, and add 
VHOST_SET/GET_CONFIG_ENDIAN for vhost_vdpa.
If the device has not implemented interface to set its endianess, then 
no matter success or failure of SET_ENDIAN, QEMU knows the endian-ness 
anyway. In this case, if the device endianess does not match the guest, 
there needs a mediation layer or fail.
b) ops->get_config_endian() can always tell the endian-ness of the 
device config space after the vendor driver probing the device. So we 
can use this ops->get_config_endian() for
MTU, MAC and other fields handling in vdpa_dev_net_config_fill() and we 
don't need to set_features in vdpa_get_config_unlocked(), so no race 
conditions.
Every time ops->get_config() returned, we can tell the endian by 
ops-config_>get_endian(), we don't need set_features(xxx, 0) if features 
negotiation not done.

The question is: Do we need two pairs of ioctls for both vq and config 
space? Can config space endian-ness differ from the vqs?
c) do we need a new netlink attr telling the endian-ness to user space?

Thanks,
Zhu Lingshan
>
>>
>> or
>>
>> 3) revisit the idea of forcing modern only device which may simplify
>> things a lot
> I am not actually against forcing modern only config space, given that 
> it's not hard for either QEMU or individual driver to mediate or 
> emulate, and for the most part it's not conflict with the goal of 
> offload or acceleration with vDPA. But forcing LE ring layout IMO 
> would just kill off the potential of a very good use case. Currently 
> for our use case the priority for supporting 0.9.5 guest with vDPA is 
> slightly lower compared to live migration, but it is still in our TODO 
> list.
>
> Thanks,
> -Siwei
>
>>
>> which way should we go?
>>
>>> I hope
>>> it's not the latter, otherwise it loses the point to use vDPA for
>>> datapath acceleration.
>>>
>>> Even if its the former, it's a little weird for vendor device to
>>> implement a LE config space with BE ring layout, although still 
>>> possible...
>> Right.
>>
>> Thanks
>>
>>> -Siwei
>>>> Thanks
>>>>
>>>>
>>>>>> So if you think we should add a vdpa_ops->get_endian(),
>>>>>> I will drop these comments in the next version of
>>>>>> series, and work on a new patch for get_endian().
>>>>>>
>>>>>> Thanks,
>>>>>> Zhu Lingshan
>>>>> Guests don't get endian-ness from devices so this seems pointless.
>>>>>
>

