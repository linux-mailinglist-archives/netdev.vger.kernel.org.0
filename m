Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADFD2DC85E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgLPVch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:32:37 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:52233 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgLPVch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 16:32:37 -0500
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 44B2F200003;
        Wed, 16 Dec 2020 21:31:54 +0000 (UTC)
Date:   Wed, 16 Dec 2020 22:31:53 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 13/16] net: mscc: ocelot: rename aggr_count
 to num_ports_in_lag
Message-ID: <20201216213153.GQ2814589@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-14-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-14-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:59+0200, Vladimir Oltean wrote:
> It makes it a bit easier to read and understand the code that deals with
> balancing the 16 aggregation codes among the ports in a certain LAG.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index d4dbba66aa65..d87e80a15ca5 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1263,8 +1263,8 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  
>  	/* Now, set PGIDs for each LAG */
>  	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
> +		int num_ports_in_lag = 0;
>  		unsigned long bond_mask;
> -		int aggr_count = 0;
>  		u8 aggr_idx[16];
>  
>  		if (!bonds[lag])
> @@ -1276,8 +1276,7 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  			// Destination mask
>  			ocelot_write_rix(ocelot, bond_mask,
>  					 ANA_PGID_PGID, port);
> -			aggr_idx[aggr_count] = port;
> -			aggr_count++;
> +			aggr_idx[num_ports_in_lag++] = port;
>  		}
>  
>  		for_each_aggr_pgid(ocelot, i) {
> @@ -1285,7 +1284,7 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
>  
>  			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
>  			ac &= ~bond_mask;
> -			ac |= BIT(aggr_idx[i % aggr_count]);
> +			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
>  			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
>  		}
>  
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
