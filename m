Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8B93A137E
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239135AbhFILyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 07:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbhFILyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 07:54:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB20C06175F
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 04:52:09 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqwke-0004za-3X; Wed, 09 Jun 2021 13:52:04 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lqwkc-0004MU-Oi; Wed, 09 Jun 2021 13:52:02 +0200
Date:   Wed, 9 Jun 2021 13:52:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2][next] net: usb: asix: ax88772: net: Fix less than
 zero comparison of a u16
Message-ID: <20210609115202.ms32g2rwco56iygz@pengutronix.de>
References: <20210608152249.160333-1-colin.king@canonical.com>
 <20210608152249.160333-2-colin.king@canonical.com>
 <20210608181129.7mnuba6dcaemslul@pengutronix.de>
 <a289d8fa-3cfd-6b85-20ec-fe0f5b682383@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a289d8fa-3cfd-6b85-20ec-fe0f5b682383@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:50:21 up 189 days,  1:56, 46 users,  load average: 0.18, 0.07,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 10:51:09AM +0100, Colin Ian King wrote:
> On 08/06/2021 19:11, Oleksij Rempel wrote:
> > On Tue, Jun 08, 2021 at 04:22:49PM +0100, Colin King wrote:
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> The comparison of the u16 priv->phy_addr < 0 is always false because
> >> phy_addr is unsigned. Fix this by assigning the return from the call
> >> to function asix_read_phy_addr to int ret and using this for the
> >> less than zero error check comparison.
> >>
> >> Addresses-Coverity: ("Unsigned compared against 0")
> >> Fixes: 7e88b11a862a ("net: usb: asix: refactor asix_read_phy_addr() and handle errors on return")
> > 
> > Here is wrong Fixes tag. This assignment was bogus before this patch.
> 
> I'm not sure that's correct, that commit has the following change in it:
> 
> diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
> index b404c9462dce..c8ca5187eece 100644
> --- a/drivers/net/usb/ax88172a.c
> +++ b/drivers/net/usb/ax88172a.c
> @@ -220,6 +220,11 @@ static int ax88172a_bind(struct usbnet *dev, struct
> usb_interface *intf)
>         }
> 
>         priv->phy_addr = asix_read_phy_addr(dev, priv->use_embdphy);
> +       if (priv->phy_addr < 0) {
> +               ret = priv->phy_addr;
> +               goto free;
> +       }
> +
> 

Even before my patch asix_read_phy_addr() was returning different
error values. My patch just add check for the return value.

> > 
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >> ---
> >>  drivers/net/usb/ax88172a.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
> >> index 2e2081346740..e24773bb9398 100644
> >> --- a/drivers/net/usb/ax88172a.c
> >> +++ b/drivers/net/usb/ax88172a.c
> >> @@ -205,7 +205,8 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
> >>  		goto free;
> >>  	}
> >>  
> >> -	priv->phy_addr = asix_read_phy_addr(dev, priv->use_embdphy);
> >> +	ret = asix_read_phy_addr(dev, priv->use_embdphy);
> >> +	priv->phy_addr = ret;
> > 
> > Ah.. it is same bug in different color :)
> > You probably wonted to do:
> > 	if (ret < 0)
> > 		goto free;
> > 
> > 	priv->phy_addr = ret;
> 
> Doh, brain failure of mine. I'll send a V2 later today.
> 
> > 
> >>  	if (priv->phy_addr < 0) {
> >>  		ret = priv->phy_addr;
> >>  		goto free;
> >> -- 
> >> 2.31.1
> >>
> >>
> > 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
