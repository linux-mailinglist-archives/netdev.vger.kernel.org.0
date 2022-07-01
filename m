Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98ACF562BEC
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiGAGoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGAGoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:44:02 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA8A33A1F;
        Thu, 30 Jun 2022 23:43:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VI-452o_1656657830;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VI-452o_1656657830)
          by smtp.aliyun-inc.com;
          Fri, 01 Jul 2022 14:43:52 +0800
Message-ID: <1656657816.4296634-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v11 01/40] virtio: add helper virtqueue_get_vring_max_size()
Date:   Fri, 1 Jul 2022 14:43:36 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        kangjie.xu@linux.alibaba.com
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEuWK5i4pyvzN306v2ijstFQQbuspNCcNRJrw0kskvcozg@mail.gmail.com>
In-Reply-To: <CACGkMEuWK5i4pyvzN306v2ijstFQQbuspNCcNRJrw0kskvcozg@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 14:35:38 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Wed, Jun 29, 2022 at 2:57 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > Record the maximum queue num supported by the device.
> >
> > virtio-net can display the maximum (supported by hardware) ring size in
> > ethtool -g eth0.
> >
> > When the subsequent patch implements vring reset, it can judge whether
> > the ring size passed by the driver is legal based on this.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  arch/um/drivers/virtio_uml.c             |  1 +
> >  drivers/platform/mellanox/mlxbf-tmfifo.c |  2 ++
> >  drivers/remoteproc/remoteproc_virtio.c   |  2 ++
> >  drivers/s390/virtio/virtio_ccw.c         |  3 +++
> >  drivers/virtio/virtio_mmio.c             |  2 ++
> >  drivers/virtio/virtio_pci_legacy.c       |  2 ++
> >  drivers/virtio/virtio_pci_modern.c       |  2 ++
> >  drivers/virtio/virtio_ring.c             | 14 ++++++++++++++
> >  drivers/virtio/virtio_vdpa.c             |  2 ++
> >  include/linux/virtio.h                   |  2 ++
> >  10 files changed, 32 insertions(+)
> >
> > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> > index 82ff3785bf69..e719af8bdf56 100644
> > --- a/arch/um/drivers/virtio_uml.c
> > +++ b/arch/um/drivers/virtio_uml.c
> > @@ -958,6 +958,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
> >                 goto error_create;
> >         }
> >         vq->priv = info;
> > +       vq->num_max = num;
> >         num = virtqueue_get_vring_size(vq);
> >
> >         if (vu_dev->protocol_features &
> > diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > index 38800e86ed8a..1ae3c56b66b0 100644
> > --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > @@ -959,6 +959,8 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
> >                         goto error;
> >                 }
> >
> > +               vq->num_max = vring->num;
> > +
> >                 vqs[i] = vq;
> >                 vring->vq = vq;
> >                 vq->priv = vring;
> > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
> > index d43d74733f0a..0f7706e23eb9 100644
> > --- a/drivers/remoteproc/remoteproc_virtio.c
> > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > @@ -125,6 +125,8 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
> >                 return ERR_PTR(-ENOMEM);
> >         }
> >
> > +       vq->num_max = num;
> > +
> >         rvring->vq = vq;
> >         vq->priv = rvring;
> >
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > index 161d3b141f0d..6b86d0280d6b 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -530,6 +530,9 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
> >                 err = -ENOMEM;
> >                 goto out_err;
> >         }
> > +
> > +       vq->num_max = info->num;
> > +
> >         /* it may have been reduced */
> >         info->num = virtqueue_get_vring_size(vq);
> >
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index 083ff1eb743d..a20d5a6b5819 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -403,6 +403,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
> >                 goto error_new_virtqueue;
> >         }
> >
> > +       vq->num_max = num;
> > +
> >         /* Activate the queue */
> >         writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
> >         if (vm_dev->version == 1) {
> > diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> > index a5e5721145c7..2257f1b3d8ae 100644
> > --- a/drivers/virtio/virtio_pci_legacy.c
> > +++ b/drivers/virtio/virtio_pci_legacy.c
> > @@ -135,6 +135,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> >         if (!vq)
> >                 return ERR_PTR(-ENOMEM);
> >
> > +       vq->num_max = num;
> > +
> >         q_pfn = virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
> >         if (q_pfn >> 32) {
> >                 dev_err(&vp_dev->pci_dev->dev,
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> > index 623906b4996c..e7e0b8c850f6 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -218,6 +218,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> >         if (!vq)
> >                 return ERR_PTR(-ENOMEM);
> >
> > +       vq->num_max = num;
> > +
> >         /* activate the queue */
> >         vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq));
> >         vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index a5ec724c01d8..4cac600856ad 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2385,6 +2385,20 @@ void vring_transport_features(struct virtio_device *vdev)
> >  }
> >  EXPORT_SYMBOL_GPL(vring_transport_features);
> >
> > +/**
> > + * virtqueue_get_vring_max_size - return the max size of the virtqueue's vring
> > + * @_vq: the struct virtqueue containing the vring of interest.
> > + *
> > + * Returns the max size of the vring.
> > + *
> > + * Unlike other operations, this need not be serialized.
> > + */
> > +unsigned int virtqueue_get_vring_max_size(struct virtqueue *_vq)
> > +{
> > +       return _vq->num_max;
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_get_vring_max_size);
> > +
> >  /**
> >   * virtqueue_get_vring_size - return the size of the virtqueue's vring
> >   * @_vq: the struct virtqueue containing the vring of interest.
> > diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> > index c40f7deb6b5a..9670cc79371d 100644
> > --- a/drivers/virtio/virtio_vdpa.c
> > +++ b/drivers/virtio/virtio_vdpa.c
> > @@ -183,6 +183,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
> >                 goto error_new_virtqueue;
> >         }
> >
> > +       vq->num_max = max_num;
> > +
> >         /* Setup virtqueue callback */
> >         cb.callback = callback ? virtio_vdpa_virtqueue_cb : NULL;
> >         cb.private = info;
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index d8fdf170637c..a82620032e43 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -31,6 +31,7 @@ struct virtqueue {
> >         struct virtio_device *vdev;
> >         unsigned int index;
> >         unsigned int num_free;
> > +       unsigned int num_max;
>
> A question, since we export virtqueue to drivers, this means they can
> access vq->num_max directly.
>
> So we probably don't need a helper here.

I think you are right.

Thanks.

>
> Thanks
>
> >         void *priv;
> >  };
> >
> > @@ -80,6 +81,7 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
> >
> >  void *virtqueue_detach_unused_buf(struct virtqueue *vq);
> >
> > +unsigned int virtqueue_get_vring_max_size(struct virtqueue *vq);
> >  unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
> >
> >  bool virtqueue_is_broken(struct virtqueue *vq);
> > --
> > 2.31.0
> >
>
