Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EB02F679B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbhANR1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbhANR1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 12:27:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD2523B53;
        Thu, 14 Jan 2021 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610645184;
        bh=KGUL3oGL9uMkClqX4GZ4mcMkJnHlMIC4jocOG2mcHyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=baWmyeFvZXn5uKSyEVk4kck0qohHF97JRj6jz96gCg6dtNI4/U8OLOAem51BFLPDK
         uAdUb7rIcRXP0XXFyAQuMQ5DdMXDm3TrXyMp/l9LClstFcc2koCkHN16ZEXMLrZa6Y
         5ppaET3hme0lAt9B0SODjhes6gSIQlZyyVzU6Z7r3WMI3HEblEjHvrBNqWxJkjgzAr
         oUnQxZa7XYmpWzlOTImQaUdBm269YfZO8uevy7Qhx0cEBsuTP4jm88d8kmnX0+uV1y
         H2itx/pMJOJA2qikN0unF9CgzhuUNUtL/NXe81NVrn8dDAGCtqqZW0Y8HhSUVJ1mjo
         +9COpEGMI4xqA==
Date:   Thu, 14 Jan 2021 19:26:20 +0200
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
Message-ID: <20210114172620.GC944463@unreal>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
 <20210112065601.GD4678@unreal>
 <CAKgT0UdndGdA3xONBr62hE-_RBdL-fq6rHLy0PrdsuMn1936TA@mail.gmail.com>
 <20210113061909.GG4678@unreal>
 <CAKgT0Uc4v54vqRVk_HhjOk=OLJu-20AhuBVcg7=C9_hsLtzxLA@mail.gmail.com>
 <20210114065024.GK4678@unreal>
 <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 08:40:14AM -0800, Alexander Duyck wrote:
> On Wed, Jan 13, 2021 at 10:50 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Jan 13, 2021 at 02:44:45PM -0800, Alexander Duyck wrote:
> > > On Tue, Jan 12, 2021 at 10:19 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Tue, Jan 12, 2021 at 01:34:50PM -0800, Alexander Duyck wrote:
> > > > > On Mon, Jan 11, 2021 at 10:56 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > >
> > > > > > On Mon, Jan 11, 2021 at 11:30:39AM -0800, Alexander Duyck wrote:
> > > > > > > On Sun, Jan 10, 2021 at 7:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > > >
> > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > >
> > > > > > > > Some SR-IOV capable devices provide an ability to configure specific
> > > > > > > > number of MSI-X vectors on their VF prior driver is probed on that VF.
> > > > > > > >
> > > > > > > > In order to make management easy, provide new read-only sysfs file that
> > > > > > > > returns a total number of possible to configure MSI-X vectors.
> > > > > > > >
> > > > > > > > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> > > > > > > >   = 0 - feature is not supported
> > > > > > > >   > 0 - total number of MSI-X vectors to consume by the VFs
> > > > > > > >
> > > > > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > > ---
> > > > > > > >  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
> > > > > > > >  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
> > > > > > > >  drivers/pci/pci.h                       |  3 +++
> > > > > > > >  include/linux/pci.h                     |  2 ++
> > > > > > > >  4 files changed, 50 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > > > index 05e26e5da54e..64e9b700acc9 100644
> > > > > > > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > > > @@ -395,3 +395,17 @@ Description:
> > > > > > > >                 The file is writable if the PF is bound to a driver that
> > > > > > > >                 supports the ->sriov_set_msix_vec_count() callback and there
> > > > > > > >                 is no driver bound to the VF.
> > > > > > > > +
> > > > > > > > +What:          /sys/bus/pci/devices/.../sriov_vf_total_msix
> > > > > > >
> > > > > > > In this case I would drop the "vf" and just go with sriov_total_msix
> > > > > > > since now you are referring to a global value instead of a per VF
> > > > > > > value.
> > > > > >
> > > > > > This field indicates the amount of MSI-X available for VFs, it doesn't
> > > > > > include PFs. The missing "_vf_" will mislead users who will believe that
> > > > > > it is all MSI-X vectors available for this device. They will need to take
> > > > > > into consideration amount of PF MSI-X in order to calculate the VF distribution.
> > > > > >
> > > > > > So I would leave "_vf_" here.
> > > > >
> > > > > The problem is you aren't indicating how many are available for an
> > > > > individual VF though, you are indicating how many are available for
> > > > > use by SR-IOV to give to the VFs. The fact that you are dealing with a
> > > > > pool makes things confusing in my opinion. For example sriov_vf_device
> > > > > describes the device ID that will be given to each VF.
> > > >
> > > > sriov_vf_device is different and is implemented accordingly to the PCI
> > > > spec, 9.3.3.11 VF Device ID (Offset 1Ah)
> > > > "This field contains the Device ID that should be presented for every VF
> > > > to the SI."
> > > >
> > > > It is one ID for all VFs.
> > >
> > > Yes, but that is what I am getting at. It is also what the device
> > > configuration will be for one VF. So when I read sriov_vf_total_msix
> > > it reads as the total for a single VF, not all of the the VFs. That is
> > > why I think dropping the "vf_" part of the name would make sense, as
> > > what you are describing is the total number of MSI-X vectors for use
> > > by SR-IOV VFs.
> >
> > I can change to anything as long as new name will give clear indication
> > that this total number is for VFs and doesn't include SR-IOV PF MSI-X.
>
> It is interesting that you make that distinction.
>
> So in the case of the Intel hardware we had one pool of MSI-X
> interrupts that was available for the entire port, both PF and VF.
> When we enabled SR-IOV we had to repartition that pool in order to
> assign interrupts to devices. So it sounds like in your case you don't
> do that and instead the PF is static and the VFs are the only piece
> that is flexible. Do I have that correct?

