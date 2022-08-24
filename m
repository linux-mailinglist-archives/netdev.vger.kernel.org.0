Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFA25A0244
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbiHXTry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbiHXTrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:47:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B2179ED1;
        Wed, 24 Aug 2022 12:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cliv8fOIUE97X2LZJl8OSkONVdBjqeQgsQroJzWn400=; b=wN3w5NUgq41D/YUu/EkW7FPwjJ
        woYC+U1ES1nXR04yaNs/qiws1a53aHRx2t4frvxmzV1hxQqjEeMwwh3dBvOQebSFyv/XZPHYROABs
        Jy3wKUIBoMNyZAX0lxBzbRwgqsEopF4qo6+lF2id3YzFRnsSu52N6ijCso9H8hEjpAW4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQwLs-00ETnd-95; Wed, 24 Aug 2022 21:47:48 +0200
Date:   Wed, 24 Aug 2022 21:47:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael@walle.cc, UNGLinuxDriver@microchip.com,
        maxime.chevallier@bootlin.com
Subject: Re: [PATCH net] net: phy: micrel: Make the GPIO to be non-exclusive
Message-ID: <YwaAZAXcXhGmu7r9@lunn.ch>
References: <20220824192827.437095-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824192827.437095-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 09:28:27PM +0200, Horatiu Vultur wrote:
> The same GPIO line can be shared by multiple phys for the coma mode pin.
> If that is the case then, all the other phys that share the same line
> will failed to be probed because the access to the gpio line is not
> non-exclusive.
> Fix this by making access to the gpio line to be nonexclusive using flag
> GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
> probed.
> 
> Fixes: 738871b09250ee ("net: phy: micrel: add coma mode GPIO")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index e78d0bf69bc3..ea72ff64ad33 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -2878,7 +2878,8 @@ static int lan8814_release_coma_mode(struct phy_device *phydev)
>  	struct gpio_desc *gpiod;
>  
>  	gpiod = devm_gpiod_get_optional(&phydev->mdio.dev, "coma-mode",
> -					GPIOD_OUT_HIGH_OPEN_DRAIN);
> +					GPIOD_OUT_HIGH_OPEN_DRAIN |
> +					GPIOD_FLAGS_BIT_NONEXCLUSIVE);

I would suggest putting a comment here. You are assuming the driver
never gains a lan8814_take_coma_mode() when the PHY is put into
suspend, since it sounds like that will put all PHYs on the shared
GPIO into coma mode.

     Andrew
