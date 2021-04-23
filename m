Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B10136925F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbhDWMrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:47:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhDWMro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:47:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZvD5-000eTU-RS; Fri, 23 Apr 2021 14:47:03 +0200
Date:   Fri, 23 Apr 2021 14:47:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] drivers: net: dsa: qca8k: add support for specific
 QCA access function
Message-ID: <YILBx5jUn+m97sSr@lunn.ch>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423014741.11858-11-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline void qca8k_phy_mmd_prep(struct mii_bus *bus, int phy_addr, u16 addr, u16 reg)
> +{
> +	bus->write(bus, phy_addr, MII_ATH_MMD_ADDR, addr);
> +	bus->write(bus, phy_addr, MII_ATH_MMD_DATA, reg);
> +	bus->write(bus, phy_addr, MII_ATH_MMD_ADDR, addr | 0x4000);
> +}
> +
> +void qca8k_phy_mmd_write(struct qca8k_priv *priv, int phy_addr, u16 addr, u16 reg, u16 data)
> +{
> +	struct mii_bus *bus = priv->bus;
> +
> +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	qca8k_phy_mmd_prep(bus, phy_addr, addr, reg);
> +	bus->write(bus, phy_addr, MII_ATH_MMD_DATA, data);
> +	mutex_unlock(&bus->mdio_lock);
> +}
> +
> +u16 qca8k_phy_mmd_read(struct qca8k_priv *priv, int phy_addr, u16 addr, u16 reg)
> +{
> +	struct mii_bus *bus = priv->bus;
> +	u16 data;
> +
> +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	qca8k_phy_mmd_prep(bus, phy_addr, addr, reg);
> +	data = bus->read(bus, phy_addr, MII_ATH_MMD_DATA);
> +	mutex_unlock(&bus->mdio_lock);
> +
> +	return data;
> +}

Can you use the PHY core MMD access functions?

    Andrew
