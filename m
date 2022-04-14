Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4842950097D
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbiDNJUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237472AbiDNJUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:20:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A87CE50B01
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649927886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XwteEASpUdm+Z5zxGY0xsMXakuoAoS580SIQ+0S8fUU=;
        b=S/IK3RKnzl109pw7hhOC7+UEfYYN8rkMWu8SCnd69DdsaM7xxbyXv8N15vs5eWs4bceNWU
        p9HaLZa0vb/1sr/ZAc7H4Ni8ZaCJA3sNP9I5+05NseTRFJ2B3nAI/wqHOvKFBPN6N9DVWJ
        DpOF5uYlV6f9UxnMG1a+M5u6QpAXi7c=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-5m9jLROYMsSQsjvqiS5UPA-1; Thu, 14 Apr 2022 05:18:05 -0400
X-MC-Unique: 5m9jLROYMsSQsjvqiS5UPA-1
Received: by mail-lf1-f72.google.com with SMTP id o4-20020a056512230400b0046d0a7f733cso1071285lfu.15
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:18:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XwteEASpUdm+Z5zxGY0xsMXakuoAoS580SIQ+0S8fUU=;
        b=Yw4Sk2Apsm8yNQSmPKOjxSQjj+TDj3dApiXpkLf5DucNkAvBmWCsDlaOd9f9YEwfhR
         epoDVPxi+3swlMqKxWvN71ucpWyllVqCs0pl7+6qezxwCJFb3u5Y1OhMXBxz4iFNGCML
         xaJ50WMmv3rDD0jSWL8ssJYp3x4oZ+qvIGxIjPvmd3nGrMPyd11WjwQ3+uiGk96U03Pn
         O5hgCU9V7tZj789nYClasunJmtR/O2B1J2aCcf2/PoydydLU2i0+W6F6gaGVE/g5dQQB
         Hzy8t8SLXkDFoZIbrYhndYAD251fJ+G96UNPMd39u5MXMJs/MAoG+U9bG1ZlXXHI8vJ6
         RwRA==
X-Gm-Message-State: AOAM530GwuOe0UIfnDQOXQaq8lGg6sVLClyOiRm21CqZRVauivX2ofh/
        18DgPu3NbM45yJJKx+hbcVRRRHyoj4zahEU7VDtTFWVjqmi4ICRni91Bp1fS9ni2ovYyjUDXUZe
        GdY4J1q7Ytl9N2ZDyuRJOJ0ROTEs0kYWU
X-Received: by 2002:a05:6512:33c5:b0:46b:af94:55f4 with SMTP id d5-20020a05651233c500b0046baf9455f4mr1365872lfg.98.1649927884050;
        Thu, 14 Apr 2022 02:18:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzT5YWFA9DfNyU3wLaWkSkS4Df/EMqLUcy7nWwMxLgd02Cutbtt7B1fuQHOoVoiXLNzBS3HiRtGb9OIjiK3C34=
X-Received: by 2002:a05:6512:33c5:b0:46b:af94:55f4 with SMTP id
 d5-20020a05651233c500b0046baf9455f4mr1365844lfg.98.1649927883776; Thu, 14 Apr
 2022 02:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-24-xuanzhuo@linux.alibaba.com> <d040a3fe-765e-93d6-cef9-603f23a0fd1e@redhat.com>
 <1649820105.687942-3-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1649820105.687942-3-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 14 Apr 2022 17:17:52 +0800
