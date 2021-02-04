Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1C130F717
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhBDQBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237455AbhBDPve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 10:51:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2592564F53;
        Thu,  4 Feb 2021 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612453851;
        bh=gVzi+q4p4yScoyRUHjNRfwEoOlDDN/dr3dOE58csVn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uJo0fPpnTNOXbLHPuXUCCXgkVLu4rM2RJIQ9ipiTjiEKXyNcdsYToZZqiwhS0w1SJ
         ToW4WGEfkbTVB5rF1fs83pvtHrXWdDeiveii0Pl/2CEFs1ljty5/AMOZQawXi2naXB
         cxTkAQ4phrrzNzUhg7hLol+/J3bAnujGwcqz83BGsq80ZUytKHs5nr8WR+vYEdVbX8
         2giq9s+OPPNZYer52C7rpiVIEIfMuKggPmtayZtG1r75IW1YL4w/0K7eOl3tl9lxV5
         /g3tRTxwCfJGauzf9TXiaMyhWbnImoC6VZbyGyJ4+9Slf7uM+mDGWHCZUAIJuXTwDb
         iPH8BTIIElJAQ==
Date:   Thu, 4 Feb 2021 17:50:48 +0200
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
Message-ID: <20210204155048.GC93433@unreal>
References: <20210202194429.GH3264866@unreal>
 <20210204001039.GA16871@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204001039.GA16871@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 06:10:39PM -0600, Bjorn Helgaas wrote:
> On Tue, Feb 02, 2021 at 09:44:29PM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 02, 2021 at 12:06:09PM -0600, Bjorn Helgaas wrote:
> > > On Tue, Jan 26, 2021 at 10:57:27AM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Extend PCI sysfs interface with a new callback that allows
> > > > configure the number of MSI-X vectors for specific SR-IO VF.
> > > > This is needed to optimize the performance of newly bound
> > > > devices by allocating the number of vectors based on the
> > > > administrator knowledge of targeted VM.
> > >
> > > I'm reading between the lines here, but IIUC the point is that you
> > > have a PF that supports a finite number of MSI-X vectors for use
> > > by all the VFs, and this interface is to control the distribution
> > > of those MSI-X vectors among the VFs.
> >
> > The MSI-X is HW resource, all devices in the world have limitation
> > here.
> >
> > > > This function is applicable for SR-IOV VF because such devices
> > > > allocate their MSI-X table before they will run on the VMs and
> > > > HW can't guess the right number of vectors, so the HW allocates
> > > > them statically and equally.
> > >
> > > This is written in a way that suggests this is behavior required
> > > by the PCIe spec.  If it is indeed related to something in the
> > > spec, please cite it.
> >
> > Spec doesn't say it directly, but you will need to really hurt brain
> > of your users if you decide to do it differently. You have one
> > enable bit to create all VFs at the same time without any option to
> > configure them in advance.
> >
> > Of course, you can create some partition map, upload it to FW and
> > create from there.
>
> Of course all devices have limitations.  But let's add some details
> about the way *this* device works.  That will help avoid giving the
> impression that this is the *only* way spec-conforming devices can
> work.

Sure

>
> > > "such devices allocate their MSI-X table before they will run on
> > > the VMs": Let's be specific here.  This MSI-X Table allocation
> > > apparently doesn't happen when we set VF Enable in the PF, because
> > > these sysfs files are attached to the VFs, which don't exist yet.
> > > It's not the VF driver binding, because that's a software
> > > construct.  What is the hardware event that triggers the
> > > allocation?
> >
> > Write of MSI-X vector count to the FW through PF.
>
> This is an example of something that is obviously specific to this
> mlx5 device.  The Table Size field in Message Control is RO per spec,
> and obviously firmware on the device is completely outside the scope
> of the PCIe spec.
>
> This commit log should describe how *this* device manages this
> allocation and how the PF Table Size and the VF Table Sizes are
> related.  Per PCIe, there is no necessary connection between them.

