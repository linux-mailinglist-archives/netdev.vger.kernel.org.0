Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB70C2DCB10
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgLQCjw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Dec 2020 21:39:52 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2528 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQCjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:39:52 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CxGQK3hFMzQt07;
        Thu, 17 Dec 2020 10:38:33 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.214]) by
 DGGEMM402-HUB.china.huawei.com ([10.3.20.210]) with mapi id 14.03.0509.000;
 Thu, 17 Dec 2020 10:38:59 +0800
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
Subject: RE: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
Thread-Topic: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
Thread-Index: AQHW04Rfp56K/196YUuYX4LzCnUku6n47QYAgAGeBmA=
Date:   Thu, 17 Dec 2020 02:38:59 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB86566@DGGEMM533-MBX.china.huawei.com>
References: <cover.1608065644.git.wangyunjian@huawei.com>
 <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
 <20201216042027-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201216042027-mutt-send-email-mst@kernel.org>
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
> Sent: Wednesday, December 16, 2020 5:23 PM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: netdev@vger.kernel.org; jasowang@redhat.com;
> willemdebruijn.kernel@gmail.com; virtualization@lists.linux-foundation.org;
> Lilijun (Jerry) <jerry.lilijun@huawei.com>; chenchanghu
> <chenchanghu@huawei.com>; xudingke <xudingke@huawei.com>; huangbin (J)
> <brian.huangbin@huawei.com>
> Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg fails
> 
> On Wed, Dec 16, 2020 at 04:20:37PM +0800, wangyunjian wrote:
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > Currently we break the loop and wake up the vhost_worker when sendmsg
> > fails. When the worker wakes up again, we'll meet the same error. This
> > will cause high CPU load. To fix this issue, we can skip this
> > description by ignoring the error. When we exceeds sndbuf, the return
> > value of sendmsg is -EAGAIN. In the case we don't skip the description
> > and don't drop packet.
> 
> Question: with this patch, what happens if sendmsg is interrupted by a signal?

The descriptors are consumed as normal. However, the packet is discarded.
Could you explain the specific scenario?

> 
> 
> >
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > ---
> >  drivers/vhost/net.c | 21 +++++++++------------
> >  1 file changed, 9 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c index
> > c8784dfafdd7..3d33f3183abe 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -827,16 +827,13 @@ static void handle_tx_copy(struct vhost_net *net,
> struct socket *sock)
> >  				msg.msg_flags &= ~MSG_MORE;
> >  		}
> >
> > -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
> >  		err = sock->ops->sendmsg(sock, &msg, len);
> > -		if (unlikely(err < 0)) {
> > +		if (unlikely(err == -EAGAIN)) {
> >  			vhost_discard_vq_desc(vq, 1);
> >  			vhost_net_enable_vq(net, vq);
> >  			break;
> > -		}
> > -		if (err != len)
> > -			pr_debug("Truncated TX packet: len %d != %zd\n",
> > -				 err, len);
> > +		} else if (unlikely(err != len))
> > +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err,
> > +len);
> >  done:
> >  		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
> >  		vq->heads[nvq->done_idx].len = 0;
> > @@ -922,7 +919,6 @@ static void handle_tx_zerocopy(struct vhost_net
> *net, struct socket *sock)
> >  			msg.msg_flags &= ~MSG_MORE;
> >  		}
> >
> > -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
> >  		err = sock->ops->sendmsg(sock, &msg, len);
> >  		if (unlikely(err < 0)) {
> >  			if (zcopy_used) {
> > @@ -931,13 +927,14 @@ static void handle_tx_zerocopy(struct vhost_net
> *net, struct socket *sock)
> >  				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> >  					% UIO_MAXIOV;
> >  			}
> > -			vhost_discard_vq_desc(vq, 1);
> > -			vhost_net_enable_vq(net, vq);
> > -			break;
> > +			if (err == -EAGAIN) {
> > +				vhost_discard_vq_desc(vq, 1);
> > +				vhost_net_enable_vq(net, vq);
> > +				break;
> > +			}
> >  		}
> >  		if (err != len)
> > -			pr_debug("Truncated TX packet: "
> > -				 " len %d != %zd\n", err, len);
> > +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err,
> > +len);
> 
> I'd rather make the pr_debug -> vq_err a separate change, with proper commit
> log describing motivation.

This log was originally triggered when packets were truncated. But after the
modification of this patch, other error scenarios will also trigger this log.
That's why I modified the content and level of this log together.
Now, should I just change the content of this patch?

Thanks

> 
> 
> >  		if (!zcopy_used)
> >  			vhost_add_used_and_signal(&net->dev, vq, head, 0);
> >  		else
> > --
> > 2.23.0

