Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1103D687F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhGZUe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:34:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46276 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232788AbhGZUe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 16:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Yoc2z7uSUjkhWnv+tKrvr5GkQUl2nOVtSonxg9WBwAg=; b=fx8fYTsSCW+Qonl46qValLkRYL
        itn1Vur0eObChQR30YQp85ntEWfAPd3naBCSLlLPbX5huNS8U4c+mDF4Ab2hFJmTXId9l5eN1GsgW
        beKngG6niNYpyXY1+4PzYV3/bf3ck04bV1PjkYHLySD0tUHm7Mk5DeK4QqYDm8gJjQNI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m87wX-00EuuR-Cu; Mon, 26 Jul 2021 23:15:21 +0200
Date:   Mon, 26 Jul 2021 23:15:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] tsnep: Add TSN endpoint Ethernet MAC driver
Message-ID: <YP8l6cWaQU/2NoIA@lunn.ch>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726194603.14671-5-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct tsnep_adapter *adapter = bus->priv;
> +	u16 data;
> +	int retval;
> +
> +	if (adapter->loopback)
> +		return 0;
> +
> +	retval = tsnep_read_md(adapter, addr, regnum, &data);
> +	if (retval != 0)
> +		return retval;

It appears your MDIO bus can only do C22. Please add a test for C45 and return -EOPNOTSUPP.

> +static void tsnep_phy_link_status_change(struct net_device *netdev)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(netdev);
> +	struct phy_device *phydev = netdev->phydev;
> +
> +	if (adapter->loopback)
> +		return;
> +
> +	if (adapter->gmii2rgmii) {
> +		u16 val;
> +
> +		if (phydev->link && phydev->speed == 1000)
> +			val = BMCR_SPEED1000;
> +		else
> +			val = BMCR_SPEED100;
> +		tsnep_write_md(adapter, ECM_GMII2RGMII_ADDR,
> +			       ECM_GMII2RGMII_BMCR, val);
> +	}

I _think_ this is wrong. They way the PHYs are chained means you
should not need to do this, the xgmiitorgmii_read_status() does it.
Maybe you have the chaining setup wrong?

> +static int tsnep_phy_open(struct tsnep_adapter *adapter)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask);
> +	struct ethtool_eee ethtool_eee;
> +	int retval;
> +
> +	retval = phy_connect_direct(adapter->netdev, adapter->phydev,
> +				    tsnep_phy_link_status_change,
> +				    adapter->phy_mode);
> +	if (retval)
> +		return -EIO;

phy_connect_direct() returns an error code. Use it, rather than
changing it to something else. This applies everywhere. You must have
a good reason to change error codes, and then it is wise to put a
comment why you change it.

> +
> +	/* MAC supports only 100Mbps|1000Mbps full duplex
> +	 * SPE (Single Pair Ethernet) is also an option but not implemented yet
> +	 */
> +	linkmode_zero(mask);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, mask);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, mask);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, mask);
> +	linkmode_and(mask, adapter->phydev->supported, mask);
> +	linkmode_copy(adapter->phydev->supported, mask);
> +	linkmode_copy(adapter->phydev->advertising, mask);

You should not be accessing the phydev directly. Use
phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT),
etc.

> +static int tsnep_phy_init(struct tsnep_adapter *adapter)
> +{
> +	struct device_node *dn;
> +	u16 val;
> +	u32 id;
> +	int retval;
> +
> +	retval = of_get_phy_mode(adapter->pdev->dev.of_node,
> +				 &adapter->phy_mode);
> +	if (retval)
> +		adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
> +
> +	dn = of_parse_phandle(adapter->pdev->dev.of_node, "phy-handle", 0);
> +	adapter->phydev = of_phy_find_device(dn);
> +	if (!adapter->phydev)
> +		adapter->phydev = phy_find_first(adapter->mdiobus);
> +	if (!adapter->phydev)
> +		return -EIO;
> +
> +	/* detect optional GMII2RGMII */
> +	retval = tsnep_read_md(adapter, ECM_GMII2RGMII_ADDR, MII_PHYSID1, &val);
> +	if (retval)
> +		return retval;
> +	id = val << 16;
> +	retval = tsnep_read_md(adapter, ECM_GMII2RGMII_ADDR, MII_PHYSID2, &val);
> +	if (retval)
> +		return retval;
> +	id |= val;
> +	if (id == 0)
> +		adapter->gmii2rgmii = true;

This is where i think GMII2RGMII goes wrong. MAC phy-handle should
point to the GMII2RGMII device in DT. The GMII2RGMII should have a
phy-handle which points to the PHY.

> +	/* reset PHY */
> +	retval = tsnep_write_md(adapter, adapter->phydev->mdio.addr, MII_BMCR,
> +				BMCR_RESET);
> +	if (retval)
> +		return retval;
> +
> +	/* reset GMII2RGMII */
> +	if (adapter->gmii2rgmii) {
> +		retval = tsnep_write_md(adapter, ECM_GMII2RGMII_ADDR,
> +					ECM_GMII2RGMII_BMCR, BMCR_RESET);
> +		if (retval)
> +			return retval;
> +		retval = tsnep_write_md(adapter, ECM_GMII2RGMII_ADDR,
> +					ECM_GMII2RGMII_BMCR, BMCR_SPEED100);
> +		if (retval)
> +			return retval;
> +	}

The PHY driver is in control of the PHY, not the MAC. Please remove.

    Andrew
