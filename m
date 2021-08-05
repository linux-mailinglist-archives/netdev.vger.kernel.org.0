Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785FD3E180E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 17:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242046AbhHEPbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 11:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238390AbhHEPbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 11:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3138060F35;
        Thu,  5 Aug 2021 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628177497;
        bh=U6aKIz0g06u4wCe/q6bsAhRSJ5oHrtqJe+reCcGUy14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=k6uyNpMzgdLgc/vVL5x+KZZQ5XStYUwqo13M2XdNMByP64SC3vdGLSDKDQD87j+9u
         uvFFs4OGg4fNE8g2YavD90klD4okcS604fbh7WNBuiP4PIJNOPWKCjToeSZLqh0Sbb
         TAY5vKM414V9CdN3szxHrpK0oVzZ7Irnk/btY4KmiUlTm0bpx0A4i61FZKn7PP/W37
         4ULpfj3C5GcjEhIcqSDaX9784uAQU8MU9GNSh+e0ugC2XjWDi8s26V6gGAkyJ+s4j4
         RH85NBRt9vhf3MG8beeXCbEAVFkvPZ+HDORIotGj3geKKcLhB9kopO4Rxa6CsRpyOR
         p49CQCyOiJiwA==
Date:   Thu, 5 Aug 2021 10:31:35 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 7/9] PCI/sysfs: Add a 10-Bit Tag sysfs file
Message-ID: <20210805153135.GA1757362@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f300d75c-5fb8-54ae-0c84-3916b1dda360@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 04:37:39PM +0800, Dongdong Liu wrote:
> 
> 
> On 2021/8/5 7:49, Bjorn Helgaas wrote:
> > On Wed, Aug 04, 2021 at 09:47:06PM +0800, Dongdong Liu wrote:
> > > PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
> > > sending Requests to other Endpoints (as opposed to host memory), the
> > > Endpoint must not send 10-Bit Tag Requests to another given Endpoint
> > > unless an implementation-specific mechanism determines that the Endpoint
> > > supports 10-Bit Tag Completer capability. Add a 10bit_tag sysfs file,
> > > write 0 to disable 10-Bit Tag Requester when the driver does not bind
> > > the device if the peer device does not support the 10-Bit Tag Completer.
> > > This will make P2P traffic safe. the 10bit_tag file content indicate
> > > current 10-Bit Tag Requester Enable status.
> > > 
> > > Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-bus-pci | 16 +++++++-
> > >  drivers/pci/pci-sysfs.c                 | 69 +++++++++++++++++++++++++++++++++
> > >  2 files changed, 84 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > index 793cbb7..0e0c97d 100644
> > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > @@ -139,7 +139,7 @@ Description:
> > >  		binary file containing the Vital Product Data for the
> > >  		device.  It should follow the VPD format defined in
> > >  		PCI Specification 2.1 or 2.2, but users should consider
> > > -		that some devices may have incorrectly formatted data.
> > > +		that some devices may have incorrectly formatted data.
> > >  		If the underlying VPD has a writable section then the
> > >  		corresponding section of this file will be writable.
> > > 
> > > @@ -407,3 +407,17 @@ Description:
> > > 
> > >  		The file is writable if the PF is bound to a driver that
> > >  		implements ->sriov_set_msix_vec_count().
> > > +
> > > +What:		/sys/bus/pci/devices/.../10bit_tag
> > > +Date:		August 2021
> > > +Contact:	Dongdong Liu <liudongdong3@huawei.com>
> > > +Description:
> > > +		If a PCI device support 10-Bit Tag Requester, will create the
> > > +		10bit_tag sysfs file. The file is readable, the value
> > > +		indicate current 10-Bit Tag Requester Enable.
> > > +		1 - enabled, 0 - disabled.
> > > +
> > > +		The file is also writeable, the value only accept by write 0
> > > +		to disable 10-Bit Tag Requester when the driver does not bind
> > > +		the deivce. The typical use case is for p2pdma when the peer
> > > +		device does not support 10-BIT Tag Completer.

> > > +static ssize_t pci_10bit_tag_store(struct device *dev,
> > > +				   struct device_attribute *attr,
> > > +				   const char *buf, size_t count)
> > > +{
> > > +	struct pci_dev *pdev = to_pci_dev(dev);
> > > +	bool enable;
> > > +
> > > +	if (kstrtobool(buf, &enable) < 0)
> > > +		return -EINVAL;
> > > +
> > > +	if (enable != false )
> > > +		return -EINVAL;
> > 
> > Is this the same as "if (enable)"?
> Yes, Will fix.

I actually don't like the one-way nature of this.  When the hierarchy
supports 10-bit tags, we automatically enable them during enumeration.

Then we provide this sysfs file, but it can only *disable* 10-bit
tags.  There's no way to re-enable them except by rebooting (or using
setpci, I guess).

Why can't we allow *enabling* them here if they're supported in this
hierarchy?

> > > +	if (pdev->driver)
> > > +		 return -EBUSY;
> > > +
> > > +	pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL2,
> > > +				   PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> > > +	pci_info(pdev, "disabled 10-Bit Tag Requester\n");
> > > +
> > > +	return count;
> > > +}
