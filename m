Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6003C26E7
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhGIPgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhGIPgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:36:44 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD3AC0613DD;
        Fri,  9 Jul 2021 08:34:00 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4GLxys6W0HzQjlj;
        Fri,  9 Jul 2021 17:33:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id 0FudsvOO8jHb; Fri,  9 Jul 2021 17:33:53 +0200 (CEST)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709145831.6123-1-verdre@v0yd.nl>
 <20210709145831.6123-3-verdre@v0yd.nl> <20210709151800.7b2qqezlcicbgrqn@pali>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <b1002254-97c6-d271-c385-4a5c9fe0c914@mailbox.org>
Date:   Fri, 9 Jul 2021 17:33:34 +0200
MIME-Version: 1.0
In-Reply-To: <20210709151800.7b2qqezlcicbgrqn@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.77 / 15.00 / 15.00
X-Rspamd-Queue-Id: F2B5C1893
X-Rspamd-UID: 2d6149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/21 5:18 PM, Pali Rohár wrote:
> On Friday 09 July 2021 16:58:31 Jonas Dreßler wrote:
>> From: Tsuchiya Yuto <kitakar@gmail.com>
>>
>> To reset mwifiex on Surface gen4+ (Pro 4 or later gen) devices, it
>> seems that putting the wifi device into D3cold is required according
>> to errata.inf file on Windows installation (Windows/INF/errata.inf).
>>
>> This patch adds a function that performs power-cycle (put into D3cold
>> then D0) and call the function at the end of reset_prepare().
>>
>> Note: Need to also reset the parent device (bridge) of wifi on SB1;
>> it might be because the bridge of wifi always reports it's in D3hot.
>> When I tried to reset only the wifi device (not touching parent), it gave
>> the following error and the reset failed:
>>
>>      acpi device:4b: Cannot transition to power state D0 for parent in D3hot
>>      mwifiex_pcie 0000:03:00.0: can't change power state from D3cold to D0 (config space inaccessible)
>>
>> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
>> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
>> ---
>>   drivers/net/wireless/marvell/mwifiex/pcie.c   |   7 +
>>   .../wireless/marvell/mwifiex/pcie_quirks.c    | 123 ++++++++++++++++++
>>   .../wireless/marvell/mwifiex/pcie_quirks.h    |   3 +
>>   3 files changed, 133 insertions(+)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> index a530832c9421..c6ccce426b49 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> @@ -528,6 +528,13 @@ static void mwifiex_pcie_reset_prepare(struct pci_dev *pdev)
>>   	mwifiex_shutdown_sw(adapter);
>>   	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
>>   	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
>> +
>> +	/* On MS Surface gen4+ devices FLR isn't effective to recover from
>> +	 * hangups, so we power-cycle the card instead.
>> +	 */
>> +	if (card->quirks & QUIRK_FW_RST_D3COLD)
>> +		mwifiex_pcie_reset_d3cold_quirk(pdev);
>> +
> 
> Hello! Now I'm thinking loudly about this patch. Why this kind of reset
> is needed only for Surface devices? AFAIK these 88W8897 chips are same
> in all cards. Chip itself implements PCIe interface (and also SDIO) so
> for me looks very strange if this 88W8897 PCIe device needs DMI specific
> quirks. I cannot believe that Microsoft got some special version of
> these chips from Marvell which are different than version uses on cards
> in mPCIe form factor.
> 
> And now when I'm reading comment below about PCIe bridge to which is
> this 88W8897 PCIe chip connected, is not this rather an issue in that
> PCIe bridge (instead of mwifiex/88W8897) or in ACPI firmware which
> controls this bridge?
> 
> Or are having other people same issues on mPCIe form factor wifi cards
> with 88W8897 chips and then this quirk should not DMI dependent?
> 
> Note that I'm seeing issues with reset and other things also on chip
> 88W8997 when is connected to system via SDIO. These chips have both PCIe
> and SDIO buses, it just depends which pins are used.
> 

Hi and thanks for the quick reply! Honestly I've no idea, this is just 
the first method we found that allows for a proper reset of the chip. 
What I know is that some Surface devices need that ACPI DSM call (the 
one that was done in the commit I dropped in this version of the 
patchset) to reset the chip instead of this method.

Afaik other devices with this chip don't need this resetting method, at 
least Marvell employees couldn't reproduce the issues on their testing 
devices.

