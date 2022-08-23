Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703C059D17F
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 08:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240619AbiHWGwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 02:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239988AbiHWGwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 02:52:30 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ECD3CBC8;
        Mon, 22 Aug 2022 23:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661237549; x=1692773549;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=teYM1P+/2c/MjzYkIezmPusJTcjbZ+PMcUqRsOswTXs=;
  b=cc7/oInv0oIc3qMUNfmXN9dd0/q9E1yiE0nHaXW8xI2atRvWmih0f/+f
   LaYfQvvIzFX2C+MhTQDUfYePTuCyE0qdhLQpESjW1sbEfGeZlg+MeC2SE
   hy+Nw3SNRpc0SNj5euZoJZ5INRyNBHFdVi3MpZ0xDtOxrOmo7HIdO9mGI
   hnYF3OMb0sUJgmgDyAuqXAWJjpWwwiHiyoWA6Tv9pyRKDxEOkL+QsnLjN
   wFErZwvhe0lNoKZ82vKvnnJ5YMdQK6s/zY46Yo71c58Y9582UF+Z+dpOP
   p9zOaNVNjUK/bPB7GoWtu+ZhBauMji8jYENg8T2XEbYP7fqq5/ajfjrVq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="292349227"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="292349227"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 23:52:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="585853174"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.174.222]) ([10.249.174.222])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 23:52:25 -0700
Message-ID: <0b02a7a6-8845-a22c-04c3-076887675980@intel.com>
Date:   Tue, 23 Aug 2022 14:52:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.1.2
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
 <e06d1f6d-3199-1b75-d369-2e5d69040271@intel.com>
 <CACGkMEv24Rn9+bJ5mma1ciJNwa7wvRCwJ6jF+CBMbz6DtV8MvA@mail.gmail.com>
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEv24Rn9+bJ5mma1ciJNwa7wvRCwJ6jF+CBMbz6DtV8MvA@mail.gmail.com>
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



