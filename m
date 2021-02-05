Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD9E310EE0
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 18:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhBEP5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 10:57:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233373AbhBEPyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 10:54:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93EF564DA5;
        Fri,  5 Feb 2021 17:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612546551;
        bh=Cd7nYScqEXbmOIap0SxzrEdVh+3I5uoCBdxclqKhhns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s4vCnTFcCwzHCFlccPvINmfYFc0dSbWilQsPSTGTlJMV2Csm4TY42sixkcKphpygB
         nHFEL6P7HQNDo/nSJfm7DMP0J4kWE/RtuGL/05h9rmeFgqXUVX9HtPZwSoB6ZipvcD
         w1iJPZoIVFQ8VFGrvjDucaM0Sg3WlANiEZoHd60zm+cdw1zKD1OtKldIIsMjq7xOkO
         JpwZbceyd6Ux4ni1BH14tEv30wqWPgcDFu5mS8hxTQTrNHaj8OJERsctI4MxyD9sX/
         3xsTU4RCBfep52rj62qvcdRg/IpDcsw7+r61gLboCJ8sZNwNwjOUTgxsjfrYFtbpFw
         P/oBL/kbFAYGA==
Date:   Fri, 5 Feb 2021 19:35:47 +0200
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
Message-ID: <20210205173547.GE93433@unreal>
References: <20210204155048.GC93433@unreal>
 <20210204211212.GA83310@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204211212.GA83310@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 03:12:12PM -0600, Bjorn Helgaas wrote:
> On Thu, Feb 04, 2021 at 05:50:48PM +0200, Leon Romanovsky wrote:
> > On Wed, Feb 03, 2021 at 06:10:39PM -0600, Bjorn Helgaas wrote:
> > > On Tue, Feb 02, 2021 at 09:44:29PM +0200, Leon Romanovsky wrote:
> > > > On Tue, Feb 02, 2021 at 12:06:09PM -0600, Bjorn Helgaas wrote:
> > > > > On Tue, Jan 26, 2021 at 10:57:27AM +0200, Leon Romanovsky wrote:
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > >
> > > > > > Extend PCI sysfs interface with a new callback that allows
> > > > > > configure the number of MSI-X vectors for specific SR-IO VF.
> > > > > > This is needed to optimize the performance of newly bound
> > > > > > devices by allocating the number of vectors based on the
> > > > > > administrator knowledge of targeted VM.
> > > > >
> > > > > I'm reading between the lines here, but IIUC the point is that you
> > > > > have a PF that supports a finite number of MSI-X vectors for use
> > > > > by all the VFs, and this interface is to control the distribution
> > > > > of those MSI-X vectors among the VFs.
>
> > > This commit log should describe how *this* device manages this
> > > allocation and how the PF Table Size and the VF Table Sizes are
> > > related.  Per PCIe, there is no necessary connection between them.
> >
> > There is no connection in mlx5 devices either. PF is used as a vehicle
> > to access VF that doesn't have driver yet. From "table size" perspective
> > they completely independent, because PF already probed by driver and
> > it is already too late to change it.
> >
> > So PF table size is static and can be changed through FW utility only.
>
> This is where description of the device would be useful.
>
> The fact that you need "sriov_vf_total_msix" to advertise how many
> vectors are available and "sriov_vf_msix_count" to influence how they
> are distributed across the VFs suggests that these Table Sizes are not
> completely independent.
>
> Can a VF have a bigger Table Size than the PF does?  Can all the VF
> Table Sizes added together be bigger than the PF Table Size?  If VF A
> has a larger Table Size, does that mean VF B must have a smaller Table
> Size?

VFs are completely independent devices and their table size can be
bigger than PF. FW has two pools, one for PF and another for all VFs.
In real world scenarios, every VF will have more MSI-X vectors than PF,
which will be distributed by orchestration software.

In theory, users can assign almost all vectors to one VF and leave others
depleted. In practice, it is not possible, we ensure that all VFs start
with some sensible number of vectors and FW protects with check of max
vector size write.

