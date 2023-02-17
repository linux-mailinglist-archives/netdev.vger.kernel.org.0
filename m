Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA169A578
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 07:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBQGDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 01:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBQGDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 01:03:51 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2866F27488
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 22:03:50 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pStqW-0003ec-Ia; Fri, 17 Feb 2023 07:03:48 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pStqV-0005xK-HB; Fri, 17 Feb 2023 07:03:47 +0100
Date:   Fri, 17 Feb 2023 07:03:47 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next] net: phy: Read EEE abilities when using
 .features
Message-ID: <20230217060347.GB1974@pengutronix.de>
References: <20230217031520.1249198-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230217031520.1249198-1-andrew@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:15:20AM +0100, Andrew Lunn wrote:
> A PHY driver can use a static integer value to indicate what link mode
> features it supports, i.e, its abilities.. This is the old way, but
> useful when dynamically determining the devices features does not
> work, e.g. support of fibre.
> 
> EEE support has been moved into phydev->supported_eee. This needs to
> be set otherwise the code assumes EEE is not supported. It is normally
> set as part of reading the devices abilities. However if a static
> integer value was used, the dynamic reading of the abilities is not
> performed. Add a call to genphy_c45_read_eee_abilities() to read the
> EEE abilities.
> 
> Fixes: 8b68710a3121 ("net: phy: start using genphy_c45_ethtool_get/set_eee()")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  drivers/net/phy/phy_device.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 8d927c5e3bf8..71becceb8764 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -3113,8 +3113,10 @@ static int phy_probe(struct device *dev)
>  	 * a controller will attach, and may modify one
>  	 * or both of these values
>  	 */
> -	if (phydrv->features)
> +	if (phydrv->features) {
>  		linkmode_copy(phydev->supported, phydrv->features);
> +		genphy_c45_read_eee_abilities(phydev);
> +	}
>  	else if (phydrv->get_features)
>  		err = phydrv->get_features(phydev);
>  	else if (phydev->is_c45)
> -- 
> 2.39.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
