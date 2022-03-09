Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9424D2C22
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiCIJf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiCIJfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:35:52 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB99D80901;
        Wed,  9 Mar 2022 01:34:49 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6j5w1D_1646818482;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6j5w1D_1646818482)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 17:34:44 +0800
Message-ID: <1646818472.5069678-10-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 18/26] virtio: find_vqs() add arg sizes
Date:   Wed, 9 Mar 2022 17:34:32 +0800
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
 <20220308123518.33800-19-xuanzhuo@linux.alibaba.com>
 <0fb55c37-69a6-a700-504b-e8d78b86fed4@redhat.com>
In-Reply-To: <0fb55c37-69a6-a700-504b-e8d78b86fed4@redhat.com>
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

On Wed, 9 Mar 2022 16:59:32 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:35, Xuan Zhuo =E5=86=99=E9=81=93:
> > find_vqs() adds a new parameter sizes to specify the size of each vq
> > vring.
> >
> > 0 means use the maximum size supported by the backend.
> >
> > In the split scenario, the meaning of size is the largest size, because
> > it may be limited by memory, the virtio core will try a smaller size.
> > And the size is power of 2.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   arch/um/drivers/virtio_uml.c             |  2 +-
> >   drivers/platform/mellanox/mlxbf-tmfifo.c |  3 ++-
> >   drivers/remoteproc/remoteproc_virtio.c   |  2 +-
> >   drivers/s390/virtio/virtio_ccw.c         |  2 +-
> >   drivers/virtio/virtio_mmio.c             |  2 +-
> >   drivers/virtio/virtio_pci_common.c       |  2 +-
> >   drivers/virtio/virtio_pci_common.h       |  2 +-
> >   drivers/virtio/virtio_pci_modern.c       |  5 +++--
> >   drivers/virtio/virtio_vdpa.c             |  2 +-
> >   include/linux/virtio_config.h            | 11 +++++++----
> >   10 files changed, 19 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> > index ba562d68dc04..055b91ccbe8a 100644
> > --- a/arch/um/drivers/virtio_uml.c
> > +++ b/arch/um/drivers/virtio_uml.c
> > @@ -998,7 +998,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_=
device *vdev,
> >   static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> >   		       struct virtqueue *vqs[], vq_callback_t *callbacks[],
> >   		       const char * const names[], const bool *ctx,
> > -		       struct irq_affinity *desc)
> > +		       struct irq_affinity *desc, u32 sizes[])
> >   {
> >   	struct virtio_uml_device *vu_dev =3D to_virtio_uml_device(vdev);
> >   	int i, queue_idx =3D 0, rc;
> > diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platfor=
m/mellanox/mlxbf-tmfifo.c
> > index 38800e86ed8a..aea7aa218b22 100644
> > --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > @@ -929,7 +929,8 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virt=
io_device *vdev,
> >   					vq_callback_t *callbacks[],
> >   					const char * const names[],
>
>
> Nit: Let's be consistent here, e.g move sizes before ctx (this is what
> next patch did and seems cleaner).

OK.

Thanks.