>
> Obviously I do not understand the details about how this device works.
> It would be helpful to have those details here.
>
> Here's the sequence as I understand it:
>
>   1) PF driver binds to PF
>   2) PF driver enables VFs
>   3) PF driver creates /sys/.../<PF>/sriov_vf_total_msix
>   4) PF driver creates /sys/.../<VFn>/sriov_vf_msix_count for each VF
>   5) Management app reads sriov_vf_total_msix, writes sriov_vf_msix_count
>   6) VF driver binds to VF
>   7) VF reads MSI-X Message Control (Table Size)
>
> Is it true that "lspci VF" at 4.1 and "lspci VF" at 5.1 may read
> different Table Sizes?  That would be a little weird.

Yes, this is the flow. I think differently from you and think this
is actual good thing that user writes new msix count and it is shown
immediately.

>
> I'm also a little concerned about doing 2 before 3 & 4.  That works
> for mlx5 because implements the Table Size adjustment in a way that
> works *after* the VFs have been enabled.

It is not related to mlx5, but to the PCI spec that requires us to
create all VFs at the same time. Before enabling VFs, they don't
exist.

>
> But it seems conceivable that a device could implement vector
> distribution in a way that would require the VF Table Sizes to be
> fixed *before* enabling VFs.  That would be nice in the sense that the
> VFs would be created "fully formed" and the VF Table Size would be
> completely read-only as documented.

It is not how SR-IOV is used in real world. Cloud providers create many
VFs but don't assign those VFs yet. They do it after customer request
VM with specific properties (number of CPUs) which means number of MSI-X
vectors in our case.

All this is done when other VFs already in use and we can't destroy and
recreate them at that point of time.

>
> The other knob idea you mentioned at [2]:
>
>   echo "0000:01:00.2 123" > sriov_vf_msix_count

This knob doesn't always work if you have many devices and it is
nightmare to guess "new" VF BDF before it is claimed.

As an example on my machine with two devices, VFs are created differently:
[root@c ~]$ lspci |grep nox
08:00.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
08:00.1 Infiniband controller: Mellanox Technologies MT27800 Family [ConnectX-5]
[root@c ~]# echo 2 > /sys/bus/pci/devices/0000\:08\:00.1/sriov_numvfs
[root@c ~]# lspci |grep nox
08:00.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
08:00.1 Infiniband controller: Mellanox Technologies MT27800 Family [ConnectX-5]
08:01.2 Infiniband controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
08:01.3 Infiniband controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
[root@c ~]# echo 0 > /sys/bus/pci/devices/0000\:08\:00.1/sriov_numvfs
[root@c ~]# echo 2 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
[root@c ~]# lspci |grep nox
08:00.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
08:00.1 Infiniband controller: Mellanox Technologies MT27800 Family [ConnectX-5]
08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
08:00.3 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]

>
> would have the advantage of working for both cases.  That's definitely
> more complicated, but at the same time, I would hate to carve a sysfs
> interface into stone if it might not work for other devices.

As you can see above, it is not really solves pre-creation configuration flow.
For such flows, probably devlink is the best choice.

>
> > > > > > +What:		/sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
> > > > > > +Date:		January 2021
> > > > > > +Contact:	Leon Romanovsky <leonro@nvidia.com>
> > > > > > +Description:
> > > > > > +		This file is associated with the SR-IOV PFs.
> > > > > > +		It returns a total number of possible to configure MSI-X
> > > > > > +		vectors on the enabled VFs.
> > > > > > +
> > > > > > +		The values returned are:
> > > > > > +		 * > 0 - this will be total number possible to consume by VFs,
> > > > > > +		 * = 0 - feature is not supported
> >
> > > Not sure the "= 0" description is necessary here.  If the value
> > > returned is the number of MSI-X vectors available for assignment to
> > > VFs, "0" is a perfectly legitimate value.  It just means there are
> > > none.  It doesn't need to be described separately.
> >
> > I wanted to help users and remove ambiguity. For example, mlx5 drivers
> > will always implement proper .set_...() callbacks but for some devices
> > without needed FW support, the value will be 0. Instead of misleading
> > users with wrong promise that feature supported but doesn't have
> > available vectors, I decided to be more clear. For the users, 0 means, don't
> > try, it is not working.
>
> Oh, you mean "feature is not supported by the FIRMWARE on some mlx5
> devices"?  I totally missed that; I thought you meant "not supported
> by the PF driver."  Why not have the PF driver detect that the
> firmware doesn't support the feature and just not expose the sysfs
> files at all in that case?

