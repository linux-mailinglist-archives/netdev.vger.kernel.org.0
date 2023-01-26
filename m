Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D9467D3B6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjAZSDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjAZSC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:02:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21C323320;
        Thu, 26 Jan 2023 10:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2fn1f2DBGOfmVNObvGAqQdKxfCARW6QU6WUMMysdb0A=; b=6IUr4h54isdqRSgXZ+fIMyiapA
        Ld5fGDkEMhmPEPHdAIQopdowK5Gx0iyzrdFwATryqkSfNz2OqNtlvxkE//VUSXwd+di0I8eNtPMKX
        IAjYjni1HbAvvLg3iLk9TjRjTvpwCyBwsSvbfWFAe1cqpjVWGipNoBaZVRqXOiiFxL9A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pL6a9-003GdB-3T; Thu, 26 Jan 2023 19:02:41 +0100
Date:   Thu, 26 Jan 2023 19:02:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Wei Fang <wei.fang@nxp.com>, linux-gpio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fec: convert to gpio descriptor
Message-ID: <Y9LAQRjb6h+ynXBZ@lunn.ch>
References: <20230126135339.3488682-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126135339.3488682-1-arnd@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 02:52:58PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver can be trivially converted, as it only triggers the gpio
> pin briefly to do a reset, and it already only supports DT.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 25 ++++++++++-------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 5ff45b1a74a5..dee2890fd702 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -56,7 +56,7 @@
>  #include <linux/fec.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> -#include <linux/of_gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <linux/regulator/consumer.h>
> @@ -4035,7 +4035,8 @@ static int fec_enet_init(struct net_device *ndev)
>  #ifdef CONFIG_OF
>  static int fec_reset_phy(struct platform_device *pdev)
>  {
> -	int err, phy_reset;
> +	int err;
> +	struct gpio_desc *phy_reset;
>  	bool active_high = false;
>  	int msec = 1, phy_post_delay = 0;
>  	struct device_node *np = pdev->dev.of_node;

Hi Arnd

netdev drivers are supposed to use 'reverse Christmas tree'. It looks
like this function is actually using 'Christmas tree' :-) Please could
you keep with the current coding style.

> @@ -4048,12 +4049,6 @@ static int fec_reset_phy(struct platform_device *pdev)
>  	if (!err && msec > 1000)
>  		msec = 1;
>  
> -	phy_reset = of_get_named_gpio(np, "phy-reset-gpios", 0);
> -	if (phy_reset == -EPROBE_DEFER)
> -		return phy_reset;
> -	else if (!gpio_is_valid(phy_reset))
> -		return 0;
> -
>  	err = of_property_read_u32(np, "phy-reset-post-delay", &phy_post_delay);
>  	/* valid reset duration should be less than 1s */
>  	if (!err && phy_post_delay > 1000)
> @@ -4061,11 +4056,13 @@ static int fec_reset_phy(struct platform_device *pdev)
>  
>  	active_high = of_property_read_bool(np, "phy-reset-active-high");
>  
> -	err = devm_gpio_request_one(&pdev->dev, phy_reset,
> -			active_high ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
> -			"phy-reset");
> -	if (err) {
> -		dev_err(&pdev->dev, "failed to get phy-reset-gpios: %d\n", err);
> +	phy_reset = devm_gpiod_get(&pdev->dev, "phy-reset",
> +			active_high ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW);
> +	if (IS_ERR(phy_reset)) {
> +		err = PTR_ERR(phy_reset);
> +		if (err != -EPROBE_DEFER)
> +			dev_err(&pdev->dev,
> +				"failed to get phy-reset-gpios: %d\n", err);

dev_err_probe() looks usable here.

		Andrew
