Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A73E38DAE3
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 12:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhEWKcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 06:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhEWKcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 06:32:11 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DC2C061574;
        Sun, 23 May 2021 03:30:44 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FnxSb2cspzQjw1;
        Sun, 23 May 2021 12:30:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id Na8ymqoZGslB; Sun, 23 May 2021 12:30:34 +0200 (CEST)
Subject: Re: [RFC PATCH 2/3] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     Amey Narkhede <ameynarkhede03@gmail.com>,
        =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210522131827.67551-1-verdre@v0yd.nl>
 <20210522131827.67551-3-verdre@v0yd.nl>
 <20210522184416.mscbmay27jciy2hv@archlinux>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <9520783e-f446-8872-f608-a3cf41b76065@mailbox.org>
Date:   Sun, 23 May 2021 12:30:30 +0200
MIME-Version: 1.0
In-Reply-To: <20210522184416.mscbmay27jciy2hv@archlinux>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.13 / 15.00 / 15.00
X-Rspamd-Queue-Id: C96B1108C
X-Rspamd-UID: 248834
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/21 8:44 PM, Amey Narkhede wrote:
 > On 21/05/22 03:18PM, Jonas DreÃŸler wrote:
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
 >> When I tried to reset only the wifi device (not touching parent), it 
gave
 >> the following error and the reset failed:
 >>
 >>      acpi device:4b: Cannot transition to power state D0 for parent 
in D3hot
 >>      mwifiex_pcie 0000:03:00.0: can't change power state from D3cold 
to D0 (config space inaccessible)
 >>
 > May I know how did you reset only the wifi device when you encountered
 > this error?

Not exactly sure what you mean by that, the trick was to put the parent
bridge into D3cold and then into D0 before transitioning the card into
D0.

That "Cannot transition to power state" warning is just the kernel
enforcing ACPI specs afaik, and that prevents us from putting the device
into ACPI state D0. This in turn means the device still has no power and
we can't set the PCI power state to D0, which is the second error.

 >
 >> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
 >> Signed-off-by: Jonas DreÃŸler <verdre@v0yd.nl>
 >> ---
 >>   drivers/net/wireless/marvell/mwifiex/pcie.c   |   7 +
 >>   .../wireless/marvell/mwifiex/pcie_quirks.c    | 123 ++++++++++++++++++
 >>   .../wireless/marvell/mwifiex/pcie_quirks.h    |   3 +
 >>   3 files changed, 133 insertions(+)
 >>
 >> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c 
b/drivers/net/wireless/marvell/mwifiex/pcie.c
 >> index 02fdce926de5..d9acfea395ad 100644
 >> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
 >> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
 >> @@ -528,6 +528,13 @@ static void mwifiex_pcie_reset_prepare(struct 
pci_dev *pdev)
 >>   	mwifiex_shutdown_sw(adapter);
 >>   	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
 >>   	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
 >> +
 >> +	/* For Surface gen4+ devices, we need to put wifi into D3cold right
 >> +	 * before performing FLR
 >> +	 */
 >> +	if (card->quirks & QUIRK_FW_RST_D3COLD)
 >> +		mwifiex_pcie_reset_d3cold_quirk(pdev);
 >> +
 >>   	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 >>
 >>   	card->pci_reset_ongoing = true;
 >> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c 
b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
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
 >> @@ -29,4 +95,61 @@ void mwifiex_initialize_quirks(struct 
pcie_service_card *card)
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
 > pci_set_power_state with PCI_D3cold state calls
 > pci_bus_set_current_state(dev->subordinate, PCI_D3cold).
 > Maybe this was the reason for the earlier problem you had?
 > Not 100% sure about this though CCing: Alex

Hmm, so we'd only have to put the bridge into D3cold and that takes care
of the device going to D3cold automatically?

 >
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
 > On the side note just save and restore is enough in this case?
 > What would be the device <-> driver state after the reset as you
 > are calling this on parent_pdev below so that affects other
 > devices on bus?

Not sure we can do anything more than save and restore, can we? I don't
think it will affect other devices on the bus, the parent bridge is only
connected to the wifi card, nothing else.

 >
 > Thanks,
 > Amey
 >
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
 >> +	dev_info(&pdev->dev, "Using reset_d3cold quirk to perform FW 
reset\n");
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
 >> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h 
b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
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

Thanks for the review,
Jonas
