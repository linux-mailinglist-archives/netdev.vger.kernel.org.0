Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3056B28BE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjCIPXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjCIPX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:23:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3489EF16AB;
        Thu,  9 Mar 2023 07:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TZtnq4ErD6+p46J1xiQAutyT1OfQ3UHS3Utv9OsbD3k=; b=4u643A2Y3jE+yVdrqGMaYCOOLt
        pUoE/QBgVG8HivDUgvuxodEqXCK/29gfplEGQEf/qEFBYL8Ii/Tir4i9ovOxmF8wVWYwl0TW0weqA
        ygUG5e8884d5Ik+oAh26XdFyioQdTjOlFbjCA44mXbPUSidZwDRvcnL5pPeD8JZqv7OQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paI63-006t3h-Ua; Thu, 09 Mar 2023 16:22:23 +0100
Date:   Thu, 9 Mar 2023 16:22:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v8 00/13] Adds support for PHY LEDs with offload triggers
Message-ID: <8226f000-dd9c-4774-b972-a7f1113f0986@lunn.ch>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <CACRpkda30Ky5oYPn_nGWGOzT5ntZYdE3gafrs7D27ZHxgGuO8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda30Ky5oYPn_nGWGOzT5ntZYdE3gafrs7D27ZHxgGuO8A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am a bit reluctant on the ambition to rely on configuration from sysfs
> for the triggers, and I am also puzzled to how a certain trigger on a
> certain LED is going to associate itself with, say, a certain port.

Hi Linus

There will need to be a device tree binding for the default
trigger. That is what nearly all the rejected hacks so far have been
about, write registers in the PHYs LEDs registers to put it into a
specific mode. I don't see that part of the overall problem too
problematic, apart from the old issue, is it describing configuration,
not hardware.

As to 'how a certain trigger on a certain LED is going to associate
itself with, say, a certain port' is clearly a property of the
hardware, when offloading is supported. I've not seen a switch you can
arbitrarily assign LEDs to ports. The Marvell switches have the LED
registers within the port registers, for example, two LEDs per port.

> 
> I want to draw your attention to this recently merged patch series
> from Hans de Goede:
> https://lore.kernel.org/linux-leds/20230120114524.408368-1-hdegoede@redhat.com/
> 
> This adds the devm_led_get() API which works similar to getting
> regulators, clocks, GPIOs or any other resources.

Interesting. Thanks for pointing this out. But i don't think it is of
interest in our use case, which is hardware offload. For a purely
software controlled LED, where the LED could be anywhere,
devm_led_get() makes sense. But in our case, the LED is in a well
defined place, either the MAC or the PHY, where it has access to the
RX and TX packets, link status etc. So we don't have the problem of
finding it in an arbitrary location.

There is also one additional problem we have, both for MAC and PHY
LEDs. The trigger is ledtrig-netdev. All trigger state revolves around
a netdev. A DSA port is not a netdev. A PHY is not a netdev. Each of
these three things have there own life cycle. Often, a PHY does not
know what netdev it is associated to until the interface is opened,
ie. ip link set eth0 up. But once it is associated, phylib knows this
information, so can return it, without any additional configuration
data in DT. A DSA switch port can be created before the netdev
associated to it is created. But again, the DSA core does know the
mapping between a netdev and a port. Using devm_led_get() does not
gain us anything.

	Andrew
