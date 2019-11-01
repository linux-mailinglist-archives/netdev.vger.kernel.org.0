Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E1CEBE66
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 08:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfKAHSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 03:18:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49562 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729965AbfKAHSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 03:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572592684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4yFBfK6P5qO2iGdElvY9cHWNWW3eh/j179BCPUqcV0=;
        b=atr6DPzXqG24fiSPKZjBqqEode72e5PWQ++EiXtYCIrVayoB4I14fd6brNN1huYZzwCYbh
        c/8bU93URiQkHf3dcdZLXdodo2+RM6paH3uDQdZXEBU4BP6IKL3TGDCfFAz8PlqazmSDH7
        KxPyam/Eonss+Fh7UP1YkTR0N5bdfvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-vmEXXq4tO1KNPerKdQYPQA-1; Fri, 01 Nov 2019 03:17:55 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B13F5107ACC0;
        Fri,  1 Nov 2019 07:17:53 +0000 (UTC)
Received: from [10.72.12.30] (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30C515D6A7;
        Fri,  1 Nov 2019 07:17:40 +0000 (UTC)
Subject: Re: [PATCH v4] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, maxime.coquelin@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20191031140114.25615-1-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f9036643-7aaf-7107-8bf0-85975ab95d4b@redhat.com>
Date:   Fri, 1 Nov 2019 15:17:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191031140114.25615-1-tiwei.bie@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: vmEXXq4tO1KNPerKdQYPQA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/31 =E4=B8=8B=E5=8D=8810:01, Tiwei Bie wrote:
> This patch introduces a mdev based hardware vhost backend.
> This backend is built on top of the same abstraction used
> in virtio-mdev and provides a generic vhost interface for
> userspace to accelerate the virtio devices in guest.
>
> This backend is implemented as a mdev device driver on top
> of the same mdev device ops used in virtio-mdev but using
> a different mdev class id, and it will register the device
> as a VFIO device for userspace to use. Userspace can setup
> the IOMMU with the existing VFIO container/group APIs and
> then get the device fd with the device name. After getting
> the device fd of this device, userspace can use vhost ioctls
> to setup the backend.
>
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> ---
> This patch depends on below series:
> https://lkml.org/lkml/2019/10/30/62
>
> v3 -> v4:
> - Rebase on top of virtio-mdev series v6;
> - Some minor tweaks and improvements;
>
> v2 -> v3:
> - Fix the return value (Jason);
> - Don't cache unnecessary information in vhost-mdev (Jason);
> - Get rid of the memset in open (Jason);
> - Add comments for VHOST_SET_MEM_TABLE, ... (Jason);
> - Filter out unsupported features in vhost-mdev (Jason);
> - Add _GET_DEVICE_ID ioctl (Jason);
> - Add _GET_CONFIG/_SET_CONFIG ioctls (Jason);
> - Drop _GET_QUEUE_NUM ioctl (Jason);
> - Fix the copy-paste errors in _IOW/_IOR usage;
> - Some minor fixes and improvements;
>
> v1 -> v2:
> - Replace _SET_STATE with _SET_STATUS (MST);
> - Check status bits at each step (MST);
> - Report the max ring size and max number of queues (MST);
> - Add missing MODULE_DEVICE_TABLE (Jason);
> - Only support the network backend w/o multiqueue for now;
> - Some minor fixes and improvements;
> - Rebase on top of virtio-mdev series v4;
>
> RFC v4 -> v1:
> - Implement vhost-mdev as a mdev device driver directly and
>    connect it to VFIO container/group. (Jason);
> - Pass ring addresses as GPAs/IOVAs in vhost-mdev to avoid
>    meaningless HVA->GPA translations (Jason);
>
> RFC v3 -> RFC v4:
> - Build vhost-mdev on top of the same abstraction used by
>    virtio-mdev (Jason);
> - Introduce vhost fd and pass VFIO fd via SET_BACKEND ioctl (MST);
>
> RFC v2 -> RFC v3:
> - Reuse vhost's ioctls instead of inventing a VFIO regions/irqs
>    based vhost protocol on top of vfio-mdev (Jason);
>
> RFC v1 -> RFC v2:
> - Introduce a new VFIO device type to build a vhost protocol
>    on top of vfio-mdev;
>
>   drivers/vfio/mdev/mdev_core.c    |  20 ++
>   drivers/vfio/mdev/mdev_private.h |   1 +
>   drivers/vhost/Kconfig            |  12 +
>   drivers/vhost/Makefile           |   3 +
>   drivers/vhost/mdev.c             | 556 +++++++++++++++++++++++++++++++
>   include/linux/mdev.h             |   5 +
>   include/uapi/linux/vhost.h       |  18 +
>   include/uapi/linux/vhost_types.h |   8 +
>   8 files changed, 623 insertions(+)
>   create mode 100644 drivers/vhost/mdev.c
>
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index 22ca589750d8..109dbac01a8f 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -96,6 +96,26 @@ mdev_get_virtio_ops(struct mdev_device *mdev)
>   }
>   EXPORT_SYMBOL(mdev_get_virtio_ops);
>  =20
> +/* Specify the vhost device ops for the mdev device, this
> + * must be called during create() callback for vhost mdev device.
> + */
> +void mdev_set_vhost_ops(struct mdev_device *mdev,
> +=09=09=09const struct virtio_mdev_device_ops *vhost_ops)
> +{
> +=09mdev_set_class(mdev, MDEV_CLASS_ID_VHOST);
> +=09mdev->vhost_ops =3D vhost_ops;
> +}
> +EXPORT_SYMBOL(mdev_set_vhost_ops);
> +
> +/* Get the vhost device ops for the mdev device. */
> +const struct virtio_mdev_device_ops *
> +mdev_get_vhost_ops(struct mdev_device *mdev)
> +{
> +=09WARN_ON(mdev->class_id !=3D MDEV_CLASS_ID_VHOST);
> +=09return mdev->vhost_ops;
> +}
> +EXPORT_SYMBOL(mdev_get_vhost_ops);
> +
>   struct device *mdev_dev(struct mdev_device *mdev)
>   {
>   =09return &mdev->dev;
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_pr=
ivate.h
> index 7b47890c34e7..5597c846e52f 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -40,6 +40,7 @@ struct mdev_device {
>   =09union {
>   =09=09const struct vfio_mdev_device_ops *vfio_ops;
>   =09=09const struct virtio_mdev_device_ops *virtio_ops;
> +=09=09const struct virtio_mdev_device_ops *vhost_ops;


Any reason why virtio_ops is not used for vhost here?

Other looks good.

Thanks


