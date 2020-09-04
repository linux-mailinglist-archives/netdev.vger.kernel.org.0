Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3F25D125
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgIDGQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgIDGQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:16:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1774AC061245
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 23:16:09 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kE50z-0007ki-13; Fri, 04 Sep 2020 08:16:01 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kE50w-0005Ue-ON; Fri, 04 Sep 2020 08:15:58 +0200
Date:   Fri, 4 Sep 2020 08:15:58 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, adam.rudzinski@arf.net.pl,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: bcm7xxx: request and manage GPHY
 clock
Message-ID: <20200904061558.s2s33nfof6itt24y@pengutronix.de>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903043947.3272453-4-f.fainelli@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:07:31 up 293 days, 21:26, 275 users,  load average: 0.05, 0.04,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 20-09-02 21:39, Florian Fainelli wrote:
> The internal Gigabit PHY on Broadcom STB chips has a digital clock which
> drives its MDIO interface among other things, the driver now requests
> and manage that clock during .probe() and .remove() accordingly.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/phy/bcm7xxx.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
> index 692048d86ab1..f0ffcdcaef03 100644
> --- a/drivers/net/phy/bcm7xxx.c
> +++ b/drivers/net/phy/bcm7xxx.c
> @@ -11,6 +11,7 @@
>  #include "bcm-phy-lib.h"
>  #include <linux/bitops.h>
>  #include <linux/brcmphy.h>
> +#include <linux/clk.h>
>  #include <linux/mdio.h>
>  
>  /* Broadcom BCM7xxx internal PHY registers */
> @@ -39,6 +40,7 @@
>  
>  struct bcm7xxx_phy_priv {
>  	u64	*stats;
> +	struct clk *clk;
>  };
>  
>  static int bcm7xxx_28nm_d0_afe_config_init(struct phy_device *phydev)
> @@ -534,7 +536,19 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
>  	if (!priv->stats)
>  		return -ENOMEM;
>  
> -	return 0;
> +	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);

Since the clock is binded to the mdio-dev here..

> +	if (IS_ERR(priv->clk))
> +		return PTR_ERR(priv->clk);
> +
> +	return clk_prepare_enable(priv->clk);

clould we use devm_add_action_or_reset() here so we don't have to
register the .remove() hook?

> +}
> +
> +static void bcm7xxx_28nm_remove(struct phy_device *phydev)
> +{
> +	struct bcm7xxx_phy_priv *priv = phydev->priv;
> +
> +	clk_disable_unprepare(priv->clk);
> +	devm_clk_put(&phydev->mdio.dev, priv->clk);

Is this really necessary? The devm_clk_get_optional() function already
registers the devm_clk_release() hook.

Regards,
  Marco

>  }
>  
>  #define BCM7XXX_28NM_GPHY(_oui, _name)					\
> @@ -552,6 +566,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
>  	.get_strings	= bcm_phy_get_strings,				\
>  	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
>  	.probe		= bcm7xxx_28nm_probe,				\
> +	.remove		= bcm7xxx_28nm_remove,				\
>  }
>  
>  #define BCM7XXX_28NM_EPHY(_oui, _name)					\
> @@ -567,6 +582,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
>  	.get_strings	= bcm_phy_get_strings,				\
>  	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
>  	.probe		= bcm7xxx_28nm_probe,				\
> +	.remove		= bcm7xxx_28nm_remove,				\
>  }
>  
>  #define BCM7XXX_40NM_EPHY(_oui, _name)					\
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
