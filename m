Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC81575D81
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbiGOIbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiGOIbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:31:50 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91157804B5;
        Fri, 15 Jul 2022 01:31:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VJOUor5_1657873898;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VJOUor5_1657873898)
          by smtp.aliyun-inc.com;
          Fri, 15 Jul 2022 16:31:40 +0800
Message-ID: <1657873703.9301925-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v11 39/40] virtio_net: support tx queue resize
Date:   Fri, 15 Jul 2022 16:28:23 +0800
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
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        kangjie.xu@linux.alibaba.com,
        virtualization <virtualization@lists.linux-foundation.org>
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-40-xuanzhuo@linux.alibaba.com>
 <102d3b83-1ae9-a59a-16ce-251c22b7afb0@redhat.com>
 <1656986432.1164997-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEt8MSS=tcn=Hd6WF9+btT0ccocxEd1ighRgK-V1uiWmCQ@mail.gmail.com>
In-Reply-To: <CACGkMEt8MSS=tcn=Hd6WF9+btT0ccocxEd1ighRgK-V1uiWmCQ@mail.gmail.com>
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

On Fri, 8 Jul 2022 14:23:57 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Jul 5, 2022 at 10:01 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wr=
ote:
> >
> > On Mon, 4 Jul 2022 11:45:52 +0800, Jason Wang <jasowang@redhat.com> wro=
te:
> > >
> > > =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > This patch implements the resize function of the tx queues.
> > > > Based on this function, it is possible to modify the ring num of the
> > > > queue.
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > ---
> > > >   drivers/net/virtio_net.c | 48 +++++++++++++++++++++++++++++++++++=
+++++
> > > >   1 file changed, 48 insertions(+)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 6ab16fd193e5..fd358462f802 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -135,6 +135,9 @@ struct send_queue {
> > > >     struct virtnet_sq_stats stats;
> > > >
> > > >     struct napi_struct napi;
> > > > +
> > > > +   /* Record whether sq is in reset state. */
> > > > +   bool reset;
> > > >   };
> > > >
> > > >   /* Internal representation of a receive virtqueue */
> > > > @@ -279,6 +282,7 @@ struct padded_vnet_hdr {
> > > >   };
> > > >
> > > >   static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void=
 *buf);
> > > > +static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void =
*buf);
> > > >
> > > >   static bool is_xdp_frame(void *ptr)
> > > >   {
> > > > @@ -1603,6 +1607,11 @@ static void virtnet_poll_cleantx(struct rece=
ive_queue *rq)
> > > >             return;
> > > >
> > > >     if (__netif_tx_trylock(txq)) {
> > > > +           if (READ_ONCE(sq->reset)) {
> > > > +                   __netif_tx_unlock(txq);
> > > > +                   return;
> > > > +           }
> > > > +
> > > >             do {
> > > >                     virtqueue_disable_cb(sq->vq);
> > > >                     free_old_xmit_skbs(sq, true);
> > > > @@ -1868,6 +1877,45 @@ static int virtnet_rx_resize(struct virtnet_=
info *vi,
> > > >     return err;
> > > >   }
> > > >
> > > > +static int virtnet_tx_resize(struct virtnet_info *vi,
> > > > +                        struct send_queue *sq, u32 ring_num)
> > > > +{
> > > > +   struct netdev_queue *txq;
> > > > +   int err, qindex;
> > > > +
> > > > +   qindex =3D sq - vi->sq;
> > > > +
> > > > +   virtnet_napi_tx_disable(&sq->napi);
> > > > +
> > > > +   txq =3D netdev_get_tx_queue(vi->dev, qindex);
> > > > +
> > > > +   /* 1. wait all ximt complete
> > > > +    * 2. fix the race of netif_stop_subqueue() vs netif_start_subq=
ueue()
> > > > +    */
> > > > +   __netif_tx_lock_bh(txq);
> > > > +
> > > > +   /* Prevent rx poll from accessing sq. */
> > > > +   WRITE_ONCE(sq->reset, true);
> > >
> > >
> > > Can we simply disable RX NAPI here?
> >
> > Disable rx napi is indeed a simple solution. But I hope that when deali=
ng with
> > tx, it will not affect rx.
>
> Ok, but I think we've already synchronized with tx lock here, isn't it?

Yes, do you have any questions about WRITE_ONCE()? There is a set false ope=
ration
later, I did not use lock there, so I used WRITE/READ_ONCE
uniformly.

Thanks.

>
> Thanks
>
> >
> > Thanks.
> >
> >
> > >
> > > Thanks
> > >
> > >
> > > > +
> > > > +   /* Prevent the upper layer from trying to send packets. */
> > > > +   netif_stop_subqueue(vi->dev, qindex);
> > > > +
> > > > +   __netif_tx_unlock_bh(txq);
> > > > +
> > > > +   err =3D virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unus=
ed_buf);
> > > > +   if (err)
> > > > +           netdev_err(vi->dev, "resize tx fail: tx queue index: %d=
 err: %d\n", qindex, err);
> > > > +
> > > > +   /* Memory barrier before set reset and start subqueue. */
> > > > +   smp_mb();
> > > > +
> > > > +   WRITE_ONCE(sq->reset, false);
> > > > +   netif_tx_wake_queue(txq);
> > > > +
> > > > +   virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> > > > +   return err;
> > > > +}
> > > > +
> > > >   /*
> > > >    * Send command via the control virtqueue and check status.  Comm=
ands
> > > >    * supported by the hypervisor, as indicated by feature bits, sho=
uld
> > >
> >
>
