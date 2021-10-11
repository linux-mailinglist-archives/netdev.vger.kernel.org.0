Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743A2429519
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhJKREV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232954AbhJKREU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 13:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3F79606A5;
        Mon, 11 Oct 2021 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633971740;
        bh=+sw5vVvYzB9olZ/QfKHrBKLtJpmBFQ+mzziJlwpYm24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HaZY28og8tI1/NuWbqAd1wxI/WmDvzz3qE12WZHII4SuxckNVP4s/8G9c/90KGEz2
         MCbdEHemGkjr5yaZESU/9LGdQfZusr602hfmFM170uwJMvkhS5l3kilUuNMLDPLFj2
         1z1QYP+ubJwTpGleScPwPOI3MU6uO+mULW5BdKQSMVNzYYdknkfhJd0MctezGgG0XA
         bA/Cf3Bcu6q+DuZS9S/OqceSmpL0XTCeqAr/FiNv58wmpuJN897IeKrIJR4zQliIbE
         8WHQKzLp+sFNFhMsbNcJ1CNF9DELxl4t0NWnqZZQcSt2KV9Gp3cpMj+tSV/d+WRSWK
         lHxf2+dd3zztQ==
Received: by pali.im (Postfix)
        id A78F17C9; Mon, 11 Oct 2021 19:02:15 +0200 (CEST)
Date:   Mon, 11 Oct 2021 19:02:15 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS
 Surface devices
Message-ID: <20211011170215.3bnmi6sa5yqux2r7@pali>
References: <20211011134238.16551-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211011134238.16551-1-verdre@v0yd.nl>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 11 October 2021 15:42:38 Jonas Dreßler wrote:
> The most recent firmware (15.68.19.p21) of the 88W8897 PCIe+USB card
> reports a hardcoded LTR value to the system during initialization,
> probably as an (unsuccessful) attempt of the developers to fix firmware
> crashes. This LTR value prevents most of the Microsoft Surface devices
> from entering deep powersaving states (either platform C-State 10 or
> S0ix state), because the exit latency of that state would be higher than
> what the card can tolerate.

This description looks like a generic issue in 88W8897 chip or its
firmware and not something to Surface PCIe controller or Surface HW. But
please correct me if I'm wrong here.

Has somebody 88W8897-based PCIe card in non-Surface device and can check
or verify if this issue happens also outside of the Surface device?

It would be really nice to know if this is issue in Surface or in 8897.

> Turns out the card works just the same (including the firmware crashes)
> no matter if that hardcoded LTR value is reported or not, so it's kind
> of useless and only prevents us from saving power.
> 
> To get rid of those hardcoded LTR requirements, it's possible to reset
> the PCI bridge device after initializing the cards firmware. I'm not
> exactly sure why that works, maybe the power management subsystem of the
> PCH resets its stored LTR values when doing a function level reset of
> the bridge device. Doing the reset once after starting the wifi firmware
> works very well, probably because the firmware only reports that LTR
> value a single time during firmware startup.
> 
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c   | 12 +++++++++
>  .../wireless/marvell/mwifiex/pcie_quirks.c    | 26 +++++++++++++------
>  .../wireless/marvell/mwifiex/pcie_quirks.h    |  1 +
>  3 files changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index c6ccce426b49..2506e7e49f0c 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -1748,9 +1748,21 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
>  static int mwifiex_pcie_init_fw_port(struct mwifiex_adapter *adapter)
>  {
>  	struct pcie_service_card *card = adapter->card;
> +	struct pci_dev *pdev = card->dev;
> +	struct pci_dev *parent_pdev = pci_upstream_bridge(pdev);
>  	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
>  	int tx_wrap = card->txbd_wrptr & reg->tx_wrap_mask;
>  
> +	/* Trigger a function level reset of the PCI bridge device, this makes
> +	 * the firmware (latest version 15.68.19.p21) of the 88W8897 PCIe+USB
> +	 * card stop reporting a fixed LTR value that prevents the system from
> +	 * entering package C10 and S0ix powersaving states.
> +	 * We need to do it here because it must happen after firmware
> +	 * initialization and this function is called right after that is done.
> +	 */
> +	if (card->quirks & QUIRK_DO_FLR_ON_BRIDGE)
> +		pci_reset_function(parent_pdev);
> +
>  	/* Write the RX ring read pointer in to reg->rx_rdptr */
>  	if (mwifiex_write_reg(adapter, reg->rx_rdptr, card->rxbd_rdptr |
>  			      tx_wrap)) {
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> index 0234cf3c2974..cbf0565353ae 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> @@ -27,7 +27,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 4"),
>  		},
> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
> +					QUIRK_DO_FLR_ON_BRIDGE),
>  	},
>  	{
>  		.ident = "Surface Pro 5",
> @@ -36,7 +37,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>  			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1796"),
>  		},
> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
> +					QUIRK_DO_FLR_ON_BRIDGE),
>  	},
>  	{
>  		.ident = "Surface Pro 5 (LTE)",
> @@ -45,7 +47,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>  			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1807"),
>  		},
> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
> +					QUIRK_DO_FLR_ON_BRIDGE),
>  	},
>  	{
>  		.ident = "Surface Pro 6",
> @@ -53,7 +56,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 6"),
>  		},
> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
> +					QUIRK_DO_FLR_ON_BRIDGE),
>  	},
>  	{
>  		.ident = "Surface Book 1",
> @@ -61,7 +65,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book"),
>  		},
> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
> +					QUIRK_DO_FLR_ON_BRIDGE),
>  	},
>  	{
>  		.ident = "Surface Book 2",
> @@ -69,7 +74,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book 2"),
>  		},
> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
> +					QUIRK_DO_FLR_ON_BRIDGE),
>  	},
>  	{
>  		.ident = "Surface Laptop 1",
> @@ -77,7 +83,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop"),
>  		},
> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
> +					QUIRK_DO_FLR_ON_BRIDGE),
>  	},
>  	{
>  		.ident = "Surface Laptop 2",
> @@ -85,7 +92,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop 2"),
>  		},
> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
> +					QUIRK_DO_FLR_ON_BRIDGE),
>  	},
>  	{}
>  };
> @@ -103,6 +111,8 @@ void mwifiex_initialize_quirks(struct pcie_service_card *card)
>  		dev_info(&pdev->dev, "no quirks enabled\n");
>  	if (card->quirks & QUIRK_FW_RST_D3COLD)
>  		dev_info(&pdev->dev, "quirk reset_d3cold enabled\n");
> +	if (card->quirks & QUIRK_DO_FLR_ON_BRIDGE)
> +		dev_info(&pdev->dev, "quirk do_flr_on_bridge enabled\n");
>  }
>  
>  static void mwifiex_pcie_set_power_d3cold(struct pci_dev *pdev)
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> index 8ec4176d698f..f8d463f4269a 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> @@ -18,6 +18,7 @@
>  #include "pcie.h"
>  
>  #define QUIRK_FW_RST_D3COLD	BIT(0)
> +#define QUIRK_DO_FLR_ON_BRIDGE	BIT(1)
>  
>  void mwifiex_initialize_quirks(struct pcie_service_card *card);
>  int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev);
> -- 
> 2.31.1
> 