There is no connection in mlx5 devices either. PF is used as a vehicle
to access VF that doesn't have driver yet. From "table size" perspective
they completely independent, because PF already probed by driver and
it is already too late to change it.

So PF table size is static and can be changed through FW utility only.

>
> > > > cat /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
> > > >   = 0 - feature is not supported
> > > >   > 0 - total number of MSI-X vectors to consume by the VFs
> > >
> > > "total number of MSI-X vectors available for distribution among the
> > > VFs"?
> >
> > Users need to be aware of how much vectors exist in the system.
>
> Understood -- if there's an interface to influence the distribution of
> vectors among VFs, one needs to know how many vectors there are to
> work with.
>
> My point was that "number of vectors to consume by VFs" is awkward
> wording, so I suggested an alternative.

Got it, thanks

>
> > > > +What:            /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
> > > > +Date:            January 2021
> > > > +Contact: Leon Romanovsky <leonro@nvidia.com>
> > > > +Description:
> > > > +         This file is associated with the SR-IOV VFs.
> > > > +         It allows configuration of the number of MSI-X vectors for
> > > > +         the VF. This is needed to optimize performance of newly bound
> > > > +         devices by allocating the number of vectors based on the
> > > > +         administrator knowledge of targeted VM.
> > > > +
> > > > +         The values accepted are:
> > > > +          * > 0 - this will be number reported by the VF's MSI-X
> > > > +                  capability
> > > > +          * < 0 - not valid
> > > > +          * = 0 - will reset to the device default value
> > > > +
> > > > +         The file is writable if the PF is bound to a driver that
> > > > +         set sriov_vf_total_msix > 0 and there is no driver bound
> > > > +         to the VF.
>
> Drivers don't actually set "sriov_vf_total_msix".  This should
> probably say something like "the PF is bound to a driver that
> implements ->sriov_set_msix_vec_count()."

Sure, will change.

>
> > > > +What:		/sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
> > > > +Date:		January 2021
> > > > +Contact:	Leon Romanovsky <leonro@nvidia.com>
> > > > +Description:
> > > > +		This file is associated with the SR-IOV PFs.
> > > > +		It returns a total number of possible to configure MSI-X
> > > > +		vectors on the enabled VFs.
> > > > +
> > > > +		The values returned are:
> > > > +		 * > 0 - this will be total number possible to consume by VFs,
> > > > +		 * = 0 - feature is not supported
>
> Can you swap the order of these two files in the documentation?
> sriov_vf_total_msix is associated with the PF and logically precedes
> sriov_vf_msix_count, which is associated with VFs.

I'll do.

>
> Not sure the "= 0" description is necessary here.  If the value
> returned is the number of MSI-X vectors available for assignment to
> VFs, "0" is a perfectly legitimate value.  It just means there are
> none.  It doesn't need to be described separately.

I wanted to help users and remove ambiguity. For example, mlx5 drivers
will always implement proper .set_...() callbacks but for some devices
without needed FW support, the value will be 0. Instead of misleading
users with wrong promise that feature supported but doesn't have
available vectors, I decided to be more clear. For the users, 0 means, don't
try, it is not working.

>
> > > Do these filenames really need to contain both "sriov" and "vf"?
> >
> > This is what I was asked at some point. In previous versions the name
> > was without "sriov".
>
> We currently have:
>
>   $ grep DEVICE_ATTR drivers/pci/iov.c
>   static DEVICE_ATTR_RO(sriov_totalvfs);
>   static DEVICE_ATTR_RW(sriov_numvfs);
>   static DEVICE_ATTR_RO(sriov_offset);
>   static DEVICE_ATTR_RO(sriov_stride);
>   static DEVICE_ATTR_RO(sriov_vf_device);
>   static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
>
> If we put them in a new "vfs_overlay" directory, it seems like
> overkill to repeat the "vf" part, but I'm hoping the new files can end
> up next to these existing files.  In that case, I think it makes sense
> to include "sriov".  And it probably does make sense to include "vf"
> as well.

I put everything in folder to group any possible future extensions.
Those extensions are applicable to SR-IOV VFs only, IMHO they deserve
separate folder.

