Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63437577E2B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbiGRI7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiGRI7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:59:37 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3DBF5B6;
        Mon, 18 Jul 2022 01:59:35 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VJgGPA0_1658134768;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VJgGPA0_1658134768)
          by smtp.aliyun-inc.com;
          Mon, 18 Jul 2022 16:59:29 +0800
Message-ID: <1658134695.4666655-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v11 38/40] virtio_net: support rx queue resize
Date:   Mon, 18 Jul 2022 16:58:15 +0800
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
 <20220629065656.54420-39-xuanzhuo@linux.alibaba.com>
 <c0747cbc-685b-85a9-1931-0124124755f2@redhat.com>
 <1656986375.3420787-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEu80KP-ULz_CBvauRk_3XsCubMkkWv0uLnbt-wib5KOnA@mail.gmail.com>
 <1657874178.9766078-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEtF5NSXh-=nnsniLqy0pX2Tpyh413S5Bu5vZ6h=d+aHTA@mail.gmail.com>
In-Reply-To: <CACGkMEtF5NSXh-=nnsniLqy0pX2Tpyh413S5Bu5vZ6h=d+aHTA@mail.gmail.com>
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

On Mon, 18 Jul 2022 16:56:24 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Fri, Jul 15, 2022 at 4:37 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wr=
ote:
> >
> > On Fri, 8 Jul 2022 14:20:52 +0800, Jason Wang <jasowang@redhat.com> wro=
te:
> > > On Tue, Jul 5, 2022 at 10:00 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com=
> wrote:
> > > >
> > > > On Mon, 4 Jul 2022 11:44:12 +0800, Jason Wang <jasowang@redhat.com>=
 wrote:
> > > > >
> > > > > =E5=9C=A8 2022/6/29 14:56, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > > > This patch implements the resize function of the rx queues.
> > > > > > Based on this function, it is possible to modify the ring num o=
f the
> > > > > > queue.
> > > > > >
> > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > ---
> > > > > >   drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
> > > > > >   1 file changed, 22 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > index 9fe222a3663a..6ab16fd193e5 100644
> > > > > > --- a/drivers/net/virtio_net.c
> > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > @@ -278,6 +278,8 @@ struct padded_vnet_hdr {
> > > > > >     char padding[12];
> > > > > >   };
> > > > > >
> > > > > > +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, v=
oid *buf);
> > > > > > +
> > > > > >   static bool is_xdp_frame(void *ptr)
> > > > > >   {
> > > > > >     return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > > > > @@ -1846,6 +1848,26 @@ static netdev_tx_t start_xmit(struct sk_=
buff *skb, struct net_device *dev)
> > > > > >     return NETDEV_TX_OK;
> > > > > >   }
> > > > > >
> > > > > > +static int virtnet_rx_resize(struct virtnet_info *vi,
> > > > > > +                        struct receive_queue *rq, u32 ring_num)
> > > > > > +{
> > > > > > +   int err, qindex;
> > > > > > +
> > > > > > +   qindex =3D rq - vi->rq;
> > > > > > +
> > > > > > +   napi_disable(&rq->napi);
> > > > >
> > > > >
> > > > > Do we need to cancel the refill work here?
> > > >
> > > >
> > > > I think no, napi_disable is mutually exclusive, which ensures that =
there will be
> > > > no conflicts between them.
> > >
> > > So this sounds similar to what I've fixed recently.
> > >
> > > 1) NAPI schedule delayed work.
> > > 2) we disable NAPI here
> > > 3) delayed work get schedule and call NAPI again
> > >
> > > ?
> >
> > Yes, but I don't think there are any negative effects.
>
> An infinite wait on the napi_disable()?

Yes.

Thanks.


>
> Thanks
>
> >
> > Thanks.
> >
> > >
> > > Thanks
> > >
> > > >
> > > > Thanks.
> > > >
> > > > >
> > > > > Thanks
> > > > >
> > > > >
> > > > > > +
> > > > > > +   err =3D virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_=
unused_buf);
> > > > > > +   if (err)
> > > > > > +           netdev_err(vi->dev, "resize rx fail: rx queue index=
: %d err: %d\n", qindex, err);
> > > > > > +
> > > > > > +   if (!try_fill_recv(vi, rq, GFP_KERNEL))
> > > > > > +           schedule_delayed_work(&vi->refill, 0);
> > > > > > +
> > > > > > +   virtnet_napi_enable(rq->vq, &rq->napi);
> > > > > > +   return err;
> > > > > > +}
> > > > > > +
> > > > > >   /*
> > > > > >    * Send command via the control virtqueue and check status.  =
Commands
> > > > > >    * supported by the hypervisor, as indicated by feature bits,=
 should
> > > > >
> > > >
> > >
> >
>
