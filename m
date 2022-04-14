Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D56500974
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241591AbiDNJTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236094AbiDNJTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:19:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 756DC50E22
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649927794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oDyHVey8Or3yypg5xnBGmBMb7pZ6GTNQ18Cis2FA/oo=;
        b=a5Jg2FVT0Js0d7xfEwWA1vvGePp6nNhFIZanOkRgvNgTVJUV/A+Du4J5odSyS1lrL3lHM7
        2QdKkJR9LXdf7EhIFEEC55ZDYA2kn5pSS/5dTcIrdsugl9Mx7Apv1G3zg59oVbfubwzFDS
        Nea3mnwWIi92eBxIHDLaHLW2htI+QmI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-dYDw4rS8PwyMh18_jUir6A-1; Thu, 14 Apr 2022 05:16:33 -0400
X-MC-Unique: dYDw4rS8PwyMh18_jUir6A-1
Received: by mail-lf1-f72.google.com with SMTP id i32-20020a0565123e2000b0046d092e6bffso1323015lfv.2
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:16:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oDyHVey8Or3yypg5xnBGmBMb7pZ6GTNQ18Cis2FA/oo=;
        b=EfX2X0L86aEEy9aNJp9kDAOsUnzBuwH2fnLhxd4s4tOh9AW3rgYgStoNBmYU0bqN1H
         X2r1jtPUXO6J/EwUKu04xZY3pg8O2fu98nEx3BO1v0o+GvWMQQUzW6alVTbpVXZYngsN
         7IbZQSLO+Us2LOCd5AydE2B7QX1q4IJwUUSNVwoyAxzcbM6KMPM7CNCUXXXsO6DfJf91
         zEk2AFWGSJjuPTZsuCPr91O7LO9iSJg+TKtvNmzlfvtOtOWblXH+ypIj9jmV3KQXGOrx
         SJ6J6utcVzB2MUAkII43PTULNjRO6WUO/vFx2lWppgmoyjL5MmSzODkh5Khu6MZRBtOg
         iMKg==
X-Gm-Message-State: AOAM530i7cAyjdyB70a7lKHYg6k3ocRp3EKgNhVRLCFEmGzfU1ER3Uke
        K0CIlmWhuwFdaEOzBh4cYeHaygRf0lp5FUBYTbNZ41CIGm9XD4wxxh1MRE1Cszz4On8q48cYPqd
        Vv/wc7yj3jgwwMuIxHOi1JOTWLyRGaIAg
X-Received: by 2002:a05:6512:3093:b0:46b:814c:3a69 with SMTP id z19-20020a056512309300b0046b814c3a69mr1318056lfd.376.1649927791440;
        Thu, 14 Apr 2022 02:16:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0kFBUTO7Dlm65tLj1wmU6knA+DzshVe6hYxPEBB/AR6yhSIFpfw3Y9RgnR4ACapxp3cguHQaa7kh1RItoYPY=
X-Received: by 2002:a05:6512:3093:b0:46b:814c:3a69 with SMTP id
 z19-20020a056512309300b0046b814c3a69mr1318022lfd.376.1649927791051; Thu, 14
 Apr 2022 02:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-2-xuanzhuo@linux.alibaba.com> <71fbd7fc-20db-024b-ec66-b875216be4bd@redhat.com>
 <1649816652.9004085-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1649816652.9004085-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 14 Apr 2022 17:16:19 +0800
