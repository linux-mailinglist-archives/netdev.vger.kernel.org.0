Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F584B8298
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiBPIIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:08:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiBPIIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:08:20 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B895FEBDCD;
        Wed, 16 Feb 2022 00:08:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V4cKqy5_1644998885;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V4cKqy5_1644998885)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 16:08:06 +0800
Message-ID: <1644998595.3309107-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v5 14/22] virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
Date:   Wed, 16 Feb 2022 16:03:15 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
 <20220214081416.117695-15-xuanzhuo@linux.alibaba.com>
 <CACGkMEufh3sbGx4wFCkpiXNR0w0WoCC=TNeLHE+QkqrhyXH6Bw@mail.gmail.com>
In-Reply-To: <CACGkMEufh3sbGx4wFCkpiXNR0w0WoCC=TNeLHE+QkqrhyXH6Bw@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 12:14:25 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Mon, Feb 14, 2022 at 4:14 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > This patch implements virtio pci support for QUEUE RESET.
> >
> > Performing reset on a queue is divided into these steps:
> >
> > 1. reset_vq: reset one vq
> > 2. recycle the buffer from vq by virtqueue_detach_unused_buf()
> > 3. release the ring of the vq by vring_release_virtqueue()
> > 4. enable_reset_vq: re-enable the reset queue
> >
> > This patch implements reset_vq, enable_reset_vq in the pci scenario.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/virtio/virtio_pci_common.c |  8 ++--
> >  drivers/virtio/virtio_pci_modern.c | 60 ++++++++++++++++++++++++++++++
> >  2 files changed, 65 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> > index 5a4f750a0b97..9ea319b1d404 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -255,9 +255,11 @@ static void vp_del_vq(struct virtqueue *vq)
> >         struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
> >         unsigned long flags;
> >
> > -       spin_lock_irqsave(&vp_dev->lock, flags);
> > -       list_del(&info->node);
> > -       spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +       if (!vq->reset) {
> > +               spin_lock_irqsave(&vp_dev->lock, flags);
> > +               list_del(&info->node);
> > +               spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +       }
> >
> >         vp_dev->del_vq(info);
> >         kfree(info);
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> > index bed3e9b84272..7d28f4c36fc2 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
> >         if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
> >                         pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
> >                 __virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> > +
> > +       if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> > +               __virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
> >  }
> >
> >  /* virtio config->finalize_features() implementation */
> > @@ -176,6 +179,59 @@ static void vp_reset(struct virtio_device *vdev)
> >         vp_disable_cbs(vdev);
> >  }
> >
> > +static int vp_modern_reset_vq(struct virtqueue *vq)
> > +{
> > +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> > +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> > +       struct virtio_pci_vq_info *info;
> > +       unsigned long flags;
> > +
> > +       if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
> > +               return -ENOENT;
> > +
> > +       vp_modern_set_queue_reset(mdev, vq->index);
> > +
> > +       info = vp_dev->vqs[vq->index];
> > +
>
> Any reason that we don't need to disable irq here as the previous versions did?

Based on the spec, for the case of one interrupt per queue, there will be no
more interrupts after the reset queue operation. Whether the interrupt is turned
off or not has no effect. I turned off the interrupt before just to be safe.

And for irq sharing scenarios, I don't want to turn off shared interrupts for a
queue.

And the following list_del has been guaranteed to be safe, so I removed the code
for closing interrupts in the previous version.

Thanks.

>
>
> > +       /* delete vq from irq handler */
> > +       spin_lock_irqsave(&vp_dev->lock, flags);
> > +       list_del(&info->node);
> > +       spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +
> > +       INIT_LIST_HEAD(&info->node);
> > +
> > +       vq->reset = VIRTQUEUE_RESET_STAGE_DEVICE;
> > +
> > +       return 0;
> > +}
> > +
> > +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
> > +{
> > +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> > +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> > +       struct virtio_pci_vq_info *info;
> > +       struct virtqueue *_vq;
> > +
> > +       if (vq->reset != VIRTQUEUE_RESET_STAGE_RELEASE)
> > +               return -EBUSY;
> > +
> > +       /* check queue reset status */
> > +       if (vp_modern_get_queue_reset(mdev, vq->index) != 1)
> > +               return -EBUSY;
> > +
> > +       info = vp_dev->vqs[vq->index];
> > +       _vq = vp_setup_vq(vq->vdev, vq->index, NULL, NULL, NULL,
> > +                        info->msix_vector);
>
> So we only care about moden devices, this means using vp_setup_vq()
> with NULL seems tricky.
>
> As replied in another thread, I would simply ask the caller to call
> the vring reallocation helper. See the reply for patch 17.
>
> Thanks
>
>
> > +       if (IS_ERR(_vq)) {
> > +               vq->reset = VIRTQUEUE_RESET_STAGE_RELEASE;
> > +               return PTR_ERR(_vq);
> > +       }
> > +
> > +       vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
> > +
> > +       return 0;
> > +}
> > +
> >  static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
> >  {
> >         return vp_modern_config_vector(&vp_dev->mdev, vector);
> > @@ -397,6 +453,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
> >         .set_vq_affinity = vp_set_vq_affinity,
> >         .get_vq_affinity = vp_get_vq_affinity,
> >         .get_shm_region  = vp_get_shm_region,
> > +       .reset_vq        = vp_modern_reset_vq,
> > +       .enable_reset_vq = vp_modern_enable_reset_vq,
> >  };
> >
> >  static const struct virtio_config_ops virtio_pci_config_ops = {
> > @@ -415,6 +473,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
> >         .set_vq_affinity = vp_set_vq_affinity,
> >         .get_vq_affinity = vp_get_vq_affinity,
> >         .get_shm_region  = vp_get_shm_region,
> > +       .reset_vq        = vp_modern_reset_vq,
> > +       .enable_reset_vq = vp_modern_enable_reset_vq,
> >  };
> >
> >  /* the PCI probing function */
> > --
> > 2.31.0
> >
>
