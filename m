Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D64293250
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389341AbgJTASN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:18:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35704 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389331AbgJTASN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:18:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUfLj-002Zrt-JM; Tue, 20 Oct 2020 02:17:59 +0200
Date:   Tue, 20 Oct 2020 02:17:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6097/6095/6185
Message-ID: <20201020001759.GT456889@lunn.ch>
References: <20201019024355.30717-1-chris.packham@alliedtelesis.co.nz>
 <20201019024355.30717-3-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019024355.30717-3-chris.packham@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 03:43:54PM +1300, Chris Packham wrote:
> Implement serdes_power, serdes_get_lane and serdes_pcs_get_state ops for
> the MV88E6097/6095/6185 so that ports 8 & 9 can be supported as serdes
> ports and directly connected to other network interfaces or to SFPs
> without a PHY.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Just a nit pick below.

> +int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
> +			   bool up)
> +{
> +	/* The serdes power can't be controlled on this switch chip but we need
> +	 * to supply this function to avoid returning -EOPNOTSUPP in
> +	 * mv88e6xxx_serdes_power_up/mv88e6xxx_serdes_power_down
> +	 */
> +	return 0;
> +}
> +
> +u8 mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
> +{
> +	switch (chip->ports[port].cmode) {
> +	case MV88E6185_PORT_STS_CMODE_SERDES:
> +	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
> +		return 0xff; /* Unused */
> +	default:
> +		return 0;
> +	}
> +}

mv88e6185_serdes_power() has a nice comment about why it exists and
just returns 0. It would be nice to have something similar here, that
there are no SERDES lane registers, but something other than 0 has to
be returned to indicate there is in fact a SERDES for the given port.

   Andrew
