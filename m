Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35896C7DC2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjCXMLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCXMLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:11:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D666DAD1F;
        Fri, 24 Mar 2023 05:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p3XMUSLrnS/jiuxpKJ52EhVMkuEU2VI+ix52pq+MhSY=; b=zYpHKvmzQSD9efpUNZ0jTEj3qj
        Ldv/Fhy3TjpCwM2zwuy5e/hRMy/Jnfy72yx7FK1GJgnUJQCH4A5athPolK+nrUrupCyrixi18HVHT
        kdlz/tUn/9YhTVvO8jw48SK0DcJkSDcULIVuLsA6UZ1KHt2yNTBp89JQSyFoP3CPTpiI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pfgGB-008HzK-OT; Fri, 24 Mar 2023 13:11:07 +0100
Date:   Fri, 24 Mar 2023 13:11:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 4/7] mfd: ocelot-spi: Change the regmap stride to reflect
 the real one
Message-ID: <c87cd0b0-9ea4-493d-819d-217334c299dd@lunn.ch>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-5-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324093644.464704-5-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 10:36:41AM +0100, Maxime Chevallier wrote:
> When used over SPI, the register addresses needs to be translated,
> compared to when used over MMIO. The translation consists in applying an
> offset with reg_base, then downshifting the registers by 2. This
> actually changes the register stride from 4 to 1.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  drivers/mfd/ocelot-spi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> index 2d1349a10ca9..107cda0544aa 100644
> --- a/drivers/mfd/ocelot-spi.c
> +++ b/drivers/mfd/ocelot-spi.c
> @@ -124,7 +124,7 @@ static int ocelot_spi_initialize(struct device *dev)
>  
>  static const struct regmap_config ocelot_spi_regmap_config = {
>  	.reg_bits = 24,
> -	.reg_stride = 4,
> +	.reg_stride = 1,
>  	.reg_shift = REGMAP_DOWNSHIFT(2),
>  	.val_bits = 32,

This does not look like a bisectable change? Or did it never work
before?

	Andrew
