Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B99DE2C3B
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 10:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438246AbfJXIdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 04:33:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34194 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727024AbfJXIdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 04:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571905983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GP6qD2J1CBmhiVD+sbR/nBuazK8LU9m7yhlITTEQS64=;
        b=BjhhtX0rV9o+lKLCfMH095/SU8rOW3u514UXQcTOSxGUEORphqLOYOtO/yT3TroG+uDqP0
        Krt6XiuYsDd9rmxMQw+Sgxh3L6CP/X59QW5S5tLTAz5z2HExCmCXfhrkWnHBEAOaUy4hu1
        vVRSEEovid+QD0qQ561oD1A7ba5DJxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-zHllE4ZJP_6HPNgUQkm_IQ-1; Thu, 24 Oct 2019 04:33:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B751A800D5A;
        Thu, 24 Oct 2019 08:33:00 +0000 (UTC)
Received: from [10.72.13.32] (ovpn-13-32.pek2.redhat.com [10.72.13.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A93A5D717;
        Thu, 24 Oct 2019 08:32:43 +0000 (UTC)
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
From:   Jason Wang <jasowang@redhat.com>
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
 <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
Message-ID: <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
Date:   Thu, 24 Oct 2019 16:32:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: zHllE4ZJP_6HPNgUQkm_IQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/24 =E4=B8=8B=E5=8D=884:03, Jason Wang wrote:
>
> On 2019/10/24 =E4=B8=8B=E5=8D=8812:21, Tiwei Bie wrote:
>> On Wed, Oct 23, 2019 at 06:29:21PM +0800, Jason Wang wrote:
>>> On 2019/10/23 =E4=B8=8B=E5=8D=886:11, Tiwei Bie wrote:
>>>> On Wed, Oct 23, 2019 at 03:25:00PM +0800, Jason Wang wrote:
>>>>> On 2019/10/23 =E4=B8=8B=E5=8D=883:07, Tiwei Bie wrote:
>>>>>> On Wed, Oct 23, 2019 at 01:46:23PM +0800, Jason Wang wrote:
>>>>>>> On 2019/10/23 =E4=B8=8A=E5=8D=8811:02, Tiwei Bie wrote:
>>>>>>>> On Tue, Oct 22, 2019 at 09:30:16PM +0800, Jason Wang wrote:
>>>>>>>>> On 2019/10/22 =E4=B8=8B=E5=8D=885:52, Tiwei Bie wrote:
>>>>>>>>>> This patch introduces a mdev based hardware vhost backend.
>>>>>>>>>> This backend is built on top of the same abstraction used
>>>>>>>>>> in virtio-mdev and provides a generic vhost interface for
>>>>>>>>>> userspace to accelerate the virtio devices in guest.
>>>>>>>>>>
>>>>>>>>>> This backend is implemented as a mdev device driver on top
>>>>>>>>>> of the same mdev device ops used in virtio-mdev but using
>>>>>>>>>> a different mdev class id, and it will register the device
>>>>>>>>>> as a VFIO device for userspace to use. Userspace can setup
>>>>>>>>>> the IOMMU with the existing VFIO container/group APIs and
>>>>>>>>>> then get the device fd with the device name. After getting
>>>>>>>>>> the device fd of this device, userspace can use vhost ioctls
>>>>>>>>>> to setup the backend.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>>>>>>>>>> ---
>>>>>>>>>> This patch depends on below series:
>>>>>>>>>> https://lkml.org/lkml/2019/10/17/286
>>>>>>>>>>
>>>>>>>>>> v1 -> v2:
>>>>>>>>>> - Replace _SET_STATE with _SET_STATUS (MST);
>>>>>>>>>> - Check status bits at each step (MST);
>>>>>>>>>> - Report the max ring size and max number of queues (MST);
>>>>>>>>>> - Add missing MODULE_DEVICE_TABLE (Jason);
>>>>>>>>>> - Only support the network backend w/o multiqueue for now;
>>>>>>>>> Any idea on how to extend it to support devices other than=20
>>>>>>>>> net? I think we
>>>>>>>>> want a generic API or an API that could be made generic in the=20
>>>>>>>>> future.
>>>>>>>>>
>>>>>>>>> Do we want to e.g having a generic vhost mdev for all kinds of=20
>>>>>>>>> devices or
>>>>>>>>> introducing e.g vhost-net-mdev and vhost-scsi-mdev?
>>>>>>>> One possible way is to do what vhost-user does. I.e. Apart from
>>>>>>>> the generic ring, features, ... related ioctls, we also introduce
>>>>>>>> device specific ioctls when we need them. As vhost-mdev just needs
>>>>>>>> to forward configs between parent and userspace and even won't
>>>>>>>> cache any info when possible,
>>>>>>> So it looks to me this is only possible if we expose e.g=20
>>>>>>> set_config and
>>>>>>> get_config to userspace.
>>>>>> The set_config and get_config interface isn't really everything
>>>>>> of device specific settings. We also have ctrlq in virtio-net.
>>>>> Yes, but it could be processed by the exist API. Isn't it? Just=20
>>>>> set ctrl vq
>>>>> address and let parent to deal with that.
>>>> I mean how to expose ctrlq related settings to userspace?
>>>
>>> I think it works like:
>>>
>>> 1) userspace find ctrl_vq is supported
>>>
>>> 2) then it can allocate memory for ctrl vq and set its address through
>>> vhost-mdev
>>>
>>> 3) userspace can populate ctrl vq itself
>> I see. That is to say, userspace e.g. QEMU will program the
>> ctrl vq with the existing VHOST_*_VRING_* ioctls, and parent
>> drivers should know that the addresses used in ctrl vq are
>> host virtual addresses in vhost-mdev's case.
>
>
> That's really good point. And that means parent needs to differ vhost=20
> from virtio. It should work.=20


HVA may only work when we have something similar to VHOST_SET_OWNER=20
which can reuse MM of its owner.


> But is there any chance to use DMA address? I'm asking since the API=20
> then tends to be device specific.=20


I wonder whether we can introduce MAP IOMMU notifier and get DMA=20
mappings from that.

Thanks

