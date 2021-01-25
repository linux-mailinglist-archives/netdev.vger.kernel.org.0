Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C756304967
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732892AbhAZF2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbhAYSrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C35E206FA;
        Mon, 25 Jan 2021 18:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611600442;
        bh=aes1csZ5xz5Ut64yIXHedOXiqt+WZ494OkUk9tO4aBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CwJBecAgB0gXi0OS2WYZZXK+h0Hlz22hNvnZTpUUJZS3KSsnXYIX1A06DoksOUOof
         T8vMuuQy0tyvcQqTrW5VdqjFKonN9Pa+6I442MGo49GC2DpA16rXZTfIWk0wtJLrWW
         EE5OSewqZ3HIMkja0X3KQ9ByADpAMpWXzXcxZt8eypXfTEV+ULeBMh7Na6O4CLJtwy
         BP6/TJwW0jdTytxYghgAmc4RZqWTHof09RwxYcfVL4Rwe13TSK7mVGc+nq12fCq1sj
         PsZ53DWEoUl0pL6VwB+IYwwtGM4/hdXv4vt0STxoxEKp6p0HzKRuMpAXrL9cF69LLd
         FCRXeio5RCH0Q==
Date:   Mon, 25 Jan 2021 20:47:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v4 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210125184719.GK579511@unreal>
References: <20210124131119.558563-1-leon@kernel.org>
 <20210124131119.558563-2-leon@kernel.org>
 <CAKgT0UcJQ3uy6J_CCLizDLfzGL2saa_PjOYH4nK+RQjfmpNA=w@mail.gmail.com>
 <20210124190032.GD5038@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124190032.GD5038@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 09:00:32PM +0200, Leon Romanovsky wrote:
> On Sun, Jan 24, 2021 at 08:47:44AM -0800, Alexander Duyck wrote:
> > On Sun, Jan 24, 2021 at 5:11 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Extend PCI sysfs interface with a new callback that allows configure
> > > the number of MSI-X vectors for specific SR-IO VF. This is needed
> > > to optimize the performance of newly bound devices by allocating
> > > the number of vectors based on the administrator knowledge of targeted VM.
> > >
> > > This function is applicable for SR-IOV VF because such devices allocate
> > > their MSI-X table before they will run on the VMs and HW can't guess the
> > > right number of vectors, so the HW allocates them statically and equally.
> > >
> > > 1) The newly added /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
> > > file will be seen for the VFs and it is writable as long as a driver is not
> > > bounded to the VF.
> > >
> > > The values accepted are:
> > >  * > 0 - this will be number reported by the VF's MSI-X capability
> > >  * < 0 - not valid
> > >  * = 0 - will reset to the device default value
> > >
> > > 2) In order to make management easy, provide new read-only sysfs file that
> > > returns a total number of possible to configure MSI-X vectors.
> > >
> > > cat /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
> > >   = 0 - feature is not supported
> > >   > 0 - total number of MSI-X vectors to consume by the VFs
> > >
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-bus-pci |  32 +++++
> > >  drivers/pci/iov.c                       | 180 ++++++++++++++++++++++++
> > >  drivers/pci/msi.c                       |  47 +++++++
> > >  drivers/pci/pci.h                       |   4 +
> > >  include/linux/pci.h                     |  10 ++
> > >  5 files changed, 273 insertions(+)
> > >
> >
> > <snip>
> >
> > > +
> > > +static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
> > > +                                         struct attribute *a, int n)
> > > +{
> > > +       struct device *dev = kobj_to_dev(kobj);
> > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > +
> > > +       if (!pdev->msix_cap || !dev_is_pf(dev))
> > > +               return 0;
> > > +
> > > +       return a->mode;
> > > +}
> > > +
> > > +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> > > +                                         struct attribute *a, int n)
> > > +{
> > > +       struct device *dev = kobj_to_dev(kobj);
> > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > +
> > > +       if (!pdev->msix_cap || dev_is_pf(dev))
> > > +               return 0;
> > > +
> > > +       return a->mode;
> > > +}
> > > +
> >
> > Given the changes I don't see why we need to add the "visible"
> > functions. We are only registering this from the PF if there is a need
> > to make use of the interfaces, correct? If so we can just assume that
> > the interfaces should always be visible if they are requested.
>
> I added them to make extension of this vfs_overlay interface more easy,
> so we won't forget that current fields needs "msix_cap". Also I followed
> same style as other attribute_group which has .is_visible.
>
> >
> > Also you may want to look at placing a link to the VF folders in the
> > PF folder, although I suppose there are already links from the PF PCI
> > device to the VF PCI devices so maybe that isn't necessary. It just
> > takes a few extra steps to navigate between the two.
>
> We already have, I don't think that we need to add extra links, it will
> give nothing.
>
> [leonro@vm ~]$ ls -l /sys/bus/pci/devices/0000\:01\:00.0/
> ....
> drwxr-xr-x 2 root root        0 Jan 24 14:02 vfs_overlay
> lrwxrwxrwx 1 root root        0 Jan 24 14:02 virtfn0 -> ../0000:01:00.1
> lrwxrwxrwx 1 root root        0 Jan 24 14:02 virtfn1 -> ../0000:01:00.2
> ....

Alexander, are we clear here? Do you expect v5 without ".is_visible" from me?

Thanks

>
> Thanks
