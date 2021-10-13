Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DDD42C872
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 20:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbhJMSQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 14:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhJMSQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 14:16:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F213461130;
        Wed, 13 Oct 2021 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634148869;
        bh=nTv0tRFqu3rs6zCgIelWjkmGWCCAcB61amgKTV3GfC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=HOLLh68Gs9vf4Npd6whvsjzKAoFHcVugXPxOcgeVyO732h8qgr+DSmkWwj+upu833
         2GS1m+i3/ZzqrPhLaWml/+vF7n4KSFWN7vivN6sdzeb0R7CadkUZ/Ls3KBzcBGT5FE
         P7YEPTmdFlVm63NKRClCMh5xlUNzrMBS02v7nNZDB7ERffjEdsNKgaAEPUO8Q5RMw+
         Q90N9x92/Wc6rpIpp+FgplmzxhrMnDmgoHQbayy2BQmnwtfaLhSv87bXfLFElBPwig
         813KDACHpaI04Vunmw4nRcp+/W7Zu4Q0CNL9GOJ6NC7pG8jXfTf2a9hQT0hPVBZPHK
         DH76xPmHZ9lRQ==
Date:   Wed, 13 Oct 2021 13:14:26 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, bhelgaas@google.com, jgg@nvidia.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 01/13] PCI/IOV: Provide internal VF index
Message-ID: <20211013181426.GA1906116@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013094707.163054-2-yishaih@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 12:46:55PM +0300, Yishai Hadas wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> The PCI core uses the VF index internally, often called the vf_id,
> during the setup of the VF, eg pci_iov_add_virtfn().
> 
> This index is needed for device drivers that implement live migration
> for their internal operations that configure/control their VFs.
> 
> Specifically, mlx5_vfio_pci driver that is introduced in coming patches
> from this series needs it and not the bus/device/function which is
> exposed today.
> 
> Add pci_iov_vf_id() which computes the vf_id by reversing the math that
> was used to create the bus/device/function.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

I already acked this:

  https://lore.kernel.org/r/20210922215930.GA231505@bhelgaas

Saves me time if you carry the ack so I don't have to look at this
again.  But since I *am* looking at it again, I think it's nice if the
subject line includes the actual interface you're adding, e.g.,

  PCI/IOV: Add pci_iov_vf_id() to get VF index

> ---
>  drivers/pci/iov.c   | 14 ++++++++++++++
>  include/linux/pci.h |  8 +++++++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index dafdc652fcd0..e7751fa3fe0b 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -33,6 +33,20 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
>  }
>  EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);
>  
> +int pci_iov_vf_id(struct pci_dev *dev)
> +{
> +	struct pci_dev *pf;
> +
> +	if (!dev->is_virtfn)
> +		return -EINVAL;
> +
> +	pf = pci_physfn(dev);
> +	return (((dev->bus->number << 8) + dev->devfn) -
> +		((pf->bus->number << 8) + pf->devfn + pf->sriov->offset)) /
> +	       pf->sriov->stride;
> +}
> +EXPORT_SYMBOL_GPL(pci_iov_vf_id);
> +
>  /*
>   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
>   * change when NumVFs changes.
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index cd8aa6fce204..2337512e67f0 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -2153,7 +2153,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
>  #ifdef CONFIG_PCI_IOV
>  int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
>  int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
> -
> +int pci_iov_vf_id(struct pci_dev *dev);
>  int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
>  void pci_disable_sriov(struct pci_dev *dev);
>  
> @@ -2181,6 +2181,12 @@ static inline int pci_iov_virtfn_devfn(struct pci_dev *dev, int id)
>  {
>  	return -ENOSYS;
>  }
> +
> +static inline int pci_iov_vf_id(struct pci_dev *dev)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
>  { return -ENODEV; }
>  
> -- 
> 2.18.1
> 
