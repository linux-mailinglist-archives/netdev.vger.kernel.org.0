Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675D955E093
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243891AbiF1Etk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 00:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243678AbiF1Et3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 00:49:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F2F12AD3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 21:49:28 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o63A4-0006mF-MN; Tue, 28 Jun 2022 06:49:16 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o63A1-0003gZ-By; Tue, 28 Jun 2022 06:49:13 +0200
Date:   Tue, 28 Jun 2022 06:49:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Anton Lundin <glance@acc.umu.se>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net v1 1/2] net: asix: fix "can't send until first packet
 is send" issue
Message-ID: <20220628044913.GB13092@pengutronix.de>
References: <20220624075139.3139300-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220624075139.3139300-1-o.rempel@pengutronix.de>
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

On Fri, Jun 24, 2022 at 09:51:38AM +0200, Oleksij Rempel wrote:
> If cable is attached after probe sequence, the usbnet framework would
> not automatically start processing RX packets except at least one
> packet was transmitted.
> 
> On systems with any kind of address auto configuration this issue was
> not detected, because some packets are send immediately after link state
> is changed to "running".
> 
> With this patch we will notify usbnet about link status change provided by the
> PHYlib.
> 
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Reported-by: Anton Lundin <glance@acc.umu.se>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

In different mail thread Anton reported as tested.
Tested-by: Anton Lundin <glance@acc.umu.se>

> ---
>  drivers/net/usb/asix_common.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index 632fa6c1d5e3..b4a1b7abcfc9 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -431,6 +431,7 @@ void asix_adjust_link(struct net_device *netdev)
>  
>  	asix_write_medium_mode(dev, mode, 0);
>  	phy_print_status(phydev);
> +	usbnet_link_change(dev, phydev->link, 0);
>  }
>  
>  int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm)
> -- 
> 2.30.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
