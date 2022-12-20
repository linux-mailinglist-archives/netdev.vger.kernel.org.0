Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACA96529A3
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 00:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiLTXLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 18:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLTXLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 18:11:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834E7BC2;
        Tue, 20 Dec 2022 15:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=H+syPNoxSkSUhg/ESgG9XpHDiX6tgXxdYU9tU+g5JW4=; b=tljLNCO2qtu4hke0pxGKosR0v+
        0dCr4/noa5t7/Jqg2s9PWmBO/7IcBx8UHnaGRckrcZmL6hTcT/a1GGTDNOhKHLALk43IJ5kTsTDcq
        NYQ+OHHlPluhTbiaG0JAjEHLZjO4+3G2uG8K5U6/MSSD/6q6zEkC7auF+COisq3ERzws=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7llS-00086B-33; Wed, 21 Dec 2022 00:11:14 +0100
Date:   Wed, 21 Dec 2022 00:11:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 10/11] net: dsa: qca8k: add LEDs support
Message-ID: <Y6JBEigWvh6if/Qe@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-11-ansuelsmth@gmail.com>
 <Y5teRQ5mv1aTix4w@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5teRQ5mv1aTix4w@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +qca8k_cled_trigger_offload(struct led_classdev *ldev, bool enable)
> > +{
> > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > +
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +	u32 val = QCA8K_LED_ALWAYS_OFF;
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	if (enable)
> > +		val = QCA8K_LED_RULE_CONTROLLED;
> > +
> > +	return regmap_update_bits(priv->regmap, reg_info.reg,
> > +				  GENMASK(1, 0) << reg_info.shift,
> > +				  val << reg_info.shift);
> 
> 88e151x doesn't have the ability to change in this way - we have
> a register with a 4-bit field which selects the LED mode from one
> of many, or forces the LED on/off/hi-z/blink.
> 
> Not specifically for this patch, but talking generally about this
> approach, the other issue I forsee with this is that yes, 88e151x has
> three LEDs, but the LED modes are also used to implement control
> signals (e.g., on a SFP, LOS can be implemented by programming mode
> 0 on LED2 (which makes it indicate link or not.) If we expose all the
> LEDs we run the risk of the LED subsystem trampling over that
> configuration and essentially messing up such modules. So the Marvell
> PHY driver would need to know when it is appropriate to expose these
> things to the LED subsystem.
> 
> I guess doing it dependent on firmware description as you do in
> this driver would work - if there's no firmware description, they're
> not exposed.
> 

I expect there will always be some sort of firmware involved,
describing the hardware. Without that, we have no idea how many LEDs
are actually connected to pins of the PHY, for example.

I've not yet looked at this patchset in detail, but i hope the DT
binding code is reusable, so all PHYs will have the same basic
binding.

    Andrew
