Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D4F9B482
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436731AbfHWQap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:30:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388826AbfHWQao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 12:30:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=awuwnE92Er2PK628thfY5rV7b5FrmsaiwMNv462F5W0=; b=nVycf3ePO/M/WEfw2za9u1NDET
        tVumvy5/sw0cJFdUqQjfcDSDZ7QGM2zFAqJpnJRbgIhDaz5F2tkJ7m+xYG+Ay92Oqd1nP/2qHUnQt
        RsQS60LcCsV5RLJC++BSwpX4rWsQYIRImJg/qXkKDQVd7i1ksLdkCKblL2VMn//lWppI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1CST-0005Lu-TP; Fri, 23 Aug 2019 18:30:37 +0200
Date:   Fri, 23 Aug 2019 18:30:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next] dpaa2-eth: Add pause frame support
Message-ID: <20190823163037.GA19727@lunn.ch>
References: <1566573579-9940-1-git-send-email-ruxandra.radulescu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566573579-9940-1-git-send-email-ruxandra.radulescu@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> @@ -78,29 +78,20 @@ static int
>  dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
>  			     struct ethtool_link_ksettings *link_settings)
>  {
> -	struct dpni_link_state state = {0};
> -	int err = 0;
>  	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
>  
> -	err = dpni_get_link_state(priv->mc_io, 0, priv->mc_token, &state);
> -	if (err) {
> -		netdev_err(net_dev, "ERROR %d getting link state\n", err);
> -		goto out;
> -	}
> -
>  	/* At the moment, we have no way of interrogating the DPMAC
>  	 * from the DPNI side - and for that matter there may exist
>  	 * no DPMAC at all. So for now we just don't report anything
>  	 * beyond the DPNI attributes.
>  	 */
> -	if (state.options & DPNI_LINK_OPT_AUTONEG)
> +	if (priv->link_state.options & DPNI_LINK_OPT_AUTONEG)
>  		link_settings->base.autoneg = AUTONEG_ENABLE;
> -	if (!(state.options & DPNI_LINK_OPT_HALF_DUPLEX))
> +	if (!(priv->link_state.options & DPNI_LINK_OPT_HALF_DUPLEX))
>  		link_settings->base.duplex = DUPLEX_FULL;
> -	link_settings->base.speed = state.rate;
> +	link_settings->base.speed = priv->link_state.rate;
>  
> -out:
> -	return err;
> +	return 0;

Hi Ioana

I think this patch can be broken up a bit, to help review.

It looks like this change to report state via priv->link_state should
be a separate patch. I think this change can be made without the pause
changes. That then makes the pause changes themselves simpler.

> +static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,
> +				     struct ethtool_pauseparam *pause)
> +{
> +	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
> +	u64 link_options = priv->link_state.options;
> +
> +	pause->rx_pause = !!(link_options & DPNI_LINK_OPT_PAUSE);
> +	pause->tx_pause = pause->rx_pause ^
> +			  !!(link_options & DPNI_LINK_OPT_ASYM_PAUSE);

Since you don't support auto-neg, you should set pause->autoneg to
false. It probably already is set to false, by a memset, but setting
it explicitly is a form of documentation, this hardware only supports
forced pause configuration.

> +}
> +
> +static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
> +				    struct ethtool_pauseparam *pause)
> +{
> +	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
> +	struct dpni_link_cfg cfg = {0};
> +	int err;
> +
> +	if (!dpaa2_eth_has_pause_support(priv)) {
> +		netdev_info(net_dev, "No pause frame support for DPNI version < %d.%d\n",
> +			    DPNI_PAUSE_VER_MAJOR, DPNI_PAUSE_VER_MINOR);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (pause->autoneg)
> +		netdev_err(net_dev, "Pause frame autoneg not supported\n");

And here you should return -EOPNOTSUPP. No need for an netdev_err. It
is not an error, you simply don't support it.

There is also the issue of what is the PHY doing? It would not be good
if the MAC is configured one way, but the PHY is advertising something
else. So it appears you have no control over the PHY. But i assume you
know what the PHY is actually doing? Does it advertise pause/asym
pause?

It might be, to keep things consistent, we only accept pause
configuration when auto-neg in general is disabled.

   Andrew
