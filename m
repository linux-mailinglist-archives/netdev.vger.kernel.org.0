Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56489103020
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfKSX0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:26:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59068 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfKSX0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:26:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aQNn3lNXtYAiGX23behF/h+D4Cpxf5u4acfmOkK6zC0=; b=IvQfhlf2QPTVSNSirEXcOxZBU
        xL6wuNh9aawes0QS/GvvmaE1RBzeOv3zGXU6VEZ4yeOGf3FDqF99uYGChnVKe9woGcX1Nll4XIbr8
        3BjcSigWLcLKCUeVQe9XgynDIb0H7d9IYel2mQhqMk6Sq4un5Yy8HkVsrmgoHqF+FMxJYZJYlN5JF
        lO07auOXxZeNLt+Xys/oQw53Mc4cdFg6pLBAMSntD7wgkMxjzoU3CvsHtyIjV9fnZSldYOF1i99q6
        Q1MChAb/38R9E2BFAoAEmWOU5atSDHI/Jyfow7QDYztGkXknQYztXNNyhgOCiWQ0bwOxME/312F8/
        jYMHSVKVg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58486)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXCsY-0004TP-7Z; Tue, 19 Nov 2019 23:25:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXCsU-00017b-CF; Tue, 19 Nov 2019 23:25:46 +0000
Date:   Tue, 19 Nov 2019 23:25:46 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: mscc: ocelot: convert to PHYLINK
Message-ID: <20191119232546.GF25745@shell.armlinux.org.uk>
References: <20191118181030.23921-1-olteanv@gmail.com>
 <20191118181030.23921-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118181030.23921-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 08:10:30PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch reworks ocelot_board.c (aka the MIPS on the VSC7514) to
> register a PHYLINK instance for each port. The registration code is
> local to the VSC7514, but the PHYLINK callback implementation is common
> so that the Felix DSA front-end can use it as well (but DSA does its own
> registration).
> 
> Now Felix can use native PHYLINK callbacks instead of the PHYLIB
> adaptation layer in DSA, which had issues supporting fixed-link slave
> ports (no struct phy_device to pass to the adjust_link callback), as
> well as fixed-link CPU port at 2.5Gbps.
> 
> The old code from ocelot_port_enable and ocelot_port_disable has been
> moved into ocelot_phylink_mac_link_up and ocelot_phylink_mac_link_down.
> 
> The PHY connect operation has been moved from ocelot_port_open to
> mscc_ocelot_probe in ocelot_board.c.
> 
> The phy_set_mode_ext() call for the SerDes PHY has also been moved into
> mscc_ocelot_probe from ocelot_port_open, and since that was the only
> reason why a reference to it was kept in ocelot_port_private, that
> reference was removed.
> 
> Again, the usage of phy_interface_t phy_mode is now local to
> mscc_ocelot_probe only, after moving the PHY connect operation.
> So it was also removed from ocelot_port_private.
> *Maybe* in the future, it can be added back to the common struct
> ocelot_port, with the purpose of validating mismatches between
> state->phy_interface and ocelot_port->phy_mode in PHYLINK callbacks.
> But at the moment that is not critical, since other DSA drivers are not
> doing that either. No SFP+ modules are in use with Felix/Ocelot yet, to
> my knowledge.
> 
> In-band AN is not yet supported, due to the fact that this is a mostly
> mechanical patch for the moment. The mac_an_restart PHYLINK operation
> needs to be implemented, as well as mac_link_state. Both are SerDes
> specific, and Felix does not have its PCS configured yet (it works just
> by virtue of U-Boot initialization at the moment).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

So the crash got me to look at the code to figure out what you're doing
with phylink.

> +int ocelot_phylink_mac_link_state(struct ocelot *ocelot, int port,
> +				  struct phylink_link_state *state)
> +{
> +	return -EOPNOTSUPP;

This does nothing useful.  Set state->link to 0 and just return 0.

> @@ -422,26 +465,24 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
>  		break;
>  	case SPEED_1000:
>  		speed = OCELOT_SPEED_1000;
> -		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
> +		mac_mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
>  		break;
>  	case SPEED_2500:
>  		speed = OCELOT_SPEED_2500;
> -		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
> +		mac_mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
>  		break;
>  	default:
>  		dev_err(ocelot->dev, "Unsupported PHY speed on port %d: %d\n",
> -			port, phydev->speed);
> +			port, state->speed);
>  		return;
>  	}
>  
> -	phy_print_status(phydev);
> -
> -	if (!phydev->link)
> +	if (!state->link)
>  		return;

