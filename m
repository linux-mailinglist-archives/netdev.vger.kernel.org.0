Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0227C6B4B96
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbjCJPrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbjCJPrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:47:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999C2F6022;
        Fri, 10 Mar 2023 07:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ubonWFxei1BSJBCpzuPCTlOng9woXvk00b8UzkkOn8s=; b=L8Pz1A9cZZFsBjeAtMHtcCUw3r
        vQSaSGju5MJBB8U5AYCpSun9Kdtwd84Gh2ehNPewetlMpwneK/2C8mATI1ANXczFA1lcIAE36Z4qg
        d2RfzdLQoqC3TWrLbzacEUZhr8nvS0BNMOXtv88yN2U11r/JpcgE4SVUYTsTvzTb4qDM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paeSU-006zGA-G5; Fri, 10 Mar 2023 16:15:02 +0100
Date:   Fri, 10 Mar 2023 16:15:02 +0100
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
Message-ID: <576d57cb-481c-46ba-9e3b-d3b7e3a4ec69@lunn.ch>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <CACRpkda30Ky5oYPn_nGWGOzT5ntZYdE3gafrs7D27ZHxgGuO8A@mail.gmail.com>
 <8226f000-dd9c-4774-b972-a7f1113f0986@lunn.ch>
 <CACRpkdapuk39vcdNhmsMN0tbTPTSYUgY9r+EBJ-O+v2dsB=wNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdapuk39vcdNhmsMN0tbTPTSYUgY9r+EBJ-O+v2dsB=wNA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 10:37:25AM +0100, Linus Walleij wrote:
> On Thu, Mar 9, 2023 at 4:22 PM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > As to 'how a certain trigger on a certain LED is going to associate
> > itself with, say, a certain port' is clearly a property of the
> > hardware, when offloading is supported. I've not seen a switch you can
> > arbitrarily assign LEDs to ports. The Marvell switches have the LED
> > registers within the port registers, for example, two LEDs per port.
> 
> Aha so there is an implicit HW dependency between the port and the
> LED, that we just cannot see in the device tree. Okay, it makes sense.

Well, i would say the dependency is in the device tree, in that the
LEDs are described in the ports, not as a block of their own at a
higher level within the switch. And in some switches, they might
actually be a block of registers in there own space, rather than in
the port registers. But i still expect there is a fixed mapping
between LED and port.

> I think there will be a day when a switch without LED controller appears,
> but the system has a few LEDs for the ports connected to an
> arbitrary GPIO controller, and then we will need this. But we have
> not seen that yet :)

The microchip sparx5 might be going in that direction. It has what
looks like a reasonably generic sgpio controller:
drivers/pinctrl/pinctrl-microchip-sgpio.c

But this not just about switches. It is also plain NICs. And using
ledtrig-netdev, you could make your keyboard LED blink based on
network traffic etc. So yes, using a phandle to an LED could very well
be useful in the future.

   Andrew
