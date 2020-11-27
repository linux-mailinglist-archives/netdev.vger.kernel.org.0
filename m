Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCC22C6A7B
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgK0RPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:15:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbgK0RPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 12:15:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kihKs-0099nq-Kt; Fri, 27 Nov 2020 18:15:06 +0100
Date:   Fri, 27 Nov 2020 18:15:06 +0100
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
Message-ID: <20201127171506.GW2073444@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133307.2969817-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a very large driver, which is going to make it slow to review.

> +static int sparx5_probe_port(struct sparx5 *sparx5,
> +			     struct device_node *portnp,
> +			     struct phy *serdes,
> +			     u32 portno,
> +			     struct sparx5_port_config *conf)
> +{
> +	phy_interface_t phy_mode = conf->phy_mode;
> +	struct sparx5_port *spx5_port;
> +	struct net_device *ndev;
> +	struct phylink *phylink;
> +	int err;
> +
> +	err = sparx5_create_targets(sparx5);
> +	if (err)
> +		return err;
> +	ndev = sparx5_create_netdev(sparx5, portno);
> +	if (IS_ERR(ndev)) {
> +		dev_err(sparx5->dev, "Could not create net device: %02u\n", portno);
> +		return PTR_ERR(ndev);
> +	}
> +	spx5_port = netdev_priv(ndev);
> +	spx5_port->of_node = portnp;
> +	spx5_port->serdes = serdes;
> +	spx5_port->pvid = NULL_VID;
> +	spx5_port->signd_internal = true;
> +	spx5_port->signd_active_high = true;
> +	spx5_port->signd_enable = true;
> +	spx5_port->flow_control = false;
> +	spx5_port->max_vlan_tags = SPX5_PORT_MAX_TAGS_NONE;
> +	spx5_port->vlan_type = SPX5_VLAN_PORT_TYPE_UNAWARE;
> +	spx5_port->custom_etype = 0x8880; /* Vitesse */
> +	conf->portmode = conf->phy_mode;
> +	spx5_port->conf.speed = SPEED_UNKNOWN;
> +	spx5_port->conf.power_down = true;
> +	sparx5->ports[portno] = spx5_port;


> +struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
> +{
> +	struct net_device *ndev;
> +	struct sparx5_port *spx5_port;
> +	int err;
> +
> +	ndev = devm_alloc_etherdev(sparx5->dev, sizeof(struct sparx5_port));
> +	if (!ndev)
> +		return ERR_PTR(-ENOMEM);
> +

...

> +	err = register_netdev(ndev);
> +	if (err) {
> +		dev_err(sparx5->dev, "netdev registration failed\n");
> +		return ERR_PTR(err);
> +	}

This is one of the classic bugs in network drivers. As soon as you
call register_netdev() the interface is live. The network stack can
start using it. But you have not finished initialzing spx5_port. So
bad things are going to happen.

    Andrew
