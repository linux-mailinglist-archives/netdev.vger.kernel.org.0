Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4FF2D433C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbgLIN3E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Dec 2020 08:29:04 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2475 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732357AbgLIN2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:28:49 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CrdBs24gCz53Lr;
        Wed,  9 Dec 2020 21:27:33 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.12]) by
 DGGEMM406-HUB.china.huawei.com ([10.3.20.214]) with mapi id 14.03.0487.000;
 Wed, 9 Dec 2020 21:27:58 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>
Subject: RE: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
Thread-Topic: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
Thread-Index: AQHWziE8nJQGdy3dYky5c7D9irxA4anuMTMAgACNl9A=
Date:   Wed, 9 Dec 2020 13:27:57 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB61ADF@DGGEMM533-MBX.china.huawei.com>
References: <1607514504-20956-1-git-send-email-wangyunjian@huawei.com>
 <20201209074832-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201209074832-mutt-send-email-mst@kernel.org>
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
> Sent: Wednesday, December 9, 2020 8:50 PM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: jasowang@redhat.com; virtualization@lists.linux-foundation.org;
> netdev@vger.kernel.org; Lilijun (Jerry) <jerry.lilijun@huawei.com>;
> chenchanghu <chenchanghu@huawei.com>; xudingke <xudingke@huawei.com>
> Subject: Re: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
> 
> On Wed, Dec 09, 2020 at 07:48:24PM +0800, wangyunjian wrote:
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > Currently we break the loop and wake up the vhost_worker when sendmsg
> > fails. When the worker wakes up again, we'll meet the same error. This
> > will cause high CPU load. To fix this issue, we can skip this
> > description by ignoring the error.
> >
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > ---
> >  drivers/vhost/net.c | 24 +++++-------------------
> >  1 file changed, 5 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c index
> > 531a00d703cd..ac950b1120f5 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -829,14 +829,8 @@ static void handle_tx_copy(struct vhost_net *net,
> > struct socket *sock)
> >
> >  		/* TODO: Check specific error and bomb out unless ENOBUFS? */
> >  		err = sock->ops->sendmsg(sock, &msg, len);
> > -		if (unlikely(err < 0)) {
> > -			vhost_discard_vq_desc(vq, 1);
> > -			vhost_net_enable_vq(net, vq);
> > -			break;
> > -		}
> > -		if (err != len)
> > -			pr_debug("Truncated TX packet: len %d != %zd\n",
> > -				 err, len);
> > +		if (unlikely(err < 0 || err != len))
> > +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err,
> > +len);
> >  done:
> >  		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
> >  		vq->heads[nvq->done_idx].len = 0;
> 
> One of the reasons for sendmsg to fail is ENOBUFS.
> In that case for sure we don't want to drop packet.

Now the function tap_sendmsg()/tun_sendmsg() don't return ENOBUFS.

> There could be other transient errors.
> Which error did you encounter, specifically?

Currently a guest vm send a skb which length is more than 64k.
If virtio hdr is wrong, the problem will also be triggered.

Thanks

> 
> > @@ -925,19 +919,11 @@ static void handle_tx_zerocopy(struct vhost_net
> > *net, struct socket *sock)
> >
> >  		/* TODO: Check specific error and bomb out unless ENOBUFS? */
> >  		err = sock->ops->sendmsg(sock, &msg, len);
> > -		if (unlikely(err < 0)) {
> > -			if (zcopy_used) {
> > +		if (unlikely(err < 0 || err != len)) {
> > +			if (zcopy_used && err < 0)
> >  				vhost_net_ubuf_put(ubufs);
> > -				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
> > -					% UIO_MAXIOV;
> > -			}
> > -			vhost_discard_vq_desc(vq, 1);
> > -			vhost_net_enable_vq(net, vq);
> > -			break;
> > +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n", err,
> > +len);
> >  		}
> > -		if (err != len)
> > -			pr_debug("Truncated TX packet: "
> > -				 " len %d != %zd\n", err, len);
> >  		if (!zcopy_used)
> >  			vhost_add_used_and_signal(&net->dev, vq, head, 0);
> >  		else
> > --
> > 2.23.0

