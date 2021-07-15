Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516A93CA3E7
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhGOR0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhGOR0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 13:26:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBE3613C3;
        Thu, 15 Jul 2021 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626369818;
        bh=OGUJau3scHdd64RSx5cFSqUwQcJpiG2djIeuei8VZG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=OdPNYAcFfgbsuPxqoZtCZvpLrCWmmtm+h5G/QUcmG0WayfrHgisLKB6+a3IohCqN9
         kQc7+VLwXw7leCgLPAi8tZlm1GM0OROs7iRU7SaIJVOlhMlwjBTFDDtUMYnvyQOy29
         raqTKd266KLvoDMSb/t2A/iuIXEZk7WZqZ8HmdFyi6gWHUz5Ne3PhyK3x5YgoHsLj/
         RvnZBWQDX9FspIEqy8YdwLUtynF4je2ZjCiPTEdTTAcNOvG0GZiKhukBJoUnLMjSY1
         zWIao0UUb3EMU5VarklADbrjKbVdxu4xnL378DY3Kf9uqchs0dk/ki8TA79hjDU31t
         iXqapcLUNqFsQ==
Date:   Thu, 15 Jul 2021 12:23:36 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, linux-pci@vger.kernel.org,
        rajur@chelsio.com, hverkuil-cisco@xs4all.nl,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH V5 4/6] PCI: Enable 10-Bit tag support for PCIe Endpoint
 devices
Message-ID: <20210715172336.GA1972959@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624271242-111890-5-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Logan]

On Mon, Jun 21, 2021 at 06:27:20PM +0800, Dongdong Liu wrote:
> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
> field size from 8 bits to 10 bits.
> 
> For platforms where the RC supports 10-Bit Tag Completer capability,
> it is highly recommended for platform firmware or operating software

Recommended by whom?  If the spec recommends it, we should provide the
citation.

> that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
> bit automatically in Endpoints with 10-Bit Tag Requester capability. This
> enables the important class of 10-Bit Tag capable adapters that send
> Memory Read Requests only to host memory.

What is the implication for P2PDMA?  What happens if we enable 10-bit
tags for device A, and A generates Mem Read Requests to device B,
which does not support 10-bit tags?

> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/pci/probe.c | 33 +++++++++++++++++++++++++++++++++
>  include/linux/pci.h |  2 ++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 0208865..33241fb 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -2048,6 +2048,38 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>  	return 0;
>  }
>  
> +static void pci_configure_10bit_tags(struct pci_dev *dev)
> +{
> +	struct pci_dev *bridge;
> +
> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP))
> +		return;
> +
> +	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT) {
> +		dev->ext_10bit_tag = 1;
> +		return;
> +	}
> +
> +	bridge = pci_upstream_bridge(dev);
> +	if (bridge && bridge->ext_10bit_tag)
> +		dev->ext_10bit_tag = 1;
> +
> +	/*
> +	 * 10-Bit Tag Requester Enable in Device Control 2 Register is RsvdP
> +	 * for VF.
> +	 */
> +	if (dev->is_virtfn)
> +		return;
> +
> +	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ENDPOINT &&
> +	    dev->ext_10bit_tag == 1 &&
> +	    (dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ)) {
> +		pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
> +		pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
> +					PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +	}
> +}
> +
>  /**
>   * pcie_relaxed_ordering_enabled - Probe for PCIe relaxed ordering enable
>   * @dev: PCI device to query
> @@ -2184,6 +2216,7 @@ static void pci_configure_device(struct pci_dev *dev)
>  {
>  	pci_configure_mps(dev);
>  	pci_configure_extended_tags(dev, NULL);
> +	pci_configure_10bit_tags(dev);

I think 10-bit tag support should be integrated with extended (8-bit)
tag support instead of having two separate functions.

If we have "no_ext_tags" set because some device doesn't support 8-bit
tags correctly, we probably shouldn't try to enable 10-bit tags
either.

>  	pci_configure_relaxed_ordering(dev);
>  	pci_configure_ltr(dev);
>  	pci_configure_eetlp_prefix(dev);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index de1fc24..445d102 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -393,6 +393,8 @@ struct pci_dev {
>  #endif
>  	unsigned int	eetlp_prefix_path:1;	/* End-to-End TLP Prefix */
>  
> +	unsigned int	ext_10bit_tag:1; /* 10-Bit Tag Completer Supported
> +					    from root to here */
>  	pci_channel_state_t error_state;	/* Current connectivity state */
>  	struct device	dev;			/* Generic device interface */
>  
> -- 
> 2.7.4
> 
