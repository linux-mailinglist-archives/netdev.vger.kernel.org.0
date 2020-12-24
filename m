Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F27F2E23E1
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 04:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgLXDD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 22:03:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728757AbgLXDD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 22:03:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608778916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KPLnodcrwUN4GMfm5lbPHRru+qvn7V5IOIP88OOpGr0=;
        b=WtmqsqypWSbXQFNMVthszusaYm3LudVTfAQ67ouXttvqoN6qFT4SLLVrJQzvarbfJXLLKe
        TU9iiJlvqQy4vm0J7AT+cnM7rpkg9/hu23S6IAmT/R2QXk9nto7tdD9gC0uHvMDCqMtD8K
        3whqIoc36aQSucOspop81Egg8hRVZiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-hnOO6NEUNoWhHY2GPPNmnA-1; Wed, 23 Dec 2020 22:01:52 -0500
X-MC-Unique: hnOO6NEUNoWhHY2GPPNmnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8D9E1005513;
        Thu, 24 Dec 2020 03:01:50 +0000 (UTC)
Received: from [10.72.13.109] (ovpn-13-109.pek2.redhat.com [10.72.13.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9871310023AD;
        Thu, 24 Dec 2020 03:01:35 +0000 (UTC)
Subject: Re: [RFC v2 06/13] vduse: Introduce VDUSE - vDPA Device in Userspace
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
 <20201222145221.711-7-xieyongji@bytedance.com>
 <468be90d-1d98-c819-5492-32a2152d2e36@redhat.com>
 <CACycT3vYb_CdWz3wZ1OY=KynG=1qZgaa_Ngko2AO0JHn_fFXEA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <26ea3a3d-b06b-6256-7243-8ca9eae61bce@redhat.com>
Date:   Thu, 24 Dec 2020 11:01:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vYb_CdWz3wZ1OY=KynG=1qZgaa_Ngko2AO0JHn_fFXEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/23 下午10:17, Yongji Xie wrote:
> On Wed, Dec 23, 2020 at 4:08 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2020/12/22 下午10:52, Xie Yongji wrote:
>>> This VDUSE driver enables implementing vDPA devices in userspace.
>>> Both control path and data path of vDPA devices will be able to
>>> be handled in userspace.
>>>
>>> In the control path, the VDUSE driver will make use of message
>>> mechnism to forward the config operation from vdpa bus driver
>>> to userspace. Userspace can use read()/write() to receive/reply
>>> those control messages.
>>>
>>> In the data path, the VDUSE driver implements a MMU-based on-chip
>>> IOMMU driver which supports mapping the kernel dma buffer to a
>>> userspace iova region dynamically. Userspace can access those
>>> iova region via mmap(). Besides, the eventfd mechanism is used to
>>> trigger interrupt callbacks and receive virtqueue kicks in userspace
>>>
>>> Now we only support virtio-vdpa bus driver with this patch applied.
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> ---
>>>    Documentation/driver-api/vduse.rst                 |   74 ++
>>>    Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>>>    drivers/vdpa/Kconfig                               |    8 +
>>>    drivers/vdpa/Makefile                              |    1 +
>>>    drivers/vdpa/vdpa_user/Makefile                    |    5 +
>>>    drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
>>>    drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
>>>    drivers/vdpa/vdpa_user/iova_domain.c               |  442 ++++++++
>>>    drivers/vdpa/vdpa_user/iova_domain.h               |   93 ++
>>>    drivers/vdpa/vdpa_user/vduse.h                     |   59 ++
>>>    drivers/vdpa/vdpa_user/vduse_dev.c                 | 1121 ++++++++++++++++++++
>>>    include/uapi/linux/vdpa.h                          |    1 +
>>>    include/uapi/linux/vduse.h                         |   99 ++
>>>    13 files changed, 2173 insertions(+)
>>>    create mode 100644 Documentation/driver-api/vduse.rst
>>>    create mode 100644 drivers/vdpa/vdpa_user/Makefile
>>>    create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
>>>    create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
>>>    create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>>>    create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>>>    create mode 100644 drivers/vdpa/vdpa_user/vduse.h
>>>    create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>>>    create mode 100644 include/uapi/linux/vduse.h
>>>
>>> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
>>> new file mode 100644
>>> index 000000000000..da9b3040f20a
>>> --- /dev/null
>>> +++ b/Documentation/driver-api/vduse.rst
>>> @@ -0,0 +1,74 @@
>>> +==================================
>>> +VDUSE - "vDPA Device in Userspace"
>>> +==================================
>>> +
>>> +vDPA (virtio data path acceleration) device is a device that uses a
>>> +datapath which complies with the virtio specifications with vendor
>>> +specific control path. vDPA devices can be both physically located on
>>> +the hardware or emulated by software. VDUSE is a framework that makes it
>>> +possible to implement software-emulated vDPA devices in userspace.
>>> +
>>> +How VDUSE works
>>> +------------
>>> +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
>>> +the VDUSE character device (/dev/vduse). Then a file descriptor pointing
>>> +to the new resources will be returned, which can be used to implement the
>>> +userspace vDPA device's control path and data path.
>>> +
>>> +To implement control path, the read/write operations to the file descriptor
>>> +will be used to receive/reply the control messages from/to VDUSE driver.
>>> +Those control messages are based on the vdpa_config_ops which defines a
>>> +unified interface to control different types of vDPA device.
>>> +
>>> +The following types of messages are provided by the VDUSE framework now:
>>> +
>>> +- VDUSE_SET_VQ_ADDR: Set the addresses of the different aspects of virtqueue.
>>> +
>>> +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
>>> +
>>> +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
>>> +
>>> +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
>>> +
>>> +- VDUSE_SET_FEATURES: Set virtio features supported by the driver
>>> +
>>> +- VDUSE_GET_FEATURES: Get virtio features supported by the device
>>> +
>>> +- VDUSE_SET_STATUS: Set the device status
>>> +
>>> +- VDUSE_GET_STATUS: Get the device status
>>> +
>>> +- VDUSE_SET_CONFIG: Write to device specific configuration space
>>> +
>>> +- VDUSE_GET_CONFIG: Read from device specific configuration space
>>> +
>>> +Please see include/linux/vdpa.h for details.
>>> +
>>> +In the data path, VDUSE framework implements a MMU-based on-chip IOMMU
>>> +driver which supports mapping the kernel dma buffer to a userspace iova
>>> +region dynamically. The userspace iova region can be created by passing
>>> +the userspace vDPA device fd to mmap(2).
>>> +
>>> +Besides, the eventfd mechanism is used to trigger interrupt callbacks and
>>> +receive virtqueue kicks in userspace. The following ioctls on the userspace
>>> +vDPA device fd are provided to support that:
>>> +
>>> +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is used
>>> +  by VDUSE driver to notify userspace to consume the vring.
>>> +
>>> +- VDUSE_VQ_SETUP_IRQFD: set the irqfd for virtqueue, this eventfd is used
>>> +  by userspace to notify VDUSE driver to trigger interrupt callbacks.
>>> +
>>> +MMU-based IOMMU Driver
>>> +----------------------
>>> +The basic idea behind the IOMMU driver is treating MMU (VA->PA) as
>>> +IOMMU (IOVA->PA). This driver will set up MMU mapping instead of IOMMU mapping
>>> +for the DMA transfer so that the userspace process is able to use its virtual
>>> +address to access the dma buffer in kernel.
>>> +
>>> +And to avoid security issue, a bounce-buffering mechanism is introduced to
>>> +prevent userspace accessing the original buffer directly which may contain other
>>> +kernel data. During the mapping, unmapping, the driver will copy the data from
>>> +the original buffer to the bounce buffer and back, depending on the direction of
>>> +the transfer. And the bounce-buffer addresses will be mapped into the user address
>>> +space instead of the original one.
>>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> index a4c75a28c839..71722e6f8f23 100644
>>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> @@ -300,6 +300,7 @@ Code  Seq#    Include File                                           Comments
>>>    'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                        conflict!
>>>    '|'   00-7F  linux/media.h
>>>    0x80  00-1F  linux/fb.h
>>> +0x81  00-1F  linux/vduse.h
>>>    0x89  00-06  arch/x86/include/asm/sockios.h
>>>    0x89  0B-DF  linux/sockios.h
>>>    0x89  E0-EF  linux/sockios.h                                         SIOCPROTOPRIVATE range
>>> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
>>> index 4be7be39be26..211cc449cbd3 100644
>>> --- a/drivers/vdpa/Kconfig
>>> +++ b/drivers/vdpa/Kconfig
>>> @@ -21,6 +21,14 @@ config VDPA_SIM
>>>          to RX. This device is used for testing, prototyping and
>>>          development of vDPA.
>>>
>>> +config VDPA_USER
>>> +     tristate "VDUSE (vDPA Device in Userspace) support"
>>> +     depends on EVENTFD && MMU && HAS_DMA
>>> +     default n
>>
>> The "default n" is not necessary.
>>
> OK.
>>> +     help
>>> +       With VDUSE it is possible to emulate a vDPA Device
>>> +       in a userspace program.
>>> +
>>>    config IFCVF
>>>        tristate "Intel IFC VF vDPA driver"
>>>        depends on PCI_MSI
>>> diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
>>> index d160e9b63a66..66e97778ad03 100644
>>> --- a/drivers/vdpa/Makefile
>>> +++ b/drivers/vdpa/Makefile
>>> @@ -1,5 +1,6 @@
>>>    # SPDX-License-Identifier: GPL-2.0
>>>    obj-$(CONFIG_VDPA) += vdpa.o
>>>    obj-$(CONFIG_VDPA_SIM) += vdpa_sim/
>>> +obj-$(CONFIG_VDPA_USER) += vdpa_user/
>>>    obj-$(CONFIG_IFCVF)    += ifcvf/
>>>    obj-$(CONFIG_MLX5_VDPA) += mlx5/
>>> diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user/Makefile
>>> new file mode 100644
>>> index 000000000000..b7645e36992b
>>> --- /dev/null
>>> +++ b/drivers/vdpa/vdpa_user/Makefile
>>> @@ -0,0 +1,5 @@
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +
>>> +vduse-y := vduse_dev.o iova_domain.o eventfd.o
>>
>> Do we really need eventfd.o here consider we've selected it.
>>
> Do you mean the file "drivers/vdpa/vdpa_user/eventfd.c"?


My bad, I confuse this with the common eventfd. So the code is fine here.


>
>>> +
>>> +obj-$(CONFIG_VDPA_USER) += vduse.o
>>> diff --git a/drivers/vdpa/vdpa_user/eventfd.c b/drivers/vdpa/vdpa_user/eventfd.c
>>> new file mode 100644
>>> index 000000000000..dbffddb08908
>>> --- /dev/null
>>> +++ b/drivers/vdpa/vdpa_user/eventfd.c
>>> @@ -0,0 +1,221 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Eventfd support for VDUSE
>>> + *
>>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
>>> + *
>>> + * Author: Xie Yongji <xieyongji@bytedance.com>
>>> + *
>>> + */
>>> +
>>> +#include <linux/eventfd.h>
>>> +#include <linux/poll.h>
>>> +#include <linux/wait.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/file.h>
>>> +#include <uapi/linux/vduse.h>
>>> +
>>> +#include "eventfd.h"
>>> +
>>> +static struct workqueue_struct *vduse_irqfd_cleanup_wq;
>>> +
>>> +static void vduse_virqfd_shutdown(struct work_struct *work)
>>> +{
>>> +     u64 cnt;
>>> +     struct vduse_virqfd *virqfd = container_of(work,
>>> +                                     struct vduse_virqfd, shutdown);
>>> +
>>> +     eventfd_ctx_remove_wait_queue(virqfd->ctx, &virqfd->wait, &cnt);
>>> +     flush_work(&virqfd->inject);
>>> +     eventfd_ctx_put(virqfd->ctx);
>>> +     kfree(virqfd);
>>> +}
>>> +
>>> +static void vduse_virqfd_inject(struct work_struct *work)
>>> +{
>>> +     struct vduse_virqfd *virqfd = container_of(work,
>>> +                                     struct vduse_virqfd, inject);
>>> +     struct vduse_virtqueue *vq = virqfd->vq;
>>> +
>>> +     spin_lock_irq(&vq->irq_lock);
>>> +     if (vq->ready && vq->cb)
>>> +             vq->cb(vq->private);
>>> +     spin_unlock_irq(&vq->irq_lock);
>>> +}
>>> +
>>> +static void virqfd_deactivate(struct vduse_virqfd *virqfd)
>>> +{
>>> +     queue_work(vduse_irqfd_cleanup_wq, &virqfd->shutdown);
>>> +}
>>> +
>>> +static int vduse_virqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
>>> +                             int sync, void *key)
>>> +{
>>> +     struct vduse_virqfd *virqfd = container_of(wait, struct vduse_virqfd, wait);
>>> +     struct vduse_virtqueue *vq = virqfd->vq;
>>> +
>>> +     __poll_t flags = key_to_poll(key);
>>> +
>>> +     if (flags & EPOLLIN)
>>> +             schedule_work(&virqfd->inject);
>>> +
>>> +     if (flags & EPOLLHUP) {
>>> +             spin_lock(&vq->irq_lock);
>>> +             if (vq->virqfd == virqfd) {
>>> +                     vq->virqfd = NULL;
>>> +                     virqfd_deactivate(virqfd);
>>> +             }
>>> +             spin_unlock(&vq->irq_lock);
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static void vduse_virqfd_ptable_queue_proc(struct file *file,
>>> +                     wait_queue_head_t *wqh, poll_table *pt)
>>> +{
>>> +     struct vduse_virqfd *virqfd = container_of(pt, struct vduse_virqfd, pt);
>>> +
>>> +     add_wait_queue(wqh, &virqfd->wait);
>>> +}
>>> +
>>> +int vduse_virqfd_setup(struct vduse_dev *dev,
>>> +                     struct vduse_vq_eventfd *eventfd)
>>> +{
>>> +     struct vduse_virqfd *virqfd;
>>> +     struct fd irqfd;
>>> +     struct eventfd_ctx *ctx;
>>> +     struct vduse_virtqueue *vq;
>>> +     __poll_t events;
>>> +     int ret;
>>> +
>>> +     if (eventfd->index >= dev->vq_num)
>>> +             return -EINVAL;
>>> +
>>> +     vq = &dev->vqs[eventfd->index];
>>> +     virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
>>> +     if (!virqfd)
>>> +             return -ENOMEM;
>>> +
>>> +     INIT_WORK(&virqfd->shutdown, vduse_virqfd_shutdown);
>>> +     INIT_WORK(&virqfd->inject, vduse_virqfd_inject);
>>
>> Any reason that a workqueue is must here?
>>
> Mainly for performance considerations. Make sure the push() and pop()
> for used vring can be asynchronous.


I see.


>
>>> +
>>> +     ret = -EBADF;
>>> +     irqfd = fdget(eventfd->fd);
>>> +     if (!irqfd.file)
>>> +             goto err_fd;
>>> +
>>> +     ctx = eventfd_ctx_fileget(irqfd.file);
>>> +     if (IS_ERR(ctx)) {
>>> +             ret = PTR_ERR(ctx);
>>> +             goto err_ctx;
>>> +     }
>>> +
>>> +     virqfd->vq = vq;
>>> +     virqfd->ctx = ctx;
>>> +     spin_lock(&vq->irq_lock);
>>> +     if (vq->virqfd)
>>> +             virqfd_deactivate(virqfd);
>>> +     vq->virqfd = virqfd;
>>> +     spin_unlock(&vq->irq_lock);
>>> +
>>> +     init_waitqueue_func_entry(&virqfd->wait, vduse_virqfd_wakeup);
>>> +     init_poll_funcptr(&virqfd->pt, vduse_virqfd_ptable_queue_proc);
>>> +
>>> +     events = vfs_poll(irqfd.file, &virqfd->pt);
>>> +
>>> +     /*
>>> +      * Check if there was an event already pending on the eventfd
>>> +      * before we registered and trigger it as if we didn't miss it.
>>> +      */
>>> +     if (events & EPOLLIN)
>>> +             schedule_work(&virqfd->inject);
>>> +
>>> +     fdput(irqfd);
>>> +
>>> +     return 0;
>>> +err_ctx:
>>> +     fdput(irqfd);
>>> +err_fd:
>>> +     kfree(virqfd);
>>> +     return ret;
>>> +}
>>> +
>>> +void vduse_virqfd_release(struct vduse_dev *dev)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < dev->vq_num; i++) {
>>> +             struct vduse_virtqueue *vq = &dev->vqs[i];
>>> +
>>> +             spin_lock(&vq->irq_lock);
>>> +             if (vq->virqfd) {
>>> +                     virqfd_deactivate(vq->virqfd);
>>> +                     vq->virqfd = NULL;
>>> +             }
>>> +             spin_unlock(&vq->irq_lock);
>>> +     }
>>> +     flush_workqueue(vduse_irqfd_cleanup_wq);
>>> +}
>>> +
>>> +int vduse_virqfd_init(void)
>>> +{
>>> +     vduse_irqfd_cleanup_wq = alloc_workqueue("vduse-irqfd-cleanup",
>>> +                                             WQ_UNBOUND, 0);
>>> +     if (!vduse_irqfd_cleanup_wq)
>>> +             return -ENOMEM;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +void vduse_virqfd_exit(void)
>>> +{
>>> +     destroy_workqueue(vduse_irqfd_cleanup_wq);
>>> +}
>>> +
>>> +void vduse_vq_kick(struct vduse_virtqueue *vq)
>>> +{
>>> +     spin_lock(&vq->kick_lock);
>>> +     if (vq->ready && vq->kickfd)
>>> +             eventfd_signal(vq->kickfd, 1);
>>> +     spin_unlock(&vq->kick_lock);
>>> +}
>>> +
>>> +int vduse_kickfd_setup(struct vduse_dev *dev,
>>> +                     struct vduse_vq_eventfd *eventfd)
>>> +{
>>> +     struct eventfd_ctx *ctx;
>>> +     struct vduse_virtqueue *vq;
>>> +
>>> +     if (eventfd->index >= dev->vq_num)
>>> +             return -EINVAL;
>>> +
>>> +     vq = &dev->vqs[eventfd->index];
>>> +     ctx = eventfd_ctx_fdget(eventfd->fd);
>>> +     if (IS_ERR(ctx))
>>> +             return PTR_ERR(ctx);
>>> +
>>> +     spin_lock(&vq->kick_lock);
>>> +     if (vq->kickfd)
>>> +             eventfd_ctx_put(vq->kickfd);
>>> +     vq->kickfd = ctx;
>>> +     spin_unlock(&vq->kick_lock);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +void vduse_kickfd_release(struct vduse_dev *dev)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < dev->vq_num; i++) {
>>> +             struct vduse_virtqueue *vq = &dev->vqs[i];
>>> +
>>> +             spin_lock(&vq->kick_lock);
>>> +             if (vq->kickfd) {
>>> +                     eventfd_ctx_put(vq->kickfd);
>>> +                     vq->kickfd = NULL;
>>> +             }
>>> +             spin_unlock(&vq->kick_lock);
>>> +     }
>>> +}
>>> diff --git a/drivers/vdpa/vdpa_user/eventfd.h b/drivers/vdpa/vdpa_user/eventfd.h
>>> new file mode 100644
>>> index 000000000000..14269ff27f47
>>> --- /dev/null
>>> +++ b/drivers/vdpa/vdpa_user/eventfd.h
>>> @@ -0,0 +1,48 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/*
>>> + * Eventfd support for VDUSE
>>> + *
>>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
>>> + *
>>> + * Author: Xie Yongji <xieyongji@bytedance.com>
>>> + *
>>> + */
>>> +
>>> +#ifndef _VDUSE_EVENTFD_H
>>> +#define _VDUSE_EVENTFD_H
>>> +
>>> +#include <linux/eventfd.h>
>>> +#include <linux/poll.h>
>>> +#include <linux/wait.h>
>>> +#include <uapi/linux/vduse.h>
>>> +
>>> +#include "vduse.h"
>>> +
>>> +struct vduse_dev;
>>> +
>>> +struct vduse_virqfd {
>>> +     struct eventfd_ctx *ctx;
>>> +     struct vduse_virtqueue *vq;
>>> +     struct work_struct inject;
>>> +     struct work_struct shutdown;
>>> +     wait_queue_entry_t wait;
>>> +     poll_table pt;
>>> +};
>>> +
>>> +int vduse_virqfd_setup(struct vduse_dev *dev,
>>> +                     struct vduse_vq_eventfd *eventfd);
>>> +
>>> +void vduse_virqfd_release(struct vduse_dev *dev);
>>> +
>>> +int vduse_virqfd_init(void);
>>> +
>>> +void vduse_virqfd_exit(void);
>>> +
>>> +void vduse_vq_kick(struct vduse_virtqueue *vq);
>>> +
>>> +int vduse_kickfd_setup(struct vduse_dev *dev,
>>> +                     struct vduse_vq_eventfd *eventfd);
>>> +
>>> +void vduse_kickfd_release(struct vduse_dev *dev);
>>> +
>>> +#endif /* _VDUSE_EVENTFD_H */
>>> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
>>> new file mode 100644
>>> index 000000000000..27022157abc6
>>> --- /dev/null
>>> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
>>> @@ -0,0 +1,442 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * MMU-based IOMMU implementation
>>> + *
>>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
>>> + *
>>> + * Author: Xie Yongji <xieyongji@bytedance.com>
>>> + *
>>> + */
>>> +
>>> +#include <linux/wait.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/genalloc.h>
>>> +#include <linux/dma-mapping.h>
>>> +
>>> +#include "iova_domain.h"
>>> +
>>> +#define IOVA_CHUNK_SHIFT 26
>>> +#define IOVA_CHUNK_SIZE (_AC(1, UL) << IOVA_CHUNK_SHIFT)
>>> +#define IOVA_CHUNK_MASK (~(IOVA_CHUNK_SIZE - 1))
>>> +
>>> +#define IOVA_MIN_SIZE (IOVA_CHUNK_SIZE << 1)
>>> +
>>> +#define IOVA_ALLOC_ORDER 12
>>> +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
>>> +
>>> +struct vduse_mmap_vma {
>>> +     struct vm_area_struct *vma;
>>> +     struct list_head list;
>>> +};
>>> +
>>> +static inline struct page *
>>> +vduse_domain_get_bounce_page(struct vduse_iova_domain *domain,
>>> +                             unsigned long iova)
>>> +{
>>> +     unsigned long index = iova >> IOVA_CHUNK_SHIFT;
>>> +     unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
>>> +     unsigned long pgindex = chunkoff >> PAGE_SHIFT;
>>> +
>>> +     return domain->chunks[index].bounce_pages[pgindex];
>>> +}
>>> +
>>> +static inline void
>>> +vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
>>> +                             unsigned long iova, struct page *page)
>>> +{
>>> +     unsigned long index = iova >> IOVA_CHUNK_SHIFT;
>>> +     unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
>>> +     unsigned long pgindex = chunkoff >> PAGE_SHIFT;
>>> +
>>> +     domain->chunks[index].bounce_pages[pgindex] = page;
>>> +}
>>> +
>>> +static inline struct vduse_iova_map *
>>> +vduse_domain_get_iova_map(struct vduse_iova_domain *domain,
>>> +                             unsigned long iova)
>>> +{
>>> +     unsigned long index = iova >> IOVA_CHUNK_SHIFT;
>>> +     unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
>>> +     unsigned long mapindex = chunkoff >> IOVA_ALLOC_ORDER;
>>> +
>>> +     return domain->chunks[index].iova_map[mapindex];
>>> +}
>>> +
>>> +static inline void
>>> +vduse_domain_set_iova_map(struct vduse_iova_domain *domain,
>>> +                     unsigned long iova, struct vduse_iova_map *map)
>>> +{
>>> +     unsigned long index = iova >> IOVA_CHUNK_SHIFT;
>>> +     unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
>>> +     unsigned long mapindex = chunkoff >> IOVA_ALLOC_ORDER;
>>> +
>>> +     domain->chunks[index].iova_map[mapindex] = map;
>>> +}
>>> +
>>> +static int
>>> +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain,
>>> +                             unsigned long iova, size_t size)
>>> +{
>>> +     struct page *page;
>>> +     size_t walk_sz = 0;
>>> +     int frees = 0;
>>> +
>>> +     while (walk_sz < size) {
>>> +             page = vduse_domain_get_bounce_page(domain, iova);
>>> +             if (page) {
>>> +                     vduse_domain_set_bounce_page(domain, iova, NULL);
>>> +                     put_page(page);
>>> +                     frees++;
>>> +             }
>>> +             iova += PAGE_SIZE;
>>> +             walk_sz += PAGE_SIZE;
>>> +     }
>>> +
>>> +     return frees;
>>> +}
>>> +
>>> +int vduse_domain_add_vma(struct vduse_iova_domain *domain,
>>> +                             struct vm_area_struct *vma)
>>> +{
>>> +     unsigned long size = vma->vm_end - vma->vm_start;
>>> +     struct vduse_mmap_vma *mmap_vma;
>>> +
>>> +     if (WARN_ON(size != domain->size))
>>> +             return -EINVAL;
>>> +
>>> +     mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
>>> +     if (!mmap_vma)
>>> +             return -ENOMEM;
>>> +
>>> +     mmap_vma->vma = vma;
>>> +     mutex_lock(&domain->vma_lock);
>>> +     list_add(&mmap_vma->list, &domain->vma_list);
>>> +     mutex_unlock(&domain->vma_lock);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +void vduse_domain_remove_vma(struct vduse_iova_domain *domain,
>>> +                             struct vm_area_struct *vma)
>>> +{
>>> +     struct vduse_mmap_vma *mmap_vma;
>>> +
>>> +     mutex_lock(&domain->vma_lock);
>>> +     list_for_each_entry(mmap_vma, &domain->vma_list, list) {
>>> +             if (mmap_vma->vma == vma) {
>>> +                     list_del(&mmap_vma->list);
>>> +                     kfree(mmap_vma);
>>> +                     break;
>>> +             }
>>> +     }
>>> +     mutex_unlock(&domain->vma_lock);
>>> +}
>>> +
>>> +int vduse_domain_add_mapping(struct vduse_iova_domain *domain,
>>> +                             unsigned long iova, unsigned long orig,
>>> +                             size_t size, enum dma_data_direction dir)
>>> +{
>>> +     struct vduse_iova_map *map;
>>> +     unsigned long last = iova + size;
>>> +
>>> +     map = kzalloc(sizeof(struct vduse_iova_map), GFP_ATOMIC);
>>> +     if (!map)
>>> +             return -ENOMEM;
>>> +
>>> +     map->iova = iova;
>>> +     map->orig = orig;
>>> +     map->size = size;
>>> +     map->dir = dir;
>>> +
>>> +     while (iova < last) {
>>> +             vduse_domain_set_iova_map(domain, iova, map);
>>> +             iova += IOVA_ALLOC_SIZE;
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +struct vduse_iova_map *
>>> +vduse_domain_get_mapping(struct vduse_iova_domain *domain,
>>> +                     unsigned long iova)
>>> +{
>>> +     return vduse_domain_get_iova_map(domain, iova);
>>> +}
>>> +
>>> +void vduse_domain_remove_mapping(struct vduse_iova_domain *domain,
>>> +                             struct vduse_iova_map *map)
>>> +{
>>> +     unsigned long iova = map->iova;
>>> +     unsigned long last = iova + map->size;
>>> +
>>> +     while (iova < last) {
>>> +             vduse_domain_set_iova_map(domain, iova, NULL);
>>> +             iova += IOVA_ALLOC_SIZE;
>>> +     }
>>> +}
>>> +
>>> +void vduse_domain_unmap(struct vduse_iova_domain *domain,
>>> +                     unsigned long iova, size_t size)
>>> +{
>>> +     struct vduse_mmap_vma *mmap_vma;
>>> +     unsigned long uaddr;
>>> +
>>> +     mutex_lock(&domain->vma_lock);
>>> +     list_for_each_entry(mmap_vma, &domain->vma_list, list) {
>>> +             mmap_read_lock(mmap_vma->vma->vm_mm);
>>> +             uaddr = iova + mmap_vma->vma->vm_start;
>>> +             zap_page_range(mmap_vma->vma, uaddr, size);
>>> +             mmap_read_unlock(mmap_vma->vma->vm_mm);
>>> +     }
>>> +     mutex_unlock(&domain->vma_lock);
>>> +}
>>> +
>>> +int vduse_domain_direct_map(struct vduse_iova_domain *domain,
>>> +                     struct vm_area_struct *vma, unsigned long iova)
>>> +{
>>> +     unsigned long uaddr = iova + vma->vm_start;
>>> +     unsigned long start = iova & PAGE_MASK;
>>> +     unsigned long last = start + PAGE_SIZE - 1;
>>> +     unsigned long offset;
>>> +     struct vduse_iova_map *map;
>>> +     struct page *page = NULL;
>>> +
>>> +     map = vduse_domain_get_iova_map(domain, iova);
>>> +     if (map) {
>>> +             offset = last - map->iova;
>>> +             page = virt_to_page(map->orig + offset);
>>> +     }
>>> +
>>> +     return page ? vm_insert_page(vma, uaddr, page) : -EFAULT;
>>> +}
>>
>> So as we discussed before, we need to find way to make vhost work. And
>> it's better to make vhost transparent to VDUSE. One idea is to implement
>> shadow virtqueue here, that is, instead of trying to insert the pages to
>> VDUSE userspace, we use the shadow virtqueue to relay the descriptors to
>> userspace. With this, we don't need stuffs like shmfd etc.
>>
> Good idea! The disadvantage is performance will go down (one more
> thread switch overhead and vhost-liked kworker will become bottleneck
> without multi-thread support).


Yes, the disadvantage is the performance. But it should be simpler (I 
guess) and we know it can succeed.



> I think I can try this in v3. And the
> MMU-based IOMMU implementation can be a future optimization in the
> virtio-vdpa case. What's your opinion?


Maybe I was wrong, but I think we can try as what has been proposed here 
first and use shadow virtqueue as backup plan if we fail.


>
>>> +
>>> +void vduse_domain_bounce(struct vduse_iova_domain *domain,
>>> +                     unsigned long iova, unsigned long orig,
>>> +                     size_t size, enum dma_data_direction dir)
>>> +{
>>> +     unsigned int offset = offset_in_page(iova);
>>> +
>>> +     while (size) {
>>> +             struct page *p = vduse_domain_get_bounce_page(domain, iova);
>>> +             size_t copy_len = min_t(size_t, PAGE_SIZE - offset, size);
>>> +             void *addr;
>>> +
>>> +             if (p) {
>>> +                     addr = page_address(p) + offset;
>>> +                     if (dir == DMA_TO_DEVICE)
>>> +                             memcpy(addr, (void *)orig, copy_len);
>>> +                     else if (dir == DMA_FROM_DEVICE)
>>> +                             memcpy((void *)orig, addr, copy_len);
>>> +             }
>>
>> I think I miss something, for DMA_FROM_DEVICE, if p doesn't exist how is
>> it expected to work? Or do we need to warn here in this case?
>>
> Yes, I think we need a WARN_ON here.


Ok.


>
>
>>> +             size -= copy_len;
>>> +             orig += copy_len;
>>> +             iova += copy_len;
>>> +             offset = 0;
>>> +     }
>>> +}
>>> +
>>> +int vduse_domain_bounce_map(struct vduse_iova_domain *domain,
>>> +                     struct vm_area_struct *vma, unsigned long iova)
>>> +{
>>> +     unsigned long uaddr = iova + vma->vm_start;
>>> +     unsigned long start = iova & PAGE_MASK;
>>> +     unsigned long offset = 0;
>>> +     bool found = false;
>>> +     struct vduse_iova_map *map;
>>> +     struct page *page;
>>> +
>>> +     mutex_lock(&domain->map_lock);
>>> +
>>> +     page = vduse_domain_get_bounce_page(domain, iova);
>>> +     if (page)
>>> +             goto unlock;
>>> +
>>> +     page = alloc_page(GFP_KERNEL);
>>> +     if (!page)
>>> +             goto unlock;
>>> +
>>> +     while (offset < PAGE_SIZE) {
>>> +             unsigned int src_offset = 0, dst_offset = 0;
>>> +             void *src, *dst;
>>> +             size_t copy_len;
>>> +
>>> +             map = vduse_domain_get_iova_map(domain, start + offset);
>>> +             if (!map) {
>>> +                     offset += IOVA_ALLOC_SIZE;
>>> +                     continue;
>>> +             }
>>> +
>>> +             found = true;
>>> +             offset += map->size;
>>> +             if (map->dir == DMA_FROM_DEVICE)
>>> +                     continue;
>>> +
>>> +             if (start > map->iova)
>>> +                     src_offset = start - map->iova;
>>> +             else
>>> +                     dst_offset = map->iova - start;
>>> +
>>> +             src = (void *)(map->orig + src_offset);
>>> +             dst = page_address(page) + dst_offset;
>>> +             copy_len = min_t(size_t, map->size - src_offset,
>>> +                             PAGE_SIZE - dst_offset);
>>> +             memcpy(dst, src, copy_len);
>>> +     }
>>> +     if (!found) {
>>> +             put_page(page);
>>> +             page = NULL;
>>> +     }
>>> +     vduse_domain_set_bounce_page(domain, iova, page);
>>> +unlock:
>>> +     mutex_unlock(&domain->map_lock);
>>> +
>>> +     return page ? vm_insert_page(vma, uaddr, page) : -EFAULT;
>>> +}
>>> +
>>> +bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
>>> +                             unsigned long iova)
>>> +{
>>> +     unsigned long index = iova >> IOVA_CHUNK_SHIFT;
>>> +     struct vduse_iova_chunk *chunk = &domain->chunks[index];
>>> +
>>> +     return atomic_read(&chunk->map_type) == TYPE_DIRECT_MAP;
>>> +}
>>> +
>>> +unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *domain,
>>> +                                     size_t size, enum iova_map_type type)
>>> +{
>>> +     struct vduse_iova_chunk *chunk;
>>> +     unsigned long iova = 0;
>>> +     int align = (type == TYPE_DIRECT_MAP) ? PAGE_SIZE : IOVA_ALLOC_SIZE;
>>> +     struct genpool_data_align data = { .align = align };
>>> +     int i;
>>> +
>>> +     for (i = 0; i < domain->chunk_num; i++) {
>>> +             chunk = &domain->chunks[i];
>>> +             if (unlikely(atomic_read(&chunk->map_type) == TYPE_NONE))
>>> +                     atomic_cmpxchg(&chunk->map_type, TYPE_NONE, type);
>>> +
>>> +             if (atomic_read(&chunk->map_type) != type)
>>> +                     continue;
>>> +
>>> +             iova = gen_pool_alloc_algo(chunk->pool, size,
>>> +                                     gen_pool_first_fit_align, &data);
>>> +             if (iova)
>>> +                     break;
>>> +     }
>>> +
>>> +     return iova;
>>
>> I wonder why not just reuse the iova domain implements in
>> driver/iommu/iova.c
>>
> The iova domain in driver/iommu/iova.c is only an iova allocator which
> is implemented by the genpool memory allocator in our case. The other
> part in our iova domain is chunk management and iova_map management.
> We need different chunks to distinguish different dma mapping types:
> consistent mapping or streaming mapping. We can only use
> bouncing-mechanism in the streaming mapping case.


To differ dma mappings, you can use two iova domains with different 
ranges. It looks simpler than the gen_pool. (AFAIK most IOMMU driver is 
using iova domain).

Thanks

