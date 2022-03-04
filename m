Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369B34CD0FD
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbiCDJ0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiCDJ0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:26:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FA2EA767;
        Fri,  4 Mar 2022 01:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WKflogar9XXH27SbWEKtvOrLXzLKB9hwmFagW/PHySQ=; b=Z64cFBQc5olNq/QAFIZkaQEE2z
        rBiZcs1GOTPMYnR1A+HJgQO6Kn4C54Gs4P2r1X0b5+phWLxHsmZ/XhipbzCnx18VMF29ZeIgojQvC
        wjgAmeMB5biqHcw4tD3ZlSu+nZrOkaAyJHyo8QfWdaqHUlA+4/r+j+ASjWUbIsx66Kk8WCrIn8vBU
        4mi/Qs/1TIAJMrupuEK/lNYI4y1+gcwl4ZHwwCFCNZ6p+ZHomZ4YineJMvkkfQl70w6KZ9YJ/VYWw
        A2d2jn3YUmhcllyrxZqWGm3w6d+0hVuJkeAkvRaWTC8X+K1EP9gv7fOX1PkPF7pi2naYRoREgEgtx
        K1ICK9Dw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57618)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nQ4Bc-0004IU-7h; Fri, 04 Mar 2022 09:25:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nQ4Ba-0001yF-M9; Fri, 04 Mar 2022 09:25:18 +0000
Date:   Fri, 4 Mar 2022 09:25:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, vigneshr@ti.com,
        grygorii.strashko@ti.com
Subject: Re: [RESEND PATCH] net: ethernet: ti: am65-cpsw: Convert to PHYLINK
Message-ID: <YiHa/himI3WJVOhy@shell.armlinux.org.uk>
References: <20220304075812.1723-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304075812.1723-1-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 04, 2022 at 01:28:12PM +0530, Siddharth Vadapalli wrote:
> Convert am65-cpsw driver and am65-cpsw ethtool to use Phylink APIs
> as described at Documentation/networking/sfp-phylink.rst. All calls
> to Phy APIs are replaced with their equivalent Phylink APIs.

Okay, that's what you're doing, but please mention what the reason for
the change is.

> @@ -1494,6 +1409,87 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
>  	.ndo_get_devlink_port   = am65_cpsw_ndo_get_devlink_port,
>  };
>  
> +static void am65_cpsw_nuss_validate(struct phylink_config *config, unsigned long *supported,
> +				    struct phylink_link_state *state)
> +{
> +	phylink_generic_validate(config, supported, state);
> +}

If you don't need anything special, please just initialise the member
directly:

	.validate = phylink_generic_validate,

> +
> +static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
> +				      const struct phylink_link_state *state)
> +{
> +	/* Currently not used */
> +}
> +
> +static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned int mode,
> +					 phy_interface_t interface)
> +{
> +	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
> +							  phylink_config);
> +	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
> +	struct am65_cpsw_common *common = port->common;
> +	struct net_device *ndev = port->ndev;
> +	int tmo;
> +
> +	/* disable forwarding */
> +	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_DISABLE);
> +
> +	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
> +
> +	tmo = cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
> +	dev_dbg(common->dev, "down msc_sl %08x tmo %d\n",
> +		cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);
> +
> +	cpsw_sl_ctl_reset(port->slave.mac_sl);
> +
> +	am65_cpsw_qos_link_down(ndev);
> +	netif_tx_disable(ndev);

You didn't call netif_tx_disable() in your adjust_link afaics, so why
is it added here?

