Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2996439FE4B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhFHSAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbhFHSAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 14:00:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D19C061787
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 10:58:27 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqfzZ-0006nr-Gj; Tue, 08 Jun 2021 19:58:21 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lqfzY-0003Cp-AE; Tue, 08 Jun 2021 19:58:20 +0200
Date:   Tue, 8 Jun 2021 19:58:20 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2][next] net: usb: asix: Fix less than zero comparison
 of a u16
Message-ID: <20210608175820.fxeaotpomtsywwfh@pengutronix.de>
References: <20210608152249.160333-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210608152249.160333-1-colin.king@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:57:08 up 188 days,  8:03, 50 users,  load average: 0.02, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 04:22:48PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of the u16 priv->phy_addr < 0 is always false because
> phy_addr is unsigned. Fix this by assigning the return from the call
> to function asix_read_phy_addr to int ret and using this for the
> less than zero error check comparison.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/usb/asix_devices.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 57dafb3262d9..211c5a87eb15 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -704,9 +704,10 @@ static int ax88772_init_phy(struct usbnet *dev)
>  	struct asix_common_private *priv = dev->driver_priv;
>  	int ret;
>  
> -	priv->phy_addr = asix_read_phy_addr(dev, true);
> -	if (priv->phy_addr < 0)
> +	ret = asix_read_phy_addr(dev, true);
> +	if (ret < 0)
>  		return priv->phy_addr;

please add new line here
> +	priv->phy_addr = ret;
>  
>  	snprintf(priv->phy_name, sizeof(priv->phy_name), PHY_ID_FMT,
>  		 priv->mdio->id, priv->phy_addr);
> -- 
> 2.31.1
> 

Thank you!

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
