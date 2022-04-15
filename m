Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00B15024FE
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 07:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350181AbiDOF4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 01:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347761AbiDOF4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 01:56:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F8DF4553E
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 22:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650002048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DUpQQRjllWeKgwaikEH9+Zg1RdjLEbvQ8m8vSLOXgo=;
        b=JYDcM6icb+UjJ5dzA+fDv0+QD3YMy5jtDDmnCS2Gp2U9uvKTrzZb368I+Q2VDzPPLslzSr
        FCtYFzFVMd5pWY5SDQw6Swds49XZni1lEPUVGYmLbp/bqT35bIya+oIGHF5VWAtI7HYjDv
        ClGj+45cXs0WpX6KlwsUSQ6pLSGpimM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-ZL0uP-DbMSONSpYkOt5mUQ-1; Fri, 15 Apr 2022 01:54:07 -0400
X-MC-Unique: ZL0uP-DbMSONSpYkOt5mUQ-1
Received: by mail-lf1-f70.google.com with SMTP id bi4-20020a0565120e8400b0044acdd98ce2so3192110lfb.17
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 22:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4DUpQQRjllWeKgwaikEH9+Zg1RdjLEbvQ8m8vSLOXgo=;
        b=54MazTxgEe+m+hW1Hnjr0ZNwdi//z4VLfJJ59TbqSIt/jyz3UICFotwKgvZQ8/VV50
         bXJ8mZ8NpFaW1/yMdlzdppoPYgl7kgmnKLVjRA3vEBYO22VRQNrgjY4ZTUbFyXHcSalj
         2Yn0zq7+AzyuPBqS914vrgABWMUZMyKNK6op/eDw0J+VQYGZUzE3oNBqLjfRkLqdEaFX
         1t8jFRoKEubBo6+pTr31WEOaiAb6Ja9iCy6t4wWFlVHlWd9iXNscfc85rt/RQAjapfBa
         foeztpSyatH+M25mKXNyV0zWCqQeEVjY9zpBauIok9rcyrN486M9V7Q63Jj8BVs+tv06
         iX6w==
X-Gm-Message-State: AOAM532LO2iXEm6cmQe0qm5uD/N2SozWdcRciy0wGSxD/gAX40TCHV2H
        Pm8SimFYgpNmM2JYkBDvCQGmoCB0VF8yI/dvcEjyJ0oNSyeQXA0qS+tLom8F/nG62iV+di8oOdL
        fpPpeEjmLNeEIFYjA5FyVncA3aVvMbTeC
X-Received: by 2002:a05:6512:1285:b0:46b:a899:1111 with SMTP id u5-20020a056512128500b0046ba8991111mr4242509lfs.190.1650002045410;
        Thu, 14 Apr 2022 22:54:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMjPqFCCnsam4Gad1pwnmaN1PVSlqjX3b129ONCrCyE1AW6MdYUcqBDKuUQc4SGRNnhmWVZl0obuYmi/qz+og=
X-Received: by 2002:a05:6512:1285:b0:46b:a899:1111 with SMTP id
 u5-20020a056512128500b0046ba8991111mr4242472lfs.190.1650002045138; Thu, 14
 Apr 2022 22:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-32-xuanzhuo@linux.alibaba.com> <122008a6-1e79-14d3-1478-59f96464afc9@redhat.com>
 <1649838917.6726515-10-xuanzhuo@linux.alibaba.com> <CACGkMEvPH1k76xB_cHq_S9hvMXgGruoXpKLfoMZvJZ-L7wM9iw@mail.gmail.com>
 <1649989126.5433838-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1649989126.5433838-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 15 Apr 2022 13:53:54 +0800
