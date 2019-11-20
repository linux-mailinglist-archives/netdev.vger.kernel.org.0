Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F4010464C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKTWHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:07:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27102 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725819AbfKTWHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 17:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574287662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKtm25Ps4MeWjgK6jPgD7e0SXC/v+lNrkASHkARakjI=;
        b=PPC0N1e9BqP+dzuId8oZqBBoSCsTlCwYd4MqVdF2t3pbU9hJJZ7YUbLCwEmZT3G8omSlx5
        iS7efD+dNS3MHx9HOnB55w/q6+m1SASqovYq/IaYI0R7ZPS21A2Yrs+/laoCoTflltgcy9
        7N2WzSUKtmT/9MKLgYe7suVnnk9xHmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-bKikakWVP_mL_hSahyl8og-1; Wed, 20 Nov 2019 17:07:39 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A97C801E74;
        Wed, 20 Nov 2019 22:07:37 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6306F5F923;
        Wed, 20 Nov 2019 22:07:33 +0000 (UTC)
Date:   Wed, 20 Nov 2019 15:07:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120150732.2fffa141@x1.home>
In-Reply-To: <20191120181108.GJ22515@ziepe.ca>
References: <20191119164632.GA4991@ziepe.ca>
        <20191119134822-mutt-send-email-mst@kernel.org>
        <20191119191547.GL4991@ziepe.ca>
        <20191119163147-mutt-send-email-mst@kernel.org>
        <20191119231023.GN4991@ziepe.ca>
        <20191119191053-mutt-send-email-mst@kernel.org>
        <20191120014653.GR4991@ziepe.ca>
        <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
        <20191120133835.GC22515@ziepe.ca>
        <20191120102856.7e01e2e2@x1.home>
        <20191120181108.GJ22515@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: bKikakWVP_mL_hSahyl8og-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 14:11:08 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, Nov 20, 2019 at 10:28:56AM -0700, Alex Williamson wrote:
> > > > Are you objecting the mdev_set_iommu_deivce() stuffs here?   =20
> > >=20
> > > I'm questioning if it fits the vfio PCI device security model, yes. =
=20
> >=20
> > The mdev IOMMU backing device model is for when an mdev device has
> > IOMMU based isolation, either via the PCI requester ID or via requester
> > ID + PASID.  For example, an SR-IOV VF may be used by a vendor to
> > provide IOMMU based translation and isolation, but the VF may not be
> > complete otherwise to provide a self contained device.  It might
> > require explicit coordination and interaction with the PF driver, ie.
> > mediation.   =20
>=20
> In this case the PF does not look to be involved, the ICF kernel
> driver is only manipulating registers in the same VF that the vfio
> owns the IOMMU for.

The mdev_set_iommu_device() call is probably getting caught up in the
confusion of mdev as it exists today being vfio specific.  What I
described in my reply is vfio specific.  The vfio iommu backend is
currently the only code that calls mdev_get_iommu_device(), JasonW
doesn't use it in the virtio-mdev code, so this seems like a stray vfio
specific interface that's setup by IFC but never used.

> This is why I keep calling it a "so-called mediated device" because it
> is absolutely not clear what the kernel driver is mediating. Nearly
> all its work is providing a subsystem-style IOCTL interface under the
> existing vfio multiplexer unrelated to vfio requirements for DMA.

Names don't always evolve well to what an interface becomes, see for
example vfio.  However, even in the vfio sense of mediated devices we
have protocol translation.  The mdev vendor driver translates vfio API
callbacks into hardware specific interactions.  Is this really much
different?

> > The IOMMU backing device is certainly not meant to share an IOMMU
> > address space with host drivers, except as necessary for the
> > mediation of the device.  The vfio model manages the IOMMU domain of
> > the backing device exclusively, any attempt to dual-host the device
> > respective to the IOMMU should fault in the dma/iommu-ops.  Thanks, =20
>=20
> Sounds more reasonable if the kernel dma_ops are prevented while vfio
> is using the device.

AFAIK we can't mix DMA ops and IOMMU ops at the same time and the
domain information necessary for the latter is owned within the vfio
IOMMU backend.

> However, to me it feels wrong that just because a driver wishes to use
> PASID or IOMMU features it should go through vfio and mediated
> devices.

I don't think I said this.  IOMMU backing of an mdev is an acceleration
feature as far as vfio-mdev is concerned.  There are clearly other ways
to use the IOMMU.

> It is not even necessary as we have several examples already of
> drivers using these features without vfio.

Of course.

> I feel like mdev is suffering from mission creep. I see people
> proposing to use mdev for many wild things, the Mellanox SF stuff in
> the other thread and this 'virtio subsystem' being the two that have
> come up publicly this month.

Tell me about it... ;)
=20
> Putting some boundaries on mdev usage would really help people know
> when to use it. My top two from this discussion would be:
>=20
> - mdev devices should only bind to vfio. It is not a general kernel
>   driver matcher mechanism. It is not 'virtual-bus'.

I think this requires the driver-core knowledge to really appreciate.
Otherwise there's apparently a common need to create sub-devices and
without closer inspection of the bus:driver API contract, it's too easy
to try to abstract the device:driver API via the bus.  mdev already has
a notion that the device itself can use any API, but the interface to
the bus is the vendor provided, vfio compatible callbacks.

> - mdev & vfio are not a substitute for a proper kernel subsystem. We
>   shouldn't export a complex subsystem-like ioctl API through
>   vfio ioctl extensions. Make a proper subsystem, it is not so hard.

This is not as clear to me, is "ioctl" used once or twice too often or
are you describing a defined structure of callbacks as an ioctl API?
The vfio mdev interface is just an extension of the file descriptor
based vfio device API.  The device needs to handle actual ioctls, but
JasonW's virtio-mdev series had their own set of callbacks.  Maybe a
concrete example of this item would be helpful.  Thanks,

Alex