Message-ID: <CACGkMEvCrgRf=6TXQ_pQU0hm-ZDLEBu5VZcL71+c+jVWq=KLDg@mail.gmail.com>
Subject: Re: [PATCH v9 01/32] virtio: add helper virtqueue_get_vring_max_size()
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 10:30 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wro=
te:
>
> On Tue, 12 Apr 2022 10:41:03 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> >
> > =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=
=93:
> > > Record the maximum queue num supported by the device.
> > >
> > > virtio-net can display the maximum (supported by hardware) ring size =
in
> > > ethtool -g eth0.
> > >
> > > When the subsequent patch implements vring reset, it can judge whethe=
r
> > > the ring size passed by the driver is legal based on this.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >   arch/um/drivers/virtio_uml.c             |  1 +
> > >   drivers/platform/mellanox/mlxbf-tmfifo.c |  2 ++
> > >   drivers/remoteproc/remoteproc_virtio.c   |  2 ++
> > >   drivers/s390/virtio/virtio_ccw.c         |  3 +++
> > >   drivers/virtio/virtio_mmio.c             |  2 ++
> > >   drivers/virtio/virtio_pci_legacy.c       |  2 ++
> > >   drivers/virtio/virtio_pci_modern.c       |  2 ++
> > >   drivers/virtio/virtio_ring.c             | 14 ++++++++++++++
> > >   drivers/virtio/virtio_vdpa.c             |  2 ++
> > >   include/linux/virtio.h                   |  2 ++
> > >   10 files changed, 32 insertions(+)
> > >
> > > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_um=
l.c
> > > index ba562d68dc04..904993d15a85 100644
> > > --- a/arch/um/drivers/virtio_uml.c
> > > +++ b/arch/um/drivers/virtio_uml.c
> > > @@ -945,6 +945,7 @@ static struct virtqueue *vu_setup_vq(struct virti=
o_device *vdev,
> > >             goto error_create;
> > >     }
> > >     vq->priv =3D info;
> > > +   vq->num_max =3D num;
> > >     num =3D virtqueue_get_vring_size(vq);
> > >
> > >     if (vu_dev->protocol_features &
> > > diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platf=
orm/mellanox/mlxbf-tmfifo.c
> > > index 38800e86ed8a..1ae3c56b66b0 100644
> > > --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > @@ -959,6 +959,8 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct vi=
rtio_device *vdev,
> > >                     goto error;
> > >             }
> > >
> > > +           vq->num_max =3D vring->num;
> > > +
> > >             vqs[i] =3D vq;
> > >             vring->vq =3D vq;
> > >             vq->priv =3D vring;
> > > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remotep=
roc/remoteproc_virtio.c
> > > index 70ab496d0431..7611755d0ae2 100644
> > > --- a/drivers/remoteproc/remoteproc_virtio.c
> > > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > > @@ -125,6 +125,8 @@ static struct virtqueue *rp_find_vq(struct virtio=
_device *vdev,
> > >             return ERR_PTR(-ENOMEM);
> > >     }
> > >
> > > +   vq->num_max =3D len;
> >
> >
> > I wonder if this is correct.
> >
> > It looks to me len is counted in bytes:
> >
> > /**
> >   * struct rproc_vring - remoteproc vring state
> >   * @va: virtual address
> >   * @len: length, in bytes
> >   * @da: device address
> >   * @align: vring alignment
> >   * @notifyid: rproc-specific unique vring index
> >   * @rvdev: remote vdev
> >   * @vq: the virtqueue of this vring
> >   */
> > struct rproc_vring {
> >          void *va;
> >          int len;
> >          u32 da;
> >          u32 align;
> >          int notifyid;
> >          struct rproc_vdev *rvdev;
> >          struct virtqueue *vq;
> > };
> >
>
> I think this comment is incorrect because here len is passed as num to
> vring_new_virtqueue().
>
> There is also this usage:
>
>         /* actual size of vring (in bytes) */
>         size =3D PAGE_ALIGN(vring_size(rvring->len, rvring->align));
>
>
> And this value comes from here:
>
>         static int
>         rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *r=
sc, int i)
>         {
>                 struct rproc *rproc =3D rvdev->rproc;
>                 struct device *dev =3D &rproc->dev;
>                 struct fw_rsc_vdev_vring *vring =3D &rsc->vring[i];
>                 struct rproc_vring *rvring =3D &rvdev->vring[i];
>
>                 dev_dbg(dev, "vdev rsc: vring%d: da 0x%x, qsz %d, align %=
d\n",
>                         i, vring->da, vring->num, vring->align);
>
>                 /* verify queue size and vring alignment are sane */
>                 if (!vring->num || !vring->align) {
>                         dev_err(dev, "invalid qsz (%d) or alignment (%d)\=
n",
>                                 vring->num, vring->align);
>                         return -EINVAL;
>                 }
>
>        >        rvring->len =3D vring->num;
>                 rvring->align =3D vring->align;
>                 rvring->rvdev =3D rvdev;
>
>                 return 0;
>         }
>
> /**
>  * struct fw_rsc_vdev_vring - vring descriptor entry
>  * @da: device address
>  * @align: the alignment between the consumer and producer parts of the v=
ring
>  * @num: num of buffers supported by this vring (must be power of two)
>  * @notifyid: a unique rproc-wide notify index for this vring. This notif=
y
>  * index is used when kicking a remote processor, to let it know that thi=
s
>  * vring is triggered.
>  * @pa: physical address
>  *
>  * This descriptor is not a resource entry by itself; it is part of the
>  * vdev resource type (see below).
>  *
>  * Note that @da should either contain the device address where
>  * the remote processor is expecting the vring, or indicate that
>  * dynamically allocation of the vring's device address is supported.
>  */
> struct fw_rsc_vdev_vring {
>         u32 da;
>         u32 align;
>         u32 num;
>         u32 notifyid;
>         u32 pa;
> } __packed;
>
> So I think the 'len' here may have changed its meaning in a version updat=
e.

I think you're right, let's have a patch to fix the comment (probably
with the name since len is confusing here).

Thanks

