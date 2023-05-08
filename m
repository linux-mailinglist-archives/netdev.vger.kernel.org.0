Return-Path: <netdev+bounces-810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4506F9FDA
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B99B61C2096F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CEF13AFE;
	Mon,  8 May 2023 06:28:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597717E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:28:16 +0000 (UTC)
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D7330E8;
	Sun,  7 May 2023 23:28:13 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vi.ayqL_1683527290;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vi.ayqL_1683527290)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 14:28:11 +0800
Message-ID: <1683526688.7492425-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum MTU' bigger than 1500
Date: Mon, 8 May 2023 14:18:08 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: huangml@yusur.tech,
 zy@yusur.tech,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 "open list:VIRTIO CORE AND NET DRIVERS" <virtualization@lists.linux-foundation.org>,
 "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 Hao Chen <chenh@yusur.tech>,
 hengqi@linux.alibaba.com
References: <20230506021529.396812-1-chenh@yusur.tech>
 <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
 <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
 <20230507045627-mutt-send-email-mst@kernel.org>
 <1683511319.099806-2-xuanzhuo@linux.alibaba.com>
 <20230508020953-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230508020953-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Mon, 8 May 2023 02:15:46 -0400, "Michael S. Tsirkin" <mst@redhat.com> wr=
ote:
> On Mon, May 08, 2023 at 10:01:59AM +0800, Xuan Zhuo wrote:
> > On Sun, 7 May 2023 04:58:58 -0400, "Michael S. Tsirkin" <mst@redhat.com=
> wrote:
> > > On Sat, May 06, 2023 at 04:56:35PM +0800, Hao Chen wrote:
> > > >
> > > >
> > > > =E5=9C=A8 2023/5/6 10:50, Xuan Zhuo =E5=86=99=E9=81=93:
> > > > > On Sat,  6 May 2023 10:15:29 +0800, Hao Chen <chenh@yusur.tech> w=
rote:
> > > > > > When VIRTIO_NET_F_MTU(3) Device maximum MTU reporting is suppor=
ted.
> > > > > > If offered by the device, device advises driver about the value=
 of its
> > > > > > maximum MTU. If negotiated, the driver uses mtu as the maximum
> > > > > > MTU value. But there the driver also uses it as default mtu,
> > > > > > some devices may have a maximum MTU greater than 1500, this may
> > > > > > cause some large packages to be discarded,
> > > > >
> > > > > You mean tx packet?
> > > > Yes.
> > > > >
> > > > > If yes, I do not think this is the problem of driver.
> > > > >
> > > > > Maybe you should give more details about the discard.
> > > > >
> > > > In the current code, if the maximum MTU supported by the virtio net=
 hardware
> > > > is 9000, the default MTU of the virtio net driver will also be set =
to 9000.
> > > > When sending packets through "ping -s 5000", if the peer router doe=
s not
> > > > support negotiating a path MTU through ICMP packets, the packets wi=
ll be
> > > > discarded. If the peer router supports negotiating path mtu through=
 ICMP
> > > > packets, the host side will perform packet sharding processing base=
d on the
> > > > negotiated path mtu, which is generally within 1500.
> > > > This is not a bugfix patch, I think setting the default mtu to with=
in 1500
> > > > would be more suitable here.Thanks.
> > >
> > > I don't think VIRTIO_NET_F_MTU is appropriate for support for jumbo p=
ackets.
> > > The spec says:
> > > 	The device MUST forward transmitted packets of up to mtu (plus low l=
evel ethernet header length) size with
> > > 	gso_type NONE or ECN, and do so without fragmentation, after VIRTIO_=
NET_F_MTU has been success-
> > > 	fully negotiated.
> > > VIRTIO_NET_F_MTU has been designed for all kind of tunneling devices,
> > > and this is why we set mtu to max by default.
> > >
> > > For things like jumbo frames where MTU might or might not be availabl=
e,
> > > a new feature would be more appropriate.
> >
> >
> > So for jumbo frame, what is the problem?
> >
> > We are trying to do this. @Heng
> >
> > Thanks.
>
> It is not a problem as such. But VIRTIO_NET_F_MTU will set the
> default MTU not just the maximum one, because spec seems to
> say it can.

I see.

In the case of Jumbo Frame, we also hope that the driver will set the defau=
lt
directly to the max mtu. Just like what you said "Bigger packets =3D better
performance."

I don't know, in any scenario, when the hardware supports a large mtu, but =
we do
not want the user to use it by default. Of course, the scene that this patch
wants to handle does exist, but I have never thought that this is a problem=
 at
the driver level.

Thanks.


>
>
> >
> > >
> > > > > > so I changed the MTU to a more
> > > > > > general 1500 when 'Device maximum MTU' bigger than 1500.
> > > > > >
> > > > > > Signed-off-by: Hao Chen <chenh@yusur.tech>
> > > > > > ---
> > > > > >   drivers/net/virtio_net.c | 5 ++++-
> > > > > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > index 8d8038538fc4..e71c7d1b5f29 100644
> > > > > > --- a/drivers/net/virtio_net.c
> > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > @@ -4040,7 +4040,10 @@ static int virtnet_probe(struct virtio_d=
evice *vdev)
> > > > > >   			goto free;
> > > > > >   		}
> > > > > >
> > > > > > -		dev->mtu =3D mtu;
> > > > > > +		if (mtu > 1500)
> > > > >
> > > > > s/1500/ETH_DATA_LEN/
> > > > >
> > > > > Thanks.
> > > > >
> > > > > > +			dev->mtu =3D 1500;
> > > > > > +		else
> > > > > > +			dev->mtu =3D mtu;
> > > > > >   		dev->max_mtu =3D mtu;
> > > > > >   	}
> > > > > >
> > > > > > --
> > > > > > 2.27.0
> > > > > >
> > >
>