Message-ID: <CACGkMEuju+kdapRbnx6OxsmAbD=JZin67xGBLEqLrMeuPPw0Fg@mail.gmail.com>
Subject: Re: [PATCH v9 31/32] virtio_net: support rx/tx queue resize
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 10:23 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wro=
te:
>
> On Thu, 14 Apr 2022 17:30:02 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> > On Wed, Apr 13, 2022 at 4:47 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Wed, 13 Apr 2022 16:00:18 +0800, Jason Wang <jasowang@redhat.com> =
wrote:
> > > >
> > > > =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=
=81=93:
> > > > > This patch implements the resize function of the rx, tx queues.
> > > > > Based on this function, it is possible to modify the ring num of =
the
> > > > > queue.
> > > > >
> > > > > There may be an exception during the resize process, the resize m=
ay
> > > > > fail, or the vq can no longer be used. Either way, we must execut=
e
> > > > > napi_enable(). Because napi_disable is similar to a lock, napi_en=
able
> > > > > must be called after calling napi_disable.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >   drivers/net/virtio_net.c | 81 +++++++++++++++++++++++++++++++++=
+++++++
> > > > >   1 file changed, 81 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index b8bf00525177..ba6859f305f7 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -251,6 +251,9 @@ struct padded_vnet_hdr {
> > > > >     char padding[4];
> > > > >   };
> > > > >
> > > > > +static void virtnet_sq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > > +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > > +
> > > > >   static bool is_xdp_frame(void *ptr)
> > > > >   {
> > > > >     return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > > > @@ -1369,6 +1372,15 @@ static void virtnet_napi_enable(struct vir=
tqueue *vq, struct napi_struct *napi)
> > > > >   {
> > > > >     napi_enable(napi);
> > > > >
> > > > > +   /* Check if vq is in reset state. The normal reset/resize pro=
cess will
> > > > > +    * be protected by napi. However, the protection of napi is o=
nly enabled
> > > > > +    * during the operation, and the protection of napi will end =
after the
> > > > > +    * operation is completed. If re-enable fails during the proc=
ess, vq
> > > > > +    * will remain unavailable with reset state.
> > > > > +    */
> > > > > +   if (vq->reset)
> > > > > +           return;
> > > >
> > > >
> > > > I don't get when could we hit this condition.
> > >
> > >
> > > In patch 23, the code to implement re-enable vq is as follows:
> > >
> > > +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
> > > +{
> > > +       struct virtio_pci_device *vp_dev =3D to_vp_device(vq->vdev);
> > > +       struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> > > +       struct virtio_pci_vq_info *info;
> > > +       unsigned long flags, index;
> > > +       int err;
> > > +
> > > +       if (!vq->reset)
> > > +               return -EBUSY;
> > > +
> > > +       index =3D vq->index;
> > > +       info =3D vp_dev->vqs[index];
> > > +
> > > +       /* check queue reset status */
> > > +       if (vp_modern_get_queue_reset(mdev, index) !=3D 1)
> > > +               return -EBUSY;
> > > +
> > > +       err =3D vp_active_vq(vq, info->msix_vector);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       if (vq->callback) {
> > > +               spin_lock_irqsave(&vp_dev->lock, flags);
> > > +               list_add(&info->node, &vp_dev->virtqueues);
> > > +               spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +       } else {
> > > +               INIT_LIST_HEAD(&info->node);
> > > +       }
> > > +
> > > +       vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
> > > +
> > > +       if (vp_dev->per_vq_vectors && info->msix_vector !=3D VIRTIO_M=
SI_NO_VECTOR)
> > > +               enable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix=
_vector));
> > > +
> > > +       vq->reset =3D false;
> > > +
> > > +       return 0;
> > > +}
> > >
> > >
> > > There are three situations where an error will be returned. These are=
 the
> > > situations I want to handle.
> >
> > Right, but it looks harmless if we just schedule the NAPI without the c=
heck.
>
> Yes.
>
> > >
> > > But I'm rethinking the question, and I feel like you're right, althou=
gh the
> > > hardware setup may fail. We can no longer sync with the hardware. But=
 using it
> > > as a normal vq doesn't have any problems.
> >
> > Note that we should make sure the buggy(malicous) device won't crash
> > the codes by changing the queue_reset value at its will.
>
> I will keep an eye on this situation.
>
> >
> > >
> > > >
> > > >
> > > > > +
> > > > >     /* If all buffers were filled by other side before we napi_en=
abled, we
> > > > >      * won't get another interrupt, so process any outstanding pa=
ckets now.
> > > > >      * Call local_bh_enable after to trigger softIRQ processing.
> > > > > @@ -1413,6 +1425,15 @@ static void refill_work(struct work_struct=
 *work)
> > > > >             struct receive_queue *rq =3D &vi->rq[i];
> > > > >
> > > > >             napi_disable(&rq->napi);
> > > > > +
> > > > > +           /* Check if vq is in reset state. See more in
> > > > > +            * virtnet_napi_enable()
> > > > > +            */
> > > > > +           if (rq->vq->reset) {
> > > > > +                   virtnet_napi_enable(rq->vq, &rq->napi);
> > > > > +                   continue;
> > > > > +           }
> > > >
> > > >
> > > > Can we do something similar in virtnet_close() by canceling the wor=
k?
> > >
> > > I think there is no need to cancel the work here, because napi_disabl=
e will wait
> > > for the napi_enable of the resize. So if the re-enable failed vq is u=
sed as a normal
> > > vq, this logic can be removed.
> >
> > Actually I meant the part of virtnet_rx_resize().
> >
> > If we don't synchronize with the refill work, it might enable NAPI unex=
pectedly?
>
> I don't think this situation will be encountered, because napi_disable is
> mutually exclusive, so there will be no unexpected napi enable.
>
> Is there something I misunderstood?

