Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D489353720
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 09:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhDDHCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 03:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhDDHCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 03:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F1EF6136A;
        Sun,  4 Apr 2021 07:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617519756;
        bh=wDHeSpp21bHcFsxv+473kLXqepmISuehI5Xc0f2rNoc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rf99YKqZDA/pVCnPCLveICKE7TuEpUn8V2aK5bg0IAoeJxCJjCM2KBz0Tc3qo7CDE
         WqPcHnnFz27VxNMFPFzIhb1J+4tgHHzTZia/efPu7C6jAcYSxpKUWRZLu4GQ69at4P
         FK0i+XgLaVHA5Arsz+ix1NE6D4YnivLG+OIYeVtnd5PONvrS9EYFEdwp0wnnR/10xH
         mb8bTt7Z/5VH5nzvsBzIQLEJK4otZ+JN4bI/Lnz3n0wZgIdXifKiMkkEPW3xh5bjNN
         56iFi+sdclYnmJxPSVR0RMqQ7CDCkJXv0i+Qc1nKrmhunRg7ygIBX/mCUZwhxROlru
         c6sLB3+EGVapg==
Date:   Sun, 4 Apr 2021 10:02:32 +0300
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
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v8 1/4] PCI: Add a sysfs file to change the
 MSI-X table size of SR-IOV VFs
Message-ID: <YGlkiBpcZwWFdE81@unreal>
References: <20210314124256.70253-2-leon@kernel.org>
 <20210403002426.GA1560457@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403002426.GA1560457@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 07:24:26PM -0500, Bjorn Helgaas wrote:
> Possible subject, since this adds *two* files, not just "a file":
> 
>   PCI/IOV: Add sysfs MSI-X vector assignment interface

Sure

> 
> On Sun, Mar 14, 2021 at 02:42:53PM +0200, Leon Romanovsky wrote:
> > A typical cloud provider SR-IOV use case is to create many VFs for use by
> > guest VMs. The VFs may not be assigned to a VM until a customer requests a
> > VM of a certain size, e.g., number of CPUs. A VF may need MSI-X vectors
> > proportional to the number of CPUs in the VM, but there is no standard way
> > to change the number of MSI-X vectors supported by a VF.
> > ...
> 
> > +#ifdef CONFIG_PCI_MSI
> > +static ssize_t sriov_vf_msix_count_store(struct device *dev,
> > +					 struct device_attribute *attr,
> > +					 const char *buf, size_t count)
> > +{
> > +	struct pci_dev *vf_dev = to_pci_dev(dev);
> > +	struct pci_dev *pdev = pci_physfn(vf_dev);
> > +	int val, ret;
> > +
> > +	ret = kstrtoint(buf, 0, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (val < 0)
> > +		return -EINVAL;
> > +
> > +	device_lock(&pdev->dev);
> > +	if (!pdev->driver || !pdev->driver->sriov_set_msix_vec_count) {
> > +		ret = -EOPNOTSUPP;
> > +		goto err_pdev;
> > +	}
> > +
> > +	device_lock(&vf_dev->dev);
> > +	if (vf_dev->driver) {
> > +		/*
> > +		 * A driver is already attached to this VF and has configured
> > +		 * itself based on the current MSI-X vector count. Changing
> > +		 * the vector size could mess up the driver, so block it.
> > +		 */
> > +		ret = -EBUSY;
> > +		goto err_dev;
> > +	}
> > +
> > +	ret = pdev->driver->sriov_set_msix_vec_count(vf_dev, val);
> > +
> > +err_dev:
> > +	device_unlock(&vf_dev->dev);
> > +err_pdev:
> > +	device_unlock(&pdev->dev);
> > +	return ret ? : count;
> > +}
> > +static DEVICE_ATTR_WO(sriov_vf_msix_count);
> > +
> > +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> > +					struct device_attribute *attr,
> > +					char *buf)
> > +{
> > +	struct pci_dev *pdev = to_pci_dev(dev);
> > +	u32 vf_total_msix = 0;
> > +
> > +	device_lock(dev);
> > +	if (!pdev->driver || !pdev->driver->sriov_get_vf_total_msix)
> > +		goto unlock;
> > +
> > +	vf_total_msix = pdev->driver->sriov_get_vf_total_msix(pdev);
> > +unlock:
> > +	device_unlock(dev);
> > +	return sysfs_emit(buf, "%u\n", vf_total_msix);
> > +}
> > +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> 
> Can you reverse the order of sriov_vf_total_msix_show() and
> sriov_vf_msix_count_store()?  Currently we have:
> 
>   VF stuff (msix_count_store)
>   PF stuff (total_msix)
>   more VF stuff related to the above (vf_dev_attrs, are_visible)
> 
> so the total_msix bit is mixed in the middle.

