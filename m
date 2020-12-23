Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F84E2E19AC
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbgLWIKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:10:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728093AbgLWIKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 03:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608710918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wUF409s0Z09LuYxcinNf3kQJcw3v3/i6P20S+VZzJLk=;
        b=MTC+aJzy3bSSCkPEdajN/w6rVh5cBfkI6Rb/IsTw8v/H5aBtVKlziBDrzcnV9b41hHcMf2
        EdTLgtNtx0Hi9sVTN+KtsJhZauGoVR+ADVQoMqVcHUCHTte7Q54ZiehHE5msqwmsuQ94fz
        6XxiBqhAEb/M/h6JPX9gtSj5oV9CZeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-shy3aBkTOkKXw6Sk8zMHQQ-1; Wed, 23 Dec 2020 03:08:34 -0500
X-MC-Unique: shy3aBkTOkKXw6Sk8zMHQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 076561800D42;
        Wed, 23 Dec 2020 08:08:32 +0000 (UTC)
Received: from [10.72.12.54] (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10C6F19725;
        Wed, 23 Dec 2020 08:08:18 +0000 (UTC)
Subject: Re: [RFC v2 06/13] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        akpm@linux-foundation.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <20201222145221.711-7-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <468be90d-1d98-c819-5492-32a2152d2e36@redhat.com>
Date:   Wed, 23 Dec 2020 16:08:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201222145221.711-7-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/22 下午10:52, Xie Yongji wrote:
> This VDUSE driver enables implementing vDPA devices in userspace.
> Both control path and data path of vDPA devices will be able to
> be handled in userspace.
>
> In the control path, the VDUSE driver will make use of message
> mechnism to forward the config operation from vdpa bus driver
> to userspace. Userspace can use read()/write() to receive/reply
> those control messages.
>
> In the data path, the VDUSE driver implements a MMU-based on-chip
> IOMMU driver which supports mapping the kernel dma buffer to a
> userspace iova region dynamically. Userspace can access those
> iova region via mmap(). Besides, the eventfd mechanism is used to
> trigger interrupt callbacks and receive virtqueue kicks in userspace
>
> Now we only support virtio-vdpa bus driver with this patch applied.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   Documentation/driver-api/vduse.rst                 |   74 ++
>   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>   drivers/vdpa/Kconfig                               |    8 +
>   drivers/vdpa/Makefile                              |    1 +
>   drivers/vdpa/vdpa_user/Makefile                    |    5 +
>   drivers/vdpa/vdpa_user/eventfd.c                   |  221 ++++
>   drivers/vdpa/vdpa_user/eventfd.h                   |   48 +
>   drivers/vdpa/vdpa_user/iova_domain.c               |  442 ++++++++
>   drivers/vdpa/vdpa_user/iova_domain.h               |   93 ++
>   drivers/vdpa/vdpa_user/vduse.h                     |   59 ++
>   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1121 ++++++++++++++++++++
>   include/uapi/linux/vdpa.h                          |    1 +
>   include/uapi/linux/vduse.h                         |   99 ++
>   13 files changed, 2173 insertions(+)
>   create mode 100644 Documentation/driver-api/vduse.rst
>   create mode 100644 drivers/vdpa/vdpa_user/Makefile
>   create mode 100644 drivers/vdpa/vdpa_user/eventfd.c
>   create mode 100644 drivers/vdpa/vdpa_user/eventfd.h
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>   create mode 100644 drivers/vdpa/vdpa_user/vduse.h
>   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>   create mode 100644 include/uapi/linux/vduse.h
>
> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-api/vduse.rst
> new file mode 100644
> index 000000000000..da9b3040f20a
> --- /dev/null
> +++ b/Documentation/driver-api/vduse.rst
> @@ -0,0 +1,74 @@
> +==================================
> +VDUSE - "vDPA Device in Userspace"
> +==================================
> +
> +vDPA (virtio data path acceleration) device is a device that uses a
> +datapath which complies with the virtio specifications with vendor
> +specific control path. vDPA devices can be both physically located on
> +the hardware or emulated by software. VDUSE is a framework that makes it
> +possible to implement software-emulated vDPA devices in userspace.
> +
> +How VDUSE works
> +------------
> +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> +the VDUSE character device (/dev/vduse). Then a file descriptor pointing
> +to the new resources will be returned, which can be used to implement the
> +userspace vDPA device's control path and data path.
> +
> +To implement control path, the read/write operations to the file descriptor
> +will be used to receive/reply the control messages from/to VDUSE driver.
> +Those control messages are based on the vdpa_config_ops which defines a
> +unified interface to control different types of vDPA device.
> +
> +The following types of messages are provided by the VDUSE framework now:
> +
> +- VDUSE_SET_VQ_ADDR: Set the addresses of the different aspects of virtqueue.
> +
> +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
> +
> +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
> +
> +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
> +
> +- VDUSE_SET_FEATURES: Set virtio features supported by the driver
> +
> +- VDUSE_GET_FEATURES: Get virtio features supported by the device
> +
> +- VDUSE_SET_STATUS: Set the device status
> +
> +- VDUSE_GET_STATUS: Get the device status
> +
> +- VDUSE_SET_CONFIG: Write to device specific configuration space
> +
> +- VDUSE_GET_CONFIG: Read from device specific configuration space
> +
> +Please see include/linux/vdpa.h for details.
> +
> +In the data path, VDUSE framework implements a MMU-based on-chip IOMMU
> +driver which supports mapping the kernel dma buffer to a userspace iova
> +region dynamically. The userspace iova region can be created by passing
> +the userspace vDPA device fd to mmap(2).
> +
> +Besides, the eventfd mechanism is used to trigger interrupt callbacks and
> +receive virtqueue kicks in userspace. The following ioctls on the userspace
> +vDPA device fd are provided to support that:
> +
> +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is used
> +  by VDUSE driver to notify userspace to consume the vring.
> +
> +- VDUSE_VQ_SETUP_IRQFD: set the irqfd for virtqueue, this eventfd is used
> +  by userspace to notify VDUSE driver to trigger interrupt callbacks.
> +
> +MMU-based IOMMU Driver
> +----------------------
> +The basic idea behind the IOMMU driver is treating MMU (VA->PA) as
> +IOMMU (IOVA->PA). This driver will set up MMU mapping instead of IOMMU mapping
> +for the DMA transfer so that the userspace process is able to use its virtual
> +address to access the dma buffer in kernel.
> +
> +And to avoid security issue, a bounce-buffering mechanism is introduced to
> +prevent userspace accessing the original buffer directly which may contain other
> +kernel data. During the mapping, unmapping, the driver will copy the data from
> +the original buffer to the bounce buffer and back, depending on the direction of
> +the transfer. And the bounce-buffer addresses will be mapped into the user address
> +space instead of the original one.
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index a4c75a28c839..71722e6f8f23 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -300,6 +300,7 @@ Code  Seq#    Include File                                           Comments
>   'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                        conflict!
>   '|'   00-7F  linux/media.h
>   0x80  00-1F  linux/fb.h
> +0x81  00-1F  linux/vduse.h
>   0x89  00-06  arch/x86/include/asm/sockios.h
>   0x89  0B-DF  linux/sockios.h
>   0x89  E0-EF  linux/sockios.h                                         SIOCPROTOPRIVATE range
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index 4be7be39be26..211cc449cbd3 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -21,6 +21,14 @@ config VDPA_SIM
>   	  to RX. This device is used for testing, prototyping and
>   	  development of vDPA.
>   
> +config VDPA_USER
> +	tristate "VDUSE (vDPA Device in Userspace) support"
> +	depends on EVENTFD && MMU && HAS_DMA
> +	default n


The "default n" is not necessary.


> +	help
> +	  With VDUSE it is possible to emulate a vDPA Device
> +	  in a userspace program.
> +
>   config IFCVF
>   	tristate "Intel IFC VF vDPA driver"
>   	depends on PCI_MSI
> diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> index d160e9b63a66..66e97778ad03 100644
> --- a/drivers/vdpa/Makefile
> +++ b/drivers/vdpa/Makefile
> @@ -1,5 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   obj-$(CONFIG_VDPA) += vdpa.o
>   obj-$(CONFIG_VDPA_SIM) += vdpa_sim/
> +obj-$(CONFIG_VDPA_USER) += vdpa_user/
>   obj-$(CONFIG_IFCVF)    += ifcvf/
>   obj-$(CONFIG_MLX5_VDPA) += mlx5/
> diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user/Makefile
> new file mode 100644
> index 000000000000..b7645e36992b
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +vduse-y := vduse_dev.o iova_domain.o eventfd.o


Do we really need eventfd.o here consider we've selected it.


> +
> +obj-$(CONFIG_VDPA_USER) += vduse.o
> diff --git a/drivers/vdpa/vdpa_user/eventfd.c b/drivers/vdpa/vdpa_user/eventfd.c
> new file mode 100644
> index 000000000000..dbffddb08908
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/eventfd.c
> @@ -0,0 +1,221 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Eventfd support for VDUSE
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#include <linux/eventfd.h>
> +#include <linux/poll.h>
> +#include <linux/wait.h>
> +#include <linux/slab.h>
> +#include <linux/file.h>
> +#include <uapi/linux/vduse.h>
> +
> +#include "eventfd.h"
> +
> +static struct workqueue_struct *vduse_irqfd_cleanup_wq;
> +
> +static void vduse_virqfd_shutdown(struct work_struct *work)
> +{
> +	u64 cnt;
> +	struct vduse_virqfd *virqfd = container_of(work,
> +					struct vduse_virqfd, shutdown);
> +
> +	eventfd_ctx_remove_wait_queue(virqfd->ctx, &virqfd->wait, &cnt);
> +	flush_work(&virqfd->inject);
> +	eventfd_ctx_put(virqfd->ctx);
> +	kfree(virqfd);
> +}
> +
> +static void vduse_virqfd_inject(struct work_struct *work)
> +{
> +	struct vduse_virqfd *virqfd = container_of(work,
> +					struct vduse_virqfd, inject);
> +	struct vduse_virtqueue *vq = virqfd->vq;
> +
> +	spin_lock_irq(&vq->irq_lock);
> +	if (vq->ready && vq->cb)
> +		vq->cb(vq->private);
> +	spin_unlock_irq(&vq->irq_lock);
> +}
> +
> +static void virqfd_deactivate(struct vduse_virqfd *virqfd)
> +{
> +	queue_work(vduse_irqfd_cleanup_wq, &virqfd->shutdown);
> +}
> +
> +static int vduse_virqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
> +				int sync, void *key)
> +{
> +	struct vduse_virqfd *virqfd = container_of(wait, struct vduse_virqfd, wait);
> +	struct vduse_virtqueue *vq = virqfd->vq;
> +
> +	__poll_t flags = key_to_poll(key);
> +
> +	if (flags & EPOLLIN)
> +		schedule_work(&virqfd->inject);
> +
> +	if (flags & EPOLLHUP) {
> +		spin_lock(&vq->irq_lock);
> +		if (vq->virqfd == virqfd) {
> +			vq->virqfd = NULL;
> +			virqfd_deactivate(virqfd);
> +		}
> +		spin_unlock(&vq->irq_lock);
> +	}
> +
> +	return 0;
> +}
> +
> +static void vduse_virqfd_ptable_queue_proc(struct file *file,
> +			wait_queue_head_t *wqh, poll_table *pt)
> +{
> +	struct vduse_virqfd *virqfd = container_of(pt, struct vduse_virqfd, pt);
> +
> +	add_wait_queue(wqh, &virqfd->wait);
> +}
> +
> +int vduse_virqfd_setup(struct vduse_dev *dev,
> +			struct vduse_vq_eventfd *eventfd)
> +{
> +	struct vduse_virqfd *virqfd;
> +	struct fd irqfd;
> +	struct eventfd_ctx *ctx;
> +	struct vduse_virtqueue *vq;
> +	__poll_t events;
> +	int ret;
> +
> +	if (eventfd->index >= dev->vq_num)
> +		return -EINVAL;
> +
> +	vq = &dev->vqs[eventfd->index];
> +	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
> +	if (!virqfd)
> +		return -ENOMEM;
> +
> +	INIT_WORK(&virqfd->shutdown, vduse_virqfd_shutdown);
> +	INIT_WORK(&virqfd->inject, vduse_virqfd_inject);


Any reason that a workqueue is must here?


> +
> +	ret = -EBADF;
> +	irqfd = fdget(eventfd->fd);
> +	if (!irqfd.file)
> +		goto err_fd;
> +
> +	ctx = eventfd_ctx_fileget(irqfd.file);
> +	if (IS_ERR(ctx)) {
> +		ret = PTR_ERR(ctx);
> +		goto err_ctx;
> +	}
> +
> +	virqfd->vq = vq;
> +	virqfd->ctx = ctx;
> +	spin_lock(&vq->irq_lock);
> +	if (vq->virqfd)
> +		virqfd_deactivate(virqfd);
> +	vq->virqfd = virqfd;
> +	spin_unlock(&vq->irq_lock);
> +
> +	init_waitqueue_func_entry(&virqfd->wait, vduse_virqfd_wakeup);
> +	init_poll_funcptr(&virqfd->pt, vduse_virqfd_ptable_queue_proc);
> +
> +	events = vfs_poll(irqfd.file, &virqfd->pt);
> +
> +	/*
> +	 * Check if there was an event already pending on the eventfd
> +	 * before we registered and trigger it as if we didn't miss it.
> +	 */
> +	if (events & EPOLLIN)
> +		schedule_work(&virqfd->inject);
> +
> +	fdput(irqfd);
> +
> +	return 0;
> +err_ctx:
> +	fdput(irqfd);
> +err_fd:
> +	kfree(virqfd);
> +	return ret;
> +}
> +
> +void vduse_virqfd_release(struct vduse_dev *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < dev->vq_num; i++) {
> +		struct vduse_virtqueue *vq = &dev->vqs[i];
> +
> +		spin_lock(&vq->irq_lock);
> +		if (vq->virqfd) {
> +			virqfd_deactivate(vq->virqfd);
> +			vq->virqfd = NULL;
> +		}
> +		spin_unlock(&vq->irq_lock);
> +	}
> +	flush_workqueue(vduse_irqfd_cleanup_wq);
> +}
> +
> +int vduse_virqfd_init(void)
> +{
> +	vduse_irqfd_cleanup_wq = alloc_workqueue("vduse-irqfd-cleanup",
> +						WQ_UNBOUND, 0);
> +	if (!vduse_irqfd_cleanup_wq)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +void vduse_virqfd_exit(void)
> +{
> +	destroy_workqueue(vduse_irqfd_cleanup_wq);
> +}
> +
> +void vduse_vq_kick(struct vduse_virtqueue *vq)
> +{
> +	spin_lock(&vq->kick_lock);
> +	if (vq->ready && vq->kickfd)
> +		eventfd_signal(vq->kickfd, 1);
> +	spin_unlock(&vq->kick_lock);
> +}
> +
> +int vduse_kickfd_setup(struct vduse_dev *dev,
> +			struct vduse_vq_eventfd *eventfd)
> +{
> +	struct eventfd_ctx *ctx;
> +	struct vduse_virtqueue *vq;
> +
> +	if (eventfd->index >= dev->vq_num)
> +		return -EINVAL;
> +
> +	vq = &dev->vqs[eventfd->index];
> +	ctx = eventfd_ctx_fdget(eventfd->fd);
> +	if (IS_ERR(ctx))
> +		return PTR_ERR(ctx);
> +
> +	spin_lock(&vq->kick_lock);
> +	if (vq->kickfd)
> +		eventfd_ctx_put(vq->kickfd);
> +	vq->kickfd = ctx;
> +	spin_unlock(&vq->kick_lock);
> +
> +	return 0;
> +}
> +
> +void vduse_kickfd_release(struct vduse_dev *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < dev->vq_num; i++) {
> +		struct vduse_virtqueue *vq = &dev->vqs[i];
> +
> +		spin_lock(&vq->kick_lock);
> +		if (vq->kickfd) {
> +			eventfd_ctx_put(vq->kickfd);
> +			vq->kickfd = NULL;
> +		}
> +		spin_unlock(&vq->kick_lock);
> +	}
> +}
> diff --git a/drivers/vdpa/vdpa_user/eventfd.h b/drivers/vdpa/vdpa_user/eventfd.h
> new file mode 100644
> index 000000000000..14269ff27f47
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/eventfd.h
> @@ -0,0 +1,48 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Eventfd support for VDUSE
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#ifndef _VDUSE_EVENTFD_H
> +#define _VDUSE_EVENTFD_H
> +
> +#include <linux/eventfd.h>
> +#include <linux/poll.h>
> +#include <linux/wait.h>
> +#include <uapi/linux/vduse.h>
> +
> +#include "vduse.h"
> +
> +struct vduse_dev;
> +
> +struct vduse_virqfd {
> +	struct eventfd_ctx *ctx;
> +	struct vduse_virtqueue *vq;
> +	struct work_struct inject;
> +	struct work_struct shutdown;
> +	wait_queue_entry_t wait;
> +	poll_table pt;
> +};
> +
> +int vduse_virqfd_setup(struct vduse_dev *dev,
> +			struct vduse_vq_eventfd *eventfd);
> +
> +void vduse_virqfd_release(struct vduse_dev *dev);
> +
> +int vduse_virqfd_init(void);
> +
> +void vduse_virqfd_exit(void);
> +
> +void vduse_vq_kick(struct vduse_virtqueue *vq);
> +
> +int vduse_kickfd_setup(struct vduse_dev *dev,
> +			struct vduse_vq_eventfd *eventfd);
> +
> +void vduse_kickfd_release(struct vduse_dev *dev);
> +
> +#endif /* _VDUSE_EVENTFD_H */
> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
> new file mode 100644
> index 000000000000..27022157abc6
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> @@ -0,0 +1,442 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * MMU-based IOMMU implementation
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#include <linux/wait.h>
> +#include <linux/slab.h>
> +#include <linux/genalloc.h>
> +#include <linux/dma-mapping.h>
> +
> +#include "iova_domain.h"
> +
> +#define IOVA_CHUNK_SHIFT 26
> +#define IOVA_CHUNK_SIZE (_AC(1, UL) << IOVA_CHUNK_SHIFT)
> +#define IOVA_CHUNK_MASK (~(IOVA_CHUNK_SIZE - 1))
> +
> +#define IOVA_MIN_SIZE (IOVA_CHUNK_SIZE << 1)
> +
> +#define IOVA_ALLOC_ORDER 12
> +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
> +
> +struct vduse_mmap_vma {
> +	struct vm_area_struct *vma;
> +	struct list_head list;
> +};
> +
> +static inline struct page *
> +vduse_domain_get_bounce_page(struct vduse_iova_domain *domain,
> +				unsigned long iova)
> +{
> +	unsigned long index = iova >> IOVA_CHUNK_SHIFT;
> +	unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
> +	unsigned long pgindex = chunkoff >> PAGE_SHIFT;
> +
> +	return domain->chunks[index].bounce_pages[pgindex];
> +}
> +
> +static inline void
> +vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
> +				unsigned long iova, struct page *page)
> +{
> +	unsigned long index = iova >> IOVA_CHUNK_SHIFT;
> +	unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
> +	unsigned long pgindex = chunkoff >> PAGE_SHIFT;
> +
> +	domain->chunks[index].bounce_pages[pgindex] = page;
> +}
> +
> +static inline struct vduse_iova_map *
> +vduse_domain_get_iova_map(struct vduse_iova_domain *domain,
> +				unsigned long iova)
> +{
> +	unsigned long index = iova >> IOVA_CHUNK_SHIFT;
> +	unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
> +	unsigned long mapindex = chunkoff >> IOVA_ALLOC_ORDER;
> +
> +	return domain->chunks[index].iova_map[mapindex];
> +}
> +
> +static inline void
> +vduse_domain_set_iova_map(struct vduse_iova_domain *domain,
> +			unsigned long iova, struct vduse_iova_map *map)
> +{
> +	unsigned long index = iova >> IOVA_CHUNK_SHIFT;
> +	unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
> +	unsigned long mapindex = chunkoff >> IOVA_ALLOC_ORDER;
> +
> +	domain->chunks[index].iova_map[mapindex] = map;
> +}
> +
> +static int
> +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain,
> +				unsigned long iova, size_t size)
> +{
> +	struct page *page;
> +	size_t walk_sz = 0;
> +	int frees = 0;
> +
> +	while (walk_sz < size) {
> +		page = vduse_domain_get_bounce_page(domain, iova);
> +		if (page) {
> +			vduse_domain_set_bounce_page(domain, iova, NULL);
> +			put_page(page);
> +			frees++;
> +		}
> +		iova += PAGE_SIZE;
> +		walk_sz += PAGE_SIZE;
> +	}
> +
> +	return frees;
> +}
> +
> +int vduse_domain_add_vma(struct vduse_iova_domain *domain,
> +				struct vm_area_struct *vma)
> +{
> +	unsigned long size = vma->vm_end - vma->vm_start;
> +	struct vduse_mmap_vma *mmap_vma;
> +
> +	if (WARN_ON(size != domain->size))
> +		return -EINVAL;
> +
> +	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
> +	if (!mmap_vma)
> +		return -ENOMEM;
> +
> +	mmap_vma->vma = vma;
> +	mutex_lock(&domain->vma_lock);
> +	list_add(&mmap_vma->list, &domain->vma_list);
> +	mutex_unlock(&domain->vma_lock);
> +
> +	return 0;
> +}
> +
> +void vduse_domain_remove_vma(struct vduse_iova_domain *domain,
> +				struct vm_area_struct *vma)
> +{
> +	struct vduse_mmap_vma *mmap_vma;
> +
> +	mutex_lock(&domain->vma_lock);
> +	list_for_each_entry(mmap_vma, &domain->vma_list, list) {
> +		if (mmap_vma->vma == vma) {
> +			list_del(&mmap_vma->list);
> +			kfree(mmap_vma);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&domain->vma_lock);
> +}
> +
> +int vduse_domain_add_mapping(struct vduse_iova_domain *domain,
> +				unsigned long iova, unsigned long orig,
> +				size_t size, enum dma_data_direction dir)
> +{
> +	struct vduse_iova_map *map;
> +	unsigned long last = iova + size;
> +
> +	map = kzalloc(sizeof(struct vduse_iova_map), GFP_ATOMIC);
> +	if (!map)
> +		return -ENOMEM;
> +
> +	map->iova = iova;
> +	map->orig = orig;
> +	map->size = size;
> +	map->dir = dir;
> +
> +	while (iova < last) {
> +		vduse_domain_set_iova_map(domain, iova, map);
> +		iova += IOVA_ALLOC_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +struct vduse_iova_map *
> +vduse_domain_get_mapping(struct vduse_iova_domain *domain,
> +			unsigned long iova)
> +{
> +	return vduse_domain_get_iova_map(domain, iova);
> +}
> +
> +void vduse_domain_remove_mapping(struct vduse_iova_domain *domain,
> +				struct vduse_iova_map *map)
> +{
> +	unsigned long iova = map->iova;
> +	unsigned long last = iova + map->size;
> +
> +	while (iova < last) {
> +		vduse_domain_set_iova_map(domain, iova, NULL);
> +		iova += IOVA_ALLOC_SIZE;
> +	}
> +}
> +
> +void vduse_domain_unmap(struct vduse_iova_domain *domain,
> +			unsigned long iova, size_t size)
> +{
> +	struct vduse_mmap_vma *mmap_vma;
> +	unsigned long uaddr;
> +
> +	mutex_lock(&domain->vma_lock);
> +	list_for_each_entry(mmap_vma, &domain->vma_list, list) {
> +		mmap_read_lock(mmap_vma->vma->vm_mm);
> +		uaddr = iova + mmap_vma->vma->vm_start;
> +		zap_page_range(mmap_vma->vma, uaddr, size);
> +		mmap_read_unlock(mmap_vma->vma->vm_mm);
> +	}
> +	mutex_unlock(&domain->vma_lock);
> +}
> +
> +int vduse_domain_direct_map(struct vduse_iova_domain *domain,
> +			struct vm_area_struct *vma, unsigned long iova)
> +{
> +	unsigned long uaddr = iova + vma->vm_start;
> +	unsigned long start = iova & PAGE_MASK;
> +	unsigned long last = start + PAGE_SIZE - 1;
> +	unsigned long offset;
> +	struct vduse_iova_map *map;
> +	struct page *page = NULL;
> +
> +	map = vduse_domain_get_iova_map(domain, iova);
> +	if (map) {
> +		offset = last - map->iova;
> +		page = virt_to_page(map->orig + offset);
> +	}
> +
> +	return page ? vm_insert_page(vma, uaddr, page) : -EFAULT;
> +}


So as we discussed before, we need to find way to make vhost work. And 
it's better to make vhost transparent to VDUSE. One idea is to implement 
shadow virtqueue here, that is, instead of trying to insert the pages to 
VDUSE userspace, we use the shadow virtqueue to relay the descriptors to 
userspace. With this, we don't need stuffs like shmfd etc.


> +
> +void vduse_domain_bounce(struct vduse_iova_domain *domain,
> +			unsigned long iova, unsigned long orig,
> +			size_t size, enum dma_data_direction dir)
> +{
> +	unsigned int offset = offset_in_page(iova);
> +
> +	while (size) {
> +		struct page *p = vduse_domain_get_bounce_page(domain, iova);
> +		size_t copy_len = min_t(size_t, PAGE_SIZE - offset, size);
> +		void *addr;
> +
> +		if (p) {
> +			addr = page_address(p) + offset;
> +			if (dir == DMA_TO_DEVICE)
> +				memcpy(addr, (void *)orig, copy_len);
> +			else if (dir == DMA_FROM_DEVICE)
> +				memcpy((void *)orig, addr, copy_len);
> +		}


I think I miss something, for DMA_FROM_DEVICE, if p doesn't exist how is 
it expected to work? Or do we need to warn here in this case?


> +		size -= copy_len;
> +		orig += copy_len;
> +		iova += copy_len;
> +		offset = 0;
> +	}
> +}
> +
> +int vduse_domain_bounce_map(struct vduse_iova_domain *domain,
> +			struct vm_area_struct *vma, unsigned long iova)
> +{
> +	unsigned long uaddr = iova + vma->vm_start;
> +	unsigned long start = iova & PAGE_MASK;
> +	unsigned long offset = 0;
> +	bool found = false;
> +	struct vduse_iova_map *map;
> +	struct page *page;
> +
> +	mutex_lock(&domain->map_lock);
> +
> +	page = vduse_domain_get_bounce_page(domain, iova);
> +	if (page)
> +		goto unlock;
> +
> +	page = alloc_page(GFP_KERNEL);
> +	if (!page)
> +		goto unlock;
> +
> +	while (offset < PAGE_SIZE) {
> +		unsigned int src_offset = 0, dst_offset = 0;
> +		void *src, *dst;
> +		size_t copy_len;
> +
> +		map = vduse_domain_get_iova_map(domain, start + offset);
> +		if (!map) {
> +			offset += IOVA_ALLOC_SIZE;
> +			continue;
> +		}
> +
> +		found = true;
> +		offset += map->size;
> +		if (map->dir == DMA_FROM_DEVICE)
> +			continue;
> +
> +		if (start > map->iova)
> +			src_offset = start - map->iova;
> +		else
> +			dst_offset = map->iova - start;
> +
> +		src = (void *)(map->orig + src_offset);
> +		dst = page_address(page) + dst_offset;
> +		copy_len = min_t(size_t, map->size - src_offset,
> +				PAGE_SIZE - dst_offset);
> +		memcpy(dst, src, copy_len);
> +	}
> +	if (!found) {
> +		put_page(page);
> +		page = NULL;
> +	}
> +	vduse_domain_set_bounce_page(domain, iova, page);
> +unlock:
> +	mutex_unlock(&domain->map_lock);
> +
> +	return page ? vm_insert_page(vma, uaddr, page) : -EFAULT;
> +}
> +
> +bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
> +				unsigned long iova)
> +{
> +	unsigned long index = iova >> IOVA_CHUNK_SHIFT;
> +	struct vduse_iova_chunk *chunk = &domain->chunks[index];
> +
> +	return atomic_read(&chunk->map_type) == TYPE_DIRECT_MAP;
> +}
> +
> +unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *domain,
> +					size_t size, enum iova_map_type type)
> +{
> +	struct vduse_iova_chunk *chunk;
> +	unsigned long iova = 0;
> +	int align = (type == TYPE_DIRECT_MAP) ? PAGE_SIZE : IOVA_ALLOC_SIZE;
> +	struct genpool_data_align data = { .align = align };
> +	int i;
> +
> +	for (i = 0; i < domain->chunk_num; i++) {
> +		chunk = &domain->chunks[i];
> +		if (unlikely(atomic_read(&chunk->map_type) == TYPE_NONE))
> +			atomic_cmpxchg(&chunk->map_type, TYPE_NONE, type);
> +
> +		if (atomic_read(&chunk->map_type) != type)
> +			continue;
> +
> +		iova = gen_pool_alloc_algo(chunk->pool, size,
> +					gen_pool_first_fit_align, &data);
> +		if (iova)
> +			break;
> +	}
> +
> +	return iova;


I wonder why not just reuse the iova domain implements in 
driver/iommu/iova.c


> +}
> +
> +void vduse_domain_free_iova(struct vduse_iova_domain *domain,
> +				unsigned long iova, size_t size)
> +{
> +	unsigned long index = iova >> IOVA_CHUNK_SHIFT;
> +	struct vduse_iova_chunk *chunk = &domain->chunks[index];
> +
> +	gen_pool_free(chunk->pool, iova, size);
> +}
> +
> +static void vduse_iova_chunk_cleanup(struct vduse_iova_chunk *chunk)
> +{
> +	vfree(chunk->bounce_pages);
> +	vfree(chunk->iova_map);
> +	gen_pool_destroy(chunk->pool);
> +}
> +
> +void vduse_iova_domain_destroy(struct vduse_iova_domain *domain)
> +{
> +	struct vduse_iova_chunk *chunk;
> +	int i;
> +
> +	for (i = 0; i < domain->chunk_num; i++) {
> +		chunk = &domain->chunks[i];
> +		vduse_domain_free_bounce_pages(domain,
> +					chunk->start, IOVA_CHUNK_SIZE);
> +		vduse_iova_chunk_cleanup(chunk);
> +	}
> +
> +	mutex_destroy(&domain->map_lock);
> +	mutex_destroy(&domain->vma_lock);
> +	kfree(domain->chunks);
> +	kfree(domain);
> +}
> +
> +static int vduse_iova_chunk_init(struct vduse_iova_chunk *chunk,
> +				unsigned long addr, size_t size)
> +{
> +	int ret;
> +	int pages = size >> PAGE_SHIFT;
> +
> +	chunk->pool = gen_pool_create(IOVA_ALLOC_ORDER, -1);
> +	if (!chunk->pool)
> +		return -ENOMEM;
> +
> +	/* addr 0 is used in allocation failure case */
> +	if (addr == 0)
> +		addr += IOVA_ALLOC_SIZE;
> +
> +	ret = gen_pool_add(chunk->pool, addr, size, -1);
> +	if (ret)
> +		goto err;
> +
> +	ret = -ENOMEM;
> +	chunk->bounce_pages = vzalloc(pages * sizeof(struct page *));
> +	if (!chunk->bounce_pages)
> +		goto err;
> +
> +	chunk->iova_map = vzalloc((size >> IOVA_ALLOC_ORDER) *
> +				sizeof(struct vduse_iova_map *));
> +	if (!chunk->iova_map)
> +		goto err;
> +
> +	chunk->start = addr;
> +	atomic_set(&chunk->map_type, TYPE_NONE);
> +
> +	return 0;
> +err:
> +	if (chunk->bounce_pages) {
> +		vfree(chunk->bounce_pages);
> +		chunk->bounce_pages = NULL;
> +	}
> +	gen_pool_destroy(chunk->pool);
> +	return ret;
> +}
> +
> +struct vduse_iova_domain *vduse_iova_domain_create(size_t size)
> +{
> +	int j, i = 0;
> +	struct vduse_iova_domain *domain;
> +	unsigned long num = size >> IOVA_CHUNK_SHIFT;
> +	unsigned long addr = 0;
> +
> +	if (size < IOVA_MIN_SIZE || size & ~IOVA_CHUNK_MASK)
> +		return NULL;
> +
> +	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
> +	if (!domain)
> +		return NULL;
> +
> +	domain->chunks = kcalloc(num, sizeof(struct vduse_iova_chunk), GFP_KERNEL);
> +	if (!domain->chunks)
> +		goto err;
> +
> +	for (i = 0; i < num; i++, addr += IOVA_CHUNK_SIZE)
> +		if (vduse_iova_chunk_init(&domain->chunks[i], addr,
> +					IOVA_CHUNK_SIZE))
> +			goto err;
> +
> +	domain->chunk_num = num;
> +	domain->size = size;
> +	INIT_LIST_HEAD(&domain->vma_list);
> +	mutex_init(&domain->vma_lock);
> +	mutex_init(&domain->map_lock);
> +
> +	return domain;
> +err:
> +	for (j = 0; j < i; j++)
> +		vduse_iova_chunk_cleanup(&domain->chunks[j]);
> +	kfree(domain);
> +
> +	return NULL;
> +}
> diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa_user/iova_domain.h
> new file mode 100644
> index 000000000000..fe1816287f5f
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/iova_domain.h
> @@ -0,0 +1,93 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * MMU-based IOMMU implementation
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#ifndef _VDUSE_IOVA_DOMAIN_H
> +#define _VDUSE_IOVA_DOMAIN_H
> +
> +#include <linux/genalloc.h>
> +#include <linux/dma-mapping.h>
> +
> +enum iova_map_type {
> +	TYPE_NONE,
> +	TYPE_DIRECT_MAP,
> +	TYPE_BOUNCE_MAP,
> +};
> +
> +struct vduse_iova_map {
> +	unsigned long iova;
> +	unsigned long orig;
> +	size_t size;
> +	enum dma_data_direction dir;
> +};
> +
> +struct vduse_iova_chunk {
> +	struct gen_pool *pool;
> +	struct page **bounce_pages;
> +	struct vduse_iova_map **iova_map;
> +	unsigned long start;
> +	atomic_t map_type;
> +};
> +
> +struct vduse_iova_domain {
> +	struct vduse_iova_chunk *chunks;
> +	int chunk_num;
> +	size_t size;
> +	struct mutex map_lock;
> +	struct mutex vma_lock;
> +	struct list_head vma_list;
> +};


It's better to explain why you need to organize the bounce buffer with 
chunks by adding some comments above or in the commit log. Is this 
because you want to have O(1) for finding the page for a specific IOVA?


> +
> +int vduse_domain_add_vma(struct vduse_iova_domain *domain,
> +				struct vm_area_struct *vma);
> +
> +void vduse_domain_remove_vma(struct vduse_iova_domain *domain,
> +				struct vm_area_struct *vma);
> +
> +int vduse_domain_add_mapping(struct vduse_iova_domain *domain,
> +				unsigned long iova, unsigned long orig,
> +				size_t size, enum dma_data_direction dir);
> +
> +struct vduse_iova_map *
> +vduse_domain_get_mapping(struct vduse_iova_domain *domain,
> +			unsigned long iova);
> +
> +void vduse_domain_remove_mapping(struct vduse_iova_domain *domain,
> +				struct vduse_iova_map *map);
> +
> +void vduse_domain_unmap(struct vduse_iova_domain *domain,
> +			unsigned long iova, size_t size);
> +
> +int vduse_domain_direct_map(struct vduse_iova_domain *domain,
> +			struct vm_area_struct *vma, unsigned long iova);
> +
> +void vduse_domain_bounce(struct vduse_iova_domain *domain,
> +			unsigned long iova, unsigned long orig,
> +			size_t size, enum dma_data_direction dir);
> +
> +int vduse_domain_bounce_map(struct vduse_iova_domain *domain,
> +			struct vm_area_struct *vma, unsigned long iova);
> +
> +bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
> +				unsigned long iova);
> +
> +unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *domain,
> +					size_t size, enum iova_map_type type);
> +
> +void vduse_domain_free_iova(struct vduse_iova_domain *domain,
> +				unsigned long iova, size_t size);
> +
> +bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
> +				unsigned long iova);
> +
> +void vduse_iova_domain_destroy(struct vduse_iova_domain *domain);
> +
> +struct vduse_iova_domain *vduse_iova_domain_create(size_t size);
> +
> +#endif /* _VDUSE_IOVA_DOMAIN_H */
> diff --git a/drivers/vdpa/vdpa_user/vduse.h b/drivers/vdpa/vdpa_user/vduse.h
> new file mode 100644
> index 000000000000..1041ce7bddc4
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/vduse.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * VDUSE: vDPA Device in Userspace
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#ifndef _VDUSE_H
> +#define _VDUSE_H
> +
> +#include <linux/eventfd.h>
> +#include <linux/wait.h>
> +#include <linux/vdpa.h>
> +
> +#include "iova_domain.h"
> +#include "eventfd.h"
> +
> +struct vduse_virtqueue {
> +	u16 index;
> +	bool ready;
> +	spinlock_t kick_lock;
> +	spinlock_t irq_lock;
> +	struct eventfd_ctx *kickfd;
> +	struct vduse_virqfd *virqfd;
> +	void *private;
> +	irqreturn_t (*cb)(void *data);
> +};
> +
> +struct vduse_dev;
> +
> +struct vduse_vdpa {
> +	struct vdpa_device vdpa;
> +	struct vduse_dev *dev;
> +};
> +
> +struct vduse_dev {
> +	struct vduse_vdpa *vdev;
> +	struct vduse_virtqueue *vqs;
> +	struct vduse_iova_domain *domain;
> +	struct mutex lock;
> +	spinlock_t msg_lock;
> +	atomic64_t msg_unique;
> +	wait_queue_head_t waitq;
> +	struct list_head send_list;
> +	struct list_head recv_list;
> +	struct list_head list;
> +	refcount_t refcnt;
> +	u32 id;
> +	u16 vq_size_max;
> +	u16 vq_num;
> +	u32 vq_align;
> +	u32 device_id;
> +	u32 vendor_id;
> +};
> +
> +#endif /* _VDUSE_H_ */
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> new file mode 100644
> index 000000000000..4a869b9698ef
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -0,0 +1,1121 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VDUSE: vDPA Device in Userspace
> + *
> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights reserved.
> + *
> + * Author: Xie Yongji <xieyongji@bytedance.com>
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/slab.h>
> +#include <linux/wait.h>
> +#include <linux/dma-map-ops.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
> +#include <linux/uio.h>
> +#include <linux/vdpa.h>
> +#include <uapi/linux/vduse.h>
> +#include <uapi/linux/vdpa.h>
> +#include <uapi/linux/virtio_config.h>
> +#include <linux/mod_devicetable.h>
> +
> +#include "vduse.h"
> +
> +#define DRV_VERSION  "1.0"
> +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
> +#define DRV_DESC     "vDPA Device in Userspace"
> +#define DRV_LICENSE  "GPL v2"
> +
> +struct vduse_dev_msg {
> +	struct vduse_dev_request req;
> +	struct vduse_dev_response resp;
> +	struct list_head list;
> +	wait_queue_head_t waitq;
> +	bool completed;
> +	refcount_t refcnt;
> +};
> +
> +static struct workqueue_struct *vduse_vdpa_wq;
> +static DEFINE_MUTEX(vduse_lock);
> +static LIST_HEAD(vduse_devs);
> +
> +static inline struct vduse_dev *vdpa_to_vduse(struct vdpa_device *vdpa)
> +{
> +	struct vduse_vdpa *vdev = container_of(vdpa, struct vduse_vdpa, vdpa);
> +
> +	return vdev->dev;
> +}
> +
> +static inline struct vduse_dev *dev_to_vduse(struct device *dev)
> +{
> +	struct vdpa_device *vdpa = dev_to_vdpa(dev);
> +
> +	return vdpa_to_vduse(vdpa);
> +}
> +
> +static struct vduse_dev_msg *vduse_dev_new_msg(struct vduse_dev *dev, int type)
> +{
> +	struct vduse_dev_msg *msg = kzalloc(sizeof(*msg),
> +					GFP_KERNEL | __GFP_NOFAIL);
> +
> +	msg->req.type = type;
> +	msg->req.unique = atomic64_fetch_inc(&dev->msg_unique);
> +	init_waitqueue_head(&msg->waitq);
> +	refcount_set(&msg->refcnt, 1);
> +
> +	return msg;
> +}
> +
> +static void vduse_dev_msg_get(struct vduse_dev_msg *msg)
> +{
> +	refcount_inc(&msg->refcnt);
> +}
> +
> +static void vduse_dev_msg_put(struct vduse_dev_msg *msg)
> +{
> +	if (refcount_dec_and_test(&msg->refcnt))
> +		kfree(msg);
> +}
> +
> +static struct vduse_dev_msg *vduse_dev_find_msg(struct vduse_dev *dev,
> +						struct list_head *head,
> +						uint32_t unique)
> +{
> +	struct vduse_dev_msg *tmp, *msg = NULL;
> +
> +	spin_lock(&dev->msg_lock);
> +	list_for_each_entry(tmp, head, list) {
> +		if (tmp->req.unique == unique) {
> +			msg = tmp;
> +			list_del(&tmp->list);
> +			break;
> +		}
> +	}
> +	spin_unlock(&dev->msg_lock);
> +
> +	return msg;
> +}
> +
> +static struct vduse_dev_msg *vduse_dev_dequeue_msg(struct vduse_dev *dev,
> +						struct list_head *head)
> +{
> +	struct vduse_dev_msg *msg = NULL;
> +
> +	spin_lock(&dev->msg_lock);
> +	if (!list_empty(head)) {
> +		msg = list_first_entry(head, struct vduse_dev_msg, list);
> +		list_del(&msg->list);
> +	}
> +	spin_unlock(&dev->msg_lock);
> +
> +	return msg;
> +}
> +
> +static void vduse_dev_enqueue_msg(struct vduse_dev *dev,
> +			struct vduse_dev_msg *msg, struct list_head *head)
> +{
> +	spin_lock(&dev->msg_lock);
> +	list_add_tail(&msg->list, head);
> +	spin_unlock(&dev->msg_lock);
> +}
> +
> +static int vduse_dev_msg_sync(struct vduse_dev *dev, struct vduse_dev_msg *msg)
> +{
> +	int ret;
> +
> +	vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> +	wake_up(&dev->waitq);
> +	wait_event(msg->waitq, msg->completed);
> +	/* coupled with smp_wmb() in vduse_dev_msg_complete() */
> +	smp_rmb();
> +	ret = msg->resp.result;
> +
> +	return ret;
> +}
> +
> +static void vduse_dev_msg_complete(struct vduse_dev_msg *msg,
> +					struct vduse_dev_response *resp)
> +{
> +	vduse_dev_msg_get(msg);
> +	memcpy(&msg->resp, resp, sizeof(*resp));
> +	/* coupled with smp_rmb() in vduse_dev_msg_sync() */
> +	smp_wmb();
> +	msg->completed = 1;
> +	wake_up(&msg->waitq);
> +	vduse_dev_msg_put(msg);
> +}
> +
> +static u64 vduse_dev_get_features(struct vduse_dev *dev)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_GET_FEATURES);
> +	u64 features;
> +
> +	vduse_dev_msg_sync(dev, msg);
> +	features = msg->resp.features;
> +	vduse_dev_msg_put(msg);
> +
> +	return features;
> +}
> +
> +static int vduse_dev_set_features(struct vduse_dev *dev, u64 features)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_SET_FEATURES);
> +	int ret;
> +
> +	msg->req.size = sizeof(features);
> +	msg->req.features = features;
> +
> +	ret = vduse_dev_msg_sync(dev, msg);
> +	vduse_dev_msg_put(msg);
> +
> +	return ret;
> +}
> +
> +static u8 vduse_dev_get_status(struct vduse_dev *dev)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_GET_STATUS);
> +	u8 status;
> +
> +	vduse_dev_msg_sync(dev, msg);
> +	status = msg->resp.status;
> +	vduse_dev_msg_put(msg);
> +
> +	return status;
> +}
> +
> +static void vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_SET_STATUS);
> +
> +	msg->req.size = sizeof(status);
> +	msg->req.status = status;
> +
> +	vduse_dev_msg_sync(dev, msg);
> +	vduse_dev_msg_put(msg);
> +}
> +
> +static void vduse_dev_get_config(struct vduse_dev *dev, unsigned int offset,
> +					void *buf, unsigned int len)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_GET_CONFIG);
> +
> +	WARN_ON(len > sizeof(msg->req.config.data));
> +
> +	msg->req.size = sizeof(struct vduse_dev_config_data);
> +	msg->req.config.offset = offset;
> +	msg->req.config.len = len;
> +	vduse_dev_msg_sync(dev, msg);
> +	memcpy(buf, msg->resp.config.data, len);
> +	vduse_dev_msg_put(msg);
> +}
> +
> +static void vduse_dev_set_config(struct vduse_dev *dev, unsigned int offset,
> +					const void *buf, unsigned int len)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_SET_CONFIG);
> +
> +	WARN_ON(len > sizeof(msg->req.config.data));
> +
> +	msg->req.size = sizeof(struct vduse_dev_config_data);
> +	msg->req.config.offset = offset;
> +	msg->req.config.len = len;
> +	memcpy(msg->req.config.data, buf, len);
> +	vduse_dev_msg_sync(dev, msg);
> +	vduse_dev_msg_put(msg);
> +}
> +
> +static void vduse_dev_set_vq_num(struct vduse_dev *dev,
> +				struct vduse_virtqueue *vq, u32 num)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_SET_VQ_NUM);
> +
> +	msg->req.size = sizeof(struct vduse_vq_num);
> +	msg->req.vq_num.index = vq->index;
> +	msg->req.vq_num.num = num;
> +
> +	vduse_dev_msg_sync(dev, msg);
> +	vduse_dev_msg_put(msg);
> +}
> +
> +static int vduse_dev_set_vq_addr(struct vduse_dev *dev,
> +				struct vduse_virtqueue *vq, u64 desc_addr,
> +				u64 driver_addr, u64 device_addr)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_SET_VQ_ADDR);
> +	int ret;
> +
> +	msg->req.size = sizeof(struct vduse_vq_addr);
> +	msg->req.vq_addr.index = vq->index;
> +	msg->req.vq_addr.desc_addr = desc_addr;
> +	msg->req.vq_addr.driver_addr = driver_addr;
> +	msg->req.vq_addr.device_addr = device_addr;
> +
> +	ret = vduse_dev_msg_sync(dev, msg);
> +	vduse_dev_msg_put(msg);
> +
> +	return ret;
> +}
> +
> +static void vduse_dev_set_vq_ready(struct vduse_dev *dev,
> +				struct vduse_virtqueue *vq, bool ready)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_SET_VQ_READY);
> +
> +	msg->req.size = sizeof(struct vduse_vq_ready);
> +	msg->req.vq_ready.index = vq->index;
> +	msg->req.vq_ready.ready = ready;
> +
> +	vduse_dev_msg_sync(dev, msg);
> +	vduse_dev_msg_put(msg);
> +}
> +
> +static bool vduse_dev_get_vq_ready(struct vduse_dev *dev,
> +				   struct vduse_virtqueue *vq)
> +{
> +	struct vduse_dev_msg *msg = vduse_dev_new_msg(dev, VDUSE_GET_VQ_READY);
> +	bool ready;
> +
> +	msg->req.size = sizeof(struct vduse_vq_ready);
> +	msg->req.vq_ready.index = vq->index;
> +
> +	vduse_dev_msg_sync(dev, msg);
> +	ready = msg->resp.vq_ready.ready;
> +	vduse_dev_msg_put(msg);
> +
> +	return ready;
> +}
> +
> +static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_iter *to)
> +{
> +	struct file *file = iocb->ki_filp;
> +	struct vduse_dev *dev = file->private_data;
> +	struct vduse_dev_msg *msg;
> +	int size = sizeof(struct vduse_dev_request);
> +	ssize_t ret = 0;
> +
> +	if (iov_iter_count(to) < size)
> +		return 0;
> +
> +	while (1) {
> +		msg = vduse_dev_dequeue_msg(dev, &dev->send_list);
> +		if (msg)
> +			break;
> +
> +		if (file->f_flags & O_NONBLOCK)
> +			return -EAGAIN;
> +
> +		ret = wait_event_interruptible_exclusive(dev->waitq,
> +					!list_empty(&dev->send_list));
> +		if (ret)
> +			return ret;
> +	}
> +	ret = copy_to_iter(&msg->req, size, to);
> +	if (ret != size) {
> +		vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> +		return -EFAULT;
> +	}
> +	vduse_dev_enqueue_msg(dev, msg, &dev->recv_list);
> +
> +	return ret;
> +}
> +
> +static ssize_t vduse_dev_write_iter(struct kiocb *iocb, struct iov_iter *from)
> +{
> +	struct file *file = iocb->ki_filp;
> +	struct vduse_dev *dev = file->private_data;
> +	struct vduse_dev_response resp;
> +	struct vduse_dev_msg *msg;
> +	size_t ret;
> +
> +	ret = copy_from_iter(&resp, sizeof(resp), from);
> +	if (ret != sizeof(resp))
> +		return -EINVAL;
> +
> +	msg = vduse_dev_find_msg(dev, &dev->recv_list, resp.unique);
> +	if (!msg)
> +		return -EINVAL;
> +
> +	vduse_dev_msg_complete(msg, &resp);
> +
> +	return ret;
> +}
> +
> +static __poll_t vduse_dev_poll(struct file *file, poll_table *wait)
> +{
> +	struct vduse_dev *dev = file->private_data;
> +	__poll_t mask = 0;
> +
> +	poll_wait(file, &dev->waitq, wait);
> +
> +	if (!list_empty(&dev->send_list))
> +		mask |= EPOLLIN | EPOLLRDNORM;
> +
> +	return mask;
> +}
> +
> +static void vduse_dev_reset(struct vduse_dev *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < dev->vq_num; i++) {
> +		struct vduse_virtqueue *vq = &dev->vqs[i];
> +
> +		spin_lock(&vq->irq_lock);
> +		vq->ready = false;
> +		vq->cb = NULL;
> +		vq->private = NULL;
> +		spin_unlock(&vq->irq_lock);
> +	}
> +}
> +
> +static int vduse_vdpa_set_vq_address(struct vdpa_device *vdpa, u16 idx,
> +				u64 desc_area, u64 driver_area,
> +				u64 device_area)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +	struct vduse_virtqueue *vq = &dev->vqs[idx];
> +
> +	return vduse_dev_set_vq_addr(dev, vq, desc_area,
> +					driver_area, device_area);
> +}
> +
> +static void vduse_vdpa_kick_vq(struct vdpa_device *vdpa, u16 idx)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +	struct vduse_virtqueue *vq = &dev->vqs[idx];
> +
> +	vduse_vq_kick(vq);
> +}
> +
> +static void vduse_vdpa_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
> +			      struct vdpa_callback *cb)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +	struct vduse_virtqueue *vq = &dev->vqs[idx];
> +
> +	vq->cb = cb->callback;
> +	vq->private = cb->private;
> +}
> +
> +static void vduse_vdpa_set_vq_num(struct vdpa_device *vdpa, u16 idx, u32 num)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +	struct vduse_virtqueue *vq = &dev->vqs[idx];
> +
> +	vduse_dev_set_vq_num(dev, vq, num);
> +}
> +
> +static void vduse_vdpa_set_vq_ready(struct vdpa_device *vdpa,
> +					u16 idx, bool ready)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +	struct vduse_virtqueue *vq = &dev->vqs[idx];
> +
> +	vduse_dev_set_vq_ready(dev, vq, ready);
> +	vq->ready = ready;
> +}
> +
> +static bool vduse_vdpa_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +	struct vduse_virtqueue *vq = &dev->vqs[idx];
> +
> +	vq->ready = vduse_dev_get_vq_ready(dev, vq);
> +
> +	return vq->ready;
> +}
> +
> +static u32 vduse_vdpa_get_vq_align(struct vdpa_device *vdpa)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	return dev->vq_align;
> +}
> +
> +static u64 vduse_vdpa_get_features(struct vdpa_device *vdpa)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +	u64 fixed = (1ULL << VIRTIO_F_ACCESS_PLATFORM);
> +
> +	return (vduse_dev_get_features(dev) | fixed);
> +}
> +
> +static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 features)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	return vduse_dev_set_features(dev, features);
> +}
> +
> +static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
> +				  struct vdpa_callback *cb)
> +{
> +	/* We don't support config interrupt */
> +}
> +
> +static u16 vduse_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	return dev->vq_size_max;
> +}
> +
> +static u32 vduse_vdpa_get_device_id(struct vdpa_device *vdpa)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	return dev->device_id;
> +}
> +
> +static u32 vduse_vdpa_get_vendor_id(struct vdpa_device *vdpa)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	return dev->vendor_id;
> +}
> +
> +static u8 vduse_vdpa_get_status(struct vdpa_device *vdpa)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	return vduse_dev_get_status(dev);
> +}
> +
> +static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	if (status == 0)
> +		vduse_dev_reset(dev);
> +
> +	vduse_dev_set_status(dev, status);
> +}
> +
> +static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned int offset,
> +			     void *buf, unsigned int len)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	vduse_dev_get_config(dev, offset, buf, len);
> +}
> +
> +static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned int offset,
> +			const void *buf, unsigned int len)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	vduse_dev_set_config(dev, offset, buf, len);
> +}
> +
> +static void vduse_vdpa_free(struct vdpa_device *vdpa)
> +{
> +	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> +
> +	vduse_kickfd_release(dev);
> +	vduse_virqfd_release(dev);
> +
> +	WARN_ON(!list_empty(&dev->send_list));
> +	WARN_ON(!list_empty(&dev->recv_list));
> +	dev->vdev = NULL;
> +}
> +
> +static const struct vdpa_config_ops vduse_vdpa_config_ops = {
> +	.set_vq_address		= vduse_vdpa_set_vq_address,
> +	.kick_vq		= vduse_vdpa_kick_vq,
> +	.set_vq_cb		= vduse_vdpa_set_vq_cb,
> +	.set_vq_num             = vduse_vdpa_set_vq_num,
> +	.set_vq_ready		= vduse_vdpa_set_vq_ready,
> +	.get_vq_ready		= vduse_vdpa_get_vq_ready,
> +	.get_vq_align		= vduse_vdpa_get_vq_align,
> +	.get_features		= vduse_vdpa_get_features,
> +	.set_features		= vduse_vdpa_set_features,
> +	.set_config_cb		= vduse_vdpa_set_config_cb,
> +	.get_vq_num_max		= vduse_vdpa_get_vq_num_max,
> +	.get_device_id		= vduse_vdpa_get_device_id,
> +	.get_vendor_id		= vduse_vdpa_get_vendor_id,
> +	.get_status		= vduse_vdpa_get_status,
> +	.set_status		= vduse_vdpa_set_status,
> +	.get_config		= vduse_vdpa_get_config,
> +	.set_config		= vduse_vdpa_set_config,
> +	.free			= vduse_vdpa_free,
> +};
> +
> +static dma_addr_t vduse_dev_map_page(struct device *dev, struct page *page,
> +					unsigned long offset, size_t size,
> +					enum dma_data_direction dir,
> +					unsigned long attrs)
> +{
> +	struct vduse_dev *vdev = dev_to_vduse(dev);
> +	struct vduse_iova_domain *domain = vdev->domain;
> +	unsigned long iova = vduse_domain_alloc_iova(domain, size,
> +							TYPE_BOUNCE_MAP);
> +	unsigned long orig = (unsigned long)page_address(page) + offset;
> +
> +	if (!iova)
> +		return DMA_MAPPING_ERROR;
> +
> +	if (vduse_domain_add_mapping(domain, iova, orig, size, dir)) {
> +		vduse_domain_free_iova(domain, iova, size);
> +		return DMA_MAPPING_ERROR;
> +	}
> +
> +	if (dir == DMA_TO_DEVICE)


How about bidirectional mapping?


> +		vduse_domain_bounce(domain, iova, orig, size, dir);
> +
> +	return (dma_addr_t)iova;
> +}
> +
> +static void vduse_dev_unmap_page(struct device *dev, dma_addr_t dma_addr,
> +				size_t size, enum dma_data_direction dir,
> +				unsigned long attrs)
> +{
> +	struct vduse_dev *vdev = dev_to_vduse(dev);
> +	struct vduse_iova_domain *domain = vdev->domain;
> +	unsigned long iova = (unsigned long)dma_addr;
> +	struct vduse_iova_map *map = vduse_domain_get_mapping(domain, iova);
> +
> +	if (WARN_ON(!map))
> +		return;
> +
> +	if (dir == DMA_FROM_DEVICE)
> +		vduse_domain_bounce(domain, iova, map->orig, size, dir);
> +	vduse_domain_remove_mapping(domain, map);
> +	vduse_domain_free_iova(domain, iova, size);
> +	kfree(map);
> +}
> +
> +static void *vduse_dev_alloc_coherent(struct device *dev, size_t size,
> +					dma_addr_t *dma_addr, gfp_t flag,
> +					unsigned long attrs)
> +{
> +	struct vduse_dev *vdev = dev_to_vduse(dev);
> +	struct vduse_iova_domain *domain = vdev->domain;
> +	unsigned long iova = vduse_domain_alloc_iova(domain, size,
> +							TYPE_DIRECT_MAP);
> +	void *orig = alloc_pages_exact(size, flag);
> +
> +	if (!iova || !orig)
> +		goto err;
> +
> +	if (vduse_domain_add_mapping(domain, iova,
> +				(unsigned long)orig, size, DMA_BIDIRECTIONAL))
> +		goto err;
> +
> +	*dma_addr = (dma_addr_t)iova;
> +
> +	return orig;
> +err:
> +	*dma_addr = DMA_MAPPING_ERROR;
> +	if (orig)
> +		free_pages_exact(orig, size);
> +	if (iova)
> +		vduse_domain_free_iova(domain, iova, size);
> +
> +	return NULL;
> +}
> +
> +static void vduse_dev_free_coherent(struct device *dev, size_t size,
> +					void *vaddr, dma_addr_t dma_addr,
> +					unsigned long attrs)
> +{
> +	struct vduse_dev *vdev = dev_to_vduse(dev);
> +	struct vduse_iova_domain *domain = vdev->domain;
> +	unsigned long iova = (unsigned long)dma_addr;
> +	struct vduse_iova_map *map = vduse_domain_get_mapping(domain, iova);
> +
> +	if (WARN_ON(!map))
> +		return;
> +
> +	vduse_domain_remove_mapping(domain, map);
> +	vduse_domain_unmap(domain, map->iova, PAGE_ALIGN(map->size));
> +	free_pages_exact((void *)map->orig, map->size);
> +	vduse_domain_free_iova(domain, map->iova, map->size);
> +	kfree(map);
> +}
> +
> +static const struct dma_map_ops vduse_dev_dma_ops = {
> +	.map_page = vduse_dev_map_page,
> +	.unmap_page = vduse_dev_unmap_page,
> +	.alloc = vduse_dev_alloc_coherent,
> +	.free = vduse_dev_free_coherent,
> +};
> +
> +static void vduse_dev_mmap_open(struct vm_area_struct *vma)
> +{
> +	struct vduse_iova_domain *domain = vma->vm_private_data;
> +
> +	if (!vduse_domain_add_vma(domain, vma))
> +		return;
> +
> +	vma->vm_private_data = NULL;
> +}
> +
> +static void vduse_dev_mmap_close(struct vm_area_struct *vma)
> +{
> +	struct vduse_iova_domain *domain = vma->vm_private_data;
> +
> +	if (!domain)
> +		return;
> +
> +	vduse_domain_remove_vma(domain, vma);
> +}
> +
> +static int vduse_dev_mmap_split(struct vm_area_struct *vma, unsigned long addr)
> +{
> +	return -EPERM;
> +}
> +
> +static vm_fault_t vduse_dev_mmap_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct vduse_iova_domain *domain = vma->vm_private_data;
> +	unsigned long iova = vmf->address - vma->vm_start;
> +	int ret;
> +
> +	if (!domain)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (vduse_domain_is_direct_map(domain, iova))
> +		ret = vduse_domain_direct_map(domain, vma, iova);
> +	else
> +		ret = vduse_domain_bounce_map(domain, vma, iova);
> +
> +	if (ret == -ENOMEM)
> +		return VM_FAULT_OOM;
> +	if (ret < 0 && ret != -EBUSY)
> +		return VM_FAULT_SIGBUS;
> +
> +	return VM_FAULT_NOPAGE;
> +}
> +
> +static const struct vm_operations_struct vduse_dev_mmap_ops = {
> +	.open = vduse_dev_mmap_open,
> +	.close = vduse_dev_mmap_close,
> +	.may_split = vduse_dev_mmap_split,
> +	.fault = vduse_dev_mmap_fault,
> +};
> +
> +static int vduse_dev_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct vduse_dev *dev = file->private_data;
> +	struct vduse_iova_domain *domain = dev->domain;
> +	unsigned long size = vma->vm_end - vma->vm_start;
> +	int ret;
> +
> +	if (domain->size != size || vma->vm_pgoff)
> +		return -EINVAL;
> +
> +	ret = vduse_domain_add_vma(domain, vma);
> +	if (ret)
> +		return ret;
> +
> +	vma->vm_flags |= VM_MIXEDMAP | VM_DONTCOPY |
> +				VM_DONTDUMP | VM_DONTEXPAND;
> +	vma->vm_private_data = domain;
> +	vma->vm_ops = &vduse_dev_mmap_ops;
> +
> +	return 0;
> +}
> +
> +static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
> +			unsigned long arg)
> +{
> +	struct vduse_dev *dev = file->private_data;
> +	void __user *argp = (void __user *)arg;
> +	int ret;
> +
> +	mutex_lock(&dev->lock);
> +	switch (cmd) {
> +	case VDUSE_VQ_SETUP_KICKFD: {
> +		struct vduse_vq_eventfd eventfd;
> +
> +		ret = -EFAULT;
> +		if (copy_from_user(&eventfd, argp, sizeof(eventfd)))
> +			break;
> +
> +		ret = vduse_kickfd_setup(dev, &eventfd);
> +		break;
> +	}
> +	case VDUSE_VQ_SETUP_IRQFD: {
> +		struct vduse_vq_eventfd eventfd;
> +
> +		ret = -EFAULT;
> +		if (copy_from_user(&eventfd, argp, sizeof(eventfd)))
> +			break;
> +
> +		ret = vduse_virqfd_setup(dev, &eventfd);
> +		break;
> +	}
> +	}
> +	mutex_unlock(&dev->lock);
> +
> +	return ret;
> +}
> +
> +static int vduse_dev_release(struct inode *inode, struct file *file)
> +{
> +	struct vduse_dev *dev = file->private_data;
> +	struct vduse_dev_msg *msg;
> +
> +	while ((msg = vduse_dev_dequeue_msg(dev, &dev->recv_list)))
> +		vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> +
> +	refcount_dec(&dev->refcnt);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations vduse_dev_fops = {
> +	.owner		= THIS_MODULE,
> +	.release	= vduse_dev_release,
> +	.read_iter	= vduse_dev_read_iter,
> +	.write_iter	= vduse_dev_write_iter,
> +	.poll		= vduse_dev_poll,
> +	.mmap		= vduse_dev_mmap,
> +	.unlocked_ioctl	= vduse_dev_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
> +	.llseek		= noop_llseek,
> +};
> +
> +static struct vduse_dev *vduse_dev_create(void)
> +{
> +	struct vduse_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +
> +	if (!dev)
> +		return NULL;
> +
> +	mutex_init(&dev->lock);
> +	spin_lock_init(&dev->msg_lock);
> +	INIT_LIST_HEAD(&dev->send_list);
> +	INIT_LIST_HEAD(&dev->recv_list);
> +	atomic64_set(&dev->msg_unique, 0);
> +	init_waitqueue_head(&dev->waitq);
> +	refcount_set(&dev->refcnt, 1);
> +
> +	return dev;
> +}
> +
> +static void vduse_dev_destroy(struct vduse_dev *dev)
> +{
> +	mutex_destroy(&dev->lock);
> +	kfree(dev);
> +}
> +
> +static struct vduse_dev *vduse_find_dev(u32 id)
> +{
> +	struct vduse_dev *tmp, *dev = NULL;
> +
> +	list_for_each_entry(tmp, &vduse_devs, list) {
> +		if (tmp->id == id) {
> +			dev = tmp;
> +			break;
> +		}
> +	}
> +	return dev;
> +}
> +
> +static int vduse_get_dev(u32 id)
> +{
> +	int fd;
> +	char name[64];
> +	struct vduse_dev *dev = vduse_find_dev(id);
> +
> +	if (!dev)
> +		return -EINVAL;
> +
> +	snprintf(name, sizeof(name), "vduse-dev:%u", dev->id);
> +	fd = anon_inode_getfd(name, &vduse_dev_fops, dev, O_RDWR | O_CLOEXEC);
> +	if (fd < 0)
> +		return fd;
> +
> +	refcount_inc(&dev->refcnt);
> +
> +	return fd;
> +}
> +
> +static int vduse_destroy_dev(u32 id)
> +{
> +	struct vduse_dev *dev = vduse_find_dev(id);
> +
> +	if (!dev)
> +		return -EINVAL;
> +
> +	if (dev->vdev || refcount_read(&dev->refcnt) > 1)
> +		return -EBUSY;
> +
> +	list_del(&dev->list);
> +	kfree(dev->vqs);
> +	vduse_iova_domain_destroy(dev->domain);
> +	vduse_dev_destroy(dev);
> +
> +	return 0;
> +}
> +
> +static int vduse_create_dev(struct vduse_dev_config *config)
> +{
> +	int i, fd;
> +	struct vduse_dev *dev;
> +	char name[64];
> +
> +	if (vduse_find_dev(config->id))
> +		return -EEXIST;
> +
> +	dev = vduse_dev_create();
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->id = config->id;
> +	dev->device_id = config->device_id;
> +	dev->vendor_id = config->vendor_id;
> +	dev->domain = vduse_iova_domain_create(config->iova_size);
> +	if (!dev->domain)
> +		goto err_domain;
> +
> +	dev->vq_align = config->vq_align;
> +	dev->vq_size_max = config->vq_size_max;
> +	dev->vq_num = config->vq_num;
> +	dev->vqs = kcalloc(dev->vq_num, sizeof(*dev->vqs), GFP_KERNEL);
> +	if (!dev->vqs)
> +		goto err_vqs;
> +
> +	for (i = 0; i < dev->vq_num; i++) {
> +		dev->vqs[i].index = i;
> +		spin_lock_init(&dev->vqs[i].kick_lock);
> +		spin_lock_init(&dev->vqs[i].irq_lock);
> +	}
> +
> +	snprintf(name, sizeof(name), "vduse-dev:%u", config->id);
> +	fd = anon_inode_getfd(name, &vduse_dev_fops, dev, O_RDWR | O_CLOEXEC);
> +	if (fd < 0)
> +		goto err_fd;
> +
> +	refcount_inc(&dev->refcnt);
> +	list_add(&dev->list, &vduse_devs);
> +
> +	return fd;
> +err_fd:
> +	kfree(dev->vqs);
> +err_vqs:
> +	vduse_iova_domain_destroy(dev->domain);
> +err_domain:
> +	vduse_dev_destroy(dev);
> +	return fd;
> +}
> +
> +static long vduse_ioctl(struct file *file, unsigned int cmd,
> +			unsigned long arg)
> +{
> +	int ret;
> +	void __user *argp = (void __user *)arg;
> +
> +	mutex_lock(&vduse_lock);
> +	switch (cmd) {
> +	case VDUSE_CREATE_DEV: {
> +		struct vduse_dev_config config;
> +
> +		ret = -EFAULT;
> +		if (copy_from_user(&config, argp, sizeof(config)))
> +			break;
> +
> +		ret = vduse_create_dev(&config);
> +		break;
> +	}
> +	case VDUSE_GET_DEV:
> +		ret = vduse_get_dev(arg);
> +		break;


What's the use case of VDUSE_GET_DEV? (Need to document this)


> +	case VDUSE_DESTROY_DEV:
> +		ret = vduse_destroy_dev(arg);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +	mutex_unlock(&vduse_lock);
> +
> +	return ret;
> +}
> +
> +static const struct file_operations vduse_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= vduse_ioctl,
> +	.compat_ioctl	= compat_ptr_ioctl,
> +	.llseek		= noop_llseek,
> +};
> +
> +static struct miscdevice vduse_misc = {
> +	.fops = &vduse_fops,
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "vduse",
> +};
> +
> +static void vduse_parent_release(struct device *dev)
> +{
> +}
> +
> +static struct device vduse_parent = {
> +	.init_name = "vduse",
> +	.release = vduse_parent_release,
> +};
> +
> +static struct vdpa_parent_dev parent_dev;
> +
> +static int vduse_dev_add_vdpa(struct vduse_dev *dev, const char *name)
> +{
> +	struct vduse_vdpa *vdev = dev->vdev;
> +	int ret;
> +
> +	if (vdev)
> +		return -EEXIST;
> +
> +	vdev = vdpa_alloc_device(struct vduse_vdpa, vdpa, NULL,
> +				&vduse_vdpa_config_ops, dev->vq_num, name);
> +	if (!vdev)
> +		return -ENOMEM;
> +
> +	vdev->dev = dev;
> +	vdev->vdpa.dev.dma_mask = &vdev->vdpa.dev.coherent_dma_mask;
> +	ret = dma_set_mask_and_coherent(&vdev->vdpa.dev, DMA_BIT_MASK(64));
> +	if (ret)
> +		goto err;
> +
> +	set_dma_ops(&vdev->vdpa.dev, &vduse_dev_dma_ops);
> +	vdev->vdpa.dma_dev = &vdev->vdpa.dev;
> +	vdev->vdpa.pdev = &parent_dev;
> +
> +	ret = _vdpa_register_device(&vdev->vdpa);
> +	if (ret)
> +		goto err;
> +
> +	dev->vdev = vdev;
> +
> +	return 0;
> +err:
> +	put_device(&vdev->vdpa.dev);
> +	return ret;
> +}
> +
> +static struct vdpa_device *vdpa_dev_add(struct vdpa_parent_dev *pdev,
> +					const char *name, u32 device_id,
> +					struct nlattr **attrs)
> +{
> +	u32 vduse_id;
> +	struct vduse_dev *dev;
> +	int ret = -EINVAL;
> +
> +	if (!attrs[VDPA_ATTR_BACKEND_ID])
> +		return ERR_PTR(-EINVAL);
> +
> +	mutex_lock(&vduse_lock);
> +	vduse_id = nla_get_u32(attrs[VDPA_ATTR_BACKEND_ID]);
> +	dev = vduse_find_dev(vduse_id);
> +	if (!dev)
> +		goto unlock;
> +
> +	if (dev->device_id != device_id)
> +		goto unlock;
> +
> +	ret = vduse_dev_add_vdpa(dev, name);
> +unlock:
> +	mutex_unlock(&vduse_lock);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	return &dev->vdev->vdpa;
> +}
> +
> +static void vdpa_dev_del(struct vdpa_parent_dev *pdev, struct vdpa_device *dev)
> +{
> +	_vdpa_unregister_device(dev);
> +}
> +
> +static const struct vdpa_dev_ops vdpa_dev_parent_ops = {
> +	.dev_add = vdpa_dev_add,
> +	.dev_del = vdpa_dev_del
> +};
> +
> +static struct virtio_device_id id_table[] = {
> +	{ VIRTIO_DEV_ANY_ID, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
> +
> +static struct vdpa_parent_dev parent_dev = {
> +	.device = &vduse_parent,
> +	.id_table = id_table,
> +	.ops = &vdpa_dev_parent_ops,
> +};
> +
> +static int vduse_parentdev_init(void)
> +{
> +	int ret;
> +
> +	ret = device_register(&vduse_parent);
> +	if (ret)
> +		return ret;
> +
> +	ret = vdpa_parentdev_register(&parent_dev);
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +err:
> +	device_unregister(&vduse_parent);
> +	return ret;
> +}
> +
> +static void vduse_parentdev_exit(void)
> +{
> +	vdpa_parentdev_unregister(&parent_dev);
> +	device_unregister(&vduse_parent);
> +}
> +
> +static int vduse_init(void)
> +{
> +	int ret;
> +
> +	ret = misc_register(&vduse_misc);
> +	if (ret)
> +		return ret;
> +
> +	ret = -ENOMEM;
> +	vduse_vdpa_wq = alloc_workqueue("vduse-vdpa", WQ_UNBOUND, 1);
> +	if (!vduse_vdpa_wq)
> +		goto err_vdpa_wq;
> +
> +	ret = vduse_virqfd_init();
> +	if (ret)
> +		goto err_irqfd;
> +
> +	ret = vduse_parentdev_init();
> +	if (ret)
> +		goto err_parentdev;
> +
> +	return 0;
> +err_parentdev:
> +	vduse_virqfd_exit();
> +err_irqfd:
> +	destroy_workqueue(vduse_vdpa_wq);
> +err_vdpa_wq:
> +	misc_deregister(&vduse_misc);
> +	return ret;
> +}
> +module_init(vduse_init);
> +
> +static void vduse_exit(void)
> +{
> +	misc_deregister(&vduse_misc);
> +	destroy_workqueue(vduse_vdpa_wq);
> +	vduse_virqfd_exit();
> +	vduse_parentdev_exit();
> +}
> +module_exit(vduse_exit);
> +
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE(DRV_LICENSE);
> +MODULE_AUTHOR(DRV_AUTHOR);
> +MODULE_DESCRIPTION(DRV_DESC);
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> index bba8b83a94b5..a7a841e5ffc7 100644
> --- a/include/uapi/linux/vdpa.h
> +++ b/include/uapi/linux/vdpa.h
> @@ -33,6 +33,7 @@ enum vdpa_attr {
>   	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
>   	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
>   	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
> +	VDPA_ATTR_BACKEND_ID,			/* u32 */
>   
>   	/* new attributes must be added above here */
>   	VDPA_ATTR_MAX,
> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> new file mode 100644
> index 000000000000..f8579abdaa3b
> --- /dev/null
> +++ b/include/uapi/linux/vduse.h
> @@ -0,0 +1,99 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_VDUSE_H_
> +#define _UAPI_VDUSE_H_
> +
> +#include <linux/types.h>
> +
> +/* the control messages definition for read/write */
> +
> +#define VDUSE_CONFIG_DATA_LEN	256
> +
> +enum vduse_req_type {
> +	VDUSE_SET_VQ_NUM,
> +	VDUSE_SET_VQ_ADDR,
> +	VDUSE_SET_VQ_READY,
> +	VDUSE_GET_VQ_READY,
> +	VDUSE_SET_FEATURES,
> +	VDUSE_GET_FEATURES,
> +	VDUSE_SET_STATUS,
> +	VDUSE_GET_STATUS,
> +	VDUSE_SET_CONFIG,
> +	VDUSE_GET_CONFIG,
> +};
> +
> +struct vduse_vq_num {
> +	__u32 index;
> +	__u32 num;
> +};
> +
> +struct vduse_vq_addr {
> +	__u32 index;
> +	__u64 desc_addr;
> +	__u64 driver_addr;
> +	__u64 device_addr;
> +};
> +
> +struct vduse_vq_ready {
> +	__u32 index;
> +	__u8 ready;
> +};
> +
> +struct vduse_dev_config_data {
> +	__u32 offset;
> +	__u32 len;
> +	__u8 data[VDUSE_CONFIG_DATA_LEN];
> +};
> +
> +struct vduse_dev_request {
> +	__u32 type; /* request type */
> +	__u32 unique; /* request id */
> +	__u32 flags; /* request flags */
> +	__u32 size; /* the payload size */
> +	union {
> +		struct vduse_vq_num vq_num; /* virtqueue num */
> +		struct vduse_vq_addr vq_addr; /* virtqueue address */
> +		struct vduse_vq_ready vq_ready; /* virtqueue ready status */
> +		struct vduse_dev_config_data config; /* virtio device config space */
> +		__u64 features; /* virtio features */
> +		__u8 status; /* device status */
> +	};
> +};
> +
> +struct vduse_dev_response {
> +	__u32 unique; /* corresponding request id */
> +	__s32 result; /* the result of request */
> +	union {
> +		struct vduse_vq_ready vq_ready; /* virtqueue ready status */
> +		struct vduse_dev_config_data config; /* virtio device config space */
> +		__u64 features; /* virtio features */
> +		__u8 status; /* device status */
> +	};
> +};
> +
> +/* ioctls */
> +
> +struct vduse_dev_config {
> +	__u32 id; /* vduse device id */
> +	__u32 vendor_id; /* virtio vendor id */
> +	__u32 device_id; /* virtio device id */
> +	__u64 iova_size; /* iova space size, used for mmap(2) */
> +	__u16 vq_num; /* the number of virtqueues */
> +	__u16 vq_size_max; /* the max size of virtqueue */
> +	__u32 vq_align; /* the allocation alignment of virtqueue's metadata */
> +};
> +
> +struct vduse_vq_eventfd {
> +	__u32 index; /* virtqueue index */
> +	__u32 fd; /* eventfd */
> +};
> +
> +#define VDUSE_BASE	0x81
> +
> +#define VDUSE_CREATE_DEV	_IOW(VDUSE_BASE, 0x01, struct vduse_dev_config)
> +#define VDUSE_GET_DEV		_IO(VDUSE_BASE, 0x02)
> +#define VDUSE_DESTROY_DEV	_IO(VDUSE_BASE, 0x03)
> +
> +#define VDUSE_VQ_SETUP_KICKFD	_IOW(VDUSE_BASE, 0x04, struct vduse_vq_eventfd)
> +#define VDUSE_VQ_SETUP_IRQFD	_IOW(VDUSE_BASE, 0x05, struct vduse_vq_eventfd)
> +
> +#endif /* _UAPI_VDUSE_H_ */

