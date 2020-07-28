Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465F6230F0E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbgG1QSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:18:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60186 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730810AbgG1QSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:18:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0SIi-007J3m-Gm; Tue, 28 Jul 2020 18:18:00 +0200
Date:   Tue, 28 Jul 2020 18:18:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 1/2] net: phy: add API for LEDs
 controlled by PHY HW
Message-ID: <20200728161800.GJ1705504@lunn.ch>
References: <20200728150530.28827-1-marek.behun@nic.cz>
 <20200728150530.28827-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728150530.28827-2-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int of_phy_register_led(struct phy_device *phydev, struct device_node *np)
> +{
> +	struct led_init_data init_data = {};
> +	struct phy_device_led *led;
> +	u32 reg;
> +	int ret;
> +
> +	ret = of_property_read_u32(np, "reg", &reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	led = devm_kzalloc(&phydev->mdio.dev, sizeof(struct phy_device_led), GFP_KERNEL);
> +	if (!led)
> +		return -ENOMEM;
> +
> +	led->cdev.brightness_set_blocking = phy_led_brightness_set;
> +	led->cdev.trigger_type = &phy_hw_led_trig_type;
> +	led->addr = reg;
> +
> +	of_property_read_string(np, "linux,default-trigger", &led->cdev.default_trigger);

Hi Marek

I think we need one more optional property. If the trigger has been
set to the PHY hardware trigger, we then should be able to set which
of the different blink patterns we want the LED to use. I guess most
users will never actually make use of the sys/class/led interface, if
the default in device tree is sensible. But that requires DT can fully
configure the LED.

   Andrew
