Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08D22F6EC3
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbhANXBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:01:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730929AbhANXBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:01:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0BbV-000eLv-5M; Fri, 15 Jan 2021 00:00:33 +0100
Date:   Fri, 15 Jan 2021 00:00:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: do not allow inband AN for
 2500base-x mode
Message-ID: <YADNEWkiPQX34Tyo@lunn.ch>
References: <20210114024055.17602-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114024055.17602-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> index 3195936dc5be..b8241820679e 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -55,9 +55,20 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
>  {
>  	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
>  		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> +
> +		if (state->interface == PHY_INTERFACE_MODE_2500BASEX) {
> +			if (state->link) {
> +				state->speed = SPEED_2500;
> +				state->duplex = DUPLEX_FULL;
> +			}
> +
> +			return 0;
> +		}
> +
> +		state->an_complete = 1;

Should this be here? It seems like a logically different change, it is
not clear to me it is to do with PHY_INTERFACE_MODE_2500BASEX.

>  		state->duplex = status &
>  				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
> -			                         DUPLEX_FULL : DUPLEX_HALF;
> +						DUPLEX_FULL : DUPLEX_HALF;

This looks like an unintended white space change.

     Andrew
