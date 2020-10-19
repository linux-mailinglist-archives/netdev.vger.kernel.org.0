Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3C229309C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbgJSVgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:36:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733051AbgJSVgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:36:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUcpa-002Yi1-Bf; Mon, 19 Oct 2020 23:36:38 +0200
Date:   Mon, 19 Oct 2020 23:36:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX
 mode
Message-ID: <20201019213638.GW139700@lunn.ch>
References: <20201019203923.467065-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019203923.467065-1-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
>  			       const struct phylink_link_state *state)
>  {
> -	/* nothing meaningful to do */
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct axienet_local *lp = netdev_priv(ndev);
> +	int ret;
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		ret = phylink_mii_c22_pcs_config(lp->pcs_phy, mode,
> +						 state->interface,
> +						 state->advertising);
> +		if (ret < 0)
> +			netdev_warn(ndev, "Failed to configure PCS: %d\n",
> +				    ret);
> +
> +		/* Ensure isolate bit is cleared */
> +		ret = mdiobus_modify(lp->pcs_phy->bus, lp->pcs_phy->addr,
> +				     MII_BMCR, BMCR_ISOLATE, 0);

Hi Robert

That looks like a layering violation. Maybe move this into
phylink_mii_c22_pcs_config(), it is accessing MII_BMCR anyway.

      Andrew
