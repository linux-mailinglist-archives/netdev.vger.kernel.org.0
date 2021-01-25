Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2433020C7
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 04:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbhAYDS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 22:18:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726855AbhAYDSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 22:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611544606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eQlIKnWX05Xi/5RErZApghH+PFmHdjO65B3IKtiO0Xk=;
        b=LsQiyrrkhxIrtU9wGg38AA5EeR3tMw2XC5c4/vgE76DFc+KC3mLmZVWSBKDe5JBD1795va
        nVS8A3NtIM3vj9m0XVRVAOeoewkD2WY490kCTnhOqwfLhqk934BbdtsUqb/1VdVQAQZQgu
        tJGFrdsecc6tJptDVUekqnqOLyFbt7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-xK_3t1Q6OUSIheIP5bwhbw-1; Sun, 24 Jan 2021 22:16:43 -0500
X-MC-Unique: xK_3t1Q6OUSIheIP5bwhbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDB37107ACE4;
        Mon, 25 Jan 2021 03:16:41 +0000 (UTC)
Received: from [10.72.12.105] (ovpn-12-105.pek2.redhat.com [10.72.12.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 985E310013C0;
        Mon, 25 Jan 2021 03:16:31 +0000 (UTC)
Subject: Re: [PATCH 21/21] vdpasim: control virtqueue support
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Michael Tsirkin <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cindy Lu <lulu@redhat.com>,
        Eli Cohen <eli@mellanox.com>, lingshan.zhu@intel.com,
        Rob Miller <rob.miller@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-22-jasowang@redhat.com>
 <20210111122601.GA172492@mtl-vdi-166.wap.labs.mlnx>
 <da50981b-6bbc-ee61-b5b1-a57a09da8e93@redhat.com>
 <CAJaqyWcRirQgz+n63rU2nYVH2RKqjQfwHGFLzOG=H46qRWuTog@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9be0b845-4d59-05fc-5575-347a03c5da52@redhat.com>
Date:   Mon, 25 Jan 2021 11:16:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWcRirQgz+n63rU2nYVH2RKqjQfwHGFLzOG=H46qRWuTog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/23 上午3:43, Eugenio Perez Martin wrote:
> On Tue, Jan 12, 2021 at 4:12 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/1/11 下午8:26, Eli Cohen wrote:
>>> On Wed, Dec 16, 2020 at 02:48:18PM +0800, Jason Wang wrote:
>>>> This patch introduces the control virtqueue support for vDPA
>>>> simulator. This is a requirement for supporting advanced features like
>>>> multiqueue.
>>>>
>>>> A requirement for control virtqueue is to isolate its memory access
>>>> from the rx/tx virtqueues. This is because when using vDPA device
>>>> for VM, the control virqueue is not directly assigned to VM. Userspace
>>>> (Qemu) will present a shadow control virtqueue to control for
>>>> recording the device states.
>>>>
>>>> The isolation is done via the virtqueue groups and ASID support in
>>>> vDPA through vhost-vdpa. The simulator is extended to have:
>>>>
>>>> 1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
>>>> 2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
>>>>      contains CVQ
>>>> 3) two address spaces and the simulator simply implements the address
>>>>      spaces by mapping it 1:1 to IOTLB.
>>>>
>>>> For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
>>>> to group 1. So we have:
>>>>
>>>> 1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
>>>>      RX and TX can be assigned to guest directly.
>>>> 2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
>>>>      is the buffers that allocated and managed by VMM only. So CVQ of
>>>>      vhost-vdpa is visible to VMM only. And Guest can not access the CVQ
>>>>      of vhost-vdpa.
>>>>
>>>> For the other use cases, since AS 0 is associated to all virtqueue
>>>> groups by default. All virtqueues share the same mapping by default.
>>>>
>>>> To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
>>>> implemented in the simulator for the driver to set mac address.
>>>>
>>> Hi Jason,
>>>
>>> is there any version of qemu/libvirt available that I can see the
>>> control virtqueue working in action?
>>
>> Not yet, the qemu part depends on the shadow virtqueue work of Eugenio.
>> But it will work as:
>>
>> 1) qemu will use a separated address space for the control virtqueue
>> (shadow) exposed through vhost-vDPA
>> 2) the commands sent through control virtqueue by guest driver will
>> intercept by qemu
>> 3) Qemu will send those commands to the shadow control virtqueue
>>
>> Eugenio, any ETA for the new version of shadow virtqueue support in Qemu?
>>
> Hi Jason. Sorry for the late response.
>
> For the notification part I have addressed all the issues of the RFC
> [1], except the potential race conditions Stefan pointed, and tested
> with vdpa devices. You can find at
> https://github.com/eugpermar/qemu/tree/vdpa_sw_live_migration.d/notifications.rfc
> . Since the shadow path is activated only through QMP and does not
> interfere with regular operation, I could post to the qemu list if you
> prefer. The series will be smaller if merged in steps.


Sure. Please post them.


>
> Adding the buffer forwarding on top should not take long.
>
> [1] https://lkml.org/lkml/2020/9/23/1243
>
> Thanks!


Thanks