On 8/23/2022 11:26 AM, Jason Wang wrote:
> On Mon, Aug 22, 2022 at 1:08 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 8/20/2022 4:55 PM, Si-Wei Liu wrote:
>>>
>>> On 8/18/2022 5:42 PM, Jason Wang wrote:
>>>> On Fri, Aug 19, 2022 at 7:20 AM Si-Wei Liu <si-wei.liu@oracle.com>
>>>> wrote:
>>>>>
>>>>> On 8/17/2022 9:15 PM, Jason Wang wrote:
>>>>>> 在 2022/8/17 18:37, Michael S. Tsirkin 写道:
>>>>>>> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
>>>>>>>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
>>>>>>>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
>>>>>>>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
>>>>>>>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>>>>>>>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1
>>>>>>>>>>>> because of
>>>>>>>>>>>> transitional devices, so maybe this is the best we can do for
>>>>>>>>>>>> now
>>>>>>>>>>> I think vhost generally needs an API to declare config space
>>>>>>>>>>> endian-ness
>>>>>>>>>>> to kernel. vdpa can reuse that too then.
>>>>>>>>>> Yes, I remember you have mentioned some IOCTL to set the
>>>>>>>>>> endian-ness,
>>>>>>>>>> for vDPA, I think only the vendor driver knows the endian,
>>>>>>>>>> so we may need a new function vdpa_ops->get_endian().
>>>>>>>>>> In the last thread, we say maybe it's better to add a comment for
>>>>>>>>>> now.
>>>>>>>>>> But if you think we should add a vdpa_ops->get_endian(), I can
>>>>>>>>>> work
>>>>>>>>>> on it for sure!
>>>>>>>>>>
>>>>>>>>>> Thanks
>>>>>>>>>> Zhu Lingshan
>>>>>>>>> I think QEMU has to set endian-ness. No one else knows.
>>>>>>>> Yes, for SW based vhost it is true. But for HW vDPA, only
>>>>>>>> the device & driver knows the endian, I think we can not
>>>>>>>> "set" a hardware's endian.
>>>>>>> QEMU knows the guest endian-ness and it knows that
>>>>>>> device is accessed through the legacy interface.
>>>>>>> It can accordingly send endian-ness to the kernel and
>>>>>>> kernel can propagate it to the driver.
>>>>>> I wonder if we can simply force LE and then Qemu can do the endian
>>>>>> conversion?
>>>>> convert from LE for config space fields only, or QEMU has to forcefully
>>>>> mediate and covert endianness for all device memory access including
>>>>> even the datapath (fields in descriptor and avail/used rings)?
>>>> Former. Actually, I want to force modern devices for vDPA when
>>>> developing the vDPA framework. But then we see requirements for
>>>> transitional or even legacy (e.g the Ali ENI parent). So it
>>>> complicates things a lot.
>>>>
>>>> I think several ideas has been proposed:
>>>>
>>>> 1) Your proposal of having a vDPA specific way for
>>>> modern/transitional/legacy awareness. This seems very clean since each
>>>> transport should have the ability to do that but it still requires
>>>> some kind of mediation for the case e.g running BE legacy guest on LE
>>>> host.
>>> In theory it seems like so, though practically I wonder if we can just
>>> forbid BE legacy driver from running on modern LE host. For those who
>>> care about legacy BE guest, they mostly like could and should talk to
>>> vendor to get native BE support to achieve hardware acceleration,
> The problem is the hardware still needs a way to know the endian of the guest?
>
>>> few
>>> of them would count on QEMU in mediating or emulating the datapath
>>> (otherwise I don't see the benefit of adopting vDPA?). I still feel
>>> that not every hardware vendor has to offer backward compatibility
>>> (transitional device) with legacy interface/behavior (BE being just
>>> one),
> Probably, I agree it is a corner case, and dealing with transitional
> device for the following setups is very challenge for hardware:
>
> - driver without IOMMU_PLATFORM support, (requiring device to send
> translated request which have security implications)
> - BE legacy guest on LE host, (requiring device to have a way to know
> the endian)
> - device specific requirement (e.g modern virtio-net mandate minimal
> header length to contain mrg_rxbuf even if the device doesn't offer
> it)
>
> It is not obvious for the hardware vendor, so we may end up defecting
> in the implementation. Dealing with compatibility for the transitional
> devices is kind of a nightmare which there's no way for the spec to
> rule the behavior of legacy devices.
>
>>>   this is unlike the situation on software virtio device, which
>>> has legacy support since day one. I think we ever discussed it before:
>>> for those vDPA vendors who don't offer legacy guest support, maybe we
>>> should mandate some feature for e.g. VERSION_1, as these devices
>>> really don't offer functionality of the opposite side (!VERSION_1)
>>> during negotiation.
> I've tried something similar here (a global mandatory instead of per device).
>
> https://lkml.org/lkml/2021/6/4/26
I think this is the best option
>
> But for some reason, it is not applied by Michael. It would be a great
> relief if we support modern devices only. Maybe it's time to revisit
> this idea then we can introduce new backend features and then we can
> mandate VERSION_1
>
>>> Having it said, perhaps we should also allow vendor device to
>>> implement only partial support for legacy. We can define "reversed"
>>> backend feature to denote some part of the legacy
>>> interface/functionality not getting implemented by device. For
>>> instance, VHOST_BACKEND_F_NO_BE_VRING, VHOST_BACKEND_F_NO_BE_CONFIG,
>>> VHOST_BACKEND_F_NO_ALIGNED_VRING,
>>> VHOST_BACKEND_NET_F_NO_WRITEABLE_MAC, and et al. Not all of these
>>> missing features for legacy would be easy for QEMU to make up for, so
>>> QEMU can selectively emulate those at its best when necessary and
>>> applicable. In other word, this design shouldn't prevent QEMU from
>>> making up for vendor device's partial legacy support.
> This looks too heavyweight since it tries to provide compatibility for
> legacy drivers. Considering we've introduced modern devices for 5+
> years, I'd rather:
>
> - Qemu to mediate the config space stuffs
So that's what I have suggested, new ops to support VHOST_SET_VRING_ENDIAN,
then after QEMU issue this IOCTL, no matter success or fail, QEMU will
know the endian. Then QEMU can mediate the config space.

And these ops(get/get_endian) can help us mediate config space fields in
net_config_fill()
> - Shadow virtqueue to mediate the datapath (AF_XDP told us shadow ring
> can perform very well if we do zero-copy).
>
>>>> 2) Michael suggests using VHOST_SET_VRING_ENDIAN where it means we
>>>> need a new config ops for vDPA bus, but it doesn't solve the issue for
>>>> config space (at least from its name). We probably need a new ioctl
>>>> for both vring and config space.
>>> Yep adding a new ioctl makes things better, but I think the key is not
>>> the new ioctl. It's whether or not we should enforce every vDPA vendor
>>> driver to implement all transitional interfaces to be spec compliant.
> I think the answer is no since the spec allows transitional device.
> And we know things will be greatly simplified if vDPA support non
> transitional device only.
>
> So we can change the question to:
>
> 1) do we need (or is it too late) to enforce non transitional device?
> 2) if yes, can transitional device be mediate in an efficient way?
>
> For 1), it's probably too late but we can invent new vDPA features as
> you suggest to be non transitional. Then we can:
>
> 1.1) extend the netlink API to provision non-transitonal device
> 1.2) work on the non-transtional device in the future
> 1.3) presenting transitional device via mediation
>
> The previous transitional vDPA work as is, it's probably too late to
> fix all the issue we suffer.
>
> For 2), the key part is the datapath mediation, we can use shadow virtqueue.
>
>>> If we allow them to reject the VHOST_SET_VRING_ENDIAN  or
>>> VHOST_SET_CONFIG_ENDIAN call, what could we do? We would still end up
>>> with same situation of either fail the guest, or trying to
>>> mediate/emulate, right?
>>>
>>> Not to mention VHOST_SET_VRING_ENDIAN is rarely supported by vhost
>>> today - few distro kernel has CONFIG_VHOST_CROSS_ENDIAN_LEGACY enabled
>>> and QEMU just ignores the result. vhost doesn't necessarily depend on
>>> it to determine endianness it looks.
>> I would like to suggest to add two new config ops get/set_vq_endian()
>> and get/set_config_endian() for vDPA. This is used to:
>> a) support VHOST_GET/SET_VRING_ENDIAN as MST suggested, and add
>> VHOST_SET/GET_CONFIG_ENDIAN for vhost_vdpa.
>> If the device has not implemented interface to set its endianess, then
>> no matter success or failure of SET_ENDIAN, QEMU knows the endian-ness
>> anyway.
> How can Qemu know the endian in this way? And if it can, there's no
> need for the new API?
If we have VHOST_SET_VRING_ENDIAN support for vDPA, then when QEMU sets
the endian of a vDPA device through VHOST_SET_VRING_ENDIAN, no matter
this ioctl success or fail, QEMU knows the endian of the device.
E.g., if QEMU sets BE, but failed, then QEMU knows the device is LE only.
>
>> In this case, if the device endianess does not match the guest,
>> there needs a mediation layer or fail.
>> b) ops->get_config_endian() can always tell the endian-ness of the
>> device config space after the vendor driver probing the device. So we
>> can use this ops->get_config_endian() for
>> MTU, MAC and other fields handling in vdpa_dev_net_config_fill() and we
>> don't need to set_features in vdpa_get_config_unlocked(), so no race
>> conditions.
>> Every time ops->get_config() returned, we can tell the endian by
>> ops-config_>get_endian(), we don't need set_features(xxx, 0) if features
>> negotiation not done.
>>
>> The question is: Do we need two pairs of ioctls for both vq and config
>> space? Can config space endian-ness differ from the vqs?
>> c) do we need a new netlink attr telling the endian-ness to user space?
> Generally, I'm not sure this is a good design consider it provides neither:
>
> Compatibility with the virtio spec
I think this is not about the spec, we implement a new pair of ops to 
set/get_endian(),
then we can handle the device config space fields properly, at least to 
vdpa_dev_net_config_fill().

