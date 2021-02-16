Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B2431CDBB
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 17:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhBPQNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 11:13:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230497AbhBPQMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 11:12:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80FB864DE0;
        Tue, 16 Feb 2021 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613491933;
        bh=YsmSNbs1fG6/XCwIIYDqUXP6IHfT1nl9WMU20aRi7hk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=nYEwBNSn9HzLcEW/+f8c/O7H3bXtzz0Vp+S9Q9/b2QN4SEex1umuRRDh9gAtcOQus
         6jVaP+GeK6e0u7JFWcdzGDuf7pOt/yN860oWwoPAT4ng+3Kesn+YibEgKCOBO0GvTn
         AWw3KCRVfDeTMCKCJYeSSA4YGCxynTtUBhq+R3ASFIuzo8bu+ZHUl4nuwE04Q3N/UT
         wz9JTJHXqXv+Eff+JALa6BTHgm4xFq4vChRsc77cvCferw1F4MaS+kQgRGBX7vH28V
         qsDrVkuV0SULwF7l2Z/ybFaWwOjblSy9mlPlXF/gzzbh/aTQQSj0Uyb3vTSkcyOAF9
         8TanjHmNNA66w==
Date:   Tue, 16 Feb 2021 10:12:12 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210216161212.GA805748@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCt1WAAEO1hx2pjY@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Proposed subject:

  PCI/IOV: Add dynamic MSI-X vector assignment sysfs interface

On Tue, Feb 16, 2021 at 09:33:44AM +0200, Leon Romanovsky wrote:
> On Mon, Feb 15, 2021 at 03:01:06PM -0600, Bjorn Helgaas wrote:
> > On Tue, Feb 09, 2021 at 03:34:42PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>

Here's a draft of the sort of thing I'm looking for here:

  A typical cloud provider SR-IOV use case is to create many VFs for
  use by guest VMs.  The VFs may not be assigned to a VM until a
  customer requests a VM of a certain size, e.g., number of CPUs.  A
  VF may need MSI-X vectors proportional to the number of CPUs in the
  VM, but there is no standard way to change the number of MSI-X
  vectors supported by a VF.

  Some Mellanox ConnectX devices support dynamic assignment of MSI-X
  vectors to SR-IOV VFs.  This can be done by the PF driver after VFs
  are enabled, and it can be done without affecting VFs that are
  already in use.  The hardware supports a limited pool of MSI-X
  vectors that can be assigned to the PF or to individual VFs.  This
  is device-specific behavior that requires support in the PF driver.

  Add a read-only "sriov_vf_total_msix" sysfs file for the PF and a
  writable "sriov_vf_msix_count" file for each VF.  Management
  software may use these to learn how many MSI-X vectors are available
  and to dynamically assign them to VFs before the VFs are passed
  through to a VM.

  If the PF driver implements the ->sriov_get_vf_total_msix()
  callback, "sriov_vf_total_msix" contains the total number of MSI-X
  vectors available for distribution among VFs.

  If no driver is bound to the VF, writing "N" to
  "sriov_vf_msix_count" uses the PF driver ->sriov_set_msix_vec_count()
  callback to assign "N" MSI-X vectors to the VF.  When a VF driver
  subsequently reads the MSI-X Message Control register, it will see
  the new Table Size "N".

> > > Extend PCI sysfs interface with a new callback that allows configuration
> > > of the number of MSI-X vectors for specific SR-IOV VF. This is needed
> > > to optimize the performance of VFs devices by allocating the number of
> > > vectors based on the administrator knowledge of the intended use of the VF.
> > >
> > > This function is applicable for SR-IOV VF because such devices allocate
> > > their MSI-X table before they will run on the VMs and HW can't guess the
> > > right number of vectors, so some devices allocate them statically and equally.
> >
> > This commit log should be clear that this functionality is motivated
> > by *mlx5* behavior.  The description above makes it sound like this is
> > generic PCI spec behavior, and it is not.
> >
> > It may be a reasonable design that conforms to the spec, and we hope
> > the model will be usable by other designs, but it is not required by
> > the spec and AFAIK there is nothing in the spec you can point to as
> > background for this.
> >
> > So don't *remove* the text you have above, but please *add* some
> > preceding background information about how mlx5 works.
> >
> > > 1) The newly added /sys/bus/pci/devices/.../sriov_vf_msix_count
> > > file will be seen for the VFs and it is writable as long as a driver is not
> > > bound to the VF.
> >
> >   This adds /sys/bus/pci/devices/.../sriov_vf_msix_count for VF
> >   devices and is writable ...
> >
> > > The values accepted are:
> > >  * > 0 - this will be number reported by the Table Size in the VF's MSI-X Message
> > >          Control register
> > >  * < 0 - not valid
> > >  * = 0 - will reset to the device default value
> >
> >   = 0 - will reset to a device-specific default value
> >
> > > 2) In order to make management easy, provide new read-only sysfs file that
> > > returns a total number of possible to configure MSI-X vectors.
> >
> >   For PF devices, this adds a read-only
> >   /sys/bus/pci/devices/.../sriov_vf_total_msix file that contains the
> >   total number of MSI-X vectors available for distribution among VFs.
> >
> > Just as in sysfs-bus-pci, this file should be listed first, because
> > you must read it before you can use vf_msix_count.
> 
> No problem, I'll change, just remember that we are talking about commit
> message because in Documentation file, the order is exactly as you request.