This is the link with the request to change name:
https://lore.kernel.org/linux-pci/CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com/

Also, _vf_ in the sriov_vf_total_msix symbolize that we are talking
explicitly about VFs and not whole device/PF.

>
> > > Should these be next to the existing SR-IOV sysfs files, i.e., in or
> > > alongside sriov_dev_attr_group?
> >
> > This was suggestion in previous versions. I didn't hear anyone
> > supporting it.
>
> Pointer to this discussion?  I'm not sure what value is added by a new
> directory.

In the link below, Alex talks about creating PF driven sysfs entries clearly
visible by the users as not PCI config space writes. The overlay folder achieves
that.

https://lore.kernel.org/linux-pci/CAKgT0UeYb5xz8iehE1Y0s-cyFbsy46bjF83BkA7qWZMkAOLR-g@mail.gmail.com/

and this is the resolution that proposed structure is OK:
https://lore.kernel.org/linux-pci/20210124190032.GD5038@unreal/

>
> > > Hmmm, I see pci_enable_vfs_overlay() is called by the driver.  I don't
> > > really like that because then we're dependent on drivers to maintain
> > > the PCI sysfs hierarchy.  E.g., a driver might forget to call
> > > pci_disable_vfs_overlay(), and then a future driver load will fail.
> > >
> > > Maybe this could be done with .is_visible() functions that call driver
> > > callbacks.
> >
> > It was in previous versions too, but this solution allows PF to control
> > the VFs overlay dynamically.
>
> See below; I think it might be possible to do this dynamically even
> without pci_enable_vfs_overlay().

The request was to have this overlay be PF driven. It means that if
PF driver is removed, the folder should disappear. I tried to do it
with .si_visible() and found myself adding hooks in general pci remove
flow. It was far from clean.

