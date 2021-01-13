Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890532F53A2
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbhAMTuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:50:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbhAMTuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 14:50:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B808206C0;
        Wed, 13 Jan 2021 19:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610567362;
        bh=liKrlxPQO3vjDSJyVqFsYCRIjwPMLfx+k+nniFEpqlU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dTB4Oc5o260FgWHCxQiX8+qM0/Py4+y2rjBBS1eZrBMH5AJo3e67kAPdtn2cNMVzA
         reD4hn2Faeq1CsTrB32fSG85T4OC5sGYlSLTaMuaGL0SAPajHY0q4jaqSE6zLhCaEU
         JuXVnKjwCygLuwDYWuHt9VwgG0gGubAFq6jyt5lS8tWOYYvqsB/g4q2/BgH/0tmDiM
         KbbF0zmWyNu3TLDPSwFUdcn2SnOBHdhbkIGVL7PAuJ+HPCRYEJeJoMVO310AFTmfMH
         H4P5EJJg07VMql2QwSQelTnEabTEpz+B32wRSYm+EHlQm1hqO2g7YgBT90JYcIKW2i
         jwxVyvIUToYJg==
Date:   Wed, 13 Jan 2021 21:49:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH mlx5-next v1 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210113194918.GJ4678@unreal>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-2-leon@kernel.org>
 <20210113105052.43cf3c15@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113105052.43cf3c15@omen.home.shazbot.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 10:50:52AM -0700, Alex Williamson wrote:
> On Sun, 10 Jan 2021 17:07:23 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Extend PCI sysfs interface with a new callback that allows configure
> > the number of MSI-X vectors for specific SR-IO VF. This is needed
> > to optimize the performance of newly bound devices by allocating
> > the number of vectors based on the administrator knowledge of targeted VM.
> >
> > This function is applicable for SR-IOV VF because such devices allocate
> > their MSI-X table before they will run on the VMs and HW can't guess the
> > right number of vectors, so the HW allocates them statically and equally.
> >
> > The newly added /sys/bus/pci/devices/.../vf_msix_vec file will be seen
> > for the VFs and it is writable as long as a driver is not bounded to the VF.
> >
> > The values accepted are:
> >  * > 0 - this will be number reported by the VF's MSI-X capability
> >  * < 0 - not valid
> >  * = 0 - will reset to the device default value
> >
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-pci | 20 ++++++++
> >  drivers/pci/iov.c                       | 62 +++++++++++++++++++++++++
> >  drivers/pci/msi.c                       | 29 ++++++++++++
> >  drivers/pci/pci-sysfs.c                 |  1 +
> >  drivers/pci/pci.h                       |  2 +
> >  include/linux/pci.h                     |  8 +++-
> >  6 files changed, 121 insertions(+), 1 deletion(-)

<...>

> > +/**
> > + * pci_set_msix_vec_count - change the reported number of MSI-X vectors
> > + * This function is applicable for SR-IOV VF because such devices allocate
> > + * their MSI-X table before they will run on the VMs and HW can't guess the
> > + * right number of vectors, so the HW allocates them statically and equally.
> > + * @dev: VF device that is going to be changed
> > + * @numb: amount of MSI-X vectors
> > + **/
> > +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
> > +{
> > +	struct pci_dev *pdev = pci_physfn(dev);
> > +
> > +	if (!dev->msix_cap || !pdev->msix_cap)
> > +		return -EINVAL;
> > +
> > +	if (dev->driver || !pdev->driver ||
> > +	    !pdev->driver->sriov_set_msix_vec_count)
> > +		return -EOPNOTSUPP;
>
>
> This seems racy, don't we need to hold device_lock on both the VF and
> PF to avoid driver {un}binding races?  Does that happen implicitly
> somewhere?  Thanks,

Yes, you are right absolutely, pdev and dev are not protected here.

Thanks
