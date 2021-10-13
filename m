Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD89B42C8A7
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 20:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhJMS3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 14:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhJMS3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 14:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52D6D60C49;
        Wed, 13 Oct 2021 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634149629;
        bh=0KaxqBpPYtBpR05jXKW1Op9xgdPeY4wuR3VX8HO8Yug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=FIxQNrdc60xMqLc8svzrhC1Ia2JmTjEC2KvqlXNDX1MD77r2c9NY0a2ASgaCstVxW
         maCg0Pa6KUPMJktX9Kekr5KQuKzXG4dNAKjPgcbUhJf1FEj+RbPqlnqLhmEyOTVChk
         Fl4wUi2sF2/ncJgl4CQiSCy5aDZXsLudht4eFwTYeHXbqU5lW2LReRjsmNG+o663n6
         0ZwJDI+J4aGH7XraGw+8ZD/TYGfJbQAJSWAiWSW9pZ4ev1e7wknnhoMbPa4YVtIbHL
         +hQdIK4jnr+9yIMUdoiJ3T9BgVrnoLfPadWDnK1114lmJND8FpvLLkZkbP4YlaUY7Q
         JcEnlPhWOMRzw==
Date:   Wed, 13 Oct 2021 13:27:07 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, bhelgaas@google.com, jgg@nvidia.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 04/13] PCI/IOV: Allow SRIOV VF drivers to
 reach the drvdata of a PF
Message-ID: <20211013182707.GA1906754@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013094707.163054-5-yishaih@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 12:46:58PM +0300, Yishai Hadas wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> There are some cases where a SRIOV VF driver will need to reach into and
> interact with the PF driver. This requires accessing the drvdata of the PF.
> 
> Provide a function pci_iov_get_pf_drvdata() to return this PF drvdata in a
> safe way. Normally accessing a drvdata of a foreign struct device would be
> done using the device_lock() to protect against device driver
> probe()/remove() races.
> 
> However, due to the design of pci_enable_sriov() this will result in a
> ABBA deadlock on the device_lock as the PF's device_lock is held during PF
> sriov_configure() while calling pci_enable_sriov() which in turn holds the
> VF's device_lock while calling VF probe(), and similarly for remove.
> 
> This means the VF driver can never obtain the PF's device_lock.
> 
> Instead use the implicit locking created by pci_enable/disable_sriov(). A
> VF driver can access its PF drvdata only while its own driver is attached,
> and the PF driver can control access to its own drvdata based on when it
> calls pci_enable/disable_sriov().
> 
> To use this API the PF driver will setup the PF drvdata in the probe()
> function. pci_enable_sriov() is only called from sriov_configure() which
> cannot happen until probe() completes, ensuring no VF races with drvdata
> setup.
> 
> For removal, the PF driver must call pci_disable_sriov() in its remove
> function before destroying any of the drvdata. This ensures that all VF
> drivers are unbound before returning, fencing concurrent access to the
> drvdata.
> 
> The introduction of a new function to do this access makes clear the
> special locking scheme and the documents the requirements on the PF/VF
> drivers using this.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Nit: s/SRIOV/SR-IOV/ above so it matches usage in the spec.

I think it's nice to include the actual interface in the subject when
practical.

> ---
>  drivers/pci/iov.c   | 29 +++++++++++++++++++++++++++++
>  include/linux/pci.h |  7 +++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index e7751fa3fe0b..ca696730f761 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -47,6 +47,35 @@ int pci_iov_vf_id(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_iov_vf_id);
>  
> +/**
> + * pci_iov_get_pf_drvdata - Return the drvdata of a PF
> + * @dev - VF pci_dev
> + * @pf_driver - Device driver required to own the PF
> + *
> + * This must be called from a context that ensures that a VF driver is attached.
> + * The value returned is invalid once the VF driver completes its remove()
> + * callback.
> + *
> + * Locking is achieved by the driver core. A VF driver cannot be probed until
> + * pci_enable_sriov() is called and pci_disable_sriov() does not return until
> + * all VF drivers have completed their remove().
> + *
> + * The PF driver must call pci_disable_sriov() before it begins to destroy the
> + * drvdata.
> + */
> +void *pci_iov_get_pf_drvdata(struct pci_dev *dev, struct pci_driver *pf_driver)
> +{
> +	struct pci_dev *pf_dev;
> +
> +	if (dev->is_physfn)
> +		return ERR_PTR(-EINVAL);
> +	pf_dev = dev->physfn;
> +	if (pf_dev->driver != pf_driver)
> +		return ERR_PTR(-EINVAL);
> +	return pci_get_drvdata(pf_dev);
> +}
> +EXPORT_SYMBOL_GPL(pci_iov_get_pf_drvdata);
> +
>  /*
>   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
>   * change when NumVFs changes.
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2337512e67f0..639a0a239774 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -2154,6 +2154,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
>  int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
>  int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
>  int pci_iov_vf_id(struct pci_dev *dev);
> +void *pci_iov_get_pf_drvdata(struct pci_dev *dev, struct pci_driver *pf_driver);
>  int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
>  void pci_disable_sriov(struct pci_dev *dev);
>  
> @@ -2187,6 +2188,12 @@ static inline int pci_iov_vf_id(struct pci_dev *dev)
>  	return -ENOSYS;
>  }
>  
> +static inline void *pci_iov_get_pf_drvdata(struct pci_dev *dev,
> +					   struct pci_driver *pf_driver)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +
>  static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
>  { return -ENODEV; }
>  
> -- 
> 2.18.1
> 
