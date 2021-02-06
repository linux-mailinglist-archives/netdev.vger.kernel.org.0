Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF21311D27
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 13:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhBFMnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 07:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBFMnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 07:43:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5226B64ECC;
        Sat,  6 Feb 2021 12:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612615371;
        bh=K+VMkGgrhIx6wRS2S0pCwXsb1Z4BJwuZQMHCICdX/rI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n2bXwtEyKm1iWvMSoEkl8TuiAZuL95DEJbIqTks7TSP/xfjhZaefAhEtiMLTA6qmh
         CeC/5KHkHHc9fm7uBXCmJNjR4/6pkUJmq8KURJoldAvn5qtnHBkSd32keXRI0LTemR
         RkFNPPNXSvwrAhHpJXaGmRnwlBraw26ZiCs+jF5YnRlUH3Sc7STwNnXh0ceJRh1NJT
         a+Zk+ZORs0hNaX7l01HvSF9Xr/GCB05ldulMmB3N3s9YaCYEmb/6ttwLPRyCxwTNpp
         MavejoE9pefcx+9uTQdU2p8RrKRbqd/nakHjT8JJPWveLLsGjYqWuqG2M1Yz2/dk6P
         Cp7QDZz5h0B3A==
Date:   Sat, 6 Feb 2021 14:42:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v5 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210206124247.GF93433@unreal>
References: <20210205173547.GE93433@unreal>
 <20210205225703.GA193188@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205225703.GA193188@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 04:57:03PM -0600, Bjorn Helgaas wrote:
> On Fri, Feb 05, 2021 at 07:35:47PM +0200, Leon Romanovsky wrote:
> > On Thu, Feb 04, 2021 at 03:12:12PM -0600, Bjorn Helgaas wrote:
> > > On Thu, Feb 04, 2021 at 05:50:48PM +0200, Leon Romanovsky wrote:
> > > > On Wed, Feb 03, 2021 at 06:10:39PM -0600, Bjorn Helgaas wrote:
> > > > > On Tue, Feb 02, 2021 at 09:44:29PM +0200, Leon Romanovsky wrote:
> > > > > > On Tue, Feb 02, 2021 at 12:06:09PM -0600, Bjorn Helgaas wrote:
> > > > > > > On Tue, Jan 26, 2021 at 10:57:27AM +0200, Leon Romanovsky wrote:
> > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > >
> > > > > > > > Extend PCI sysfs interface with a new callback that allows
> > > > > > > > configure the number of MSI-X vectors for specific SR-IO VF.
> > > > > > > > This is needed to optimize the performance of newly bound
> > > > > > > > devices by allocating the number of vectors based on the
> > > > > > > > administrator knowledge of targeted VM.
> > > > > > >
> > > > > > > I'm reading between the lines here, but IIUC the point is that you
> > > > > > > have a PF that supports a finite number of MSI-X vectors for use
> > > > > > > by all the VFs, and this interface is to control the distribution
> > > > > > > of those MSI-X vectors among the VFs.
> > >
> > > > > This commit log should describe how *this* device manages this
> > > > > allocation and how the PF Table Size and the VF Table Sizes are
> > > > > related.  Per PCIe, there is no necessary connection between them.
> > > >
> > > > There is no connection in mlx5 devices either. PF is used as a vehicle
> > > > to access VF that doesn't have driver yet. From "table size" perspective
> > > > they completely independent, because PF already probed by driver and
> > > > it is already too late to change it.
> > > >
> > > > So PF table size is static and can be changed through FW utility only.
> > >
> > > This is where description of the device would be useful.
> > >
> > > The fact that you need "sriov_vf_total_msix" to advertise how many
> > > vectors are available and "sriov_vf_msix_count" to influence how they
> > > are distributed across the VFs suggests that these Table Sizes are not
> > > completely independent.
> > >
> > > Can a VF have a bigger Table Size than the PF does?  Can all the VF
> > > Table Sizes added together be bigger than the PF Table Size?  If VF A
> > > has a larger Table Size, does that mean VF B must have a smaller Table
> > > Size?
> >
> > VFs are completely independent devices and their table size can be
> > bigger than PF. FW has two pools, one for PF and another for all VFs.
> > In real world scenarios, every VF will have more MSI-X vectors than PF,
> > which will be distributed by orchestration software.
>
> Well, if the sum of all the VF Table Sizes cannot exceed the size of
> the FW pool for VFs, I would say the VFs are not completely
> independent.  Increasing the Table Size of one VF reduces it for other
> VFs.
>
> This is an essential detail because it's the whole reason behind this
> interface, so sketching this out in the commit log will make this much
> easier to understand.

