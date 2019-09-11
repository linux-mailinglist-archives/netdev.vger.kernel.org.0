Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D14AB026E
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 19:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfIKROF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 13:14:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:16174 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729450AbfIKROF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 13:14:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 10:14:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="336315272"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga004.jf.intel.com with ESMTP; 11 Sep 2019 10:13:58 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i86Bo-0001zn-Jk; Wed, 11 Sep 2019 20:13:56 +0300
Date:   Wed, 11 Sep 2019 20:13:56 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Jonas Karlman <jonas@kwiboo.se>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/11] Add support for software nodes to gpiolib
Message-ID: <20190911171356.GV2680@smile.fi.intel.com>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 12:52:04AM -0700, Dmitry Torokhov wrote:
> This series attempts to add support for software nodes to gpiolib, using
> software node references that were introduced recently. This allows us
> to convert more drivers to the generic device properties and drop
> support for custom platform data:
> 
> static const struct software_node gpio_bank_b_node = {
> |-------.name = "B",
> };
> 
> static const struct property_entry simone_key_enter_props[] = {
> |-------PROPERTY_ENTRY_U32("linux,code", KEY_ENTER),
> |-------PROPERTY_ENTRY_STRING("label", "enter"),
> |-------PROPERTY_ENTRY_REF("gpios", &gpio_bank_b_node, 123, GPIO_ACTIVE_LOW),
> |-------{ }
> };
> 
> If we agree in principle, I would like to have the very first 3 patches
> in an immutable branch off maybe -rc8 so that it can be pulled into
> individual subsystems so that patches switching various drivers to
> fwnode_gpiod_get_index() could be applied.

FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

for patches 1-8 after addressing minor issues.
I'll review the rest later on.

> 
> Thanks,
> Dmitry
> 
> Dmitry Torokhov (11):
>   gpiolib: of: add a fallback for wlf,reset GPIO name
>   gpiolib: introduce devm_fwnode_gpiod_get_index()
>   gpiolib: introduce fwnode_gpiod_get_index()
>   net: phylink: switch to using fwnode_gpiod_get_index()
>   net: mdio: switch to using fwnode_gpiod_get_index()
>   drm/bridge: ti-tfp410: switch to using fwnode_gpiod_get_index()
>   gpliolib: make fwnode_get_named_gpiod() static
>   gpiolib: of: tease apart of_find_gpio()
>   gpiolib: of: tease apart acpi_find_gpio()
>   gpiolib: consolidate fwnode GPIO lookups
>   gpiolib: add support for software nodes
> 
>  drivers/gpio/Makefile              |   1 +
>  drivers/gpio/gpiolib-acpi.c        | 153 ++++++++++++++----------
>  drivers/gpio/gpiolib-acpi.h        |  21 ++--
>  drivers/gpio/gpiolib-devres.c      |  33 ++----
>  drivers/gpio/gpiolib-of.c          | 159 ++++++++++++++-----------
>  drivers/gpio/gpiolib-of.h          |  26 ++--
>  drivers/gpio/gpiolib-swnode.c      |  92 +++++++++++++++
>  drivers/gpio/gpiolib-swnode.h      |  13 ++
>  drivers/gpio/gpiolib.c             | 184 ++++++++++++++++-------------
>  drivers/gpu/drm/bridge/ti-tfp410.c |   4 +-
>  drivers/net/phy/mdio_bus.c         |   4 +-
>  drivers/net/phy/phylink.c          |   4 +-
>  include/linux/gpio/consumer.h      |  53 ++++++---
>  13 files changed, 471 insertions(+), 276 deletions(-)
>  create mode 100644 drivers/gpio/gpiolib-swnode.c
>  create mode 100644 drivers/gpio/gpiolib-swnode.h
> 
> -- 
> 2.23.0.162.g0b9fbb3734-goog
> 

-- 
With Best Regards,
Andy Shevchenko