No problem, I'll do.

> 
> > +#endif
> > +
> > +static struct attribute *sriov_vf_dev_attrs[] = {
> > +#ifdef CONFIG_PCI_MSI
> > +	&dev_attr_sriov_vf_msix_count.attr,
> > +#endif
> > +	NULL,
> > +};
> > +
> > +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> > +					  struct attribute *a, int n)
> > +{
> > +	struct device *dev = kobj_to_dev(kobj);
> > +	struct pci_dev *pdev = to_pci_dev(dev);
> > +
> > +	if (!pdev->is_virtfn)
> > +		return 0;
> > +
> > +	return a->mode;
> > +}
> > +
> > +const struct attribute_group sriov_vf_dev_attr_group = {
> > +	.attrs = sriov_vf_dev_attrs,
> > +	.is_visible = sriov_vf_attrs_are_visible,
> > +};
> > +
> >  int pci_iov_add_virtfn(struct pci_dev *dev, int id)
> >  {
> >  	int i;
> > @@ -400,18 +487,21 @@ static DEVICE_ATTR_RO(sriov_stride);
> >  static DEVICE_ATTR_RO(sriov_vf_device);
> >  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> > 
> > -static struct attribute *sriov_dev_attrs[] = {
> > +static struct attribute *sriov_pf_dev_attrs[] = {
> 
> This and the related sriov_pf_attrs_are_visible change below are nice.
> Would you mind splitting them to a preliminary patch, since they
> really aren't related to the concept of *this* patch?

I don't think so, that prepatch will have only two lines of renames
from sriov_dev_attrs to be sriov_pf_dev_attrs. It is not worth the
hassle.

Thanks

> 
> >  	&dev_attr_sriov_totalvfs.attr,
> >  	&dev_attr_sriov_numvfs.attr,
> >  	&dev_attr_sriov_offset.attr,
> >  	&dev_attr_sriov_stride.attr,
> >  	&dev_attr_sriov_vf_device.attr,
> >  	&dev_attr_sriov_drivers_autoprobe.attr,
> > +#ifdef CONFIG_PCI_MSI
> > +	&dev_attr_sriov_vf_total_msix.attr,
> > +#endif
> >  	NULL,
> >  };
> > 
> > -static umode_t sriov_attrs_are_visible(struct kobject *kobj,
> > -				       struct attribute *a, int n)
> > +static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
> > +					  struct attribute *a, int n)
> >  {
> >  	struct device *dev = kobj_to_dev(kobj);
> > 
> > @@ -421,9 +511,9 @@ static umode_t sriov_attrs_are_visible(struct kobject *kobj,
> >  	return a->mode;
> >  }
> > 
> > -const struct attribute_group sriov_dev_attr_group = {
> > -	.attrs = sriov_dev_attrs,
> > -	.is_visible = sriov_attrs_are_visible,
> > +const struct attribute_group sriov_pf_dev_attr_group = {
> > +	.attrs = sriov_pf_dev_attrs,
> > +	.is_visible = sriov_pf_attrs_are_visible,
> >  };