It is partially correct. The mlx5 devices have ability to change MSI-X
vectors of PF too, but to do so, you will need driver reload and much
more complex user interface. So we (SW) leave it as static.

>
> > >
> > > > >
> > > > > > >
> > > > > > > > +Date:          January 2021
> > > > > > > > +Contact:       Leon Romanovsky <leonro@nvidia.com>
> > > > > > > > +Description:
> > > > > > > > +               This file is associated with the SR-IOV PFs.
> > > > > > > > +               It returns a total number of possible to configure MSI-X
> > > > > > > > +               vectors on the enabled VFs.
> > > > > > > > +
> > > > > > > > +               The values returned are:
> > > > > > > > +                * > 0 - this will be total number possible to consume by VFs,
> > > > > > > > +                * = 0 - feature is not supported
> > > > > > > > +
> > > > > > > > +               If no SR-IOV VFs are enabled, this value will return 0.
> > > > > > > > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > > > > > > > index 42c0df4158d1..0a6ddf3230fd 100644
> > > > > > > > --- a/drivers/pci/iov.c
> > > > > > > > +++ b/drivers/pci/iov.c
> > > > > > > > @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
> > > > > > > >         return count;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> > > > > > > > +                                       struct device_attribute *attr,
> > > > > > > > +                                       char *buf)
> > > > > > > > +{
> > > > > > > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > > > > > > +
> > > > > > > > +       return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);
> > > > > > > > +}
> > > > > > > > +
> > > > > > >
> > > > > > > You display it as a signed value, but unsigned values are not
> > > > > > > supported, correct?
> > > > > >
> > > > > > Right, I made it similar to the vf_msix_set. I can change.
> > > > > >
> > > > > > >
> > > > > > > >  static DEVICE_ATTR_RO(sriov_totalvfs);
> > > > > > > >  static DEVICE_ATTR_RW(sriov_numvfs);
> > > > > > > >  static DEVICE_ATTR_RO(sriov_offset);
> > > > > > > >  static DEVICE_ATTR_RO(sriov_stride);
> > > > > > > >  static DEVICE_ATTR_RO(sriov_vf_device);
> > > > > > > >  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> > > > > > > > +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> > > > > > > >
> > > > > > > >  static struct attribute *sriov_dev_attrs[] = {
> > > > > > > >         &dev_attr_sriov_totalvfs.attr,
> > > > > > > > @@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
> > > > > > > >         &dev_attr_sriov_stride.attr,
> > > > > > > >         &dev_attr_sriov_vf_device.attr,
> > > > > > > >         &dev_attr_sriov_drivers_autoprobe.attr,
> > > > > > > > +       &dev_attr_sriov_vf_total_msix.attr,
> > > > > > > >         NULL,
> > > > > > > >  };
> > > > > > > >
> > > > > > > > @@ -658,6 +669,7 @@ static void sriov_disable(struct pci_dev *dev)
> > > > > > > >                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
> > > > > > > >
> > > > > > > >         iov->num_VFs = 0;
> > > > > > > > +       iov->vf_total_msix = 0;
> > > > > > > >         pci_iov_set_numvfs(dev, 0);
> > > > > > > >  }
> > > > > > > >
> > > > > > > > @@ -1116,6 +1128,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
> > > > > > > >  }
> > > > > > > >  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
> > > > > > > >
> > > > > > > > +/**
> > > > > > > > + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> > > > > > > > + * @dev: the PCI PF device
> > > > > > > > + * @numb: the total number of MSI-X vector to consume by the VFs
> > > > > > > > + *
> > > > > > > > + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> > > > > > > > + * This interface is complimentary part of the pci_set_msix_vec_count()
> > > > > > > > + * that will be used to configure the required number on the VF.
> > > > > > > > + */
> > > > > > > > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb)
> > > > > > > > +{
> > > > > > > > +       if (!dev->is_physfn || !dev->driver ||
> > > > > > > > +           !dev->driver->sriov_set_msix_vec_count)
> > > > > > > > +               return;
> > > > > > > > +
> > > > > > > > +       dev->sriov->vf_total_msix = numb;
> > > > > > > > +}
> > > > > > > > +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> > > > > > > > +
> > > > > > >
> > > > > > > This seems broken. What validation is being done on the numb value?
> > > > > > > You pass it as int, and your documentation all refers to tests for >=
> > > > > > > 0, but isn't a signed input a possibility as well? Also "numb" doesn't
> > > > > > > make for a good abbreviation as it is already a word of its own. It
> > > > > > > might make more sense to use count or something like that rather than
> > > > > > > trying to abbreviate number.
> > > > > >
> > > > > > "Broken" is a nice word to describe misunderstanding.
> > > > >
> > > > > Would you prefer "lacking input validation".
> > > > >
> > > > > I see all this code in there checking for is_physfn and driver and
> > > > > sriov_set_msix_vec_count before allowing the setting of vf_total_msix.
> > > > > It just seems like a lot of validation is taking place on the wrong
> > > > > things if you are just going to be setting a value reporting the total
> > > > > number of MSI-X vectors in use for SR-IOV.
> > > >
> > > > All those checks are in place to ensure that we are not overwriting the
> > > > default value, which is 0.
> > >
> > > Okay, so what you really have is surplus interrupts that you are
> > > wanting to give out to VF devices. So when we indicate 0 here as the
> > > default it really means we have no additional interrupts to give out.
> > > Am I understanding that correctly?
> >
> > The vf_total_msix is static value and shouldn't be recalculated after
> > every MSI-X vector number change. So 0 means that driver doesn't support
> > at all this feature. The operator is responsible to make proper assignment
> > calculations, because he is already doing it for the CPUs and netdev queues.
>
> Honestly that makes things even uglier. So basically this is a feature
> where if it isn't supported it will make it look like the SR-IOV
> device doesn't support MSI-X. I realize it is just the way it is
> worded but it isn't very pretty.

