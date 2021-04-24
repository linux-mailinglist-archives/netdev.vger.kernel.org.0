Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D01536A1E6
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 18:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbhDXQBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 12:01:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39386 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhDXQBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 12:01:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1laKiP-000ppG-UI; Sat, 24 Apr 2021 18:01:05 +0200
Date:   Sat, 24 Apr 2021 18:01:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v6 08/10] net: dsa: microchip: Add Microchip
 KSZ8863 SMI based driver support
Message-ID: <YIRAwY+5yLJf1+CH@lunn.ch>
References: <20210423080218.26526-1-o.rempel@pengutronix.de>
 <20210423080218.26526-9-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423080218.26526-9-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
> +			     void *val_buf, size_t val_len)
> +{
> +	struct ksz_device *dev = ctx;
> +	struct ksz8 *ksz8 = dev->priv;
> +	struct mdio_device *mdev = ksz8->priv;
> +	u8 reg = *(u8 *)reg_buf;
> +	u8 *val = val_buf;
> +	int ret = 0;
> +	int i;

...


> +
> +	mutex_lock_nested(&mdev->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	for (i = 0; i < val_len; i++) {
> +		int tmp = reg + i;
> +
> +		ret = __mdiobus_read(mdev->bus, ((tmp & 0xE0) >> 5) |
> +				     SMI_KSZ88XX_READ_PHY, tmp);
> +		if (ret < 0)
> +			goto out;
> +
> +		val[i] = ret;
> +	}
> +	ret = 0;
> +
> + out:
> +	mutex_unlock(&mdev->bus->mdio_lock);
> +
> +	return ret;
> +}
> +
> +static int ksz8863_mdio_write(void *ctx, const void *data, size_t count)
> +{
> +	struct ksz_device *dev = ctx;
> +	struct ksz8 *ksz8 = dev->priv;
> +	struct mdio_device *mdev = ksz8->priv;
> +	u8 *val = (u8 *)(data + 4);
> +	u32 reg = *(u32 *)data;
> +	int ret = 0;
> +	int i;

...


> +static const struct of_device_id ksz8863_dt_ids[] = {
> +	{ .compatible = "microchip,ksz8863" },
> +	{ .compatible = "microchip,ksz8873" },
> +	{ },
> +};

Is there code somewhere which verifies that what has been found really
does match what is in device tree? We don't want errors in the device
tree to be ignored.

     Andrew
