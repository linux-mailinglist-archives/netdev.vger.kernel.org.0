Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50072C73C3
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgK1Vtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732852AbgK1TEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 14:04:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kj5VO-009HKI-Ol; Sat, 28 Nov 2020 20:03:34 +0100
Date:   Sat, 28 Nov 2020 20:03:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201128190334.GE2191767@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133307.2969817-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int sparx5_port_open(struct net_device *ndev)
> +{
> +	struct sparx5_port *port = netdev_priv(ndev);
> +	int err = 0;
> +
> +	sparx5_port_enable(port, true);
> +	if (port->conf.phy_mode != PHY_INTERFACE_MODE_NA) {
> +		err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
> +		if (err) {
> +			netdev_err(ndev, "Could not attach to PHY\n");
> +			return err;
> +		}
> +	}

This looks a bit odd. PHY_INTERFACE_MODE_NA means don't touch,
something else has already configured the MAC-PHY mode in the PHY.
You should not not connect the PHY because of this.

> +void sparx5_destroy_netdev(struct sparx5 *sparx5, struct sparx5_port *port)
> +{
> +	if (port->phylink) {
> +		/* Disconnect the phy */
> +		if (rtnl_trylock()) {

Why do you use rtnl_trylock()?

    Andrew
