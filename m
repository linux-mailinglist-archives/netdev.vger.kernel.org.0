Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC36C48168E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 21:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhL2UMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 15:12:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60692 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhL2UMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 15:12:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C294614B3;
        Wed, 29 Dec 2021 20:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41703C36AE9;
        Wed, 29 Dec 2021 20:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640808751;
        bh=vWtanjbewujinnsoAkIMuVPTzg/CYmtOfG32HMGoOIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ri2QRYB/7J/7LVZ8rfiwgnIizpgwLsLMSsLF3cm4tBjkhVFJrtTto93EM18va0Yqr
         FYhWUXtXuIcM5kYowDEonIa23f+MV8wNNdNhi9rHljv2F64NfNznxlJP5uuPmNlxN3
         we4bma2po+ck6Pxx3nWUGOX/bl5iZ9kbKO+I3mXRKGGsoqNBYEE3+9mpXYmfRvkSmb
         MfKwkkCRLPNJZ8WvnSrldTdF07hOG1th8BRnvWCOm5BW7Y2d41ctz6KoEjpnWDCJEo
         NznV53lorTyejhVUqJgmARWf/NOxYjP1+bea/FKfvni2Hr302VZXjHejIp1Vx/FSdd
         JMKiG/5vDQgag==
Date:   Wed, 29 Dec 2021 14:12:29 -0600
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
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 1/2] net: wwan: iosm: Let PCI core handle PCI power
 transition
Message-ID: <20211229201229.GA1698801@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211224081914.345292-1-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Rafael, in case you have insight about the PCI_D0 question below;
Vaibhav, since this is related to your generic PM conversions]

On Fri, Dec 24, 2021 at 04:19:13PM +0800, Kai-Heng Feng wrote:
> pci_pm_suspend_noirq() and pci_pm_resume_noirq() already handle power
> transition for system-wide suspend and resume, so it's not necessary to
> do it in the driver.

I see DaveM has already applied this, but it looks good to me, thanks
for doing this!

One minor question below...

> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_pcie.c | 49 ++-------------------------
>  1 file changed, 2 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> index 2fe88b8be3481..d73894e2a84ed 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
> @@ -363,67 +363,22 @@ static int __maybe_unused ipc_pcie_resume_s2idle(struct iosm_pcie *ipc_pcie)
>  
>  int __maybe_unused ipc_pcie_suspend(struct iosm_pcie *ipc_pcie)
>  {
> -	struct pci_dev *pdev;
> -	int ret;
> -
> -	pdev = ipc_pcie->pci;
> -
> -	/* Execute D3 one time. */
> -	if (pdev->current_state != PCI_D0) {
> -		dev_dbg(ipc_pcie->dev, "done for PM=%d", pdev->current_state);
> -		return 0;
> -	}

I don't understand the intent of this early exit, and it's not obvious
to me that pci_pm_suspend_noirq() bails out early when
(pdev->current_state != PCI_D0).

>  	/* The HAL shall ask the shared memory layer whether D3 is allowed. */
>  	ipc_imem_pm_suspend(ipc_pcie->imem);
>  
> -	/* Save the PCI configuration space of a device before suspending. */
> -	ret = pci_save_state(pdev);
> -
> -	if (ret) {
> -		dev_err(ipc_pcie->dev, "pci_save_state error=%d", ret);
> -		return ret;
> -	}
> -
> -	/* Set the power state of a PCI device.
> -	 * Transition a device to a new power state, using the device's PCI PM
> -	 * registers.
> -	 */
> -	ret = pci_set_power_state(pdev, PCI_D3cold);
> -
> -	if (ret) {
> -		dev_err(ipc_pcie->dev, "pci_set_power_state error=%d", ret);
> -		return ret;
> -	}
> -
>  	dev_dbg(ipc_pcie->dev, "SUSPEND done");
> -	return ret;
> +	return 0;
>  }
>  
>  int __maybe_unused ipc_pcie_resume(struct iosm_pcie *ipc_pcie)
>  {
> -	int ret;
> -
> -	/* Set the power state of a PCI device.
> -	 * Transition a device to a new power state, using the device's PCI PM
> -	 * registers.
> -	 */
> -	ret = pci_set_power_state(ipc_pcie->pci, PCI_D0);
> -
> -	if (ret) {
> -		dev_err(ipc_pcie->dev, "pci_set_power_state error=%d", ret);
> -		return ret;
> -	}
> -
> -	pci_restore_state(ipc_pcie->pci);
> -
>  	/* The HAL shall inform the shared memory layer that the device is
>  	 * active.
>  	 */
>  	ipc_imem_pm_resume(ipc_pcie->imem);
>  
>  	dev_dbg(ipc_pcie->dev, "RESUME done");
> -	return ret;
> +	return 0;
>  }
>  
>  static int __maybe_unused ipc_pcie_suspend_cb(struct device *dev)
> -- 
> 2.33.1
> 
