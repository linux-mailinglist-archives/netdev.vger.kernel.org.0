Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EDD564B6F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 04:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiGDCEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 22:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGDCEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 22:04:50 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5809538BB;
        Sun,  3 Jul 2022 19:04:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VIDpTgv_1656900279;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VIDpTgv_1656900279)
          by smtp.aliyun-inc.com;
          Mon, 04 Jul 2022 10:04:40 +0800
Message-ID: <1656900267.44917-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v11 09/40] virtio_ring: split: extract the logic of alloc state and extra
Date:   Mon, 4 Jul 2022 10:04:27 +0800
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
 <20220629065656.54420-10-xuanzhuo@linux.alibaba.com>
 <c4d24e5c-1a3e-e577-462e-c9ebde90d659@redhat.com>
In-Reply-To: <c4d24e5c-1a3e-e577-462e-c9ebde90d659@redhat.com>
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

On Fri, 1 Jul 2022 16:55:05 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
> > Separate the logic of creating desc_state, desc_extra, and subsequent
> > patches will call it independently.
> >
> > Since only the structure vring is passed into __vring_new_virtqueue(),
> > when creating the function vring_alloc_state_extra_split(), we prefer to
> > use vring_virtqueue_split as a parameter, and it will be more convenient
> > to pass vring_virtqueue_split to some subsequent functions.
> >
> > So a new vring_virtqueue_split variable is added in
> > __vring_new_virtqueue().
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 58 +++++++++++++++++++++++++-----------
> >   1 file changed, 40 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index a9ceb9c16c54..cedd340d6db7 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -204,6 +204,7 @@ struct vring_virtqueue {
> >   #endif
> >   };
> >
> > +static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int nu=
m);
> >
> >   /*
> >    * Helpers.
> > @@ -939,6 +940,32 @@ static void *virtqueue_detach_unused_buf_split(str=
uct virtqueue *_vq)
> >   	return NULL;
> >   }
> >
> > +static int vring_alloc_state_extra_split(struct vring_virtqueue_split =
*vring)
> > +{
> > +	struct vring_desc_state_split *state;
> > +	struct vring_desc_extra *extra;
> > +	u32 num =3D vring->vring.num;
> > +
> > +	state =3D kmalloc_array(num, sizeof(struct vring_desc_state_split), G=
FP_KERNEL);
> > +	if (!state)
> > +		goto err_state;
> > +
> > +	extra =3D vring_alloc_desc_extra(num);
> > +	if (!extra)
> > +		goto err_extra;
> > +
> > +	memset(state, 0, num * sizeof(struct vring_desc_state_split));
> > +
> > +	vring->desc_state =3D state;
> > +	vring->desc_extra =3D extra;
> > +	return 0;
> > +
> > +err_extra:
> > +	kfree(state);
> > +err_state:
> > +	return -ENOMEM;
> > +}
> > +
> >   static void vring_free_split(struct vring_virtqueue_split *vring,
> >   			     struct virtio_device *vdev)
> >   {
> > @@ -2224,7 +2251,7 @@ EXPORT_SYMBOL_GPL(vring_interrupt);
> >
> >   /* Only available for split ring */
> >   struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > -					struct vring vring,
> > +					struct vring _vring,
> >   					struct virtio_device *vdev,
> >   					bool weak_barriers,
> >   					bool context,
> > @@ -2232,7 +2259,9 @@ struct virtqueue *__vring_new_virtqueue(unsigned =
int index,
> >   					void (*callback)(struct virtqueue *),
> >   					const char *name)
> >   {
> > +	struct vring_virtqueue_split vring =3D {};
>
>
> Nit: to reduce the change-set, let's use vring_split here?

Will fix.

Thanks.


>
> Other looks good.
>
> Thanks
>
>
> >   	struct vring_virtqueue *vq;
> > +	int err;
> >
> >   	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
> >   		return NULL;
> > @@ -2261,7 +2290,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned =
int index,
> >   	vq->split.queue_dma_addr =3D 0;
> >   	vq->split.queue_size_in_bytes =3D 0;
> >
> > -	vq->split.vring =3D vring;
> > +	vq->split.vring =3D _vring;
> >   	vq->split.avail_flags_shadow =3D 0;
> >   	vq->split.avail_idx_shadow =3D 0;
> >
> > @@ -2273,30 +2302,23 @@ struct virtqueue *__vring_new_virtqueue(unsigne=
d int index,
> >   					vq->split.avail_flags_shadow);
> >   	}
> >
> > -	vq->split.desc_state =3D kmalloc_array(vring.num,
> > -			sizeof(struct vring_desc_state_split), GFP_KERNEL);
> > -	if (!vq->split.desc_state)
> > -		goto err_state;
> > +	vring.vring =3D _vring;
> >
> > -	vq->split.desc_extra =3D vring_alloc_desc_extra(vring.num);
> > -	if (!vq->split.desc_extra)
> > -		goto err_extra;
> > +	err =3D vring_alloc_state_extra_split(&vring);
> > +	if (err) {
> > +		kfree(vq);
> > +		return NULL;
> > +	}
> >
> > -	memset(vq->split.desc_state, 0, vring.num *
> > -			sizeof(struct vring_desc_state_split));
> > +	vq->split.desc_state =3D vring.desc_state;
> > +	vq->split.desc_extra =3D vring.desc_extra;
> >
> > -	virtqueue_init(vq, vq->split.vring.num);
> > +	virtqueue_init(vq, vring.vring.num);
> >
> >   	spin_lock(&vdev->vqs_list_lock);
> >   	list_add_tail(&vq->vq.list, &vdev->vqs);
> >   	spin_unlock(&vdev->vqs_list_lock);
> >   	return &vq->vq;
> > -
> > -err_extra:
> > -	kfree(vq->split.desc_state);
> > -err_state:
> > -	kfree(vq);
> > -	return NULL;
> >   }
> >   EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
> >
>
