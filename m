Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D1E4FECE9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiDMCcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiDMCcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:32:23 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CA027CD5;
        Tue, 12 Apr 2022 19:30:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V9xY7Pv_1649816994;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V9xY7Pv_1649816994)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Apr 2022 10:29:56 +0800
Message-ID: <1649816652.9004085-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 01/32] virtio: add helper virtqueue_get_vring_max_size()
Date:   Wed, 13 Apr 2022 10:24:12 +0800
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
 <20220406034346.74409-2-xuanzhuo@linux.alibaba.com>
 <71fbd7fc-20db-024b-ec66-b875216be4bd@redhat.com>
In-Reply-To: <71fbd7fc-20db-024b-ec66-b875216be4bd@redhat.com>
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

On Tue, 12 Apr 2022 10:41:03 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
> > Record the maximum queue num supported by the device.
> >
> > virtio-net can display the maximum (supported by hardware) ring size in
> > ethtool -g eth0.
> >
> > When the subsequent patch implements vring reset, it can judge whether
> > the ring size passed by the driver is legal based on this.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   arch/um/drivers/virtio_uml.c             |  1 +
> >   drivers/platform/mellanox/mlxbf-tmfifo.c |  2 ++
> >   drivers/remoteproc/remoteproc_virtio.c   |  2 ++
> >   drivers/s390/virtio/virtio_ccw.c         |  3 +++
> >   drivers/virtio/virtio_mmio.c             |  2 ++
> >   drivers/virtio/virtio_pci_legacy.c       |  2 ++
> >   drivers/virtio/virtio_pci_modern.c       |  2 ++
> >   drivers/virtio/virtio_ring.c             | 14 ++++++++++++++
> >   drivers/virtio/virtio_vdpa.c             |  2 ++
> >   include/linux/virtio.h                   |  2 ++
> >   10 files changed, 32 insertions(+)
> >
> > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> > index ba562d68dc04..904993d15a85 100644
> > --- a/arch/um/drivers/virtio_uml.c
> > +++ b/arch/um/drivers/virtio_uml.c
> > @@ -945,6 +945,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_=
device *vdev,
> >   		goto error_create;
> >   	}
> >   	vq->priv =3D info;
> > +	vq->num_max =3D num;
> >   	num =3D virtqueue_get_vring_size(vq);
> >
> >   	if (vu_dev->protocol_features &
> > diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platfor=
m/mellanox/mlxbf-tmfifo.c
> > index 38800e86ed8a..1ae3c56b66b0 100644
> > --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > @@ -959,6 +959,8 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virt=
io_device *vdev,
> >   			goto error;
> >   		}
> >
> > +		vq->num_max =3D vring->num;
> > +
> >   		vqs[i] =3D vq;
> >   		vring->vq =3D vq;
> >   		vq->priv =3D vring;
> > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remotepro=
c/remoteproc_virtio.c
> > index 70ab496d0431..7611755d0ae2 100644
> > --- a/drivers/remoteproc/remoteproc_virtio.c
> > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > @@ -125,6 +125,8 @@ static struct virtqueue *rp_find_vq(struct virtio_d=
evice *vdev,
> >   		return ERR_PTR(-ENOMEM);
> >   	}
> >
> > +	vq->num_max =3D len;
>
>
> I wonder if this is correct.
>
> It looks to me len is counted in bytes:
>
> /**
>  =C2=A0* struct rproc_vring - remoteproc vring state
>  =C2=A0* @va: virtual address
>  =C2=A0* @len: length, in bytes
>  =C2=A0* @da: device address
>  =C2=A0* @align: vring alignment
>  =C2=A0* @notifyid: rproc-specific unique vring index
>  =C2=A0* @rvdev: remote vdev
>  =C2=A0* @vq: the virtqueue of this vring
>  =C2=A0*/
> struct rproc_vring {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *va;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int len;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 da;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 align;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int notifyid;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct rproc_vdev *rvdev;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct virtqueue *vq;
> };
>

I think this comment is incorrect because here len is passed as num to
vring_new_virtqueue().

There is also this usage:

	/* actual size of vring (in bytes) */
	size =3D PAGE_ALIGN(vring_size(rvring->len, rvring->align));


And this value comes from here:

	static int
	rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
	{
		struct rproc *rproc =3D rvdev->rproc;
		struct device *dev =3D &rproc->dev;
		struct fw_rsc_vdev_vring *vring =3D &rsc->vring[i];
		struct rproc_vring *rvring =3D &rvdev->vring[i];

		dev_dbg(dev, "vdev rsc: vring%d: da 0x%x, qsz %d, align %d\n",
			i, vring->da, vring->num, vring->align);

		/* verify queue size and vring alignment are sane */
		if (!vring->num || !vring->align) {
			dev_err(dev, "invalid qsz (%d) or alignment (%d)\n",
				vring->num, vring->align);
			return -EINVAL;
		}

       >	rvring->len =3D vring->num;
		rvring->align =3D vring->align;
		rvring->rvdev =3D rvdev;

		return 0;
	}

