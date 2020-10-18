Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D1E29184E
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 18:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgJRQQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 12:16:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgJRQQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 12:16:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUBM8-002K1a-U4; Sun, 18 Oct 2020 18:16:24 +0200
Date:   Sun, 18 Oct 2020 18:16:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6097
Message-ID: <20201018161624.GD456889@lunn.ch>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
 <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 03:18:58PM +1300, Chris Packham wrote:
> Implement serdes_power, serdes_get_lane and serdes_pcs_get_state ops for
> the MV88E6097 so that ports 8 & 9 can be supported as serdes ports and
> directly connected to other network interfaces or to SFPs without a PHY.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
> 
> This should be usable for all variants of the 88E6185 that have
> tri-speed capable ports (which is why I used the mv88e6185 prefix
> instead of mv88e6097). But my hardware only has a 88e6097 so I've only
> connected up the ops for that chip.
> 
>  drivers/net/dsa/mv88e6xxx/chip.c | 61 ++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 1ef392ee52c5..1c6cd5c43eb1 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3436,6 +3436,64 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
>  	return err;
>  }
>  
> +static int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
> +				  bool up)
> +{
> +	/* The serdes power can't be controlled on this switch chip but we need
> +	 * to supply this function to avoid returning -EOPNOTSUPP in
> +	 * mv88e6xxx_serdes_power_up/mv88e6xxx_serdes_power_down
> +	 */

Hi Chris

How about bit 11 of the control register 0? This looks a lot like a
BMCR, and BMCR_PDOWN.

This is what mv88e6352_serdes_power() does. You might be able to even
re-use it, if you can make the lane numbers work.

      Andrew
