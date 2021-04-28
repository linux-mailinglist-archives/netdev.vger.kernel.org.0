Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B122336D741
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbhD1M1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:27:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44408 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235924AbhD1M1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 08:27:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbjGw-001Vf0-KD; Wed, 28 Apr 2021 14:26:30 +0200
Date:   Wed, 28 Apr 2021 14:26:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com,
        netdev@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH V3 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Message-ID: <YIlUdprPfqa5d2ez@lunn.ch>
References: <20210428074107.2378-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428074107.2378-1-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
> -	u32 support = WAKE_MAGIC | WAKE_UCAST;
> +	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
> +	u32 support = WAKE_MAGIC | WAKE_UCAST | WAKE_MAGICSECURE | WAKE_BCAST;

Reverse christmass tree please.

>  
> -	if (!device_can_wakeup(priv->device))
> -		return -EOPNOTSUPP;
> +	if (wol->wolopts & ~support)
> +		return -EINVAL;

Maybe -EOPNOTSUPP would be better.

>  
> -	if (!priv->plat->pmt) {
> +	/* First check if can WoL from PHY */
> +	phylink_ethtool_get_wol(priv->phylink, &wol_phy);

This could return an error. In which case, you probably should not
trust wol_phy.

> +	if (wol->wolopts & wol_phy.supported) {

This returns true if the PHY supports one or more of the requested WoL
sources.

>  		int ret = phylink_ethtool_set_wol(priv->phylink, wol);

and here you request the PHY to enable all the requested WoL
sources. If it only supports a subset, it is likely to return
-EOPNOTSUPP, or -EINVAL, and do nothing. So here you only want to
enable those sources the PHY actually supports. And let the MAC
implement the rest.

	  Andrew