E.g, we can use __virtio16_to_cpu(vdpa->get_endian(), xxx);

And this can support VHOST_SET_VRING_ENDIAN.
>
> nor
>
> Compatibility with the existing vhost API (VHOST_SET_VRING_ENDIAN)
that's true, but if the endian does not match the guest endian, it can not
work without a mediation layer anyway.

Thanks
Zhu Lingshan
>
> Thanks
>
>> Thanks,
>> Zhu Lingshan
>>>> or
>>>>
>>>> 3) revisit the idea of forcing modern only device which may simplify
>>>> things a lot
>>> I am not actually against forcing modern only config space, given that
>>> it's not hard for either QEMU or individual driver to mediate or
>>> emulate, and for the most part it's not conflict with the goal of
>>> offload or acceleration with vDPA. But forcing LE ring layout IMO
>>> would just kill off the potential of a very good use case. Currently
>>> for our use case the priority for supporting 0.9.5 guest with vDPA is
>>> slightly lower compared to live migration, but it is still in our TODO
>>> list.
>>>
>>> Thanks,
>>> -Siwei
>>>
>>>> which way should we go?
>>>>
>>>>> I hope
>>>>> it's not the latter, otherwise it loses the point to use vDPA for
>>>>> datapath acceleration.
>>>>>
>>>>> Even if its the former, it's a little weird for vendor device to
>>>>> implement a LE config space with BE ring layout, although still
>>>>> possible...
>>>> Right.
>>>>
>>>> Thanks
>>>>
>>>>> -Siwei
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>>> So if you think we should add a vdpa_ops->get_endian(),
>>>>>>>> I will drop these comments in the next version of
>>>>>>>> series, and work on a new patch for get_endian().
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Zhu Lingshan
>>>>>>> Guests don't get endian-ness from devices so this seems pointless.
>>>>>>>