I can do it and will do it, but this behavior will be possible because
mlx5 is flexible enough. I imagine that other device won't be so flexible,
for example they will decide to "close" this feature because of other
SW limitation.

>
> > > If we put them in a new "vfs_overlay" directory, it seems like
> > > overkill to repeat the "vf" part, but I'm hoping the new files can end
> > > up next to these existing files.  In that case, I think it makes sense
> > > to include "sriov".  And it probably does make sense to include "vf"
> > > as well.
> >
> > I put everything in folder to group any possible future extensions.
> > Those extensions are applicable to SR-IOV VFs only, IMHO they deserve
> > separate folder.
>
> I'm not convinced (yet) that the possibility of future extensions is
> enough justification for adding the "vfs_overlay" directory.  It
> really complicates the code flow -- if we skipped the new directory,
> I'm pretty sure we could make .is_visible() work, which would be a
> major simplification.

Unfortunately not, is_visible() is not dynamic and called when device
creates sysfs and it doesn't rescan it or refresh them. It means that
all files from vfs_overlay folder will exist even driver is removed
from PF.

Also sysfs is created before driver is probed.

>
> And there's quite a bit of value in the new files being right next to
> the existing sriov_* files.

I have no problem to drop folder, just need clear request, should I.

>
> > > > > > +void pci_disable_vfs_overlay(struct pci_dev *dev)
> > > > > > +{
> > > > > > +	struct pci_dev *virtfn;
> > > > > > +	int id;
> > > > > > +
> > > > > > +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> > > > > > +		return;
> > > > > > +
> > > > > > +	id = dev->sriov->num_VFs;
> > > > > > +	while (id--) {
> > > > > > +		virtfn = pci_get_domain_bus_and_slot(
> > > > > > +			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
> > > > > > +			pci_iov_virtfn_devfn(dev, id));
> > > > > > +
> > > > > > +		if (!virtfn)
> > > > > > +			continue;
> > > > > > +
> > > > > > +		sysfs_remove_group(&virtfn->dev.kobj, &sriov_vf_dev_attr_group);
> > > > > > +	}
> > > > > > +	sysfs_remove_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
> > > > > > +}
> > > > > > +EXPORT_SYMBOL_GPL(pci_disable_vfs_overlay);
> > > > >
> > > > > I'm not convinced all this sysfs wrangling is necessary.  If it is,
> > > > > add a hint in a comment about why this is special and can't use
> > > > > something like sriov_dev_attr_group.
> > > >
> > > > This makes the overlay to be PF-driven. Alexander insisted on this flow.
> > >
> > > If you're referring to [1], I think "insisted on this flow" might be
> > > an overstatement of what Alex was looking for.  IIUC Alex wants the
> > > sysfs files to be visible only when they're useful, i.e., when a
> > > driver implements ->sriov_set_msix_vec_count().
> >
> > It is only one side of the request, the sysfs files shouldn't be visible
> > if PF driver was removed and visible again when its probed again.
>
> I can't parse this, but it's probably related to the question below.
>
> > > That seems reasonable and also seems like something a smarter
> > > .is_visible() function could accomplish without having drivers call
> > > pci_enable_vfs_overlay(), e.g., maybe some variation of this:
> > >
> > >   static umode_t sriov_vf_attrs_are_visible(...)
> > >   {
> > >     if (!pdev->msix_cap || dev_is_pf(dev))
> > >       return 0;
> > >
> > >     pf = pci_physfn(pdev);
> > >     if (pf->driver && pf->driver->sriov_set_msix_vec_count)
> > >       return a->mode;
> > >
> > >     return 0;
> > >   }
> >
> > It doesn't work with the following flow:
> > 1. load driver
> > 2. disable autoprobe
> > 3. echo to sriov_numvfs
> > .... <--- you have this sriov_vf_attrs_are_visible() created
> > 4. unload driver
> > .... <--- sysfs still exists despite not having PF driver.
>
> I missed your point here, sorry.  After unloading the PF driver,
> "pf->driver" in the sketch above will be NULL, so the VF sysfs file
> would not be visible.  Right?  Maybe it has to do with autoprobe?  I
> didn't catch what the significance of disabling autoprobe was.

