Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA38B562EB3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbiGAIrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiGAIrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:47:01 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8C073592;
        Fri,  1 Jul 2022 01:46:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VI.FZu2_1656665211;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VI.FZu2_1656665211)
          by smtp.aliyun-inc.com;
          Fri, 01 Jul 2022 16:46:52 +0800
Message-ID: <1656665158.0036178-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v11 08/40] virtio_ring: split: extract the logic of alloc queue
Date:   Fri, 1 Jul 2022 16:45:58 +0800
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
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-9-xuanzhuo@linux.alibaba.com>
 <3e36e44f-1f37-ad02-eb89-833a0856ec4e@redhat.com>
In-Reply-To: <3e36e44f-1f37-ad02-eb89-833a0856ec4e@redhat.com>
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

On Fri, 1 Jul 2022 16:26:25 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
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
> > index 49d61e412dc6..a9ceb9c16c54 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -949,28 +949,19 @@ static void vring_free_split(struct vring_virtque=
ue_split *vring,
> >   	kfree(vring->desc_extra);
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
> > +static int vring_alloc_queue_split(struct vring_virtqueue_split *vring,
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
> > @@ -981,11 +972,11 @@ static struct virtqueue *vring_create_virtqueue_s=
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
> > @@ -993,21 +984,46 @@ static struct virtqueue *vring_create_virtqueue_s=
plit(
> >   					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
> >   	}
> >   	if (!queue)
> > -		return NULL;
> > +		return -ENOMEM;
> > +
> > +	vring_init(&vring->vring, num, queue, vring_align);
> >
> > -	queue_size_in_bytes =3D vring_size(num, vring_align);
> > -	vring_init(&vring, num, queue, vring_align);
> > +	vring->queue_dma_addr =3D dma_addr;
> > +	vring->queue_size_in_bytes =3D vring_size(num, vring_align);
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
> > +	struct vring_virtqueue_split vring =3D {};
> > +	struct virtqueue *vq;
> > +	int err;
> > +
> > +	err =3D vring_alloc_queue_split(&vring, vdev, num, vring_align,
> > +				      may_reduce_num);
> > +	if (err)
> > +		return NULL;
> >
> > -	vq =3D __vring_new_virtqueue(index, vring, vdev, weak_barriers, conte=
xt,
> > -				   notify, callback, name);
> > +	vq =3D __vring_new_virtqueue(index, vring.vring, vdev, weak_barriers,
> > +				   context, notify, callback, name);
> >   	if (!vq) {
> > -		vring_free_queue(vdev, queue_size_in_bytes, queue,
> > -				 dma_addr);
> > +		vring_free_split(&vring, vdev);
> >   		return NULL;
> >   	}
> >
> > -	to_vvq(vq)->split.queue_dma_addr =3D dma_addr;
> > -	to_vvq(vq)->split.queue_size_in_bytes =3D queue_size_in_bytes;
> > +	to_vvq(vq)->split.queue_dma_addr =3D vring.queue_dma_addr;
>
>
> Nit: having two queue_dma_addr seems redundant (so did queue_size_in_byte=
s).

two?

Where is the problem I don't understand?

Thanks.

>
> Thanks
>
>
> > +	to_vvq(vq)->split.queue_size_in_bytes =3D vring.queue_size_in_bytes;
> >   	to_vvq(vq)->we_own_ring =3D true;
> >
> >   	return vq;
>
