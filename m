Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2FA31C6E0
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhBPHeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:32922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhBPHe3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 02:34:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62E5D64E04;
        Tue, 16 Feb 2021 07:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613460828;
        bh=RbFLXIpmV+6BbnaecTY/k2NgUz9HSQXSB02BzYCtQ20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HZ3korqGinigAJrhhx3pWEfnIzcvu6f/NwObpzm8g8Ew3MJS5BN2tOlOzZ8VVvMS0
         /+WKfRD8caPBSZ44OTOFZ97+ryg1oW2NZcp26VNWkrVDYl3lyD+XYEJEilYsigkq9S
         K7Fi7xzX0U6WqqqW825oonetSkcRiBD8fKnBS32r49XyTmR0BE2bG+GkbaU6e6Xe8z
         vOZFdDAK7m+k3sqK8cHFTDzwomJg9oDjRy8tqRupLqpdpMPvSdt3VJLOvtLrjuFlaU
         mRWdtjljWE1dG8U23AoScWsk3ukwB9K3TWFOG0pBbSprh8kbkCZ4bx4bp/SiLjI1eR
         CFuKkjaAhL04A==
Date:   Tue, 16 Feb 2021 09:33:44 +0200
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
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <YCt1WAAEO1hx2pjY@unreal>
References: <20210209133445.700225-2-leon@kernel.org>
 <20210215210106.GA744958@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215210106.GA744958@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 03:01:06PM -0600, Bjorn Helgaas wrote:
> On Tue, Feb 09, 2021 at 03:34:42PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Extend PCI sysfs interface with a new callback that allows configuration
> > of the number of MSI-X vectors for specific SR-IOV VF. This is needed
> > to optimize the performance of VFs devices by allocating the number of
> > vectors based on the administrator knowledge of the intended use of the VF.
> >
> > This function is applicable for SR-IOV VF because such devices allocate
> > their MSI-X table before they will run on the VMs and HW can't guess the
> > right number of vectors, so some devices allocate them statically and equally.
>
> This commit log should be clear that this functionality is motivated
> by *mlx5* behavior.  The description above makes it sound like this is
> generic PCI spec behavior, and it is not.
>
> It may be a reasonable design that conforms to the spec, and we hope
> the model will be usable by other designs, but it is not required by
> the spec and AFAIK there is nothing in the spec you can point to as
> background for this.
>
> So don't *remove* the text you have above, but please *add* some
> preceding background information about how mlx5 works.
>
> > 1) The newly added /sys/bus/pci/devices/.../sriov_vf_msix_count
> > file will be seen for the VFs and it is writable as long as a driver is not
> > bound to the VF.
>
>   This adds /sys/bus/pci/devices/.../sriov_vf_msix_count for VF
>   devices and is writable ...
>
> > The values accepted are:
> >  * > 0 - this will be number reported by the Table Size in the VF's MSI-X Message
> >          Control register
> >  * < 0 - not valid
> >  * = 0 - will reset to the device default value
>
>   = 0 - will reset to a device-specific default value
>
> > 2) In order to make management easy, provide new read-only sysfs file that
> > returns a total number of possible to configure MSI-X vectors.
>
>   For PF devices, this adds a read-only
>   /sys/bus/pci/devices/.../sriov_vf_total_msix file that contains the
>   total number of MSI-X vectors available for distribution among VFs.
>
> Just as in sysfs-bus-pci, this file should be listed first, because
> you must read it before you can use vf_msix_count.

No problem, I'll change, just remember that we are talking about commit
message because in Documentation file, the order is exactly as you request.

>
> > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> >   = 0 - feature is not supported
> >   > 0 - total number of MSI-X vectors available for distribution among the VFs
> >
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-pci |  28 +++++
> >  drivers/pci/iov.c                       | 153 ++++++++++++++++++++++++
> >  include/linux/pci.h                     |  12 ++
> >  3 files changed, 193 insertions(+)

<...>

> > + */
> > +int pci_enable_vf_overlay(struct pci_dev *dev)
> > +{
> > +	struct pci_dev *virtfn;
> > +	int id, ret;
> > +
> > +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> > +		return 0;
> > +
> > +	ret = sysfs_create_files(&dev->dev.kobj, sriov_pf_dev_attrs);
>
> But I still don't like the fact that we're calling
> sysfs_create_files() and sysfs_remove_files() directly.  It makes
> complication and opportunities for errors.

It is not different from any other code that we have in the kernel.
Let's be concrete, can you point to the errors in this code that I
should fix?

>
> I don't see the advantage of creating these files only when the PF
> driver supports this.  The management tools have to deal with
> sriov_vf_total_msix == 0 and sriov_vf_msix_count == 0 anyway.
> Having the sysfs files not be present at all might be slightly
> prettier to the person running "ls", but I'm not sure the code
> complication is worth that.

It is more than "ls", right now sriov_numvfs is visible without relation
to the driver, even if driver doesn't implement ".sriov_configure", which
IMHO bad. We didn't want to repeat.

Right now, we have many devices that supports SR-IOV, but small amount
of them are capable to rewrite their VF MSI-X table siz. We don't want
"to punish" and clatter their sysfs.

>
> I see a hint that Alex might have requested this "only visible when PF
> driver supports it" functionality, but I don't see that email on
> linux-pci, so I missed the background.

First version of this patch had static files solution.
https://lore.kernel.org/linux-pci/20210103082440.34994-2-leon@kernel.org/#Z30drivers:pci:iov.c

Thanks
