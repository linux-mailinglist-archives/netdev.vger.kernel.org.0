Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BAA2DB1E0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgLOQuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:50:19 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57441 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731232AbgLOQuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:50:09 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 3CD7060007;
        Tue, 15 Dec 2020 16:49:26 +0000 (UTC)
Date:   Tue, 15 Dec 2020 17:49:25 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 09/16] net: mscc: ocelot: use "lag" variable
 name in ocelot_bridge_stp_state_set
Message-ID: <20201215164925.GM1781038@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-10-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208120802.1268708-10-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 14:07:55+0200, Vladimir Oltean wrote:
> In anticipation of further simplification, make it more clear what we're
> iterating over.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 080fd4ce37ea..c3c6682e6e79 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -903,7 +903,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>  {
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	u32 port_cfg;
> -	int p, i;
> +	int p;
>  
>  	if (!(BIT(port) & ocelot->bridge_mask))
>  		return;
> @@ -928,14 +928,17 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
>  	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
>  
>  	/* Apply FWD mask. The loop is needed to add/remove the current port as
> -	 * a source for the other ports.
> +	 * a source for the other ports. If the source port is in a bond, then
> +	 * all the other ports from that bond need to be removed from this
> +	 * source port's forwarding mask.
>  	 */
>  	for (p = 0; p < ocelot->num_phys_ports; p++) {
>  		if (ocelot->bridge_fwd_mask & BIT(p)) {
>  			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
> +			int lag;
>  
> -			for (i = 0; i < ocelot->num_phys_ports; i++) {
> -				unsigned long bond_mask = ocelot->lags[i];
> +			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
> +				unsigned long bond_mask = ocelot->lags[lag];
>  
>  				if (!bond_mask)
>  					continue;
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
