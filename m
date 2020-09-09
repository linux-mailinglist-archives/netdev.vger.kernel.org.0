Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A526F2635CA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgIISUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIISUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:20:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADD2C061573;
        Wed,  9 Sep 2020 11:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Gs7l2ozHR0HxDr2hbk3gqjz3Et8a8q1twWwZC7hxypY=; b=W6u3PSCFmSajTX3+XLDF/fiiG7
        +efOlDW3xUWpArrgADLOP/BB8Pa2PP1S4JczSLNNV0hxeJIJAbwE69Ym7L+PIR2oKcYxIAuQgwo90
        KbGrlZlKSoiy1Y+SKznpbvvw0azanhsi50kZlrC93YY4gGFMqpnP6v2QxFrdM4rfQF215wfM5iGia
        dzCWdjQ0UEsVfhk60DUTjKsLHcEkra5RAv4usFfHjCTGTc3jvKNqljHXaBk35EpJxnQCEjK48VQr0
        pOH0dYxvUt8tvmBC1X6diLy4uSHmwFmGBRmphI0psMq7lygxlhcd3YwJ1aXP+RkFp5PoK5jjKLJXh
        zIipE4iw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kG4hR-0004S1-Or; Wed, 09 Sep 2020 18:20:08 +0000
Subject: Re: [PATCH net-next + leds v2 2/7] leds: add generic API for LEDs
 that can be controlled by hardware
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond=c5=99ej_Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-3-marek.behun@nic.cz>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <84bfc0ce-752d-9d1f-1043-fabe4cc25b15@infradead.org>
Date:   Wed, 9 Sep 2020 11:20:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200909162552.11032-3-marek.behun@nic.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/9/20 9:25 AM, Marek Behún wrote:
> Many an ethernet PHY (and other chips) supports various HW control modes
> for LEDs connected directly to them.
> 
> This patch adds a generic API for registering such LEDs when described
> in device tree. This API also exposes generic way to select between
> these hardware control modes.
> 
> This API registers a new private LED trigger called dev-hw-mode. When
> this trigger is enabled for a LED, the various HW control modes which
> are supported by the device for given LED can be get/set via hw_mode
> sysfs file.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> ---
>  .../sysfs-class-led-trigger-dev-hw-mode       |   8 +
>  drivers/leds/Kconfig                          |  10 +
>  drivers/leds/Makefile                         |   1 +
>  drivers/leds/leds-hw-controlled.c             | 227 ++++++++++++++++++
>  include/linux/leds-hw-controlled.h            |  74 ++++++
>  5 files changed, 320 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-led-trigger-dev-hw-mode
>  create mode 100644 drivers/leds/leds-hw-controlled.c
>  create mode 100644 include/linux/leds-hw-controlled.h
> 

> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 1c181df24eae4..5e47ab21aafb4 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -49,6 +49,16 @@ config LEDS_BRIGHTNESS_HW_CHANGED
>  
>  	  See Documentation/ABI/testing/sysfs-class-led for details.
>  
> +config LEDS_HW_CONTROLLED
> +	bool "API for LEDs that can be controlled by hardware"
> +	depends on LEDS_CLASS

	depends on OF || COMPILE_TEST
?

> +	select LEDS_TRIGGERS
> +	help
> +	  This option enables support for a generic API via which other drivers
> +	  can register LEDs that can be put into hardware controlled mode, eg.

	                                                                   e.g.

> +	  a LED connected to an ethernet PHY can be configured to blink on

	  an LED

> +	  network activity.
> +
>  comment "LED drivers"
>  
>  config LEDS_88PM860X


> diff --git a/include/linux/leds-hw-controlled.h b/include/linux/leds-hw-controlled.h
> new file mode 100644
> index 0000000000000..2c9b8a06def18
> --- /dev/null
> +++ b/include/linux/leds-hw-controlled.h
> @@ -0,0 +1,74 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Generic API for LEDs that can be controlled by hardware (eg. by an ethernet PHY chip)
> + *
> + * Copyright (C) 2020 Marek Behun <marek.behun@nic.cz>
> + */
> +#ifndef _LINUX_LEDS_HW_CONTROLLED_H_
> +#define _LINUX_LEDS_HW_CONTROLLED_H_
> +
> +#include <linux/kernel.h>
> +#include <linux/leds.h>
> +
> +struct hw_controlled_led {
> +	struct led_classdev cdev;
> +	const struct hw_controlled_led_ops *ops;
> +	struct mutex lock;
> +
> +	/* these members are filled in by OF if OF is enabled */
> +	int addr;
> +	bool active_low;
> +	bool tristate;
> +
> +	/* also filled in by OF, but changed by led_set_hw_mode operation */
> +	const char *hw_mode;
> +
> +	void *priv;
> +};
> +#define led_cdev_to_hw_controlled_led(l) container_of(l, struct hw_controlled_led, cdev)
> +
> +/* struct hw_controlled_led_ops: Operations on LEDs that can be controlled by HW
> + *
> + * All the following operations must be implemented:
> + * @led_init: Should initialize the LED from OF data (and sanity check whether they are correct).
> + *            This should also change led->cdev.max_brightness, if the value differs from default,
> + *            which is 1.
> + * @led_brightness_set: Sets brightness.
> + * @led_iter_hw_mode: Iterates available HW control mode names for this LED.
> + * @led_set_hw_mode: Sets HW control mode to value specified by given name.
> + * @led_get_hw_mode: Returns current HW control mode name.
> + */

Convert that struct info to kernel-doc?

> +struct hw_controlled_led_ops {
> +	int (*led_init)(struct device *dev, struct hw_controlled_led *led);
> +	int (*led_brightness_set)(struct device *dev, struct hw_controlled_led *led,
> +				  enum led_brightness brightness);
> +	const char *(*led_iter_hw_mode)(struct device *dev, struct hw_controlled_led *led,
> +					void **iter);
> +	int (*led_set_hw_mode)(struct device *dev, struct hw_controlled_led *led,
> +			       const char *mode);
> +	const char *(*led_get_hw_mode)(struct device *dev, struct hw_controlled_led *led);
> +};
> +

> +
> +#endif /* _LINUX_LEDS_HW_CONTROLLED_H_ */

thanks.
-- 
~Randy

