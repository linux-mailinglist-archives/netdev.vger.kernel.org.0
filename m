Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461B34FF031
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiDMGzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbiDMGzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:55:51 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF79627FE6;
        Tue, 12 Apr 2022 23:53:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V9yAtwn_1649832804;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9yAtwn_1649832804)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 14:53:25 +0800
Message-ID: <1649832776.947242-8-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 06/32] virtio_ring: split: extract the logic of alloc queue
Date:   Wed, 13 Apr 2022 14:52:56 +0800
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
 <20220406034346.74409-7-xuanzhuo@linux.alibaba.com>
 <b435b86d-26af-2e39-8859-6746830769d5@redhat.com>
In-Reply-To: <b435b86d-26af-2e39-8859-6746830769d5@redhat.com>
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

On Tue, 12 Apr 2022 11:22:33 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
> > Separate the logic of split to create vring queue.
> >
> > This feature is required for subsequent virtuqueue reset vring.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_ring.c | 53 ++++++++++++++++++++++++------------
> >   1 file changed, 36 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 33fddfb907a6..72d5ae063fa0 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -915,23 +915,15 @@ static void *virtqueue_detach_unused_buf_split(st=
ruct virtqueue *_vq)
> >   	return NULL;
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
> > +static void *vring_alloc_queue_split(struct virtio_device *vdev,
> > +				     dma_addr_t *dma_addr,
> > +				     u32 *n,
> > +				     unsigned int vring_align,
> > +				     bool weak_barriers,
>
>
> This is not used in this function.

The next version will fix it.

Thanks.


>
> Thanks
>
>
> > +				     bool may_reduce_num)
> >   {
> > -	struct virtqueue *vq;
> >   	void *queue =3D NULL;
> > -	dma_addr_t dma_addr;
> > -	size_t queue_size_in_bytes;
> > -	struct vring vring;
> > +	u32 num =3D *n;
> >
> >   	/* We assume num is a power of 2. */
> >   	if (num & (num - 1)) {
> > @@ -942,7 +934,7 @@ static struct virtqueue *vring_create_virtqueue_spl=
it(
> >   	/* TODO: allocate each queue chunk individually */
> >   	for (; num && vring_size(num, vring_align) > PAGE_SIZE; num /=3D 2) {
> >   		queue =3D vring_alloc_queue(vdev, vring_size(num, vring_align),
> > -					  &dma_addr,
> > +					  dma_addr,
> >   					  GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
> >   		if (queue)
> >   			break;
> > @@ -956,11 +948,38 @@ static struct virtqueue *vring_create_virtqueue_s=
plit(
> >   	if (!queue) {
> >   		/* Try to get a single page. You are my only hope! */
> >   		queue =3D vring_alloc_queue(vdev, vring_size(num, vring_align),
> > -					  &dma_addr, GFP_KERNEL|__GFP_ZERO);
> > +					  dma_addr, GFP_KERNEL|__GFP_ZERO);
> >   	}
> >   	if (!queue)
> >   		return NULL;
> >
> > +	*n =3D num;
> > +	return queue;
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
> > +	size_t queue_size_in_bytes;
> > +	struct virtqueue *vq;
> > +	dma_addr_t dma_addr;
> > +	struct vring vring;
> > +	void *queue;
> > +
> > +	queue =3D vring_alloc_queue_split(vdev, &dma_addr, &num, vring_align,
> > +					weak_barriers, may_reduce_num);
> > +	if (!queue)
> > +		return NULL;
> > +
> >   	queue_size_in_bytes =3D vring_size(num, vring_align);
> >   	vring_init(&vring, num, queue, vring_align);
> >
>
