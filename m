Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1547B2D4EDE
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388745AbgLIXlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:41:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgLIXlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:41:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn94G-00B8S3-JC; Thu, 10 Dec 2020 00:40:20 +0100
Date:   Thu, 10 Dec 2020 00:40:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     ashkan.boldaji@digi.com, clang-built-linux@googlegroups.com,
        davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v11 4/4] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family of Marvell
Message-ID: <20201209234020.GI2649111@lunn.ch>
References: <cover.1607488953.git.pavana.sharma@digi.com>
 <9db13ff47826f8bf9d08ec7cdc194c2187868a40.1607488953.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9db13ff47826f8bf9d08ec7cdc194c2187868a40.1607488953.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X)
> + * This function adds new speed 5000 supported by Amethyst family.
> + * Function mv88e6xxx_port_set_speed_duplex() can't be used as the register
> + * values for speeds 2500 & 5000 conflict.
> + */

Thanks, that should stop my or somebody else trying to wrong combine
them.

> +/* Offset 0x10 & 0x11: EPC */
> +
> +static int mv88e6393x_epc_wait_ready(struct mv88e6xxx_chip *chip, int port)
> +{
> +	int bit = __bf_shf(MV88E6393X_PORT_EPC_CMD_BUSY);
> +
> +	return mv88e6xxx_port_wait_bit(chip, port, MV88E6393X_PORT_EPC_CMD, bit, 0);
> +}

To follow the naming convention, this should really be called mv88e6393x_port_epc_wait_ready


> +int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
> +	    int lane, bool enable)

It can be hard to tell in a diff, but the indentation looks wrong
here. 'int lane' should line up with 'struct'.

> +{
> +	u8 cmode = chip->ports[port].cmode;
> +	int err = 0;
> +
> +	switch (cmode) {
> +	case MV88E6XXX_PORT_STS_CMODE_SGMII:
> +	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
> +	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
> +		err = mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
> +	}
> +
> +	return err;
> +}
> +
> +irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
> +				 int lane)

Maybe here as well?

> +int mv88e6393x_setup_errata(struct mv88e6xxx_chip *chip)

It should have _serdes_ in the name to follow the naming convention.

   Andrew
