Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B13291422
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 21:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439424AbgJQTaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 15:30:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60998 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437545AbgJQTaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 15:30:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTrue-002BUa-QN; Sat, 17 Oct 2020 21:30:44 +0200
Date:   Sat, 17 Oct 2020 21:30:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v3] Add support for mv88e6393x family of Marvell.
Message-ID: <20201017193044.GO456889@lunn.ch>
References: <20201016020902.28237-1-pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016020902.28237-1-pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
> +					unsigned long *mask,
> +					struct phylink_link_state *state)
> +{
> +	if (port == 0 || port >= 9) {
> +		phylink_set(mask, 10000baseT_Full);
> +		phylink_set(mask, 10000baseKR_Full);
> +		phylink_set(mask, 2500baseX_Full);
> +		phylink_set(mask, 2500baseT_Full);
> +	}
> +
> +	phylink_set(mask, 1000baseT_Full);
> +	phylink_set(mask, 1000baseX_Full);
> +
> +	mv88e6065_phylink_validate(chip, port, mask, state);
> +}
> +
>  static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
>  			       unsigned long *supported,
>  			       struct phylink_link_state *state)
> @@ -4141,6 +4158,56 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
>  	.phylink_validate = mv88e6390_phylink_validate,
>  };
>  
> +static const struct mv88e6xxx_ops mv88e6193x_ops = {
> +	/* MV88E6XXX_FAMILY_6393X */

Please add support for the 6393X and the 6391X. Most of the
differences are in mv88e6X93x_phylink_validate() functions, given the
different number of multiG ports. Just a best effort, since i guess
you do not have the hardware to test on.

> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 823ae89e5fca..407d683c0fcf 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -63,6 +63,7 @@ enum mv88e6xxx_model {
>  	MV88E6190,
>  	MV88E6190X,
>  	MV88E6191,
> +	MV88E6193X,
>  	MV88E6220,
>  	MV88E6240,
>  	MV88E6250,
> @@ -90,6 +91,7 @@ enum mv88e6xxx_family {
>  	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
>  	MV88E6XXX_FAMILY_6352,	/* 6172 6176 6240 6352 */
>  	MV88E6XXX_FAMILY_6390,  /* 6190 6190X 6191 6290 6390 6390X */
> +	MV88E6XXX_FAMILY_6393X, /* 6191X 6193X 6393X */
>  };

Are there any 6393 devices, i.e. not X? I just wondering if we want to
call the family plain 6393? In general, it would be nicer to use the
name 6393, not 6393X.

> +int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> +			      phy_interface_t mode)
> +{
> +	if (lane >= 0) {
> +		if (chip->ports[port].serdes_irq) {
> +			err = mv88e6393x_serdes_irq_enable(chip, port, lane, false);
> +			if (err)
> +				return err;
> +	}
> +
> +		err = mv88e6393x_serdes_power(chip, port, lane, false);
> +		if (err)
> +			return err;
> +	}

Something wrong with the indentation here.

Please can you also look at trying to refactor
mv88e6xxx_port_set_cmode() so you don't have to duplicate so much.

> +/* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393X*/
> +
> +static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 pointer,
> +				u8 data)
> +{
> +	u16 reg;
> +	int port;
> +	int err = 0;

Reverse Christmas tree please, here and everywhere.

> +static int mv88e6393x_epc_wait_ready(struct mv88e6xxx_chip *chip, int port)
> +{
> +	const unsigned long timeout = jiffies + 1 * HZ;
> +	u16 val;
> +	int err;
> +
> +	while (time_before(jiffies, timeout)) {
> +		err = mv88e6xxx_port_read(chip, port, MV88E6393X_PORT_EPC_CMD, &val);
> +		if (err)
> +			return err;
> +		if (!(val & MV88E6393X_PORT_EPC_CMD_BUSY))
> +			break;
> +		usleep_range(1000, 2000);
> +	}
> +
> +	if (time_after(jiffies, timeout))
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}

Please build something on top of mv88e6xxx_wait_bit(). Look at
global1.c as an example for its _wait_ functions.

> +/* Return the SERDES lane address a port is using. Only Ports 0, 9 and 10
> + * have SERDES lanes. Returns -ENODEV if a port does not have a lane.
> + */
> +u8 mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +
> +	switch (port) {
> +	case 0:
> +		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_10GBASER)
> +			return MV88E6393X_PORT0_LANE;
> +		return ENODEV;

Missing the - in -ENODEV.

> +	case 9:
> +		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_10GBASER)
> +			return MV88E6393X_PORT9_LANE;
> +		return ENODEV;
> +	case 10:
> +		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
> +		    cmode == MV88E6XXX_PORT_STS_CMODE_10GBASER)
> +			return MV88E6393X_PORT10_LANE;
> +		return ENODEV;
> +	default:
> +		return ENODEV;
> +	}
> +}
> +

  Andrew
