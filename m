Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694A52F6F44
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbhAOAHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:07:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbhAOAHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 19:07:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610669148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++XP1ZGCBZvxkkc558CilV07g0jT3tcv6eywevTFqA4=;
        b=h5g9rQw4WQba8H2ONU9DFL8bx9MpuCvtLNi/Va5vRtLtOcf+Tkjof2YZwl3C4IaUT4qNzR
        afecmyvZC37VikC2QdNiZ/jnut+vjmwVySrFjH2pN52h1unsxAmeZyH9RNKlIa3oq3yAk4
        3fdN45SVlszShrGLamiVIWtOiblF1/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447--xKJ_ZqmMlWFCpI6m-hmMQ-1; Thu, 14 Jan 2021 19:05:46 -0500
X-MC-Unique: -xKJ_ZqmMlWFCpI6m-hmMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E16BC107ACF7;
        Fri, 15 Jan 2021 00:05:44 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35F4A19C45;
        Fri, 15 Jan 2021 00:05:44 +0000 (UTC)
Date:   Thu, 14 Jan 2021 17:05:43 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH mlx5-next v2 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210114170543.143cce49@omen.home.shazbot.org>
In-Reply-To: <20210114103140.866141-2-leon@kernel.org>
References: <20210114103140.866141-1-leon@kernel.org>
        <20210114103140.866141-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 12:31:36 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend PCI sysfs interface with a new callback that allows configure
> the number of MSI-X vectors for specific SR-IO VF. This is needed
> to optimize the performance of newly bound devices by allocating
> the number of vectors based on the administrator knowledge of targeted VM.
> 
> This function is applicable for SR-IOV VF because such devices allocate
> their MSI-X table before they will run on the VMs and HW can't guess the
> right number of vectors, so the HW allocates them statically and equally.
> 
> The newly added /sys/bus/pci/devices/.../sriov_vf_msix_count file will be seen
> for the VFs and it is writable as long as a driver is not bounded to the VF.
> 
> The values accepted are:
>  * > 0 - this will be number reported by the VF's MSI-X capability
>  * < 0 - not valid
>  * = 0 - will reset to the device default value
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 20 +++++++++
>  drivers/pci/iov.c                       | 58 +++++++++++++++++++++++++
>  drivers/pci/msi.c                       | 47 ++++++++++++++++++++
>  drivers/pci/pci-sysfs.c                 |  1 +
>  drivers/pci/pci.h                       |  2 +
>  include/linux/pci.h                     |  3 ++
>  6 files changed, 131 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 25c9c39770c6..34a8c6bcde70 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -375,3 +375,23 @@ Description:
>  		The value comes from the PCI kernel device state and can be one
>  		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
>  		The file is read only.
> +
> +What:		/sys/bus/pci/devices/.../sriov_vf_msix_count
> +Date:		December 2020
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
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 4afd4ee4f7f0..5bc496f8ffa3 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
>  	return (dev->devfn + dev->sriov->offset +
>  		dev->sriov->stride * vf_id) & 0xff;
>  }
> +EXPORT_SYMBOL(pci_iov_virtfn_devfn);
> 
>  /*
>   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
> @@ -426,6 +427,63 @@ const struct attribute_group sriov_dev_attr_group = {
>  	.is_visible = sriov_attrs_are_visible,
>  };
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
> +	return sprintf(buf, "%d\n", count);
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
> +	ret = pci_set_msix_vec_count(vf_dev, val);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}
> +static DEVICE_ATTR_RW(sriov_vf_msix_count);
> +#endif
> +
> +static struct attribute *sriov_vf_dev_attrs[] = {
> +#ifdef CONFIG_PCI_MSI
> +	&dev_attr_sriov_vf_msix_count.attr,
> +#endif
> +	NULL,
> +};
> +
> +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> +					  struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +
> +	if (dev_is_pf(dev))
> +		return 0;

Wouldn't it be cleaner to also hide this on VFs where
pci_msix_vec_count() returns an error or where the PF driver doesn't
implement .sriov_set_msix_vec_count()?  IOW, expose it only where it
could actually work.

> +
> +	return a->mode;
> +}
> +
> +const struct attribute_group sriov_vf_dev_attr_group = {
> +	.attrs = sriov_vf_dev_attrs,
> +	.is_visible = sriov_vf_attrs_are_visible,
> +};
> +
>  int __weak pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs)
>  {
>  	return 0;
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 3162f88fe940..5a40200343c9 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -991,6 +991,53 @@ int pci_msix_vec_count(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pci_msix_vec_count);
> 
> +/**
> + * pci_set_msix_vec_count - change the reported number of MSI-X vectors
> + * This function is applicable for SR-IOV VF because such devices allocate
> + * their MSI-X table before they will run on the VMs and HW can't guess the
> + * right number of vectors, so the HW allocates them statically and equally.

Nit, this is an assumption of the VF usage and conjecture of the
implementation.

> + * @dev: VF device that is going to be changed
> + * @count amount of MSI-X vectors
> + **/
> +int pci_set_msix_vec_count(struct pci_dev *dev, int count)

pci_vf_set_msix_vec_count()?  Long, I know, but if it's limited to VFs
name it accordingly.  Thanks,

Alex

> +{
> +	struct pci_dev *pdev = pci_physfn(dev);
> +	int ret;
> +
> +	if (!dev->msix_cap || !pdev->msix_cap || count < 0)
> +		/*
> +		 * We don't support negative numbers for now,
> +		 * but maybe in the future it will make sense.
> +		 */
> +		return -EINVAL;
> +
> +	device_lock(&pdev->dev);
> +	if (!pdev->driver || !pdev->driver->sriov_set_msix_vec_count) {
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
> +
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
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index fb072f4b3176..0af2222643c2 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1557,6 +1557,7 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
>  	&pci_dev_hp_attr_group,
>  #ifdef CONFIG_PCI_IOV
>  	&sriov_dev_attr_group,
> +	&sriov_vf_dev_attr_group,
>  #endif
>  	&pci_bridge_attr_group,
>  	&pcie_dev_attr_group,
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 5c59365092fa..dbbfa9e73ea8 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -183,6 +183,7 @@ extern unsigned int pci_pm_d3hot_delay;
> 
>  #ifdef CONFIG_PCI_MSI
>  void pci_no_msi(void);
> +int pci_set_msix_vec_count(struct pci_dev *dev, int count);
>  #else
>  static inline void pci_no_msi(void) { }
>  #endif
> @@ -502,6 +503,7 @@ resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
>  void pci_restore_iov_state(struct pci_dev *dev);
>  int pci_iov_bus_range(struct pci_bus *bus);
>  extern const struct attribute_group sriov_dev_attr_group;
> +extern const struct attribute_group sriov_vf_dev_attr_group;
>  #else
>  static inline int pci_iov_init(struct pci_dev *dev)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index b32126d26997..6be96d468eda 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -856,6 +856,8 @@ struct module;
>   *		e.g. drivers/net/e100.c.
>   * @sriov_configure: Optional driver callback to allow configuration of
>   *		number of VFs to enable via sysfs "sriov_numvfs" file.
> + * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
> + *              exposed by the sysfs "vf_msix_vec" entry.
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
> --
> 2.29.2
> 

