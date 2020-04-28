Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC961BC651
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgD1RTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgD1RTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 13:19:30 -0400
Received: from localhost (mobile-166-175-187-210.mycingular.net [166.175.187.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F8732082E;
        Tue, 28 Apr 2020 17:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588094370;
        bh=hh6nXBiocZ2GmSoC/HUt/H1ViNWeuSi+aGw8ni8/Vvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=17nyOSUWlUVh2D5YBLMoRXzFRf9mzTyTROtZ8B5ZHjNJxg+5j7ESUyJgPbQq5TroI
         LLXY0smLQRaOIuamjjyPUqXEVCT55Slkrvn6qQIXc4+57aDc9pYekU/1KybBw1/rYQ
         x3rlcb6g5qdNQB0ExSFcfFOBt6FSELMWYXWXTvWA=
Date:   Tue, 28 Apr 2020 12:19:28 -0500
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
Subject: Re: [Linux-kernel-mentees] [PATCH v2 1/2] realtek/8139too: Remove
 Legacy Power Management
Message-ID: <20200428171928.GA170516@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428144314.24533-2-vaibhavgupta40@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uncapitalize "legacy power management" in subject.  I'd say "convert",
not "remove", to make it clear that the driver will still do power
management afterwards.

I think your to: and cc: list came from the get_maintainer.pl script,
but you can trim it a bit by omitting people who have just made
occasional random fixups.  These drivers are really unmaintained, so
Dave M, netdev, Rafael, linux-pm, linux-pci, and maybe LKML are
probably enough.

On Tue, Apr 28, 2020 at 08:13:13PM +0530, Vaibhav Gupta wrote:
> Upgrade power management from legacy to generic using dev_pm_ops.

Instead of the paragraphs below, which cover the stuff that's fairly
obvious, I think it would be more useful to include hints about where
the things you removed will be done now.  That helps reviewers verify
that this doesn't break anything.  E.g.,

  In the legacy PM model, drivers save and restore PCI state and set
  the device power state directly.  In the generic model, this is all
  done by the PCI core in .suspend_noirq() (pci_pm_suspend_noirq())
  and .resume_noirq() (pci_pm_resume_noirq()).

This sort of thing could go in each commit log.  The cover letter
doesn't normally go in the commit log, so you have to assume it will
be lost.

> Remove "struct pci_driver.suspend" and "struct pci_driver.resume"
> bindings, and add "struct pci_driver.driver.pm" .
> 
> Add "__maybe_unused" attribute to resume() and susend() callbacks
> definition to suppress compiler warnings.
>
> Generic callback requires an argument of type "struct device*". Hence,
> convert it to "struct net_device*" using "dev_get_drvdata()" to use
> it in the callback.
>
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks a lot for doing this!

> ---
>  drivers/net/ethernet/realtek/8139too.c | 26 +++++++-------------------
>  1 file changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
> index 5caeb8368eab..227139d42227 100644
> --- a/drivers/net/ethernet/realtek/8139too.c
> +++ b/drivers/net/ethernet/realtek/8139too.c
> @@ -2603,17 +2603,13 @@ static void rtl8139_set_rx_mode (struct net_device *dev)
>  	spin_unlock_irqrestore (&tp->lock, flags);
>  }
>  
> -#ifdef CONFIG_PM
> -
> -static int rtl8139_suspend (struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused rtl8139_suspend(struct device *device)
>  {
> -	struct net_device *dev = pci_get_drvdata (pdev);
> +	struct net_device *dev = dev_get_drvdata(device);
>  	struct rtl8139_private *tp = netdev_priv(dev);
>  	void __iomem *ioaddr = tp->mmio_addr;
>  	unsigned long flags;
>  
> -	pci_save_state (pdev);
> -
>  	if (!netif_running (dev))
>  		return 0;
>  
> @@ -2631,38 +2627,30 @@ static int rtl8139_suspend (struct pci_dev *pdev, pm_message_t state)
>  
>  	spin_unlock_irqrestore (&tp->lock, flags);
>  
> -	pci_set_power_state (pdev, PCI_D3hot);
> -
>  	return 0;
>  }
>  
> -
> -static int rtl8139_resume (struct pci_dev *pdev)
> +static int __maybe_unused rtl8139_resume(struct device *device)
>  {
> -	struct net_device *dev = pci_get_drvdata (pdev);
> +	struct net_device *dev = dev_get_drvdata(device);
>  
> -	pci_restore_state (pdev);
>  	if (!netif_running (dev))
>  		return 0;
> -	pci_set_power_state (pdev, PCI_D0);
> +
>  	rtl8139_init_ring (dev);
>  	rtl8139_hw_start (dev);
>  	netif_device_attach (dev);
>  	return 0;
>  }
>  
> -#endif /* CONFIG_PM */
> -
> +static SIMPLE_DEV_PM_OPS(rtl8139_pm_ops, rtl8139_suspend, rtl8139_resume);
>  
>  static struct pci_driver rtl8139_pci_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= rtl8139_pci_tbl,
>  	.probe		= rtl8139_init_one,
>  	.remove		= rtl8139_remove_one,
> -#ifdef CONFIG_PM
> -	.suspend	= rtl8139_suspend,
> -	.resume		= rtl8139_resume,
> -#endif /* CONFIG_PM */
> +	.driver.pm	= &rtl8139_pm_ops,
>  };
>  
>  
> -- 
> 2.26.2
> 
