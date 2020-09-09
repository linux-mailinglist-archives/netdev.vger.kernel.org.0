Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57C026360C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgIISb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:31:27 -0400
Received: from mail.nic.cz ([217.31.204.67]:35510 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgIISbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 14:31:25 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 13A1314097F;
        Wed,  9 Sep 2020 20:31:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599676282; bh=MBNYhnZIH4TIaYHsF1IHyF5CYUjwTEWIE0r+GysP038=;
        h=Date:From:To;
        b=xwWJM2L/+RaaKPc1GBej5r1U3EY0ctyrEyBpsvaL4q2/H53Vl+CkhBLlD8IIumzt/
         C+Gl9rieB9wDe4KLL8Y9ooHiMflqK0pS2td6pAsGxrFDTRxCFTNxggoNsYI2JhSYyL
         rs28cfodwTmIpB/rlf9DIJmUZZlBQt6yXkt89uKI=
Date:   Wed, 9 Sep 2020 20:31:21 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 2/7] leds: add generic API for LEDs
 that can be controlled by hardware
Message-ID: <20200909203121.73bfcfa1@dellmb.labs.office.nic.cz>
In-Reply-To: <84bfc0ce-752d-9d1f-1043-fabe4cc25b15@infradead.org>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-3-marek.behun@nic.cz>
        <84bfc0ce-752d-9d1f-1043-fabe4cc25b15@infradead.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 11:20:00 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> Hi,
>=20
> On 9/9/20 9:25 AM, Marek Beh=C3=BAn wrote:
> > Many an ethernet PHY (and other chips) supports various HW control
> > modes for LEDs connected directly to them.
> >=20
> > This patch adds a generic API for registering such LEDs when
> > described in device tree. This API also exposes generic way to
> > select between these hardware control modes.
> >=20
> > This API registers a new private LED trigger called dev-hw-mode.
> > When this trigger is enabled for a LED, the various HW control
> > modes which are supported by the device for given LED can be
> > get/set via hw_mode sysfs file.
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <marek.behun@nic.cz>
> > ---
> >  .../sysfs-class-led-trigger-dev-hw-mode       |   8 +
> >  drivers/leds/Kconfig                          |  10 +
> >  drivers/leds/Makefile                         |   1 +
> >  drivers/leds/leds-hw-controlled.c             | 227
> > ++++++++++++++++++ include/linux/leds-hw-controlled.h            |
> > 74 ++++++ 5 files changed, 320 insertions(+)
> >  create mode 100644
> > Documentation/ABI/testing/sysfs-class-led-trigger-dev-hw-mode
> > create mode 100644 drivers/leds/leds-hw-controlled.c create mode
> > 100644 include/linux/leds-hw-controlled.h=20
>=20
> > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> > index 1c181df24eae4..5e47ab21aafb4 100644
> > --- a/drivers/leds/Kconfig
> > +++ b/drivers/leds/Kconfig
> > @@ -49,6 +49,16 @@ config LEDS_BRIGHTNESS_HW_CHANGED
> > =20
> >  	  See Documentation/ABI/testing/sysfs-class-led for
> > details.=20
> > +config LEDS_HW_CONTROLLED
> > +	bool "API for LEDs that can be controlled by hardware"
> > +	depends on LEDS_CLASS =20
>=20
> 	depends on OF || COMPILE_TEST
> ?
>=20

I specifically did not add OF dependency so that this can be also used
on non-OF systems. A device driver may register such LED itself...
That's why hw_controlled_led_brightness_set symbol is exported.

Do you think I shouldn't do it?

> > +	select LEDS_TRIGGERS
> > +	help
> > +	  This option enables support for a generic API via which
> > other drivers
> > +	  can register LEDs that can be put into hardware
> > controlled mode, eg. =20
>=20
> 	                                                                   e.g.
>=20

This will need to be changed on multiple places, thanks.

> > +	  a LED connected to an ethernet PHY can be configured to
> > blink on =20
>=20
> 	  an LED
>=20

This as well

> > +	  network activity.
> > +
> >  comment "LED drivers"
> > =20
> >  config LEDS_88PM860X =20
>=20
>=20
> > diff --git a/include/linux/leds-hw-controlled.h
> > b/include/linux/leds-hw-controlled.h new file mode 100644
> > index 0000000000000..2c9b8a06def18
> > --- /dev/null
> > +++ b/include/linux/leds-hw-controlled.h
> > @@ -0,0 +1,74 @@
> > +/* SPDX-License-Identifier: GPL-2.0+ */
> > +/*
> > + * Generic API for LEDs that can be controlled by hardware (eg. by
> > an ethernet PHY chip)
> > + *
> > + * Copyright (C) 2020 Marek Behun <marek.behun@nic.cz>
> > + */
> > +#ifndef _LINUX_LEDS_HW_CONTROLLED_H_
> > +#define _LINUX_LEDS_HW_CONTROLLED_H_
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/leds.h>
> > +
> > +struct hw_controlled_led {
> > +	struct led_classdev cdev;
> > +	const struct hw_controlled_led_ops *ops;
> > +	struct mutex lock;
> > +
> > +	/* these members are filled in by OF if OF is enabled */
> > +	int addr;
> > +	bool active_low;
> > +	bool tristate;
> > +
> > +	/* also filled in by OF, but changed by led_set_hw_mode
> > operation */
> > +	const char *hw_mode;
> > +
> > +	void *priv;
> > +};
> > +#define led_cdev_to_hw_controlled_led(l) container_of(l, struct
> > hw_controlled_led, cdev) +
> > +/* struct hw_controlled_led_ops: Operations on LEDs that can be
> > controlled by HW
> > + *
> > + * All the following operations must be implemented:
> > + * @led_init: Should initialize the LED from OF data (and sanity
> > check whether they are correct).
> > + *            This should also change led->cdev.max_brightness, if
> > the value differs from default,
> > + *            which is 1.
> > + * @led_brightness_set: Sets brightness.
> > + * @led_iter_hw_mode: Iterates available HW control mode names for
> > this LED.
> > + * @led_set_hw_mode: Sets HW control mode to value specified by
> > given name.
> > + * @led_get_hw_mode: Returns current HW control mode name.
> > + */ =20
>=20
> Convert that struct info to kernel-doc?
>=20

Will look into this.
Thanks.

> > +struct hw_controlled_led_ops {
> > +	int (*led_init)(struct device *dev, struct
> > hw_controlled_led *led);
> > +	int (*led_brightness_set)(struct device *dev, struct
> > hw_controlled_led *led,
> > +				  enum led_brightness brightness);
> > +	const char *(*led_iter_hw_mode)(struct device *dev, struct
> > hw_controlled_led *led,
> > +					void **iter);
> > +	int (*led_set_hw_mode)(struct device *dev, struct
> > hw_controlled_led *led,
> > +			       const char *mode);
> > +	const char *(*led_get_hw_mode)(struct device *dev, struct
> > hw_controlled_led *led); +};
> > + =20
>=20
> > +
> > +#endif /* _LINUX_LEDS_HW_CONTROLLED_H_ */ =20
>=20
> thanks.

