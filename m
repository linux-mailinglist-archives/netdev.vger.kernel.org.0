Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68682B9FB7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgKTB3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:29:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgKTB3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:29:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfvEY-0082d5-4S; Fri, 20 Nov 2020 02:29:06 +0100
Date:   Fri, 20 Nov 2020 02:29:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     lkp@intel.com, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v10 4/4] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family  of Marvell
Message-ID: <20201120012906.GA1804098@lunn.ch>
References: <cover.1605830552.git.pavana.sharma@digi.com>
 <df58a3716ab900a0c2a4d727ddae52ef1310fcdc.1605830552.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df58a3716ab900a0c2a4d727ddae52ef1310fcdc.1605830552.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -222,8 +231,8 @@ static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
>  		return err;
>  
>  	reg &= ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
> -		 MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
> -		 MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL);
> +		MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
> +		MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL);

This looks like a white space change?


>  	if (alt_bit)
>  		reg &= ~MV88E6390_PORT_MAC_CTL_ALTSPEED;
> @@ -390,6 +399,84 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
>  	return PHY_INTERFACE_MODE_NA;
>  }
>  
> +/* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X) */
> +int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
> +		int speed, int duplex)
> +{
> +	u16 reg, ctrl;
> +	int err;
> +
> +	if (speed == SPEED_MAX)
> +		speed = (port > 0 && port < 9) ? 1000 : 10000;
> +
> +	if (speed == 200 && port != 0)
> +		return -EOPNOTSUPP;
> +
> +	if (speed >= 2500 && port > 0 && port < 9)
> +		return -EOPNOTSUPP;

Maybe i'm missing something, but it looks like at this point you can
call

	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, true, true, duplex);


> +/* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393X */
> +
> +static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 pointer,
> +				u8 data)
> +{
> +
> +	int err = 0;
> +	int port;
> +	u16 reg;
> +
> +	/* Setup per Port policy register */
> +	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> +		if (dsa_is_unused_port(chip->ds, port))
> +			continue;
> +
> +		/* Prevent the use of an invalid port. */
> +		if (mv88e6xxx_is_invalid_port(chip, port)) {
> +			dev_err(chip->dev, "port %d is invalid\n", port);
> +			return -EINVAL;
> +		}

        /* Mark certain ports as invalid. This is required for example for the
         * MV88E6220 (which is in general a MV88E6250 with 7 ports) but the
         * ports 2-4 are not routed to pins.
         */
        unsigned int invalid_port_mask;

You have not set this in the info structure of the 6393x devices, so
you can skip this check.


> +/* Only Ports 0, 9 and 10 have SERDES lanes. Return the SERDES lane address
> + * a port is using else Returns -ENODEV.
> + */
> +int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +	int lane = -ENODEV;
> +
> +	if (port == 0 || port == 9 || port == 10) {

Maybe 

	if (port != 0 && port != 9 && port == 10)
		return -ENODEV

> +		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
> +			cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
> +			cmode == MV88E6XXX_PORT_STS_CMODE_5GBASER ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_10GBASER ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_USXGMII)

Indentation is messed up.

> +			lane = port;

	return port;

	Andrew
