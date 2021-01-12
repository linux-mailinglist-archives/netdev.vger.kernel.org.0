Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE4A2F3D50
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438150AbhALVhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437024AbhALUoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:44:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzQVl-000ECn-ED; Tue, 12 Jan 2021 21:43:29 +0100
Date:   Tue, 12 Jan 2021 21:43:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <X/4J8cB1ITZmesN5@lunn.ch>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111050044.22002-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
> + * instead via address 0x51, when SFP page is set to 0x03 and password to
> + * 0xffffffff.
> + * Since current SFP code does not modify SFP_PAGE, we set it to 0x03 only at
> + * bus creation time, and expect it to remain set to 0x03 throughout the
> + * lifetime of the module plugged into the system. If the SFP code starts
> + * modifying SFP_PAGE in the future, this code will need to change.

...

> +/* In order to not interfere with other SFP code (which possibly may manipulate
> + * SFP_PAGE), for every transfer we do this:
> + *   1. lock the bus
> + *   2. save content of SFP_PAGE
> + *   3. set SFP_PAGE to 3
> + *   4. do the transfer
> + *   5. restore original SFP_PAGE
> + *   6. unlock the bus

These two comments seem to contradict each other?

> +static int i2c_rollball_mii_poll(struct mii_bus *bus, int bus_addr, u8 *buf,
> +				 size_t len)
> +{
> +	struct i2c_adapter *i2c = bus->priv;
> +	struct i2c_msg msgs[2];
> +	u8 cmd_addr, tmp, *res;
> +	int i, ret;
> +
> +	cmd_addr = ROLLBALL_CMD_ADDR;
> +
> +	res = buf ? buf : &tmp;
> +	len = buf ? len : 1;
> +
> +	msgs[0].addr = bus_addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 1;
> +	msgs[0].buf = &cmd_addr;
> +
> +	msgs[1].addr = bus_addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = len;
> +	msgs[1].buf = res;
> +
> +	/* By experiment it takes up to 70 ms to access a register for these
> +	 * SFPs. Sleep 20ms between iteratios and try 10 times.
> +	 */

iterations

> +static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
> +{
> +	u8 buf[4], res[6];
> +	int bus_addr, ret;
> +	u16 val;
> +
> +	if (!(reg & MII_ADDR_C45))
> +		return -EOPNOTSUPP;
> +
> +	bus_addr = i2c_mii_phy_addr(phy_id);
> +	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
> +		return 0xffff;
> +
> +	buf[0] = ROLLBALL_DATA_ADDR;
> +	buf[1] = (reg >> 16) & 0x1f;
> +	buf[2] = (reg >> 8) & 0xff;
> +	buf[3] = reg & 0xff;

This looks odd. There are only 32 registers for C22 transactions, so
it fits in one byte. You can set buf[1] and buf[2] to zero.

C45 transactions allow for 65536 registers, and has the devtype field,
so would need 3 bytes. Which suggests that C45 might actually be
supported? At least by the protocol, if not the device.

> +	dev_dbg(&bus->dev, "read reg %02x:%04x = %04x\n", (reg >> 16) & 0x1f,
> +		reg & 0xffff, val);

There is a tracepoint that allows access to this information, so you
can probably remove this.

    Andrew