> +}
> +
> +static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy_device *phy,
> +				       unsigned int mode, phy_interface_t interface, int speed,
> +				       int duplex, bool tx_pause, bool rx_pause)
> +{
> +	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
> +							  phylink_config);
> +	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
> +	struct am65_cpsw_common *common = port->common;
> +	struct net_device *ndev = port->ndev;
> +	u32 mac_control = CPSW_SL_CTL_GMII_EN;
> +
> +	if (speed == SPEED_1000)
> +		mac_control |= CPSW_SL_CTL_GIG;
> +	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
> +		/* Can be used with in band mode only */
> +		mac_control |= CPSW_SL_CTL_EXT_EN;
> +	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
> +		mac_control |= CPSW_SL_CTL_IFCTL_A;
> +	if (duplex)
> +		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
> +
> +	/* rx_pause/tx_pause */
> +	if (rx_pause)
> +		mac_control |= CPSW_SL_CTL_RX_FLOW_EN;
> +
> +	if (tx_pause)
> +		mac_control |= CPSW_SL_CTL_TX_FLOW_EN;
> +
> +	cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
> +
> +	/* enable forwarding */
> +	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
> +
> +	am65_cpsw_qos_link_up(ndev, speed);
> +	netif_tx_wake_all_queues(ndev);
> +}
> +
> +static const struct phylink_mac_ops am65_cpsw_phylink_mac_ops = {
> +	.validate = am65_cpsw_nuss_validate,
> +	.mac_config = am65_cpsw_nuss_mac_config,
> +	.mac_link_down = am65_cpsw_nuss_mac_link_down,
> +	.mac_link_up = am65_cpsw_nuss_mac_link_up,
> +};
> +
>  static void am65_cpsw_nuss_slave_disable_unused(struct am65_cpsw_port *port)
>  {
>  	struct am65_cpsw_common *common = port->common;
> @@ -1887,24 +1883,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
>  				of_property_read_bool(port_np, "ti,mac-only");
>  
>  		/* get phy/link info */
> -		if (of_phy_is_fixed_link(port_np)) {
> -			ret = of_phy_register_fixed_link(port_np);
> -			if (ret)
> -				return dev_err_probe(dev, ret,
> -						     "failed to register fixed-link phy %pOF\n",
> -						     port_np);
> -			port->slave.phy_node = of_node_get(port_np);
> -		} else {
> -			port->slave.phy_node =
> -				of_parse_phandle(port_np, "phy-handle", 0);
> -		}
> -
> -		if (!port->slave.phy_node) {
> -			dev_err(dev,
> -				"slave[%d] no phy found\n", port_id);
> -			return -ENODEV;
> -		}
> -
> +		port->slave.phy_node = port_np;
>  		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
>  		if (ret) {
>  			dev_err(dev, "%pOF read phy-mode err %d\n",
> @@ -1947,6 +1926,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
>  	struct am65_cpsw_ndev_priv *ndev_priv;
>  	struct device *dev = common->dev;
>  	struct am65_cpsw_port *port;
> +	struct phylink *phylink;
>  	int ret;
>  
>  	port = &common->ports[port_idx];
> @@ -1984,6 +1964,26 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
>  	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
>  	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
>  
> +	/* Configuring Phylink */
> +	port->slave.phylink_config.dev = &port->ndev->dev;
> +	port->slave.phylink_config.type = PHYLINK_NETDEV;
> +	port->slave.phylink_config.pcs_poll = true;

Does this compile? This member was removed, so you probably get a
compile error today.

> +	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
> +	MAC_100 | MAC_1000FD | MAC_2500FD;
> +
> +	phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_SGMII, port->slave.phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_1000BASEX, port->slave.phylink_config.supported_interfaces);

If you support SGMII and 1000BASE-X with inband signalling, I strongly
recommend that you implement phylink_pcs support as well, so you are
able to provide phylink with the inband results.

> +
> +	phylink = phylink_create(&port->slave.phylink_config, dev->fwnode, port->slave.phy_if,
> +				 &am65_cpsw_phylink_mac_ops);
> +	if (IS_ERR(phylink)) {
> +		phylink_destroy(port->slave.phylink);

This is wrong and will cause a NULL pointer dereference - please remove
the call to phylink_destroy() here.

However, I could not find another call to phylink_destroy() in your
patch which means you will leak memory when the driver is unbound.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
