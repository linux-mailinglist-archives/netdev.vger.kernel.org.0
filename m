Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEEC2DCB4E
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 04:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgLQDcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 22:32:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727734AbgLQDcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 22:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608175833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HO6KkKBsPBYL8yo5xJcOwAGMsGPxSzjnmDq5FDQ+Bkg=;
        b=hOLLwjVxfFh4wOWnIKO3spOSkNsD979sSlXIm4JCbsftlObLnZtp7fswaH8tzqNcuYpzMC
        pRqsn0HQ9DoxErO7tWKHmx9bQ8sLAlLbkgwUnSZmlVvsrgiN4bbKFB3sz0nIUT8TXkUJY2
        j3oLUkL3FyRNc3ePLWWass8OfUwLI7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-XOc3xLNlML-NxSqRAwwukw-1; Wed, 16 Dec 2020 22:30:32 -0500
X-MC-Unique: XOc3xLNlML-NxSqRAwwukw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B86910054FF;
        Thu, 17 Dec 2020 03:30:30 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4301860C15;
        Thu, 17 Dec 2020 03:30:20 +0000 (UTC)
Subject: Re: [PATCH 00/21] Control VQ support in vDPA
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216044051-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <aa061fcb-9395-3a1b-5d6e-76b5454dfb6c@redhat.com>
Date:   Thu, 17 Dec 2020 11:30:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201216044051-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/16 下午5:47, Michael S. Tsirkin wrote:
> On Wed, Dec 16, 2020 at 02:47:57PM +0800, Jason Wang wrote:
>> Hi All:
>>
>> This series tries to add the support for control virtqueue in vDPA.
>>
>> Control virtqueue is used by networking device for accepting various
>> commands from the driver. It's a must to support multiqueue and other
>> configurations.
>>
>> When used by vhost-vDPA bus driver for VM, the control virtqueue
>> should be shadowed via userspace VMM (Qemu) instead of being assigned
>> directly to Guest. This is because Qemu needs to know the device state
>> in order to start and stop device correctly (e.g for Live Migration).
>>
>> This requies to isolate the memory mapping for control virtqueue
>> presented by vhost-vDPA to prevent guest from accesing it directly.
>> To achieve this, vDPA introduce two new abstractions:
>>
>> - address space: identified through address space id (ASID) and a set
>>                   of memory mapping in maintained
>> - virtqueue group: the minimal set of virtqueues that must share an
>>                   address space
> How will this support the pretty common case where control vq
> is programmed by the kernel through the PF, and others by the VFs?


In this case, the VF parent need to provide a software control vq and 
decode the command then send them to VF.


>
>
> I actually thought the way to support it is by exposing
> something like an "inject buffers" API which sends data to a given VQ.
> Maybe an ioctl, and maybe down the road uio ring can support batching
> these ....


So the virtuqueue allows the request to be processed asynchronously (e.g 
driver may choose to use interrupt for control vq). This means we need 
to support that in uAPI level. And if we manage to do that, it's just 
another type of virtqueue.

For virtio-vDPA, this also means the extensions for queue processing 
which is a functional duplication. Using what proposed in this series, 
we don't need any changes for kernel virtio drivers.

What's more important, this series could be used for future features 
that requires DMA isolation between virtqueues:

- report dirty pages via virtqueue
- sub function level device slicing

...

Thanks