No, is_visible() is called on file creation only, see fs/sysfs/group.c:
create_files(). After you remove driver, there is no sysfs file refresh.

>
> > > > > > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count)
> > > > > > +{
> > > > > > +	if (!dev->is_physfn)
> > > > > > +		return;
> > > > > > +
> > > > > > +	dev->sriov->vf_total_msix = count;
> > > > >
> > > > > The PCI core doesn't use vf_total_msix at all.  The driver, e.g.,
> > > > > mlx5, calls this, and all the PCI core does is hang onto the value and
> > > > > expose it via sysfs.  I think I'd rather have a callback in struct
> > > > > pci_driver and let the driver supply the value when needed.  I.e.,
> > > > > sriov_vf_total_msix_show() would call the callback instead of looking
> > > > > at pdev->sriov->vf_total_msix.
> > > >
> > > > It will cause to unnecessary locking to ensure that driver doesn't
> > > > vanish during sysfs read. I can change, but don't think that it is right
> > > > decision.
> > >
> > > Doesn't sysfs already ensure the driver can't vanish while we're
> > > executing a DEVICE_ATTR accessor?
> >
> > It is not, you can see it by adding device_lock_held() check in any
> > .show attribute. See drivers/base/core.c: dev_attr_show(), it doesn't
> > do much. This is why pci_vf_set_msix_vec_count() has double lock.
>
> Aahh, right, I learned something today, thanks!  There are only a few
> PCI sysfs attributes that reference the driver, and they do their own
> locking.
>
> I do think vf_total_msix is a bit of driver state related to
> implementing this functionality and doesn't need to be in the PCI
> core.  I think device locking is acceptable; it's very similar to what
> is done in sriov_numvfs_store().  Doing the locking and calling a
> driver callback makes it obvious that vf_total_msix is part of this PF
> driver-specific functionality, not a generic part of the PCI core.
>
> So let's give it a try.  If it turns out to be terrible, we can
> revisit it.

No problem.

>
> > > Also, pci_vf_set_msix_vec_count() is in pci/msi.c, but AFAICT there's
> > > no actual *reason* for it to be there other than the fact that it has
> > > "msix" in the name.  It uses no MSI data structures.  Maybe it could
> > > be folded into sriov_vf_msix_count_store(), which would make the
> > > analysis even easier.
> >
> > I put _set_ command near _get_ command, but I can move it to iov.c
>
> You mean you put pci_vf_set_msix_vec_count() near
> pci_msix_vec_count()?  That's *true*, but they are not analogues, and
> one is not setting the value returned by the other.
>
> pci_vf_set_msix_vec_count() is a completely magical thing that uses a
> device-specific mechanism on a PF that happens to change what
> pci_msix_vec_count() on a VF will return later.  I think this is more
> related to SR-IOV than it is to MSI.

I will do.

>
> Bjorn
>
> > > [1] https://lore.kernel.org/r/CAKgT0UcJQ3uy6J_CCLizDLfzGL2saa_PjOYH4nK+RQjfmpNA=w@mail.gmail.com
>
> [2] https://lore.kernel.org/linux-pci/20210118132800.GA4835@unreal/
