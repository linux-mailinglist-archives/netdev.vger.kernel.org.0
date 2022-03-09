Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644A44D2C82
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiCIJvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiCIJvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:51:31 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9E6169230;
        Wed,  9 Mar 2022 01:50:30 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0V6j5yrf_1646819424;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6j5yrf_1646819424)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Mar 2022 17:50:25 +0800
Message-ID: <1646819291.9191294-12-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v7 26/26] virtio_net: support set_ringparam
Date:   Wed, 9 Mar 2022 17:48:11 +0800
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
 <20220308123518.33800-27-xuanzhuo@linux.alibaba.com>
 <bd27898f-59bc-215b-bb84-14582b12cb16@redhat.com>
In-Reply-To: <bd27898f-59bc-215b-bb84-14582b12cb16@redhat.com>
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

On Wed, 9 Mar 2022 17:29:28 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2022/3/8 =E4=B8=8B=E5=8D=888:35, Xuan Zhuo =E5=86=99=E9=81=93:
> > Support set_ringparam based on virtio queue reset.
> >
> > The rx,tx_pending required to be passed must be power of 2.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 47 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index f1bdc6ce21c3..1fa2d632a994 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2290,6 +2290,52 @@ static void virtnet_get_ringparam(struct net_dev=
ice *dev,
> >   	ring->tx_pending =3D virtqueue_get_vring_size(vi->sq[0].vq);
> >   }
> >
> > +static int virtnet_set_ringparam(struct net_device *dev,
> > +				 struct ethtool_ringparam *ring,
> > +				 struct kernel_ethtool_ringparam *kernel_ring,
> > +				 struct netlink_ext_ack *extack)
> > +{
> > +	struct virtnet_info *vi =3D netdev_priv(dev);
> > +	u32 rx_pending, tx_pending;
> > +	struct receive_queue *rq;
> > +	struct send_queue *sq;
> > +	int i, err;
> > +
> > +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> > +		return -EINVAL;
>
>
> Any chance that we may hit this EINVAL?

This is definitely not the case at present.

I think this can be kept, this makes sense.

I can remove it in the next version if you think it should be removed.

Thanks.

>
> Thanks
>
>
> > +
> > +	rx_pending =3D virtqueue_get_vring_size(vi->rq[0].vq);
> > +	tx_pending =3D virtqueue_get_vring_size(vi->sq[0].vq);
> > +
> > +	if (ring->rx_pending =3D=3D rx_pending &&
> > +	    ring->tx_pending =3D=3D tx_pending)
> > +		return 0;
> > +
> > +	if (ring->rx_pending > virtqueue_get_vring_max_size(vi->rq[0].vq))
> > +		return -EINVAL;
> > +
> > +	if (ring->tx_pending > virtqueue_get_vring_max_size(vi->sq[0].vq))
> > +		return -EINVAL;
> > +
> > +	for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > +		rq =3D vi->rq + i;
> > +		sq =3D vi->sq + i;
> > +
> > +		if (ring->tx_pending !=3D tx_pending) {
> > +			err =3D virtnet_tx_vq_reset(vi, sq, ring->tx_pending);
> > +			if (err)
> > +				return err;
> > +		}
> > +
> > +		if (ring->rx_pending !=3D rx_pending) {
> > +			err =3D virtnet_rx_vq_reset(vi, rq, ring->rx_pending);
> > +			if (err)
> > +				return err;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> >
> >   static void virtnet_get_drvinfo(struct net_device *dev,
> >   				struct ethtool_drvinfo *info)
> > @@ -2523,6 +2569,7 @@ static const struct ethtool_ops virtnet_ethtool_o=
ps =3D {
> >   	.get_drvinfo =3D virtnet_get_drvinfo,
> >   	.get_link =3D ethtool_op_get_link,
> >   	.get_ringparam =3D virtnet_get_ringparam,
> > +	.set_ringparam =3D virtnet_set_ringparam,
> >   	.get_strings =3D virtnet_get_strings,
> >   	.get_sset_count =3D virtnet_get_sset_count,
> >   	.get_ethtool_stats =3D virtnet_get_ethtool_stats,
>
