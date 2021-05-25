Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD2638F83A
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhEYCfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:35:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhEYCfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 22:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qC5mEnkCJi4aHOhkG/zqZvPxdIzajQ431K50lneCqpo=; b=hJ3bMmk2ehTTy8kZNLfIf4wKdT
        6JLmiJ+cy62edN1oCqkkYsGw8laBIxfZpZQTQEEShYp6KnG4/P0gdOXq03BEPiaW79pZLUbJIcIa9
        +i1EPkK15yea45FTeR5z8agwfBE71VqUphSNxUInLZgtVMxYJNG/sHAdmaxRKSXd3c8Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llMsv-0064bz-7Z; Tue, 25 May 2021 04:33:33 +0200
Date:   Tue, 25 May 2021 04:33:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 12/13] net: dsa: sja1105: expose the SGMII PCS
 as an mdio_device
Message-ID: <YKxh/d2/SXfxVmr7@lunn.ch>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-13-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524232214.1378937-13-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
> +{
> +	struct sja1105_mdio_private *mdio_priv;
> +	struct dsa_switch *ds = priv->ds;
> +	struct mii_bus *bus;
> +	int rc = 0;
> +	int port;
> +
> +	if (!priv->info->pcs_mdio_read || !priv->info->pcs_mdio_write)
> +		return 0;
> +
> +	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->name = "SJA1105 PCS MDIO bus";
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-pcs",
> +		 dev_name(ds->dev));
> +	bus->read = priv->info->pcs_mdio_read;
> +	bus->write = priv->info->pcs_mdio_write;
> +	bus->parent = ds->dev;
> +	mdio_priv = bus->priv;
> +	mdio_priv->priv = priv;
> +
> +	/* We don't register this MDIO bus because there is no PHY on it */

Interesting. If you don't register it, you miss out on the stats in
/sysfs. I wonder if it makes more sense to set phy_mask to stop it
probing for PHYs and register it?

	Andrew
