Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFF759908B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344328AbiHRW3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbiHRW3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:29:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D9DD9E84
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DWCsOlDBiqc1I9PXioA8e/h8QGwr93p5upk5bktoJ6w=; b=1Hc4jfQRia3Aq54aManZFkx4ps
        AvFdOLY3rJkk6ZpAKw3++aMnsd8pmiR37i0J9h/8VIT2XH5jTzEVJHGKSnnE5ekWOVsDkOOv6KPII
        ivabH1VF1KEjO6gN7yQnSk/Wzh4iuwCw12fIIr18lPsxJ3HOSPmviNfmMVrYKsK6DFYE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOo0u-00Dqsx-1S; Fri, 19 Aug 2022 00:29:20 +0200
Date:   Fri, 19 Aug 2022 00:29:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Subject: Re: [RFC PATCH net-next] net: ngbe: Add build support for ngbe
Message-ID: <Yv69QNVsCVeCMdjf@lunn.ch>
References: <20220816075331.22084-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816075331.22084-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ngbe_probe(struct pci_dev *pdev,
> +		      const struct pci_device_id __always_unused *ent)
> +{
> +	struct ngbe_adapter *adapter = NULL;
> +	struct net_device *netdev;
> +	int err;
> +
> +	err = pci_enable_device_mem(pdev);
> +	if (err)
> +		return err;
> +
> +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"No usable DMA configuration, aborting\n");
> +		goto err_pci_disable_dev;
> +	}
> +
> +	err = pci_request_selected_regions(pdev,
> +					   pci_select_bars(pdev, IORESOURCE_MEM),
> +					   ngbe_driver_name);
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"pci_request_selected_regions failed 0x%x\n", err);
> +		goto err_pci_disable_dev;
> +	}

nitpick: Since include/linux/errno.h uses decimal, i think it would be
better to print the error code in decimal. 

Otherwise this looks pretty good.

	  Andrew
