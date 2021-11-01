Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D22E44220C
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 21:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhKAU5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 16:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhKAU5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 16:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 787966052B;
        Mon,  1 Nov 2021 20:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635800084;
        bh=iJ+MBPjtmkOQFrq08Qfx6r4mlodxysE1veodnx84o+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=deUHehsU4umCnCq0ONUcJfkuH8yLhAhFh2kGnNjSBvKQaf+Uf7E3WAijgi3akurJi
         okqVkIqLbxQPWCjf83GklJb2urjaDq+CDmCLDJ7rxmkxhItEkvZzPd6FTZ74j2vO1R
         oRTJJ57bNCMPUi1ghIh/6fnbeIkTSjMrfY8AYDU66phwfHCs4CeNYbWUYGPLzHVm2A
         GXj2s4VpAR3HoszbTa2vKe5XTRsljc9vQ7G0QCSo55LU9umDO7XiRMrqYsUN6DUbr3
         IKGSPKfJfinSRIKJIN+nZ9fI0Sg7GSw6NGyOTjCobrdIApPrvENaRmXe2tnDanmbNd
         mjotnnw3XRQVA==
Date:   Mon, 1 Nov 2021 15:54:42 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V11 4/8] PCI/sysfs: Add a tags sysfs file for PCIe
 Endpoint devices
Message-ID: <20211101205442.GA546492@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030135348.61364-5-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 09:53:44PM +0800, Dongdong Liu wrote:
> PCIe spec 5.0 r1.0 section 2.2.6.2 says:
> 
>   If an Endpoint supports sending Requests to other Endpoints (as
>   opposed to host memory), the Endpoint must not send 10-Bit Tag
>   Requests to another given Endpoint unless an implementation-specific
>   mechanism determines that the Endpoint supports 10-Bit Tag Completer
>   capability.
> 
> Add a tags sysfs file, write 0 to disable 10-Bit Tag Requester
> when the driver does not bind the device. The typical use case is for
> p2pdma when the peer device does not support 10-Bit Tag Completer.
> Write 10 to enable 10-Bit Tag Requester when RC supports 10-Bit Tag
> Completer capability. The typical use case is for host memory targeted
> by DMA Requests. The tags file content indicate current status of Tags
> Enable.
> 
> PCIe r5.0, sec 2.2.6.2 says:
> 
>   Receivers/Completers must handle 8-bit Tag values correctly regardless
>   of the setting of their Extended Tag Field Enable bit (see Section
>   7.5.3.4).
> 
> Add this comment in pci_configure_extended_tags(). As all PCIe completers
> are required to support 8-bit tags, so we do not use tags sysfs file
> to manage 8-bit tags.

> +What:		/sys/bus/pci/devices/.../tags
> +Date:		September 2021
> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
> +Description:
> +		The file will be visible when the device supports 10-Bit Tag
> +		Requester. The file is readable, the value indicate current
> +		status of Tags Enable(5-Bit, 8-Bit, 10-Bit).
> +
> +		The file is also writable, The values accepted are:
> +		* > 0 - this number will be reported as tags bit to be
> +			enabled. current only 10 is accepted
> +		* < 0 - not valid
> +		* = 0 - disable 10-Bit Tag, use Extended Tags(8-Bit or 5-Bit)
> +
> +		write 0 to disable 10-Bit Tag Requester when the driver does
> +		not bind the device. The typical use case is for p2pdma when
> +		the peer device does not support 10-Bit Tag Completer.
> +
> +		Write 10 to enable 10-Bit Tag Requester when RC supports 10-Bit
> +		Tag Completer capability. The typical use case is for host
> +		memory targeted by DMA Requests.

1) I think I would rename this from "tags" to "tag_bits".  A file
   named "tags" that contains 8 suggests that we can use 8 tags, but
   in fact, we can use 256 tags.

2) This controls tag size the requester will use.  The current knobs
   in the hardware allow 5, 8, or 10 bits.

   "0" to disable 10-bit tags without specifying whether we should use
   5- or 8-bit tags doesn't seem right.  All completers are *supposed*
   to support 8-bit, but we've tripped over a few that don't.

   I don't think we currently have a run-time (or even a boot-time)
   way to disable 8-bit tags; all we have is the quirk_no_ext_tags()
   quirk.  But if we ever wanted to *add* that, maybe we would want:

      5 - use 5-bit tags
      8 - use 8-bit tags
     10 - use 10-bit tags

   Maybe we just say "0" is invalid, since there's no obvious way to
   map this?

> +static ssize_t tags_show(struct device *dev,
> +			 struct device_attribute *attr,
> +			 char *buf)
> +{
> + ...

> +	if (ctl & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN)
> +		return sysfs_emit(buf, "%s\n", "10-Bit");
> +
> +	ret = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
> +	if (ret)
> +		return -EINVAL;
> +
> +	if (ctl & PCI_EXP_DEVCTL_EXT_TAG)
> +		return sysfs_emit(buf, "%s\n", "8-Bit");
> +
> +	return sysfs_emit(buf, "%s\n", "5-Bit");

Since I prefer the "tag_bits" name, my preference would be bare
numbers here: "10", "8", "5".

Both comments apply to the sriov files, too.

> +static umode_t pcie_dev_tags_attrs_is_visible(struct kobject *kobj,
> +					      struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (pdev->is_virtfn)
> +		return 0;
> +
> +	if (pci_pcie_type(pdev) != PCI_EXP_TYPE_ENDPOINT)
> +		return 0;
> +
> +	if (!(pdev->devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
> +		return 0;

Makes sense for now that the file is only visible if a requester
supports 10-bit tags.  If we ever wanted to extend this to control 5-
vs 8-bit tags, we could make it visible in more cases then.

> +
> +	return a->mode;
> +}

> @@ -2075,6 +2089,12 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>  		return 0;
>  	}
>  
> +	/*
> +	 * PCIe r5.0, sec 2.2.6.2 says "Receivers/Completers must handle 8-bit
> +	 * Tag values correctly regardless of the setting of their Extended Tag
> +	 * Field Enable bit (see Section 7.5.3.4)", so it is safe to enable
> +	 * Extented Tags.

s/Extented/Extended/

> +	 */
>  	if (!(ctl & PCI_EXP_DEVCTL_EXT_TAG)) {
>  		pci_info(dev, "enabling Extended Tags\n");
>  		pcie_capability_set_word(dev, PCI_EXP_DEVCTL,
> -- 
> 2.22.0
> 
