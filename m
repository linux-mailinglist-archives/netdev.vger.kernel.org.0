Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05D062B253
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiKPE24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKPE2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:28:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3324B13F79;
        Tue, 15 Nov 2022 20:28:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D893DB81AC8;
        Wed, 16 Nov 2022 04:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6EFC433D6;
        Wed, 16 Nov 2022 04:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668572932;
        bh=9PS1GRX3KmLc2cLNj7ATROrNzp/1leY/k9Vq8TaXn5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r/CH5dZqqzGWktUIF4lTMCKVvdRTMb7/rDg/5V3xeSGoBFdhDL4iNwakcixERgZAw
         cgIvo+k7T46lVJZyAabTxsBlUSAA2Ee4Qos4JERpRoXHvIP5ROejF9T0WYBnehIrEe
         8+PdNIhQpnk5QnI7JfTNuLZ1swqAPvVnb4v/zrE+qvz3X644dcGrHr2mod+0015Pkq
         Gyj45+lvMPi81h+kWGNpF/mfyXxK6XyjEl9N9UKkCk8faq4KqpGXzK69h0pJP31RN7
         LSBfiiJOxG3wN2H20fIrIqw2xHsACqCJpG7Uk9xboOhgVZs73+f0NcSgClbyyLMPmh
         Fo9Ir+IHlJE4A==
Date:   Tue, 15 Nov 2022 20:28:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <mw@semihalf.com>,
        <linux@armlinux.org.uk>, <leon@kernel.org>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
Subject: Re: [PATCH net v4] net: mvpp2: fix possible invalid pointer
 dereference
Message-ID: <20221115202850.7beeea87@kernel.org>
In-Reply-To: <20221116021437.145204-1-tanghui20@huawei.com>
References: <20221116020617.137247-1-tanghui20@huawei.com>
        <20221116021437.145204-1-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 10:14:37 +0800 Hui Tang wrote:
> It will cause invalid pointer dereference to priv->cm3_base behind,
> if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().
> 
> Fixes: a59d354208a7 ("net: mvpp2: enable global flow control")
> Signed-off-by: Hui Tang <tanghui20@huawei.com>

Please do not repost new versions so often:

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#tl-dr

do not use --in-reply-to

> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index d98f7e9a480e..efb582b63640 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -7349,6 +7349,7 @@ static int mvpp2_get_sram(struct platform_device *pdev,
>  			  struct mvpp2 *priv)
>  {
>  	struct resource *res;
> +	void __iomem *base;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
>  	if (!res) {
> @@ -7359,9 +7360,11 @@ static int mvpp2_get_sram(struct platform_device *pdev,
>  		return 0;
>  	}
>  
> -	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (!IS_ERR(base))
> +		priv->cm3_base = base;
>  
> -	return PTR_ERR_OR_ZERO(priv->cm3_base);
> +	return PTR_ERR_OR_ZERO(base);

Use the idiomatic error handling, keep success path un-indented:

	ptr = function();
	if (IS_ERR(ptr))
		return PTR_ERR(ptr);

	priv->bla = ptr;
	return 0;
	

