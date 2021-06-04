Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B2739C1D7
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhFDVKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhFDVKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25F81613EA;
        Fri,  4 Jun 2021 21:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622840914;
        bh=Xye3NEgxGGlW+L7h1jlnfY5apTXpxQ80ISWiwLJL5g0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=TaM//SWb/KIsUNGkxKDWGLtb5Sev3OUCRqvvGSWzSx9tdz7rNOT0dEgfA6QUVLadm
         lcSEAyOZePbSq+JBbNucDkEvQrhLWUqHiIbkAvfttf7cDveTYmp+5lb3oDLbh1hQlV
         py1Sp3P2Z2A1IN277joEPD8Zv1n+lPz1jSVHURZFATuftUpnPIcQzLqULie7PTTOv8
         Jlh/FTCg5JVQKmLeLTFeujWdm2B91poSc6cmnzKNX99UL9eeJVkhouNFIdsBvKPlOj
         FzFvtM4CqJG3qlEut8U6GL+Ysloe8TzHh8sQmEqqqXC+tJ/c0y8GvmNjlCZP4JG/DR
         Z6pTG/V5xHnCA==
Date:   Fri, 4 Jun 2021 16:08:32 -0500
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
Subject: Re: [RFC PATCH 2/3] mwifiex: pcie: add reset_d3cold quirk for
 Surface gen4+ devices
Message-ID: <20210604210832.GA2239805@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210522131827.67551-3-verdre@v0yd.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 22, 2021 at 03:18:26PM +0200, Jonas Dreﬂler wrote:
> From: Tsuchiya Yuto <kitakar@gmail.com>
> 
> To reset mwifiex on Surface gen4+ (Pro 4 or later gen) devices, it
> seems that putting the wifi device into D3cold is required according
> to errata.inf file on Windows installation (Windows/INF/errata.inf).
> 
> This patch adds a function that performs power-cycle (put into D3cold
> then D0) and call the function at the end of reset_prepare().
> 
> Note: Need to also reset the parent device (bridge) of wifi on SB1;
> it might be because the bridge of wifi always reports it's in D3hot.
> When I tried to reset only the wifi device (not touching parent), it gave
> the following error and the reset failed:
> 
>     acpi device:4b: Cannot transition to power state D0 for parent in D3hot
>     mwifiex_pcie 0000:03:00.0: can't change power state from D3cold to D0 (config space inaccessible)
> 
> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
> Signed-off-by: Jonas Dreﬂler <verdre@v0yd.nl>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c   |   7 +
>  .../wireless/marvell/mwifiex/pcie_quirks.c    | 123 ++++++++++++++++++
>  .../wireless/marvell/mwifiex/pcie_quirks.h    |   3 +
>  3 files changed, 133 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 02fdce926de5..d9acfea395ad 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -528,6 +528,13 @@ static void mwifiex_pcie_reset_prepare(struct pci_dev *pdev)
>  	mwifiex_shutdown_sw(adapter);
>  	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
>  	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
> +
> +	/* For Surface gen4+ devices, we need to put wifi into D3cold right
> +	 * before performing FLR

This comment seems incorrect or at least incomplete.  When the device
is in D3cold, it isn't powered at all, so you can't do anything with
it, including FLR.  But maybe you meant that you need to put it in
D3cold and back to D0 before doing an FLR.  That would work.  But in
that case, there's no point in an FLR because the power cycle has
already reset more than the FLR will.

Bjorn
