Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB404FED77
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 05:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiDMDZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 23:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiDMDZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 23:25:22 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89312E097;
        Tue, 12 Apr 2022 20:23:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V9xgCAI_1649820174;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9xgCAI_1649820174)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 11:22:55 +0800
Message-ID: <1649820105.687942-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 23/32] virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
Date:   Wed, 13 Apr 2022 11:21:45 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
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
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-24-xuanzhuo@linux.alibaba.com>
 <d040a3fe-765e-93d6-cef9-603f23a0fd1e@redhat.com>
In-Reply-To: <d040a3fe-765e-93d6-cef9-603f23a0fd1e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 15:07:58 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
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
> >   drivers/virtio/virtio_pci_common.c |  8 +--
> >   drivers/virtio/virtio_pci_modern.c | 84 ++++++++++++++++++++++++++++++
> >   drivers/virtio/virtio_ring.c       |  2 +
> >   include/linux/virtio.h             |  1 +
> >   4 files changed, 92 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio=
_pci_common.c
> > index fdbde1db5ec5..863d3a8a0956 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -248,9 +248,11 @@ static void vp_del_vq(struct virtqueue *vq)
> >   	struct virtio_pci_vq_info *info =3D vp_dev->vqs[vq->index];
> >   	unsigned long flags;
> >
> > -	spin_lock_irqsave(&vp_dev->lock, flags);
> > -	list_del(&info->node);
> > -	spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +	if (!vq->reset) {
>
>
> On which condition that we may hit this path?
>
>
> > +		spin_lock_irqsave(&vp_dev->lock, flags);
> > +		list_del(&info->node);
> > +		spin_unlock_irqrestore(&vp_dev->lock, flags);
> > +	}
> >
> >   	vp_dev->del_vq(info);
> >   	kfree(info);
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio=
_pci_modern.c
> > index 49a4493732cf..cb5d38f1c9c8 100644
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
> > @@ -199,6 +202,83 @@ static int vp_active_vq(struct virtqueue *vq, u16 =
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
> > +	 * being received again and the pending irq, call disable_irq().
> > +	 *
> > +	 * In the scenario based on shared interrupts, vq will be searched fr=
om
> > +	 * the queue virtqueues. Since the previous list_del() has been delet=
ed
> > +	 * from the queue, it is impossible for vq to be called in this case.
> > +	 * There is no need to close the corresponding interrupt.
> > +	 */
> > +	if (vp_dev->per_vq_vectors && info->msix_vector !=3D VIRTIO_MSI_NO_VE=
CTOR)
> > +		disable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
>
>
> See the previous discussion and the revert of the first try to harden
> the interrupt. We probably can't use disable_irq() since it conflicts
> with the affinity managed IRQ that is used by some drivers.
>
> We need to use synchonize_irq() and per virtqueue flag instead. As
> mentioned in previous patches, this could be done on top of my rework on
> the IRQ hardening .

OK, the next version will contain hardened features by per virtqueue flag.

Thanks.

>
>
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
> > +	/* check queue reset status */
> > +	if (vp_modern_get_queue_reset(mdev, index) !=3D 1)
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
> > +	vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
> > +
> > +	if (vp_dev->per_vq_vectors && info->msix_vector !=3D VIRTIO_MSI_NO_VE=
CTOR)
> > +		enable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
>
>
> We had the same issue as disable_irq().
>
> Thanks
>
>
> > +
> > +	vq->reset =3D false;
> > +
> > +	return 0;
> > +}
> > +
> >   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vec=
tor)
> >   {
> >   	return vp_modern_config_vector(&vp_dev->mdev, vector);
> > @@ -407,6 +487,8 @@ static const struct virtio_config_ops virtio_pci_co=
nfig_nodev_ops =3D {
> >   	.set_vq_affinity =3D vp_set_vq_affinity,
> >   	.get_vq_affinity =3D vp_get_vq_affinity,
> >   	.get_shm_region  =3D vp_get_shm_region,
> > +	.reset_vq	 =3D vp_modern_reset_vq,
> > +	.enable_reset_vq =3D vp_modern_enable_reset_vq,
> >   };
> >
> >   static const struct virtio_config_ops virtio_pci_config_ops =3D {
> > @@ -425,6 +507,8 @@ static const struct virtio_config_ops virtio_pci_co=
nfig_ops =3D {
> >   	.set_vq_affinity =3D vp_set_vq_affinity,
> >   	.get_vq_affinity =3D vp_get_vq_affinity,
> >   	.get_shm_region  =3D vp_get_shm_region,
> > +	.reset_vq	 =3D vp_modern_reset_vq,
> > +	.enable_reset_vq =3D vp_modern_enable_reset_vq,
> >   };
> >
> >   /* the PCI probing function */
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 6250e19fc5bf..91937e21edca 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2028,6 +2028,7 @@ static struct virtqueue *vring_create_virtqueue_p=
acked(
> >   	vq->vq.vdev =3D vdev;
> >   	vq->vq.name =3D name;
> >   	vq->vq.index =3D index;
> > +	vq->vq.reset =3D false;
> >   	vq->notify =3D notify;
> >   	vq->weak_barriers =3D weak_barriers;
> >
> > @@ -2508,6 +2509,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned =
int index,
> >   	vq->vq.vdev =3D vdev;
> >   	vq->vq.name =3D name;
> >   	vq->vq.index =3D index;
> > +	vq->vq.reset =3D false;
> >   	vq->notify =3D notify;
> >   	vq->weak_barriers =3D weak_barriers;
> >
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index c86ff02e0ca0..33ab003c5100 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -33,6 +33,7 @@ struct virtqueue {
> >   	unsigned int num_free;
> >   	unsigned int num_max;
> >   	void *priv;
> > +	bool reset;
> >   };
> >
> >   int virtqueue_add_outbuf(struct virtqueue *vq,
>
