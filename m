Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD5616F884
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgBZH2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:28:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51785 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbgBZH2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582702095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CmPVjcusZKfDB9hlUKHH83X59AF997QxembAwB/q2SQ=;
        b=ftZZENpbfBICKFXPzSXckZv0mAibs+boeu+j0Wz+oejydWgXBgTAyXJp+BpH4+g3nZmM+E
        eO+tx/c3p+Qa3bFsPdW8J4U3+mC6kezmZ2SujGxAjbPCXvSgpHL9wx3Ef7hn+CfnHaALIf
        A/etbLkFdcs79UtkD2GauRlGtHQYIqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-eiKYtqorPVmJnsGBX3KOsg-1; Wed, 26 Feb 2020 02:28:13 -0500
X-MC-Unique: eiKYtqorPVmJnsGBX3KOsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BFC8107B103;
        Wed, 26 Feb 2020 07:28:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E2C79297B;
        Wed, 26 Feb 2020 07:28:12 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id D23CE35AE1;
        Wed, 26 Feb 2020 07:28:11 +0000 (UTC)
Date:   Wed, 26 Feb 2020 02:28:10 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>
Message-ID: <449099311.10687151.1582702090890.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200226014333-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com> <20200226014333-mutt-send-email-mst@kernel.org>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.11]
Thread-Topic: virtio_net: Relax queue requirement for using XDP
Thread-Index: oFwmcwdRq8OVbxYmN2oTxSimN7YHkA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> On Wed, Feb 26, 2020 at 11:00:40AM +0800, Jason Wang wrote:
> >=20
> > On 2020/2/26 =E4=B8=8A=E5=8D=888:57, David Ahern wrote:
> > > From: David Ahern <dahern@digitalocean.com>
> > >=20
> > > virtio_net currently requires extra queues to install an XDP program,
> > > with the rule being twice as many queues as vcpus. From a host
> > > perspective this means the VM needs to have 2*vcpus vhost threads
> > > for each guest NIC for which XDP is to be allowed. For example, a
> > > 16 vcpu VM with 2 tap devices needs 64 vhost threads.
> > >=20
> > > The extra queues are only needed in case an XDP program wants to
> > > return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
> > > additional queues. Relax the queue requirement and allow XDP
> > > functionality based on resources. If an XDP program is loaded and
> > > there are insufficient queues, then return a warning to the user
> > > and if a program returns XDP_TX just drop the packet. This allows
> > > the use of the rest of the XDP functionality to work without
> > > putting an unreasonable burden on the host.
> > >=20
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Signed-off-by: David Ahern <dahern@digitalocean.com>
> > > ---
> > >   drivers/net/virtio_net.c | 14 ++++++++++----
> > >   1 file changed, 10 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 2fe7a3188282..2f4c5b2e674d 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -190,6 +190,8 @@ struct virtnet_info {
> > >   =09/* # of XDP queue pairs currently used by the driver */
> > >   =09u16 xdp_queue_pairs;
> > > +=09bool can_do_xdp_tx;
> > > +
> > >   =09/* I like... big packets and I cannot lie! */
> > >   =09bool big_packets;
> > > @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct
> > > net_device *dev,
> > >   =09=09=09len =3D xdp.data_end - xdp.data;
> > >   =09=09=09break;
> > >   =09=09case XDP_TX:
> > > +=09=09=09if (!vi->can_do_xdp_tx)
> > > +=09=09=09=09goto err_xdp;
> >=20
> >=20
> > I wonder if using spinlock to synchronize XDP_TX is better than droppin=
g
> > here?
> >=20
> > Thanks
>=20
> I think it's less a problem with locking, and more a problem
> with queue being potentially full and XDP being unable to
> transmit.

I'm not sure we need care about this. Even XDP_TX with dedicated queue
can meet this. And XDP generic work like this.

>=20
> From that POV just sharing the queue would already be better than just
> an uncondiitonal drop, however I think this is not what XDP users came
> to expect. So at this point, partitioning the queue might be reasonable.
> When XDP attaches we could block until queue is mostly empty.

This mean XDP_TX have a higher priority which I'm not sure is good.

> However,
> how exactly to partition the queue remains open.

It would be not easy unless we have support from virtio layer.


> Maybe it's reasonable
> to limit number of RX buffers to achieve balance.
>

If I understand this correctly, this can only help to throttle
XDP_TX. But we may have XDP_REDIRECT ...

So consider either dropping or sharing is much better than not enable
XDP, we may start from them.

Thanks

