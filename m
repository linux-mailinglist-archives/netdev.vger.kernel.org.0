Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238D04D1184
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbiCHIGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiCHIGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:06:22 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95CF3E5E4;
        Tue,  8 Mar 2022 00:05:24 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6dDcfX_1646726717;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6dDcfX_1646726717)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 16:05:18 +0800
Message-ID: <1646726461.091596-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v6 06/26] virtio_ring: packed: extrace the logic of creating vring
Date:   Tue, 8 Mar 2022 16:01:01 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
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
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20220224081102.80224-1-xuanzhuo@linux.alibaba.com>
 <20220224081102.80224-7-xuanzhuo@linux.alibaba.com>
 <20220307171629-mutt-send-email-mst@kernel.org>
 <1646722885.3801584-1-xuanzhuo@linux.alibaba.com>
 <91910574-d3f7-6a75-57cf-06a5fcb29be8@redhat.com>
In-Reply-To: <91910574-d3f7-6a75-57cf-06a5fcb29be8@redhat.com>
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

On Tue, 8 Mar 2022 15:28:22 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=883:01, Xuan Zhuo =E5=86=99=E9=81=93:
> > On Mon, 7 Mar 2022 17:17:51 -0500, "Michael S. Tsirkin" <mst@redhat.com=
> wrote:
> >> On Thu, Feb 24, 2022 at 04:10:42PM +0800, Xuan Zhuo wrote:
> >>> Separate the logic of packed to create vring queue.
> >>>
> >>> For the convenience of passing parameters, add a structure
> >>> vring_packed.
> >>>
> >>> This feature is required for subsequent virtuqueue reset vring.
> >>>
> >>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >> Subject has a typo.
> > I will fix it.
> >
> >> Besides:
> >>
> >>> ---
> >>>   drivers/virtio/virtio_ring.c | 121 ++++++++++++++++++++++++++------=
---
> >>>   1 file changed, 92 insertions(+), 29 deletions(-)
> >>>
> >>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_rin=
g.c
> >>> index dc6313b79305..41864c5e665f 100644
> >>> --- a/drivers/virtio/virtio_ring.c
> >>> +++ b/drivers/virtio/virtio_ring.c
> >>> @@ -92,6 +92,18 @@ struct vring_split {
> >>>   	struct vring vring;
> >>>   };
> >>>
> >>> +struct vring_packed {
> >>> +	u32 num;
> >>> +	struct vring_packed_desc *ring;
> >>> +	struct vring_packed_desc_event *driver;
> >>> +	struct vring_packed_desc_event *device;
> >>> +	dma_addr_t ring_dma_addr;
> >>> +	dma_addr_t driver_event_dma_addr;
> >>> +	dma_addr_t device_event_dma_addr;
> >>> +	size_t ring_size_in_bytes;
> >>> +	size_t event_size_in_bytes;
> >>> +};
> >>> +
> >>>   struct vring_virtqueue {
> >>>   	struct virtqueue vq;
> >>>
> >>> @@ -1683,45 +1695,101 @@ static struct vring_desc_extra *vring_alloc_=
desc_extra(struct vring_virtqueue *v
> >>>   	return desc_extra;
> >>>   }
> >>>
> >>> -static struct virtqueue *vring_create_virtqueue_packed(
> >>> -	unsigned int index,
> >>> -	unsigned int num,
> >>> -	unsigned int vring_align,
> >>> -	struct virtio_device *vdev,
> >>> -	bool weak_barriers,
> >>> -	bool may_reduce_num,
> >>> -	bool context,
> >>> -	bool (*notify)(struct virtqueue *),
> >>> -	void (*callback)(struct virtqueue *),
> >>> -	const char *name)
> >>> +static void vring_free_vring_packed(struct vring_packed *vring,
> >>> +				    struct virtio_device *vdev)
> >>> +{
> >>> +	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_a=
ddr;
> >>> +	struct vring_packed_desc_event *driver, *device;
> >>> +	size_t ring_size_in_bytes, event_size_in_bytes;
> >>> +	struct vring_packed_desc *ring;
> >>> +
> >>> +	ring                  =3D vring->ring;
> >>> +	driver                =3D vring->driver;
> >>> +	device                =3D vring->device;
> >>> +	ring_dma_addr         =3D vring->ring_size_in_bytes;
> >>> +	event_size_in_bytes   =3D vring->event_size_in_bytes;
> >>> +	ring_dma_addr         =3D vring->ring_dma_addr;
> >>> +	driver_event_dma_addr =3D vring->driver_event_dma_addr;
> >>> +	device_event_dma_addr =3D vring->device_event_dma_addr;
> >>> +
> >>> +	if (device)
> >>> +		vring_free_queue(vdev, event_size_in_bytes, device, device_event_d=
ma_addr);
> >>> +
> >>> +	if (driver)
> >>> +		vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_d=
ma_addr);
> >>> +
> >>> +	if (ring)
> >>> +		vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
> >> ring_size_in_bytes is uninitialized here.
> >>
> >> Which begs the question how was this tested patchset generally and
> >> this patch in particular.
> >> Please add note on tested configurations and tests run to the patchset.
> > Sorry, my environment is running in split mode. I did not retest the pa=
cked mode
> > before sending patches. Because my dpdk vhost-user is not easy to use, I
> > need to change the kernel of the host.
> >
> > I would like to ask if there are other lightweight environments that ca=
n be used
> > to test packed mode.
>
>
> You can use Qemu's dataplane. It has support for packed virtqueue.


I thought about it, I feel that the current Qemu's virtio-net seems to have=
 no
problem if it adds a PACKED feature, so I tried it. I manually added the PA=
CKED
feature to Qemu's virtio-net. After I start the vm, run OK. PACKED also
negotiated successfully. After the test, it is also OK.

I think virtio-net in Qemu just does not open PACKED, but the implementatio=
n of
PACKED is in virtio core, so as long as virtio-net opens PACKED, it will be
fine. If there is any problem, I hope someone will approve it.

If my idea is correct, then virtio-net can add a parameter to open PACKED, =
which
will be very convenient when testing the packed mode of virtio.

Thanks.

>
> Thanks
>
>
> >
> >
> > Thanks.
> >
> >
> >>> +}
> >>> +
> >>> +static int vring_create_vring_packed(struct vring_packed *vring,
> >>> +				    struct virtio_device *vdev,
> >>> +				    u32 num)
> >>>   {
> >>> -	struct vring_virtqueue *vq;
> >>>   	struct vring_packed_desc *ring;
> >>>   	struct vring_packed_desc_event *driver, *device;
> >>>   	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_=
addr;
> >>>   	size_t ring_size_in_bytes, event_size_in_bytes;
> >>>
> >>> +	memset(vring, 0, sizeof(*vring));
> >>> +
> >>>   	ring_size_in_bytes =3D num * sizeof(struct vring_packed_desc);
> >>>
> >>>   	ring =3D vring_alloc_queue(vdev, ring_size_in_bytes,
> >>>   				 &ring_dma_addr,
> >>>   				 GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
> >>>   	if (!ring)
> >>> -		goto err_ring;
> >>> +		goto err;
> >>> +
> >>> +	vring->num =3D num;
> >>> +	vring->ring =3D ring;
> >>> +	vring->ring_size_in_bytes =3D ring_size_in_bytes;
> >>> +	vring->ring_dma_addr =3D ring_dma_addr;
> >>>
> >>>   	event_size_in_bytes =3D sizeof(struct vring_packed_desc_event);
> >>> +	vring->event_size_in_bytes =3D event_size_in_bytes;
> >>>
> >>>   	driver =3D vring_alloc_queue(vdev, event_size_in_bytes,
> >>>   				   &driver_event_dma_addr,
> >>>   				   GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
> >>>   	if (!driver)
> >>> -		goto err_driver;
> >>> +		goto err;
> >>> +
> >>> +	vring->driver =3D driver;
> >>> +	vring->driver_event_dma_addr =3D driver_event_dma_addr;
> >>>
> >>>   	device =3D vring_alloc_queue(vdev, event_size_in_bytes,
> >>>   				   &device_event_dma_addr,
> >>>   				   GFP_KERNEL|__GFP_NOWARN|__GFP_ZERO);
> >>>   	if (!device)
> >>> -		goto err_device;
> >>> +		goto err;
> >>> +
> >>> +	vring->device =3D device;
> >>> +	vring->device_event_dma_addr =3D device_event_dma_addr;
> >>> +	return 0;
> >>> +
> >>> +err:
> >>> +	vring_free_vring_packed(vring, vdev);
> >>> +	return -ENOMEM;
> >>> +}
> >>> +
> >>> +static struct virtqueue *vring_create_virtqueue_packed(
> >>> +	unsigned int index,
> >>> +	unsigned int num,
> >>> +	unsigned int vring_align,
> >>> +	struct virtio_device *vdev,
> >>> +	bool weak_barriers,
> >>> +	bool may_reduce_num,
> >>> +	bool context,
> >>> +	bool (*notify)(struct virtqueue *),
> >>> +	void (*callback)(struct virtqueue *),
> >>> +	const char *name)
> >>> +{
> >>> +	struct vring_virtqueue *vq;
> >>> +	struct vring_packed vring;
> >>> +
> >>> +	if (vring_create_vring_packed(&vring, vdev, num))
> >>> +		goto err_vq;
> >>>
> >>>   	vq =3D kmalloc(sizeof(*vq), GFP_KERNEL);
> >>>   	if (!vq)
> >>> @@ -1753,17 +1821,17 @@ static struct virtqueue *vring_create_virtque=
ue_packed(
> >>>   	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> >>>   		vq->weak_barriers =3D false;
> >>>
> >>> -	vq->packed.ring_dma_addr =3D ring_dma_addr;
> >>> -	vq->packed.driver_event_dma_addr =3D driver_event_dma_addr;
> >>> -	vq->packed.device_event_dma_addr =3D device_event_dma_addr;
> >>> +	vq->packed.ring_dma_addr =3D vring.ring_dma_addr;
> >>> +	vq->packed.driver_event_dma_addr =3D vring.driver_event_dma_addr;
> >>> +	vq->packed.device_event_dma_addr =3D vring.device_event_dma_addr;
> >>>
> >>> -	vq->packed.ring_size_in_bytes =3D ring_size_in_bytes;
> >>> -	vq->packed.event_size_in_bytes =3D event_size_in_bytes;
> >>> +	vq->packed.ring_size_in_bytes =3D vring.ring_size_in_bytes;
> >>> +	vq->packed.event_size_in_bytes =3D vring.event_size_in_bytes;
> >>>
> >>>   	vq->packed.vring.num =3D num;
> >>> -	vq->packed.vring.desc =3D ring;
> >>> -	vq->packed.vring.driver =3D driver;
> >>> -	vq->packed.vring.device =3D device;
> >>> +	vq->packed.vring.desc =3D vring.ring;
> >>> +	vq->packed.vring.driver =3D vring.driver;
> >>> +	vq->packed.vring.device =3D vring.device;
> >>>
> >>>   	vq->packed.next_avail_idx =3D 0;
> >>>   	vq->packed.avail_wrap_counter =3D 1;
> >>> @@ -1804,12 +1872,7 @@ static struct virtqueue *vring_create_virtqueu=
e_packed(
> >>>   err_desc_state:
> >>>   	kfree(vq);
> >>>   err_vq:
> >>> -	vring_free_queue(vdev, event_size_in_bytes, device, device_event_dm=
a_addr);
> >>> -err_device:
> >>> -	vring_free_queue(vdev, event_size_in_bytes, driver, driver_event_dm=
a_addr);
> >>> -err_driver:
> >>> -	vring_free_queue(vdev, ring_size_in_bytes, ring, ring_dma_addr);
> >>> -err_ring:
> >>> +	vring_free_vring_packed(&vring, vdev);
> >>>   	return NULL;
> >>>   }
> >>>
> >>> --
> >>> 2.31.0
>
