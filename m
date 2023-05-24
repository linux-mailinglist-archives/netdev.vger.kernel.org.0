Return-Path: <netdev+bounces-5079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 101CF70F9D4
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAE7D1C20E0A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD9419526;
	Wed, 24 May 2023 15:10:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EEB1950D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD444C433D2;
	Wed, 24 May 2023 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684941056;
	bh=1HziZk0Ofryk7MpDRZfUaSYzXybvtVckG6+PfRVCo1c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=VtjnI42vjLtKXXQrmlFpD4S0MDxUXc3TpPumveYqzmCrv1phZPzw7aRVWX9r8I8yP
	 YcjvDpK6GkfOBA/6OeuZwCDBgZ2WckqL/A+/9iwEtBPG9/SIwno60R6pfkl913ttyW
	 nL25h06PJrbFVcD7bmLFRfSdcJJU5y29FLYXidHBuQRR+cf4ZNvdjD1T7PWAaVwSFC
	 Rj0W0eGEa4LsxRsjwtWcKvGP92NeX3DdYfDctqQnAGbBjegMhH5WDiuy3f+XbD978d
	 cu7RGX43IKJ6B0X2NNZRbNNbflLK2CP+uPHAUTIf75BZNgbEoakwdIXqFS2oTrmxBt
	 7JaVh7h5oEUrw==
Date: Wed, 24 May 2023 10:10:54 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Lukas Wunner <lukas@wunner.de>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dean Luick <dean.luick@cornelisnetworks.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 9/9] wifi: ath10k: Use RMW accessors for changing
 LNKCTL
Message-ID: <ZG4o/pYseBklnrTc@bhelgaas>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230517105235.29176-10-ilpo.jarvinen@linux.intel.com>

On Wed, May 17, 2023 at 01:52:35PM +0300, Ilpo Järvinen wrote:
> Don't assume that only the driver would be accessing LNKCTL. ASPM
> policy changes can trigger write to LNKCTL outside of driver's control.
> 
> Use RMW capability accessors which does proper locking to avoid losing
> concurrent updates to the register value. On restore, clear the ASPMC
> field properly.
> 
> Fixes: 76d870ed09ab ("ath10k: enable ASPM")
> Suggested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/net/wireless/ath/ath10k/pci.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index a7f44f6335fb..9275a672f90c 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1963,8 +1963,9 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
>  	ath10k_pci_irq_enable(ar);
>  	ath10k_pci_rx_post(ar);
>  
> -	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> -				   ar_pci->link_ctl);
> +	pcie_capability_clear_and_set_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> +					   PCI_EXP_LNKCTL_ASPMC,
> +					   ar_pci->link_ctl & PCI_EXP_LNKCTL_ASPMC);
>  
>  	return 0;
>  }
> @@ -2821,8 +2822,8 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar,
>  
>  	pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
>  				  &ar_pci->link_ctl);
> -	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> -				   ar_pci->link_ctl & ~PCI_EXP_LNKCTL_ASPMC);
> +	pcie_capability_clear_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> +				   PCI_EXP_LNKCTL_ASPMC);

These ath drivers all have the form:

  1) read LNKCTL
  2) save LNKCTL value in ->link_ctl
  3) write LNKCTL with "->link_ctl & ~PCI_EXP_LNKCTL_ASPMC"
     to disable ASPM
  4) write LNKCTL with ->link_ctl, presumably to re-enable ASPM

These patches close the hole between 1) and 3) where other LNKCTL
updates could interfere, which is definitely a good thing.

But the hole between 1) and 4) is much bigger and still there.  Any
update by the PCI core in that interval would be lost.

Straw-man proposal:

  - Change pci_disable_link_state() so it ignores aspm_disabled and
    always disables ASPM even if platform firmware hasn't granted
    ownership.  Maybe this should warn and taint the kernel.

  - Change drivers to use pci_disable_link_state() instead of writing
    LNKCTL directly.

Bjorn

