Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFDFE8621
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbfJ2Kv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:51:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55842 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731386AbfJ2Kv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:51:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572346315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kM0JNiY187v6wEt+j+0YP4rGxuxjA2De0OZc6dXPUnE=;
        b=LjG10Lw6AyMJ/jelJvxencK3H/0l160X/1ZpICoT5gveqI+nx1NNIqI5FW/2KERD69Taw4
        GS3Vu7IqimQQ43HL5OrXszd3t7rKJLBLntvU3XIy18MEV1UKSDHo4L2iqfor2bkLpp3E+7
        GDPKx76J/5T1ZD5Nb3IJ9l6pYRabQcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-lEk6vtPrN4KZlTgdDQ9b4g-1; Tue, 29 Oct 2019 06:51:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEE8D8017DD;
        Tue, 29 Oct 2019 10:51:50 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 871725D6C3;
        Tue, 29 Oct 2019 10:51:35 +0000 (UTC)
Subject: Re: [RFC] vhost_mdev: add network control vq support
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20191029101726.12699-1-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <59474431-9e77-567c-9a46-a3965f587f65@redhat.com>
Date:   Tue, 29 Oct 2019 18:51:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191029101726.12699-1-tiwei.bie@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: lEk6vtPrN4KZlTgdDQ9b4g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/29 =E4=B8=8B=E5=8D=886:17, Tiwei Bie wrote:
> This patch adds the network control vq support in vhost-mdev.
> A vhost-mdev specific op is introduced to allow parent drivers
> to handle the network control commands come from userspace.


Probably work for userspace driver but not kernel driver.


