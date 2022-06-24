Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1874559488
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 10:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiFXID4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 04:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiFXIDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 04:03:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985D56B8FB
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 01:03:46 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o4eHy-0007dS-0s; Fri, 24 Jun 2022 10:03:38 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o4eHx-00059C-NY; Fri, 24 Jun 2022 10:03:37 +0200
Date:   Fri, 24 Jun 2022 10:03:37 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next v1 1/1] net: asix: add optional flow control
 support
Message-ID: <20220624080337.GA14396@pengutronix.de>
References: <20220624080208.3143093-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220624080208.3143093-1-o.rempel@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 10:02:07AM +0200, Oleksij Rempel wrote:
> Add optional flow control support with respect to the link partners
> abilities.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

This is a net-next patch, depending on other net patch:
https://lore.kernel.org/all/20220624075139.3139300-2-o.rempel@pengutronix.de/

> ---
>  drivers/net/usb/asix_common.c  | 10 ++++++++++
>  drivers/net/usb/asix_devices.c |  2 ++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index b4a1b7abcfc9..c9df7cd8daae 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -420,6 +420,8 @@ void asix_adjust_link(struct net_device *netdev)
>  	u16 mode = 0;
>  
>  	if (phydev->link) {
> +		bool tx_pause, rx_pause;
> +
>  		mode = AX88772_MEDIUM_DEFAULT;
>  
>  		if (phydev->duplex == DUPLEX_HALF)
> @@ -427,6 +429,14 @@ void asix_adjust_link(struct net_device *netdev)
>  
>  		if (phydev->speed != SPEED_100)
>  			mode &= ~AX_MEDIUM_PS;
> +
> +		phy_get_pause(phydev, &tx_pause, &rx_pause);
> +
> +		if (rx_pause)
> +			mode |= AX_MEDIUM_RFC;
> +
> +		if (tx_pause)
> +			mode |= AX_MEDIUM_TFC;
>  	}
>  
>  	asix_write_medium_mode(dev, mode, 0);
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 5b5eb630c4b7..1bb12bbc34bf 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -677,6 +677,8 @@ static int ax88772_init_phy(struct usbnet *dev)
>  	phy_suspend(priv->phydev);
>  	priv->phydev->mac_managed_pm = 1;
>  
> +	phy_support_asym_pause(priv->phydev);
> +
>  	phy_attached_info(priv->phydev);
>  
>  	if (priv->embd_phy)
> -- 
> 2.30.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
