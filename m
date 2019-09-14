Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8597B2C58
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfINRJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 13:09:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:46516 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbfINRJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 13:09:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Sep 2019 10:09:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="188186220"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003.jf.intel.com with ESMTP; 14 Sep 2019 10:09:34 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i9BYD-0005Gw-HZ; Sat, 14 Sep 2019 20:09:33 +0300
Date:   Sat, 14 Sep 2019 20:09:33 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mdio: switch to using gpiod_get_optional()
Message-ID: <20190914170933.GV2680@smile.fi.intel.com>
References: <20190913225547.GA106494@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913225547.GA106494@dtor-ws>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 03:55:47PM -0700, Dmitry Torokhov wrote:
> The MDIO device reset line is optional and now that gpiod_get_optional()
> returns proper value when GPIO support is compiled out, there is no
> reason to use fwnode_get_named_gpiod() that I plan to hide away.
> 
> Let's switch to using more standard gpiod_get_optional() and
> gpiod_set_consumer_name() to keep the nice "PHY reset" label.
> 
> Also there is no reason to only try to fetch the reset GPIO when we have
> OF node, gpiolib can fetch GPIO data from firmwares as well.
> 

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

But see comment below.

> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> Note this is an update to a patch titled "[PATCH 05/11] net: mdio:
> switch to using fwnode_gpiod_get_index()" that no longer uses the new
> proposed API and instead works with already existing ones.
> 
>  drivers/net/phy/mdio_bus.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index ce940871331e..2e29ab841b4d 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -42,21 +42,17 @@
>  
>  static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
>  {
> -	struct gpio_desc *gpiod = NULL;
> +	int error;
>  
>  	/* Deassert the optional reset signal */
> -	if (mdiodev->dev.of_node)
> -		gpiod = fwnode_get_named_gpiod(&mdiodev->dev.of_node->fwnode,
> -					       "reset-gpios", 0, GPIOD_OUT_LOW,
> -					       "PHY reset");
> -	if (IS_ERR(gpiod)) {
> -		if (PTR_ERR(gpiod) == -ENOENT || PTR_ERR(gpiod) == -ENOSYS)
> -			gpiod = NULL;
> -		else
> -			return PTR_ERR(gpiod);
> -	}
> -
> -	mdiodev->reset_gpio = gpiod;
> +	mdiodev->reset_gpio = gpiod_get_optional(&mdiodev->dev,
> +						 "reset", GPIOD_OUT_LOW);
> +	error = PTR_ERR_OR_ZERO(mdiodev->reset_gpio);
> +	if (error)
> +		return error;
> +

> +	if (mdiodev->reset_gpio)

This is redundant check.

> +		gpiod_set_consumer_name(mdiodev->reset_gpio, "PHY reset");

>  	return 0;
>  }
> -- 
> 2.23.0.237.gc6a4ce50a0-goog
> 
> 
> -- 
> Dmitry

-- 
With Best Regards,
Andy Shevchenko


