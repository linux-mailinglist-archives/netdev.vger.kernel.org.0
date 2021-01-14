Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7FB2F5AF8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 07:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbhANGvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 01:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbhANGvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 01:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6247623976;
        Thu, 14 Jan 2021 06:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610607028;
        bh=Uq30qPGb43CK4plrXz+NbB47exQOEcZwvGTgi9cYDKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cCsTzZrKLXZ216KBRUqhbAIdVb4ImCQBQN4q+mEtqdJ+Osc7bz24YeBfkjEfnA5WJ
         epbqhCOi8lzeTyV0QFFnQGOV1uavIZjlYevcXUi+8VfIoJodUo5i+0dc+X6dkPATnI
         8JYzbgcWrv86gwmd8KPq5P6Cp1Lt0R0j/TqDjQyQyKJNTqmiYoaJ4mjsr1RiKXa5aU
         SbVBo8AL+Kzw58J8qQCvcgbbl0TNpwDchOWFyWNI+onC/0u2n08CGdtnYOqo7mW32+
         xLcM3PoVc/4MXPR3HlTkh6nyYBBtLOAZmDIaR0+Uk3y+xYSZUiNwhuGdKdNfnDJWvZ
         +b1jf3PqJe6Zw==
Date:   Thu, 14 Jan 2021 08:50:24 +0200
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
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210114065024.GK4678@unreal>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
 <20210112065601.GD4678@unreal>
 <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal>
 <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 02:44:45PM -0800, Alexander Duyck wrote:
> On Tue, Jan 12, 2021 at 10:19 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Jan 12, 2021 at 01:34:50PM -0800, Alexander Duyck wrote:
> > > On Mon, Jan 11, 2021 at 10:56 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Mon, Jan 11, 2021 at 11:30:39AM -0800, Alexander Duyck wrote:
> > > > > On Sun, Jan 10, 2021 at 7:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > >
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > >
> > > > > > Some SR-IOV capable devices provide an ability to configure specific
> > > > > > number of MSI-X vectors on their VF prior driver is probed on that VF.
> > > > > >
> > > > > > In order to make management easy, provide new read-only sysfs file that
> > > > > > returns a total number of possible to configure MSI-X vectors.
> > > > > >
> > > > > > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> > > > > >   = 0 - feature is not supported
> > > > > >   > 0 - total number of MSI-X vectors to consume by the VFs
> > > > > >
> > > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > > ---
> > > > > >  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
> > > > > >  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
> > > > > >  drivers/pci/pci.h                       |  3 +++
> > > > > >  include/linux/pci.h                     |  2 ++
> > > > > >  4 files changed, 50 insertions(+)
> > > > > >
> > > > > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > index 05e26e5da54e..64e9b700acc9 100644
> > > > > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > @@ -395,3 +395,17 @@ Description:
> > > > > >                 The file is writable if the PF is bound to a driver that
> > > > > >                 supports the ->sriov_set_msix_vec_count() callback and there
> > > > > >                 is no driver bound to the VF.
> > > > > > +
> > > > > > +What:          /sys/bus/pci/devices/.../sriov_vf_total_msix
> > > > >
> > > > > In this case I would drop the "vf" and just go with sriov_total_msix
> > > > > since now you are referring to a global value instead of a per VF
> > > > > value.
> > > >
> > > > This field indicates the amount of MSI-X available for VFs, it doesn't
> > > > include PFs. The missing "_vf_" will mislead users who will believe that
> > > > it is all MSI-X vectors available for this device. They will need to take
> > > > into consideration amount of PF MSI-X in order to calculate the VF distribution.
> > > >
> > > > So I would leave "_vf_" here.
> > >
> > > The problem is you aren't indicating how many are available for an
> > > individual VF though, you are indicating how many are available for
> > > use by SR-IOV to give to the VFs. The fact that you are dealing with a
> > > pool makes things confusing in my opinion. For example sriov_vf_device
> > > describes the device ID that will be given to each VF.
> >
> > sriov_vf_device is different and is implemented accordingly to the PCI
> > spec, 9.3.3.11 VF Device ID (Offset 1Ah)
> > "This field contains the Device ID that should be presented for every VF
> > to the SI."
> >
> > It is one ID for all VFs.
>
> Yes, but that is what I am getting at. It is also what the device
> configuration will be for one VF. So when I read sriov_vf_total_msix
> it reads as the total for a single VF, not all of the the VFs. That is
> why I think dropping the "vf_" part of the name would make sense, as
> what you are describing is the total number of MSI-X vectors for use
> by SR-IOV VFs.

I can change to anything as long as new name will give clear indication
that this total number is for VFs and doesn't include SR-IOV PF MSI-X.

