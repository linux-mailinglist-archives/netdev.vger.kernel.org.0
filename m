Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDDB353491
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 17:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhDCPbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 11:31:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32884 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236615AbhDCPbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 11:31:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lSiFE-00EeF7-TB; Sat, 03 Apr 2021 17:31:28 +0200
Date:   Sat, 3 Apr 2021 17:31:28 +0200
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
Subject: Re: [PATCH net-next v1 7/9] net: dsa: qca: ar9331: add bridge support
Message-ID: <YGiKUMMm4oKNFUSs@lunn.ch>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403114848.30528-8-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 01:48:46PM +0200, Oleksij Rempel wrote:
> This switch is providing forwarding matrix, with it we can configure
> individual bridges. Potentially we can configure more then one not VLAN
> based bridge on this HW.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 73 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index b2c22ba924f0..bf9588574205 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -40,6 +40,7 @@
>   */
>  
>  #include <linux/bitfield.h>
> +#include <linux/if_bridge.h>
>  #include <linux/module.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_mdio.h>
> @@ -1134,6 +1135,76 @@ static int ar9331_sw_set_ageing_time(struct dsa_switch *ds,
>  				  val);
>  }
>  
> +static int ar9331_sw_port_bridge_join(struct dsa_switch *ds, int port,
> +				      struct net_device *br)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int port_mask = BIT(priv->cpu_port);
> +	int i, ret;
> +	u32 val;
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (dsa_to_port(ds, i)->bridge_dev != br)
> +			continue;
> +
> +		if (!dsa_is_user_port(ds, port))
> +			continue;
> +
> +		val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, BIT(port));
> +		ret = regmap_set_bits(regmap, AR9331_SW_REG_PORT_VLAN(i), val);
> +		if (ret)
> +			goto error;
> +
> +		if (i != port)
> +			port_mask |= BIT(i);
> +	}
> +
> +	val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask);
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
> +				 AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, val);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +error:
> +	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static void ar9331_sw_port_bridge_leave(struct dsa_switch *ds, int port,
> +					struct net_device *br)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int i, ret;
> +	u32 val;
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (dsa_to_port(ds, i)->bridge_dev != br)
> +			continue;
> +
> +		if (!dsa_is_user_port(ds, port))
> +			continue;
> +
> +		val = FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, BIT(port));
> +		ret = regmap_clear_bits(regmap, AR9331_SW_REG_PORT_VLAN(i), val);
> +		if (ret)
> +			goto error;
> +	}

Join and leave only seems to differ by:

> +		if (i != port)
> +			port_mask |= BIT(i);

Maybe refactor the code to add a helper for the identical parts?

      Andrew
