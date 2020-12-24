Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957822E23BF
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 03:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgLXCnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 21:43:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728630AbgLXCnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 21:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608777710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4p4XCLcT9Cy4rfmz8sdmumlkVjWox2OdnsnLNXRg9jc=;
        b=LCE8glcz7owlUYx4cLJg4E1v00wiUNJfh7XZ967MrRRJfuVM4noUzLbqi6Hw6r7MzUCwex
        12egbcZHY/XVVaSIQN8Ck/E+4SlVNmwmWWIL4e6i/8O5b7nBHt81bxcFlqfUSpYeKRD0Oh
        Vah2IoGYBhFC63jM2R06xM6wFwY25N8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-YdIz8xygPwCd8x_rcseEqg-1; Wed, 23 Dec 2020 21:41:46 -0500
X-MC-Unique: YdIz8xygPwCd8x_rcseEqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3C15800D53;
        Thu, 24 Dec 2020 02:41:43 +0000 (UTC)
Received: from [10.72.13.109] (ovpn-13-109.pek2.redhat.com [10.72.13.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B45E60C04;
        Thu, 24 Dec 2020 02:41:26 +0000 (UTC)
Subject: Re: [External] Re: [RFC v2 09/13] vduse: Add support for processing
 vhost iotlb message
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com>
Date:   Thu, 24 Dec 2020 10:41:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/23 下午8:14, Yongji Xie wrote:
> On Wed, Dec 23, 2020 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2020/12/22 下午10:52, Xie Yongji wrote:
>>> To support vhost-vdpa bus driver, we need a way to share the
>>> vhost-vdpa backend process's memory with the userspace VDUSE process.
>>>
>>> This patch tries to make use of the vhost iotlb message to achieve
>>> that. We will get the shm file from the iotlb message and pass it
>>> to the userspace VDUSE process.
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> ---
>>>    Documentation/driver-api/vduse.rst |  15 +++-
>>>    drivers/vdpa/vdpa_user/vduse_dev.c | 147 ++++++++++++++++++++++++++++++++++++-
>>>    include/uapi/linux/vduse.h         |  11 +++
>>>    3 files changed, 171 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
>>> index 623f7b040ccf..48e4b1ba353f 100644
>>> --- a/Documentation/driver-api/vduse.rst
>>> +++ b/Documentation/driver-api/vduse.rst
>>> @@ -46,13 +46,26 @@ The following types of messages are provided by the VDUSE framework now:
>>>
>>>    - VDUSE_GET_CONFIG: Read from device specific configuration space
>>>
>>> +- VDUSE_UPDATE_IOTLB: Update the memory mapping in device IOTLB
>>> +
>>> +- VDUSE_INVALIDATE_IOTLB: Invalidate the memory mapping in device IOTLB
>>> +
>>>    Please see include/linux/vdpa.h for details.
>>>
>>> -In the data path, VDUSE framework implements a MMU-based on-chip IOMMU
>>> +The data path of userspace vDPA device is implemented in different ways
>>> +depending on the vdpa bus to which it is attached.
>>> +
>>> +In virtio-vdpa case, VDUSE framework implements a MMU-based on-chip IOMMU
>>>    driver which supports mapping the kernel dma buffer to a userspace iova
>>>    region dynamically. The userspace iova region can be created by passing
>>>    the userspace vDPA device fd to mmap(2).
>>>
>>> +In vhost-vdpa case, the dma buffer is reside in a userspace memory region
>>> +which will be shared to the VDUSE userspace processs via the file
>>> +descriptor in VDUSE_UPDATE_IOTLB message. And the corresponding address
>>> +mapping (IOVA of dma buffer <-> VA of the memory region) is also included
>>> +in this message.
>>> +
>>>    Besides, the eventfd mechanism is used to trigger interrupt callbacks and
>>>    receive virtqueue kicks in userspace. The following ioctls on the userspace
>>>    vDPA device fd are provided to support that:
>>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
>>> index b974333ed4e9..d24aaacb6008 100644
>>> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
>>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
>>> @@ -34,6 +34,7 @@
>>>
>>>    struct vduse_dev_msg {
>>>        struct vduse_dev_request req;
>>> +     struct file *iotlb_file;
>>>        struct vduse_dev_response resp;
>>>        struct list_head list;
>>>        wait_queue_head_t waitq;
>>> @@ -325,12 +326,80 @@ static int vduse_dev_set_vq_state(struct vduse_dev *dev,
>>>        return ret;
>>>    }
>>>
>>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev, struct file *file,
>>> +                             u64 offset, u64 iova, u64 size, u8 perm)
>>> +{
>>> +     struct vduse_dev_msg *msg;
>>> +     int ret;
>>> +
>>> +     if (!size)
>>> +             return -EINVAL;
>>> +
>>> +     msg = vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
>>> +     msg->req.size = sizeof(struct vduse_iotlb);
>>> +     msg->req.iotlb.offset = offset;
>>> +     msg->req.iotlb.iova = iova;
>>> +     msg->req.iotlb.size = size;
>>> +     msg->req.iotlb.perm = perm;
>>> +     msg->req.iotlb.fd = -1;
>>> +     msg->iotlb_file = get_file(file);
>>> +
>>> +     ret = vduse_dev_msg_sync(dev, msg);
>>
>> My feeling is that we should provide consistent API for the userspace
>> device to use.
>>
>> E.g we'd better carry the IOTLB message for both virtio/vhost drivers.
>>
>> It looks to me for virtio drivers we can still use UPDAT_IOTLB message
>> by using VDUSE file as msg->iotlb_file here.
>>
> It's OK for me. One problem is when to transfer the UPDATE_IOTLB
> message in virtio cases.


Instead of generating IOTLB messages for userspace.

How about record the mappings (which is a common case for device have 
on-chip IOMMU e.g mlx5e and vdpa simlator), then we can introduce ioctl 
for userspace to query?

Thanks


>
>>> +     vduse_dev_msg_put(msg);
>>> +     fput(file);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static int vduse_dev_invalidate_iotlb(struct vduse_dev *dev,
>>> +                                     u64 iova, u64 size)
>>> +{
>>> +     struct vduse_dev_msg *msg;
>>> +     int ret;
>>> +
>>> +     if (!size)
>>> +             return -EINVAL;
>>> +
>>> +     msg = vduse_dev_new_msg(dev, VDUSE_INVALIDATE_IOTLB);
>>> +     msg->req.size = sizeof(struct vduse_iotlb);
>>> +     msg->req.iotlb.iova = iova;
>>> +     msg->req.iotlb.size = size;
>>> +
>>> +     ret = vduse_dev_msg_sync(dev, msg);
>>> +     vduse_dev_msg_put(msg);
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static unsigned int perm_to_file_flags(u8 perm)
>>> +{
>>> +     unsigned int flags = 0;
>>> +
>>> +     switch (perm) {
>>> +     case VHOST_ACCESS_WO:
>>> +             flags |= O_WRONLY;
>>> +             break;
>>> +     case VHOST_ACCESS_RO:
>>> +             flags |= O_RDONLY;
>>> +             break;
>>> +     case VHOST_ACCESS_RW:
>>> +             flags |= O_RDWR;
>>> +             break;
>>> +     default:
>>> +             WARN(1, "invalidate vhost IOTLB permission\n");
>>> +             break;
>>> +     }
>>> +
>>> +     return flags;
>>> +}
>>> +
>>>    static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>>    {
>>>        struct file *file = iocb->ki_filp;
>>>        struct vduse_dev *dev = file->private_data;
>>>        struct vduse_dev_msg *msg;
>>> -     int size = sizeof(struct vduse_dev_request);
>>> +     unsigned int flags;
>>> +     int fd, size = sizeof(struct vduse_dev_request);
>>>        ssize_t ret = 0;
>>>
>>>        if (iov_iter_count(to) < size)
>>> @@ -349,6 +418,18 @@ static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>>                if (ret)
>>>                        return ret;
>>>        }
>>> +
>>> +     if (msg->req.type == VDUSE_UPDATE_IOTLB && msg->req.iotlb.fd == -1) {
>>> +             flags = perm_to_file_flags(msg->req.iotlb.perm);
>>> +             fd = get_unused_fd_flags(flags);
>>> +             if (fd < 0) {
>>> +                     vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
>>> +                     return fd;
>>> +             }
>>> +             fd_install(fd, get_file(msg->iotlb_file));
>>> +             msg->req.iotlb.fd = fd;
>>> +     }
>>> +
>>>        ret = copy_to_iter(&msg->req, size, to);
>>>        if (ret != size) {
>>>                vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
>>> @@ -565,6 +646,69 @@ static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned int offset,
>>>        vduse_dev_set_config(dev, offset, buf, len);
>>>    }
>>>
>>> +static void vduse_vdpa_invalidate_iotlb(struct vduse_dev *dev,
>>> +                                     struct vhost_iotlb_msg *msg)
>>> +{
>>> +     vduse_dev_invalidate_iotlb(dev, msg->iova, msg->size);
>>> +}
>>> +
>>> +static int vduse_vdpa_update_iotlb(struct vduse_dev *dev,
>>> +                                     struct vhost_iotlb_msg *msg)
>>> +{
>>> +     u64 uaddr = msg->uaddr;
>>> +     u64 iova = msg->iova;
>>> +     u64 size = msg->size;
>>> +     u64 offset;
>>> +     struct vm_area_struct *vma;
>>> +     int ret;
>>> +
>>> +     while (uaddr < msg->uaddr + msg->size) {
>>> +             vma = find_vma(current->mm, uaddr);
>>> +             ret = -EINVAL;
>>> +             if (!vma)
>>> +                     goto err;
>>> +
>>> +             size = min(msg->size, vma->vm_end - uaddr);
>>> +             offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
>>> +             if (vma->vm_file && (vma->vm_flags & VM_SHARED)) {
>>> +                     ret = vduse_dev_update_iotlb(dev, vma->vm_file, offset,
>>> +                                                     iova, size, msg->perm);
>>> +                     if (ret)
>>> +                             goto err;
>>
>> My understanding is that vma is something that should not be known by a
>> device. So I suggest to move the above processing to vhost-vdpa.c.
>>
> Will do it.
>
> Thanks,
> Yongji
>

