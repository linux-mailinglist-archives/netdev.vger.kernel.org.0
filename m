Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7125D4FF001
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiDMGnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiDMGnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:43:20 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5ED286C0;
        Tue, 12 Apr 2022 23:40:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V9yQeE6_1649832051;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9yQeE6_1649832051)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 14:40:53 +0800
Message-ID: <1649831529.7724812-5-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 11/32] virtio_ring: split: introduce virtqueue_resize_split()
Date:   Wed, 13 Apr 2022 14:32:09 +0800
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
 <20220406034346.74409-12-xuanzhuo@linux.alibaba.com>
 <f79fc367-7ac5-961b-83c5-90f3d097c672@redhat.com>
In-Reply-To: <f79fc367-7ac5-961b-83c5-90f3d097c672@redhat.com>
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

On Tue, 12 Apr 2022 13:53:44 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
> > virtio ring split supports resize.
> >
> > Only after the new vring is successfully allocated based on the new num,
> > we will release the old vring. In any case, an error is returned,
> > indicating that the vring still points to the old vring.
> >
> > In the case of an error, the caller must
> > re-initialize(virtqueue_reinit_split()) the virtqueue to ensure that the
> > vring can be used.
> >
> > In addition, vring_align, may_reduce_num are necessary for reallocating
> > vring, so they are retained for creating vq.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 47 ++++++++++++++++++++++++++++++++++++
> >   1 file changed, 47 insertions(+)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 3dc6ace2ba7a..33864134a744 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -139,6 +139,12 @@ struct vring_virtqueue {
> >   			/* DMA address and size information */
> >   			dma_addr_t queue_dma_addr;
> >   			size_t queue_size_in_bytes;
> > +
> > +			/* The parameters for creating vrings are reserved for
> > +			 * creating new vring.
> > +			 */
> > +			u32 vring_align;
> > +			bool may_reduce_num;
> >   		} split;
> >
> >   		/* Available for packed ring */
> > @@ -199,6 +205,7 @@ struct vring_virtqueue {
> >   };
> >
> >   static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int n=
um);
> > +static void vring_free(struct virtqueue *_vq);
> >
> >   /*
> >    * Helpers.
> > @@ -1088,6 +1095,8 @@ static struct virtqueue *vring_create_virtqueue_s=
plit(
> >   		return NULL;
> >   	}
> >
> > +	to_vvq(vq)->split.vring_align =3D vring_align;
> > +	to_vvq(vq)->split.may_reduce_num =3D may_reduce_num;
>
>
> It looks to me the above should belong to patch 6.

patch 6 just extracts a function, no logical modification.

to_vvq(vq)->split.may_reduce_num is newly added, so I don't think it should=
 be
merged into patch 6.

>
>
> >   	to_vvq(vq)->split.queue_dma_addr =3D dma_addr;
> >   	to_vvq(vq)->split.queue_size_in_bytes =3D queue_size_in_bytes;
> >   	to_vvq(vq)->we_own_ring =3D true;
> > @@ -1095,6 +1104,44 @@ static struct virtqueue *vring_create_virtqueue_=
split(
> >   	return vq;
> >   }
> >
> > +static int virtqueue_resize_split(struct virtqueue *_vq, u32 num)
> > +{
> > +	struct vring_virtqueue *vq =3D to_vvq(_vq);
> > +	struct virtio_device *vdev =3D _vq->vdev;
> > +	struct vring_desc_state_split *state;
> > +	struct vring_desc_extra *extra;
> > +	size_t queue_size_in_bytes;
> > +	dma_addr_t dma_addr;
> > +	struct vring vring;
> > +	int err =3D -ENOMEM;
> > +	void *queue;
> > +
> > +	queue =3D vring_alloc_queue_split(vdev, &dma_addr, &num,
> > +					vq->split.vring_align,
> > +					vq->weak_barriers,
> > +					vq->split.may_reduce_num);
> > +	if (!queue)
> > +		return -ENOMEM;
> > +
> > +	queue_size_in_bytes =3D vring_size(num, vq->split.vring_align);
> > +
> > +	err =3D vring_alloc_state_extra_split(num, &state, &extra);
> > +	if (err) {
> > +		vring_free_queue(vdev, queue_size_in_bytes, queue, dma_addr);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	vring_free(&vq->vq);
> > +
> > +	vring_init(&vring, num, queue, vq->split.vring_align);
> > +	vring_virtqueue_attach_split(vq, vring, state, extra);
> > +	vq->split.queue_dma_addr =3D dma_addr;
> > +	vq->split.queue_size_in_bytes =3D queue_size_in_bytes;
>
>
> I wonder if it's better to move the above assignments to
> vring_virtqueue_attach_split().

I also think so, the reason for not doing this is that there is no dma_addr=
 and
queue_size_in_bytes when vring_virtqueue_attach_split is called in
__vring_new_virtqueue.

As discussed in patch 12, we can pass the struct struct vring_virtqueue_spl=
it to
vring_virtqueue_attach_split(). This is much more convenient.

Thanks.

>
> Other looks good.
>
> Thanks
>
>
> > +
> > +	vring_virtqueue_init_split(vq, vdev, true);
> > +	return 0;
> > +}
> > +
> >
> >   /*
> >    * Packed ring specific functions - *_packed().
>
