Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8044AF5EB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiBIQBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiBIQB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:01:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F458C0613C9;
        Wed,  9 Feb 2022 08:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ra5g0T3VlzyA5hCnuk9FntM7LL+ZGOWg6+oMRbHNWkc=; b=Iw16vNAv331p3QhwXKA/Y5jSnU
        2EWE3WfzfluRcc0mWKd+FYLFE3lVMz+FSzerwULtiCXRshj2prdjHSpTbzf1JdvAZUXIRJ3dSFr2f
        HeoI0FWxbPZXDyVtJI7et2hiumJrld1+QUIC/dPWvbyY7HG5FC/FXNaTR3HqYj5j4TWU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHpPI-00596C-Dq; Wed, 09 Feb 2022 17:01:24 +0100
Date:   Wed, 9 Feb 2022 17:01:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mans Rullgard <mans@mansr.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: fix reset on probe
Message-ID: <YgPlVGclJOkvLZ1i@lunn.ch>
References: <20220209145454.19749-1-mans@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209145454.19749-1-mans@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 02:54:54PM +0000, Mans Rullgard wrote:
> The reset input to the LAN9303 chip is active low, and devicetree
> gpio handles reflect this.  Therefore, the gpio should be requested
> with an initial state of high in order for the reset signal to be
> asserted.  Other uses of the gpio already use the correct polarity.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---
>  drivers/net/dsa/lan9303-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index aa1142d6a9f5..2de67708bbd2 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1301,7 +1301,7 @@ static int lan9303_probe_reset_gpio(struct lan9303 *chip,
>  				     struct device_node *np)
>  {
>  	chip->reset_gpio = devm_gpiod_get_optional(chip->dev, "reset",
> -						   GPIOD_OUT_LOW);
> +						   GPIOD_OUT_HIGH);
>  	if (IS_ERR(chip->reset_gpio))
>  		return PTR_ERR(chip->reset_gpio);

lan9303_handle_reset() does a sleep and then releases the reset. I
don't see anywhere in the driver which asserts the reset first. So is
it actually asserted as part of this getting the GPIO? And if so, does
not this change actually break the reset?

    Andrew
