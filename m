Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83D71EB335
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 04:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgFBCEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 22:04:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24783 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726019AbgFBCEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 22:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591063458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PedYmW3SLiDBFf7zOV+n1NX3iWWaRGxmR+P2IYjNGD0=;
        b=gA6L7saCCGA3p//z+G1u5EoWp/Gmmm9y3WOqqSYW954s92/T7fSLYr82ETm/39xZ1bUWlM
        x6T5w2DSj6j2K7nWp9k+THIF4qL+YOHosjQebcgV3TX3ToW0l7XcsCWrV6Vh778vyc6P+1
        dDdtZgKE6ixvdTLyn64EFvXlKJBP75w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-YHfUNmPeMFuri27MHJyvTw-1; Mon, 01 Jun 2020 22:04:14 -0400
X-MC-Unique: YHfUNmPeMFuri27MHJyvTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A12D0107ACCA;
        Tue,  2 Jun 2020 02:04:13 +0000 (UTC)
Received: from [10.72.12.140] (ovpn-12-140.pek2.redhat.com [10.72.12.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29CAE60C80;
        Tue,  2 Jun 2020 02:04:10 +0000 (UTC)
Subject: Re: [virtio-dev] Re: [PATCH 4/6] vhost_vdpa: support doorbell mapping
 via mmap
To:     Rob Miller <rob.miller@broadcom.com>,
        Virtio-Dev <virtio-dev@lists.oasis-open.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-5-jasowang@redhat.com>
 <CAJPjb1JGn-+Y2EHvn1S+=uX_cjPVEUmGGo7CmAM2kTqyn4NRYQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e8a88037-4027-b919-684d-9b83416c1c12@redhat.com>
Date:   Tue, 2 Jun 2020 10:04:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAJPjb1JGn-+Y2EHvn1S+=uX_cjPVEUmGGo7CmAM2kTqyn4NRYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/30 上午2:30, Rob Miller wrote:
> Given the need for 4K doorbell such that QEMU can easily map, ect, and 
> assuming that I have a HW device which exposes 2 VQ's, with a 
> notification area off of BAR3, offset=whatever, notifier_multiplier=4, 
> we don't need to have 2 x 4K pages mapped into the VM for both 
> doorbells do we? The guest driver would ring DB0 at BAR4+offset, and 
> DB1 at BAR4+offset+(4*1).


This requires qemu to advertise notifier_multiplier = 4 to guest, it has 
several implications:

- guest may think control virtqueue sit in the same page then we can't 
trap access to control virtqueue, qemu may lose the state of the device
- it requires the destination to have exact the same queue_notify_off 
and notifier_multiplier in order to let migration to work

So for doorbell mapping itself, we can support the mapping of doorbells 
at once which may occupy one or more pages, but it may bring troubles 
for other features.


>
> The 4K per DB is useful how? This allows for QEMU trapping of 
> individual DBs, that can then be used to do what, just forward the DBs 
> via some other scheme - this makes sense for non-HW related Virtio 
> devices I guess. Is this why there is a qemu option?


The page per vq option provides extra flexibility. Note that it's the 
layout seen by guest, so actually for hardware vendor, the most easy way 
is to:

- use a single doorbell register for all virtqueues except for the 
control virtqueue (driver can differ queue index by the value wrote by 
the driver)
- do not share the page with other registers

In this way, it doesn't require much BAR space and we can still:

- map doorbell separately to guest: guest may see a page per vq doorbell 
layout but in fact all those pages are mapped into the same page
- trap the control virtqueue, (don't do mmap for control vq)

Thanks


>
> Rob Miller
> rob.miller@broadcom.com <mailto:rob.miller@broadcom.com>
> (919)721-3339
>
>
> On Fri, May 29, 2020 at 4:03 AM Jason Wang <jasowang@redhat.com 
> <mailto:jasowang@redhat.com>> wrote:
>
>     Currently the doorbell is relayed via eventfd which may have
>     significant overhead because of the cost of vmexits or syscall. This
>     patch introduces mmap() based doorbell mapping which can eliminate the
>     overhead caused by vmexit or syscall.
>
>     To ease the userspace modeling of the doorbell layout (usually
>     virtio-pci), this patch starts from a doorbell per page
>     model. Vhost-vdpa only support the hardware doorbell that sit at the
>     boundary of a page and does not share the page with other registers.
>
>     Doorbell of each virtqueue must be mapped separately, pgoff is the
>     index of the virtqueue. This allows userspace to map a subset of the
>     doorbell which may be useful for the implementation of software
>     assisted virtqueue (control vq) in the future.
>
>     Signed-off-by: Jason Wang <jasowang@redhat.com
>     <mailto:jasowang@redhat.com>>
>     ---
>      drivers/vhost/vdpa.c | 59
>     ++++++++++++++++++++++++++++++++++++++++++++
>      1 file changed, 59 insertions(+)
>
>     diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>     index 6ff72289f488..bbe23cea139a 100644
>     --- a/drivers/vhost/vdpa.c
>     +++ b/drivers/vhost/vdpa.c
>     @@ -15,6 +15,7 @@
>      #include <linux/module.h>
>      #include <linux/cdev.h>
>      #include <linux/device.h>
>     +#include <linux/mm.h>
>      #include <linux/iommu.h>
>      #include <linux/uuid.h>
>      #include <linux/vdpa.h>
>     @@ -741,12 +742,70 @@ static int vhost_vdpa_release(struct inode
>     *inode, struct file *filep)
>             return 0;
>      }
>
>     +static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
>     +{
>     +       struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
>     +       struct vdpa_device *vdpa = v->vdpa;
>     +       const struct vdpa_config_ops *ops = vdpa->config;
>     +       struct vdpa_notification_area notify;
>     +       struct vm_area_struct *vma = vmf->vma;
>     +       u16 index = vma->vm_pgoff;
>     +
>     +       notify = ops->get_vq_notification(vdpa, index);
>     +
>     +       vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>     +       if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
>     +                           notify.addr >> PAGE_SHIFT, PAGE_SIZE,
>     +                           vma->vm_page_prot))
>     +               return VM_FAULT_SIGBUS;
>     +
>     +       return VM_FAULT_NOPAGE;
>     +}
>     +
>     +static const struct vm_operations_struct vhost_vdpa_vm_ops = {
>     +       .fault = vhost_vdpa_fault,
>     +};
>     +
>     +static int vhost_vdpa_mmap(struct file *file, struct
>     vm_area_struct *vma)
>     +{
>     +       struct vhost_vdpa *v = vma->vm_file->private_data;
>     +       struct vdpa_device *vdpa = v->vdpa;
>     +       const struct vdpa_config_ops *ops = vdpa->config;
>     +       struct vdpa_notification_area notify;
>     +       int index = vma->vm_pgoff;
>     +
>     +       if (vma->vm_end - vma->vm_start != PAGE_SIZE)
>     +               return -EINVAL;
>     +       if ((vma->vm_flags & VM_SHARED) == 0)
>     +               return -EINVAL;
>     +       if (vma->vm_flags & VM_READ)
>     +               return -EINVAL;
>     +       if (index > 65535)
>     +               return -EINVAL;
>     +       if (!ops->get_vq_notification)
>     +               return -ENOTSUPP;
>     +
>     +       /* To be safe and easily modelled by userspace, We only
>     +        * support the doorbell which sits on the page boundary and
>     +        * does not share the page with other registers.
>     +        */
>     +       notify = ops->get_vq_notification(vdpa, index);
>     +       if (notify.addr & (PAGE_SIZE - 1))
>     +               return -EINVAL;
>     +       if (vma->vm_end - vma->vm_start != notify.size)
>     +               return -ENOTSUPP;
>     +
>     +       vma->vm_ops = &vhost_vdpa_vm_ops;
>     +       return 0;
>     +}
>     +
>      static const struct file_operations vhost_vdpa_fops = {
>             .owner          = THIS_MODULE,
>             .open           = vhost_vdpa_open,
>             .release        = vhost_vdpa_release,
>             .write_iter     = vhost_vdpa_chr_write_iter,
>             .unlocked_ioctl = vhost_vdpa_unlocked_ioctl,
>     +       .mmap           = vhost_vdpa_mmap,
>             .compat_ioctl   = compat_ptr_ioctl,
>      };
>
>     -- 
>     2.20.1
>

