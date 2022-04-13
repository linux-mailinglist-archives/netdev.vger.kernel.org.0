Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792944FF051
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiDMHHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiDMHHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:07:17 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EB21C901;
        Wed, 13 Apr 2022 00:04:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V9yF4q8_1649833489;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9yF4q8_1649833489)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 15:04:50 +0800
Message-ID: <1649833450.9482608-9-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 09/32] virtio_ring: split: extract the logic of vq init
Date:   Wed, 13 Apr 2022 15:04:10 +0800
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
 <20220406034346.74409-10-xuanzhuo@linux.alibaba.com>
 <f91435e4-6559-c0c9-2b37-92084c88dee2@redhat.com>
In-Reply-To: <f91435e4-6559-c0c9-2b37-92084c88dee2@redhat.com>
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

On Tue, 12 Apr 2022 11:42:25 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
> > Separate the logic of initializing vq, and subsequent patches will call
> > it separately.
> >
> > The feature of this part is that it does not depend on the information
> > passed by the upper layer and can be called repeatedly.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 68 ++++++++++++++++++++----------------
> >   1 file changed, 38 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 083f2992ba0d..874f878087a3 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -916,6 +916,43 @@ static void *virtqueue_detach_unused_buf_split(str=
uct virtqueue *_vq)
> >   	return NULL;
> >   }
> >
> > +static void vring_virtqueue_init_split(struct vring_virtqueue *vq,
> > +				       struct virtio_device *vdev,
> > +				       bool own_ring)
> > +{
> > +	vq->packed_ring =3D false;
> > +	vq->vq.num_free =3D vq->split.vring.num;
> > +	vq->we_own_ring =3D own_ring;
> > +	vq->broken =3D false;
> > +	vq->last_used_idx =3D 0;
> > +	vq->event_triggered =3D false;
> > +	vq->num_added =3D 0;
> > +	vq->use_dma_api =3D vring_use_dma_api(vdev);
> > +#ifdef DEBUG
> > +	vq->in_use =3D false;
> > +	vq->last_add_time_valid =3D false;
> > +#endif
> > +
> > +	vq->event =3D virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> > +
> > +	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> > +		vq->weak_barriers =3D false;
> > +
> > +	vq->split.avail_flags_shadow =3D 0;
> > +	vq->split.avail_idx_shadow =3D 0;
> > +
> > +	/* No callback?  Tell other side not to bother us. */
> > +	if (!vq->vq.callback) {
> > +		vq->split.avail_flags_shadow |=3D VRING_AVAIL_F_NO_INTERRUPT;
> > +		if (!vq->event)
> > +			vq->split.vring.avail->flags =3D cpu_to_virtio16(vdev,
> > +					vq->split.avail_flags_shadow);
> > +	}
> > +
> > +	/* Put everything in free lists. */
> > +	vq->free_head =3D 0;
>
>
> It's not clear what kind of initialization that we want to do here. E.g
> it mixes split specific setups with some general setups which is kind of
> duplication of vring_virtqueue_init_packed().
>
> I wonder if it's better to only do split specific setups here and have a
> common helper to do the setup that is irrelevant to ring layout.

Yes, you are right, I didn't notice this situation before.

Thanks.

>
> Thanks
>
>
> > +}
> > +
> >   static void vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> >   					 struct vring vring,
> >   					 struct vring_desc_state_split *desc_state,
> > @@ -2249,42 +2286,15 @@ struct virtqueue *__vring_new_virtqueue(unsigne=
d int index,
> >   	if (!vq)
> >   		return NULL;
> >
> > -	vq->packed_ring =3D false;
> >   	vq->vq.callback =3D callback;
> >   	vq->vq.vdev =3D vdev;
> >   	vq->vq.name =3D name;
> > -	vq->vq.num_free =3D vring.num;
> >   	vq->vq.index =3D index;
> > -	vq->we_own_ring =3D false;
> >   	vq->notify =3D notify;
> >   	vq->weak_barriers =3D weak_barriers;
> > -	vq->broken =3D false;
> > -	vq->last_used_idx =3D 0;
> > -	vq->event_triggered =3D false;
> > -	vq->num_added =3D 0;
> > -	vq->use_dma_api =3D vring_use_dma_api(vdev);
> > -#ifdef DEBUG
> > -	vq->in_use =3D false;
> > -	vq->last_add_time_valid =3D false;
> > -#endif
> >
> >   	vq->indirect =3D virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DES=
C) &&
> >   		!context;
> > -	vq->event =3D virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> > -
> > -	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> > -		vq->weak_barriers =3D false;
> > -
> > -	vq->split.avail_flags_shadow =3D 0;
> > -	vq->split.avail_idx_shadow =3D 0;
> > -
> > -	/* No callback?  Tell other side not to bother us. */
> > -	if (!callback) {
> > -		vq->split.avail_flags_shadow |=3D VRING_AVAIL_F_NO_INTERRUPT;
> > -		if (!vq->event)
> > -			vq->split.vring.avail->flags =3D cpu_to_virtio16(vdev,
> > -					vq->split.avail_flags_shadow);
> > -	}
> >
> >   	err =3D vring_alloc_state_extra_split(vring.num, &state, &extra);
> >   	if (err) {
> > @@ -2293,9 +2303,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned =
int index,
> >   	}
> >
> >   	vring_virtqueue_attach_split(vq, vring, state, extra);
> > -
> > -	/* Put everything in free lists. */
> > -	vq->free_head =3D 0;
> > +	vring_virtqueue_init_split(vq, vdev, false);
> >
> >   	spin_lock(&vdev->vqs_list_lock);
> >   	list_add_tail(&vq->vq.list, &vdev->vqs);
>
