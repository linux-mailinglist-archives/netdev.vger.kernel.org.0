Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE696504E0D
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 10:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbiDRI5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 04:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiDRI5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 04:57:36 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24EC257;
        Mon, 18 Apr 2022 01:54:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0VALaedj_1650272086;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VALaedj_1650272086)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Apr 2022 16:54:48 +0800
Message-ID: <1650271705.1503067-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v9 31/32] virtio_net: support rx/tx queue resize
Date:   Mon, 18 Apr 2022 16:48:25 +0800
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
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-32-xuanzhuo@linux.alibaba.com>
 <122008a6-1e79-14d3-1478-59f96464afc9@redhat.com>
 <1650252077.7934203-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEtZOJ2PCsJidDcFKL57Q6oLHk4TH7xtewrLCTFhrbXSAA@mail.gmail.com>
In-Reply-To: <CACGkMEtZOJ2PCsJidDcFKL57Q6oLHk4TH7xtewrLCTFhrbXSAA@mail.gmail.com>
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

On Mon, 18 Apr 2022 15:49:29 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Mon, Apr 18, 2022 at 11:24 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> w=
rote:
> >
> > On Wed, 13 Apr 2022 16:00:18 +0800, Jason Wang <jasowang@redhat.com> wr=
ote:
> > >
> > > =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=
=93:
> > > > This patch implements the resize function of the rx, tx queues.
> > > > Based on this function, it is possible to modify the ring num of the
> > > > queue.
> > > >
> > > > There may be an exception during the resize process, the resize may
> > > > fail, or the vq can no longer be used. Either way, we must execute
> > > > napi_enable(). Because napi_disable is similar to a lock, napi_enab=
le
> > > > must be called after calling napi_disable.
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > ---
> > > >   drivers/net/virtio_net.c | 81 +++++++++++++++++++++++++++++++++++=
+++++
> > > >   1 file changed, 81 insertions(+)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index b8bf00525177..ba6859f305f7 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -251,6 +251,9 @@ struct padded_vnet_hdr {
> > > >     char padding[4];
> > > >   };
> > > >
> > > > +static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void =
*buf);
> > > > +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void =
*buf);
> > > > +
> > > >   static bool is_xdp_frame(void *ptr)
> > > >   {
> > > >     return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > > @@ -1369,6 +1372,15 @@ static void virtnet_napi_enable(struct virtq=
ueue *vq, struct napi_struct *napi)
> > > >   {
> > > >     napi_enable(napi);
> > > >
> > > > +   /* Check if vq is in reset state. The normal reset/resize proce=
ss will
> > > > +    * be protected by napi. However, the protection of napi is onl=
y enabled
> > > > +    * during the operation, and the protection of napi will end af=
ter the
> > > > +    * operation is completed. If re-enable fails during the proces=
s, vq
> > > > +    * will remain unavailable with reset state.
> > > > +    */
> > > > +   if (vq->reset)
> > > > +           return;
> > >
> > >
> > > I don't get when could we hit this condition.
> > >
> > >
> > > > +
> > > >     /* If all buffers were filled by other side before we napi_enab=
led, we
> > > >      * won't get another interrupt, so process any outstanding pack=
ets now.
> > > >      * Call local_bh_enable after to trigger softIRQ processing.
> > > > @@ -1413,6 +1425,15 @@ static void refill_work(struct work_struct *=
work)
> > > >             struct receive_queue *rq =3D &vi->rq[i];
> > > >
> > > >             napi_disable(&rq->napi);
> > > > +
> > > > +           /* Check if vq is in reset state. See more in
> > > > +            * virtnet_napi_enable()
> > > > +            */
> > > > +           if (rq->vq->reset) {
> > > > +                   virtnet_napi_enable(rq->vq, &rq->napi);
> > > > +                   continue;
> > > > +           }
> > >
> > >
> > > Can we do something similar in virtnet_close() by canceling the work?
> > >
> > >
> > > > +
> > > >             still_empty =3D !try_fill_recv(vi, rq, GFP_KERNEL);
> > > >             virtnet_napi_enable(rq->vq, &rq->napi);
> > > >
> > > > @@ -1523,6 +1544,10 @@ static void virtnet_poll_cleantx(struct rece=
ive_queue *rq)
> > > >     if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
> > > >             return;
> > > >
> > > > +   /* Check if vq is in reset state. See more in virtnet_napi_enab=
le() */
> > > > +   if (sq->vq->reset)
> > > > +           return;
> > >
> > >
> > > We've disabled TX napi, any chance we can still hit this?
> >
> >
> > static int virtnet_poll(struct napi_struct *napi, int budget)
> > {
> >         struct receive_queue *rq =3D
> >                 container_of(napi, struct receive_queue, napi);
> >         struct virtnet_info *vi =3D rq->vq->vdev->priv;
> >         struct send_queue *sq;
> >         unsigned int received;
> >         unsigned int xdp_xmit =3D 0;
> >
> >         virtnet_poll_cleantx(rq);
> > ...
> > }
> >
> > This is called by rx poll. Although it is the logic of tx, it is not dr=
iven by
> > tx napi, but is called in rx poll.
>
> Ok, but we need guarantee the memory ordering in this case. Disable RX
> napi could be a solution for this.

Yes, I have realized this too. I have two solutions, disable rx napi or the
following.

Thanks.


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9bf1b6530b38..7764d1dcb831 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -135,6 +135,7 @@ struct send_queue {
 	struct virtnet_sq_stats stats;

 	struct napi_struct napi;
+	bool reset;
 };

 /* Internal representation of a receive virtqueue */
@@ -1583,6 +1587,11 @@ static void virtnet_poll_cleantx(struct receive_queu=
e *rq)
 		return;

 	if (__netif_tx_trylock(txq)) {
+		if (sq->reset) {
+			__netif_tx_unlock(txq);
+			return;
+		}
+
 		do {
 			virtqueue_disable_cb(sq->vq);
 			free_old_xmit_skbs(sq, true);
@@ -1828,6 +1837,56 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, s=
truct net_device *dev)
 	return NETDEV_TX_OK;
 }

+static int virtnet_tx_resize(struct virtnet_info *vi,
+			     struct send_queue *sq, u32 ring_num)
+{
+	struct netdev_queue *txq;
+	int err, qindex;
+
+	qindex =3D sq - vi->sq;
+
+	virtnet_napi_tx_disable(&sq->napi);
+
+	txq =3D netdev_get_tx_queue(vi->dev, qindex);
+
+	__netif_tx_lock_bh(txq);
+	netif_stop_subqueue(vi->dev, qindex);
+	sq->reset =3D true;
+	__netif_tx_unlock_bh(txq);
+
+	err =3D virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
+	if (err)
+		netdev_err(vi->dev, "resize tx fail: tx queue index: %d err: %d\n", qind=
ex, err);
+
+	__netif_tx_lock_bh(txq);
+	sq->reset =3D false;
+	netif_start_subqueue(vi->dev, qindex);
+	__netif_tx_unlock_bh(txq);
+
+	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
+	return err;
+}
+