Message-ID: <CACGkMEt+pkyUnFXHMqahVtXCNZKMGt5s9jYE_oFNDRbrYEJK6Q@mail.gmail.com>
Subject: Re: [PATCH v9 23/32] virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
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
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 11:23 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wro=
te:
>
> On Tue, 12 Apr 2022 15:07:58 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> >
> > =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=
=93:
> > > This patch implements virtio pci support for QUEUE RESET.
> > >
> > > Performing reset on a queue is divided into these steps:
> > >
> > >   1. notify the device to reset the queue
> > >   2. recycle the buffer submitted
> > >   3. reset the vring (may re-alloc)
> > >   4. mmap vring to device, and enable the queue
> > >
> > > This patch implements virtio_reset_vq(), virtio_enable_resetq() in th=
e
> > > pci scenario.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >   drivers/virtio/virtio_pci_common.c |  8 +--
> > >   drivers/virtio/virtio_pci_modern.c | 84 +++++++++++++++++++++++++++=
+++
> > >   drivers/virtio/virtio_ring.c       |  2 +
> > >   include/linux/virtio.h             |  1 +
> > >   4 files changed, 92 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virt=
io_pci_common.c
> > > index fdbde1db5ec5..863d3a8a0956 100644
> > > --- a/drivers/virtio/virtio_pci_common.c
> > > +++ b/drivers/virtio/virtio_pci_common.c
> > > @@ -248,9 +248,11 @@ static void vp_del_vq(struct virtqueue *vq)
> > >     struct virtio_pci_vq_info *info =3D vp_dev->vqs[vq->index];
> > >     unsigned long flags;
> > >
> > > -   spin_lock_irqsave(&vp_dev->lock, flags);
> > > -   list_del(&info->node);
> > > -   spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +   if (!vq->reset) {
> >
> >
> > On which condition that we may hit this path?
> >
> >
> > > +           spin_lock_irqsave(&vp_dev->lock, flags);
> > > +           list_del(&info->node);
> > > +           spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +   }
> > >
> > >     vp_dev->del_vq(info);
> > >     kfree(info);
> > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virt=
io_pci_modern.c
> > > index 49a4493732cf..cb5d38f1c9c8 100644
> > > --- a/drivers/virtio/virtio_pci_modern.c
> > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_dev=
ice *vdev, u64 features)
> > >     if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
> > >                     pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_S=
RIOV))
> > >             __virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> > > +
> > > +   if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> > > +           __virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
> > >   }
> > >
> > >   /* virtio config->finalize_features() implementation */
> > > @@ -199,6 +202,83 @@ static int vp_active_vq(struct virtqueue *vq, u1=
6 msix_vec)
> > >     return 0;
> > >   }
> > >
> > > +static int vp_modern_reset_vq(struct virtqueue *vq)
> > > +{
> > > +   struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > > +   struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > +   struct virtio_pci_vq_info *info;
> > > +   unsigned long flags;
> > > +
> > > +   if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
> > > +           return -ENOENT;
> > > +
> > > +   vp_modern_set_queue_reset(mdev, vq->index);
> > > +
> > > +   info =3D vp_dev->vqs[vq->index];
> > > +
> > > +   /* delete vq from irq handler */
> > > +   spin_lock_irqsave(&vp_dev->lock, flags);
> > > +   list_del(&info->node);
> > > +   spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +
> > > +   INIT_LIST_HEAD(&info->node);
> > > +
> > > +   /* For the case where vq has an exclusive irq, to prevent the irq=
 from
> > > +    * being received again and the pending irq, call disable_irq().
> > > +    *
> > > +    * In the scenario based on shared interrupts, vq will be searche=
d from
> > > +    * the queue virtqueues. Since the previous list_del() has been d=
eleted
> > > +    * from the queue, it is impossible for vq to be called in this c=
ase.
> > > +    * There is no need to close the corresponding interrupt.
> > > +    */
> > > +   if (vp_dev->per_vq_vectors && info->msix_vector !=3D VIRTIO_MSI_N=
O_VECTOR)
> > > +           disable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_ve=
ctor));
> >
> >
> > See the previous discussion and the revert of the first try to harden
> > the interrupt. We probably can't use disable_irq() since it conflicts
> > with the affinity managed IRQ that is used by some drivers.
> >
> > We need to use synchonize_irq() and per virtqueue flag instead. As
> > mentioned in previous patches, this could be done on top of my rework o=
n
> > the IRQ hardening .
>
> OK, the next version will contain hardened features by per virtqueue flag=
.

Actually, I'm working on a new version of hardening. I plan to switch
to the virtqueue flag so we will be fine here if we do the resize work
on top.

I will cc you in the new version.

Thanks

