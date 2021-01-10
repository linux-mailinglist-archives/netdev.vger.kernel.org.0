Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EA82F08C1
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbhAJReV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:34:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbhAJReV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 12:34:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyeas-00HLTA-Sj; Sun, 10 Jan 2021 18:33:34 +0100
Date:   Sun, 10 Jan 2021 18:33:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org
Subject: Re: [PATCH RFC net-next  14/19] net: mvpp2: add ethtool flow control
 configuration support
Message-ID: <X/s6bkkoq4HVbLR+@lunn.ch>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-15-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-15-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -5373,6 +5402,30 @@ static int mvpp2_ethtool_set_pause_param(struct net_device *dev,
>  					 struct ethtool_pauseparam *pause)
>  {
>  	struct mvpp2_port *port = netdev_priv(dev);
> +	int i;
> +
> +	if (pause->tx_pause && port->priv->global_tx_fc) {
> +		port->tx_fc = true;
> +		mvpp2_rxq_enable_fc(port);
> +		if (port->priv->percpu_pools) {
> +			for (i = 0; i < port->nrxqs; i++)
> +				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i], true);
> +		} else {
> +			mvpp2_bm_pool_update_fc(port, port->pool_long, true);
> +			mvpp2_bm_pool_update_fc(port, port->pool_short, true);
> +		}
> +
> +	} else if (port->priv->global_tx_fc) {
> +		port->tx_fc = false;
> +		mvpp2_rxq_disable_fc(port);
> +		if (port->priv->percpu_pools) {
> +			for (i = 0; i < port->nrxqs; i++)
> +				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i], false);
> +		} else {
> +			mvpp2_bm_pool_update_fc(port, port->pool_long, false);
> +			mvpp2_bm_pool_update_fc(port, port->pool_short, false);
> +		}
> +	}


This looks wrong. Flow control is normally the result of auto
negotiation. Both ends need to agree to it. Which is why
mvpp2_ethtool_set_pause_param() passes the users request onto phylink.
phylink will handle the autoneg and then ask the MAC to setup flow
control depending on the result in mvpp2_mac_link_up().

	Andrew
