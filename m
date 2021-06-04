Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD33539C224
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFDVQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhFDVQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABDC4613EC;
        Fri,  4 Jun 2021 21:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622841289;
        bh=Z+jNg1MHlfZNsox8xVn89P0HmI8FFZrxLQHj9wuDIJE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=aEPEQkjAUU+kW4KQXDyxNA81kumxZbVShD1sHjVs3amHQ6KlUxkbvZ2jtIkPh8N2s
         sxz69LdS8bFF7aoO9jn1Y5w9oqyB4fm4t4K5vaRnVFuZRWTqKpoB68dPGzDRJiaI5X
         tkoJNy8VASPliaGMOnMVcJ5NxcTB8nGomW4F66L9XoxGyfvBFVpnqVmVBbGzP8ScgY
         eUXO5nUfcHz/9/CqGV1FcfyCwdfBI70IyXptNP3T74aaHRY+T5UZ0wLn8KkMC8GUbh
         FmeiCX0M8hH0htqW+Zze3XSjCV3Wngndq5ZkliDovvJcVno23ljFC4F/x/VLAd9HD0
         tPw5coxi08qgg==
Date:   Fri, 4 Jun 2021 16:14:47 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
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
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [RFC PATCH 3/3] mwifiex: pcie: add reset_wsid quirk for Surface 3
Message-ID: <20210604211447.GA2240001@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210522131827.67551-4-verdre@v0yd.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 22, 2021 at 03:18:27PM +0200, Jonas Dreﬂler wrote:
> From: Tsuchiya Yuto <kitakar@gmail.com>
> 
> This commit adds reset_wsid quirk and uses this quirk for Surface 3 on
> card reset.
> 
> To reset mwifiex on Surface 3, it seems that calling the _DSM method
> exists in \_SB.WSID [1] device is required.
> 
> On Surface 3, calling the _DSM method removes/re-probes the card by
> itself. So, need to place the reset function before performing FLR and
> skip performing any other reset-related works.

Maybe this is a nit-pick, but I understand "probing" to be something
the OS does, namely what we normally call "enumeration," i.e.,
discovering a device.

So it sounds like the _DSM causes a logical hot-removal of the card,
which the PCI hotplug driver should notice and it should remove the
driver and remove the pci_dev.

And the _DSM also causes a hot-add (reading the code below, it looks
like this is actually a second _DSM), which the PCI hotplug driver
should also notice and enumerate the bus (i.e., it reads config space
looking for a device).  This all would cause a new pci_dev to be
allocated, resources assigned for its BARs, and the driver .probe()
method to be called again?

That seems like a lot, so maybe I didn't understand what's actually
happening.

