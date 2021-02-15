Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8597431C35A
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhBOVBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:01:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhBOVBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 16:01:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F1B764DE0;
        Mon, 15 Feb 2021 21:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613422868;
        bh=jhLDkmMeB9GWLA/Fyt8bSjt9sBgR0R85xv2jsssuOqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=syGT6qEDelVShIwFdhqYuO0gH4at+sIvJYQhFx31NPaKFyjIhX9pNLuasSrViZPav
         BaKgIjSYhWRAibh4/pD7RPCmF5u6TGJeEPUbAY4QuYLL0RNQPhlMRRSxnGokhGiN1P
         ZWce0eyJq2S23hP6zYvP9M7IDiRNGTGjPhBgLFobCN/d0fiQjqSf+OD1MNmnicY9vF
         FZxKwN+NfVfJ67dzOPRvJLW+GSViiZLbkT5UcVc5ADUqoklt+mkFpNCCAOPP4Yf7Cv
         FKt+8kXmONtImiYjf50IlXL2M4K230FTvv0xLTsFZeyLMUp33bSTxEWFqtRffMVR+f
         OZyYIypAFKFvA==
Date:   Mon, 15 Feb 2021 15:01:06 -0600
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
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210215210106.GA744958@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209133445.700225-2-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 03:34:42PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend PCI sysfs interface with a new callback that allows configuration
> of the number of MSI-X vectors for specific SR-IOV VF. This is needed
> to optimize the performance of VFs devices by allocating the number of
> vectors based on the administrator knowledge of the intended use of the VF.
> 
> This function is applicable for SR-IOV VF because such devices allocate
> their MSI-X table before they will run on the VMs and HW can't guess the
> right number of vectors, so some devices allocate them statically and equally.

This commit log should be clear that this functionality is motivated
by *mlx5* behavior.  The description above makes it sound like this is
generic PCI spec behavior, and it is not.

It may be a reasonable design that conforms to the spec, and we hope
the model will be usable by other designs, but it is not required by
the spec and AFAIK there is nothing in the spec you can point to as
background for this.

So don't *remove* the text you have above, but please *add* some
preceding background information about how mlx5 works.

> 1) The newly added /sys/bus/pci/devices/.../sriov_vf_msix_count
> file will be seen for the VFs and it is writable as long as a driver is not
> bound to the VF.

  This adds /sys/bus/pci/devices/.../sriov_vf_msix_count for VF
  devices and is writable ...

> The values accepted are:
>  * > 0 - this will be number reported by the Table Size in the VF's MSI-X Message
>          Control register
>  * < 0 - not valid
>  * = 0 - will reset to the device default value

  = 0 - will reset to a device-specific default value

> 2) In order to make management easy, provide new read-only sysfs file that
> returns a total number of possible to configure MSI-X vectors.

  For PF devices, this adds a read-only
  /sys/bus/pci/devices/.../sriov_vf_total_msix file that contains the
  total number of MSI-X vectors available for distribution among VFs.

Just as in sysfs-bus-pci, this file should be listed first, because
you must read it before you can use vf_msix_count.

> cat /sys/bus/pci/devices/.../sriov_vf_total_msix
>   = 0 - feature is not supported
>   > 0 - total number of MSI-X vectors available for distribution among the VFs
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |  28 +++++
>  drivers/pci/iov.c                       | 153 ++++++++++++++++++++++++
>  include/linux/pci.h                     |  12 ++
>  3 files changed, 193 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 25c9c39770c6..7dadc3610959 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -375,3 +375,31 @@ Description:
>  		The value comes from the PCI kernel device state and can be one
>  		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
>  		The file is read only.
> +
> +What:		/sys/bus/pci/devices/.../sriov_vf_total_msix
> +Date:		January 2021
> +Contact:	Leon Romanovsky <leonro@nvidia.com>
> +Description:
> +		This file is associated with the SR-IOV PFs.
> +		It contains the total number of MSI-X vectors available for
> +		assignment to all VFs associated with this PF. It may be zero
> +		if the device doesn't support this functionality.

