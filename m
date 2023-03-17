Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58426BED95
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCQQCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCQQCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:02:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1271A4741D;
        Fri, 17 Mar 2023 09:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8jvxC/cI3fuMCxuOzLp5kkLkPCuNIeHm7MIIEgtYwp0=; b=QhENWArrtirPbhzhLN30jRAefc
        lz8GpWMl3QuOk6oBP0IsKB5XWyFBxKy09l3Nw0LaoTIA14YELZMINqf23Su8H5fqRgm8TbsZX0pPr
        SUTaEqmDdOFsWkLazi3MEIkn5UJu/YeAlYXezAUetbFCiStVTv/VFa8efWpFLiFc3bkw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdCXL-007cwr-7Z; Fri, 17 Mar 2023 17:02:35 +0100
Date:   Fri, 17 Mar 2023 17:02:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Lee Jones <lee@kernel.org>, linux-leds@vger.kernel.org,
        pavel@ucw.cz, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v4 10/14] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <c087d270-56f6-4ead-a15b-aa3bfb732ba8@lunn.ch>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-11-ansuelsmth@gmail.com>
 <20230317091410.58787646@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317091410.58787646@dellmb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I would like to start a discussion on this and hear about your opinions,
> because I think that the trigger-sources and function properties were
> proposed in good faith, but currently the implementation and usage is a
> mess.
 
Hi Marek

We are pushing the boundaries of the LED code here, doing things which
have not been done before, as far as i know. So i expect some
discussion about this. However, that discussion should not really
affect this patchset, which is just adding plain boring software
controlled LEDs.

A quick recap about ledtrig-netdev.

If you have a plain boring LED, you have:

root@370rd:/sys/class/net/eth0/phydev/leds/f1072004.mdio-mii:00:WAN# ls
brightness  device  max_brightness  power  subsystem  trigger  uevent

You can turn the LED on with

root@370rd:/sys/class/net/eth0/phydev/leds/f1072004.mdio-mii:00:WAN# echo 1 > brightness 

and turn it off with:

root@370rd:/sys/class/net/eth0/phydev/leds/f1072004.mdio-mii:00:WAN# echo 0 > brightness 

You select the trigger via the trigger sysfs file:

root@370rd:/sys/class/net/eth0/phydev/leds/f1072004.mdio-mii:00:WAN# cat trigger 
[none] kbd-scrolllock kbd-numlock kbd-capslock kbd-kanalock kbd-shiftlock kbd-altgrlock kbd-ctrllock kbd-altlock kbd-shiftllock kbd-shiftrlock kbd-ctrlllock kbd-ctrlrlock timer heartbeat netdev mmc0

root@370rd:/sys/class/net/eth0/phydev/leds/f1072004.mdio-mii:00:WAN# echo netdev > trigger
root@370rd:/sys/class/net/eth0/phydev/leds/f1072004.mdio-mii:00:WAN# ls
activity	brightness  device_name  half_duplex  link     link_100   max_brightness  rx	     trigger  uevent
available_mode	device	    full_duplex  interval     link_10  link_1000  power		  subsystem  tx

When you select a trigger, that trigger can add additional sysfs
files. For the netdev trigger we gain link, link_10, link_100, link_1000, rx & tx.

Nothing special here, if you selected the timer trigger you get
delay_off delay_on. The oneshot trigger has invert, delay_on,
delay_off etc.

You then configure the trigger via setting values in the sysfs
files. If you want the LED to indicate if there is link, you would do:

echo 1 > link

The LED would then light up if the netdev has carrier.

If you want link plus RX packets

echo 1 > link
echo 1 > rx

The LED will then be on if there is link, and additionally blink if
the netdev stats indicate received frames.

For the netdev trigger, all the configuration values are boolean. So a
simple way to represent this in DT would be boolean properties:

	netdev-link = <1>;
	netdev->rx = <1>;

We probably want these properties name spaced, because we have oneshot
delay_on and timer delay_on for example. The same sysfs name could
have different types, bool vs milliseconds, etc.

I would make it, that when the trigger is activated, the values are
read from DT and used. There is currently no persistent state for
triggers. If you where to swap to the timer trigger and then return to
the netdev trigger, all state is lost, so i would re-read DT.

Offloading to hardware should not make an difference here. All we are
going to do is pass the current configuration to the LED and ask it,
can you do this? If it says no, we keep blinking in software. If yes,
we leave the blinking to the hardware.

There is the open question of if DT should be used like this.  It is
not describing hardware, it is describing configuration of
hardware. So it could well get rejected. You then need to configure it
in software.

   Andrew