> Note that Surface Pro 3 also has the WSID device [2], but it seems to need
> more work. This commit only supports Surface 3 yet.
> 
> [1] https://github.com/linux-surface/acpidumps/blob/05cba925f3a515f222acb5b3551a032ddde958fe/surface_3/dsdt.dsl#L11947-L12011
> [2] https://github.com/linux-surface/acpidumps/blob/05cba925f3a515f222acb5b3551a032ddde958fe/surface_pro_3/dsdt.dsl#L12164-L12216
> 
> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
> Signed-off-by: Jonas Dreﬂler <verdre@v0yd.nl>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c   | 10 ++
>  .../wireless/marvell/mwifiex/pcie_quirks.c    | 91 +++++++++++++++++++
>  .../wireless/marvell/mwifiex/pcie_quirks.h    |  6 ++
>  3 files changed, 107 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index d9acfea395ad..6e049236ae1a 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2969,6 +2969,16 @@ static void mwifiex_pcie_card_reset_work(struct mwifiex_adapter *adapter)
>  {
>  	struct pcie_service_card *card = adapter->card;
>  
> +	/* On Surface 3, reset_wsid method removes then re-probes card by
> +	 * itself. So, need to place it here and skip performing any other
> +	 * reset-related works.
> +	 */
> +	if (card->quirks & QUIRK_FW_RST_WSID_S3) {
> +		mwifiex_pcie_reset_wsid_quirk(card->dev);
> +		/* skip performing any other reset-related works */
> +		return;
> +	}
> +
>  	/* We can't afford to wait here; remove() might be waiting on us. If we
>  	 * can't grab the device lock, maybe we'll get another chance later.
>  	 */
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> index b5f214fc1212..f0a6fa0a7ae5 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
> @@ -9,10 +9,21 @@
>   * down, or causes NULL ptr deref).
>   */
>  
> +#include <linux/acpi.h>
>  #include <linux/dmi.h>
>  
>  #include "pcie_quirks.h"
>  
> +/* For reset_wsid quirk */
> +#define ACPI_WSID_PATH		"\\_SB.WSID"
> +#define WSID_REV		0x0
> +#define WSID_FUNC_WIFI_PWR_OFF	0x1
> +#define WSID_FUNC_WIFI_PWR_ON	0x2
> +/* WSID _DSM UUID: "534ea3bf-fcc2-4e7a-908f-a13978f0c7ef" */
> +static const guid_t wsid_dsm_guid =
> +	GUID_INIT(0x534ea3bf, 0xfcc2, 0x4e7a,
> +		  0x90, 0x8f, 0xa1, 0x39, 0x78, 0xf0, 0xc7, 0xef);
> +
>  /* quirk table based on DMI matching */
>  static const struct dmi_system_id mwifiex_quirk_table[] = {
>  	{
> @@ -81,6 +92,22 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>  		},
>  		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>  	},
> +	{
> +		.ident = "Surface 3",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface 3"),
> +		},
> +		.driver_data = (void *)QUIRK_FW_RST_WSID_S3,
> +	},
> +	{
> +		.ident = "Surface Pro 3",
> +		.matches = {
> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 3"),
> +		},
> +		.driver_data = 0,
> +	},
>  	{}
>  };
>  
> @@ -97,6 +124,9 @@ void mwifiex_initialize_quirks(struct pcie_service_card *card)
>  		dev_info(&pdev->dev, "no quirks enabled\n");
>  	if (card->quirks & QUIRK_FW_RST_D3COLD)
>  		dev_info(&pdev->dev, "quirk reset_d3cold enabled\n");
> +	if (card->quirks & QUIRK_FW_RST_WSID_S3)
> +		dev_info(&pdev->dev,
> +			 "quirk reset_wsid for Surface 3 enabled\n");
>  }
>  
>  static void mwifiex_pcie_set_power_d3cold(struct pci_dev *pdev)
> @@ -153,3 +183,64 @@ int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev)
>  
>  	return 0;
>  }
> +
> +int mwifiex_pcie_reset_wsid_quirk(struct pci_dev *pdev)
> +{
> +	acpi_handle handle;
> +	union acpi_object *obj;
> +	acpi_status status;
> +
> +	dev_info(&pdev->dev, "Using reset_wsid quirk to perform FW reset\n");
> +
> +	status = acpi_get_handle(NULL, ACPI_WSID_PATH, &handle);
> +	if (ACPI_FAILURE(status)) {
> +		dev_err(&pdev->dev, "No ACPI handle for path %s\n",
> +			ACPI_WSID_PATH);
> +		return -ENODEV;
> +	}
> +
> +	if (!acpi_has_method(handle, "_DSM")) {
> +		dev_err(&pdev->dev, "_DSM method not found\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!acpi_check_dsm(handle, &wsid_dsm_guid,
> +			    WSID_REV, WSID_FUNC_WIFI_PWR_OFF)) {
> +		dev_err(&pdev->dev,
> +			"_DSM method doesn't support wifi power off func\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!acpi_check_dsm(handle, &wsid_dsm_guid,
> +			    WSID_REV, WSID_FUNC_WIFI_PWR_ON)) {
> +		dev_err(&pdev->dev,
> +			"_DSM method doesn't support wifi power on func\n");
> +		return -ENODEV;
> +	}
> +
> +	/* card will be removed immediately after this call on Surface 3 */
> +	dev_info(&pdev->dev, "turning wifi off...\n");
> +	obj = acpi_evaluate_dsm(handle, &wsid_dsm_guid,
> +				WSID_REV, WSID_FUNC_WIFI_PWR_OFF,
> +				NULL);
> +	if (!obj) {
> +		dev_err(&pdev->dev,
> +			"device _DSM execution failed for turning wifi off\n");
> +		return -EIO;
> +	}
> +	ACPI_FREE(obj);
> +
> +	/* card will be re-probed immediately after this call on Surface 3 */
> +	dev_info(&pdev->dev, "turning wifi on...\n");
> +	obj = acpi_evaluate_dsm(handle, &wsid_dsm_guid,
> +				WSID_REV, WSID_FUNC_WIFI_PWR_ON,
> +				NULL);
> +	if (!obj) {
> +		dev_err(&pdev->dev,
> +			"device _DSM execution failed for turning wifi on\n");
> +		return -EIO;
> +	}
> +	ACPI_FREE(obj);
> +
> +	return 0;
> +}
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> index 549093067813..d90ada3f2daa 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
> @@ -7,5 +7,11 @@
>  
>  #define QUIRK_FW_RST_D3COLD	BIT(0)
>  
> +/* Surface 3 and Surface Pro 3 have the same _DSM method but need to
> + * be handled differently. Currently, only S3 is supported.
> + */
> +#define QUIRK_FW_RST_WSID_S3	BIT(1)
> +
>  void mwifiex_initialize_quirks(struct pcie_service_card *card);
>  int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev);
> +int mwifiex_pcie_reset_wsid_quirk(struct pci_dev *pdev);
> -- 
> 2.31.1
> 
