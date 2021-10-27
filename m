Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8871F43D4CE
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 23:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhJ0VYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 17:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232208AbhJ0VXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 17:23:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D111610CA;
        Wed, 27 Oct 2021 21:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635369649;
        bh=XAKQElgr6BBu1UxLggaDKytR7eU4feqnPzmw0g25Rh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=p0b4YLUwvJPjelhXK6tuNGSLxPc8W57wzTHLdwcnMUmPB94v3hsvXslXLq1TZ7GY3
         sL93c85du1ZkOYvv6Pe8m//9lhA+RCJvKPQ3Uxy4IpiUrRzmmHS2TjXc+bDuZhbHC1
         l+E73WotWsbVG9NLfon08np6Kd/XgVf0Jxca7lyT4yX6vB73LFYEef0IfwG2arUu8/
         99lPcmeJ/rIFzzRSmhPjxtiZo5dpdJB8a4yC6OHadP/Fj4Qj6F80bnWXW+gPhJdbdy
         kbLLEj07eEaOlMSzDYq1FQHtoTNtzXOYOJc/bLD1mWl8TMf9oIuR/1QaiRsDmFW7pE
         HwI4EGZ6WMvrg==
Date:   Wed, 27 Oct 2021 16:20:48 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V10 6/8] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
Message-ID: <20211027212048.GA252528@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211009104938.48225-7-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 06:49:36PM +0800, Dongdong Liu wrote:
> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
> 10-Bit Tag Requester doesn't interact with a device that does not
> support 10-Bit Tag Completer. 

Shouldn't this also take into account Extended Tags (8 bits)?  I think
the only tag size guaranteed to be supported is 5 bits.

> Before that happens, the kernel should emit a warning.

The warning is nice, but the critical thing is that the P2PDMA mapping
should fail so we don't attempt DMA in this situation.  I guess that's
sort of what you're saying with "ensure that a device ... doesn't
interact with a device ..."

> "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to disable 10-Bit Tag
> Requester for PF device.
> 
> "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
> 10-Bit Tag Requester for VF device.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/pci/p2pdma.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 50cdde3e9a8b..804e390f4c22 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -19,6 +19,7 @@
>  #include <linux/random.h>
>  #include <linux/seq_buf.h>
>  #include <linux/xarray.h>
> +#include "pci.h"
>  
>  enum pci_p2pdma_map_type {
>  	PCI_P2PDMA_MAP_UNKNOWN = 0,
> @@ -410,6 +411,50 @@ static unsigned long map_types_idx(struct pci_dev *client)
>  		(client->bus->number << 8) | client->devfn;
>  }
>  
> +static bool pci_10bit_tags_unsupported(struct pci_dev *a,
> +				       struct pci_dev *b,
> +				       bool verbose)
> +{
> +	bool req;
> +	bool comp;
> +	u16 ctl;
> +	const char *str = "10bit_tag";
> +
> +	if (a->is_virtfn) {
> +#ifdef CONFIG_PCI_IOV
> +		req = !!(a->physfn->sriov->ctrl &
> +			 PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN);
> +#endif
> +	} else {
> +		pcie_capability_read_word(a, PCI_EXP_DEVCTL2, &ctl);
> +		req = !!(ctl & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +	}
> +
> +	comp = !!(b->devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP);
> +	/* 10-bit tags not enabled on requester */
> +	if (!req)
> +		return false;
> +
> +	 /* Completer can handle anything */
> +	if (comp)
> +		return false;
> +
> +	if (!verbose)
> +		return true;
> +
> +	pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set for this device, but peer device (%s) does not support the 10-Bit Tag Completer\n",
> +		 pci_name(b));
> +
> +	if (a->is_virtfn)
> +		str = "sriov_vf_10bit_tag_ctl";
> +
> +	pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/%s\n",
> +		 pci_name(a), str);
> +
> +	return true;
> +}
> +
>  /*
>   * Calculate the P2PDMA mapping type and distance between two PCI devices.
>   *
> @@ -532,6 +577,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>  	}
>  done:
> +	if (pci_10bit_tags_unsupported(client, provider, verbose))
> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +
>  	rcu_read_lock();
>  	p2pdma = rcu_dereference(provider->p2pdma);
>  	if (p2pdma)
> -- 
> 2.22.0
> 
