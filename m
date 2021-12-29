Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090A848169C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 21:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhL2USV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 15:18:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42284 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhL2USU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 15:18:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6BC63CE1A32;
        Wed, 29 Dec 2021 20:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4F6C36AE9;
        Wed, 29 Dec 2021 20:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640809096;
        bh=OO/7H+q1tJgl+UkE2VDhBPwDsy+1vjPE6DQfF6j9qh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=F+Plc0rWh9Hck56YGRXWzhcF6epaqqsaGxlZKhJf/NeCFraR983xCbxZDBKcRbZkx
         juf5NnrJY1i/98V7kQj68uTTQLMxwlr+/R9eLPlbzzk2kFei4csC47gNrNaEF5DZOO
         XY/lu9IIGzN4bMtI9XYsV61B0yi2x9pXI9xzWs38prFy/SbMvwEDMxP4Lj6cX1QF09
         mhaFPtq8mWPwjj59u+d+KOcAh6SdqiZ4iE/gRCACCYmGTXGk9PbzVnt2utVHgAq7Tc
         +KQYvJ3/1hyVXCQknQ2K3B3gvKSWZsUTc23UPMJ1ih+RYV/IgIkve9qqF252408jiW
         BFED9/DlyB9ag==
Date:   Wed, 29 Dec 2021 14:18:14 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
Subject: Re: [PATCH 2/2] net: wwan: iosm: Keep device at D0 for s2idle case
Message-ID: <20211229201814.GA1699315@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211224081914.345292-2-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Rafael, Vaibhav]

On Fri, Dec 24, 2021 at 04:19:14PM +0800, Kai-Heng Feng wrote:
> We are seeing spurious wakeup caused by Intel 7560 WWAN on AMD laptops.
> This prevent those laptops to stay in s2idle state.
> 
> From what I can understand, the intention of ipc_pcie_suspend() is to
> put the device to D3cold, and ipc_pcie_suspend_s2idle() is to keep the
> device at D0. However, the device can still be put to D3hot/D3cold by
> PCI core.
> 
> So explicitly let PCI core know this device should stay at D0, to solve
> the spurious wakeup.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_pcie.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> index d73894e2a84ed..af1d0e837fe99 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> @@ -340,6 +340,9 @@ static int __maybe_unused ipc_pcie_suspend_s2idle(struct iosm_pcie *ipc_pcie)
>  
>  	ipc_imem_pm_s2idle_sleep(ipc_pcie->imem, true);
>  
> +	/* Let PCI core know this device should stay at D0 */
> +	pci_save_state(ipc_pcie->pci);

This is a weird and non-obvious way to say "this device should stay at
D0".  It's also fairly expensive since pci_save_state() does a lot of
slow PCI config reads.

>  	return 0;
>  }
>  
> -- 
> 2.33.1
> 
