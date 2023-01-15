Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9A766B0DB
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 13:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjAOMG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 07:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjAOMG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 07:06:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F4893D4
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 04:06:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12D9660C97
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 12:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4783C433D2;
        Sun, 15 Jan 2023 12:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673784384;
        bh=89DfjPUGg8AJ1fEOP8FCpq13lk8WAqt53idNmCOpsFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cuMGqKbE7IF8ld7oK+NqVPoMF39KC3M9P/keqAA8tYf+MubSlvlwx5yBK/SCG+T0O
         TGTMH1FYIcSy7Yw+Nl+xoBJ+LkpfjrOvtmtZw06dklkdidQQ+LKDNAswWDEv6Az92I
         3LGkewyTy32wmf6tK2cMzfMHsypYsCueYTvLCI/SvdrqvHHe8S+jpMbww5skucvhxR
         LSH+u/uUD5DXTWkmEt47VYCj62kN4+t9T43TxNw5CgCadH3uVwTI2Drztrn68K909I
         Bvk3Id+UDT+nEW1gW9/ThjZWjy1aWeb9Uiniw4YDMKshv7WlhaZbM8cs/1STDmL0t+
         XTMVAreUq8pcQ==
Date:   Sun, 15 Jan 2023 14:06:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Slawomir Laba <slawomirx.laba@intel.com>,
        netdev@vger.kernel.org, jan.sokolowski@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net 1/1] iavf: Fix shutdown pci callback to match the
 remove one
Message-ID: <Y8PsO9J3PghkBjEs@unreal>
References: <20230113215012.971028-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113215012.971028-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 01:50:12PM -0800, Tony Nguyen wrote:
> From: Slawomir Laba <slawomirx.laba@intel.com>
> 
> Make the flow for pci shutdown be the same to the pci remove.
> 
> iavf_shutdown was implementing an incomplete version
> of iavf_remove. It misses several calls to the kernel like
> iavf_free_misc_irq, iavf_reset_interrupt_capability, iounmap
> that might break the system on reboot or hibernation.
> 
> Implement the call of iavf_remove directly in iavf_shutdown to
> close this gap.
> 
> Fixes: 5eae00c57f5e ("i40evf: main driver core")
> Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Marek Szlosek <marek.szlosek@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 40 +++++++--------------
>  1 file changed, 12 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index adc02adef83a..34c9bd62546b 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -4812,34 +4812,6 @@ int iavf_process_config(struct iavf_adapter *adapter)
>  	return 0;
>  }
>  
> -/**
> - * iavf_shutdown - Shutdown the device in preparation for a reboot
> - * @pdev: pci device structure
> - **/
> -static void iavf_shutdown(struct pci_dev *pdev)
> -{
> -	struct iavf_adapter *adapter = iavf_pdev_to_adapter(pdev);
> -	struct net_device *netdev = adapter->netdev;
> -
> -	netif_device_detach(netdev);
> -
> -	if (netif_running(netdev))
> -		iavf_close(netdev);
> -
> -	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
> -		dev_warn(&adapter->pdev->dev, "%s: failed to acquire crit_lock\n", __func__);
> -	/* Prevent the watchdog from running. */
> -	iavf_change_state(adapter, __IAVF_REMOVE);
> -	adapter->aq_required = 0;
> -	mutex_unlock(&adapter->crit_lock);
> -
> -#ifdef CONFIG_PM
> -	pci_save_state(pdev);
> -
> -#endif
> -	pci_disable_device(pdev);
> -}
> -
>  /**
>   * iavf_probe - Device Initialization Routine
>   * @pdev: PCI device information struct
> @@ -5177,6 +5149,18 @@ static void iavf_remove(struct pci_dev *pdev)
>  	pci_disable_device(pdev);
>  }
>  
> +/**
> + * iavf_shutdown - Shutdown the device in preparation for a reboot
> + * @pdev: pci device structure
> + **/
> +static void iavf_shutdown(struct pci_dev *pdev)
> +{
> +	iavf_remove(pdev);
> +
> +	if (system_state == SYSTEM_POWER_OFF)
> +		pci_set_power_state(pdev, PCI_D3hot);

Why do you need it? and why does "system_state == SYSTEM_POWER_OFF" line
exist in small number of old drivers?

What is missing in PCI core power state management, which pushes you
to set D3 state in hibernation?

Thanks


> +}
> +
>  static SIMPLE_DEV_PM_OPS(iavf_pm_ops, iavf_suspend, iavf_resume);
>  
>  static struct pci_driver iavf_driver = {
> -- 
> 2.38.1
> 
