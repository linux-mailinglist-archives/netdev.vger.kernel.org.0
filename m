Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC1216BDB7
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 10:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgBYJmg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Feb 2020 04:42:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55401 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729332AbgBYJmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 04:42:35 -0500
Received: from mail-pj1-f69.google.com ([209.85.216.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1j6WjY-0007Fa-H3
        for netdev@vger.kernel.org; Tue, 25 Feb 2020 09:42:32 +0000
Received: by mail-pj1-f69.google.com with SMTP id c31so1723574pje.9
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 01:42:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qW9RGA2yoPMiW3Kx/nzk+m/gnWxZba3lZu/gpv/Ykio=;
        b=CYQzx/DDlof2w4OBHMQvY/25GA6jdGTSpLBOFsZXq0r/K09J0mdxPvXsrTXVCZALtq
         ZuZOA4qKHwXKy9o7w5WYgm/j9kqu40jaiWCa65h4wBYhtmS07c3FUY36tatyP1NtK7dp
         t09u+HqhhTYgN8YzvCxHwpv6MlGi9LAf4Uu0DEk5ZUSRL0/XiXHEnhFpRayUYFyoZnb+
         BkTBzbGYrosy4zMblHxrivKMZ7V1Tsea/XmQg5969iVz/HFd3nbntzMAY82PEnpYrBJl
         RtI9TcqV7HudVbbBbgBcme8Idu0VlNy8mB3OfZiK8hpkaGNu1lEDvn4QKuL4oy/P3704
         GQYA==
X-Gm-Message-State: APjAAAV7X3tvhSo8J0UWd6WTYVYAOQs/f9EI1qqI3a0vZ/ahuScovqPu
        5FK/zHS6MDETmKwuC6JN2xJsExAPBEobvjv7O3N2ihVh7CfY+voucAeMJq1TURmaeAJEN4j44Rk
        DBJIoHDzdWAM6HYafsi2JCBbv9t+/X3fvog==
X-Received: by 2002:a17:902:b089:: with SMTP id p9mr54667621plr.42.1582623751054;
        Tue, 25 Feb 2020 01:42:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqzXiUrpXHoo48RK24Wp0HqIr5ldhZ93iqCXYewVgNjhMgIUvCWcxmth/JlUGNfosIYuNKD1nw==
X-Received: by 2002:a17:902:b089:: with SMTP id p9mr54667588plr.42.1582623750614;
        Tue, 25 Feb 2020 01:42:30 -0800 (PST)
Received: from 2001-b011-380f-3214-6d62-6b9e-e5b8-db59.dynamic-ip6.hinet.net (2001-b011-380f-3214-6d62-6b9e-e5b8-db59.dynamic-ip6.hinet.net. [2001:b011:380f:3214:6d62:6b9e:e5b8:db59])
        by smtp.gmail.com with ESMTPSA id e18sm16697476pfm.24.2020.02.25.01.42.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 01:42:30 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [RFC PATCH v2] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20191007172559.11166.29328.stgit@localhost.localdomain>
Date:   Tue, 25 Feb 2020 17:42:26 +0800
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        zdai@linux.vnet.ibm.com,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        zdai@us.ibm.com, David Miller <davem@davemloft.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <681404C7-9015-4C64-B8FE-2C93D75A7318@canonical.com>
References: <CAKgT0UdwqGGKvaSJ+3vd-_d-6t9MB=No+7SpkbOT2PnynRK+2w@mail.gmail.com>
 <20191007172559.11166.29328.stgit@localhost.localdomain>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

> On Oct 8, 2019, at 01:27, Alexander Duyck <alexander.duyck@gmail.com> wrote:
> 
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> This patch is meant to address possible race conditions that can exist
> between network configuration and power management. A similar issue was
> fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
> netif_device_detach").
> 
> In addition it consolidates the code so that the PCI error handling code
> will essentially perform the power management freeze on the device prior to
> attempting a reset, and will thaw the device afterwards if that is what it
> is planning to do. Otherwise when we call close on the interface it should
> see it is detached and not attempt to call the logic to down the interface
> and free the IRQs again.
> 
>> From what I can tell the check that was adding the check for __E1000_DOWN
> in e1000e_close was added when runtime power management was added. However
> it should not be relevant for us as we perform a call to
> pm_runtime_get_sync before we call e1000_down/free_irq so it should always
> be back up before we call into this anyway.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Please merge this commit, a7023819404ac9bd2bb311a4fafd38515cfa71ec to stable v5.14.

`modprobe -r e1000e` triggers a null pointer dereference [1] after the the following two patches are applied to v5.4.y:
d635e7c4b34e6a630c7a1e8f1a8fd52c3e3ceea7 e1000e: Revert "e1000e: Make watchdog use delayed work"
21c6137939723ed6f5e4aec7882cdfc247304c27 e1000e: Drop unnecessary __E1000_DOWN bit twiddling

[1] https://bugs.launchpad.net/bugs/1864303

Kai-Heng

> ---
> 
> RFC v2: Dropped some unused variables
> 	Added logic to check for device present before removing to pm_freeze
> 	Fixed misplaced err_irq to before rtnl_unlock()
> 
> drivers/net/ethernet/intel/e1000e/netdev.c |   40 +++++++++++++++-------------
> 1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index d7d56e42a6aa..8b4e589aca36 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -4715,12 +4715,12 @@ int e1000e_close(struct net_device *netdev)
> 
> 	pm_runtime_get_sync(&pdev->dev);
> 
> -	if (!test_bit(__E1000_DOWN, &adapter->state)) {
> +	if (netif_device_present(netdev)) {
> 		e1000e_down(adapter, true);
> 		e1000_free_irq(adapter);
> 
> 		/* Link status message must follow this format */
> -		pr_info("%s NIC Link is Down\n", adapter->netdev->name);
> +		pr_info("%s NIC Link is Down\n", netdev->name);
> 	}
> 
> 	napi_disable(&adapter->napi);
> @@ -6298,10 +6298,14 @@ static int e1000e_pm_freeze(struct device *dev)
> {
> 	struct net_device *netdev = dev_get_drvdata(dev);
> 	struct e1000_adapter *adapter = netdev_priv(netdev);
> +	bool present;
> 
> +	rtnl_lock();
> +
> +	present = netif_device_present(netdev);
> 	netif_device_detach(netdev);
> 
> -	if (netif_running(netdev)) {
> +	if (present && netif_running(netdev)) {
> 		int count = E1000_CHECK_RESET_COUNT;
> 
> 		while (test_bit(__E1000_RESETTING, &adapter->state) && count--)
> @@ -6313,6 +6317,8 @@ static int e1000e_pm_freeze(struct device *dev)
> 		e1000e_down(adapter, false);
> 		e1000_free_irq(adapter);
> 	}
> +	rtnl_unlock();
> +
> 	e1000e_reset_interrupt_capability(adapter);
> 
> 	/* Allow time for pending master requests to run */
> @@ -6626,27 +6632,31 @@ static int __e1000_resume(struct pci_dev *pdev)
> 	return 0;
> }
> 
> -#ifdef CONFIG_PM_SLEEP
> static int e1000e_pm_thaw(struct device *dev)
> {
> 	struct net_device *netdev = dev_get_drvdata(dev);
> 	struct e1000_adapter *adapter = netdev_priv(netdev);
> +	int rc = 0;
> 
> 	e1000e_set_interrupt_capability(adapter);
> -	if (netif_running(netdev)) {
> -		u32 err = e1000_request_irq(adapter);
> 
> -		if (err)
> -			return err;
> +	rtnl_lock();
> +	if (netif_running(netdev)) {
> +		rc = e1000_request_irq(adapter);
> +		if (rc)
> +			goto err_irq;
> 
> 		e1000e_up(adapter);
> 	}
> 
> 	netif_device_attach(netdev);
> +err_irq:
> +	rtnl_unlock();
> 
> -	return 0;
> +	return rc;
> }
> 
> +#ifdef CONFIG_PM_SLEEP
> static int e1000e_pm_suspend(struct device *dev)
> {
> 	struct pci_dev *pdev = to_pci_dev(dev);
> @@ -6818,16 +6828,11 @@ static void e1000_netpoll(struct net_device *netdev)
> static pci_ers_result_t e1000_io_error_detected(struct pci_dev *pdev,
> 						pci_channel_state_t state)
> {
> -	struct net_device *netdev = pci_get_drvdata(pdev);
> -	struct e1000_adapter *adapter = netdev_priv(netdev);
> -
> -	netif_device_detach(netdev);
> +	e1000e_pm_freeze(&pdev->dev);
> 
> 	if (state == pci_channel_io_perm_failure)
> 		return PCI_ERS_RESULT_DISCONNECT;
> 
> -	if (netif_running(netdev))
> -		e1000e_down(adapter, true);
> 	pci_disable_device(pdev);
> 
> 	/* Request a slot slot reset. */
> @@ -6893,10 +6898,7 @@ static void e1000_io_resume(struct pci_dev *pdev)
> 
> 	e1000_init_manageability_pt(adapter);
> 
> -	if (netif_running(netdev))
> -		e1000e_up(adapter);
> -
> -	netif_device_attach(netdev);
> +	e1000e_pm_thaw(&pdev->dev);
> 
> 	/* If the controller has AMT, do not set DRV_LOAD until the interface
> 	 * is up.  For all other cases, let the f/w know that the h/w is now
> 

