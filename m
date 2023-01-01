Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3911065A994
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 11:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjAAKcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 05:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjAAKcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 05:32:22 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5464E6150;
        Sun,  1 Jan 2023 02:32:20 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aefd4.dynamic.kabel-deutschland.de [95.90.239.212])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 72F6060027FC1;
        Sun,  1 Jan 2023 11:32:16 +0100 (CET)
Message-ID: <eb5a9805-3e53-ec22-696e-21c6b8cf0bfc@molgen.mpg.de>
Date:   Sun, 1 Jan 2023 11:32:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
To:     Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        rajat.khandelwal@intel.com, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
References: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc: +Bjorn, +linux-pci]


Dear Rajat,


Thank you for your patch.

Am 29.12.22 um 13:26 schrieb Rajat Khandelwal:
> The CPU logs get flooded with replay rollover/timeout AER errors in
> the system with i225_lmvp connected, usually inside thunderbolt devices.

Please add one example log message to the commit message.

> One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates

I couldn’t find that device. Is that the correct name?

> an Intel Foxville chipset, which uses the igc driver.

Please add a blank line between paragraphs.

> On connecting ethernet, CPU logs get inundated with these errors. The point
> is we shouldn't be spamming the logs with such correctible errors as it

correctable

> confuses other kernel developers less familiar with PCI errors, support
> staff, and users who happen to look at the logs.

Please reference the bug reports (bug tracker and mailing list), you 
know of, where this was reported.

> Signed-off-by: Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 28 +++++++++++++++++++++--
>   1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index ebff0e04045d..a3a6e8086c8d 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6201,6 +6201,26 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>   	return value;
>   }
>   
> +#ifdef CONFIG_PCIEAER
> +static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)

correctable

> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	u32 aer_pos, corr_mask;

Instead of using the preprocessor, use a normal C conditional. From 
`Documentation/process/coding-style.rst`:

> Within code, where possible, use the IS_ENABLED macro to convert a Kconfig
> symbol into a C boolean expression, and use it in a normal C conditional:
> 
> .. code-block:: c                                                  
>                                                                         
>         if (IS_ENABLED(CONFIG_SOMETHING)) {
>                 ...
>         }
> 
> The compiler will constant-fold the conditional away, and include or exclude
> the block of code just as with an #ifdef, so this will not add any runtime
> overhead.  However, this approach still allows the C compiler to see the code
> inside the block, and check it for correctness (syntax, types, symbol
> references, etc).  Thus, you still have to use an #ifdef if the code inside the
> block references symbols that will not exist if the condition is not met.


> +
> +	if (pdev->device != IGC_DEV_ID_I225_LMVP)
> +		return;
> +
> +	aer_pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
> +	if (!aer_pos)
> +		return;
> +
> +	pci_read_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, &corr_mask);
> +
> +	corr_mask |= PCI_ERR_COR_REP_ROLL | PCI_ERR_COR_REP_TIMER;
> +	pci_write_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, corr_mask);
> +}
> +#endif
> +
>   /**
>    * igc_probe - Device Initialization Routine
>    * @pdev: PCI device information struct
> @@ -6236,8 +6256,6 @@ static int igc_probe(struct pci_dev *pdev,
>   	if (err)
>   		goto err_pci_reg;
>   
> -	pci_enable_pcie_error_reporting(pdev);
> -
>   	err = pci_enable_ptm(pdev, NULL);
>   	if (err < 0)
>   		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
> @@ -6272,6 +6290,12 @@ static int igc_probe(struct pci_dev *pdev,
>   	if (!adapter->io_addr)
>   		goto err_ioremap;
>   
> +#ifdef CONFIG_PCIEAER
> +	igc_mask_aer_replay_correctible(adapter);
> +#endif
> +
> +	pci_enable_pcie_error_reporting(pdev);
> +
>   	/* hw->hw_addr can be zeroed, so use adapter->io_addr for unmap */
>   	hw->hw_addr = adapter->io_addr;
>   


Kind regards,

Paul