>
> > >
> > > > >
> > > > > > +Date:          January 2021
> > > > > > +Contact:       Leon Romanovsky <leonro@nvidia.com>
> > > > > > +Description:
> > > > > > +               This file is associated with the SR-IOV PFs.
> > > > > > +               It returns a total number of possible to configure MSI-X
> > > > > > +               vectors on the enabled VFs.
> > > > > > +
> > > > > > +               The values returned are:
> > > > > > +                * > 0 - this will be total number possible to consume by VFs,
> > > > > > +                * = 0 - feature is not supported
> > > > > > +
> > > > > > +               If no SR-IOV VFs are enabled, this value will return 0.
> > > > > > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > > > > > index 42c0df4158d1..0a6ddf3230fd 100644
> > > > > > --- a/drivers/pci/iov.c
> > > > > > +++ b/drivers/pci/iov.c
> > > > > > @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
> > > > > >         return count;
> > > > > >  }
> > > > > >
> > > > > > +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> > > > > > +                                       struct device_attribute *attr,
> > > > > > +                                       char *buf)
> > > > > > +{
> > > > > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > > > > +
> > > > > > +       return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);
> > > > > > +}
> > > > > > +
> > > > >
> > > > > You display it as a signed value, but unsigned values are not
> > > > > supported, correct?
> > > >
> > > > Right, I made it similar to the vf_msix_set. I can change.
> > > >
> > > > >
> > > > > >  static DEVICE_ATTR_RO(sriov_totalvfs);
> > > > > >  static DEVICE_ATTR_RW(sriov_numvfs);
> > > > > >  static DEVICE_ATTR_RO(sriov_offset);
> > > > > >  static DEVICE_ATTR_RO(sriov_stride);
> > > > > >  static DEVICE_ATTR_RO(sriov_vf_device);
> > > > > >  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> > > > > > +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> > > > > >
> > > > > >  static struct attribute *sriov_dev_attrs[] = {
> > > > > >         &dev_attr_sriov_totalvfs.attr,
> > > > > > @@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
> > > > > >         &dev_attr_sriov_stride.attr,
> > > > > >         &dev_attr_sriov_vf_device.attr,
> > > > > >         &dev_attr_sriov_drivers_autoprobe.attr,
> > > > > > +       &dev_attr_sriov_vf_total_msix.attr,
> > > > > >         NULL,
> > > > > >  };
> > > > > >
> > > > > > @@ -658,6 +669,7 @@ static void sriov_disable(struct pci_dev *dev)
> > > > > >                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
> > > > > >
> > > > > >         iov->num_VFs = 0;
> > > > > > +       iov->vf_total_msix = 0;
> > > > > >         pci_iov_set_numvfs(dev, 0);
> > > > > >  }
> > > > > >
> > > > > > @@ -1116,6 +1128,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
> > > > > >
> > > > > > +/**
> > > > > > + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> > > > > > + * @dev: the PCI PF device
> > > > > > + * @numb: the total number of MSI-X vector to consume by the VFs
> > > > > > + *
> > > > > > + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> > > > > > + * This interface is complimentary part of the pci_set_msix_vec_count()
> > > > > > + * that will be used to configure the required number on the VF.
> > > > > > + */
> > > > > > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb)
> > > > > > +{
> > > > > > +       if (!dev->is_physfn || !dev->driver ||
> > > > > > +           !dev->driver->sriov_set_msix_vec_count)
> > > > > > +               return;
> > > > > > +
> > > > > > +       dev->sriov->vf_total_msix = numb;
> > > > > > +}
> > > > > > +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> > > > > > +
> > > > >
> > > > > This seems broken. What validation is being done on the numb value?
> > > > > You pass it as int, and your documentation all refers to tests for >=
> > > > > 0, but isn't a signed input a possibility as well? Also "numb" doesn't
> > > > > make for a good abbreviation as it is already a word of its own. It
> > > > > might make more sense to use count or something like that rather than
> > > > > trying to abbreviate number.
> > > >
> > > > "Broken" is a nice word to describe misunderstanding.
> > >
> > > Would you prefer "lacking input validation".
> > >
> > > I see all this code in there checking for is_physfn and driver and
> > > sriov_set_msix_vec_count before allowing the setting of vf_total_msix.
> > > It just seems like a lot of validation is taking place on the wrong
> > > things if you are just going to be setting a value reporting the total
> > > number of MSI-X vectors in use for SR-IOV.
> >
> > All those checks are in place to ensure that we are not overwriting the
> > default value, which is 0.
>
> Okay, so what you really have is surplus interrupts that you are
> wanting to give out to VF devices. So when we indicate 0 here as the
> default it really means we have no additional interrupts to give out.
> Am I understanding that correctly?

