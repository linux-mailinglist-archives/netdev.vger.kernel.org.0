Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295752F2899
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391602AbhALG4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbhALG4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 01:56:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C7AC22AAF;
        Tue, 12 Jan 2021 06:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610434565;
        bh=5vRK0VD1rFHmEvf6NfJkIugDWxsEb+dTmpoax0jk+Ic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mc5EpUwm4Fx5pDZ4HB2d6Pw5srv1rQs8c4qgDmw2FS/MOhDPSIj4WDjiYZW+aVVPq
         aO7TjLBX4vJVcD4mVQraW0y4IMPmot0xRWYkQPERt9DUh975jcNLP7N4R2haN67bWr
         P/GfcmmAhjdEBUDWYtVQx+tJz6YytkzmFsCOiz+lRl0Yb3Bs2MwUXqybKhOEhf4aAq
         gS9gz+YYlre6+BE1lvypG3DujPxSc2eiY7QpW+c0+JYzVSEEf3k2inTgjTIghkfBod
         GBLksOBmFpBlynualtv3srcAiJjSJX0ZJAitlj1rNObhBsM3kqBagmCg00pVIaNX02
         KTDZoVFQO24Ow==
Date:   Tue, 12 Jan 2021 08:56:01 +0200
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
Message-ID: <20210112065601.GD4678@unreal>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-3-leon@kernel.org>
 <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uczu6cULPsVjFuFVmir35SpL-bs0hosbfH-T5sZLZ78BQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:30:39AM -0800, Alexander Duyck wrote:
> On Sun, Jan 10, 2021 at 7:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Some SR-IOV capable devices provide an ability to configure specific
> > number of MSI-X vectors on their VF prior driver is probed on that VF.
> >
> > In order to make management easy, provide new read-only sysfs file that
> > returns a total number of possible to configure MSI-X vectors.
> >
> > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> >   = 0 - feature is not supported
> >   > 0 - total number of MSI-X vectors to consume by the VFs
> >
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
> >  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
> >  drivers/pci/pci.h                       |  3 +++
> >  include/linux/pci.h                     |  2 ++
> >  4 files changed, 50 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > index 05e26e5da54e..64e9b700acc9 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > @@ -395,3 +395,17 @@ Description:
> >                 The file is writable if the PF is bound to a driver that
> >                 supports the ->sriov_set_msix_vec_count() callback and there
> >                 is no driver bound to the VF.
> > +
> > +What:          /sys/bus/pci/devices/.../sriov_vf_total_msix
>
> In this case I would drop the "vf" and just go with sriov_total_msix
> since now you are referring to a global value instead of a per VF
> value.

This field indicates the amount of MSI-X available for VFs, it doesn't
include PFs. The missing "_vf_" will mislead users who will believe that
it is all MSI-X vectors available for this device. They will need to take
into consideration amount of PF MSI-X in order to calculate the VF distribution.

So I would leave "_vf_" here.

>
> > +Date:          January 2021
> > +Contact:       Leon Romanovsky <leonro@nvidia.com>
> > +Description:
> > +               This file is associated with the SR-IOV PFs.
> > +               It returns a total number of possible to configure MSI-X
> > +               vectors on the enabled VFs.
> > +
> > +               The values returned are:
> > +                * > 0 - this will be total number possible to consume by VFs,
> > +                * = 0 - feature is not supported
> > +
> > +               If no SR-IOV VFs are enabled, this value will return 0.
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > index 42c0df4158d1..0a6ddf3230fd 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
> >         return count;
> >  }
> >
> > +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> > +                                       struct device_attribute *attr,
> > +                                       char *buf)
> > +{
> > +       struct pci_dev *pdev = to_pci_dev(dev);
> > +
> > +       return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);
> > +}
> > +
>
> You display it as a signed value, but unsigned values are not
> supported, correct?

Right, I made it similar to the vf_msix_set. I can change.