>
> Thanks
>
>
> >   					const bool *ctx,
> > -					struct irq_affinity *desc)
> > +					struct irq_affinity *desc,
> > +					u32 sizes[])
> >   {
> >   	struct mlxbf_tmfifo_vdev *tm_vdev =3D mlxbf_vdev_to_tmfifo(vdev);
> >   	struct mlxbf_tmfifo_vring *vring;
> > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remotepro=
c/remoteproc_virtio.c
> > index 70ab496d0431..3a167bec5b09 100644
> > --- a/drivers/remoteproc/remoteproc_virtio.c
> > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > @@ -157,7 +157,7 @@ static int rproc_virtio_find_vqs(struct virtio_devi=
ce *vdev, unsigned int nvqs,
> >   				 vq_callback_t *callbacks[],
> >   				 const char * const names[],
> >   				 const bool * ctx,
> > -				 struct irq_affinity *desc)
> > +				 struct irq_affinity *desc, u32 sizes[])
> >   {
> >   	int i, ret, queue_idx =3D 0;
> >
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vir=
tio_ccw.c
> > index d35e7a3f7067..b74e08c71534 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -632,7 +632,7 @@ static int virtio_ccw_find_vqs(struct virtio_device=
 *vdev, unsigned nvqs,
> >   			       vq_callback_t *callbacks[],
> >   			       const char * const names[],
> >   			       const bool *ctx,
> > -			       struct irq_affinity *desc)
> > +			       struct irq_affinity *desc, u32 sizes[])
> >   {
> >   	struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> >   	unsigned long *indicatorp =3D NULL;
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index a41abc8051b9..55d575f6ef2d 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -462,7 +462,7 @@ static int vm_find_vqs(struct virtio_device *vdev, =
unsigned nvqs,
> >   		       vq_callback_t *callbacks[],
> >   		       const char * const names[],
> >   		       const bool *ctx,
> > -		       struct irq_affinity *desc)
> > +		       struct irq_affinity *desc, u32 sizes[])
> >   {
> >   	struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vdev);
> >   	int irq =3D platform_get_irq(vm_dev->pdev, 0);
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio=
_pci_common.c
> > index 863d3a8a0956..8e8fa7e5ad80 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -428,7 +428,7 @@ static int vp_find_vqs_intx(struct virtio_device *v=
dev, unsigned nvqs,
> >   int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> >   		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> >   		const char * const names[], const bool *ctx,
> > -		struct irq_affinity *desc)
> > +		struct irq_affinity *desc, u32 sizes[])
> >   {
> >   	int err;
> >
> > diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio=
_pci_common.h
> > index 23f6c5c678d5..9dbf1d555dff 100644
> > --- a/drivers/virtio/virtio_pci_common.h
> > +++ b/drivers/virtio/virtio_pci_common.h
> > @@ -114,7 +114,7 @@ void vp_del_vqs(struct virtio_device *vdev);
> >   int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> >   		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> >   		const char * const names[], const bool *ctx,
> > -		struct irq_affinity *desc);
> > +		struct irq_affinity *desc, u32 sizes[]);
> >   const char *vp_bus_name(struct virtio_device *vdev);
> >
> >   /* Setup the affinity for a virtqueue:
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio=
_pci_modern.c
> > index 3c67d3607802..342795175c29 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -343,11 +343,12 @@ static int vp_modern_find_vqs(struct virtio_devic=
e *vdev, unsigned nvqs,
> >   			      struct virtqueue *vqs[],
> >   			      vq_callback_t *callbacks[],
> >   			      const char * const names[], const bool *ctx,
> > -			      struct irq_affinity *desc)
> > +			      struct irq_affinity *desc, u32 sizes[])
> >   {
> >   	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> >   	struct virtqueue *vq;
> > -	int rc =3D vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc);
> > +	int rc =3D vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc,
> > +			     sizes);
> >
> >   	if (rc)
> >   		return rc;
> > diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> > index 7767a7f0119b..ee08d01ee8b1 100644
> > --- a/drivers/virtio/virtio_vdpa.c
> > +++ b/drivers/virtio/virtio_vdpa.c
> > @@ -268,7 +268,7 @@ static int virtio_vdpa_find_vqs(struct virtio_devic=
e *vdev, unsigned nvqs,
> >   				vq_callback_t *callbacks[],
> >   				const char * const names[],
> >   				const bool *ctx,
> > -				struct irq_affinity *desc)
> > +				struct irq_affinity *desc, u32 sizes[])
> >   {
> >   	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev);
> >   	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_confi=
g.h
> > index 0b81fbe17c85..5157524d8036 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -57,6 +57,7 @@ struct virtio_shm_region {
> >    *		include a NULL entry for vqs that do not need a callback
> >    *	names: array of virtqueue names (mainly for debugging)
> >    *		include a NULL entry for vqs unused by driver
> > + *	sizes: array of virtqueue sizes
> >    *	Returns 0 on success or error status
> >    * @del_vqs: free virtqueues found by find_vqs().
> >    * @get_features: get the array of feature bits for this device.
> > @@ -98,7 +99,8 @@ struct virtio_config_ops {
> >   	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
> >   			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> >   			const char * const names[], const bool *ctx,
> > -			struct irq_affinity *desc);
> > +			struct irq_affinity *desc,
> > +			u32 sizes[]);
> >   	void (*del_vqs)(struct virtio_device *);
> >   	u64 (*get_features)(struct virtio_device *vdev);
> >   	int (*finalize_features)(struct virtio_device *vdev);
> > @@ -205,7 +207,7 @@ struct virtqueue *virtio_find_single_vq(struct virt=
io_device *vdev,
> >   	const char *names[] =3D { n };
> >   	struct virtqueue *vq;
> >   	int err =3D vdev->config->find_vqs(vdev, 1, &vq, callbacks, names, N=
ULL,
> > -					 NULL);
> > +					 NULL, NULL);
> >   	if (err < 0)
> >   		return ERR_PTR(err);
> >   	return vq;
> > @@ -217,7 +219,8 @@ int virtio_find_vqs(struct virtio_device *vdev, uns=
igned nvqs,
> >   			const char * const names[],
> >   			struct irq_affinity *desc)
> >   {
> > -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL=
, desc);
> > +	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL,
> > +				      desc, NULL);
> >   }
> >
> >   static inline
> > @@ -227,7 +230,7 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev,=
 unsigned nvqs,
> >   			struct irq_affinity *desc)
> >   {
> >   	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
> > -				      desc);
> > +				      desc, NULL);
> >   }
> >
> >   /**
>
