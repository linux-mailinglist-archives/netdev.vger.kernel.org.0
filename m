Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FA757D91E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 05:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiGVD57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 23:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiGVD54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 23:57:56 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136CD6C105;
        Thu, 21 Jul 2022 20:57:52 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VK3SFm4_1658462266;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VK3SFm4_1658462266)
          by smtp.aliyun-inc.com;
          Fri, 22 Jul 2022 11:57:47 +0800
Message-ID: <1658461678.632858-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v12 08/40] virtio_ring: split: extract the logic of alloc queue
Date:   Fri, 22 Jul 2022 11:47:58 +0800
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
 <20220720030436.79520-9-xuanzhuo@linux.alibaba.com>
 <0b3c985d-d479-a554-4fe2-bfe94fc74070@redhat.com>
In-Reply-To: <0b3c985d-d479-a554-4fe2-bfe94fc74070@redhat.com>
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

On Thu, 21 Jul 2022 17:13:49 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/7/20 11:04, Xuan Zhuo =E5=86=99=E9=81=93:
> > Separate the logic of split to create vring queue.
> >
> > This feature is required for subsequent virtuqueue reset vring.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 68 ++++++++++++++++++++++--------------
> >   1 file changed, 42 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index c94c5461e702..c7971438bb2c 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -950,28 +950,19 @@ static void vring_free_split(struct vring_virtque=
ue_split *vring_split,
> >   	kfree(vring_split->desc_extra);
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
> > +static int vring_alloc_queue_split(struct vring_virtqueue_split *vring=
_split,
> > +				   struct virtio_device *vdev,
> > +				   u32 num,
> > +				   unsigned int vring_align,
> > +				   bool may_reduce_num)
> >   {
> > -	struct virtqueue *vq;
> >   	void *queue =3D NULL;
> >   	dma_addr_t dma_addr;
> > -	size_t queue_size_in_bytes;
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
> > @@ -982,11 +973,11 @@ static struct virtqueue *vring_create_virtqueue_s=
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
> > @@ -994,21 +985,46 @@ static struct virtqueue *vring_create_virtqueue_s=
plit(
> >   					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
> >   	}
> >   	if (!queue)
> > -		return NULL;
> > +		return -ENOMEM;
> > +
> > +	vring_init(&vring_split->vring, num, queue, vring_align);
> >
> > -	queue_size_in_bytes =3D vring_size(num, vring_align);
> > -	vring_init(&vring, num, queue, vring_align);
> > +	vring_split->queue_dma_addr =3D dma_addr;
> > +	vring_split->queue_size_in_bytes =3D vring_size(num, vring_align);
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
> > +	struct vring_virtqueue_split vring_split =3D {};
> > +	struct virtqueue *vq;
> > +	int err;
> > +
> > +	err =3D vring_alloc_queue_split(&vring_split, vdev, num, vring_align,
> > +				      may_reduce_num);
> > +	if (err)
> > +		return NULL;
> >
> > -	vq =3D __vring_new_virtqueue(index, vring, vdev, weak_barriers, conte=
xt,
> > -				   notify, callback, name);
> > +	vq =3D __vring_new_virtqueue(index, vring_split.vring, vdev, weak_bar=
riers,
> > +				   context, notify, callback, name);
> >   	if (!vq) {
> > -		vring_free_queue(vdev, queue_size_in_bytes, queue,
> > -				 dma_addr);
> > +		vring_free_split(&vring_split, vdev);
> >   		return NULL;
> >   	}
> >
> > -	to_vvq(vq)->split.queue_dma_addr =3D dma_addr;
> > -	to_vvq(vq)->split.queue_size_in_bytes =3D queue_size_in_bytes;
> > +	to_vvq(vq)->split.queue_dma_addr =3D vring_split.queue_dma_addr;
> > +	to_vvq(vq)->split.queue_size_in_bytes =3D vring_split.queue_size_in_b=
ytes;
>
>
> This still seems a little bit redundant since the current logic is a
> little bit complicated since the vq->split is not initialized in a
> single place.
>
> I wonder if it's better to:
>
> vring_alloc_queue_split()
> vring_alloc_desc_extra() (reorder to make patch 9 come first)
>
> then we can simply assign vring_split to vq->split in
> __vring_new_virtqueue() since it has:
>
>  =C2=A0=C2=A0=C2=A0 vq->split.queue_dma_addr =3D 0;
>  =C2=A0=C2=A0 =C2=A0vq->split.queue_size_in_bytes =3D 0;
>
>  =C2=A0=C2=A0=C2=A0 vq->split.vring =3D vring;
>  =C2=A0=C2=A0=C2=A0 vq->split.avail_flags_shadow =3D 0;
>  =C2=A0=C2=A0=C2=A0 vq->split.avail_idx_shadow =3D 0;
>
> This seems to simplify the logic and task of e.g
> virtqueue_vring_attach_split() to a simple:
>
> vq->split=3D vring_split;

This does look simpler. The reason for not doing this is that the argument
accepted by __vring_new_virtqueue() is "struct vring", and
__vring_new_virtqueue() is an export symbol.

I took a look, and the only external direct call to __vring_new_virtqueue is
here.

	tools/virtio/virtio_test.c
	static void vq_reset(struct vq_info *info, int num, struct virtio_device *=
vdev)
	{
		if (info->vq)
			vring_del_virtqueue(info->vq);

		memset(info->ring, 0, vring_size(num, 4096));
		vring_init(&info->vring, num, info->ring, 4096);
		info->vq =3D __vring_new_virtqueue(info->idx, info->vring, vdev, true,
						 false, vq_notify, vq_callback, "test");
		assert(info->vq);
		info->vq->priv =3D info;
	}

I think this could be replaced with vring_new_virtqueue() so that we don't =
need
to make __vring_new_virtqueue as an export function so we can make some
modifications to it.

nit: vring_alloc_desc_extra() should not have to be extract from
__vring_new_virtqueue() .

Thanks.

>
> And if this makes sense, we can do something similar to packed ring.
>
> Thanks
>
>
> >   	to_vvq(vq)->we_own_ring =3D true;
> >
> >   	return vq;
>
