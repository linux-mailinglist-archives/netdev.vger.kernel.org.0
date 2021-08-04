Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCD53E0AFB
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhHDXuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232888AbhHDXuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 19:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F3A60EE9;
        Wed,  4 Aug 2021 23:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628120995;
        bh=f5r/sMP7iIPAEJr9tIsobo8fkmy6QOlehbE9BvavuqA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=gFHneAe7skpZlFzWA5gm5BTcX8zO6oEGGg1fx7117nifuyc2R41dCehhqETaVULIO
         dgMyeBNdOkR7NmbKLgS7z35Q9jut2e9QTPM0tBXiyys3+wb+DsxKXiVJqTkHdH9gMr
         zswHMkXB1oKvclpGXUPb4Jkgt5GrzuuL+R+k764ZmGCCbahoQK0OzhrkolZ2EhWVoW
         wHIBWWiMA5Vl6RnAZClCbH9VE9b/Yx4inZEb96XTRbtlatnfMOoKiB3ApRzz5zxNtR
         m6j8dIEpF3c9VmMh9duHNoLK/qBV4XYXV/30QmPHU9zNbzUlkk/5BC3mKjeHAXHkKS
         Vnk0WsjVZyB+A==
Date:   Wed, 4 Aug 2021 18:49:54 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 7/9] PCI/sysfs: Add a 10-Bit Tag sysfs file
Message-ID: <20210804234954.GA1692741@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628084828-119542-8-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 09:47:06PM +0800, Dongdong Liu wrote:
> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
> sending Requests to other Endpoints (as opposed to host memory), the
> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
> unless an implementation-specific mechanism determines that the Endpoint
> supports 10-Bit Tag Completer capability. Add a 10bit_tag sysfs file,
> write 0 to disable 10-Bit Tag Requester when the driver does not bind
> the device if the peer device does not support the 10-Bit Tag Completer.
> This will make P2P traffic safe. the 10bit_tag file content indicate
> current 10-Bit Tag Requester Enable status.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 16 +++++++-
>  drivers/pci/pci-sysfs.c                 | 69 +++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 793cbb7..0e0c97d 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -139,7 +139,7 @@ Description:
>  		binary file containing the Vital Product Data for the
>  		device.  It should follow the VPD format defined in
>  		PCI Specification 2.1 or 2.2, but users should consider
> -		that some devices may have incorrectly formatted data.  
> +		that some devices may have incorrectly formatted data.
>  		If the underlying VPD has a writable section then the
>  		corresponding section of this file will be writable.
>  
> @@ -407,3 +407,17 @@ Description:
>  
>  		The file is writable if the PF is bound to a driver that
>  		implements ->sriov_set_msix_vec_count().
> +
> +What:		/sys/bus/pci/devices/.../10bit_tag
> +Date:		August 2021
> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
> +Description:
> +		If a PCI device support 10-Bit Tag Requester, will create the
> +		10bit_tag sysfs file. The file is readable, the value
> +		indicate current 10-Bit Tag Requester Enable.
> +		1 - enabled, 0 - disabled.
> +
> +		The file is also writeable, the value only accept by write 0
> +		to disable 10-Bit Tag Requester when the driver does not bind
> +		the deivce. The typical use case is for p2pdma when the peer
> +		device does not support 10-BIT Tag Completer.

s/writeable/writable/
s/deivce/device/

The first sentence does not parse.

> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 5d63df7..e93ce8b 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -306,6 +306,49 @@ static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RW(enable);
>  
> +static ssize_t pci_10bit_tag_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	bool enable;
> +
> +	if (kstrtobool(buf, &enable) < 0)
> +		return -EINVAL;
> +
> +	if (enable != false )
> +		return -EINVAL;

Is this the same as "if (enable)"?

> +	if (pdev->driver)
> +		 return -EBUSY;
> +
> +	pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL2,
> +				   PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +	pci_info(pdev, "disabled 10-Bit Tag Requester\n");
> +
> +	return count;
> +}
> +
> +static ssize_t pci_10bit_tag_show(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	u16 ctl;
> +	int ret;
> +
> +	ret = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &ctl);
> +	if (ret)
> +		return -EINVAL;
> +
> +	return sysfs_emit(buf, "%u\n",
> +			  !!(ctl & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN));
> +}
> +
> +static struct device_attribute dev_attr_10bit_tag = __ATTR(10bit_tag, 0600,
> +							   pci_10bit_tag_show,
> +							   pci_10bit_tag_store);

Is this DEVICE_ATTR_ADMIN_RW()?

Why is it 0600?  Everything else in this file looks like
DEVICE_ATTR_RO or DEVICE_ATTR_RW.  This should be the same unless
there's a reason to be different.

>  #ifdef CONFIG_NUMA
>  static ssize_t numa_node_store(struct device *dev,
>  			       struct device_attribute *attr, const char *buf,
> @@ -635,6 +678,11 @@ static struct attribute *pcie_dev_attrs[] = {
>  	NULL,
>  };
>  
> +static struct attribute *pcie_dev_10bit_tag_attrs[] = {
> +	&dev_attr_10bit_tag.attr,
> +	NULL,
> +};
> +
>  static struct attribute *pcibus_attrs[] = {
>  	&dev_attr_bus_rescan.attr,
>  	&dev_attr_cpuaffinity.attr,
> @@ -1482,6 +1530,21 @@ static umode_t pcie_dev_attrs_are_visible(struct kobject *kobj,
>  	return 0;
>  }
>  
> +static umode_t pcie_dev_10bit_tag_attrs_are_visible(struct kobject *kobj,
> +					  struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (pdev->is_virtfn)
> +		return 0;
> +
> +	if (!(pdev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
> +		return 0;
> +
> +	return a->mode;
> +}
> +
>  static const struct attribute_group pci_dev_group = {
>  	.attrs = pci_dev_attrs,
>  };
> @@ -1521,6 +1584,11 @@ static const struct attribute_group pcie_dev_attr_group = {
>  	.is_visible = pcie_dev_attrs_are_visible,
>  };
>  
> +static const struct attribute_group pcie_dev_10bit_tag_attr_group = {
> +	.attrs = pcie_dev_10bit_tag_attrs,
> +	.is_visible = pcie_dev_10bit_tag_attrs_are_visible,
> +};
> +
>  static const struct attribute_group *pci_dev_attr_groups[] = {
>  	&pci_dev_attr_group,
>  	&pci_dev_hp_attr_group,
> @@ -1530,6 +1598,7 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
>  #endif
>  	&pci_bridge_attr_group,
>  	&pcie_dev_attr_group,
> +	&pcie_dev_10bit_tag_attr_group,
>  #ifdef CONFIG_PCIEAER
>  	&aer_stats_attr_group,
>  #endif
> -- 
> 2.7.4
> 
