Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7C22310DB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbgG1R2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:28:41 -0400
Received: from lists.nic.cz ([217.31.204.67]:59002 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731892AbgG1R2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 13:28:41 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 2127F140760;
        Tue, 28 Jul 2020 19:28:39 +0200 (CEST)
Date:   Tue, 28 Jul 2020 19:28:38 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 1/2] net: phy: add API for LEDs
 controlled by PHY HW
Message-ID: <20200728192838.29c798a9@nic.cz>
In-Reply-To: <20200728161800.GJ1705504@lunn.ch>
References: <20200728150530.28827-1-marek.behun@nic.cz>
        <20200728150530.28827-2-marek.behun@nic.cz>
        <20200728161800.GJ1705504@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 18:18:00 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > +static int of_phy_register_led(struct phy_device *phydev, struct device_node *np)
> > +{
> > +	struct led_init_data init_data = {};
> > +	struct phy_device_led *led;
> > +	u32 reg;
> > +	int ret;
> > +
> > +	ret = of_property_read_u32(np, "reg", &reg);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	led = devm_kzalloc(&phydev->mdio.dev, sizeof(struct phy_device_led), GFP_KERNEL);
> > +	if (!led)
> > +		return -ENOMEM;
> > +
> > +	led->cdev.brightness_set_blocking = phy_led_brightness_set;
> > +	led->cdev.trigger_type = &phy_hw_led_trig_type;
> > +	led->addr = reg;
> > +
> > +	of_property_read_string(np, "linux,default-trigger", &led->cdev.default_trigger);  
> 
> Hi Marek
> 
> I think we need one more optional property. If the trigger has been
> set to the PHY hardware trigger, we then should be able to set which
> of the different blink patterns we want the LED to use. I guess most
> users will never actually make use of the sys/class/led interface, if
> the default in device tree is sensible. But that requires DT can fully
> configure the LED.
> 
>    Andrew

Yes, I also thought about that. We have the linux,default-trigger
property, so maybe we could add linux,default-hw-control-mode property
as well.

Marek
