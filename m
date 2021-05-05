Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC80137334A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhEEArX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:47:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEArW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 20:47:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5gF-002Z0Q-NH; Wed, 05 May 2021 02:46:23 +0200
Date:   Wed, 5 May 2021 02:46:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 07/20] net: dsa: qca8k: handle error with
 qca8k_rmw operation
Message-ID: <YJHq346ATRgV2BZp@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-7-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static void
> +static int
>  qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
>  {
> -	qca8k_rmw(priv, reg, 0, val);
> +	int ret;
> +
> +	ret = qca8k_rmw(priv, reg, 0, val);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;

Maybe return qca8k_rmw(priv, reg, 0, val); ??

> -static void
> +static int
>  qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
>  {
> -	qca8k_rmw(priv, reg, val, 0);
> +	int ret;
> +
> +	ret = qca8k_rmw(priv, reg, val, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
>  }

Maybe return qca8k_rmw(priv, reg, val, 0);

> @@ -1249,17 +1280,20 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
>  		/* Add this port to the portvlan mask of the other ports
>  		 * in the bridge
>  		 */
> -		qca8k_reg_set(priv,
> -			      QCA8K_PORT_LOOKUP_CTRL(i),
> -			      BIT(port));
> +		ret = qca8k_reg_set(priv,
> +				    QCA8K_PORT_LOOKUP_CTRL(i),
> +				    BIT(port));
> +		if (ret)
> +			return ret;
>  		if (i != port)
>  			port_mask |= BIT(i);
>  	}
> +
>  	/* Add all other ports to this ports portvlan mask */
> -	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> -		  QCA8K_PORT_LOOKUP_MEMBER, port_mask);
> +	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> +			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
>  
> -	return 0;
> +	return ret < 0 ? ret : 0;

Can this is simplified to 

	return  = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
			    QCA8K_PORT_LOOKUP_MEMBER, port_mask);

> @@ -1396,18 +1430,19 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
>  			  struct netlink_ext_ack *extack)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> +	int ret;
>  
>  	if (vlan_filtering) {
> -		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> -			  QCA8K_PORT_LOOKUP_VLAN_MODE,
> -			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
> +		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> +				QCA8K_PORT_LOOKUP_VLAN_MODE,
> +				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
>  	} else {
> -		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> -			  QCA8K_PORT_LOOKUP_VLAN_MODE,
> -			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
> +		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> +				QCA8K_PORT_LOOKUP_VLAN_MODE,
> +				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
>  	}
>  
> -	return 0;
> +	return ret < 0 ? ret : 0;

What does qca8k_rmw() actually return?

     Andrew
