Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A12A2C7395
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389247AbgK1Vt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387519AbgK1TY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 14:24:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kj5pK-009HRH-ID; Sat, 28 Nov 2020 20:24:10 +0100
Date:   Sat, 28 Nov 2020 20:24:10 +0100
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
Message-ID: <20201128192410.GG2191767@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133307.2969817-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void sparx5_attr_stp_state_set(struct sparx5_port *port,
> +				      struct switchdev_trans *trans,
> +				      u8 state)
> +{
> +	struct sparx5 *sparx5 = port->sparx5;
> +
> +	if (!test_bit(port->portno, sparx5->bridge_mask)) {
> +		netdev_err(port->ndev,
> +			   "Controlling non-bridged port %d?\n", port->portno);
> +		return;
> +	}
> +
> +	switch (state) {
> +	case BR_STATE_FORWARDING:
> +		set_bit(port->portno, sparx5->bridge_fwd_mask);
> +		break;
> +	default:
> +		clear_bit(port->portno, sparx5->bridge_fwd_mask);
> +		break;
> +	}

That is pretty odd. What about listening, learning, blocking?

> +static int sparx5_port_bridge_join(struct sparx5_port *port,
> +				   struct net_device *bridge)
> +{
> +	struct sparx5 *sparx5 = port->sparx5;
> +
> +	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
> +		/* First bridged port */
> +		sparx5->hw_bridge_dev = bridge;
> +	else
> +		if (sparx5->hw_bridge_dev != bridge)
> +			/* This is adding the port to a second bridge, this is
> +			 * unsupported
> +			 */
> +			return -ENODEV;
> +
> +	set_bit(port->portno, sparx5->bridge_mask);
> +
> +	/* Port enters in bridge mode therefor don't need to copy to CPU
> +	 * frames for multicast in case the bridge is not requesting them
> +	 */
> +	__dev_mc_unsync(port->ndev, sparx5_mc_unsync);
> +
> +	return 0;
> +}

This looks suspiciously empty? Don't you need to tell the hardware
which ports this port is bridges to? Normally you see some code which
walks all the ports and finds those in the same bridge, and sets a bit
which allows these ports to talk to each other. Is that code somewhere
else?

	Andrew