I think that it is already written, but will recheck.

>
> > > Here's the sequence as I understand it:
> > >
> > >   1) PF driver binds to PF
> > >   2) PF driver enables VFs
> > >   3) PF driver creates /sys/.../<PF>/sriov_vf_total_msix
> > >   4) PF driver creates /sys/.../<VFn>/sriov_vf_msix_count for each VF
> > >   5) Management app reads sriov_vf_total_msix, writes sriov_vf_msix_count
> > >   6) VF driver binds to VF
> > >   7) VF reads MSI-X Message Control (Table Size)
> > >
> > > Is it true that "lspci VF" at 4.1 and "lspci VF" at 5.1 may read
> > > different Table Sizes?  That would be a little weird.
> >
> > Yes, this is the flow. I think differently from you and think this
> > is actual good thing that user writes new msix count and it is shown
> > immediately.
>
> Only weird because per spec Table Size is read-only and in this
> scenario it changes, so it may be surprising, but probably not a huge
> deal.
>
> > > I'm also a little concerned about doing 2 before 3 & 4.  That works
> > > for mlx5 because implements the Table Size adjustment in a way that
> > > works *after* the VFs have been enabled.
> >
> > It is not related to mlx5, but to the PCI spec that requires us to
> > create all VFs at the same time. Before enabling VFs, they don't
> > exist.
>
> Yes.  I can imagine a PF driver that collects characteristics for the
> desired VFs before enabling them, sort of like we already collect the
> *number* of VFs.  But I think your argument for dynamic changes after
> creation below is pretty compelling.

IMHO, the best tool for such pre-configured changes will be devlink.

>
> > > But it seems conceivable that a device could implement vector
> > > distribution in a way that would require the VF Table Sizes to be
> > > fixed *before* enabling VFs.  That would be nice in the sense that the
> > > VFs would be created "fully formed" and the VF Table Size would be
> > > completely read-only as documented.
> >
> > It is not how SR-IOV is used in real world. Cloud providers create many
> > VFs but don't assign those VFs yet. They do it after customer request
> > VM with specific properties (number of CPUs) which means number of MSI-X
> > vectors in our case.
> >
> > All this is done when other VFs already in use and we can't destroy and
> > recreate them at that point of time.
>
> Makes sense, thanks for this insight.  The need to change the MSI-X
> Table Size dynamically while other VFs are in use would also be useful
> in the commit log because it really helps motivate this design.

It is already written, but I will add more info.

>
> > > > > > > > +What:		/sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
> > > > > > > > +Date:		January 2021
> > > > > > > > +Contact:	Leon Romanovsky <leonro@nvidia.com>
> > > > > > > > +Description:
> > > > > > > > +		This file is associated with the SR-IOV PFs.
> > > > > > > > +		It returns a total number of possible to configure MSI-X
> > > > > > > > +		vectors on the enabled VFs.
> > > > > > > > +
> > > > > > > > +		The values returned are:
> > > > > > > > +		 * > 0 - this will be total number possible to consume by VFs,
> > > > > > > > +		 * = 0 - feature is not supported
> > > >
> > > > > Not sure the "= 0" description is necessary here.  If the value
> > > > > returned is the number of MSI-X vectors available for assignment to
> > > > > VFs, "0" is a perfectly legitimate value.  It just means there are
> > > > > none.  It doesn't need to be described separately.
> > > >
> > > > I wanted to help users and remove ambiguity. For example, mlx5 drivers
> > > > will always implement proper .set_...() callbacks but for some devices
> > > > without needed FW support, the value will be 0. Instead of misleading
> > > > users with wrong promise that feature supported but doesn't have
> > > > available vectors, I decided to be more clear. For the users, 0 means, don't
> > > > try, it is not working.
> > >
> > > Oh, you mean "feature is not supported by the FIRMWARE on some mlx5
> > > devices"?  I totally missed that; I thought you meant "not supported
> > > by the PF driver."  Why not have the PF driver detect that the
> > > firmware doesn't support the feature and just not expose the sysfs
> > > files at all in that case?
> >
> > I can do it and will do it, but this behavior will be possible because
> > mlx5 is flexible enough. I imagine that other device won't be so flexible,
> > for example they will decide to "close" this feature because of other
> > SW limitation.
>
> What about something like this?
>
>   This file contains the total number of MSI-X vectors available for
>   assignment to all VFs associated with this PF.  It may be zero if
>   the device doesn't support this functionality.

