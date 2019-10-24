Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECC7E2F44
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438842AbfJXKnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:43:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436872AbfJXKnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571913789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4wI1HwBUjiSqLG+R/qGHQwon1lbGfQ/yWCz8YkSyTFo=;
        b=Aul8tlXAOr6pzbLDJApqjF3zUuERNVMeA+pxt2HMMsvVPYy6uxwUYq3dremy/SvSKM4zgS
        220ixex/mlgHYupPQF/0pHb7uNnSmwxZxsoBurf5Bls5vD4uQJ0ZrPe3KroheAONMFFtQR
        6tOfTBdDEduihL8RkpqZ8f81vHxUSIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-RTDyQiFIPI60gnHRQ8FavA-1; Thu, 24 Oct 2019 06:43:05 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDA801800DFB;
        Thu, 24 Oct 2019 10:43:03 +0000 (UTC)
Received: from [10.72.13.32] (ovpn-13-32.pek2.redhat.com [10.72.13.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B3701001B2B;
        Thu, 24 Oct 2019 10:42:52 +0000 (UTC)
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <47a572fd-5597-1972-e177-8ee25ca51247@redhat.com>
 <20191023030253.GA15401@___>
 <ac36f1e3-b972-71ac-fe0c-3db03e016dcf@redhat.com>
 <20191023070747.GA30533@___>
 <106834b5-dae5-82b2-0f97-16951709d075@redhat.com> <20191023101135.GA6367@___>
 <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
 <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
 <20191024091839.GA17463@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fefc82a3-a137-bc03-e1c3-8de79b238080@redhat.com>
Date:   Thu, 24 Oct 2019 18:42:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024091839.GA17463@___>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: RTDyQiFIPI60gnHRQ8FavA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/24 =E4=B8=8B=E5=8D=885:18, Tiwei Bie wrote:
> On Thu, Oct 24, 2019 at 04:32:42PM +0800, Jason Wang wrote:
>> On 2019/10/24 =E4=B8=8B=E5=8D=884:03, Jason Wang wrote:
>>> On 2019/10/24 =E4=B8=8B=E5=8D=8812:21, Tiwei Bie wrote:
>>>> On Wed, Oct 23, 2019 at 06:29:21PM +0800, Jason Wang wrote:
>>>>> On 2019/10/23 =E4=B8=8B=E5=8D=886:11, Tiwei Bie wrote:
>>>>>> On Wed, Oct 23, 2019 at 03:25:00PM +0800, Jason Wang wrote:
>>>>>>> On 2019/10/23 =E4=B8=8B=E5=8D=883:07, Tiwei Bie wrote:
>>>>>>>> On Wed, Oct 23, 2019 at 01:46:23PM +0800, Jason Wang wrote:
>>>>>>>>> On 2019/10/23 =E4=B8=8A=E5=8D=8811:02, Tiwei Bie wrote:
>>>>>>>>>> On Tue, Oct 22, 2019 at 09:30:16PM +0800, Jason Wang wrote:
>>>>>>>>>>> On 2019/10/22 =E4=B8=8B=E5=8D=885:52, Tiwei Bie wrote:
>>>>>>>>>>>> This patch introduces a mdev based hardware vhost backend.
>>>>>>>>>>>> This backend is built on top of the same abstraction used
>>>>>>>>>>>> in virtio-mdev and provides a generic vhost interface for
>>>>>>>>>>>> userspace to accelerate the virtio devices in guest.
>>>>>>>>>>>>
>>>>>>>>>>>> This backend is implemented as a mdev device driver on top
>>>>>>>>>>>> of the same mdev device ops used in virtio-mdev but using
>>>>>>>>>>>> a different mdev class id, and it will register the device
>>>>>>>>>>>> as a VFIO device for userspace to use. Userspace can setup
>>>>>>>>>>>> the IOMMU with the existing VFIO container/group APIs and
>>>>>>>>>>>> then get the device fd with the device name. After getting
>>>>>>>>>>>> the device fd of this device, userspace can use vhost ioctls
>>>>>>>>>>>> to setup the backend.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>>>>>>>>>>>> ---
>>>>>>>>>>>> This patch depends on below series:
>>>>>>>>>>>> https://lkml.org/lkml/2019/10/17/286
>>>>>>>>>>>>
>>>>>>>>>>>> v1 -> v2:
>>>>>>>>>>>> - Replace _SET_STATE with _SET_STATUS (MST);
>>>>>>>>>>>> - Check status bits at each step (MST);
>>>>>>>>>>>> - Report the max ring size and max number of queues (MST);
>>>>>>>>>>>> - Add missing MODULE_DEVICE_TABLE (Jason);
>>>>>>>>>>>> - Only support the network backend w/o multiqueue for now;
>>>>>>>>>>> Any idea on how to extend it to support
>>>>>>>>>>> devices other than net? I think we
>>>>>>>>>>> want a generic API or an API that could
>>>>>>>>>>> be made generic in the future.
>>>>>>>>>>>
>>>>>>>>>>> Do we want to e.g having a generic vhost
>>>>>>>>>>> mdev for all kinds of devices or
>>>>>>>>>>> introducing e.g vhost-net-mdev and vhost-scsi-mdev?
>>>>>>>>>> One possible way is to do what vhost-user does. I.e. Apart from
>>>>>>>>>> the generic ring, features, ... related ioctls, we also introduc=
e
>>>>>>>>>> device specific ioctls when we need them. As vhost-mdev just nee=
ds
>>>>>>>>>> to forward configs between parent and userspace and even won't
>>>>>>>>>> cache any info when possible,
>>>>>>>>> So it looks to me this is only possible if we
>>>>>>>>> expose e.g set_config and
>>>>>>>>> get_config to userspace.
>>>>>>>> The set_config and get_config interface isn't really everything
>>>>>>>> of device specific settings. We also have ctrlq in virtio-net.
>>>>>>> Yes, but it could be processed by the exist API. Isn't
>>>>>>> it? Just set ctrl vq
>>>>>>> address and let parent to deal with that.
>>>>>> I mean how to expose ctrlq related settings to userspace?
>>>>> I think it works like:
>>>>>
>>>>> 1) userspace find ctrl_vq is supported
>>>>>
>>>>> 2) then it can allocate memory for ctrl vq and set its address throug=
h
>>>>> vhost-mdev
>>>>>
>>>>> 3) userspace can populate ctrl vq itself
>>>> I see. That is to say, userspace e.g. QEMU will program the
>>>> ctrl vq with the existing VHOST_*_VRING_* ioctls, and parent
>>>> drivers should know that the addresses used in ctrl vq are
>>>> host virtual addresses in vhost-mdev's case.
>>>
>>> That's really good point. And that means parent needs to differ vhost
>>> from virtio. It should work.
>>
>> HVA may only work when we have something similar to VHOST_SET_OWNER whic=
h
>> can reuse MM of its owner.
> We already have VHOST_SET_OWNER in vhost now, parent can handle
> the commands in its .kick_vq() which is called by vq's .handle_kick
> callback. Virtio-user did something similar:
>
> https://github.com/DPDK/dpdk/blob/0da7f445df445630c794897347ee360d6fe6348=
b/drivers/net/virtio/virtio_user_ethdev.c#L313-L322


This probably means a process context is required, something like=20
kthread that is used by vhost which seems a burden for parent. Or we can=20
extend ioctl to processing kick in the system call context.


>
>>
>>> But is there any chance to use DMA address? I'm asking since the API
>>> then tends to be device specific.
>>
>> I wonder whether we can introduce MAP IOMMU notifier and get DMA mapping=
s
>> from that.
> I think this will complicate things unnecessarily and may
> bring pains. Because, in vhost-mdev, mdev's ctrl vq is
> supposed to be managed by host.


Yes.


>   And we should try to avoid
> putting ctrl vq and Rx/Tx vqs in the same DMA space to prevent
> guests having the chance to bypass the host (e.g. QEMU) to
> setup the backend accelerator directly.


That's really good point.=C2=A0 So when "vhost" type is created, parent=20
should assume addr of ctrl_vq is hva.

Thanks


>
>> Thanks
>>

