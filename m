Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E9E365716
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhDTLFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:05:31 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:57011 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhDTLF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:05:29 -0400
Received: (qmail 15708 invoked from network); 20 Apr 2021 11:04:55 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 20 Apr 2021 11:04:55 -0000
Subject: Re: [PATCH net-next v2] net: phy: at803x: fix probe error if copper
 page is selected
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210420102929.13505-1-michael@walle.cc>
From:   David Bauer <mail@david-bauer.net>
Message-ID: <a0e5c38d-9a60-5b48-48bf-ff4884adebb4@david-bauer.net>
Date:   Tue, 20 Apr 2021 13:04:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420102929.13505-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4/20/21 12:29 PM, Michael Walle wrote:
> The commit c329e5afb42f ("net: phy: at803x: select correct page on
> config init") selects the copper page during probe. This fails if the
> copper page was already selected. In this case, the value of the copper
> page (which is 1) is propagated through phy_restore_page() and is
> finally returned for at803x_probe(). Fix it, by just using the
> at803x_page_write() directly.

Ouch, i didn't spot that. Thanks for taking care.

> 
> Also in case of an error, the regulator is not disabled and leads to a
> WARN_ON() when the probe fails. This couldn't happen before, because
> at803x_parse_dt() was the last call in at803x_probe(). It is hard to
> see, that the parse_dt() actually enables the regulator. Thus move the
> regulator_enable() to the probe function and undo it in case of an
> error.
> 
> Fixes: c329e5afb42f ("net: phy: at803x: select correct page on config init")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: David Bauer <mail@david-bauer.net>

Best
David

> ---
> Changes since v1:
>  - take the bus lock
> 
>  drivers/net/phy/at803x.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index e0f56850edc5..32af52dd5aed 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -554,10 +554,6 @@ static int at803x_parse_dt(struct phy_device *phydev)
>  			phydev_err(phydev, "failed to get VDDIO regulator\n");
>  			return PTR_ERR(priv->vddio);
>  		}
> -
> -		ret = regulator_enable(priv->vddio);
> -		if (ret < 0)
> -			return ret;
>  	}
>  
>  	return 0;
> @@ -579,15 +575,30 @@ static int at803x_probe(struct phy_device *phydev)
>  	if (ret)
>  		return ret;
>  
> +	if (priv->vddio) {
> +		ret = regulator_enable(priv->vddio);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	/* Some bootloaders leave the fiber page selected.
>  	 * Switch to the copper page, as otherwise we read
>  	 * the PHY capabilities from the fiber side.
>  	 */
>  	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
> -		ret = phy_select_page(phydev, AT803X_PAGE_COPPER);
> -		ret = phy_restore_page(phydev, AT803X_PAGE_COPPER, ret);
> +		phy_lock_mdio_bus(phydev);
> +		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
> +		phy_unlock_mdio_bus(phydev);
> +		if (ret)
> +			goto err;
>  	}
>  
> +	return 0;
> +
> +err:
> +	if (priv->vddio)
> +		regulator_disable(priv->vddio);
> +
>  	return ret;
>  }
>  
> 
