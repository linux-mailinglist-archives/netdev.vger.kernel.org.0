Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C99524C33
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350875AbiELL5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344488AbiELL5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:57:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919613DA51
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3exCiv+h2ZK+KDohYB9BgQm57zZe4OY9ARRUYwOSy2M=; b=3OrcLVqWBaH+dZUVd6iufb8LaO
        Q8p1Fw9AeoozqO+7Y6l8tsCp5OIOfXk52ImJeFGsxO3wKb2CvtFSLOZeATw4GhxqKq4xBAgv8eGU2
        ek7XOpBL7PVy2vYOrWNBz11QlJvDRYGKLJpLN7jKss6I1sLzOj1lX2S6dHpyXAaNBVqk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1np7RD-002Rhq-3p; Thu, 12 May 2022 13:56:59 +0200
Date:   Thu, 12 May 2022 13:56:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 13/14] net: txgbe: Support debug filesystem
Message-ID: <Ynz2C5556V3hmP/V@lunn.ch>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
 <20220511032659.641834-14-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511032659.641834-14-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static ssize_t
> +txgbe_dbg_reg_ops_write(struct file *filp,
> +			const char __user *buffer,
> +			size_t count, loff_t *ppos)
> +{
> +	struct txgbe_adapter *adapter = filp->private_data;
> +	char *pc = txgbe_dbg_reg_ops_buf;
> +	int len;

No writing from debugfs please. It allows closed source binary blobs
in user space, rather than proper open solutions.

> +/**
> + * txgbe_dbg_adapter_init - setup the debugfs directory for the adapter
> + * @adapter: the adapter that is starting up
> + **/
> +void txgbe_dbg_adapter_init(struct txgbe_adapter *adapter)
> +{
> +	const char *name = pci_name(adapter->pdev);
> +	struct dentry *pfile;
> +
> +	adapter->txgbe_dbg_adapter = debugfs_create_dir(name, txgbe_dbg_root);
> +	if (!adapter->txgbe_dbg_adapter) {
> +		txgbe_dev_err("debugfs entry for %s failed\n", name);
> +		return;
> +	}

Don't check the return code for debugfs_XXX API calls. The API is
designed to work even when there are errors.

> +/**
> + * txgbe_dump - Print registers, tx-rings and rx-rings
> + **/
> +void txgbe_dump(struct txgbe_adapter *adapter)
> +{
> +	struct net_device *netdev = adapter->netdev;
> +	struct txgbe_hw *hw = &adapter->hw;
> +	struct txgbe_reg_info *reg_info;
> +	int n = 0;
> +	struct txgbe_ring *tx_ring;
> +	struct txgbe_tx_buffer *tx_buffer;
> +	union txgbe_tx_desc *tx_desc;
> +	struct my_u0 { u64 a; u64 b; } *u0;
> +	struct txgbe_ring *rx_ring;
> +	union txgbe_rx_desc *rx_desc;
> +	struct txgbe_rx_buffer *rx_buffer_info;
> +	u32 staterr;
> +	int i = 0;
> +
> +	if (!netif_msg_hw(adapter))
> +		return;
> +
> +	/* Print Registers */
> +	dev_info(&adapter->pdev->dev, "Register Dump\n");
> +	pr_info(" Register Name   Value\n");
> +	for (reg_info = txgbe_reg_info_tbl; reg_info->name; reg_info++)
> +		txgbe_regdump(hw, reg_info);
> +
> +	/* Print TX Ring Summary */
> +	if (!netdev || !netif_running(netdev))
> +		return;
> +
> +	dev_info(&adapter->pdev->dev, "TX Rings Summary\n");
> +	pr_info(" %s     %s              %s        %s\n",
> +		"Queue [NTU] [NTC] [bi(ntc)->dma  ]",
> +		"leng", "ntw", "timestamp");

Don't dump this sort of thing to the kernel log. The only case where
this is currently done in the kernel is for helping to find real bugs
in drivers which have broken DMA handling. There is one driver i know
of where the DMA ring will stop working, and after a timeout the ring
is dumped to see what sort of shape it is in, where the head/tail
pointers are, which descriptors are busy etc.

Does your driver have issues? Or is it production ready?

> +#ifdef CONFIG_DEBUG_FS
> +	txgbe_dbg_adapter_init(adapter);
> +#endif
>  	/* setup link for SFP devices with MNG FW, else wait for TXGBE_UP */
>  	if (txgbe_mng_present(hw) && txgbe_is_sfp(hw) &&
>  	    ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
> @@ -6618,6 +6621,10 @@ static void txgbe_remove(struct pci_dev *pdev)
>  		return;
>  
>  	netdev = adapter->netdev;
> +#ifdef CONFIG_DEBUG_FS
> +	txgbe_dbg_adapter_exit(adapter);
> +#endif
> +
>  	set_bit(__TXGBE_REMOVING, &adapter->state);
>  	cancel_work_sync(&adapter->service_task);
>  
> @@ -6703,6 +6710,10 @@ static int __init txgbe_init_module(void)
>  		return -ENOMEM;
>  	}
>  
> +#ifdef CONFIG_DEBUG_FS
> +	txgbe_dbg_init();
> +#endif
> +
>  	ret = pci_register_driver(&txgbe_driver);
>  	return ret;
>  }
> @@ -6720,6 +6731,9 @@ static void __exit txgbe_exit_module(void)
>  	pci_unregister_driver(&txgbe_driver);
>  	if (txgbe_wq)
>  		destroy_workqueue(txgbe_wq);
> +#ifdef CONFIG_DEBUG_FS
> +	txgbe_dbg_exit();
> +#endif

debugfs is designed such that you don't need all these #ifdef
CONFIG_DEBUG_FS calls. There are stubs for when it is not part of the
kernel. So just makes the calls.

In general #ifdef is not liked in C code. Try to avoid it.

	Andrew