So in virtnet_rx_resize() we do:

napi_disable()
...
resize()
...
napi_enalbe()

How can we guarantee that the work is not run after the napi_disable()?

Thanks

>
> Thanks.
>
> >
> > Thanks
> >
> > >
> > >
> > > >
> > > >
> > > > > +
> > > > >             still_empty =3D !try_fill_recv(vi, rq, GFP_KERNEL);
> > > > >             virtnet_napi_enable(rq->vq, &rq->napi);
> > > > >
> > > > > @@ -1523,6 +1544,10 @@ static void virtnet_poll_cleantx(struct re=
ceive_queue *rq)
> > > > >     if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
> > > > >             return;
> > > > >
> > > > > +   /* Check if vq is in reset state. See more in virtnet_napi_en=
able() */
> > > > > +   if (sq->vq->reset)
> > > > > +           return;
> > > >
> > > >
> > > > We've disabled TX napi, any chance we can still hit this?
> > >
> > > Same as above.
> > >
> > > >
> > > >
> > > > > +
> > > > >     if (__netif_tx_trylock(txq)) {
> > > > >             do {
> > > > >                     virtqueue_disable_cb(sq->vq);
> > > > > @@ -1769,6 +1794,62 @@ static netdev_tx_t start_xmit(struct sk_bu=
ff *skb, struct net_device *dev)
> > > > >     return NETDEV_TX_OK;
> > > > >   }
> > > > >
> > > > > +static int virtnet_rx_resize(struct virtnet_info *vi,
> > > > > +                        struct receive_queue *rq, u32 ring_num)
> > > > > +{
> > > > > +   int err;
> > > > > +
> > > > > +   napi_disable(&rq->napi);
> > > > > +
> > > > > +   err =3D virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_un=
used_buf);
> > > > > +   if (err)
> > > > > +           goto err;
> > > > > +
> > > > > +   if (!try_fill_recv(vi, rq, GFP_KERNEL))
> > > > > +           schedule_delayed_work(&vi->refill, 0);
> > > > > +
> > > > > +   virtnet_napi_enable(rq->vq, &rq->napi);
> > > > > +   return 0;
> > > > > +
> > > > > +err:
> > > > > +   netdev_err(vi->dev,
> > > > > +              "reset rx reset vq fail: rx queue index: %td err: =
%d\n",
> > > > > +              rq - vi->rq, err);
> > > > > +   virtnet_napi_enable(rq->vq, &rq->napi);
> > > > > +   return err;
> > > > > +}
> > > > > +
> > > > > +static int virtnet_tx_resize(struct virtnet_info *vi,
> > > > > +                        struct send_queue *sq, u32 ring_num)
> > > > > +{
> > > > > +   struct netdev_queue *txq;
> > > > > +   int err, qindex;
> > > > > +
> > > > > +   qindex =3D sq - vi->sq;
> > > > > +
> > > > > +   virtnet_napi_tx_disable(&sq->napi);
> > > > > +
> > > > > +   txq =3D netdev_get_tx_queue(vi->dev, qindex);
> > > > > +   __netif_tx_lock_bh(txq);
> > > > > +   netif_stop_subqueue(vi->dev, qindex);
> > > > > +   __netif_tx_unlock_bh(txq);
> > > > > +
> > > > > +   err =3D virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_un=
used_buf);
> > > > > +   if (err)
> > > > > +           goto err;
> > > > > +
> > > > > +   netif_start_subqueue(vi->dev, qindex);
> > > > > +   virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> > > > > +   return 0;
> > > > > +
> > > > > +err:
> > > >
> > > >
> > > > I guess we can still start the queue in this case? (Since we don't
> > > > change the queue if resize fails).
> > >
> > > Yes, you are right.
> > >
> > > Thanks.
> > >
> > > >
> > > >
> > > > > +   netdev_err(vi->dev,
> > > > > +              "reset tx reset vq fail: tx queue index: %td err: =
%d\n",
> > > > > +              sq - vi->sq, err);
> > > > > +   virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> > > > > +   return err;
> > > > > +}
> > > > > +
> > > > >   /*
> > > > >    * Send command via the control virtqueue and check status.  Co=
mmands
> > > > >    * supported by the hypervisor, as indicated by feature bits, s=
hould
> > > >
> > >
> >
>

