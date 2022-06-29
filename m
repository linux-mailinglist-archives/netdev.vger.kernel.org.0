Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1326855F50E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiF2EQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiF2EQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:16:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F82F2EB
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656476169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PtwcZuLsTm8Dg1uSD41ajc7r0fnpDwfXXB+rZRvhTko=;
        b=FyCeTzy9MIud46C17k26o0lvqcx5cFpJVPoLZktdtTnUbh0VZwmc1Zs+/5x4DGp/wnxT6P
        aSBSsIai1gluGAmkP0LOmVFh7JzOYQ12oWBlx29UnxtP6NB71EarF2yDpUfccbGU+ljjtd
        iR8CCgVlCBABVQ+BmOQxFv+CfhGiUo8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-eGWHhZ8PNPqIk9MF8VUAYQ-1; Wed, 29 Jun 2022 00:16:08 -0400
X-MC-Unique: eGWHhZ8PNPqIk9MF8VUAYQ-1
Received: by mail-lj1-f199.google.com with SMTP id k2-20020a2e8882000000b0025a96a32388so1947015lji.13
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PtwcZuLsTm8Dg1uSD41ajc7r0fnpDwfXXB+rZRvhTko=;
        b=BLxVOgt6bzLXKzPDh22LHTUfMydvtutW94dAEIB5RGbyRtIv/1HHE46x+kP1vtB5Ja
         B1WxiBfdVQ76hQI629uIPjGd2HMeyMzPgZY20fJODGfhcVyydED8xPmm67++mkBcCcxk
         qaZbXcDACUrRKtV81BnIUDjyW8cCt5QxgtPd6OkH8xI8Zyqbg1OiKxuuwlR4loMrvMNs
         qcMDNMWOJi9l+PtGTBaARmK96FFu6GOWRn5/gctFjgY53Uc427hQMYH9E1TXZ5IMLQ/x
         Bisx2ZQkJ8Cjt0QOVSLlejGntp8s6m2N/hgrhIH/NJ+I4jhC4FtyznC/BPRfKmSv0/D8
         gUMw==
X-Gm-Message-State: AJIora+eAEHD7y9kvdTlgGLIoBmGz0AL1hnnoJUHmoRj/L9Tpz8YN/Qv
        CuN0c0qH1G/gfsZpBbeQmmzwy33FB4K+J4Yk5Z3JKGrCIPariddsLxONInwmQN3UdKPiqN96+eC
        VNbSqjVDquxttutJuGe307AZIPEeZL6+l
X-Received: by 2002:a05:6512:22c3:b0:47f:704b:3820 with SMTP id g3-20020a05651222c300b0047f704b3820mr752422lfu.411.1656476166634;
        Tue, 28 Jun 2022 21:16:06 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1upMFAw7enEFnGLqSFGGLIxAK2UAfb9LAQXHDG8zw5aYCyUArCflbvxul/RikhyXAcaaorbxWBe3MU1XUQAnHc=
X-Received: by 2002:a05:6512:22c3:b0:47f:704b:3820 with SMTP id
 g3-20020a05651222c300b0047f704b3820mr752395lfu.411.1656476166417; Tue, 28 Jun
 2022 21:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-4-eperezma@redhat.com>
In-Reply-To: <20220623160738.632852-4-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 29 Jun 2022 12:15:55 +0800
Message-ID: <CACGkMEt6YQvtyYwkYVxmZ01pZJK9PMFM2oPTVttPZ_kZDY-9Jw@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] vhost-vdpa: uAPI to suspend the device
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        habetsm.xilinx@gmail.com, "Dawar, Gautam" <gautam.dawar@amd.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 12:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> The ioctl adds support for suspending the device from userspace.
>
> This is a must before getting virtqueue indexes (base) for live migration=
,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
> After a successful return of the ioctl call the device must not process
> more virtqueue descriptors. The device can answer to read or writes of
> config fields as if it were not suspended. In particular, writing to
> "queue_enable" with a value of 1 will not make the device start
> processing buffers of the virtqueue.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
>  include/uapi/linux/vhost.h | 14 ++++++++++++++
>  2 files changed, 33 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3d636e192061..7fa671ac4bdf 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -478,6 +478,22 @@ static long vhost_vdpa_get_vqs_count(struct vhost_vd=
pa *v, u32 __user *argp)
>         return 0;
>  }
>
> +/* After a successful return of ioctl the device must not process more
> + * virtqueue descriptors. The device can answer to read or writes of con=
fig
> + * fields as if it were not suspended. In particular, writing to "queue_=
enable"
> + * with a value of 1 will not make the device start processing buffers.
> + */
> +static long vhost_vdpa_suspend(struct vhost_vdpa *v)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       if (!ops->suspend)
> +               return -EOPNOTSUPP;
> +
> +       return ops->suspend(vdpa);
> +}
> +
>  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cm=
d,
>                                    void __user *argp)
>  {
> @@ -654,6 +670,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *fi=
lep,
>         case VHOST_VDPA_GET_VQS_COUNT:
>                 r =3D vhost_vdpa_get_vqs_count(v, argp);
>                 break;
> +       case VHOST_VDPA_SUSPEND:
> +               r =3D vhost_vdpa_suspend(v);
> +               break;
>         default:
>                 r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
>                 if (r =3D=3D -ENOIOCTLCMD)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index cab645d4a645..6d9f45163155 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -171,4 +171,18 @@
>  #define VHOST_VDPA_SET_GROUP_ASID      _IOW(VHOST_VIRTIO, 0x7C, \
>                                              struct vhost_vring_state)
>
> +/* Suspend or resume a device so it does not process virtqueue requests =
anymore
> + *
> + * After the return of ioctl with suspend !=3D 0, the device must finish=
 any
> + * pending operations like in flight requests.

I'm not sure we should mandate the flush here. This probably blocks us
from adding inflight descriptor reporting in the future.

Thanks

It must also preserve all the
> + * necessary state (the virtqueue vring base plus the possible device sp=
ecific
> + * states) that is required for restoring in the future. The device must=
 not
> + * change its configuration after that point.
> + *
> + * After the return of ioctl with suspend =3D=3D 0, the device can conti=
nue
> + * processing buffers as long as typical conditions are met (vq is enabl=
ed,
> + * DRIVER_OK status bit is enabled, etc).
> + */
> +#define VHOST_VDPA_SUSPEND             _IOW(VHOST_VIRTIO, 0x7D, int)
> +
>  #endif
> --
> 2.31.1
>

