Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19621439B9D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhJYQga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:36:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233913AbhJYQga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635179647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynlrOvDkwL5I16uhJfJEmQ9iYxzs+WVm4ZH555IrioY=;
        b=DZ8hU244YouFZnIh51uEwlB1VAU3F6fBXzg2BLwVFu9cDGYrMp3/gA77hV7v98dzL+ojVU
        K3J6n8vhKxF1IG2nN+GVjYhXieGmg3StAy6FCFrupWK6VcjlNqZ/Kx/65qFmaqa4FKC4fI
        uXbSS1LwL/Gjnzv4UxyvxINJii/1muE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-uckCM272PWWKwztGn8HAYw-1; Mon, 25 Oct 2021 12:34:05 -0400
X-MC-Unique: uckCM272PWWKwztGn8HAYw-1
Received: by mail-wm1-f72.google.com with SMTP id r205-20020a1c44d6000000b0032cb058fe13so1767882wma.7
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ynlrOvDkwL5I16uhJfJEmQ9iYxzs+WVm4ZH555IrioY=;
        b=XALw6Hx5kRCchy49qXJUVRwbUVrIDk/09N/zlusIqyj0VgNU4StWafzP4T2TOVJ/0m
         t9lv7QpLKjhq05uR2haigcR+kjyKtk0YHnA8v5XyHwXo6indezUp501dYfKOC33gvbGy
         cen73CEOe8YUDffn/91lUU1Gj2J/6ePYcgl3/wTvefQHorJFj7kf2xU6+fX6wUwWR5ds
         /oO23KIzG6Mg0haHIpu1xuM2ptOpwBJDcdNlcba6ANA4qEXXnJLeSNEWzwuSCbsSUGJo
         tmu27dijdWkEuj1QHQ7ymPZK74/sKD86B/gCJ+sSccv8IaTcZVN49V/irlSTSk97Jidx
         io1A==
X-Gm-Message-State: AOAM530oNPFhl2Zs0Z7UmPUNPoVMSf7k77ZDrE4aha8DPshjTQ+KiYbX
        lc8Kx1kk31xPvQDSOIyeDe+nex9CAAO4Vg5M9Jl/qLefNUPWQT6TpzwirS2kFuD28C9lS5MJ9Cv
        z0XyvnxZzTfjZPBCb
X-Received: by 2002:a1c:1f17:: with SMTP id f23mr13074623wmf.125.1635179644509;
        Mon, 25 Oct 2021 09:34:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4mcLAz7awLLqXAZYrdfxP8MmMW/541UPPqAs48umNwcoQAJHMARVeyspPwbjDaQyAkZNijQ==
X-Received: by 2002:a1c:1f17:: with SMTP id f23mr13074595wmf.125.1635179644281;
        Mon, 25 Oct 2021 09:34:04 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id 19sm10487749wmb.24.2021.10.25.09.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:34:03 -0700 (PDT)
Date:   Mon, 25 Oct 2021 17:34:01 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <YXbceaVo0q6hOesg@work-vm>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211020105230.524e2149.alex.williamson@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> [Cc +dgilbert, +cohuck]
>=20
> On Wed, 20 Oct 2021 11:28:04 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>=20
> > On 10/20/2021 2:04 AM, Jason Gunthorpe wrote:
> > > On Tue, Oct 19, 2021 at 02:58:56PM -0600, Alex Williamson wrote: =20
> > >> I think that gives us this table:
> > >>
> > >> |   NDMA   | RESUMING |  SAVING  |  RUNNING |
> > >> +----------+----------+----------+----------+ ---
> > >> |     X    |     0    |     0    |     0    |  ^
> > >> +----------+----------+----------+----------+  |
> > >> |     0    |     0    |     0    |     1    |  |
> > >> +----------+----------+----------+----------+  |
> > >> |     X    |     0    |     1    |     0    |
> > >> +----------+----------+----------+----------+  NDMA value is either =
compatible
> > >> |     0    |     0    |     1    |     1    |  to existing behavior =
or don't
> > >> +----------+----------+----------+----------+  care due to redundanc=
y vs
> > >> |     X    |     1    |     0    |     0    |  !_RUNNING/INVALID/ERR=
OR
> > >> +----------+----------+----------+----------+
> > >> |     X    |     1    |     0    |     1    |  |
> > >> +----------+----------+----------+----------+  |
> > >> |     X    |     1    |     1    |     0    |  |
> > >> +----------+----------+----------+----------+  |
> > >> |     X    |     1    |     1    |     1    |  v
> > >> +----------+----------+----------+----------+ ---
> > >> |     1    |     0    |     0    |     1    |  ^
> > >> +----------+----------+----------+----------+  Desired new useful ca=
ses
> > >> |     1    |     0    |     1    |     1    |  v
> > >> +----------+----------+----------+----------+ ---
> > >>
> > >> Specifically, rows 1, 3, 5 with NDMA =3D 1 are valid states a user c=
an
> > >> set which are simply redundant to the NDMA =3D 0 cases. =20
> > > It seems right
> > > =20
> > >> Row 6 remains invalid due to lack of support for pre-copy (_RESUMING
> > >> | _RUNNING) and therefore cannot be set by userspace.  Rows 7 & 8
> > >> are error states and cannot be set by userspace. =20
> > > I wonder, did Yishai's series capture this row 6 restriction? Yishai?=
 =20
