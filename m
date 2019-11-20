Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA95104215
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfKTR3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:29:07 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58831 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727784AbfKTR3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:29:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574270945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FM5VdnRbXM1pwoUeS+uKGn/v8Dwx+uJBhZdqVHKSqgY=;
        b=ZZSk8PeDkmCYC3OJMej/fmZe9r1GWZJdBn8hKTpLTJH01C2ZjR1pWIDk4kR6OoU2dcgDoU
        om32Vz8ydTaNw2/C6HHr2xGw/PT2owUQJmEw4JhmZ/9C7MoteMXvgh5h1XpiTJ7cH0yIkA
        BsVQWctzgKOwIll1eCWOQf+2GedzoVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-9vHOO7QHO2yHep94Ojfm7w-1; Wed, 20 Nov 2019 12:29:02 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C1D4107ACE3;
        Wed, 20 Nov 2019 17:29:00 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF85B19EE3;
        Wed, 20 Nov 2019 17:28:56 +0000 (UTC)
Date:   Wed, 20 Nov 2019 10:28:56 -0700
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
Message-ID: <20191120102856.7e01e2e2@x1.home>
In-Reply-To: <20191120133835.GC22515@ziepe.ca>
References: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191119164632.GA4991@ziepe.ca>
        <20191119134822-mutt-send-email-mst@kernel.org>
        <20191119191547.GL4991@ziepe.ca>
        <20191119163147-mutt-send-email-mst@kernel.org>
        <20191119231023.GN4991@ziepe.ca>
        <20191119191053-mutt-send-email-mst@kernel.org>
        <20191120014653.GR4991@ziepe.ca>
        <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
        <20191120133835.GC22515@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 9vHOO7QHO2yHep94Ojfm7w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 09:38:35 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Nov 19, 2019 at 10:59:20PM -0500, Jason Wang wrote:
>=20
> > > > The interface between vfio and userspace is
> > > > based on virtio which is IMHO much better than
> > > > a vendor specific one. userspace stays vendor agnostic. =20
> > >=20
> > > Why is that even a good thing? It is much easier to provide drivers
> > > via qemu/etc in user space then it is to make kernel upgrades. We've
> > > learned this lesson many times. =20
> >=20
> > For upgrades, since we had a unified interface. It could be done
> > through:
> >=20
> > 1) switch the datapath from hardware to software (e.g vhost)
> > 2) unload and load the driver
> > 3) switch teh datapath back
> >=20
> > Having drivers in user space have other issues, there're a lot of
> > customers want to stick to kernel drivers. =20
>=20
> So you want to support upgrade of kernel modules, but runtime
> upgrading the userspace part is impossible? Seems very strange to me.
>=20
> > > This is why we have had the philosophy that if it doesn't need to be
> > > in the kernel it should be in userspace. =20
> >=20
> > Let me clarify again. For this framework, it aims to support both
> > kernel driver and userspce driver. For this series, it only contains
> > the kernel driver part. What it did is to allow kernel virtio driver
> > to control vDPA devices. Then we can provide a unified interface for
> > all of the VM, containers and bare metal. For this use case, I don't
> > see a way to leave the driver in userspace other than injecting
> > traffic back through vhost/TAP which is ugly. =20
>=20
> Binding to the other kernel virtio drivers is a reasonable
> justification, but none of this comes through in the patch cover
> letters or patch commit messages.
>=20
> > > > That has lots of security and portability implications and isn't
> > > > appropriate for everyone. =20
> > >=20
> > > This is already using vfio. It doesn't make sense to claim that using
> > > vfio properly is somehow less secure or less portable.
> > >=20
> > > What I find particularly ugly is that this 'IFC VF NIC' driver
> > > pretends to be a mediated vfio device, but actually bypasses all the
> > > mediated device ops for managing dma security and just directly plugs
> > > the system IOMMU for the underlying PCI device into vfio. =20
> >=20
> > Well, VFIO have multiple types of API. The design is to stick the VFIO
> > DMA model like container work for making DMA API work for userspace
> > driver. =20
>=20
> Well, it doesn't, that model, for security, is predicated on vfio
> being the exclusive owner of the device. For instance if the kernel
> driver were to perform DMA as well then security would be lost.
>=20
> > > I suppose this little hack is what is motivating this abuse of vfio i=
n
> > > the first place?
> > >=20
> > > Frankly I think a kernel driver touching a PCI function for which vfi=
o
> > > is now controlling the system iommu for is a violation of the securit=
y
> > > model, and I'm very surprised AlexW didn't NAK this idea.
> > >
> > > Perhaps it is because none of the patches actually describe how the
> > > DMA security model for this so-called mediated device works? :(
> > >
> > > Or perhaps it is because this submission is split up so much it is
> > > hard to see what is being proposed? (I note this IFC driver is the
> > > first user of the mdev_set_iommu_device() function) =20
> >=20
> > Are you objecting the mdev_set_iommu_deivce() stuffs here? =20
>=20
> I'm questioning if it fits the vfio PCI device security model, yes.

The mdev IOMMU backing device model is for when an mdev device has
IOMMU based isolation, either via the PCI requester ID or via requester
ID + PASID.  For example, an SR-IOV VF may be used by a vendor to
provide IOMMU based translation and isolation, but the VF may not be
complete otherwise to provide a self contained device.  It might
require explicit coordination and interaction with the PF driver, ie.
mediation.  The IOMMU backing device is certainly not meant to share an
IOMMU address space with host drivers, except as necessary for the
mediation of the device.  The vfio model manages the IOMMU domain of
the backing device exclusively, any attempt to dual-host the device
respective to the IOMMU should fault in the dma/iommu-ops.  Thanks,

Alex

