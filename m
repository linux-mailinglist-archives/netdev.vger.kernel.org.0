Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8EE30C941
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbhBBSNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237741AbhBBSGy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 13:06:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD63664F97;
        Tue,  2 Feb 2021 18:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612289171;
        bh=3S+7P27RMzr8d6XETMrt1rgmhF2MpHhAyqj36nnMhuE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DMI8lkZcv6aye091hEYrDtFtNKfRmj+GaTQRtcDh8CEGB6cor2OtMb6MfB5mEBACy
         xHcV2j9QXXHKnMy6JxsFY5Z86RCugC3LspH8kWooTiXuP+268+A+SiFn8Fm0mkkEy5
         yH9v5iT7MW2ZPkGvUE+y4LTt9oSNHzWXPQKNDVP76KAHIMMTQTiRiht/D/22YkwU2d
         vBhLHIHFvj7ZvnSRH97lWVRbLDeudtHA2LaIWGcCojlCTkZ3krmjPQFDZWWS5jxYP/
         JgLKcRmEKNNBwEmixv4CC+SeSG4P/VDGtwrpH9L0MQc04xfquQjEyJ9pzx4doxY89U
         VbUMy/8yjuDdw==
Date:   Tue, 2 Feb 2021 12:06:09 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v5 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210202180609.GA108070@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126085730.1165673-2-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:57:27AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend PCI sysfs interface with a new callback that allows configure
> the number of MSI-X vectors for specific SR-IO VF. This is needed
> to optimize the performance of newly bound devices by allocating
> the number of vectors based on the administrator knowledge of targeted VM.

s/configure/configuration of/
s/SR-IO/SR-IOV/
s/newly bound/VFs/ ?
s/VF/VFs/
s/knowledge of targeted VM/knowledge of the intended use of the VF/
(I'm not a VF expert, but I think they can be used even without VMs)

I'm reading between the lines here, but IIUC the point is that you
have a PF that supports a finite number of MSI-X vectors for use by
all the VFs, and this interface is to control the distribution of
those MSI-X vectors among the VFs.

> This function is applicable for SR-IOV VF because such devices allocate
> their MSI-X table before they will run on the VMs and HW can't guess the
> right number of vectors, so the HW allocates them statically and equally.

This is written in a way that suggests this is behavior required by
the PCIe spec.  If it is indeed related to something in the spec,
please cite it.

But I think this is actually something device-specific, not something
we can derive directly from the spec.  If that's the case, be clear
that we're addressing a device-specific need, and we're hoping that
this will be useful for other devices as well.

"such devices allocate their MSI-X table before they will run on the
VMs": Let's be specific here.  This MSI-X Table allocation apparently
doesn't happen when we set VF Enable in the PF, because these sysfs
files are attached to the VFs, which don't exist yet.  It's not the VF
driver binding, because that's a software construct.  What is the
hardware event that triggers the allocation?

Obviously the distribution among VFs can be changed after VF Enable is
set.  Maybe the distribution is dynamic, and the important point is
that it must be changed before the VF driver reads the Message Control
register for Table Size?

But that isn't the same as "devices allocating their MSI-X table
before being passed through to a VM," so it's confusing.  The
language about allocating the MSI-X table needs to be made precise
here and in the code comments below.

"before they will run on the VMs": Devices don't "run on VMs".  I
think the usual terminology is that a device may be "passed through to
a VM".

"HW allocates them statically and equally" sounds like a description
of some device-specific behavior (unless there's something in the spec
that requires this, in which case you should cite it).  It's OK if
this is device-specific; just don't pretend that it's generic if it's
not.

> 1) The newly added /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
> file will be seen for the VFs and it is writable as long as a driver is not
> bounded to the VF.

"bound to the VF"

> The values accepted are:
>  * > 0 - this will be number reported by the VF's MSI-X capability

Specifically, I guess by Table Size in the VF's MSI-X Message Control
register?

>  * < 0 - not valid
>  * = 0 - will reset to the device default value
> 
> 2) In order to make management easy, provide new read-only sysfs file that
> returns a total number of possible to configure MSI-X vectors.
> 
> cat /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
>   = 0 - feature is not supported
>   > 0 - total number of MSI-X vectors to consume by the VFs

"total number of MSI-X vectors available for distribution among the
VFs"?

> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |  32 +++++
>  drivers/pci/iov.c                       | 180 ++++++++++++++++++++++++
>  drivers/pci/msi.c                       |  47 +++++++
>  drivers/pci/pci.h                       |   4 +
>  include/linux/pci.h                     |  10 ++
>  5 files changed, 273 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 25c9c39770c6..4d206ade5331 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -375,3 +375,35 @@ Description:
>  		The value comes from the PCI kernel device state and can be one
>  		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
>  		The file is read only.
> +
> +What:		/sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
> +Date:		January 2021
> +Contact:	Leon Romanovsky <leonro@nvidia.com>
> +Description:
> +		This file is associated with the SR-IOV VFs.
> +		It allows configuration of the number of MSI-X vectors for
> +		the VF. This is needed to optimize performance of newly bound
> +		devices by allocating the number of vectors based on the
> +		administrator knowledge of targeted VM.
> +
> +		The values accepted are:
> +		 * > 0 - this will be number reported by the VF's MSI-X
> +			 capability
> +		 * < 0 - not valid
> +		 * = 0 - will reset to the device default value
> +
> +		The file is writable if the PF is bound to a driver that
> +		set sriov_vf_total_msix > 0 and there is no driver bound
> +		to the VF.
> +
> +What:		/sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
> +Date:		January 2021
> +Contact:	Leon Romanovsky <leonro@nvidia.com>
> +Description:
> +		This file is associated with the SR-IOV PFs.
> +		It returns a total number of possible to configure MSI-X
> +		vectors on the enabled VFs.
> +
> +		The values returned are:
> +		 * > 0 - this will be total number possible to consume by VFs,
> +		 * = 0 - feature is not supported

What does "vfs_overlay" mean?  "vfs" sounds like the Virtual File
System.

Do these filenames really need to contain both "sriov" and "vf"?

Should these be next to the existing SR-IOV sysfs files, i.e., in or
alongside sriov_dev_attr_group?

Hmmm, I see pci_enable_vfs_overlay() is called by the driver.  I don't
really like that because then we're dependent on drivers to maintain
the PCI sysfs hierarchy.  E.g., a driver might forget to call
pci_disable_vfs_overlay(), and then a future driver load will fail.

Maybe this could be done with .is_visible() functions that call driver
callbacks.

> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 4afd4ee4f7f0..3e95f835eba5 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
>  	return (dev->devfn + dev->sriov->offset +
>  		dev->sriov->stride * vf_id) & 0xff;
>  }
> +EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);
> 
>  /*
>   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
> @@ -157,6 +158,166 @@ int pci_iov_sysfs_link(struct pci_dev *dev,
>  	return rc;
>  }
> 
> +#ifdef CONFIG_PCI_MSI
> +static ssize_t sriov_vf_msix_count_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	int count = pci_msix_vec_count(pdev);
> +
> +	if (count < 0)
> +		return count;
> +
> +	return sysfs_emit(buf, "%d\n", count);
> +}
> +
> +static ssize_t sriov_vf_msix_count_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t count)
> +{
> +	struct pci_dev *vf_dev = to_pci_dev(dev);
> +	int val, ret;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	ret = pci_vf_set_msix_vec_count(vf_dev, val);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +static DEVICE_ATTR_RW(sriov_vf_msix_count);
> +
> +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	return sysfs_emit(buf, "%u\n", pdev->sriov->vf_total_msix);
> +}
> +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> +#endif
> +
> +static struct attribute *sriov_pf_dev_attrs[] = {
> +#ifdef CONFIG_PCI_MSI
> +	&dev_attr_sriov_vf_total_msix.attr,
> +#endif
> +	NULL,
> +};
> +
> +static struct attribute *sriov_vf_dev_attrs[] = {
> +#ifdef CONFIG_PCI_MSI
> +	&dev_attr_sriov_vf_msix_count.attr,
> +#endif
> +	NULL,
> +};
> +
> +static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
> +					  struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (!pdev->msix_cap || !dev_is_pf(dev))
> +		return 0;
> +
> +	return a->mode;
> +}
> +
> +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> +					  struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (!pdev->msix_cap || dev_is_pf(dev))
> +		return 0;
> +
> +	return a->mode;
> +}
> +
> +static const struct attribute_group sriov_pf_dev_attr_group = {
> +	.attrs = sriov_pf_dev_attrs,
> +	.is_visible = sriov_pf_attrs_are_visible,
> +	.name = "vfs_overlay",
> +};
> +
> +static const struct attribute_group sriov_vf_dev_attr_group = {
> +	.attrs = sriov_vf_dev_attrs,
> +	.is_visible = sriov_vf_attrs_are_visible,
> +	.name = "vfs_overlay",
> +};
> +
> +int pci_enable_vfs_overlay(struct pci_dev *dev)
> +{
> +	struct pci_dev *virtfn;
> +	int id, ret;
> +
> +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> +		return 0;
> +
> +	ret = sysfs_create_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
> +	if (ret)
> +		return ret;
> +
> +	for (id = 0; id < dev->sriov->num_VFs; id++) {
> +		virtfn = pci_get_domain_bus_and_slot(
> +			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
> +			pci_iov_virtfn_devfn(dev, id));
> +
> +		if (!virtfn)
> +			continue;
> +
> +		ret = sysfs_create_group(&virtfn->dev.kobj,
> +					 &sriov_vf_dev_attr_group);
> +		if (ret)
> +			goto out;
> +	}
> +	return 0;
> +
> +out:
> +	while (id--) {
> +		virtfn = pci_get_domain_bus_and_slot(
> +			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
> +			pci_iov_virtfn_devfn(dev, id));
> +
> +		if (!virtfn)
> +			continue;
> +
> +		sysfs_remove_group(&virtfn->dev.kobj, &sriov_vf_dev_attr_group);
> +	}
> +	sysfs_remove_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pci_enable_vfs_overlay);
> +
> +void pci_disable_vfs_overlay(struct pci_dev *dev)
> +{
> +	struct pci_dev *virtfn;
> +	int id;
> +
> +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> +		return;
> +
> +	id = dev->sriov->num_VFs;
> +	while (id--) {
> +		virtfn = pci_get_domain_bus_and_slot(
> +			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
> +			pci_iov_virtfn_devfn(dev, id));
> +
> +		if (!virtfn)
> +			continue;
> +
> +		sysfs_remove_group(&virtfn->dev.kobj, &sriov_vf_dev_attr_group);
> +	}
> +	sysfs_remove_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
> +}
> +EXPORT_SYMBOL_GPL(pci_disable_vfs_overlay);

I'm not convinced all this sysfs wrangling is necessary.  If it is,
add a hint in a comment about why this is special and can't use
something like sriov_dev_attr_group.

>  int pci_iov_add_virtfn(struct pci_dev *dev, int id)
>  {
>  	int i;
> @@ -596,6 +757,7 @@ static void sriov_disable(struct pci_dev *dev)
>  		sysfs_remove_link(&dev->dev.kobj, "dep_link");
> 
>  	iov->num_VFs = 0;
> +	iov->vf_total_msix = 0;
>  	pci_iov_set_numvfs(dev, 0);
>  }
> 
> @@ -1054,6 +1216,24 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
> 
> +/**
> + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> + * @dev: the PCI PF device
> + * @count: the total number of MSI-X vector to consume by the VFs
> + *
> + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> + * This interface is complimentary part of the pci_vf_set_msix_vec_count()

s/Sets the/Set the/
s/complimentary part of the/complementary to/

> + * that will be used to configure the required number on the VF.
> + */
> +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count)
> +{
> +	if (!dev->is_physfn)
> +		return;
> +
> +	dev->sriov->vf_total_msix = count;

The PCI core doesn't use vf_total_msix at all.  The driver, e.g.,
mlx5, calls this, and all the PCI core does is hang onto the value and
expose it via sysfs.  I think I'd rather have a callback in struct
pci_driver and let the driver supply the value when needed.  I.e.,
sriov_vf_total_msix_show() would call the callback instead of looking
at pdev->sriov->vf_total_msix.

> +}
> +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> +
>  /**
>   * pci_sriov_configure_simple - helper to configure SR-IOV
>   * @dev: the PCI device
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 3162f88fe940..1022fe9e6efd 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -991,6 +991,53 @@ int pci_msix_vec_count(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pci_msix_vec_count);
> 
> +/**
> + * pci_vf_set_msix_vec_count - change the reported number of MSI-X vectors
> + * This function is applicable for SR-IOV VF because such devices allocate
> + * their MSI-X table before they will run on the VMs and HW can't guess the
> + * right number of vectors, so the HW allocates them statically and equally.
> + * @dev: VF device that is going to be changed
> + * @count: amount of MSI-X vectors

s/amount/number/

> + **/
> +int pci_vf_set_msix_vec_count(struct pci_dev *dev, int count)
> +{
> +	struct pci_dev *pdev = pci_physfn(dev);
> +	int ret;
> +
> +	if (count < 0)
> +		/*
> +		 * We don't support negative numbers for now,
> +		 * but maybe in the future it will make sense.
> +		 */

Drop the comment; I don't think it adds useful information.

> +		return -EINVAL;
> +
> +	device_lock(&pdev->dev);
> +	if (!pdev->driver) {
> +		ret = -EOPNOTSUPP;
> +		goto err_pdev;
> +	}
> +
> +	device_lock(&dev->dev);
> +	if (dev->driver) {
> +		/*
> +		 * Driver already probed this VF and configured itself
> +		 * based on previously configured (or default) MSI-X vector
> +		 * count. It is too late to change this field for this
> +		 * specific VF.
> +		 */
> +		ret = -EBUSY;
> +		goto err_dev;
> +	}
> +
> +	ret = pdev->driver->sriov_set_msix_vec_count(dev, count);

This looks like a NULL pointer dereference.

> +err_dev:
> +	device_unlock(&dev->dev);
> +err_pdev:
> +	device_unlock(&pdev->dev);
> +	return ret;
> +}
> +
>  static int __pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries,
>  			     int nvec, struct irq_affinity *affd, int flags)
>  {
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 5c59365092fa..2bd6560d91e2 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -183,6 +183,7 @@ extern unsigned int pci_pm_d3hot_delay;
> 
>  #ifdef CONFIG_PCI_MSI
>  void pci_no_msi(void);
> +int pci_vf_set_msix_vec_count(struct pci_dev *dev, int count);
>  #else
>  static inline void pci_no_msi(void) { }
>  #endif
> @@ -326,6 +327,9 @@ struct pci_sriov {
>  	u16		subsystem_device; /* VF subsystem device */
>  	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
>  	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
> +	u32		vf_total_msix;  /* Total number of MSI-X vectors the VFs
> +					 * can consume
> +					 */

  * can consume */

Hopefully you can eliminate vf_total_msix altogether.

>  };
> 
>  /**
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index b32126d26997..24d118ad6e7b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -856,6 +856,8 @@ struct module;
>   *		e.g. drivers/net/e100.c.
>   * @sriov_configure: Optional driver callback to allow configuration of
>   *		number of VFs to enable via sysfs "sriov_numvfs" file.
> + * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
> + *              exposed by the sysfs "vf_msix_vec" entry.

"vf_msix_vec" is apparently stale?  There's no other reference in this
patch.

I think the important part is that this changes the number of vectors
advertised in the VF's MSI-X Message Control register, which will be
read when the VF driver enables MSI-X.

If that's true, why would we expose this via a sysfs file?  We can
easily read it via lspci.

>   * @err_handler: See Documentation/PCI/pci-error-recovery.rst
>   * @groups:	Sysfs attribute groups.
>   * @driver:	Driver model structure.
> @@ -871,6 +873,7 @@ struct pci_driver {
>  	int  (*resume)(struct pci_dev *dev);	/* Device woken up */
>  	void (*shutdown)(struct pci_dev *dev);
>  	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
> +	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
>  	const struct pci_error_handlers *err_handler;
>  	const struct attribute_group **groups;
>  	struct device_driver	driver;
> @@ -2059,6 +2062,9 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
>  int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
>  int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
> 
> +int pci_enable_vfs_overlay(struct pci_dev *dev);
> +void pci_disable_vfs_overlay(struct pci_dev *dev);
> +
>  int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
>  void pci_disable_sriov(struct pci_dev *dev);
> 
> @@ -2072,6 +2078,7 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev);
>  int pci_sriov_configure_simple(struct pci_dev *dev, int nr_virtfn);
>  resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno);
>  void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe);
> +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count);
> 
>  /* Arch may override these (weak) */
>  int pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs);
> @@ -2100,6 +2107,8 @@ static inline int pci_iov_add_virtfn(struct pci_dev *dev, int id)
>  }
>  static inline void pci_iov_remove_virtfn(struct pci_dev *dev,
>  					 int id) { }
> +static inline int pci_enable_vfs_overlay(struct pci_dev *dev) { return 0; }
> +static inline void pci_disable_vfs_overlay(struct pci_dev *dev) {}

s/{}/{ }/
Please make your code match the rest of the file, e.g., the very next line!

>  static inline void pci_disable_sriov(struct pci_dev *dev) { }
>  static inline int pci_num_vf(struct pci_dev *dev) { return 0; }
>  static inline int pci_vfs_assigned(struct pci_dev *dev)
> @@ -2112,6 +2121,7 @@ static inline int pci_sriov_get_totalvfs(struct pci_dev *dev)
>  static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
>  { return 0; }
>  static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
> +static inline void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count) {}

Also here.  Unless removing the space would make this fit in 80
columns.

>  #endif
> 
>  #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
> --
> 2.29.2
> 