> >=20
> >=20
> > It seems so,=A0 by using the below check which includes the=20
> > !VFIO_DEVICE_STATE_VALID clause.
> >=20
> > if (old_state =3D=3D VFIO_DEVICE_STATE_ERROR ||
> >  =A0=A0=A0 =A0=A0=A0 !VFIO_DEVICE_STATE_VALID(state) ||
> >  =A0=A0=A0 =A0=A0=A0 (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
> >  =A0=A0=A0 =A0=A0=A0 return -EINVAL;
> >=20
> > Which is:
> >=20
> > #define VFIO_DEVICE_STATE_VALID(state) \
> >  =A0=A0=A0 (state & VFIO_DEVICE_STATE_RESUMING ? \
> >  =A0=A0=A0 (state & VFIO_DEVICE_STATE_MASK) =3D=3D VFIO_DEVICE_STATE_RE=
SUMING : 1)
> >=20
> > > =20
> > >> Like other bits, setting the bit should be effective at the completi=
on
> > >> of writing device state.  Therefore the device would need to flush a=
ny
> > >> outbound DMA queues before returning. =20
> > > Yes, the device commands are expected to achieve this.
> > > =20
> > >> The question I was really trying to get to though is whether we have=
 a
> > >> supportable interface without such an extension.  There's currently
> > >> only an experimental version of vfio migration support for PCI devic=
es
> > >> in QEMU (afaik), =20
> > > If I recall this only matters if you have a VM that is causing
> > > migratable devices to interact with each other. So long as the devices
> > > are only interacting with the CPU this extra step is not strictly
> > > needed.
> > >
> > > So, single device cases can be fine as-is
> > >
> > > IMHO the multi-device case the VMM should probably demand this support
> > > from the migration drivers, otherwise it cannot know if it is safe for
> > > sure.
> > >
> > > A config option to override the block if the admin knows there is no
> > > use case to cause devices to interact - eg two NVMe devices without
> > > CMB do not have a useful interaction.
> > > =20
> > >> so it seems like we could make use of the bus-master bit to fill
> > >> this gap in QEMU currently, before we claim non-experimental
> > >> support, but this new device agnostic extension would be required
> > >> for non-PCI device support (and PCI support should adopt it as
> > >> available).  Does that sound right?  Thanks, =20
> > > I don't think the bus master support is really a substitute, tripping
> > > bus master will stop DMA but it will not do so in a clean way and is
> > > likely to be non-transparent to the VM's driver.
> > >
> > > The single-device-assigned case is a cleaner restriction, IMHO.
> > >
> > > Alternatively we can add the 4th bit and insist that migration drivers
> > > support all the states. I'm just unsure what other HW can do, I get
> > > the feeling people have been designing to the migration description in
> > > the header file for a while and this is a new idea.
>=20
> I'm wondering if we're imposing extra requirements on the !_RUNNING
> state that don't need to be there.  For example, if we can assume that
> all devices within a userspace context are !_RUNNING before any of the
> devices begin to retrieve final state, then clearing of the _RUNNING
> bit becomes the device quiesce point and the beginning of reading
> device data is the point at which the device state is frozen and
> serialized.  No new states required and essentially works with a slight
> rearrangement of the callbacks in this series.  Why can't we do that?

So without me actually understanding your bit encodings that closely, I
think the problem is we have to asusme that any transition takes time.
=46rom the QEMU point of view I think the requirement is when we stop the
machine (vm_stop_force_state(RUN_STATE_FINISH_MIGRATE) in
migration_completion) that at the point that call returns (with no
error) all devices are idle.  That means you need a way to command the
device to go into the stopped state, and probably another to make sure
it's got there.

Now, you could be a *little* more sloppy; you could allow a device carry
on doing stuff purely with it's own internal state up until the point
it needs to serialise; but that would have to be strictly internal state
only - if it can change any other devices state (or issue an interrupt,
change RAM etc) then you get into ordering issues on the serialisation
of multiple devices.

Dave

> Maybe a clarification of the uAPI spec is sufficient to achieve this,
> ex. !_RUNNING devices may still update their internal state machine
> based on external access.  Userspace is expected to quiesce all external
> access prior to initiating the retrieval of the final device state from
> the data section of the migration region.  Failure to do so may result
> in inconsistent device state or optionally the device driver may induce
> a fault if a quiescent state is not maintained.
>=20
> > Just to be sure,
> >=20
> > We refer here to some future functionality support with this extra 4th=
=20
> > bit but it doesn't enforce any change in the submitted code, right ?
> >=20
> > The below code uses the (state & ~MLX5VF_SUPPORTED_DEVICE_STATES) claus=
e=20
> > which fails any usage of a non-supported bit as of this one.
> >=20
> > if (old_state =3D=3D VFIO_DEVICE_STATE_ERROR ||
> >  =A0=A0=A0 =A0=A0=A0 !VFIO_DEVICE_STATE_VALID(state) ||
> >  =A0=A0=A0 =A0=A0=A0 (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
> >  =A0=A0=A0 =A0=A0=A0 return -EINVAL;
>=20
> Correct, userspace shouldn't be setting any extra bits unless we
> advertise support, such as via a capability or flag.  Drivers need to
> continue to sanitize user input to validate yet-to-be-defined bits are
> not accepted from userspace or else we risk not being able to define
> them later without breaking userspace.  Thanks,
>=20
> Alex
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

