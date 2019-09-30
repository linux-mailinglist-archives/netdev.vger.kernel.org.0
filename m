Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A078C1B27
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 07:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfI3Fxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 01:53:42 -0400
Received: from first.geanix.com ([116.203.34.67]:53610 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729404AbfI3Fxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 01:53:42 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id E200884AA1;
        Mon, 30 Sep 2019 05:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1569822770; bh=niD5nD50+iOGRz2jnywfyDGaPYO8I26JFN732h/5CHc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=kPacu2epjfTFZebPkNP8lk28FTPSP+Z3EyKbHemXEy32anQrQGd80mbz7d0L5O2o6
         rXGyGNKWNgbObmxUyG/uVfjTR9sxZM7wwdhLJUcD3TWAQzXvoluq5TrfBJVcWIr37w
         8lGXKS3w/ZD22G6fFSON1b9TNvgDs/DiFvFv6E7q/zbTEmq/r6WceX/UtIH0rytcXS
         kOTTN+yspd7bQ5BCjwBFYXr/Ll3he83b6fePI2HENoHnVAfgv7rsTIgMSLyAR3lSKA
         y7YbuKpFaFSmY4nesoqZ8CX5tFhdJZEBJNo0Achk5srcvrCHjtBfgqM55JMTXqU+O9
         m5yv7GNJLvrvQ==
Subject: Re: [PATCH] can: flexcan: use devm_platform_ioremap_resource() to
 simplify code
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20190929082854.11952-1-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <542c7e8a-ed76-70db-36ff-f46e8de71d77@geanix.com>
Date:   Mon, 30 Sep 2019 07:53:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190929082854.11952-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=disabled
        version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b8b5098bc1bc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/09/2019 10.32, Joakim Zhang wrote:
> Use the new helper devm_platform_ioremap_resource() which wraps the
> platform_get_resource() and devm_ioremap_resource() together to simplify
> the code.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
> ---
>   drivers/net/can/flexcan.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index b3edaf6a5a61..3cfa6037f03c 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -1507,7 +1507,6 @@ static int flexcan_probe(struct platform_device *pdev)
>   	struct net_device *dev;
>   	struct flexcan_priv *priv;
>   	struct regulator *reg_xceiver;
> -	struct resource *mem;
>   	struct clk *clk_ipg = NULL, *clk_per = NULL;
>   	struct flexcan_regs __iomem *regs;
>   	int err, irq;
> @@ -1538,12 +1537,11 @@ static int flexcan_probe(struct platform_device *pdev)
>   		clock_freq = clk_get_rate(clk_per);
>   	}
>   
> -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	irq = platform_get_irq(pdev, 0);
>   	if (irq <= 0)
>   		return -ENODEV;
>   
> -	regs = devm_ioremap_resource(&pdev->dev, mem);
> +	regs = devm_platform_ioremap_resource(pdev, 0);
>   	if (IS_ERR(regs))
>   		return PTR_ERR(regs);
>   
> 