Please don't use state->link, it isn't guaranteed to be correct here.
Please read the documentation that I spent time to create for folk
wanting to use phylink, and conform, or ask questions, thanks.

...

> @@ -432,16 +513,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  		if (IS_ERR(regs))
>  			continue;
>  
> -		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
> -		if (!phy_node)
> -			continue;
> -
> -		phy = of_phy_find_device(phy_node);
> -		of_node_put(phy_node);
> -		if (!phy)
> -			continue;
> -
> -		err = ocelot_probe_port(ocelot, port, regs, phy);
> +		err = ocelot_probe_port(ocelot, port, regs);

In this function, you  create and register the network device, so by the
time this function returns, the network device is available for use.
Yet, you haven't finished setting it up... so this is racy.

>  		if (err) {
>  			of_node_put(portnp);
>  			goto out_put_ports;
> @@ -453,9 +525,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  
>  		of_get_phy_mode(portnp, &phy_mode);
>  
> -		priv->phy_mode = phy_mode;
> -
> -		switch (priv->phy_mode) {
> +		switch (phy_mode) {
>  		case PHY_INTERFACE_MODE_NA:
>  			continue;

What does PHY_INTERFACE_MODE_NA mean here?  That this port is not
connected to anything?

>  		case PHY_INTERFACE_MODE_SGMII:
> @@ -492,7 +562,41 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  			goto out_put_ports;
>  		}
>  
> -		priv->serdes = serdes;
> +		if (serdes) {
> +			err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
> +					       phy_mode);
> +			if (err) {
> +				dev_err(ocelot->dev,
> +					"Could not set mode of SerDes\n");
> +				of_node_put(portnp);
> +				goto out_put_ports;
> +			}
> +		}
> +
> +		priv->phylink_config.dev = &priv->dev->dev;
> +		priv->phylink_config.type = PHYLINK_NETDEV;
> +
> +		priv->phylink = phylink_create(&priv->phylink_config,
> +					       of_fwnode_handle(portnp),
> +					       phy_mode, &ocelot_phylink_ops);
> +		if (IS_ERR(priv->phylink)) {
> +			dev_err(ocelot->dev,
> +				"Could not create a phylink instance (%ld)\n",
> +				PTR_ERR(priv->phylink));
> +			err = PTR_ERR(priv->phylink);
> +			priv->phylink = NULL;
> +			of_node_put(portnp);
> +			goto out_put_ports;
> +		}
> +
> +		err = phylink_of_phy_connect(priv->phylink, portnp, 0);
> +		if (err) {
> +			dev_err(ocelot->dev, "Could not connect to PHY: %d\n",
> +				err);
> +			phylink_destroy(priv->phylink);
> +			of_node_put(portnp);
> +			goto out_put_ports;
> +		}
>  	}
>  
>  	register_netdevice_notifier(&ocelot_netdevice_nb);
> @@ -509,12 +613,27 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  static int mscc_ocelot_remove(struct platform_device *pdev)
>  {
>  	struct ocelot *ocelot = platform_get_drvdata(pdev);
> +	int port;
>  
>  	ocelot_deinit(ocelot);
>  	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
>  	unregister_switchdev_notifier(&ocelot_switchdev_nb);
>  	unregister_netdevice_notifier(&ocelot_netdevice_nb);
>  
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		struct ocelot_port_private *priv;
> +
> +		priv = container_of(ocelot->ports[port],
> +				    struct ocelot_port_private,
> +				    port);
> +
> +		if (priv->phylink) {
> +			rtnl_lock();
> +			phylink_destroy(priv->phylink);

Deadlock waiting to happen.  You must not hold the rtnl lock while
destroying a phylink.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
