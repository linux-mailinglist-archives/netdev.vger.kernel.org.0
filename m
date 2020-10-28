Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2902329DD22
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbgJ1WT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731775AbgJ1WRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6FF322265;
        Wed, 28 Oct 2020 01:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603847774;
        bh=oV3S7duOeyYOo1nqmZIN8j5XHCODctICMAsJBKge0Go=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pv3ljmqkgAOqHddWzXpxcEDzRkrUglNMaoyOracRL+8yRYh/IRfQEVKa84lvqVm02
         TJdnEXaUm5YqHnm4HE616LfRZquoRCOLYW4UG0vOW5NTHdUSt8C3KmO0K39avQQ09Q
         aE0jYELsiXB/3rIZZfg3CskCZO7/slzE1CfCNbXE=
Date:   Tue, 27 Oct 2020 18:16:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mdio: use inline functions for to_mdio_device() etc
Message-ID: <20201027181613.03f3f67a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026165113.3723159-1-arnd@kernel.org>
References: <20201026165113.3723159-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 17:51:09 +0100 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Nesting container_of() causes warnings with W=2, and doing this
> in a header means we see a lot of them, like:
> 
> In file included from drivers/net/mdio/of_mdio.c:11:
> drivers/net/mdio/of_mdio.c: In function 'of_phy_find_device':
> include/linux/kernel.h:852:8: warning: declaration of '__mptr' shadows a previous local [-Wshadow]
>   852 |  void *__mptr = (void *)(ptr);     \
>       |        ^~~~~~
> include/linux/phy.h:655:26: note: in expansion of macro 'container_of'
>   655 | #define to_phy_device(d) container_of(to_mdio_device(d), \
>       |                          ^~~~~~~~~~~~
> include/linux/mdio.h:52:27: note: in expansion of macro 'container_of'
>    52 | #define to_mdio_device(d) container_of(d, struct mdio_device, dev)
>       |                           ^~~~~~~~~~~~
> include/linux/phy.h:655:39: note: in expansion of macro 'to_mdio_device'
>   655 | #define to_phy_device(d) container_of(to_mdio_device(d), \
>       |                                       ^~~~~~~~~~~~~~
> drivers/net/mdio/of_mdio.c:379:10: note: in expansion of macro 'to_phy_device'
>   379 |   return to_phy_device(&mdiodev->dev);
>       |          ^~~~~~~~~~~~~
> include/linux/kernel.h:852:8: note: shadowed declaration is here
>   852 |  void *__mptr = (void *)(ptr);     \
>       |        ^~~~~~
> include/linux/phy.h:655:26: note: in expansion of macro 'container_of'
>   655 | #define to_phy_device(d) container_of(to_mdio_device(d), \
>       |                          ^~~~~~~~~~~~
> drivers/net/mdio/of_mdio.c:379:10: note: in expansion of macro 'to_phy_device'
>   379 |   return to_phy_device(&mdiodev->dev);
>       |          ^~~~~~~~~~~~~
> 
> Redefine the macros in linux/mdio.h as inline functions to avoid this
> problem.
> 
> Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")

I feel like this is slightly onerous, please drop the tag. 

Harmless W=2 warnings hardly call for getting this into the cogs of
the stable machinery.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/mdio.h | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index dbd69b3d170b..7c059cb8e069 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -49,7 +49,10 @@ struct mdio_device {
>  	unsigned int reset_assert_delay;
>  	unsigned int reset_deassert_delay;
>  };
> -#define to_mdio_device(d) container_of(d, struct mdio_device, dev)

empty line

> +static inline struct mdio_device *to_mdio_device(struct device *dev)
> +{
> +	return container_of(dev, struct mdio_device, dev);
> +}
>  
>  /* struct mdio_driver_common: Common to all MDIO drivers */
>  struct mdio_driver_common {
> @@ -57,8 +60,11 @@ struct mdio_driver_common {
>  	int flags;
>  };
>  #define MDIO_DEVICE_FLAG_PHY		1
> -#define to_mdio_common_driver(d) \
> -	container_of(d, struct mdio_driver_common, driver)

and here

> +static inline struct mdio_driver_common *
> +to_mdio_common_driver(struct device_driver *drv)
> +{
> +	return container_of(drv, struct mdio_driver_common, driver);
> +}
>  
>  /* struct mdio_driver: Generic MDIO driver */
>  struct mdio_driver {
> @@ -73,8 +79,12 @@ struct mdio_driver {
>  	/* Clears up any memory if needed */
>  	void (*remove)(struct mdio_device *mdiodev);
>  };
> -#define to_mdio_driver(d)						\
> -	container_of(to_mdio_common_driver(d), struct mdio_driver, mdiodrv)
> +
> +static inline struct mdio_driver *to_mdio_driver(struct device_driver *drv)
> +{
> +	struct mdio_driver_common *common = to_mdio_common_driver(drv);

and here

Otherwise we're trading W=2 warnings for checkpatch warnings :)

Thanks!

> +	return container_of(common, struct mdio_driver, mdiodrv);
> +}
>  
>  /* device driver data */
>  static inline void mdiodev_set_drvdata(struct mdio_device *mdio, void *data)

