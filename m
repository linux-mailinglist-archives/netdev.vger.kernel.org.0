Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7101453D3F2
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 01:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiFCXzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 19:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiFCXzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 19:55:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEB23981D
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 16:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAC9FB82501
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 23:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C3BC385A9;
        Fri,  3 Jun 2022 23:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654300515;
        bh=C9h3wZe8GpITvh5294wi+SCcHIg0kDLl+FaXF8m0qtY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=JCIlqFm19u+PrmodYJydRwnOkLxNr82B3gt0KKmxmJSJJcM+WZ/dhml+xZHZsRSlO
         MvNKIWA6b+ko5HhXv3QmDvPxvyfhsMZbAZNwuQ5zGx79WE1iN/t3U8hXRMNddvrtpd
         Z++dz8IKIxzDJbrQ0qb2qqCtaU0dF3VwVvY6YBI6d2nZRKy8oh+4wbR4CkegSOkv70
         b+8SsNrLqfIUN1sxQLW7EcuFS4iiz455N2GfTl4TYGwXaceEWJNOA6cyy3UtoeIE55
         /w4zYl9qqAKKCf0h+R14w8Y1hVqi8RClcaWrnhKiPY02kG93MFZvCoYfj8ECoQr9KU
         eMv4SsSGfwAow==
Date:   Fri, 3 Jun 2022 18:55:12 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
Subject: Re: [PATCH net] net: stmmac: Fix WoL for PCI-based setups
Message-ID: <20220603235512.GA110908@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a47502239c0f5867d4dcebb2140849c40c5967f.1533046004.git.joabreu@synopsys.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Rafael, Vaibhav for wakeup usage questions]

On Tue, Jul 31, 2018 at 03:08:20PM +0100, Jose Abreu wrote:
> WoL won't work in PCI-based setups because we are not saving the PCI EP
> state before entering suspend state and not allowing D3 wake.
> 
> Fix this by using a wrapper around stmmac_{suspend/resume} which
> correctly sets the PCI EP state.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 40 ++++++++++++++++++++++--
>  1 file changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> index 8d375e51a526..6a393b16a1fc 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> @@ -257,7 +257,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
>  		return -ENOMEM;
>  
>  	/* Enable pci device */
> -	ret = pcim_enable_device(pdev);
> +	ret = pci_enable_device(pdev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n",
>  			__func__);
> @@ -300,9 +300,45 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
>  static void stmmac_pci_remove(struct pci_dev *pdev)
>  {
>  	stmmac_dvr_remove(&pdev->dev);
> +	pci_disable_device(pdev);
>  }
>  
> -static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, stmmac_suspend, stmmac_resume);
> +static int stmmac_pci_suspend(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	int ret;
> +
> +	ret = stmmac_suspend(dev);
> +	if (ret)
> +		return ret;
> +
> +	ret = pci_save_state(pdev);
> +	if (ret)
> +		return ret;
> +
> +	pci_disable_device(pdev);
> +	pci_wake_from_d3(pdev, true);

I have a question about this.  This driver uses generic power
management (thank you for that!), and in that case the PCI core should
take care of all these PCI details for you, e.g.,

  suspend_devices_and_enter
    dpm_suspend_start(PMSG_SUSPEND)
      pci_pm_suspend                       # PCI bus .suspend() method
        stmmac_suspend                     # driver->pm->suspend
          netif_device_detach              <-- device-specific
          ...                              <-- device-specific
    suspend_enter
      dpm_suspend_noirq(PMSG_SUSPEND)
        pci_pm_suspend_noirq               # PCI bus .suspend_noirq() method
          pci_save_state                   <-- generic PCI
          pci_prepare_to_sleep             <-- generic PCI
            pci_enable_wake(true)
            pci_set_power_state
    ...
    dpm_resume_end(PMSG_RESUME)
      pci_pm_resume                        # PCI bus .resume() method
        pci_restore_standard_config
          pci_set_power_state(PCI_D0)      <-- generic PCI
          pci_restore_state                <-- generic PCI
        pci_pm_default_resume
          pci_enable_wake(false)
        stmmac_resume                      # driver->pm->resume
          ...                              <-- device-specific
          netif_device_attach              <-- device-specific

So why did WoL not work before this patch?  IIUC there are two
important pieces to the generic wakeup framework:

  device_set_wakeup_capable(true):  device physically CAN signal wakeup
  device_set_wakeup_enable(true):   device is ALLOWED to signal wakeup

The PCI core calls device_set_wakeup_capable(true) in pci_pm_init() if
the device advertises support for PME, so that part was probably fine.

But I don't think WoL would *work* unless somebody called
device_set_wakeup_enable(true), which the PCI core doesn't do.
stmmac_set_wol() does, but I think that's only exercised by ethtool.

There are several drivers, e.g., e1000, igb, ixgbe, that call
device_set_wakeup_enable() from their .probe() methods, and I suspect
that if you did the same, you wouldn't need this patch.

I'm not 100% sure that's the right approach though because of these
notes from devices.rst, which seem a little bit contradictory:

  These fields are initialized by bus or device driver code using
  device_set_wakeup_capable() and device_set_wakeup_enable(), defined
  in include/linux/pm_wakeup.h. [1]
  ...
  Device drivers, however, are not expected to call
  device_set_wakeup_enable() directly in any case. [2]

If drivers aren't expected to call device_set_wakeup_enable(), I guess
WoL would never be enabled except by user-space doing something?  If
that's the intent, why do all these drivers enable wakeup themselves?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/driver-api/pm/devices.rst?id=v5.18#n141
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/driver-api/pm/devices.rst?id=v5.18#n181

> +	return 0;
> +}
> +
> +static int stmmac_pci_resume(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	int ret;
> +
> +	pci_restore_state(pdev);
> +	pci_set_power_state(pdev, PCI_D0);
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret)
> +		return ret;
> +
> +	pci_set_master(pdev);
> +
> +	return stmmac_resume(dev);
> +}
> +
> +static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, stmmac_pci_suspend, stmmac_pci_resume);
>  
>  /* synthetic ID, no official vendor */
>  #define PCI_VENDOR_ID_STMMAC 0x700
> -- 
> 2.7.4
