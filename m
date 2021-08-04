Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35473E0AC7
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhHDXRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhHDXRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 19:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA52B61029;
        Wed,  4 Aug 2021 23:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628119051;
        bh=LB/yWwNyZPNern/LMAfi3Q2yQX76M51Zx+XEZVhnae8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=EKJq8oPfu3fKGmj6h/YUHkspfkI8cW8KKMtkE8AMSrBiM7SrQ3IlqFY8gBprdsKEw
         e9K4jQjRXDSQ2EeWLceqX6ogolzZldyVn7afLljP4rSxY61IMB9aL4gr2waOSSok9i
         IzGPOGEjpOWxzOhbCa43SnikCpXaDUIsaxIDcjJdmlVhs+pul3fc7JZmt1untR120O
         l1Kv4C/t40Q3MPkA3g/ljwWl8eHZ3frdiAPkRjQq6wVM5nwTEdqkdrbyJ543VB8fVT
         fa6GhvOdtp09nHMCBFtfDWsMWQVR71cWbXZZKsE+4xi7Z90aT0ubcohtpvGREn4kO4
         AwQO/ZVz0xstA==
Date:   Wed, 4 Aug 2021 18:17:29 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 4/9] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 devices
Message-ID: <20210804231729.GA1679826@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628084828-119542-5-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 09:47:03PM +0800, Dongdong Liu wrote:
> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
> field size from 8 bits to 10 bits.
> 
> PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
> 10-Bit Tag Capabilities" Implementation Note.
> For platforms where the RC supports 10-Bit Tag Completer capability,
> it is highly recommended for platform firmware or operating software
> that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
> bit automatically in Endpoints with 10-Bit Tag Requester capability. This
> enables the important class of 10-Bit Tag capable adapters that send
> Memory Read Requests only to host memory.

Quoted material should be set off with a blank line before it and
indented by two spaces so it's clear exactly what comes from the spec
and what you've added.  For example, see
https://git.kernel.org/linus/ec411e02b7a2

We need to say why we assume it's safe to enable 10-bit tags for all
devices below a Root Port that supports them.  I think this has to do
with switches being required to forward 10-bit tags correctly even if
they were designed before 10-bit tags were added to the spec.

And it should call out any cases where it is *not* safe, e.g., if P2P
traffic is an issue.

If there are cases where we don't want to enable 10-bit tags, whether
it's to enable P2P traffic or merely to work around device defects,
that ability needs to be here from the beginning.  If somebody needs
to bisect with 10-bit tags disabled, we don't want a bisection hole
between this commit and the commit that adds the control.

> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/pci/probe.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/pci.h |  2 ++
>  2 files changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index c83245b..3da7baa 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -2029,10 +2029,42 @@ static void pci_configure_mps(struct pci_dev *dev)
>  		 p_mps, mps, mpss);
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

Is it meaningful to set dev->ext_10bit_tag when "dev" is a VF?  I
suspect only if the VF could be a switch.  Is that possible?  If not,
I think the dev->is_virtfn check could be done first.

> +
> +	/*
> +	 * 10-Bit Tag Requester Enable in Device Control 2 Register is RsvdP
> +	 * for VF.

(Per 9.3.5.10)

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
>  int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>  {
>  	struct pci_host_bridge *host;
> -	u16 ctl;
> +	u16 ctl, ctl2;
>  	int ret;
>  
>  	if (!pci_is_pcie(dev))
> @@ -2045,6 +2077,10 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>  	if (ret)
>  		return 0;
>  
> +	ret = pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &ctl2);
> +	if (ret)
> +		return 0;
> +
>  	host = pci_find_host_bridge(dev->bus);
>  	if (!host)
>  		return 0;
> @@ -2059,6 +2095,12 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>  			pcie_capability_clear_word(dev, PCI_EXP_DEVCTL,
>  						   PCI_EXP_DEVCTL_EXT_TAG);
>  		}
> +
> +		if (ctl2 & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN) {
> +			pci_info(dev, "disabling 10-Bit Tags\n");
> +			pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
> +					PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +		}
>  		return 0;
>  	}
>  
> @@ -2067,6 +2109,9 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>  		pcie_capability_set_word(dev, PCI_EXP_DEVCTL,
>  					 PCI_EXP_DEVCTL_EXT_TAG);
>  	}
> +
> +	pci_configure_10bit_tags(dev);
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9aab67f..af6cb53 100644
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