The vf_total_msix is static value and shouldn't be recalculated after
every MSI-X vector number change. So 0 means that driver doesn't support
at all this feature. The operator is responsible to make proper assignment
calculations, because he is already doing it for the CPUs and netdev queues.

>
> The problem is this is very vendor specific so I am doing my best to
> understand it as it is different then the other NICs I have worked
> with.

There is nothing vendor specific here. There are two types of devices:
1. Support this feature. - The vf_total_msix will be greater than 0 for them
and their FW will do sanity checks when user overwrites their default number
that they sat in the VF creation stage.
2. Doesn't support this feature - The vf_total_msix will be 0.

It is PCI spec, so those "other NICs" that didn't implement the PCI spec
will stay with option #2. It is not different from current situation.

>
> So this value is the size of the total pool of interrupt vectors you
> have to split up between the functions, or just the spare ones you
> could add to individual VFs? Since you say "total" I am assuming it is
> the total pool which means that in order to figure out how many are
> available to be reserved we would have to run through all the VFs and
> figure out what has already been assigned, correct? If so it wouldn't
> hurt to also think about having a free and in-use count somewhere as
> well.

It is not really necessary, the VFs are created with some defaults,
because FW needs to ensure that after "echo X > sriov_numvfs" everything
is operable.

As we already discussed, FW has no other way but create VFs with same
configuration. It means that user needs to check only first VF MSI-X
number and multiply by number of VFs to get total number of already
consumed.

The reserved vectors are implemented by checks in FW to ensure that user
can't write number below certain level.

I prefer to stay "lean" as much as possible and add extra fields only
after the real need arise. Right now and for seen future, it is not needed.

>
> > >
> > > In addition this value seems like a custom purpose being pushed into
> > > the PCIe code since there isn't anything that defaults the value. It
> > > seems like at a minimum there should be something that programs a
> > > default value for both of these new fields that are being added so
> > > that you pull the maximum number of VFs when SR-IOV is enabled, the
> > > maximum number of MSI-X vectors from a single VF, and then the default
> > > value for this should be the multiple of the two which can then be
> > > overridden later.
> >
> > The default is 0, because most SR-IOV doesn't have proper support of
> > setting VF MSI-X.
>
> It wasn't designed to work this way. That is why it doesn't really work.

It can be true for everything that doesn't work.
I will rewrite my sentence above:
"The default is 0, because I don't have other than mlx5 devices at my disposal,
so leave it to other driver authors to implement their callbacks"

>
> > Regarding the calculation, it is not correct for the mlx5. We have large
> > pool of MSI-X vectors, but setting small number of them. This allows us
> > to increase that number on specific VF without need to decrease on
> > others "to free" the vectors.
>
> I think I am finally starting to grok what is going on here, but I
> really don't like the approach.
>
> Is there any reason why you couldn't have configured your VF to
> support whatever the maximum number of MSI-X vectors you wanted to use
> was, and then just internally masked off or disabled the ones that you
> couldn't allocate to the VF and communicate that to the VF via some
> sort of firmware message so it wouldn't use them? If I am not mistaken
> that is the approach that has been taken in the past for at least this
> portion of things in the Intel drivers.

I'm not proficient in Intel drivers and can't comment it, but the idea
looks very controversial and hacky to me.

There are so many issues with proposed model:
1. During driver probe, the __pci_enable_msix() is called and device MSI-X
number is used to set internal to the kernel and device configuration.
It means that vfio will try to set it to be large (our default is huge),
so we will need to provide some module parameter or sysfs to limit in VFIO
and it should be done per-VM.
2. Without limiting in VFIO during VM attach, the first VM can and will
grab everything and we are returning to square one.
3. The difference in lspci output on the hypervisor and inside VM in
regards of MSI-X vector count will be source of endless bug reports.
4. I afraid that is not how orchestration works.

This supports even more than before the need to do it properly in
pci/core and make user experience clean, easy and reliable.

>
> Then the matter is how to configure it. I'm not a big fan of adding
> sysfs to the VF to manage resources that are meant to be controlled by
> the PF. Especially when you are having to add sysfs to the PF as well
> which creates an asymmetric setup where you are having to read the PF
> to find out what resources you can move to the VF. I wonder if
> something like the Devlink Resource interface wouldn't make more sense
> in this case. Then you would just manage "vf-interrupts" or something
> like that with the resource split between each of the VFs with each VF
> uniquely identified as a separate sub resource.

I remind you that this feature is applicable to all SR-IOV devices, we have
RDMA, NVMe, crypto, FPGA and netdev VFs. The devlink is not supported
outside of netdev world and implementation there will make this feature
is far from being usable.

Right now, the configuration of PCI/core is done through sysfs, so let's
review this feature from PCI/core perspective and not from netdev where
sysfs is not widely used.

Thanks
