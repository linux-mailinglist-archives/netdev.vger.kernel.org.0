Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731D2230D22
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgG1PLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:11:30 -0400
Received: from mail.nic.cz ([217.31.204.67]:46602 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbgG1PLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:11:30 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 7261313FCD6;
        Tue, 28 Jul 2020 17:11:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595949088; bh=7uovp5tiRjX0Q63trdBfxs/RHAlmPAqgR0xCiyLf3Cc=;
        h=Date:From:To;
        b=aX50kRH0WUaobGgSRxE97ikqg3Uj/nhtXx/hA2vDiK97ShqjTmkjcIGtC6L+hXe5o
         e3CXHVDS2R3QCYRBnnwOWy0juraKeg/k7aEw2wsprXz0pQepIN5pPdj1rUHiQ/R39K
         1tXQWpeoWvXe1nmXWD8TsdBaW5cB9Ihs4evn2Vdo=
Date:   Tue, 28 Jul 2020 17:11:28 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond?= =?UTF-8?Q?=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 1/2] net: phy: add API for LEDs
 controlled by PHY HW
Message-ID: <20200728171128.61c7193b@dellmb.labs.office.nic.cz>
In-Reply-To: <20200728150530.28827-2-marek.behun@nic.cz>
References: <20200728150530.28827-1-marek.behun@nic.cz>
        <20200728150530.28827-2-marek.behun@nic.cz>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 17:05:29 +0200
Marek Beh=C3=BAn <marek.behun@nic.cz> wrote:

> @@ -736,6 +777,16 @@ struct phy_driver {
>  	int (*set_loopback)(struct phy_device *dev, bool enable);
>  	int (*get_sqi)(struct phy_device *dev);
>  	int (*get_sqi_max)(struct phy_device *dev);
> +
> +	/* PHY LED support */
> +	int (*led_init)(struct phy_device *dev, struct
> phy_device_led *led);
> +	int (*led_brightness_set)(struct phy_device *dev, struct
> phy_device_led *led,
> +				  enum led_brightness brightness);
> +	const char *(*led_iter_hw_mode)(struct phy_device *dev,
> struct phy_device_led *led,
> +					void **	iter);
> +	int (*led_set_hw_mode)(struct phy_device *dev, struct
> phy_device_led *led,
> +			       const char *mode);
> +	const char *(*led_get_hw_mode)(struct phy_device *dev,
> struct phy_device_led *led); };
>  #define to_phy_driver(d)
> container_of(to_mdio_common_driver(d),		\ struct
> phy_driver, mdiodrv)

The problem here is that the same code will have to be added to DSA
switch ops structure, which is not OK.

I wanted to put this into struct mdio_driver_common, so that all mdio
drivers would be able to have HW LEDs connected. But then I remembered
that not all DSA drivers are connected via MDIO, some are via SPI.

So maybe this could instead become part of LED API, instead of phydev
API. Structure
  struct hw_controlled_led
and
  struct hw_controlled_led_ops
could be offered by the LED API, which would also register the needed
trigger.

struct phydev, struct dsa_switch and other could then just contain
pointer to struct hw_controlled_led_ops...

Marek
