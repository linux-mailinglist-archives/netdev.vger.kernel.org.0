Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7603160C27F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJYELv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJYELv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:11:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDAE12D81D
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B18661725
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C3BC433D7;
        Tue, 25 Oct 2022 04:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666671109;
        bh=b4mQY3lSXKjjuWMSHM9R8VzxKEhbAWIvb4GUDvasR4o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WFy1qtamnkxf5HC/ZvLGh0WKoYt3nhlHzZJk/0WEvYKwcxkBFvPgZBhuom6VhN8jg
         5+8MJ5mZeX7QngEfwZKP70GeOdsXnr4Lb9zpFMuz1yJl604NXz1JwfUwbnG+ogD6pr
         +fKV0yB7gDd/gIyPbrlYq/y3jaAo7KW1njupzlr5Kk0nBoIXQyJvw7kTWk2u21Fq08
         CvXriCm7Rm39VWbcG7mwbPKBTRF88wSpAZby5Q2okm9ihA7WsXzK0iwLQh5r4ezgvn
         ok9NtlvwH1pbePQqq+O9NtTU9A9RK9IvY99mSGDd5e3RL8U0nvWTYV6tmEc4KpwWBE
         CNguWREQePb1A==
Date:   Mon, 24 Oct 2022 21:11:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] net: natsemi: xtsonic: switch to use
 platform_get_irq()
Message-ID: <20221024211148.6522caac@kernel.org>
In-Reply-To: <20221025031236.1031330-1-yangyingliang@huawei.com>
References: <20221025031236.1031330-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 11:12:35 +0800 Yang Yingliang wrote:
> Switch to use platform_get_irq() which supports more cases.

More cases of what? You need to explain what you're trying to achieve
and why you're touching this old driver.

> diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
> index 52fef34d43f9..ffb3814c54cb 100644
> --- a/drivers/net/ethernet/natsemi/xtsonic.c
> +++ b/drivers/net/ethernet/natsemi/xtsonic.c
> @@ -201,14 +201,17 @@ int xtsonic_probe(struct platform_device *pdev)
>  {
>  	struct net_device *dev;
>  	struct sonic_local *lp;
> -	struct resource *resmem, *resirq;
> +	struct resource *resmem;
> +	int irq;
>  	int err = 0;

The variable declaration lines should be sorted longest to shortest.

>  	if ((resmem = platform_get_resource(pdev, IORESOURCE_MEM, 0)) == NULL)
>  		return -ENODEV;
>  
> -	if ((resirq = platform_get_resource(pdev, IORESOURCE_IRQ, 0)) == NULL)
> -		return -ENODEV;
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
>  

extra new line
