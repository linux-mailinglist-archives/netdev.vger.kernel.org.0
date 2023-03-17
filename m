Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990986BEA83
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 14:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjCQNzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 09:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCQNzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 09:55:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A0FE1A2;
        Fri, 17 Mar 2023 06:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=eC33ACaQYYAv+vtinocwyhqk7H8NHOdp/sCwnyXAa10=; b=hb
        E0g7jIY/DnDZ7+E9Xp4KFPWV/I6LZuPmsXY0+f+I9LM7v4LWbjupLhNUIFJGNnMiuYElpwU04pHub
        0t2dDVDw03GyfcH+NGYLfBoCteGFXFUlgeoKh0JqHyY1yr8Rlh6PHeAWfV1MU7T+ZaJOqZ9N0VNAJ
        HR+EKHLxI4qYnj0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdAY3-007c8f-O2; Fri, 17 Mar 2023 14:55:11 +0100
Date:   Fri, 17 Mar 2023 14:55:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v4 04/14] net: phy: Add a binding for PHY LEDs
Message-ID: <6cf03603-2a8e-4c08-a61b-aef164a0f5d9@lunn.ch>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-5-ansuelsmth@gmail.com>
 <20230317084519.12d3587a@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317084519.12d3587a@dellmb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 08:45:19AM +0100, Marek Behún wrote:
> On Fri, 17 Mar 2023 03:31:15 +0100
> Christian Marangi <ansuelsmth@gmail.com> wrote:
> 
> > +	cdev->brightness_set_blocking = phy_led_set_brightness;
> > +	cdev->max_brightness = 1;
> > +	init_data.devicename = dev_name(&phydev->mdio.dev);
> > +	init_data.fwnode = of_fwnode_handle(led);
> > +
> > +	err = devm_led_classdev_register_ext(dev, cdev, &init_data);
> 
> Since init_data.devname_mandatory is false, devicename is ignored.
> Which is probably good, becuse the device name of a mdio device is
> often ugly, taken from devicetree or switch drivers, for example:
>   f1072004.mdio-mii
>   fixed-0
>   mv88e6xxx-1
> So either don't fill devicename or use devname_mandatory (and maybe
> fill devicename with something less ugly, but I guess if we don't have
> much choice if we want to keep persistent names).
> 
> Without devname_mandatory, the name of the LED classdev will be of the
> form
>   color:function[-function-enumerator],
> i.e.
>   green:lan
>   amber:lan-1
> 
> With multiple switch ethenret ports all having LAN function, it is
> worth noting that the function enumerator must be explicitly used in the
> devicetree, otherwise multiple LEDs will be registered under the same
> name, and the LED subsystem will add a number at the and of the name
> (function led_classdev_next_name), resulting in names
>   green:lan
>   green:lan_1
>   green:lan_2
>   ...

I'm testing on a Marvell RDK, with limited LEDs. It has one LED on the
front port to represent the WAN port. The DT patch is at the end of
the series. With that, i end up with:

root@370rd:/sys/class/leds# ls -l
total 0
lrwxrwxrwx 1 root root 0 Mar 17 01:10 f1072004.mdio-mii:00:WAN -> ../../devices/platform/soc/soc:interna
l-regs/f1072004.mdio/mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:00/leds/f1072004.mdio-mii:00:WAN

I also have:

root@370rd:/sys/class/net/eth0/phydev/leds# ls
f1072004.mdio-mii:00:WAN

f1072004.mdio-mii:00: is not nice, but it is unique to a netdev. The
last part then comes from the label property. Since there is only one
LED, i went with what the port is intended to be used as. If there had
been more LEDs, i would of probably used labels like "LINK" and
"ACTIVITY", since that is often what they reset default
to. Alternatively, you could names the "Left" and "Right", which does
suggest they can be given any function.

I don't actually think the name is too important, so long as it is
unique. You are going to find it via /sys/class/net. MAC LEDs should
be /sys/class/net/eth42/leds, and PHY LEDs will be
/sys/class/net/phydev/leds.

It has been discussed in the past to either extend ethtool to
understand this, or write a new little tool to make it easier to
manipulate these LEDs.

	   Andrew

