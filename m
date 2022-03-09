Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD4B4D2CEB
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiCIKQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiCIKQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:16:20 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEFF16A59F;
        Wed,  9 Mar 2022 02:15:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6jAw-c_1646820913;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6jAw-c_1646820913)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 18:15:14 +0800
Message-ID: <1646820327.1766295-14-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 24/26] virtio_net: support rx/tx queue reset
Date:   Wed, 9 Mar 2022 18:05:27 +0800
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
 <20220308123518.33800-25-xuanzhuo@linux.alibaba.com>
 <7ff78ff8-bdd0-bb5e-1cea-cf1126226feb@redhat.com>
In-Reply-To: <7ff78ff8-bdd0-bb5e-1cea-cf1126226feb@redhat.com>
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

On Wed, 9 Mar 2022 17:14:34 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:35, Xuan Zhuo =E5=86=99=E9=81=93:
> > This patch implements the reset function of the rx, tx queues.
> >
> > Based on this function, it is possible to modify the ring num of the
> > queue. And quickly recycle the buffer in the queue.
> >
> > In the process of the queue disable, in theory, as long as virtio
> > supports queue reset, there will be no exceptions.
> >
> > However, in the process of the queue enable, there may be exceptions du=
e to
> > memory allocation.  In this case, vq is not available, but we still have
> > to execute napi_enable(). Because napi_disable is similar to a lock,
> > napi_enable must be called after calling napi_disable.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 107 +++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 107 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 409a8e180918..ffff323dcef0 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -251,6 +251,11 @@ struct padded_vnet_hdr {
> >   	char padding[4];
> >   };
> >
> > +static void virtnet_sq_free_unused_bufs(struct virtnet_info *vi,
> > +					struct send_queue *sq);
> > +static void virtnet_rq_free_unused_bufs(struct virtnet_info *vi,
> > +					struct receive_queue *rq);
> > +
> >   static bool is_xdp_frame(void *ptr)
> >   {
> >   	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > @@ -1369,6 +1374,9 @@ static void virtnet_napi_enable(struct virtqueue =
*vq, struct napi_struct *napi)
> >   {
> >   	napi_enable(napi);
> >
> > +	if (vq->reset)
> > +		return;
> > +
>
>
> Let's WARN_ONCE() here?
>
>
> >   	/* If all buffers were filled by other side before we napi_enabled, =
we
> >   	 * won't get another interrupt, so process any outstanding packets n=
ow.
> >   	 * Call local_bh_enable after to trigger softIRQ processing.
> > @@ -1413,6 +1421,10 @@ static void refill_work(struct work_struct *work)
> >   		struct receive_queue *rq =3D &vi->rq[i];
> >
> >   		napi_disable(&rq->napi);
> > +		if (rq->vq->reset) {
> > +			virtnet_napi_enable(rq->vq, &rq->napi);
> > +			continue;
> > +		}
>
>
> This seems racy and it's a hint that we need sync with the refill work
> during reset like what we did in virtnet_close():
>
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Make sure refill_work does=
n't re-enable napi! */
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cancel_delayed_work_sync(&vi-=
>refill);
>
>
> >   		still_empty =3D !try_fill_recv(vi, rq, GFP_KERNEL);
> >   		virtnet_napi_enable(rq->vq, &rq->napi);
> >
> > @@ -1523,6 +1535,9 @@ static void virtnet_poll_cleantx(struct receive_q=
ueue *rq)
> >   	if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
> >   		return;
> >
> > +	if (sq->vq->reset)
> > +		return;
>
>
> It looks to me we'd better either WARN or just remove this. Since it
> looks like a workaround for the un-synchronized NAPI somehow.
>

During the reset process, both ring reset and enable may fail. In the case =
of
failure, vq will be unavailable. All three cases prevent this situation.

Even if it fails, napi still needs to be enabled. This is to prevent
napi_disable from being stuck when the network card is closed.


So the first and second cases above are that napi is enabled, but vq has not
been reset successfully or is still in reset.

And the third case is to deal with tx in reset, and rx is in working state,=
 then
here will access the vq of sq.




>
> > +
> >   	if (__netif_tx_trylock(txq)) {
> >   		do {
> >   			virtqueue_disable_cb(sq->vq);
> > @@ -1769,6 +1784,98 @@ static netdev_tx_t start_xmit(struct sk_buff *sk=
b, struct net_device *dev)
> >   	return NETDEV_TX_OK;
> >   }
> >
> > +static int virtnet_rx_vq_reset(struct virtnet_info *vi,
> > +			       struct receive_queue *rq, u32 ring_num)
>
>
> It's better to rename this as virtnet_rx_resize().


I don't think resize is good enough, because I think resize is an effect of
reset. Inside af_xdp, we will call it just to reset to free the buffer with=
out
resize with ring_num =3D=3D 0.

So virtnet_rx_reset() might be better.

>
>
> > +{
> > +	int err;
> > +
> > +	/* stop napi */
> > +	napi_disable(&rq->napi);
> > +
>
>
> Here, as discussed above, we need synchronize with the refill work.
>
>
> > +	/* reset the queue */
> > +	err =3D virtio_reset_vq(rq->vq);
> > +	if (err)
> > +		goto err;
>
>
> Btw, most comment of this function seems useless since code already
> explain themselves.

OK, I will remove these.

>
>
> > +
> > +	/* free bufs */
> > +	virtnet_rq_free_unused_bufs(vi, rq);
> > +
> > +	/* reset vring. */
> > +	err =3D virtqueue_reset_vring(rq->vq, ring_num);
> > +	if (err)
> > +		goto err;
> > +
> > +	/* enable reset queue */
> > +	err =3D virtio_enable_resetq(rq->vq);
> > +	if (err)
> > +		goto err;
> > +
> > +	/* fill recv */
> > +	if (!try_fill_recv(vi, rq, GFP_KERNEL))
> > +		schedule_delayed_work(&vi->refill, 0);
> > +
> > +	/* enable napi */
> > +	virtnet_napi_enable(rq->vq, &rq->napi);
> > +	return 0;
> > +
> > +err:
> > +	netdev_err(vi->dev,
> > +		   "reset rx reset vq fail: rx queue index: %ld err: %d\n",
> > +		   rq - vi->rq, err);
> > +	virtnet_napi_enable(rq->vq, &rq->napi);
> > +	return err;
> > +}
> > +
> > +static int virtnet_tx_vq_reset(struct virtnet_info *vi,
> > +			       struct send_queue *sq, u32 ring_num)
> > +{
>
>
> It looks to me it's better to rename this as "virtnet_rx_resize()"
>
>
> > +	struct netdev_queue *txq;
> > +	int err, qindex;
> > +
> > +	qindex =3D sq - vi->sq;
> > +
> > +	txq =3D netdev_get_tx_queue(vi->dev, qindex);
> > +	__netif_tx_lock_bh(txq);
> > +
> > +	/* stop tx queue and napi */
> > +	netif_stop_subqueue(vi->dev, qindex);
> > +	virtnet_napi_tx_disable(&sq->napi);
>
>
> There's no need to hold tx lock for napi disable.

tx lock =E7=9A=84=E4=B8=BB=E8=A6=81=E7=9B=AE=E7=9A=84=E6=98=AF=E7=AD=89=E5=
=BE=85=E5=85=B6=E5=AE=83=E7=9A=84 xmit =E8=B0=83=E7=94=A8=E7=BB=93=E6=9D=9F.
=E5=B9=B6=E8=AE=BE=E7=BD=AE netif_stop_subqueue()

The main purpose of tx lock is to wait for other xmit calls to end. And set
netif_stop_subqueue()

Thanks.

>
> Thanks
>
>
> > +
> > +	__netif_tx_unlock_bh(txq);
> > +
> > +	/* reset the queue */
> > +	err =3D virtio_reset_vq(sq->vq);
> > +	if (err) {
> > +		netif_start_subqueue(vi->dev, qindex);
> > +		goto err;
> > +	}
> > +
> > +	/* free bufs */
> > +	virtnet_sq_free_unused_bufs(vi, sq);
> > +
> > +	/* reset vring. */
> > +	err =3D virtqueue_reset_vring(sq->vq, ring_num);
> > +	if (err)
> > +		goto err;
> > +
> > +	/* enable reset queue */
> > +	err =3D virtio_enable_resetq(sq->vq);
> > +	if (err)
> > +		goto err;
> > +
> > +	/* start tx queue and napi */
> > +	netif_start_subqueue(vi->dev, qindex);
> > +	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> > +	return 0;
> > +
> > +err:
> > +	netdev_err(vi->dev,
> > +		   "reset tx reset vq fail: tx queue index: %ld err: %d\n",
> > +		   sq - vi->sq, err);
> > +	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> > +	return err;
> > +}
> > +
> >   /*
> >    * Send command via the control virtqueue and check status.  Commands
> >    * supported by the hypervisor, as indicated by feature bits, should
>