So would you suggest we just try to match for the pci chip 88W8897 
instead? Then we'd probably have to check if there are any laptops where 
multiple devices are connected to the pci bridge as Amey suggested in a 
review before.

>>   	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
>>   
>>   	card->pci_reset_ongoing = true;
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>> index 4064f99b36ba..b5f214fc1212 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>> @@ -15,6 +15,72 @@
>>   
>>   /* quirk table based on DMI matching */
>>   static const struct dmi_system_id mwifiex_quirk_table[] = {
>> +	{
>> +		.ident = "Surface Pro 4",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 4"),
>> +		},
>> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +	},
>> +	{
>> +		.ident = "Surface Pro 5",
>> +		.matches = {
>> +			/* match for SKU here due to generic product name "Surface Pro" */
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1796"),
>> +		},
>> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +	},
>> +	{
>> +		.ident = "Surface Pro 5 (LTE)",
>> +		.matches = {
>> +			/* match for SKU here due to generic product name "Surface Pro" */
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1807"),
>> +		},
>> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +	},
>> +	{
>> +		.ident = "Surface Pro 6",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 6"),
>> +		},
>> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +	},
>> +	{
>> +		.ident = "Surface Book 1",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book"),
>> +		},
>> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +	},
>> +	{
>> +		.ident = "Surface Book 2",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book 2"),
>> +		},
>> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +	},
>> +	{
>> +		.ident = "Surface Laptop 1",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop"),
>> +		},
>> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +	},
>> +	{
>> +		.ident = "Surface Laptop 2",
>> +		.matches = {
>> +			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop 2"),
>> +		},
>> +		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +	},
>>   	{}
>>   };
>>   
>> @@ -29,4 +95,61 @@ void mwifiex_initialize_quirks(struct pcie_service_card *card)
>>   
>>   	if (!card->quirks)
>>   		dev_info(&pdev->dev, "no quirks enabled\n");
>> +	if (card->quirks & QUIRK_FW_RST_D3COLD)
>> +		dev_info(&pdev->dev, "quirk reset_d3cold enabled\n");
>> +}
>> +
>> +static void mwifiex_pcie_set_power_d3cold(struct pci_dev *pdev)
>> +{
>> +	dev_info(&pdev->dev, "putting into D3cold...\n");
>> +
>> +	pci_save_state(pdev);
>> +	if (pci_is_enabled(pdev))
>> +		pci_disable_device(pdev);
>> +	pci_set_power_state(pdev, PCI_D3cold);
>> +}
>> +
>> +static int mwifiex_pcie_set_power_d0(struct pci_dev *pdev)
>> +{
>> +	int ret;
>> +
>> +	dev_info(&pdev->dev, "putting into D0...\n");
>> +
>> +	pci_set_power_state(pdev, PCI_D0);
>> +	ret = pci_enable_device(pdev);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "pci_enable_device failed\n");
>> +		return ret;
>> +	}
>> +	pci_restore_state(pdev);
>> +
>> +	return 0;
>> +}
>> +
>> +int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev)
>> +{
>> +	struct pci_dev *parent_pdev = pci_upstream_bridge(pdev);
>> +	int ret;
>> +
>> +	/* Power-cycle (put into D3cold then D0) */
>> +	dev_info(&pdev->dev, "Using reset_d3cold quirk to perform FW reset\n");
>> +
>> +	/* We need to perform power-cycle also for bridge of wifi because
>> +	 * on some devices (e.g. Surface Book 1), the OS for some reasons
>> +	 * can't know the real power state of the bridge.
>> +	 * When tried to power-cycle only wifi, the reset failed with the
>> +	 * following dmesg log:
>> +	 * "Cannot transition to power state D0 for parent in D3hot".
>> +	 */
>> +	mwifiex_pcie_set_power_d3cold(pdev);
>> +	mwifiex_pcie_set_power_d3cold(parent_pdev);
>> +
>> +	ret = mwifiex_pcie_set_power_d0(parent_pdev);
>> +	if (ret)
>> +		return ret;
>> +	ret = mwifiex_pcie_set_power_d0(pdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>>   }
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>> index 7a1fe3b3a61a..549093067813 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>> @@ -5,4 +5,7 @@
>>   
>>   #include "pcie.h"
>>   
>> +#define QUIRK_FW_RST_D3COLD	BIT(0)
>> +
>>   void mwifiex_initialize_quirks(struct pcie_service_card *card);
>> +int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev);
>> -- 
>> 2.31.1
>>

