Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EF716F0B2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 21:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgBYU52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 15:57:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgBYU52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 15:57:28 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ACF22176D;
        Tue, 25 Feb 2020 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582664247;
        bh=Rypr7ZcCh3/KMa7zUtTWHxN5tpwd6oUsx8Lx4vdqwMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=saTPPq1IDMzPUuwqxy3ZuO7f+3vh/70NVZ0l1VhP3hk7OqaweW93ZLKtzBrT18SjH
         10l061LcAZN51AIZTBJ6w9HmtBuH4sTJDFIkV/1Bn0DyWQHP9+QrwNae+mdvAqGZoL
         Fu6UaLjJ2+1p1nAM411ujb0LsepAurPQ6kmQm+k8=
Date:   Tue, 25 Feb 2020 14:57:25 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 2/8] PCI: add pci_status_get_and_clear_errors
Message-ID: <20200225205725.GA197467@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45054c7d-cc48-2be0-11fa-4c3ffce8fdd7@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 03:04:23PM +0100, Heiner Kallweit wrote:
> Few drivers use the following code sequence:

This reads like "Not very many drivers".  I think "Several drivers"
would capture the sense of this better.

> 1. Read PCI_STATUS
> 2. Mask out non-error bits
> 3. Action based on error bits set
> 4. Write back set error bits to clear them
> 
> As this is a repeated pattern, add a helper to the PCI core.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/pci/pci.c   | 23 +++++++++++++++++++++++
>  include/linux/pci.h |  1 +
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index d828ca835..c16b0ba2a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -173,6 +173,29 @@ unsigned char pci_bus_max_busnr(struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL_GPL(pci_bus_max_busnr);
>  
> +/**
> + * pci_status_get_and_clear_errors - return and clear error bits in PCI_STATUS
> + * @pdev: the PCI device
> + *
> + * Returns error bits set in PCI_STATUS and clears them.
> + */
> +int pci_status_get_and_clear_errors(struct pci_dev *pdev)
> +{
> +	u16 status;
> +	int ret;
> +
> +	ret = pci_read_config_word(pdev, PCI_STATUS, &status);
> +	if (ret != PCIBIOS_SUCCESSFUL)
> +		return -EIO;
> +
> +	status &= PCI_STATUS_ERROR_BITS;
> +	if (status)
> +		pci_write_config_word(pdev, PCI_STATUS, status);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(pci_status_get_and_clear_errors);
> +
>  #ifdef CONFIG_HAS_IOMEM
>  void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 3840a541a..7a75aae04 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1203,6 +1203,7 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags);
>  bool pci_device_is_present(struct pci_dev *pdev);
>  void pci_ignore_hotplug(struct pci_dev *dev);
>  struct pci_dev *pci_real_dma_dev(struct pci_dev *dev);
> +int pci_status_get_and_clear_errors(struct pci_dev *pdev);
>  
>  int __printf(6, 7) pci_request_irq(struct pci_dev *dev, unsigned int nr,
>  		irq_handler_t handler, irq_handler_t thread_fn, void *dev_id,
> -- 
> 2.25.1
> 
> 
> 
> 
