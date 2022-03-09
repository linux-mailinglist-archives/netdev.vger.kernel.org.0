Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4CB4D2BB8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiCIJXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiCIJXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:23:05 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4A316E7E5;
        Wed,  9 Mar 2022 01:22:02 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6j1jVj_1646817715;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6j1jVj_1646817715)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 17:21:57 +0800
Message-ID: <1646817687.2614713-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 05/26] virtio_ring: split: extract the logic of init vq and attach vring
Date:   Wed, 9 Mar 2022 17:21:27 +0800
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
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-6-xuanzhuo@linux.alibaba.com>
 <85dde6ed-cdf1-61e4-6f05-d3e2477b9e35@redhat.com>
In-Reply-To: <85dde6ed-cdf1-61e4-6f05-d3e2477b9e35@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 15:36:59 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:34, Xuan Zhuo =E5=86=99=E9=81=93:
> > Split the logic of split assignment vq into three parts.
> >
> > 1. The assignment passed from the function parameter
> > 2. The part that attaches vring to vq. -- __vring_virtqueue_attach_spli=
t()
> > 3. The part that initializes vq to a fixed value --
> >     __vring_virtqueue_init_split()
> >
> > This feature is required for subsequent virtuqueue reset vring
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 111 +++++++++++++++++++++--------------
> >   1 file changed, 67 insertions(+), 44 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index d32793615451..dc6313b79305 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2196,34 +2196,40 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> >   }
> >   EXPORT_SYMBOL_GPL(vring_interrupt);
> >
> > -/* Only available for split ring */
> > -struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > -					struct vring vring,
> > -					struct virtio_device *vdev,
> > -					bool weak_barriers,
> > -					bool context,
> > -					bool (*notify)(struct virtqueue *),
> > -					void (*callback)(struct virtqueue *),
> > -					const char *name)
> > +static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> > +					  struct virtio_device *vdev,
> > +					  struct vring vring)
> >   {
> > -	struct vring_virtqueue *vq;
> > +	vq->vq.num_free =3D vring.num;
> >
> > -	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
> > -		return NULL;
> > +	vq->split.vring =3D vring;
> > +	vq->split.queue_dma_addr =3D 0;
> > +	vq->split.queue_size_in_bytes =3D 0;
> >
> > -	vq =3D kmalloc(sizeof(*vq), GFP_KERNEL);
> > -	if (!vq)
> > -		return NULL;
> > +	vq->split.desc_state =3D kmalloc_array(vring.num,
> > +					     sizeof(struct vring_desc_state_split), GFP_KERNEL);
> > +	if (!vq->split.desc_state)
> > +		goto err_state;
> >
> > +	vq->split.desc_extra =3D vring_alloc_desc_extra(vq, vring.num);
> > +	if (!vq->split.desc_extra)
> > +		goto err_extra;
>
>
> So this contains stuffs more than just attach. I wonder if it's better
> to split the allocation out to an dedicated helper (we have dedicated
> helper to allocate vring).

I will try in next version.

Thanks.

>
> Thanks
>
>
> > +
> > +	memset(vq->split.desc_state, 0, vring.num *
> > +	       sizeof(struct vring_desc_state_split));
> > +	return 0;
> > +
> > +err_extra:
> > +	kfree(vq->split.desc_state);
> > +err_state:
> > +	return -ENOMEM;
> > +}
> > +
> > +static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
> > +					 struct virtio_device *vdev)
> > +{
> >   	vq->packed_ring =3D false;
> > -	vq->vq.callback =3D callback;
> > -	vq->vq.vdev =3D vdev;
> > -	vq->vq.name =3D name;
> > -	vq->vq.num_free =3D vring.num;
> > -	vq->vq.index =3D index;
> >   	vq->we_own_ring =3D false;
> > -	vq->notify =3D notify;
> > -	vq->weak_barriers =3D weak_barriers;
> >   	vq->broken =3D false;
> >   	vq->last_used_idx =3D 0;
> >   	vq->event_triggered =3D false;
> > @@ -2234,50 +2240,67 @@ struct virtqueue *__vring_new_virtqueue(unsigne=
d int index,
> >   	vq->last_add_time_valid =3D false;
> >   #endif
> >
> > -	vq->indirect =3D virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC=
) &&
> > -		!context;
> >   	vq->event =3D virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> >
> >   	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> >   		vq->weak_barriers =3D false;
> >
> > -	vq->split.queue_dma_addr =3D 0;
> > -	vq->split.queue_size_in_bytes =3D 0;
> > -
> > -	vq->split.vring =3D vring;
> >   	vq->split.avail_flags_shadow =3D 0;
> >   	vq->split.avail_idx_shadow =3D 0;
> >
> >   	/* No callback?  Tell other side not to bother us. */
> > -	if (!callback) {
> > +	if (!vq->vq.callback) {
> >   		vq->split.avail_flags_shadow |=3D VRING_AVAIL_F_NO_INTERRUPT;
> >   		if (!vq->event)
> >   			vq->split.vring.avail->flags =3D cpu_to_virtio16(vdev,
> >   					vq->split.avail_flags_shadow);
> >   	}
> >
> > -	vq->split.desc_state =3D kmalloc_array(vring.num,
> > -			sizeof(struct vring_desc_state_split), GFP_KERNEL);
> > -	if (!vq->split.desc_state)
> > -		goto err_state;
> > -
> > -	vq->split.desc_extra =3D vring_alloc_desc_extra(vq, vring.num);
> > -	if (!vq->split.desc_extra)
> > -		goto err_extra;
> > -
> >   	/* Put everything in free lists. */
> >   	vq->free_head =3D 0;
> > -	memset(vq->split.desc_state, 0, vring.num *
> > -			sizeof(struct vring_desc_state_split));
> > +}
> > +
> > +/* Only available for split ring */
> > +struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > +					struct vring vring,
> > +					struct virtio_device *vdev,
> > +					bool weak_barriers,
> > +					bool context,
> > +					bool (*notify)(struct virtqueue *),
> > +					void (*callback)(struct virtqueue *),
> > +					const char *name)
> > +{
> > +	struct vring_virtqueue *vq;
> > +	int err;
> > +
> > +	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
> > +		return NULL;
> > +
> > +	vq =3D kmalloc(sizeof(*vq), GFP_KERNEL);
> > +	if (!vq)
> > +		return NULL;
> > +
> > +	vq->vq.callback =3D callback;
> > +	vq->vq.vdev =3D vdev;
> > +	vq->vq.name =3D name;
> > +	vq->vq.index =3D index;
> > +	vq->notify =3D notify;
> > +	vq->weak_barriers =3D weak_barriers;
> > +	vq->indirect =3D virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC=
) &&
> > +		!context;
> > +
> > +	err =3D __vring_virtqueue_attach_split(vq, vdev, vring);
> > +	if (err)
> > +		goto err;
> > +
> > +	__vring_virtqueue_init_split(vq, vdev);
> >
> >   	spin_lock(&vdev->vqs_list_lock);
> >   	list_add_tail(&vq->vq.list, &vdev->vqs);
> >   	spin_unlock(&vdev->vqs_list_lock);
> > -	return &vq->vq;
> >
> > -err_extra:
> > -	kfree(vq->split.desc_state);
> > -err_state:
> > +	return &vq->vq;
> > +err:
> >   	kfree(vq);
> >   	return NULL;
> >   }
>