Sounds good.

>
> Side question: How does user-space use this?  This file contains a
> constant, and there's no interface to learn how many vectors are still
> available in the pool, right?

Right, it is easy for the kernel implementation and easy for the users.
They don't need from the kernel to see exact utilized number.

Every VF has vectors assigned from the beginning and there is no parallel
race between kernel and user space to claim resources in our flow, so at the
point when orchestration will have a chance to run the system will be in steady
state.

Access to the hypervisor with ability to write to sysfs files requires
root permissions and management software already counts number of users,
their CPUs and number of vectors.

>
> I guess the user just has to manage the values written to
> .../VF<n>/sriov_vf_msix_count so the sum of all of them never exceeds
> sriov_vf_total_msix?  If that user app crashes, I guess it can
> reconstruct this state by reading all the
> .../VF<n>/sriov_vf_msix_count files?

Yes, if orchestration software crashes on hypervisor, it will simply
reiterate all VFs from the beginning.

>
> > > > > If we put them in a new "vfs_overlay" directory, it seems like
> > > > > overkill to repeat the "vf" part, but I'm hoping the new files can end
> > > > > up next to these existing files.  In that case, I think it makes sense
> > > > > to include "sriov".  And it probably does make sense to include "vf"
> > > > > as well.
> > > >
> > > > I put everything in folder to group any possible future extensions.
> > > > Those extensions are applicable to SR-IOV VFs only, IMHO they deserve
> > > > separate folder.
> > >
> > > I'm not convinced (yet) that the possibility of future extensions is
> > > enough justification for adding the "vfs_overlay" directory.  It
> > > really complicates the code flow -- if we skipped the new directory,
> > > I'm pretty sure we could make .is_visible() work, which would be a
> > > major simplification.
> >
> > Unfortunately not, is_visible() is not dynamic and called when device
> > creates sysfs and it doesn't rescan it or refresh them. It means that
> > all files from vfs_overlay folder will exist even driver is removed
> > from PF.
> >
> > Also sysfs is created before driver is probed.
>
> Ah, both excellent points, that makes this much clearer to me, thank
> you!
>
> > > And there's quite a bit of value in the new files being right next to
> > > the existing sriov_* files.
> >
> > I have no problem to drop folder, just need clear request, should I.
>
> I think we should drop the folder.  I missed the previous discussion
> though, so if somebody has a good objection to dropping it, let me
> know.

Just to be clear, dropping "vfs_overlay" folder won't remove any
complexity with pci_enable_vfs_overlay()/pci_disable_vfs_overlay(), but
will cause to simple change of the name attribute in the attribute_group.

>
> Dropping the folder has the potential advantage that we *could* decide
> to expose these files always, and just have them be non-functional if
> the device doesn't support assignment or the PF driver isn't bound.
> Then I think we could use static sysfs attributes without
> pci_enable_vfs_overlay().

Such static initialization was in v0..v3 versions, but the request was to have
new files to be PF-driven and it requires enable/disable callbacks.

They need to allow the flow when PF driver is bounded after VF devices
already created. For example this flow:
1. modprobe mlx5_core
2. echo 5 > .../sriov_numvf
3. rmmod mlx5_core
...
4. modprobe mlx5_core <- need to reattach to already existing VFs.

Thanks

>
> Bjorn
