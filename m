Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6049E3E0AEC
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhHDXjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233775AbhHDXjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 19:39:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AE9E61037;
        Wed,  4 Aug 2021 23:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628120332;
        bh=h/WL88N/qB73Qu9R4aafhExy3Rm8W7zuv5+DwEs6Q6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=aawEBKA984kKtwMG0dlt1H+VrEfyO1QfSF/BstIe7KJfDVvu1++EWRhk/LrqJQyQy
         bcRjkKeQsVUxPqyH9taGZAd7N7YHO0uxPqpuwlN1yzc12Xirt7syIYddkmUI2m+E+C
         yMB8BWkQIKdAYwTqo8hkoDIHZbQTTZZzAFo8CR7M8NwD8EkENg4796D7e/X+DzjhUz
         TZYpRL2uUl9YmugtVrVpgai0bd23iLqcUetARle6jPiP8POWa7V11kAIdbisjHu7WL
         k0BWMgXF/crVZpJ4+MnQ5l6p80n+PCDlE942x2wfKYsikhg1LqT6RzOiQw5eqbeV2t
         x6Wwdz6BHLpEQ==
Date:   Wed, 4 Aug 2021 18:38:50 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 6/9] PCI: Enable 10-Bit Tag support for PCIe RP devices
Message-ID: <20210804233850.GA1691988@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628084828-119542-7-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 09:47:05PM +0800, Dongdong Liu wrote:
> PCIe spec 5.0r1.0 section 2.2.6.2 implementation note, In configurations
> where a Requester with 10-Bit Tag Requester capability needs to target
> multiple Completers, one needs to ensure that the Requester sends 10-Bit
> Tag Requests only to Completers that have 10-Bit Tag Completer capability.
> So we enable 10-Bit Tag Requester for root port only when the devices
> under the root port support 10-Bit Tag Completer.

Fix quoting.  I can't tell what is from the spec and what you wrote.

> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  drivers/pci/pcie/portdrv_pci.c | 69 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index c7ff1ee..2382cd2 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -90,6 +90,72 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>  #define PCIE_PORTDRV_PM_OPS	NULL
>  #endif /* !PM */
>  
> +static int pci_10bit_tag_comp_support(struct pci_dev *dev, void *data)
> +{
> +	bool *support = (bool *)data;
> +
> +	if (!pci_is_pcie(dev)) {
> +		*support = false;
> +		return 1;
> +	}
> +
> +	/*
> +	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
> +	 * For configurations where a Requester with 10-Bit Tag Requester
> +	 * capability targets Completers where some do and some do not have
> +	 * 10-Bit Tag Completer capability, how the Requester determines which
> +	 * NPRs include 10-Bit Tags is outside the scope of this specification.
> +	 * So we do not consider hotplug scenario.
> +	 */
> +	if (dev->is_hotplug_bridge) {
> +		*support = false;
> +		return 1;
> +	}
> +
> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP)) {
> +		*support = false;
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void pci_configure_rp_10bit_tag(struct pci_dev *dev)
> +{
> +	bool support = true;
> +
> +	if (dev->subordinate == NULL)
> +		return;
> +
> +	/* If no devices under the root port, no need to enable 10-Bit Tag. */
> +	if (list_empty(&dev->subordinate->devices))
> +		return;
> +
> +	pci_10bit_tag_comp_support(dev, &support);
> +	if (!support)
> +		return;
> +
> +	/*
> +	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
> +	 * In configurations where a Requester with 10-Bit Tag Requester
> +	 * capability needs to target multiple Completers, one needs to ensure
> +	 * that the Requester sends 10-Bit Tag Requests only to Completers
> +	 * that have 10-Bit Tag Completer capability. So we enable 10-Bit Tag
> +	 * Requester for root port only when the devices under the root port
> +	 * support 10-Bit Tag Completer.
> +	 */
> +	pci_walk_bus(dev->subordinate, pci_10bit_tag_comp_support, &support);
> +	if (!support)
> +		return;
> +
> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
> +		return;
> +
> +	pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
> +	pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
> +				 PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +}
> +
>  /*
>   * pcie_portdrv_probe - Probe PCI-Express port devices
>   * @dev: PCI-Express port device being probed
> @@ -111,6 +177,9 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
>  	     (type != PCI_EXP_TYPE_RC_EC)))
>  		return -ENODEV;
>  
> +	if (type == PCI_EXP_TYPE_ROOT_PORT)
> +		pci_configure_rp_10bit_tag(dev);

I don't think this has anything to do with the portdrv, so all this
should go somewhere else.

Out of curiosity, IIUC this enables 10-bit tags for MMIO transactions
from the root port toward the device, i.e., traffic that originates
from a CPU.  Is that a significant benefit?  I would expect high-speed
devices would primarily operate via DMA with relatively little MMIO
traffic.

>  	if (type == PCI_EXP_TYPE_RC_EC)
>  		pcie_link_rcec(dev);
>  
> -- 
> 2.7.4
> 