/**
 * struct fw_rsc_vdev_vring - vring descriptor entry
 * @da: device address
 * @align: the alignment between the consumer and producer parts of the vri=
ng
 * @num: num of buffers supported by this vring (must be power of two)
 * @notifyid: a unique rproc-wide notify index for this vring. This notify
 * index is used when kicking a remote processor, to let it know that this
 * vring is triggered.
 * @pa: physical address
 *
 * This descriptor is not a resource entry by itself; it is part of the
 * vdev resource type (see below).
 *
 * Note that @da should either contain the device address where
 * the remote processor is expecting the vring, or indicate that
 * dynamically allocation of the vring's device address is supported.
 */
struct fw_rsc_vdev_vring {
	u32 da;
	u32 align;
	u32 num;
	u32 notifyid;
	u32 pa;
} __packed;

So I think the 'len' here may have changed its meaning in a version update.

Thanks.

>
> Other looks good.
>
> Thanks
>
>
> > +
> >   	rvring->vq =3D vq;
> >   	vq->priv =3D rvring;
> >
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vir=
tio_ccw.c
> > index d35e7a3f7067..468da60b56c5 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -529,6 +529,9 @@ static struct virtqueue *virtio_ccw_setup_vq(struct=
 virtio_device *vdev,
> >   		err =3D -ENOMEM;
> >   		goto out_err;
> >   	}
> > +
> > +	vq->num_max =3D info->num;
> > +
> >   	/* it may have been reduced */
> >   	info->num =3D virtqueue_get_vring_size(vq);
> >
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index 56128b9c46eb..a41abc8051b9 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -390,6 +390,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_=
device *vdev, unsigned index,
> >   		goto error_new_virtqueue;
> >   	}
> >
> > +	vq->num_max =3D num;
> > +
> >   	/* Activate the queue */
> >   	writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_QUEU=
E_NUM);
> >   	if (vm_dev->version =3D=3D 1) {
> > diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio=
_pci_legacy.c
> > index 34141b9abe27..b68934fe6b5d 100644
> > --- a/drivers/virtio/virtio_pci_legacy.c
> > +++ b/drivers/virtio/virtio_pci_legacy.c
> > @@ -135,6 +135,8 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
> >   	if (!vq)
> >   		return ERR_PTR(-ENOMEM);
> >
> > +	vq->num_max =3D num;
> > +
> >   	q_pfn =3D virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
> >   	if (q_pfn >> 32) {
> >   		dev_err(&vp_dev->pci_dev->dev,
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio=
_pci_modern.c
> > index 5455bc041fb6..86d301f272b8 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -218,6 +218,8 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
> >   	if (!vq)
> >   		return ERR_PTR(-ENOMEM);
> >
> > +	vq->num_max =3D num;
> > +
> >   	/* activate the queue */
> >   	vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq));
> >   	vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > index 962f1477b1fa..b87130c8f312 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2371,6 +2371,20 @@ void vring_transport_features(struct virtio_devi=
ce *vdev)
> >   }
> >   EXPORT_SYMBOL_GPL(vring_transport_features);
> >
> > +/**
> > + * virtqueue_get_vring_max_size - return the max size of the virtqueue=
's vring
> > + * @_vq: the struct virtqueue containing the vring of interest.
> > + *
> > + * Returns the max size of the vring.
> > + *
> > + * Unlike other operations, this need not be serialized.
> > + */
> > +unsigned int virtqueue_get_vring_max_size(struct virtqueue *_vq)
> > +{
> > +	return _vq->num_max;
> > +}
> > +EXPORT_SYMBOL_GPL(virtqueue_get_vring_max_size);
> > +
> >   /**
> >    * virtqueue_get_vring_size - return the size of the virtqueue's vring
> >    * @_vq: the struct virtqueue containing the vring of interest.
> > diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> > index 7767a7f0119b..39e4c08eb0f2 100644
> > --- a/drivers/virtio/virtio_vdpa.c
> > +++ b/drivers/virtio/virtio_vdpa.c
> > @@ -183,6 +183,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, un=
signed int index,
> >   		goto error_new_virtqueue;
> >   	}
> >
> > +	vq->num_max =3D max_num;
> > +
> >   	/* Setup virtqueue callback */
> >   	cb.callback =3D virtio_vdpa_virtqueue_cb;
> >   	cb.private =3D info;
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index 72292a62cd90..d59adc4be068 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -31,6 +31,7 @@ struct virtqueue {
> >   	struct virtio_device *vdev;
> >   	unsigned int index;
> >   	unsigned int num_free;
> > +	unsigned int num_max;
> >   	void *priv;
> >   };
> >
> > @@ -80,6 +81,7 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *vq=
);
> >
> >   void *virtqueue_detach_unused_buf(struct virtqueue *vq);
> >
> > +unsigned int virtqueue_get_vring_max_size(struct virtqueue *vq);
> >   unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
> >
> >   bool virtqueue_is_broken(struct virtqueue *vq);
>
