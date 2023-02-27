Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657C56A3F41
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjB0KNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjB0KNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:13:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EEDCA01
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 02:13:40 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pWaTS-000825-0r; Mon, 27 Feb 2023 11:11:14 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pWaTQ-0000gH-7e; Mon, 27 Feb 2023 11:11:12 +0100
Date:   Mon, 27 Feb 2023 11:11:12 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: phy: unlock on error in phy_probe()
Message-ID: <20230227101112.GB24064@pengutronix.de>
References: <Y/x/6kHCjnQHqOpF@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/x/6kHCjnQHqOpF@kili>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 01:03:22PM +0300, Dan Carpenter wrote:
> If genphy_c45_read_eee_adv() fails then we need to do a reset and unlock
> the &phydev->lock mutex before returning.
> 
> Fixes: 3eeca4e199ce ("net: phy: do not force EEE support")
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  drivers/net/phy/phy_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 3f8a64fb9d71..9e9fd8ff00f6 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -3146,7 +3146,7 @@ static int phy_probe(struct device *dev)
>  	 */
>  	err = genphy_c45_read_eee_adv(phydev, phydev->advertising_eee);
>  	if (err)
> -		return err;
> +		goto out;
>  
>  	/* There is no "enabled" flag. If PHY is advertising, assume it is
>  	 * kind of enabled.
> -- 
> 2.39.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
