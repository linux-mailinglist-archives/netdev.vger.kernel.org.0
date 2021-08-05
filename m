Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0969B3E0B15
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 02:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhHEAFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 20:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhHEAFk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 20:05:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D221E60F41;
        Thu,  5 Aug 2021 00:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628121927;
        bh=aJsHU45E+AMYpCbQOpoPjJfhQy92huQZqAwWcJibXu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=CaFGLAXx3W/YYe2NufnLcbOTs9MvistiGxZ8qj/CgsE0F3+nkq1eWc8MeUb6bW4C7
         bZQqA5Nl4IwwBMFM7ueF0LtZWhJ63bkvYEiaC/cjMz2TgYoB0F3zjTXfhQHsLpBVK3
         kJHG49lpjZxmuEre2Iuc+7C34r3SGAsXlc8Z+OHW+36tFp5XJKMIIoZ9zTVZaS1I7H
         6c+KRjyg8Dg6RZMBrGIghKQvvFNHpofWWXEyKx3+jw5PkmIYj9CebtVJph07fXfLbe
         c8gl9neCtbaGi+/LoT1Ec2suodKzyjBEDppwgJUyS69JXV9cosYwZQIZc03wr8YB9V
         5k+xrRmnExl8Q==
Date:   Wed, 4 Aug 2021 19:05:25 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 8/9] PCI/IOV: Add 10-Bit Tag sysfs files for VF devices
Message-ID: <20210805000525.GA1693795@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628084828-119542-9-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 09:47:07PM +0800, Dongdong Liu wrote:
> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
> sending Requests to other Endpoints (as opposed to host memory), the
> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
> unless an implementation-specific mechanism determines that the
> Endpoint supports 10-Bit Tag Completer capability.
> Add sriov_vf_10bit_tag file to query the status of VF 10-Bit Tag
> Requester Enable. Add sriov_vf_10bit_tag_ctl file to disable the VF
> 10-Bit Tag Requester. The typical use case is for p2pdma when the peer
> device does not support 10-BIT Tag Completer.

Fix the usual spec quoting issue.  Or maybe this is not actually
quoted but is missing blank lines between paragraphs.

s/10-BIT/10-Bit/

> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 20 +++++++++++++
>  drivers/pci/iov.c                       | 50 +++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 0e0c97d..8fdbfae 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -421,3 +421,23 @@ Description:
>  		to disable 10-Bit Tag Requester when the driver does not bind
>  		the deivce. The typical use case is for p2pdma when the peer
>  		device does not support 10-BIT Tag Completer.
> +
> +What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag
> +Date:		August 2021
> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
> +Description:
> +		This file is associated with a SR-IOV physical function (PF).
> +		It is visible when the device has VF 10-Bit Tag Requester
> +		Supported. It contains the status of VF 10-Bit Tag Requester
> +		Enable. The file is only readable.

s/only readable/read-only/

> +What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl

Why does this file have "_ctl" on the end when the one in patch 7/9
does not?

> +Date:		August 2021
> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
> +Description:
> +		This file is associated with a SR-IOV virtual function (VF).
> +		It is visible when the device has VF 10-Bit Tag Requester
> +		Supported. It only allows to write 0 to disable VF 10-Bit
> +		Tag Requester. The file is only writeable when the vf driver
> +		does not bind to a dirver. The typical use case is for p2pdma
> +		when the peer device does not support 10-BIT Tag Completer.

s/vf/VF/
s/dirver/driver/
s/10-BIT/10-Bit/

"when the vr driver does not bind to a driver"?  Not quite right.
Must be a "device" in there somewhere.

So IIUC this file is associated with a VF, but the bit it writes is
actually in the *PF*?  So writing 0 to any VF's file disables 10-bit
tags for *all* VFs?  That's worth mentioning here.

> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 0d0bed1..04c1298 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -220,10 +220,38 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
>  static DEVICE_ATTR_WO(sriov_vf_msix_count);
>  #endif
>  
> +static ssize_t sriov_vf_10bit_tag_ctl_store(struct device *dev,
> +					    struct device_attribute *attr,
> +					    const char *buf, size_t count)
> +{
> +	struct pci_dev *vf_dev = to_pci_dev(dev);
> +	struct pci_dev *pdev = pci_physfn(vf_dev);
> +	struct pci_sriov *iov;
> +	bool enable;
> +
> +	if (kstrtobool(buf, &enable) < 0)
> +		return -EINVAL;
> +
> +	if (enable != false)
> +		return -EINVAL;

Is this "if (enable)" again?

> +	if (vf_dev->driver)
> +		return -EBUSY;
> +
> +	iov = pdev->sriov;
> +	iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
> +	pci_write_config_word(pdev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
> +	pci_info(pdev, "disabled SRIOV 10-Bit Tag Requester\n");

s/SRIOV/SR-IOV/ to match spec and other usages.

> +
> +	return count;
> +}
> +static DEVICE_ATTR_WO(sriov_vf_10bit_tag_ctl);
> +
>  static struct attribute *sriov_vf_dev_attrs[] = {
>  #ifdef CONFIG_PCI_MSI
>  	&dev_attr_sriov_vf_msix_count.attr,
>  #endif
> +	&dev_attr_sriov_vf_10bit_tag_ctl.attr,
>  	NULL,
>  };
>  
> @@ -236,6 +264,11 @@ static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
>  	if (!pdev->is_virtfn)
>  		return 0;
>  
> +	pdev = pci_physfn(pdev);
> +	if ((a == &dev_attr_sriov_vf_10bit_tag_ctl.attr) &&
> +	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
> +		return 0;
> +
>  	return a->mode;
>  }
>  
> @@ -487,12 +520,23 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t sriov_vf_10bit_tag_show(struct device *dev,
> +				       struct device_attribute *attr,
> +				       char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	return sysfs_emit(buf, "%u\n",
> +		!!(pdev->sriov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN));
> +}
> +
>  static DEVICE_ATTR_RO(sriov_totalvfs);
>  static DEVICE_ATTR_RW(sriov_numvfs);
>  static DEVICE_ATTR_RO(sriov_offset);
>  static DEVICE_ATTR_RO(sriov_stride);
>  static DEVICE_ATTR_RO(sriov_vf_device);
>  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
> +static DEVICE_ATTR_RO(sriov_vf_10bit_tag);
>  
>  static struct attribute *sriov_pf_dev_attrs[] = {
>  	&dev_attr_sriov_totalvfs.attr,
> @@ -501,6 +545,7 @@ static struct attribute *sriov_pf_dev_attrs[] = {
>  	&dev_attr_sriov_stride.attr,
>  	&dev_attr_sriov_vf_device.attr,
>  	&dev_attr_sriov_drivers_autoprobe.attr,
> +	&dev_attr_sriov_vf_10bit_tag.attr,
>  #ifdef CONFIG_PCI_MSI
>  	&dev_attr_sriov_vf_total_msix.attr,
>  #endif
> @@ -511,10 +556,15 @@ static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
>  					  struct attribute *a, int n)
>  {
>  	struct device *dev = kobj_to_dev(kobj);
> +	struct pci_dev *pdev = to_pci_dev(dev);
>  
>  	if (!dev_is_pf(dev))
>  		return 0;
>  
> +	if ((a == &dev_attr_sriov_vf_10bit_tag.attr) &&
> +	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
> +		return 0;
> +
>  	return a->mode;
>  }
>  
> -- 
> 2.7.4
> 
