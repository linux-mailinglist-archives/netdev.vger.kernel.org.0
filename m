Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830142E65AA
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404690AbgL1QEC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Dec 2020 11:04:02 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2108 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389946AbgL1N2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 08:28:36 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4D4JGv35JjzVtqw;
        Mon, 28 Dec 2020 21:26:31 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.164]) by
 DGGEMM401-HUB.china.huawei.com ([10.3.20.209]) with mapi id 14.03.0509.000;
 Mon, 28 Dec 2020 21:27:43 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: RE: [PATCH net v5 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
Thread-Topic: [PATCH net v5 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
Thread-Index: AQHW2o8CIIFi7oWOkU++EKfH1Cw3SqoKSW4AgAI7R4A=
Date:   Mon, 28 Dec 2020 13:27:42 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DBA8C53@DGGEMM533-MBX.china.huawei.com>
References: <1608881073-19004-1-git-send-email-wangyunjian@huawei.com>
 <20201227061916-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201227061916-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.127]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Michael S. Tsirkin [mailto:mst@redhat.com]
> Sent: Sunday, December 27, 2020 7:21 PM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: netdev@vger.kernel.org; jasowang@redhat.com;
> willemdebruijn.kernel@gmail.com; virtualization@lists.linux-foundation.org;
> Lilijun (Jerry) <jerry.lilijun@huawei.com>; chenchanghu
> <chenchanghu@huawei.com>; xudingke <xudingke@huawei.com>; huangbin (J)
> <brian.huangbin@huawei.com>
> Subject: Re: [PATCH net v5 2/2] vhost_net: fix tx queue stuck when sendmsg
> fails
> 
> On Fri, Dec 25, 2020 at 03:24:33PM +0800, wangyunjian wrote:
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > Currently the driver doesn't drop a packet which can't be sent by tun
> > (e.g bad packet). In this case, the driver will always process the
> > same packet lead to the tx queue stuck.
> 
> So not making progress on a bad packet has some advantages, e.g. this is
> easier to debug.
> When is it important to drop the packet and continue?
> 
> 
> > To fix this issue:
> > 1. in the case of persistent failure (e.g bad packet), the driver
> >    can skip this descriptor by ignoring the error.
> > 2. in the case of transient failure (e.g -ENOBUFS, -EAGAIN and -ENOMEM),
> >    the driver schedules the worker to try again.
> >
> > Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
> 
> I'd just drop this tag, looks more like a feature than a bug ...

Do these two patches need to be sent separately?

Thanks

> 
> 
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > Acked-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  drivers/vhost/net.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c index
> > c8784dfafdd7..01558fb2c552 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -827,14 +827,13 @@ static void handle_tx_copy(struct vhost_net *net,
> struct socket *sock)
> >  				msg.msg_flags &= ~MSG_MORE;
> >  		}
> >
> > -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
> >  		err = sock->ops->sendmsg(sock, &msg, len);
> > -		if (unlikely(err < 0)) {
> > +		if (unlikely(err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS))
> > +{
> >  			vhost_discard_vq_desc(vq, 1);
> >  			vhost_net_enable_vq(net, vq);
> >  			break;
> >  		}
> > -		if (err != len)
> > +		if (err >= 0 && err != len)
> >  			pr_debug("Truncated TX packet: len %d != %zd\n",
> >  				 err, len);
> >  done:
> > @@ -922,7 +921,6 @@ static void handle_tx_zerocopy(struct vhost_net
> *net, struct socket *sock)
> >  			msg.msg_flags &= ~MSG_MORE;
> >  		}
> >
> > -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
> >  		err = sock->ops->sendmsg(sock, &msg, len);
> >  		if (unlikely(err < 0)) {
> >  			if (zcopy_used) {
> > @@ -931,11 +929,13 @@ static void handle_tx_zerocopy(struct vhost_net
> *net, struct socket *sock)
> >  				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> >  					% UIO_MAXIOV;
> >  			}
> > -			vhost_discard_vq_desc(vq, 1);
> > -			vhost_net_enable_vq(net, vq);
> > -			break;
> > +			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
> > +				vhost_discard_vq_desc(vq, 1);
> > +				vhost_net_enable_vq(net, vq);
> > +				break;
> > +			}
> >  		}
> > -		if (err != len)
> > +		if (err >= 0 && err != len)
> >  			pr_debug("Truncated TX packet: "
> >  				 " len %d != %zd\n", err, len);
> >  		if (!zcopy_used)
> > --
> > 2.23.0

