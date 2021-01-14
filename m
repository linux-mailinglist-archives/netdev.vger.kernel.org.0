Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C43E2F5B29
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbhANHRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbhANHRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 02:17:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 326012311F;
        Thu, 14 Jan 2021 07:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610608614;
        bh=5DxTNM0Xk+VzQmaLJSGV9LER2ZCiGhWWw2gqm54zeaY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lg3IxBMa9y1OHOXbchOcL+rODgEWjCj6DmbncZX3JKxdKAx0JpxSQsglrSefTUU4W
         9m2miQepvgWB6M9w5TTAhX3HBNKeUsVvAJQJpNH9odVD+LfOBXxwhoIzxGdkSXwthD
         8Ry8rBt71tU5Z1e+XyNItU9ikJKJnX4QRSbsTEONgRKFdYeWqKhrEtGMl1BckKVy1l
         STe+ZYKghi5kriBpVW2vvuoRjPoSQAFJjLWTMhu03MnZsI7UNPov6tsWtUdycYXCmm
         RpqCc72xVOK6GvX4hrMK6SFpkCh7Jt0ABdF+iP5gmS4TLYu6UhmqntHCVpvulxr0G1
         o+uSEKZrzUtxQ==
Date:   Thu, 14 Jan 2021 09:16:49 +0200
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
Message-ID: <20210114071649.GL4678@unreal>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-2-leon@kernel.org>
 <CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com>
 <20210112063925.GC4678@unreal>
 <CAKgT0Udxd01agBMruooMi8TfAE+QkMt8n7-a2QrZ7Pj6-oFEAg@mail.gmail.com>
 <20210113060938.GF4678@unreal>
 <CAKgT0UecBX+LTR9GuxFb=P+pcUkjU5RYNNjeynExS-9Pik1Hsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UecBX+LTR9GuxFb=P+pcUkjU5RYNNjeynExS-9Pik1Hsg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 12:00:00PM -0800, Alexander Duyck wrote:
