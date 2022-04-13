Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282314FF027
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiDMGzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbiDMGzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:55:11 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B26210F2;
        Tue, 12 Apr 2022 23:52:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V9yF1bX_1649832763;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9yF1bX_1649832763)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 14:52:44 +0800
Message-ID: <1649832486.146921-7-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 07/32] virtio_ring: split: extract the logic of alloc state and extra
Date:   Wed, 13 Apr 2022 14:48:06 +0800
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
 <20220406034346.74409-8-xuanzhuo@linux.alibaba.com>
 <927ee895-84ae-fb69-c9ed-9c1836ff1d03@redhat.com>
In-Reply-To: <927ee895-84ae-fb69-c9ed-9c1836ff1d03@redhat.com>
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

On Tue, 12 Apr 2022 11:26:49 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
> > Separate the logic of creating desc_state, desc_extra, and subsequent
> > patches will call it independently.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++++----------
> >   1 file changed, 38 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 72d5ae063fa0..6de67439cb57 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -198,6 +198,7 @@ struct vring_virtqueue {
> >   #endif
> >   };
> >
> > +static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int nu=
m);
> >
> >   /*
> >    * Helpers.
> > @@ -915,6 +916,33 @@ static void *virtqueue_detach_unused_buf_split(str=
uct virtqueue *_vq)
> >   	return NULL;
> >   }
> >
> > +static int vring_alloc_state_extra_split(u32 num,
> > +					 struct vring_desc_state_split **desc_state,
> > +					 struct vring_desc_extra **desc_extra)
> > +{
> > +	struct vring_desc_state_split *state;
> > +	struct vring_desc_extra *extra;
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
> > +	*desc_state =3D state;
> > +	*desc_extra =3D extra;
> > +	return 0;
> > +
> > +err_extra:
> > +	kfree(state);
> > +err_state:
> > +	return -ENOMEM;
> > +}
> > +
> >   static void *vring_alloc_queue_split(struct virtio_device *vdev,
> >   				     dma_addr_t *dma_addr,
> >   				     u32 *n,
> > @@ -2196,7 +2224,10 @@ struct virtqueue *__vring_new_virtqueue(unsigned=
 int index,
> >   					void (*callback)(struct virtqueue *),
> >   					const char *name)
> >   {
> > +	struct vring_desc_state_split *state;
> > +	struct vring_desc_extra *extra;
> >   	struct vring_virtqueue *vq;
> > +	int err;
> >
> >   	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
> >   		return NULL;
> > @@ -2246,30 +2277,22 @@ struct virtqueue *__vring_new_virtqueue(unsigne=
d int index,
> >   					vq->split.avail_flags_shadow);
> >   	}
> >
> > -	vq->split.desc_state =3D kmalloc_array(vring.num,
> > -			sizeof(struct vring_desc_state_split), GFP_KERNEL);
> > -	if (!vq->split.desc_state)
> > -		goto err_state;
> > +	err =3D vring_alloc_state_extra_split(vring.num, &state, &extra);
>
>
> Nit: we can pass e.g &vq->split.desc_state here to avoid extra temp
> variable and assignment.

The reason for not doing this is that when we implement resize later, when =
we
call vring_alloc_state_extra_split(), we want to keep the old desc_state, a=
nd
desc_extra because we want to release them.

As discussed in patch 11, 12, struct vring_virtqueue_split will optimize th=
is
logic.

Thanks.

>
> Other looks good.
>
> Thanks
>
>
> > +	if (err) {
> > +		kfree(vq);
> > +		return NULL;
> > +	}
> >
> > -	vq->split.desc_extra =3D vring_alloc_desc_extra(vring.num);
> > -	if (!vq->split.desc_extra)
> > -		goto err_extra;
> > +	vq->split.desc_state =3D state;
> > +	vq->split.desc_extra =3D extra;
> >
> >   	/* Put everything in free lists. */
> >   	vq->free_head =3D 0;
> > -	memset(vq->split.desc_state, 0, vring.num *
> > -			sizeof(struct vring_desc_state_split));
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
