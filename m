Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F04320A58
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 14:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhBUNB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 08:01:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhBUNBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 08:01:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77D8E64EEC;
        Sun, 21 Feb 2021 13:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613912444;
        bh=SvCSMNwWOjD1RuFrrE7KudoLB/8aoqxbB8zypDJjoCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bi9ddrkqP48OS4okEi3xYoWSm2RFfvovUOX9ntPK+Neer2x3Oy1skfCCqZgnJ3UFt
         GvI7TQdNBuGSb8nC6sOmqpuP8KWcf42bdCPCJsEc+/QODqDWJSukxvG4a9XDjGaolq
         Yew1KGyShZA361oAW1HK4NnCpSqav+oXN36aFNhw=
Date:   Sun, 21 Feb 2021 14:00:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <YDJZeWoLna8kQk5L@kroah.com>
References: <YC90wkwk/CdgcYY6@kroah.com>
 <20210220190600.GA1260870@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220190600.GA1260870@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 01:06:00PM -0600, Bjorn Helgaas wrote:
> On Fri, Feb 19, 2021 at 09:20:18AM +0100, Greg Kroah-Hartman wrote:
> 
> > Ok, can you step back and try to explain what problem you are trying to
> > solve first, before getting bogged down in odd details?  I find it
> > highly unlikely that this is something "unique", but I could be wrong as
> > I do not understand what you are wanting to do here at all.
> 
> We want to add two new sysfs files:
> 
>   sriov_vf_total_msix, for PF devices
>   sriov_vf_msix_count, for VF devices associated with the PF
> 
> AFAICT it is *acceptable* if they are both present always.  But it
> would be *ideal* if they were only present when a driver that
> implements the ->sriov_get_vf_total_msix() callback is bound to the
> PF.

Ok, so in the pci bus probe function, if the driver that successfully
binds to the device is of this type, then create the sysfs files.

The driver core will properly emit a KOBJ_BIND message when the driver
is bound to the device, so userspace knows it is now safe to rescan the
device to see any new attributes.

Here's some horrible pseudo-patch for where this probably should be
done:


diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index ec44a79e951a..5a854a5e3977 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -307,8 +307,14 @@ static long local_pci_probe(void *_ddi)
 	pm_runtime_get_sync(dev);
 	pci_dev->driver = pci_drv;
 	rc = pci_drv->probe(pci_dev, ddi->id);
-	if (!rc)
+	if (!rc) {
+		/* If PF or FV driver was bound, let's add some more sysfs files */
+		if (pci_drv->is_pf)
+			device_add_groups(pci_dev->dev, pf_groups);
+		if (pci_drv->is_fv)
+			device_add_groups(pci_dev->dev, fv_groups);
 		return rc;
+	}
 	if (rc < 0) {
 		pci_dev->driver = NULL;
 		pm_runtime_put_sync(dev);




Add some proper error handling if device_add_groups() fails, and then do
the same thing to remove the sysfs files when the device is unbound from
the driver, and you should be good to go.

Or is this what you all are talking about already and I'm just totally
confused?

thanks,

greg k-h
