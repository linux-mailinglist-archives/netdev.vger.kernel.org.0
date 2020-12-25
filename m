Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75D42E2A16
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 08:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgLYG7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 01:59:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbgLYG7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 01:59:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608879500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBTp23RhCF2lNaGdXuKBZ6xR632uHIkymwYyPE70oOU=;
        b=IA4Ua3naXxbrY0tsVTYFCP6FFneeXf/h3cXU+blBsXYa92FYnx7uJ2ofzOdR3hETDDQ6jp
        EqXjFjyk3XKiUN2zTTiaeemYftRywUiuyrG6YGuMyI3krSHetVdauJq09HrWFe+sfi8Cs8
        cuy3W5pcYNoO78T15bAPtInaX7kPkxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-jwRdfOAsMsGt45YAWXmUug-1; Fri, 25 Dec 2020 01:58:16 -0500
X-MC-Unique: jwRdfOAsMsGt45YAWXmUug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E8DC10054FF;
        Fri, 25 Dec 2020 06:58:13 +0000 (UTC)
Received: from [10.72.12.97] (ovpn-12-97.pek2.redhat.com [10.72.12.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3962B62462;
        Fri, 25 Dec 2020 06:58:00 +0000 (UTC)
Subject: Re: [RFC v2 09/13] vduse: Add support for processing vhost iotlb
 message
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <20201222145221.711-10-xieyongji@bytedance.com>
 <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com>
 <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
 <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com>
 <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com>
Date:   Fri, 25 Dec 2020 14:57:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/24 下午3:37, Yongji Xie wrote:
> On Thu, Dec 24, 2020 at 10:41 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2020/12/23 下午8:14, Yongji Xie wrote:
>>> On Wed, Dec 23, 2020 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2020/12/22 下午10:52, Xie Yongji wrote:
>>>>> To support vhost-vdpa bus driver, we need a way to share the
>>>>> vhost-vdpa backend process's memory with the userspace VDUSE process.
>>>>>
>>>>> This patch tries to make use of the vhost iotlb message to achieve
>>>>> that. We will get the shm file from the iotlb message and pass it
>>>>> to the userspace VDUSE process.
>>>>>
>>>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>>>> ---
>>>>>     Documentation/driver-api/vduse.rst |  15 +++-
>>>>>     drivers/vdpa/vdpa_user/vduse_dev.c | 147 ++++++++++++++++++++++++++++++++++++-
>>>>>     include/uapi/linux/vduse.h         |  11 +++
>>>>>     3 files changed, 171 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
>>>>> index 623f7b040ccf..48e4b1ba353f 100644
>>>>> --- a/Documentation/driver-api/vduse.rst
>>>>> +++ b/Documentation/driver-api/vduse.rst
>>>>> @@ -46,13 +46,26 @@ The following types of messages are provided by the VDUSE framework now:
>>>>>
>>>>>     - VDUSE_GET_CONFIG: Read from device specific configuration space
>>>>>
>>>>> +- VDUSE_UPDATE_IOTLB: Update the memory mapping in device IOTLB
>>>>> +
>>>>> +- VDUSE_INVALIDATE_IOTLB: Invalidate the memory mapping in device IOTLB
>>>>> +
>>>>>     Please see include/linux/vdpa.h for details.
>>>>>
>>>>> -In the data path, VDUSE framework implements a MMU-based on-chip IOMMU
>>>>> +The data path of userspace vDPA device is implemented in different ways
>>>>> +depending on the vdpa bus to which it is attached.
>>>>> +
>>>>> +In virtio-vdpa case, VDUSE framework implements a MMU-based on-chip IOMMU
>>>>>     driver which supports mapping the kernel dma buffer to a userspace iova
>>>>>     region dynamically. The userspace iova region can be created by passing
>>>>>     the userspace vDPA device fd to mmap(2).
>>>>>
>>>>> +In vhost-vdpa case, the dma buffer is reside in a userspace memory region
>>>>> +which will be shared to the VDUSE userspace processs via the file
>>>>> +descriptor in VDUSE_UPDATE_IOTLB message. And the corresponding address
>>>>> +mapping (IOVA of dma buffer <-> VA of the memory region) is also included
>>>>> +in this message.
>>>>> +
>>>>>     Besides, the eventfd mechanism is used to trigger interrupt callbacks and
>>>>>     receive virtqueue kicks in userspace. The following ioctls on the userspace
>>>>>     vDPA device fd are provided to support that:
>>>>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
>>>>> index b974333ed4e9..d24aaacb6008 100644
>>>>> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
>>>>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
>>>>> @@ -34,6 +34,7 @@
>>>>>
>>>>>     struct vduse_dev_msg {
>>>>>         struct vduse_dev_request req;
>>>>> +     struct file *iotlb_file;
>>>>>         struct vduse_dev_response resp;
>>>>>         struct list_head list;
>>>>>         wait_queue_head_t waitq;
>>>>> @@ -325,12 +326,80 @@ static int vduse_dev_set_vq_state(struct vduse_dev *dev,
>>>>>         return ret;
>>>>>     }
>>>>>
>>>>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev, struct file *file,
>>>>> +                             u64 offset, u64 iova, u64 size, u8 perm)
>>>>> +{
>>>>> +     struct vduse_dev_msg *msg;
>>>>> +     int ret;
>>>>> +
>>>>> +     if (!size)
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     msg = vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
>>>>> +     msg->req.size = sizeof(struct vduse_iotlb);
>>>>> +     msg->req.iotlb.offset = offset;
>>>>> +     msg->req.iotlb.iova = iova;
>>>>> +     msg->req.iotlb.size = size;
>>>>> +     msg->req.iotlb.perm = perm;
>>>>> +     msg->req.iotlb.fd = -1;
>>>>> +     msg->iotlb_file = get_file(file);
>>>>> +
>>>>> +     ret = vduse_dev_msg_sync(dev, msg);
>>>> My feeling is that we should provide consistent API for the userspace
>>>> device to use.
>>>>
>>>> E.g we'd better carry the IOTLB message for both virtio/vhost drivers.
>>>>
>>>> It looks to me for virtio drivers we can still use UPDAT_IOTLB message
>>>> by using VDUSE file as msg->iotlb_file here.
>>>>
>>> It's OK for me. One problem is when to transfer the UPDATE_IOTLB
>>> message in virtio cases.
>>
>> Instead of generating IOTLB messages for userspace.
>>
>> How about record the mappings (which is a common case for device have
>> on-chip IOMMU e.g mlx5e and vdpa simlator), then we can introduce ioctl
>> for userspace to query?
>>
> If so, the IOTLB UPDATE is actually triggered by ioctl, but
> IOTLB_INVALIDATE is triggered by the message. Is it a little odd?


Good point.

Some questions here:

1) Userspace think the IOTLB was flushed after IOTLB_INVALIDATE syscall 
is returned. But this patch doesn't have this guarantee. Can this lead 
some issues?
2) I think after VDUSE userspace receives IOTLB_INVALIDATE, it needs to 
issue a munmap(). What if it doesn't do that?


>   Or
> how about trigger it when userspace call mmap() on the device fd?


One possible issue is that the IOTLB_UPDATE/INVALIDATE might come after 
mmap():

1) When vIOMMU is enabled
2) Guest memory topology has been changed (memory hotplug).

Thanks


>
> Thanks,
> Yongji
>

