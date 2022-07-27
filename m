Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D711582164
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 09:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiG0HoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 03:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiG0HoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 03:44:09 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0E73FA0F;
        Wed, 27 Jul 2022 00:44:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VKZx5Pm_1658907838;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VKZx5Pm_1658907838)
          by smtp.aliyun-inc.com;
          Wed, 27 Jul 2022 15:43:59 +0800
Message-ID: <1658907413.1860468-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v13 16/42] virtio_ring: split: introduce virtqueue_resize_split()
Date:   Wed, 27 Jul 2022 15:36:53 +0800
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
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-17-xuanzhuo@linux.alibaba.com>
 <15aa26f2-f8af-5dbd-f2b2-9270ad873412@redhat.com>
In-Reply-To: <15aa26f2-f8af-5dbd-f2b2-9270ad873412@redhat.com>
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

On Wed, 27 Jul 2022 11:12:19 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/7/26 15:21, Xuan Zhuo =E5=86=99=E9=81=93:
> > virtio ring split supports resize.
> >
> > Only after the new vring is successfully allocated based on the new num,
> > we will release the old vring. In any case, an error is returned,
> > indicating that the vring still points to the old vring.
> >
> > In the case of an error, re-initialize(virtqueue_reinit_split()) the
> > virtqueue to ensure that the vring can be used.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 34 ++++++++++++++++++++++++++++++++++
> >   1 file changed, 34 insertions(+)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index b6fda91c8059..58355e1ac7d7 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -220,6 +220,7 @@ static struct virtqueue *__vring_new_virtqueue(unsi=
gned int index,
> >   					       void (*callback)(struct virtqueue *),
> >   					       const char *name);
> >   static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int n=
um);
> > +static void vring_free(struct virtqueue *_vq);
> >
> >   /*
> >    * Helpers.
> > @@ -1117,6 +1118,39 @@ static struct virtqueue *vring_create_virtqueue_=
split(
> >   	return vq;
> >   }
> >
> > +static int virtqueue_resize_split(struct virtqueue *_vq, u32 num)
> > +{
> > +	struct vring_virtqueue_split vring_split =3D {};
> > +	struct vring_virtqueue *vq =3D to_vvq(_vq);
> > +	struct virtio_device *vdev =3D _vq->vdev;
> > +	int err;
> > +
> > +	err =3D vring_alloc_queue_split(&vring_split, vdev, num,
> > +				      vq->split.vring_align,
> > +				      vq->split.may_reduce_num);
> > +	if (err)
> > +		goto err;
>
>
> I think we don't need to do anything here?

Am I missing something?

>
>
> > +
> > +	err =3D vring_alloc_state_extra_split(&vring_split);
> > +	if (err) {
> > +		vring_free_split(&vring_split, vdev);
> > +		goto err;
>
>
> I suggest to move vring_free_split() into a dedicated error label.

Will change.

Thanks.


>
> Thanks
>
>
> > +	}
> > +
> > +	vring_free(&vq->vq);
> > +
> > +	virtqueue_vring_init_split(&vring_split, vq);
> > +
> > +	virtqueue_init(vq, vring_split.vring.num);
> > +	virtqueue_vring_attach_split(vq, &vring_split);
> > +
> > +	return 0;
> > +
> > +err:
> > +	virtqueue_reinit_split(vq);
> > +	return -ENOMEM;
> > +}
> > +
> >
> >   /*
> >    * Packed ring specific functions - *_packed().
>
