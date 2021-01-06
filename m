Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809732EC3DA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbhAFTXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:23:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbhAFTXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 14:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1201C2311B;
        Wed,  6 Jan 2021 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609960955;
        bh=RXHsLQtWdosGRs1gseCy3y7sgHRpinIQi/zgMsifvFU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Vl2LOzH8x0qYlMyLbJ0l++GdU/D8nW3gLhL03xYpjX0RewIERSygJpcK+X2Z+JLQK
         oJnxuQnQxWrp8irH1HISVj/tlZDS6obZ1KGLwN1mB2LyLGAODFI1OxV8t1dtI7E9N8
         z/04+t6tTqqiNfriq6OtRs3hWydrCyXGlZnPrwz8tu8eFEUDD+jYoHRCs3/EmFE99g
         DH8PnI2XNL9f0pNj9ifWlqYpVOdONJXcrK75zs97JPowp9ChR7Julndq+7sbvIykFK
         S/zpTvjK/bB3rxZ2D9nUkNmBKA/AetCPyKSNGtmkFpYL3pAL3wY6/iO6ESWkxDeOnS
         bHAvP0pUtjiKA==
Date:   Wed, 6 Jan 2021 13:22:33 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] PCI: Disable parity checking if broken_parity is
 set
Message-ID: <20210106192233.GA1329080@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d375987c-ea4f-dd98-4ef8-99b2fbfe7c33@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 06:50:22PM +0100, Heiner Kallweit wrote:
> If we know that a device has broken parity checking, then disable it.
> This avoids quirks like in r8169 where on the first parity error
> interrupt parity checking will be disabled if broken_parity_status
> is set. Make pci_quirk_broken_parity() public so that it can be used
> by platform code, e.g. for Thecus N2100.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

This series should all go together.  Let me know if you want me to do
anything more (would require acks for arm and r8169, of course).

> ---
>  drivers/pci/quirks.c | 17 +++++++++++------
>  include/linux/pci.h  |  2 ++
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 653660e3b..ab54e26b8 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -205,17 +205,22 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>  				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
>  
> +void pci_quirk_broken_parity(struct pci_dev *dev)
> +{
> +	u16 cmd;
> +
> +	dev->broken_parity_status = 1;	/* This device gives false positives */
> +	pci_read_config_word(dev, PCI_COMMAND, &cmd);
> +	pci_write_config_word(dev, PCI_COMMAND, cmd & ~PCI_COMMAND_PARITY);
> +}
> +
>  /*
>   * The Mellanox Tavor device gives false positive parity errors.  Mark this
>   * device with a broken_parity_status to allow PCI scanning code to "skip"
>   * this now blacklisted device.
>   */
> -static void quirk_mellanox_tavor(struct pci_dev *dev)
> -{
> -	dev->broken_parity_status = 1;	/* This device gives false positives */
> -}
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, quirk_mellanox_tavor);
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, quirk_mellanox_tavor);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, pci_quirk_broken_parity);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, pci_quirk_broken_parity);
>  
>  /*
>   * Deal with broken BIOSes that neglect to enable passive release,
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index b32126d26..161dcc474 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1916,6 +1916,8 @@ enum pci_fixup_pass {
>  	pci_fixup_suspend_late,	/* pci_device_suspend_late() */
>  };
>  
> +void pci_quirk_broken_parity(struct pci_dev *dev);
> +
>  #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
>  #define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
>  				    class_shift, hook)			\
> -- 
> 2.30.0
> 
> 
> 
