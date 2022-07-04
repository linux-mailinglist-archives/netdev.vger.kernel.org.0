Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA8F564F45
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiGDIF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiGDIF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:05:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF157AE6B;
        Mon,  4 Jul 2022 01:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7GygIGXSxd6G3xyvobd2JqTIHJupQX3Y87RpFsQ4vZE=; b=wTE5Tj5gEMqfk1bsGMtyh1A8nu
        RjUCm3MRYXUEyXKEIFtB6rcKYnKcUSRWqGWQKW8rFu2Ksh1vJYNlhKiy5cIT8TAYw/vbISJ9wM4iU
        M2awCTocsP9EnPLMbRg3EwhNxTdeQOGBBD1fA0c7EYWhlyegs3G4haf+Ob67xhZBvLl8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o8H5H-009G8M-Fv; Mon, 04 Jul 2022 10:05:31 +0200
Date:   Mon, 4 Jul 2022 10:05:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [PATCH] net: phy: mdio: add clock support for PHYs
Message-ID: <YsKfSxSVQX8JyzmY@lunn.ch>
References: <20220704004533.17762-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704004533.17762-1-andre.przywara@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mdiobus_register_clock(struct mdio_device *mdiodev)
> +{
> +	struct clk *clk;
> +
> +	clk = devm_clk_get_optional(&mdiodev->dev, NULL);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);

How does this interact with the clock code of the micrel and smsc
drivers?

Please document this clock in the binding, ethernet-phy.yaml.

> diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
> index 250742ffdfd9..e8424a46a81e 100644
> --- a/drivers/net/phy/mdio_device.c
> +++ b/drivers/net/phy/mdio_device.c
> @@ -6,6 +6,7 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/errno.h>
>  #include <linux/gpio.h>
> @@ -136,6 +137,14 @@ void mdio_device_reset(struct mdio_device *mdiodev, int value)
>  }
>  EXPORT_SYMBOL(mdio_device_reset);
>  
> +static void mdio_device_toggle_clock(struct mdio_device *mdiodev, int value)

Not sure this is the best name, you are not toggling the clock, you
are toggling the clock gate. And you are not really toggling it, since
you pass value.

    Andrew
