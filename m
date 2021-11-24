Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D39145B846
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhKXKYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhKXKYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 05:24:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53644C061714;
        Wed, 24 Nov 2021 02:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pCdjSOsXdGlJ8+cnfMdWcEIa7d9zwXe6ePu8SPJAXxE=; b=tpIyUYXQ878LgsAQPafzOhlRlO
        A4BNgBGfLV6gzbhDXUzCjj7NUPYH/Kh/agDOWSCe1/JeayXJin91Yd5i5X2Y5icdQf42iB5jynOUs
        jdi1x9HfEOeEPsLMVU0BuGoyTVZAm7E+fU4jM2T3k5fpKW5Ucrbwj6KE3HH/ONNsDodmnIvTNkVaO
        sTL6GbupSmM8L9XL7deMYKa+FVs32wEhXILU62F7jG6nKWnSrGTcRDN2eLSOFbh2L3MLdNkTaFeXc
        +chdy1lEXQY13EZKLsFFfV3KNL7BeKtJvypEL9isGWtjnZ4/vCtctBNbM/md33ux2BhauzNcWAj2W
        JDSJpISg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55832)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mppOb-0000Sc-12; Wed, 24 Nov 2021 10:20:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mppOZ-00017G-AK; Wed, 24 Nov 2021 10:20:55 +0000
Date:   Wed, 24 Nov 2021 10:20:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/6] net: lan966x: add port module support
Message-ID: <YZ4SB/wX6UT3zrEV@shell.armlinux.org.uk>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
 <20211124083915.2223065-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124083915.2223065-4-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Nov 24, 2021 at 09:39:12AM +0100, Horatiu Vultur wrote:
> +static int lan966x_port_open(struct net_device *dev)
> +{
> +	struct lan966x_port *port = netdev_priv(dev);
> +	struct lan966x *lan966x = port->lan966x;
> +	int err;
> +
> +	if (port->serdes) {
> +		err = phy_set_mode_ext(port->serdes, PHY_MODE_ETHERNET,
> +				       port->config.phy_mode);
> +		if (err) {
> +			netdev_err(dev, "Could not set mode of SerDes\n");
> +			return err;
> +		}
> +	}

This could be done in the mac_prepare() method.

> +static void lan966x_cleanup_ports(struct lan966x *lan966x)
> +{
> +	struct lan966x_port *port;
> +	int portno;
> +
> +	for (portno = 0; portno < lan966x->num_phys_ports; portno++) {
> +		port = lan966x->ports[portno];
> +		if (!port)
> +			continue;
> +
> +		if (port->phylink) {
> +			rtnl_lock();
> +			lan966x_port_stop(port->dev);
> +			rtnl_unlock();
> +			phylink_destroy(port->phylink);
> +			port->phylink = NULL;
> +		}
> +
> +		if (port->fwnode)
> +			fwnode_handle_put(port->fwnode);
> +
> +		if (port->dev)
> +			unregister_netdev(port->dev);

This doesn't look like the correct sequence to me. Shouldn't the net
device be unregistered first, which will take the port down by doing
so and make it unavailable to userspace to further manipulate. Then
we should start tearing other stuff down such as destroying phylink
and disabling interrupts (in the caller of this.)

Don't you need to free the netdev as well at some point?

>  static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
> -			      phy_interface_t phy_mode)
> +			      phy_interface_t phy_mode,
> +			      struct fwnode_handle *portnp)
>  {
...
> +	port->phylink_config.dev = &port->dev->dev;
> +	port->phylink_config.type = PHYLINK_NETDEV;
> +	port->phylink_config.pcs_poll = true;
> +	port->phylink_pcs.poll = true;

You don't need to set both of these - please omit
port->phylink_config.pcs_poll.

> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 7a1ff9d19fbf..ce2798db0449 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
...
> @@ -44,15 +58,48 @@ struct lan966x {
>  	void __iomem *regs[NUM_TARGETS];
>  
>  	int shared_queue_sz;
> +
> +	/* interrupts */
> +	int xtr_irq;
> +};
> +
> +struct lan966x_port_config {
> +	phy_interface_t portmode;
> +	phy_interface_t phy_mode;

What is the difference between "portmode" and "phy_mode"? Does it matter
if port->config.phy_mode get zeroed when lan966x_port_pcs_set() is
called from lan966x_pcs_config()? It looks to me like the first call
will clear phy_mode, setting it to PHY_INTERFACE_MODE_NA from that point
on.

> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> new file mode 100644
> index 000000000000..ca1b0c8d1bf5
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> @@ -0,0 +1,422 @@
...
> +void lan966x_port_status_get(struct lan966x_port *port,
> +			     struct phylink_link_state *state)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +	u16 lp_adv, ld_adv;
> +	bool link_down;
> +	u16 bmsr = 0;
> +	u32 val;
> +
> +	val = lan_rd(lan966x, DEV_PCS1G_STICKY(port->chip_port));
> +	link_down = DEV_PCS1G_STICKY_LINK_DOWN_STICKY_GET(val);
> +	if (link_down)
> +		lan_wr(val, lan966x, DEV_PCS1G_STICKY(port->chip_port));
> +
> +	/* Get both current Link and Sync status */
> +	val = lan_rd(lan966x, DEV_PCS1G_LINK_STATUS(port->chip_port));
> +	state->link = DEV_PCS1G_LINK_STATUS_LINK_STATUS_GET(val) &&
> +		      DEV_PCS1G_LINK_STATUS_SYNC_STATUS_GET(val);
> +	state->link &= !link_down;
> +
> +	if (port->config.portmode == PHY_INTERFACE_MODE_1000BASEX)
> +		state->speed = SPEED_1000;
> +	else if (port->config.portmode == PHY_INTERFACE_MODE_2500BASEX)
> +		state->speed = SPEED_2500;

Why not use state->interface? state->interface will be the currently
configured interface mode (which should be the same as your
port->config.portmode.)

> +
> +	state->duplex = DUPLEX_FULL;

Also, what is the purpose of initialising state->speed and state->duplex
here? phylink_mii_c22_pcs_decode_state() will do that for you when
decoding the advertisements.

If it's to deal with autoneg disabled, then it ought to be conditional on
autoneg being disabled and the link being up.

> +
> +	/* Get PCS ANEG status register */
> +	val = lan_rd(lan966x, DEV_PCS1G_ANEG_STATUS(port->chip_port));
> +
> +	/* Aneg complete provides more information  */
> +	if (DEV_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(val)) {
> +		lp_adv = DEV_PCS1G_ANEG_STATUS_LP_ADV_GET(val);
> +		state->an_complete = true;
> +
> +		bmsr |= state->link ? BMSR_LSTATUS : 0;
> +		bmsr |= state->an_complete;

Shouldn't this be setting BMSR_ANEGCOMPLETE?

> +
> +		if (port->config.portmode == PHY_INTERFACE_MODE_SGMII) {
> +			phylink_mii_c22_pcs_decode_state(state, bmsr, lp_adv);
> +		} else {
> +			val = lan_rd(lan966x, DEV_PCS1G_ANEG_CFG(port->chip_port));
> +			ld_adv = DEV_PCS1G_ANEG_CFG_ADV_ABILITY_GET(val);
> +			phylink_mii_c22_pcs_decode_state(state, bmsr, ld_adv);
> +		}

This looks like it can be improved:

	if (DEV_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(val)) {
		state->an_complete = true;

		bmsr |= state->link ? BMSR_LSTATUS : 0;
		bmsr |= BMSR_ANEGCOMPLETE;

		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
			lp_adv = DEV_PCS1G_ANEG_STATUS_LP_ADV_GET(val);
		} else {
			val = lan_rd(lan966x, DEV_PCS1G_ANEG_CFG(port->chip_port));
			lp_adv = DEV_PCS1G_ANEG_CFG_ADV_ABILITY_GET(val);
		}

		phylink_mii_c22_pcs_decode_state(state, bmsr, lp_adv);
	}

I'm not sure that the non-SGMII code is actually correct though. Which
advertisement are you extracting by reading the DEV_PCS1G_ANEG_CFG
register and extracting DEV_PCS1G_ANEG_CFG_ADV_ABILITY_GET ? From the
code in lan966x_port_pcs_set(), it suggests this is our advertisement,
but it's supposed to always be the link partner's advertisement being
passed to phylink_mii_c22_pcs_decode_state().

> +int lan966x_port_pcs_set(struct lan966x_port *port,
> +			 struct lan966x_port_config *config)
> +{
...
> +	port->config = *config;

As mentioned elsewhere, "config" won't have phy_mode set, so this clears
port->config.phymode to PHY_INTERFACE_MODE_NA, which I think will cause
e.g. lan966x_port_link_up() not to behave as intended.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
