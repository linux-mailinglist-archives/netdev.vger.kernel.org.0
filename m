Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC022F671E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbhANRNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbhANRNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 12:13:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE96623B31;
        Thu, 14 Jan 2021 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610644356;
        bh=Ks55mQXoAeg+ag0q8XZoSvGVsUpHSJCQXqPKpmvWRXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=szGajKBxFN6BkeKJ8IHP9v3IbJ2c4Bgj2Py/EUopZYESKNeGY2bTXwFxF9azmSt0F
         27sUo0sO21wBcXZZze2Ysg+ENmdl6ilQGtVj7dMu6Dzx/Ikf6fH9e85tmg2C8YS66y
         dcrCsG6wVSYIcVkXV0hfx6zzY5BLARe2ohtmyS+xxSkgqZt6GbY8m1iO6h85GG85F8
         /VK8G60AMnDVAie2oAmePV3BrfUIKgvT+eRrLrUlcNTiPLygiwhWbKxhDuA9l5wlup
         kx0hBD6FShl+Exq2Da56E7oRtr3mCgBAxGNy4YVVe2iNv2CfES9YvIaC8u8nPFZAAN
         /KlE+1QZ0SUeg==
Date:   Thu, 14 Jan 2021 19:12:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next v1 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210114171232.GB944463@unreal>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-2-leon@kernel.org>
 <CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com>
 <20210112063925.GC4678@unreal>
 <CAKgT0Udxd01agBMruooMi8TfAE+QkMt8n7-a2QrZ7Pj6-oFEAg@mail.gmail.com>
 <20210113060938.GF4678@unreal>
 <CAKgT0UecBX+LTR9GuxFb=P+pcUkjU5RYNNjeynExS-9Pik1Hsg@mail.gmail.com>
 <20210114071649.GL4678@unreal>
 <CAKgT0UdPZvSf0qSsU1NGcVcK_j6rPZQ8YT_UcygU+2FEq_dGpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UdPZvSf0qSsU1NGcVcK_j6rPZQ8YT_UcygU+2FEq_dGpQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 08:51:22AM -0800, Alexander Duyck wrote:
> On Wed, Jan 13, 2021 at 11:16 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Jan 13, 2021 at 12:00:00PM -0800, Alexander Duyck wrote:
> > > On Tue, Jan 12, 2021 at 10:09 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Tue, Jan 12, 2021 at 01:59:51PM -0800, Alexander Duyck wrote:
> > > > > On Mon, Jan 11, 2021 at 10:39 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > >
> > > > > > On Mon, Jan 11, 2021 at 11:30:33AM -0800, Alexander Duyck wrote:
> > > > > > > On Sun, Jan 10, 2021 at 7:12 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > > >
> > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > >
>
> <snip>
>
> > >
> > > > >
> > > > > Also I am not a big fan of the VF groping around looking for a PF
> > > > > interface as it means the interface will likely be exposed in the
> > > > > guest as well, but it just won't work.
> > > >
> > > > If you are referring to VF exposed to the VM, so in this case VF must be
> > > > bound too vfio driver, or any other driver, and won't allow MSI-X change.
> > > > If you are referring to PF exposed to the VM, it is very unlikely scenario
> > > > in real world and reserved for braves among us. Even in this case, the
> > > > set MSI-X won't work, because PF will be connected to the hypervisor driver
> > > > that doesn't support set_msix.
> > > >
> > > > So both cases are handled.
> > >
> > > I get that they are handled. However I am not a huge fan of the sysfs
> > > attributes for one device being dependent on another device. When you
> > > have to start searching for another device it just makes things messy.
> >
> > This is pretty common way, nothing new here.
>
> This is how writable fields within the device are handled. I am pretty
> sure this is the first sysfs entry that is providing a workaround via
> a device firmware to make the field editable that wasn't intended to
> be.
>
> So if in the future I define a device that has an MMIO register that
> allows me to edit configuration space should I just tie it into the
> same framework? That is kind of where I am going with my objection to
> this. It just seems like you are adding a backdoor to allow editing
> read-only configuration options.

I have no objections as long as your new sysfs will make sense and will
be acceptable by PCI community.

>
> > >
> > > > >
> > > > > > >
> > > > > > > If you are calling this on the VFs then it doesn't really make any
> > > > > > > sense anyway since the VF is not a "VF PCI dev representor" and
> > > > > > > shouldn't be treated as such. In my opinion if we are going to be
> > > > > > > doing per-port resource limiting that is something that might make
> > > > > > > more sense as a part of the devlink configuration for the VF since the
> > > > > > > actual change won't be visible to an assigned device.
> > > > > >
> > > > > > https://lore.kernel.org/linux-pci/20210112061535.GB4678@unreal/
> > > > >
> > > > > So the question I would have is if we are spawning the VFs and
> > > > > expecting them to have different configs or the same configuration?
> > > >
> > > > By default, they have same configuration.
> > > >
> > > > > I'm assuming in your case you are looking for a different
> > > > > configuration per port. Do I have that correct?
> > > >
> > > > No, per-VF as represents one device in the PCI world. For example, mlx5
> > > > can have more than one physical port.
> > >
> > > Sorry, I meant per virtual function, not per port.
> >
> > Yes, PCI spec is clear, MSI-X vector count is per-device and in our case
> > it means per-VF.
>
> I think you overlooked the part about it being "read-only". It isn't
> really meant to be changed and that is what this patch set is
> providing.

We doesn't allow writes to this field, but setting "hint" to the HW on
the proper resource provisioning.

>
> > >
> > > > >
> > > > > Where this gets ugly is that SR-IOV assumes a certain uniformity per
> > > > > VF so doing a per-VF custom limitation gets ugly pretty quick.
> > > >
> > > > I don't find any support for this "uniformity" claim in the PCI spec.
> > >
> > > I am referring to the PCI configuration space. Each VF ends up with
> > > some fixed amount of MMIO resources per function. So typically when
> > > you spawn VFs we had things setup so that all you do is say how many
> > > you want.
> > >
> > > > > I wonder if it would make more sense if we are going this route to just
> > > > > define a device-tree like schema that could be fed in to enable VFs
> > > > > instead of just using echo X > sriov_numvfs and then trying to fix
> > > > > things afterwards. Then you could define this and other features that
> > > > > I am sure you would need in the future via json-schema like is done in
> > > > > device-tree and write it once enabling the set of VFs that you need.
> > > >
> > > > Sorry, but this is overkill, it won't give us much and it doesn't fit
> > > > the VF usage model at all.
> > > >
> > > > Right now, all heavy users of SR-IOV are creating many VFs up to the maximum.
> > > > They do it with autoprobe disabled, because it is too time consuming to wait
> > > > till all VFs probe themselves and unbind them later.
> > > >
> > > > After that, they wait for incoming request to provision VM on VF, they set MAC
> > > > address, change MSI-X according to VM properties and bind that VF to new VM.
> > > >
> > > > So MSI-X change is done after VFs were created.
> > >
> > > So if I understand correctly based on your comments below you are
> > > dynamically changing the VF's MSI-X configuration space then?
> >
> > I'm changing "Table Size" from "7.7.2.2 Message Control Register for
> > MSI-X (Offset 02h)" and nothing more.
> >
> > If you do raw PCI read before and after, only this field will be changed.
>
> I would hope there is much more going on. Otherwise the VF hardware
> will be exploitable by a malicious driver in the guest since you could
> read/write to registers beyond the table and see some result. I am
> assuming the firmware doesn't allow triggering of any interrupts
> beyond the ones defined as being in the table.

You are talking about internal FW implementation, which is of course
secure. I'm talking about PCI config space.

Thanks
