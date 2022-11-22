Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEAE633C73
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiKVM2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiKVM2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:28:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8929254B3C
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:28:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1D1A616CD
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E8BC433C1;
        Tue, 22 Nov 2022 12:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669120086;
        bh=kAbjs6A5Z20pI0hgvNqjFISXDXwAWdWyrv+rGHU0k4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ld4qBog7d/hM9XILgGLQbBy6+/mAXuqr0UumtxGpj0dtJ/kduLoDsiOSM2l0YCO+s
         K2bL4i6Dob05hkvN6MiVtPKfJ9IHq2lRr3EfxSlwQIGwjZ87/EgiHZ5pe59mjYt9hv
         PPv8+9WtllyK6ImlLSvCc73LZ3hjPRM0rUIpPEy+EFSLU24+tHBn2Lhpi8COnqU6P1
         7lKniPxZYFEu/SxX/ESky1BSS2HCq1wUza4S6wmqEKaRhMhdoyVjjVG099VZvWZ5bD
         h6KnyeCLCYCmDoJq2z0dOVFSgOvaC3DhmPXWhcyVrN8SjFNFGcV/stNYOi5OxEiGcF
         EbMJXhTYIr+9w==
Date:   Tue, 22 Nov 2022 14:28:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, thomas.lendacky@amd.com, shayagr@amazon.com,
        wsa+renesas@sang-engineering.com, msink@permonline.ru,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: wiznet: w5300: free irq when alloc
 link_name failed in w5300_hw_probe()
Message-ID: <Y3zAUi5phHtYkjbb@unreal>
References: <20221119071007.3858043-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119071007.3858043-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 03:10:07PM +0800, Gaosheng Cui wrote:
> When alloc link_name failed in w5300_hw_probe(), irq has not been
> freed. Fix it.
> 
> Fixes: 9899b81e7ca5 ("Ethernet driver for the WIZnet W5300 chip")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  drivers/net/ethernet/wiznet/w5300.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
> index b0958fe8111e..5571d4c365e9 100644
> --- a/drivers/net/ethernet/wiznet/w5300.c
> +++ b/drivers/net/ethernet/wiznet/w5300.c
> @@ -572,8 +572,10 @@ static int w5300_hw_probe(struct platform_device *pdev)
>  	priv->link_gpio = data ? data->link_gpio : -EINVAL;
>  	if (gpio_is_valid(priv->link_gpio)) {
>  		char *link_name = devm_kzalloc(&pdev->dev, 16, GFP_KERNEL);
> -		if (!link_name)
> +		if (!link_name) {
> +			free_irq(irq, ndev);
>  			return -ENOMEM;
> +		}
>  		snprintf(link_name, 16, "%s-link", name);
>  		priv->link_irq = gpio_to_irq(priv->link_gpio);
>  		if (request_any_context_irq(priv->link_irq, w5300_detect_link,

  579                 if (request_any_context_irq(priv->link_irq, w5300_detect_link,
  580                                 IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
  581                                 link_name, priv->ndev) < 0)
  582                         priv->link_gpio = -EINVAL;

You should call to same free_irq(irq, ndev) in this "if" too.

Thanks

> -- 
> 2.25.1
> 
