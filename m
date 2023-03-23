Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA26C5D00
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjCWDCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjCWDCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:02:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C211F5F7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679540513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V020neUbbZWaZoIFJtWjwKXZ29/hnOcn6337E3R+7Xs=;
        b=aw63qbmQF7fZKF/MPeJNqCgR1hpYHbsh6OcceSsYf8YNeb5D76WPnKUENKWiVGXmj7SoNd
        bl4b4evfIr3qL0r99mhu1gDleHzHTR9jhTSScN9Ge8JcTVyvg7LpEbEW9AnIc9KxQ9IL2u
        gwgmRDATvAVX8PUu1oUZpO4v2ZdjoY8=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-6rNmlJqhMVegtaaRJLQsHQ-1; Wed, 22 Mar 2023 23:01:51 -0400
X-MC-Unique: 6rNmlJqhMVegtaaRJLQsHQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-17abfe9fd10so10744571fac.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:01:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679540511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V020neUbbZWaZoIFJtWjwKXZ29/hnOcn6337E3R+7Xs=;
        b=E6kZ6ybo6PnkUAzG8vU50XcoU0/USBXKnR53CV6yn2n9m4WHWaMvJLs521L0+n+JaA
         UlRmuP2eOCgQLpFH0uNMRxE8BBPyCBEflevOsRrHUDinbTRz9rG/S8/iLwER8jpFBIcx
         3l268YDYUJiJsxavxB5cKyKWTmuzSmZkSyhU8ZCkoHD8zbiwp5mE6ZGPDnvVaA2XpzCj
         ZClNN8OWpMM9REaAzJUV0v8Wio0a40DF69IEESAVbHkMydORYsrLkK74mt+rGcqysTmG
         zOz4arSOUt3AKfm0sNaFkZaKrWz1Cnlo0JUJWiqGPSV2lsbUXokzrhkUizLshRMG2dl6
         zz5g==
X-Gm-Message-State: AO0yUKV8pTfDu6weRPbLWZursD7kAWU0lp+yVdiZy8nic6zLL4Lf2Iuy
        AXyeL1Plh2LKjL/3TdMNSV2ls4E9UbNWjPEGIMXZ+QP5WuE3OgB/dgHjEEwdfD+h/OR2DNNcu9y
        AHm8az6M8NRvzd7mDn8qyoURwuf25jgep
X-Received: by 2002:a4a:da03:0:b0:536:c774:d6cc with SMTP id e3-20020a4ada03000000b00536c774d6ccmr1503651oou.0.1679540511117;
        Wed, 22 Mar 2023 20:01:51 -0700 (PDT)
X-Google-Smtp-Source: AK7set/tckm88ucwnaPIT76mp9XcG9XGO5SMDYk5qPRCnqR4YfUWsnGbFN7uYCec8c4MsR1rUwyhA1vi/LxnZGNE7ZQ=
X-Received: by 2002:a4a:da03:0:b0:536:c774:d6cc with SMTP id
 e3-20020a4ada03000000b00536c774d6ccmr1503644oou.0.1679540510894; Wed, 22 Mar
 2023 20:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154228.182769-1-sgarzare@redhat.com> <20230321154228.182769-3-sgarzare@redhat.com>
In-Reply-To: <20230321154228.182769-3-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 11:01:39 +0800
Message-ID: <CACGkMEtq8PWL01WBL2Ve-Yr=ZO+su73tKuOh1EBLagkrLdiCaQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 11:42=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> When the user call VHOST_SET_OWNER ioctl and the vDPA device
> has `use_va` set to true, let's call the bind_mm callback.
> In this way we can bind the device to the user address space
> and directly use the user VA.
>
> The unbind_mm callback is called during the release after
> stopping the device.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>     v3:
>     - added `case VHOST_SET_OWNER` in vhost_vdpa_unlocked_ioctl() [Jason]
>     v2:
>     - call the new unbind_mm callback during the release [Jason]
>     - avoid to call bind_mm callback after the reset, since the device
>       is not detaching it now during the reset
>
>  drivers/vhost/vdpa.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 7be9d9d8f01c..20250c3418b2 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>         return vdpa_reset(vdpa);
>  }
>
> +static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       if (!vdpa->use_va || !ops->bind_mm)
> +               return 0;
> +
> +       return ops->bind_mm(vdpa, v->vdev.mm);
> +}
> +
> +static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       if (!vdpa->use_va || !ops->unbind_mm)
> +               return;
> +
> +       ops->unbind_mm(vdpa);
> +}
> +
>  static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *ar=
gp)
>  {
>         struct vdpa_device *vdpa =3D v->vdpa;
> @@ -709,6 +731,14 @@ static long vhost_vdpa_unlocked_ioctl(struct file *f=
ilep,
>         case VHOST_VDPA_RESUME:
>                 r =3D vhost_vdpa_resume(v);
>                 break;
> +       case VHOST_SET_OWNER:
> +               r =3D vhost_dev_set_owner(d);

Nit:

I'd stick to the current way of passing the cmd, argp to
vhost_dev_ioctl() and introduce a new switch after the
vhost_dev_ioctl().

In this way, we are immune to any possible changes of dealing with
VHOST_SET_OWNER in vhost core.

Others look good.

Thanks

> +               if (r)
> +                       break;
> +               r =3D vhost_vdpa_bind_mm(v);
> +               if (r)
> +                       vhost_dev_reset_owner(d, NULL);
> +               break;
>         default:
>                 r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
>                 if (r =3D=3D -ENOIOCTLCMD)
> @@ -1287,6 +1317,7 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>         vhost_vdpa_clean_irq(v);
>         vhost_vdpa_reset(v);
>         vhost_dev_stop(&v->vdev);
> +       vhost_vdpa_unbind_mm(v);
>         vhost_vdpa_config_put(v);
>         vhost_vdpa_cleanup(v);
>         mutex_unlock(&d->mutex);
> --
> 2.39.2
>

