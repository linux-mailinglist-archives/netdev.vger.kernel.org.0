Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830154C2FF
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfFSVcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfFSVcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 17:32:42 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF30F208CB;
        Wed, 19 Jun 2019 21:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560979961;
        bh=CDPA4HtuI28sp/o5jhSfPYklJ8LJ3Tdxzzv6K+fuFJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w9n5drERN5CmY9LmSEE4xtZ+wc2vv/xUBUixBx/eJq5MfwudUWR8RjTeHD1ql9Kkh
         FR6ejrN47TjQfMC3szeb+mdZJ+6+e96gmgAHMbfhwBEZU/pt+ItXKaTDftz2sni849
         hjTODNvj1Bn6YYr4U7tHFpC5WavZeePVlBbZdovc=
Date:   Wed, 19 Jun 2019 16:32:39 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] PCI: let pci_disable_link_state propagate
 errors
Message-ID: <20190619213238.GD143205@google.com>
References: <5ea56278-05e2-794f-5f66-23343e72164c@gmail.com>
 <604f2954-c60c-d2aa-3849-9a2f8872001c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604f2954-c60c-d2aa-3849-9a2f8872001c@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 11:13:48PM +0200, Heiner Kallweit wrote:
> Drivers may rely on pci_disable_link_state() having disabled certain
> ASPM link states. If OS can't control ASPM then pci_disable_link_state()
> turns into a no-op w/o informing the caller. The driver therefore may
> falsely assume the respective ASPM link states are disabled.
> Let pci_disable_link_state() propagate errors to the caller, enabling
> the caller to react accordingly.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks, I think this makes good sense.

> ---
>  drivers/pci/pcie/aspm.c  | 20 +++++++++++---------
>  include/linux/pci-aspm.h |  7 ++++---
>  2 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index fd4cb7508..e44af7f4d 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -1062,18 +1062,18 @@ void pcie_aspm_powersave_config_link(struct pci_dev *pdev)
>  	up_read(&pci_bus_sem);
>  }
>  
> -static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
> +static int __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
>  {
>  	struct pci_dev *parent = pdev->bus->self;
>  	struct pcie_link_state *link;
>  
>  	if (!pci_is_pcie(pdev))
> -		return;
> +		return 0;
>  
>  	if (pdev->has_secondary_link)
>  		parent = pdev;
>  	if (!parent || !parent->link_state)
> -		return;
> +		return -EINVAL;
>  
>  	/*
>  	 * A driver requested that ASPM be disabled on this device, but
> @@ -1085,7 +1085,7 @@ static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
>  	 */
>  	if (aspm_disabled) {
>  		pci_warn(pdev, "can't disable ASPM; OS doesn't have ASPM control\n");
> -		return;
> +		return -EPERM;
>  	}
>  
>  	if (sem)
> @@ -1105,11 +1105,13 @@ static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
>  	mutex_unlock(&aspm_lock);
>  	if (sem)
>  		up_read(&pci_bus_sem);
> +
> +	return 0;
>  }
>  
> -void pci_disable_link_state_locked(struct pci_dev *pdev, int state)
> +int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
>  {
> -	__pci_disable_link_state(pdev, state, false);
> +	return __pci_disable_link_state(pdev, state, false);
>  }
>  EXPORT_SYMBOL(pci_disable_link_state_locked);
>  
> @@ -1117,14 +1119,14 @@ EXPORT_SYMBOL(pci_disable_link_state_locked);
>   * pci_disable_link_state - Disable device's link state, so the link will
>   * never enter specific states.  Note that if the BIOS didn't grant ASPM
>   * control to the OS, this does nothing because we can't touch the LNKCTL
> - * register.
> + * register. Returns 0 or a negative errno.
>   *
>   * @pdev: PCI device
>   * @state: ASPM link state to disable
>   */
> -void pci_disable_link_state(struct pci_dev *pdev, int state)
> +int pci_disable_link_state(struct pci_dev *pdev, int state)
>  {
> -	__pci_disable_link_state(pdev, state, true);
> +	return __pci_disable_link_state(pdev, state, true);
>  }
>  EXPORT_SYMBOL(pci_disable_link_state);
>  
> diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
> index df28af5ce..67064145d 100644
> --- a/include/linux/pci-aspm.h
> +++ b/include/linux/pci-aspm.h
> @@ -24,11 +24,12 @@
>  #define PCIE_LINK_STATE_CLKPM	4
>  
>  #ifdef CONFIG_PCIEASPM
> -void pci_disable_link_state(struct pci_dev *pdev, int state);
> -void pci_disable_link_state_locked(struct pci_dev *pdev, int state);
> +int pci_disable_link_state(struct pci_dev *pdev, int state);
> +int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
>  void pcie_no_aspm(void);
>  #else
> -static inline void pci_disable_link_state(struct pci_dev *pdev, int state) { }
> +static inline int pci_disable_link_state(struct pci_dev *pdev, int state)
> +{ return 0; }
>  static inline void pcie_no_aspm(void) { }
>  #endif
>  
> -- 
> 2.22.0
> 
> 
