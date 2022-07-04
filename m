Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9796D564BA9
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 04:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiGDCWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 22:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiGDCWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 22:22:46 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02CA64FE;
        Sun,  3 Jul 2022 19:22:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VIE1rLs_1656901358;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VIE1rLs_1656901358)
          by smtp.aliyun-inc.com;
          Mon, 04 Jul 2022 10:22:39 +0800
Message-ID: <1656901259.0328152-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v11 22/40] virtio_ring: introduce virtqueue_resize()
Date:   Mon, 4 Jul 2022 10:20:59 +0800
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
 <20220629065656.54420-23-xuanzhuo@linux.alibaba.com>
 <d3788739-1c7f-4f1e-a222-f83bd73c14a1@redhat.com>
In-Reply-To: <d3788739-1c7f-4f1e-a222-f83bd73c14a1@redhat.com>
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

On Fri, 1 Jul 2022 17:31:34 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
> > Introduce virtqueue_resize() to implement the resize of vring.
> > Based on these, the driver can dynamically adjust the size of the vring.
> > For example: ethtool -G.
> >
> > virtqueue_resize() implements resize based on the vq reset function. In
> > case of failure to allocate a new vring, it will give up resize and use
> > the original vring.
> >
> > During this process, if the re-enable reset vq fails, the vq can no
> > longer be used. Although the probability of this situation is not high.
> >
> > The parameter recycle is used to recycle the buffer that is no longer
> > used.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 72 ++++++++++++++++++++++++++++++++++++
> >   include/linux/virtio.h       |  3 ++
> >   2 files changed, 75 insertions(+)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 4860787286db..5ec43607cc15 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2542,6 +2542,78 @@ struct virtqueue *vring_create_virtqueue(
> >   }
> >   EXPORT_SYMBOL_GPL(vring_create_virtqueue);
> >
> > +/**
> > + * virtqueue_resize - resize the vring of vq
> > + * @_vq: the struct virtqueue we're talking about.
> > + * @num: new ring num
> > + * @recycle: callback for recycle the useless buffer
> > + *
> > + * When it is really necessary to create a new vring, it will set the =
current vq
> > + * into the reset state. Then call the passed callback to recycle the =
buffer
> > + * that is no longer used. Only after the new vring is successfully cr=
eated, the
> > + * old vring will be released.
> > + *
> > + * Caller must ensure we don't call this with other virtqueue operatio=
ns
> > + * at the same time (except where noted).
> > + *
> > + * Returns zero or a negative error.
> > + * 0: success.
> > + * -ENOMEM: Failed to allocate a new ring, fall back to the original r=
ing size.
> > + *  vq can still work normally
> > + * -EBUSY: Failed to sync with device, vq may not work properly
> > + * -ENOENT: Transport or device not supported
> > + * -E2BIG/-EINVAL: num error
> > + * -EPERM: Operation not permitted
> > + *
> > + */
> > +int virtqueue_resize(struct virtqueue *_vq, u32 num,
> > +		     void (*recycle)(struct virtqueue *vq, void *buf))
> > +{
> > +	struct vring_virtqueue *vq =3D to_vvq(_vq);
> > +	struct virtio_device *vdev =3D vq->vq.vdev;
> > +	bool packed;
> > +	void *buf;
> > +	int err;
> > +
> > +	if (!vq->we_own_ring)
> > +		return -EPERM;
> > +
> > +	if (num > vq->vq.num_max)
> > +		return -E2BIG;
> > +
> > +	if (!num)
> > +		return -EINVAL;
> > +
> > +	packed =3D virtio_has_feature(vdev, VIRTIO_F_RING_PACKED) ? true : fa=
lse;
>
>
> vq->packed_ring?

Will fix.

>
>
> > +
> > +	if ((packed ? vq->packed.vring.num : vq->split.vring.num) =3D=3D num)
> > +		return 0;
> > +
> > +	if (!vdev->config->reset_vq)
> > +		return -ENOENT;
> > +
> > +	if (!vdev->config->enable_reset_vq)
> > +		return -ENOENT;
>
>
> Not sure this is useful, e.g driver may choose to resize after a reset
> of the device?

There may be some misunderstandings, this is to check whether the transport=
 has
set the callback enable_reset_vq().

Thanks.


>
> Thanks
>
>
> > +
> > +	err =3D vdev->config->reset_vq(_vq);
> > +	if (err)
> > +		return err;
> > +
> > +	while ((buf =3D virtqueue_detach_unused_buf(_vq)) !=3D NULL)
> > +		recycle(_vq, buf);
> > +
> > +	if (packed)
> > +		err =3D virtqueue_resize_packed(_vq, num);
> > +	else
> > +		err =3D virtqueue_resize_split(_vq, num);
> > +
> > +	if (vdev->config->enable_reset_vq(_vq))
> > +		return -EBUSY;
> > +
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_resize);
> > +
> >   /* Only available for split ring */
> >   struct virtqueue *vring_new_virtqueue(unsigned int index,
> >   				      unsigned int num,
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index a82620032e43..1272566adec6 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -91,6 +91,9 @@ dma_addr_t virtqueue_get_desc_addr(struct virtqueue *=
vq);
> >   dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);
> >   dma_addr_t virtqueue_get_used_addr(struct virtqueue *vq);
> >
> > +int virtqueue_resize(struct virtqueue *vq, u32 num,
> > +		     void (*recycle)(struct virtqueue *vq, void *buf));
> > +
> >   /**
> >    * virtio_device - representation of a device using virtio
> >    * @index: unique position on the virtio bus
>
