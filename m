Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F56E22D8A8
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGYQWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 12:22:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55278 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgGYQWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 12:22:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jzMwR-006pHK-D0; Sat, 25 Jul 2020 18:22:31 +0200
Date:   Sat, 25 Jul 2020 18:22:31 +0200
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
Subject: Re: [PATCH RFC leds + net-next v3 1/2] net: phy: add API for LEDs
 controlled by PHY HW
Message-ID: <20200725162231.GJ1472201@lunn.ch>
References: <20200724164603.29148-1-marek.behun@nic.cz>
 <20200724164603.29148-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200724164603.29148-2-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 06:46:02PM +0200, Marek Behún wrote:
> Many PHYs support various HW control modes for LEDs connected directly
> to them.
> 
> This code adds a new private LED trigger called phydev-hw-mode. When
> this trigger is enabled for a LED, the various HW control modes which
> the PHY supports for given LED can be get/set via hw_mode sysfs file.
> 
> A PHY driver wishing to utilize this API needs to register the LEDs on
> its own and set the .trigger_type member of LED classdev to
> &phy_hw_led_trig_type. It also needs to implement the methods
> .led_iter_hw_mode, .led_set_hw_mode and .led_get_hw_mode in struct
> phydev.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> ---
>  drivers/net/phy/Kconfig           |  9 +++
>  drivers/net/phy/Makefile          |  1 +
>  drivers/net/phy/phy_hw_led_mode.c | 96 +++++++++++++++++++++++++++++++
>  include/linux/phy.h               | 15 +++++
>  4 files changed, 121 insertions(+)
>  create mode 100644 drivers/net/phy/phy_hw_led_mode.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index dd20c2c27c2f..ffea11f73acd 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -283,6 +283,15 @@ config LED_TRIGGER_PHY
>  		<Speed in megabits>Mbps OR <Speed in gigabits>Gbps OR link
>  		for any speed known to the PHY.
>  
> +config LED_TRIGGER_PHY_HW
> +	bool "Support HW LED control modes"
> +	depends on LEDS_TRIGGERS
> +	help
> +	  Many PHYs can control blinking of LEDs connected directly to them.
> +	  This adds a special LED trigger called phydev-hw-mode. When enabled,
> +	  the various control modes supported by the PHY on given LED can be
> +	  chosen via hw_mode sysfs file.
> +
>  
>  comment "MII PHY device drivers"
>  
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index d84bab489a53..fd0253ab8097 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -20,6 +20,7 @@ endif
>  obj-$(CONFIG_MDIO_DEVRES)	+= mdio_devres.o
>  libphy-$(CONFIG_SWPHY)		+= swphy.o
>  libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
> +libphy-$(CONFIG_LED_TRIGGER_PHY_HW)	+= phy_hw_led_mode.o
>  
>  obj-$(CONFIG_PHYLINK)		+= phylink.o
>  obj-$(CONFIG_PHYLIB)		+= libphy.o
> diff --git a/drivers/net/phy/phy_hw_led_mode.c b/drivers/net/phy/phy_hw_led_mode.c
> new file mode 100644
> index 000000000000..b4c2f25266a5
> --- /dev/null
> +++ b/drivers/net/phy/phy_hw_led_mode.c
> @@ -0,0 +1,96 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * drivers/net/phy/phy_hw_led_mode.c
> + *
> + * PHY HW LED mode trigger
> + *
> + * Copyright (C) 2020 Marek Behun <marek.behun@nic.cz>
> + */
> +#include <linux/leds.h>
> +#include <linux/phy.h>
> +
> +static void phy_hw_led_trig_deactivate(struct led_classdev *cdev)
> +{
> +	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
> +	int ret;
> +
> +	ret = phydev->drv->led_set_hw_mode(phydev, cdev, NULL);
> +	if (ret < 0) {
> +		phydev_err(phydev, "failed deactivating HW mode on LED %s\n", cdev->name);
> +		return;
> +	}

The core holds the phydev mutex when calling into the driver. There
are a few exceptions, but it would be good if all the LED calls into
the driver also held the mutex.

> +}
> +
> +static ssize_t hw_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct led_classdev *cdev = led_trigger_get_led(dev);
> +	struct phy_device *phydev = to_phy_device(cdev->dev->parent);
> +	const char *mode, *cur_mode;
> +	void *iter = NULL;
> +	int len = 0;

Reverse christmas tree.  

> +static int __init phy_led_triggers_init(void)
> +{
> +	return led_trigger_register(&phy_hw_led_trig);
> +}
> +
> +module_init(phy_led_triggers_init);
> +
> +static void __exit phy_led_triggers_exit(void)
> +{
> +	led_trigger_unregister(&phy_hw_led_trig);
> +}
> +
> +module_exit(phy_led_triggers_exit);

It is a bit of a surprise to find the module init/exit calls here, and
not in phy.c. I think they should be moved.

    Andrew
