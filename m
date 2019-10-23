Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F3EE17F9
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404471AbfJWKaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:30:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28626 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391076AbfJWKaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571826611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x3lZ3Bo1e/mYDo8MUIcOkY/ZXzHg1U9rdfroL4Ixwe4=;
        b=FyrWT8NCa0xopvA4KT4UBCNKppU+a39BS6N/to7bAvKiETMRRtEaimYHkh90bZ7wJSBsRD
        Geu8IkQ05rwBIKb73oiaMjeR3HiM5UDTy9c2TqbXWaN4ACk/wGsUhx+uoUTGBcKovqv3sh
        1lB4t/6NQCehdbecznIZaHs5RHmIZXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-AhIKu5Q-Pu65-8OG6n8GXA-1; Wed, 23 Oct 2019 06:30:07 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BA02107AD31;
        Wed, 23 Oct 2019 10:30:06 +0000 (UTC)
Received: from [10.72.12.79] (ovpn-12-79.pek2.redhat.com [10.72.12.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D01351763;
        Wed, 23 Oct 2019 10:29:33 +0000 (UTC)
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <20191022095230.2514-1-tiwei.bie@intel.com>
 <47a572fd-5597-1972-e177-8ee25ca51247@redhat.com>
 <20191023030253.GA15401@___>
 <ac36f1e3-b972-71ac-fe0c-3db03e016dcf@redhat.com>
 <20191023070747.GA30533@___>
 <106834b5-dae5-82b2-0f97-16951709d075@redhat.com> <20191023101135.GA6367@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
Date:   Wed, 23 Oct 2019 18:29:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191023101135.GA6367@___>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: AhIKu5Q-Pu65-8OG6n8GXA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/23 =E4=B8=8B=E5=8D=886:11, Tiwei Bie wrote:
> On Wed, Oct 23, 2019 at 03:25:00PM +0800, Jason Wang wrote:
>> On 2019/10/23 =E4=B8=8B=E5=8D=883:07, Tiwei Bie wrote:
>>> On Wed, Oct 23, 2019 at 01:46:23PM +0800, Jason Wang wrote:
>>>> On 2019/10/23 =E4=B8=8A=E5=8D=8811:02, Tiwei Bie wrote:
>>>>> On Tue, Oct 22, 2019 at 09:30:16PM +0800, Jason Wang wrote:
>>>>>> On 2019/10/22 =E4=B8=8B=E5=8D=885:52, Tiwei Bie wrote:
>>>>>>> This patch introduces a mdev based hardware vhost backend.
>>>>>>> This backend is built on top of the same abstraction used
>>>>>>> in virtio-mdev and provides a generic vhost interface for
>>>>>>> userspace to accelerate the virtio devices in guest.
>>>>>>>
>>>>>>> This backend is implemented as a mdev device driver on top
>>>>>>> of the same mdev device ops used in virtio-mdev but using
>>>>>>> a different mdev class id, and it will register the device
>>>>>>> as a VFIO device for userspace to use. Userspace can setup
>>>>>>> the IOMMU with the existing VFIO container/group APIs and
>>>>>>> then get the device fd with the device name. After getting
>>>>>>> the device fd of this device, userspace can use vhost ioctls
>>>>>>> to setup the backend.
>>>>>>>
>>>>>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>>>>>>> ---
>>>>>>> This patch depends on below series:
>>>>>>> https://lkml.org/lkml/2019/10/17/286
>>>>>>>
>>>>>>> v1 -> v2:
>>>>>>> - Replace _SET_STATE with _SET_STATUS (MST);
>>>>>>> - Check status bits at each step (MST);
>>>>>>> - Report the max ring size and max number of queues (MST);
>>>>>>> - Add missing MODULE_DEVICE_TABLE (Jason);
>>>>>>> - Only support the network backend w/o multiqueue for now;
>>>>>> Any idea on how to extend it to support devices other than net? I th=
ink we
>>>>>> want a generic API or an API that could be made generic in the futur=
e.
>>>>>>
>>>>>> Do we want to e.g having a generic vhost mdev for all kinds of devic=
es or
>>>>>> introducing e.g vhost-net-mdev and vhost-scsi-mdev?
>>>>> One possible way is to do what vhost-user does. I.e. Apart from
>>>>> the generic ring, features, ... related ioctls, we also introduce
>>>>> device specific ioctls when we need them. As vhost-mdev just needs
>>>>> to forward configs between parent and userspace and even won't
>>>>> cache any info when possible,
>>>> So it looks to me this is only possible if we expose e.g set_config an=
d
>>>> get_config to userspace.
>>> The set_config and get_config interface isn't really everything
>>> of device specific settings. We also have ctrlq in virtio-net.
>>
>> Yes, but it could be processed by the exist API. Isn't it? Just set ctrl=
 vq
>> address and let parent to deal with that.
> I mean how to expose ctrlq related settings to userspace?


I think it works like:

1) userspace find ctrl_vq is supported

2) then it can allocate memory for ctrl vq and set its address through=20
vhost-mdev

3) userspace can populate ctrl vq itself


