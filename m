Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB961BC6A0
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgD1R3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbgD1R3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 13:29:20 -0400
Received: from localhost (mobile-166-175-187-210.mycingular.net [166.175.187.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38D1C2085B;
        Tue, 28 Apr 2020 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588094959;
        bh=KVlfB6OONnLYWB6zTD4NzqP3muDeWV4yVUIppLNLLR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=MxwYE2w2lKs5eDKpwbNX8Fs+0pJ2GijfEqIhf7nzZ8rNyGiqrQMqA93fspMHjHEQy
         Gw+tm+13xO0WK8HHvcXokteJtLGtgYcWO7MhuD9yqRTerZnvx93JLJfSxb/V0s16tO
         KFYuby1C0slOe4Y0mFMyK52Kj6NclZLuIfB8arWs=
Date:   Tue, 28 Apr 2020 12:29:17 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Habets <mhabets@solarflare.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        netdev@vger.kernel.org, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, skhan@linuxfoundation.org
Subject: Re: [Linux-kernel-mentees] [PATCH v2 2/2] realtek/8139cp: Remove
 Legacy Power Management
Message-ID: <20200428172917.GA177492@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428144314.24533-3-vaibhavgupta40@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 08:13:14PM +0530, Vaibhav Gupta wrote:
> Upgrade power management from legacy to generic using dev_pm_ops.
> 
> Add "__maybe_unused" attribute to resume() and susend() callbacks
> definition to suppress compiler warnings.
> 
> Generic callback requires an argument of type "struct device*". Hence,
> convert it to "struct net_device*" using "dev_get_drv_data()" to use
> it in the callback.
> 
> Most of the cleaning part is to remove pci_save_state(),
> pci_set_power_state(), etc power management function calls.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/net/ethernet/realtek/8139cp.c | 25 +++++++------------------
>  1 file changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
> index 60d342f82fb3..4f2fb1393966 100644
> --- a/drivers/net/ethernet/realtek/8139cp.c
> +++ b/drivers/net/ethernet/realtek/8139cp.c
> @@ -2054,10 +2054,9 @@ static void cp_remove_one (struct pci_dev *pdev)
>  	free_netdev(dev);
>  }
>  
> -#ifdef CONFIG_PM
> -static int cp_suspend (struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused cp_suspend(struct device *device)
>  {
> -	struct net_device *dev = pci_get_drvdata(pdev);
> +	struct net_device *dev = dev_get_drvdata(device);
>  	struct cp_private *cp = netdev_priv(dev);
>  	unsigned long flags;
>  
> @@ -2075,16 +2074,12 @@ static int cp_suspend (struct pci_dev *pdev, pm_message_t state)
>  
>  	spin_unlock_irqrestore (&cp->lock, flags);
>  
> -	pci_save_state(pdev);
> -	pci_enable_wake(pdev, pci_choose_state(pdev, state), cp->wol_enabled);

This one is a little more interesting because it relies on the driver
state (cp->wol_enabled).  IIUC, the corresponding pci_enable_wake() in
the generic path is in pci_prepare_to_sleep() (called from
pci_pm_suspend_noirq()).

But of course the generic path doesn't look at cp->wol_enabled.  It
looks at device_may_wakeup(), but I don't know whether there's a
connection between that and cp->wol_enabled.

> -	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> -
>  	return 0;
>  }
>  
> -static int cp_resume (struct pci_dev *pdev)
> +static int __maybe_unused cp_resume(struct device *device)
>  {
> -	struct net_device *dev = pci_get_drvdata (pdev);
> +	struct net_device *dev = dev_get_drvdata(device);
>  	struct cp_private *cp = netdev_priv(dev);
>  	unsigned long flags;
>  
> @@ -2093,10 +2088,6 @@ static int cp_resume (struct pci_dev *pdev)
>  
>  	netif_device_attach (dev);
>  
> -	pci_set_power_state(pdev, PCI_D0);
> -	pci_restore_state(pdev);
> -	pci_enable_wake(pdev, PCI_D0, 0);
> -
>  	/* FIXME: sh*t may happen if the Rx ring buffer is depleted */
>  	cp_init_rings_index (cp);
>  	cp_init_hw (cp);
> @@ -2111,7 +2102,6 @@ static int cp_resume (struct pci_dev *pdev)
>  
>  	return 0;
>  }
> -#endif /* CONFIG_PM */
>  
>  static const struct pci_device_id cp_pci_tbl[] = {
>          { PCI_DEVICE(PCI_VENDOR_ID_REALTEK,     PCI_DEVICE_ID_REALTEK_8139), },
> @@ -2120,15 +2110,14 @@ static const struct pci_device_id cp_pci_tbl[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, cp_pci_tbl);
>  
> +static SIMPLE_DEV_PM_OPS(cp_pm_ops, cp_suspend, cp_resume);
> +
>  static struct pci_driver cp_driver = {
>  	.name         = DRV_NAME,
>  	.id_table     = cp_pci_tbl,
>  	.probe        =	cp_init_one,
>  	.remove       = cp_remove_one,
> -#ifdef CONFIG_PM
> -	.resume       = cp_resume,
> -	.suspend      = cp_suspend,
> -#endif
> +	.driver.pm    = &cp_pm_ops,
>  };
>  
>  module_pci_driver(cp_driver);
> -- 
> 2.26.2
> 