>
> Thanks.
>
> >
> > Other looks good.
> >
> > Thanks
> >
> >
> > > +
> > >     rvring->vq =3D vq;
> > >     vq->priv =3D rvring;
> > >
> > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/v=
irtio_ccw.c
> > > index d35e7a3f7067..468da60b56c5 100644
> > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > @@ -529,6 +529,9 @@ static struct virtqueue *virtio_ccw_setup_vq(stru=
ct virtio_device *vdev,
> > >             err =3D -ENOMEM;
> > >             goto out_err;
> > >     }
> > > +
> > > +   vq->num_max =3D info->num;
> > > +
> > >     /* it may have been reduced */
> > >     info->num =3D virtqueue_get_vring_size(vq);
> > >
> > > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmi=
o.c
> > > index 56128b9c46eb..a41abc8051b9 100644
> > > --- a/drivers/virtio/virtio_mmio.c
> > > +++ b/drivers/virtio/virtio_mmio.c
> > > @@ -390,6 +390,8 @@ static struct virtqueue *vm_setup_vq(struct virti=
o_device *vdev, unsigned index,
> > >             goto error_new_virtqueue;
> > >     }
> > >
> > > +   vq->num_max =3D num;
> > > +
> > >     /* Activate the queue */
> > >     writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_Q=
UEUE_NUM);
> > >     if (vm_dev->version =3D=3D 1) {
> > > diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virt=
io_pci_legacy.c
> > > index 34141b9abe27..b68934fe6b5d 100644
> > > --- a/drivers/virtio/virtio_pci_legacy.c
> > > +++ b/drivers/virtio/virtio_pci_legacy.c
> > > @@ -135,6 +135,8 @@ static struct virtqueue *setup_vq(struct virtio_p=
ci_device *vp_dev,
> > >     if (!vq)
> > >             return ERR_PTR(-ENOMEM);
> > >
> > > +   vq->num_max =3D num;
> > > +
> > >     q_pfn =3D virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SH=
IFT;
> > >     if (q_pfn >> 32) {
> > >             dev_err(&vp_dev->pci_dev->dev,
> > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virt=
io_pci_modern.c
> > > index 5455bc041fb6..86d301f272b8 100644
> > > --- a/drivers/virtio/virtio_pci_modern.c
> > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > @@ -218,6 +218,8 @@ static struct virtqueue *setup_vq(struct virtio_p=
ci_device *vp_dev,
> > >     if (!vq)
> > >             return ERR_PTR(-ENOMEM);
> > >
> > > +   vq->num_max =3D num;
> > > +
> > >     /* activate the queue */
> > >     vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq=
));
> > >     vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_rin=
g.c
> > > index 962f1477b1fa..b87130c8f312 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -2371,6 +2371,20 @@ void vring_transport_features(struct virtio_de=
vice *vdev)
> > >   }
> > >   EXPORT_SYMBOL_GPL(vring_transport_features);
> > >
> > > +/**
> > > + * virtqueue_get_vring_max_size - return the max size of the virtque=
ue's vring
> > > + * @_vq: the struct virtqueue containing the vring of interest.
> > > + *
> > > + * Returns the max size of the vring.
> > > + *
> > > + * Unlike other operations, this need not be serialized.
> > > + */
> > > +unsigned int virtqueue_get_vring_max_size(struct virtqueue *_vq)
> > > +{
> > > +   return _vq->num_max;
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtqueue_get_vring_max_size);
> > > +
> > >   /**
> > >    * virtqueue_get_vring_size - return the size of the virtqueue's vr=
ing
> > >    * @_vq: the struct virtqueue containing the vring of interest.
> > > diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdp=
a.c
> > > index 7767a7f0119b..39e4c08eb0f2 100644
> > > --- a/drivers/virtio/virtio_vdpa.c
> > > +++ b/drivers/virtio/virtio_vdpa.c
> > > @@ -183,6 +183,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, =
unsigned int index,
> > >             goto error_new_virtqueue;
> > >     }
> > >
> > > +   vq->num_max =3D max_num;
> > > +
> > >     /* Setup virtqueue callback */
> > >     cb.callback =3D virtio_vdpa_virtqueue_cb;
> > >     cb.private =3D info;
> > > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > > index 72292a62cd90..d59adc4be068 100644
> > > --- a/include/linux/virtio.h
> > > +++ b/include/linux/virtio.h
> > > @@ -31,6 +31,7 @@ struct virtqueue {
> > >     struct virtio_device *vdev;
> > >     unsigned int index;
> > >     unsigned int num_free;
> > > +   unsigned int num_max;
> > >     void *priv;
> > >   };
> > >
> > > @@ -80,6 +81,7 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *=
vq);
> > >
> > >   void *virtqueue_detach_unused_buf(struct virtqueue *vq);
> > >
> > > +unsigned int virtqueue_get_vring_max_size(struct virtqueue *vq);
> > >   unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
> > >
> > >   bool virtqueue_is_broken(struct virtqueue *vq);
> >
>