>
>>
>>>>> I think it might be better to do
>>>>> this in one generic vhost-mdev module.
>>>> Looking at definitions of VhostUserRequest in qemu, it mixed generic A=
PI
>>>> with device specific API. If we want go this ways (a generic vhost-mde=
v),
>>>> more questions needs to be answered:
>>>>
>>>> 1) How could userspace know which type of vhost it would use? Do we ne=
ed to
>>>> expose virtio subsystem device in for userspace this case?
>>>>
>>>> 2) That generic vhost-mdev module still need to filter out unsupported
>>>> ioctls for a specific type. E.g if it probes a net device, it should r=
efuse
>>>> API for other type. This in fact a vhost-mdev-net but just not modular=
ize it
>>>> on top of vhost-mdev.
>>>>
>>>>
>>>>>>> - Some minor fixes and improvements;
>>>>>>> - Rebase on top of virtio-mdev series v4;
>>> [...]
>>>>>>> +
>>>>>>> +static long vhost_mdev_get_features(struct vhost_mdev *m, u64 __us=
er *featurep)
>>>>>>> +{
>>>>>>> +=09if (copy_to_user(featurep, &m->features, sizeof(m->features)))
>>>>>>> +=09=09return -EFAULT;
>>>>>> As discussed in previous version do we need to filter out MQ feature=
 here?
>>>>> I think it's more straightforward to let the parent drivers to
>>>>> filter out the unsupported features. Otherwise it would be tricky
>>>>> when we want to add more features in vhost-mdev module,
>>>> It's as simple as remove the feature from blacklist?
>>> It's not really that easy. It may break the old drivers.
>>
>> I'm not sure I understand here, we do feature negotiation anyhow. For ol=
d
>> drivers do you mean the guest drivers without MQ?
> For old drivers I mean old parent drivers. It's possible
> to compile old drivers on new kernels.


Yes, but if old parent driver itself can not support MQ it should just=20
not advertise that feature.


>
> I'm not quite sure how will we implement MQ support in
> vhost-mdev.


Yes, that's why I ask here. I think we want the vhost-mdev to be generic=20
which means it's better not let vhost-mdev to know anything which is=20
device specific. So this is a question that should be considered.


> If we need to introduce new virtio_mdev_device_ops
> callbacks and an old driver exposed the MQ feature,
> then the new vhost-mdev will see this old driver expose
> MQ feature but not provide corresponding callbacks.ean


That's exact the issue which current API can not handle, so that's why I=20
suggest to filter MQ out for vhost-mdev.

And in the future, we can:

1) invent new ioctls and convert them to config access or

2) just exposing config for userspace to access (then vhost-mdev work=20
much more similar to virtio-mdev).


>
>>
>>>>> i.e. if
>>>>> the parent drivers may expose unsupported features and relay on
>>>>> vhost-mdev to filter them out, these features will be exposed
>>>>> to userspace automatically when they are enabled in vhost-mdev
>>>>> in the future.
>>>> The issue is, it's only that vhost-mdev knows its own limitation. E.g =
in
>>>> this patch, vhost-mdev only implements a subset of transport API, but =
parent
>>>> doesn't know about that.
>>>>
>>>> Still MQ as an example, there's no way (or no need) for parent to know=
 that
>>>> vhost-mdev does not support MQ.
>>> The mdev is a MDEV_CLASS_ID_VHOST mdev device. When the parent
>>> is being developed, it should know the currently supported features
>>> of vhost-mdev.
>>
>> How can parent know MQ is not supported by vhost-mdev?
> Good point. I agree vhost-mdev should filter out the unsupported
> features. But in the meantime, I think drivers also shouldn't
> expose unsupported features.


Exactly. But there's a case in the middle, e.g parent drivers support MQ=20
and virtio-mdev can do that but not vhost-mdev.


>
>>
>>>> And this allows old kenrel to work with new
>>>> parent drivers.
>>> The new drivers should provide things like VIRTIO_MDEV_F_VERSION_1
>>> to be compatible with the old kernels. When VIRTIO_MDEV_F_VERSION_1
>>> is provided/negotiated, the behaviours should be consistent.
>>
>> To be clear, I didn't mean a change in virtio-mdev API, I meant:
>>
>> 1) old vhost-mdev kernel driver that filters out MQ
>>
>> 2) new parent driver that support MQ
>>
>>
>>>> So basically we have three choices here:
>>>>
>>>> 1) Implement what vhost-user did and implement a generic vhost-mdev (b=
ut may
>>>> still have lots of device specific code). To support advanced feature =
which
>>>> requires the access to config, still lots of API that needs to be adde=
d.
>>>>
>>>> 2) Implement what vhost-kernel did, have a generic vhost-mdev driver a=
nd a
>>>> vhost bus on top for match a device specific API e.g vhost-mdev-net. W=
e
>>>> still have device specific API but limit them only to device specific
>>>> module. Still require new ioctls for advanced feature like MQ.
>>>>
>>>> 3) Simply expose all virtio-mdev transport to userspace.
>>> Currently, virtio-mdev transport is a set of function callbacks
>>> defined in kernel. How to simply expose virtio-mdev transport to
>>> userspace?
>>
>> The most straightforward way is to have an 1:1 mapping between ioctl and
>> virito_mdev_device_ops.
> Seems we are already trying to do 1:1 mapping between ioctl
> and virtio_mdev_device_ops in vhost-mdev now (the major piece
> missing is get_device_id/get_config/set_config).


Yes, with this we can have a device independent API. Do you think this=20
is better?

Thanks


>
>
>> Thanks
>>
>>
>>>
>>>> A generic module
>>>> without any type specific code (like virtio-mdev). No need dedicated A=
PI for
>>>> e.g MQ. But then the API will look much different than current vhost d=
id.
>>>>
>>>> Consider the limitation of 1) I tend to choose 2 or 3. What's you opin=
ion?
>>>>
>>>>

