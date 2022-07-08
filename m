Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C259856B8ED
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbiGHLxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238165AbiGHLxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BF459A6A4
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 04:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657281231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Au8fEXSHsSDgZjvjm3vRIhqvVQgLVoiU4uVaHChEFQg=;
        b=UfmnvxVnmp6aIVp2sH2Rd3wWDtC/weGS3WrW+bZtonvo3/fVfcT/YPjLURzpUA5WgpFpMy
        eK5lcjr2M+Q+xRNuonf70m+6T0eDq4KZeCp3O05FuKPowMDAMDJ6VbCOzUfF8NrIWg7Skp
        gfPQAzgoakwxijHTaCJZwzIwxHwkiEU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-ZBsUGWKcPqeMn9awDfCXwA-1; Fri, 08 Jul 2022 07:53:43 -0400
X-MC-Unique: ZBsUGWKcPqeMn9awDfCXwA-1
Received: by mail-qk1-f200.google.com with SMTP id x22-20020a05620a259600b006b552a69231so4376699qko.18
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 04:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Au8fEXSHsSDgZjvjm3vRIhqvVQgLVoiU4uVaHChEFQg=;
        b=YmI7NfWQm6U/b4Iqkds/VdqA44xpdH768/MFttX1MGux4uxpEHI2AyS+k/VkhqO0AQ
         k4xp0ZOaxSCJuqjBqSwI8dZqL/+VBaGjdQFskSFboq/jUZpurHdkD2h+suXd8b7XImnG
         /gi+fprcuCsn+LK/s3o1eaJUpUa9nDNex560Rl78rEWSv+jsB9PpEJqaB9JwHiHuYi5T
         9KNy0EffvjhOyUF8m9sgWubNoWCOX7618f/60CxDkZrr5QWi9ahjixv+Klni0Dxx40jQ
         8GAk1u3zvOpr27PQEqagCV4KgbRogLy8SZW5WcjxXKUrrlWGYmhMdABU1cLJsgyFQhCR
         l4Ow==
X-Gm-Message-State: AJIora+7lKNJfLw0/GUpCLhO5DNUplr95LC9Y66ncuklAyF3rfSVF0Sv
        ABp93HY3Tcz2/aG8YilefklrCvtQbTEaratw3z/3OLoRzfIvYVoG/94zcj2KrdflzdPagfVF+O4
        BieCFucEHYuT3EkiLdbzlFGdKhjh/Ce2s
X-Received: by 2002:a05:620a:4256:b0:6ab:54c4:cf9 with SMTP id w22-20020a05620a425600b006ab54c40cf9mr1909687qko.234.1657281222902;
        Fri, 08 Jul 2022 04:53:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tC3cyQOULJED59oav9eoO/aainINzErGzXB1UQy8CCVH0EIiUdYz+pAt3GXdZU/oPzHvGXC8+JPi42expVyN4=
X-Received: by 2002:a05:620a:4256:b0:6ab:54c4:cf9 with SMTP id
 w22-20020a05620a425600b006ab54c40cf9mr1909661qko.234.1657281222529; Fri, 08
 Jul 2022 04:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-4-eperezma@redhat.com>
 <CACGkMEt6YQvtyYwkYVxmZ01pZJK9PMFM2oPTVttPZ_kZDY-9Jw@mail.gmail.com>
In-Reply-To: <CACGkMEt6YQvtyYwkYVxmZ01pZJK9PMFM2oPTVttPZ_kZDY-9Jw@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 8 Jul 2022 13:53:06 +0200
Message-ID: <CAJaqyWfGXu8k7JN1gCPdUXS2_Dct73w4wS_SdB3aLqVCWJqJQg@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] vhost-vdpa: uAPI to suspend the device
To:     Jason Wang <jasowang@redhat.com>
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 6:16 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, Jun 24, 2022 at 12:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com>=
 wrote:
> >
> > The ioctl adds support for suspending the device from userspace.
> >
> > This is a must before getting virtqueue indexes (base) for live migrati=
on,
> > since the device could modify them after userland gets them. There are
> > individual ways to perform that action for some devices
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> > After a successful return of the ioctl call the device must not process
> > more virtqueue descriptors. The device can answer to read or writes of
> > config fields as if it were not suspended. In particular, writing to
> > "queue_enable" with a value of 1 will not make the device start
> > processing buffers of the virtqueue.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  drivers/vhost/vdpa.c       | 19 +++++++++++++++++++
> >  include/uapi/linux/vhost.h | 14 ++++++++++++++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 3d636e192061..7fa671ac4bdf 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -478,6 +478,22 @@ static long vhost_vdpa_get_vqs_count(struct vhost_=
vdpa *v, u32 __user *argp)
> >         return 0;
> >  }
> >
> > +/* After a successful return of ioctl the device must not process more
> > + * virtqueue descriptors. The device can answer to read or writes of c=
onfig
> > + * fields as if it were not suspended. In particular, writing to "queu=
e_enable"
> > + * with a value of 1 will not make the device start processing buffers=
.
> > + */
> > +static long vhost_vdpa_suspend(struct vhost_vdpa *v)
> > +{
> > +       struct vdpa_device *vdpa =3D v->vdpa;
> > +       const struct vdpa_config_ops *ops =3D vdpa->config;
> > +
> > +       if (!ops->suspend)
> > +               return -EOPNOTSUPP;
> > +
> > +       return ops->suspend(vdpa);
> > +}
> > +
> >  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int =
cmd,
> >                                    void __user *argp)
> >  {
> > @@ -654,6 +670,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
> >         case VHOST_VDPA_GET_VQS_COUNT:
> >                 r =3D vhost_vdpa_get_vqs_count(v, argp);
> >                 break;
> > +       case VHOST_VDPA_SUSPEND:
> > +               r =3D vhost_vdpa_suspend(v);
> > +               break;
> >         default:
> >                 r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> >                 if (r =3D=3D -ENOIOCTLCMD)
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index cab645d4a645..6d9f45163155 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -171,4 +171,18 @@
> >  #define VHOST_VDPA_SET_GROUP_ASID      _IOW(VHOST_VIRTIO, 0x7C, \
> >                                              struct vhost_vring_state)
> >
> > +/* Suspend or resume a device so it does not process virtqueue request=
s anymore
> > + *
> > + * After the return of ioctl with suspend !=3D 0, the device must fini=
sh any
> > + * pending operations like in flight requests.
>
> I'm not sure we should mandate the flush here. This probably blocks us
> from adding inflight descriptor reporting in the future.
>

That's right. Maybe we should add a flags argument to allow not to
flush in flight descriptors in the future? Or maybe the right solution
is to discard that requirement and to mandate in_order to be
migratable at the moment?

Thanks!

> Thanks
>
> It must also preserve all the
> > + * necessary state (the virtqueue vring base plus the possible device =
specific
> > + * states) that is required for restoring in the future. The device mu=
st not
> > + * change its configuration after that point.
> > + *
> > + * After the return of ioctl with suspend =3D=3D 0, the device can con=
tinue
> > + * processing buffers as long as typical conditions are met (vq is ena=
bled,
> > + * DRIVER_OK status bit is enabled, etc).
> > + */
> > +#define VHOST_VDPA_SUSPEND             _IOW(VHOST_VIRTIO, 0x7D, int)
> > +
> >  #endif
> > --
> > 2.31.1
> >
>

