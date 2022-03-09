Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FA84D2C3E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiCIJh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiCIJh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:37:27 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83EF16F95B;
        Wed,  9 Mar 2022 01:36:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6j1lsR_1646818580;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6j1lsR_1646818580)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 17:36:21 +0800
Message-ID: <1646818559.1648765-11-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 25/26] virtio_net: set the default max ring size by find_vqs()
Date:   Wed, 9 Mar 2022 17:35:59 +0800
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
 <20220308123518.33800-26-xuanzhuo@linux.alibaba.com>
 <d7ec6eed-d692-091b-a438-1ae1cc5ee614@redhat.com>
In-Reply-To: <d7ec6eed-d692-091b-a438-1ae1cc5ee614@redhat.com>
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

On Wed, 9 Mar 2022 17:28:21 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:35, Xuan Zhuo =E5=86=99=E9=81=93:
> > Use virtio_find_vqs_ctx_size() to specify the maximum ring size of tx,
> > rx at the same time.
> >
> >                           | rx/tx ring size
> > -------------------------------------------
> > speed =3D=3D UNKNOWN or < 10G| 1024
> > speed < 40G              | 4096
> > speed >=3D 40G             | 8192
> >
> > Call virtnet_update_settings() once before calling init_vqs() to update
> > speed.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++++++++++++----
> >   1 file changed, 38 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index ffff323dcef0..f1bdc6ce21c3 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2977,6 +2977,29 @@ static unsigned int mergeable_min_buf_len(struct=
 virtnet_info *vi, struct virtqu
> >   		   (unsigned int)GOOD_PACKET_LEN);
> >   }
> >
> > +static void virtnet_config_sizes(struct virtnet_info *vi, u32 *sizes)
> > +{
> > +	u32 i, rx_size, tx_size;
> > +
> > +	if (vi->speed =3D=3D SPEED_UNKNOWN || vi->speed < SPEED_10000) {
> > +		rx_size =3D 1024;
> > +		tx_size =3D 1024;
> > +
> > +	} else if (vi->speed < SPEED_40000) {
> > +		rx_size =3D 1024 * 4;
> > +		tx_size =3D 1024 * 4;
> > +
> > +	} else {
> > +		rx_size =3D 1024 * 8;
> > +		tx_size =3D 1024 * 8;
> > +	}
> > +
> > +	for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > +		sizes[rxq2vq(i)] =3D rx_size;
> > +		sizes[txq2vq(i)] =3D tx_size;
> > +	}
> > +}
> > +
> >   static int virtnet_find_vqs(struct virtnet_info *vi)
> >   {
> >   	vq_callback_t **callbacks;
> > @@ -2984,6 +3007,7 @@ static int virtnet_find_vqs(struct virtnet_info *=
vi)
> >   	int ret =3D -ENOMEM;
> >   	int i, total_vqs;
> >   	const char **names;
> > +	u32 *sizes;
> >   	bool *ctx;
> >
> >   	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
> > @@ -3011,10 +3035,15 @@ static int virtnet_find_vqs(struct virtnet_info=
 *vi)
> >   		ctx =3D NULL;
> >   	}
> >
> > +	sizes =3D kmalloc_array(total_vqs, sizeof(*sizes), GFP_KERNEL);
> > +	if (!sizes)
> > +		goto err_sizes;
> > +
> >   	/* Parameters for control virtqueue, if any */
> >   	if (vi->has_cvq) {
> >   		callbacks[total_vqs - 1] =3D NULL;
> >   		names[total_vqs - 1] =3D "control";
> > +		sizes[total_vqs - 1] =3D 0;
>
>
> Nit: Do we need a sane value for the control vq? (e.g 64)


I think it can.

Thanks.

>
> Thanks
>
>
> >   	}
> >
> >   	/* Allocate/initialize parameters for send/receive virtqueues */
> > @@ -3029,8 +3058,10 @@ static int virtnet_find_vqs(struct virtnet_info =
*vi)
> >   			ctx[rxq2vq(i)] =3D true;
> >   	}
> >
> > -	ret =3D virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
> > -				  names, ctx, NULL);
> > +	virtnet_config_sizes(vi, sizes);
> > +
> > +	ret =3D virtio_find_vqs_ctx_size(vi->vdev, total_vqs, vqs, callbacks,
> > +				       names, ctx, NULL, sizes);
> >   	if (ret)
> >   		goto err_find;
> >
> > @@ -3050,6 +3081,8 @@ static int virtnet_find_vqs(struct virtnet_info *=
vi)
> >
> >
> >   err_find:
> > +	kfree(sizes);
> > +err_sizes:
> >   	kfree(ctx);
> >   err_ctx:
> >   	kfree(names);
> > @@ -3368,6 +3401,9 @@ static int virtnet_probe(struct virtio_device *vd=
ev)
> >   		vi->curr_queue_pairs =3D num_online_cpus();
> >   	vi->max_queue_pairs =3D max_queue_pairs;
> >
> > +	virtnet_init_settings(dev);
> > +	virtnet_update_settings(vi);
> > +
> >   	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
> >   	err =3D init_vqs(vi);
> >   	if (err)
> > @@ -3380,8 +3416,6 @@ static int virtnet_probe(struct virtio_device *vd=
ev)
> >   	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
> >   	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
> >
> > -	virtnet_init_settings(dev);
> > -
> >   	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
> >   		vi->failover =3D net_failover_create(vi->dev);
> >   		if (IS_ERR(vi->failover)) {
>