I'm not native English speaker, we can work together later on the
Documentation to make it more clear.

>
> > >
> > > The problem is this is very vendor specific so I am doing my best to
> > > understand it as it is different then the other NICs I have worked
> > > with.
> >
> > There is nothing vendor specific here. There are two types of devices:
> > 1. Support this feature. - The vf_total_msix will be greater than 0 for them
> > and their FW will do sanity checks when user overwrites their default number
> > that they sat in the VF creation stage.
> > 2. Doesn't support this feature - The vf_total_msix will be 0.
> >
> > It is PCI spec, so those "other NICs" that didn't implement the PCI spec
> > will stay with option #2. It is not different from current situation.
>
> Where in the spec is this?
>
> I know in the PCI spec it says that the MSI-X table size is read-only
> and is not supposed to be written by system software. That is what is
> being overwritten right now by your patches that has me concerned.

My patches are not over-writting anything, they are asking from FW to
set more appropriate value. The field stays read-only.

<...>

> >
> > I remind you that this feature is applicable to all SR-IOV devices, we have
> > RDMA, NVMe, crypto, FPGA and netdev VFs. The devlink is not supported
> > outside of netdev world and implementation there will make this feature
> > is far from being usable.
>
> To quote the documentation:
> "devlink is an API to expose device information and resources not directly
> related to any device class, such as chip-wide/switch-ASIC-wide configuration."

There is a great world outside of netdev and it doesn't include devlink. :)

>
> > Right now, the configuration of PCI/core is done through sysfs, so let's
> > review this feature from PCI/core perspective and not from netdev where
> > sysfs is not widely used.
>
> The problem is what you are configuring is not necessarily PCI device
> specific. You are configuring the firmware which operates at a level
> above the PCI device. You just have it manifesting as a PCI behavior
> as you are editing a read-only configuration space field.

In our devices, PCI config space is managed by FW and it represents HW.

>
> Also as I mentioned a few times now the approach you are taking
> violates the PCIe spec by essentially providing a means of making a
> read-only field writable.

AS you said, we see the same picture differently.

Thansk