>
> > > > +int pci_enable_vfs_overlay(struct pci_dev *dev)
> > > > +{
> > > > +	struct pci_dev *virtfn;
> > > > +	int id, ret;
> > > > +
> > > > +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> > > > +		return 0;
> > > > +
> > > > +	ret = sysfs_create_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	for (id = 0; id < dev->sriov->num_VFs; id++) {
> > > > +		virtfn = pci_get_domain_bus_and_slot(
> > > > +			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
> > > > +			pci_iov_virtfn_devfn(dev, id));
> > > > +
> > > > +		if (!virtfn)
> > > > +			continue;
> > > > +
> > > > +		ret = sysfs_create_group(&virtfn->dev.kobj,
> > > > +					 &sriov_vf_dev_attr_group);
> > > > +		if (ret)
> > > > +			goto out;
> > > > +	}
> > > > +	return 0;
> > > > +
> > > > +out:
> > > > +	while (id--) {
> > > > +		virtfn = pci_get_domain_bus_and_slot(
> > > > +			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
> > > > +			pci_iov_virtfn_devfn(dev, id));
> > > > +
> > > > +		if (!virtfn)
> > > > +			continue;
> > > > +
> > > > +		sysfs_remove_group(&virtfn->dev.kobj, &sriov_vf_dev_attr_group);
> > > > +	}
> > > > +	sysfs_remove_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
> > > > +	return ret;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(pci_enable_vfs_overlay);
> > > > +
> > > > +void pci_disable_vfs_overlay(struct pci_dev *dev)
> > > > +{
> > > > +	struct pci_dev *virtfn;
> > > > +	int id;
> > > > +
> > > > +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> > > > +		return;
> > > > +
> > > > +	id = dev->sriov->num_VFs;
> > > > +	while (id--) {
> > > > +		virtfn = pci_get_domain_bus_and_slot(
> > > > +			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
> > > > +			pci_iov_virtfn_devfn(dev, id));
> > > > +
> > > > +		if (!virtfn)
> > > > +			continue;
> > > > +
> > > > +		sysfs_remove_group(&virtfn->dev.kobj, &sriov_vf_dev_attr_group);
> > > > +	}
> > > > +	sysfs_remove_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(pci_disable_vfs_overlay);
> > >
> > > I'm not convinced all this sysfs wrangling is necessary.  If it is,
> > > add a hint in a comment about why this is special and can't use
> > > something like sriov_dev_attr_group.
> >
> > This makes the overlay to be PF-driven. Alexander insisted on this flow.
>
> If you're referring to [1], I think "insisted on this flow" might be
> an overstatement of what Alex was looking for.  IIUC Alex wants the
> sysfs files to be visible only when they're useful, i.e., when a
> driver implements ->sriov_set_msix_vec_count().

It is only one side of the request, the sysfs files shouldn't be visible
if PF driver was removed and visible again when its probed again.

>
> That seems reasonable and also seems like something a smarter
> .is_visible() function could accomplish without having drivers call
> pci_enable_vfs_overlay(), e.g., maybe some variation of this:
>
>   static umode_t sriov_vf_attrs_are_visible(...)
>   {
>     if (!pdev->msix_cap || dev_is_pf(dev))
>       return 0;
>
>     pf = pci_physfn(pdev);
>     if (pf->driver && pf->driver->sriov_set_msix_vec_count)
>       return a->mode;
>
>     return 0;
>   }

It doesn't work with the following flow:
1. load driver
2. disable autoprobe
3. echo to sriov_numvfs
.... <--- you have this sriov_vf_attrs_are_visible() created
4. unload driver
.... <--- sysfs still exists despite not having PF driver.

>
> (Probably needs locking while we look at pf->driver, just like in
> pci_vf_set_msix_vec_count().)
>
> pci_enable_vfs_overlay() significantly complicates the code and it's
> the sort of sysfs code we're trying to avoid, so if we really do need
> it, please add a brief comment about *why* we have to do it that way.

I will add.

>
> > > > +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count)
> > > > +{
> > > > +	if (!dev->is_physfn)
> > > > +		return;
> > > > +
> > > > +	dev->sriov->vf_total_msix = count;
> > >
> > > The PCI core doesn't use vf_total_msix at all.  The driver, e.g.,
> > > mlx5, calls this, and all the PCI core does is hang onto the value and
> > > expose it via sysfs.  I think I'd rather have a callback in struct
> > > pci_driver and let the driver supply the value when needed.  I.e.,
> > > sriov_vf_total_msix_show() would call the callback instead of looking
> > > at pdev->sriov->vf_total_msix.
> >
> > It will cause to unnecessary locking to ensure that driver doesn't
> > vanish during sysfs read. I can change, but don't think that it is right
> > decision.
>
> Doesn't sysfs already ensure the driver can't vanish while we're
> executing a DEVICE_ATTR accessor?

It is not, you can see it by adding device_lock_held() check in any
.show attribute. See drivers/base/core.c: dev_attr_show(), it doesn't
do much. This is why pci_vf_set_msix_vec_count() has double lock.

>
> > > > +int pci_vf_set_msix_vec_count(struct pci_dev *dev, int count)
> > > > +{
> > > > +	struct pci_dev *pdev = pci_physfn(dev);
> > > > +	int ret;
> > > > +
> > > > +	if (count < 0)
> > > > +		/*
> > > > +		 * We don't support negative numbers for now,
> > > > +		 * but maybe in the future it will make sense.
> > > > +		 */
> > >
> > > Drop the comment; I don't think it adds useful information.
> > >
> > > > +		return -EINVAL;
> > > > +
> > > > +	device_lock(&pdev->dev);
> > > > +	if (!pdev->driver) {
> > > > +		ret = -EOPNOTSUPP;
> > > > +		goto err_pdev;
> > > > +	}
> > > > +
> > > > +	device_lock(&dev->dev);
> > > > +	if (dev->driver) {
> > > > +		/*
> > > > +		 * Driver already probed this VF and configured itself
> > > > +		 * based on previously configured (or default) MSI-X vector
> > > > +		 * count. It is too late to change this field for this
> > > > +		 * specific VF.
> > > > +		 */
> > > > +		ret = -EBUSY;
> > > > +		goto err_dev;
> > > > +	}
> > > > +
> > > > +	ret = pdev->driver->sriov_set_msix_vec_count(dev, count);
> > >
> > > This looks like a NULL pointer dereference.
> >
> > In current code, it is impossible, the call to pci_vf_set_msix_vec_count()
> > will be only for devices that supports sriov_vf_msix_count which is
> > possible with ->sriov_set_msix_vec_count() only.
>
> OK.  I think you're right, but it takes quite a lot of analysis to
> prove that right now.  If the .is_visible() function for
> sriov_vf_msix_count checked whether the driver implements
> ->sriov_set_msix_vec_count(), it would be quite a bit easier,
> and it might even help get rid of pci_enable_vfs_overlay().
>
> Also, pci_vf_set_msix_vec_count() is in pci/msi.c, but AFAICT there's
> no actual *reason* for it to be there other than the fact that it has
> "msix" in the name.  It uses no MSI data structures.  Maybe it could
> be folded into sriov_vf_msix_count_store(), which would make the
> analysis even easier.

I put _set_ command near _get_ command, but I can move it to iov.c

>
> > > > @@ -326,6 +327,9 @@ struct pci_sriov {
> > > >  	u16		subsystem_device; /* VF subsystem device */
> > > >  	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
> > > >  	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
> > > > +	u32		vf_total_msix;  /* Total number of MSI-X vectors the VFs
> > > > +					 * can consume
> > > > +					 */
> > >
> > >   * can consume */
> > >
> > > Hopefully you can eliminate vf_total_msix altogether.
> >
> > I think that will be worse from the flow point of view (extra locks)
> > and the memory if you are worried about it. This variable consumes 4
> > bytes, the pointer to the function will take 8 bytes.
>
> I'm not concerned about the space.  The function pointer is in struct
> pci_driver, whereas the variable is in struct pci_sriov, so the
> variable would likely consume more space because there are probably
> more VFs than pci_drivers.
>
> My bigger concern is that vf_total_msix is really *driver* state, not
> PCI core state, and I'd prefer if the PCI core were not responsible
> for it.

As i said above, I can do it, just don't think that it is right.
Should I do it or not?

>
> > > > +++ b/include/linux/pci.h
> > > > @@ -856,6 +856,8 @@ struct module;
> > > >   *		e.g. drivers/net/e100.c.
> > > >   * @sriov_configure: Optional driver callback to allow configuration of
> > > >   *		number of VFs to enable via sysfs "sriov_numvfs" file.
> > > > + * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
> > > > + *              exposed by the sysfs "vf_msix_vec" entry.
> > >
> > > "vf_msix_vec" is apparently stale?  There's no other reference in this
> > > patch.
> > >
> > > I think the important part is that this changes the number of vectors
> > > advertised in the VF's MSI-X Message Control register, which will be
> > > read when the VF driver enables MSI-X.
> > >
> > > If that's true, why would we expose this via a sysfs file?  We can
> > > easily read it via lspci.
> >
> > I did it for feature complete, we don't need read of this sysfs.
>
> If you don't need this sysfs file, just remove it.  If you do need it,
> please update the "vf_msix_vec" so it's correct.  Also, clarify the
> description so we can tell that we're changing the Table Size VFs will
> see in their Message Control registers.

I'll do

>
> > > > +static inline void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count) {}
> > >
> > > Also here.  Unless removing the space would make this fit in 80
> > > columns.
> >
> > Yes, it is 80 columns without space.
>
> No, I don't think it is.  In an 80 column window, the result looks
> like:
>
>   static inline void pci_sriov_set_vf_total_msix(...) {
>   }
>
> Please change it so it looks like this so it matches the rest of the
> file:
>
>   static inline void pci_sriov_set_vf_total_msix(...)
>   { }

I counted back then, but sure will check again.

Thanks for your review.

>
> Bjorn
>
> [1] https://lore.kernel.org/r/CAKgT0UcJQ3uy6J_CCLizDLfzGL2saa_PjOYH4nK+RQjfmpNA=w@mail.gmail.com
