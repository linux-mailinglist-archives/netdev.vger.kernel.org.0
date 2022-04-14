Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9879E500612
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 08:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237867AbiDNG1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 02:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiDNG1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 02:27:24 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97631FA6F;
        Wed, 13 Apr 2022 23:24:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0VA0zc-G_1649917489;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VA0zc-G_1649917489)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Apr 2022 14:24:51 +0800
Message-ID: <1649917349.6242197-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 22/32] virtio_pci: queue_reset: extract the logic of active vq for modern pci
Date:   Thu, 14 Apr 2022 14:22:29 +0800
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
 <20220406034346.74409-23-xuanzhuo@linux.alibaba.com>
 <d228a41f-a3a1-029d-f259-d4fbab822e78@redhat.com>
In-Reply-To: <d228a41f-a3a1-029d-f259-d4fbab822e78@redhat.com>
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

On Tue, 12 Apr 2022 14:58:19 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=93:
> > Introduce vp_active_vq() to configure vring to backend after vq attach
> > vring. And configure vq vector if necessary.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/virtio/virtio_pci_modern.c | 46 ++++++++++++++++++------------
> >   1 file changed, 28 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio=
_pci_modern.c
> > index 86d301f272b8..49a4493732cf 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -176,6 +176,29 @@ static void vp_reset(struct virtio_device *vdev)
> >   	vp_disable_cbs(vdev);
> >   }
> >
> > +static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
> > +{
> > +	struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > +	struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > +	unsigned long index;
> > +
> > +	index =3D vq->index;
> > +
> > +	/* activate the queue */
> > +	vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq));
> > +	vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> > +				virtqueue_get_avail_addr(vq),
> > +				virtqueue_get_used_addr(vq));
> > +
> > +	if (msix_vec !=3D VIRTIO_MSI_NO_VECTOR) {
> > +		msix_vec =3D vp_modern_queue_vector(mdev, index, msix_vec);
> > +		if (msix_vec =3D=3D VIRTIO_MSI_NO_VECTOR)
> > +			return -EBUSY;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >   static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vec=
tor)
> >   {
> >   	return vp_modern_config_vector(&vp_dev->mdev, vector);
> > @@ -220,32 +243,19 @@ static struct virtqueue *setup_vq(struct virtio_p=
ci_device *vp_dev,
> >
> >   	vq->num_max =3D num;
> >
> > -	/* activate the queue */
> > -	vp_modern_set_queue_size(mdev, index, virtqueue_get_vring_size(vq));
> > -	vp_modern_queue_address(mdev, index, virtqueue_get_desc_addr(vq),
> > -				virtqueue_get_avail_addr(vq),
> > -				virtqueue_get_used_addr(vq));
> > +	err =3D vp_active_vq(vq, msix_vec);
> > +	if (err)
> > +		goto err;
> >
> >   	vq->priv =3D (void __force *)vp_modern_map_vq_notify(mdev, index, NU=
LL);
> >   	if (!vq->priv) {
> >   		err =3D -ENOMEM;
> > -		goto err_map_notify;
> > -	}
> > -
> > -	if (msix_vec !=3D VIRTIO_MSI_NO_VECTOR) {
> > -		msix_vec =3D vp_modern_queue_vector(mdev, index, msix_vec);
> > -		if (msix_vec =3D=3D VIRTIO_MSI_NO_VECTOR) {
> > -			err =3D -EBUSY;
> > -			goto err_assign_vector;
> > -		}
> > +		goto err;
> >   	}
> >
> >   	return vq;
> >
> > -err_assign_vector:
> > -	if (!mdev->notify_base)
> > -		pci_iounmap(mdev->pci_dev, (void __iomem __force *)vq->priv);
>
>
> We need keep this or anything I missed?

I think so, after modification, vp_modern_map_vq_notify is the last step be=
fore
returning vq. If it fails, then vq->priv is equal to NULL, so there is no n=
eed
to execute pci_iounmap.

Did I miss something?

Thanks.

>
> Thanks
>
>
> > -err_map_notify:
> > +err:
> >   	vring_del_virtqueue(vq);
> >   	return ERR_PTR(err);
> >   }
>
