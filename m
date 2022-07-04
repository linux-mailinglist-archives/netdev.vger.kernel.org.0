Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FC3564BA0
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 04:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiGDCUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 22:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGDCUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 22:20:52 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CF86401;
        Sun,  3 Jul 2022 19:20:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VIEJAfc_1656901242;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VIEJAfc_1656901242)
          by smtp.aliyun-inc.com;
          Mon, 04 Jul 2022 10:20:43 +0800
Message-ID: <1656900812.860175-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v11 21/40] virtio_ring: packed: introduce virtqueue_resize_packed()
Date:   Mon, 4 Jul 2022 10:13:32 +0800
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
 <20220629065656.54420-22-xuanzhuo@linux.alibaba.com>
 <de7cf56d-acbd-1a2b-2226-a9fdd89afb78@redhat.com>
In-Reply-To: <de7cf56d-acbd-1a2b-2226-a9fdd89afb78@redhat.com>
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

On Fri, 1 Jul 2022 17:27:48 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
> > virtio ring packed supports resize.
> >
> > Only after the new vring is successfully allocated based on the new num,
> > we will release the old vring. In any case, an error is returned,
> > indicating that the vring still points to the old vring.
> >
> > In the case of an error, re-initialize(by virtqueue_reinit_packed()) the
> > virtqueue to ensure that the vring can be used.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
> >   1 file changed, 29 insertions(+)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 650f701a5480..4860787286db 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2042,6 +2042,35 @@ static struct virtqueue *vring_create_virtqueue_=
packed(
> >   	return NULL;
> >   }
> >
> > +static int virtqueue_resize_packed(struct virtqueue *_vq, u32 num)
> > +{
> > +	struct vring_virtqueue_packed vring =3D {};
> > +	struct vring_virtqueue *vq =3D to_vvq(_vq);
> > +	struct virtio_device *vdev =3D _vq->vdev;
> > +	int err;
> > +
> > +	if (vring_alloc_queue_packed(&vring, vdev, num))
> > +		goto err_ring;
> > +
> > +	err =3D vring_alloc_state_extra_packed(&vring);
> > +	if (err)
> > +		goto err_state_extra;
> > +
> > +	vring_free(&vq->vq);
> > +
> > +	virtqueue_init(vq, vring.vring.num);
> > +	virtqueue_vring_attach_packed(vq, &vring);
> > +	virtqueue_vring_init_packed(vq);
> > +
> > +	return 0;
> > +
> > +err_state_extra:
> > +	vring_free_packed(&vring, vdev);
> > +err_ring:
> > +	virtqueue_reinit_packed(vq);
>
>
> So desc_state and desc_extra has been freed vring_free_packed() when
> vring_alloc_state_extra_packed() fails. We might get use-after-free here?

vring_free_packed() frees the temporary structure vring. It does not affect
desc_state and desc_extra of vq. So it is safe.

>
> Actually, I think for resize we need
>
> 1) detach old
> 2) allocate new
> 3) if 2) succeed, attach new otherwise attach old


The implementation is now:

1. allocate new
2. free old (detach old)
3. attach new

error:
1. free temporary
2. reinit old

Do you think this is ok? We need to add a new variable to save the old vrin=
g in
the process you mentioned, there is not much difference in other.

Thanks.


>
> This seems more clearer than the current logic?
>
> Thanks
>
>
> > +	return -ENOMEM;
> > +}
> > +
> >
> >   /*
> >    * Generic functions and exported symbols.
>