>
> Thanks.
>
> >
> >
> > > +
> > > +   vq->reset =3D true;
> > > +
> > > +   return 0;
> > > +}
> > > +
> > > +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
> > > +{
> > > +   struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > > +   struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > +   struct virtio_pci_vq_info *info;
> > > +   unsigned long flags, index;
> > > +   int err;
> > > +
> > > +   if (!vq->reset)
> > > +           return -EBUSY;
> > > +
> > > +   index =3D vq->index;
> > > +   info =3D vp_dev->vqs[index];
> > > +
> > > +   /* check queue reset status */
> > > +   if (vp_modern_get_queue_reset(mdev, index) !=3D 1)
> > > +           return -EBUSY;
> > > +
> > > +   err =3D vp_active_vq(vq, info->msix_vector);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   if (vq->callback) {
> > > +           spin_lock_irqsave(&vp_dev->lock, flags);
> > > +           list_add(&info->node, &vp_dev->virtqueues);
> > > +           spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +   } else {
> > > +           INIT_LIST_HEAD(&info->node);
> > > +   }
> > > +
> > > +   vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
> > > +
> > > +   if (vp_dev->per_vq_vectors && info->msix_vector !=3D VIRTIO_MSI_N=
O_VECTOR)
> > > +           enable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vec=
tor));
> >
> >
> > We had the same issue as disable_irq().
> >
> > Thanks
> >
> >
> > > +
> > > +   vq->reset =3D false;
> > > +
> > > +   return 0;
> > > +}
> > > +
> > >   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 v=
ector)
> > >   {
> > >     return vp_modern_config_vector(&vp_dev->mdev, vector);
> > > @@ -407,6 +487,8 @@ static const struct virtio_config_ops virtio_pci_=
config_nodev_ops =3D {
> > >     .set_vq_affinity =3D vp_set_vq_affinity,
> > >     .get_vq_affinity =3D vp_get_vq_affinity,
> > >     .get_shm_region  =3D vp_get_shm_region,
> > > +   .reset_vq        =3D vp_modern_reset_vq,
> > > +   .enable_reset_vq =3D vp_modern_enable_reset_vq,
> > >   };
> > >
> > >   static const struct virtio_config_ops virtio_pci_config_ops =3D {
> > > @@ -425,6 +507,8 @@ static const struct virtio_config_ops virtio_pci_=
config_ops =3D {
> > >     .set_vq_affinity =3D vp_set_vq_affinity,
> > >     .get_vq_affinity =3D vp_get_vq_affinity,
> > >     .get_shm_region  =3D vp_get_shm_region,
> > > +   .reset_vq        =3D vp_modern_reset_vq,
> > > +   .enable_reset_vq =3D vp_modern_enable_reset_vq,
> > >   };
> > >
> > >   /* the PCI probing function */
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_rin=
g.c
> > > index 6250e19fc5bf..91937e21edca 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -2028,6 +2028,7 @@ static struct virtqueue *vring_create_virtqueue=
_packed(
> > >     vq->vq.vdev =3D vdev;
> > >     vq->vq.name =3D name;
> > >     vq->vq.index =3D index;
> > > +   vq->vq.reset =3D false;
> > >     vq->notify =3D notify;
> > >     vq->weak_barriers =3D weak_barriers;
> > >
> > > @@ -2508,6 +2509,7 @@ struct virtqueue *__vring_new_virtqueue(unsigne=
d int index,
> > >     vq->vq.vdev =3D vdev;
> > >     vq->vq.name =3D name;
> > >     vq->vq.index =3D index;
> > > +   vq->vq.reset =3D false;
> > >     vq->notify =3D notify;
> > >     vq->weak_barriers =3D weak_barriers;
> > >
> > > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > > index c86ff02e0ca0..33ab003c5100 100644
> > > --- a/include/linux/virtio.h
> > > +++ b/include/linux/virtio.h
> > > @@ -33,6 +33,7 @@ struct virtqueue {
> > >     unsigned int num_free;
> > >     unsigned int num_max;
> > >     void *priv;
> > > +   bool reset;
> > >   };
> > >
> > >   int virtqueue_add_outbuf(struct virtqueue *vq,
> >
>

