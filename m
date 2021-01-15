Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE742F6F41
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbhAOAHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:07:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbhAOAHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 19:07:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610669143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBPKCL+kqPX9iVSz+iKSVSYyOfI3KtlyhhyW5r/9Qww=;
        b=Xi27H1Ou7aGJKAaQPN195yVpcmQ1fSmNegvMglmqKSzhc70Ly0lG+KNyGMV08ReUkKwmxT
        RxxyrEq6yJ9C83QpICMayWwbsczbSKHIKX2aFcTeTgmNGZ2wVFTWlvqMiLb46mXF8FFUMJ
        7W9PleyVBPtZE6DoMhj7QvVAcl4w/NE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-bG3jlvP5PS2tdXM2EVpoVg-1; Thu, 14 Jan 2021 19:05:39 -0500
X-MC-Unique: bG3jlvP5PS2tdXM2EVpoVg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD60A802B46;
        Fri, 15 Jan 2021 00:05:37 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2652860C6A;
        Fri, 15 Jan 2021 00:05:37 +0000 (UTC)
Date:   Thu, 14 Jan 2021 17:05:36 -0700
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
Subject: Re: [PATCH mlx5-next v2 2/5] PCI: Add SR-IOV sysfs entry to read
 total number of dynamic MSI-X vectors
Message-ID: <20210114170536.004601d1@omen.home.shazbot.org>
In-Reply-To: <20210114103140.866141-3-leon@kernel.org>
References: <20210114103140.866141-1-leon@kernel.org>
        <20210114103140.866141-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 12:31:37 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Some SR-IOV capable devices provide an ability to configure specific
> number of MSI-X vectors on their VF prior driver is probed on that VF.
> 
> In order to make management easy, provide new read-only sysfs file that
> returns a total number of possible to configure MSI-X vectors.
> 
> cat /sys/bus/pci/devices/.../sriov_vf_total_msix
>   = 0 - feature is not supported
>   > 0 - total number of MSI-X vectors to consume by the VFs  
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
>  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
>  drivers/pci/pci.h                       |  3 +++
>  include/linux/pci.h                     |  2 ++
>  4 files changed, 50 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 34a8c6bcde70..530c249cc3da 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -395,3 +395,17 @@ Description:
>  		The file is writable if the PF is bound to a driver that
>  		set sriov_vf_total_msix > 0 and there is no driver bound
>  		to the VF.
> +
> +What:		/sys/bus/pci/devices/.../sriov_vf_total_msix
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

As with previous, why expose it if not supported?

This seems pretty challenging for userspace to use; aiui they would
need to iterate all the VFs to learn how many vectors are already
allocated, subtract that number from this value, all while hoping they
aren't racing someone else doing the same.  Would it be more useful if
this reported the number of surplus vectors available?

How would a per VF limit be exposed?  Do we expect users to know the
absolutely MSI-X vector limit or the device specific limit?  Thanks,

Alex

> +
> +		If no SR-IOV VFs are enabled, this value will return 0.
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 5bc496f8ffa3..f9dc31947dbc 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
>  	return count;
>  }
> 
> +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	return sprintf(buf, "%u\n", pdev->sriov->vf_total_msix);
> +}
> +
>  static DEVICE_ATTR_RO(sriov_totalvfs);
>  static DEVICE_ATTR_RW(sriov_numvfs);
>  static DEVICE_ATTR_RO(sriov_offset);
>  static DEVICE_ATTR_RO(sriov_stride);
>  static DEVICE_ATTR_RO(sriov_vf_device);
>  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> +static DEVICE_ATTR_RO(sriov_vf_total_msix);
> 
>  static struct attribute *sriov_dev_attrs[] = {
>  	&dev_attr_sriov_totalvfs.attr,
> @@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
>  	&dev_attr_sriov_stride.attr,
>  	&dev_attr_sriov_vf_device.attr,
>  	&dev_attr_sriov_drivers_autoprobe.attr,
> +	&dev_attr_sriov_vf_total_msix.attr,
>  	NULL,
>  };
> 
> @@ -654,6 +665,7 @@ static void sriov_disable(struct pci_dev *dev)
>  		sysfs_remove_link(&dev->dev.kobj, "dep_link");
> 
>  	iov->num_VFs = 0;
> +	iov->vf_total_msix = 0;
>  	pci_iov_set_numvfs(dev, 0);
>  }
> 
> @@ -1112,6 +1124,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);
> 
> +/**
> + * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
> + * @dev: the PCI PF device
> + * @count: the total number of MSI-X vector to consume by the VFs
> + *
> + * Sets the number of MSI-X vectors that is possible to consume by the VFs.
> + * This interface is complimentary part of the pci_set_msix_vec_count()
> + * that will be used to configure the required number on the VF.
> + */
> +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count)
> +{
> +	if (!dev->is_physfn || !dev->driver ||
> +	    !dev->driver->sriov_set_msix_vec_count)
> +		return;
> +
> +	dev->sriov->vf_total_msix = count;
> +}
> +EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
> +
>  /**
>   * pci_sriov_configure_simple - helper to configure SR-IOV
>   * @dev: the PCI device
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index dbbfa9e73ea8..604e1f9172c2 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -327,6 +327,9 @@ struct pci_sriov {
>  	u16		subsystem_device; /* VF subsystem device */
>  	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
>  	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
> +	u32		vf_total_msix;  /* Total number of MSI-X vectors the VFs
> +					 * can consume
> +					 */
>  };
> 
>  /**
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 6be96d468eda..c950513558b8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -2075,6 +2075,7 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev);
>  int pci_sriov_configure_simple(struct pci_dev *dev, int nr_virtfn);
>  resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno);
>  void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe);
> +void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count);
> 
>  /* Arch may override these (weak) */
>  int pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs);
> @@ -2115,6 +2116,7 @@ static inline int pci_sriov_get_totalvfs(struct pci_dev *dev)
>  static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
>  { return 0; }
>  static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
> +static inline void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count) {}
>  #endif
> 
>  #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
> --
> 2.29.2
> 

