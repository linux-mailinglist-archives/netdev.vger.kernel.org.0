Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3166B4D2BCC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiCIJ0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiCIJ0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:26:22 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08B114E96B;
        Wed,  9 Mar 2022 01:25:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6jFhsP_1646817915;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6jFhsP_1646817915)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 17:25:16 +0800
Message-ID: <1646817847.746638-6-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 09/26] virtio_ring: split: implement virtqueue_reset_vring_split()
Date:   Wed, 9 Mar 2022 17:24:07 +0800
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
 <20220308123518.33800-10-xuanzhuo@linux.alibaba.com>
 <512de020-b36e-8473-69c8-8b3925fbb6c1@redhat.com>
In-Reply-To: <512de020-b36e-8473-69c8-8b3925fbb6c1@redhat.com>
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

On Wed, 9 Mar 2022 15:55:44 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:35, Xuan Zhuo =E5=86=99=E9=81=93:
> > virtio ring supports reset.
> >
> > Queue reset is divided into several stages.
> >
> > 1. notify device queue reset
> > 2. vring release
> > 3. attach new vring
> > 4. notify device queue re-enable
> >
> > After the first step is completed, the vring reset operation can be
> > performed. If the newly set vring num does not change, then just reset
> > the vq related value.
> >
> > Otherwise, the vring will be released and the vring will be reallocated.
> > And the vring will be attached to the vq. If this process fails, the
> > function will exit, and the state of the vq will be the vring release
> > state. You can call this function again to reallocate the vring.
> >
> > In addition, vring_align, may_reduce_num are necessary for reallocating
> > vring, so they are retained when creating vq.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 69 ++++++++++++++++++++++++++++++++++++
> >   1 file changed, 69 insertions(+)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index e0422c04c903..148fb1fd3d5a 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -158,6 +158,12 @@ struct vring_virtqueue {
> >   			/* DMA address and size information */
> >   			dma_addr_t queue_dma_addr;
> >   			size_t queue_size_in_bytes;
> > +
> > +			/* The parameters for creating vrings are reserved for
> > +			 * creating new vrings when enabling reset queue.
> > +			 */
> > +			u32 vring_align;
> > +			bool may_reduce_num;
> >   		} split;
> >
> >   		/* Available for packed ring */
> > @@ -217,6 +223,12 @@ struct vring_virtqueue {
> >   #endif
> >   };
> >
> > +static void vring_free(struct virtqueue *vq);
> > +static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
> > +					 struct virtio_device *vdev);
> > +static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> > +					  struct virtio_device *vdev,
> > +					  struct vring vring);
> >
> >   /*
> >    * Helpers.
> > @@ -1012,6 +1024,8 @@ static struct virtqueue *vring_create_virtqueue_s=
plit(
> >   		return NULL;
> >   	}
> >
> > +	to_vvq(vq)->split.vring_align =3D vring_align;
> > +	to_vvq(vq)->split.may_reduce_num =3D may_reduce_num;
> >   	to_vvq(vq)->split.queue_dma_addr =3D vring.dma_addr;
> >   	to_vvq(vq)->split.queue_size_in_bytes =3D vring.queue_size_in_bytes;
> >   	to_vvq(vq)->we_own_ring =3D true;
> > @@ -1019,6 +1033,59 @@ static struct virtqueue *vring_create_virtqueue_=
split(
> >   	return vq;
> >   }
> >
> > +static int virtqueue_reset_vring_split(struct virtqueue *_vq, u32 num)
> > +{
>
>
> So what this function does is to resize the virtqueue actually, I
> suggest to rename it as virtqueue_resize_split().

OK.

>
>
> > +	struct vring_virtqueue *vq =3D to_vvq(_vq);
> > +	struct virtio_device *vdev =3D _vq->vdev;
> > +	struct vring_split vring;
> > +	int err;
> > +
> > +	if (num > _vq->num_max)
> > +		return -E2BIG;
> > +
> > +	switch (vq->vq.reset) {
> > +	case VIRTIO_VQ_RESET_STEP_NONE:
> > +		return -ENOENT;
> > +
> > +	case VIRTIO_VQ_RESET_STEP_VRING_ATTACH:
> > +	case VIRTIO_VQ_RESET_STEP_DEVICE:
> > +		if (vq->split.vring.num =3D=3D num || !num)
> > +			break;
> > +
> > +		vring_free(_vq);
> > +
> > +		fallthrough;
> > +
> > +	case VIRTIO_VQ_RESET_STEP_VRING_RELEASE:
> > +		if (!num)
> > +			num =3D vq->split.vring.num;
> > +
> > +		err =3D vring_create_vring_split(&vring, vdev,
> > +					       vq->split.vring_align,
> > +					       vq->weak_barriers,
> > +					       vq->split.may_reduce_num, num);
> > +		if (err)
> > +			return -ENOMEM;
>
>
> We'd better need a safe fallback here like:
>
> If we can't allocate new memory, we can keep using the current one.
> Otherwise an ethtool -G fail may make the device not usable.
>
> This could be done by not freeing the old vring and virtqueue states
> until new is allocated.

I've been thinking the same thing for the past two days.

>
>
> > +
> > +		err =3D __vring_virtqueue_attach_split(vq, vdev, vring.vring);
> > +		if (err) {
> > +			vring_free_queue(vdev, vring.queue_size_in_bytes,
> > +					 vring.queue,
> > +					 vring.dma_addr);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		vq->split.queue_dma_addr =3D vring.dma_addr;
> > +		vq->split.queue_size_in_bytes =3D vring.queue_size_in_bytes;
> > +	}
> > +
> > +	__vring_virtqueue_init_split(vq, vdev);
> > +	vq->we_own_ring =3D true;
>
>
> This seems wrong, we have the transport (rproc/mlxtbf) that allocate the
> vring by themselves. I think we need to fail the resize for we_own_ring
> =3D=3D false.

Oh, it turns out that we_own_ring is for this purpose.

Thanks.

>
> Thanks
>
>
>
> > +	vq->vq.reset =3D VIRTIO_VQ_RESET_STEP_VRING_ATTACH;
> > +
> > +	return 0;
> > +}
> > +
> >
> >   /*
> >    * Packed ring specific functions - *_packed().
> > @@ -2317,6 +2384,8 @@ static int __vring_virtqueue_attach_split(struct =
vring_virtqueue *vq,
> >   static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
> >   					 struct virtio_device *vdev)
> >   {
> > +	vq->vq.reset =3D VIRTIO_VQ_RESET_STEP_NONE;
> > +
> >   	vq->packed_ring =3D false;
> >   	vq->we_own_ring =3D false;
> >   	vq->broken =3D false;
>
