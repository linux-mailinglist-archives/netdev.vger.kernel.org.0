Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46774F588D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbfKHUen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:34:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38343 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729617AbfKHUem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573245281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KMSEjXsq99hiNjoujWoEIIjY1ii1GajRovSx/9CzKSI=;
        b=EP/IWnQbFT35K9LL7V04GhTiL6DgsSZFbx4PoTreHJyMM4GTXUNCi5nHSOKfzVfAOedQfJ
        4uzBdknw6eoNWCuzZqnuLzLTGtjtjx2nbT3GkeRN3yXtKoVdush2BINZOGtsszhlTo6N2J
        cnPKPhmsebLt3mDBIIzmXEFusKlckN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-rqU7v7gZOdGJik4OXqMK6g-1; Fri, 08 Nov 2019 15:34:40 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2915800C72;
        Fri,  8 Nov 2019 20:34:37 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37DAA60BE1;
        Fri,  8 Nov 2019 20:34:36 +0000 (UTC)
Date:   Fri, 8 Nov 2019 13:34:35 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108133435.6dcc80bd@x1.home>
In-Reply-To: <20191108201253.GE10956@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: rqU7v7gZOdGJik4OXqMK6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 16:12:53 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
> > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote: =20
> > > > The new intel driver has been having a very similar discussion abou=
t how to
> > > > model their 'multi function device' ie to bind RDMA and other drive=
rs to a
> > > > shared PCI function, and I think that discussion settled on adding =
a new bus?
> > > >=20
> > > > Really these things are all very similar, it would be nice to have =
a clear
> > > > methodology on how to use the device core if a single PCI device is=
 split by
> > > > software into multiple different functional units and attached to d=
ifferent
> > > > driver instances.
> > > >=20
> > > > Currently there is alot of hacking in this area.. And a consistent =
scheme
> > > > might resolve the ugliness with the dma_ops wrappers.
> > > >=20
> > > > We already have the 'mfd' stuff to support splitting platform devic=
es, maybe
> > > > we need to create a 'pci-mfd' to support splitting PCI devices?
> > > >=20
> > > > I'm not really clear how mfd and mdev relate, I always thought mdev=
 was
> > > > strongly linked to vfio.
> > > > =20
> > >
> > > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > > above it is addressing more use case.
> > >=20
> > > I observed that discussion, but was not sure of extending mdev furthe=
r.
> > >=20
> > > One way to do for Intel drivers to do is after series [9].
> > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO
> > > RDMA driver mdev_register_driver(), matches on it and does the probe(=
). =20
> >=20
> > Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> > muddying the purpose of mdevs is not a clear trade off. =20
>=20
> IMHO, mdev has amdev_parent_ops structure clearly intended to link it
> to vfio, so using a mdev for something not related to vfio seems like
> a poor choice.

Unless there's some opposition, I'm intended to queue this for v5.5:

https://www.spinics.net/lists/kvm/msg199613.html

mdev has started out as tied to vfio, but at it's core, it's just a
device life cycle infrastructure with callbacks between bus drivers
and vendor devices.  If virtio is on the wrong path with the above
series, please speak up.  Thanks,

Alex

=20
> I suppose this series is the start and we will eventually see the
> mlx5's mdev_parent_ops filled in to support vfio - but *right now*
> this looks identical to the problem most of the RDMA capable net
> drivers have splitting into a 'core' and a 'function'
>=20
> > IMHO MFD should be of more natural use for Intel, since it's about
> > providing different functionality rather than virtual slices of the
> > same device. =20
>=20
> I don't think the 'different functionality' should matter much.=20
>=20
> Generally these multi-function drivers are build some some common
> 'core' language like queues interrupts, BAR space, etc and then these
> common things can be specialized into netdev, rdma, scsi, etc. So we
> see a general rough design with a core layer managing the raw HW then
> drivers on top of that (including netdev) using that API.
>=20
> The actual layering doesn't come through in the driver model,
> generally people put all the core stuff in with the netdev and then
> try and shuffle the netdev around as the 'handle' for that core API.
>=20
> These SFs are pretty similar in that the core physical driver
> continues to provide some software API support to the SF children (at
> least for mlx it is a small API)
>=20
> For instance mdev has no generic way to learn the BAR struct
> resources, so there is some extra API around the side that does this -
> in this series it is done by hackily co-opting the drvdata to
> something owned by the struct device instead of the device_driver and
> using that to access the API surface on 'struct mlx5_sf *', which
> includes the BAR info and so forth.
>=20
> This is probably the main difference from MFD. At least the few
> drivers I looked at, did not try and expose an SW API from the 'core'
> to the 'part', everything was usual generic driver resource stuff.
>=20
> Jason

