Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569AA2F8C37
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 09:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbhAPIVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 03:21:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbhAPIVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 03:21:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 742EA221E2;
        Sat, 16 Jan 2021 08:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610785236;
        bh=/OMqaqhP24E3ddcv7U8rMRBb7LkJzzz8NXuXj/8AUgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F9hLPMk05F2tOe3ofixPIFTdQYQ/LNk9nJY36XueQwUhtm7NlfC3ObIIfmdyTv8WG
         jXRm8s1vWGjCR7fjWi8KOonR5Xxj2q7uRPpF+1pTwIc12KtbDt5kUd3CqLK8+bVwYO
         Pk3bsuvmpkLpfNgg1fRACQDtyE6F8SirKz52XKMtCNMdUHLRMqquoBCzQyVT0xUGu/
         +1mdz57+kHLgH7ybAKovtLX/E5sQLIZgwvbFVm025vxyq3xRDCml/3TlE5Hmr2epkh
         6TgEGmOLd+NsUud/Q4rYEANrk2cQWg2lvdg6eltG/oI11fV3NUQNqjrP7pukIdGO6k
         NKt4cMsm79VQA==
Date:   Sat, 16 Jan 2021 10:20:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210116082031.GK944463@unreal>
References: <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com>
 <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com>
 <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org>
 <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com>
 <20210115155315.GJ944463@unreal>
 <CAKgT0UdzCqbLwxSnDTtgha+PwTMW5iVb-3VXbwdMNiaAYXyWzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UdzCqbLwxSnDTtgha+PwTMW5iVb-3VXbwdMNiaAYXyWzQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 05:48:59PM -0800, Alexander Duyck wrote:
> On Fri, Jan 15, 2021 at 7:53 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Fri, Jan 15, 2021 at 10:06:19AM -0400, Jason Gunthorpe wrote:
> > > On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:
> > >
> > > > That said, it only works at the driver level. So if the firmware is
> > > > the one that is having to do this it also occured to me that if this
> > > > update happened on FLR that would probably be preferred.
> > >
> > > FLR is not free, I'd prefer not to require it just for some
> > > philosophical reason.
> > >
> > > > Since the mlx5 already supports devlink I don't see any reason why the
> > > > driver couldn't be extended to also support the devlink resource
> > > > interface and apply it to interrupts.
> > >
> > > So you are OK with the PF changing the VF as long as it is devlink not
> > > sysfs? Seems rather arbitary?
> > >
> > > Leon knows best, but if I recall devlink becomes wonky when the VF
> > > driver doesn't provide a devlink instance. How does it do reload of a
> > > VF then?
> > >
> > > I think you end up with essentially the same logic as presented here
> > > with sysfs.
> >
> > The reasons why I decided to go with sysfs are:
> > 1. This MSI-X table size change is applicable to ALL devices in the world,
> > and not only netdev.
>
> In the PCI world MSI-X table size is a read only value. That is why I
> am pushing back on this as a PCI interface.

And it stays read-only.

>
> > 2. This is purely PCI field and apply equally with same logic to all
> > subsystems and not to netdev only.
>
> Again, calling this "purely PCI" is the sort of wording that has me
> concerned. I would prefer it if we avoid that wording. There is much
> more to this than just modifying the table size field. The firmware is
> having to shift resources between devices and this potentially has an
> effect on the entire part, not just one VF.

It is internal to HW implementation, dumb device can solve it differently.

>
> > 3. The sysfs interface is the standard way of configuring PCI/core, not
> > devlink.
>
> This isn't PCI core that is being configured. It is the firmware for
> the device. You are working with resources that are shared between
> multiple functions.

I'm ensuring that "lspci -vv .." will work correctly after such change.
It is PCI core responsibility.

>
> > 4. This is how orchestration software provisioning VFs already. It fits
> > real world usage of SR-IOV, not the artificial one that is proposed during
> > the discussion.
>
> What do you mean this is how they are doing it already? Do you have
> something out-of-tree and that is why you are fighting to keep the
> sysfs? If so that isn't a valid argument.

I have Kubernetes and OpenStack, indeed they are not part of the kernel tree.
They already use sriov_driver_autoprobe sysfs knob to disable autobind
before even starting. They configure MACs and bind VFs through sysfs/netlink
already. For them, the read/write of sysfs that is going to be bound to
the already created VM with known CPU properties, fits perfectly.

>
> > So the idea to use devlink just because mlx5 supports it, sound really
> > wrong to me. If it was other driver from another subsystem without
> > devlink support, the request to use devlink won't never come.
> >
> > Thanks
>
> I am suggesting the devlink resources interface because it would be a
> VERY good fit for something like this. By the definition of it:
> ``devlink`` provides the ability for drivers to register resources, which
> can allow administrators to see the device restrictions for a given
> resource, as well as how much of the given resource is currently
> in use. Additionally, these resources can optionally have configurable size.
> This could enable the administrator to limit the number of resources that
> are used.

It is not resource, but HW objects. The devlink doesn't even see the VFs
as long as they are not bound to the drivers.

This is an example:

[root@vm ~]# echo 0 > /sys/bus/pci/devices/0000\:01\:00.0/sriov_drivers_autoprobe
[root@vm ~]# echo 0 > /sys/bus/pci/devices/0000\:01\:00.0/sriov_numvfs
[ 2370.579711] mlx5_core 0000:01:00.0: E-Switch: Disable: mode(LEGACY), nvfs(2), active vports(3)
[root@vm ~]# echo 2 > /sys/bus/pci/devices/0000\:01\:00.0/sriov_numvfs
[ 2377.663666] mlx5_core 0000:01:00.0: E-Switch: Enable: mode(LEGACY), nvfs(2), active vports(3)
[ 2377.777010] pci 0000:01:00.1: [15b3:101c] type 00 class 0x020000
[ 2377.784903] pci 0000:01:00.2: [15b3:101c] type 00 class 0x020000
[root@vm ~]# devlink dev
pci/0000:01:00.0
[root@vm ~]# lspci |grep nox
01:00.0 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6]
01:00.1 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6 Virtual Function]
01:00.2 Ethernet controller: Mellanox Technologies MT28908 Family [ConnectX-6 Virtual Function]

So despite us having 2 VFs ready to be given to VMs, administrator doesn't
see them as devices.

>
> Even looking over the example usage I don't see there being much to
> prevent you from applying it to this issue. In addition it has the
> idea of handling changes that cannot be immediately applied already
> included. Your current solution doesn't have a good way of handling
> that and instead just aborts with an error.

Yes, because it is HW resource that should be applied immediately to
make sure that it is honored, before it is committed to the users.

It is very tempting to use devlink everywhere, but it is really wrong
tool for this scenario.

Thanks
