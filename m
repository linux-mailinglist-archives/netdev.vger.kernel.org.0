Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB01AF043C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390402AbfKERom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:44:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25802 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390248AbfKERol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572975880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=46u2l9L8Y05Qm2/MKUXXTgxpERoN9tnFQ6gH6kXcl6k=;
        b=VceUb5MQBplMp5ya6r8thW+i2Q4N1HGx2vsb6t8ZMd+zNPDuPCxXqC0iEOsqWUPR1G8boC
        jzT/H6zlofg2Kypm9gMh/j38lwMKpewHJ+5QHF+ZfYybPYq/X5tcyFg2nROnymTCb1Bw+x
        DcUkVUcLBo7wzFFo5sg9TQ764Y8/VYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-Fsp1fWk7MS6L-3vtqVbnMQ-1; Tue, 05 Nov 2019 12:44:36 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DEFC477;
        Tue,  5 Nov 2019 17:44:32 +0000 (UTC)
Received: from x1.home (ovpn-116-110.phx2.redhat.com [10.3.116.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D1385D9CD;
        Tue,  5 Nov 2019 17:44:19 +0000 (UTC)
Date:   Tue, 5 Nov 2019 10:44:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V8 3/6] mdev: introduce device specific ops
Message-ID: <20191105104418.1735d800@x1.home>
In-Reply-To: <20191105175025.1a620844.cohuck@redhat.com>
References: <20191105093240.5135-1-jasowang@redhat.com>
        <20191105093240.5135-4-jasowang@redhat.com>
        <20191105175025.1a620844.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Fsp1fWk7MS6L-3vtqVbnMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 17:50:25 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue,  5 Nov 2019 17:32:37 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>=20
> > Currently, except for the create and remove, the rest of
> > mdev_parent_ops is designed for vfio-mdev driver only and may not help
> > for kernel mdev driver. With the help of class id, this patch
> > introduces device specific callbacks inside mdev_device
> > structure. This allows different set of callback to be used by
> > vfio-mdev and virtio-mdev.
> >=20
> > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  .../driver-api/vfio-mediated-device.rst       | 35 +++++++++----
> >  MAINTAINERS                                   |  1 +
> >  drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 ++++---
> >  drivers/s390/cio/vfio_ccw_ops.c               | 18 ++++---
> >  drivers/s390/crypto/vfio_ap_ops.c             | 14 +++--
> >  drivers/vfio/mdev/mdev_core.c                 | 24 ++++++++-
> >  drivers/vfio/mdev/mdev_private.h              |  5 ++
> >  drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
> >  include/linux/mdev.h                          | 43 ++++-----------
> >  include/linux/mdev_vfio_ops.h                 | 52 +++++++++++++++++++
> >  samples/vfio-mdev/mbochs.c                    | 20 ++++---
> >  samples/vfio-mdev/mdpy.c                      | 20 ++++---
> >  samples/vfio-mdev/mtty.c                      | 18 ++++---
> >  13 files changed, 206 insertions(+), 99 deletions(-)
> >  create mode 100644 include/linux/mdev_vfio_ops.h
> >  =20
>=20
> (...)
>=20
> > @@ -172,10 +163,34 @@ that a driver should use to unregister itself wit=
h the mdev core driver::
> > =20
> >  =09extern void mdev_unregister_device(struct device *dev);
> > =20
> > -It is also required to specify the class_id in create() callback throu=
gh::
> > +As multiple types of mediated devices may be supported, class id needs
> > +to be specified in the create callback(). This could be done =20
>=20
> The brackets should probably go behind 'create'?
>=20
> > +explicitly for the device that does not use on mdev bus for its =20
>=20
> "for devices that do not use the mdev bus" ?
>=20
> But why wouldn't they? I feel like I've missed some discussion here :/

The device ops provide a route through mdev-core for known callbacks,
which is primarily useful when we have 1:N relation between mdev bus
driver and vendor drivers.  The obvious example here is vfio-mdev,
where we have GVT-g, vfio-ap, vfio-ccw, NVIDIA GRID, and various sample
drivers all advertising vfio-mdev support via their class id.  However,
if we have a tightly coupled vendor driver and mdev bus driver, as the
mlx5 support that Parav is developing, the claim is that they prefer
not to expose any device ops and intend to interact directly with the
mdev device.  At least that's my understanding.  Thanks,

Alex

> > +operation through:
> > =20
> >  =09int mdev_set_class(struct mdev_device *mdev, u16 id);
> > =20
> > +For the device that uses on the mdev bus for its operation, the class =
=20
>=20
> "For devices that use the mdev bus..."
>=20
> But same comment as above.
>=20
> > +should provide helper function to set class id and device specific
> > +ops. E.g for vfio-mdev devices, the function to be called is::
> > +
> > +=09int mdev_set_vfio_ops(struct mdev_device *mdev,
> > +                              const struct mdev_vfio_device_ops *vfio_=
ops);
> > +
> > +The class id (set by this function to MDEV_CLASS_ID_VFIO) is used to
> > +match a device with an mdev driver via its id table. The device
> > +specific callbacks (specified in *vfio_ops) are obtainable via
> > +mdev_get_vfio_ops() (for use by the mdev bus driver). A vfio-mdev
> > +device (class id MDEV_CLASS_ID_VFIO) uses the following
> > +device-specific ops:
> > +
> > +* open: open callback of vfio mediated device
> > +* close: close callback of vfio mediated device
> > +* ioctl: ioctl callback of vfio mediated device
> > +* read : read emulation callback
> > +* write: write emulation callback
> > +* mmap: mmap emulation callback
> > +
> >  Mediated Device Management Interface Through sysfs
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D =20
>=20
> Otherwise, looks good.