Yes, I noticed that, thank you!  It will be good to have them in the
same order in both the commit log and the Documentation file.  I think
it will make more sense to readers.

> > > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> > >   = 0 - feature is not supported
> > >   > 0 - total number of MSI-X vectors available for distribution among the VFs
> > >
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-bus-pci |  28 +++++
> > >  drivers/pci/iov.c                       | 153 ++++++++++++++++++++++++
> > >  include/linux/pci.h                     |  12 ++
> > >  3 files changed, 193 insertions(+)
> 
> <...>
> 
> > > + */
> > > +int pci_enable_vf_overlay(struct pci_dev *dev)
> > > +{
> > > +	struct pci_dev *virtfn;
> > > +	int id, ret;
> > > +
> > > +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> > > +		return 0;
> > > +
> > > +	ret = sysfs_create_files(&dev->dev.kobj, sriov_pf_dev_attrs);
> >
> > But I still don't like the fact that we're calling
> > sysfs_create_files() and sysfs_remove_files() directly.  It makes
> > complication and opportunities for errors.
> 
> It is not different from any other code that we have in the kernel.

It *is* different.  There is a general rule that drivers should not
call sysfs_* [1].  The PCI core is arguably not a "driver," but it is
still true that callers of sysfs_create_files() are very special, and
I'd prefer not to add another one.

> Let's be concrete, can you point to the errors in this code that I
> should fix?

I'm not saying there are current errors; I'm saying the additional
code makes errors possible in future code.  For example, we hope that
other drivers can use these sysfs interfaces, and it's possible they
may not call pci_enable_vf_overlay() or pci_disable_vfs_overlay()
correctly.

Or there may be races in device addition/removal.  We have current
issues in this area, e.g., [2], and they're fairly subtle.  I'm not
saying your patches have these issues; only that extra code makes more
chances for mistakes and it's more work to validate it.

> > I don't see the advantage of creating these files only when the PF
> > driver supports this.  The management tools have to deal with
> > sriov_vf_total_msix == 0 and sriov_vf_msix_count == 0 anyway.
> > Having the sysfs files not be present at all might be slightly
> > prettier to the person running "ls", but I'm not sure the code
> > complication is worth that.
> 
> It is more than "ls", right now sriov_numvfs is visible without relation
> to the driver, even if driver doesn't implement ".sriov_configure", which
> IMHO bad. We didn't want to repeat.
> 
> Right now, we have many devices that supports SR-IOV, but small amount
> of them are capable to rewrite their VF MSI-X table siz. We don't want
> "to punish" and clatter their sysfs.

I agree, it's clutter, but at least it's just cosmetic clutter (but
I'm willing to hear discussion about why it's more than cosmetic; see
below).

From the management software point of view, I don't think it matters.
That software already needs to deal with files that don't exist (on
old kernels) and files that contain zero (feature not supported or no
vectors are available).

From my point of view, pci_enable_vf_overlay() or
pci_disable_vfs_overlay() are also clutter, at least compared to
static sysfs attributes.

> > I see a hint that Alex might have requested this "only visible when PF
> > driver supports it" functionality, but I don't see that email on
> > linux-pci, so I missed the background.
> 
> First version of this patch had static files solution.
> https://lore.kernel.org/linux-pci/20210103082440.34994-2-leon@kernel.org/#Z30drivers:pci:iov.c

Thanks for the pointer to the patch.  Can you point me to the
discussion about why we should use the "only visible when PF driver
supports it" model?

Bjorn

[1] https://lore.kernel.org/linux-pci/YBmG7qgIDYIveDfX@kroah.com/
[2] https://lore.kernel.org/linux-pci/20200716110423.xtfyb3n6tn5ixedh@pali/
