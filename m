Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FE4373346
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhEEAmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:42:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53408 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEAmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 20:42:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5bQ-002Yxc-UD; Wed, 05 May 2021 02:41:24 +0200
Date:   Wed, 5 May 2021 02:41:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 06/20] net: dsa: qca8k: handle error with
 qca8k_write operation
Message-ID: <YJHptHS8eN2gGaRd@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-6-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static void
> +static int
>  qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
>  {
> +	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
>  	int ret;
>  
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
> -	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
>  
>  	ret = qca8k_set_page(priv->bus, page);
>  	if (ret < 0)
> @@ -183,6 +184,7 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
>  
>  exit:
>  	mutex_unlock(&priv->bus->mdio_lock);
> +	return ret;
>  }

Same comment as read. Maybe put this and the other similar change into one patch.

> @@ -636,7 +660,9 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
>  	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
>  	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
>  
> -	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
> +	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
> +	if (ret)
> +		return ret;
>  
>  	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
>  			    QCA8K_MDIO_MASTER_BUSY))
> @@ -767,12 +793,18 @@ qca8k_setup(struct dsa_switch *ds)
>  		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
>  
>  	/* Enable MIB counters */
> -	qca8k_mib_init(priv);
> +	ret = qca8k_mib_init(priv);
> +	if (ret)
> +		pr_warn("mib init failed");

Please use dev_warn().

>  
>  	/* Enable QCA header mode on the cpu port */
> -	qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
> -		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
> -		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
> +	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
> +			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
> +			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
> +	if (ret) {
> +		pr_err("failed enabling QCA header mode");

dev_err()

In general, always use dev_err(), dev_warn(), dev_info() etc, so we
know which device returned an error.

     Andrew
