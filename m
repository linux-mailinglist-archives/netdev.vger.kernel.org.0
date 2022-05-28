Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4865369B0
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351885AbiE1B3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiE1B3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:29:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACA31271B8
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 18:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=H/t6ROs2wGPrO9D2IwI9VnRt7OlllXswmBtPyEHkAqo=; b=Ck7XvVdl7Ww68fN9GIgD3HWmPK
        pHtEv/TZSVaNXys7Wu+AxKGNr+N/HkSqv+hPAjhwM6bhf5Qt3Ji8zKrLl7Q923jJCpvJwwRyNj8kB
        OD9PyQD9IB5z87rWJouXN1dao7dwp18Ab7+lY0U3HtaQqtRGstU015vQgEmXB7KjYoUg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nulGu-004Upf-PC; Sat, 28 May 2022 03:29:40 +0200
Date:   Sat, 28 May 2022 03:29:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: txgbe: Add build support for txgbe
Message-ID: <YpF7BJOV9B+VHB7h@lunn.ch>
References: <20220527063157.486686-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527063157.486686-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +
> +err_sw_init:
> +	devm_iounmap(&pdev->dev, adapter->io_addr);

You should not need this. That is the point of the devm_ API, it gets
released automatically either when probe fails, or after the release
method is called.

> +static struct pci_driver txgbe_driver = {
> +	.name     = txgbe_driver_name,
> +	.id_table = txgbe_pci_tbl,
> +	.probe    = txgbe_probe,
> +	.remove   = txgbe_remove,
> +	.shutdown = txgbe_shutdown,
> +};
> +
> +/**
> + * txgbe_init_module - Driver Registration Routine
> + *
> + * txgbe_init_module is the first routine called when the driver is
> + * loaded. All it does is register with the PCI subsystem.
> + **/
> +static int __init txgbe_init_module(void)
> +{
> +	int ret;
> +
> +	ret = pci_register_driver(&txgbe_driver);
> +	return ret;
> +}
> +
> +module_init(txgbe_init_module);
> +
> +/**
> + * txgbe_exit_module - Driver Exit Cleanup Routine
> + *
> + * txgbe_exit_module is called just before the driver is removed
> + * from memory.
> + **/
> +static void __exit txgbe_exit_module(void)
> +{
> +	pci_unregister_driver(&txgbe_driver);
> +}

It looks like you should be able to use module_pci_driver().

   Andrew