s/associated with the/associated with/

> +What:		/sys/bus/pci/devices/.../sriov_vf_msix_count
> +Date:		January 2021
> +Contact:	Leon Romanovsky <leonro@nvidia.com>
> +Description:
> +		This file is associated with the SR-IOV VFs.
> +		It allows configuration of the number of MSI-X vectors for
> +		the VF. This is needed to optimize performance of newly bound
> +		devices by allocating the number of vectors based on the
> +		administrator knowledge of targeted VM.

s/associated with the/associated with/
s/knowledge of targeted VM/knowledge of how the VF will be used/

> +		The values accepted are:
> +		 * > 0 - this will be number reported by the VF's MSI-X
> +			 capability

  this number will be reported as the Table Size in the VF's MSI-X
  capability

> +		 * < 0 - not valid
> +		 * = 0 - will reset to the device default value
> +
> +		The file is writable if the PF is bound to a driver that
> +		implements ->sriov_set_msix_vec_count().
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 4afd4ee4f7f0..c0554aa6b90a 100644
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
> @@ -157,6 +158,158 @@ int pci_iov_sysfs_link(struct pci_dev *dev,
>  	return rc;
>  }
> 
> +#ifdef CONFIG_PCI_MSI
> +static ssize_t sriov_vf_msix_count_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t count)
> +{
> +	struct pci_dev *vf_dev = to_pci_dev(dev);
> +	struct pci_dev *pdev = pci_physfn(vf_dev);
> +	int val, ret;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val < 0)
> +		return -EINVAL;
> +
> +	device_lock(&pdev->dev);
> +	if (!pdev->driver || !pdev->driver->sriov_set_msix_vec_count) {
> +		ret = -EOPNOTSUPP;
> +		goto err_pdev;
> +	}
> +
> +	device_lock(&vf_dev->dev);
> +	if (vf_dev->driver) {
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
> +	ret = pdev->driver->sriov_set_msix_vec_count(vf_dev, val);
> +
> +err_dev:
> +	device_unlock(&vf_dev->dev);
> +err_pdev:
> +	device_unlock(&pdev->dev);
> +	return ret ? : count;
> +}
> +static DEVICE_ATTR_WO(sriov_vf_msix_count);
> +
> +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	u32 vf_total_msix;
> +
> +	device_lock(dev);
> +	if (!pdev->driver || !pdev->driver->sriov_get_vf_total_msix) {
> +		device_unlock(dev);
> +		return -EOPNOTSUPP;
> +	}
> +	vf_total_msix = pdev->driver->sriov_get_vf_total_msix(pdev);
> +	device_unlock(dev);
> +
> +	return sysfs_emit(buf, "%u\n", vf_total_msix);
> +}
> +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> +#endif
> +
> +static const struct attribute *sriov_pf_dev_attrs[] = {
> +#ifdef CONFIG_PCI_MSI
> +	&dev_attr_sriov_vf_total_msix.attr,
> +#endif
> +	NULL,
> +};
> +
> +static const struct attribute *sriov_vf_dev_attrs[] = {
> +#ifdef CONFIG_PCI_MSI
> +	&dev_attr_sriov_vf_msix_count.attr,
> +#endif
> +	NULL,
> +};
> +
> +/*
> + * The PF can change the specific properties of associated VFs. Such
> + * functionality is usually known after PF probed and PCI sysfs files
> + * were already created.

s/The PF can/The PF may be able to/

> + * The function below is driven by such PF. It adds sysfs files to already
> + * existing PF/VF sysfs device hierarchies.

  pci_enable_vf_overlay() and pci_disable_vf_overlay() should be
  called by PF drivers that support changing the number of MSI-X
  vectors assigned to their VFs.

> + */
> +int pci_enable_vf_overlay(struct pci_dev *dev)
> +{
> +	struct pci_dev *virtfn;
> +	int id, ret;
> +
> +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> +		return 0;
> +
> +	ret = sysfs_create_files(&dev->dev.kobj, sriov_pf_dev_attrs);

But I still don't like the fact that we're calling
sysfs_create_files() and sysfs_remove_files() directly.  It makes
complication and opportunities for errors.

I don't see the advantage of creating these files only when the PF
driver supports this.  The management tools have to deal with
sriov_vf_total_msix == 0 and sriov_vf_msix_count == 0 anyway.
Having the sysfs files not be present at all might be slightly
prettier to the person running "ls", but I'm not sure the code
complication is worth that.

I see a hint that Alex might have requested this "only visible when PF
driver supports it" functionality, but I don't see that email on
linux-pci, so I missed the background.

It's true that we have a clump of "sriov_*" sysfs files and this makes
the clump a little bigger.  I wish we had put them all inside an "iov"
directory to begin with, but that's water under the bridge.

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
> +		ret = sysfs_create_files(&virtfn->dev.kobj,
> +					 sriov_vf_dev_attrs);
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
> +		sysfs_remove_files(&virtfn->dev.kobj, sriov_vf_dev_attrs);
> +	}
> +	sysfs_remove_files(&dev->dev.kobj, sriov_pf_dev_attrs);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pci_enable_vf_overlay);
> +
> +void pci_disable_vf_overlay(struct pci_dev *dev)
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
> +		sysfs_remove_files(&virtfn->dev.kobj, sriov_vf_dev_attrs);
> +	}
> +	sysfs_remove_files(&dev->dev.kobj, sriov_pf_dev_attrs);
> +}
> +EXPORT_SYMBOL_GPL(pci_disable_vf_overlay);
> +
>  int pci_iov_add_virtfn(struct pci_dev *dev, int id)
>  {
>  	int i;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index b32126d26997..732611937574 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -856,6 +856,11 @@ struct module;
>   *		e.g. drivers/net/e100.c.
>   * @sriov_configure: Optional driver callback to allow configuration of
>   *		number of VFs to enable via sysfs "sriov_numvfs" file.
> + * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
> + *              to configure via sysfs "sriov_vf_msix_count" entry. This will
> + *              change MSI-X Table Size in their Message Control registers.

s/Driver callback/PF driver callback/
s/in their/in VF/

> + * @sriov_get_vf_total_msix: Total number of MSI-X veectors to distribute
> + *              to the VFs

s/Total number/PF driver callback to get the total number/
s/veectors/vectors/
s/to distribute/available for distribution/

>   * @err_handler: See Documentation/PCI/pci-error-recovery.rst
>   * @groups:	Sysfs attribute groups.
>   * @driver:	Driver model structure.
> @@ -871,6 +876,8 @@ struct pci_driver {
>  	int  (*resume)(struct pci_dev *dev);	/* Device woken up */
>  	void (*shutdown)(struct pci_dev *dev);
>  	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
> +	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
> +	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
>  	const struct pci_error_handlers *err_handler;
>  	const struct attribute_group **groups;
>  	struct device_driver	driver;
> @@ -2059,6 +2066,9 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
>  int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
>  int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
> 
> +int pci_enable_vf_overlay(struct pci_dev *dev);
> +void pci_disable_vf_overlay(struct pci_dev *dev);
> +
>  int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
>  void pci_disable_sriov(struct pci_dev *dev);
> 
> @@ -2100,6 +2110,8 @@ static inline int pci_iov_add_virtfn(struct pci_dev *dev, int id)
>  }
>  static inline void pci_iov_remove_virtfn(struct pci_dev *dev,
>  					 int id) { }
> +static inline int pci_enable_vf_overlay(struct pci_dev *dev) { return 0; }
> +static inline void pci_disable_vf_overlay(struct pci_dev *dev) { }
>  static inline void pci_disable_sriov(struct pci_dev *dev) { }
>  static inline int pci_num_vf(struct pci_dev *dev) { return 0; }
>  static inline int pci_vfs_assigned(struct pci_dev *dev)
> --
> 2.29.2
> 
