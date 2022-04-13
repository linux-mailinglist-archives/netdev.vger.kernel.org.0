Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F2E4FF019
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiDMGuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiDMGt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:49:59 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139782C676;
        Tue, 12 Apr 2022 23:47:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V9yF0Rm_1649832451;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9yF0Rm_1649832451)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 14:47:32 +0800
Message-ID: <1649832244.772237-6-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 08/32] virtio_ring: split: extract the logic of attach vring
Date:   Wed, 13 Apr 2022 14:44:04 +0800
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
 <20220406034346.74409-9-xuanzhuo@linux.alibaba.com>
 <28237db0-cf04-aa36-b7b8-de55b11d18db@redhat.com>
In-Reply-To: <28237db0-cf04-aa36-b7b8-de55b11d18db@redhat.com>
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

On Tue, 12 Apr 2022 11:31:08 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
> > Separate the logic of attach vring, subsequent patches will call it
> > separately.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 20 ++++++++++++++------
> >   1 file changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 6de67439cb57..083f2992ba0d 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -916,6 +916,19 @@ static void *virtqueue_detach_unused_buf_split(str=
uct virtqueue *_vq)
> >   	return NULL;
> >   }
> >
> > +static void vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> > +					 struct vring vring,
> > +					 struct vring_desc_state_split *desc_state,
> > +					 struct vring_desc_extra *desc_extra)
> > +{
> > +	vq->split.vring =3D vring;
> > +	vq->split.queue_dma_addr =3D 0;
> > +	vq->split.queue_size_in_bytes =3D 0;
>
>
> Any reason to add the above two assignment in attach? It seems belong to
> free or reset.

As discussed in patch 11, since there is no dma_addr in __vring_new_virtque=
ue(),
the corresponding vq->split.queue_dma_addr cannot be set, so the purpose he=
re
is just to initialize it.

In the next version, struct vring_virtqueue_split will be passed to
vring_virtqueue_attach_split() to make the logic here look more reasonable.

Thanks.


>
> Thanks
>
>
> > +
> > +	vq->split.desc_state =3D desc_state;
> > +	vq->split.desc_extra =3D desc_extra;
> > +}
> > +
> >   static int vring_alloc_state_extra_split(u32 num,
> >   					 struct vring_desc_state_split **desc_state,
> >   					 struct vring_desc_extra **desc_extra)
> > @@ -2262,10 +2275,6 @@ struct virtqueue *__vring_new_virtqueue(unsigned=
 int index,
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
> > @@ -2283,8 +2292,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned =
int index,
> >   		return NULL;
> >   	}
> >
> > -	vq->split.desc_state =3D state;
> > -	vq->split.desc_extra =3D extra;
> > +	vring_virtqueue_attach_split(vq, vring, state, extra);
> >
> >   	/* Put everything in free lists. */
> >   	vq->free_head =3D 0;
>
