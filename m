Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64EC688625
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjBBSKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBBSKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:10:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350D9E3A6
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=f1U1dyLRAYG/jSAD0BOG1LvfTTbA4bdPLnt0cGIN/5c=; b=uX
        iatlx+nTgdwLaEcT7ssnwYQluA7qQ7EeWtnZJ/C0veAZZyMoz/HueEiTh82I6Jd3Hx0BVSAQiJHUa
        EPhUkwRcJ3n/IJELHX8dyNsqVa/OWMkfSuhb1w7OsTeQ+s41t0f3fGQYKOGFGdVW5/QtAjUwvr54i
        VnVGpBfwLULE8kE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNe28-003v4c-1u; Thu, 02 Feb 2023 19:10:04 +0100
Date:   Thu, 2 Feb 2023 19:10:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Valek, Andrej" <andrej.valek@siemens.com>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA mv88e6xxx_probe
Message-ID: <Y9v8fBxpO19jr9+9@lunn.ch>
References: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
 <Y9vfLYtio1fbZvfW@lunn.ch>
 <af64afe5fee14cc373511acfa5a9b927516c4d66.camel@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af64afe5fee14cc373511acfa5a9b927516c4d66.camel@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > chip->reset = devm_gpiod_get_optional(dev, "reset",
> > > > GPIOD_OUT_LOW);
> > > > if (IS_ERR(chip->reset))
> > > >         goto out;
> > > > 
> > > > if (chip->reset)
> > > >         usleep_range(1000, 2000);
> > > 
> > > So it should wait, but for what?
> > 
> > The current code is designed to take a switch held in reset out of
> > reset. It does not perform an actual reset.
> > 
> How does it then work? I see just a "devm_gpiod_get_optional" which
> just assign an pointer to "chip->reset" and then
> " if (chip->reset) usleep_range(1000, 2000);" which just waits for
> "something" ? Where is the "reset" took out? I don't see any gpio set
> to 0.

https://elixir.bootlin.com/linux/latest/source/include/linux/gpio/consumer.h#L49

	GPIOD_OUT_LOW	= GPIOD_FLAGS_BIT_DIR_SET | GPIOD_FLAGS_BIT_DIR_OUT,

https://elixir.bootlin.com/linux/latest/source/drivers/gpio/gpiolib.c#L4051

	/* Process flags */
	if (dflags & GPIOD_FLAGS_BIT_DIR_OUT)
		ret = gpiod_direction_output(desc,
				!!(dflags & GPIOD_FLAGS_BIT_DIR_VAL));
	else
		ret = gpiod_direction_input(desc);

> > If you need a real reset, you probably need to call
> > mv88e6xxx_hardware_reset(chip), not usleep().
> > 
> > However, a reset can be a slow operation, specially if the EEPROM is
> > full of stuff. So we want to avoid two resets if possible.
> > 
> > The MDIO bus itself has DT descriptions for a GPIO reset. See
> > Documentation/devicetree/bindings/net/mdio.yaml
> This looks promising. So I have to just move the "reset-gpios" DTB
> entry from switch to mdio section. But which driver handles it,
> drivers/net/phy/mdio_bus.c,

Yes.

> > mdio {
> > 	#address-cells = <1>;
> > 	#size-cells = 0>;
> while here is no compatible part... .

It does not need a compatible, because it is part of the FEC, and the
FEC has a compatible. Remember this is device tree, sometimes you need
to go up the tree towards the root to find the actual device with a
compatible.

    Andrew
