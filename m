Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D4D57D8DA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 05:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbiGVDGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 23:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiGVDGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 23:06:09 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC51823A5;
        Thu, 21 Jul 2022 20:06:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VK3N6a-_1658459160;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VK3N6a-_1658459160)
          by smtp.aliyun-inc.com;
          Fri, 22 Jul 2022 11:06:01 +0800
Message-ID: <1658459137.1276448-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v12 30/40] virtio_pci: support VIRTIO_F_RING_RESET
Date:   Fri, 22 Jul 2022 11:05:37 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Richard Weinberger <richard@nod.at>,
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
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com,
        virtualization@lists.linux-foundation.org
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
 <20220720030436.79520-31-xuanzhuo@linux.alibaba.com>
 <efb6adca-a2a8-98d2-5604-5482d8be6ec9@redhat.com>
In-Reply-To: <efb6adca-a2a8-98d2-5604-5482d8be6ec9@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 17:15:11 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/7/20 11:04, Xuan Zhuo =E5=86=99=E9=81=93:
> > This patch implements virtio pci support for QUEUE RESET.
> >
> > Performing reset on a queue is divided into these steps:
> >
> >   1. notify the device to reset the queue
> >   2. recycle the buffer submitted
> >   3. reset the vring (may re-alloc)
> >   4. mmap vring to device, and enable the queue
> >
> > This patch implements virtio_reset_vq(), virtio_enable_resetq() in the
> > pci scenario.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_pci_common.c | 12 +++-
> >   drivers/virtio/virtio_pci_modern.c | 96 ++++++++++++++++++++++++++++++
> >   2 files changed, 105 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio=
_pci_common.c
> > index ca51fcc9daab..ad258a9d3b9f 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -214,9 +214,15 @@ static void vp_del_vq(struct virtqueue *vq)
> >   	struct virtio_pci_vq_info *info =3D vp_dev->vqs[vq->index];
> >   	unsigned long flags;
> >
> > -	spin_lock_irqsave(&vp_dev->lock, flags);
> > -	list_del(&info->node);
> > -	spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +	/*
> > +	 * If it fails during re-enable reset vq. This way we won't rejoin
> > +	 * info->node to the queue. Prevent unexpected irqs.
> > +	 */
> > +	if (!vq->reset) {
> > +		spin_lock_irqsave(&vp_dev->lock, flags);
> > +		list_del(&info->node);
> > +		spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +	}
> >
> >   	vp_dev->del_vq(info);
> >   	kfree(info);
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio=
_pci_modern.c
> > index 9041d9a41b7d..4d28b6918c80 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_devic=
e *vdev, u64 features)
> >   	if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
> >   			pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
> >   		__virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> > +
> > +	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> > +		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
> >   }
> >
> >   /* virtio config->finalize_features() implementation */
> > @@ -199,6 +202,95 @@ static int vp_active_vq(struct virtqueue *vq, u16 =
msix_vec)
> >   	return 0;
> >   }
> >
> > +static int vp_modern_reset_vq(struct virtqueue *vq)
> > +{
> > +	struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > +	struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > +	struct virtio_pci_vq_info *info;
> > +	unsigned long flags;
> > +
> > +	if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
> > +		return -ENOENT;
> > +
> > +	vp_modern_set_queue_reset(mdev, vq->index);
> > +
> > +	info =3D vp_dev->vqs[vq->index];
> > +
> > +	/* delete vq from irq handler */
> > +	spin_lock_irqsave(&vp_dev->lock, flags);
> > +	list_del(&info->node);
> > +	spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +
> > +	INIT_LIST_HEAD(&info->node);
> > +
> > +	/* For the case where vq has an exclusive irq, to prevent the irq from
> > +	 * being received again and the pending irq, call synchronize_irq(), =
and
> > +	 * break it.
> > +	 *
> > +	 * We can't use disable_irq() since it conflicts with the affinity
> > +	 * managed IRQ that is used by some drivers. So this is done on top of
> > +	 * IRQ hardening.
> > +	 *
> > +	 * In the scenario based on shared interrupts, vq will be searched fr=
om
> > +	 * the queue virtqueues. Since the previous list_del() has been delet=
ed
> > +	 * from the queue, it is impossible for vq to be called in this case.
> > +	 * There is no need to close the corresponding interrupt.
> > +	 */
> > +	if (vp_dev->per_vq_vectors && info->msix_vector !=3D VIRTIO_MSI_NO_VE=
CTOR) {
> > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > +		__virtqueue_break(vq);
> > +#endif
>
>
> I think we should do this unconditionally since it's an independent
> feature, though the list_del() above should be sufficient.

Yes.

>
>
> > +		synchronize_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
> > +	}
> > +
> > +	vq->reset =3D true;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
> > +{
> > +	struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > +	struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > +	struct virtio_pci_vq_info *info;
> > +	unsigned long flags, index;
> > +	int err;
> > +
> > +	if (!vq->reset)
> > +		return -EBUSY;
> > +
> > +	index =3D vq->index;
> > +	info =3D vp_dev->vqs[index];
> > +
> > +	if (vp_modern_get_queue_reset(mdev, index))
> > +		return -EBUSY;
> > +
> > +	if (vp_modern_get_queue_enable(mdev, index))
> > +		return -EBUSY;
> > +
> > +	err =3D vp_active_vq(vq, info->msix_vector);
> > +	if (err)
> > +		return err;
> > +
> > +	if (vq->callback) {
> > +		spin_lock_irqsave(&vp_dev->lock, flags);
> > +		list_add(&info->node, &vp_dev->virtqueues);
> > +		spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +	} else {
> > +		INIT_LIST_HEAD(&info->node);
> > +	}
> > +
> > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > +	if (vp_dev->per_vq_vectors && info->msix_vector !=3D VIRTIO_MSI_NO_VE=
CTOR)
> > +		__virtqueue_unbreak(vq);
> > +#endif
> > +
> > +	vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
> > +	vq->reset =3D false;
> > +
> > +	return 0;
> > +}
> > +
> >   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vec=
tor)
> >   {
> >   	return vp_modern_config_vector(&vp_dev->mdev, vector);
> > @@ -413,6 +505,8 @@ static const struct virtio_config_ops virtio_pci_co=
nfig_nodev_ops =3D {
> >   	.set_vq_affinity =3D vp_set_vq_affinity,
> >   	.get_vq_affinity =3D vp_get_vq_affinity,
> >   	.get_shm_region  =3D vp_get_shm_region,
> > +	.disable_vq_and_reset =3D vp_modern_reset_vq,
> > +	.enable_vq_after_reset =3D vp_modern_enable_reset_vq,
>
>
> Nit:
>
> To be consistent, let's use vp_modern_disable_vq_and_reset() and
> vp_modern_enable_vq_after_reset()

Will fix.

Thanks.


>
> Thanks
>
>
> >   };
> >
> >   static const struct virtio_config_ops virtio_pci_config_ops =3D {
> > @@ -431,6 +525,8 @@ static const struct virtio_config_ops virtio_pci_co=
nfig_ops =3D {
> >   	.set_vq_affinity =3D vp_set_vq_affinity,
> >   	.get_vq_affinity =3D vp_get_vq_affinity,
> >   	.get_shm_region  =3D vp_get_shm_region,
> > +	.disable_vq_and_reset =3D vp_modern_reset_vq,
> > +	.enable_vq_after_reset =3D vp_modern_enable_reset_vq,
> >   };
> >
> >   /* the PCI probing function */
>
