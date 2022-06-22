Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431E8554251
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357060AbiFVFh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354898AbiFVFhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:37:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C7136331
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8236E61984
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA9DC3411B;
        Wed, 22 Jun 2022 05:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655876237;
        bh=ZqFqsNDhAdywcQQ++ai5pXiCaGFruC5Qkh112gL41Zw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dngNeoWWMJL0OJYalFSlc/t/vmi/tTTZAORDRRhsyhHSIDm+ghQftorGgoBDSO4jD
         9pFu7dL07YjKetoNq7bgcpTd3pvz59rTO5ZkagI1i/fiMl7M/i1mDXERY1SDVlUP2Y
         OekoubJGsXp7LkK8JWfi601uBMq/qZc6jJgwM+QkVDTM+YTwP36SF6oSVPtbzsNaSW
         u3PWnfVWkG2W7GjlofBZ34/K2yiX3JYU4VtoSJc8HtTMhXQ2AomGMFsSN7z9ZnYzuP
         bf/FXquZzZxCPZ/fcgq9J8AAltTe75bvi7A2MyIc3jgF2GeNraelMMnouQV1VUgKSn
         uOvIjHyP+6pSg==
Date:   Tue, 21 Jun 2022 22:37:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v7] net: txgbe: Add build support for txgbe
Message-ID: <20220621223716.5b936d93@kernel.org>
In-Reply-To: <20220621023209.599386-1-jiawenwu@trustnetic.com>
References: <20220621023209.599386-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jun 2022 10:32:09 +0800 Jiawen Wu wrote:
> +	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
> +	    !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
> +		pci_using_dac = 1;

dma_set_mask_and_coherent() ...

> +	} else {
> +		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));

... but really this entire dance is unnecessary. Please see commit
c38f30683956 ("vmxnet3: Remove useless DMA-32 fallback configuration")
for references to why that's the case.

> +		if (err) {
> +			err = dma_set_coherent_mask(&pdev->dev,
> +						    DMA_BIT_MASK(32));
> +			if (err) {
> +				dev_err(&pdev->dev,
> +					"No usable DMA configuration, aborting\n");
> +				goto err_dma;
> +			}
> +		}
> +		pci_using_dac = 0;
> +	}
> +
> +	err = pci_request_selected_regions(pdev,
> +					   pci_select_bars(pdev, IORESOURCE_MEM),
> +					   txgbe_driver_name);
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"pci_request_selected_regions failed 0x%x\n", err);
> +		goto err_dma;
> +	}
> +
> +	pci_enable_pcie_error_reporting(pdev);
> +	pci_set_master(pdev);
> +
> +	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
> +					 sizeof(struct txgbe_adapter),
> +					 TXGBE_MAX_TX_QUEUES,
> +					 TXGBE_MAX_RX_QUEUES);
> +	if (!netdev) {
> +		err = -ENOMEM;
> +		goto err_alloc_etherdev;
> +	}
> +
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +
> +	adapter = netdev_priv(netdev);
> +	adapter->netdev = netdev;
> +	adapter->pdev = pdev;
> +
> +	adapter->io_addr = devm_ioremap(&pdev->dev,
> +					pci_resource_start(pdev, 0),
> +					pci_resource_len(pdev, 0));
> +	if (!adapter->io_addr) {
> +		err = -EIO;
> +		goto err_alloc_etherdev;

See, now this jumps to err_alloc_etherdev which I can't wrap my head
around. Please name the labels after the target, not the source...

> +	}
> +
> +	if (pci_using_dac)
> +		netdev->features |= NETIF_F_HIGHDMA;
> +
> +	pci_set_drvdata(pdev, adapter);
> +
> +	return 0;
> +
> +err_alloc_etherdev:

... so for example:

err_pci_release_regions:

> +	pci_release_selected_regions(pdev,
> +				     pci_select_bars(pdev, IORESOURCE_MEM));
> +err_dma:

and

err_pci_disable_dev:

> +	pci_disable_device(pdev);
> +	return err;
