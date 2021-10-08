Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB16C42738E
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 00:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243606AbhJHWUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 18:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231830AbhJHWUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 18:20:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCA7261027;
        Fri,  8 Oct 2021 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633731498;
        bh=jbRxgF7cUld4xploZ4pjD2AkK79eJfqFv2yuwOnEhxY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VI129sKT6e4HYgkh4aTVCvrjT0JsKWR0oWaVLtya44Ynsb/XNexLFmVwsGN6fqw2l
         lsvVVy1h2ineRftiTn03HR2lVb5vgEt5P2ElKRuj0PU8l4r+gc30NDpoYFWW3/PDUm
         X6WRxiSOP60vqB1QCcTShpvmxd5vvnAZ8wQkgvP36vWWVMzYLExXAmVzTgk4nNV2O6
         rVL4gTlYcbKTKJMUMK+eG5805GgkWItMQVxuzoZ4tKbkjOwtTKC3CHHlInPAxb775n
         FtS07O1lA930h8ZUQQEvbVIWM6wQi4bKRX17JoOrdorVt9UIVXgEZY+tdViCewxbZh
         9+0e8Pzsw8N4Q==
Date:   Fri, 8 Oct 2021 17:18:16 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com,
        davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Vidya Sagar <vidyas@nvidia.com>
Subject: Re: [RFC] [PATCH net-next v5 1/3] PCI/ASPM: Introduce a new helper
 to report ASPM capability
Message-ID: <20211008221816.GA1384615@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007161552.272771-2-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 12:15:50AM +0800, Kai-Heng Feng wrote:
> Introduce a new helper, pcie_aspm_capable(), to report ASPM capability.
> 
> The user will be introduced by next patch.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Change subject to:

  PCI/ASPM: Add pcie_aspm_capable()

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
> v6:
> v5:
>  - No change.
> 
> v4:
>  - Report aspm_capable instead.
> 
> v3:
>  - This is a new patch
> 
>  drivers/pci/pcie/aspm.c | 11 +++++++++++
>  include/linux/pci.h     |  2 ++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 013a47f587cea..788e7496f33b1 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -1201,6 +1201,17 @@ bool pcie_aspm_enabled(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL_GPL(pcie_aspm_enabled);
>  
> +bool pcie_aspm_capable(struct pci_dev *pdev)
> +{
> +	struct pcie_link_state *link = pcie_aspm_get_link(pdev);
> +
> +	if (!link)
> +		return false;
> +
> +	return link->aspm_capable;
> +}
> +EXPORT_SYMBOL_GPL(pcie_aspm_capable);
> +
>  static ssize_t aspm_attr_show_common(struct device *dev,
>  				     struct device_attribute *attr,
>  				     char *buf, u8 state)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index cd8aa6fce2041..a17baa39141f4 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1639,6 +1639,7 @@ int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
>  void pcie_no_aspm(void);
>  bool pcie_aspm_support_enabled(void);
>  bool pcie_aspm_enabled(struct pci_dev *pdev);
> +bool pcie_aspm_capable(struct pci_dev *pdev);
>  #else
>  static inline int pci_disable_link_state(struct pci_dev *pdev, int state)
>  { return 0; }
> @@ -1647,6 +1648,7 @@ static inline int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
>  static inline void pcie_no_aspm(void) { }
>  static inline bool pcie_aspm_support_enabled(void) { return false; }
>  static inline bool pcie_aspm_enabled(struct pci_dev *pdev) { return false; }
> +static inline bool pcie_aspm_capable(struct pci_dev *pdev) { return false; }
>  #endif
>  
>  #ifdef CONFIG_PCIEAER
> -- 
> 2.32.0
> 
