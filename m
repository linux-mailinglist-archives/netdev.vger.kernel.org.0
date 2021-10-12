Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A531B42A065
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhJLI5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhJLI5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 04:57:13 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C78C061570;
        Tue, 12 Oct 2021 01:55:11 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:105:465:1:3:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HT8cs6zClzQkBS;
        Tue, 12 Oct 2021 10:55:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <c62bcb73-778d-1958-6c14-d5bdcca85812@v0yd.nl>
Date:   Tue, 12 Oct 2021 10:55:03 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS Surface
 devices
Content-Language: en-US
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
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
References: <20211011134238.16551-1-verdre@v0yd.nl>
 <20211011170215.3bnmi6sa5yqux2r7@pali>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <20211011170215.3bnmi6sa5yqux2r7@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0E4C26E
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/21 19:02, Pali Rohár wrote:
> On Monday 11 October 2021 15:42:38 Jonas Dreßler wrote:
>> The most recent firmware (15.68.19.p21) of the 88W8897 PCIe+USB card
>> reports a hardcoded LTR value to the system during initialization,
>> probably as an (unsuccessful) attempt of the developers to fix firmware
>> crashes. This LTR value prevents most of the Microsoft Surface devices
>> from entering deep powersaving states (either platform C-State 10 or
>> S0ix state), because the exit latency of that state would be higher than
>> what the card can tolerate.
> 
> This description looks like a generic issue in 88W8897 chip or its
> firmware and not something to Surface PCIe controller or Surface HW. But
> please correct me if I'm wrong here.
> 
> Has somebody 88W8897-based PCIe card in non-Surface device and can check
> or verify if this issue happens also outside of the Surface device?
> 
> It would be really nice to know if this is issue in Surface or in 8897.
> 

Fairly sure the LTR value is something that's reported by the firmware
and will be the same on all 8897 devices (as mentioned in my reply to Bjorn
the second-latest firmware doesn't report that fixed LTR value).

The thing is I'm not sure if this hack works fine on non-Surface devices
or maybe breaks things there (I guess the change had some effect on Marvells
test platform at least), so this is simply the minimum risk approach.

>> Turns out the card works just the same (including the firmware crashes)
>> no matter if that hardcoded LTR value is reported or not, so it's kind
>> of useless and only prevents us from saving power.
>>
>> To get rid of those hardcoded LTR requirements, it's possible to reset
>> the PCI bridge device after initializing the cards firmware. I'm not
>> exactly sure why that works, maybe the power management subsystem of the
>> PCH resets its stored LTR values when doing a function level reset of
>> the bridge device. Doing the reset once after starting the wifi firmware
>> works very well, probably because the firmware only reports that LTR
>> value a single time during firmware startup.
>>
>> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
>> ---
>>   drivers/net/wireless/marvell/mwifiex/pcie.c   | 12 +++++++++
>>   .../wireless/marvell/mwifiex/pcie_quirks.c    | 26 +++++++++++++------
>>   .../wireless/marvell/mwifiex/pcie_quirks.h    |  1 +
>>   3 files changed, 31 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> index c6ccce426b49..2506e7e49f0c 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> @@ -1748,9 +1748,21 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
>>   static int mwifiex_pcie_init_fw_port(struct mwifiex_adapter *adapter)
>>   {
>>   	struct pcie_service_card *card = adapter->card;
>> +	struct pci_dev *pdev = card->dev;
>> +	struct pci_dev *parent_pdev = pci_upstream_bridge(pdev);
>>   	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
>>   	int tx_wrap = card->txbd_wrptr & reg->tx_wrap_mask;
>>   
>> +	/* Trigger a function level reset of the PCI bridge device, this makes
>> +	 * the firmware (latest version 15.68.19.p21) of the 88W8897 PCIe+USB
>> +	 * card stop reporting a fixed LTR value that prevents the system from
>> +	 * entering package C10 and S0ix powersaving states.
>> +	 * We need to do it here because it must happen after firmware
>> +	 * initialization and this function is called right after that is done.
>> +	 */
>> +	if (card->quirks & QUIRK_DO_FLR_ON_BRIDGE)
>> +		pci_reset_function(parent_pdev);
>> +
>>   	/* Write the RX ring read pointer in to reg->rx_rdptr */
>>   	if (mwifiex_write_reg(adapter, reg->rx_rdptr, card->rxbd_rdptr |
>>   			      tx_wrap)) {
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>> index 0234cf3c2974..cbf0565353ae 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
>> @@ -27,7 +27,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>>   			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>>   			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 4"),
>>   		},
>> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
>> +					QUIRK_DO_FLR_ON_BRIDGE),
>>   	},
>>   	{
>>   		.ident = "Surface Pro 5",
>> @@ -36,7 +37,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>>   			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>>   			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1796"),
>>   		},
>> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
>> +					QUIRK_DO_FLR_ON_BRIDGE),
>>   	},
>>   	{
>>   		.ident = "Surface Pro 5 (LTE)",
>> @@ -45,7 +47,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>>   			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>>   			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1807"),
>>   		},
>> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
>> +					QUIRK_DO_FLR_ON_BRIDGE),
>>   	},
>>   	{
>>   		.ident = "Surface Pro 6",
>> @@ -53,7 +56,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>>   			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>>   			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 6"),
>>   		},
>> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
>> +					QUIRK_DO_FLR_ON_BRIDGE),
>>   	},
>>   	{
>>   		.ident = "Surface Book 1",
>> @@ -61,7 +65,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>>   			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>>   			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book"),
>>   		},
>> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
>> +					QUIRK_DO_FLR_ON_BRIDGE),
>>   	},
>>   	{
>>   		.ident = "Surface Book 2",
>> @@ -69,7 +74,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>>   			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>>   			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book 2"),
>>   		},
>> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
>> +					QUIRK_DO_FLR_ON_BRIDGE),
>>   	},
>>   	{
>>   		.ident = "Surface Laptop 1",
>> @@ -77,7 +83,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>>   			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>>   			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop"),
>>   		},
>> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
>> +					QUIRK_DO_FLR_ON_BRIDGE),
>>   	},
>>   	{
>>   		.ident = "Surface Laptop 2",
>> @@ -85,7 +92,8 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
>>   			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
>>   			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop 2"),
>>   		},
>> -		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
>> +		.driver_data = (void *)(QUIRK_FW_RST_D3COLD |
>> +					QUIRK_DO_FLR_ON_BRIDGE),
>>   	},
>>   	{}
>>   };
>> @@ -103,6 +111,8 @@ void mwifiex_initialize_quirks(struct pcie_service_card *card)
>>   		dev_info(&pdev->dev, "no quirks enabled\n");
>>   	if (card->quirks & QUIRK_FW_RST_D3COLD)
>>   		dev_info(&pdev->dev, "quirk reset_d3cold enabled\n");
>> +	if (card->quirks & QUIRK_DO_FLR_ON_BRIDGE)
>> +		dev_info(&pdev->dev, "quirk do_flr_on_bridge enabled\n");
>>   }
>>   
>>   static void mwifiex_pcie_set_power_d3cold(struct pci_dev *pdev)
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>> index 8ec4176d698f..f8d463f4269a 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
>> @@ -18,6 +18,7 @@
>>   #include "pcie.h"
>>   
>>   #define QUIRK_FW_RST_D3COLD	BIT(0)
>> +#define QUIRK_DO_FLR_ON_BRIDGE	BIT(1)
>>   
>>   void mwifiex_initialize_quirks(struct pcie_service_card *card);
>>   int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev);
>> -- 
>> 2.31.1
>>

