Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56A93FCF60
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 23:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhHaV4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 17:56:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232930AbhHaV4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 17:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=k1/rSYg6WsYp4LWCuQniMNUeD6v5qygPUI6I9l4QrGM=; b=JrbwPy+2/mT2R5088LS59W7Z+6
        1YACKFtvXaWUnFYKnh+uFXt8BweVQ6+ZCmEJ7TeLpMR4FYUqQcGQ06NPiZybre76s2TfunuXEqaTI
        dBmwL5yKE2vKkpibPRqRQNQ/CEYqC9QIfAdIshq73mqffLNc0y6JTGFdWl/Thb+6eZzw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLBir-004lSX-AX; Tue, 31 Aug 2021 23:55:13 +0200
Date:   Tue, 31 Aug 2021 23:55:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] tsnep: Add TSN endpoint Ethernet MAC
 driver
Message-ID: <YS6lQejOJJCATMCp@lunn.ch>
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-4-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831193425.26193-4-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int tsnep_ethtool_set_priv_flags(struct net_device *netdev,
> +					u32 priv_flags)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	int retval;
> +
> +	if (priv_flags & ~TSNEP_PRIV_FLAGS)
> +		return -EINVAL;
> +
> +	if ((priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_100) &&
> +	    (priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_1000))
> +		return -EINVAL;
> +
> +	if ((priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_100) &&
> +	    adapter->loopback != SPEED_100) {
> +		if (adapter->loopback != SPEED_UNKNOWN)
> +			retval = phy_loopback(adapter->phydev, false);
> +		else
> +			retval = 0;
> +
> +		if (!retval) {
> +			adapter->phydev->speed = SPEED_100;
> +			adapter->phydev->duplex = DUPLEX_FULL;
> +			retval = phy_loopback(adapter->phydev, true);

This is a pretty unusual use of private flags, changing loopback at
runtime. ethtool --test generally does that.

What is your use case which requires loopback in normal operation, not
during testing?

> +static irqreturn_t tsnep_irq(int irq, void *arg)
> +{
> +	struct tsnep_adapter *adapter = arg;
> +	u32 active = ioread32(adapter->addr + ECM_INT_ACTIVE);
> +
> +	/* acknowledge interrupt */
> +	if (active != 0)
> +		iowrite32(active, adapter->addr + ECM_INT_ACKNOWLEDGE);
> +
> +	/* handle management data interrupt */
> +	if ((active & ECM_INT_MD) != 0) {
> +		adapter->md_active = false;
> +		wake_up_interruptible(&adapter->md_wait);
> +	}
> +
> +	/* handle link interrupt */
> +	if ((active & ECM_INT_LINK) != 0) {
> +		if (adapter->netdev->phydev) {
> +			struct phy_device *phydev = adapter->netdev->phydev;
> +			u32 status = ioread32(adapter->addr + ECM_STATUS);
> +			int link = (status & ECM_NO_LINK) ? 0 : 1;
> +			u32 speed = status & ECM_SPEED_MASK;

How does PHY link and speed get into this MAC register? Is the MAC
polling the PHY over the MDIO bus? Is the PHY internal to the MAC and
it has backdoor access to the PHY status?

> +static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct tsnep_adapter *adapter = bus->priv;
> +	u32 md;
> +	int retval;
> +
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	/* management data frame without preamble */
> +	md = ECM_MD_READ;

I know some PHYs are happy to work without a preamble. But as far as i
know, 802.3 c22 does not say it is optional. So this needs to be an
opt-in feature, for when you know all the devices on the bus support
it. We have a standard DT property for this. See mdio.yaml,
suppress-preamble. Please look for this in the DT blob, and only
suppress the pre-amble if it is present.

> +	md |= (regnum << ECM_MD_ADDR_SHIFT) & ECM_MD_ADDR_MASK;
> +	md |= ECM_MD_PHY_ADDR_FLAG;
> +	md |= (addr << ECM_MD_PHY_ADDR_SHIFT) & ECM_MD_PHY_ADDR_MASK;
> +	adapter->md_active = true;
> +	iowrite32(md, adapter->addr + ECM_MD_CONTROL);
> +	retval = wait_event_interruptible(adapter->md_wait,
> +					  !adapter->md_active);

It is pretty normal to have some sort of timeout here. So maybe use
wait_event_interruptible_timeout()?

> +static void tsnep_phy_link_status_change(struct net_device *netdev)
> +{
> +	phy_print_status(netdev->phydev);
> +}

There is normally something here, like telling the MAC what speed it
should run at.


>  +static int tsnep_phy_open(struct tsnep_adapter *adapter)
> +{
> +	struct phy_device *phydev;
> +	struct ethtool_eee ethtool_eee;
> +	int retval;
> +
> +	retval = phy_connect_direct(adapter->netdev, adapter->phydev,
> +				    tsnep_phy_link_status_change,
> +				    adapter->phy_mode);
> +	if (retval)
> +		return retval;
> +	phydev = adapter->netdev->phydev;
> +
> +	/* MAC supports only 100Mbps|1000Mbps full duplex
> +	 * SPE (Single Pair Ethernet) is also an option but not implemented yet
> +	 */
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +
> +	/* disable EEE autoneg, EEE not supported by TSNEP */
> +	memset(&ethtool_eee, 0, sizeof(ethtool_eee));
> +	phy_ethtool_set_eee(adapter->phydev, &ethtool_eee);
> +
> +	adapter->phydev->irq = PHY_MAC_INTERRUPT;
> +	phy_start(adapter->phydev);
> +	phy_start_aneg(adapter->phydev);

No need to call phy_start_aneg(). 

> +static int tsnep_phy_init(struct tsnep_adapter *adapter)
> +{
> +	struct device_node *dn;
> +	int retval;
> +
> +	retval = of_get_phy_mode(adapter->pdev->dev.of_node,
> +				 &adapter->phy_mode);
> +	if (retval)
> +		adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
> +
> +	dn = of_parse_phandle(adapter->pdev->dev.of_node, "phy-handle", 0);
> +	adapter->phydev = of_phy_find_device(dn);
> +	of_node_put(dn);
> +	if (!adapter->phydev && adapter->mdiobus)
> +		adapter->phydev = phy_find_first(adapter->mdiobus);

Do you actually need phy_find_first()? It is better to have it in DT.

> +	if (!adapter->phydev)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int tsnep_probe(struct platform_device *pdev)
> +{

...

> +	dev_info(&adapter->pdev->dev, "device version %d.%02d\n", version,
> +		 revision);
> +	if (adapter->gate_control)
> +		dev_info(&adapter->pdev->dev, "gate control detected\n");
> +
> +	return 0;
> +
> +	unregister_netdev(adapter->netdev);

How do you get here? Is gcc is warning about unreachable code?

> +register_failed:
> +	tsnep_tc_cleanup(adapter);
> +tc_init_failed:
> +	tsnep_ptp_cleanup(adapter);
> +ptp_init_failed:
> +phy_init_failed:
> +	if (adapter->mdiobus)
> +		mdiobus_unregister(adapter->mdiobus);
> +mdio_init_failed:
> +mac_init_failed:
> +	return retval;
> +}

  Andrew
