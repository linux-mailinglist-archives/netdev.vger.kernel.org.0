Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA9357F990
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 08:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiGYGnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 02:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiGYGnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 02:43:06 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2861165;
        Sun, 24 Jul 2022 23:43:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VKIBBAF_1658731375;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VKIBBAF_1658731375)
          by smtp.aliyun-inc.com;
          Mon, 25 Jul 2022 14:42:56 +0800
Message-ID: <1658731116.1695666-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v12 38/40] virtio_net: support rx queue resize
Date:   Mon, 25 Jul 2022 14:38:36 +0800
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
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
 <20220720030436.79520-39-xuanzhuo@linux.alibaba.com>
 <726a5056-789a-b445-a2c6-879008ad270a@redhat.com>
In-Reply-To: <726a5056-789a-b445-a2c6-879008ad270a@redhat.com>
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

On Thu, 21 Jul 2022 17:25:59 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/7/20 11:04, Xuan Zhuo =E5=86=99=E9=81=93:
> > This patch implements the resize function of the rx queues.
> > Based on this function, it is possible to modify the ring num of the
> > queue.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
> >   1 file changed, 22 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index fe4dc43c05a1..1115a8b59a08 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -278,6 +278,8 @@ struct padded_vnet_hdr {
> >   	char padding[12];
> >   };
> >
> > +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf=
);
> > +
> >   static bool is_xdp_frame(void *ptr)
> >   {
> >   	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > @@ -1846,6 +1848,26 @@ static netdev_tx_t start_xmit(struct sk_buff *sk=
b, struct net_device *dev)
> >   	return NETDEV_TX_OK;
> >   }
> >
> > +static int virtnet_rx_resize(struct virtnet_info *vi,
> > +			     struct receive_queue *rq, u32 ring_num)
> > +{
> > +	int err, qindex;
> > +
> > +	qindex =3D rq - vi->rq;
> > +
> > +	napi_disable(&rq->napi);
>
>
> We need to disable refill work as well. So this series might need
> rebasing on top of
>
> https://lore.kernel.org/netdev/20220704074859.16912-1-jasowang@redhat.com/

I understand that your patch is used to solve the situation where dev is
destoryed but refill work is running.

And is there such a possibility here? Or is there any other scenario that I=
'm
not expecting?

Thanks.


>
> I will send a new version (probably tomorrow).
>
> Thanks
>
>
> > +
> > +	err =3D virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_unused_buf=
);
> > +	if (err)
> > +		netdev_err(vi->dev, "resize rx fail: rx queue index: %d err: %d\n", =
qindex, err);
> > +
> > +	if (!try_fill_recv(vi, rq, GFP_KERNEL))
> > +		schedule_delayed_work(&vi->refill, 0);
> > +
> > +	virtnet_napi_enable(rq->vq, &rq->napi);
> > +	return err;
> > +}
> > +
> >   /*
> >    * Send command via the control virtqueue and check status.  Commands
> >    * supported by the hypervisor, as indicated by feature bits, should
>
