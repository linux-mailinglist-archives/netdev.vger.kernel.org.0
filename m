Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E350C42A054
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhJLIvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbhJLIvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 04:51:05 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71998C061570;
        Tue, 12 Oct 2021 01:49:04 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HT8Tn3Ln9zQkhX;
        Tue, 12 Oct 2021 10:49:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <fee8b431-617f-3890-3ad2-67a61d3ffca2@v0yd.nl>
Date:   Tue, 12 Oct 2021 10:48:49 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS Surface
 devices
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
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
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20211011165301.GA1650148@bhelgaas>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <20211011165301.GA1650148@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5514626E
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/21 18:53, Bjorn Helgaas wrote:
> [+cc Alex]
> 
> On Mon, Oct 11, 2021 at 03:42:38PM +0200, Jonas Dreßler wrote:
>> The most recent firmware (15.68.19.p21) of the 88W8897 PCIe+USB card
>> reports a hardcoded LTR value to the system during initialization,
>> probably as an (unsuccessful) attempt of the developers to fix firmware
>> crashes. This LTR value prevents most of the Microsoft Surface devices
>> from entering deep powersaving states (either platform C-State 10 or
>> S0ix state), because the exit latency of that state would be higher than
>> what the card can tolerate.
> 
> S0ix and C-State 10 are ACPI concepts that don't mean anything in a
> PCIe context.
> 
> I think LTR is only involved in deciding whether to enter the ASPM
> L1.2 substate.  Maybe the system will only enter C-State 10 or S0ix
> when the link is in L1.2?

Yup, this is indeed the case, see https://01.org/blogs/qwang59/2020/linux-s0ix-troubleshooting
(ctrl+f "IP LINK PM STATE").

> 
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
> 
> I don't believe this.  Why would resetting the root port change what
> the downstream device reports via LTR messages?
> 
>  From PCIe r5.0, sec 5.5.1:
> 
>    The following rules define how the L1.1 and L1.2 substates are entered:
>      ...
>      * When in ASPM L1.0 and the ASPM L1.2 Enable bit is Set, the L1.2
>        substate must be entered when CLKREQ# is deasserted and all of
>        the following conditions are true:
> 
>        - The reported snooped LTR value last sent or received by this
> 	Port is greater than or equal to the value set by the
> 	LTR_L1.2_THRESHOLD Value and Scale fields, or there is no
> 	snoop service latency requirement.
> 
>        - The reported non-snooped LTR last sent or received by this
> 	Port value is greater than or equal to the value set by the
> 	LTR_L1.2_THRESHOLD Value and Scale fields, or there is no
> 	non-snoop service latency requirement.
> 
>  From the LTR Message format in sec 6.18:
> 
>    No-Snoop Latency and Snoop Latency: As shown in Figure 6-15, these
>    fields include a Requirement bit that indicates if the device has a
>    latency requirement for the given type of Request. If the
>    Requirement bit is Set, the LatencyValue and LatencyScale fields
>    describe the latency requirement. If the Requirement bit is Clear,
>    there is no latency requirement and the LatencyValue and
>    LatencyScale fields are ignored.
> 
> Resetting the root port might make it forget the LTR value it last
> received.  If that's equivalent to having no service latency
> requirement, it *might* enable L1.2 entry, although that doesn't seem
> equivalent to the downstream device having sent an LTR message with
> the Requirement bit cleared.
> 
> I think the endpoint is required to send a new LTR message before it
> goes to a non-D0 state (sec 6.18), so the bridge will capture the
> latency again, and we'll probably be back in the same state.

Indeed that happens when suspending the device, after resuming the LTR
value is back to the initial value. mwifiex_pcie_init_fw_port() is
executed on resume, too though (I should probably have mentioned this
in the commit message, will do in v2), so this is taken care of.

While suspended, the device goes into D3 anyway and S0ix is achieved
regardless of the LTR value.

> 
> This all seems fragile to me.  If we force the link to L1.2 without
> knowing accurate exit latencies and latency tolerance, the device is
> liable to drop packets.

Yeah, I'm not saying this patch isn't an ugly hack...

What I can say though is that this patch has been running in the
linux-surface (https://github.com/linux-surface/kernel/pull/72) kernel
for a few months now, and so far we've only received positive feedback.

There's two alternatives I can think of to deal with this issue:

1) Revert the cards firmware in linux-firmware back to the second-latest
version. That firmware didn't report a fixed LTR value and also doesn't
have any other obvious issues I know of compared to the latest one.

2) Somehow interact with the PMC Core driver to make it ignore the LTR
values reported by the card (I doubt that's possible from mwifiex).
It can be done manually via debugfs by writing to
/sys/kernel/debug/pmc_core/ltr_ignore.

> 
>> +	 * We need to do it here because it must happen after firmware
>> +	 * initialization and this function is called right after that is done.
>> +	 */
>> +	if (card->quirks & QUIRK_DO_FLR_ON_BRIDGE)
>> +		pci_reset_function(parent_pdev);
> 
> PCIe r5.0, sec 7.5.3.3, says Function Level Reset can only be
> supported by endpoints, so I guess this will actually do some other
> kind of reset.

Interesting, I briefly searched and it doesn't seem like think
there's public documentation available by Intel that goes into
the specifics here, maybe someone working at Intel knows more?

> 
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

