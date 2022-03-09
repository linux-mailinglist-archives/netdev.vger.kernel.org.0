Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7938E4D2BAC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiCIJVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiCIJVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:21:50 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE4E3465F;
        Wed,  9 Mar 2022 01:20:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6j5tde_1646817644;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6j5tde_1646817644)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 17:20:45 +0800
Message-ID: <1646817603.8985817-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 04/26] virtio_ring: split: extract the logic of creating vring
Date:   Wed, 9 Mar 2022 17:20:03 +0800
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
 <20220308123518.33800-5-xuanzhuo@linux.alibaba.com>
 <4b32d0b4-b794-cc1c-25f7-50b5ea6ac25e@redhat.com>
In-Reply-To: <4b32d0b4-b794-cc1c-25f7-50b5ea6ac25e@redhat.com>
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

Agree for all.

Thanks.

On Wed, 9 Mar 2022 14:46:01 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:34, Xuan Zhuo =E5=86=99=E9=81=93:
> > Separate the logic of split to create vring queue.
> >
> > For the convenience of passing parameters, add a structure
> > vring_split.
> >
> > This feature is required for subsequent virtuqueue reset vring.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 74 +++++++++++++++++++++++++-----------
> >   1 file changed, 51 insertions(+), 23 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index b87130c8f312..d32793615451 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -85,6 +85,13 @@ struct vring_desc_extra {
> >   	u16 next;			/* The next desc state in a list. */
> >   };
> >
> > +struct vring_split {
> > +	void *queue;
> > +	dma_addr_t dma_addr;
> > +	size_t queue_size_in_bytes;
> > +	struct vring vring;
> > +};
>
>
> So this structure will be only used in vring_create_vring_split() which
> seems not that useful.
>
> More see below.
>
>
> > +
> >   struct vring_virtqueue {
> >   	struct virtqueue vq;
> >
> > @@ -915,28 +922,21 @@ static void *virtqueue_detach_unused_buf_split(st=
ruct virtqueue *_vq)
> >   	return NULL;
> >   }
> >
> > -static struct virtqueue *vring_create_virtqueue_split(
> > -	unsigned int index,
> > -	unsigned int num,
> > -	unsigned int vring_align,
> > -	struct virtio_device *vdev,
> > -	bool weak_barriers,
> > -	bool may_reduce_num,
> > -	bool context,
> > -	bool (*notify)(struct virtqueue *),
> > -	void (*callback)(struct virtqueue *),
> > -	const char *name)
> > +static int vring_create_vring_split(struct vring_split *vring,
> > +				    struct virtio_device *vdev,
> > +				    unsigned int vring_align,
> > +				    bool weak_barriers,
> > +				    bool may_reduce_num,
> > +				    u32 num)
>
>
> I'd rename this as vring_alloc_queue_split() and let it simply return
> the address of queue like vring_alloc_queue().
>
> And let it simple accept dma_addr_t *dma_adder instead of vring_split.
>
>
> >   {
> > -	struct virtqueue *vq;
> >   	void *queue =3D NULL;
> >   	dma_addr_t dma_addr;
> >   	size_t queue_size_in_bytes;
> > -	struct vring vring;
> >
> >   	/* We assume num is a power of 2. */
> >   	if (num & (num - 1)) {
> >   		dev_warn(&vdev->dev, "Bad virtqueue length %u\n", num);
> > -		return NULL;
> > +		return -EINVAL;
> >   	}
> >
> >   	/* TODO: allocate each queue chunk individually */
> > @@ -947,11 +947,11 @@ static struct virtqueue *vring_create_virtqueue_s=
plit(
> >   		if (queue)
> >   			break;
> >   		if (!may_reduce_num)
> > -			return NULL;
> > +			return -ENOMEM;
> >   	}
> >
> >   	if (!num)
> > -		return NULL;
> > +		return -ENOMEM;
> >
> >   	if (!queue) {
> >   		/* Try to get a single page. You are my only hope! */
> > @@ -959,21 +959,49 @@ static struct virtqueue *vring_create_virtqueue_s=
plit(
> >   					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
> >   	}
> >   	if (!queue)
> > -		return NULL;
> > +		return -ENOMEM;
> >
> >   	queue_size_in_bytes =3D vring_size(num, vring_align);
> > -	vring_init(&vring, num, queue, vring_align);
> > +	vring_init(&vring->vring, num, queue, vring_align);
>
>
> It's better to move this to its caller (vring_create_virtqueue_split),
> so we have rather simple logic below:
>
>
>
> > +
> > +	vring->dma_addr =3D dma_addr;
> > +	vring->queue =3D queue;
> > +	vring->queue_size_in_bytes =3D queue_size_in_bytes;
> > +
> > +	return 0;
> > +}
> > +
> > +static struct virtqueue *vring_create_virtqueue_split(
> > +	unsigned int index,
> > +	unsigned int num,
> > +	unsigned int vring_align,
> > +	struct virtio_device *vdev,
> > +	bool weak_barriers,
> > +	bool may_reduce_num,
> > +	bool context,
> > +	bool (*notify)(struct virtqueue *),
> > +	void (*callback)(struct virtqueue *),
> > +	const char *name)
> > +{
> > +	struct vring_split vring;
> > +	struct virtqueue *vq;
> > +	int err;
> > +
> > +	err =3D vring_create_vring_split(&vring, vdev, vring_align, weak_barr=
iers,
> > +				       may_reduce_num, num);
> > +	if (err)
> > +		return NULL;
>
>
> queue =3D vring_alloc_queue_split(vdev, &dma_addr, ...);
>
> if (!queue)
>
>  =C2=A0=C2=A0=C2=A0 return -ENOMEM;
>
> vring_init();
>
> ...
>
> Thanks
>
>
> >
> > -	vq =3D __vring_new_virtqueue(index, vring, vdev, weak_barriers, conte=
xt,
> > +	vq =3D __vring_new_virtqueue(index, vring.vring, vdev, weak_barriers,=
 context,
> >   				   notify, callback, name);
> >   	if (!vq) {
> > -		vring_free_queue(vdev, queue_size_in_bytes, queue,
> > -				 dma_addr);
> > +		vring_free_queue(vdev, vring.queue_size_in_bytes, vring.queue,
> > +				 vring.dma_addr);
> >   		return NULL;
> >   	}
> >
> > -	to_vvq(vq)->split.queue_dma_addr =3D dma_addr;
> > -	to_vvq(vq)->split.queue_size_in_bytes =3D queue_size_in_bytes;
> > +	to_vvq(vq)->split.queue_dma_addr =3D vring.dma_addr;
> > +	to_vvq(vq)->split.queue_size_in_bytes =3D vring.queue_size_in_bytes;
> >   	to_vvq(vq)->we_own_ring =3D true;
> >
> >   	return vq;
>
