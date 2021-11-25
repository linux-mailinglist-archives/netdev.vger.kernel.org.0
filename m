Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865FF45D337
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhKYCnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhKYCmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 21:42:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F4D60EB5;
        Thu, 25 Nov 2021 02:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637807941;
        bh=vluxboMI/h21+lsToRUC9ys/umSNVZzQagzu/ueIefs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EOlKeXJ7f+Edd2RM9xC2lf8rEp0kHBcaEAeK4/zgWdx4DR2erCHsHs5Bd7XQ2vFKo
         tW3wv94gxqJdzFyeFcSlhbFvQ+a2yLO8acNMKd8JZFMyGpRn5YkW5TDlaXwjSJiO1j
         ojxhda0A8pjpzkSy2QhDLhQm40n3FOiLauDeHmsyfufhsDTaQK4xlop5gF4gUwLYMD
         JEWm5uYM6heuxKOt2lH6Ddqb6D4bFmEBGw8ay6U5Bc38qitJIPyYD7BiPtPj6A1f2R
         cJp0N8idFLNJ/ZxobZwI4a+oM7hglaqOxmQaP0dAJBuAnKtdgFlxWoYVb4M3op9omR
         mha3YA3wN4RKA==
Date:   Wed, 24 Nov 2021 18:39:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next] net: dsa: felix: enable cut-through
 forwarding between ports by default
Message-ID: <20211124183900.7fb192f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211123132116.913520-1-olteanv@gmail.com>
References: <20211123132116.913520-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 15:21:16 +0200 Vladimir Oltean wrote:
> +static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
> +{
> +	struct felix *felix = ocelot_to_felix(ocelot);
> +	struct dsa_switch *ds = felix->ds;
> +	int port, other_port;
> +
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		struct ocelot_port *ocelot_port = ocelot->ports[port];
> +		unsigned long mask;
> +		int min_speed;
> +		u32 val = 0;
> +
> +		if (ocelot_port->speed <= 0)
> +			continue;

Would it not be safer to disable cut-thru for ports which are down?

	goto set;

> +		min_speed = ocelot_port->speed;
> +		if (port == ocelot->npi) {
> +			/* Ocelot switches forward from the NPI port towards
> +			 * any port, regardless of it being in the NPI port's
> +			 * forwarding domain or not.
> +			 */
> +			mask = dsa_user_ports(ds);
> +		} else {
> +			mask = ocelot_read_rix(ocelot, ANA_PGID_PGID,
> +					       PGID_SRC + port);
> +			/* Ocelot switches forward to the NPI port despite it
> +			 * not being in the source ports' forwarding domain.
> +			 */
> +			if (ocelot->npi >= 0)
> +				mask |= BIT(ocelot->npi);
> +		}
> +
> +		for_each_set_bit(other_port, &mask, ocelot->num_phys_ports) {
> +			struct ocelot_port *other_ocelot_port;
> +
> +			other_ocelot_port = ocelot->ports[other_port];
> +			if (other_ocelot_port->speed <= 0)
> +				continue;
> +
> +			if (min_speed > other_ocelot_port->speed)
> +				min_speed = other_ocelot_port->speed;

break; ?

> +		}
> +
> +		/* Enable cut-through forwarding for all traffic classes. */
> +		if (ocelot_port->speed == min_speed)

Any particular reason this is not <= ?

> +			val = GENMASK(7, 0);

set: ?

> +		ocelot_write_rix(ocelot, val, ANA_CUT_THRU_CFG, port);
> +	}
> +}

>  static const struct felix_info felix_info_vsc9959 = {
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 95920668feb0..30c790f401be 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c

> @@ -697,6 +702,8 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
>  	int mac_speed, mode = 0;
>  	u32 mac_fc_cfg;
>  
> +	ocelot_port->speed = speed;
> +
>  	/* The MAC might be integrated in systems where the MAC speed is fixed
>  	 * and it's the PCS who is performing the rate adaptation, so we have
>  	 * to write "1000Mbps" into the LINK_SPEED field of DEV_CLOCK_CFG
> @@ -772,6 +779,9 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
>  	/* Core: Enable port for frame transfer */
>  	ocelot_fields_write(ocelot, port,
>  			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);

Does this enable forwarding? Is there a window here with forwarding
enabled and old cut-thru masks if we don't clear cut-thru when port
goes down?

> +	if (ocelot->ops->cut_through_fwd)
> +		ocelot->ops->cut_through_fwd(ocelot);
>  }
>  EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
>  
> @@ -1637,6 +1647,9 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
>  
>  		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
>  	}

Obviously shooting from the hip here, but I was expecting the cut-thru
update to be before the bridge reconfig if port is joining, and after
if port is leaving. Do you know what I'm getting at?

> +	if (ocelot->ops->cut_through_fwd)
> +		ocelot->ops->cut_through_fwd(ocelot);
>  }
>  EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
