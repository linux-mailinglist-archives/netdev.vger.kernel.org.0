Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A241F4AD219
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 08:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348036AbiBHHUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 02:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237283AbiBHHUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 02:20:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82097C0401EF
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 23:20:31 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHKnc-0000gW-Pq; Tue, 08 Feb 2022 08:20:28 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHKnY-000085-PV; Tue, 08 Feb 2022 08:20:24 +0100
Date:   Tue, 8 Feb 2022 08:20:24 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: Re: [PATCH net 2/7] net: dsa: ar9331: register the mdiobus under
 devres
Message-ID: <20220208072024.GB18325@pengutronix.de>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
 <20220207161553.579933-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220207161553.579933-3-vladimir.oltean@nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:19:37 up 59 days, 16:05, 65 users,  load average: 0.18, 0.18,
 0.18
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 06:15:48PM +0200, Vladimir Oltean wrote:
> As explained in commits:
> 74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
> 5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")
> 
> mdiobus_free() will panic when called from devm_mdiobus_free() <-
> devres_release_all() <- __device_release_driver(), and that mdiobus was
> not previously unregistered.
> 
> The ar9331 is an MDIO device, so the initial set of constraints that I
> thought would cause this (I2C or SPI buses which call ->remove on
> ->shutdown) do not apply. But there is one more which applies here.
> 
> If the DSA master itself is on a bus that calls ->remove from ->shutdown
> (like dpaa2-eth, which is on the fsl-mc bus), there is a device link
> between the switch and the DSA master, and device_links_unbind_consumers()
> will unbind the ar9331 switch driver on shutdown.
> 
> So the same treatment must be applied to all DSA switch drivers, which
> is: either use devres for both the mdiobus allocation and registration,
> or don't use devres at all.
> 
> The ar9331 driver doesn't have a complex code structure for mdiobus
> removal, so just replace of_mdiobus_register with the devres variant in
> order to be all-devres and ensure that we don't free a still-registered
> bus.
> 
> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  drivers/net/dsa/qca/ar9331.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index 3bda7015f0c1..e5098cfe44bc 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -378,7 +378,7 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
>  	if (!mnp)
>  		return -ENODEV;
>  
> -	ret = of_mdiobus_register(mbus, mnp);
> +	ret = devm_of_mdiobus_register(dev, mbus, mnp);
>  	of_node_put(mnp);
>  	if (ret)
>  		return ret;
> @@ -1066,7 +1066,6 @@ static void ar9331_sw_remove(struct mdio_device *mdiodev)
>  	}
>  
>  	irq_domain_remove(priv->irqdomain);
> -	mdiobus_unregister(priv->mbus);
>  	dsa_unregister_switch(&priv->ds);
>  
>  	reset_control_assert(priv->sw_reset);
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
