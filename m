Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23812CC079
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgLBPML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:12:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgLBPMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 10:12:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkTmu-009st9-P7; Wed, 02 Dec 2020 16:11:24 +0100
Date:   Wed, 2 Dec 2020 16:11:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201202151124.GE2324545@lunn.ch>
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202120712.6212-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -422,6 +527,7 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
>  					    phy_interface_t interface)
>  {
>  	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct ar9331_sw_port *p = &priv->port[port];
>  	struct regmap *regmap = priv->regmap;
>  	int ret;
>  
> @@ -429,6 +535,8 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
>  				 AR9331_SW_PORT_STATUS_MAC_MASK, 0);
>  	if (ret)
>  		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> +
> +	cancel_delayed_work_sync(&p->mib_read);
>  }

You could update the stats here, after the interface is down. You then
know the stats are actually up to date and correct!

     Andrew