>
>
>> Device needs to advertise the following attributes to vDPA:
>>
>> - the number of address spaces supported in the device
>> - the number of virtqueue groups supported in the device
>> - the mappings from a specific virtqueue to its virtqueue groups
>>
>> The mappings from virtqueue to virtqueue groups is fixed and defined
>> by vDPA device driver. E.g:
>>
>> - For the device that has hardware ASID support, it can simply
>>    advertise a per virtqueue virtqueue group.
>> - For the device that does not have hardware ASID support, it can
>>    simply advertise a single virtqueue group that contains all
>>    virtqueues. Or if it wants a software emulated control virtqueue, it
>>    can advertise two virtqueue groups, one is for cvq, another is for
>>    the rest virtqueues.
>>
>> vDPA also allow to change the association between virtqueue group and
>> address space. So in the case of control virtqueue, userspace
>> VMM(Qemu) may use a dedicated address space for the control virtqueue
>> group to isolate the memory mapping.
>>
>> The vhost/vhost-vDPA is also extend for the userspace to:
>>
>> - query the number of virtqueue groups and address spaces supported by
>>    the device
>> - query the virtqueue group for a specific virtqueue
>> - assocaite a virtqueue group with an address space
>> - send ASID based IOTLB commands
>>
>> This will help userspace VMM(Qemu) to detect whether the control vq
>> could be supported and isolate memory mappings of control virtqueue
>> from the others.
>>
>> To demonstrate the usage, vDPA simulator is extended to support
>> setting MAC address via a emulated control virtqueue.
>>
>> Please review.
>>
>> Changes since RFC:
>>
>> - tweak vhost uAPI documentation
>> - switch to use device specific IOTLB really in patch 4
>> - tweak the commit log
>> - fix that ASID in vhost is claimed to be 32 actually but 16bit
>>    actually
>> - fix use after free when using ASID with IOTLB batching requests
>> - switch to use Stefano's patch for having separated iov
>> - remove unused "used_as" variable
>> - fix the iotlb/asid checking in vhost_vdpa_unmap()
>>
>> Thanks
>>
>> Jason Wang (20):
>>    vhost: move the backend feature bits to vhost_types.h
>>    virtio-vdpa: don't set callback if virtio doesn't need it
>>    vhost-vdpa: passing iotlb to IOMMU mapping helpers
>>    vhost-vdpa: switch to use vhost-vdpa specific IOTLB
>>    vdpa: add the missing comment for nvqs in struct vdpa_device
>>    vdpa: introduce virtqueue groups
>>    vdpa: multiple address spaces support
>>    vdpa: introduce config operations for associating ASID to a virtqueue
>>      group
>>    vhost_iotlb: split out IOTLB initialization
>>    vhost: support ASID in IOTLB API
>>    vhost-vdpa: introduce asid based IOTLB
>>    vhost-vdpa: introduce uAPI to get the number of virtqueue groups
>>    vhost-vdpa: introduce uAPI to get the number of address spaces
>>    vhost-vdpa: uAPI to get virtqueue group id
>>    vhost-vdpa: introduce uAPI to set group ASID
>>    vhost-vdpa: support ASID based IOTLB API
>>    vdpa_sim: advertise VIRTIO_NET_F_MTU
>>    vdpa_sim: factor out buffer completion logic
>>    vdpa_sim: filter destination mac address
>>    vdpasim: control virtqueue support
>>
>> Stefano Garzarella (1):
>>    vdpa_sim: split vdpasim_virtqueue's iov field in out_iov and in_iov
>>
>>   drivers/vdpa/ifcvf/ifcvf_main.c   |   9 +-
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c |  11 +-
>>   drivers/vdpa/vdpa.c               |   8 +-
>>   drivers/vdpa/vdpa_sim/vdpa_sim.c  | 292 ++++++++++++++++++++++++------
>>   drivers/vhost/iotlb.c             |  23 ++-
>>   drivers/vhost/vdpa.c              | 246 ++++++++++++++++++++-----
>>   drivers/vhost/vhost.c             |  23 ++-
>>   drivers/vhost/vhost.h             |   4 +-
>>   drivers/virtio/virtio_vdpa.c      |   2 +-
>>   include/linux/vdpa.h              |  42 ++++-
>>   include/linux/vhost_iotlb.h       |   2 +
>>   include/uapi/linux/vhost.h        |  25 ++-
>>   include/uapi/linux/vhost_types.h  |  10 +-
>>   13 files changed, 561 insertions(+), 136 deletions(-)
>>
>> -- 
>> 2.25.1

