Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE344A556
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 04:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhKID2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 22:28:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238905AbhKID2I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 22:28:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 271A46128B;
        Tue,  9 Nov 2021 03:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636428322;
        bh=2EywPiFPfXadvZ0O84sB/RywSKBOhmALvSM5TU6ux54=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BnPjKubSbqe1wh+Q80XFfaL/bkFgrGfnLWRabQgBQjLNxlXar8Rzi6YFIAmy8NZOP
         A227wQB4mvGLlNVWEXf6arZTYTJxsrdSG/uSWhmsywi4rgN0rQBCe5b/FaYo3S/7dN
         +biwyyySzxMPEHeEkVKHlov6btzKzAzSnkjNVruoYWr2jPA0NEMKtmChd7JEmc9V+H
         +h1x4QERTNcQTtXkTjZd6ZP6SCDiH79ACv89rnE0q9syS0bdf6TSvIGH+zdDj7HXiR
         iKvQPIBD7J60u1U63a1/H1uZ6tmZy0oIiJl0GnwIMC6lCRrYZe+m8TGihcU35mHdGo
         5UqViCxwOoSZw==
Date:   Tue, 9 Nov 2021 04:25:17 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity
 trigger
Message-ID: <20211109042517.03baa809@thinkpad>
In-Reply-To: <20211109022608.11109-7-ansuelsmth@gmail.com>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
        <20211109022608.11109-7-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Nov 2021 03:26:06 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> Add Hardware Only Trigger for PHY Activity. This special trigger is used to