>
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> ---
> This patch depends on below patch:
> https://lkml.org/lkml/2019/10/29/335
>
>  drivers/vhost/mdev.c             | 37 ++++++++++++++++++++++++++++++--
>  include/linux/virtio_mdev_ops.h  | 10 +++++++++
>  include/uapi/linux/vhost.h       |  7 ++++++
>  include/uapi/linux/vhost_types.h |  6 ++++++
>  4 files changed, 58 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/mdev.c b/drivers/vhost/mdev.c
> index 35b2fb33e686..c9b3eaa77405 100644
> --- a/drivers/vhost/mdev.c
> +++ b/drivers/vhost/mdev.c
> @@ -47,6 +47,13 @@ enum {
>  =09=09(1ULL << VIRTIO_NET_F_HOST_UFO) |
>  =09=09(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
>  =09=09(1ULL << VIRTIO_NET_F_STATUS) |
> +=09=09(1ULL << VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) |
> +=09=09(1ULL << VIRTIO_NET_F_CTRL_VQ) |
> +=09=09(1ULL << VIRTIO_NET_F_CTRL_RX) |
> +=09=09(1ULL << VIRTIO_NET_F_CTRL_VLAN) |
> +=09=09(1ULL << VIRTIO_NET_F_CTRL_RX_EXTRA) |
> +=09=09(1ULL << VIRTIO_NET_F_GUEST_ANNOUNCE) |
> +=09=09(1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR) |
>  =09=09(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
>  };
> =20
> @@ -362,6 +369,29 @@ static long vhost_mdev_vring_ioctl(struct vhost_mdev=
 *m, unsigned int cmd,
>  =09return r;
>  }
> =20
> +/*
> + * Device specific (e.g. network) ioctls.
> + */
> +static long vhost_mdev_dev_ioctl(struct vhost_mdev *m, unsigned int cmd,
> +=09=09=09=09 void __user *argp)
> +{
> +=09struct mdev_device *mdev =3D m->mdev;
> +=09const struct virtio_mdev_device_ops *ops =3D mdev_get_vhost_ops(mdev)=
;
> +
> +=09switch (m->virtio_id) {
> +=09case VIRTIO_ID_NET:
> +=09=09switch (cmd) {
> +=09=09case VHOST_MDEV_NET_CTRL:
> +=09=09=09if (!ops->net.ctrl)
> +=09=09=09=09return -ENOTSUPP;
> +=09=09=09return ops->net.ctrl(mdev, argp);
> +=09=09}
> +=09=09break;
> +=09}
> +
> +=09return -ENOIOCTLCMD;
> +}


As you comment above, then vhost-mdev need device specific stuffs.


> +
>  static int vhost_mdev_open(void *device_data)
>  {
>  =09struct vhost_mdev *m =3D device_data;
> @@ -460,8 +490,11 @@ static long vhost_mdev_unlocked_ioctl(void *device_d=
ata,
>  =09=09 * VHOST_SET_LOG_FD are not used yet.
>  =09=09 */
>  =09=09r =3D vhost_dev_ioctl(&m->dev, cmd, argp);
> -=09=09if (r =3D=3D -ENOIOCTLCMD)
> -=09=09=09r =3D vhost_mdev_vring_ioctl(m, cmd, argp);
> +=09=09if (r =3D=3D -ENOIOCTLCMD) {
> +=09=09=09r =3D vhost_mdev_dev_ioctl(m, cmd, argp);
> +=09=09=09if (r =3D=3D -ENOIOCTLCMD)
> +=09=09=09=09r =3D vhost_mdev_vring_ioctl(m, cmd, argp);
> +=09=09}
>  =09}
> =20
>  =09mutex_unlock(&m->mutex);
> diff --git a/include/linux/virtio_mdev_ops.h b/include/linux/virtio_mdev_=
ops.h
> index d417b41f2845..622861804ebd 100644
> --- a/include/linux/virtio_mdev_ops.h
> +++ b/include/linux/virtio_mdev_ops.h
> @@ -20,6 +20,8 @@ struct virtio_mdev_callback {
>  =09void *private;
>  };
> =20
> +struct vhost_mdev_net_ctrl;
> +
>  /**
>   * struct vfio_mdev_device_ops - Structure to be registered for each
>   * mdev device to register the device for virtio/vhost drivers.
> @@ -151,6 +153,14 @@ struct virtio_mdev_device_ops {
> =20
>  =09/* Mdev device ops */
>  =09u64 (*get_mdev_features)(struct mdev_device *mdev);
> +
> +=09/* Vhost-mdev (MDEV_CLASS_ID_VHOST) specific ops */
> +=09union {
> +=09=09struct {
> +=09=09=09int (*ctrl)(struct mdev_device *mdev,
> +=09=09=09=09    struct vhost_mdev_net_ctrl __user *ctrl);
> +=09=09} net;
> +=09};


And so did device_ops. I still think we'd try out best to avoid such thing.

Thanks


>  };
> =20
>  void mdev_set_virtio_ops(struct mdev_device *mdev,
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 061a2824a1b3..3693b2cba0c4 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -134,4 +134,11 @@
>  /* Get the max ring size. */
>  #define VHOST_MDEV_GET_VRING_NUM=09_IOR(VHOST_VIRTIO, 0x76, __u16)
> =20
> +/* VHOST_MDEV device specific defines */
> +
> +/* Send virtio-net commands. The commands follow the same definition
> + * of the virtio-net commands defined in virtio-spec.
> + */
> +#define VHOST_MDEV_NET_CTRL=09=09_IOW(VHOST_VIRTIO, 0x77, struct vhost_m=
dev_net_ctrl *)
> +
>  #endif
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index 7b105d0b2fb9..e76b4d8e35e5 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -127,6 +127,12 @@ struct vhost_mdev_config {
>  =09__u8 buf[0];
>  };
> =20
> +struct vhost_mdev_net_ctrl {
> +=09__u8 class;
> +=09__u8 cmd;
> +=09__u8 cmd_data[0];
> +} __attribute__((packed));
> +
>  /* Feature bits */
>  /* Log all write descriptors. Can be changed while device is active. */
>  #define VHOST_F_LOG_ALL 26

