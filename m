Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DF66C7E44
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjCXMsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCXMsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:48:23 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A5C1FCB;
        Fri, 24 Mar 2023 05:48:21 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 69CDC1BF213;
        Fri, 24 Mar 2023 12:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679662100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=beaHYk4b0xIx4JQCeJ7Rbi2htRk2mvqoOU7MSS3WMFQ=;
        b=meJLw8pRvEt5Bjnjc80nXyhHpSx7o5W5tDHkHTuVYKroWjc+P/JxZ+WtM7bwY1VXG3Ghbd
        i+M2JV/fF8rzneIR1UlnTGQfcOz2zVB1sHWNXCxdBizMBgerzwjPKer/mhV1O27R7uQv1q
        9c88Om74IGAMeXbllBsBzp78r/G8g/zKxyJhAeMy+bKaKOe+uLMeoN4EHLbu6vXuuTFA79
        2EccSWSi39cxdQ/MCZabLDAxfx6oPatHZKt5LQJSi0oCK/HNIHgAv0MUcIG/TjeQdCq4Hf
        7VpHSn2UhttLB8zXjb3FF1uUSHmm9nH3RfGTx/+5EPGNqlscf6TS78EwPjK15A==
Date:   Fri, 24 Mar 2023 13:48:17 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20230324134817.50358271@pc-7.home>
In-Reply-To: <c87cd0b0-9ea4-493d-819d-217334c299dd@lunn.ch>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
        <20230324093644.464704-5-maxime.chevallier@bootlin.com>
        <c87cd0b0-9ea4-493d-819d-217334c299dd@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On Fri, 24 Mar 2023 13:11:07 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, Mar 24, 2023 at 10:36:41AM +0100, Maxime Chevallier wrote:
> > When used over SPI, the register addresses needs to be translated,
> > compared to when used over MMIO. The translation consists in
> > applying an offset with reg_base, then downshifting the registers
> > by 2. This actually changes the register stride from 4 to 1.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > ---
> >  drivers/mfd/ocelot-spi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > index 2d1349a10ca9..107cda0544aa 100644
> > --- a/drivers/mfd/ocelot-spi.c
> > +++ b/drivers/mfd/ocelot-spi.c
> > @@ -124,7 +124,7 @@ static int ocelot_spi_initialize(struct device
> > *dev) 
> >  static const struct regmap_config ocelot_spi_regmap_config = {
> >  	.reg_bits = 24,
> > -	.reg_stride = 4,
> > +	.reg_stride = 1,
> >  	.reg_shift = REGMAP_DOWNSHIFT(2),
> >  	.val_bits = 32,  
> 
> This does not look like a bisectable change? Or did it never work
> before?

Actually this works in all cases because of "regmap: check for alignment
on translated register addresses" in this series. Before this series,
I think using a stride of 1 would have worked too, as any 4-byte-aligned
accesses are also 1-byte aligned.

But that's also why I need review on this, my understanding is that
reg_stride is used just as a check for alignment, and I couldn't test
this ocelot-related patch on the real HW, so please take it with a
grain of salt :(

Thanks,

Maxime

> 	Andrew