> configure and expose the different HW trigger that are provided by the
> PHY. Each blink mode can be configured by sysfs and on trigger
> activation the hardware mode is enabled.
> 
> This currently implement these hw triggers:
>   - blink_tx: Blink LED on tx packet receive
>   - blink_rx: Blink LED on rx packet receive
>   - keep_link_10m: Keep LED on with 10m link speed
>   - keep_link_100m: Keep LED on with 100m link speed
>   - kepp_link_1000m: Keep LED on with 1000m link speed
>   - keep_half_duplex: Keep LED on with half duplex link
>   - keep_full_duplex: Keep LED on with full duplex link
>   - option_linkup_over: Ignore blink tx/rx with link keep not active
>   - option_power_on_reset: Keep LED on with switch reset
>   - option_blink_2hz: Set blink speed at 2hz for every blink event
>   - option_blink_4hz: Set blink speed at 4hz for every blink event
>   - option_blink_8hz: Set blink speed at 8hz for every blink event
>   - option_blink_auto: Set blink speed at 2hz for 10m link speed,
>       4hz for 100m and 8hz for 1000m
> 
> The trigger will check if the LED driver support the various blink modes
> and will expose the blink modes in sysfs.
> It will finally enable hw mode for the LED without configuring any rule.
> This mean that the LED will blink/follow whatever offload trigger is
> active by default and the user needs to manually configure the desired
> offload triggers using sysfs.
> A flag is passed to configure_offload with the related rule from this
> trigger to active or disable.
> It's in the led driver interest the detection and knowing how to
> elaborate the passed flags and should report -EOPNOTSUPP otherwise.
> 
> The different hw triggers are exposed in the led sysfs dir under the
> offload-phy-activity subdir.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/leds/trigger/Kconfig                  |  28 +++
>  drivers/leds/trigger/Makefile                 |   1 +
>  .../trigger/ledtrig-hardware-phy-activity.c   | 171 ++++++++++++++++++
>  include/linux/leds.h                          |  22 +++
>  4 files changed, 222 insertions(+)
>  create mode 100644 drivers/leds/trigger/ledtrig-hardware-phy-activity.c
> 
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index dc6816d36d06..b947b238be3f 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -154,4 +154,32 @@ config LEDS_TRIGGER_TTY
>  
>  	  When build as a module this driver will be called ledtrig-tty.
>  
> +config LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY
> +	tristate "LED Trigger for PHY Activity for Hardware Controlled LED"
> +	depends on LEDS_HARDWARE_CONTROL
> +	help
> +	  This allows LEDs to be configured to run by hardware and offloaded
> +	  based on some rules. The LED will blink or be on based on the PHY
> +	  Activity for example on packet receive or based on the link speed.
> +
> +	  The current supported offload triggers are:
> +	  - blink_tx: Blink LED on tx packet receive
> +	  - blink_rx: Blink LED on rx packet receive
> +	  - keep_link_10m: Keep LED on with 10m link speed
> +	  - keep_link_100m: Keep LED on with 100m link speed
> +	  - keep_link_1000m: Keep LED on with 1000m link speed
> +	  - keep_half_duplex: Keep LED on with half duplex link
> +	  - keep_full_duplex: Keep LED on with full duplex link
> +	  - option_linkup_over: Blink rules are ignored with absent link
> +	  - option_power_on_reset: Power ON Led on Switch/PHY reset
> +	  - option_blink_2hz: Set blink speed at 2hz for every blink event
> +	  - option_blink_4hz: Set blink speed at 4hz for every blink event
> +	  - option_blink_8hz: Set blink speed at 8hz for every blink event
> +
> +	  These blink modes are present in the LED sysfs dir under
> +	  hardware-phy-activity if supported by the LED driver.
> +
> +	  This trigger can be used only by LEDs that supports Hardware mode
> +
> +
>  endif # LEDS_TRIGGERS
> diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
> index 25c4db97cdd4..f5d0d0057d2b 100644
> --- a/drivers/leds/trigger/Makefile
> +++ b/drivers/leds/trigger/Makefile
> @@ -16,3 +16,4 @@ obj-$(CONFIG_LEDS_TRIGGER_NETDEV)	+= ledtrig-netdev.o
>  obj-$(CONFIG_LEDS_TRIGGER_PATTERN)	+= ledtrig-pattern.o
>  obj-$(CONFIG_LEDS_TRIGGER_AUDIO)	+= ledtrig-audio.o
>  obj-$(CONFIG_LEDS_TRIGGER_TTY)		+= ledtrig-tty.o
> +obj-$(CONFIG_LEDS_TRIGGER_HARDWARE_PHY_ACTIVITY) += ledtrig-hardware-phy-activity.o
> diff --git a/drivers/leds/trigger/ledtrig-hardware-phy-activity.c b/drivers/leds/trigger/ledtrig-hardware-phy-activity.c
> new file mode 100644
> index 000000000000..7fd0557fe878
> --- /dev/null
> +++ b/drivers/leds/trigger/ledtrig-hardware-phy-activity.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/leds.h>
> +#include <linux/slab.h>
> +
> +#define PHY_ACTIVITY_MAX_TRIGGERS 12
> +
> +#define DEFINE_OFFLOAD_TRIGGER(trigger_name, trigger) \
> +	static ssize_t trigger_name##_show(struct device *dev, \
> +				struct device_attribute *attr, char *buf) \
> +	{ \
> +		struct led_classdev *led_cdev = led_trigger_get_led(dev); \
> +		int val; \
> +		val = led_cdev->hw_control_configure(led_cdev, trigger, BLINK_MODE_READ); \
> +		return sprintf(buf, "%d\n", val ? 1 : 0); \
> +	} \
> +	static ssize_t trigger_name##_store(struct device *dev, \
> +					struct device_attribute *attr, \
> +					const char *buf, size_t size) \
> +	{ \
> +		struct led_classdev *led_cdev = led_trigger_get_led(dev); \
> +		unsigned long state; \
> +		int cmd, ret; \
> +		ret = kstrtoul(buf, 0, &state); \
> +		if (ret) \
> +			return ret; \
> +		cmd = !!state ? BLINK_MODE_ENABLE : BLINK_MODE_DISABLE; \
> +		/* Update the configuration with every change */ \
> +		led_cdev->hw_control_configure(led_cdev, trigger, cmd); \
> +		return size; \
> +	} \
> +	DEVICE_ATTR_RW(trigger_name)
> +
> +/* Expose sysfs for every blink to be configurable from userspace */
> +DEFINE_OFFLOAD_TRIGGER(blink_tx, BLINK_TX);
> +DEFINE_OFFLOAD_TRIGGER(blink_rx, BLINK_RX);
> +DEFINE_OFFLOAD_TRIGGER(keep_link_10m, KEEP_LINK_10M);
> +DEFINE_OFFLOAD_TRIGGER(keep_link_100m, KEEP_LINK_100M);
> +DEFINE_OFFLOAD_TRIGGER(keep_link_1000m, KEEP_LINK_1000M);
> +DEFINE_OFFLOAD_TRIGGER(keep_half_duplex, KEEP_HALF_DUPLEX);
> +DEFINE_OFFLOAD_TRIGGER(keep_full_duplex, KEEP_FULL_DUPLEX);
> +DEFINE_OFFLOAD_TRIGGER(option_linkup_over, OPTION_LINKUP_OVER);
> +DEFINE_OFFLOAD_TRIGGER(option_power_on_reset, OPTION_POWER_ON_RESET);
> +DEFINE_OFFLOAD_TRIGGER(option_blink_2hz, OPTION_BLINK_2HZ);
> +DEFINE_OFFLOAD_TRIGGER(option_blink_4hz, OPTION_BLINK_4HZ);
> +DEFINE_OFFLOAD_TRIGGER(option_blink_8hz, OPTION_BLINK_8HZ);

This is very strange. Is option_blink_2hz a trigger on itself? Or just
an option for another trigger? It seems that it is an option, so that I
can set something like
  blink_tx,option_blink_2hz
and the LED will blink on tx activity with frequency 2 Hz... If that is
so, I think you are misnaming your macros or something, since you are
defining option_blink_2hz as a trigger with
 DEFINE_OFFLOAD_TRIGGER

Marek