>
> >  static DEVICE_ATTR_RO(sriov_totalvfs);
> >  static DEVICE_ATTR_RW(sriov_numvfs);
> >  static DEVICE_ATTR_RO(sriov_offset);
> >  static DEVICE_ATTR_RO(sriov_stride);
> >  static DEVICE_ATTR_RO(sriov_vf_device);
> >  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> > +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> >
> >  static struct attribute *sriov_dev_attrs[] = {
> >         &dev_attr_sriov_totalvfs.attr,
> > @@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
> >         &dev_attr_sriov_stride.attr,
> >         &dev_attr_sriov_vf_device.attr,
> >         &dev_attr_sriov_drivers_autoprobe.attr,
> > +       &dev_attr_sriov_vf_total_msix.attr,
> >         NULL,
> >  };
> >
> > @@ -658,6 +669,7 @@ static void sriov_disable(struct pci_dev *dev)
> >                 sysfs_remove_link(&dev->dev.kobj, "dep_link");
> >
> >         iov->num_VFs = 0;
> > +       iov->vf_total_msix = 0;
> >         pci_iov_set_numvfs(dev, 0);
> >  }
> >
> > @@ -1116,6 +1128,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
> >
> > +/**
> > + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> > + * @dev: the PCI PF device
> > + * @numb: the total number of MSI-X vector to consume by the VFs
> > + *
> > + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> > + * This interface is complimentary part of the pci_set_msix_vec_count()
> > + * that will be used to configure the required number on the VF.
> > + */
> > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb)
> > +{
> > +       if (!dev->is_physfn || !dev->driver ||
> > +           !dev->driver->sriov_set_msix_vec_count)
> > +               return;
> > +
> > +       dev->sriov->vf_total_msix = numb;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> > +
>
> This seems broken. What validation is being done on the numb value?
> You pass it as int, and your documentation all refers to tests for >=
> 0, but isn't a signed input a possibility as well? Also "numb" doesn't
> make for a good abbreviation as it is already a word of its own. It
> might make more sense to use count or something like that rather than
> trying to abbreviate number.

"Broken" is a nice word to describe misunderstanding.

The vf_total_msix is not set by the users and used solely by the drivers
to advertise their capability. This field is needed to give a way to
calculate how much MSI-X VFs can get. The driver code is part of the
kernel and like any other kernel code, it is trusted.

I'm checking < 0 in another _set_ routine to make sure that we will be
able to extend this sysfs entry if at some point of time negative vector
count will make sense.

"Count" instead of "numb" is fine by me.

>
>
> >  /**
> >   * pci_sriov_configure_simple - helper to configure SR-IOV
> >   * @dev: the PCI device
> > diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> > index 1fd273077637..0fbe291eb0f2 100644
> > --- a/drivers/pci/pci.h
> > +++ b/drivers/pci/pci.h
> > @@ -327,6 +327,9 @@ struct pci_sriov {
> >         u16             subsystem_device; /* VF subsystem device */
> >         resource_size_t barsz[PCI_SRIOV_NUM_BARS];      /* VF BAR size */
> >         bool            drivers_autoprobe; /* Auto probing of VFs by driver */
> > +       int             vf_total_msix;  /* Total number of MSI-X vectors the VFs
> > +                                        * can consume
> > +                                        */
> >  };
> >
> >  /**
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index a17cfc28eb66..fd9ff1f42a09 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -2074,6 +2074,7 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev);
> >  int pci_sriov_configure_simple(struct pci_dev *dev, int nr_virtfn);
> >  resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno);
> >  void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe);
> > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb);
> >
> >  /* Arch may override these (weak) */
> >  int pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs);
> > @@ -2114,6 +2115,7 @@ static inline int pci_sriov_get_totalvfs(struct pci_dev *dev)
> >  static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
> >  { return 0; }
> >  static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
> > +static inline void pci_sriov_set_vf_total_msix(struct pci_dev *dev, int numb) {}
> >  #endif
> >
> >  #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
> > --
> > 2.29.2
> >