> On Tue, Jan 12, 2021 at 10:09 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Jan 12, 2021 at 01:59:51PM -0800, Alexander Duyck wrote:
> > > On Mon, Jan 11, 2021 at 10:39 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Mon, Jan 11, 2021 at 11:30:33AM -0800, Alexander Duyck wrote:
> > > > > On Sun, Jan 10, 2021 at 7:12 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > >
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > >
> > > > > > Extend PCI sysfs interface with a new callback that allows configure
> > > > > > the number of MSI-X vectors for specific SR-IO VF. This is needed
> > > > > > to optimize the performance of newly bound devices by allocating
> > > > > > the number of vectors based on the administrator knowledge of targeted VM.
> > > > > >
> > > > > > This function is applicable for SR-IOV VF because such devices allocate
> > > > > > their MSI-X table before they will run on the VMs and HW can't guess the
> > > > > > right number of vectors, so the HW allocates them statically and equally.
> > > > > >
> > > > > > The newly added /sys/bus/pci/devices/.../vf_msix_vec file will be seen
> > > > > > for the VFs and it is writable as long as a driver is not bounded to the VF.
> > > > > >
> > > > > > The values accepted are:
> > > > > >  * > 0 - this will be number reported by the VF's MSI-X capability
> > > > > >  * < 0 - not valid
> > > > > >  * = 0 - will reset to the device default value
> > > > > >
> > > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > > ---
> > > > > >  Documentation/ABI/testing/sysfs-bus-pci | 20 ++++++++
> > > > > >  drivers/pci/iov.c                       | 62 +++++++++++++++++++++++++
> > > > > >  drivers/pci/msi.c                       | 29 ++++++++++++
> > > > > >  drivers/pci/pci-sysfs.c                 |  1 +
> > > > > >  drivers/pci/pci.h                       |  2 +
> > > > > >  include/linux/pci.h                     |  8 +++-
> > > > > >  6 files changed, 121 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > index 25c9c39770c6..05e26e5da54e 100644
> > > > > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > > > > @@ -375,3 +375,23 @@ Description:
> > > > > >                 The value comes from the PCI kernel device state and can be one
> > > > > >                 of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
> > > > > >                 The file is read only.
> > > > > > +
> > > > > > +What:          /sys/bus/pci/devices/.../vf_msix_vec
> > > > >
> > > > > So the name for this doesn't seem to match existing SR-IOV naming.  It
> > > > > seems like this should probably be something like sriov_vf_msix_count
> > > > > in order to be closer to the actual naming of what is being dealt
> > > > > with.
> > > >
> > > > I'm open for suggestions. I didn't use sriov_vf_msix_count because it
> > > > seems too long for me.
> > > >
> > > > >
> > > > > > +Date:          December 2020
> > > > > > +Contact:       Leon Romanovsky <leonro@nvidia.com>
> > > > > > +Description:
> > > > > > +               This file is associated with the SR-IOV VFs.
> > > > > > +               It allows configuration of the number of MSI-X vectors for
> > > > > > +               the VF. This is needed to optimize performance of newly bound
> > > > > > +               devices by allocating the number of vectors based on the
> > > > > > +               administrator knowledge of targeted VM.
> > > > > > +
> > > > > > +               The values accepted are:
> > > > > > +                * > 0 - this will be number reported by the VF's MSI-X
> > > > > > +                        capability
> > > > > > +                * < 0 - not valid
> > > > > > +                * = 0 - will reset to the device default value
> > > > > > +
> > > > > > +               The file is writable if the PF is bound to a driver that
> > > > > > +               supports the ->sriov_set_msix_vec_count() callback and there
> > > > > > +               is no driver bound to the VF.
> > > > > > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > > > > > index 4afd4ee4f7f0..42c0df4158d1 100644
> > > > > > --- a/drivers/pci/iov.c
> > > > > > +++ b/drivers/pci/iov.c
> > > > > > @@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
> > > > > >         return (dev->devfn + dev->sriov->offset +
> > > > > >                 dev->sriov->stride * vf_id) & 0xff;
> > > > > >  }
> > > > > > +EXPORT_SYMBOL(pci_iov_virtfn_devfn);
> > > > > >
> > > > > >  /*
> > > > > >   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
> > > > > > @@ -426,6 +427,67 @@ const struct attribute_group sriov_dev_attr_group = {
> > > > > >         .is_visible = sriov_attrs_are_visible,
> > > > > >  };
> > > > > >
> > > > > > +#ifdef CONFIG_PCI_MSI
> > > > > > +static ssize_t vf_msix_vec_show(struct device *dev,
> > > > > > +                               struct device_attribute *attr, char *buf)
> > > > > > +{
> > > > > > +       struct pci_dev *pdev = to_pci_dev(dev);
> > > > > > +       int numb = pci_msix_vec_count(pdev);
> > > > > > +       struct pci_dev *pfdev;
> > > > > > +
> > > > > > +       if (numb < 0)
> > > > > > +               return numb;
> > > > > > +
> > > > > > +       pfdev = pci_physfn(pdev);
> > > > > > +       if (!pfdev->driver || !pfdev->driver->sriov_set_msix_vec_count)
> > > > > > +               return -EOPNOTSUPP;
> > > > > > +
> > > > >
> > > > > This doesn't make sense to me. You are getting the vector count for
> > > > > the PCI device and reporting that. Are you expecting to call this on
> > > > > the PF or the VFs? It seems like this should be a PF attribute and not
> > > > > be called on the individual VFs.
> > > >
> > > > We had this discussion over v0 variant of this series.
> > > > https://lore.kernel.org/linux-pci/20210108072525.GB31158@unreal/
> > > >
> > > > This is per-VF property, but this VF is not bounded to the driver so you
> > > > need some way to convey new number to the HW, so it will update PCI value.
> > > >
> > > > You must change/update this field after VF is created, because all SR-IOV VFs
> > > > are created at the same time. The operator (administrator/orchestration
> > > > software/e.t.c) will know the right amount of MSI-X vectors right before
> > > > he will bind this VF to requested VM.
> > > >
> > > > It means that extending PF sysfs to get both VF index and count will
> > > > look very unfriendly for the users.
> > > >
> > > > The PF here is an anchor to the relevant driver.
> > >
> > > Yes, but the problem is you are attempting to do it after a driver may
> > > have already bound itself to the VF device. This setup works for the
> > > direct assigned VF case, however if the VF drivers are running on the
> > > host then this gets ugly as the driver may already be up and running.
> >
> > Please take a look on the pci_set_msix_vec_count() implementation, it
> > checks that VF is not probed yet. I outlined this requirement almost
> > in all my responses and commit messages.
> >
> > So no, it is not possible to set MSI-X vectors to already bound device.
>
> Unless you are holding the device lock you cannot guarantee that as
> Alex Williamson pointed out you can end up racing with the driver
> probe/remove.

Yeah, I overlooked it, thanks.

>
> Secondly the fact that the driver might be probed before you even get
> to make your call will cause this to return EOPNOTSUPP which doesn't
> exactly make sense since it is supported, you just cannot do it since
> the device is busy.

I'll return -EBUSY.

>
> > >
> > > Also I am not a big fan of the VF groping around looking for a PF
> > > interface as it means the interface will likely be exposed in the
> > > guest as well, but it just won't work.
> >
> > If you are referring to VF exposed to the VM, so in this case VF must be
> > bound too vfio driver, or any other driver, and won't allow MSI-X change.
> > If you are referring to PF exposed to the VM, it is very unlikely scenario
> > in real world and reserved for braves among us. Even in this case, the
> > set MSI-X won't work, because PF will be connected to the hypervisor driver
> > that doesn't support set_msix.
> >
> > So both cases are handled.
>
> I get that they are handled. However I am not a huge fan of the sysfs
> attributes for one device being dependent on another device. When you
> have to start searching for another device it just makes things messy.

This is pretty common way, nothing new here.

>
> > >
> > > > >
> > > > > If you are calling this on the VFs then it doesn't really make any
> > > > > sense anyway since the VF is not a "VF PCI dev representor" and
> > > > > shouldn't be treated as such. In my opinion if we are going to be
> > > > > doing per-port resource limiting that is something that might make
> > > > > more sense as a part of the devlink configuration for the VF since the
> > > > > actual change won't be visible to an assigned device.
> > > >
> > > > https://lore.kernel.org/linux-pci/20210112061535.GB4678@unreal/
> > >
> > > So the question I would have is if we are spawning the VFs and
> > > expecting them to have different configs or the same configuration?
> >
> > By default, they have same configuration.
> >
> > > I'm assuming in your case you are looking for a different
> > > configuration per port. Do I have that correct?
> >
> > No, per-VF as represents one device in the PCI world. For example, mlx5
> > can have more than one physical port.
>
> Sorry, I meant per virtual function, not per port.

Yes, PCI spec is clear, MSI-X vector count is per-device and in our case
it means per-VF.

>
> > >
> > > Where this gets ugly is that SR-IOV assumes a certain uniformity per
> > > VF so doing a per-VF custom limitation gets ugly pretty quick.
> >
> > I don't find any support for this "uniformity" claim in the PCI spec.
>
> I am referring to the PCI configuration space. Each VF ends up with
> some fixed amount of MMIO resources per function. So typically when
> you spawn VFs we had things setup so that all you do is say how many
> you want.
>
> > > I wonder if it would make more sense if we are going this route to just
> > > define a device-tree like schema that could be fed in to enable VFs
> > > instead of just using echo X > sriov_numvfs and then trying to fix
> > > things afterwards. Then you could define this and other features that
> > > I am sure you would need in the future via json-schema like is done in
> > > device-tree and write it once enabling the set of VFs that you need.
> >
> > Sorry, but this is overkill, it won't give us much and it doesn't fit
> > the VF usage model at all.
> >
> > Right now, all heavy users of SR-IOV are creating many VFs up to the maximum.
> > They do it with autoprobe disabled, because it is too time consuming to wait
> > till all VFs probe themselves and unbind them later.
> >
> > After that, they wait for incoming request to provision VM on VF, they set MAC
> > address, change MSI-X according to VM properties and bind that VF to new VM.
> >
> > So MSI-X change is done after VFs were created.
>
> So if I understand correctly based on your comments below you are
> dynamically changing the VF's MSI-X configuration space then?

I'm changing "Table Size" from "7.7.2.2 Message Control Register for
MSI-X (Offset 02h)" and nothing more.

If you do raw PCI read before and after, only this field will be changed.

>
> > >
> > > Given that SR-IOV isn't meant to be tweaked dynamically it seems like
> > > that would be a much better fit for most users as then you can just
> > > modify the schema and reload it which would probably be less effort
> > > than having to manually redo all the commands needed to setup the VFs
> > > using this approach if you are having to manually update each VF.
> >
> > Quite opposite it true. First users use orchestration software to manage it.
> > Second, you will need to take care of already bound device.
>
> This is the part that concerns me. It seems like this is all adding a
> bunch of orchestration need to all of this. Basically the device
> config can shift out from under us on the host if we aren't paying
> attention.

I just presented one possible use case that is for sure will be used here.
Nothing prohibits from curious user to block driver probe, or to unbind
or do any other trick to ensure that driver is not probed.

>
> > >
> > > > >
> > > > > > +       return sprintf(buf, "%d\n", numb);
> > > > > > +}
> > > > > > +
> > > > > > +static ssize_t vf_msix_vec_store(struct device *dev,
> > > > > > +                                struct device_attribute *attr, const char *buf,
> > > > > > +                                size_t count)
> > > > > > +{
> > > > > > +       struct pci_dev *vf_dev = to_pci_dev(dev);
> > > > > > +       int val, ret;
> > > > > > +
> > > > > > +       ret = kstrtoint(buf, 0, &val);
> > > > > > +       if (ret)
> > > > > > +               return ret;
> > > > > > +
> > > > > > +       ret = pci_set_msix_vec_count(vf_dev, val);
> > > > > > +       if (ret)
> > > > > > +               return ret;
> > > > > > +
> > > > > > +       return count;
> > > > > > +}
> > > > > > +static DEVICE_ATTR_RW(vf_msix_vec);
> > > > > > +#endif
> > > > > > +
> > > > > > +static struct attribute *sriov_vf_dev_attrs[] = {
> > > > > > +#ifdef CONFIG_PCI_MSI
> > > > > > +       &dev_attr_vf_msix_vec.attr,
> > > > > > +#endif
> > > > > > +       NULL,
> > > > > > +};
> > > > > > +
> > > > > > +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> > > > > > +                                         struct attribute *a, int n)
> > > > > > +{
> > > > > > +       struct device *dev = kobj_to_dev(kobj);
> > > > > > +
> > > > > > +       if (dev_is_pf(dev))
> > > > > > +               return 0;
> > > > > > +
> > > > > > +       return a->mode;
> > > > > > +}
> > > > > > +
> > > > > > +const struct attribute_group sriov_vf_dev_attr_group = {
> > > > > > +       .attrs = sriov_vf_dev_attrs,
> > > > > > +       .is_visible = sriov_vf_attrs_are_visible,
> > > > > > +};
> > > > > > +
> > > > > >  int __weak pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs)
> > > > > >  {
> > > > > >         return 0;
> > > > > > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > > > > > index 3162f88fe940..20705ca94666 100644
> > > > > > --- a/drivers/pci/msi.c
> > > > > > +++ b/drivers/pci/msi.c
> > > > > > @@ -991,6 +991,35 @@ int pci_msix_vec_count(struct pci_dev *dev)
> > > > > >  }
> > > > > >  EXPORT_SYMBOL(pci_msix_vec_count);
> > > > > >
> > > > > > +/**
> > > > > > + * pci_set_msix_vec_count - change the reported number of MSI-X vectors
> > > > > > + * This function is applicable for SR-IOV VF because such devices allocate
> > > > > > + * their MSI-X table before they will run on the VMs and HW can't guess the
> > > > > > + * right number of vectors, so the HW allocates them statically and equally.
> > > > > > + * @dev: VF device that is going to be changed
> > > > > > + * @numb: amount of MSI-X vectors
> > > > > > + **/
> > > > > > +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
> > > > > > +{
> > > > > > +       struct pci_dev *pdev = pci_physfn(dev);
> > > > > > +
> > > > > > +       if (!dev->msix_cap || !pdev->msix_cap)
> > > > > > +               return -EINVAL;
> > > > > > +
> > > > > > +       if (dev->driver || !pdev->driver ||
> > > > > > +           !pdev->driver->sriov_set_msix_vec_count)
> > > > > > +               return -EOPNOTSUPP;
> > > > > > +
> > > > > > +       if (numb < 0)
> > > > > > +               /*
> > > > > > +                * We don't support negative numbers for now,
> > > > > > +                * but maybe in the future it will make sense.
> > > > > > +                */
> > > > > > +               return -EINVAL;
> > > > > > +
> > > > > > +       return pdev->driver->sriov_set_msix_vec_count(dev, numb);
> > > > > > +}
> > > > > > +
> > > > >
> > > > > If you are going to have a set operation for this it would make sense
> > > > > to have a get operation. Your show operation seems unbalanced since
> > > > > you are expecting to call it on the VF directly which just seems
> > > > > wrong.
> > > >
> > > > There is already get operator - pci_msix_vec_count().
> > > > The same as above, PF is an anchor for the driver. VF doesn't have
> > > > driver yet and we can't write directly to this PCI field - it is read-only.
> > >
> > > That returns the maximum. I would want to know what the value is that
> > > you wrote here.
> >
> > It returns the value from the device and not maximum.
>
> Okay, that was the part I hadn't caught onto. That you were using this
> to make read-only configuration space writable.
>
> > >
> > > Also being able to change this once the device already exists is kind
> > > of an ugly setup as I would imagine there will be cases where the
> > > device has already partitioned out the vectors that it wanted.
> >
> > It is not possible, because all VFs starts with some value. Normal FW
> > won't allow you to decrease vector count below certain limit.
> >
> > So VFs are always operable.
>
> I get that. My concern is more the fact that you are modifying read
> only bits within the configuration space that is visible to the host.

Yes, and this is why it is done through PF and without driver probes
and with driver callback. It is done to make coherent picture for the
administrator and VM user.

> I initially thought you were doing the dynamic resizing behind the
> scenes by just not enabling some of the MSI-X vectors in the table.
> However, as I understand it now you are resizing the MSI-X table
> itself which doesn't seem correct to me. The read-only portions of the
> configuration space shouldn't be changed, at least within the host. I
> just see the changing of fields that are expected to be static to be
> problematic.

This is why sriov_drivers_autoprobe exist, to configure device prior
driver initialization.

>
> If all of this is just to tweak the MSI-X table size in the guest
> /userspace wouldn't it just make more sense to add the ability for
> vfio to limit this directly and perhaps intercept the reads to the
> MSI-X control register? Then you could have vfio also take care of the
> coordination of things with the driver which would make much more
> sense to me as then you don't have to worry about a device on the host
> changing size unexpectedly.

I hope that I provided answers in parallel thread on why vfio solution
is not viable.

>
> Anyway that is just my $.02.
>
> - Alex
